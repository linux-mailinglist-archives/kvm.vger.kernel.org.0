Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD0448A7A6
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 07:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348085AbiAKGSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 01:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiAKGST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 01:18:19 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377E1C06173F;
        Mon, 10 Jan 2022 22:18:19 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m13so16708981pji.3;
        Mon, 10 Jan 2022 22:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=X18v40N5uNeF4+CxOKsSVdbKFEsMdXIdNxMHtmaLwOg=;
        b=dT/e3xwnwJjpE4movXCCfNcZovcHkl71fXQxB35sT1aaBs9gqi3tdY355frbZ240ZR
         TYf7DKppKmZ8gGEULR34UkpVXjEuBQSSjfS1DcuVTg2U1x9iVAYXq37EGXytxrgOmz6Z
         G31myFDh/pEl1bf27dB4UsDZPNRUCONfnAWeYnELzJJ/myo6AfVPVY4JG0XDqobPruD3
         /C4qGUIIvz5kHDzYHoqNYRnqQAzw1bfm/wlcMiszPMSg2GF9LYN8n6tp8CH9ADRExd9a
         m8geOKe5G/M4F4Fm74KlnNF4I3HFfZbe7Y+DPtPd3gRccBycVwgcOQr4e+PqQfoHE1jb
         omvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=X18v40N5uNeF4+CxOKsSVdbKFEsMdXIdNxMHtmaLwOg=;
        b=2iq043gc1h1L4FS8O5w9DJ/do2QJKG6YuH7ofDxusmpCr5PJ6ydfFgRSvfX+/SI5H6
         mI0a5CiWlIirwmCy0Lt6gNaOFQGpsO6JyrfHKo/gEU6qRsu9V5bhnI4wrLKU8IR42Qrz
         DQVFmBmqr46gaNE/tlJFqMYwggkC6okGCEg3XM8+DYJE43ntJJiDhTJeRnMSP7fJ1dG0
         itHEHxjZuuENWAG+M5RbUeSAMGMdSFupuBCuP+3WPwan1lccoA4wp4UPPR3O/yxVjkJA
         E48FnZtUs6KJ+OU+wZVGBl/eaYx/Nep5IzvE/kNw4JylAbl5BA7Bte+V1IhVh6GF17tF
         oyrw==
X-Gm-Message-State: AOAM531PedvpRw51wzyv+qJhcSV/0chrTgabWH8LJmj61HKXf8j4o9in
        lSOAcaQ5bHfeYye7Jm52Kis=
X-Google-Smtp-Source: ABdhPJwfAIdWa+7sJg6SLLD5LRkeD2p5JRQemA4o10kwgRdmOEWj/vIG5DuP5vdZXy9Zk17vC7pVVA==
X-Received: by 2002:a17:90a:294f:: with SMTP id x15mr1573022pjf.136.1641881898544;
        Mon, 10 Jan 2022 22:18:18 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s6sm900240pjp.19.2022.01.10.22.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 22:18:18 -0800 (PST)
Message-ID: <7fa1a2d8-040c-1485-41ae-ad51f1182bdb@gmail.com>
Date:   Tue, 11 Jan 2022 14:18:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
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
 <a2b6fb82-292b-f714-cfd7-31a5310c28ed@gmail.com>
 <CALMp9eQbiqjf_MMJP9Cc9=Ubm7qKv88BXtu3=7z8ax9W_1AY4Q@mail.gmail.com>
 <1f293656-49f5-ce02-1c59-a0f215306033@gmail.com>
 <CALMp9eTqMMia0Vx=kfGpQVHVYvSCDtuBN1eDr12cop0EAzCSaw@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU
 virtualization
In-Reply-To: <CALMp9eTqMMia0Vx=kfGpQVHVYvSCDtuBN1eDr12cop0EAzCSaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/1/2022 11:24 am, Jim Mattson wrote:
> On Mon, Jan 10, 2022 at 6:11 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 11/1/2022 2:13 am, Jim Mattson wrote:
>>> On Sun, Jan 9, 2022 at 10:23 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>>>
>>>> On 9/1/2022 9:23 am, Jim Mattson wrote:
>>>>> On Fri, Dec 10, 2021 at 7:48 PM Jim Mattson <jmattson@google.com> wrote:
>>>>>>
>>>>>> On Fri, Dec 10, 2021 at 6:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>>>>>
>>>>>>> On 12/10/21 20:25, Jim Mattson wrote:
>>>>>>>> In the long run, I'd like to be able to override this system-wide
>>>>>>>> setting on a per-VM basis, for VMs that I trust. (Of course, this
>>>>>>>> implies that I trust the userspace process as well.)
>>>>>>>>
>>>>>>>> How would you feel if we were to add a kvm ioctl to override this
>>>>>>>> setting, for a particular VM, guarded by an appropriate permissions
>>>>>>>> check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?
>>>>>>>
>>>>>>> What's the rationale for guarding this with a capability check?  IIRC
>>>>>>> you don't have such checks for perf_event_open (apart for getting kernel
>>>>>>> addresses, which is not a problem for virtualization).
>>>>>>
>>>>>> My reasoning was simply that for userspace to override a mode 0444
>>>>>> kernel module parameter, it should have the rights to reload the
>>>>>> module with the parameter override. I wasn't thinking specifically
>>>>>> about PMU capabilities.
>>>>
>>>> Do we have a precedent on any module parameter rewriting for privileger ?
>>>>
>>>> A further requirement is whether we can dynamically change this part of
>>>> the behaviour when the guest is already booted up.
>>>>
>>>>>
>>>>> Assuming that we trust userspace to decide whether or not to expose a
>>>>> virtual PMU to a guest (as we do on the Intel side), perhaps we could
>>>>> make use of the existing PMU_EVENT_FILTER to give us per-VM control,
>>>>> rather than adding a new module parameter for per-host control. If
>>>>
>>>> Various granularities of control are required to support vPMU production
>>>> scenarios, including per-host, per-VM, and dynamic-guest-alive control.
>>>>
>>>>> userspace calls KVM_SET_PMU_EVENT_FILTER with an action of
>>>>> KVM_PMU_EVENT_ALLOW and an empty list of allowed events, KVM could
>>>>> just disable the virtual PMU for that VM.
>>>>
>>>> AMD will also have "CPUID Fn8000_0022_EBX[NumCorePmc, 3:0]".
>>>
>>> Where do you see this? Revision 3.33 (November 2021) of the AMD APM,
>>> volume 3, only goes as high as CPUID Fn8000_0021.
>>
>> Try APM Revision: 4.04 (November 2021),  page 1849/3273,
>> "CPUID Fn8000_0022_EBX Extended Performance Monitoring and Debug".
> 
> Is this a public document?

The latest version of APM (40332) is revision v4.04, released on 12/1/2021.

> 
>> Given the current ambiguity in this revision, the AMD folks will reveal more
>> details bout this field in the next revision.
>>
>>>
>>>>>
>>>>> Today, the semantics of an empty allow list are quite different from
>>>>> the proposed pmuv module parameter being false. However, it should be
>>>>> an easy conversion. Would anyone be concerned about changing the
>>>>> current semantics of an empty allow list? Is there a need for
>>>>> disabling PMU virtualization for legacy userspace implementations that
>>>>> can't be modified to ask for an empty allow list?
>>>>>
>>>>
>>>> AFAI, at least one user-space agent has integrated with it plus additional
>>>> "action"s.
>>>>
>>>> Once the API that the kernel presents to user space has been defined,
>>>> it's best not to change it and instead fall into remorse.
>>>
>>> Okay.
>>>
>>> I propose the following:
>>> 1) The new module parameter should apply to Intel as well as AMD, for
>>> situations where userspace is not trusted.
>>> 2) If the module parameter allows PMU virtualization, there should be
>>> a new KVM_CAP whereby userspace can enable/disable PMU virtualization.
>>> (Since you require a dynamic toggle, and there is a move afoot to
>>> refuse guest CPUID changes once a guest is running, this new KVM_CAP
>>> is needed on Intel as well as AMD).
>>
>> Both hands in favour. Do you need me as a labourer, or you have a ready-made one ?
> 
> We could split the work. Since (1) is a modification of the change you
> proposed in this thread, perhaps you could apply it to both AMD and

We obviously need extra code to make the module parameters suitable for Intel 
since it
affects other features (such as LBR and PEBS), we may not rush to draw this line 
clearly.

> Intel in v2? We can find someone for (2).

The ioctl_set_pmu_event_filter() interface is already practical for dynamic toggle,
as not being able to program any events is the same as having none vPMU,
w/o considering performance impact of traversing the list.

I am not sure if the maintainer will buy in another KVM_CAP for only per-VM, 
considering
"CPUID Fn8000_0022_EBX[NumCorePmc, 3:0]" is a feature that will be available soon.

> 
>>> 3) If the module parameter does not allow PMU virtualization, there
>>> should be no userspace override, since we have no precedent for
>>> authorizing that kind of override.
>>
>> Uh, I thought you (Google) had a lot of these (interesting) use cases internally.
> 
> We have modified some module parameters so that they can be changed at
> runtime, but we don't have any concept of a privileged userspace
> overriding a module parameter restriction.

Considering that the semantics of the different module parameters are different,
allowing one of them to be overridden does not mean that such a generic framework
is promising, but it makes sense for the community to see another case for it.

> 
>>>
>>>> "But I am not a decision maker. " :D
>>>>
>>>> Thanks,
>>>> Like Xu
>>>>
> 
