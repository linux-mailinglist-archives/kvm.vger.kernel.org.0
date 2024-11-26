Return-Path: <kvm+bounces-32542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFB99D9DFD
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 20:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56BAB163C9A
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 19:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73FD1DE8AB;
	Tue, 26 Nov 2024 19:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LaSbl+o3"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AB0155321;
	Tue, 26 Nov 2024 19:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732648997; cv=none; b=LcaTY9HXu6A/9ZETam4LU0gJ0zlyosnqGn/MmS0xAqwlbrTgsF4Oxc48MBq7XRIoVaO9Q614J/fInNsBflBIo4exrVbFOBuNZcq3gDicwjxSlX5JK6xeP8YTGEMuff9L6IvZqiNiz5BFeVtqUhElTJGuAVtQ7NF9LkRVB4Jw/lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732648997; c=relaxed/simple;
	bh=Zfhini+GVv5bq6VOaUi1V1RUEDaYr0lOcPsJ6obU1tM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XPeRoOJ7ovEdGA940UAOLK0h2ZYfhDQ2+zMSBrNdZgcUK9hysQsa+0Vw1IOeB4oeJ0Fn/Th0Ztb+zQKlmhJPF2E/tMh5Y9CPo2WfcHXmEG3sGDwv5mqIidPh2lFZe2GvXYpvXhAmM8nFBBuNpYbYzG7w/r9O+6MT+vOIEvV4ZH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LaSbl+o3; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.205] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4AQJMjF51617016
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 26 Nov 2024 11:22:46 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4AQJMjF51617016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1732648967;
	bh=Tr04QomOx3lXyUJ8bNdm/pa60hf4Db7a7UcA66jhfgc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LaSbl+o3KD3YPZYPJ8p1ms14vOdw0V3gvNOWqMUOOpmdX18u6CUNu4p92qX1cCN3g
	 hSsNkLRPvl2CRAhIpqrsQnozikLXFHqGpLhJAEljRSUoEt94IaVJYgw5zGOyskwtNY
	 XPDqt4Plr2OIMrPD2sjq7PxKS5R7A2qMtz+xkWwU1y92Scw2ji8zwovuHJ59ok7CTG
	 XdYQ9/Zino6gRi8oWxq08CO0rkxWrOtVJioF0Z+fcxYa1g2nMyy0Sy9JW0FMHtG2M2
	 Yq351SPW2VcTVQWbGTrcYZWgNaKFJjbrcjIFmW0m1EgsZJdz+W5YvrHtY4oC+Jlmj8
	 w2G15euEkyJtQ==
Message-ID: <e7f6e7c2-272a-4527-ba50-08167564e787@zytor.com>
Date: Tue, 26 Nov 2024 11:22:45 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/27] KVM: VMX: Do not use
 MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-10-xin@zytor.com>
 <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/2024 10:02 AM, Borislav Petkov wrote:
> On Mon, Sep 30, 2024 at 10:00:52PM -0700, Xin Li (Intel) wrote:
>> No need to use MAX_POSSIBLE_PASSTHROUGH_MSRS in the definition of array
>> vmx_possible_passthrough_msrs, as the macro name indicates the _possible_
>> maximum size of passthrough MSRs.
>>
>> Use ARRAY_SIZE instead of MAX_POSSIBLE_PASSTHROUGH_MSRS when the size of
>> the array is needed and add a BUILD_BUG_ON to make sure the actual array
>> size does not exceed the possible maximum size of passthrough MSRs.
> 
> This commit message needs to talk about the why - not the what. Latter should
> be visible from the diff itself.

I should not write such a changelog...

> What you're not talking about is the sneaked increase of
> MAX_POSSIBLE_PASSTHROUGH_MSRS to 64. Something you *should* mention because
> the array is full and blablabla...

It's still far from full in a bitmap on x86-64, but just that the
existing use of MAX_POSSIBLE_PASSTHROUGH_MSRS tastes bad.


A better one?

Per the definition, a bitmap on x86-64 is an array of 'unsigned long',
and is at least 64-bit long.

#define DECLARE_BITMAP(name,bits) \
	unsigned long name[BITS_TO_LONGS(bits)]

It's not accurate and error-prone to use a hard-coded possible size of
a bitmap, Use ARRAY_SIZE with an overflow build check instead.

> 
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index e0d76d2460ef..e7409f8f28b1 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -356,7 +356,7 @@ struct vcpu_vmx {
>>   	struct lbr_desc lbr_desc;
>>   
>>   	/* Save desired MSR intercept (read: pass-through) state */
>> -#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
>> +#define MAX_POSSIBLE_PASSTHROUGH_MSRS	64
> 						^^^
> 


