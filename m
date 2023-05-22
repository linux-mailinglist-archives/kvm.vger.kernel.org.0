Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BD270B2A9
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 03:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjEVBCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 21:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjEVBCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 21:02:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092FDB9;
        Sun, 21 May 2023 18:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684717363; x=1716253363;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7f6iKPShfrkGjooLvduk/ZxPA+rLHn+04UdPcaTn4Ac=;
  b=aWiyYp6xnOVCN9Ses3pSpq4LjnBQJaWUxxSf0Z5IuA5m+FFfN10BK8W+
   BFgCa8uITrLEb69pcplEBQ9nFiB4geV/XGpB+FBGC63RvaigW/ZNtU0E9
   Z8qEOl66MqFHYr/drt4onY//nFq768CPtzi7i1iQNavfClo0TFcZtIc9t
   1aWAz0vq4BBQX7BMelEZaJ36nRFqsmP+IisvKIqT1Z361xTk782XKk78x
   KniUujawXwESp8ZrW9q2mwsJx/c22Ze482j+Y6n0bXY86i9d0i70l95Cf
   v4FfOpzvCCUyzAw5CCblqLxznfpLzZQB8L3gaEUv1Gv1h6+5Wcgftz2y0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="356021375"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="356021375"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2023 18:02:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="706335211"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="706335211"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.166]) ([10.255.29.166])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2023 18:02:02 -0700
Message-ID: <d6f9f2b0-3f44-5182-46d2-36677bbfa14b@intel.com>
Date:   Mon, 22 May 2023 09:02:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [RFC PATCH v2 06/11] KVM: x86: Advertise ARCH_CAP_VIRTUAL_ENUM
 support
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-7-chao.gao@intel.com>
 <3b0f3295-27d7-4c83-e1cf-8494548ecf14@intel.com>
 <ZGdIASx1lTamNaDd@chao-email>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZGdIASx1lTamNaDd@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/2023 5:57 PM, Chao Gao wrote:
> On Thu, May 18, 2023 at 06:14:40PM +0800, Xiaoyao Li wrote:
>>>    static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
>>> @@ -1591,7 +1593,8 @@ static unsigned int num_msr_based_features;
>>>    	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
>>>    	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
>>>    	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
>>> -	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
>>> +	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | \
>>> +	 ARCH_CAP_VIRTUAL_ENUM)
>>
>> We cannot do it.
>>
>> Otherwise, an AMD L1 with X86_FEATURE_ARCH_CAPABILITIES configured is
>> possible to expose MSR_VIRTUAL_ENUMERATION to L2 while no support for it.
> 
> How does AMD L1 see the ARCH_CAP_VIRTUAL_ENUM feature in the first
> place? because ...
> 
>>
>>>    static u64 kvm_get_arch_capabilities(void)
>>>    {
>>> @@ -1610,6 +1613,17 @@ static u64 kvm_get_arch_capabilities(void)
>>>    	 */
>>>    	data |= ARCH_CAP_PSCHANGE_MC_NO;
>>> +	/*
>>> +	 * Virtual enumeration is a paravirt feature. The only usage for now
>>> +	 * is to bridge the gap caused by microarchitecture changes between
>>> +	 * different Intel processors. And its usage is linked to "virtualize
>>> +	 * IA32_SPEC_CTRL" which is a VMX feature. Whether AMD SVM can benefit
>>> +	 * from the same usage and how to implement it is still unclear. Limit
>>> +	 * virtual enumeration to VMX.
>>> +	 */
>>> +	if (static_call(kvm_x86_has_emulated_msr)(NULL, MSR_VIRTUAL_ENUMERATION))
>>> +		data |= ARCH_CAP_VIRTUAL_ENUM;
> 
> the feature is exposed on Intel CPUs only.
> 
> Do you mean AMD L1 created on Intel L0? and Intel L0 even emulates
> nested (SVM) support for the L1? This sounds a very contrived case.

you are right. I was thinking of an rare case but ignored the fact that 
VMX doesn't nested svm.

Sorry for it.

>>> +
>>>    	/*
>>>    	 * If we're doing cache flushes (either "always" or "cond")
>>>    	 * we will do one whenever the guest does a vmlaunch/vmresume.
>>

