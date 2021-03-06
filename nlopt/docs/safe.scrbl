#lang scribble/manual

@(require (for-label (except-in racket version)
                     nlopt/safe racket/flonum))

@title[#:tag "safe"]{Safe Interface}

@defmodule[nlopt/safe]

This module is the safe, fully-contracted version of the interface
to the C library. For the unsafe, contractless version, see
@racket[nlopt/unsafe].

@section{Basics}

@defproc[(create [algorithm symbol?]
                 [dimension (and/c natural-number/c positive?)])
         nlopt-opt?]{
  Creates a new NLopt options structure. The algorithm and dimension
  of the optimization problem cannot be changed later. Everything else
  can be.

  The general pattern for using this library is to @racket[create] an
  options structure, apply the various setup options to it (making sure
  to include a stopping condition!), and then run @racket[optimize].
                     }

@defproc[(copy [opt nlopt-opt?])
         nlopt-opt?]{
  Copies an existing options object. Racket objects stored as data
  arguments for functions are not copied.
                     }

@defproc[(get-algorithm [opt nlopt-opt?])
         symbol?]{
  Returns the algorithm being used by the options structure.
  }

@defproc[(get-dimension [opt nlopt-opt?])
         (and/c natural-number/c positive?)]{
  Returns the dimension the options structure is set up to handle.
  }

@defproc[(optimize [opt nlopt-opt?]
                   [x flvector?])
         (values [res symbol?]
                 [f flonum?])]{
  Runs the optimization problem, with an initial guess provided
  in @racket[x]. The status of the optimization is returned in
  @racket[res]. If it was successful, @racket[x] will contain the
  optimized values of the parameters, and @racket[f] will by the
  corresponding value of the objective function.

  @racket[x] must be at least as large as the dimension of @racket[opt].
}

@defproc[(nlopt-opt? [v any/c]) boolean?]{
Returns @racket[#t] if @racket[v] is a NLopt options structure,
@racket[#f] otherwise. 
}

@section{Constraints}

@defproc[(set-lower-bounds [opt nlopt-opt?]
                           [bounds (flvector/length? (get-dimension opt))])
         nlopt-result/c]{
                         }

@defproc[(set-upper-bounds [opt nlopt-opt?]
                           [bounds (flvector/length? (get-dimension opt))])
         nlopt-result/c]{
                         }

@defproc[(set-lower-bounds1 [opt nlopt-opt?]
                            [lower-bound real?])
         nlopt-result/c]{Sets all of the lower bounds to the same value,
                              @racket[lower-bound].}

@defproc[(set-upper-bounds1 [opt nlopt-opt?]
                            [upper-bound real?])
         nlopt-result/c]{Sets all of the upper bounds to the same value,
                              @racket[upper-bound].}

@defproc[(get-lower-bounds [opt nlopt-opt?])
         (values
          [res nlopt-result/c]
          [bounds (flvector/length? (get-dimension opt))])]{
                                                            }

@defproc[(get-upper-bounds [opt nlopt-opt?])
         (values
          [res nlopt-result/c]
          [bounds (flvector/length? (get-dimension opt))])]{
                                                            }


@defproc[(remove-inequality-constraints [opt nlopt-opt?])
         nlopt-result/c]{
Removes all inequality constraints.}

@defproc[(add-inequality-constraint
          [opt nlopt-opt?]
          [f (-> (=/c (get-dimension opt))
                 flvector?
                 (or/c flvector? #f)
                 any/c
                 flonum?)]
          [data any/c]
          [tolerance real?])
         nlopt-result/c]{
The optimization will be constrainted such that
@racket[(<= (fun x data) 0.0)] is @racket[#t].                         
      }

@defproc[(remove-equality-constraints [opt nlopt-opt?])
         nlopt-result/c]{
Removes all equality constraints.}

@defproc[(add-equality-constraint
          [opt nlopt-opt?]
          [f (-> (=/c (get-dimension opt))
                 flvector?
                 (or/c flvector? #f)
                 any/c
                 flonum?)]
          [data any/c]
          [tolerance real?])
         nlopt-result/c]{
The optimization will be constrainted such that
@racket[(= (fun x data) 0.0)] is @racket[#t].                         
      }

@section{Stopping Criteria}

@defproc[(set-stopval [opt nlopt-opt?] [stopval real?])
         nlopt-result/c]{}

@defproc[(get-stopval [opt nlopt-opt?]) flonum?]{}

@defproc[(set-ftol-rel [opt nlopt-opt?] [ftol-rel real?])
         nlopt-result/c]{}

@defproc[(get-ftol-rel [opt nlopt-opt?]) flonum?]{}

@defproc[(set-ftol-abs [opt nlopt-opt?] [ftol-abs real?])
         nlopt-result/c]{}

@defproc[(get-ftol-abs [opt nlopt-opt?]) flonum?]{}

@defproc[(set-xtol-rel [opt nlopt-opt?] [xtol-rel real?])
         nlopt-result/c]{}

@defproc[(get-xtol-rel [opt nlopt-opt?]) flonum?]{}

@defproc[(set-xtol-abs1 [opt nlopt-opt?] [xtol-abs real?])
         nlopt-result/c]{}

@defproc[(set-xtol-abs [opt nlopt-opt?] [xtols (flvector/length? (get-dimension opt))])
         nlopt-result/c]{}

@defproc[(get-xtol-abs [opt nlopt-opt?])
         (values nlopt-result/c
                 (flvector/length? (get-dimension opt)))]{}

@defproc[(set-maxeval [opt nlopt-opt?] [maxeval natural-number/c])
         nlopt-result/c]{}

@defproc[(get-maxeval [opt nlopt-opt?]) natural-number/c]{}

@defproc[(set-maxtime [opt nlopt-opt?] [maxtime real?])
         nlopt-result/c]{}

@defproc[(get-maxtime [opt nlopt-opt?]) flonum?]{}

@defproc[(force-stop [opt nlopt-opt?])
         nlopt-result/c]{
When called within an objective function evaluation, the optimization will
stop at the next opportunity. Calling @racket[set-force-stop] will save an
integer value which can be retrieved after @racket[optimize] returns with
@racket[get-force-stop].}

@defproc[(set-force-stop [opt nlopt-opt?] [value integer?])
         nlopt-result/c]{
@racket[value] is stored within the optimization options, and can be
retrieved by @racket[get-force-stop] later.}

@defproc[(get-force-stop [opt nlopt-opt?])
         integer?]{Retrieves the value stored by @racket[set-force-stop].}

@section{Algorithm-Specific Parameters}

@defproc[(set-local-optimizer [opt nlopt-opt?] [local-opt nlopt-opt?])
         nlopt-result/c]{}

@defproc[(set-population [opt nlopt-opt?] [pop natural-number/c])
         nlopt-result/c]{}
@defproc[(get-population [opt nlopt-opt?]) natural-number/c]{}

@defproc[(set-vector-storage [opt nlopt-opt?] [vectors natural-number/c])
         nlopt-result/c]{}
@defproc[(get-vector-storage [opt nlopt-opt?]) natural-number/c]{}

@defproc[(set-default-initial-step [opt nlopt-opt?]
                                   [bounds (flvector/length? (get-dimension opt))])
         nlopt-result/c]{}
@defproc[(set-initial-step1 [opt nlopt-opt?] [initial-step real?])
         nlopt-result/c]{}
@defproc[(set-initial-step [opt nlopt-opt?] [bounds (flvector/length? (get-dimension opt))])
         nlopt-result/c]{}
@defproc[(get-initial-step [opt nlopt-opt?])
         (values nlopt-result/c
                 (flvector/length? (get-dimension opt)))]{}
