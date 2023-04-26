Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98AD6EEE52
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 08:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbjDZG0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 02:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238586AbjDZG0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 02:26:25 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3387E35A1;
        Tue, 25 Apr 2023 23:26:03 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-51efefe7814so6780176a12.3;
        Tue, 25 Apr 2023 23:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682490362; x=1685082362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZHn9sTXEzMs5ji4aB0cw2xEtdZV2Wc90msMFQpQNypo=;
        b=R0M+kyYTCMVB+3lxhcSwBtYOjt0JotGWCJKJXXWAQhLq6Bjtn8CObXI7IkuESeMcTb
         lx320puUayJvTNeIo1hwCPEPWSE5BWejYyYHaRj0G190VY/V4QvJLgj3XXpqDL0y/TX/
         RkgVzxMYOmUdKbjGFKbuXqSxkPvh8GSkFeYdXTN5oG7YttmR14BJrOHxMtJq2riXjzPV
         FOXf+zWHDGSsrdWVdjdwOZpN2CqwdQTaxE0hF0rvh+GIWSZcSChBNJTZLsKahupcaz9U
         nNaychYm0w78JpMk4NU1mYaVd47ETtRr4TGbvxb2ldCE9DHRnLmCAj33nDf0BrdK0oGR
         6pHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682490362; x=1685082362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHn9sTXEzMs5ji4aB0cw2xEtdZV2Wc90msMFQpQNypo=;
        b=kZgLJpzn4QbzB3ysWLU4m5RRs+JW05eyJVov36PKNRetTQRcn/TztxZWrDKf0eG8eK
         w4xEqt2USrHGFiC9eEExqKsZ01AMAO6gVnCNqwTZ9b41/ZJ5Wg46hcV+AXHUPYnKs50Z
         7BVjXPv+eeaKvgAbumoeo9EsGX5z22B51q0/fPrfNfMPkl4jBP3WAfj3gd0qdq3EPaMO
         K5POAGvcNBoJCEubdD8FuoMssq4ekj4I3YRrOgmGAfqkY4nkU9f8aQc8BJ9U7sqyjYUt
         SDCjgTaaYUgTHlAynRW+nKjXq8zdEjD1/+es9Ks5tzegHvyulrastNkBZ0wHJWpcYnYH
         uZtA==
X-Gm-Message-State: AAQBX9cVXc7fu2UaZNN4WiWhzDfTPyBwOhG/l8QhqwFXy+geTnqlY92e
        d8NkXU1okNdiRU7oHlzlEtQ=
X-Google-Smtp-Source: AKy350a03z1aaD7fJpGumg3AOFY1jix0f4yuQp+5pPOq4mLIVggmhKL81EhyiyDNd/VOxTLnqNhRPw==
X-Received: by 2002:a05:6a20:3d93:b0:f3:6746:ba37 with SMTP id s19-20020a056a203d9300b000f36746ba37mr15940657pzi.13.1682490362481;
        Tue, 25 Apr 2023 23:26:02 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k10-20020a65464a000000b0050336b0b08csm8906630pgr.19.2023.04.25.23.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 23:26:01 -0700 (PDT)
Message-ID: <aa1d858f-ad45-150c-2bbb-97523ce78e22@gmail.com>
Date:   Wed, 26 Apr 2023 14:25:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
To:     Sandipan Das <sandipan.das@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        "Tom Lendacky (AMD)" <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
References: <20230310105346.12302-1-likexu@tencent.com>
 <20230310105346.12302-6-likexu@tencent.com> <ZC99f+AO1tZguu1I@google.com>
 <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
 <ZDAvDhV/bpPyt3oX@google.com>
 <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
 <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/4/2023 1:25 pm, Sandipan Das wrote:
