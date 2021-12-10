Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0241246FE86
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhLJKPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhLJKPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:15:11 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22659C061746;
        Fri, 10 Dec 2021 02:11:37 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id m24so7631196pgn.7;
        Fri, 10 Dec 2021 02:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=LY1mQWWaMvke+UWIweZH9XREVkdzI6MKWI9ATeJso/c=;
        b=emGWNtCB2IHeYhgUmIqeWo/4q7vSbDFtMxUwfdfrm7mWPyEs+Q2o8OUCnqSYC4qmec
         A1VU7U2HelneqTVJ4lfN+J8p4n4jt1XLTfcXvpH34j/2iws/8F6pP7zHq0h9A4WY/iIO
         ecjZqOmE2ixSaq7D3c/FreZWn2UBAShLKdk22SisCMHUEvj22RwqZJ60YWu8qBysSbp0
         DXBas8oFIxwtaW19RFPiWTChf0QvaZgP1kIqkzjYTyZzTXdgUgWtUoPdE4i7BttY+pKU
         fkyMliIw6cB35/wSW3lFjmMJ1QtXWJAPnmBs/exYGpeDqUX+vUvwOJzEW7epZ4kTrA/v
         dJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=LY1mQWWaMvke+UWIweZH9XREVkdzI6MKWI9ATeJso/c=;
        b=48pNGIcX/TDHRnK6iObxCtL+WuiwyD7+68+3j4vEmEX9BZEj9HYtSZ8brBo3irjdLm
         LVrSUQ1uguRkXzut2700nyZzm1hx4Bx4jk9NeI+1hV00ghd4pAEH+W1psDtCB75zjRqf
         EMWmrCqmiCLbjj3zFTxueFGRpW+Pef1KdBl8gpBLe+GZNfI1AMFlnbsyf2DPBHssZJoi
         3SFXrAms8fSc59I7U3J8g3BfeAOkIJ/Ur2HiwLuYDBN3E2n/eH3BICMag9vmREAvI/D+
         0TjMnFxkMsHDdXM0ZLL6tP4c+sb9U3ksJdca9kSQg8HuLGnEnG8jdp1dw71hSMJ/XZiH
         mzig==
X-Gm-Message-State: AOAM531+MjY3gR6GfvVNpHHthu1VhW/T4pyZBW8FzIINNctnLIy5/hu3
        hCSAEXpBUlb11H0c0JgFNmG8uY/pg9w=
X-Google-Smtp-Source: ABdhPJyh4b8qta3pDyTa35UIoOcxyHQNi58jjvvFPr/c7XCH5DgFZWlvWC5VIwC2rFYPgy/UyOIDgA==
X-Received: by 2002:a05:6a00:a89:b0:4a4:e9f5:d88a with SMTP id b9-20020a056a000a8900b004a4e9f5d88amr17217052pfl.28.1639131096636;
        Fri, 10 Dec 2021 02:11:36 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p6sm2328286pjb.48.2021.12.10.02.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 02:11:36 -0800 (PST)
Message-ID: <8659b829-6437-17f1-3e35-7c9f123a6c3e@gmail.com>
Date:   Fri, 10 Dec 2021 18:11:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
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
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor
 kvm_perf_overflow{_intr}()
In-Reply-To: <b6c1eb18-9237-f604-9a96-9e6ca397121c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2021 5:35 pm, Paolo Bonzini wrote:
> On 12/10/21 01:54, Jim Mattson wrote:
>> On Thu, Dec 9, 2021 at 12:28 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>
>>> On 9/12/2021 12:25 pm, Jim Mattson wrote:
>>>>
>>>> Not your change, but if the event is counting anything based on
>>>> cycles, and the guest TSC is scaled to run at a different rate from
>>>> the host TSC, doesn't the initial value of the underlying hardware
>>>> counter have to be adjusted as well, so that the interrupt arrives
>>>> when the guest's counter overflows rather than when the host's counter
>>>> overflows?
>>>
>>> I've thought about this issue too and at least the Intel Specification
>>> did not let me down on this detail:
>>>
>>>          "The counter changes in the VMX non-root mode will follow
>>>          VMM's use of the TSC offset or TSC scaling VMX controls"
>>

Emm, before I left Intel to play AMD, my hardware architect gave
me a verbal yes about any reported TSC values for vmx non-root mode
(including the Timed LBR or PEBS records or PT packages) as long as
we enable the relevant VM execution control bits.

Not sure if it's true for legacy platforms.

>> Where do you see this? I see similar text regarding TSC packets in the
>> section on Intel Processor Trace, but nothing about PMU counters
>> advancing at a scaled TSC frequency.
> 
> Indeed it seems quite unlikely that PMU counters can count fractionally.
> 
> Even for tracing the SDM says "Like the value returned by RDTSC, TSC packets 
> will include these adjustments, but other timing packets (such as MTC, CYC, and 
> CBR) are not impacted".  Considering that "stand-alone TSC packets are typically 
> generated only when generation of other timing packets (MTCs and CYCs) has 
> ceased for a period of time", I'm not even sure it's a good thing that the 
> values in TSC packets are scaled and offset.

There are some discussion that cannot be made public.

We recommend (as software developers) that any PMU enabled guest
should keep the host/guest TSC as a joint progression for
performance tuning since guest doesn't have AMPERF capability.

> 
> Back to the PMU, for non-architectural counters it's not really possible to know 
> if they count in cycles or not.  So it may not be a good idea to special case 
> the architectural counters.

Yes captain.
Let's see if we have real world challenges or bugs to explore this detail further.

> 
> Paolo
> 
