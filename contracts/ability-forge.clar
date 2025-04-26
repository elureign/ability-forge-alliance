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

;; Repository for individual contributor information
(define-map contributor-registry
    principal
    {
        identity: (string-ascii 100),
        capabilities: (list 10 (string-ascii 50)),
        location: (string-ascii 100),
        biography: (string-ascii 500)
    }
)

;; Repository for organizational entity information
(define-map organization-registry
    principal
    {
        title: (string-ascii 100),
        industry: (string-ascii 50),
        location: (string-ascii 100)
    }
)

;; =============================================
;; COLLABORATION LISTING MANAGEMENT FUNCTIONS
;; =============================================

;; Create a new collaboration listing
(define-public (publish-collaboration-listing 
    (title (string-ascii 100))
    (description (string-ascii 500))
    (location (string-ascii 100))
    (requirements (list 10 (string-ascii 50))))
    (let
        (
            (account-owner tx-sender)
            (existing-listing (map-get? collaboration-listings account-owner))
        )
        ;; Verify listing doesn't already exist
        (if (is-none existing-listing)
            (begin
                ;; Validate all required fields
                (if (or (is-eq title "")
                        (is-eq description "")
                        (is-eq location "")
                        (is-eq (len requirements) u0))
                    (err ERR-INVALID-LISTING)
                    (begin
                        ;; Store the collaboration listing
                        (map-set collaboration-listings account-owner
                            {
                                title: title,
                                description: description,
                                creator: account-owner,
                                location: location,
                                requirements: requirements
                            }
                        )
                        (ok "Collaboration listing successfully published.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Modify an existing collaboration listing
(define-public (update-collaboration-listing 
    (title (string-ascii 100))
    (description (string-ascii 500))
    (location (string-ascii 100))
    (requirements (list 10 (string-ascii 50))))
    (let
        (
            (account-owner tx-sender)
            (existing-listing (map-get? collaboration-listings account-owner))
        )
        ;; Verify listing exists
        (if (is-some existing-listing)
            (begin
                ;; Validate all required fields
                (if (or (is-eq title "")
                        (is-eq description "")
                        (is-eq location "")
                        (is-eq (len requirements) u0))
                    (err ERR-INVALID-LISTING)
                    (begin
                        ;; Update the collaboration listing
                        (map-set collaboration-listings account-owner
                            {
                                title: title,
                                description: description,
                                creator: account-owner,
                                location: location,
                                requirements: requirements
                            }
                        )
                        (ok "Collaboration listing successfully updated.")
                    )
                )
            )
            (err ERR-RESOURCE-UNAVAILABLE)
        )
    )
)

;; Delete an existing collaboration listing
(define-public (withdraw-collaboration-listing)
    (let
        (
            (account-owner tx-sender)
            (existing-listing (map-get? collaboration-listings account-owner))
        )
        ;; Verify listing exists
        (if (is-some existing-listing)
            (begin
                ;; Remove the collaboration listing
                (map-delete collaboration-listings account-owner)
                (ok "Collaboration listing successfully withdrawn.")
            )
            (err ERR-RESOURCE-UNAVAILABLE)
        )
    )
)

;; =============================================
;; CONTRIBUTOR PROFILE MANAGEMENT FUNCTIONS
;; =============================================

;; Initialize a new contributor profile
(define-public (register-contributor 
    (identity (string-ascii 100))
    (capabilities (list 10 (string-ascii 50)))
    (location (string-ascii 100))
    (biography (string-ascii 500)))
    (let
        (
            (account-owner tx-sender)
            (existing-profile (map-get? contributor-registry account-owner))
        )
        ;; Verify profile doesn't already exist
        (if (is-none existing-profile)
            (begin
                ;; Validate all required profile fields
                (if (or (is-eq identity "")
                        (is-eq location "")
                        (is-eq (len capabilities) u0)
                        (is-eq biography ""))
                    (err ERR-INVALID-BIOGRAPHY)
                    (begin
                        ;; Store the new contributor profile
                        (map-set contributor-registry account-owner
                            {
                                identity: identity,
                                capabilities: capabilities,
                                location: location,
                                biography: biography
                            }
                        )
                        (ok "Contributor profile successfully registered.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Modify an existing contributor profile
(define-public (modify-contributor-profile 
    (identity (string-ascii 100))
    (capabilities (list 10 (string-ascii 50)))
    (location (string-ascii 100))
    (biography (string-ascii 500)))
    (let
        (
            (account-owner tx-sender)
            (existing-profile (map-get? contributor-registry account-owner))
        )
        ;; Verify profile exists
        (if (is-some existing-profile)
            (begin
                ;; Validate all required profile fields
                (if (or (is-eq identity "")
                        (is-eq location "")
                        (is-eq (len capabilities) u0)
                        (is-eq biography ""))
                    (err ERR-INVALID-BIOGRAPHY)
                    (begin
                        ;; Update the contributor profile
                        (map-set contributor-registry account-owner
                            {
                                identity: identity,
                                capabilities: capabilities,
                                location: location,
                                biography: biography
                            }
                        )
                        (ok "Contributor profile successfully modified.")
                    )
                )
            )
            (err ERR-RESOURCE-UNAVAILABLE)
        )
    )
)

;; Delete an existing contributor profile
(define-public (deregister-contributor)
    (let
        (
            (account-owner tx-sender)
            (existing-profile (map-get? contributor-registry account-owner))
        )
        ;; Verify profile exists
        (if (is-some existing-profile)
            (begin
                ;; Remove the contributor profile
                (map-delete contributor-registry account-owner)
                (ok "Contributor profile successfully deregistered.")
            )
            (err ERR-RESOURCE-UNAVAILABLE)
        )
    )
)

;; =============================================
;; ORGANIZATION PROFILE MANAGEMENT FUNCTIONS
;; =============================================

;; Initialize a new organization profile
(define-public (register-organization 
    (title (string-ascii 100))
    (industry (string-ascii 50))
    (location (string-ascii 100)))
    (let
        (
            (account-owner tx-sender)
            (existing-record (map-get? organization-registry account-owner))
        )
        ;; Verify profile doesn't already exist
        (if (is-none existing-record)
            (begin
                ;; Validate all required fields
                (if (or (is-eq title "")
                        (is-eq industry "")
                        (is-eq location ""))
                    (err ERR-INVALID-LOCATION)
                    (begin
                        ;; Store the new organization profile
                        (map-set organization-registry account-owner
                            {
                                title: title,
                                industry: industry,
                                location: location
                            }
                        )
                        (ok "Organization profile successfully registered.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Modify an existing organization profile
(define-public (modify-organization-profile 
    (title (string-ascii 100))
    (industry (string-ascii 50))
    (location (string-ascii 100)))
    (let
        (
            (account-owner tx-sender)
            (existing-record (map-get? organization-registry account-owner))
        )
        ;; Verify profile exists
        (if (is-some existing-record)
            (begin
                ;; Validate all required fields
                (if (or (is-eq title "")
                        (is-eq industry "")
                        (is-eq location ""))
                    (err ERR-INVALID-LOCATION)
                    (begin
                        ;; Update the organization profile
                        (map-set organization-registry account-owner
                            {
                                title: title,
                                industry: industry,
                                location: location
                            }
                        )
                        (ok "Organization profile successfully modified.")
                    )
                )
            )
            (err ERR-RESOURCE-UNAVAILABLE)
        )
    )
)

;; Delete an existing organization profile
(define-public (deregister-organization)
    (let
        (
            (account-owner tx-sender)
            (existing-record (map-get? organization-registry account-owner))
        )
        ;; Verify profile exists
        (if (is-some existing-record)
            (begin
                ;; Remove the organization profile
                (map-delete organization-registry account-owner)
                (ok "Organization profile successfully deregistered.")
            )
            (err ERR-RESOURCE-UNAVAILABLE)
        )
    )
)



