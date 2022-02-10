Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDF4B0F72
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 14:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242512AbiBJN5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 08:57:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239698AbiBJN5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 08:57:10 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901D8BF5;
        Thu, 10 Feb 2022 05:57:11 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id r19so10364282pfh.6;
        Thu, 10 Feb 2022 05:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=1hgSmDYgxujSJUiUOVkYVmp81RiJTwQhhgI2GMQNrx0=;
        b=qEQuj6F+aZmhqg3RX3H44VgCUrX9EDwGTQJtiJjITBjTErJsgxsVCCdUWMlXE637vm
         VEyqVZxy3mAz/rWPke+8nFlMP0tP4+zywVA5SRb0wahb7gou6Q9v2HjV97AWyAVHgy69
         5nzPEOkGHGI1IZKjAO48a3RNu+pk+pUR/88mohJ3tRYzclWYNUhIdl1qKkdcPPfYI8gh
         LYPn7k+qzQvvHEMzabjnpjfHxZcC/nDEy/Bmxjm5XMtqs05/qevSIHNGQOkPo3b817AQ
         UF4Uu9cx0Wj54VLKIfVPGjIcTwl5RGgO+klDjy70G3B9oxRT/0vPxRAtSQqQRfJbM9AJ
         N3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=1hgSmDYgxujSJUiUOVkYVmp81RiJTwQhhgI2GMQNrx0=;
        b=cYqHhZ/OAx9uGG3vCm6lA0ci2QtTAsq2ZxUApCe4Js1+5l4fCMd464ML47Ai6DljyN
         nlPdcTsEsuyzDRye3wq4x3t6nWb01SQXXJEeSvRb/wEHQSGSYm5JQWfdUx4aAGr6q41N
         7wfefF2HT5lpBnFDkpyKyqbYeSt01UK8Ytpq4WdIvfXK8Q/74BYZIqYdnaLekjAm7Lpl
         AA7Yko27Lhef4CCJ5naBAwntcSTja/XMViqIDOMh14gGmQIEGwLCP6VlEgKLQlb+n54F
         pkkdql31w52IgWjUEmZmjTi92sC172cZdfqAKQBOEkju9GhY/CvVd+p5hVwIgyH7ZM0N
         wOhA==
X-Gm-Message-State: AOAM533RCiCeVMyTozwwvXaNy+/wS+EQ5ilC0JqwqsyOowe4XSefQHp1
        oimseFuhlZhOzYgjruLACdc=
X-Google-Smtp-Source: ABdhPJzVaW6mWrx/caKqe4n6w6xAlnoOfOe+/bx2n4+B2NxeBR/V4Ew1zD0xuhlksQtgINsM2Yvt/w==
X-Received: by 2002:a63:5a01:: with SMTP id o1mr6300336pgb.306.1644501431010;
        Thu, 10 Feb 2022 05:57:11 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s1sm2435190pjr.56.2022.02.10.05.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 05:57:10 -0800 (PST)
Message-ID: <c7b418f5-7014-d322-ea47-2d4ee9c2748c@gmail.com>
Date:   Thu, 10 Feb 2022 21:56:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Content-Language: en-US
To:     Ravi Bangoria <ravi.bangoria@amd.com>,
        Jim Mattson <jmattson@google.com>
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
 <e58ca80c-b54c-48b3-fb0b-3e9497c877b7@gmail.com>
 <CALMp9eRuBwj9Sg60jg2ucWd-XoAcE_kXP5ULFgpkSHg88sOJZQ@mail.gmail.com>
 <fc5fd517-7ad6-10e1-2582-ef1335dc82b2@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <fc5fd517-7ad6-10e1-2582-ef1335dc82b2@amd.com>
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

