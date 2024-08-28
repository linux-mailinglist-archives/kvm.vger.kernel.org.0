Return-Path: <kvm+bounces-25218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79FAE961B41
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 03:08:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02AE12852CB
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 01:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0041CA8D;
	Wed, 28 Aug 2024 01:07:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A627F11CA0;
	Wed, 28 Aug 2024 01:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807274; cv=none; b=AVKJVybz0nmLn2SuhcYrv5CFqsNw7IuO38Yfm9VixPFF0GBKzKBa2JnpidlIKD8GIC8eD2KsE1ApXdW5mZVfzi3USkga/PE7Cl9mpQ05imqObSjna8kgSn5MI2N3EtTaLeLUK1dUYvQ0jj53a4gkl+QPl47sgN/E62FzDupFPKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807274; c=relaxed/simple;
	bh=nKcdKsFSS+WJ1q91i22amOCmzc4CBR3u4lbnt/wEA8I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=nxiIVutxbuuzt13Bkm4ZjYVgbtRpCS/aE4rps45wbkzGb1gpu4vs//0TnszCRdeyvKzibUFGmoT9Jw8w7DEcF6/oK0Wlz+yjsR+f5Kb1JRfOpMtQMKwuiYw4jHbiKIDGLLPYO+Lu6o3VcAlawfXIv0obxRfIozFA/Dzk2vvFIH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxaZpeeM5mUzwiAA--.32516S3;
	Wed, 28 Aug 2024 09:07:42 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMDxkeFbeM5mywElAA--.26480S3;
	Wed, 28 Aug 2024 09:07:40 +0800 (CST)
Subject: Re: [PATCH v2] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
To: Zenghui Yu <zenghui.yu@linux.dev>,
 Dandan Zhang <zhangdandan@uniontech.com>
Cc: pbonzini@redhat.com, corbet@lwn.net, zhaotianrui@loongson.cn,
 chenhuacai@kernel.org, kernel@xen0n.name, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, guanwentao@uniontech.com,
 wangyuli@uniontech.com, baimingcong@uniontech.com,
 Xianglai Li <lixianglai@loongson.cn>, Mingcong Bai <jeffbai@aosc.io>
References: <DE6B1B9EAC9BEF4C+20240826054727.24166-1-zhangdandan@uniontech.com>
 <804a804c-f62d-4814-a174-51d19e3ea094@linux.dev>
From: maobibo <maobibo@loongson.cn>
Message-ID: <29999cfc-6ec1-d881-277a-19f51f5c7b96@loongson.cn>
Date: Wed, 28 Aug 2024 09:07:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <804a804c-f62d-4814-a174-51d19e3ea094@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxkeFbeM5mywElAA--.26480S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jw43CFW5Cw1DKFW7ZF47Awc_yoWxJrW7pa
	s5JayfKr4kXry7Aw17tw15Xryjk3s7tF47JF18tr18Xryqvr1fJr4Utr1YkF18G348AFy0
	qF1jqw1j9F1UA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2-VyUUUUU

Zenghui,

On 2024/8/27 上午1:00, Zenghui Yu wrote:
> [ Trivial comments inline.  You can feel free to ignore them since I
>    know almost nothing about loongarch. ]
Thanks for reviewing the hypercall document, we all know that you have 
strong background knowledge with both kernel and architecture.

