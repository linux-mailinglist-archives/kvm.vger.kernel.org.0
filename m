Return-Path: <kvm+bounces-11060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50572872685
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:26:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0681C28763E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0616418E1A;
	Tue,  5 Mar 2024 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="Gj3rJTE4"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ED118AEA;
	Tue,  5 Mar 2024 18:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709663182; cv=none; b=teyp7BtbfllPj8SefF/4qgWQaIVV5fNPBr3yGkcPVet0jGTZZXG6Bti0QlWad04OSpF/DVwOVACafMVaEfB5L70ppw6YLl0rXQiWYEjguf+NJ90GZQwu4PhaO0Vb/8VmDrAzL9RejcEzb/jI3F8cBgQtNnAwpfOFWcL25UCiYYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709663182; c=relaxed/simple;
	bh=WNffBT41r5F0XyJ7MFk8QsD65CMScBYk1QPLYhExK8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZAQUSriV5cSFz+r3lkXmW3xSjebiZNwYVgirgzvdMcT3skEcE4PRzs8yxJ/KY5uulLfCEQeywHCcuU80H767aTVPC6ont3xRarm1tF3Iqs7x+TNjAYEcYZxZupH/rjVTIewTFi70IRPGd4NLKjHHtF144cnMq374GBufNoLWHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=Gj3rJTE4; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1709663171; bh=WNffBT41r5F0XyJ7MFk8QsD65CMScBYk1QPLYhExK8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gj3rJTE4Xx3wNJQce3qkYCM6NYncvK5hc0F86WWBKwv2x62hB2XsL2VccgAK0xs5s
	 BG6+or8HD2sQlbxrbymoHoO5rdAmQfh8Ece349RdQGaJ5L0xKiGew2G03DpbzwAJEh
	 dKrY3/3xm5Olljr7p+9afGsitGUuwP7AGyt9U0AE=
Received: from [IPV6:240e:388:8d00:6500:3d21:65e4:41f4:2696] (unknown [IPv6:240e:388:8d00:6500:3d21:65e4:41f4:2696])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 18FFE60106;
	Wed,  6 Mar 2024 02:26:11 +0800 (CST)
Message-ID: <ec871702-388d-4a29-aec1-5cd6d1de6d0a@xen0n.name>
Date: Wed, 6 Mar 2024 02:26:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] Documentation: KVM: Add hypercall for LoongArch
Content-Language: en-US
To: maobibo <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240302082532.1415200-1-maobibo@loongson.cn>
 <20240302084724.1415344-1-maobibo@loongson.cn>
 <846a5e46-4e8f-4f73-ac5b-323e78ec1bb1@xen0n.name>
 <853f2909-e455-bd1c-c6a4-6a13beb37125@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <853f2909-e455-bd1c-c6a4-6a13beb37125@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/4/24 17:10, maobibo wrote:
> On 2024/3/2 下午5:41, WANG Xuerui wrote:
>> On 3/2/24 16:47, Bibo Mao wrote:
>>> [snip]
>>> +Querying for existence
>>> +======================
>>> +
>>> +To find out if we're running on KVM or not, cpucfg can be used with 
>>> index
>>> +CPUCFG_KVM_BASE (0x40000000), cpucfg range between 0x40000000 - 
>>> 0x400000FF
>>> +is marked as a specially reserved range. All existing and future 
>>> processors
>>> +will not implement any features in this range.
>>> +
>>> +When Linux is running on KVM, cpucfg with index CPUCFG_KVM_BASE 
>>> (0x40000000)
>>> +returns magic string "KVM\0"
>>> +
>>> +Once you determined you're running under a PV capable KVM, you can 
>>> now use
>>> +hypercalls as described below.
>>
>> So this is still the approach similar to the x86 CPUID-based 
>> implementation. But here the non-privileged behavior isn't specified 
>> -- I see there is PLV checking in Patch 3 but it's safer to have the 
>> requirement spelled out here too.
>>
>> But I still think this approach touches more places than strictly 
>> needed. As it is currently the case in 
>> arch/loongarch/kernel/cpu-probe.c, the FEATURES IOCSR is checked for a 
>> bit IOCSRF_VM that already signifies presence of a hypervisor; if this 
>> information can be interpreted as availability of the HVCL instruction 
>> (which I suppose is the case -- a hypervisor can always 
>> trap-and-emulate in case HVCL isn't provided by hardware), here we can 
>> already start making calls with HVCL.
>>
>> We can and should define a uniform interface for probing the 
>> hypervisor kind, similar to the centrally-managed RISC-V SBI 
>> implementation ID registry [1]: otherwise future non-KVM hypervisors 
>> would have to
>>
>> 1. somehow pretend they are KVM and eventually fail to do so, leading 
>> to subtle incompatibilities,
>> 2. invent another way of probing for their existence,
>> 3. piggy-back on the current KVM definition, which is inelegant 
>> (reading the LoongArch-KVM-defined CPUCFG leaf only to find it's not 
>> KVM) and utterly makes the definition here *not* KVM-specific.
>>
>> [1]: 
>> https://github.com/riscv-non-isa/riscv-sbi-doc/blob/v2.0/src/ext-base.adoc
>>
> Sorry, I know nothing about riscv. Can you describe how sbi_get_mimpid() 
> is implemented in detailed? Is it a simple library or need trap into 
> secure mode or need trap into hypervisor mode?

For these simple interfaces you can expect trivial implementation. See 
for example [OpenSBI]'s respective code.

[OpenSBI]: 
https://github.com/riscv-software-src/opensbi/blob/v1.4/lib/sbi/sbi_ecall.c#L29-L34

>> My take on this:
>>
>> To check if we are running on Linux KVM or not, first check IOCSR 0x8 
>> (``LOONGARCH_IOCSR_FEATURES``) for bit 11 (``IOCSRF_VM``); we are 
>> running under a hypervisor if the bit is set. Then invoke ``HVCL 0`` 
>> to find out the hypervisor implementation ID; a return value in 
>> ``$a0`` of 0x004d564b (``KVM\0``) means Linux KVM, in which case the 
>> rest of the convention applies.
>>
> I do not think so. `HVCL 0` requires that hypercall ABIs need be unified 
> for all hypervisors. Instead it is not necessary, each hypervisor can 
> has its own hypercall ABI.

I don't think agreeing upon the ABI of HVCL 0 is going to affect ABI of 
other hypercalls. Plus, as long as people don't invent something that 
they think is smart and deviate from the platform calling convention, 
I'd expect every hypervisor to have identical ABI apart from the exact 
HVCL operation ID chosen.

>>> +
>>> +KVM hypercall ABI
>>> +=================
>>> +
>>> +Hypercall ABI on KVM is simple, only one scratch register a0 (v0) 
>>> and at most
>>> +five generic registers used as input parameter. FP register and 
>>> vector register
>>> +is not used for input register and should not be modified during 
>>> hypercall.
>>> +Hypercall function can be inlined since there is only one scratch 
>>> register.
>>
>> It should be pointed out explicitly that on hypercall return all 
> Well, return value description will added. What do think about the 
> meaning of return value for KVM_HCALL_FUNC_PV_IPI hypercall?  The number 
> of CPUs with IPI delivered successfully like kvm x86 or simply 
> success/failure?
>> architectural state except ``$a0`` is preserved. Or is the whole ``$a0 
>> - $t8`` range clobbered, just like with Linux syscalls?
>>
> what is advantage with $a0 - > $t8 clobbered?

Because then a hypercall is going to behave identical as an ordinary C 
function call, which is easy for people and compilers to understand.

> It seems that with linux Loongarch syscall, t0--t8 are clobber rather 
> than a0-t8. Am I wrong?

You're right, my memory has faded a bit. But I think my reasoning still 
holds.

>>> +
>>> +The parameters are as follows:
>>> +
>>> +        ========    ================    ================
>>> +    Register    IN            OUT
>>> +        ========    ================    ================
>>> +    a0        function number        Return code
>>> +    a1        1st parameter        -
>>> +    a2        2nd parameter        -
>>> +    a3        3rd parameter        -
>>> +    a4        4th parameter        -
>>> +    a5        5th parameter        -
>>> +        ========    ================    ================
>>> +
>>> +Return codes can be as follows:
>>> +
>>> +    ====        =========================
>>> +    Code        Meaning
>>> +    ====        =========================
>>> +    0        Success
>>> +    -1        Hypercall not implemented
>>> +    -2        Hypercall parameter error
>>
>> What about re-using well-known errno's, like -ENOSYS for "hypercall 
>> not implemented" and -EINVAL for "invalid parameter"? This could save 
>> people some hair when more error codes are added in the future.
>>
> No, I do not think so. Here is hypercall return value, some OS need see 
> it. -ENOSYS/-EINVAL may be not understandable for non-Linux OS.

As long as you accept the associated costs (documentation, potential 
mapping back-and-forth, proper conveyance of information etc.) I have no 
problem with that either.

>>> +    ====        =========================
>>> +
>>> +KVM Hypercalls Documentation
>>> +============================
>>> +
>>> +The template for each hypercall is:
>>> +1. Hypercall name
>>> +2. Purpose
>>> +
>>> +1. KVM_HCALL_FUNC_PV_IPI
>>> +------------------------
>>> +
>>> +:Purpose: Send IPIs to multiple vCPUs.
>>> +
>>> +- a0: KVM_HCALL_FUNC_PV_IPI
>>> +- a1: lower part of the bitmap of destination physical CPUIDs
>>> +- a2: higher part of the bitmap of destination physical CPUIDs
>>> +- a3: the lowest physical CPUID in bitmap
>>
>> "CPU ID", instead of "CPUID" for clarity: I suppose most people 
>> reading this also know about x86, so "CPUID" could evoke the wrong 
>> intuition.
>>
> Both "CPU core id" or "CPUID" are ok for me since there is csr register 
> named LOONGARCH_CSR_CPUID already.

I was suggesting to minimize confusion even at theoretical level, 
because you cannot assume anything about your readers. Feel free to 
provide extra info (e.g. the "CPU core ID" you suggested) as long as it 
helps to resolve any potential ambiguity / confusion.

>> This function is equivalent to the C signature "void hypcall(int func, 
>> u128 mask, int lowest_cpu_id)", which I think is fine, but one can 
>> also see that the return value description is missing.
>>
> Sure, the return value description will added.
> 
> And it is not equivalent to the C signature "void hypcall(int func, u128 
> mask, int lowest_cpu_id)". int/u128/stucture is not permitted with 
> hypercall ABI, all parameter is "unsigned long".

I was talking about the ABI in a C perspective, and the register usage 
is identical. You can define the KVM hypercall ABI however you want but 
having some nice analogy/equivalence would help a lot, especially for 
people not already familiar with all the details.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


