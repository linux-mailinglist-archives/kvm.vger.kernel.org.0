Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0462664CEFD
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 18:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiLNRxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 12:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiLNRxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 12:53:18 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8321023
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 09:53:17 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id pa22so1583279qkn.9
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 09:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qtzqksgbDSBUnfThhwNIuG565HLgSHV/Y7SFXSX6iRk=;
        b=Uo4p9ILjJJYHbbHc3nJgt5xQFrwb3luZ6P6bVtkhqfKaeP3jDnRd6GXebGp25O1t3H
         cd2MP63e1aX2ujsbzlY3acrZbjlxvH+WKpV9udfhvXXTIm7pTrnBtS6UKUsdBjFyR9ZA
         me9TX1JZ5xpN4SV5vgLl3Bp3F4EcDGabBjuWUjSRqb5T3Sc5+EXPYUx1QgU1ppU+owo9
         HiBede2+++uqyp1C1faFk3XpPsZ5W62tfkD3I6SN2eIDB3texOcYkSwNrhK8mXi9uiaY
         HA88oxlHm1vVoUML4lIbjAqPuRqfZD22ZQso1JPnOzvxTRvAHjVh2UMOPwnTsVwmPAOe
         OoCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qtzqksgbDSBUnfThhwNIuG565HLgSHV/Y7SFXSX6iRk=;
        b=jHfKZy0f0jPL8iuLsp21lU5FRbNFsuulHIuSQ3yX/gvhBOj5N9aQxjSZCAKz4EQNRp
         rNdToZuF8jKK87O6Iw4pjXKH4u89lhjYgonlstsWV6I/0IEDFLWeKt5e5hiHFFYgVDfC
         k6QWlSfPFD6cFyIDHEz5suSDsh6EY6zXNthyJny4PJaK9R4QvL2Nnz0Ij4bZ0NxXIFe6
         mjMQSLbibmet1DIjxuPY0lpek1qdpKYuIcNkzEWl9c9rnk8aaB/N8KVuibqui3EBwop6
         2WnlZxeT1q2K0nQgHYddOmSxx9e826+Smp8UryNPSLyP7F+wE3vgge8r3rfyDhp2Wy8V
         9kRQ==
X-Gm-Message-State: ANoB5pmAoSEFpoHVCGIIfGhgaabSWDc6S8F7wiEZSMLSYM+3bMtSURsQ
        ZhTBVBqT/Yakk2heszJ2v8eeP4MxxUqQzwo6ZatsAg==
X-Google-Smtp-Source: AA0mqf7sok6JDxBUsgOA7+BuK5IYefYnUo0u4V0WhrMLpoqG4afD6PuUwYTrli1heFAoEK+jlsyrscDySVaWUO5VXgo=
X-Received: by 2002:a37:808:0:b0:6fe:d95e:3cae with SMTP id
 8-20020a370808000000b006fed95e3caemr8831426qki.768.1671040396424; Wed, 14 Dec
 2022 09:53:16 -0800 (PST)
MIME-Version: 1.0
References: <20221206173601.549281-1-bgardon@google.com> <20221206173601.549281-3-bgardon@google.com>
 <Y5O+/1CYivRishFE@google.com> <CANgfPd8-i=B_c60MFn6symaqpUMXqu+HHJFDkQm8OuzOLnHQ+A@mail.gmail.com>
 <Y5kf2KI5oharI0xZ@google.com>
