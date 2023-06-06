Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C67B7236DC
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 07:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjFFFdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 01:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjFFFdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 01:33:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755D61B1
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 22:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686029587; x=1717565587;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P7jq6W6rE0HhPBxZk38H6GutRLHHQnTUdLpClUKuPUc=;
  b=DWZkdBE34rT9lRHIfn+dGOumYj/B4U3l/FKFSY2DZ++oYRC6H7hbNFAC
   jtIEHf3B6D2+n1yPClrKXfhG7UXqIGoZQ9VpjbHn/vdiBgzKYI30x2nLi
   AM2Q16mVZD14NJrWomD32buZfssMTrhpMiHHAMH4t7apXHmtLYKaCHYBV
   SaG5U/oxSrTDwovpgaw820BAEhhkkN1NLYBkq8GXlLfQm3zd7N5e45JKc
   EeCI1KJjf3rwFtNSvnMdehiKzIyoaAIWdfz1QpSUjqVovLUYkfFZXTScG
   R2TssYwg/uvIztyGThQ45+jOct7cEFXkpS33ZRJYZtdXRtUGIUiTt95Mw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336191978"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336191978"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 22:33:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="1039042738"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="1039042738"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.170.159]) ([10.249.170.159])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 22:33:06 -0700
Message-ID: <9be70225-a1ab-d276-a5ba-37070e3c061e@linux.intel.com>
Date:   Tue, 6 Jun 2023 13:33:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 2/3] KVM: x86: Fix comments that refer to the out-dated
 msrs_to_save_all
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20230518091339.1102-1-binbin.wu@linux.intel.com>
 <20230518091339.1102-3-binbin.wu@linux.intel.com>
 <ZH4++07thYZk/AX9@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZH4++07thYZk/AX9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/6/2023 4:00 AM, Sean Christopherson wrote:
> On Thu, May 18, 2023, Binbin Wu wrote:
>> msrs_to_save_all is out-dated after commit 2374b7310b66
>> (KVM: x86/pmu: Use separate array for defining "PMU MSRs to save").
>>
>> Update the comments to msrs_to_save_base.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ceb7c5e9cf9e..ca7cff5252ae 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1432,7 +1432,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
>>    *
>>    * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
>>    * extract the supported MSRs from the related const lists.
>> - * msrs_to_save is selected from the msrs_to_save_all to reflect the
>> + * msrs_to_save is selected from the msrs_to_save_base to reflect the
> A straight conversion isn't correct, msrs_to_save isn't selected from *just*
> msrs_to_save_base.
>
>>    * capabilities of the host cpu. This capabilities test skips MSRs that are
>>    * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
> This "kvm-specific" blurb is also stale.
>
>>    * may depend on host virtualization features rather than host cpu features.
>> @@ -1535,7 +1535,7 @@ static const u32 emulated_msrs_all[] = {
>>   	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
>>   	 * We always support the "true" VMX control MSRs, even if the host
>>   	 * processor does not, so I am putting these registers here rather
>> -	 * than in msrs_to_save_all.
>> +	 * than in msrs_to_save_base.
> And this entire comment is rather weird, e.g. I have no idea what MSRs the part
> about CPUID and other MSRs is referring to.
>
> Rather than do a blind replacement, how about this?
LGTM. Thanks.

>
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 5 Jun 2023 12:56:46 -0700
> Subject: [PATCH] KVM: x86: Update comments about MSR lists exposed to
>   userspace
>
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