> Hi Sean, Like,
> 
> On 4/19/2023 7:11 PM, Like Xu wrote:
>> On 7/4/2023 10:56 pm, Sean Christopherson wrote:
>>> On Fri, Apr 07, 2023, Like Xu wrote:
>>>> On 7/4/2023 10:18 am, Sean Christopherson wrote:
>>>>> Wait, really?  VMRUN is counted if and only if it enters to a CPL0 guest?  Can
>>>>> someone from AMD confirm this?  I was going to say we should just treat this as
>>>>> "normal" behavior, but counting CPL0 but not CPL>0 is definitely quirky.
>>>>
>>>> VMRUN is only counted on a CPL0-target (branch) instruction counter.
>>>
>>> Yes or no question: if KVM does VMRUN and a PMC is programmed to count _all_ taken
>>> branches, will the PMC count VMRUN as a branch if guest CPL>0 according to the VMCB?
>>
>> YES, my quick tests (based on run_in_user() from KUT on Zen4) show:
>>
>> EVENTSEL_GUESTONLY + EVENTSEL_ALL + VMRUN_to_USR -> AMD_ZEN_BR_RETIRED + 1
>> EVENTSEL_GUESTONLY + EVENTSEL_ALL + VMRUN_to_OS -> AMD_ZEN_BR_RETIRED + 1
>>
>> EVENTSEL_GUESTONLY + EVENTSEL_USR + VMRUN_to_USR -> AMD_ZEN_BR_RETIRED + 1
>> EVENTSEL_GUESTONLY + EVENTSEL_OS + VMRUN_to_OS -> AMD_ZEN_BR_RETIRED + 1
>>
>> VENTSEL_GUESTONLY + EVENTSEL_OS + VMRUN_to_USR -> No change
>> VENTSEL_GUESTONLY + EVENTSEL_USR + VMRUN_to_OS -> No change
>>
>> I'm actually not surprised and related test would be posted later.
>>
>>>
>>>> This issue makes a guest CPL0-target instruction counter inexplicably
>>>> increase, as if it would have been under-counted before the virtualization
>>>> instructions were counted.
>>>
>>> Heh, it's very much explicable, it's just not desirable, and you and I would argue
>>> that it's also incorrect.
>>
>> This is completely inaccurate from the end guest pmu user's perspective.
>>
>> I have a toy that looks like virtio-pmu, through which guest users can get hypervisor performance data.
>> But the side effect of letting the guest see the VMRUN instruction by default is unacceptable, isn't it ?
>>
>>>
>>> AMD folks, are there plans to document this as an erratum?  I agree with Like that
>>> counting VMRUN as a taken branch in guest context is a CPU bug, even if the behavior
>>> is known/expected.
>>
> 
> This behaviour is architectural and an erratum will not be issued. However, for clarity, a future
> release of the APM will include additional details like the following:
> 
>    1) From the perspective of performance monitoring counters, VMRUNs are considered as far control
>       transfers and VMEXITs as exceptions.
> 
>    2) When the performance monitoring counters are set up to count events only in certain modes
>       through the "OsUserMode" and "HostGuestOnly" bits, instructions and events that change the
>       mode are counted in the target mode. For example, a SYSCALL from CPL 3 to CPL 0 with a
>       counter set to count retired instructions with USR=1 and OS=0 will not cause an increment of
>       the counter. However, the SYSRET back from CPL 0 to CPL 3 will cause an increment of the
>       counter and the total count will end up correct. Similarly, when counting PMCx0C6 (retired
>       far control transfers, including exceptions and interrupts) with Guest=1 and Host=0, a VMRUN
>       instruction will cause an increment of the counter. However, the subsequent VMEXIT that occurs,
>       since the target is in the host, will not cause an increment of the counter and so the total
>       count will end up correct.
> 

Thanks for the clarification, that fits my understanding.

"Calculated in target mode" and "correct total count" are architectural choices,
which is not a problem if the consumers of PMU data are on the same side.

But for a VM user, seeing SYSRET in the user mode is completely and functionally
different from seeing VMRUN in the guest context. Since the host user and
the guest user are two separate pmu data consumers, and they do not aggregate
or share the so-called "total" PMU data.

This situation is even worse for nested SVM guests and SEV-SNP guests.

I'm not urging that AMD hardware should change, but it is entirely necessary
for our software layer to take this step, as it is part of the hypervisor's 
responsibility
to hide itself by default.
