Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FA23D0EA1
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 14:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbhGUL3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 07:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhGUL3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 07:29:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E73C061574;
        Wed, 21 Jul 2021 05:10:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g24so1528306pji.4;
        Wed, 21 Jul 2021 05:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ik8G/1vteSJbfR+LBOlD27tSJ2iU7J9ntHCUgQlrJQ=;
        b=HKUBYR4jF9tk3KU3jxUqcjq2lY9UxmO4b1Z26y9VH2DQZKoDJvOnl608BSCnSTo0nL
         T0p2cgN5opHiNqFyWC3Qg+XlTrwihLkeTB4ep3widZzrwr0yFtH/BQQvDr4kDMEmejUl
         /NcRw4zeBWxKC743BtpeRba3BVyFU5T+n7PtZpb77yBWxRj1zkTct3XaLeE+aPVrpQ4z
         ZXneIXbeJOFjyGGOWNiOiGsHn6KiCIpGOPfqu/HGQgoPncenZRiJYw1Ly3JKYStZ8Rhv
         hLF4J6wurSkTNwnw3rOTKBXxe2RmcmUVctQE/zUMPFtEanVNRvruz7nBnoLjLuMFyNZ+
         rxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ik8G/1vteSJbfR+LBOlD27tSJ2iU7J9ntHCUgQlrJQ=;
        b=JGLx9xmRSranZMUBKY+9JAcPO5CrLT/o85LdNAMiTV8I5A432NgwKrp2gohhgTD4oW
         XiiFnLv9rUeY2n7KX5xvVSjoOk9womjKLZ3FY11FW+PGuXvBqpVlzTHf+UK+n7kQluGd
         AyF5kTYgVL3nNmeTwFTGybO2Xlo9TdqJw84kvx9ME0DlbdNJktv0kubu3ETC4Dl2v+c4
         /Je0+y1wcvQ2H5u0YOk0GC6dYmwHR8KeBqeLBYZyXqBeujjTWEze6iFbU+/52p+WiKmI
         bDpy3O8gwz+UEFmqkQeDelu3YhVS4zQ5h5e+mH3fhJoydrFCaAtxFoYFDla98EibKjRo
         GL+w==
X-Gm-Message-State: AOAM530vqf1Gomc5BlP5vnobSD1WS9VzDhBbYGH5MUe/SK8vIUKg5Jl4
        vkX5N1Lh4hQc6nEbw4wUIV0=
X-Google-Smtp-Source: ABdhPJwegrQgdhVtK7JZrptFsAqrZodnPUMs5MR0fpEGOhPAqO9AFyuS688DoZ2NZ459ufZUPd80iQ==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr3563327pjq.88.1626869422556;
        Wed, 21 Jul 2021 05:10:22 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y2sm9350282pfe.146.2021.07.21.05.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 05:10:21 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, peterz@infradead.org,
        pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, boris.ostrvsky@oracle.com,
        "Liang, Kan" <kan.liang@linux.intel.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <CALMp9eSz6RPN=spjN6zdD5iQY2ZZDwM2bHJ2R4qWijOt1A_6aw@mail.gmail.com>
 <b6568241-02e3-faf6-7507-c7ad1c4db281@linux.intel.com>
 <CALMp9eT48THXwEG23Kb0-QExyA8qZAtkXxrxc+6+pdvtvVVN0A@mail.gmail.com>
 <7c3d3ab5-191f-bd5b-f801-de5ebf68cfee@linux.intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH V8 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
