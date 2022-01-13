Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33B048DCAF
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 18:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiAMRKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 12:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiAMRKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 12:10:36 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD75C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 09:10:35 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id s30so21863933lfo.7
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 09:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JOz96PjrzNYDSxp90dJH/qz3cIJ31aow/lemfL+/Kl4=;
        b=PBSSAutGD+wJm6XXGTzbQLAOVwWxTK025E3bGM/NA4V31Nv9kR1gS8ObPM9oSILKTd
         oEedbJKGD8OU24Layp8tMU1qRi3a+d4Yuj3YMNmDipQLZtvs6Uh8UaoMV6r2MJTjsN6B
         jVJd3jm+hkQGrjuLNTTSa7oUUH9pynd29Bw/bvNPXkDZqOy9N7LmWscmoiDBY5BRTsCJ
         yFAKnFxvc5rRagkdi2BsMcLHhhDKnXAOMT0t2dBZ6sea4BuT+jW9EkXmtawWWE2ph2fU
         1tdPb6ru+lxkPpFr5bUn95dHhnfzBLJNUylDEI+yNooYPX7fRbWmf+03puEMWLIi66+q
         7HzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JOz96PjrzNYDSxp90dJH/qz3cIJ31aow/lemfL+/Kl4=;
        b=lOvIvVjgU6sFWkajKEiLjtEyi+qepV2IgWYj07TJ//A5ERixrU6/R/oWkn0OSzgoB/
         uV0Gk5EnTSi7wBVFzh2vIugpqeRIatM26oO00aG8zoCRa0V7xlVgjyF/VQJTv5EFtroC
         I5ncupG73hr1vCJHoag5kfKhwyTWsZ3OAKzCy1LQw1heu+cSUOagkuS6DLsryFjFVxsA
         owvM38cWmuhB68+8exa+8UX1jhoFgUa5l0rCt0bayFviTKtbzwUOOYfRgc+pw3G3mSfT
         gBlJwU4D7jomK/Osr7TSROitYi4GyHp4bDinXbhMNb7CdY78H81R4oGs0SV4HkuTEnUR
         DUog==
X-Gm-Message-State: AOAM530IRJMLK5NpEjKdUnH6iL4REjkb41WfzyO1SwPb2Pl0WLccwYyt
        LKjS5h69ykAZ14mrDUS7BpsX31C40dPPetgJRvH/tzjLAs29Bw==
X-Google-Smtp-Source: ABdhPJx/M1DXkjiGhYzRVZaOUfcpMoE675R5O1kc3y8tEFJ6Zl0gqYhG6SFciytRPc5YVp4MEdcb7tDZgBcmQ6sufg0=
X-Received: by 2002:a05:6512:b93:: with SMTP id b19mr3689196lfv.190.1642093833735;
 Thu, 13 Jan 2022 09:10:33 -0800 (PST)
MIME-Version: 1.0
References: <20220112215801.3502286-1-dmatlack@google.com> <20220112215801.3502286-3-dmatlack@google.com>
 <Yd92T8RoZZi6usxH@google.com>
