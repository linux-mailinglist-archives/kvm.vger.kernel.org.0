Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5861353F2E9
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 02:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbiFGAUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 20:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiFGAUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 20:20:54 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7374DC5DBC
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 17:20:52 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q7so21884031wrg.5
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 17:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DMGzLGJzBT5T5b9r1J4zZuri0cLPViU0feoULeNGdLY=;
        b=oKDGVKm9F8zo/W+3dYhfwstlQfxZhRht93GrC1XCeJloml8fDQgLoynuKZfjGe+tse
         mrQEuAvRAuXVFbvfjbfFXwPCREHvKyfDEsXPxcRDaSIUyEc/5ks90/LxV9p/1f7vTLXN
         0qTOOaWD1SVMuLZAYzZbMSjLGylotunMJTEBR82Kzn5QxTi/DkBJ/kuxW5xnOKo295Bf
         iQ0wGcNuyYi/KtFbmVLnKNyC+hbDsaG5+1Xdp61+UQD43pSFREdTcC9V6mUoooaEuxyo
         hUx53uwhPBcoBIsK6PEmzc9pxijDzb6xC9qR4cNUsNoV9GtRlKG59ybKoCqgfFyRgPob
         6ETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DMGzLGJzBT5T5b9r1J4zZuri0cLPViU0feoULeNGdLY=;
        b=P9AB+pACDSSIPzR83NbEnfaji68bZKej1D1/M7iF1PIuImX0tmFdqc8W/EmZHov8pE
         Rl81akgSH03P4sN/3ozAmKKXQDm21b+B3ddANCbojqcxq9jERQXFXRYfDl2ZuOIX6SHn
         W23CdJ9hQLlnmj4rKi9ytUZDdpweRUrAeHtF3GY/IjoT6yCiPjQaK7mper0bFF3/m485
         IyFbpK6S0uuKJ4m1pXs4mCDt21NN7pf+7hA/y/06SN8683oyRDuhdDpWVJHuy0k1gBQ5
         1ZbO88EPXPWcDoZADM+DuXatmn57dI+sYojkXjpBA1RwX/mrVkm9k8JKRxhQvYknQMsp
         giHA==
X-Gm-Message-State: AOAM532K5dbHTKPdJ8FWdncQ3tICtZOKTUxuMwiPRD70bOwbIfSYreWt
        2H2JKkOq4vUmg5QJ5fCwQ8Hkhj58IQVyBcvJU8mYig==
X-Google-Smtp-Source: ABdhPJx+8X8hTzr3xVfvuroF0RVItmgqlm+YewhrD+ZiGchKPEilEhhxIlhTvdnxLo0na+sWqpTBG04Oqv1fgRtR+aY=
X-Received: by 2002:a5d:4b10:0:b0:213:5e0:2c6c with SMTP id
 v16-20020a5d4b10000000b0021305e02c6cmr23716926wrq.126.1654561250805; Mon, 06
 Jun 2022 17:20:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org> <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
 <CA+EHjTx328na4FDfKU-cdLX+SV4MmKfMKKrTHo5H0=iB2GTQ+A@mail.gmail.com>
 <Ypl5TdMN3J/tttNe@google.com> <87v8tgltqy.wl-maz@kernel.org>
