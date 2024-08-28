Return-Path: <kvm+bounces-25225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA75961DB5
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 06:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25B39285457
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 04:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407E53D96A;
	Wed, 28 Aug 2024 04:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="qPaBI5dk"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A6F145FFF;
	Wed, 28 Aug 2024 04:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.82.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724820308; cv=none; b=Nii3eKCCcbJmp4MVUQW5Uzf84cI1o8E0+xaWOuX56ZmqmFEtYhGa7ulDEEvb11EVlRBa/O4XXjZZcPJ1W0QXrwDDt5OM8QMjX5l9Z61iSYlqKCgMSyDQ+fKRlSUmsLSZ8ZFgBIvMhy4vTKsI6UFSfkaSf9s6oMVWceVdi7XD+r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724820308; c=relaxed/simple;
	bh=5EN/U7WmEttawiw0CzO4Sg2M++/dOYJaQjMmsL3uuHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=frpqsC4tSgxBWFbPmQMFa5JTSfnHTJec42qNNGCDBvRxH+o/552Ypy3pQfWtyO6i4YjTf+JMqVx4+fKY6UAmLAJ7ZJ9n1LWMKiCTr6OkAVgOp078OrBB5iiqcKbVIQch5Q9qAazcoknkoAmUaPocUfunTpD+F8i+3m3bdsLWgIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=qPaBI5dk; arc=none smtp.client-ip=15.184.82.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1724820296;
	bh=UEItIcioovAv5Ci1nI+0tCkJjAr8eoE2rmmGVwKzl4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=qPaBI5dk33cvA6fX0oXgndQSffdlKOY3PI8jhJi4ERqXHKSXdqoyojxND/eC4F/Z3
	 z/GSz/KkQcGoPN7xZxYpTttXeBQp305Rx0xJ61JzTFhZ2yUEWUye0JC6TJdb9UZEC+
	 ESxKbHFClUpcFhCzSS1/yfMrvuT9phcHIuqVNS3o=
X-QQ-mid: bizesmtp80t1724820289tg8p19uc
X-QQ-Originating-IP: qn/TZvWSOmwD8CP02Kvtub3A0oRA/VUMXkfWHBbXxuY=
Received: from [10.20.53.89] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 28 Aug 2024 12:44:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2718462679820382276
Message-ID: <F7E458B77CD6B30A+554b04f1-7716-4a81-8755-c5a4f138ae71@uniontech.com>
Date: Wed, 28 Aug 2024 12:44:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
To: maobibo <maobibo@loongson.cn>, Zenghui Yu <zenghui.yu@linux.dev>,
 Dandan Zhang <zhangdandan@uniontech.com>
Cc: pbonzini@redhat.com, corbet@lwn.net, zhaotianrui@loongson.cn,
 chenhuacai@kernel.org, kernel@xen0n.name, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, guanwentao@uniontech.com,
 baimingcong@uniontech.com, Xianglai Li <lixianglai@loongson.cn>,
 Mingcong Bai <jeffbai@aosc.io>
References: <DE6B1B9EAC9BEF4C+20240826054727.24166-1-zhangdandan@uniontech.com>
 <804a804c-f62d-4814-a174-51d19e3ea094@linux.dev>
 <29999cfc-6ec1-d881-277a-19f51f5c7b96@loongson.cn>
From: WangYuli <wangyuli@uniontech.com>
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <29999cfc-6ec1-d881-277a-19f51f5c7b96@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

Thanks for review.

We'll get these problems sorted out as soon as possible.

