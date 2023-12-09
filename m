Return-Path: <kvm+bounces-3985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA25280B410
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 12:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48D4A2810EF
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 11:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE7614281;
	Sat,  9 Dec 2023 11:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gpE8cWrc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D6C137
	for <kvm@vger.kernel.org>; Sat,  9 Dec 2023 03:57:26 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-a1f6433bc1eso339791166b.1
        for <kvm@vger.kernel.org>; Sat, 09 Dec 2023 03:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1702123045; x=1702727845; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mj9IkjGM5bRDRMCtZPs5pD8acnCJT6TuxhCGWsEoCBo=;
        b=gpE8cWrctNE5uq6ayiROwrSSvv5RMFp1Uod0s6dO2YgmjuAaBVq7kpKthAeDaa8Sh9
         PAeQNvTko6CMpD8TrCWJUts3a0d30pgX6bLAeK7Ni8+qLQCHdmdDepHsxX8vPxe+5w73
         FWPxR7KEvrpujSGcSfOMDWgYzU1gjJDpvJ2JfW0/1E9oQzlLIqJhioqXUut/LFoBuLWN
         83zudLSl0rVJ2j2ZJ9wT0WmCffYJGELNnj/qrzjxohra9op6+VbcaMv1H7T8p/opVvV1
         73H82jgdciBSSjzgZT1WaflwMhl5/+Xl29aisijFJexDf2rG1sUj8aLlgg/8rjia1IRp
         QPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702123045; x=1702727845;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mj9IkjGM5bRDRMCtZPs5pD8acnCJT6TuxhCGWsEoCBo=;
        b=vd2aNg/cE58jD/M/LD9SxQbjEHFA5D4ibRUJ+r9ZErjk36HeCnC4GteAg7yYlyVyQ8
         cOxCj2MsaXJIpzqVCKijijEJR+OupCCYPlZRsoSGrUHv6fNLQBBwc3bQb4wp5BdKHZ8o
         c+/XxKGGj5g/dG2oJS7gBMc1ZAzXIWzzVscp4IW610a5kq9Y1qdjz8jdS/XjjoQNJSI6
         XwOgl1MSU8Wj6Bd/TRx3qAoslmsfMv+GA6zGiiWOdA2143z1oBxDZUxuZMOdD3uURdT6
         4Ypm9UooOGmg1qkYbk6YmAW2vzjHCR6QXdv+zCkv/nJAyfCPO7pMTZ2Hoy0dqQ7pCh9d
         NdSA==
X-Gm-Message-State: AOJu0YytvU79gN3mx5IugG9lrGSknalvChAV8jLAFjhha+XHU9S1uJ4D
	nIrMDN5a2tYTrBFqTiQT7U8DFT3T9ddfLlAKn8a10A==
X-Google-Smtp-Source: AGHT+IGgta7Jxk34kweuhA8Cdq+Ns1KnaFrcUnCwE88ylKeOP19RsoEgQsESwXKcvcbLOsP25P5muA==
X-Received: by 2002:a17:907:da6:b0:a19:a409:37ce with SMTP id go38-20020a1709070da600b00a19a40937cemr2110755ejc.39.1702123045154;
        Sat, 09 Dec 2023 03:57:25 -0800 (PST)
Received: from ?IPV6:2a10:bac0:b000:731f:e6b0:e567:aab6:1db2? ([2a10:bac0:b000:731f:e6b0:e567:aab6:1db2])
        by smtp.gmail.com with ESMTPSA id mn6-20020a1709077b0600b00a18374ade6bsm2129793ejc.67.2023.12.09.03.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Dec 2023 03:57:24 -0800 (PST)
Message-ID: <b028a431-92e0-4440-adf9-6b855edb88c0@suse.com>
Date: Sat, 9 Dec 2023 13:57:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: User mutex guards to eliminate
 __kvm_x86_vendor_init()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231030141728.1406118-1-nik.borisov@suse.com>
 <ZT_UtjWSKCwgBxb_@google.com>
From: Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <ZT_UtjWSKCwgBxb_@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 30.10.23 г. 18:07 ч., Sean Christopherson wrote:
> On Mon, Oct 30, 2023, Nikolay Borisov wrote:
>> Current separation between (__){0,1}kvm_x86_vendor_init() is 
>> superfluos as
> 
> superfluous
> 
> But this intro is actively misleading.  The double-underscore variant 
> most definitely
> isn't superfluous, e.g. it eliminates the need for gotos reduces the 
> probability
> of incorrect error codes, bugs in the error handling, etc.  It _becomes_ 
> superflous
> after switching to guard(mutex).
> 
> IMO, this is one of the instances where the "problem, then solution" 
> appoach is
> counter-productive.  If there are no objections, I'll massage the change 
> log to
> the below when applying (for 6.8, in a few weeks).
> 
>   Use the recently introduced guard(mutex) infrastructure acquire and
>   automatically release vendor_module_lock when the guard goes out of 
> scope.
>   Drop the inner __kvm_x86_vendor_init(), its sole purpose was to simplify
>   releasing vendor_module_lock in error paths.
> 
>   No functional change intended.
> 
>> the the underscore version doesn't have any other callers.
>>


Has this fallen through the cracks as I don't see it in 6.7?

