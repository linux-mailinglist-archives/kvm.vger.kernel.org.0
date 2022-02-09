Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E01B4AEF42
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 11:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiBIK0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 05:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiBIK0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 05:26:10 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE3EE091ED2;
        Wed,  9 Feb 2022 02:18:59 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 9so554649pfx.12;
        Wed, 09 Feb 2022 02:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=T1Hj+tSM9t+g8VeOB7lokNQ899yMgNewNvSOg9nMbik=;
        b=i5jSnodjNDPdvY+9fXQPC6S+YwkOqrneed3MWyePypm5iXeKekItraCbANxEeUv1lW
         GWUzsD+hBVVOOxmxXBrmWQy72qaMxDhMQbIP/eMJ4i2cmC5hGx82CTS+nMG6lJ0D6Nw8
         xjjpAxaIfaKSY5bWaXDwye7SkJJ0sfFu2QYNgl6zEJr0Py8gPjfBTKhJl7PlZg+yRaIk
         w/s215n5PrwRInR4PDtBMAFa3HEM0FoAn6cQ4U8RnB0LudCylCDohxF5yEhpix15OXC/
         5ksJVneYhG1lxHi02SoYq/Rfnyj3vW98jkxVeIWg6ufFujZwl8KMHmmC8KWk6s6KXLCM
         9PTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=T1Hj+tSM9t+g8VeOB7lokNQ899yMgNewNvSOg9nMbik=;
        b=IQ55P3WfCRSPw9NpiZ1Y97OegmTJi7IypA9zvrKbUwMSF0pBF8fH9o7Vs9G9sLRha0
         eGxjrvCDzD+1dYRalvLIgC7A9X7U2sULJnq6MtuEjRwRvxxX1YVJ3nz9qwF6bHbrunde
         S+srg4UR/QgvmSjbQALd9y07/v2IE/jbi6wQspv8DslxHVQyePnxajGQFOijjsmTikJi
         SlJUd/Vwm08rWjMAdFkaD885HLaBxC5TTD1PVto01cr1c3Qvxoeh6UUMvBtDfim370QR
         CwBwsBoq+LDBTtY44HCs3LYSonipeYSMhGB1CjbpZ2YdSEyht1Vhq9Qu+/suyfmc/3mq
         hySQ==
X-Gm-Message-State: AOAM531IlZpFgMQC1YLdxseiRaciq+QlsWFE58KaKbRfAlGWK5K69or+
        Lp+rb9KVcxLgK4i2y8i3weY=
X-Google-Smtp-Source: ABdhPJyxJuVMgoBUcN0nOvAFED4KoL/Lm4G5W2DRDA9avA4NWlt4GblW8pUs0QdLxFWVUSx28/jd3w==
X-Received: by 2002:aa7:9404:: with SMTP id x4mr1637147pfo.37.1644401938196;
        Wed, 09 Feb 2022 02:18:58 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g20sm19995520pfj.196.2022.02.09.02.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 02:18:57 -0800 (PST)
Message-ID: <e58ca80c-b54c-48b3-fb0b-3e9497c877b7@gmail.com>
Date:   Wed, 9 Feb 2022 18:18:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     eranian@google.com, santosh.shukla@amd.com, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        joro@8bytes.org, peterz@infradead.org, mingo@redhat.com,
        alexander.shishkin@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com
References: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
 <20220202105158.7072-1-ravi.bangoria@amd.com>
 <CALMp9eQHfAgcW-J1YY=01ki4m_YVBBEz6D1T662p2BUp05ZcPQ@mail.gmail.com>
 <3c97e081-ae46-d92d-fe8f-58642d6b773e@amd.com>
 <CALMp9eS72bhP=hGJRzTwGxG9XrijEnGKnJ-pqtHxYG-5Shs+2g@mail.gmail.com>
 <9b890769-e769-83ed-c953-d25930b067ba@amd.com>
 <CALMp9eQ9K+CXHVZ1zSyw78n-agM2+NQ1xJ4niO-YxSkQCLcK-A@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eQ9K+CXHVZ1zSyw78n-agM2+NQ1xJ4niO-YxSkQCLcK-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/2/2022 9:01 pm, Jim Mattson wrote:
> On Fri, Feb 4, 2022 at 1:33 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>
>>
>>
>> On 03-Feb-22 11:25 PM, Jim Mattson wrote:
>>> On Wed, Feb 2, 2022 at 9:18 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>
>>>> Hi Jim,
>>>>
>>>> On 03-Feb-22 9:39 AM, Jim Mattson wrote:
>>>>> On Wed, Feb 2, 2022 at 2:52 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>>>
>>>>>> Perf counter may overcount for a list of Retire Based Events. Implement
>>>>>> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
>>>>>> Revision Guide[1]:
>>>>>>
>>>>>>    To count the non-FP affected PMC events correctly:
>>>>>>      o Use Core::X86::Msr::PERF_CTL2 to count the events, and
>>>>>>      o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>>>>>>      o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
>>>>>>
>>>>>> Note that the specified workaround applies only to counting events and
>>>>>> not to sampling events. Thus sampling event will continue functioning
>>>>>> as is.
>>>>>>
>>>>>> Although the issue exists on all previous Zen revisions, the workaround
>>>>>> is different and thus not included in this patch.
>>>>>>
>>>>>> This patch needs Like's patch[2] to make it work on kvm guest.
>>>>>
>>>>> IIUC, this patch along with Like's patch actually breaks PMU
>>>>> virtualization for a kvm guest.
>>>>>
>>>>> Suppose I have some code which counts event 0xC2 [Retired Branch
>>>>> Instructions] on PMC0 and event 0xC4 [Retired Taken Branch
>>>>> Instructions] on PMC1. I then divide PMC1 by PMC0 to see what
>>>>> percentage of my branch instructions are taken. On hardware that
>>>>> suffers from erratum 1292, both counters may overcount, but if the
>>>>> inaccuracy is small, then my final result may still be fairly close to
>>>>> reality.
>>>>>
>>>>> With these patches, if I run that same code in a kvm guest, it looks
>>>>> like one of those events will be counted on PMC2 and the other won't
>>>>> be counted at all. So, when I calculate the percentage of branch
>>>>> instructions taken, I either get 0 or infinity.
>>>>
>>>> Events get multiplexed internally. See below quick test I ran inside
>>>> guest. My host is running with my+Like's patch and guest is running
>>>> with only my patch.
>>>
>>> Your guest may be multiplexing the counters. The guest I posited does not.
>>
>> It would be helpful if you can provide an example.
> 
> Perf on any current Linux distro (i.e. without your fix).

The patch for errata #1292 (like most hw issues or vulnerabilities) should be
applied to both the host and guest.

For non-patched guests on a patched host, the KVM-created perf_events
will be true for is_sampling_event() due to get_sample_period().

I think we (KVM) have a congenital defect in distinguishing whether guest
counters are used in counting mode or sampling mode, which is just
a different use of pure software.

> 
>>> I hope that you are not saying that kvm's *thread-pinned* perf events
>>> are not being multiplexed at the host level, because that completely
>>> breaks PMU virtualization.
>>
>> IIUC, multiplexing happens inside the guest.
> 
> I'm not sure that multiplexing is the answer. Extrapolation may
> introduce greater imprecision than the erratum.

If you run the same test on the patched host, the PMC2 will be
used in a multiplexing way. This is no different.

> 
> If you count something like "instructions retired" three ways:
> 1) Unfixed counter
> 2) PMC2 with the fix
> 3) Multiplexed on PMC2 with the fix
> 
> Is (3) always more accurate than (1)?

The loss of accuracy is due to a reduction in the number of trustworthy counters,
not to these two workaround patches. Any multiplexing (whatever on the host or
the guest) will result in a loss of accuracy. Right ?

I'm not sure if we should provide a sysfs knob for (1), is there a precedent for 
this ?

> 
>> Thanks,
>> Ravi
