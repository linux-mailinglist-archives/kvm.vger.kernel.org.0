Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542204933D0
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 04:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351432AbiASDyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 22:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351390AbiASDyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 22:54:13 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D9FC061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 19:54:13 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 188so1170199pgf.1
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 19:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=As+hUVutO1ZU06X+Fr8CLVqO0TMk0HTA9Vzv1i8wCbs=;
        b=mk0vv1zXMkDMubyJZqG2vlBn8Zw++85rvxi1X4cJHBKCKUSmAsn9qMmpdxiagEAaUg
         9DP30D2mMcawp9yDPi6BYiBBXbY5aIsfXfGZkeZ8QEhE4iiTV1C4PHtu4Gpaw6LHr8DC
         l9s5rqCpnMRZgEcTtteXfYp5rKqufPNsr+/lX2E+MJ3W560wiaXrtE+wXyaEyqjucZAX
         pmW25a+bP4hlOUNuPunw3pyByvo9R1+XjramR/hMF2NWk5dsg/DRfZ5WRxdwOJRmjB0S
         1kCahW3Imhtny/l/Fw1+kAceIhByF2jE2jd5pZt4IG1+GUXWHraHij41txWhPIf1rxFn
         2OwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=As+hUVutO1ZU06X+Fr8CLVqO0TMk0HTA9Vzv1i8wCbs=;
        b=UstY5MbTTuG6yftcTeUrRP03kvW+qhFrF3ByqXkuwVLLx9KmCvbwnlF/+d/nEAktA8
         3L2nTQILqqSy2C3e2LI5cc9s+HIctUhGvumyZFVgXvgLb31SxJFnsfhS/iB+NzfMiaWS
         GsY95NmUyEnFb/+4PZLXATjpS/rPPz5OxkzQbVhp6QSxM3My33hNm6lBth+uCgQAuwCt
         QLoAxaAd66eoY2xoSsPsUoM+HOhN5STuITTb46ggXi97YpwOhV85Yi3U1LIsdmoa9GNQ
         VMU/OW4rEVg3cVNesjH2V+KXm4fupLFLNPpX9c/qC2LkUXi2exKcWsaGiV4FGt5tEqF+
         ukLA==
X-Gm-Message-State: AOAM532c3ZLh1mRYnItGqr3MNS2iZwHA9LteB+Q1kiDa7DfMZ9l6T6j0
        L12lK0NNjZFedvWjMLnY3Zc=
X-Google-Smtp-Source: ABdhPJw5ohI2V+ZAz4Ki6PPKoe9wW8ZtMKrhhQVloBMffw+/d70wF4989a1JUNsFSvYzcDmUXsgBnw==
X-Received: by 2002:a05:6a00:1946:b0:492:64f1:61b5 with SMTP id s6-20020a056a00194600b0049264f161b5mr28840876pfk.52.1642564452726;
        Tue, 18 Jan 2022 19:54:12 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k30sm6548431pgi.2.2022.01.18.19.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 19:54:12 -0800 (PST)
Message-ID: <4fd35b75-a79d-e6f6-1cca-49abda43206e@gmail.com>
Date:   Wed, 19 Jan 2022 11:54:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: PMU virtualization and AMD erratum 1292
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Ananth Narayan <ananth.narayan@amd.com>
References: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
 <453a2a09-5f29-491e-c386-6b23d4244cc2@gmail.com>
 <CALMp9eSkYEXKkqDYLYYWpJ0oX10VWECJTwtk_pBWY5G-vN5H0A@mail.gmail.com>
 <CALMp9eQAMpnJOSk_Rw+pp2amwi8Fk4Np1rviKYxJtoicas=6BQ@mail.gmail.com>
 <b3cffb4b-8425-06bb-d40e-89e7f01d5c05@gmail.com>
 <CALMp9eRhdLKq0Y372e+ZGnUCtDNQYv7pUiYL0bqJsYCDfqTpcQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eRhdLKq0Y372e+ZGnUCtDNQYv7pUiYL0bqJsYCDfqTpcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/1/2022 2:22 am, Jim Mattson wrote:
> On Mon, Jan 17, 2022 at 10:25 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 18/1/2022 12:08 pm, Jim Mattson wrote:
>>> On Mon, Jan 17, 2022 at 12:57 PM Jim Mattson <jmattson@google.com> wrote:
>>>>
>>>> On Sun, Jan 16, 2022 at 8:26 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>>> ...
>>>>> It's easy for KVM to clear the reserved bit PERF_CTL2[43]
>>>>> for only (AMD Family 19h Models 00h-0Fh) guests.
>>>>
>>>> KVM is currently *way* too aggressive about synthesizing #GP for
>>>> "reserved" bits on AMD hardware. Note that "reserved" generally has a
>>>> much weaker definition in AMD documentation than in Intel
>>>> documentation. When Intel says that an MSR bit is "reserved," it means
>>>> that an attempt to set the bit will raise #GP. When AMD says that an
>>>> MSR bit is "reserved," it does not necessarily mean the same thing.
>>
>> I agree. And I'm curious as to why there are hardly any guest user complaints.
>>
>> The term "reserved" is described in the AMD "Conventions and Definitions":
>>
>>          Fields marked as reserved may be used at some future time.
>>          To preserve compatibility with future processors, reserved fields require
>> special handling when
>>          read or written by software. Software must not depend on the state of a
>> reserved field (unless
>>          qualified as RAZ), nor upon the ability of such fields to return a previously
>> written state.
>>
>>          If a field is marked reserved *without qualification*, software must not change
>> the state of
>>          that field; it must reload that field with the same value returned from a prior
>> read.
>>
>>          Reserved fields may be qualified as IGN, MBZ, RAZ, or SBZ.
>>
>> For AMD, #GP comes from "Writing 1 to any bit that must be zero (MBZ) in the MSR."
>>
>>>> (Usually, AMD will write MBZ to indicate that the bit must be zero.)
>>>>
>>>> On my Zen3 CPU, I can write 0xffffffffffffffff to MSR 0xc0010204,
>>>> without getting a #GP. Hence, KVM should not synthesize a #GP for any
>>>> writes to this MSR.
>>>>
>>
>> ; storage behind bit 43 test
>> ; CPU family:          25
>> ; Model:               1
>>
>> wrmsr -p 0 0xc0010204 0x80000000000
>> rdmsr -p 0 0xc0010204 # return 0x80000000000
> 
> Oops. You're right. The host that I thought was a Zen3 was actually a
> Zen2. Switching to an actual Zen3, I find that there is storage behind
> bits 42 and 43, both of which are indicated as reserved.
> 
> 
>>>> Note that the value I get back from rdmsr is 0x30fffdfffff, so there
>>>> appears to be no storage behind bit 43. If KVM allows this bit to be
>>>> set, it should ensure that reads of this bit always return 0, as they
>>>> do on hardware.
>>
>> The PERF_CTL2[43] is marked reserved without qualification in the in Figure 13-7.
>>
>> I'm not sure we really need a cleanup storm of #GP for all SVM's non-MBZ
>> reserved bits.
> 
> OTOH, we wouldn't need to have this discussion if these MSRs had been
> implemented correctly to begin with.

So should KVM remove all #GP for AMD's non-MBZ reserved bits?

Not a small amount of work, plus almost none guest user complaints.

> 
>>>
>>> Bit 19 (Intel's old Pin Control bit) seems to have storage behind it.
>>> It is interesting that in Figure 13-7 "Core Performance Event-Select
>>> Register (PerfEvtSeln)" of the APM volume 2, this "reserved" bit is
>>> not marked in grey. The remaining "reserved" bits (which are marked in
>>> grey), should probably be annotated with "RAZ."
>>>
>>
>> In any diagram, we at least have three types of "reservation":
>>
>> - Reserved + grey
>> - Reserved, MBZ + grey
>> - Reserved + no grey
>>
>> So it is better not to think of "Reserved + grey" as "Reserved, MBZ + grey".
> 
> Right. None of these bits MBZ. I was observing that the grey fields
> RAZ. However, that observation was on Zen2. Zen3 is different. Now,
> it's not clear to me what the grey highlights mean. Perhaps nothing at
> all.

Anyway, does this fix [0] help with this issue, assuming AMD guys would come
up with a workaround for the host perf scheduler as usual ?

[0] https://lore.kernel.org/kvm/20220117055703.52020-1-likexu@tencent.com/
