Return-Path: <kvm+bounces-50387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A48AE4B0F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 133CC1669A9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F7529A9FE;
	Mon, 23 Jun 2025 16:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ZqNao/kX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7CD26D4C3;
	Mon, 23 Jun 2025 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750696524; cv=none; b=YKys2+ddu9DB4tz90QOyolY59XHU67Fnq/e3unrmbiX0A3v/VpZVKJq9mmSPw61P1DofO6HsNuHzSkCdv7cRBPn2ZwfsZ9C1sD6FabTjtE3i1jmmvl5dQ2asF+1RvOeQ4elNCnLU9+EwdtSLaVXUlQTTjm0trQenM7iFJGUuU2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750696524; c=relaxed/simple;
	bh=Ve+SpKyRBls5/n1FP5Nes9FcvfturoeCFj7ZqH+eynQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mH4bdIe06tb81Z3nJexiJAmMSFHF3YhQ8/doED0pAXouwGfT0GXZHsNvxK5phuESkfNWjauOGdTGigdvxL/biuv6+egoz9qVlbA9vZVIEVWdrYkKObS13ZixsufveI8lkNoNfUb6fSVb8CLAXqWIFSRdYTk4Osdqu7BkJanCaIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ZqNao/kX; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55NGYaHH1005381
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 23 Jun 2025 09:34:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55NGYaHH1005381
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750696477;
	bh=pJ4n1VEcTP7nUT8MFJdFAr79IrfN7vjnPZUzVxTm0Gs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZqNao/kXH0QhsZEIKDxhQRs9nGqZsXOX3O1PQqTydeuF32axKfiWw/YcrZkrEjVt/
	 tDapUNCaVI5Vfi2UuLtdj+C7sULRXA5EuQUpkiNjaNa80KSs6NAGviEkYlc08oi6HV
	 jSLszTK4xHQf9+kWq2iPQU16ohCdkQv5+Usrm6h3oWNrgfv4EaegzXAJlBZqEduk94
	 Ciw/9T5RAiWbwR3sa4w5Hk7KmxHXOwdmhTAmqVml/J24QD1eAl22MY02cPC7HoEOeu
	 swhQoIhYcUrZxtWvkiXK4Z/+BTHjWmh39FzFhfJsVabhuZn0/+5x/dKBV1YGUIP2D4
	 hgvB5sGMg5n/A==
Message-ID: <b170c705-c2a8-44ac-a77d-0c3c73ebed0a@zytor.com>
Date: Mon, 23 Jun 2025 09:34:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
To: Ethan Zhao <haifeng.zhao@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
References: <20250620231504.2676902-1-xin@zytor.com>
 <20250620231504.2676902-2-xin@zytor.com>
 <4018038c-8c96-49e0-b6b7-f54e0f52a65f@linux.intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <4018038c-8c96-49e0-b6b7-f54e0f52a65f@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/22/2025 11:49 PM, Ethan Zhao wrote:
