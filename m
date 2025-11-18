Return-Path: <kvm+bounces-63540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D7419C6953A
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 13:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8A6BA3652C9
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 12:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2F3353899;
	Tue, 18 Nov 2025 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Nvl3z/sr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91092D1936
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 12:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763467840; cv=none; b=dTSIl0v9zLEj6ZT+yW2Rtk5dLs/TCdVFcZJAq2xT/4hsVfqQxQzaZrDLvFzk6dRUpXmf1VGuDZkBsTUPbXTcOuWyg0bwyGw+qH9y6KrxDP51qC/FeIIietWEk9jupPuq/iPsZCdxAzEUCnmC+C2D7ri1hRjg95ME7afhKxiOip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763467840; c=relaxed/simple;
	bh=1xz4uIVI+a44YEnI3ELHhMFnRvFbV3PbJPceLwJkXrE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=aKFHmtVry1vL/zUz8eo4iUzDMC6nCm1ERnLOEj1O+GOx30sPfv6GKwSVa3j2fOh1V6Ta/lfvLE7iZYeQaQ6/ynGwr69Jqtl16FUdy+0fA9tnJ6kBvLav48MrUyJPV7uk0FePv98DfVNi1Ngm9vVHTo9tUlta1LkRnu2fteoazPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Nvl3z/sr; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed82ee9e57so72268171cf.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 04:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763467837; x=1764072637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5cTSPvZXig8oNiEd2LL42DAJa1gzVENjQJ573LEoR0w=;
        b=Nvl3z/sr2zigyC29Gn0RMc08t5aWaPN0bxsLLlKiTbRtvXlK1bXFd+ZAvz4BwFgImt
         3OlG3sY26md79L5iZA0C35+uZCyirLLYtg2rNO1umgMpp9w//Fl97wHK/sAG4UDsnAG8
         BRUP0gQnCWRVUn9np6R5jwl8TmJ7gpkxuh7m+EsOE+PHCHwBQGcnnqxlSCez9hadfwQX
         GytnMSZaVkuoM6abDUjVQ6jXT23TStqu++z+WSHrjI6vC9R4PTkT9/bklwkETxM90HQB
         KpCWm88kIOzNNS79OItKft6tDXDrEQSBTbKtRj7Dvq1up1KwPi34SjyvLJftV/ssAIiD
         JV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763467837; x=1764072637;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cTSPvZXig8oNiEd2LL42DAJa1gzVENjQJ573LEoR0w=;
        b=LkEp+89fAAWgjT8g+RRXkbXLdZJ55txYZpmfRPiVJ1RE/t/pAZJd8eq58FdxBDCowD
         RjDSw/bIygMprQ5B/+dXC73pHtkv0NuOyy2UyXn5nxSt8LYpN3ADEu+CY1tifEDAqx17
         VadbWFa7+Dd1Uh6vZpYhw0eGkVq8CUobcPXPT0O0jBnY4M8z0FsHjr2ADLty+3GO5Y8j
         +R76vpMc4cttoJpMrp6AxSdyZJmiF1jfLJ+LjpKL4KkQKy2rv+s1Q8Gs9ITPEXRVvSMv
         xpIg9qcRnhBG7RxCmqAp4j9ozkzzbaUWYpRYSViwWU+/55ex5HqyQefHVge9t57Mnb64
         NLXQ==
X-Gm-Message-State: AOJu0Yyqu56Bc0g2qc5R3i6QJWN+DCIYoJ6qgdAanF3RNK8vT3lA3L5A
	MZjNwMI6ptHuKSpmY24prkJFjfroDdzrIxxQl0oCBUj/DpflNGTCzZcayUcPxKR1plk=
X-Gm-Gg: ASbGncsHL8ylLKTPkv7mjo+uvWW3CxbFSgYjF5ABabE2OYDzPdnCK8T/6AMT6LfTBIE
	Be+uL0bZLWIUfkTC01xcSlDOZEYBNR2rIvPkYzFdYeeTCVtWa1aPsqfgj3k+eyY7sJI6WvLYfmI
	wFp4jR8UsOw0udgP93apNUFfnqT/zqDNlpYImL3XcTZEnLlpY96BMoI0ctQpUmSOu2x6JE+rLXm
	GuU5IHp1VK2Kzy3OWwc46EjO5lBBPGSyJcnIWcUfOtQ0zcACAjmzXG5dIiOWQB2R84COIkRitmF
	PVEAHHZBuEw+GIl+QRAYjW10eXgxtondWnGbeEReGbUuXckpV7JGpLkLYb7I56VxnwYPZjnu1t1
	N259CAUDDV5Y/AERcKiRapd8CVIEWYYt+52eeme+k+7CCKaYBFi9UXci27nGKXNJ2mqUXgjDXpX
	XSbw7HL8NOFHo1N4tK/FBQfzIodpQvMxYhYOfIzD8vakKaK2eyT/RyBbYLjBTKMogJYCumZrnIn
	51mA2kNBj3KDmn+Ctl4ny4YssLcyJfeDurWIbqWJBIDIQ==
X-Google-Smtp-Source: AGHT+IGnfIxYe0h8UJDvO2bTv0cB8Y+k2CPXm6yvL/pdxTSqThcSgQe3TSeCNyndw81MbiRhfVsgAA==
X-Received: by 2002:a05:622a:47c4:b0:4ee:bff:69e0 with SMTP id d75a77b69052e-4ee0bff6b5fmr121032551cf.9.1763467836825;
        Tue, 18 Nov 2025 04:10:36 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee1bc0667bsm49625071cf.33.2025.11.18.04.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 04:10:36 -0800 (PST)
Message-ID: <8c930616-05ab-4406-8b57-26fa55031026@grsecurity.net>
Date: Tue, 18 Nov 2025 13:10:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <d67ede24-0b75-4bdb-bdc9-272b9608f632@grsecurity.net>
 <8a42b563-71b7-4bab-9f1d-248c81295704@grsecurity.net>
Content-Language: en-US, de-DE
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <8a42b563-71b7-4bab-9f1d-248c81295704@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18.11.25 12:56, Mathias Krause wrote:
> On 18.11.25 05:04, Mathias Krause wrote:
> [...]> After some sleep it makes lot more sense. Well, not really, but
it's a
> race that f01ea38a385a, apparently, makes easier to hit.
> 
>>
>> Below debug diff shows the issue:
>>
>> diff --git a/x86/vmx.c b/x86/vmx.c
>> index c803eaa67ac6..e49668f5ff95 100644
>> --- a/x86/vmx.c
>> +++ b/x86/vmx.c
>> @@ -806,4 +806,5 @@ asm(
>>         "       mov $1, %edi\n\t"
>>         "       call hypercall\n\t"
>> +       "       ud2"
>>  );
> That hypercall call shouldn't return, as it's HYPERCALL_VMEXIT which
> makes vmx_run() return and not re-enter the guest. But, apparently, it
> does so and it does so because the guest/VMM shared variable
> 'hypercall_field' to communicate to the VMM what to do can also be
> modified concurrently by the other CPU/guest #2 after it was written by
> CPU/guest #1 but before read by the VMM. Bummer!

Bleh, I messed up my test setup and it's not it. Back to square one.

