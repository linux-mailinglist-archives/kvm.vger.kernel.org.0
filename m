Return-Path: <kvm+bounces-64916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D538EC90A2A
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 03:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F1347348389
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 02:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3865427AC31;
	Fri, 28 Nov 2025 02:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQp2X6+B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903A61E7C18;
	Fri, 28 Nov 2025 02:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764296918; cv=none; b=pSWxZbfksSsHWW0ODy7SbmzeA1/iuxjVCtMg1cVQy3yf9mvt4q5RdHcWBT2GugQcTVkWpnCaOstMT3EGLMUikQBhsV0jLbrQVf3+3Ei22er5XgyqEd4eTrVtA0OMVB6pYBAp/hviq29b7cuAXhBn0JNiTrz7FECdRoZv9UWCEIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764296918; c=relaxed/simple;
	bh=/HjtqXfCqsAKCoCv0qEGUunf0cxzQvr9PqFXd/cNbk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pe43x63P90j0sNULSU8oBup4/JukzZEsqLkIJEFSFw7oH9gYm3vfS6jHZn1rAMcTGTexMh8xhHRNb1gxR8kEYsxtvVPHmI4+zaTSoCEFWVFoRJRgNvI8bGGPO107NI8qGJNodldqQbKA+1QSF5qWetiHUcVv51JqbQh19syDB/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQp2X6+B; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764296916; x=1795832916;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/HjtqXfCqsAKCoCv0qEGUunf0cxzQvr9PqFXd/cNbk0=;
  b=kQp2X6+B8msFaycgFbXmhztVJXtKIWGj4fzvUxN7bFpIcEwWBk2ZAt6C
   bsBX4H6WJ3/NMbH2/FDloiIHl+VFkg6QezTPHLuAbPtYi30vokRxcsNu4
   c6qZIeAqMr7mzokMDDgesPYTqmNglrxbqFLByzzh7XQE8RM3d7IE2c7Mx
   GEkDYxC6HFwcyDidxA/OxcIGEaK0FaIDUPsgRryCYHeqzZUOZXRiYSGuX
   KtdZwSPu9tE9RG63iSLH5cvrY8dU3UinMNIHGLzqA9hFl2HBehoZx4HEr
   h+ZE7epujaZxYeeI2P1Uw2kzeJ3u6Kzp6s1S+ssmmUWR6c9mkfDHeKLRc
   A==;
X-CSE-ConnectionGUID: JitPDHNWRR+BPdPGbH6Krg==
X-CSE-MsgGUID: /P3S0XJiQfGBlfEEhUnzTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="66229577"
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="66229577"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 18:28:35 -0800
X-CSE-ConnectionGUID: 2mwpRCyfQ5ifeiejOB6g7A==
X-CSE-MsgGUID: dJmRNK0tR3+2b7I4YZBuEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="193156307"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 18:28:30 -0800
Message-ID: <2d50eba2-c308-45a2-90ec-e0c3bcbb4db0@intel.com>
Date: Fri, 28 Nov 2025 10:28:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/split_lock: Don't try to handle user split lock
 in TDX guest
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 Reinette Chatre <reinette.chatre@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, chao.p.peng@intel.com
References: <20251126100205.1729391-1-xiaoyao.li@intel.com>
 <20251126100205.1729391-2-xiaoyao.li@intel.com>
 <lvobu4gpfsjg63syubgy2jwcja72folflrst7bu2eqv6rhaqre@ttbkykphu32f>
 <33fe9716-ef3b-42f3-9806-4bd23fed6949@intel.com>
 <qvsi3xht4kn3iwkx5xw2p7zsq4cvpg4xhq3ra52fe34xjpixfo@fsgchsobc343>
 <0f8983e9-0e23-4a05-8015-de6e2218d8a5@intel.com>
 <f2hkqt5xtmej7cfnuytigcfszr3qja4l6ywww4qrqxjbqmlko2@r75b6deae2hd>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f2hkqt5xtmej7cfnuytigcfszr3qja4l6ywww4qrqxjbqmlko2@r75b6deae2hd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/2025 12:16 AM, Kiryl Shutsemau wrote:
