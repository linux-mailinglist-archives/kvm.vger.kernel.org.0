Return-Path: <kvm+bounces-47922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B89A0AC754E
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 03:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2C637A9B0B
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 01:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47581AA786;
	Thu, 29 May 2025 01:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tdjxoYDy"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6892F3E;
	Thu, 29 May 2025 01:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748481454; cv=none; b=g7yrwpv9w4vKdER7CU9G6e/9U2skXu9VWhhbfG8mIO0J0wNcX4RVkp9hkUnlQKNnVrFV0ZjqEVNlizhLOj/0xhezF6ahhjTtWcs5m2Wu3Cvpyl1GVpzx30thRIMw4Gift6VATJFM93Ttkyj/oI4AXQ1dCDz4K3CRcsPotNj273o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748481454; c=relaxed/simple;
	bh=I+s5c7M9UXD5VAtyYRXYHGHT2EGBD11K/FtbBc6lSdw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=b1+ig6h2xOUnIzDkPYcMo97Y6bvnXYh2c9wVEH6zVS02TqOMvMcvwk3FX63ieEFm5cZgj+h+zU3kdV6KEana0g+9ehTk2RMYpyXQ+covnKX1a6cNFhtGZI+UgTM42j1FhaEyhHhealX6Zhj0xr+8w+TZqLlYCHYe5YIUywkGM0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tdjxoYDy; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <de7bb6aa-543f-4bfa-a76c-722871a8f0f2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748481449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8uJJOQ8lxfvmIQ5Wkp1c8cgXJ9Z8D5V6tF2OpxE4+0s=;
	b=tdjxoYDyfihDSKK53F2QPE25Xi4RHvl/i+uko67IN20AfTqw/yYy+C4v8Peh5pcKsbMf9e
	DqICBUuPyrC0fJezQDQIQzdsOdd3ikrpy93YRfZUDQu1JhzCkuUcWP61I6hCtM26xHO7VW
	nK/7rphkN1n8T56/5QltKyT5Tz/7VSE=
Date: Wed, 28 May 2025 18:17:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org,
 linux-riscv <linux-riscv-bounces@lists.infradead.org>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
 <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
 <DA3KSSN3MJW5.2CM40VEWBWDHQ@ventanamicro.com>
 <61627296-6f94-45ea-9410-ed0ea2251870@linux.dev>
 <DA5YWWPPVCQW.22VHONAQHOCHE@ventanamicro.com>
 <20250526-224478e15ee50987124a47ac@orel>
 <ace8be22-3dba-41b0-81f0-bf6d661b4343@linux.dev>
 <20250528-ff9f6120de39c3e4eefc5365@orel>
 <1169138f-8445-4522-94dd-ad008524c600@linux.dev>
Content-Language: en-US
In-Reply-To: <1169138f-8445-4522-94dd-ad008524c600@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 5/28/25 12:21 PM, Atish Patra wrote:
> <Removing Palmer's rivos email address to avoid bouncing>
> 
> On 5/28/25 8:09 AM, Andrew Jones wrote:
>> On Wed, May 28, 2025 at 07:16:11AM -0700, Atish Patra wrote:
>>> On 5/26/25 4:13 AM, Andrew Jones wrote:
>>>> On Mon, May 26, 2025 at 11:00:30AM +0200, Radim Krčmář wrote:
>>>>> 2025-05-23T10:16:11-07:00, Atish Patra <atish.patra@linux.dev>:
>>>>>> On 5/23/25 6:31 AM, Radim Krčmář wrote:
>>>>>>> 2025-05-22T12:03:43-07:00, Atish Patra <atishp@rivosinc.com>:
>>>>>>>> Upgrade the SBI version to v3.0 so that corresponding features
>>>>>>>> can be enabled in the guest.
>>>>>>>>
>>>>>>>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>>>>>>>> ---
>>>>>>>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/ 
>>>>>>>> include/asm/kvm_vcpu_sbi.h
>>>>>>>> -#define KVM_SBI_VERSION_MAJOR 2
>>>>>>>> +#define KVM_SBI_VERSION_MAJOR 3
>>>>>>> I think it's time to add versioning to KVM SBI implementation.
>>>>>>> Userspace should be able to select the desired SBI version and 
>>>>>>> KVM would
>>>>>>> tell the guest that newer features are not supported.
>>>> We need new code for this, but it's a good idea.
>>>>
>>>>>> We can achieve that through onereg interface by disabling 
>>>>>> individual SBI
>>>>>> extensions.
>>>>>> We can extend the existing onereg interface to disable a specific SBI
>>>>>> version directly
>>>>>> instead of individual ones to save those IOCTL as well.
>>>>> Yes, I am all in favor of letting userspace provide all values in the
>>>>> BASE extension.
>>> We already support vendorid/archid/impid through one reg. I think we 
>>> just
>>> need to add the SBI version support to that so that user space can 
>>> set it.
>>>
>>>> This is covered by your recent patch that provides userspace_sbi.
>>> Why do we need to invent new IOCTL for this ? Once the user space 
>>> sets the
>>> SBI version, KVM can enforce it.
>> If an SBI spec version provides an extension that can be emulated by
>> userspace, then userspace could choose to advertise that spec version,
>> implement a BASE probe function that advertises the extension, and
>> implement the extension, even if the KVM version running is older
>> and unaware of it. But, in order to do that, we need KVM to exit to
>> userspace for all unknown SBI calls and to allow BASE to be overridden
> You mean only the version field in BASE - Correct ?
> 
> We already support vendorid/archid/impid through one reg. I don't see the
> point of overriding SBI implementation ID & version.
> 
>> by userspace. The new KVM CAP ioctl allows opting into that new behavior.
> 
> But why we need a new IOCTL for that ? We can achieve that with existing
> one reg interface with improvements.
> 
>> The old KVM with new VMM configuration isn't totally far-fetched. While
>> host kernels tend to get updated regularly to include security fixes,
>> enterprise kernels tend to stop adding features at some point in order
>> to maximize stability. While enterprise VMMs would also eventually stop
>> adding features, enterprise consumers are always free to use their own
>> VMMs (at their own risk). So, there's a real chance we could have
> 
> I think we are years away from that happening (if it happens). My 
> suggestion was not to
> try to build a world where no body lives ;). When we get to that 

We also support KVM as a kernel module. So it is relatively easier to 
update the RISC-V KVM module for enterprise consumers.

> scenario, the default KVM
> shipped will have many extension implemented. So there won't be much 
> advantage to
> reimplement them in the user space. We can also take an informed 
> decision at that time
> if the current selective forwarding approach is better or we need to 
> blindly forward any
> unknown SBI calls to the user space.
> 
>> deployments with older, stable KVM where users want to enable later SBI
>> extensions, and, in some cases, that should be possible by just updating
>> the VMM -- but only if KVM is only acting as an SBI implementation
>> accelerator and not as a userspace SBI implementation gatekeeper.
> 
> But some of the SBI extensions are so fundamental that it must be 
> implemented in KVM
> for various reasons pointed by Anup on other thread.
> 
>> Thanks,
>> drew
>>
>>>> With that, userspace can disable all extensions that aren't
>>>> supported by a given spec version, disable BASE and then provide
>>>> a BASE that advertises the version it wants. The new code is needed
>>>> for extensions that userspace still wants KVM to accelerate, but then
>>>> KVM needs to be informed it should deny all functions not included in
>>>> the selected spec version.
>>>>
>>>> Thanks,
>>>> drew
>>>>
>>>> _______________________________________________
>>>> linux-riscv mailing list
>>>> linux-riscv@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/linux-riscv


