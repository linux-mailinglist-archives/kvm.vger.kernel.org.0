Return-Path: <kvm+bounces-50743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF97AE8BFA
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 20:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFDC5680E92
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF522D5C8D;
	Wed, 25 Jun 2025 18:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="KPEIW0mO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A017D3F4;
	Wed, 25 Jun 2025 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750874761; cv=none; b=PnDB56NM8ZMxAeSY99LoaY3OxsWd0Na1+D8q8vcJxNU1gnM5f0oMWVxvUDjxh80J4gK1gLf6mICwVFp2MmPPIkhH1H1K5H4Zm3dKMNd4yc8JMeMCeVax0el8GMII+LWkJqP9Jhv6g35Q3dI2IqrgDk0xVx339hujCl5p5U2ZTEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750874761; c=relaxed/simple;
	bh=pbH+T4L44qFF+RjKR44BWtq7M4T8XhzszGTXxJBmILE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O4DpaRScuBsWbkosEgEoh5GiXynqGreXGepO1J4jb4bP1z9Rdv0wDvQtRu2ek6Mt/bWxWOBewwHCRMwf2y7PFYXPoq1p1QZNT/XxTCTxl0sxYTz9i4rMJZz4oIHC/6+GdfbEgGPYo5UtPKNuiBT4wSZPvcSJaKZRpCcZWciP6WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=KPEIW0mO; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55PI544F1878253
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 25 Jun 2025 11:05:05 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55PI544F1878253
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750874707;
	bh=uUIBwnF/NuuO4EITmYNvsIOIhSU28axy5Dd+n+kluw8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KPEIW0mOtLf4M5A0uDTpd1I6Chv53XOVonBfR2smAgqkJQjn2Wj4l0rJn2JywBej5
	 YXwtshhuGkybf4Vb/K9/y5cmYLzUR1twsJUh+ZLmZSJVO9LtiMlq0YnJ0q9IDapEj+
	 1dYrsljFe08yXhnHcxijgTZIJScll8+azU4en7BPWvHRV9iJCemunLgpHiKXOMAF88
	 Q5UBQk1oQ2lckzxXG2I8q+tpcQEJG9sNjHGIY4jlWVKfWpdJLB0DSPTkA64CftqxxU
	 8CEeKXGkGTsVBSe5rZs1OTD2FYyapuE27QnH65SfXYWTgdm15c5LNhuNJo1mdzqouW
	 cx09OumVwz0lw==
Message-ID: <2dc165c7-e3fd-48f6-bcfb-c2119fc94a54@zytor.com>
Date: Wed, 25 Jun 2025 11:05:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/19] KVM: x86: Allow FRED/LKGS to be advertised to
 guests
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, andrew.cooper3@citrix.com,
        luto@kernel.org, peterz@infradead.org, chao.gao@intel.com,
        xin3.li@intel.com
References: <20250328171205.2029296-1-xin@zytor.com>
 <20250328171205.2029296-16-xin@zytor.com> <aFrUg4BB-MXuYi3L@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aFrUg4BB-MXuYi3L@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/2025 9:38 AM, Sean Christopherson wrote:
> The shortlog (and changelog intro) are wrong.  KVM isn't allowing FRED/LKGS to
> be advertised to the guest.  Userspace can advertise whatever it wants.  The guest
> will break badly without KVM support, but that doesn't stop userspace from
> advertising a bogus vCPU model.
> 
>    KVM: x86: Advertise support for FRED/LKGS to userspace
> 
> On Fri, Mar 28, 2025, Xin Li (Intel) wrote:
>> From: Xin Li <xin3.li@intel.com>
>>
>> Allow FRED/LKGS to be advertised to guests after changes required to
> 
> Please explain what LKGS is early in the changelog.  I assumed it was a feature
> of sorts; turns out it's a new instruction.
> 
> Actually, why wait this long to enumerate support for LKGS?  I.e. why not have a
> patch at the head of the series to enumerate support for LKGS?  IIUC, LKGS doesn't
> depend on FRED.

I will send LKGS as a separate patch, thus if you prefer you can take
it before the KVM FRED patch set.

> 
>> enable FRED in a KVM guest are in place.
>>
>> LKGS is introduced with FRED to completely eliminate the need to swapgs
>> explicilty, because
>>
>> 1) FRED transitions ensure that an operating system can always operate
>>     with its own GS base address.
>>
>> 2) LKGS behaves like the MOV to GS instruction except that it loads
>>     the base address into the IA32_KERNEL_GS_BASE MSR instead of the
>>     GS segment’s descriptor cache, which is exactly what Linux kernel
>>     does to load a user level GS base.  Thus there is no need to SWAPGS
>>     away from the kernel GS base and an execution of SWAPGS causes #UD
>>     if FRED transitions are enabled.
>>
>> A FRED CPU must enumerate LKGS.  When LKGS is not available, FRED must
>> not be enabled.
>>
>> Signed-off-by: Xin Li <xin3.li@intel.com>
>> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>> Tested-by: Shan Kang <shan.kang@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 5e4d4934c0d3..8f290273aee1 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -992,6 +992,8 @@ void kvm_set_cpu_caps(void)
>>   		F(FZRM),
>>   		F(FSRS),
>>   		F(FSRC),
>> +		F(FRED),
>> +		F(LKGS),
> 
> These need to be X86_64_F, no?

Yes.  Both LKGS and FRED are 64-bit only features.

However I assume KVM is 64-bit only now, so X86_64_F is essentially F,
right?

Thanks!
     Xin

