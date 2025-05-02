Return-Path: <kvm+bounces-45249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E93AA792C
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 20:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF57D1C047F5
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 18:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A65269811;
	Fri,  2 May 2025 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Ik1PM2pU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A04342A87;
	Fri,  2 May 2025 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746209422; cv=none; b=dZVLpDk76MBLh0Y9538xO/s7EchN8drZWbme7de1lrtIOwoFostyl5TNUAU5HB9r72hGQs8CYT/LgkXxHlgcMGBlo+Q6b0CWY/3I6hEmwhOsCYNAENukaYkkMTOql43BCAOWEKzYZAV10BK1+mdwY2n6NjJuFN/9+zJEW2ZwJ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746209422; c=relaxed/simple;
	bh=1wXTTHb5bXBrdK2EgccYQYFHa4IE2A2pICCNASrvymc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=euZt8aldPEb5N55H7c294NmxxViMoxWJ6UOWTkaftKyTYLaHxL31j7yWohnBw8U9U4ZvtZuoDwY+aOsxa9uSLCRgqaIuJZr2RF/DcwSsWTsnmx5NjXR5+si++hnEEsgxm7Af6169i78ef80yDXFiNG6IGa80VgeW3TGbouIfNKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Ik1PM2pU; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 542I9URm2109765
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 2 May 2025 11:09:30 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 542I9URm2109765
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1746209374;
	bh=vq/A29GwC24q+yBRNQofOThRodhc2pHOhalxWP8yF44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ik1PM2pUOLDwsjM0pqh49zNwLFsJWsVvCOj193iIxEYzWbmWmPkLOpNjbPdzrjX3v
	 011IuXpNubhbptoPBokYY/dElyxPQHBCRBjU3Lulkb2yxO4epZ6XSk5+/VuLkmyTKm
	 0Ud2Zan/4XorBw9nLxr1az3pZ8UdL1JipoDA4C6q89BQQ1lor7RIvGuJ3g6OnfiFiz
	 CnEXvlTclGzLsYNkl8D2WwBsbJipZUTOsHbneDfOJuaejckEKDSBWeybOIBPjijOO0
	 KGDNLUtdX+eqbIB7ygYhUbhkhUiAb06+5ytRj+5jyUF4CBn/8fUyg6Mi66qsYtwZ4H
	 VoszEMjA20uGw==
Message-ID: <2cbb468c-188e-4e6b-9b17-b60a66208c7a@zytor.com>
Date: Fri, 2 May 2025 11:09:29 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/15] x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
References: <20250427092027.1598740-1-xin@zytor.com>
 <20250427092027.1598740-3-xin@zytor.com> <aBR8EoYkxaFHwZN2@gmail.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aBR8EoYkxaFHwZN2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/2/2025 1:02 AM, Ingo Molnar wrote:
> 
> * Xin Li (Intel) <xin@zytor.com> wrote:
> 
>> index 94408a784c8e..13335a130edf 100644
>> --- a/arch/x86/include/asm/tsc.h
>> +++ b/arch/x86/include/asm/tsc.h
>> @@ -7,7 +7,81 @@
>>   
>>   #include <asm/cpufeature.h>
>>   #include <asm/processor.h>
>> -#include <asm/msr.h>
>> +
>> +/*
>> + * both i386 and x86_64 returns 64-bit value in edx:eax, but gcc's "A"
>> + * constraint has different meanings. For i386, "A" means exactly
>> + * edx:eax, while for x86_64 it doesn't mean rdx:rax or edx:eax. Instead,
>> + * it means rax *or* rdx.
>> + */
>> +#ifdef CONFIG_X86_64
>> +/* Using 64-bit values saves one instruction clearing the high half of low */
>> +#define DECLARE_ARGS(val, low, high)	unsigned long low, high
>> +#define EAX_EDX_VAL(val, low, high)	((low) | (high) << 32)
>> +#define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
>> +#else
>> +#define DECLARE_ARGS(val, low, high)	u64 val
>> +#define EAX_EDX_VAL(val, low, high)	(val)
>> +#define EAX_EDX_RET(val, low, high)	"=A" (val)
>> +#endif
> 
> Meh, this patch creates a duplicate copy of DECLARE_ARGS() et al in
> <asm/tsc.h> now:
> 
>   arch/x86/include/asm/msr.h:#define DECLARE_ARGS(val, low, high) unsigned long low, high
>   arch/x86/include/asm/msr.h:#define DECLARE_ARGS(val, low, high) u64 val
>   arch/x86/include/asm/msr.h:     DECLARE_ARGS(val, low, high);
>   arch/x86/include/asm/msr.h:     DECLARE_ARGS(val, low, high);
>   arch/x86/include/asm/msr.h:     DECLARE_ARGS(val, low, high);
>   arch/x86/include/asm/tsc.h:#define DECLARE_ARGS(val, low, high) unsigned long low, high
>   arch/x86/include/asm/tsc.h:#define DECLARE_ARGS(val, low, high) u64 val
>   arch/x86/include/asm/tsc.h:     DECLARE_ARGS(val, low, high);
>   arch/x86/include/asm/tsc.h:     DECLARE_ARGS(val, low, high);
>   arch/x86/include/asm/tsc.h:#undef DECLARE_ARGS
> 
> Which was both an undeclared change, bloats the code, causes various
> problems, and is totally unnecessary to boot.
> 
> Please don't do that ...

Learned!

Especially that every change needs to explicitly called out.

