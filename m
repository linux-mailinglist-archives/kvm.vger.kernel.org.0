Return-Path: <kvm+bounces-13990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F05A89DBF0
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 720D21C20CD1
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7365912FF70;
	Tue,  9 Apr 2024 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L3b4kJEt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DA97F7CB;
	Tue,  9 Apr 2024 14:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712672108; cv=none; b=cvPqInyibIUpbIPA7qLbnS2TnpeLjgSFcgQJNjARsfkXjp3Go1xc4jYJfA2c4+mGibANhC7MbHopUJvwQ6G0a+WjDqgOJosAByyoJgdsZjMAnfIzdb0NOe1ppfe3CGDpD3ColdXdyi60Ty54tEeKNsTu2SIHbG2HHpLr5bHhQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712672108; c=relaxed/simple;
	bh=w3QKbuBJwcCjbBH7DUcEkVnmAfgOavXXlVQiyGShmdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kATJOSZXtqcqnn7pYUBid2Emo96So2FvF9yvAKL0Ce3KTnih2vK9E+TovGgTUWnSoBp3CvL1xooXAYHEDmR0vHYxwPW5Sk+c+nrLehFXL5Ycp33prDnhjAMnl/I1Qur8R1ed0IIogQ9UKyHsmtWjwqUuIl/zlqEzn2NyX7RwFrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L3b4kJEt; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712672107; x=1744208107;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=w3QKbuBJwcCjbBH7DUcEkVnmAfgOavXXlVQiyGShmdM=;
  b=L3b4kJEtQ/Y6vrZ3zNfm8gXg4On7drW2B27QlZAjnu4byY+YiYP9i7u0
   3BliVqmh+lLAgcwfYw+CcjMY+sVeaUMRYVuHsU1wSiUOi1G5hblLdBbo/
   lfrJCoIk0NlVZjdeMn/a2rYxzyu24/tih+S+tasjmdAArxoPiro7ml1TH
   hmK5BFBS9g75aqEzsy2BIfZ5ogMde/5mGi0aRDcrYApQhISEQoEV4qJih
   HAOG+oxr/YSxkAcE3s7REu9oNRJp5tyDFUiofiEvXhOLjQxvii7MA2i0H
   tMgL/WMoz5VRITp/8Qg17zUqMefgW5/o99PsHbU97lAiPjiFbzvC0+uYL
   Q==;
X-CSE-ConnectionGUID: OnjsjfNsSpWEGfGsu/V8DA==
X-CSE-MsgGUID: rILNYIU1SxSSkShn/lif/w==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18551297"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="18551297"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 07:15:07 -0700
X-CSE-ConnectionGUID: PeNHtEUHSd2WfpwjoOmOBA==
X-CSE-MsgGUID: uwwCQ/OjSJegQna6pmerXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="20699579"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 07:15:03 -0700
Message-ID: <f59ca834-2915-43c2-8bc5-5b83121693d6@intel.com>
Date: Tue, 9 Apr 2024 22:15:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Wei W Wang
 <wei.w.wang@intel.com>, David Skidmore <davidskidmore@google.com>,
 Steve Rutherford <srutherford@google.com>,
 Pankaj Gupta <pankaj.gupta@amd.com>
References: <20240405165844.1018872-1-seanjc@google.com>
 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com>
 <24c80d16-733b-4036-8057-075a0dab3b4d@intel.com>
 <ZhVKIfydhfac9SE4@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZhVKIfydhfac9SE4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/2024 10:01 PM, Sean Christopherson wrote:
