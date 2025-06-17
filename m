Return-Path: <kvm+bounces-49779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F03AADDFDA
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E061C189C696
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2E52957CE;
	Tue, 17 Jun 2025 23:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="aDeNDSM/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3E52F5312;
	Tue, 17 Jun 2025 23:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750204714; cv=none; b=eKEfuBe3fbm5Wz0FGtC+GVwMeXx0RMfDHY+i+P4cEP4sxsIN0/jLS2VZbCoi07+59rF5KMC96CxbO6gGcY333cG42YeTS0JqqS1JmASTiWQOUAE0VtF/i9Ip2mOqvhA/V2/uZseKwRSnl0sYMtJg2uSNqyNiA2MlkWHGqloQOIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750204714; c=relaxed/simple;
	bh=HX7MRmvcueVaUvj7JXHNiLlhLnfO6RxJ38NDNr9sqP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jocVM3TH/SDxx25OMSa1mxnVe0/YRbgoHq1LvnQO1qmTTUsQqO9KLlf/l+iu5sRR8kTd7Kp5bU56oZEzQ9g2H8Ot7bP2dSPqIwPsKxWuePcE3fYMGGfyG1q6rOQee0zjzdT4xfjU8cjXxW+/PexNlJYjXSasxjqCWOxz2TmklpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=aDeNDSM/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55HNvpMa1322113
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 17 Jun 2025 16:57:52 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55HNvpMa1322113
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750204673;
	bh=p6620qyWPj8fispzJPyWEIIXAvYBb2yN8x8fXfVE1Zs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aDeNDSM/EmMYFj1+3TS9c+ylkfuq8Na6duujVkfhStdPdSPeY9MXE0iDTExzzGD2Y
	 ix/IUEKvilyOHWcfZiSR+m2Uimt2s7owv1vk95BtjgLpKweQgkguPL9qQg4O0547FA
	 WV+UFriHRGDlgSzxOptSsfaqjpvribFTeFkv1DqDibStUrKm5ivOVSs/9gUtNX6Bp7
	 oIMnFR5IxqMtMJWB1qp9zF2dGuTjUXLcFS6vleOcfwJBbomLlR+u7prPhW3H/C3GB6
	 2yAJVU4kExlA4cJXDCEvJHrDX5Fg7AXS+euaqIgvP6GbGhv+bqo+O7cMrWPvHgUdEv
	 aw0FbRFgjQ1Zg==
Message-ID: <25896236-de8d-4bd9-8a27-da407c0e5a38@zytor.com>
Date: Tue, 17 Jun 2025 16:57:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
To: Sean Christopherson <seanjc@google.com>,
        Sohil Mehta <sohil.mehta@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        peterz@infradead.org, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
References: <20250617073234.1020644-1-xin@zytor.com>
 <20250617073234.1020644-2-xin@zytor.com>
 <fa32b6e9-b087-495a-acf1-a28cfed7e28a@intel.com>
 <aFHUZh6koJyVi3p-@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aFHUZh6koJyVi3p-@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/2025 1:47 PM, Sean Christopherson wrote:
> On Tue, Jun 17, 2025, Sohil Mehta wrote:
>> On 6/17/2025 12:32 AM, Xin Li (Intel) wrote:
>>> diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/uapi/asm/debugreg.h
>>> index 0007ba077c0c..8f335b9fa892 100644
>>> --- a/arch/x86/include/uapi/asm/debugreg.h
>>> +++ b/arch/x86/include/uapi/asm/debugreg.h
>>> @@ -15,7 +15,12 @@
>>>      which debugging register was responsible for the trap.  The other bits
>>>      are either reserved or not of interest to us. */
>>>   
>>> -/* Define reserved bits in DR6 which are always set to 1 */
>>> +/*
>>> + * Define reserved bits in DR6 which are set to 1 by default.
>>> + *
>>> + * This is also the DR6 architectural value following Power-up, Reset or INIT.
>>> + * Some of these reserved bits can be set to 0 by hardware or software.
>>> + */
>>>   #define DR6_RESERVED	(0xFFFF0FF0)
>>>   
>>
>> Calling this "RESERVED" and saying some bits can be modified seems
>> inconsistent. These bits may have been reserved in the past, but they
>> are no longer so.
>>
>> Should this be renamed to DR6_INIT or DR6_RESET? Your commit log also
>> says so in the beginning:
>>
>>     "Initialize DR6 by writing its architectural reset value to ensure
>>      compliance with the specification."
>>
>> That way, it would also match the usage in code at
>> initialize_debug_regs() and debug_read_reset_dr6().
>>
>> I can understand if you want to minimize changes and do this in a
>> separate patch, since this would need to be backported.
> 
> Yeah, the name is weird, but IMO DR6_INIT or DR6_RESET aren't great either.  I'm
> admittedly very biased, but I think KVM's DR6_ACTIVE_LOW better captures the
> behavior of the bits.  E.g. even if bits that are currently reserved become defined
> in the future, they'll still need to be active low so as to be backwards compatible
> with existing software.

"active low" seems to better indicate how the bits are or will be used.


> Note, DR6_VOLATILE and DR6_FIXED_1 aren't necessarily aligned with the current
> architectural definitions (I haven't actually checked),

I'm not sure what do you mean by "architectural definitions" here.

However because zeroing DR6 leads to different DR6 values depending on
whether the CPU supports BLD:

   1) On CPUs with BLD support, DR6 becomes 0xFFFF07F0 (bit 11, DR6.BLD,
      is cleared).

   2) On CPUs without BLD, DR6 becomes 0xFFFF0FF0.

DR6_FIXED_1, if it is still defined to include all bits that can't be
cleared, is a constant value only on a *specific* CPU architecture,
i.e., it is not a constant value on all CPU implementations.


> rather they are KVM's
> view of the world, i.e. what KVM supports from a virtualization perspective.

So KVM probably should expose the fixed 1s in DR6 to the guest depending 
on which features, such as BLD or RTM, are enabled and visible to the
guest or not?

(Sorry I haven't looked into how the macro DR6_FIXED_1 is used in KVM,
maybe it's already used in such a way)

> 
> Ah, and now I see that DR6_RESERVED is an existing #define in a uAPI header (Xin
> said there were a few, but I somehow missed them earlier).  Maybe just leave that
> thing alone, but update the comment to state that it's a historical wart?  And
> then put DR6_ACTIVE_LOW and other macros in arch/x86/include/asm/debugreg.h?

Yeah, kind of what I'm thinking too :)

I want to replace all DR6_RESERVED uses in kernel with a better name,
and DR6_ACTIVE_LOW is a good candidate.  (Ofc DR6_RESERVED will be kept
in the uAPI header).

BTW, I think you want to move DR macros to 
arch/x86/include/asm/debugreg.h from arch/x86/include/asm/kvm_host.h.


> 
> /*
>   * DR6_ACTIVE_LOW combines fixed-1 and active-low bits.
>   * We can regard all the bits in DR6_FIXED_1 as active_low bits;
>   * they will never be 0 for now, but when they are defined
>   * in the future it will require no code change.
>   *
>   * DR6_ACTIVE_LOW is also used as the init/reset value for DR6.
>   */
> #define DR6_ACTIVE_LOW	0xffff0ff0
> #define DR6_VOLATILE	0x0001e80f
> #define DR6_FIXED_1	(DR6_ACTIVE_LOW & ~DR6_VOLATILE)


