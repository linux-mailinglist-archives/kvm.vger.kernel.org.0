Return-Path: <kvm+bounces-48120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F4CAC9621
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 21:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABC721C21B2A
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 19:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F9B28134A;
	Fri, 30 May 2025 19:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qejIatAl"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD138280338
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 19:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748633392; cv=none; b=H75OpD5+f8OaPC3eA3oS1fH2tPA53TbvowgFl2VjI6sisT+fEKinCSmxH3CMOcUwWn6GSvnw5dUJeRly3IazWR5GkmPpz8XtujxJvx9g2jV63Z4wHM9qP0zCC2H6VcUd1Aln10YxjSsHKP2zMBLoqqLWzueQKRJiYdQEWyiaJVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748633392; c=relaxed/simple;
	bh=VHN1sgts+2xB2xrF6P1F1g5v6UKe5rxGHeCV1L66Wxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IFEd0Rt6EFnP4B46ujNuqvjBRMDPLsykPK6I3p3zx8cKIBCGUt2rgXCWMwW2ndsXe9MkfY67D5e69QAzv7sjAqS/oPf1+XeL35aPvx4ETqERijIj9SPlH1uAYPViW2Zfv8l3qtH39Azf5PqV9fvq68B66ctcANjwlcDGZdSV6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qejIatAl; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <0dcd01cd-419f-4225-b22c-cbaf82718235@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748633376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tkiGcg9Pp6HB9HenrxwiWzm/IMuLvXwvBc2ohIpTcuU=;
	b=qejIatAl3IVBpVjd5b1sjdObGZ7rJABj1bGentvPoaT9Gk2nMpl/NODNwtlNVuxD7mIwiW
	xTQUdOt6Gu3DaCC7BjJCdrWEHh521evt/yWAJJhiesYDNH5GuqToxdnr9DVQXVDc4uDjZ3
	Hq4CVYV8tCgSZSBhWUbuMlqAshgB7wA=
Date: Fri, 30 May 2025 12:29:30 -0700
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
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <DA9G60UI0ZLC.1KIWBXCTX0427@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 5/30/25 4:09 AM, Radim Krčmář wrote:
> 2025-05-29T11:44:38-07:00, Atish Patra <atish.patra@linux.dev>:
>> On 5/29/25 3:24 AM, Radim Krčmář wrote:
>>> I originally gave up on the idea, but I feel kinda bad for Drew now, so
>>> trying again:
>> I am sorry if some of my replies came across in the wrong way. That was
>> never
>> the intention.
> I didn't mean to accuse you, my apologies.  I agree with Drew's
> positions, so to expand on a question that wasn't touched in his mail:
>
>>> Even if userspace wants SBI for the M-mode interface, security minded
>> This is probably a 3rd one ? Why we want M-mode interface in the user
>> space ?
> It is about turning KVM into an ISA accelerator.
>
> A guest thinks it is running in S/HS-mode.
> The ecall instruction traps to M-mode.  RISC-V H extension doesn't
> accelerate M-mode, so we have to emulate the trap in software.
We don't need to accelerate M-mode. That's the beauty of the RISC-V H 
extension.
The ISA is designed in such a way that the SBI is the interface between 
the supervisor environment (VS/HS)
and the supervisor execution environment (HS/M).


>
> The ISA doesn't say that M-mode means SBI.  We try really hard to have
> SBI on all RISC-V, but I think KVM is taking it a bit too far.
>
> We can discuss how best to describe SBI, so userspace can choose to
> accelerate the M-mode in KVM, but I think that the ability to emulate
> M-mode in userspace should be provided.
I am still trying to understand the advantages of emulating the M-mode 
in the user space.
Can you please elaborate ?
I am assuming you are not hinting Nested virtualization which can be 
achieved with existing
ISA provided mechanisms and accelerated by SBI NACL.



