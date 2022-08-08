Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8FD58C2F0
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 07:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbiHHFlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 01:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiHHFlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 01:41:00 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3D62EA;
        Sun,  7 Aug 2022 22:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659937259; x=1691473259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=akNgTm7cdedf1F6vbkF2TOqzk+nLQRL0d/XpdejauUo=;
  b=TyPWU/yY2ME3ZgNQnXi2VhG3m44N0IMbaU8OjQajVxRkCMO0Op/cXWhQ
   eli/R4nZYOzFOVOQvXFt//aYBebvQKKXwrIYa0HIn9TRR+ioFFuy0AMKh
   dHmALN42kCak3d65exqLKVVUtqIKu/x/rtpDA8iyU3+1V1uRj/kZDtSkx
   sUYaXzAQ1KVX+KLEJfrzWs7Gx6tI1GFymoQBLvRnyYCvpYOBKDFsV2fV9
   Q+fdx+kZUku2nHxnaqGrUPcZRpA4VVcQ3uV6MKeymcpGec2PlVAcCg1oG
   FTPSZoUhS2UM/ggjhApcOa+R1dZ8Mwd/SD/AobCrup4RxeRJTIbQqpDYP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="291283923"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="291283923"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 22:40:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632744483"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.11]) ([10.249.175.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 22:40:57 -0700
Message-ID: <e275d842-d115-d1d2-a4c2-07ddd057ece1@intel.com>
Date:   Mon, 8 Aug 2022 13:40:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC PATCH 13/13] KVM: x86: remove struct
 kvm_arch.tdp_max_page_level
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854957.git.isaku.yamahata@intel.com>
 <1469a0a4aabcaf51f67ed4b4e25155267e07bfd1.1659854957.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1469a0a4aabcaf51f67ed4b4e25155267e07bfd1.1659854957.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/8/2022 6:18 AM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Now that everything is there to support large page for TD guest.  Remove
> tdp_max_page_level from struct kvm_arch that limits the page size.

Isaku, we cannot do this to remove tdp_max_page_level. Instead, we need 
assign it as PG_LEVEL_2M, because TDX currently only supports AUG'ing a 
4K/2M page, 1G is not supported yet.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 -
>   arch/x86/kvm/mmu/mmu.c          | 1 -
>   arch/x86/kvm/mmu/mmu_internal.h | 2 +-
>   arch/x86/kvm/vmx/tdx.c          | 3 ---
>   4 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a6bfcabcbbd7..80f2bc3fbf0c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1190,7 +1190,6 @@ struct kvm_arch {
>   	unsigned long n_requested_mmu_pages;
>   	unsigned long n_max_mmu_pages;
>   	unsigned int indirect_shadow_pages;
> -	int tdp_max_page_level;
>   	u8 mmu_valid_gen;
>   	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>   	struct list_head active_mmu_pages;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ba21503fa46f..0cbd52c476d7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6232,7 +6232,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>   	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
>   	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
>   
> -	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index e5d5fea29bfa..82b220c4d1bd 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -395,7 +395,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   			is_nx_huge_page_enabled(vcpu->kvm),
>   		.is_private = kvm_is_private_gpa(vcpu->kvm, cr2_or_gpa),
>   
> -		.max_level = vcpu->kvm->arch.tdp_max_page_level,
> +		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
>   		.req_level = PG_LEVEL_4K,
>   		.goal_level = PG_LEVEL_4K,
>   	};
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index a340caeb9c62..72f21f5f78af 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -460,9 +460,6 @@ int tdx_vm_init(struct kvm *kvm)
>   	 */
>   	kvm_mmu_set_mmio_spte_mask(kvm, 0, VMX_EPT_RWX_MASK);
>   
> -	/* TODO: Enable 2mb and 1gb large page support. */
> -	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
> -
>   	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
>   	kvm->max_vcpus = 0;
>   

