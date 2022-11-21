Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D876A63271E
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 15:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiKUO5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 09:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiKUO4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 09:56:21 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD43D14D7;
        Mon, 21 Nov 2022 06:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669042009; x=1700578009;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9W9R6jj2B8mlqU0oXc8ufbjgICy2DcEoaRvZ9VRKl7Q=;
  b=B57G2qcoTH359KQ7kFQUSu1jsqYx2pt8AmuGgY6mJnEvRgwd4UQNF04b
   28GBAGUkQ8ndJe4PD1t+CTa6xXloiwk63aVv0PBB7p1gGv8xZ4BjWe9m8
   l8JdRodMDxIc5HTPW649HWirIG3WarN0MlBMSDE+l2ricwBz5wrciaUna
   m31YrvLCeVRlEDUso6aSazvkEyixhuNy20SFSbKSLXO+eHbnOp6wr3jP9
   SoG2KAQcIHEnHZ4sqXYb814qI3d5cBDgoUuYdjD715o3gQKaZrl32xp3z
   4/yaI0kWyrMUEj1nmx09lvVaK3eDQRTWLmwM4vodqLFYwfZKEqQtQPyC7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="293961838"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="293961838"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 06:46:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="709829545"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="709829545"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.254.209.33]) ([10.254.209.33])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 06:46:36 -0800
Message-ID: <66ac6be5-9b2b-fb9e-3ccd-0a56ec2851c4@linux.intel.com>
Date:   Mon, 21 Nov 2022 22:46:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4 3/6] x86: KVM: Advertise AVX-IFMA CPUID to user space
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-4-jiaxi.chen@linux.intel.com>
 <Y3et+VpYh+L7N8SL@google.com>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y3et+VpYh+L7N8SL@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/2022 12:08 AM, Sean Christopherson wrote:
> On Fri, Nov 18, 2022, Jiaxi Chen wrote:
>> AVX-IFMA is a new instruction in the latest Intel platform Sierra
>> Forest. This instruction packed multiplies unsigned 52-bit integers and
>> adds the low/high 52-bit products to Qword Accumulators.
>>
>> The bit definition:
>> CPUID.(EAX=7,ECX=1):EAX[bit 23]
>>
>> This CPUID is exposed to user space. Besides, there is no other VMX
>> control for this instruction.
>>
>> Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  arch/x86/kvm/cpuid.c               | 4 ++--
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index df4a7f7505a9..159f8b9898bf 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -310,6 +310,7 @@
>>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
>>  #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
>>  #define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */
>> +#define X86_FEATURE_AVX_IFMA            (12*32+23) /* Support for VPMADD52[H,L]UQ */
>>  
>>  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
>>  #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 2a334d4cd04e..5726afb2d14c 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -657,8 +657,8 @@ void kvm_set_cpu_caps(void)
>>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>>  
>>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>> -		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
>> -	);
>> +		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
>> +		F(AVX_IFMA));
> 
> Please keep the terminating paranthesis+semicolon on a separate line.  KVM isn't
> 100% consistent (as usual), but I would rather "fix" the cases that don't put
> the terminators on their own line. 

That's very careful. Thank you~
-- 
Regards,
Jiaxi
