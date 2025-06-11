Return-Path: <kvm+bounces-48939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4FD2AD47EA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:35:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FBEB17B233
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C4781732;
	Wed, 11 Jun 2025 01:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f6kx4sHa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A344685
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 01:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749605734; cv=none; b=BWdQ5uLsiGH10GrZniiwHf0CWs2oSjWN5848Vg9LawFXaaa3eocnELyAXv2brAyCseP8Ir57+KN7VFQqYLghNEOD0cNm8rREpE815zatEZvbq8j50w7IwNoDG7n14LdZ1HDI5iX4cccemOImFMyBz7UzdXTUkG/b9/SIE97LY7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749605734; c=relaxed/simple;
	bh=FQsEYn9oP1fqXMCUMu34hlcs0W3mH4Y5hSNBgoXZ3s0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LiTLP0eHc6FGgvRCoZrzt/u6nB3tX6zCMvsj0l69xe8dxFibGuxAcJoy/iWfkhYjkD8D6oPJMzpBn1ahq5GBf28UkpEU3HcieS8jvYpkC8owORiSIDVuBn/fhrkMmPxz6TK63kBXbFu+8sek/Mz8lFhUtgI2CoWB9kpOYQAK4rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f6kx4sHa; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749605733; x=1781141733;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FQsEYn9oP1fqXMCUMu34hlcs0W3mH4Y5hSNBgoXZ3s0=;
  b=f6kx4sHaRjwnOXQxwBGTDtJifL3KDFnxePTYU3We06ciDdVKg0kuu4fM
   dSXmH8TlhlUHcn6iFkG1PLvquiDtYahAclsRHfHfMgCZEQYm62gqsaR0c
   5i35bn3vVp6PfsEhxvEfRj1fKdq1ZggD40+phNOIwvzeuzQY4ALyy5ofm
   jF0g4zFXQkgYRUolqpoJXzHjLgd2wv0pj7hQpvcha0IXEj92SHcaGXIdN
   Zqs2wcYH9iOW+stH5hjF4omi5+TNFsTnOgIIwCzYKkVePkTsokvoyGUhX
   3yutQeZB5CrDOKrIC32s1XLt2adAT5Y056+rwBfQ/xXrH4lqiPNRKcOfU
   g==;
X-CSE-ConnectionGUID: hsn3oqNjRza8umUR8HCOOg==
X-CSE-MsgGUID: UYd//oTmQzyLL2F37bR/5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="62016812"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="62016812"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:35:32 -0700
X-CSE-ConnectionGUID: vEIuRQQ/RFOzLXr4I5G0mA==
X-CSE-MsgGUID: TNA3H4CKRyK5K1l5DBZhyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="177948709"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:35:30 -0700
Message-ID: <7f13ac75-41f1-4386-94be-3ddfc91d7129@linux.intel.com>
Date: Wed, 11 Jun 2025 09:35:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 07/14] x86/pmu: Mark Intel architectural
 event available iff X <= CPUID.0xA.EAX[31:24]
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Liam Merwick <liam.merwick@oracle.com>
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-8-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250610195415.115404-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 3:54 AM, Sean Christopherson wrote:
> Mask the set of available architectural events based on the bit vector
> length to avoid marking reserved/undefined events as available.  Per the
> SDM:
>
>   EAX Bits 31-24: Length of EBX bit vector to enumerate architectural
>                   performance monitoring events. Architectural event x is
>                   supported if EBX[x]=0 && EAX[31:24]>x.
>
> Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/pmu.c | 3 ++-
>  x86/pmu.c     | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index d37c874c..92707698 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -21,7 +21,8 @@ void pmu_init(void)
>  		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
>  
>  		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
> -		pmu.arch_event_available = ~cpuid_10.b;
> +		pmu.arch_event_available = ~cpuid_10.b &
> +					   (BIT(pmu.arch_event_mask_length) - 1);
>  
>  		if (this_cpu_has(X86_FEATURE_PDCM))
>  			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> diff --git a/x86/pmu.c b/x86/pmu.c
> index e79122ed..3987311c 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -993,6 +993,7 @@ int main(int ac, char **av)
>  	printf("GP counters:         %d\n", pmu.nr_gp_counters);
>  	printf("GP counter width:    %d\n", pmu.gp_counter_width);
>  	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
> +	printf("Arch Events (mask):  0x%x\n", pmu.arch_event_available);
>  	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>  	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



