Return-Path: <kvm+bounces-40200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A72A53F1F
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90909170301
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08BCFC12;
	Thu,  6 Mar 2025 00:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="rnePR2hw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C88FF9E8;
	Thu,  6 Mar 2025 00:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741220986; cv=none; b=c+iSgCo7VwfD0UnJC6W1p2dFO7SKZYMfP936W9zCxmNJivGdhBs4uITob/LDqcdYbpJGesrkF2XOQ/T/RsP+sBjIadOHFViawDabs0vPcCXxLtrBlRVG8fGGvu7VZEYYdccb5yW8x1MH1vmIEQt39E7sl91eOSrmi/LRNH6wPGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741220986; c=relaxed/simple;
	bh=K0hpXmBIeWACuRqHPWQt5Zf2GMFn3E5zMQxaMAaoKZw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tjsktFNE3UIUaAN2AQj6p3jOjc6bjqDvGbyaAAmuqN+F+BcXQD+GqzvSGkq2k+89B/ayxm7/ich0Z0Bu7Lx/Fz/adD/BMlcjBJUbc8BBL2JjeDjMp6w+w4HkbTXycceCmaDfuG+iYLxWPUjlGjjfkrl7x5g1DMEcRq6C6bgZ3EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=rnePR2hw; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5260TRbF3519988
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 5 Mar 2025 16:29:28 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5260TRbF3519988
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025021701; t=1741220968;
	bh=nyfZtjxpwWEfPD2aWtSJVU9prs0awbhhMdouVBIRD14=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=rnePR2hwJuXY5FmWXVv6sKakKb16gqY6la25fcNXD75cRQVpa2ZRcjCrKVOuukjCB
	 hRqstDX2y33m5xXuD7NVQPXDQYLTAplDaBg1xcMyt+j959umpzmuK30mLTDge0cGXp
	 bnvazkO/OsgotjsN+4A03SGz9l8AUI6QO/4BJ9vha8pm3FY247UsUaf91Izo6cffrQ
	 olDvEOmJ3YNx2I/0aCLbw3SAefG82cytvU9inPCFtN7bbjw/fVGuZWrUfEKeWiHKih
	 mJwYNN1fefggEc2XOBAauB3RKE/hvo3PoSnUZaFsHLKmVg/yGvEbQYRrnL4xbRkR89
	 uKCAqqVibBGfw==
Message-ID: <ab26bb7f-4466-4136-a6d7-2c239bf204b2@zytor.com>
Date: Wed, 5 Mar 2025 16:29:26 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/msr: Rename the WRMSRNS opcode macro to
 ASM_WRMSRNS (for KVM)
From: Xin Li <xin@zytor.com>
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250227010111.3222742-1-seanjc@google.com>
 <20250227010111.3222742-2-seanjc@google.com>
 <ab5ded74-91b4-46ae-b360-b372ff790fa6@zytor.com>
Content-Language: en-US
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <ab5ded74-91b4-46ae-b360-b372ff790fa6@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/26/2025 5:14 PM, Xin Li wrote:
> On 2/26/2025 5:01 PM, Sean Christopherson wrote:
>> Rename the WRMSRNS instruction opcode macro so that it doesn't collide
>> with X86_FEATURE_WRMSRNS when using token pasting to generate references
>> to X86_FEATURE_WRMSRNS.  KVM heavily uses token pasting to generate KVM's
>> set of support feature bits, and adding WRMSRNS support in KVM will run
>> will run afoul of the opcode macro.
>>
>>    arch/x86/kvm/cpuid.c:719:37: error: pasting "X86_FEATURE_" and "" 
>> "" does not
>>                                        give a valid preprocessing token
>>    719 |         u32 __leaf = 
>> __feature_leaf(X86_FEATURE_##name);                \
>>        |                                     ^~~~~~~~~~~~
>>
>> KVM has worked around one such collision in the past by #undef'ing the
>> problematic macro in order to avoid blocking a KVM rework, but such games
>> are generally undesirable, e.g. requires bleeding macro details into KVM,
>> risks weird behavior if what KVM is #undef'ing changes, etc.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/include/asm/msr.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
>> index 001853541f1e..60b80a36d045 100644
>> --- a/arch/x86/include/asm/msr.h
>> +++ b/arch/x86/include/asm/msr.h
>> @@ -300,7 +300,7 @@ do {                            \
>>   #endif    /* !CONFIG_PARAVIRT_XXL */
>>   /* Instruction opcode for WRMSRNS supported in binutils >= 2.40 */
>> -#define WRMSRNS _ASM_BYTES(0x0f,0x01,0xc6)
>> +#define ASM_WRMSRNS _ASM_BYTES(0x0f,0x01,0xc6)
>>   /* Non-serializing WRMSR, when available.  Falls back to a 
>> serializing WRMSR. */
>>   static __always_inline void wrmsrns(u32 msr, u64 val)
>> @@ -309,7 +309,7 @@ static __always_inline void wrmsrns(u32 msr, u64 val)
>>        * WRMSR is 2 bytes.  WRMSRNS is 3 bytes.  Pad WRMSR with a 
>> redundant
>>        * DS prefix to avoid a trailing NOP.
>>        */
>> -    asm volatile("1: " ALTERNATIVE("ds wrmsr", WRMSRNS, 
>> X86_FEATURE_WRMSRNS)
>> +    asm volatile("1: " ALTERNATIVE("ds wrmsr", ASM_WRMSRNS, 
>> X86_FEATURE_WRMSRNS)
>>                "2: " _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
>>                : : "c" (msr), "a" ((u32)val), "d" ((u32)(val >> 32)));
>>   }
> 
> I hit the same build issue, thanks for fixing it.
> 
> Reviewed-by: Xin Li (Intel) <xin@zytor.com>
> 

Do we need an ack from x86 maintainers?


