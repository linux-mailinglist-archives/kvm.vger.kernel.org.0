Return-Path: <kvm+bounces-10051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33758868D37
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E8C71C2275B
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9651386CB;
	Tue, 27 Feb 2024 10:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="tffeR8d1"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC621384B2;
	Tue, 27 Feb 2024 10:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029158; cv=none; b=ffRYTdBoLVJ6led6zz6jLFRsc6fSMpyXb1IrrnZifbC5KWoTtNo6A4+lL46iiePNIqHFv78TzPI1bCkjm8APMmCQcmUSmEWhJaHHK5bAFuUVGEVZAFgXa8FsfdPM2UnOAKWxLtE6Rb7PkM8CY2hypYLiNyxgEFL1FWsDBsN/XbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029158; c=relaxed/simple;
	bh=5sc9exolwsywzwMysiUeFzXsXrPi7FzwPMd2B6e7iUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i3Oy4B7t0wTEQ/wwXw4vzQyoRnFY0IvljJdkxiqli88+B13wi3Il0rPnMxs7oWC0FSPrOndVMjFKr5F4dhs2EWkvh7kmT044QSRdg0a2AAtIOPGUyo6V43owv+Si3g0NuDAMciu9ZkGfpgBFW9oc23vCDC9MqvTHTHGnZfQvsKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=tffeR8d1; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1709029150; bh=5sc9exolwsywzwMysiUeFzXsXrPi7FzwPMd2B6e7iUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tffeR8d1ZzdwRnjSiWrkYFvpX3d4HLSjHQ3sTPsEVs8BVq9o/Y1zdlByr5Z/hdKAT
	 n/2hX6ox08LvFhIwV5llcB2iIro+K/jAiVXOEm9QZiJETQ6UyAS/tHnJdpEQJbnn3v
	 hdlrI2QJ4mTlPtVm3UdAARIg1qEF3AhBTDQ92vMc=
Received: from [28.0.0.1] (unknown [101.230.251.34])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 3489160121;
	Tue, 27 Feb 2024 18:19:10 +0800 (CST)
Message-ID: <431111f3-d84a-4311-986d-eebd91559cd3@xen0n.name>
Date: Tue, 27 Feb 2024 18:19:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Content-Language: en-US
To: maobibo <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
 <CAAhV-H7p114hWUVrYRfKiBX3teG8sG7xmEW-Q-QT3i+xdLqDEA@mail.gmail.com>
 <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn>
 <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
 <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn>
 <327808dd-ac34-4c61-9992-38642acc9419@xen0n.name>
 <62cc24fd-025a-53c6-1c8e-2d20de54d297@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <62cc24fd-025a-53c6-1c8e-2d20de54d297@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/27/24 18:12, maobibo wrote:
> 
> 
> On 2024/2/27 下午5:10, WANG Xuerui wrote:
>> On 2/27/24 11:14, maobibo wrote:
>>>
>>>
>>> On 2024/2/27 上午4:02, Jiaxun Yang wrote:
>>>>
>>>>
>>>> 在2024年2月26日二月 上午8:04，maobibo写道：
>>>>> On 2024/2/26 下午2:12, Huacai Chen wrote:
>>>>>> On Mon, Feb 26, 2024 at 10:04 AM maobibo <maobibo@loongson.cn> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 2024/2/24 下午5:13, Huacai Chen wrote:
>>>>>>>> Hi, Bibo,
>>>>>>>>
>>>>>>>> On Thu, Feb 22, 2024 at 11:28 AM Bibo Mao <maobibo@loongson.cn> 
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>> Instruction cpucfg can be used to get processor features. And 
>>>>>>>>> there
>>>>>>>>> is trap exception when it is executed in VM mode, and also it is
>>>>>>>>> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
>>>>>>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
>>>>>>>>> for KVM hypervisor to privide PV features, and the area can be 
>>>>>>>>> extended
>>>>>>>>> for other hypervisors in future. This area will never be used for
>>>>>>>>> real HW, it is only used by software.
>>>>>>>> After reading and thinking, I find that the hypercall method 
>>>>>>>> which is
>>>>>>>> used in our productive kernel is better than this cpucfg method.
>>>>>>>> Because hypercall is more simple and straightforward, plus we don't
>>>>>>>> worry about conflicting with the real hardware.
>>>>>>> No, I do not think so. cpucfg is simper than hypercall, hypercall 
>>>>>>> can
>>>>>>> be in effect when system runs in guest mode. In some scenario 
>>>>>>> like TCG
>>>>>>> mode, hypercall is illegal intruction, however cpucfg can work.
>>>>>> Nearly all architectures use hypercall except x86 for its historical
>>>>> Only x86 support multiple hypervisors and there is multiple hypervisor
>>>>> in x86 only. It is an advantage, not historical reason.
>>>>
>>>> I do believe that all those stuff should not be exposed to guest 
>>>> user space
>>>> for security reasons.
>>> Can you add PLV checking when cpucfg 0x40000000-0x400000FF is 
>>> emulated? if it is user mode return value is zero and it is kernel 
>>> mode emulated value will be returned. It can avoid information leaking.
>>
>> I've suggested this approach in another reply [1], but I've rechecked 
>> the manual, and it turns out this behavior is not permitted by the 
>> current wording. See LoongArch Reference Manual v1.10, Volume 1, 
>> Section 2.2.10.5 "CPUCFG":
>>
>>  > CPUCFG 访问未定义的配置字将读回全 0 值。
>>  >
>>  > Reads of undefined CPUCFG configuration words shall return all-zeroes.
>>
>> This sentence mentions no distinction based on privilege modes, so it 
>> can only mean the behavior applies universally regardless of privilege 
>> modes.
>>
>> I think if you want to make CPUCFG behavior PLV-dependent, you may 
>> have to ask the LoongArch spec editors, internally or in public, for a 
>> new spec revision.
> No, CPUCFG behavior between CPUCFG0-CPUCFG21 is unchanged, only that it 
> can be defined by software since CPUCFG 0x400000000 is used by software.

The 0x40000000 range is not mentioned in the manuals. I know you've 
confirmed privately with HW team but this needs to be properly 
documented for public projects to properly rely on.

>> (There are already multiple third-party LoongArch implementers as of 
>> late 2023, so any ISA-level change like this would best be 
>> coordinated, to minimize surprises.)
> With document Vol 4-23
> https://www.intel.com/content/dam/develop/external/us/en/documents/335592-sdm-vol-4.pdf
> 
> There is one line "MSR address range between 40000000H - 400000FFH is 
> marked as a specially reserved range. All existing and
> future processors will not implement any features using any MSR in this 
> range."

Thanks for providing this info, now at least we know why it's this 
specific range of 0x400000XX that's chosen.

> 
> It only says that it is reserved, it does not say detailed software 
> behavior. Software behavior is defined in hypervisor such as:
> https://github.com/MicrosoftDocs/Virtualization-Documentation/blob/main/tlfs/Requirements%20for%20Implementing%20the%20Microsoft%20Hypervisor%20Interface.pdf
> https://kb.vmware.com/s/article/1009458
> 
> If hypercall method is used, there should be ABI also like aarch64:
> https://documentation-service.arm.com/static/6013e5faeee5236980d08619

Yes proper documentation of public API surface is always necessary 
*before* doing real work. Because right now the hypercall provider is 
Linux KVM, maybe we can document the existing and planned hypercall 
usage and ABI in the kernel docs along with code changes.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