In-Reply-To: <87v8tgltqy.wl-maz@kernel.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 6 Jun 2022 17:20:39 -0700
Message-ID: <CAMn1gO7mP_QTb+fkfvc6qQoN0aU6TwkExU-Wj+VR6rjBsmhs1g@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To:     Marc Zyngier <maz@kernel.org>
Cc:     Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Sat, Jun 4, 2022 at 1:26 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 03 Jun 2022 04:00:29 +0100,
> Peter Collingbourne <pcc@google.com> wrote:
> >
> > Hi Fuad,
> >
> > On Fri, May 27, 2022 at 08:55:42AM +0100, Fuad Tabba wrote:
> > > Hi Peter,
> > >
> > > On Thu, May 26, 2022 at 9:08 PM Peter Collingbourne <pcc@google.com> wrote:
> > > >
> > > > On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
> > > > >
> > > > > From: Fuad Tabba <tabba@google.com>
> > > > >
> > > > > Return an error (-EINVAL) if trying to enable MTE on a protected
> > > > > vm.
> > > >
> > > > I think this commit message needs more explanation as to why MTE is
> > > > not currently supported in protected VMs.
> > >
> > > Yes, we need to explain this more. Basically this is an extension of
> > > restricting features for protected VMs done earlier [*].
> > >
> > > Various VM feature configurations are allowed in KVM/arm64, each requiring
> > > specific handling logic to deal with traps, context-switching and potentially
> > > emulation. Achieving feature parity in pKVM therefore requires either elevating
> > > this logic to EL2 (and substantially increasing the TCB) or continuing to trust
> > > the host handlers at EL1. Since neither of these options are especially
> > > appealing, pKVM instead limits the CPU features exposed to a guest to a fixed
> > > configuration based on the underlying hardware and which can mostly be provided
> > > straightforwardly by EL2.
> > >
> > > This of course can change in the future and we can support more
> > > features for protected VMs as needed. We'll expand on this commit
> > > message when we respin.
> > >
> > > Also note that this only applies to protected VMs. Non-protected VMs
> > > in protected mode support MTE.
> >
> > I see. In this case unless I'm missing something the EL2 side seems
> > quite trivial though (flipping some bits in HCR_EL2). The patch below
> > (in place of this one) seems to make MTE work in my test environment
> > (patched [1] crosvm on Android in MTE-enabled QEMU).
> >
> > [1] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/3689015
> >
> > From c87965cd14515586d487872486e7670874209113 Mon Sep 17 00:00:00 2001
> > From: Peter Collingbourne <pcc@google.com>
> > Date: Thu, 2 Jun 2022 19:16:02 -0700
> > Subject: [PATCH] arm64: support MTE in protected VMs
> >
> > Enable HCR_EL2.ATA while running a vCPU with MTE enabled.
> >
> > To avoid exposing MTE tags from the host to protected VMs, sanitize
> > tags before donating pages.
> >
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pkvm.h | 4 +++-
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c    | 6 +++---
> >  arch/arm64/kvm/mmu.c              | 4 +++-
> >  3 files changed, 9 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index 952e3c3fa32d..9ca9296f2a25 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -73,10 +73,12 @@ void kvm_shadow_destroy(struct kvm *kvm);
> >   * Allow for protected VMs:
> >   * - Branch Target Identification
> >   * - Speculative Store Bypassing
> > + * - Memory Tagging Extension
> >   */
> >  #define PVM_ID_AA64PFR1_ALLOW (\
> >       ARM64_FEATURE_MASK(ID_AA64PFR1_BT) | \
> > -     ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) \
> > +     ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) | \
> > +     ARM64_FEATURE_MASK(ID_AA64PFR1_MTE) \
> >       )
> >
> >  /*
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index e33ba9067d7b..46ddd9093ac7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -88,7 +88,7 @@ static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
> >       /* Memory Tagging: Trap and Treat as Untagged if not supported. */
> >       if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), feature_ids)) {
> >               hcr_set |= HCR_TID5;
> > -             hcr_clear |= HCR_DCT | HCR_ATA;
> > +             hcr_clear |= HCR_ATA;
> >       }
> >
> >       vcpu->arch.hcr_el2 |= hcr_set;
> > @@ -179,8 +179,8 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
> >        * - Feature id registers: to control features exposed to guests
> >        * - Implementation-defined features
> >        */
> > -     vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS |
> > -                          HCR_TID3 | HCR_TACR | HCR_TIDCP | HCR_TID1;
> > +     vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS | HCR_TID3 | HCR_TACR | HCR_TIDCP |
> > +                          HCR_TID1 | HCR_ATA;
> >
> >       if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
> >               /* route synchronous external abort exceptions to EL2 */
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 392ff7b2362d..f513852357f7 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1206,8 +1206,10 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >               goto dec_account;
> >       }
> >
> > -     write_lock(&kvm->mmu_lock);
> >       pfn = page_to_pfn(page);
> > +     sanitise_mte_tags(kvm, pfn, PAGE_SIZE);
> > +
> > +     write_lock(&kvm->mmu_lock);
>
> Is it really safe to rely on the host to clear the tags? My guts
> feeling says that it isn't. If it is required, we cannot leave this
> responsibility to the host, and this logic must be moved to EL2. And
> if it isn't, then we should drop it.

The goal here isn't to protect the guest. It's already the case that
whatever the page contents are when the page is donated (from the
perspective of the KVM client), that's what the guest sees. That
applies to both data and (in non-protected VMs) tags.

The code that I added here is for solving a different problem, which
is to avoid exposing stale host state to the guest, which the KVM
client may not even be aware of. We sanitize pages before exposing
them in non-protected VMs for the same reason.

> >       ret = pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT);
> >       if (ret) {
> >               if (ret == -EAGAIN)
>
> But the bigger picture here is what ensures that the host cannot mess
> with the guest tags? I don't think we have a any mechanism to
> guarantee that, specially on systems where the tags are only a memory
> carve-out, which the host could map and change at will.

Right, I forgot about that. We probably only want to expose MTE to
guests if we have some indication (through the device tree or ACPI) of
how to protect the guest tag storage.

> In any case, this isn't the time to pile new features on top of
> pKVM. The current plan is to not support MTE at all, and only do it
> once we have a definitive story on page donation (which as you may
> have noticed, is pretty hacky). I don't see any compelling reason to
> add MTE to the mix until this is solved.

It sounds reasonable to land a basic set of features to begin with and
add MTE later. I'll develop my MTE-in-pKVM patch series as a followup
on top of this series.

Peter
