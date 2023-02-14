Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D9E69593D
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjBNGfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjBNGfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:35:53 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF39346A2;
        Mon, 13 Feb 2023 22:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676356551; x=1707892551;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O16AlU7iGIz74WV/VsYyNXRMzpMeistT/ioSw9FAZYc=;
  b=YAAX6D1/etqf/AMSgK1wd4Oq2gzvbwiX0g/ieRXFO+uIi5osAgo2TDIe
   6hYmwCuSCh7k046YmSKkYnUNXlfh4a5xD1DWzCB2mq55krMl52QoiEeZo
   m3JsBYnjVxmtGsUTaHlf0GMfw6wn0LwlT/ojAU5x32usgF1dJyMaf+/Gw
   pHM7O5uxmwbp5Z6ldx8scYlMXb1Fx1uRsz5n0kL2vBuwy/gDmJHf8oY5F
   n6C/2PdH1CkmAF2AThso1aDmueBflS4SsytCADweyGcIfzxUV6c8qCO3i
   Odb48c4glDvo4bks1K0Wv9opeDD0Yc0XCozZD9LlqyT9E5fRzfl5G1A3/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314735131"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314735131"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:35:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701554500"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701554500"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.2]) ([10.255.31.2])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:35:49 -0800
Message-ID: <08e86395-d67a-b24e-5256-d7f78f06873d@intel.com>
Date:   Tue, 14 Feb 2023 14:35:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.2
Subject: Re: [PATCH v2 02/21] KVM: x86: Add a helper to query whether or not a
 vCPU has ever run
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-3-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230210003148.2646712-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/2023 8:31 AM, Sean Christopherson wrote:
> Add a helper to query if a vCPU has run so that KVM doesn't have to open
> code the check on last_vmentry_cpu being set to a magic value.
> 
> No functional change intended.
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/cpuid.c   | 2 +-
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   arch/x86/kvm/x86.h     | 5 +++++
>   3 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8f8edeaf8177..448d627ce891 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -420,7 +420,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>   	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
>   	 * whether the supplied CPUID data is equal to what's already set.
>   	 */
> -	if (vcpu->arch.last_vmentry_cpu != -1) {
> +	if (kvm_vcpu_has_run(vcpu)) {
>   		r = kvm_cpuid_check_equal(vcpu, e2, nent);
>   		if (r)
>   			return r;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c91ee2927dd7..b0693195273b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5393,7 +5393,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
>   	 * kvm_arch_vcpu_ioctl().
>   	 */
> -	KVM_BUG_ON(vcpu->arch.last_vmentry_cpu != -1, vcpu->kvm);
> +	KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm);
>   }
>   
>   void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index a8167b47b8c8..754190af1791 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -83,6 +83,11 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
>   void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
>   int kvm_check_nested_events(struct kvm_vcpu *vcpu);
>   
> +static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.last_vmentry_cpu != -1;
> +}
> +
>   static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
>   {
>   	return vcpu->arch.exception.pending ||

