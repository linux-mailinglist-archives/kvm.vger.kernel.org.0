Return-Path: <kvm+bounces-11113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D64E387326E
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 10:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 140AC1C23EF4
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 09:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4457A5DF21;
	Wed,  6 Mar 2024 09:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="rBzkv6WH"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8623C5DF01;
	Wed,  6 Mar 2024 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709716970; cv=none; b=jIszY+j/M/kP7NZQ113j54l/6cGluj1+dMROzZoBRwpz6yHGELh5v88jBryFvLPoeM6yo/s4UEYHEx+99W84bPuhFn7OSl/QvmMqDPPfornCaXFCMzifU96YIt9gFsFKkZTYro3MJtLy+uXm5zCKglqnZDwieil17uPPxirUnB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709716970; c=relaxed/simple;
	bh=o4WXpLuFlb2On21gYF6e06FQki+re+8xuTwVBSizxMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=swnWBWEqkamfgfUgPw+3EoJitExCJ536ldb1/6JII5lm6BmfJY+KdfZ93H2vamt2wFPtwMg0RcpoqONxWu+TC5aVcDDRxZ+EGfsPcJ0YPrBb7aZrQlNPQxbHzgeotViA8DJUo7cyWwDG1uAgj0R3LjybKT1ijVn9Nis3wnFW1hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=rBzkv6WH; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1709716964; bh=o4WXpLuFlb2On21gYF6e06FQki+re+8xuTwVBSizxMI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rBzkv6WHSyXZIk6znzU7nnLyL4/jck+sMZRhuySYFRLWZKkN1d1KsNE7YUsV8NWoK
	 umxFcxOBgdLaEa1rvbZ520CbIoNR8/RHQG/cdi98q2Tll/TNBWCQER0u0OTXpPmCEc
	 CsAEx0w4+waz8+o8k40rSOV9dqnlRmLpToVMFjRA=
Received: from [IPV6:240e:688:100:1:e42:6442:8662:5647] (unknown [IPv6:240e:688:100:1:e42:6442:8662:5647])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 7524F600CE;
	Wed,  6 Mar 2024 17:22:44 +0800 (CST)
Message-ID: <4039d1ff-8e9f-42cf-a8fa-b326102fcbf5@xen0n.name>
Date: Wed, 6 Mar 2024 17:22:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] Documentation: KVM: Add hypercall for LoongArch
To: maobibo <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240302082532.1415200-1-maobibo@loongson.cn>
 <20240302084724.1415344-1-maobibo@loongson.cn>
 <846a5e46-4e8f-4f73-ac5b-323e78ec1bb1@xen0n.name>
 <853f2909-e455-bd1c-c6a4-6a13beb37125@loongson.cn>
 <ec871702-388d-4a29-aec1-5cd6d1de6d0a@xen0n.name>
 <7079bf3b-a7af-7cab-be78-3de1081649e1@loongson.cn>
Content-Language: en-US
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <7079bf3b-a7af-7cab-be78-3de1081649e1@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/6/24 11:28, maobibo wrote:
> On 2024/3/6 上午2:26, WANG Xuerui wrote:
>> On 3/4/24 17:10, maobibo wrote:
>>> On 2024/3/2 下午5:41, WANG Xuerui wrote:
>>>> On 3/2/24 16:47, Bibo Mao wrote:
>>>>> [snip]
>>>>> +
>>>>> +KVM hypercall ABI
>>>>> +=================
>>>>> +
>>>>> +Hypercall ABI on KVM is simple, only one scratch register a0 (v0) 
>>>>> and at most
>>>>> +five generic registers used as input parameter. FP register and 
>>>>> vector register
>>>>> +is not used for input register and should not be modified during 
>>>>> hypercall.
>>>>> +Hypercall function can be inlined since there is only one scratch 
>>>>> register.
>>>>
>>>> It should be pointed out explicitly that on hypercall return all 
>>> Well, return value description will added. What do think about the 
>>> meaning of return value for KVM_HCALL_FUNC_PV_IPI hypercall?  The 
>>> number of CPUs with IPI delivered successfully like kvm x86 or simply 
>>> success/failure?

I just noticed I've forgotten to comment on this question. FYI, RISC-V 
SBI's equivalent [1] doesn't even indicate errors. And from my 
perspective, we can always add a new hypercall returning more info 
should that info is needed in the future; for now I don't have a problem 
whether the return type is void, bool or number of CPUs that are 
successfully reached.

[1]: 
https://github.com/riscv-non-isa/riscv-sbi-doc/blob/v2.0/src/ext-ipi.adoc

>>>> architectural state except ``$a0`` is preserved. Or is the whole 
>>>> ``$a0 - $t8`` range clobbered, just like with Linux syscalls?
>>>>
>>> what is advantage with $a0 - > $t8 clobbered?
>>
>> Because then a hypercall is going to behave identical as an ordinary C 
>> function call, which is easy for people and compilers to understand.
>>
> If you really understand detailed behavior about hypercall/syscall, the 
> conclusion may be different.
> 
> If T0 - T8 is clobbered with hypercall instruction, hypercall caller 
> need save clobbered register, now hypercall exception save/restore all 
> the registers during VM exits. If so, hypercall caller need not save 
> general registers and it is not necessary scratched for hypercall ABI.
> 
> Until now all the discussion the macro level, no detail code level.
> 
> Can you show me some example code where T0-T8 need not save/restore 
> during LoongArch hypercall exception?

I was emphasizing that consistency is generally good, and yes that's 
"macroscopic" level talk. Of course, the hypercall client code would 
have to do *less* work if *more* registers than the minimum are 
preserved -- if right now everything is already preserved, nothing needs 
to change.

But please also notice that the context switch cost is paid for every 
hypercall, and we can't reduce the number of preserved registers without 
breaking compatibility. So I think we can keep the current 
implementation behavior, but promise less in the spec: this way we'll 
keep the possibility of reducing the context switch overhead.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


