Return-Path: <kvm+bounces-10779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FACF86FCC6
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 10:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA4A62843DF
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF421B814;
	Mon,  4 Mar 2024 09:10:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D6317748;
	Mon,  4 Mar 2024 09:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709543443; cv=none; b=olqQRATMsjXvlcjmf+9XTS4Fwcz67/24epRdp4iwUwJKbSlVFLhurgxQz0/roIM2tyjTyNkYoH/T+lABCT2jcGpr9VVaHgLY3lFDq9MXscnq0grY6jRuhf9z8IWePOY0RJQgApbCLCT3X2nSY2gD7907rm2P/LZkczseDg2+bZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709543443; c=relaxed/simple;
	bh=ecM/81Cew8tqn1qCfB4rRxkuZKAfzrO6bVDhJi9nQiQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=K33QCj1Y0iLQzTb6bZJGGY1eEKp0FOYpCTXl9bWQmHn3ZhSy3LrZ19AgtVbXTPSnwngjp2iSl9wgnn8WA6COqZ/IJgO4XgxlZ/yMZFqNB2NvQIO99F9UkJsd7HeM0L7tSaTs5YyvzuPwdAePexWRHDb2Y/+/cO9c9BhJz6m4+DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Cx77sIkOVlYwQUAA--.30763S3;
	Mon, 04 Mar 2024 17:10:32 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxXRMEkOVl7rBNAA--.9973S3;
	Mon, 04 Mar 2024 17:10:30 +0800 (CST)
Subject: Re: [PATCH v6 7/7] Documentation: KVM: Add hypercall for LoongArch
To: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240302082532.1415200-1-maobibo@loongson.cn>
 <20240302084724.1415344-1-maobibo@loongson.cn>
 <846a5e46-4e8f-4f73-ac5b-323e78ec1bb1@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <853f2909-e455-bd1c-c6a4-6a13beb37125@loongson.cn>
Date: Mon, 4 Mar 2024 17:10:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <846a5e46-4e8f-4f73-ac5b-323e78ec1bb1@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxXRMEkOVl7rBNAA--.9973S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3WryUJr1UGrWfuFW7tF43urX_yoWfZw4fpF
	95J3s7KrWkJryxAw17tw1UXryYyr1xJ3W7Jr18tFy8Jw45Zr1aqr4jqrn093W8Gw48AF1j
	qr4jqr17ur1UA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jepB-UUUUU=



On 2024/3/2 下午5:41, WANG Xuerui wrote:
> On 3/2/24 16:47, Bibo Mao wrote:
>> Add documentation topic for using pv_virt when running as a guest
>> on KVM hypervisor.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   Documentation/virt/kvm/index.rst              |  1 +
>>   .../virt/kvm/loongarch/hypercalls.rst         | 79 +++++++++++++++++++
>>   Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>>   3 files changed, 90 insertions(+)
>>   create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>>   create mode 100644 Documentation/virt/kvm/loongarch/index.rst
>>
>> diff --git a/Documentation/virt/kvm/index.rst 
>> b/Documentation/virt/kvm/index.rst
>> index ad13ec55ddfe..9ca5a45c2140 100644
>> --- a/Documentation/virt/kvm/index.rst
>> +++ b/Documentation/virt/kvm/index.rst
>> @@ -14,6 +14,7 @@ KVM
>>      s390/index
>>      ppc-pv
>>      x86/index
>> +   loongarch/index
>>      locking
>>      vcpu-requests
>> diff --git a/Documentation/virt/kvm/loongarch/hypercalls.rst 
>> b/Documentation/virt/kvm/loongarch/hypercalls.rst
>> new file mode 100644
>> index 000000000000..1679e48d67d2
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
>> @@ -0,0 +1,79 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +===================================
>> +The LoongArch paravirtual interface
>> +===================================
>> +
>> +KVM hypercalls use the HVCL instruction with code 0x100, and the 
>> hypercall
>> +number is put in a0 and up to five arguments may be placed in a1-a5, the
>> +return value is placed in v0 (alias with a0).
> 
> Just say a0: the name v0 is long deprecated (has been the case ever 
> since LoongArch got mainlined).
> 
Sure, will modify since you are compiler export :)