Message-ID: <713471d3-ab05-7884-66fd-1efff9f6aeea@gmail.com>
Date:   Wed, 21 Jul 2021 20:10:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7c3d3ab5-191f-bd5b-f801-de5ebf68cfee@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/7/2021 8:41 am, Liang, Kan wrote:
> 
> 
> On 7/16/2021 5:07 PM, Jim Mattson wrote:
>> On Fri, Jul 16, 2021 at 12:00 PM Liang, Kan 
>> <kan.liang@linux.intel.com> wrote:
>>>
>>>
>>>
>>> On 7/16/2021 1:02 PM, Jim Mattson wrote:
>>>> On Fri, Jul 16, 2021 at 1:54 AM Zhu Lingshan 
>>>> <lingshan.zhu@intel.com> wrote:
>>>>>
>>>>> The guest Precise Event Based Sampling (PEBS) feature can provide an
>>>>> architectural state of the instruction executed after the guest 
>>>>> instruction
>>>>> that exactly caused the event. It needs new hardware facility only 
>>>>> available
>>>>> on Intel Ice Lake Server platforms. This patch set enables the 
>>>>> basic PEBS
>>>>> feature for KVM guests on ICX.
>>>>>
>>>>> We can use PEBS feature on the Linux guest like native:
>>>>>
>>>>>      # echo 0 > /proc/sys/kernel/watchdog (on the host)
>>>>>      # perf record -e instructions:ppp ./br_instr a
>>>>>      # perf record -c 100000 -e instructions:pp ./br_instr a
>>>>>
>>>>> To emulate guest PEBS facility for the above perf usages,
>>>>> we need to implement 2 code paths:
>>>>>
>>>>> 1) Fast path
>>>>>
>>>>> This is when the host assigned physical PMC has an identical index 
>>>>> as the
>>>>> virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
>>>>> This path is used in most common use cases.
>>>>>
>>>>> 2) Slow path
>>>>>
>>>>> This is when the host assigned physical PMC has a different index 
>>>>> from the
>>>>> virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0) In 
>>>>> this case,
>>>>> KVM needs to rewrite the PEBS records to change the applicable 
>>>>> counter indexes
>>>>> to the virtual PMC indexes, which would otherwise contain the 
>>>>> physical counter
>>>>> index written by PEBS facility, and switch the counter reset values 
>>>>> to the
>>>>> offset corresponding to the physical counter indexes in the DS data 
>>>>> structure.
>>>>>
>>>>> The previous version [0] enables both fast path and slow path, 
>>>>> which seems
>>>>> a bit more complex as the first step. In this patchset, we want to 
>>>>> start with
>>>>> the fast path to get the basic guest PEBS enabled while keeping the 
>>>>> slow path
>>>>> disabled. More focused discussion on the slow path [1] is planned 
>>>>> to be put to
>>>>> another patchset in the next step.
>>>>>
>>>>> Compared to later versions in subsequent steps, the functionality 
>>>>> to support
>>>>> host-guest PEBS both enabled and the functionality to emulate guest 
>>>>> PEBS when
>>>>> the counter is cross-mapped are missing in this patch set
>>>>> (neither of these are typical scenarios).
>>>>
>>>> I'm not sure exactly what scenarios you're ruling out here. In our
>>>> environment, we always have to be able to support host-level
>>>> profiling, whether or not the guest is using the PMU (for PEBS or
>>>> anything else). Hence, for our *basic* vPMU offering, we only expose
>>>> two general purpose counters to the guest, so that we can keep two
>>>> general purpose counters for the host. In this scenario, I would
>>>> expect cross-mapped counters to be common. Are we going to be able to
>>>> use this implementation?
>>>>
>>>
>>> Let's say we have 4 GP counters in HW.
>>> Do you mean that the host owns 2 GP counters (counter 0 & 1) and the
>>> guest own the other 2 GP counters (counter 2 & 3) in your envirinment?
>>> We did a similar implementation in V1, but the proposal has been denied.
>>> https://lore.kernel.org/kvm/20200306135317.GD12561@hirez.programming.kicks-ass.net/ 
>>>
>>
>> It's the other way around. AFAIK, there is no architectural way to
>> specify that only counters 2 and 3 are available, so we have to give
>> the guest counters 0 and 1.
> 
> How about the host? Can the host see all 4 counters?
> 
>>
>>> For the current proposal, both guest and host can see all 4 GP counters.
>>> The counters are shared.
>>
>> I don't understand how that can work. If the host programs two
>> counters, how can you give the guest four counters?
>>
>>> The guest cannot know the availability of the counters. It may requires
>>> a counter (e.g., counter 0) which may has been used by the host. Host
>>> may provides another counter (e.g., counter 1) to the guest. This is the
>>> case described in the slow path. For this case, we have to modify the
>>> guest PEBS record. Because the counter index in the PEBS record is 1,
>>> while the guest perf driver expects 0.
>>
>> If we reserve counters 0 and 1 for the guest, this is not a problem
>> (assuming we tell the guest it only has two counters). If we don't
>> statically partition the counters, I don't see how you can ensure that
>> the guest behaves as architected. For example, what do you do when the
>> guest programs four counters and the host programs two?
> 
> Ideally, we should do multiplexing if the guest requires four and the 
> host requires two. But I doubt this patch set implements the 
> multiplexing, because the multiplexing should be part of the slow path, 
> which will be supported in the next step.
> 
> Could you please share more details regarding your environment?

Jim, would you mind sharing more details about the statically
partitioned hardware counters in your virtualization scenario ?

It may be useful for subsequent designs for advanced PEBS features.
Otherwise we will follow the sharing rules defined by perf subsystem.

> How do you handle the case that guest programs two counters and the host 
> programs four counters?
> 
>>
>>> If counter 0 is available, guests can use counter 0. That's the fast
>>> path. I think the fast path should be more common even both host and
>>> guest are profiling. Because except for some specific events, we may
>>> move the host event to the counters which are not required by guest if
>>> we have enough resources.
>>
>> And if you don't have enough resources? 
> 
> As my understanding, multiplexing should be the only choice if we don't 
> have enough resources.
> 
> Thanks,
> Kan
