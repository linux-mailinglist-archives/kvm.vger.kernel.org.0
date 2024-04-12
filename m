Return-Path: <kvm+bounces-14391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC15F8A2655
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE551B24590
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 06:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35CA2BCF4;
	Fri, 12 Apr 2024 06:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XQW/WOLi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6923234;
	Fri, 12 Apr 2024 06:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712902668; cv=none; b=NCfqqykDViRUuieM+Oh8sLFylMpcSbG3D1gVLqDqEri/cBi1YPqXAjIQtbKCW6iLBxEeP4w1kh19C/h6jMLZFH1p9dAcrrSYh2OWNgB2STff7+zoscPwNBKLbsmr8qhbkMaeJtYVJ7occ+4XNj8aEEviI8Gf6534LZ6lgp/LfN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712902668; c=relaxed/simple;
	bh=fJad/M5v4UkmyQdRjVeibyM7pA9CQb94YlxCzIYU7Is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TDmzXcjamuwUB/tRRVgm1PimRwWCduTH344T6y0iqtWdspVcKe13cRDxpYbgjf/pCoKDwjnzmk5eEUialBFA4uv17m+7lyxTT640S1+vD+baRbitje88RacUmKTHqGLbnvx+5MS7LG/pJyk+KjnszzA/QlAeaKCzM1YyFrpjuRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XQW/WOLi; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712902666; x=1744438666;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fJad/M5v4UkmyQdRjVeibyM7pA9CQb94YlxCzIYU7Is=;
  b=XQW/WOLiH+iuCAMxlyMvgM/EUdd7FKeaKRMmjakPe3zMdpVhmGnvYlFZ
   3tm51Egl4JB6K//jsmHXvoO14hj12YagfI0VjAssmm6YYF3jRCc/Kn07L
   75h7hMjdp++hBFqbtbvQup3RbRXlKoBLhup2JiYiLqJB6j/rPTlbqoGfR
   DBTmsDq/WTGd3qrFD9zbtVvgy5A8SxDxtFauF2GOrsDO5ArjyuAppLFIQ
   t+9UqvVGfeHbdV8r7wUr1AnQBNmXYRaBYELG/orUjX22W7/XSnhCbrRQM
   iNi71ry2kWKw8r33/IbTwkY5nWZJjgOCaIaE09BaSfmVVZ0OpCrf1occA
   w==;
X-CSE-ConnectionGUID: bfogTIZBTnunq0Cr87dWRg==
X-CSE-MsgGUID: nC+kqSMJToOQLV/PefyeLA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8477867"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8477867"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 23:17:46 -0700
X-CSE-ConnectionGUID: WoPCkQFySrilZjLdRbsGNQ==
X-CSE-MsgGUID: MwvHk+UERuqY7ad9C/NZjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21185053"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.244.162]) ([10.124.244.162])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 23:17:41 -0700
Message-ID: <3a0c2542-2aa7-464b-8a09-e09e570c88da@linux.intel.com>
Date: Fri, 12 Apr 2024 14:17:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 07/41] perf/x86: Add interface to reflect virtual
 LVTPC_MASK bit onto HW
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-8-xiong.y.zhang@linux.intel.com>
 <Zhg4Oph6yCpN0DeX@google.com>
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <Zhg4Oph6yCpN0DeX@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/12/2024 3:21 AM, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@intel.com>
>>
>> When guest clear LVTPC_MASK bit in guest PMI handler at PMU passthrough
>> mode, this bit should be reflected onto HW, otherwise HW couldn't generate
>> PMI again during VM running until it is cleared.
> 
> This fixes a bug in the previous patch, i.e. this should not be a standalone
> patch.
> 
>>
>> This commit set HW LVTPC_MASK bit at PMU vecctor switching to KVM PMI
>> vector.
>>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/events/core.c            | 9 +++++++--
>>  arch/x86/include/asm/perf_event.h | 2 +-
>>  arch/x86/kvm/lapic.h              | 1 -
>>  3 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 3f87894d8c8e..ece042cfb470 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -709,13 +709,18 @@ void perf_guest_switch_to_host_pmi_vector(void)
>>  }
>>  EXPORT_SYMBOL_GPL(perf_guest_switch_to_host_pmi_vector);
>>  
>> -void perf_guest_switch_to_kvm_pmi_vector(void)
>> +void perf_guest_switch_to_kvm_pmi_vector(bool mask)
>>  {
>>  	lockdep_assert_irqs_disabled();
>>  
>> -	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
>> +	if (mask)
>> +		apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR |
>> +			   APIC_LVT_MASKED);
>> +	else
>> +		apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
>>  }
> 
> Or more simply:
> 
> void perf_guest_enter(u32 guest_lvtpc)
> {
> 	...
> 
> 	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR |
> 			       (guest_lvtpc & APIC_LVT_MASKED));
> }
> 
> and then on the KVM side:
> 
> 	perf_guest_enter(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> 
> because an in-kernel APIC should be a hard requirement for the mediated PMU.
> this is simpler and we will follow this.

thanks

