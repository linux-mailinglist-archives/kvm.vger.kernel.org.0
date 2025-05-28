Return-Path: <kvm+bounces-47882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F08AAC6B8A
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C55A23BBE53
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 14:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DDB22A81C;
	Wed, 28 May 2025 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qjpKfob7"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F26427A108
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748441785; cv=none; b=mlfYBjKNkBwD8knnhrJp6FxLmt2cnhubO/MK0xIiOYbuwjd3aeS9AkCzfMj5PpIVmthC/h8L3j6WsFZkpPBVrebnfYkVB2BKOJ1T1tRZd7TOnu+7mVqOSsqpEQ3wBvU4p1OMUf7VRKHtFWcWJw6JUdTqsa4P9yJRgEPJrtwLf8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748441785; c=relaxed/simple;
	bh=BaZazWUNwzpYDJYIgR7YjT89yC060LzmEBjX/G4NG70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wu+9c0KlF3i6Hy7hbnb4iVWAjugA2tfWLKQV4HeSe7OY9F5r1ScThmOA7V4tSQGN3GuLHwfmz2xegyXo8GcbP8zp0tcQbE+9kovQu0vDtN42HcBvTepRFXdHtU0/xYBauzJOeASc/s/IQOs5vzqcKewJcYPkfmIHfY3/NqUdL3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qjpKfob7; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <ace8be22-3dba-41b0-81f0-bf6d661b4343@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748441779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c5mLYhkH15cgSjxuuv6l4kYe/fzzBQUwpR9u2pfZOy8=;
	b=qjpKfob7Z9nwJXoxx5GUB/npEZom5q2cVoX+WSrhUvhCp38miksFI15n7HED2ElCpa+Gzh
	rMarA3QV5uYksrG/9PUOkqwZt07frFarx52lcp28KkCgCK6TwCddvcYR3TQi0qP59jouqi
	jrs60IDKyBiuILyERrfCfy38ldk8MHk=
Date: Wed, 28 May 2025 07:16:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
To: Andrew Jones <ajones@ventanamicro.com>,
 =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv <linux-riscv-bounces@lists.infradead.org>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
 <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
 <DA3KSSN3MJW5.2CM40VEWBWDHQ@ventanamicro.com>
 <61627296-6f94-45ea-9410-ed0ea2251870@linux.dev>
 <DA5YWWPPVCQW.22VHONAQHOCHE@ventanamicro.com>
 <20250526-224478e15ee50987124a47ac@orel>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250526-224478e15ee50987124a47ac@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 5/26/25 4:13 AM, Andrew Jones wrote:
> On Mon, May 26, 2025 at 11:00:30AM +0200, Radim Krčmář wrote:
>> 2025-05-23T10:16:11-07:00, Atish Patra <atish.patra@linux.dev>:
>>> On 5/23/25 6:31 AM, Radim Krčmář wrote:
>>>> 2025-05-22T12:03:43-07:00, Atish Patra <atishp@rivosinc.com>:
>>>>> Upgrade the SBI version to v3.0 so that corresponding features
>>>>> can be enabled in the guest.
>>>>>
>>>>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>>>>> ---
>>>>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>>>>> -#define KVM_SBI_VERSION_MAJOR 2
>>>>> +#define KVM_SBI_VERSION_MAJOR 3
>>>> I think it's time to add versioning to KVM SBI implementation.
>>>> Userspace should be able to select the desired SBI version and KVM would
>>>> tell the guest that newer features are not supported.
> 
> We need new code for this, but it's a good idea.
> 
>>>
>>> We can achieve that through onereg interface by disabling individual SBI
>>> extensions.
>>> We can extend the existing onereg interface to disable a specific SBI
>>> version directly
>>> instead of individual ones to save those IOCTL as well.
>>
>> Yes, I am all in favor of letting userspace provide all values in the
>> BASE extension.
> 

We already support vendorid/archid/impid through one reg. I think we 
just need to add the SBI version support to that so that user space can 
set it.

> This is covered by your recent patch that provides userspace_sbi.

Why do we need to invent new IOCTL for this ? Once the user space sets 
the SBI version, KVM can enforce it.

> With that, userspace can disable all extensions that aren't
> supported by a given spec version, disable BASE and then provide
> a BASE that advertises the version it wants. The new code is needed
> for extensions that userspace still wants KVM to accelerate, but then
> KVM needs to be informed it should deny all functions not included in
> the selected spec version.
> 
> Thanks,
> drew
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv


