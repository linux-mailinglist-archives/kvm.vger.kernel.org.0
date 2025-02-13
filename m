Return-Path: <kvm+bounces-38002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAED8A3372B
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 06:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 681B4167240
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 05:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3372066E5;
	Thu, 13 Feb 2025 05:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nRAspnFj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E7223BE;
	Thu, 13 Feb 2025 05:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739423474; cv=none; b=cXnF2eC5HkUZrs194FBnjXDNe/JZJqBw66/qO9RViDbU6h5fnUq+4vYXKOIzWSRYdnnKuhMT8WHqSi2wnE2g0Pwx923x7uBW6fArleJdGbe5NiYflzj9HteyhhzG8ADPJChpUFwRgjGTBj/LTg4xF0ryspH5UQfAVgJ1hOGxhZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739423474; c=relaxed/simple;
	bh=82Pt9jYYg0o/v02xnz9iTSVcrIdDV9Ou/5iQIoRaXM8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=n0ZAUZTvB8GCmNdNMZDZUzu7NonTrh4TzL956HZKGOx1MJurUR2m/ugksPFdTe7jbvNP+Ok2Mpwpw6bNV9Pm0h67nPm8LSiT9Oef9yKIo6DqVfbc/0TAC8ndVfzMzMLTYSJSzlFtfuyCdcCBNKZhOaAuzyFu2V2srnTDUkrXbXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nRAspnFj; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739423473; x=1770959473;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=82Pt9jYYg0o/v02xnz9iTSVcrIdDV9Ou/5iQIoRaXM8=;
  b=nRAspnFj+r77q2Ib63AFjc7+evALtkr8JzRplPBvgnLBCSaLYQolPKag
   +J/L1Al3XyE5nYguL2obSqWXqs6vkSN8EusnDGOkx5kjbI+zqbL5X2FKN
   RBAylQ7svC8WdbrjYShRtdRkZv+Oig0BEIZpDRBE2n7WN5fL1uHf1nwmx
   WgQR3wmcD7DwKEqkncXNwrAUSVpC9mO9f0zqlwvizpaM8PMsM2IAsjVkM
   0QSPq5JItTNqJ3u85mGMqt1D6PKuBwZjDZEWi10HE39SN+93YJQ6vKaRK
   B1ys+vEx2/K3qCJ02d1D/GPdDnuv58KQZuJ4lK4IBwVFvHrMjOfvNicz8
   Q==;
X-CSE-ConnectionGUID: taCp7NdMRgyhk0REN2yFew==
X-CSE-MsgGUID: 2dBDpE4zTrWNRtiFtUnumA==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="27703805"
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="27703805"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 21:11:12 -0800
X-CSE-ConnectionGUID: S+tOur8ES6GtsVm5SxZgZA==
X-CSE-MsgGUID: cjhJUpbyQjeY5MA75sG8zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112879212"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 21:11:07 -0800
Message-ID: <c47f0fa1-b400-4186-846e-84d0470d887e@linux.intel.com>
Date: Thu, 13 Feb 2025 13:11:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com,
 linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-6-binbin.wu@linux.intel.com>
 <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
 <926a035f-e375-4164-bcd8-736e65a1c0f7@linux.intel.com>
 <Z6sReszzi8jL97TP@intel.com> <Z6vvgGFngGjQHwps@google.com>
 <3033f048-6aa8-483a-b2dc-37e8dfb237d5@linux.intel.com>
 <Z6zu8liLTKAKmPwV@google.com>
 <f12e1c06-d38d-4ed0-b471-7f016057f604@linux.intel.com>
Content-Language: en-US
In-Reply-To: <f12e1c06-d38d-4ed0-b471-7f016057f604@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/13/2025 11:23 AM, Binbin Wu wrote:
>
>
> On 2/13/2025 2:56 AM, Sean Christopherson wrote:
>> On Wed, Feb 12, 2025, Binbin Wu wrote:
>>> On 2/12/2025 8:46 AM, Sean Christopherson wrote:
>>>> I am completely comfortable saying that KVM doesn't care about STI/SS shadows
>>>> outside of the HALTED case, and so unless I'm missing something, I think it makes
>>>> sense for tdx_protected_apic_has_interrupt() to not check RVI outside of the HALTED
>>>> case, because it's impossible to know if the interrupt is actually unmasked, and
>>>> statistically it's far, far more likely that it _is_ masked.
>>> OK. Will update tdx_protected_apic_has_interrupt() in "TDX interrupts" part.
>>> And use kvm_vcpu_has_events() to replace the open code in this patch.
>> Something to keep an eye on: kvm_vcpu_has_events() returns true if pv_unhalted
>> is set, and pv_unhalted is only cleared on transitions KVM_MP_STATE_RUNNABLE.
>> If the guest initiates a spurious wakeup, pv_unhalted could be left set in
>> perpetuity.
>
> Oh, yes.
> KVM_HC_KICK_CPU is allowed in TDX guests.
>
> The change below looks good to me.
>
> One minor issue is when guest initiates a spurious wakeup, pv_unhalted is
> left set, then later when the guest want to halt the vcpu, in
> __kvm_emulate_halt(), since pv_unhalted is still set and the state will not
> transit to KVM_MP_STATE_HALTED.
> But I guess it's guests' responsibility to not initiate spurious wakeup,
> guests need to bear the fact that HLT could fail due to a previous
> spurious wakeup?

Just found a patch set for fixing the issue.
https://lore.kernel.org/kvm/20250113200150.487409-1-jmattson@google.com/

>
>>
>> I _think_ this would work and is generally desirable?
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 8e77e61d4fbd..435ca2782c3c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11114,9 +11114,6 @@ static bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>>              kvm_apic_init_sipi_allowed(vcpu))
>>                  return true;
>>   -       if (vcpu->arch.pv.pv_unhalted)
>> -               return true;
>> -
>>          if (kvm_is_exception_pending(vcpu))
>>                  return true;
>>   @@ -11157,7 +11154,8 @@ static bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>>     int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>>   {
>> -       return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
>> +       return kvm_vcpu_running(vcpu) || vcpu->arch.pv.pv_unhalted ||
>> +              kvm_vcpu_has_events(vcpu);
>>   }
>>     /* Called within kvm->srcu read side.  */
>> @@ -11293,7 +11291,7 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>>           */
>>          ++vcpu->stat.halt_exits;
>>          if (lapic_in_kernel(vcpu)) {
>> -               if (kvm_vcpu_has_events(vcpu))
>> +               if (kvm_vcpu_has_events(vcpu) || vcpu->arch.pv.pv_unhalted)
>>                          vcpu->arch.pv.pv_unhalted = false;
>>                  else
>>                          vcpu->arch.mp_state = state;
>>
>>
>
>


