Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62087618DDB
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiKDCCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 22:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDCCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 22:02:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF29F14D37;
        Thu,  3 Nov 2022 19:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667527325; x=1699063325;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PbDcGd2txZZjxfqbiNRIeanByco2lscQZW9KH00uNFo=;
  b=jSs6cPavenLFemU1mIScN/aVfzriqn6NY3fBy3A6DMsK4EhLwj1QHlqz
   +CpYmAAPRdTNlmoyCzy5k8W8ELbihrwJLlfhAiHiWcqVImwL1d1QWWyoN
   LnmmKJqERlfkctWgSBTpq/e0URHO2VWWlrBmjopF7iTiqB9KWyln1M88R
   4tLR5bhct642LzETdJo4u4kaADvBoX6lTUOOBC573+XCAbeMuMGfYuObF
   Nyla1FO0Vh5ZpvmDF8oFK0nuVAqWSrZfWf1CmA8RgzRMZZDzrT0marYnG
   SHNSv2yQLo2/4QVVEDQmjl57AnMkTfdA5zd1Mf38+PmK4lCsQNB8whn2S
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="293178852"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="293178852"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 19:02:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="698466214"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="698466214"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 19:01:57 -0700
Message-ID: <9197a0a4-4c15-1e6e-a44b-a8036c2104c4@linux.intel.com>
Date:   Fri, 4 Nov 2022 10:01:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 1/8] x86: KVM: Move existing x86 CPUID leaf
 [CPUID_7_1_EAX] to kvm-only leaf
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
 <20221103025030.78371-2-jiaxi.chen@linux.intel.com>
 <Y2N/peaVRIjTMyrw@zn.tnic>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y2N/peaVRIjTMyrw@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/2022 4:45 PM, Borislav Petkov wrote:
> On Thu, Nov 03, 2022 at 10:50:23AM +0800, Jiaxi Chen wrote:
>> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
>> index 1a85e1fb0922..fbb4e7bd2288 100644
>> --- a/arch/x86/include/asm/cpufeature.h
>> +++ b/arch/x86/include/asm/cpufeature.h
>> @@ -24,7 +24,7 @@ enum cpuid_leafs
>>  	CPUID_7_0_EBX,
>>  	CPUID_D_1_EAX,
>>  	CPUID_LNX_4,
>> -	CPUID_7_1_EAX,
>> +	CPUID_DUMMY,
>>  	CPUID_8000_0008_EBX,
>>  	CPUID_6_EAX,
>>  	CPUID_8000_000A_EDX,
> 
> No, do this (diff ontop):
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index fbb4e7bd2288..b2905ddd7ab4 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -24,7 +24,7 @@ enum cpuid_leafs
>  	CPUID_7_0_EBX,
>  	CPUID_D_1_EAX,
>  	CPUID_LNX_4,
> -	CPUID_DUMMY,
> +	CPUID_LNX_5,
>  	CPUID_8000_0008_EBX,
>  	CPUID_6_EAX,
>  	CPUID_8000_000A_EDX,
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 91acf8b8e493..5c9023438e57 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -306,6 +306,8 @@
>  #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
>  #define X86_FEATURE_CALL_DEPTH		(11*32+18) /* "" Call depth tracking for RSB stuffing */
>  
> +/* Linux-defined mapping, word 12 */
> +
>  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
>  #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
>  #define X86_FEATURE_IRPERF		(13*32+ 1) /* Instructions Retired Count */
> 
> ---
> 
> I'm pretty sure we'll need new bits soon so let's reuse that one for
> Linux-defined flags.
> 
> Then you can drop patch 2.
> 

Hi Boris,

Yes, that's reasonable. I understand the goodnees of putting CPUID_LNX_5
here is to avoid changing the array length [NCAPINTS] and other parts twice.
But before new bits come, word 12 is empty in this gap. Is that ok?

-- 
Regards,
Jiaxi
