Return-Path: <kvm+bounces-22037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DA3D938A99
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 10:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A4501F219EB
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 08:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BE2160873;
	Mon, 22 Jul 2024 08:00:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE60017C69;
	Mon, 22 Jul 2024 08:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721635242; cv=none; b=jL5xsAfuvZEcpeGYGz0cwy8DBw3TRWrbU3Q+5eMFgJH7DilvGGAxWAx6Fxds954Dz43fi+R8sDJpmDnsGp5PpsYQUXk0D4Bays7+fq+qSOUdc7bELNug6tlgrKSyXhbo7BpBLQFe1smjaybvpqn7/Q6YrLqpWhqJa4/Kn3xbm5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721635242; c=relaxed/simple;
	bh=zJcfuhn0DuH1uG0pDznMSXqnvuHQG9yPxqhYft8CvAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TD3unEBlbS9kpYifEixqK9qeYnRLROWUScq/bxBwXmCQZb7uLnfKYbmNxdKbjiwaIhftCBsOUB/5lYOKLANvtSFgMe+RImAVUhr+GVOUCdVv8/QrFkB+lSt+yYy0Sb/J7u05X0g1rqdVoMIPoTtff1btUhdHFAfyikKfgdA0O9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE3EB367;
	Mon, 22 Jul 2024 01:01:05 -0700 (PDT)
Received: from [10.162.41.8] (a077893.blr.arm.com [10.162.41.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02BB83F73F;
	Mon, 22 Jul 2024 01:00:36 -0700 (PDT)
Message-ID: <4db40b5b-bcc7-4370-a70d-57c1cd83682f@arm.com>
Date: Mon, 22 Jul 2024 13:30:33 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/sysreg: Correct the values for GICv4.1
To: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240718215532.616447-1-rananta@google.com>
 <86ikx13jeu.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <86ikx13jeu.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/19/24 13:25, Marc Zyngier wrote:
> On Thu, 18 Jul 2024 22:55:32 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
>>
>> Currently, sysreg has value as 0b0010 for the presence of GICv4.1 in
>> ID_PFR1_EL1 and ID_AA64PFR0_EL1, instead of 0b0011 as per ARM ARM.
>> Hence, correct them to reflect ARM ARM.
>>
>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>> ---
>>  arch/arm64/tools/sysreg | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index a4c1dd4741a47..7ceaa1e0b4bc2 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -149,7 +149,7 @@ Res0	63:32
>>  UnsignedEnum	31:28	GIC
>>  	0b0000	NI
>>  	0b0001	GICv3
>> -	0b0010	GICv4p1
>> +	0b0011	GICv4p1
>>  EndEnum
>>  UnsignedEnum	27:24	Virt_frac
>>  	0b0000	NI
>> @@ -903,7 +903,7 @@ EndEnum
>>  UnsignedEnum	27:24	GIC
>>  	0b0000	NI
>>  	0b0001	IMP
>> -	0b0010	V4P1
>> +	0b0011	V4P1
> 
> I wonder why we have different naming schemes for the same feature...

Both definitions were added via different commits and different developers who
might just have interpreted the following common description bit differently.

"System register interface to version 4.1 of the GIC CPU interface is supported"

1224308075f1 ("arm64/sysreg: Convert ID_PFR1_EL1 to automatic generation")
cea08f2bf406 ("arm64/sysreg: Convert ID_AA64PFR0_EL1 to automatic generation")

But I agree that same fields should be named exactly the same both in their 32
bit and 64 bit variants.

> 
>>  EndEnum
>>  SignedEnum	23:20	AdvSIMD
>>  	0b0000	IMP
>>
> 
> Yup, this looks correct and checks out against revision H.b of the GICv3
> spec, revision K.a of the ARM ARM, and even I.a (which the original
> patches were referencing).
> 
> Once more, it shows that these dumps should be automatically generated
> from the XML instead of (creatively) hand-written.
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> 
> 	M.
> 