In-Reply-To: <Y5kf2KI5oharI0xZ@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 14 Dec 2022 09:53:05 -0800
Message-ID: <CANgfPd9xkRgm691Hy=Zbk=SAx-gaW-Hkk0XWQE0UsH9mJwLU-A@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: x86/MMU: Move rmap_iterator to rmap.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 4:59 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Dec 13, 2022, Ben Gardon wrote:
> > On Fri, Dec 9, 2022 at 3:04 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > > +/*
> > > > + * Used by the following functions to iterate through the sptes linked by a
> > > > + * rmap.  All fields are private and not assumed to be used outside.
> > > > + */
> > > > +struct rmap_iterator {
> > > > +     /* private fields */
> > > > +     struct pte_list_desc *desc;     /* holds the sptep if not NULL */
> > > > +     int pos;                        /* index of the sptep */
> > > > +};
> > > > +
> > > > +u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
> > > > +                 struct rmap_iterator *iter);
> > > > +u64 *rmap_get_next(struct rmap_iterator *iter);
> > > > +
> > > > +#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)                      \
> > > > +     for (_spte_ = rmap_get_first(_rmap_head_, _iter_);              \
> > > > +          _spte_; _spte_ = rmap_get_next(_iter_))
> > > > +
> > >
> > > I always found these function names and kvm_rmap_head confusing since
>
> Heh, you definitely aren't the only one.
>
> > > they are about iterating through the pte_list_desc data structure. The
> > > rmap (gfn -> list of sptes) is a specific application of the
> > > pte_list_desc structure, but not the only application. There's also
> > > parent_ptes in struct kvm_mmu_page, which is not an rmap, just a plain
> > > old list of ptes.
> >
> > > While you are refactoring this code, what do you think about doing the
> > > following renames?
> > >
> > >   struct kvm_rmap_head  -> struct pte_list_head
> > >   struct rmap_iterator  -> struct pte_list_iterator
> > >   rmap_get_first()      -> pte_list_get_first()
> > >   rmap_get_next()       -> pte_list_get_next()
> > >   for_each_rmap_spte()  -> for_each_pte_list_entry()
>
> I would strongly prefer to keep "spte" in this one regardless of what other naming
> changes we do (see below).  Maybe just for_each_spte()?  IMO, "pte_list_entry"
> unnecessarily obfuscates that it's a list of SPTEs.
>
> > > Then we can reserve the term "rmap" just for the actual rmap
> > > (slot->arch.rmap), and code that deals with sp->parent_ptes will become
> > > a lot more clear IMO (because it will not longer mention rmap).
> > >
> > > e.g. We go from this:
> > >
> > >   struct rmap_iterator iter;
> > >   u64 *sptep;
> > >
> > >   for_each_rmap_spte(&sp->parent_ptes, &iter, sptep) {
> > >      ...
> > >   }
> > >
> > > To this:
> > >
> > >   struct pte_list_iterator iter;
> > >   u64 *sptep;
> > >
> > >   for_each_pte_list_entry(&sp->parent_ptes, &iter, sptep) {
> > >      ...
> > >   }
> >
> > I like this suggestion, and I do think it'll make things more
> > readable. It's going to be a huge patch to rename all the instances of
> > kvm_rmap_head, but it's probably worth it.
>
> I generally like this idea too, but tying into my above comment, before jumping
> in I think we should figure out what end state we want, i.e. get the bikeshedding
> out of the way now to hopefully avoid dragging out a series while various things
> get nitpicked.
>
> E.g. if we if we just rename the structs and their macros, then we'll end up with
> things like
>
>         static bool slot_rmap_write_protect(struct kvm *kvm,
>                                             struct pte_list_head *rmap_head,
>                                             const struct kvm_memory_slot *slot)
>         {
>                 return rmap_write_protect(rmap_head, false);
>         }
>
> which isn't terrible, but there's still opportunity for cleanup, e.g.
> rmap_write_protect() could easily be sptes_write_protect() or write_protect_sptes().
>
> That will generate a naming conflict of sorts with pte_list_head if we don't also
> rename that to spte_list_head.  And I think capturing that it's a list of SPTEs and
> not guest PTEs will be helpful in general.
>
> And if we rename pte_list_head, then we might as well commit 100% and use consisnent
> nomenclature across the board, e.g. end up with
>
>         static bool sptes_clear_dirty(struct kvm *kvm, struct sptes_list_head *head,
>                                       const struct kvm_memory_slot *slot)
>         {
>                 u64 *sptep;
>                 struct spte_list_iterator iter;
>                 bool flush = false;
>
>                 for_each_spte(head, &iter, sptep) {
>                         if (spte_ad_need_write_protect(*sptep))
>                                 flush |= spte_wrprot_for_clear_dirty(sptep);
>                         else
>                                 flush |= spte_clear_dirty(sptep);
>                 }
>
>                 return flush;
>         }
>
> versus the current
>
>         static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>                                        const struct kvm_memory_slot *slot)
>         {
>                 u64 *sptep;
>                 struct rmap_iterator iter;
>                 bool flush = false;
>
>                 for_each_rmap_spte(rmap_head, &iter, sptep)
>                         if (spte_ad_need_write_protect(*sptep))
>                                 flush |= spte_wrprot_for_clear_dirty(sptep);
>                         else
>                                 flush |= spte_clear_dirty(sptep);
>
>                 return flush;
>         }

I'd be happy to see some consistent SPTE-based naming in the Shadow
MMU and more or less get rid of the rmap naming scheme. Once you
change to spte_list_head or whatever, the use of the actual rmap (an
array of spte_list_heads) becomes super narrow.

Given the potential for enormous scope creep on what's already going
to be a long series, I'm inclined to split this work into two parts:
1. Move code from mmu.c to shadow_mmu.c with minimal cleanups /
refactors / renames; just move the code
2. Clean up naming conventions: make the functions exported in
shadow_mmu.h consistent, get rid of the whole rmap naming scheme, etc.

That way git-blame will preserve context around the renames /
refactors which would be obfuscated if we did 2 before 1, and we can
reduce merge conflicts.