> On Tue, Apr 09, 2024, Xiaoyao Li wrote:
>> On 4/9/2024 12:20 AM, Sean Christopherson wrote:
>>> On Sun, Apr 07, 2024, Xiaoyao Li wrote:
>>>> On 4/6/2024 12:58 AM, Sean Christopherson wrote:
>>>>>     - For guest MAXPHYADDR vs. GPAW, rely on KVM_GET_SUPPORTED_CPUID to enumerate
>>>>>       the usable MAXPHYADDR[2], and simply refuse to enable TDX if the TDX Module
>>>>>       isn't compatible.  Specifically, if MAXPHYADDR=52, 5-level paging is enabled,
>>>>>       but the TDX-Module only allows GPAW=0, i.e. only supports 4-level paging.
>>>>
>>>> So userspace can get supported GPAW from usable MAXPHYADDR, i.e.,
>>>> CPUID(0X8000_0008).eaxx[23:16] of KVM_GET_SUPPORTED_CPUID:
>>>>    - if usable MAXPHYADDR == 52, supported GPAW is 0 and 1.
>>>>    - if usable MAXPHYADDR <= 48, supported GPAW is only 0.
>>>>
>>>> There is another thing needs to be discussed. How does userspace configure
>>>> GPAW for TD guest?
>>>>
>>>> Currently, KVM uses CPUID(0x8000_0008).EAX[7:0] in struct
>>>> kvm_tdx_init_vm::cpuid.entries[] of IOCTL(KVM_TDX_INIT_VM) to deduce the
>>>> GPAW:
>>>>
>>>> 	int maxpa = 36;
>>>> 	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
>>>> 	if (entry)
>>>> 		max_pa = entry->eax & 0xff;
>>>>
>>>> 	...
>>>> 	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
>>>> 		return -EINVAL;
>>>> 	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
>>>> 		td_params->eptp_controls |= VMX_EPTP_PWL_5;
>>>> 		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
>>>> 	} else {
>>>> 		td_params->eptp_controls |= VMX_EPTP_PWL_4;
>>>> 	}
>>>>
>>>> The code implies that KVM allows the provided CPUID(0x8000_0008).EAX[7:0] to
>>>> be any value (when 5level ept is supported). when it > 48, configure GPAW of
>>>> TD to 1, otherwise to 0.
>>>>
>>>> However, the virtual value of CPUID(0x8000_0008).EAX[7:0] inside TD is
>>>> always the native value of hardware (for current TDX).
>>>>
>>>> So if we want to keep this behavior, we need to document it somewhere that
>>>> CPUID(0x8000_0008).EAX[7:0] in struct kvm_tdx_init_vm::cpuid.entries[] of
>>>> IOCTL(KVM_TDX_INIT_VM) is only for configuring GPAW, not for userspace to
>>>> configure virtual CPUID value for TD VMs.
>>>>
>>>> Another option is that, KVM doesn't allow userspace to configure
>>>> CPUID(0x8000_0008).EAX[7:0]. Instead, it provides a gpaw field in struct
>>>> kvm_tdx_init_vm for userspace to configure directly.
>>>>
>>>> What do you prefer?
>>>
>>> Hmm, neither.  I think the best approach is to build on Gerd's series to have KVM
>>> select 4-level vs. 5-level based on the enumerated guest.MAXPHYADDR, not on
>>> host.MAXPHYADDR.
>>
>> I see no difference between using guest.MAXPHYADDR (EAX[23:16]) and using
>> host.MAXPHYADDR (EAX[7:0]) to determine the GPAW (and EPT level) for TD
>> guest. The case for TDX diverges from what for non TDX VMs. The value of
>> them passed from userspace can only be used to configure GPAW and EPT level
>> for TD, but won't be reflected in CPUID inside TD.
> 
> But the TDX module will emulate EAX[7:0] to match hardware, no?  Whenever possible,
> the CPUID entries passed to KVM should match the CPUID values that are observed
> by the guest.  E.g. if host.MAXPHYADDR=52, but the CPU only supports 4-level
> paging, then KVM should get host.MAXPHYADDR=52, guest.MAXPHYADDR=48.

side topic: Do we expect KVM to check the input of EAX[7:0] to match 
with hardware value? or a zero value? or both are allowed?

> As I said in my response to Rick:
> 
>   : > An alternative would be to have the KVM API peak at the value, and then
>   : > discard it (not pass the leaf value to the TDX module). Not ideal.
>   :
>   : Heh, I typed up this idea before reading ahead.  This has my vote.  Unless I'm
>   : misreading where things are headed, using guest.MAXPHYADDR to communicate what
>   : is essentially GPAW to the guest is about to become the de facto standard.
>   :
>   : At that point, KVM can basically treat the current TDX module behavior as an
>   : erratum, i.e. discarding guest.MAXPHYADDR becomes a workaround for a "CPU" bug,
>   : not some goofy KVM quirk.

yes, bit [23:16] fits better.