On 10/2/2022 12:06 pm, Ravi Bangoria wrote:
> Hi Jim,
> 
> On 10-Feb-22 3:10 AM, Jim Mattson wrote:
>> On Wed, Feb 9, 2022 at 2:19 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>
>>> On 4/2/2022 9:01 pm, Jim Mattson wrote:
>>>> On Fri, Feb 4, 2022 at 1:33 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 03-Feb-22 11:25 PM, Jim Mattson wrote:
>>>>>> On Wed, Feb 2, 2022 at 9:18 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>>>>
>>>>>>> Hi Jim,
>>>>>>>
>>>>>>> On 03-Feb-22 9:39 AM, Jim Mattson wrote:
>>>>>>>> On Wed, Feb 2, 2022 at 2:52 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>>>>>>
>>>>>>>>> Perf counter may overcount for a list of Retire Based Events. Implement
>>>>>>>>> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
>>>>>>>>> Revision Guide[1]:
>>>>>>>>>
>>>>>>>>>     To count the non-FP affected PMC events correctly:
>>>>>>>>>       o Use Core::X86::Msr::PERF_CTL2 to count the events, and
>>>>>>>>>       o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>>>>>>>>>       o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
>>>>>>>>>
>>>>>>>>> Note that the specified workaround applies only to counting events and
>>>>>>>>> not to sampling events. Thus sampling event will continue functioning
>>>>>>>>> as is.
>>>>>>>>>
>>>>>>>>> Although the issue exists on all previous Zen revisions, the workaround
>>>>>>>>> is different and thus not included in this patch.
>>>>>>>>>
>>>>>>>>> This patch needs Like's patch[2] to make it work on kvm guest.
>>>>>>>>
>>>>>>>> IIUC, this patch along with Like's patch actually breaks PMU
>>>>>>>> virtualization for a kvm guest.
>>>>>>>>
>>>>>>>> Suppose I have some code which counts event 0xC2 [Retired Branch
>>>>>>>> Instructions] on PMC0 and event 0xC4 [Retired Taken Branch
>>>>>>>> Instructions] on PMC1. I then divide PMC1 by PMC0 to see what
>>>>>>>> percentage of my branch instructions are taken. On hardware that
>>>>>>>> suffers from erratum 1292, both counters may overcount, but if the
>>>>>>>> inaccuracy is small, then my final result may still be fairly close to
>>>>>>>> reality.
>>>>>>>>
>>>>>>>> With these patches, if I run that same code in a kvm guest, it looks
>>>>>>>> like one of those events will be counted on PMC2 and the other won't
>>>>>>>> be counted at all. So, when I calculate the percentage of branch
>>>>>>>> instructions taken, I either get 0 or infinity.
>>>>>>>
>>>>>>> Events get multiplexed internally. See below quick test I ran inside
>>>>>>> guest. My host is running with my+Like's patch and guest is running
>>>>>>> with only my patch.
>>>>>>
>>>>>> Your guest may be multiplexing the counters. The guest I posited does not.
>>>>>
>>>>> It would be helpful if you can provide an example.
>>>>
>>>> Perf on any current Linux distro (i.e. without your fix).
>>>
>>> The patch for errata #1292 (like most hw issues or vulnerabilities) should be
>>> applied to both the host and guest.
>>
>> As I'm sure you are aware, guests are often not patched. For example,

It's true. What a real world.

>> we have a lot of Debian-9 guests running on Milan, despite the fact
>> that it has to be booted with "nopcid" due to a bug introduced on
>> 4.9-stable. We submitted the fix and notified Debian about a year ago,
>> but they have not seen fit to cut a new kernel. Do you think they will
>> cut a new kernel for this patch?

Indeed, thanks for your user stories.

>>
>>> For non-patched guests on a patched host, the KVM-created perf_events
>>> will be true for is_sampling_event() due to get_sample_period().
>>>
>>> I think we (KVM) have a congenital defect in distinguishing whether guest
>>> counters are used in counting mode or sampling mode, which is just
>>> a different use of pure software.
>>
>> I have no idea what you are saying. However, when kvm sees a guest
>> counter used in sampling mode, it will just request a PERF_TYPE_RAW
>> perf event with the INT bit set in 'config.' If it sees a guest

The counters work very simply: increments until it overflows.

