Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA064E51A
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 01:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiLPASt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 19:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLPASs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 19:18:48 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB07D2D1C4;
        Thu, 15 Dec 2022 16:18:45 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so803065pjm.2;
        Thu, 15 Dec 2022 16:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BNkT/lMB4+c2Og60AfIDlidrTBQYynQG+9sbqgV86ek=;
        b=mREx+UWr4pTN6uiNErKtQO5j+Ib5777szn1BlL3ZtocgVrfbXoNSZRAMCkbnNfg0L2
         SuPZUMmRfyBUs1LoErp3f1r6ITvEKXX7jkQorCzm7UKaDwaQgUvxX8roiSO/WweQxCi8
         58hkK5nsa/GNt+ZA8ViDwPftWVL42FzA3ZPMAY+6IejwR7eKGj2TwaQvKQ/jV593GqnQ
         eJSQ3999tQxUtc3lju+fIPoC8OtvztU/TeuuQVRpYzWjZyEneRvt5zL8QjbgEgOb456G
         JqB+tMhDxNjXCa8ZeN/5WzeQS4NIuQl6N0aaTiAr1xLaVE98mm9bp1a8nCGL8p9gaPcu
         yN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNkT/lMB4+c2Og60AfIDlidrTBQYynQG+9sbqgV86ek=;
        b=qSwlwHxq2uvP6JZ6GgbRh1Z2HVcqSd5zK62iqSyO2V/lZFGmrIBJEmmleQ2iQY0twn
         Ey9cuv+lkl25uTWEk9MZ6AIzrmjrYBXQH57eURRqLhypsWWVfqM4e7qnX3cb4ZxNDc82
         QX0xWOPJ0hns+/9ufnmxd8++WegkroJQo5L3TDipVWx/v6zON/06n6pZSj5kUZd7uJWK
         OhSvstdxcDFQ3M0jtktEfYY2+U1My3klH1NRVdOv6PWnEl4zG08G6oaSl8Z4p47m51AR
         UpNcf1yl9jW8SjuxmLB+NduxBka+2XqUnJuvNy7A8NyZ0sBCYGJpoi4SEOdm5S45Ff6d
         5wHg==
X-Gm-Message-State: ANoB5pnmieFEeWksHIETFA7/C9vj2GQSE+c+8qEYalMjG/n4h48hI/4y
        locjP+xumkP6197KhE5O7Fg=
X-Google-Smtp-Source: AA0mqf7ojLTElAa+TSC+WbL2mNV+8/kO4p8HU4csMRkkLBiY6gA4N93iARUpmDSDyKoEWWDZTO7ahg==
X-Received: by 2002:a17:902:aa47:b0:185:441e:222a with SMTP id c7-20020a170902aa4700b00185441e222amr30704860plr.37.1671149925293;
        Thu, 15 Dec 2022 16:18:45 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id i1-20020a170902c94100b00186727e5f5csm198923pla.248.2022.12.15.16.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 16:18:44 -0800 (PST)
Date:   Thu, 15 Dec 2022 16:18:43 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 062/108] KVM: x86/tdp_mmu: implement MapGPA hypercall
 for TDX
Message-ID: <20221216001843.GL3632095@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <73ef2bdcdf8ec88bbec9d3780484cecda7a21e6f.1667110240.git.isaku.yamahata@intel.com>
 <b49d953a-61f0-e466-90d2-713e25dff770@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b49d953a-61f0-e466-90d2-713e25dff770@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 11:05:46PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > The TDX Guest-Hypervisor communication interface(GHCI) specification
