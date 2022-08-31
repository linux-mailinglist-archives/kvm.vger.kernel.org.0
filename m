Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1809B5A73B2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 04:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiHaCAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 22:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHaCAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 22:00:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45CF2C107
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 19:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661911232; x=1693447232;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XhaVOaApViG4U0OOBi8j4fO36jFAMwO1PvA0qNcPjbw=;
  b=CuWmtWfzh3UBPg6qcDxY4muOxQqgwX9TCZBO0HA62yHIDp5HIxr6FG2g
   tN4FwMZlc+oVN57TuUlBLVl1pQ8J0+Wiq3RR58q76WgOGtDwMjXqTX+7Z
   Kv0yXPeFanetFweVF7KsLilLf0ZrtL0l3lbamQJOrxN5aPfKv6FeYsKFr
   UPWOZ0ACQOrYwQ5q16cKXKJ44eZ/Qp8gJypOI6BoZz/6widm+P4nuLcah
   48mMnW+EQPiDf1DlM5hADfn1kEU2xUvjfhIGIahyPHWlhoupV3hXBPXLV
   RJoepK+fUEcUqmB5Dljp+Z/J40WkmNFd9UvkHXAoqg6/vrx60MTSJENc3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="357067451"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="357067451"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 19:00:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="673151342"
Received: from jwan100-mobl2.ccr.corp.intel.com (HELO [10.249.192.207]) ([10.249.192.207])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 19:00:26 -0700
Message-ID: <47f23202-65e6-bd0b-f9a0-0d288df5e9fc@intel.com>
Date:   Wed, 31 Aug 2022 10:00:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH v2] KVM: x86: Mask off unsupported and unknown bits of
 IA32_ARCH_CAPABILITIES
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vipin Sharma <vipinsh@google.com>
References: <20220830174947.2182144-1-jmattson@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220830174947.2182144-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/31/2022 1:49 AM, Jim Mattson wrote:
> KVM should not claim to virtualize unknown IA32_ARCH_CAPABILITIES
> bits. When kvm_get_arch_capabilities() was originally written, there
> were only a few bits defined in this MSR, and KVM could virtualize all
> of them. However, over the years, several bits have been defined that
> KVM cannot just blindly pass through to the guest without additional
> work (such as virtualizing an MSR promised by the
> IA32_ARCH_CAPABILITES feature bit).
> 
> Define a mask of supported IA32_ARCH_CAPABILITIES bits, and mask off
> any other bits that are set in the hardware MSR.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: 5b76a3cff011 ("KVM: VMX: Tell the nested hypervisor to skip L1D flush on vmentry")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Vipin Sharma <vipinsh@google.com>
> ---
> 
>   v1 -> v2: Clarified comment about unsupported bits.
> 
>   arch/x86/kvm/x86.c | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 205ebdc2b11b..9a18acfcfdc8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1557,12 +1557,32 @@ static const u32 msr_based_features_all[] = {
>   static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
>   static unsigned int num_msr_based_features;
>   
> +/*
> + * Some IA32_ARCH_CAPABILITIES bits have dependencies on MSRs that KVM
> + * does not yet virtualize. These include:
> + *   10 - MISC_PACKAGE_CTRLS
> + *   11 - ENERGY_FILTERING_CTL
> + *   12 - DOITM
> + *   18 - FB_CLEAR_CTRL
> + *   21 - XAPIC_DISABLE_STATUS
> + *   23 - OVERCLOCKING_STATUS
> + */
> +
> +#define KVM_SUPPORTED_ARCH_CAP \
> +	(ARCH_CAP_RDCL_NO | ARCH_CAP_IBRS_ALL | ARCH_CAP_RSBA | \
> +	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
> +	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
> +	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
> +	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
> +
>   static u64 kvm_get_arch_capabilities(void)
>   {
>   	u64 data = 0;
>   
> -	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
> +	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
>   		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
> +		data &= KVM_SUPPORTED_ARCH_CAP;
> +	}
>   
>   	/*
>   	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
> @@ -1610,9 +1630,6 @@ static u64 kvm_get_arch_capabilities(void)
>   		 */
>   	}
>   
> -	/* Guests don't need to know "Fill buffer clear control" exists */
> -	data &= ~ARCH_CAP_FB_CLEAR_CTRL;
> -
>   	return data;
>   }
>   

