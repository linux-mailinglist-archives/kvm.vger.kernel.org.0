Return-Path: <kvm+bounces-11100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E09B872D83
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 04:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C42DE1F26020
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 03:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B587C14AA0;
	Wed,  6 Mar 2024 03:28:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC64913AE2;
	Wed,  6 Mar 2024 03:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709695735; cv=none; b=EiQqaV11GsAO4MBW0uQAhFBO5n4f/eVoAICVg+I4WF6aIhovJLmlj2ShS6byxZFyLjxepCCzd43rB5YsziJsAItsX4WISHb4G9wxz98Ra/OH41pQyP44FzLEBXmbB1cyYmNGMEh1S46ku0R/e5LgJtuhByhNLYUhkc8m2x2L3JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709695735; c=relaxed/simple;
	bh=GGQf/qr075ECyEnMvmwHfFhNfOw7/FeOEawrUy7BtaQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=i/ERGGDS7wATZ0gSVbf1jVntrKs6faUBWO8n6x94ZZjj7gWc0RaYq+bkh0UZnOcsB4Ijq2GE6ORMV3PGOnJ5UOY7yd2l5+HCEGSjN4SEI7h+9MBMfKQ9DwOIakqXoZrDs9K81hgq3P417AvedA2prBRW5kbo0q28KcR0illWfRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Ax++jx4udlvPwUAA--.32675S3;
	Wed, 06 Mar 2024 11:28:49 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhPr4udlyftOAA--.23378S3;
	Wed, 06 Mar 2024 11:28:46 +0800 (CST)
Subject: Re: [PATCH v6 7/7] Documentation: KVM: Add hypercall for LoongArch
To: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240302082532.1415200-1-maobibo@loongson.cn>
 <20240302084724.1415344-1-maobibo@loongson.cn>
 <846a5e46-4e8f-4f73-ac5b-323e78ec1bb1@xen0n.name>
 <853f2909-e455-bd1c-c6a4-6a13beb37125@loongson.cn>
 <ec871702-388d-4a29-aec1-5cd6d1de6d0a@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <7079bf3b-a7af-7cab-be78-3de1081649e1@loongson.cn>
Date: Wed, 6 Mar 2024 11:28:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ec871702-388d-4a29-aec1-5cd6d1de6d0a@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhPr4udlyftOAA--.23378S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKw4DAFWrZr1rXFWUtF1kJFc_yoWfCr47pF
	95Ga4xtrWkJryxAw12gw1UXry2yr18Jw1UXrn5JFy8Aws8Zr1aqr42qF1Y9F1kGr48Ar1j
	qr4UXry7uw15A3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8HKZJUUUU
	U==



