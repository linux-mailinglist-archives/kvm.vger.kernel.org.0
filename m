Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79787CE9BD
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 23:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjJRVIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 17:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjJRVIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 17:08:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A92186
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 14:08:13 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9e0b9b96cso52616605ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 14:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697663293; x=1698268093; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PVTN0DwGw7en9yc7Uz7tI+IpU6nI5xXmVaMMJdRBSvM=;
        b=1bl+0KebzxdBeUoGPQ9rb0ky0fzroznmmfg0SS05gFbG/GXvgJ9W/Ic8P4pDQ1oLkO
         lXvBy+9RtvC9DyGT2p1h3vQnGbpdQaeESexH/fo4V3amnpa+R8/2rqUToNVEvRJDzOA1
         ELX+XLmLZiuVI3Gkn3NqIZQ/kWU1xPMY6CXux8fa2S999IWX/g3w+pCNmYX2y/otcwvS
         kbjMKQjDHgnpgxBrXYO1JXUiarqIeBCG/Ucisqco7xvgLQFogq3uJPEHAyrL73lvsqtV
         FeNHGTtjCa2zB44kCDdkh5494G+yW+425BTGcHFwt76/TfPlS8Bq7Apz0vzaDWGcizOU
         MQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697663293; x=1698268093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PVTN0DwGw7en9yc7Uz7tI+IpU6nI5xXmVaMMJdRBSvM=;
        b=Xf1W53XLAGPleAv4IqA1Qxf25LHSxlToirFF6uzWa0BxX4BA/qIWjc/9dzRDHQRBEo
         KVEUAZ2pd6+2p2keBGx0IyaZxQ672UoH7uS4iLB8Wjyt79mAhZf26WEAMb20v+tYkD0P
         IRxp2LzyJG4jBShlmdpqdb74D8KqM6D82p89NTrv5/Wvii/pY4BP2nKhAaX2gsSKjZhR
         KTD2LAYlarozNnXDKSrRJ3gE0H11RYHzV9DUYr6u+1L9yctTiDrglwhFBaWbZlBND6IN
         3db+A4zihBdH9PvQzZw7Nww/IAFW4bLslvnCuCQoLXv9kTAadRf5JCI0zByP/oG7rtvT
         eHvg==
X-Gm-Message-State: AOJu0YxpfhG03YemcuApi8oKhtC89Athxw10dggEi2c4vz1Z6IqZAkXM
        tPHIkgo1Eh7giuC7KXygbLMwhT5eqAs=
X-Google-Smtp-Source: AGHT+IGVBxOHZgerTVqsgICs+VuoL4YLyg1CdLr8SOLE1IDW1QAetoYCO7P1ttzgWgM3OSuZ2Sql8nHWrvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:654d:b0:1ca:8868:8c97 with SMTP id
 d13-20020a170902654d00b001ca88688c97mr12081pln.0.1697663293202; Wed, 18 Oct
 2023 14:08:13 -0700 (PDT)
Date:   Wed, 18 Oct 2023 14:08:11 -0700
In-Reply-To: <20230927230811.2997443-1-xin@zytor.com>
Mime-Version: 1.0
References: <20230927230811.2997443-1-xin@zytor.com>
Message-ID: <ZTBJO75Zu1JBsqvw@google.com>
Subject: Re: [PATCH 1/1] KVM: VMX: Cleanup VMX basic information defines and usages
From:   Sean Christopherson <seanjc@google.com>
To:     "Xin Li (Intel)" <xin@zytor.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Add IA32_VMX_BASIC MSR bitfield shift macros and use them to define VMX
> basic information bitfields.

Why?  Unless something actually uses the shift independently, just define the
BIT_ULL(...) straightaway.

> Add VMX_BASIC_FEATURES and VMX_BASIC_RESERVED_BITS to form a valid bitmask
> of IA32_VMX_BASIC MSR. As a result, to add a new VMX basic feature bit,
> just change the 2 new macros in the header file.

Not if a new feature bit lands in the middle of one of the reserved ranges, then
the developer will have to update at least three macros, and add a new one. More
below.

> Also replace hardcoded VMX basic numbers with the new VMX basic macros.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h       | 31 ++++++++++++++++++++------
>  arch/x86/kvm/vmx/nested.c              | 10 +++------
>  arch/x86/kvm/vmx/vmx.c                 |  2 +-
>  tools/arch/x86/include/asm/msr-index.h | 31 ++++++++++++++++++++------

Please drop the tools/ update, copying kernel headers into tools is a perf tools
thing that I want no part of.

https://lore.kernel.org/all/Y8bZ%2FJ98V5i3wG%2Fv@google.com

