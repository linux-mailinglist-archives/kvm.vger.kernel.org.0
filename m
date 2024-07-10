Return-Path: <kvm+bounces-21314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DF892D504
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06219B24AF3
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280871946B6;
	Wed, 10 Jul 2024 15:34:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B534910A09;
	Wed, 10 Jul 2024 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625657; cv=none; b=couKRjDhNK7f1i9mUdNjZ7XcQjbSqI3x8lBADa785hNTTPfcdISNAubreAerQ2yiePOUvedUhvVTyyxY1UwcTvZMKGAxjPKe9hD7o/RmH/NBFHfc+9oDo34Uf3FGUqq4qh27KQCqh/DB9oxSHE0i0dn90C0DF8hWYCKluQIg3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625657; c=relaxed/simple;
	bh=GVLn699zjrPxFqNk3Km0TnxRhpbFIGD+c620ROQtoF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnvZvXJ1ySuxkLxcZ58aaUpgmg4I85HtFx6JBZVI+rNzLAhwvaL+cAFWesYe/YE6vPkV87cz/FCpbaYOy/4IRAn7tprnfFje0Xwf1otDpcffIgu0WY6OrkHg+tBUDu+AIPIbxHDMM5dakd0hwqtkDvFZu7R49VzzijY0aKzrpo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33A21106F;
	Wed, 10 Jul 2024 08:34:40 -0700 (PDT)
Received: from [10.57.8.115] (unknown [10.57.8.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A60F3F766;
	Wed, 10 Jul 2024 08:34:11 -0700 (PDT)
Message-ID: <3b2ddd79-c7f0-4d41-8795-13d1305e3d08@arm.com>
Date: Wed, 10 Jul 2024 16:34:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/15] arm64: rsi: Add RSI definitions
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-2-steven.price@arm.com>
 <3b1c8387-f40f-4841-b2b3-9e4dc1e35efc@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <3b1c8387-f40f-4841-b2b3-9e4dc1e35efc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09/07/2024 06:19, Gavin Shan wrote:
> On 7/1/24 7:54 PM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by a realm guest through SMC (Realm Services Interface) calls.
>>
>> The SMC definitions are based on DEN0137[1] version A-eac5.
>>
>> [1] https://developer.arm.com/documentation/den0137/latest
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v3:
>>   * Drop invoke_rsi_fn_smc_with_res() function and call arm_smccc_smc()
>>     directly instead.
>>   * Rename header guard in rsi_smc.h to be consistent.
>> Changes since v2:
>>   * Rename rsi_get_version() to rsi_request_version()
>>   * Fix size/alignment of struct realm_config
>> ---
>>   arch/arm64/include/asm/rsi_cmds.h |  38 ++++++++
>>   arch/arm64/include/asm/rsi_smc.h  | 142 ++++++++++++++++++++++++++++++
>>   2 files changed, 180 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/rsi_cmds.h
>>   create mode 100644 arch/arm64/include/asm/rsi_smc.h
>>
> 
> [...]
> 
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi_smc.h
>> @@ -0,0 +1,142 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RSI_SMC_H_
>> +#define __ASM_RSI_SMC_H_
>> +
>> +/*
>> + * This file describes the Realm Services Interface (RSI) Application
>> Binary
>> + * Interface (ABI) for SMC calls made from within the Realm to the
>> RMM and
>> + * serviced by the RMM.
>> + */
>> +
>> +#define SMC_RSI_CALL_BASE        0xC4000000
>> +
> 
> These fields have been defined in include/linux/arm-smccc.h. Those definitions
> can be reused. Otherwise, it's not obvious to reader what does 0xC4000000 represent.
> 
> #define SMC_RSI_CALL_BASE    ((ARM_SMCCC_FAST_CALL << ARM_SMCCC_TYPE_SHIFT)   | \
>                                  (ARM_SMCCC_SMC_64 << ARM_SMCCC_CALL_CONV_SHIFT) | \
>                                  (ARM_SMCCC_OWNER_STANDARD << ARM_SMCCC_OWNER_SHIFT))
> 
> or
> 
> #define SMC_RSI_CALL_BASE       ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,            \
>                                                    ARM_SMCCC_SMC_64,               \
>                                                    ARM_SMCCC_OWNER_STANDARD,       \
>                                                    0)

Good point, even better is actually to just drop SMC_RSI_CALL_BASE and
just redefine SMC_RSI_FID() in terms of ARM_SMCCC_CALL_VAL().

Thanks,
Steve


