Return-Path: <kvm+bounces-47906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8581FAC7175
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 21:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27291189190F
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 19:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA4721CC4E;
	Wed, 28 May 2025 19:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y/V3rbzm"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3065421CC41
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 19:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748460132; cv=none; b=QzGSabAWfjBkRnQIlIBjMED5r64WYvE3j7+htBoVDg2qZ/1jEp4xubiWXDMmVgiumPFTuHYiIDtaA/7l72wtIdhgMJViIBrxf6cC8r3rAp/EOQAc75x23a/lhxdnhfV+biL7R8po1FufZ+mKikxEEPlHMwDOv+e+Sty1c7pwOdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748460132; c=relaxed/simple;
	bh=sXTnlvs0SF+o+xjwS3jb0zB0h8XaidUlvbp38Pk9CE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t2e+H61KvJ1nen8qsRsb5kSYzwTNS6o/x0VMC1/GtiMFLjp0kVfr0voTCqAEd+nRwWUJ0R7Sz/y5p//YyoRtKz0deFeho4ZcyqKakGt8/M+BI6FpP065kZQ/e4CjT7mNyiUmb2frYMvzMVbtA4I/pKZfayWAd/qDUYS3SoDcX4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y/V3rbzm; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <1169138f-8445-4522-94dd-ad008524c600@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748460126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pRNcAmNAMd2i0MLLlt89PMZctaigyBtb9U8DRb8tnes=;
	b=Y/V3rbzm4Kc9GHC/hoAkMCQsFBHVy3OclJnu3ppfO3zfqqimuwUCgdJDcjwGNfNBwuNpWz
	mx5ipTPzaOOv3koMm64vnvxqPbJZMLGE6Iqei5daLPV+lF6nEEDkb4csAQLWtHVygsBTqF
	LzCBgfPjzjVxe8TaWjbdhnXsx4THqaI=
Date: Wed, 28 May 2025 12:21:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
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
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250528-ff9f6120de39c3e4eefc5365@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

<Removing Palmer's rivos email address to avoid bouncing>

On 5/28/25 8:09 AM, Andrew Jones wrote:
> On Wed, May 28, 2025 at 07:16:11AM -0700, Atish Patra wrote:
>> On 5/26/25 4:13 AM, Andrew Jones wrote:
>>> On Mon, May 26, 2025 at 11:00:30AM +0200, Radim Krčmář wrote:
>>>> 2025-05-23T10:16:11-07:00, Atish Patra <atish.patra@linux.dev>:
>>>>> On 5/23/25 6:31 AM, Radim Krčmář wrote:
>>>>>> 2025-05-22T12:03:43-07:00, Atish Patra <atishp@rivosinc.com>:
>>>>>>> Upgrade the SBI version to v3.0 so that corresponding features
>>>>>>> can be enabled in the guest.
>>>>>>>
>>>>>>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>>>>>>> ---
>>>>>>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>>>>>>> -#define KVM_SBI_VERSION_MAJOR 2
>>>>>>> +#define KVM_SBI_VERSION_MAJOR 3
>>>>>> I think it's time to add versioning to KVM SBI implementation.
>>>>>> Userspace should be able to select the desired SBI version and KVM would
>>>>>> tell the guest that newer features are not supported.
>>> We need new code for this, but it's a good idea.
>>>
>>>>> We can achieve that through onereg interface by disabling individual SBI
>>>>> extensions.
>>>>> We can extend the existing onereg interface to disable a specific SBI
>>>>> version directly
>>>>> instead of individual ones to save those IOCTL as well.
>>>> Yes, I am all in favor of letting userspace provide all values in the
>>>> BASE extension.
>> We already support vendorid/archid/impid through one reg. I think we just
>> need to add the SBI version support to that so that user space can set it.
>>
>>> This is covered by your recent patch that provides userspace_sbi.
>> Why do we need to invent new IOCTL for this ? Once the user space sets the
>> SBI version, KVM can enforce it.
> If an SBI spec version provides an extension that can be emulated by
> userspace, then userspace could choose to advertise that spec version,
> implement a BASE probe function that advertises the extension, and
> implement the extension, even if the KVM version running is older
> and unaware of it. But, in order to do that, we need KVM to exit to
> userspace for all unknown SBI calls and to allow BASE to be overridden
You mean only the version field in BASE - Correct ?

We already support vendorid/archid/impid through one reg. I don't see the
point of overriding SBI implementation ID & version.

> by userspace. The new KVM CAP ioctl allows opting into that new behavior.

But why we need a new IOCTL for that ? We can achieve that with existing
one reg interface with improvements.

> The old KVM with new VMM configuration isn't totally far-fetched. While
> host kernels tend to get updated regularly to include security fixes,
> enterprise kernels tend to stop adding features at some point in order
> to maximize stability. While enterprise VMMs would also eventually stop
> adding features, enterprise consumers are always free to use their own
> VMMs (at their own risk). So, there's a real chance we could have

I think we are years away from that happening (if it happens). My 
suggestion was not to
try to build a world where no body lives ;). When we get to that 
scenario, the default KVM
shipped will have many extension implemented. So there won't be much 
advantage to
reimplement them in the user space. We can also take an informed 
decision at that time
if the current selective forwarding approach is better or we need to 
blindly forward any
unknown SBI calls to the user space.

> deployments with older, stable KVM where users want to enable later SBI
> extensions, and, in some cases, that should be possible by just updating
> the VMM -- but only if KVM is only acting as an SBI implementation
> accelerator and not as a userspace SBI implementation gatekeeper.

But some of the SBI extensions are so fundamental that it must be 
implemented in KVM
for various reasons pointed by Anup on other thread.

> Thanks,
> drew
>
>>> With that, userspace can disable all extensions that aren't
>>> supported by a given spec version, disable BASE and then provide
>>> a BASE that advertises the version it wants. The new code is needed
>>> for extensions that userspace still wants KVM to accelerate, but then
>>> KVM needs to be informed it should deny all functions not included in
>>> the selected spec version.
>>>
>>> Thanks,
>>> drew
>>>
>>> _______________________________________________
>>> linux-riscv mailing list
>>> linux-riscv@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-riscv

