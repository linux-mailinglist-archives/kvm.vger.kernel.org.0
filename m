Return-Path: <kvm+bounces-48801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02ADDAD3196
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 11:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA17B16344A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 09:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E61228B412;
	Tue, 10 Jun 2025 09:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NmWwZjFx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F82820AA
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 09:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546963; cv=none; b=gGYfj6BDN2jS1Hz5mWYrr7EY7d5ZQ7jpRrqkE+otbLqmi3j4UTtpH3G1SldRf8O06ulG74hnuutUF3Nmf1W/lYw/3h4M3lpeQ2auJHG2+G6ISmxXr8trIYdz+7nj2qyTg8bqQBTBwPh0CD5N+K4qdOTBLpK2c+e7fSuHwYA4uvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546963; c=relaxed/simple;
	bh=8augh7aIgBhaUNEIHK7x/BVmY0s3Cdqqa0amcgKbrZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dzHXO7Sv8LxHEDZ5XjE6nx2rtt0tRNF9JYX3pTa77WWZCQ+Vir9vCBKCGnFh5dM2gv1aePG9CrKwtJUkXR3hqqbvwfi0ixNiRzEpGIbxSVz/ReAy3CpkXig4NT/TkPCbMirZoOfV71DCL8nuuwWPIgwUjcfWEOK67tgHlrhkXT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NmWwZjFx; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749546963; x=1781082963;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8augh7aIgBhaUNEIHK7x/BVmY0s3Cdqqa0amcgKbrZY=;
  b=NmWwZjFxDH2nqQrh96Gsts5KItcV5c76B+oiibuPTSvNuqItsMKF6P6p
   1Bm8H9aKWE425EwYMCI3t6WS+jRAkSZQpLtowCIFXCSXvsHVJ6XpVn3wE
   qW2lU/NXDNIAMn/LKxnQjnY7NxWPzXwFrxEXDG7PBsfRE0zUv1Jl5AAVO
   3OZiHVtk4VUjbpPnroRfmXW45XUcqhsWD/PR+jd3PZnbweOEFShA3e22Q
   VfbBT46xRy2yROd5f/+z3yyN7SafrylVsrRWMfYLShL7ezzfGQyYzKaem
   rw7fGWQyr+AIMloZD3W1L0qguAn/pwT0OZo88HzUOodhPj+5hCYlOEuFf
   Q==;
X-CSE-ConnectionGUID: ZcweRPv4R3aaJD3EUpSguA==
X-CSE-MsgGUID: nEikuhJOSK2qqJ757tJ7Og==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="55311891"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="55311891"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:16:02 -0700
X-CSE-ConnectionGUID: M6vzy9NyTPSmPH1W9OPBRQ==
X-CSE-MsgGUID: tjwRnSeOSzGGOzKo08NwXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="146702655"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 02:16:00 -0700
Message-ID: <7ea62c73-e568-4481-a498-c565103bc39f@linux.intel.com>
Date: Tue, 10 Jun 2025 17:15:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Explicitly zero PERF_GLOBAL_CTRL
 at start of PMU test
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
References: <20250529210157.3791397-1-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529210157.3791397-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 5:01 AM, Sean Christopherson wrote:
> Explicitly zero PERF_GLOBAL_CTRL at the start of the PMU test as the
> architectural RESET value of PERF_GLOBAL_CTRL is to set all enable bits
> for general purpose counters (for backwards compatibility with software
> that was written for v1 PMUs).  Leaving PERF_GLOBAL_CTRL set can result in
> false failures due to counters unexpectedly being left active.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/pmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 8cf26b12..9bd0c186 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -905,9 +905,6 @@ static void set_ref_cycle_expectations(void)
>  	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
>  		return;
>  
> -	if (this_cpu_has_perf_global_ctrl())
> -		wrmsr(pmu.msr_global_ctl, 0);
> -
>  	t0 = fenced_rdtsc();
>  	start_event(&cnt);
>  	t1 = fenced_rdtsc();
> @@ -956,6 +953,9 @@ int main(int ac, char **av)
>  	handle_irq(PMI_VECTOR, cnt_overflow);
>  	buf = malloc(N*64);
>  
> +	if (this_cpu_has_perf_global_ctrl())
> +		wrmsr(pmu.msr_global_ctl, 0);
> +
>  	check_invalid_rdpmc_gp();
>  
>  	if (pmu.is_intel) {
>
> base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