> On Thu, Nov 27, 2025 at 10:00:58AM +0800, Xiaoyao Li wrote:
>> On 11/26/2025 9:35 PM, Kiryl Shutsemau wrote:
>>> On Wed, Nov 26, 2025 at 08:17:18PM +0800, Xiaoyao Li wrote:
>>>> On 11/26/2025 7:25 PM, Kiryl Shutsemau wrote:
>>>>> On Wed, Nov 26, 2025 at 06:02:03PM +0800, Xiaoyao Li wrote:
>>>>>> When the host enables split lock detection feature, the split lock from
>>>>>> guests (normal or TDX) triggers #AC. The #AC caused by split lock access
>>>>>> within a normal guest triggers a VM Exit and is handled in the host.
>>>>>> The #AC caused by split lock access within a TDX guest does not trigger
>>>>>> a VM Exit and instead it's delivered to the guest self.
>>>>>>
>>>>>> The default "warning" mode of handling split lock depends on being able
>>>>>> to temporarily disable detection to recover from the split lock event.
>>>>>> But the MSR that disables detection is not accessible to a guest.
>>>>>>
>>>>>> This means that TDX guests today can not disable the feature or use
>>>>>> the "warning" mode (which is the default). But, they can use the "fatal"
>>>>>> mode.
>>>>>>
>>>>>> Force TDX guests to use the "fatal" mode.
>>>>>>
>>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>> ---
>>>>>>     arch/x86/kernel/cpu/bus_lock.c | 17 ++++++++++++++++-
>>>>>>     1 file changed, 16 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
>>>>>> index 981f8b1f0792..f278e4ea3dd4 100644
>>>>>> --- a/arch/x86/kernel/cpu/bus_lock.c
>>>>>> +++ b/arch/x86/kernel/cpu/bus_lock.c
>>>>>> @@ -315,9 +315,24 @@ void bus_lock_init(void)
>>>>>>     	wrmsrq(MSR_IA32_DEBUGCTLMSR, val);
>>>>>>     }
>>>>>> +static bool split_lock_fatal(void)
>>>>>> +{
>>>>>> +	if (sld_state == sld_fatal)
>>>>>> +		return true;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * TDX guests can not disable split lock detection.
>>>>>> +	 * Force them into the fatal behavior.
>>>>>> +	 */
>>>>>> +	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
>>>>>> +		return true;
>>>>>> +
>>>>>> +	return false;
>>>>>> +}
>>>>>> +
>>>>>>     bool handle_user_split_lock(struct pt_regs *regs, long error_code)
>>>>>>     {
>>>>>> -	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
>>>>>> +	if ((regs->flags & X86_EFLAGS_AC) || split_lock_fatal())
>>>>>>     		return false;
>>>>>
>>>>> Maybe it would be cleaner to make it conditional on
>>>>> cpu_model_supports_sld instead of special-casing TDX guest?
>>>>>
>>>>> #AC on any platfrom when we didn't asked for it suppose to be fatal, no?
>>>>
>>>> But TDX is the only one has such special non-architectural behavior.
>>>>
>>>> For example, for normal VMs under KVM, the behavior is x86 architectural.
>>>> MSR_TEST_CTRL is not accessible to normal VMs, and no split lock #AC will be
>>>> delivered to the normal VMs because it's handled by KVM.
>>>
>>> How does it contradict what I suggested?
>>>
>>> For both normal VMs and TDX guest, cpu_model_supports_sld will not be
>>> set to true. So check for cpu_model_supports_sld here is going to be
>>> NOP, unless #AC actually delivered, like we have in TDX case. Handling
>>> it as fatal is sane behaviour in such case regardless if it TDX.
>>>
>>> And we don't need to make the check explicitly about TDX guest.
>>
>> Well, it depends on how defensive we would like to be, and whether to
>> specialize or commonize the issue.
>>
>> Either can work. If the preference and agreement are to commonize the issue,
>> I can do it in v2. And in this direction, what should we do with the patch
>> 2? just drop it since it's specialized for TDX ?
> 
> I am not sure. Leaving it as produces produces false messages which is
> not good, but not critical.
> 
> Maybe just clear X86_FEATURE_BUS_LOCK_DETECT and stop pretending we
> control split-lock behaviour from the guest?

By clearing X86_FEATURE_BUS_LOCK_DETECT, the TDX guest log doens't print 
anything about split lock detection. But the TDX guest is still possible 
to get #AC on split locks, which seems no good as well.

More, it's overkill to clear X86_FEATURE_BUS_LOCK_DETECT. Clearing it 
means TDX guest cannot use X86_FEATURE_BUS_LOCK_DETECT to detect the bus 
lock happens from the guest userspace, even when the host doesn't enable 
split lock detection. For example, on cloud environment, if the 
customers want to run their legacy workload that can generate split 
locks, the CSP would have to disable slit lock detection in the host but 
use bus lock VM exit to catch the bus lock in the TDX guest. In this 
case, TDX guest is free to use X86_FEATURE_BUS_LOCK_DETECT and it works 
as expected.




