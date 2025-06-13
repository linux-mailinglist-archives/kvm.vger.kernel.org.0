Return-Path: <kvm+bounces-49395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50011AD8507
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A3D317C32C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 425E726B767;
	Fri, 13 Jun 2025 07:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="BBLuDsW4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDEA1EA7E1;
	Fri, 13 Jun 2025 07:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749801127; cv=none; b=Gz6MhArM/aeYa+Aht9sb6VUdMau0pgjoXVIsD++BsJAoktrs7/O9m+OVDhGctbpHi5dEiy8CExiHjO8V8sYmqQL1rddI0/7R6tc6+wc8MiMMkseLfwA+GFJpZsEGgwMlFjMXwiCtkj1t/uBmPRK9GJuLJfWqZdeoNm+pQ+iMx1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749801127; c=relaxed/simple;
	bh=b0SVWHc3gp4FG6QvJ2KH53X69127OU4Pa6H6MdDkfZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uap9VJKf6DkoZ+wCzAZje9n+M9frJD8zxY8ILqrqjRyElW0I+n8/MeIPYc2GG2lRoQKcr5uVEEDm+ABPrxuByelZZ9iKCHX4K0ojWnG3oo9tbDeSIEOEeQNW1ydIUreX5PLoyAaI6oWRaL9LLLnrBEP5j/q2InN6TKRRcJLCemg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=BBLuDsW4; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55D7pWaG3710577
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 13 Jun 2025 00:51:32 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55D7pWaG3710577
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749801095;
	bh=4SWPN+8oXgcV1HAgVGKjs+YrH7d2EdR4S72zfpGcrwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BBLuDsW4t/tW1vImHGKq55Y712FkNOhlN4Dn3VxtwCxVOTH+2PsO5Ebiusi3rpBDp
	 aYjnqNGlcn2dsPvWJJkl73GT2zKbQsY+rC/Nx+IL+n4sX9lzBzFM05FRxJV7tj2d4I
	 kLIfBeFOtbicivS56GfvxOYVq8SLbX4b/SMY/rFx872PEqM4jrf6T9CKKe/vSHV/+l
	 owl9MZvhS61mdeKoceh0EtKqqfztLkD5U0YL2VG1jZ1qczVUqhT7RG7D3vpI68FL+J
	 ymvjUqz6CeWTqIdqYFKAHOWanBAnvN0y2hJfyNmMQeCoUaEccd08VDbPwpNKJ99tNH
	 9Kl20/jfEld+Q==
Message-ID: <f5ceeceb-d134-4d51-99d1-d8c6cfd7134f@zytor.com>
Date: Fri, 13 Jun 2025 00:51:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] x86/traps: Initialize DR7 by writing its
 architectural reset value
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
References: <20250613070118.3694407-1-xin@zytor.com>
 <20250613070118.3694407-3-xin@zytor.com>
 <20250613071536.GG2273038@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250613071536.GG2273038@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/2025 12:15 AM, Peter Zijlstra wrote:
> On Fri, Jun 13, 2025 at 12:01:16AM -0700, Xin Li (Intel) wrote:
> 
>> While at it, replace the hardcoded debug register number 7 with the
>> existing DR_CONTROL macro for clarity.
> 
> Yeah, not really a fan of that... IMO that obfuscates the code more than
> it helps, consider:
> 
>> -	get_debugreg(dr7, 7);
>> +	get_debugreg(dr7, DR_CONTROL);

Actually I kind of agree with you that it may not help, because I had
thought to rename DR7_RESET_VALUE to DR_CONTROL_RESET_VALUE.

Yes, we should remember DR7 is the control register, however I also hate
to decode it when looking at the code.


> 
> and:
> 
>> -	for (i = 0; i < 8; i++) {
>> -		/* Ignore db4, db5 */
>> -		if ((i == 4) || (i == 5))
>> -			continue;
>> +	/* Control register first */
>> +	set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
>> +	set_debugreg(0, DR_STATUS);
>>   
>> +	/* Ignore db4, db5 */
>> +	for (i = DR_FIRSTADDR; i <= DR_LASTADDR; i++)
> 
> I had to git-grep DR_{FIRST,LAST}ADDR to double check this was correct :(
> 
> Also, you now write them in the order:
> 
>    dr7, dr6, /* dr4, dr5 */, dr0, dr1, dr2, dr3
> 
> My OCD disagrees with this :-)
> 

The order of the other debug registers doesn't seem critical, however
the control debug register should be the first, right?

Here I prefer to use "control register" rather than "dr7" here :)

Thanks!
     Xin