The use of INT bit is not related to counting or sampling mode.
A pmu driver can set the INT bit, but set a very small ctr value and not
expect it to overflow, and it can be used for counting mode as well, right?

We don't know under what circumstances the overcount will occur, maybe
it's related to the INT bit and maybe bot, but absolutely it's nothing to do with
the software check is_sampling_event().

>> counter used in counting mode, it will either request a PERF_TYPE_RAW
>> perf event or a PERF_TYPE_HARDWARE perf event, depending on whether or
>> not it finds the requested event in amd_event_mapping[].
>>
>>>>
>>>>>> I hope that you are not saying that kvm's *thread-pinned* perf events
>>>>>> are not being multiplexed at the host level, because that completely
>>>>>> breaks PMU virtualization.
>>>>>
>>>>> IIUC, multiplexing happens inside the guest.
>>>>
>>>> I'm not sure that multiplexing is the answer. Extrapolation may
>>>> introduce greater imprecision than the erratum.
>>>
>>> If you run the same test on the patched host, the PMC2 will be
>>> used in a multiplexing way. This is no different.
>>>
>>>>
>>>> If you count something like "instructions retired" three ways:
>>>> 1) Unfixed counter
>>>> 2) PMC2 with the fix
>>>> 3) Multiplexed on PMC2 with the fix
>>>>
>>>> Is (3) always more accurate than (1)?
>>
>> Since Ravi has gone dark, I will answer my own question.
> 
> Sorry about the delay. I was discussing this internally with hw folks.
> 
>>
>> For better reproducibility, I simplified his program to:
>>
>> int main() { return 0;}
>>
>> On an unpatched Milan host, I get instructions retired between 21911
>> and 21915. I get branch instructions retired between 5565 and 5566. It
>> does not matter if I count them separately or at the same time.
>>
>> After applying v3 of Ravi's patch, if I try to count these events at
>> the same time, I get 36869 instructions retired and 4962 branch
>> instructions on the first run. On subsequent runs, perf refuses to
>> count both at the same time. I get branch instructions retired between
>> 5565 and 5567, but no instructions retired. Instead, perf tells me:
>>
>> Some events weren't counted. Try disabling the NMI watchdog:
>> echo 0 > /proc/sys/kernel/nmi_watchdog
>> perf stat ...
>> echo 1 > /proc/sys/kernel/nmi_watchdog
>>
>> If I just count one thing at a time (on the patched kernel), I get
>> between 21911 and 21916 instructions retired, and I get between 5565
>> and 5566 branch instructions retired.
>>
>> I don't know under what circumstances the unfixed counters overcount
>> or by how much. However, for this simple test case, the fixed PMC2
>> yields the same results as any unfixed counter. Ravi's patch, however
>> makes counting two of these events simultaneously either (a)
>> impossible, or (b) highly inaccurate (from 10% under to 68% over).
> 
> In further discussions with our hardware team, I am given to understand
> that the conditions under which the overcounting can happen, is quite
> rare. In my tests, I've found that the patched vs. unpatched cases are
> not significantly different to warrant the restriction introduced by

That's cute and thank you both.

I hope we can come to this conclusion before the code is committed.

But the kvm's patch may have made those PMU driver developers who read the
erratum #1292 a little happier, wouldn't it ?

> this fix. I have requested Peter to hold off pushing this fix.
> 
>>
>>> The loss of accuracy is due to a reduction in the number of trustworthy counters,
>>> not to these two workaround patches. Any multiplexing (whatever on the host or
>>> the guest) will result in a loss of accuracy. Right ?
>>
>> Yes, that's my point. Fixing one inaccuracy by using a mechanism that
>> introduces another inaccuracy only makes sense if the inaccuracy you
>> are fixing is worse than the inaccuracy you are introducing. That does

Couldn't agree more, and in response to similar issues,
we may adopt a quantitative-first strategy in the future.

>> not appear to be the case here, but I am not privy to all of the
>> details of this erratum.
> 
> Thanks,
> Ravi
