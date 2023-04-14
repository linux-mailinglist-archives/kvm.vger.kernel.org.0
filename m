Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39FE6E1FDC
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 11:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjDNJxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 05:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDNJxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 05:53:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB72E76B3;
        Fri, 14 Apr 2023 02:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681465984; x=1713001984;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2KwZCZcXOI/xtW1l98W2Ml6Mg6foLLzbpxH4qV9bwTE=;
  b=R8wl6/Dh/cYcPv7ZUFvrolIeoO1AQ9mBGIyt+vB1bQRxJJSknX+/aHvq
   /Swmm5YI7of453r3FpbMg9OdI9JpqacQoDIjLl4EAfxsEzGU42jZDoXZ/
   h6q4CpzzBfFGo/TrS6Wf21GE/3NqZPEOyNt8R5Ap9uECYmMVlaxRQ5/dA
   ZSmrQteAO9+baC7BkESbs/EUwFKr1Q8AGrLbAxXwWvbCotcLQxmIc0wK1
   O8p02SwJKNgLqf5VjSn3eBVxk4f/6WSqKybv8qkD/BHNIs65iAi5Yrhgr
   uA/agqmRw5Wc/dlBvtlp69myr3r53G3GE6oscONhBNjXcvB7+sa4TZhOL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="372291690"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="372291690"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 02:53:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="864159555"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="864159555"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.173.37]) ([10.249.173.37])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 02:53:00 -0700
Message-ID: <6337e250-f121-2a3f-65de-d01aff1be9f9@linux.intel.com>
Date:   Fri, 14 Apr 2023 17:52:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v2 01/11] x86/msr-index: Add bit definitions for
 BHI_DIS_S and BHI_NO
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-2-chao.gao@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230414062545.270178-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/2023 2:25 PM, Chao Gao wrote:
> From: Zhang Chen <chen.zhang@intel.com>
>
> To ensure VM migration from a system where software mitigation works to
> a system where it doesn't won't harm guest's security level, KVM must
> mitigate BHI attacks for guests since migration is transparent to guests
> and guests won't and can't react to VM migration.
>
> For example, simple BHB clear sequence [1] is effective in mitigating BHI
> attacks on processors prior to Alder Lake, but it is not on Alder Lake.
> Guests migrated from prior to Alder Lake host to Alder Lake host become
> vulnerable to BHI attacks even if the simmple BHB clear sequence is

/s/simmple/simple


> deployed. In this case, KVM can enable hardware mitigation for guests by
> setting BHI_DIS_S bit of IA32_SPEC_CTRL MSR.
>
> Define the SPEC_CTRL_BHI_DIS_S of IA32_SPEC_CTRL MSR and BHI_NO bits in
> arch_capabilities, which will be used by KVM later.
>
> [1]: https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html#inpage-nav-2-4
>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
>   arch/x86/include/asm/msr-index.h       | 8 +++++++-
>   tools/arch/x86/include/asm/msr-index.h | 8 +++++++-
>   2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index ad35355ee43e..60b25d87b82c 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -48,8 +48,10 @@
>   #define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
>   #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
>   #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
> -#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
> +#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior in supervisor mode */
>   #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
> +#define SPEC_CTRL_BHI_DIS_S_SHIFT	10	   /* Disable BHI behavior in supervisor mode */
> +#define SPEC_CTRL_BHI_DIS_S		BIT(SPEC_CTRL_BHI_DIS_S_SHIFT)
>   
>   /* A mask for bits which the kernel toggles when controlling mitigations */
>   #define SPEC_CTRL_MITIGATIONS_MASK	(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD \
> @@ -151,6 +153,10 @@
>   						 * are restricted to targets in
>   						 * kernel.
>   						 */
> +#define ARCH_CAP_BHI_NO			BIT(20)	/*
> +						 * Not susceptible to Branch History
> +						 * Injection.
> +						 */
>   #define ARCH_CAP_PBRSB_NO		BIT(24)	/*
>   						 * Not susceptible to Post-Barrier
>   						 * Return Stack Buffer Predictions.
> diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
> index ad35355ee43e..6079a5fdb40b 100644
> --- a/tools/arch/x86/include/asm/msr-index.h
> +++ b/tools/arch/x86/include/asm/msr-index.h
> @@ -48,8 +48,10 @@
>   #define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
>   #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
>   #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
> -#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
> +#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior in supervisor mode */
>   #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
> +#define SPEC_CTRL_BHI_DIS_S_SHIFT	10         /* Disable BHI behavior in supervisor mode */
> +#define SPEC_CTRL_BHI_DIS_S		BIT(SPEC_CTRL_BHI_DIS_S_SHIFT)
>   
>   /* A mask for bits which the kernel toggles when controlling mitigations */
>   #define SPEC_CTRL_MITIGATIONS_MASK	(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD \
> @@ -151,6 +153,10 @@
>   						 * are restricted to targets in
>   						 * kernel.
>   						 */
> +#define ARCH_CAP_BHI_NO			BIT(20) /*
> +						 * Not susceptible to Branch History
> +						 * Injection.
> +						 */
>   #define ARCH_CAP_PBRSB_NO		BIT(24)	/*
>   						 * Not susceptible to Post-Barrier
>   						 * Return Stack Buffer Predictions.
