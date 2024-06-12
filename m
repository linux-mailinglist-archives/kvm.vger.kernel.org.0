Return-Path: <kvm+bounces-19447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDA4905344
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DAFDB216EA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 13:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A473179675;
	Wed, 12 Jun 2024 13:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Usxm4G/p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAED1D54B;
	Wed, 12 Jun 2024 13:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718197608; cv=none; b=KjTAMHZdM4c7h3r1+/h6JoLwoyw8FfqzOjAukvdcXUDV7nlF45NyppBIGpwTG1dOvV6KGGJEV65Xb7vws+ls/R+D6mUWKK+ZrSj63Dx41qJiqbzsoeg3kCNYVmmXZf5FhRZEEzwGsNYngxDZny8PZD8/7CjO//leELlF4a3AOkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718197608; c=relaxed/simple;
	bh=aIayRRsQaPA/oqt1m3vRxSNmBQNMixeu/uWFnr2hb9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p+ZRnnfAQve6nadc/dAu9PX0fNjzqNUN/eHogFBuvBpcIUxOspg0qU9/+yPJCeaItQKyWdJ6+/FlcYEzJ9AVS8enb377EapYVtWCh4Rn+cnwVkmTgJXmJ6lkfABB+fKbChUIHYgonuu5O6TGpKrIhxieXJAZB3F8Re81ecW7v1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Usxm4G/p; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718197606; x=1749733606;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aIayRRsQaPA/oqt1m3vRxSNmBQNMixeu/uWFnr2hb9o=;
  b=Usxm4G/phZQxxYegJaLchXxnbXYDMObQs0hfED0849AvKGuhsVFoUdLP
   Zi/kVhVRb9ACDtrL6ATo/deGudJoRDSdjcrLjYWtyw1gS+UMgbQzBwv8k
   JYj0gnWprHMKDsm1FvLHQOGtVMInRsbPI1SG/yDNzo6XM9rrmJZ6OEeGg
   wmjQ4pUm9qv9NfyF+NMTiyYv13kHpU8jT1HRt1Da0WDiFQcVQx8Jnc3Tg
   xMA6BHerRbKw5h5YCgTyx/52MoAemLTbzwqb+fUp1IBvZFQZNn2GE1+Ge
   Se6jLU/+iqxAXvtxzzBbC9OBry1wHdrADlI8htABX7Jtav+87S8ZSZ06M
   g==;
X-CSE-ConnectionGUID: NBiRkOZoTgKUPKO9lscGaA==
X-CSE-MsgGUID: t/OBqNjyTXexmVwU3uC1Pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="15190825"
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="15190825"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 06:06:45 -0700
X-CSE-ConnectionGUID: +VOr4MHiRouuDc5MeUp1LQ==
X-CSE-MsgGUID: 1J7nmcFhTHSAKfh7h9oYhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="44722784"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.224.116]) ([10.124.224.116])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 06:06:43 -0700
Message-ID: <f4029895-01c2-453a-9104-71475cd821ab@linux.intel.com>
Date: Wed, 12 Jun 2024 21:06:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 116/130] KVM: TDX: Silently discard SMI request
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
 Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
 <ZiJ3Krs_HoqdfyWN@google.com>
 <aefee0c0-6931-4677-932e-e61db73b63a2@linux.intel.com>
 <CABgObfb9DC744cQeaDeP5hbKhgVisCvxBew=pCP5JB6U1=oz-A@mail.gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CABgObfb9DC744cQeaDeP5hbKhgVisCvxBew=pCP5JB6U1=oz-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/11/2024 10:11 PM, Paolo Bonzini wrote:
> On Tue, Jun 11, 2024 at 3:18 PM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>>>    }
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>>>> index ed46e7e57c18..4f3b872cd401 100644
>>>> --- a/arch/x86/kvm/vmx/main.c
>>>> +++ b/arch/x86/kvm/vmx/main.c
>>>> @@ -283,6 +283,43 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
>>>>       vmx_msr_filter_changed(vcpu);
>>>>    }
>>>>
>>>> +#ifdef CONFIG_KVM_SMM
>>>> +static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>>>> +{
>>>> +    if (is_td_vcpu(vcpu))
>>>> +            return tdx_smi_allowed(vcpu, for_injection);
>>> Adding stubs for something that TDX will never support is silly.  Bug the VM and
>>> return an error.
>>>
>>>        if (KVM_BUG_ON(is_td_vcpu(vcpu)))
>>>                return -EIO;
>> is_td_vcpu() is defined in tdx.h.
>> Do you mind using open code to check whether the VM is TD in vmx.c?
>> "vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM"
> I'd move it to some place that main.c can see.

is_td_vcpu() can be seen in main.c


>   Or vmx.c as Sean says
> below, but I am not sure I like the idea too much.

Which you may not like? Remove the vt_* wrapper or use KVM_BUG_ON()?

>
> Paolo
>
>>> And I wouldn't even bother with vt_* wrappers, just put that right in vmx_*().
>>> Same thing for everything below.
> If it's a KVM_BUG_ON()
>


