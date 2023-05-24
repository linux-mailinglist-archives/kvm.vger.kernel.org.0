Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB4870F924
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 16:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbjEXOuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 10:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbjEXOua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 10:50:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7351A7
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 07:50:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8c3186735so1805909276.3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 07:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684939826; x=1687531826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=40yUgUlbwc4RhRssiuflAXOTLpAUgoytovGBs7C23Yg=;
        b=Q6uwRySXlrlY7Xnv4ZpaEU7ROSnEmnn1fCPx5rO66aEKoR84OF1iZZyvsVNTPPJS6q
         utSaz7LwTHMgp6YSgfWP4rcip0TbIVxVYYhVa6IYNrSIzm+kpmFHuGQrN8bJiPHLpy9b
         BAK7elqPCSMVy0IJCz02AiaEYyAlVLV5/qOLoLICOjDtVWXrknLekEXkeLqu+Mdlxqx+
         O5UnZdN/5g3dSVvkgurIs2JPQtZA8riS1D/6AZVVYTtefd9cvOS0hd9ADZN5ML/n1/FP
         4sBqPKbTckbH5mRRQ4V2bafMpIQn0buYM5x5HLEyas2DdFuT6kG21YDkwXbOalpNwehJ
         1drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684939826; x=1687531826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40yUgUlbwc4RhRssiuflAXOTLpAUgoytovGBs7C23Yg=;
        b=eiMj1zMXNIng0yg57KzLcejYkTnk/nIIkntecYWgmf+9af31qH0ZCzqzkplGktyYGQ
         rGHS5ad9gFFWGuwaTSfS//hrMSEo9QzyWm1M2XoHNVZL8/c7v5MaSgDyV8vPE6ZUF3ZK
         kGgyk+WmY/tQLwDJ0Jzhmy+JU6nKgvakSOteE1pzN2+nSBw0mg65KXpRdJhPlYapoh8a
         52MBevFBYwdANvgmUwQWbnMnPOTQaG/VyKO/5r8FsMN3afr1gSI79c7fgdsKgyLtpAsx
         eiDnJoqUWLFSoW8LzDKcIJCTLLLD34g2Y6p/JIyTcj0stCeXcCmqigARKinj18Ku/Fbd
         St5g==
X-Gm-Message-State: AC+VfDyWl/F3/mquOBuq8SO+cGKCnjRRL2HYbwA2OoRCJajU/WbbA0rj
        i72gs/OzRVxWdNJ/M+LAhgfb7dcWvEo=
X-Google-Smtp-Source: ACHHUZ5S1CBSAogC6RsT9oNlIpsGijINHHJFq/4RV8oYeheVtgb5WnH4kNb50wcO98X2wOYk3vCUhWmPJ44=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1813:b0:ba8:4000:d7e1 with SMTP id
 cf19-20020a056902181300b00ba84000d7e1mr28841ybb.2.1684939826666; Wed, 24 May
 2023 07:50:26 -0700 (PDT)
Date:   Wed, 24 May 2023 07:50:24 -0700
In-Reply-To: <ZG10zi6YtqGeik7u@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230509134825.1523-1-yan.y.zhao@intel.com> <20230509135006.1604-1-yan.y.zhao@intel.com>
 <ZFsr9TynkA/CyPgg@chao-email> <ZFtQeLNuXP6tDMne@yzhao56-desk.sh.intel.com>
 <ZG1DhSdhpTkxrfCq@google.com> <ZG10zi6YtqGeik7u@yzhao56-desk.sh.intel.com>
Message-ID: <ZG4kMKXKnQuQOTa7@google.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to indicate
 memtype changes
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023, Yan Zhao wrote:
> On Tue, May 23, 2023 at 03:51:49PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > index 3eb6e7f47e96..a67c28a56417 100644
> > --- a/arch/x86/kvm/mtrr.c
> > +++ b/arch/x86/kvm/mtrr.c
> > @@ -320,7 +320,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> >  	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
> >  	gfn_t start, end;
> >  
> > -	if (!tdp_enabled || !kvm_arch_has_noncoherent_dma(vcpu->kvm))
> > +	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> Could we also add another helper kvm_mmu_cap_honors_guest_mtrrs(), which
> does not check kvm_arch_has_noncoherent_dma()?
> 
> +static inline bool kvm_mmu_cap_honors_guest_mtrrs(struct kvm *kvm)
> +{
> +       return !!shadow_memtype_mask;
> +}
> 
> This is because in patch 4 I plan to do the EPT zap when
> noncoherent_dma_count goes from 1 to 0.

Hrm, the 1->0 transition is annoying.  Rather than trying to capture the "everything
except non-coherent DMA" aspect, what about this?

mmu.c:

bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma)
{
	/*
	 * If the TDP is enabled, the host MTRRs are ignored by TDP
	 * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
	 * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
	 * from the guest's MTRRs so that guest accesses to memory that is
	 * DMA'd aren't cached against the guest's wishes.
	 *
	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
	 * e.g. KVM will force UC memtype for host MMIO.
	 */
	return vm_has_noncoherent_dma && tdp_enabled && shadow_memtype_mask;
}

mmu.h:

bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma);

static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
{
	
	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent_dma(kvm));
}

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 41d7bb51a297..ad0c43d7f532 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13146,13 +13146,19 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
> 
>  void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
>  {
> -       atomic_inc(&kvm->arch.noncoherent_dma_count);
> +       if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1) {
> +               if (kvm_mmu_cap_honors_guest_mtrrs(kvm))
> +                       kvm_zap_gfn_range(kvm, 0, ~0ULL);

No need for multiple if statements.  Though rather than have identical code in
both the start/end paths, how about this?  That provides a single location for a
comment.  Or maybe first/last instead of start/end?

static void kvm_noncoherent_dma_start_or_end(struct kvm *kvm)
{
	/* comment goes here. */
	if (__kvm_mmu_honors_guest_mtrrs(kvm, true))
		kvm_zap_gfn_range(kvm, 0, ~0ULL);
}

void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
{
	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)
		kvm_noncoherent_dma_start_or_end(kvm);
}
EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);

void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
{
	if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count))
		kvm_noncoherent_dma_start_or_end(kvm);
}
EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);

