Return-Path: <kvm+bounces-38539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A07EA3AF1F
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15F41174599
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3E583CC7;
	Wed, 19 Feb 2025 01:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MkCeb1/1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2E433E1
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739929797; cv=none; b=gNSLI8BjAkleL1gF9BwC9uTfOuLzkFPR3K04uL6Od9ywFdKM6MV4IZh1SRpHfBvSvOxaJfSwz5Ngiw0z2yhwTAYisHPEjCSxmEdQx/DizOXlrvVQkYYDQA9QWbQAopdoztNAwpoK/loU9ehaRTznaPmbaiDoTOnoLiXLomlOBlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739929797; c=relaxed/simple;
	bh=AicApY7bJ2VuAXlaxQUXNVzqt7qNCRItf7V6EY+Sdn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QBozX4qfLjQSP26ro+PPMhnI0qJgJlttffHgx3MdvtipAnBNpEiEqPJMK5b7JJbhsFXnfUvErzglE+GnZTxArrZ7f2kqKwoC6CImy/Il0JNggytTbaJ8GddjVUBfMcsmDgawRVxZX7PnU/tGsHgK9YZrv+YbNrnlqm2CLExAV4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MkCeb1/1; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739929796; x=1771465796;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AicApY7bJ2VuAXlaxQUXNVzqt7qNCRItf7V6EY+Sdn0=;
  b=MkCeb1/1bkI6wOJ4Mw7X/WdVyfcblzwECNP7SqWqlg4+kVXCO8+e18Y1
   g9BlC5VB44EcwEyMmulKpc9QSPDqtDDOHwmZ6OvzXkQGsrZKFfPatI/W2
   VjS/uHVcfmyF3qnJ0VOYmOjtnrz7r/tcGekJCKl/wqfRVlOhUlSGFfAFM
   V/FT1+kYNFuzReB7yY1iD3XIU/SAS8WGPJmFh5pAtqfUcdH/YuDt2qrbB
   Tv696ZnXGfkcA7AUvoxCwsr+PwaYdaHVMAkNNS3ifWGycKEQ/06e/lkmj
   Ev7YYY8zAUypS1wHUxZEfUs1fznL/8Py4WyAkw7rRvsTIfJBcMnkvaD8O
   A==;
X-CSE-ConnectionGUID: jiB+KURKRamlO6hCXJekmA==
X-CSE-MsgGUID: aq1eHJDhTtCLlV4VEiSXaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="44301399"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="44301399"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:49:55 -0800
X-CSE-ConnectionGUID: NrXLgBrgQjiOpkILRWYpjg==
X-CSE-MsgGUID: SHmrh+eNT5S6c3wYZ/WAOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="119554227"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:49:53 -0800
Message-ID: <ee173c88-3049-4c44-9df9-1da8e19c23f9@linux.intel.com>
Date: Wed, 19 Feb 2025 09:49:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v7 15/18] x86: pmu: Adjust lower boundary
 of llc-misses event to 0 for legacy CPUs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>
References: <20250215013636.1214612-1-seanjc@google.com>
 <20250215013636.1214612-16-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250215013636.1214612-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 2/15/2025 9:36 AM, Sean Christopherson wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>
> For these legacy Intel CPUs without clflush/clflushopt support, there is
> on way to force to trigger a LLC miss and the measured llc misses is

a typo:  on -> no


> possible to be 0. Thus adjust the lower boundary of llc-misses event to
> 0 to avoid possible false positive.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/pmu.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 97c05177..1fc94f26 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -81,6 +81,7 @@ struct pmu_event {
>  enum {
>  	INTEL_INSTRUCTIONS_IDX  = 1,
>  	INTEL_REF_CYCLES_IDX	= 2,
> +	INTEL_LLC_MISSES_IDX	= 4,
>  	INTEL_BRANCHES_IDX	= 5,
>  };
>  
> @@ -889,6 +890,15 @@ int main(int ac, char **av)
>  		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
>  		instruction_idx = INTEL_INSTRUCTIONS_IDX;
>  		branch_idx = INTEL_BRANCHES_IDX;
> +
> +		/*
> +		 * For legacy Intel CPUS without clflush/clflushopt support,
> +		 * there is no way to force to trigger a LLC miss, thus set
> +		 * the minimum value to 0 to avoid false positives.
> +		 */
> +		if (!this_cpu_has(X86_FEATURE_CLFLUSH))
> +			gp_events[INTEL_LLC_MISSES_IDX].min = 0;
> +
>  		report_prefix_push("Intel");
>  		set_ref_cycle_expectations();
>  	} else {

