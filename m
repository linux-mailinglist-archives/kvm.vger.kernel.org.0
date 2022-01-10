Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9834489024
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 07:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbiAJGXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 01:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiAJGXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 01:23:37 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5455C06173F;
        Sun,  9 Jan 2022 22:23:36 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id l15so11005395pls.7;
        Sun, 09 Jan 2022 22:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=Xc9UQ0yJ10lxDBbi+LUX308KpnFlT7KB4lZPUYQgwC4=;
        b=LFkOiC2LXOpZEgqKRZE/Hix39kPRzu/GgGh4iQ/VYrZ7A8xZzV9kR9ofcbMCpl8fhW
         l8jMOPMzw/S6A1PbMohxvUzHHEoila4f0i1jXRQ1Hmnpufcyy9vDPiOtycAVjjPL/Wvr
         bbWtn0y9MZYd+TAQsIZFpKZlFYYYLR6KsUals26CEiaLuDYcDGN3HO2XvQGJiRYJAZgz
         rRmOkXKzRTXPA9cu9V+/4PCWjTB3/HUj1TZWO/SeVWPNUnTIY0MabOIZj4a5SPT24PmW
         P6ICZwG5wm9fnPWx6SDzszs0qTcul3DZ+BZ+Du6jEJ23HpDfcbfWKUO+XP+ZZqgfjG+Z
         5y+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=Xc9UQ0yJ10lxDBbi+LUX308KpnFlT7KB4lZPUYQgwC4=;
        b=7mimLHGy5PI19/LPQAiWiWvS0Kl1YvvLAZmR59qRcarJOEAB1xh7xyo2LwXOJHE6WA
         4axJG0X7LCs98+gX04/r2zbOHjQ+dC22eGkXh16fqPsLxPwelgYk3A+yyJzb1H4nh2qA
         Pj7CF1asKN5p2a8Hy5sZ83VwLcxy8FzZB7oRLYf1rYpZ3w+eTxWYeBYFcajpK0dgQBSY
         T1xkflM84j/mg23+Z7Xleh9S6Jar2UG3kXWinaSSlMaqVV26S4cs7XK11YpZuXlbB7In
         bHoBigIzEhoCWdKKuTF8/V/PRhrxJRTvI9VEK4C5LHZe+BV6nT6+UIElQ1q2W7w1Wqhy
         jdSA==
X-Gm-Message-State: AOAM533qa+sJPeDifKJTXePrWGdF//fo5/YhnyTqfWorUlOyVbit6xEg
        93u3gKKU0zJ8yaiEQCIDMCKK4AcpPLxudTakpeU=
X-Google-Smtp-Source: ABdhPJxddayPvM3mnDonJYeyibcd7wqr6a3cZXhT5R5eG1XjyLGWxy6Hn1ZnWLeQHAS7N3A/0WPd0Q==
X-Received: by 2002:a17:90b:17c2:: with SMTP id me2mr28643651pjb.162.1641795816327;
        Sun, 09 Jan 2022 22:23:36 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h3sm7301857pjk.48.2022.01.09.22.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jan 2022 22:23:35 -0800 (PST)
Message-ID: <a2b6fb82-292b-f714-cfd7-31a5310c28ed@gmail.com>
Date:   Mon, 10 Jan 2022 14:23:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>
References: <20211117080304.38989-1-likexu@tencent.com>
 <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eRA8hw9zVEwnZEX56Gao-MibX5A+XXYS-n-+X0BkhrSvQ@mail.gmail.com>
 <438d42de-78e1-0ce9-6a06-38194de4abd4@redhat.com>
 <CALMp9eSLU1kfffC3Du58L8iPY6LmKyVO0yU7c3wEnJAD9JZw4w@mail.gmail.com>
 <CALMp9eR3PEgXhe_z8ArHK0bPeW4=htta_f3LHTm9jqL2rtcT7A@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU
 virtualization
In-Reply-To: <CALMp9eR3PEgXhe_z8ArHK0bPeW4=htta_f3LHTm9jqL2rtcT7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/2022 9:23 am, Jim Mattson wrote:
> On Fri, Dec 10, 2021 at 7:48 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Fri, Dec 10, 2021 at 6:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>
>>> On 12/10/21 20:25, Jim Mattson wrote:
>>>> In the long run, I'd like to be able to override this system-wide
>>>> setting on a per-VM basis, for VMs that I trust. (Of course, this
>>>> implies that I trust the userspace process as well.)
>>>>
>>>> How would you feel if we were to add a kvm ioctl to override this
>>>> setting, for a particular VM, guarded by an appropriate permissions
>>>> check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?
>>>
>>> What's the rationale for guarding this with a capability check?  IIRC
>>> you don't have such checks for perf_event_open (apart for getting kernel
>>> addresses, which is not a problem for virtualization).
>>
>> My reasoning was simply that for userspace to override a mode 0444
>> kernel module parameter, it should have the rights to reload the
>> module with the parameter override. I wasn't thinking specifically
>> about PMU capabilities.

Do we have a precedent on any module parameter rewriting for privileger ?

A further requirement is whether we can dynamically change this part of
the behaviour when the guest is already booted up.

> 
> Assuming that we trust userspace to decide whether or not to expose a
> virtual PMU to a guest (as we do on the Intel side), perhaps we could
> make use of the existing PMU_EVENT_FILTER to give us per-VM control,
> rather than adding a new module parameter for per-host control. If

Various granularities of control are required to support vPMU production
scenarios, including per-host, per-VM, and dynamic-guest-alive control.

> userspace calls KVM_SET_PMU_EVENT_FILTER with an action of
> KVM_PMU_EVENT_ALLOW and an empty list of allowed events, KVM could
> just disable the virtual PMU for that VM.

AMD will also have "CPUID Fn8000_0022_EBX[NumCorePmc, 3:0]".

> 
> Today, the semantics of an empty allow list are quite different from
> the proposed pmuv module parameter being false. However, it should be
> an easy conversion. Would anyone be concerned about changing the
> current semantics of an empty allow list? Is there a need for
> disabling PMU virtualization for legacy userspace implementations that
> can't be modified to ask for an empty allow list?
> 

AFAI, at least one user-space agent has integrated with it plus additional 
"action"s.

Once the API that the kernel presents to user space has been defined,
it's best not to change it and instead fall into remorse.

"But I am not a decision maker. " :D

Thanks,
Like Xu

