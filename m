Return-Path: <kvm+bounces-48353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C74DACD0B0
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 02:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A10253A4D31
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 00:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90A5EAF1;
	Wed,  4 Jun 2025 00:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WEPUnmjl"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259BB661
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 00:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748997008; cv=none; b=MerdzArA09xTTF5cmuLOuoQS/ybFCd6NebTuvbhQxo9EuBqVrhEYB38oCYLAay/s7bQCuYFWnnLUfbGvq82bwcnA3BIXs0MHADEwVb3JPEW800YBg/xI8dj4FaZBXGElZcaX2qiwl3DlF3rlBU5b3aUDWcxNgXpObPsK8K/wXRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748997008; c=relaxed/simple;
	bh=f4c6fEeLwQa0PlBjC7pBJS6ckl1xuWN5vfHmd22qkEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FC6oJOdsK6g3Z0imaSwjVzPhPM1P0UuFG2yuKZNFdIIPF34DF0Bwq7lb/cmGoq0ZMZ/uhHe1ys+4xrCc0exRDmfx33jfkhpfEFEhfOvmeHyuvYhxNz0YcbEgFQNI63PrGzDxtZR8vGAFofKu5u1fDms+wQd3/Y/5J/CVXt2zglg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WEPUnmjl; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <6138a043-5b5b-46af-ba8b-01dac55dee23@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748997001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8MZYMhTjyXQwSFJY/e0Bg+aJ/DYLC4LmKmte6yFXBpM=;
	b=WEPUnmjl01eoxpfj2bo/wjnCnhorQhBLZ1U6kM9OBHA8kNJHz74sZvC5bbf9Xq5wG8FEwv
	2RVwYAOiBOU0zVcu1kuuJpmJnm5Ki55YySE0AfXWX4gcRbFoRZDZsm2tjcyYXSTjjwAR5F
	F+e/j1567odazU5Fm1OHqh6K6+KqGGI=
Date: Tue, 3 Jun 2025 17:29:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 Andrew Jones <ajones@ventanamicro.com>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>,
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
 <DA8KL716NTCA.2QJX4EW2OI6AL@ventanamicro.com>
 <2bac252c-883c-4f8a-9ae1-283660991520@linux.dev>
 <DA9G60UI0ZLC.1KIWBXCTX0427@ventanamicro.com>
 <0dcd01cd-419f-4225-b22c-cbaf82718235@linux.dev>
 <DACVBRLJ5MMV.1COZ83HBMUD6A@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <DACVBRLJ5MMV.1COZ83HBMUD6A@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 6/3/25 4:40 AM, Radim Krčmář wrote:
> 2025-05-30T12:29:30-07:00, Atish Patra <atish.patra@linux.dev>:
>> On 5/30/25 4:09 AM, Radim Krčmář wrote:
>>> 2025-05-29T11:44:38-07:00, Atish Patra <atish.patra@linux.dev>:
>>>> On 5/29/25 3:24 AM, Radim Krčmář wrote:
>>>>> I originally gave up on the idea, but I feel kinda bad for Drew now, so
>>>>> trying again:
>>>> I am sorry if some of my replies came across in the wrong way. That was
>>>> never
>>>> the intention.
>>> I didn't mean to accuse you, my apologies.  I agree with Drew's
>>> positions, so to expand on a question that wasn't touched in his mail:
>>>
>>>>> Even if userspace wants SBI for the M-mode interface, security minded
>>>> This is probably a 3rd one ? Why we want M-mode interface in the user
>>>> space ?
>>> It is about turning KVM into an ISA accelerator.
>>>
>>> A guest thinks it is running in S/HS-mode.
>>> The ecall instruction traps to M-mode.  RISC-V H extension doesn't
>>> accelerate M-mode, so we have to emulate the trap in software.
>> We don't need to accelerate M-mode. That's the beauty of the RISC-V H
>> extension.
> (It is a gap to me. :])
RISC-V H extension is designed to virtualize S-mode and U-mode. Not M-mode.
I don't think retrofitting M-mode virtualization has absolutely any 
benefit. It has
many challenges that will probably result in poor performance. It can be 
a hobby project
but I am not sure if it can be adopted in production.

Are there any similar use cases in other ISAs ? Does anybody support 
virtualizaing EL3 in ARM64 ?

>> The ISA is designed in such a way that the SBI is the interface between
>> the supervisor environment (VS/HS)
>> and the supervisor execution environment (HS/M).
> The ISA says nothing about the implementation of said interface.
>
> Returning 42 in x21 as a response to an ecall with 0x10 in a7 and 0x3 in
> a6 is perfectly valid RISC-V implementation that KVM currently cannot
> virtualize.

If the concern is only supporting an older version of SBI version, we 
can support that with onereg
interface today. I think I already agreed on that earlier in this thread 
and revise this series to have
it ready for review.


>>> The ISA doesn't say that M-mode means SBI.  We try really hard to have
>>> SBI on all RISC-V, but I think KVM is taking it a bit too far.
>>>
>>> We can discuss how best to describe SBI, so userspace can choose to
>>> accelerate the M-mode in KVM, but I think that the ability to emulate
>>> M-mode in userspace should be provided.
>> I am still trying to understand the advantages of emulating the M-mode
>> in the user space.
>> Can you please elaborate ?
> This thread already has a lot of them, so to avoid repeating them, I
> have to go into quite niche use-cases:
> When developing M-mode software on RISC-V (when RISC-V has more useful
> implementations than QEMU), a developer might want to accelerate the
> S/U-modes in KVM.
> It is also simpler to implement an old SBI interface (especially with
> bugs/quirks) if virtualization just executes the old M-mode binary.
>
> Why must KVM prevent userspace from virtualizing RISC-V?

If there is a valid use case that can be put into production or
if you have any prototype that it has better performance then we can 
have it.
In absence of either, isn't it better to spend our energy on things that 
actually matter
right now and improve RISC-V virtualization performance rather than 
something that
may or may not be possible in the very far future.

>> I am assuming you are not hinting Nested virtualization which can be
>> achieved with existing
>> ISA provided mechanisms and accelerated by SBI NACL.
> Right, I am talking about virtualization of RISC-V, because I don't have
> a crystal ball to figure out what users will want.