>  4 files changed, 52 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 1d111350197f..4607448ff805 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1084,13 +1084,30 @@
>  #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
>  
>  /* VMX_BASIC bits and bitmasks */
> -#define VMX_BASIC_VMCS_SIZE_SHIFT	32
> -#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
> -#define VMX_BASIC_64		0x0001000000000000LLU
> -#define VMX_BASIC_MEM_TYPE_SHIFT	50
> -#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
> -#define VMX_BASIC_MEM_TYPE_WB	6LLU
> -#define VMX_BASIC_INOUT		0x0040000000000000LLU
> +#define VMX_BASIC_VMCS_SIZE_SHIFT		32
> +#define VMX_BASIC_ALWAYS_0			BIT_ULL(31)
> +#define VMX_BASIC_RESERVED_RANGE_1		GENMASK_ULL(47, 45)
> +#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT	48
> +#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT)
> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT	49
> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT)
> +#define VMX_BASIC_MEM_TYPE_SHIFT		50
> +#define VMX_BASIC_MEM_TYPE_WB			6LLU
> +#define VMX_BASIC_INOUT_SHIFT			54
> +#define VMX_BASIC_INOUT				BIT_ULL(VMX_BASIC_INOUT_SHIFT)
> +#define VMX_BASIC_TRUE_CTLS_SHIFT		55
> +#define VMX_BASIC_TRUE_CTLS			BIT_ULL(VMX_BASIC_TRUE_CTLS_SHIFT)
> +#define VMX_BASIC_RESERVED_RANGE_2		GENMASK_ULL(63, 56)
> +
> +#define VMX_BASIC_FEATURES			\

Maybe VMX_BASIC_FEATURES_MASK to make it more obvious it's a mask of multiple
bits?

> +	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
> +	 VMX_BASIC_INOUT |			\
> +	 VMX_BASIC_TRUE_CTLS)
> +
> +#define VMX_BASIC_RESERVED_BITS			\
> +	(VMX_BASIC_ALWAYS_0 |			\
> +	 VMX_BASIC_RESERVED_RANGE_1 |		\
> +	 VMX_BASIC_RESERVED_RANGE_2)

I don't see any value in defining VMX_BASIC_RESERVED_RANGE_1 and
VMX_BASIC_RESERVED_RANGE_2 separately.   Or VMX_BASIC_ALWAYS_0 for the matter.
And I don't think these macros need to go in msr-index.h, e.g. just define them
above vmx_restore_vmx_basic() as that's likely going to be the only user, ever.

And what's really missing is a static_assert() or BUILD_BUG_ON() to ensure that
VMX_BASIC_FEATURES doesn't overlap with VMX_BASIC_RESERVED_BITS.

>  /* Resctrl MSRs: */
>  /* - Intel: */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c5ec0ef51ff7..5280ba944c87 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1203,21 +1203,17 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>  
>  static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>  {
> -	const u64 feature_and_reserved =
> -		/* feature (except bit 48; see below) */
> -		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
> -		/* reserved */
> -		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
>  	u64 vmx_basic = vmcs_config.nested.basic;
>  
> -	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
> +	if (!is_bitwise_subset(vmx_basic, data,
> +			       VMX_BASIC_FEATURES | VMX_BASIC_RESERVED_BITS))
>  		return -EINVAL;
>  
>  	/*
>  	 * KVM does not emulate a version of VMX that constrains physical
>  	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
>  	 */
> -	if (data & BIT_ULL(48))
> +	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
>  		return -EINVAL;
>  
>  	if (vmx_basic_vmcs_revision_id(vmx_basic) !=
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 72e3943f3693..f597243d6a72 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2701,7 +2701,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  
>  #ifdef CONFIG_X86_64
>  	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
> -	if (vmx_msr_high & (1u<<16))
> +	if (vmx_msr_high & (1u << (VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT - 32)))

In all honestly, I find the existing code easier to read.  I'm definitely not
saying the existing code is good, but IMO this is at best a wash.

I would much rather we do something like this and move away from the hi/lo crud
entirely:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 86ce9efe6c66..f103980c3d02 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2693,28 +2693,28 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
                _vmexit_control &= ~x_ctrl;
        }
 
-       rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
+       rdmsrl(MSR_IA32_VMX_BASIC, vmx_msr);
 
        /* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
-       if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
+       if ((VMX_BASIC_VMCS_SIZE(vmx_msr) > PAGE_SIZE)
                return -EIO;
 
 #ifdef CONFIG_X86_64
        /* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
-       if (vmx_msr_high & (1u<<16))
+       if (vmx_msr & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
                return -EIO;
 #endif
 
        /* Require Write-Back (WB) memory type for VMCS accesses. */
-       if (((vmx_msr_high >> 18) & 15) != 6)
+       if (VMX_BASIC_VMCS_MEMTYPE(vmx_msr) != VMX_BASIC_MEM_TYPE_WB)
                return -EIO;
 
        rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
 
-       vmcs_conf->size = vmx_msr_high & 0x1fff;
-       vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
+       vmcs_conf->size = VMX_BASIC_VMCS_SIZE(vmx_msr);
+       vmcs_conf->basic_cap = ????(vmx_msr);
 
-       vmcs_conf->revision_id = vmx_msr_low;
+       vmcs_conf->revision_id = (u32)vmx_msr;
 
        vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
        vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;