On 2024/3/6 上午2:26, WANG Xuerui wrote:
> On 3/4/24 17:10, maobibo wrote:
>> On 2024/3/2 下午5:41, WANG Xuerui wrote:
>>> On 3/2/24 16:47, Bibo Mao wrote:
>>>> [snip]
>>>> +Querying for existence
>>>> +======================
>>>> +
>>>> +To find out if we're running on KVM or not, cpucfg can be used with 
>>>> index
>>>> +CPUCFG_KVM_BASE (0x40000000), cpucfg range between 0x40000000 - 
>>>> 0x400000FF
>>>> +is marked as a specially reserved range. All existing and future 
>>>> processors
>>>> +will not implement any features in this range.
>>>> +
>>>> +When Linux is running on KVM, cpucfg with index CPUCFG_KVM_BASE 
>>>> (0x40000000)
>>>> +returns magic string "KVM\0"
>>>> +
>>>> +Once you determined you're running under a PV capable KVM, you can 
>>>> now use
>>>> +hypercalls as described below.
>>>
>>> So this is still the approach similar to the x86 CPUID-based 
>>> implementation. But here the non-privileged behavior isn't specified 
>>> -- I see there is PLV checking in Patch 3 but it's safer to have the 
>>> requirement spelled out here too.
>>>
>>> But I still think this approach touches more places than strictly 
>>> needed. As it is currently the case in 
>>> arch/loongarch/kernel/cpu-probe.c, the FEATURES IOCSR is checked for 
>>> a bit IOCSRF_VM that already signifies presence of a hypervisor; if 
>>> this information can be interpreted as availability of the HVCL 
>>> instruction (which I suppose is the case -- a hypervisor can always 
>>> trap-and-emulate in case HVCL isn't provided by hardware), here we 
>>> can already start making calls with HVCL.
>>>
>>> We can and should define a uniform interface for probing the 
>>> hypervisor kind, similar to the centrally-managed RISC-V SBI 
>>> implementation ID registry [1]: otherwise future non-KVM hypervisors 
>>> would have to
>>>
>>> 1. somehow pretend they are KVM and eventually fail to do so, leading 
>>> to subtle incompatibilities,
>>> 2. invent another way of probing for their existence,
>>> 3. piggy-back on the current KVM definition, which is inelegant 
>>> (reading the LoongArch-KVM-defined CPUCFG leaf only to find it's not 
>>> KVM) and utterly makes the definition here *not* KVM-specific.
>>>
>>> [1]: 
>>> https://github.com/riscv-non-isa/riscv-sbi-doc/blob/v2.0/src/ext-base.adoc 
>>>
>>>
>> Sorry, I know nothing about riscv. Can you describe how 
>> sbi_get_mimpid() is implemented in detailed? Is it a simple library or 
>> need trap into secure mode or need trap into hypervisor mode?
> 
> For these simple interfaces you can expect trivial implementation. See 
> for example [OpenSBI]'s respective code.
> 
> [OpenSBI]: 
> https://github.com/riscv-software-src/opensbi/blob/v1.4/lib/sbi/sbi_ecall.c#L29-L34 
> 
> 
>>> My take on this:
>>>
>>> To check if we are running on Linux KVM or not, first check IOCSR 0x8 
>>> (``LOONGARCH_IOCSR_FEATURES``) for bit 11 (``IOCSRF_VM``); we are 
>>> running under a hypervisor if the bit is set. Then invoke ``HVCL 0`` 
>>> to find out the hypervisor implementation ID; a return value in 
>>> ``$a0`` of 0x004d564b (``KVM\0``) means Linux KVM, in which case the 
>>> rest of the convention applies.
>>>
>> I do not think so. `HVCL 0` requires that hypercall ABIs need be 
>> unified for all hypervisors. Instead it is not necessary, each 
>> hypervisor can has its own hypercall ABI.
> 
> I don't think agreeing upon the ABI of HVCL 0 is going to affect ABI of 
> other hypercalls. Plus, as long as people don't invent something that 
> they think is smart and deviate from the platform calling convention, 
> I'd expect every hypervisor to have identical ABI apart from the exact 
> HVCL operation ID chosen.
> 
>>>> +
>>>> +KVM hypercall ABI
>>>> +=================
>>>> +
>>>> +Hypercall ABI on KVM is simple, only one scratch register a0 (v0) 
>>>> and at most
>>>> +five generic registers used as input parameter. FP register and 
>>>> vector register
>>>> +is not used for input register and should not be modified during 
>>>> hypercall.
>>>> +Hypercall function can be inlined since there is only one scratch 
>>>> register.
>>>
>>> It should be pointed out explicitly that on hypercall return all 
>> Well, return value description will added. What do think about the 
>> meaning of return value for KVM_HCALL_FUNC_PV_IPI hypercall?  The 
>> number of CPUs with IPI delivered successfully like kvm x86 or simply 
>> success/failure?
>>> architectural state except ``$a0`` is preserved. Or is the whole 
>>> ``$a0 - $t8`` range clobbered, just like with Linux syscalls?
>>>
>> what is advantage with $a0 - > $t8 clobbered?
> 
> Because then a hypercall is going to behave identical as an ordinary C 
> function call, which is easy for people and compilers to understand.
> 
If you really understand detailed behavior about hypercall/syscall, the 
conclusion may be different.

If T0 - T8 is clobbered with hypercall instruction, hypercall caller 
need save clobbered register, now hypercall exception save/restore all 
the registers during VM exits. If so, hypercall caller need not save 
general registers and it is not necessary scratched for hypercall ABI.

Until now all the discussion the macro level, no detail code level.

Can you show me some example code where T0-T8 need not save/restore 
during LoongArch hypercall exception?

Regards
Bibo Mao

>> It seems that with linux Loongarch syscall, t0--t8 are clobber rather 
>> than a0-t8. Am I wrong?
> 
> You're right, my memory has faded a bit. But I think my reasoning still 
> holds.
> 
>>>> +
>>>> +The parameters are as follows:
>>>> +
>>>> +        ========    ================    ================
>>>> +    Register    IN            OUT
>>>> +        ========    ================    ================
>>>> +    a0        function number        Return code
>>>> +    a1        1st parameter        -
>>>> +    a2        2nd parameter        -
>>>> +    a3        3rd parameter        -
>>>> +    a4        4th parameter        -
>>>> +    a5        5th parameter        -
>>>> +        ========    ================    ================
>>>> +
>>>> +Return codes can be as follows:
>>>> +
>>>> +    ====        =========================
>>>> +    Code        Meaning
>>>> +    ====        =========================
>>>> +    0        Success
>>>> +    -1        Hypercall not implemented
>>>> +    -2        Hypercall parameter error
>>>
>>> What about re-using well-known errno's, like -ENOSYS for "hypercall 
>>> not implemented" and -EINVAL for "invalid parameter"? This could save 
>>> people some hair when more error codes are added in the future.
>>>
>> No, I do not think so. Here is hypercall return value, some OS need 
>> see it. -ENOSYS/-EINVAL may be not understandable for non-Linux OS.
> 
> As long as you accept the associated costs (documentation, potential 
> mapping back-and-forth, proper conveyance of information etc.) I have no 
> problem with that either.
> 
>>>> +    ====        =========================
>>>> +
>>>> +KVM Hypercalls Documentation
>>>> +============================
>>>> +
>>>> +The template for each hypercall is:
>>>> +1. Hypercall name
>>>> +2. Purpose
>>>> +
>>>> +1. KVM_HCALL_FUNC_PV_IPI
>>>> +------------------------
>>>> +
>>>> +:Purpose: Send IPIs to multiple vCPUs.
>>>> +
>>>> +- a0: KVM_HCALL_FUNC_PV_IPI
>>>> +- a1: lower part of the bitmap of destination physical CPUIDs
>>>> +- a2: higher part of the bitmap of destination physical CPUIDs
>>>> +- a3: the lowest physical CPUID in bitmap
>>>
>>> "CPU ID", instead of "CPUID" for clarity: I suppose most people 
>>> reading this also know about x86, so "CPUID" could evoke the wrong 
>>> intuition.
>>>
>> Both "CPU core id" or "CPUID" are ok for me since there is csr 
>> register named LOONGARCH_CSR_CPUID already.
> 
> I was suggesting to minimize confusion even at theoretical level, 
> because you cannot assume anything about your readers. Feel free to 
> provide extra info (e.g. the "CPU core ID" you suggested) as long as it 
> helps to resolve any potential ambiguity / confusion.
> 
>>> This function is equivalent to the C signature "void hypcall(int 
>>> func, u128 mask, int lowest_cpu_id)", which I think is fine, but one 
>>> can also see that the return value description is missing.
>>>
>> Sure, the return value description will added.
>>
>> And it is not equivalent to the C signature "void hypcall(int func, 
>> u128 mask, int lowest_cpu_id)". int/u128/stucture is not permitted 
>> with hypercall ABI, all parameter is "unsigned long".
> 
> I was talking about the ABI in a C perspective, and the register usage 
> is identical. You can define the KVM hypercall ABI however you want but 
> having some nice analogy/equivalence would help a lot, especially for 
> people not already familiar with all the details.
> 


