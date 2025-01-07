Return-Path: <kvm+bounces-34668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F04BAA0395E
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 09:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 358A97A23D9
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 08:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946701DFE29;
	Tue,  7 Jan 2025 08:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="anq/c82a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CC41DDA2D;
	Tue,  7 Jan 2025 08:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736237373; cv=none; b=fRqHwu1Y5y3FEDME7rCldJAu2bVziFCKewOKRQ/QlkmHvf85J5HzvnXV8bTqHg7rDS+C1NzWzTb2rvJZKA1QP8vk2QakKo3d3NT6sg/4BIyDCqQmKVWOz0Pvzu7Ph7Fl0hGV725sMcHgEHF4EnJkq/LAPTX7h7t3UjngweZiTkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736237373; c=relaxed/simple;
	bh=QIM/sWV7ZOnj6KBpVYEahXewHQYEMzzrUfpQzc/48Mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ir+j7hrJuJtzMn9bJdXe/MGieA1lOX8Pws4ztoChk6jhqs2I/DY7rPvrhbgZFoxWvo7t6UZ+FtBfPZr9L4QrofEEAHPxrOgziEsmYBjWvZ2YfD6OFbx663ekFSOwkhgfu1ZsrjXqDP/uf0AFRQotUqnoJ9bM3cMP06AxCUSX0rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=anq/c82a; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736237372; x=1767773372;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QIM/sWV7ZOnj6KBpVYEahXewHQYEMzzrUfpQzc/48Mc=;
  b=anq/c82a6uc2dYHw70D7OFJ786yzfC1ZWW9Xr7fTeD51DeY5smXoPD6y
   +V2kaq7Ohq/hIhGVASVA7UVYrs/2+zjOAmKe7GsYyuPaA99sP9qGkEYIq
   XiRxpEvBnU1URkX0pYC/51+5/Dn8fUqfE4ai31KoYKMQx2YTdSiiu9OtB
   zYqrijnUJIHmw8wf2SQCsaWsd80l1ZxC2KQy33lcL+LI+jQZq9aooNADZ
   axdrCCRwhdt0ywe3VDPQl9KJlsOOL1ia43H6oWjUgRE2H23ScIzBG6+9b
   GPEn/PzhICIHqgh1rB1rq0HpdIXXjm0Cmgi6SNFee7gSpykZxYUYWygaF
   A==;
X-CSE-ConnectionGUID: jIHBJlzkTLmhoBkyBHObrA==
X-CSE-MsgGUID: SolkQR8dSPCyRW5esEOeHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36302192"
X-IronPort-AV: E=Sophos;i="6.12,295,1728975600"; 
   d="scan'208";a="36302192"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 00:09:31 -0800
X-CSE-ConnectionGUID: FkpwPXMOQo+7wsmKgvhgIw==
X-CSE-MsgGUID: QEUsvA6kQVKVTe/Il0l1pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107319156"
Received: from unknown (HELO [10.238.1.62]) ([10.238.1.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 00:09:27 -0800
Message-ID: <ef29512a-2ca0-47c4-8b6e-6553bce1e273@linux.intel.com>
Date: Tue, 7 Jan 2025 16:09:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
To: Chao Gao <chao.gao@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
 <CAGtprH9UBZe64zay0HjZRg5f--xM85Yt+jYijKZw=sfxRH=2Ow@mail.gmail.com>
 <fc6294b7-f648-4daa-842d-0b74211f8c3a@linux.intel.com>
 <CAGtprH_JYQvBimSLkb3qgshPbrUE+Z2dTz8vEvEwV1v+OMD6Mg@mail.gmail.com>
 <Z3xqBpIgU6-OGWaj@google.com> <Z3yeWvg+JZ//wbLZ@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z3yeWvg+JZ//wbLZ@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/7/2025 11:24 AM, Chao Gao wrote:
>> Note, kvm_use_posted_timer_interrupt() uses a heuristic of HLT/MWAIT interception
>> being disabled to detect that it's worth trying to post a timer interrupt, but off
>> the top of my head I'm pretty sure that's unnecessary and pointless.  The
> Commit 1714a4eb6fb0 gives an explanation:
>
>    if only some guests isolated and others not, they would not
>    have any benefit from posted timer interrupts, and at the same time lose
>    VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
>    returns true and therefore forces kvm_can_use_hv_timer() to false.
Userspace uses KVM_CAP_X86_DISABLE_EXITS to enable mwait_in_guest or/and
hlt_in_guest for non TDX guest. The code doesn't work for TDX guests.
- Whether mwait in guest is allowed for TDX depends on the cpuid
   configuration in TD_PARAMS, not the capability of physical cpu checked by
   kvm_can_mwait_in_guest().
- hlt for TDX is via TDVMCALL, i.e. hlt_in_guest should always be false
   for TDX guests.

For TDX guests, not sure if it worths to fix kvm_{mwait,hlt}_in_guest()
or add special handling (i.e., skip checking mwait/hlt in guest) because
VMX preemption timer can't be used anyway, in order to allow housekeeping
CPU to post timer interrupt for TDX vCPUs when nohz_full is configured
after changing APICv active to true.


>
>> "vcpu->mode == IN_GUEST_MODE" is super cheap, and I can't think of any harm in
>> posting the time interrupt if the target vCPU happens to be in guest mode even
>> if the host wasn't configured just so.
>>
>>> Another scenario I was thinking of was hrtimer expiry during vcpu exit
>>> being handled in KVM/userspace, which will cause timer interrupt
>>> injection after the next exit [1] delaying timer interrupt to guest.
>> No, the IRQ won't be delayed.  Expiration from the hrtimer callback will set
>> KVM_REQ_UNBLOCK, which will prevent actually entering the guest (see the call
>> to kvm_request_pending() in kvm_vcpu_exit_request()).
>>
>>> This scenario is not specific to TDX VMs though.
>>>
>>> [1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/x86.c?h=kvm-coco-queue#n11263


