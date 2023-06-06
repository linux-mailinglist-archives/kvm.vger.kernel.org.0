Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4CA725020
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 00:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbjFFWr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 18:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240047AbjFFWrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 18:47:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CDB1723
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 15:47:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9745baf7c13so844981266b.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 15:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686091654; x=1688683654;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X1Gsh3rDXwoxQE+ZW67KOw9Ou/YNhg+Z5AKxlf0N33g=;
        b=kI8yaVNaEqbRDdLShVWzw+v0zvtY03b5cSWqxyAQgllRPr07bH1Bi7ZIF2e2t4/yfl
         ODNO1TU5thCKm8LFXthxYJSw+EDUwswBYnpelKPJhOriC2gvpSMJ2LV2vk5IcMOBjl2L
         eMeDPc2LdUJ7Pwt1naT93rJ6LLcPL1g17fKc1zfe7HXbZgdAfWubAtwrl5pZ0arLY/v7
         r5uUdepOXrTuZrf4wUJl377KlQ83m0+KSiO1SmBL8TYGivWwks7COe7jNCwBbyp1xfgW
         RG7t460f0jrwc+JSchib6sPOv+luP8WS/wgopXUb5UZ35ng+qNMOHjAcQ++4L5pgySXM
         zjDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686091654; x=1688683654;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X1Gsh3rDXwoxQE+ZW67KOw9Ou/YNhg+Z5AKxlf0N33g=;
        b=f6OT/sBttnbFn1Y52epnyEPDolCyUlt3QGP1oztOaNkYSOI4HKaDxpbJHy2+o/h2oH
         q6F3k5pBCF7J6y35TM5OEV9/7/9DUiMSFQsRAmKCOxuHRo5Q1fyAfYdQVMseMqClsXv3
         QwX+Pc9iojnQh/+DphHZZMQa1eyHWyEz0onln5kWEmYE0yQDXIEUUvKb87mw7RI+zZtU
         jxanT9MsfIc9rgfauZhjc9cGBkWNngDxnqkkg+wcC7RVrfREOePYjr385AEESYXCLp1S
         aB5WL4RfoLat+3g2gsraZ0exMyVfbaGRgaPEwyjaVXdPknK4GGRXcWeiT1QTMGi1yuvQ
         hoiA==
X-Gm-Message-State: AC+VfDwj8ISC0pQGfndGjkiOraYoLHutsl9a/0eVe8tkNII+Ijl/b4dO
        wKheAcmV6+gtuI+N8wWonoQ2b8F+0c9jgtJVDs3anA==
X-Google-Smtp-Source: ACHHUZ4iKuoK9ihXN3ve5BrpM/kTOhrcSdCc6LrobjxOs2/UMt299TRnrnV7vr1yuU1RXrgXkAU/VbgwBn5YuxIpfZg=
X-Received: by 2002:a17:907:9496:b0:96f:f19b:887a with SMTP id
 dm22-20020a170907949600b0096ff19b887amr3503289ejc.56.1686091653710; Tue, 06
 Jun 2023 15:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com> <ZH4ofuj0qvKNO9Bz@google.com>
In-Reply-To: <ZH4ofuj0qvKNO9Bz@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 6 Jun 2023 15:46:57 -0700
Message-ID: <CAL715WKtsC=93Nqr7QJZxspWzF04_CLqN3FUxUaqTHWFRUrwBA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > >
> > > I don't understand the need for READ_ONCE() here. That implies that
> > > there is something tricky going on, and I don't think that's the case.
> >
> > READ_ONCE() is just telling the compiler not to remove the read. Since
> > this is reading a global variable,  the compiler might just read a
> > previous copy if the value has already been read into a local
> > variable. But that is not the case here...
> >
> > Note I see there is another READ_ONCE for
> > kvm->arch.indirect_shadow_pages, so I am reusing the same thing.
>
> I agree with Jim, using READ_ONCE() doesn't make any sense.  I suspect it may have
> been a misguided attempt to force the memory read to be as close to the write_lock()
> as possible, e.g. to minimize the chance of a false negative.

Sean :) Your suggestion is the opposite with Jim. He is suggesting
doing nothing, but
your suggestion is doing way more than READ_ONCE().

