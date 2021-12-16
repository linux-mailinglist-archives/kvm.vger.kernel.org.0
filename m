Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0000C476E68
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 10:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhLPJ5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 04:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbhLPJ5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 04:57:50 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9345BC061574;
        Thu, 16 Dec 2021 01:57:50 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id y7so19088840plp.0;
        Thu, 16 Dec 2021 01:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=p+g50/nPMbBJlHkMrAu9B1KrlTW/RtuLWeIz/ZN+pAk=;
        b=bJ8ipM6NCk3ag3kJ+gr+k5rJ2DMETnAWtHtlYDXSkEy/5x0tPuV+Y738hGiDzSKlY6
         bOAMzsNUuTQzWujyBNcaO4sYdPyIrU7Pa+W8SB/bWHbMgWpC3stzWde1l93vKMIRvjr/
         p8rrVRlc9oOrSmvOmf1sj1EGouX/T2B7aYuaGusVP133mQQPP0Ri1lTOWxscGOVTPt5h
         2WjxmZTeoYsv2E5jSZoz2fC0kt+DCJFUi3EQzCwy4wiHGRaFX2a3McAZMHxMmRZ16HZi
         +rjDOYnce+HGt2Mihwde6mMWoBNR79WUdFMACzIWFBIMprKMDKK9qtgmjvRmDbfW58Q+
         shEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=p+g50/nPMbBJlHkMrAu9B1KrlTW/RtuLWeIz/ZN+pAk=;
        b=YOwLSDFXsukxnQp/LWlz1TXKnJXtZMV7iGRfmE7U+NU5aetT1LK4tz7OCnhURCbCBi
         fzhKVc+yeYY10vlLyYvSHLVzrInQW2SA0y6Xt4J/J9kMaY8IgqRlhKyraHVsQfKTAt8d
         UC/YnbojGaFPXDnM2umlrQfrLHCJZJRHFYUPTWnihuLu61dyJfd4841v4i2WlqFlQa+Z
         /EX+DYGsBjBajSXepSvne6A8eTg+Vdi7x+TdUW81HOytq30Qk0PtExhtl6uQDn+LkaVc
         rZGXoy8RqKYpmQBsPGWRVe5/E84LANUXuA8xXJv7z0vAWz5ahHc4QEaH7hs0Qr9Ewp1W
         kfwg==
X-Gm-Message-State: AOAM530r98AOcQKdfSMKkad1Ou/oDAe1dXF0yxy64EFVpMEy5oV5POOC
        gdUWcPTYd+npG8+eGuO9neprWUlJq5w=
X-Google-Smtp-Source: ABdhPJzJ0Qp7Ed44yRKQHVRNAQdYWsIj19YInFvME3XroZbFgFkYQ11J5NQHUZU2SSsRE6P2Y593mg==
X-Received: by 2002:a17:90a:be06:: with SMTP id a6mr5072826pjs.131.1639648670121;
        Thu, 16 Dec 2021 01:57:50 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y12sm5109566pfe.140.2021.12.16.01.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 01:57:49 -0800 (PST)
Message-ID: <ed29b3a7-53f0-94b3-4d20-f460e8160d47@gmail.com>
Date:   Thu, 16 Dec 2021 17:57:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andi Kleen <ak@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-5-likexu@tencent.com>
 <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
 <0ca44f61-f7f1-0440-e1e1-8d5e8aa9b540@gmail.com>
 <CALMp9eTtsMuEsimONp7TOjJ-uskwJBD-52kZzOefSKXeCwn_5A@mail.gmail.com>
 <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com>
 <CALMp9eRy==yu1uQriqbeezeQ+mtFyfyP_iy9HdDiSZ27SnEfFg@mail.gmail.com>
 <c381aa2c-beb5-480f-1f24-a14de693e78f@redhat.com>
 <CALMp9eTKrQVCQPm=hcA50JSUCctPaGLEP19biVbGAtBN54dQfA@mail.gmail.com>
 <CALMp9eS8xDgdbfJTbzMmek3RcXKwkLdGMW-uMkJR3eJZ6sf0GA@mail.gmail.com>
 <CALMp9eThnOMnCkYp1LYM6Ph3NeB296QvXEWtn06A_1XtS+VCDA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor
 kvm_perf_overflow{_intr}()