In-Reply-To: <Yd92T8RoZZi6usxH@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 13 Jan 2022 09:10:07 -0800
Message-ID: <CALzav=dhd3rLh6tDJV0BR7aH0FV=Xv9xVm5XdbVitQYfSAqfYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Improve comment about TLB flush
 semantics for write-protection
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 4:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jan 12, 2022, David Matlack wrote:
> > Rewrite the comment in kvm_mmu_slot_remove_write_access() that explains
> > why it is safe to flush TLBs outside of the MMU lock after
> > write-protecting SPTEs for dirty logging. The current comment is a long
> > run-on sentance that was difficult to undertsand. In addition it was
> > specific to the shadow MMU (mentioning mmu_spte_update()) when the TDP
> > MMU has to handle this as well.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 29 ++++++++++++++++++++---------
> >  1 file changed, 20 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1d275e9d76b5..33f550b3be8f 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5825,15 +5825,26 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >       }
> >
> >       /*
> > -      * We can flush all the TLBs out of the mmu lock without TLB
> > -      * corruption since we just change the spte from writable to
> > -      * readonly so that we only need to care the case of changing
> > -      * spte from present to present (changing the spte from present
> > -      * to nonpresent will flush all the TLBs immediately), in other
> > -      * words, the only case we care is mmu_spte_update() where we
> > -      * have checked Host-writable | MMU-writable instead of
> > -      * PT_WRITABLE_MASK, that means it does not depend on PT_WRITABLE_MASK
> > -      * anymore.
> > +      * It is safe to flush TLBs outside of the MMU lock since SPTEs are only
> > +      * being changed from writable to read-only (i.e. the mapping to host
> > +      * PFNs is not changing).
>
> Hmm, you mostly address things in the next sentence/paragraph, but it's more than
> the SPTE being downgraded from writable => read-only, e.g. if the SPTE were being
> made read-only due to userspace removing permissions, then KVM would need to flush
> before dropping mmu_lock.  The qualifier about the PFN not changing actually does
> more harm than good because it further suggests that writable => read-only is
> somehow inherently safe.
>
> > +      * All we care about is that CPUs start using the
> > +      * read-only mappings from this point forward to ensure the dirty bitmap
> > +      * gets updated, but that does not need to run under the MMU lock.
>
> "this point forward" isn't technically true, the requirement is that the flush
> occurs before the memslot update completes.  Definitely splitting hairs, I mean,
> this basically is the end of the memslot update, but it's an opportunity to
> clarify _why_ the flush needs to happen at this point.
>
> > +      *
> > +      * Note that there are other reasons why SPTEs can be write-protected
> > +      * besides dirty logging: (1) to intercept guest page table
> > +      * modifications when doing shadow paging and (2) to protecting guest
> > +      * memory that is not host-writable.
>
> So, technically, #2 is not possible.  KVM doesn't allow a memslot to be converted
> from writable => read-only, userspace must first delete the entire memslot.  That
> means the relevant SPTEs never transition directly from writable to !writable,
> they are instead zapped entirely and "new" SPTEs are created that are read-only
> from their genesis.
>
> Making a VMA read-only also results in SPTEs being zapped and recreated, though
> this is an area for improvement.  We could cover future changes in this area by
> being a bit fuzzy in the wording, but I think it would be better to talk only
> about the shadow paging case and thus only about MMU-writable, because Host-writable
> is (currently) immutable and making it mutable (in the mmu_notifier path) will
> have additional "rule" changes.
>
> > +      * Both of these usecases require
> > +      * flushing the TLB under the MMU lock to ensure CPUs are not running
> > +      * with writable SPTEs in their TLB. The tricky part is knowing when it
> > +      * is safe to skip a TLB flush if an SPTE is already write-protected,
> > +      * since it could have been write-protected for dirty-logging which does
> > +      * not flush under the lock.
>
> It's a bit unclear that the last "skip a TLB flush" snippet is referring to a
> future TLB flush, not this TLB flush.
>
> > +      *
> > +      * To handle this each SPTE has an MMU-writable bit and a Host-writable
> > +      * bit (KVM-specific bits that are not used by hardware). These bits
> > +      * allow KVM to deduce *why* a given SPTE is currently write-protected,
> > +      * so that it knows when it needs to flush TLBs under the MMU lock.
>
> I much rather we add this type of comment over the definitions for
> DEFAULT_SPTE_{HOST,MMU}_WRITEABLE and then provide a reference to those definitions
> after a very brief "KVM uses the MMU-writable bit".
>
> So something like this?  Plus more commentry in spte.h.
>
>         /*
>          * It's safe to flush TLBs after dropping mmu_lock as making a writable
>          * SPTE read-only for dirty logging only needs to ensure KVM starts
>          * logging writes to the memslot before the memslot update completes,
>          * i.e. before the enabling of dirty logging is visible to userspace.
>          *
>          * Note, KVM also write-protects SPTEs when shadowing guest page tables,
>          * in which case a TLB flush is needed before dropping mmu_lock().  To
>          * ensure a future TLB flush isn't missed, KVM uses a software-available
>          * bit to track if a SPTE is MMU-Writable, i.e. is considered writable
>          * for shadow paging purposes.  When write-protecting for shadow paging,
>          * KVM clears both WRITABLE and MMU-Writable, and performs a TLB flush
>          * while holding mmu_lock if either bit is cleared.
>          *
>          * See DEFAULT_SPTE_{HOST,MMU}_WRITEABLE for more details.
>          */

Makes sense. I'll rework the comment per your feedback and also
document the {host,mmu}-writable bits. Although I think it'd make more
sense to put those comments on shadow_{host,mmu}_writable_mask as
those are the symbols used throughout the code and EPT uses different
bits than DEFAULT_..._WRITABLE.

>
> >        */
> >       if (flush)
> >               kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> > --
> > 2.34.1.703.g22d0c6ccf7-goog
> >