> 
> 在 2025/6/21 7:15, Xin Li (Intel) 写道:
>> Initialize DR6 by writing its architectural reset value to avoid
>> incorrectly zeroing DR6 to clear DR6.BLD at boot time, which leads
>> to a false bus lock detected warning.
>>
>> The Intel SDM says:
>>
>>    1) Certain debug exceptions may clear bits 0-3 of DR6.
>>
>>    2) BLD induced #DB clears DR6.BLD and any other debug exception
>>       doesn't modify DR6.BLD.
>>
>>    3) RTM induced #DB clears DR6.RTM and any other debug exception
>>       sets DR6.RTM.
>>
>>    To avoid confusion in identifying debug exceptions, debug handlers
>>    should set DR6.BLD and DR6.RTM, and clear other DR6 bits before
>>    returning.
>>
>> The DR6 architectural reset value 0xFFFF0FF0, already defined as
>> macro DR6_RESERVED, satisfies these requirements, so just use it to
>> reinitialize DR6 whenever needed.
>>
>> Since clear_all_debug_regs() no longer zeros all debug registers,
>> rename it to initialize_debug_regs() to better reflect its current
>> behavior.
>>
>> Since debug_read_clear_dr6() no longer clears DR6, rename it to
>> debug_read_reset_dr6() to better reflect its current behavior.
>>
>> Reported-by: Sohil Mehta <sohil.mehta@intel.com>
>> Link: https://lore.kernel.org/lkml/06e68373-a92b-472e-8fd9- 
>> ba548119770c@intel.com/
>> Fixes: ebb1064e7c2e9 ("x86/traps: Handle #DB for bus lock")
>> Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
>> Tested-by: Sohil Mehta <sohil.mehta@intel.com>
>> Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
>> Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>> Cc: stable@vger.kernel.org
>> ---
>>
>> Changes in v3:
>> *) Polish initialize_debug_regs() (PeterZ).
>> *) Rewrite the comment for DR6_RESERVED definition (Sohil and Sean).
>> *) Collect TB, RB, AB (PeterZ and Sohil).
>>
>> Changes in v2:
>> *) Use debug register index 6 rather than DR_STATUS (PeterZ and Sean).
>> *) Move this patch the first of the patch set to ease backporting.
>> ---
>>   arch/x86/include/uapi/asm/debugreg.h | 21 ++++++++++++++++-
>>   arch/x86/kernel/cpu/common.c         | 24 ++++++++------------
>>   arch/x86/kernel/traps.c              | 34 +++++++++++++++++-----------
>>   3 files changed, 51 insertions(+), 28 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/ 
>> uapi/asm/debugreg.h
>> index 0007ba077c0c..41da492dfb01 100644
>> --- a/arch/x86/include/uapi/asm/debugreg.h
>> +++ b/arch/x86/include/uapi/asm/debugreg.h
>> @@ -15,7 +15,26 @@
>>      which debugging register was responsible for the trap.  The other 
>> bits
>>      are either reserved or not of interest to us. */
>> -/* Define reserved bits in DR6 which are always set to 1 */
>> +/*
>> + * Define bits in DR6 which are set to 1 by default.
>> + *
>> + * This is also the DR6 architectural value following Power-up, Reset 
>> or INIT.
>> + *
>> + * Note, with the introduction of Bus Lock Detection (BLD) and 
>> Restricted
>> + * Transactional Memory (RTM), the DR6 register has been modified:
>> + *
>> + * 1) BLD flag (bit 11) is no longer reserved to 1 if the CPU supports
>> + *    Bus Lock Detection.  The assertion of a bus lock could clear it.
>> + *
>> + * 2) RTM flag (bit 16) is no longer reserved to 1 if the CPU supports
>> + *    restricted transactional memory.  #DB occurred inside an RTM 
>> region
>> + *    could clear it.
>> + *
>> + * Apparently, DR6.BLD and DR6.RTM are active low bits.
>> + *
>> + * As a result, DR6_RESERVED is an incorrect name now, but it is kept 
>> for
>> + * compatibility.
>> + */
>>   #define DR6_RESERVED    (0xFFFF0FF0)
>>   #define DR_TRAP0    (0x1)        /* db0 */
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index 8feb8fd2957a..0f6c280a94f0 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -2243,20 +2243,16 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>>   #endif
>>   #endif
>> -/*
>> - * Clear all 6 debug registers:
>> - */
>> -static void clear_all_debug_regs(void)
>> +static void initialize_debug_regs(void)
>>   {
>> -    int i;
>> -
>> -    for (i = 0; i < 8; i++) {
>> -        /* Ignore db4, db5 */
>> -        if ((i == 4) || (i == 5))
>> -            continue;
>> -
>> -        set_debugreg(0, i);
>> -    }
>> +    /* Control register first -- to make sure everything is disabled. */
> 
> In the Figure 19-1. Debug Registers of SDM section 19.2 DEBUG REGISTERS,
> 
> bit 10, 12, 14, 15 of DR7 are marked as gray (Reversed) and their value 
> are filled as
> 
> 1, 0, 0,0 ; should we clear them all here ?  I didn't find any other 
> description in the
> 
> SDM about the result if they are cleaned. of course, this patch doesn't 
> change
> 
> the behaviour of original DR7 initialization code, no justification needed,
> 
> just out of curiosity.

This patch is NOT intended to make any actual change to DR7
initialization.

Please take a look at the second patch of this patch set.

Thanks!
     Xin

> 
>> +    set_debugreg(0, 7);
>> +    set_debugreg(DR6_RESERVED, 6);
>> +    /* dr5 and dr4 don't exist */
>> +    set_debugreg(0, 3);
>> +    set_debugreg(0, 2);
>> +    set_debugreg(0, 1);
>> +    set_debugreg(0, 0);

