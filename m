Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017C747CD2D
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 07:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242856AbhLVG5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 01:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbhLVG5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 01:57:07 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769D3C061574;
        Tue, 21 Dec 2021 22:57:07 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id co15so1450028pjb.2;
        Tue, 21 Dec 2021 22:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=2LqpqZaSXiOLzGBZqUyh9bGvHyoge1MdrYKsSWzF1Hs=;
        b=JF3YT1j0mEWfvgpRzo8WVQovLf4I4vw6Iq85aKFTQm+aUrFIDKi+aXXd4M7NdiAVfw
         9PRAFdxwMGjFAH63yW4FWHAFMYmL1yDrfunIyuxpMw3Dpk/MYPMGhOYb+D2M9wUzaOg1
         fAh0paC/JuBFidgrdlgbGTqXUp+xmo5mMUEeBDjp5eI1pG64nWp/u7fKRkqnqsx1+U9T
         aMFZa7ZeS19umdFvmK3HFqLKi7Cx0HXx3gdajPU0/MqMEu4tq5aczBUePPNh8d7tU5Si
         I+LfXcsVpNslEmaAk7PTTTpRGi98SoQ41YXmaIEzHh/yCG9wuCDFCBeK/70twnTIsIwA
         QQwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=2LqpqZaSXiOLzGBZqUyh9bGvHyoge1MdrYKsSWzF1Hs=;
        b=MvmSol6dwMMwOwx+Rk0t4LPd+OdRMqmS7whCBwEPDK3AZJckdiyz0p8jzXlzRLTy8T
         d0vOq5Md/EkoGgbvSDeNv6BTUuWP2l8s4nnhqCVF32JIKtQjdLCGbFyXYbzo4sDDfFK1
         z65BnnkE2WA85q2gEjRfqb23WSpJVHnDO7uJbtgANOrTlD7A21EfwxpUqgOC2wPdPb9H
         Rzhir/ZxNPIbDwIJvue/EXMHRo2ROsh6EcgU4RlY/pUAZWoP+hzQePA4jUmkOC6e8JqN
         gFOA81aznNKVs29+IRzIKWUgXYj5MRZqBjpdQwPSowGuEPPi/R4PaBVwLKSfiJ9+u+Ix
         A9Jg==
X-Gm-Message-State: AOAM530OBj8ACO4gKHzTf/8WCY+0rQBxJTuxuU7oOjB+pXCtbwYdb6zj
        FibG1QHGeJTbKHAK8LLYxMI=
X-Google-Smtp-Source: ABdhPJyXuF5ImAOoVzuMuk5BnH6MDz9WpFw21EK9Eskk/Oi5gRWliklvdlEoqRILqudB89k7u7jiTw==
X-Received: by 2002:a17:90b:1950:: with SMTP id nk16mr1962009pjb.129.1640156227006;
        Tue, 21 Dec 2021 22:57:07 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a11sm953918pgd.87.2021.12.21.22.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 22:57:06 -0800 (PST)
Message-ID: <9e898dae-c8a9-7b04-6165-ca4d7ddce988@gmail.com>
Date:   Wed, 22 Dec 2021 14:56:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, wei.huang2@amd.com,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Li RongQing <lirongqing@baidu.com>,
        Like Xu <likexu@tencent.com>
References: <20200623063530.81917-1-like.xu@linux.intel.com>
 <20200623182910.GA24107@linux.intel.com>
 <CALMp9eQPA40FWBEOiQ8T5JX2fv+uEfU_x6js8WhAguQ8TL6frA@mail.gmail.com>
 <20200623190504.GC24107@linux.intel.com>
 <CALMp9eTYKQ3LrWKu32mJKPzkWMcN5tGSFmj352TPCSrSp7jGxw@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH] KVM: X86: Emulate APERF/MPERF to report actual VCPU
 frequency
