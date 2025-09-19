Return-Path: <kvm+bounces-58110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF272B87F0A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF181568658
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 05:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045BE276041;
	Fri, 19 Sep 2025 05:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iqgAqlZw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8593126E6F2;
	Fri, 19 Sep 2025 05:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758260637; cv=none; b=pg0MNCBv82+yENzm0LcbZUVBt5ai3Gma+af943L7KdHSKK8ZW9itz+LXHkO7zY4nI0Ixsmj+EaMvSkhJLttGRjiqFDcJ3FhaDlu1GgKfIghjnugGpKlGxgnYr5FLJoTKkQGAlygPUs+WVwDw5RVh17PQmQpJnjHOjA6HIEcgFj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758260637; c=relaxed/simple;
	bh=JvtE/afKqnfVOau1uKTLUwZBev75LUuphz9p2nRD1Bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X/n4hy7vHOYTHJPPZPOmI4b28HMz87q8G1m6TIVEpLvNLRPoO5pzsv1fFrczlH3x9KcwyFG5OVZqbryjPt1GOqbJMpBLXuUTnCWfLEzTLqI/H33Lkjw5T0cgJ6iFkfIEb0lE7vZYyGtfFmpCSuUcdzxexKEM9VJR10b7FDORUzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iqgAqlZw; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260635; x=1789796635;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JvtE/afKqnfVOau1uKTLUwZBev75LUuphz9p2nRD1Bg=;
  b=iqgAqlZwlyigN93eweqqzYJzYWG+aJTewE/I02fW7aqm/jq2ieNLoZJt
   LdQLQgg4vdoYQRfJYd8QAWWPXuc+oCmiIEhgho8iPpsV+FOP8EWkk7K2+
   FJkeHotyYwZ0kXfM/TM4t1T8NEzekPNF5bJnlAZlGa+HVS4jMgXIFqW6+
   lDGzdo+aQLBgBkxMYJOR6boKy+rac2F2bHgki2z/cDVS7AteAgQV4CBh7
   1tlfCc+qVU6A1Ik0Aop2Co6wUCjZhSTrTGlRB6sBiwKz9lMnw20cuTQi9
   xf3taoSZuZ7Ja1inpaeIZxUyz1vljaoFcNyjtR98CP1dXqi2/6SkK0qi0
   Q==;
X-CSE-ConnectionGUID: diuwB/NFTx6Ht79bQ3OqEA==
X-CSE-MsgGUID: IXukxhH7Rgm+Yqpqwxfeww==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60666952"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="60666952"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:43:53 -0700
X-CSE-ConnectionGUID: JLBCWKi8R6Chr5PUBXpb0Q==
X-CSE-MsgGUID: f46w158mSe67vfn+4syNdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="174864305"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.233.177]) ([10.124.233.177])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:43:52 -0700
Message-ID: <8e3faa80-7091-454b-8ac6-1aa431185c06@linux.intel.com>
Date: Fri, 19 Sep 2025 13:43:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] KVM: selftests: Track unavailable_mask for PMU
 events as 32-bit value
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yi Lai <yi1.lai@intel.com>, dongsheng <dongsheng.x.zhang@intel.com>
References: <20250919004512.1359828-1-seanjc@google.com>
 <20250919004512.1359828-3-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250919004512.1359828-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 9/19/2025 8:45 AM, Sean Christopherson wrote:
> Track the mask of "unavailable" PMU events as a 32-bit value.  While bits
> 31:9 are currently reserved, silently truncating those bits is unnecessary
> and asking for missed coverage.  To avoid running afoul of the sanity check
> in vcpu_set_cpuid_property(), explicitly adjust the mask based on the
> non-reserved bits as reported by KVM's supported CPUID.
>
> Opportunistically update the "all ones" testcase to pass -1u instead of
> 0xff.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86/pmu_counters_test.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index 8aaaf25b6111..cfeed0103341 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> @@ -311,7 +311,7 @@ static void guest_test_arch_events(void)
>  }
>  
>  static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
> -			     uint8_t length, uint8_t unavailable_mask)
> +			     uint8_t length, uint32_t unavailable_mask)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
> @@ -320,6 +320,9 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
>  	if (!pmu_version)
>  		return;
>  
> +	unavailable_mask = GENMASK(X86_PROPERTY_PMU_EVENTS_MASK.hi_bit,
> +				   X86_PROPERTY_PMU_EVENTS_MASK.lo_bit);

Should be "unavailable_mask &="? Otherwise the incoming argument
"unavailable_mask" would be overwritten unconditionally. 


> +
>  	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_arch_events,
>  					 pmu_version, perf_capabilities);
>  
> @@ -630,7 +633,7 @@ static void test_intel_counters(void)
>  			 */
>  			for (j = 0; j <= NR_INTEL_ARCH_EVENTS + 1; j++) {
>  				test_arch_events(v, perf_caps[i], j, 0);
> -				test_arch_events(v, perf_caps[i], j, 0xff);
> +				test_arch_events(v, perf_caps[i], j, -1u);
>  
>  				for (k = 0; k < NR_INTEL_ARCH_EVENTS; k++)
>  					test_arch_events(v, perf_caps[i], j, BIT(k));

