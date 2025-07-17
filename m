Return-Path: <kvm+bounces-52724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E58B088FF
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 11:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F164718817B0
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3056C28A1FB;
	Thu, 17 Jul 2025 09:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KjfkpI/W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC382C18A;
	Thu, 17 Jul 2025 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752743355; cv=none; b=mxd6uBGt0HhLHUXHhZd0eDu4oacVqEyidvndLO/3yc4IrTQgsqiAP7MeDwRgGP6bwXsz34CtybN5RICbTQT4jB2dlP62MpoyJ8Z2+Zi7kulb+/oUBjM7i4PFysWoqz6qY3McBQQMm+sec8TmGUHeQXoY3JMv3w4d5AOsXZkHpYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752743355; c=relaxed/simple;
	bh=hSFoy5VqyrudHZ6R4bwcXEN9ZOwY5A2qYXTuyDbMPio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5eN8lK7rv1xzHmk1ee2KB5Jse7/dJUctCM5F8hazuQ2M0X/WBlg+uO21dwrmzIeMjeb6hkZ4UwFQkejf0aq2LWCbzCnBMqsnSeD9AiFnlEj1BF0qF+1UJ7KakO6+0VNGv/CwvcbFwgsHoYds1nto2M9Pb462s2/6vwgmoPs8r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KjfkpI/W; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752743353; x=1784279353;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hSFoy5VqyrudHZ6R4bwcXEN9ZOwY5A2qYXTuyDbMPio=;
  b=KjfkpI/WApoMiG18hvPxh02/WpJ9RxaeCfNAbrMK6o/VJ5UFWSDR1dCN
   QjToXzXQU8aKEDub2lVSjYdR5somLKB/kjIczmT33C/0WyonfmQ7IokU4
   o+V+IVjTB3MPY59Y5Du/GIS39lU2lYZd7cmG6iVyKCsRdHq3EytttR1dR
   uPCc9qhhLD13rHVpMcBzHIl1uYtWezQTPIqtMWHN8Y+v4AAXQNJX7f6Zu
   Eqg7dTBwpJno2aTM9jROFCedgNaSrQGyNbAhvQwbGFrHG6ShMS6GJq5Ku
   Kce3DmtNgmqG/S0QKht/l1lZFmHPbbGyqDVdI+vdyEoqIFZNAevWQqmxs
   w==;
X-CSE-ConnectionGUID: mzcO15uFTJKsyC/H2Remuw==
X-CSE-MsgGUID: yepIYSuDSg+Drfe2s9/ySA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="55129590"
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="55129590"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 02:09:13 -0700
X-CSE-ConnectionGUID: ul3g2CwIRfKNsnRjN5KzcQ==
X-CSE-MsgGUID: Fdi5OaeJQzWjtXyohyk6XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="188683008"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 02:09:09 -0700
Message-ID: <9b4651bf-20e4-406f-ba41-9f67515e5bea@linux.intel.com>
Date: Thu, 17 Jul 2025 17:09:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] perf/x86: Add PERF_CAP_PEBS_TIMING_INFO flag
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
 Eranian Stephane <eranian@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Dapeng Mi <dapeng1.mi@intel.com>,
 Yi Lai <yi1.lai@intel.com>
References: <20250717090302.11316-1-dapeng1.mi@linux.intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250717090302.11316-1-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Run basic perf  counting, PMI based sampling and PEBS based sampling on
Intel Sapphire Rapids, Granite Rapids and Sierra Forest platforms, no issue
is found.

On 7/17/2025 5:03 PM, Dapeng Mi wrote:
> IA32_PERF_CAPABILITIES.PEBS_TIMING_INFO[bit 17] is introduced to
> indicate whether timed PEBS is supported. Timed PEBS adds a new "retired
> latency" field in basic info group to show the timing info. Please find
> detailed information about timed PEBS in section 8.4.1 "Timed Processor
> Event Based Sampling" of "Intel Architecture Instruction Set Extensions
> and Future Features".
>
> This patch adds PERF_CAP_PEBS_TIMING_INFO flag and KVM module leverages
> this flag to expose timed PEBS feature to guest.
>
> Moreover, opportunistically refine the indents and make the macros
> share consistent indents.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h       | 14 ++++++++------
>  tools/arch/x86/include/asm/msr-index.h | 14 ++++++++------
>  2 files changed, 16 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index b7dded3c8113..48b7ed28718c 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -315,12 +315,14 @@
>  #define PERF_CAP_PT_IDX			16
>  
>  #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
> -#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
> -#define PERF_CAP_ARCH_REG              BIT_ULL(7)
> -#define PERF_CAP_PEBS_FORMAT           0xf00
> -#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
> -#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
> -				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
> +#define PERF_CAP_PEBS_TRAP		BIT_ULL(6)
> +#define PERF_CAP_ARCH_REG		BIT_ULL(7)
> +#define PERF_CAP_PEBS_FORMAT		0xf00
> +#define PERF_CAP_PEBS_BASELINE		BIT_ULL(14)
> +#define PERF_CAP_PEBS_TIMING_INFO	BIT_ULL(17)
> +#define PERF_CAP_PEBS_MASK		(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
> +					 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE | \
> +					 PERF_CAP_PEBS_TIMING_INFO)
>  
>  #define MSR_IA32_RTIT_CTL		0x00000570
>  #define RTIT_CTL_TRACEEN		BIT(0)
> diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
> index b7dded3c8113..48b7ed28718c 100644
> --- a/tools/arch/x86/include/asm/msr-index.h
> +++ b/tools/arch/x86/include/asm/msr-index.h
> @@ -315,12 +315,14 @@
>  #define PERF_CAP_PT_IDX			16
>  
>  #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
> -#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
> -#define PERF_CAP_ARCH_REG              BIT_ULL(7)
> -#define PERF_CAP_PEBS_FORMAT           0xf00
> -#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
> -#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
> -				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
> +#define PERF_CAP_PEBS_TRAP		BIT_ULL(6)
> +#define PERF_CAP_ARCH_REG		BIT_ULL(7)
> +#define PERF_CAP_PEBS_FORMAT		0xf00
> +#define PERF_CAP_PEBS_BASELINE		BIT_ULL(14)
> +#define PERF_CAP_PEBS_TIMING_INFO	BIT_ULL(17)
> +#define PERF_CAP_PEBS_MASK		(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
> +					 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE | \
> +					 PERF_CAP_PEBS_TIMING_INFO)
>  
>  #define MSR_IA32_RTIT_CTL		0x00000570
>  #define RTIT_CTL_TRACEEN		BIT(0)
>
> base-commit: 829f5a6308ce11c3edaa31498a825f8c41b9e9aa