>
> > I did check the reordering issue but it should be fine because when
> > 'we' see indirect_shadow_pages as 0, the shadow pages must have
> > already been zapped. Not only because of the locking, but also the
> > program order in __kvm_mmu_prepare_zap_page() shows that it will zap
> > shadow pages first before updating the stats.
>
> I don't think zapping, i.e. the 1=>0 transition, is a concern.  KVM is dropping
> the SPTE, so racing with kvm_mmu_pte_write() is a non-issue because the guest
> will either see the old value, or will fault after the SPTE is zapped, i.e. KVM
> won't run with a stale even if kvm_mmu_pte_write() sees '0' before TLBs are
> flushed.

Agree.
>
> I believe the 0=>1 transition on the other hand doesn't have a *very* theoretical
> bug.  KVM needs to ensure that either kvm_mmu_pte_write() sees an elevated count,
> or that a page fault task sees the updated guest PTE, i.e. the emulated write.
> The READ_ONCE() likely serves this purpose in practice, though technically it's
> insufficient.

Agree.

>
> So I think this?

Hmm. I agree with both points above, but below, the change seems too
heavyweight. smp_wb() is a mfence(), i.e., serializing all
loads/stores before the instruction. Doing that for every shadow page
creation and destruction seems a lot.

In fact, the case that only matters is '0->1' which may potentially
confuse kvm_mmu_pte_write() when it reads 'indirect_shadow_count', but
the majority of the cases are 'X => X + 1' where X != 0. So, those
cases do not matter. So, if we want to add barriers, we only need it
for 0->1. Maybe creating a new variable and not blocking
account_shadow() and unaccount_shadow() is a better idea?

Regardless, the above problem is related to interactions among
account_shadow(), unaccount_shadow() and kvm_mmu_pte_write(). It has
nothing to do with the 'reexecute_instruction()', which is what this
patch is about. So, I think having a READ_ONCE() for
reexecute_instruction() should be good enough. What do you think.


>
> ---
>  arch/x86/kvm/mmu.h     | 14 ++++++++++++++
>  arch/x86/kvm/mmu/mmu.c | 13 ++++++++++++-
>  arch/x86/kvm/x86.c     |  8 +-------
>  3 files changed, 27 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 92d5a1924fc1..9cd105ccb1d4 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -264,6 +264,20 @@ static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>         return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
>  }
>
> +static inline bool kvm_mmu_has_indirect_shadow_pages(struct kvm *kvm)
> +{
> +       /*
> +        * When emulating guest writes, ensure the written value is visible to
> +        * any task that is handling page faults before checking whether or not
> +        * KVM is shadowing a guest PTE.  This ensures either KVM will create
> +        * the correct SPTE in the page fault handler, or this task will see
> +        * a non-zero indirect_shadow_pages.  Pairs with the smp_mb() in
> +        * account_shadowed() and unaccount_shadowed().
> +        */
> +       smp_mb();
> +       return kvm->arch.indirect_shadow_pages;
> +}
> +
>  static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
>  {
>         /* KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K) must be 0. */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..1735bee3f653 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -830,6 +830,17 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>         gfn_t gfn;
>
>         kvm->arch.indirect_shadow_pages++;
> +
> +       /*
> +        * Ensure indirect_shadow_pages is elevated prior to re-reading guest
> +        * child PTEs in FNAME(gpte_changed), i.e. guarantee either in-flight
> +        * emulated writes are visible before re-reading guest PTEs, or that
> +        * an emulated write will see the elevated count and acquire mmu_lock
> +        * to update SPTEs.  Pairs with the smp_mb() in
> +        * kvm_mmu_has_indirect_shadow_pages().
> +        */
> +       smp_mb();
> +
>         gfn = sp->gfn;
>         slots = kvm_memslots_for_spte_role(kvm, sp->role);
>         slot = __gfn_to_memslot(slots, gfn);
> @@ -5692,7 +5703,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>          * If we don't have indirect shadow pages, it means no page is
>          * write-protected, so we can exit simply.
>          */
> -       if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> +       if (!kvm_mmu_has_indirect_shadow_pages(vcpu->kvm))
>                 return;
>
>         pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index abfba3cae0ba..22c226f5f4f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8588,13 +8588,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>
>         /* The instructions are well-emulated on direct mmu. */
>         if (vcpu->arch.mmu->root_role.direct) {
> -               unsigned int indirect_shadow_pages;
> -
> -               write_lock(&vcpu->kvm->mmu_lock);
> -               indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
> -               write_unlock(&vcpu->kvm->mmu_lock);
> -
> -               if (indirect_shadow_pages)
> +               if (kvm_mmu_has_indirect_shadow_pages(vcpu->kvm))
>                         kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
>
>                 return true;
>
> base-commit: 69b4e5b82fec7195c79c939ce25789b16a133f3a
> --
>
