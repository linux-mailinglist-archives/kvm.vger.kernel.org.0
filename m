Return-Path: <kvm+bounces-6174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D09682D30A
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 03:03:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53EFF28150F
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 02:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BF61841;
	Mon, 15 Jan 2024 02:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lGS2kXG/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9B815BB;
	Mon, 15 Jan 2024 02:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705284189; x=1736820189;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZmyJ1bc7ue0Ua4ANfQvvo7h5UHL8+CslhMKn7IpmOoE=;
  b=lGS2kXG/gozNtjp8t5cgZsXlwcEmMOpoZQR9dinNwDyXxmIhpcexcz0y
   QY4DTlopJADE+YI50RfsPMdViGEIW/Uzk/DhK28OMnucdq7TfUI89nuti
   hkPZFqhlwKFwNgXGFrDxgGb2YkoWSto4CuZsf9UccM5s2SFrNvbDgNH5v
   0/6NF6GQ1vLLC7O4R7AxcLHQ2xjx/5a/l2lMq1Es3GIADEu5W1idhWBhq
   yLbgwgoy7xEHYG1TRpAWceCHQF6XZsf3sO6yZqWRvEwUUDgXmAU3Lpr5U
   MLXSZHGeiPeVIJgwLbyAvx9QFI8Us+nHsMpLrsjEX7fUihi4WVEWRnjP5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="6271488"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="6271488"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 18:03:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="853847180"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="853847180"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.98]) ([10.93.5.98])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 18:03:06 -0800
Message-ID: <cce0483f-539b-4be3-838d-af0ec91db8f0@linux.intel.com>
Date: Mon, 15 Jan 2024 10:03:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/29] KVM: selftests: Test Intel PMU architectural
 events on gp counters
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
 Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>,
 Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
References: <20240109230250.424295-1-seanjc@google.com>
 <20240109230250.424295-17-seanjc@google.com>
 <5f51fda5-bc07-42ac-a723-d09d90136961@linux.intel.com>
 <ZaGxNsrf_pUHkFiY@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZaGxNsrf_pUHkFiY@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/13/2024 5:37 AM, Sean Christopherson wrote:
> On Fri, Jan 12, 2024, Dapeng Mi wrote:
>> On 1/10/2024 7:02 AM, Sean Christopherson wrote:
>>> +/*
>>> + * If an architectural event is supported and guaranteed to generate at least
>>> + * one "hit, assert that its count is non-zero.  If an event isn't supported or
>>> + * the test can't guarantee the associated action will occur, then all bets are
>>> + * off regarding the count, i.e. no checks can be done.
>>> + *
>>> + * Sanity check that in all cases, the event doesn't count when it's disabled,
>>> + * and that KVM correctly emulates the write of an arbitrary value.
>>> + */
>>> +static void guest_assert_event_count(uint8_t idx,
>>> +				     struct kvm_x86_pmu_feature event,
>>> +				     uint32_t pmc, uint32_t pmc_msr)
>>> +{
>>> +	uint64_t count;
>>> +
>>> +	count = _rdpmc(pmc);
>>> +	if (!this_pmu_has(event))
>>> +		goto sanity_checks;
>>> +
>>> +	switch (idx) {
>>> +	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
>>> +		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
>>> +		break;
>>> +	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
>>> +		GUEST_ASSERT_EQ(count, NUM_BRANCHES);
>>> +		break;
>>> +	case INTEL_ARCH_CPU_CYCLES_INDEX:
>>> +	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
>> Since we already support slots event in below guest_test_arch_event(), we
>> can add check for INTEL_ARCH_TOPDOWN_SLOTS_INDEX here.
> Can that actually be tested at this point, since KVM doesn't support
> X86_PMU_FEATURE_TOPDOWN_SLOTS, i.e. this_pmu_has() above should always fail, no?

I suppose X86_PMU_FEATURE_TOPDOWN_SLOTS has been supported in KVM.  The 
following output comes from a guest with latest kvm-x86 code on the 
Sapphire Rapids platform.

sudo cpuid -l 0xa
CPU 0:
    Architecture Performance Monitoring Features (0xa):
       version ID                               = 0x2 (2)
       number of counters per logical processor = 0x8 (8)
       bit width of counter                     = 0x30 (48)
       length of EBX bit vector                 = 0x8 (8)
       core cycle event                         = available
       instruction retired event                = available
       reference cycles event                   = available
       last-level cache ref event               = available
       last-level cache miss event              = available
       branch inst retired event                = available
       branch mispred retired event             = available
       top-down slots event                     = available

Current KVM doesn't support fixed counter 3 and pseudo slots event yet, 
but the architectural slots event is supported and can be programed on a 
GP counter. Current test code can cover this case, so I think we'd 
better add the check for the slots count.


>
> I'm hesitant to add an assertion of any king without the ability to actually test
> the code.

