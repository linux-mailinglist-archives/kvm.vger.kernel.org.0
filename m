Return-Path: <kvm+bounces-38324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44401A37A1D
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 04:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1670516C28A
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 03:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70BC15381A;
	Mon, 17 Feb 2025 03:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YOJVjzYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162B814A4F9;
	Mon, 17 Feb 2025 03:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739763717; cv=none; b=PneD5hmD6/lgkIMPwU4RdUCOxQ8tQGGpxliGl+gtmSIVQhU3tzFuh3JZ/sKXkXxi/FGHspnNHJsJcbNkAHmou4Y0Kui8/rrZYnBtdNViCrlHmVkCpjUhIk9H57HydLPwOp7bkMBv5g+7sxfQKFjvVNFehNAIr9U0naru9dXiisk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739763717; c=relaxed/simple;
	bh=afRrDQo715ZPSR7BJOVwm3d9UubybO6Pto4a1G8Qg+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0r5fYcQp0JyeeEyTt7uYOagaz9opelVIQkfq04G7ocLlCq+CJVDS73KvM8eUmhootFyTwBPmKUZl0KkMovo7BTpiqvguS5rJJqzMnGt4JsolZIo0mAaD80SXRlsNVfuVDnIGn8mkq1W3O/awEfrDkLDRjkMsR6Y7JyJSG7eUoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YOJVjzYJ; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739763716; x=1771299716;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=afRrDQo715ZPSR7BJOVwm3d9UubybO6Pto4a1G8Qg+Q=;
  b=YOJVjzYJ0hPt8Kkey7rojCVsDK4ftcydYLhG3ZOpU4as5rj38i/TrY3i
   Ulp458DtneAlE4GHec7L/iQD2MPz3q23y2gwMHo3pgoCbZHgTzxdkbht6
   oyY1qL05u2NQwhksrXwIisGfbH7dI4shXESjbOCF9n7IuV7UWyW57ZBvT
   CAGx2lLaZwY1MJc1LcH5FYn75+WvkJnwzID2rvMF/xWSz0bJWbzReQk6r
   QO60u0SaeQm+myk0uw7ZRTL+Id46DmqsQWURgj8KG7wIuykj8H5VvVz6z
   7SWiDaN6RWncEy6s9HryhCwxXy8tGKrvBqYlnnsCgwTg5vxS3UrsKHWr2
   Q==;
X-CSE-ConnectionGUID: y6islu2MRPCV7Sqpexag8Q==
X-CSE-MsgGUID: 0Wh2UNXDR0G9z+Aa0OTxLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="51083871"
X-IronPort-AV: E=Sophos;i="6.13,291,1732608000"; 
   d="scan'208";a="51083871"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2025 19:41:54 -0800
X-CSE-ConnectionGUID: kvQHgZpfTHKOPGZAyEKU1g==
X-CSE-MsgGUID: anugQotWSA2Jy7W4S2Yb+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114893976"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2025 19:41:52 -0800
Message-ID: <bcb80309-10ec-44e3-90db-259de6076183@linux.intel.com>
Date: Mon, 17 Feb 2025 11:41:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
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
 <c47f0fa1-b400-4186-846e-84d0470d887e@linux.intel.com>
 <Z64M_r64CCWxSD5_@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z64M_r64CCWxSD5_@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/13/2025 11:17 PM, Sean Christopherson wrote:
> On Thu, Feb 13, 2025, Binbin Wu wrote:
>> On 2/13/2025 11:23 AM, Binbin Wu wrote:
>>> On 2/13/2025 2:56 AM, Sean Christopherson wrote:
>>>> On Wed, Feb 12, 2025, Binbin Wu wrote:
>>>>> On 2/12/2025 8:46 AM, Sean Christopherson wrote:
>>>>>> I am completely comfortable saying that KVM doesn't care about STI/SS shadows
>>>>>> outside of the HALTED case, and so unless I'm missing something, I think it makes
>>>>>> sense for tdx_protected_apic_has_interrupt() to not check RVI outside of the HALTED
>>>>>> case, because it's impossible to know if the interrupt is actually unmasked, and
>>>>>> statistically it's far, far more likely that it _is_ masked.
>>>>> OK. Will update tdx_protected_apic_has_interrupt() in "TDX interrupts" part.
>>>>> And use kvm_vcpu_has_events() to replace the open code in this patch.
>>>> Something to keep an eye on: kvm_vcpu_has_events() returns true if pv_unhalted
>>>> is set, and pv_unhalted is only cleared on transitions KVM_MP_STATE_RUNNABLE.
>>>> If the guest initiates a spurious wakeup, pv_unhalted could be left set in
>>>> perpetuity.
>>> Oh, yes.
>>> KVM_HC_KICK_CPU is allowed in TDX guests.
> And a clever guest can send a REMRD IPI.
>
>>> The change below looks good to me.
>>>
>>> One minor issue is when guest initiates a spurious wakeup, pv_unhalted is
>>> left set, then later when the guest want to halt the vcpu, in
>>> __kvm_emulate_halt(), since pv_unhalted is still set and the state will not
>>> transit to KVM_MP_STATE_HALTED.
>>> But I guess it's guests' responsibility to not initiate spurious wakeup,
>>> guests need to bear the fact that HLT could fail due to a previous
>>> spurious wakeup?
>> Just found a patch set for fixing the issue.
> FWIW, Jim's series doesn't address spurious wakeups per se, it just ensures
> pv_unhalted is cleared when transitioning to RUNNING.  If the vCPU is already
> RUNNING, __apic_accept_irq() will set pv_unhalted and nothing will clear it
> until the next transition to RUNNING (which implies at least an attempted
> transition away from RUNNING).
>
Indeed.

I am wondering why KVM doesn't clear pv_unhalted before the vcpu entering guest?
Is the additional memory access a concern or is there some other reason?



