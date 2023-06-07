Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A727251CE
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 03:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbjFGBxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 21:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240599AbjFGBwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 21:52:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E17F1BC3;
        Tue,  6 Jun 2023 18:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686102751; x=1717638751;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UATaUG+RZ6pR+rRUjz9jje361LO/5ghP4b8B+Afd3mQ=;
  b=n2CQFAWqXtPTVkr0bajv3AX+sVhrpGZzm493fYyn1xojXy+yoEijy8ka
   A+oWhufNtlPJwvJKfdQn28OxNshcRyx20ubzbRd4/OFj4JoFjW5VrfMW8
   lqXgOORYyQDqkrlSsWZtGu0Dc/4dnc/BBBSN0zCZNyiTA/+h/lHdDt9lE
   CPMncRbx7Mf4DoYYSdjwAm+ThZ6KSJXMj5h5NrFuOFPt5TKtxdOVL1ZC1
   QZtPPU5HD2SGsYGK20865APQcAiqdUI2sp0ql7JxlwSjzILJBiYeYtS6x
   TG4wQLIwB+9kjpj+sv2jdXw12vmNe3eImqdsYndiMYWMc5e6P3CnvMP4x
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="341502856"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="341502856"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 18:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="659752280"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="659752280"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.17]) ([10.238.9.17])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 18:52:29 -0700
Message-ID: <fd000efe-315f-a2c7-b42b-7ebbce922928@linux.intel.com>
Date:   Wed, 7 Jun 2023 09:52:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] KVM: x86: Update comments about MSR lists exposed to
 userspace
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230607004636.1421424-1-seanjc@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230607004636.1421424-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2023 8:46 AM, Sean Christopherson wrote:
> Refresh comments about msrs_to_save, emulated_msrs, and msr_based_features
> to remove stale references left behind by commit 2374b7310b66 (KVM:
> x86/pmu: Use separate array for defining "PMU MSRs to save"), and to
> better reflect the current reality, e.g. emulated_msrs is no longer just
> for MSRs that are "kvm-specific".
>
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 27 +++++++++++++--------------
>   1 file changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5ad55ef71433..c77f72cf6dc8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1427,15 +1427,14 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
>   EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
>   
>   /*
> - * List of msr numbers which we expose to userspace through KVM_GET_MSRS
> - * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
> - *
> - * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
> - * extract the supported MSRs from the related const lists.
> - * msrs_to_save is selected from the msrs_to_save_all to reflect the
> - * capabilities of the host cpu. This capabilities test skips MSRs that are
> - * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
> - * may depend on host virtualization features rather than host cpu features.
> + * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features) track
> + * the set of MSRs that KVM exposes to userspace through KVM_GET_MSRS,
> + * KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.  msrs_to_save holds MSRs that
> + * require host support, i.e. should be probed via RDMSR.  emulated_msrs holds
> + * MSRs that emulates without strictly requiring host support.
emulates -> emulate/emulated?

BTW, do you think is it better to use msrs_emulated instead of 
emulated_msrs to align the naming style?

> + * msr_based_features holds MSRs that enumerate features, i.e. are effectively
> + * CPUID leafs.  Note, msr_based_features isn't mutually exclusive with
> + * msrs_to_save and emulated_msrs.
>    */
>   
>   static const u32 msrs_to_save_base[] = {
> @@ -1531,11 +1530,11 @@ static const u32 emulated_msrs_all[] = {
>   	MSR_IA32_UCODE_REV,
>   
>   	/*
> -	 * The following list leaves out MSRs whose values are determined
> -	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
> -	 * We always support the "true" VMX control MSRs, even if the host
> -	 * processor does not, so I am putting these registers here rather
> -	 * than in msrs_to_save_all.
> +	 * KVM always supports the "true" VMX control MSRs, even if the host
> +	 * does not.  The VMX MSRs as a whole are considered "emulated" as KVM
> +	 * doesn't strictly require them to exist in the host (ignoring that
> +	 * KVM would refuse to load in the first place if the core set of MSRs
> +	 * aren't supported).
>   	 */
>   	MSR_IA32_VMX_BASIC,
>   	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
>
> base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7

