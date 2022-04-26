Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485C2510A42
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354913AbiDZUVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354904AbiDZUVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:21:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116521A4315;
        Tue, 26 Apr 2022 13:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651004325; x=1682540325;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZDF3hFy0BWL791La2UQ13qzXZCvp2fj56KNm9NYlwqg=;
  b=ZAGzK+dQAROhcgCc0Bgq51/+3UIs93n0dv9hH0zBrgC4yI9BlFNSWdNh
   SOwToozEC8wTMy+ZSKuzON9p5k0xHp0BIBOsfv9k1RWbnXWTNvLKVQy5j
   G7uoPHpNj1gtrXuqq3c7jwuBEkop+sw+XjplkiEt2jnNgikDqWKJl8tgB
   g/aYyTlXwstCtDbCDSil2LVx/OZar7V5/3FDgIAmP5AopZZjAHJvLYUUf
   klZA3/ptOxNhANNnC+A63v+pjy1/nHY9i1Eyb5p9vrfC8IHz1TrX4U0lP
   MibiV+RteojZ/aRlXh5IU69I+29jsItNl6Twq2PdPGElhb/sEilp1ofCx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="245633473"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="245633473"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:18:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="580136420"
Received: from dsocek-mobl2.amr.corp.intel.com (HELO [10.212.69.119]) ([10.212.69.119])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:18:43 -0700
Message-ID: <334c4b90-52c4-cffc-f3e2-4bd6a987eb69@intel.com>
Date:   Tue, 26 Apr 2022 13:21:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 01/21] x86/virt/tdx: Detect SEAM
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +config INTEL_TDX_HOST
> +	bool "Intel Trust Domain Extensions (TDX) host support"
> +	default n
> +	depends on CPU_SUP_INTEL
> +	depends on X86_64
> +	help
> +	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> +	  host and certain physical attacks.  This option enables necessary TDX
> +	  support in host kernel to run protected VMs.
> +
> +	  If unsure, say N.

Nothing about KVM?

...
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> new file mode 100644
> index 000000000000..03f35c75f439
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright(c) 2022 Intel Corporation.
> + *
> + * Intel Trusted Domain Extensions (TDX) support
> + */
> +
> +#define pr_fmt(fmt)	"tdx: " fmt
> +
> +#include <linux/types.h>
> +#include <linux/cpumask.h>
> +#include <asm/msr-index.h>
> +#include <asm/msr.h>
> +#include <asm/cpufeature.h>
> +#include <asm/cpufeatures.h>
> +#include <asm/tdx.h>
> +
> +/* Support Intel Secure Arbitration Mode Range Registers (SEAMRR) */
> +#define MTRR_CAP_SEAMRR			BIT(15)
> +
> +/* Core-scope Intel SEAMRR base and mask registers. */
> +#define MSR_IA32_SEAMRR_PHYS_BASE	0x00001400
> +#define MSR_IA32_SEAMRR_PHYS_MASK	0x00001401
> +
> +#define SEAMRR_PHYS_BASE_CONFIGURED	BIT_ULL(3)
> +#define SEAMRR_PHYS_MASK_ENABLED	BIT_ULL(11)
> +#define SEAMRR_PHYS_MASK_LOCKED		BIT_ULL(10)
> +
> +#define SEAMRR_ENABLED_BITS	\
> +	(SEAMRR_PHYS_MASK_ENABLED | SEAMRR_PHYS_MASK_LOCKED)
> +
> +/* BIOS must configure SEAMRR registers for all cores consistently */
> +static u64 seamrr_base, seamrr_mask;
> +
> +static bool __seamrr_enabled(void)
> +{
> +	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> +}

But there's no case where seamrr_mask is non-zero and where
_seamrr_enabled().  Why bother checking the SEAMRR_ENABLED_BITS?

> +static void detect_seam_bsp(struct cpuinfo_x86 *c)
> +{
> +	u64 mtrrcap, base, mask;
> +
> +	/* SEAMRR is reported via MTRRcap */
> +	if (!boot_cpu_has(X86_FEATURE_MTRR))
> +		return;
> +
> +	rdmsrl(MSR_MTRRcap, mtrrcap);
> +	if (!(mtrrcap & MTRR_CAP_SEAMRR))
> +		return;
> +
> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
> +	if (!(base & SEAMRR_PHYS_BASE_CONFIGURED)) {
> +		pr_info("SEAMRR base is not configured by BIOS\n");
> +		return;
> +	}
> +
> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
> +	if ((mask & SEAMRR_ENABLED_BITS) != SEAMRR_ENABLED_BITS) {
> +		pr_info("SEAMRR is not enabled by BIOS\n");
> +		return;
> +	}
> +
> +	seamrr_base = base;
> +	seamrr_mask = mask;
> +}

Comment, please.

	/*
	 * Stash the boot CPU's MSR values so that AP values
	 * can can be checked for consistency.
	 */


> +static void detect_seam_ap(struct cpuinfo_x86 *c)
> +{
> +	u64 base, mask;
> +
> +	/*
> +	 * Don't bother to detect this AP if SEAMRR is not
> +	 * enabled after earlier detections.
> +	 */
> +	if (!__seamrr_enabled())
> +		return;
> +
> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
> +

This is the place for a comment about why the values have to be equal.

> +	if (base == seamrr_base && mask == seamrr_mask)
> +		return;
> +
> +	pr_err("Inconsistent SEAMRR configuration by BIOS\n");
> +	/* Mark SEAMRR as disabled. */
> +	seamrr_base = 0;
> +	seamrr_mask = 0;
> +}
> +
> +static void detect_seam(struct cpuinfo_x86 *c)
> +{
> +	if (c == &boot_cpu_data)
> +		detect_seam_bsp(c);
> +	else
> +		detect_seam_ap(c);
> +}
> +
> +void tdx_detect_cpu(struct cpuinfo_x86 *c)
> +{
> +	detect_seam(c);
> +}

The extra function looks a bit silly here now.  Maybe this gets filled
out later, but it's goofy-looking here.
