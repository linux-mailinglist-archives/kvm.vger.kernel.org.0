Return-Path: <kvm+bounces-50353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D544AE45E7
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF42D441256
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADB125392C;
	Mon, 23 Jun 2025 13:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="wrg68tTn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27863253931
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750687039; cv=none; b=UYRf977T3JZLjDEnhVHhQha3H4SZH3YwvV2TXovvf5/tf7cGXnHmrnZMKYlRSyO7Kja2BgVmHCgVj1KIxXJRID/P+oPcm+sDu+nx9gR1p79RbAouD5KLlpL+rOrIRJC20KijbtiLQybCVjnxZLpXJmGUk0JZL3wL0cFRrsv5xG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750687039; c=relaxed/simple;
	bh=JA4Ap4uniGc8EhlXNUBWrVH5HkKK59LMxK1kdMaoz3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gTVEotgMkGxgWPBPxVcNF4mb1dhisy5KlAQNDposvUXtnqZuWD88TjnZ27LUrz5V7HHcJ+xANTVVNlqgxZI0dVYdp+H9h7z+l73ScWy/WhxO0qPclXbNw3ZP9hdRiTiyAEFaFzVrQ0fFAScCekShsTVjkLINFfqsnQkpLAkvfQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=wrg68tTn; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-74924255af4so1697343b3a.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 06:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750687037; x=1751291837; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zTlxzker4eZQaZq2c7C+rqM08Yt0/Vl0DoWOuB+bifc=;
        b=wrg68tTnkYKwa1m11EpBdRmcTlSHadRaBZnxggsANjMC8z8cN1OBLBFRlO/GIj2+yF
         qNc88sI84SpKxvKGf058fO9nsZZ72cWBgbPqm4faVcbSV/bQdi6+Hrb30sKME6T+fbZM
         P4ZLKm7Q8zsjZKaXIYKcR5Ksm8P6YErdNOjW1kQQHmJQ1bbFjALqo4xEODRYM+uBM1Np
         R1iIN0aCAO2v8wM5aHw+ICEth2W4Hvb1clGzmBwugBAM5H6YhtTNVQZvY9N1eOuanIzb
         atNGL4br/5x3UVbo/LQ5hvewKyupYIoS2W6jwdPMfDS+sq94ulKJIvSpn/vRdj5q3mRq
         1nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750687037; x=1751291837;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTlxzker4eZQaZq2c7C+rqM08Yt0/Vl0DoWOuB+bifc=;
        b=wa2xG3p5LtHMIlHBaakZxAwcVjMFV9mVn6GAhdmQHRg5/m0EmFaGlV3Mdpm/nL3XTM
         ssLJMPL8AvbV236QLJZpsKRvp05Pyce43Caf1FodPiLRcgcmD/TK/+PUo8B/aIsAxS6R
         1mvgHe9305avYArFyRQe94ZfF0rvmXYOgjKPnZqYxQloWcfTjoRkRNKF1mVfbuuoiNOy
         anRmsglM/MpUuzU+5iAGjn1Ov/h7jZmCR+JpRbcieQ0sEzLTBQE90xAfJboCB9KDgNM0
         8U1eKPnaZFhuTIg7+NptIyJl8OF0FGlBGZcH33DKhS7rQ9LGjd3WNOjtxNmGdd1gKMao
         co7A==
X-Forwarded-Encrypted: i=1; AJvYcCXzbWPt2gVYHdpzUfFR/dFVhMkROoyh01qjUMD4u/jN4yC0Jdjzppb/4N1trgFjicWp1Og=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbk2CSrYFWtF4NMVj+Kx+4SP0Z8IVB4mvf0hJpvBLL/96ml/VP
	5c9jAwgGfkXacMllTlnRumByZrpn16gym33re9j3KDQcxa0xjoh+paS6kXuy9UPrJCNxsLNW78/
	jKgCK
X-Gm-Gg: ASbGnct9xy3Rdym3SfPUNiRhN7ekQQdiupMJ0h2YNG2lgDvuvMlFnY59s+zmHUCA0ho
	JCf+k6/9GJPfZwRbIyDmZzrZWAO0TfiY6vWIfjWTNdCGgTgifkj761eC9kMr1lXxcJS9pXciA8C
	VMflB89uM88e1ZbmbV2YIV13ec5EqAtg0jbnqNOvdqEsMU4QM261rRX2E9SeCi2BQ6wbO26JNjK
	j+lStkZazm4o5WddsZaernKP5LFtYZPL7MDW79bTxCzwBBhJtr40fFex18zYgs7E2dGWrxqbO8t
	h+TM3jcxHItxR6Wqw7eYDLieq/0shBc4CHxz8S7I5CgLrggmQfz7x5ROCYv5mmg2iTd1GofZPXD
	Cot10CEe9mzM/udtMRTFKTYnbk4mnR2raUXpDze38AP4G/lWeBqRJ102DgCKB98m6JkHawZfKhV
	CBjKEr0nAnbIiVtWeJnFvxdq4qB2X28Q==
X-Google-Smtp-Source: AGHT+IEybgpPL2KEaKWsho1lKkLaHumPvuOVy1Z5DxPlNIstWu+of6VzVezAahzYKyQeuol+vCXFuw==
X-Received: by 2002:a05:6a21:4593:b0:215:ee6e:ee3b with SMTP id adf61e73a8af0-22026d8fb5cmr18799801637.15.1750687037390;
        Mon, 23 Jun 2025 06:57:17 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a621ceasm8774585b3a.97.2025.06.23.06.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 06:57:17 -0700 (PDT)
Message-ID: <0e086840-e0e3-4710-bcf4-14e889dbb096@grsecurity.net>
Date: Mon, 23 Jun 2025 15:57:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 0/8] x86: CET fixes and enhancements
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20250620153912.214600-1-minipli@grsecurity.net>
 <aFi9rUWBarenqfkK@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aFi9rUWBarenqfkK@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23.06.25 04:36, Chao Gao wrote:
> On Fri, Jun 20, 2025 at 05:39:04PM +0200, Mathias Krause wrote:
>> Hi,
>>
>> I'm playing with the CET virtualization patch set[1] and was looking at
>> the CET tests and noticed a few obvious issues with it (flushing the
>> wrong address) as well as some missing parts (testing far rets).
>>
>> [1] https://lore.kernel.org/kvm/20240219074733.122080-1-weijiang.yang@intel.com/
> 
> Hi Mathias,
> 
> Thank you.
> 
> I posted a series https://lore.kernel.org/kvm/20250513072250.568180-1-chao.gao@intel.com/
> to fix issues and add nested test cases. we may consider merging them into one series. e.g.,

Oh, I completely missed that one! I only looked at the KUT git tree.
Looks like Paolo / Sean haven't seen it yet either :/

But sure, happy to merge the patches! I'll apply your series locally and
will try to put still relevant changes on top. I'll probably send out an
updated series later this week.

Thanks,
Mathias

