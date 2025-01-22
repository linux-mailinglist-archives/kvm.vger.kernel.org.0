Return-Path: <kvm+bounces-36208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B80A1897E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:26:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 745BF169AB3
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EB06F06A;
	Wed, 22 Jan 2025 01:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mI8ohasy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F867A13A
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 01:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737509191; cv=none; b=I0tx2VnwU5kVkTtIIqfI3C843D0008CgGE3rX8pi+uS+yIwJF1XYFxvZ454s4ArLj9roThoU2jfRP66cWsqyMZ21//lQq5KPOloxzg9kMDDAXZj7yLlQXm58hVvI8OmOfsJGU9ep6+CkC2+vZ6NLJatydApS6LtTTj1NWWXQiLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737509191; c=relaxed/simple;
	bh=pn3xHi5uqpJtOpCOmy6yoovBDNZAFfmxqKyTHKYRhaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E2mDq+YU0znPBKQ1IWCNOaErHQ86PMM202FA8N3FqSJ5wwPTY/tMeHQQqH7nu6pIn3dgaaBBH8EMjM4CC8Sp+0w4l1LDg02NW9/NfyN34SrIw8hSItWMRqXzejcs5IXEiIRxRQ2B+wONgSj9BognABJTBq8UbBtgfSXiKSg7KOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mI8ohasy; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737509190; x=1769045190;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pn3xHi5uqpJtOpCOmy6yoovBDNZAFfmxqKyTHKYRhaI=;
  b=mI8ohasyFedRAsVlXR3l+eV2Qu3Xuq76cFFOZOPpVcjA8m0WQKSnwAqc
   SWW02Cu/+K59mLFQ8ImC5hYsAU8Kh0Y6hqeMlBMJ9l/szr4TxCDYfZx5I
   zBE54Vok9/UXM8425/d5yIF1DMWwcgTeZ20DLVBVAjqQq6jAKOTx2bzEy
   vPT70bW9c84CDXIPTJhGfKEK6tzV3NcbAqRIzPSD6sj7sk6/dYN6oo4FX
   V7RMhCHruWLVmOHj22esYXuE0KNyBtylaKuOBCg8CfXB7uUO4PE5a5Np2
   QOqKvM3GR+Y0mgQuOUl3rqIXZ755LUnVWhis1aEmHuIdBw1LOibL1Ceua
   w==;
X-CSE-ConnectionGUID: nq8JCU6ATxKRZ0UuBG4vKQ==
X-CSE-MsgGUID: clJTafEJTwucmsDU/Pq8ug==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="55504656"
X-IronPort-AV: E=Sophos;i="6.13,223,1732608000"; 
   d="scan'208";a="55504656"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 17:26:29 -0800
X-CSE-ConnectionGUID: 6jtc5VLTTbyUW4WfSHRvfQ==
X-CSE-MsgGUID: Ecyh4+MiSSW3pPTXsfbXEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="137864123"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 17:26:27 -0800
Message-ID: <2aa70d89-dd04-4b46-a7bd-01e21f010e3a@linux.intel.com>
Date: Wed, 22 Jan 2025 09:26:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [KVM] 7803339fa9:
 kernel-selftests.kvm.pmu_counters_test.fail
To: Sean Christopherson <seanjc@google.com>
Cc: kernel test robot <oliver.sang@intel.com>, g@google.com,
 oe-lkp@lists.linux.dev, lkp@intel.com, Maxim Levitsky <mlevitsk@redhat.com>,
 kvm@vger.kernel.org, xudong.hao@intel.com
References: <202501141009.30c629b4-lkp@intel.com>
 <Z4a_PmUVVmUtOd4p@google.com>
 <a2adf1b8-c394-4741-a42b-32288657b07e@linux.intel.com>
 <6c23d536-484f-4c4b-aa85-3e0b9544611a@linux.intel.com>
 <Z4qPWNscnU9-b30n@google.com>
 <c1ce77cd-8921-402d-87b2-fd3fa11add4d@linux.intel.com>
 <Z4_HvwSYX592oQ5s@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z4_HvwSYX592oQ5s@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 1/22/2025 12:13 AM, Sean Christopherson wrote:
> On Mon, Jan 20, 2025, Dapeng Mi wrote:
>> On 1/18/2025 1:11 AM, Sean Christopherson wrote:
>>> @@ -98,14 +149,12 @@ static uint8_t guest_get_pmu_version(void)
>>>   * Sanity check that in all cases, the event doesn't count when it's disabled,
>>>   * and that KVM correctly emulates the write of an arbitrary value.
>>>   */
>>> -static void guest_assert_event_count(uint8_t idx,
>>> -				     struct kvm_x86_pmu_feature event,
>>> -				     uint32_t pmc, uint32_t pmc_msr)
>>> +static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr)
>>>  {
>>>  	uint64_t count;
>>>  
>>>  	count = _rdpmc(pmc);
>>> -	if (!this_pmu_has(event))
>>> +	if (!(hardware_pmu_arch_events & BIT(idx)))
>>>  		goto sanity_checks;
>>>  
>>>  	switch (idx) {
>>> @@ -126,7 +175,9 @@ static void guest_assert_event_count(uint8_t idx,
>>>  		GUEST_ASSERT_NE(count, 0);
>>>  		break;
>>>  	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
>>> -		GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
>>> +		__GUEST_ASSERT(count < NUM_INSNS_RETIRED,
>> shouldn't be "__GUEST_ASSERT(count >= NUM_INSNS_RETIRED," ?
> Yes.  I had intentionally inverted the check to verify the assert message and
> forgot to flip it back before hitting "send".  Thankfully, I didn't forget before
> posting formally[*].  Ugh, but I did forget to Cc you on that series, sorry :-/
>
> [*] https://lore.kernel.org/all/20250117234204.2600624-6-seanjc@google.com

Good to know. Thanks.


>

