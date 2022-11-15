Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62CE629B34
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 14:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238039AbiKONwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 08:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238524AbiKONwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 08:52:17 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865202C11D;
        Tue, 15 Nov 2022 05:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668520269; x=1700056269;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rzDa1w87uPv5RkrD80lJDw/6LefV+W240M22vdBwoKg=;
  b=FhqlTjeexnr7vZn3yHRx28OHbKUn064xK8cM8ixKT8yLss8kUWtqT7RG
   8zt5PGhAO8B6jiccJrBCRsl9kwKPR2agoRGkTuL3M3YArCnvKUJF1Jvh9
   JZoVzQJiAUmfywfThKdgX36VwMxofMZW/QmXUp/nZAYIRV0tj4Q9IQEuD
   MqdF60s4adXIjdbUCbEIemeau5j4BOTUZp5xOGfu30ftgNUNjZnuYmEv4
   u6+XuzE8uF+6uwwC6D6mQLQxotBJZENrt7I94bZUOiaTvD6Lqmy7xZ6K4
   26Q0ZoBftUna72nuQh+eTyY13iJv/ZeP0Kp3anBzZrlG9bW0O30Tco+9r
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="299778621"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="299778621"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 05:51:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="638949362"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="638949362"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.172.114]) ([10.249.172.114])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 05:50:55 -0800
Message-ID: <f8607d23-afaa-2670-dd03-2ae8ec1e79a0@intel.com>
Date:   Tue, 15 Nov 2022 21:50:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v3 1/7] x86: KVM: Move existing x86 CPUID leaf
 [CPUID_7_1_EAX] to kvm-only leaf
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
 <20221110015252.202566-2-jiaxi.chen@linux.intel.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20221110015252.202566-2-jiaxi.chen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/2022 9:52 AM, Jiaxi Chen wrote:
> cpuid_leaf[12] CPUID_7_1_EAX has only two bits are in use currently:
> 
>   - AVX-VNNI CPUID.(EAX=7,ECX=1):EAX[bit 4]
>   - AVX512-BF16 CPUID.(EAX=7,ECX=1):EAX[bit 5]
> 
> These two bits have no other kernel usages other than the guest
> CPUID advertisement in KVM. Given that and to save space for kernel
> feature bits, move these two bits to the kvm-only subleaves. The
> existing leaf cpuid_leafs[12] is set to CPUID_LNX_5 so future feature
> can pick it. This basically reverts:
> 
>   - commit b85a0425d805 ("Enumerate AVX Vector Neural Network
> instructions")
>   - commit b302e4b176d0 ("x86/cpufeatures: Enumerate the new AVX512
> BFLOAT16 instructions")
>   - commit 1085a6b585d7 ("KVM: Expose AVX_VNNI instruction to guset")

FYI, LAM support has been queued in tip 
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=aa387b1b1e666cacffc0b7ac7e0949a68013b2d9

It adds

+#define X86_FEATURE_LAM			(12*32+26) /* Linear Address Masking */

and conflict with this patch.

Seen from the ISE, there are more bits defined in CPUID_7_1_EAX. And I 
believe Intel will define more and it's likely some of them will be used 
by kernel just like LAM.

> Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
> ---
>   arch/x86/include/asm/cpufeature.h  | 2 +-
>   arch/x86/include/asm/cpufeatures.h | 4 +---
>   arch/x86/kernel/cpu/common.c       | 6 ------
>   arch/x86/kernel/cpu/cpuid-deps.c   | 1 -
>   arch/x86/kvm/cpuid.c               | 2 +-
>   arch/x86/kvm/reverse_cpuid.h       | 5 +++++
>   6 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 1a85e1fb0922..b2905ddd7ab4 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -24,7 +24,7 @@ enum cpuid_leafs
>   	CPUID_7_0_EBX,
>   	CPUID_D_1_EAX,
>   	CPUID_LNX_4,
> -	CPUID_7_1_EAX,
> +	CPUID_LNX_5,
>   	CPUID_8000_0008_EBX,
>   	CPUID_6_EAX,
>   	CPUID_8000_000A_EDX,
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index b71f4f2ecdd5..ec468d6eaf06 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -305,9 +305,7 @@
>   #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
>   #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
>   
> -/* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
> -#define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
> -#define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> +/* Linux-defined mapping, word 12 */
>   
>   /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
>   #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 3e508f239098..0c19c84d7ba0 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1026,12 +1026,6 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
>   		c->x86_capability[CPUID_7_0_EBX] = ebx;
>   		c->x86_capability[CPUID_7_ECX] = ecx;
>   		c->x86_capability[CPUID_7_EDX] = edx;
> -
> -		/* Check valid sub-leaf index before accessing it */
> -		if (eax >= 1) {
> -			cpuid_count(0x00000007, 1, &eax, &ebx, &ecx, &edx);
> -			c->x86_capability[CPUID_7_1_EAX] = eax;
> -		}
>   	}
>   
>   	/* Extended state features: level 0x0000000d */
> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> index c881bcafba7d..a88e0e8c39fa 100644
> --- a/arch/x86/kernel/cpu/cpuid-deps.c
> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> @@ -68,7 +68,6 @@ static const struct cpuid_dep cpuid_deps[] = {
>   	{ X86_FEATURE_CQM_OCCUP_LLC,		X86_FEATURE_CQM_LLC   },
>   	{ X86_FEATURE_CQM_MBM_TOTAL,		X86_FEATURE_CQM_LLC   },
>   	{ X86_FEATURE_CQM_MBM_LOCAL,		X86_FEATURE_CQM_LLC   },
> -	{ X86_FEATURE_AVX512_BF16,		X86_FEATURE_AVX512VL  },
>   	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
>   	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
>   	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7065462378e2..89f5e7f0402b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -656,7 +656,7 @@ void kvm_set_cpu_caps(void)
>   	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>   		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>   
> -	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> +	kvm_cpu_cap_init_scattered(CPUID_7_1_EAX,
>   		F(AVX_VNNI) | F(AVX512_BF16)
>   	);
>   
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index a19d473d0184..674de5b24f8d 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -13,6 +13,7 @@
>    */
>   enum kvm_only_cpuid_leafs {
>   	CPUID_12_EAX	 = NCAPINTS,
> +	CPUID_7_1_EAX,
>   	NR_KVM_CPU_CAPS,
>   
>   	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> @@ -24,6 +25,10 @@ enum kvm_only_cpuid_leafs {
>   #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
>   #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
>   
> +/* Intel-defined sub-features, CPUID level 0x00000007:1 (EAX) */
> +#define X86_FEATURE_AVX_VNNI            KVM_X86_FEATURE(CPUID_7_1_EAX, 4)
> +#define X86_FEATURE_AVX512_BF16         KVM_X86_FEATURE(CPUID_7_1_EAX, 5)
> +
>   struct cpuid_reg {
>   	u32 function;
>   	u32 index;

