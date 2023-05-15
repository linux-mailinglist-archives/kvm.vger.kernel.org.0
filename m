Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241327025CE
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 09:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240608AbjEOHOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 03:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbjEOHOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 03:14:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4B61700;
        Mon, 15 May 2023 00:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684134848; x=1715670848;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DI+tAcTnunitgsjyQibCmZSKQ0r7RSYMm5iZ5mQOvfY=;
  b=R0r1SV67PGAGXr8wO5HzMRCPVhAp8cR1uMH5FxZ02v7SjZx6Aw3lqRSg
   EFnECJVyRgenjaxfN246pR9nzVSlxVfNWFX0ZFRBlrnlgPpBk8anMQKsq
   qri4z02CKdtdQ4wh/Z2NDC0p+AiPwU9s1mCxU7uHJi9etveBSR2HGHbsk
   D3Pbd/cW5m2H/AJCDYSFllmCNymc5ms3NYzOCNcX6K0almKA3RX9/dVKr
   p7OH8ckamQ1bMx91WPz5myMIm3zzsGN6B6UDyQSDUxh7RZaDMhX9eb9jr
   8MYow+kfrKM/PxlZZDwmUkJdbL76dChxTcqxHxFEYGYnX/4t8tu0TCt5G
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="437466488"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="437466488"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 00:14:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="765824978"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="765824978"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.214.85]) ([10.254.214.85])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 00:14:04 -0700
Message-ID: <4ed835e8-cea6-1253-4786-f4b4e7045389@intel.com>
Date:   Mon, 15 May 2023 15:14:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [RFC PATCH v2 03/11] KVM: x86: Advertise BHI_CTRL support
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-4-chao.gao@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230414062545.270178-4-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/2023 2:25 PM, Chao Gao wrote:
> From: Zhang Chen <chen.zhang@intel.com>
> 
> Add 100% kvm-only feature for BHI_CTRL because the kernel doesn't use it
> at all.
> 
> BHI_CTRL is enumerated by CPUID.7.2.EDX[4]. If supported, BHI_DIS_S (bit
> 10) of IA32_SPEC_CTRL MSR can be used to enable BHI_DIS_S behavior.
> 
> Note that KVM does not intercept guests' IA32_SPEC_CTRL MSR accesses
> after a non-zero is written to the MSR. Therefore, guests can already
> toggle the BHI_DIS_S bit if the host supports BHI_CTRL, and no extra
> code is needed to allow guests to toggle the bit.

Same as Patch 2, please first fix virtualization of MSR_IA32_SPEC_CTRL. 
Otherwise the this patch makes no sense. E.g, if only 
X86_FEATURE_BHI_CTRL is exposed to guest without any other CPUID bits 
related to MSR_IA32_SPEC_CTRL, then guest cannot write 
MSR_IA32_SPEC_CTRL at all.

> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
>   arch/x86/kvm/cpuid.c         | 2 +-
>   arch/x86/kvm/reverse_cpuid.h | 1 +
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f024c3ac2203..7cdd859d09a2 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -686,7 +686,7 @@ void kvm_set_cpu_caps(void)
>   	);
>   
>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
> -		SF(RRSBA_CTRL)
> +		SF(RRSBA_CTRL) | F(BHI_CTRL)
>   	);
>   
>   	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index 72bad8314a9c..e7e70c9aa384 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -50,6 +50,7 @@ enum kvm_only_cpuid_leafs {
>   
>   /* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
>   #define KVM_X86_FEATURE_RRSBA_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 2)
> +#define X86_FEATURE_BHI_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
>   
>   struct cpuid_reg {
>   	u32 function;

