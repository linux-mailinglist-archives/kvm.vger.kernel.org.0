Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042BBA2938
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 23:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfH2Vvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 17:51:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35071 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfH2Vvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 17:51:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id g7so4942161wrx.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 14:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a+pc2ZK6ip9f10w36wuE0uTgxJ0ORyBREEL0adN4st0=;
        b=uZ7gYvuFxxXLJ0AI48bV1peOnU+47MgXGKBW8lzRy7hZ/tQTHGL7ShE2PgVaXPh3CG
         e9PRMNVMvZpy8TaYfaPh4y5jpQ4F5/X36gDmxAy10x1XtA6190iBK7diX9v8/8b2kuLt
         H0vfhgFxyyGro+sJ18h6TcpKtMdMnyNShmtRCZBV+IubRD68LgYTlAhbfLV8x2fEz1dE
         +8z7kbezZAdvjRFMi55zgZKuHmK/BXJb/VdQsx5l5DnA1/8dhtsM7fvzXTqE4NlIwZCs
         8veXQeTuqvQFIUjGZVqYs8L7Elcz3Sa/zsfjv2wE6e4P0oSGXDtgdic5642cbNkBc3t6
         NiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=a+pc2ZK6ip9f10w36wuE0uTgxJ0ORyBREEL0adN4st0=;
        b=J1NfIdmiPM15URhid6nUwwmIdAnySh91NMlDu5GtwBR16qoR2IjQMqyThix3ZjAsgC
         dv5KZAZ1vTy/AzI4F1JSKcCHQKGkkZebkADO3+4iNIfrdddnOVf7gyYHHo95/RqISaAf
         lw0u6i0xKwZMCD4GOcCmQ0AN/BK49KdMESCA73t42Zq5QaD7YWZ1QLSlNfWw/0/s99ME
         lGv1j3GsHIPZ0uMFuTwEY5FmM/GSUxxaQZaGpwm8AV9Jteafkt9CsBjCPqjb+4V6xoEK
         8s9KBbvNQyCgi3QRZBBRdzS4JcwmR3sFqBazuiZHgkc2NVNJ0Wl1QGyHklAGjaHrs2Tg
         Nq0A==
X-Gm-Message-State: APjAAAUY4lTQdSed8k0zu5J6rGKV+mg985dxazGyjDFMOwWNIa85mTfq
        O5GmkzWVp8vMKs/pXccY8+MTfQ==
X-Google-Smtp-Source: APXvYqwcJvLgWiR9xO8uYbzgaktiUNcuPwuuDFj7cLjIOj8rSTAY6krtwYIcFl8q4NmW3Z9/5uw8EQ==
X-Received: by 2002:a5d:6a45:: with SMTP id t5mr12230298wrw.228.1567115508416;
        Thu, 29 Aug 2019 14:51:48 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:d9ce:7caa:c9ba:7f4c? ([2a01:e34:ed2f:f020:d9ce:7caa:c9ba:7f4c])
        by smtp.googlemail.com with ESMTPSA id o14sm10135990wrg.64.2019.08.29.14.51.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 14:51:47 -0700 (PDT)
Subject: Re: Default governor regardless of cpuidle driver
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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
 <2e2a35c8-7f03-d7c8-4701-3bc9d91c1255@linaro.org>
 <f8c63af5-2509-310d-7ba0-7687b20e3b44@oracle.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Openpgp: preference=signencrypt
Autocrypt: addr=daniel.lezcano@linaro.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <b759d5a9-f418-817e-eefa-2302d17cb6ea@linaro.org>
Date:   Thu, 29 Aug 2019 23:51:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f8c63af5-2509-310d-7ba0-7687b20e3b44@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/08/2019 23:12, Joao Martins wrote:

[ ... ]

>>> Say you wanted to have a kvm specific config, you would still see the same
>>> problem if you happen to compile intel_idle together with haltpoll
>>> driver+governor. 
>>
>> Can a guest work with an intel_idle driver?
>>
> Yes.
> 
> If you use Qemu you would add '-overcommit cpu-pm=on' to try it out. ofc,
> assuming you're on a relatively recent Qemu (v3.0+) and a fairly recent kernel
> version as host (v4.17+).

Ok, thanks for the clarification.

>>> Creating two separate configs here, with and without haltpoll
>>> for VMs doesn't sound effective for distros.
>>
>> Agree
>>
>>> Perhaps decreasing the rating of
>>> haltpoll governor, but while a short term fix it wouldn't give much sensible
>>> defaults without the one-off runtime switch.

The rating has little meaning because each governor fits a specific
situation (server, desktop, etc...) and it would probably make sense to
remove it and add a default governor in the config file like the cpufreq.

May be I missed the point from some previous discussion but IMHO the
problem you are facing is coming from the design: there is no need to
create a halt governor but move the code inside the cpuidle-halt driver
instead and ignore the state asked by the governor and return the state
the driver entered.



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

