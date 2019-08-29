Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B67A27DE
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 22:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfH2UWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 16:22:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45642 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfH2UWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 16:22:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id q12so4681380wrj.12
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 13:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r+qCAPQ3NqgeYdXXxqhqH68ikIu0Viwjapx5ijxXjyU=;
        b=qSAyYuEFzHTuSEpnmD5y/VU7xrnlGWh/FpHOaFJ4fWXyG7iOqs/jtiZFRUND2b+piz
         b6yzEZO5nM2z3QQm9GUhwUpzC4zTJn2MAP+GJSDlCvoDGNQu3ZyPLqJCFdEEOtrBC8Ho
         hSxaONG+N+OIezUJAUAu2dMdmRkh6ovH8+2d9kwOGcCmnxYqq8oMMzo5OgtaJ2EoGAgK
         Ujzyg71zDi1PkAea9386nhQM0EgpirlTM7aE/FjVAP2Lbp4iW50j6ihu/zPdnZapksl5
         s/s7L15Rl5H1wfRLMnz8vVFrYwWzfFavY5y9PkBGHtcm8wUhC0l1PZUrdGzs1KYWYumI
         jonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=r+qCAPQ3NqgeYdXXxqhqH68ikIu0Viwjapx5ijxXjyU=;
        b=kLWJV1437lmGkqoK5jIfEvNrGcF8fVsGKF86TZMYZl5z/kUnbrutB/izmCAbr7tCCr
         Eq1rIcihwQJ4R8+5G38XMQHfPQGUrv/4zLrYZbPhQzSSPxqqY2qSp+RLJxoiJj3xgyXG
         SJaENckMxdyLwDjXbhCFty/LA88xZYAePBfFpiFgcEnv8UZPe5CN0Oevfu9kmvHYFr13
         D4nKoCaPLf/AgH0KSv+rxpM8fLlQum8zSneUEnlfTdQTL+ydQelo3ZwXZdxa3yeGm670
         Dr5VMwDChrL4PuGwMJqBPa6KtrPUGhbDMq/4hHMes799Ur+I48Iu8bqGzj0zYjiXYDsG
         pNeA==
X-Gm-Message-State: APjAAAUKt3nentPbZ1HLF0NDGEx/zfYtmN7idcjgtDIoBuRxdzOF+aaW
        exhp8WIXXSPEyuYlpFRY7c7Zjw==
X-Google-Smtp-Source: APXvYqy/cNCdBUbxTrmtpwqrL0Sh+mPF8B8Kgh6UJOk87RK1uiecezcgRIYL2uR1Ii/686Bv3PYx9Q==
X-Received: by 2002:adf:f3d1:: with SMTP id g17mr13955054wrp.38.1567110162171;
        Thu, 29 Aug 2019 13:22:42 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:d9ce:7caa:c9ba:7f4c? ([2a01:e34:ed2f:f020:d9ce:7caa:c9ba:7f4c])
        by smtp.googlemail.com with ESMTPSA id m23sm4942510wml.41.2019.08.29.13.22.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 13:22:41 -0700 (PDT)
Subject: Re: Default governor regardless of cpuidle driver
To:     Joao Martins <joao.m.martins@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-pm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190829151027.9930-1-joao.m.martins@oracle.com>
 <c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com>
 <d1d4ade5-04a5-4288-d994-3963bb80fb6b@linaro.org>
 <6c8816af-934a-5bf7-6fb9-f67c05e2c8aa@oracle.com>
 <901ab688-5548-cf96-1dcb-ce50e617e917@linaro.org>
 <722bd6f6-6eee-b24b-9704-c9aecc06302f@oracle.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Openpgp: preference=signencrypt