On 2024/8/28 09:07, maobibo wrote:
> Zenghui,
>
> On 2024/8/27 1:00AM, Zenghui Yu wrote:
>> [ Trivial comments inline.  You can feel free to ignore them since I
>>    know almost nothing about loongarch. ]
> Thanks for reviewing the hypercall document, we all know that you have 
> strong background knowledge with both kernel and architecture.
>
>>
>> On 2024/8/26 13:47, Dandan Zhang wrote:
>>> From: Bibo Mao <maobibo@loongson.cn>
>>>
>>> Add documentation topic for using pv_virt when running as a guest
>>> on KVM hypervisor.
>>>
>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>>> Co-developed-by: Mingcong Bai <jeffbai@aosc.io>
>>> Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
>>> Link: 
>>> https://lore.kernel.org/all/5c338084b1bcccc1d57dce9ddb1e7081@aosc.io/
>>> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
>>> ---
>>>   Documentation/virt/kvm/index.rst              |  1 +
>>>   .../virt/kvm/loongarch/hypercalls.rst         | 86 
>>> +++++++++++++++++++
>>>   Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>>>   MAINTAINERS                                   |  1 +
>>>   4 files changed, 98 insertions(+)
>>>   create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>>>   create mode 100644 Documentation/virt/kvm/loongarch/index.rst
>>>
>>> diff --git a/Documentation/virt/kvm/index.rst 
>>> b/Documentation/virt/kvm/index.rst
>>> index ad13ec55ddfe..9ca5a45c2140 100644
>>> --- a/Documentation/virt/kvm/index.rst
>>> +++ b/Documentation/virt/kvm/index.rst
>>> @@ -14,6 +14,7 @@ KVM
>>>      s390/index
>>>      ppc-pv
>>>      x86/index
>>> +   loongarch/index
>>>        locking
>>>      vcpu-requests
>>> diff --git a/Documentation/virt/kvm/loongarch/hypercalls.rst 
>>> b/Documentation/virt/kvm/loongarch/hypercalls.rst
>>> new file mode 100644
>>> index 000000000000..58168dc7166c
>>> --- /dev/null
>>> +++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
>>> @@ -0,0 +1,86 @@
>>> +.. SPDX-License-Identifier: GPL-2.0
>>> +
>>> +===================================
>>> +The LoongArch paravirtual interface
>>> +===================================
>>> +
>>> +KVM hypercalls use the HVCL instruction with code 0x100 and the 
>>> hypercall
>>> +number is put in a0. Up to five arguments may be placed in 
>>> registers a1 - a5.
>>> +The return value is placed in v0 (an alias of a0).
>>> +
>>> +Source code for this interface can be found in arch/loongarch/kvm*.
>>> +
>>> +Querying for existence
>>> +======================
>>> +
>>> +To determine if the host is running on KVM, we can utilize the 
>>> cpucfg()
>>> +function at index CPUCFG_KVM_BASE (0x40000000).
>>> +
>>> +The CPUCPU_KVM_BASE range, spanning from 0x40000000 to 0x400000FF, The
>>> +CPUCPU_KVM_BASE range between 0x40000000 - 0x400000FF is marked as 
>>> reserved.
>>
>> What is CPUCPU_KVM_BASE? Grepping it in the code shows nothing.
>>
>>> +Consequently, all current and future processors will not implement any
>>> +feature within this range.
>>> +
>>> +On a KVM-virtualized Linux system, a read operation on cpucfg() at 
>>> index
>>> +CPUCFG_KVM_BASE (0x40000000) returns the magic string 'KVM\0'.
>>> +
>>> +Once you have determined that your host is running on a 
>>> paravirtualization-
>>> +capable KVM, you may now use hypercalls as described below.
>>> +
>>> +KVM hypercall ABI
>>> +=================
>>> +
>>> +The KVM hypercall ABI is simple, with one scratch register a0 (v0) 
>>> and at most
>>> +five generic registers (a1 - a5) used as input parameters. The FP 
>>> (Floating-
>>> +point) and vector registers are not utilized as input registers and 
>>> must
>>> +remain unmodified during a hypercall.
>>> +
>>> +Hypercall functions can be inlined as it only uses one scratch 
>>> register.
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
>>
>> Please consistently use tab.
>>
>>> +
>>> +The return codes may be one of the following:
>>> +
>>> +    ====        =========================
>>> +    Code        Meaning
>>> +    ====        =========================
>>> +    0        Success
>>> +    -1        Hypercall not implemented
>>> +    -2        Bad Hypercall parameter
>>> +    ====        =========================
>>> +
>>> +KVM Hypercalls Documentation
>>> +============================
>>> +
>>> +The template for each hypercall is as follows:
>>> +
>>> +1. Hypercall name
>>> +2. Purpose
>>> +
>>> +1. KVM_HCALL_FUNC_PV_IPI
>>
>> Is it still a work-in-progress thing? I don't see it in mainline.
> It should be KVM_HCALL_FUNC_IPI here.
>
>>
>>> +------------------------
>>> +
>>> +:Purpose: Send IPIs to multiple vCPUs.
>>> +
>>> +- a0: KVM_HCALL_FUNC_PV_IPI
>>> +- a1: Lower part of the bitmap for destination physical CPUIDs
>>> +- a2: Higher part of the bitmap for destination physical CPUIDs
>>> +- a3: The lowest physical CPUID in the bitmap
>>
>> - Is it a feature that implements IPI broadcast with a PV method?
>> - Don't you need to *at least* specify which IPI to send by issuing this
>>    hypercall?
> Good question. It should be documented here. PV IPI on LoongArch 
> includes both PV IPI multicast sending and PV IPI receiving, and SWI 
> is used for PV IPI inject since there is no VM-exits accessing SWI 
> registers.
>
>>
>> But again, as I said I know nothing about loongarch.  I might have
>> missed some obvious points.
>>
>>> +
>>> +The hypercall lets a guest send multiple IPIs (Inter-Process 
>>> Interrupts) with
>>> +at most 128 destinations per hypercall.The destinations are 
>>> represented in a
>>                                            ^
>> Add a blank space.
>>
>>> +bitmap contained in the first two input registers (a1 and a2).
>>> +
>>> +Bit 0 of a1 corresponds to the physical CPUID in the third input 
>>> register (a3)
>>> +and bit 1 corresponds to the physical CPUID in a3+1 (a4), and so on.
>>
>> This looks really confusing.  "Bit 63 of a1 corresponds to the physical
>> CPUID in a3+63 (a66)"?
> The description is problematic, thanks for pointing it out.
> It should be value of register a3 plus 1, rather than a4, how about 
> *"the physical CPUID in a3 + 1"*  here?
>
> Regards
> Bibo Mao
>>
>> Zenghui
>>
>
>
Thanks
-- 
WangYuli


