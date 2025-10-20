Return-Path: <kvm+bounces-60480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A64BEF6E1
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:11:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD5773A52A4
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1A72D46DD;
	Mon, 20 Oct 2025 06:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lel4D+yE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4D02D1F61;
	Mon, 20 Oct 2025 06:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760940628; cv=none; b=PEiSpqRlFemQJi5Y4qcgiG5vSS8za/L4I5ZUqdgTWzr1+AHRsWTbJo+n+yHK8lNq83tEu+/EDYa6lpNscfp/D98FgPZ6Pc5J+ciJmk5l6kiEgmiZTwl302vjdWP/VeO9KzRN9DBloQ9lrJCM8MM+QX5Mgbgg0eN/CXQ1WEKGK3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760940628; c=relaxed/simple;
	bh=zKX6e/aPVzdbKYjY+PArPnedG80o7VOUx0Bjzuw3Whs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Btu0I/NuComOE3QgKeWYNycm6vydP8U9jxIix3G+DtGPi18SHQyY+kSxszo8+dAa11TI1xm2YVl/2zJveowgAMmF509a7c48PAlHFceaBaqiqMhK8f8kXpBgGDxwJ+dF5Wy8Blx5zb2qENxmTdnu3JZMBAULK7I/dT0FDL3XRx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lel4D+yE; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760940626; x=1792476626;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zKX6e/aPVzdbKYjY+PArPnedG80o7VOUx0Bjzuw3Whs=;
  b=Lel4D+yE4SSywoQyesE4ZNB4j9PzgKtXXV96ULimgPs7B0wiAOiqtvCL
   mAPcVQ9VMREMGo6LoyxT73tk5sKiL34UDD19yu3PB8Q9Z4T9Qudn64L4H
   cL9J6edPA0G/4cepRpxoHT9QwJ5J7dLSWThgRRCItccfmGAoL2vKR0cXe
   DN2vzRXZhb35Igd7pPFs7m9nP1A1jAGJefxeNdz4pzi3RRE/OmoxeA8op
   O7HF7yQ+V2WhA2Ow9riZpqDmtfzupcNxofnPDZcBnmEcBVBSeK/Tuu0gL
   gI9maUPDeh18rs/79sCVDQPWRux9GZQEIgK6VwBbPvn5oQGJlnGTd53GG
   A==;
X-CSE-ConnectionGUID: sGVqX451RwKJ5/7IMJgVKQ==
X-CSE-MsgGUID: APtIHmZ1TIiCZc/U8gUdYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11587"; a="85674158"
X-IronPort-AV: E=Sophos;i="6.19,242,1754982000"; 
   d="scan'208";a="85674158"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2025 23:10:17 -0700
X-CSE-ConnectionGUID: 0KdWHuIDQr6JIP6KPTPuWQ==
X-CSE-MsgGUID: OQy5l2V/S5CoEMFWBMUSuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,242,1754982000"; 
   d="scan'208";a="183269313"
Received: from unknown (HELO [10.238.2.123]) ([10.238.2.123])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2025 23:10:15 -0700
Message-ID: <0a49bd9b-e4d8-42eb-854c-e8730b5a58b7@intel.com>
Date: Mon, 20 Oct 2025 14:10:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way
 out to KVM
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
 <20251016182148.69085-3-seanjc@google.com>
 <46eb76240a29cb81b6a8aa41016466810abef559.camel@intel.com>
 <aPJ8A8u8zIvp-wB4@google.com>
 <38ac916f7c3ae7520708f37389f5524d9278c648.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <38ac916f7c3ae7520708f37389f5524d9278c648.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/2025 4:58 AM, Huang, Kai wrote:
> On Fri, 2025-10-17 at 10:25 -0700, Sean Christopherson wrote:
>> On Fri, Oct 17, 2025, Kai Huang wrote:
>>> On Thu, 2025-10-16 at 11:21 -0700, Sean Christopherson wrote:
>>>> WARN if KVM observes a SEAMCALL VM-Exit while running a TD guest, as the
>>>> TDX-Module is supposed to inject a #UD, per the "Unconditionally Blocked
>>>> Instructions" section of the TDX-Module base specification.
>>>>
>>>> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>> ---
>>>>   arch/x86/kvm/vmx/tdx.c | 3 +++
>>>>   1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>>> index 097304bf1e1d..ffcfe95f224f 100644
>>>> --- a/arch/x86/kvm/vmx/tdx.c
>>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>>> @@ -2148,6 +2148,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>>>>   		 * - If it's not an MSMI, no need to do anything here.
>>>>   		 */
>>>>   		return 1;
>>>> +	case EXIT_REASON_SEAMCALL:
>>>> +		WARN_ON_ONCE(1);
>>>> +		break;
>>>>
>>>
>>> While this exit should never happen from a TDX guest, I am wondering why
>>> we need to explicitly handle the SEAMCALL?  E.g., per "Unconditionally
>>> Blocked Instructions" ENCLS/ENCLV are also listed, therefore
>>> EXIT_REASON_ELCLS/ENCLV should never come from a TDX guest either.
>>
>> Good point.  SEAMCALL was obviously top of mind, I didn't think about all the
>> other exits that should be impossible.
>>
>> I haven't looked closely, at all, but I wonder if we can get away with this?
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 097304bf1e1d..4c68444bd673 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -2149,6 +2149,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>>                   */
>>                  return 1;
>>          default:
>> +               /* All other known exits should be handled by the TDX-Module. */
>> +               WARN_ON_ONCE(exit_reason.basic <= c);
>>                  break;
>>          }
> 
> Not 100% sure, but should be fine?  Needs more second eyes here.
> 
> E.g., when a new module feature makes another exit reason possible then
> presumably we need explicit opt-in to that feature.
> 
> Don't quite follow 'exit_reason.basic <= c' part, though.  Maybe we can
> just unconditional WARN_ON_ONCE()?
> 
> Or we can do things similar to VMX:
> 
>          vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>                      exit_reason.full);
> 
> Or just get rid of this patch :-)

I agree to it.

WARN_ON_ONCE() seems not provide more information except that we can 
identify quickly there is TDX module bug when it gets hit.

But it's not too hard to get these information from the 
KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON with vp_enter_ret in data[0].

And if we add WARN_ON_ONCE() here, we need to evaluate if it needs to 
update "EXIT_REASON_TDCALL" everytime a new EXIT reason is introduced.
e.g., currently the largest exit reason number defined in SDM is 79 (for 
WRMSRLIST) and it is actually handled by TDX module and KVM cannot 
receive it from a TD vcpu.