In-Reply-To: <CALMp9eTYKQ3LrWKu32mJKPzkWMcN5tGSFmj352TPCSrSp7jGxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/6/2020 4:34 am, Jim Mattson wrote:
> On Tue, Jun 23, 2020 at 12:05 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>>
>> On Tue, Jun 23, 2020 at 11:39:16AM -0700, Jim Mattson wrote:
>>> On Tue, Jun 23, 2020 at 11:29 AM Sean Christopherson
>>> <sean.j.christopherson@intel.com> wrote:
>>>>
>>>> On Tue, Jun 23, 2020 at 02:35:30PM +0800, Like Xu wrote:
>>>>> The aperf/mperf are used to report current CPU frequency after 7d5905dc14a
>>>>> "x86 / CPU: Always show current CPU frequency in /proc/cpuinfo". But guest
>>>>> kernel always reports a fixed VCPU frequency in the /proc/cpuinfo, which
>>>>> may confuse users especially when turbo is enabled on the host.
>>>>>
>>>>> Emulate guest APERF/MPERF capability based their values on the host.
>>>>>
>>>>> Co-developed-by: Li RongQing <lirongqing@baidu.com>
>>>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>>>> Reviewed-by: Chai Wen <chaiwen@baidu.com>
>>>>> Reviewed-by: Jia Lina <jialina01@baidu.com>
>>>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>>>> ---
>>>>
>>>> ...
>>>>
>>>>> @@ -8312,7 +8376,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>>>>                dm_request_for_irq_injection(vcpu) &&
>>>>>                kvm_cpu_accept_dm_intr(vcpu);
>>>>>        fastpath_t exit_fastpath;
>>>>> -
>>>>> +     u64 enter_mperf = 0, enter_aperf = 0, exit_mperf = 0, exit_aperf = 0;
>>>>>        bool req_immediate_exit = false;
>>>>>
>>>>>        if (kvm_request_pending(vcpu)) {
>>>>> @@ -8516,8 +8580,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>>>>                vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
>>>>>        }
>>>>>
>>>>> +     if (unlikely(vcpu->arch.hwp.hw_coord_fb_cap))
>>>>> +             get_host_amperf(&enter_mperf, &enter_aperf);
>>>>> +
>>>>>        exit_fastpath = kvm_x86_ops.run(vcpu);
>>>>>
>>>>> +     if (unlikely(vcpu->arch.hwp.hw_coord_fb_cap)) {
>>>>> +             get_host_amperf(&exit_mperf, &exit_aperf);
>>>>> +             vcpu_update_amperf(vcpu, get_amperf_delta(enter_aperf, exit_aperf),
>>>>> +                     get_amperf_delta(enter_mperf, exit_mperf));
>>>>> +     }
>>>>> +
>>>>
>>>> Is there an alternative approach that doesn't require 4 RDMSRs on every VMX
>>>> round trip?  That's literally more expensive than VM-Enter + VM-Exit
>>>> combined.

It looks like we have quite a few users who are expecting this feature in 
different scenarios.

I will add a fast path for RO usage and a slow path if the guest tries to change 
the AMPERF values.

>>>>
>>>> E.g. what about adding KVM_X86_DISABLE_EXITS_APERF_MPERF and exposing the
>>>> MSRs for read when that capability is enabled?
>>>
>>> When would you load the hardware MSRs with the guest/host values?
>>
>> Ugh, I was thinking the MSRs were read-only.
> 
> EVen if they were read-only, they should power on to zero, and they
> will most likely not be zero when a guest powers on.

Can we assume that "not zero when the guest is on" will not harm any guests ?

> 
>> Doesn't this also interact with TSC scaling?
> 
> Yes, it should!

We have too much of a historical burden on TSC emulations.

For practical reasons, what if we only expose the AMPERF cap
if the host/guest has both CONSTANT_TSC and NONSTOP_TSC ?

One more design concern, I wonder if it is *safe* for the guest to
read amperf on pCPU[x] the first time and on pCPU[y] the next time.

Any input ?

Thanks,
Like Xu