> > defines MapGPA hypercall for guest TD to request the host VMM to map given
> > GPA range as private or shared.
> > 
> > It means the guest TD uses the GPA as shared (or private).  The GPA
> > won't be used as private (or shared).  VMM should enforce GPA usage. VMM
> > doesn't have to map the GPA on the hypercall request.
> > 
> > - Zap the aliased region.
> >    If shared (or private) GPA is requested, zap private (or shared) GPA
> >    (modulo shared bit).
> > - Record the request GPA is shared (or private) by kvm.mem_attr_array.
> > - Don't map GPA. The GPA is mapped on the next EPT violation.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/mmu.h         |  5 ++++
> >   arch/x86/kvm/mmu/mmu.c     | 60 ++++++++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/mmu/tdp_mmu.c | 35 ++++++++++++++++++++++
> >   arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
> >   4 files changed, 103 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index e2a0dfbee56d..e1641fa5a862 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -219,6 +219,11 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
> >   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> > +int __kvm_mmu_map_gpa(struct kvm *kvm, gfn_t *startp, gfn_t end,
> > +		      bool map_private);
> > +int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
> > +		    bool map_private);
> > +
> >   int kvm_mmu_post_init_vm(struct kvm *kvm);
> >   void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 168c84c99de3..37b378bf60df 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6778,6 +6778,66 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
> >   	}
> >   }
> > +int __kvm_mmu_map_gpa(struct kvm *kvm, gfn_t *startp, gfn_t end,
> > +		      bool map_private)
> > +{
> > +	gfn_t start = *startp;
> > +	int attr;
> > +	int ret;
> > +
> > +	if (!kvm_gfn_shared_mask(kvm))
> > +		return -EOPNOTSUPP;
> > +
> > +	attr = map_private ? KVM_MEM_ATTR_PRIVATE : KVM_MEM_ATTR_SHARED;
> > +	start = start & ~kvm_gfn_shared_mask(kvm);
> > +	end = end & ~kvm_gfn_shared_mask(kvm);
> > +
> > +	/*
> > +	 * To make the following kvm_vm_set_mem_attr() success within spinlock
> > +	 * without memory allocation.
> > +	 */
> > +	ret = kvm_vm_reserve_mem_attr(kvm, start, end);
> > +	if (ret)
> > +		return ret;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +	if (is_tdp_mmu_enabled(kvm)) {
> 
> How about moving the condition test to the beginning of the function to make
> the code simpler?

Ok.


> > +		gfn_t s = start;
> > +
> > +		ret = kvm_tdp_mmu_map_gpa(kvm, &s, end, map_private);
> > +		if (!ret) {
> > +			KVM_BUG_ON(kvm_vm_set_mem_attr(kvm, attr, start, end), kvm);
> > +		} else if (ret == -EAGAIN) {
> > +			KVM_BUG_ON(kvm_vm_set_mem_attr(kvm, attr, start, s), kvm);
> > +			start = s;
> > +		}
> > +	} else {
> > +		ret = -EOPNOTSUPP;
> > +	}
> > +	write_unlock(&kvm->mmu_lock);
> > +
> > +	if (ret == -EAGAIN) {
> > +		if (map_private)
> > +			*startp = kvm_gfn_private(kvm, start);
> > +		else
> > +			*startp = kvm_gfn_shared(kvm, start);
> > +	}
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(__kvm_mmu_map_gpa);
> > +
> > +int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
> > +		    bool map_private)
> > +{
> > +	struct kvm_mmu *mmu = vcpu->arch.mmu;
> > +
> > +	if (!VALID_PAGE(mmu->root.hpa) || !VALID_PAGE(mmu->private_root_hpa))
> > +		return -EINVAL;
> > +
> > +	return __kvm_mmu_map_gpa(vcpu->kvm, startp, end, map_private);
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_mmu_map_gpa);
> > +
> >   static unsigned long
> >   mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> >   {
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 4b207ce83ffe..d3bab382ceaa 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -2156,6 +2156,41 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
> >   	return spte_set;
> >   }
> > +int kvm_tdp_mmu_map_gpa(struct kvm *kvm,
> > +			gfn_t *startp, gfn_t end, bool map_private)
> > +{
> > +	struct kvm_mmu_page *root;
> > +	gfn_t start = *startp;
> > +	bool flush = false;
> > +	int i;
> > +
> > +	lockdep_assert_held_write(&kvm->mmu_lock);
> > +	KVM_BUG_ON(start & kvm_gfn_shared_mask(kvm), kvm);
> > +	KVM_BUG_ON(end & kvm_gfn_shared_mask(kvm), kvm);
> > +
> > +	kvm_mmu_invalidate_begin(kvm, start, end);
> > +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > +		for_each_tdp_mmu_root_yield_safe(kvm, root, i) {
> > +			if (is_private_sp(root) == map_private)
> > +				continue;
> > +
> > +			/*
> > +			 * TODO: If necessary, return to the caller with -EAGAIN
> > +			 * instead of yield-and-resume within
> > +			 * tdp_mmu_zap_leafs().
> > +			 */
> > +			flush = tdp_mmu_zap_leafs(kvm, root, start, end,
> > +						  /*can_yield=*/true, flush,
> > +						  /*zap_private=*/is_private_sp(root));
> > +		}
> > +	}
> > +	if (flush)
> > +		kvm_flush_remote_tlbs_with_address(kvm, start, end - start);
> > +	kvm_mmu_invalidate_end(kvm, start, end);
> > +
> > +	return 0;
> > +}
> > +
> >   /*
> >    * Return the level of the lowest level SPTE added to sptes.
> >    * That SPTE may be non-present.
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index 695175c921a5..cb13bc1c3679 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -51,6 +51,9 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
> >   				      gfn_t start, gfn_t end,
> >   				      int target_level, bool shared);
> > +int kvm_tdp_mmu_map_gpa(struct kvm *kvm,
> > +			gfn_t *startp, gfn_t end, bool map_private);
> 
> Sugguest to add some description about the function to avoid confusion,
> since the function name is quite generic but the usage is highly related to
> TDX.

Agreed that the name is too generic. Will rename it to kvm_tdp_mmu_map_private().

I can think of convert_private(), convert_gpa(), or any other suggestion?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
