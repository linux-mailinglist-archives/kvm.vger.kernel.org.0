Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5411F5A8DF4
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 08:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiIAGHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 02:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIAGHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 02:07:16 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE59B111AF9;
        Wed, 31 Aug 2022 23:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662012435; x=1693548435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gIrSY7DdtbybFoNsiSfisKRymgu0udEoQ/Gc+rOFvsI=;
  b=NZA8V0qKt21XElXRweEitR/Nd1XEbfc04fVEjhN4f5RNW22+JT38r7my
   VkNEm+qDKQ58VhXrQ5CJj6eZhcJjhk13K9q3XgkFWHYDEyXRxgvTTzA3b
   634tXbV7f6pxbB4Hm3MqTMqns3y7hTsfi7GDxv3mufOGT4tARaQNdBZN8
   3Q7pHVmQK2PJWljwoWVkKGsSDpDl2DBV2mAjkFMbePwN2B0CJc0dCISAP
   y2LR43dl7Q/5fdNxE/EYgJVvxTkuOXAKn30CxRgU6U5lh1dVREEA6XVrG
   t0kc6rCTcqMsTxuzJZvGufCPIjNUPEzGgjYJ5W2MXSTOBb8UV2I2yaNp1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321770813"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321770813"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 23:07:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673695667"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 31 Aug 2022 23:07:00 -0700
Date:   Thu, 1 Sep 2022 14:07:00 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 035/103] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
Message-ID: <20220901060700.nlygpkpoijvrabee@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <af2b2a8b708f352ccd269f805c743f6c04ccda37.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af2b2a8b708f352ccd269f805c743f6c04ccda37.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:20PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> TDX requires special handling to support large private page.  For
> simplicity, only support 4K page for TD guest for now.  Add per-VM maximum
> page level support to support different maximum page sizes for TD guest and
> conventional VMX guest.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu/mmu.c          | 1 +
>  arch/x86/kvm/mmu/mmu_internal.h | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3c4051d4512b..e07294fc2219 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1142,6 +1142,7 @@ struct kvm_arch {
>  	unsigned long n_requested_mmu_pages;
>  	unsigned long n_max_mmu_pages;
>  	unsigned int indirect_shadow_pages;
> +	int tdp_max_page_level;
>  	u8 mmu_valid_gen;
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>  	struct list_head active_mmu_pages;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1f7f61e04b94..0e5a6dcc4966 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6063,6 +6063,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
>  	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
>
> +	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
>  	return 0;
>  }
>
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 582def531d4d..e1b2e84c16b5 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -272,7 +272,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.nx_huge_page_workaround_enabled =
>  			is_nx_huge_page_enabled(vcpu->kvm),
>
> -		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> +		.max_level = vcpu->kvm->arch.tdp_max_page_level,
>  		.req_level = PG_LEVEL_4K,
>  		.goal_level = PG_LEVEL_4K,
>  	};
> --
> 2.25.1
>