> 
> On 2024/8/26 13:47, Dandan Zhang wrote:
>> From: Bibo Mao <maobibo@loongson.cn>
>>
>> Add documentation topic for using pv_virt when running as a guest
>> on KVM hypervisor.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>> Co-developed-by: Mingcong Bai <jeffbai@aosc.io>
>> Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
>> Link: https://lore.kernel.org/all/5c338084b1bcccc1d57dce9ddb1e7081@aosc.io/
>> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
>> ---
>>   Documentation/virt/kvm/index.rst              |  1 +
>>   .../virt/kvm/loongarch/hypercalls.rst         | 86 +++++++++++++++++++
>>   Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>>   MAINTAINERS                                   |  1 +
>>   4 files changed, 98 insertions(+)
>>   create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>>   create mode 100644 Documentation/virt/kvm/loongarch/index.rst
>>
>> diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
>> index ad13ec55ddfe..9ca5a45c2140 100644
>> --- a/Documentation/virt/kvm/index.rst
>> +++ b/Documentation/virt/kvm/index.rst
>> @@ -14,6 +14,7 @@ KVM
>>      s390/index
>>      ppc-pv
>>      x86/index
>> +   loongarch/index
>>   
>>      locking
>>      vcpu-requests
>> diff --git a/Documentation/virt/kvm/loongarch/hypercalls.rst b/Documentation/virt/kvm/loongarch/hypercalls.rst
>> new file mode 100644
>> index 000000000000..58168dc7166c
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
>> @@ -0,0 +1,86 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +===================================
>> +The LoongArch paravirtual interface
>> +===================================
>> +
>> +KVM hypercalls use the HVCL instruction with code 0x100 and the hypercall
>> +number is put in a0. Up to five arguments may be placed in registers a1 - a5.
>> +The return value is placed in v0 (an alias of a0).
>> +
>> +Source code for this interface can be found in arch/loongarch/kvm*.
>> +
>> +Querying for existence
>> +======================
>> +
>> +To determine if the host is running on KVM, we can utilize the cpucfg()
>> +function at index CPUCFG_KVM_BASE (0x40000000).
>> +
>> +The CPUCPU_KVM_BASE range, spanning from 0x40000000 to 0x400000FF, The
>> +CPUCPU_KVM_BASE range between 0x40000000 - 0x400000FF is marked as reserved.
> 
> What is CPUCPU_KVM_BASE? Grepping it in the code shows nothing.
> 
>> +Consequently, all current and future processors will not implement any
>> +feature within this range.
>> +
>> +On a KVM-virtualized Linux system, a read operation on cpucfg() at index
>> +CPUCFG_KVM_BASE (0x40000000) returns the magic string 'KVM\0'.
>> +
>> +Once you have determined that your host is running on a paravirtualization-
>> +capable KVM, you may now use hypercalls as described below.
>> +
>> +KVM hypercall ABI
>> +=================
>> +
>> +The KVM hypercall ABI is simple, with one scratch register a0 (v0) and at most
>> +five generic registers (a1 - a5) used as input parameters. The FP (Floating-
>> +point) and vector registers are not utilized as input registers and must
>> +remain unmodified during a hypercall.
>> +
>> +Hypercall functions can be inlined as it only uses one scratch register.
>> +
>> +The parameters are as follows:
>> +
>> +        ========	================	================
>> +	Register	IN			OUT
>> +        ========	================	================
>> +	a0		function number		Return code
>> +	a1		1st parameter		-
>> +	a2		2nd parameter		-
>> +	a3		3rd parameter		-
>> +	a4		4th parameter		-
>> +	a5		5th parameter		-
>> +        ========	================	================
> 
> Please consistently use tab.
> 
>> +
>> +The return codes may be one of the following:
>> +
>> +	====		=========================
>> +	Code		Meaning
>> +	====		=========================
>> +	0		Success
>> +	-1		Hypercall not implemented
>> +	-2		Bad Hypercall parameter
>> +	====		=========================
>> +
>> +KVM Hypercalls Documentation
>> +============================
>> +
>> +The template for each hypercall is as follows:
>> +
>> +1. Hypercall name
>> +2. Purpose
>> +
>> +1. KVM_HCALL_FUNC_PV_IPI
> 
> Is it still a work-in-progress thing? I don't see it in mainline.
It should be KVM_HCALL_FUNC_IPI here.

> 
>> +------------------------
>> +
>> +:Purpose: Send IPIs to multiple vCPUs.
>> +
>> +- a0: KVM_HCALL_FUNC_PV_IPI
>> +- a1: Lower part of the bitmap for destination physical CPUIDs
>> +- a2: Higher part of the bitmap for destination physical CPUIDs
>> +- a3: The lowest physical CPUID in the bitmap
> 
> - Is it a feature that implements IPI broadcast with a PV method?
> - Don't you need to *at least* specify which IPI to send by issuing this
>    hypercall?
Good question. It should be documented here. PV IPI on LoongArch 
includes both PV IPI multicast sending and PV IPI receiving, and SWI is 
used for PV IPI inject since there is no VM-exits accessing SWI registers.

> 
> But again, as I said I know nothing about loongarch.  I might have
> missed some obvious points.
> 
>> +
>> +The hypercall lets a guest send multiple IPIs (Inter-Process Interrupts) with
>> +at most 128 destinations per hypercall.The destinations are represented in a
>                                            ^
> Add a blank space.
> 
>> +bitmap contained in the first two input registers (a1 and a2).
>> +
>> +Bit 0 of a1 corresponds to the physical CPUID in the third input register (a3)
>> +and bit 1 corresponds to the physical CPUID in a3+1 (a4), and so on.
> 
> This looks really confusing.  "Bit 63 of a1 corresponds to the physical
> CPUID in a3+63 (a66)"?
The description is problematic, thanks for pointing it out.
It should be value of register a3 plus 1, rather than a4, how about 
*"the physical CPUID in a3 + 1"*  here?

Regards
Bibo Mao
> 
> Zenghui
> 


