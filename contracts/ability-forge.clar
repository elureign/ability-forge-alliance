;; Ability Forge Alliance: Digital Networking & Collaboration Hub
;;
;; A decentralized platform facilitating connections between individuals and organizations
;; for professional engagements and collaborative ventures.

;; =============================================
;; CONSTANT ERROR DEFINITIONS
;; =============================================

(define-constant ERR-INVALID-LOCATION (err u401))
(define-constant ERR-INVALID-LISTING (err u403))
(define-constant ERR-INVALID-BIOGRAPHY (err u402))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-FIELD-VALUE (err u400))
(define-constant ERR-RESOURCE-UNAVAILABLE (err u404))

;; =============================================
;; DATA STRUCTURE DEFINITIONS
;; =============================================

;; Repository for collaboration opportunities
(define-map collaboration-listings
    principal
    {
        title: (string-ascii 100),
        description: (string-ascii 500),
        creator: principal,
        location: (string-ascii 100),
        requirements: (list 10 (string-ascii 50))
    }
)

