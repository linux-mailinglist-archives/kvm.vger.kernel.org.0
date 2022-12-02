Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9176B640AD9
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 17:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbiLBQcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 11:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiLBQcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 11:32:03 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF44EE00;
        Fri,  2 Dec 2022 08:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669998722; x=1701534722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wSnpR7zDYAssFAg6Gf+Dcdqfe3muYD3GKdvIsPR3ziw=;
  b=HPXrbcv0/YCdlXFzS54MouKSP9GvmUbc0U6O/ldxKD3E777TeU4UoJxv
   v57C4l6799+wQ7jTi+Ss1L3EELU0YLwky/kSY3MEq0/2nUCAmCnNX317y
   d0PylQqPr65Osq/R1Y8m8eG/xRfxcTHELPQMhHCaHYLiAE/kFY0bARiFe
   xdwzSQopRqLV+iOoO3LVA9yIB/1dLRbSP/qhtc9bS41XcVy8HsF8Q3ihQ
   ztRcyb6nNdgxaPVIIE4yde/GYlV9LvGWoJs23suMBGFwfiq5kyQn3XV5Y
   M8O3k7R5cdNOoEChS57sZvOb78XQaCsvvp9aenqh1Jz+EcVzOFofXaYF6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="402268617"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="402268617"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 08:32:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="890201379"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="890201379"
Received: from nschade-mobl.amr.corp.intel.com (HELO desk) ([10.209.69.47])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 08:31:59 -0800
Date:   Fri, 2 Dec 2022 08:31:58 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] x86/cpu: Support AMD Automatic IBRS
Message-ID: <20221202163158.p7yuqimmnjbmlzvq@desk>
References: <20221201015003.295769-1-kim.phillips@amd.com>
 <20221201015003.295769-7-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221201015003.295769-7-kim.phillips@amd.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 07:50:02PM -0600, Kim Phillips wrote:
>--- a/Documentation/admin-guide/kernel-parameters.txt
>+++ b/Documentation/admin-guide/kernel-parameters.txt
>@@ -5698,9 +5698,12 @@
> 			retpoline,generic - Retpolines
> 			retpoline,lfence  - LFENCE; indirect branch
> 			retpoline,amd     - alias for retpoline,lfence
>-			eibrs		  - enhanced IBRS
>-			eibrs,retpoline   - enhanced IBRS + Retpolines
>-			eibrs,lfence      - enhanced IBRS + LFENCE
>+			eibrs		  - Enhanced/Auto IBRS
>+			autoibrs	  - Enhanced/Auto IBRS
>+			eibrs,retpoline   - Enhanced/Auto IBRS + Retpolines
>+			autoibrs,retpoline- Enhanced/Auto IBRS + Retpolines
>+			eibrs,lfence      - Enhanced/Auto IBRS + LFENCE
>+			autoibrs,lfence   - Enhanced/Auto IBRS + LFENCE
> 			ibrs		  - use IBRS to protect kernel

Documentation/admin-guide/hw-vuln/spectre.rst also needs an update.

>--- a/arch/x86/kernel/cpu/common.c
>+++ b/arch/x86/kernel/cpu/common.c
>@@ -1226,7 +1226,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
> 	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
>
> 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
>-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
>+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
> 	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),

I don't know if Hygon is ever going to get Automatic IBRS, but it
doesn't hurt to add NO_EIBRS_PBRSB to Hygon as well.
