Return-Path: <kvm+bounces-14588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A4D8A3A82
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 04:29:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2F351C21A47
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 02:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11A117C7C;
	Sat, 13 Apr 2024 02:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HHbMyNTp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3722013ADA;
	Sat, 13 Apr 2024 02:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712975368; cv=none; b=aZbW+iVJJQv/3XDbBzBWchhicIKpPlv3pdZ68yYtl65JVSvD2GdIUE25izr7hLanEXjGazr4a8SXKvuw81A/HJNfC2XeoV1mG85GDpAMZXN1jn+7H21HuDy0MsHahZiNBZlKzZxxL/2F9xDOxx2qzVWCGtDSLBcmRpc4RDMFojo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712975368; c=relaxed/simple;
	bh=29lpziG7mOimAw3cCKwckLgOvzVTIJh0F3g3jnh3bdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WL9434PHlchnoC2IaoZb65xcHRUnzH98weEuCeUxvcx/h3ylUruoaPf8I8heEwlq0XiSxC0nATsSnduAtx4fK759gtd9UenUfhUDPPY8ZoA+AOuYYhJ6ylkRLvL8+bs5HFXKpw0ps251BFaKnKmBKmQiWYUlhoQrixQt44NNAhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHbMyNTp; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712975366; x=1744511366;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=29lpziG7mOimAw3cCKwckLgOvzVTIJh0F3g3jnh3bdQ=;
  b=HHbMyNTp/Dd16xzOSFYM7wluBBZqDdS0HKo0YDH7E5lYWO+BdFtPAkRG
   W4F0w2o8fFQwoQoqpOt6KCn9G49yl84N6qnkIB5EIuXGlDSuK45+8pOTj
   AiKfDJ7DEqBXFjbqF2F90K7OHYtgA544suHuGmb8rxEHvn5HM77raRMnf
   klV8lr9YCCSkF6EJ0m1DcMjzx/Hyn7tBceRypI266JaQhVui8C+0dQVOz
   SW+6NdC4NdwFWBhxI+KgyoQnWa1wbLeG4TutysBWIdRGz9MBw+a0IwnC2
   lSaExCT61YWVaf/8JVas09/NkwmT4H0SOqrc1HJ9PE92VKEbJ4pHRdiK9
   A==;
X-CSE-ConnectionGUID: 0gHgzWfaSrO8TjTOw3x+dQ==
X-CSE-MsgGUID: fLTy8AovTFufYYOrRSXSlQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8997120"
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="8997120"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 19:29:25 -0700
X-CSE-ConnectionGUID: PDLcfHYZR3WcpCn+Zk2lnw==
X-CSE-MsgGUID: PYzeBqfvTn+ujWOP8/+T5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="21829776"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 19:29:21 -0700
Message-ID: <1e6d458c-ce9e-4ef2-9985-359c7b708bd3@linux.intel.com>
Date: Sat, 13 Apr 2024 10:29:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhVfOhFBfOWtK8E@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZhhVfOhFBfOWtK8E@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/12/2024 5:26 AM, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>>   static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
>>   {
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	struct kvm_pmc *pmc;
>> +	u32 i;
>> +
>> +	if (pmu->version != 2) {
>> +		pr_warn("only PerfMon v2 is supported for passthrough PMU");
>> +		return;
>> +	}
>> +
>> +	/* Global ctrl register is already saved at VM-exit. */
>> +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
>> +	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
>> +	if (pmu->global_status)
>> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
>> +
>> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
>> +		pmc = &pmu->gp_counters[i];
>> +		rdpmcl(i, pmc->counter);
>> +		rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
>> +		/*
>> +		 * Clear hardware PERFMON_EVENTSELx and its counter to avoid
>> +		 * leakage and also avoid this guest GP counter get accidentally
>> +		 * enabled during host running when host enable global ctrl.
>> +		 */
>> +		if (pmc->eventsel)
>> +			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
>> +		if (pmc->counter)
>> +			wrmsrl(MSR_IA32_PMC0 + i, 0);
>> +	}
>> +
>> +	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
>> +	/*
>> +	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
>> +	 * also avoid these guest fixed counters get accidentially enabled
>> +	 * during host running when host enable global ctrl.
>> +	 */
>> +	if (pmu->fixed_ctr_ctrl)
>> +		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +		pmc = &pmu->fixed_counters[i];
>> +		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
>> +		if (pmc->counter)
>> +			wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>> +	}
> For the next RFC, please make that it includes AMD support.  Mostly because I'm
> pretty all of this code can be in common x86.  The fixed counters are ugly,
> but pmu->nr_arch_fixed_counters is guaranteed to '0' on AMD, so it's _just_ ugly,
> i.e. not functionally problematic.

Sure. I believe Mingwei would integrate AMD supporting patches in next 
version. Yeah, I agree there could be a part of code which can be put 
into common x86/pmu, but there are still some vendor specific code, we 
still keep an vendor specific callback.