>> +
>> +The code for that interface can be found in arch/loongarch/kvm/*
>> +
>> +Querying for existence
>> +======================
>> +
>> +To find out if we're running on KVM or not, cpucfg can be used with 
>> index
>> +CPUCFG_KVM_BASE (0x40000000), cpucfg range between 0x40000000 - 
>> 0x400000FF
>> +is marked as a specially reserved range. All existing and future 
>> processors
>> +will not implement any features in this range.
>> +
>> +When Linux is running on KVM, cpucfg with index CPUCFG_KVM_BASE 
>> (0x40000000)
>> +returns magic string "KVM\0"
>> +
>> +Once you determined you're running under a PV capable KVM, you can 
>> now use
>> +hypercalls as described below.
> 
> So this is still the approach similar to the x86 CPUID-based 
> implementation. But here the non-privileged behavior isn't specified -- 
> I see there is PLV checking in Patch 3 but it's safer to have the 
> requirement spelled out here too.
> 
> But I still think this approach touches more places than strictly 
> needed. As it is currently the case in 
> arch/loongarch/kernel/cpu-probe.c, the FEATURES IOCSR is checked for a 
> bit IOCSRF_VM that already signifies presence of a hypervisor; if this 
> information can be interpreted as availability of the HVCL instruction 
> (which I suppose is the case -- a hypervisor can always trap-and-emulate 
> in case HVCL isn't provided by hardware), here we can already start 
> making calls with HVCL.
> 
> We can and should define a uniform interface for probing the hypervisor 
> kind, similar to the centrally-managed RISC-V SBI implementation ID 
> registry [1]: otherwise future non-KVM hypervisors would have to
> 
> 1. somehow pretend they are KVM and eventually fail to do so, leading to 
> subtle incompatibilities,
> 2. invent another way of probing for their existence,
> 3. piggy-back on the current KVM definition, which is inelegant (reading 
> the LoongArch-KVM-defined CPUCFG leaf only to find it's not KVM) and 
> utterly makes the definition here *not* KVM-specific.
> 
> [1]: 
> https://github.com/riscv-non-isa/riscv-sbi-doc/blob/v2.0/src/ext-base.adoc
> 
Sorry, I know nothing about riscv. Can you describe how sbi_get_mimpid() 
is implemented in detailed? Is it a simple library or need trap into 
secure mode or need trap into hypervisor mode?

> My take on this:
> 
> To check if we are running on Linux KVM or not, first check IOCSR 0x8 
> (``LOONGARCH_IOCSR_FEATURES``) for bit 11 (``IOCSRF_VM``); we are 
> running under a hypervisor if the bit is set. Then invoke ``HVCL 0`` to 
> find out the hypervisor implementation ID; a return value in ``$a0`` of 
> 0x004d564b (``KVM\0``) means Linux KVM, in which case the rest of the 
> convention applies.
> 
I do not think so. `HVCL 0` requires that hypercall ABIs need be unified 
for all hypervisors. Instead it is not necessary, each hypervisor can 
has its own hypercall ABI.

>> +
>> +KVM hypercall ABI
>> +=================
>> +
>> +Hypercall ABI on KVM is simple, only one scratch register a0 (v0) and 
>> at most
>> +five generic registers used as input parameter. FP register and 
>> vector register
>> +is not used for input register and should not be modified during 
>> hypercall.
>> +Hypercall function can be inlined since there is only one scratch 
>> register.
> 
> It should be pointed out explicitly that on hypercall return all 
Well, return value description will added. What do think about the 
meaning of return value for KVM_HCALL_FUNC_PV_IPI hypercall?  The number 
of CPUs with IPI delivered successfully like kvm x86 or simply 
success/failure?
> architectural state except ``$a0`` is preserved. Or is the whole ``$a0 - 
> $t8`` range clobbered, just like with Linux syscalls?
> 
what is advantage with $a0 - > $t8 clobbered?

It seems that with linux Loongarch syscall, t0--t8 are clobber rather 
than a0-t8. Am I wrong?

>> +
>> +The parameters are as follows:
>> +
>> +        ========    ================    ================
>> +    Register    IN            OUT
>> +        ========    ================    ================
>> +    a0        function number        Return code
>> +    a1        1st parameter        -
>> +    a2        2nd parameter        -
>> +    a3        3rd parameter        -
>> +    a4        4th parameter        -
>> +    a5        5th parameter        -
>> +        ========    ================    ================
>> +
>> +Return codes can be as follows:
>> +
>> +    ====        =========================
>> +    Code        Meaning
>> +    ====        =========================
>> +    0        Success
>> +    -1        Hypercall not implemented
>> +    -2        Hypercall parameter error
> 
> What about re-using well-known errno's, like -ENOSYS for "hypercall not 
> implemented" and -EINVAL for "invalid parameter"? This could save people 
> some hair when more error codes are added in the future.
> 
No, I do not think so. Here is hypercall return value, some OS need see 
it. -ENOSYS/-EINVAL may be not understandable for non-Linux OS.

>> +    ====        =========================
>> +
>> +KVM Hypercalls Documentation
>> +============================
>> +
>> +The template for each hypercall is:
>> +1. Hypercall name
>> +2. Purpose
>> +
>> +1. KVM_HCALL_FUNC_PV_IPI
>> +------------------------
>> +
>> +:Purpose: Send IPIs to multiple vCPUs.
>> +
>> +- a0: KVM_HCALL_FUNC_PV_IPI
>> +- a1: lower part of the bitmap of destination physical CPUIDs
>> +- a2: higher part of the bitmap of destination physical CPUIDs
>> +- a3: the lowest physical CPUID in bitmap
> 
> "CPU ID", instead of "CPUID" for clarity: I suppose most people reading 
> this also know about x86, so "CPUID" could evoke the wrong intuition.
> 
Both "CPU core id" or "CPUID" are ok for me since there is csr register 
named LOONGARCH_CSR_CPUID already.

> This function is equivalent to the C signature "void hypcall(int func, 
> u128 mask, int lowest_cpu_id)", which I think is fine, but one can also 
> see that the return value description is missing.
> 
Sure, the return value description will added.

And it is not equivalent to the C signature "void hypcall(int func, u128 
mask, int lowest_cpu_id)". int/u128/stucture is not permitted with 
hypercall ABI, all parameter is "unsigned long".

Regards
Bibo Mao

>> +
>> +The hypercall lets a guest send multicast IPIs, with at most 128
>> +destinations per hypercall.  The destinations are represented by a 
>> bitmap
>> +contained in the first two arguments (a1 and a2). Bit 0 of a1 
>> corresponds
>> +to the physical CPUID in the third argument (a3), bit 1 corresponds 
>> to the
>> +physical ID a3+1, and so on.
>> diff --git a/Documentation/virt/kvm/loongarch/index.rst 
>> b/Documentation/virt/kvm/loongarch/index.rst
>> new file mode 100644
>> index 000000000000..83387b4c5345
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/loongarch/index.rst
>> @@ -0,0 +1,10 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=========================
>> +KVM for LoongArch systems
>> +=========================
>> +
>> +.. toctree::
>> +   :maxdepth: 2
>> +
>> +   hypercalls.rst
> 