In-Reply-To: <CALMp9eThnOMnCkYp1LYM6Ph3NeB296QvXEWtn06A_1XtS+VCDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/2021 2:37 pm, Jim Mattson wrote:
> On Sat, Dec 11, 2021 at 8:56 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Fri, Dec 10, 2021 at 3:31 PM Jim Mattson <jmattson@google.com> wrote:
>>>
>>> On Fri, Dec 10, 2021 at 2:59 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>>
>>>> On 12/10/21 23:55, Jim Mattson wrote:
>>>>>>
>>>>>> Even for tracing the SDM says "Like the value returned by RDTSC, TSC
>>>>>> packets will include these adjustments, but other timing packets (such
>>>>>> as MTC, CYC, and CBR) are not impacted".  Considering that "stand-alone
>>>>>> TSC packets are typically generated only when generation of other timing
>>>>>> packets (MTCs and CYCs) has ceased for a period of time", I'm not even
>>>>>> sure it's a good thing that the values in TSC packets are scaled and offset.
>>>>>>
>>>>>> Back to the PMU, for non-architectural counters it's not really possible
>>>>>> to know if they count in cycles or not.  So it may not be a good idea to
>>>>>> special case the architectural counters.
>>>>>
>>>>> In that case, what we're doing with the guest PMU is not
>>>>> virtualization. I don't know what it is, but it's not virtualization.

It's a use of profiling guest on the host side, like "perf kvm" and in that case,
we need to convert the guest's TSC values with the host view, taking into
account the guest TSC scaling.

>>>>
>>>> It is virtualization even if it is incompatible with live migration to a
>>>> different SKU (where, as you point out below, multiple TSC frequencies
>>>> might also count as multiple SKUs).  But yeah, it's virtualization with
>>>> more caveats than usual.
>>>
>>> It's not virtualization if the counters don't count at the rate the
>>> guest expects them to count.

We do have "Use TSC scaling" bit in the "Secondary Processor-Based VM-Execution 
Controls".

>>
>> Per the SDM, unhalted reference cycles count at "a fixed frequency."
>> If the frequency changes on migration, then the value of this event is
>> questionable at best. For unhalted core cycles, on the other hand, the
>> SDM says, "The performance counter for this event counts across
>> performance state transitions using different core clock frequencies."
>> That does seem to permit frequency changes on migration, but I suspect
>> that software expects the event to count at a fixed frequency if
>> INVARIANT_TSC is set.

Yes, I may propose that pmu be used in conjunction with INVARIANT_TSC.

> 
> Actually, I now realize that unhalted reference cycles is independent
> of the host or guest TSC, so it is not affected by TSC scaling.

I doubt it.

> However, we still have to decide on a specific fixed frequency to
> virtualize so that the frequency doesn't change on migration. As a
> practical matter, it may be the case that the reference cycles
> frequency is the same on all processors in a migration pool, and we
> don't have to do anything.

Yes, someone is already doing this in a production environment.

> 
> 
>> I'm not sure that I buy your argument regarding consistency. In
>> general, I would expect the hypervisor to exclude non-architected
>> events from the allow-list for any VM instances running in a
>> heterogeneous migration pool. Certainly, those events could be allowed
>> in a heterogeneous migration pool consisting of multiple SKUs of the
>> same microarchitecture running at different clock frequencies, but
>> that seems like a niche case.

IMO, if there are users who want to use the guest PMU, they definitely
want non-architectural events, even without live migration support.

Another input is that we actually have no problem reporting erratic
performance data during live migration transactions or host power
transactions, and there are situations where users want to know
that these kind of things are happening underwater.

The software performance tuners would not trust the perf data from
a single trial, relying more on statistical conclusions.

>>
>>
>>>>> Exposing non-architectural events is questionable with live migration,
>>>>> and TSC scaling is unnecessary without live migration. I suppose you
>>>>> could have a migration pool with different SKUs of the same generation
>>>>> with 'seemingly compatible' PMU events but different TSC frequencies,
>>>>> in which case it might be reasonable to expose non-architectural
>>>>> events, but I would argue that any of those 'seemingly compatible'
>>>>> events are actually not compatible if they count in cycles.
>>>> I agree.  Support for marshaling/unmarshaling PMU state exists but it's
>>>> more useful for intra-host updates than for actual live migration, since
>>>> these days most live migration will use TSC scaling on the destination.
>>>>
>>>> Paolo
>>>>
>>>>>
>>>>> Unless, of course, Like is right, and the PMU counters do count fractionally.
>>>>>
>>>>
> 