Autocrypt: addr=daniel.lezcano@linaro.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2e2a35c8-7f03-d7c8-4701-3bc9d91c1255@linaro.org>
Date:   Thu, 29 Aug 2019 22:22:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <722bd6f6-6eee-b24b-9704-c9aecc06302f@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/08/2019 21:11, Joao Martins wrote:
> On 8/29/19 7:28 PM, Daniel Lezcano wrote:
>> On 29/08/2019 20:07, Joao Martins wrote:
>>> On 8/29/19 6:42 PM, Daniel Lezcano wrote:
>>>> On 29/08/2019 19:16, Joao Martins wrote:
>>>>> On 8/29/19 4:10 PM, Joao Martins wrote:
>>>>>> When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
>>>>>> past the online ones and thus fail to register the idle driver.
>>>>>> This is because cpuidle_add_sysfs() will return with -ENODEV as a
>>>>>> consequence from get_cpu_device() return no device for a non-existing
>>>>>> CPU.
>>>>>>
>>>>>> Instead switch to cpuidle_register_driver() and manually register each
>>>>>> of the present cpus through cpuhp_setup_state() callback and future
>>>>>> ones that get onlined. This mimmics similar logic that intel_idle does.
>>>>>>
>>>>>> Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
>>>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>>>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>>>>> ---
>>>>>
>>>>> While testing the above, I found out another issue on the haltpoll series.
>>>>> But I am not sure what is best suited to cpuidle framework, hence requesting
>>>>> some advise if below is a reasonable solution or something else is preferred.
>>>>>
>>>>> Essentially after haltpoll governor got introduced and regardless of the cpuidle
>>>>> driver the default governor is gonna be haltpoll for a guest (given haltpoll
>>>>> governor doesn't get registered for baremetal). Right now, for a KVM guest, the
>>>>> idle governors have these ratings:
>>>>>
>>>>>  * ladder            -> 10
>>>>>  * teo               -> 19
>>>>>  * menu              -> 20
>>>>>  * haltpoll          -> 21
>>>>>  * ladder + nohz=off -> 25
>>>>>
>>>>> When a guest is booted with MWAIT and intel_idle is probed and sucessfully
>>>>> registered, we will end up with a haltpoll governor being used as opposed to
>>>>> 'menu' (which used to be the default case). This would prevent IIUC that other
>>>>> C-states get used other than poll_state (state 0) and state 1.
>>>>>
>>>>> Given that haltpoll governor is largely only useful with a cpuidle-haltpoll
>>>>> it doesn't look reasonable to be the default? What about using haltpoll governor
>>>>> as default when haltpoll idle driver registers or modload.
>>>>
>>>> Are the guest and host kernel the same? IOW compiled with the same
>>>> kernel config?
>>>>
>>> You just need to toggle this (regardless off CONFIG_HALTPOLL_CPUIDLE):
>>>
>>> 	CONFIG_CPU_IDLE_GOV_HALTPOLL=y
>>>
>>> And *if you are a KVM guest* it will be the default (unless using nohz=off in
>>> which case ladder gets the highest rating -- see the listing right above).
>>>
>>> Host will just behave differently because the haltpoll governor is checking if
>>> it is running as kvm guest, and only registering in that case.
>>
>> I understood the problem. Actually my question was about if the kernels
>> are compiled for host and guest, and can be run indifferently. 
> 
> /nods Correct.
> 
>> In this
>> case a runtime detection must be done as you propose, otherwise that can
>> be done at config time. I pretty sure it is the former but before
>> thinking about the runtime side, I wanted to double check.
>>
> Hmm, but even with separate kernels/configs for guest and host I think we would
> still have the same issue.
> 
> What I was trying to convey is that even when running with a config solely for
> KVM guests (that is different than baremetal) you can have today various ways of
> idling. An Intel x86 kvm guest can have no idle driver (but arch-specific),
> intel_idle (like baremetal config) and haltpoll. There are usecases for these
> three, and makes sense to consolidate all.
> 
> Say you wanted to have a kvm specific config, you would still see the same
> problem if you happen to compile intel_idle together with haltpoll
> driver+governor. 

Can a guest work with an intel_idle driver?

> Creating two separate configs here, with and without haltpoll
> for VMs doesn't sound effective for distros.

Agree

> Perhaps decreasing the rating of
> haltpoll governor, but while a short term fix it wouldn't give much sensible
> defaults without the one-off runtime switch.




-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

