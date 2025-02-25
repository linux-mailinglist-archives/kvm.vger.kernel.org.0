Return-Path: <kvm+bounces-39163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD57A44AE0
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 19:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A57E423B56
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66E61ACEC9;
	Tue, 25 Feb 2025 18:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="cGGbVrVF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF6940C03;
	Tue, 25 Feb 2025 18:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740509339; cv=none; b=WGMKdvTmSjcKHZnTXxKSu/iMMme5SU5Qj9hEUusuTX/mVboLUbDpSlyG0t5/vDmrQlvivDdCTrrLlfQ6X4aJbziR/xV2xVjeqw/nzCfb+/sPWgHTQDBnVcNlrYExOyhO5/SILsonOU//gx6Q1+PG56fvjLQl6qQO9yxIhAqfEnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740509339; c=relaxed/simple;
	bh=yuRBvBwOpg/sdV5toKUnRBTRqO+iwOgkuAWGgoZ+lCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e4x8R4+KpVs+MX9PVQxRafQ4VIE9uDCoaZG2xJdlulUEEA5oghvw5K51txj/bO69GvZLXeJqD/8p2fn22wSD5ckBWZ5CHH8OVoXLnl4CQZMI2UQGOKWTHH25Ut3eRvfn3zsim/FfO8qpk+9HlQlLI8tMaeoO1B2n1Qj5fqj8MBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=cGGbVrVF; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 51PImOPF1393317
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 25 Feb 2025 10:48:25 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 51PImOPF1393317
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025021701; t=1740509308;
	bh=lOaHIa4gftkNKgg9tMYjkTVsHhe2Qgo6b9c5Nd5MpZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cGGbVrVFvYRyfj/S4Rfl7BdQbO6LoMkR3iO4bu3V3a5W8ARxe4PU6PLjvGmMI8GMk
	 wdltWJFQrfA9QAMrOwHdlRAJybc/zhSggfTQiGVpIzDTm9oLfxYMbq9csCDS2W+ykg
	 K7trt9AdGETNOqekahQEwG457Sc1+ARfs25WPe6QBTsPV4HMdbA7gkwqjfpwIInSII
	 wo4mG7mRhe9aF5Xq70HDQ/obetNE4eYcxvB5McVkEfO/cknDX/DtiW6S5++xobpMFA
	 8aE2DNG6k1/sKlVuUoGzfXX0lqi+2cNKdvCwb5R9l13r91wZLPaMncvqyjrVA3hNLL
	 5FjOYN73ehS7g==
Message-ID: <035769d2-e9ed-4bd4-86d0-6a4c011d07aa@zytor.com>
Date: Tue, 25 Feb 2025 10:48:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/27] Enable FRED with KVM VMX
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
        pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <22d4574b-7e2d-4cd8-91bd-f5208e82369e@zytor.com>
 <Z73gxklugkYpwJiZ@google.com>
 <b1f0f8f3-515f-4fde-b779-43ef93484ab3@zytor.com>
 <Z73_TwUgIsceWyzQ@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <Z73_TwUgIsceWyzQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/2025 9:35 AM, Sean Christopherson wrote:
> On Tue, Feb 25, 2025, Xin Li wrote:
>> On 2/25/2025 7:24 AM, Sean Christopherson wrote:
>>> On Tue, Feb 18, 2025, Xin Li wrote:
>>>> On 9/30/2024 10:00 PM, Xin Li (Intel) wrote:
>>>> While I'm waiting for the CET patches for native Linux and KVM to be
>>>> upstreamed, do you think if it's worth it for you to take the cleanup
>>>> and some of the preparation patches first?
>>>
>>> Yes, definitely.  I'll go through the series and see what I can grab now.
>>
>> I planned to do a rebase and fix the conflicts due to the reordering.
>> But I'm more than happy you do a first round.
> 
> For now, I'm only going to grab these:
> 
>    KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM
>    KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
>    KVM: x86: Use a dedicated flow for queueing re-injected exceptions
> 
> and the WRMSRNS patch.  I'll post (and apply, if it looks good) the entry/exit
> pairs patch separately.
> 
> Easiest thing would be to rebase when all of those hit kvm-x86/next.

Excellent!


> 
>> BTW, if you plan to take
>> 	KVM: VMX: Virtualize nested exception tracking
> 
> I'm not planning on grabbing this in advance of the FRED series, especially if
> it's adding new uAPI.  The code doesn't need to exist without FRED, and doesn't
> really make much sense to readers without the context of FRED.

Sounds reasonable.

> 
>>>> Top of my mind are:
>>>>       KVM: x86: Use a dedicated flow for queueing re-injected exceptions
>>>>       KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
>>>>       KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM
> 
> As above, I'll grab these now.
> 
>>>>       KVM: nVMX: Add a prerequisite to existence of VMCS fields
>>>>       KVM: nVMX: Add a prerequisite to SHADOW_FIELD_R[OW] macros
> 
> Unless there's a really, really good reason to add precise checking, I strongly
> prefer to skip these entirely.
> 

They are to make kvm-unit-tests happy, as if we have a ground rule, it's
clear that we don't need them.

They can be used to detect whether an OS is running on a VMM or bare
metal, but do we really care the difference? -- We probably care if we
live in a virtual reality ;-)

>>>>
>>>> Then specially, the nested exception tracking patch seems a good one as
>>>> Chao Gao suggested to decouple the nested tracking from FRED:
>>>>       KVM: VMX: Virtualize nested exception tracking
>>>>
>>>> Lastly the patches to add support for the secondary VM exit controls might
>>>> go in early as well:
>>>>       KVM: VMX: Add support for the secondary VM exit controls
>>>>       KVM: nVMX: Add support for the secondary VM exit controls
> 
> Unless there's another feature on the horizon that depends on secondary exit controls,
> (and y'all will be posted patches soon), I'd prefer just grab these in the FRED
> series.  With the pairs check prep work out of the way, adding support for the
> new controls should be very straightforward, and shouldn't conflict with anything.

NP.

Thanks!
     Xin


