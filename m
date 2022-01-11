Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FAC48A574
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 03:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346533AbiAKCLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 21:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344038AbiAKCLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 21:11:32 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05ECC06173F;
        Mon, 10 Jan 2022 18:11:31 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id pf13so7512025pjb.0;
        Mon, 10 Jan 2022 18:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=3grWnhhAbTbLnTJOW3Oq0WlPusD5YaqSWIp1lNsFDtE=;
        b=Sz4/6RxqfP4OIH1D/s+4lIyW9howBuz3XNUFKzHioNs3OKd+76r7pykL8P2eApXyLY
         LBIbt4DnXMI6vk9rxzpLUL7KWS3UlLAb+DwaFlx/e2RjGC0kfJg5OF0wewpWF9o1XT4/
         cHE4H2dDll6J8KUIOYpc9by9DWM1EJhqpV1NLgG3cTwCT8TZqtm26UkY39QZuriyF8Og
         E9Dq/ZfYCisVHkRGUpI3i7CgwJ7g3XQ1UoTVGyXkD6xZjCknXRaRNHKtlh9z7ksRcmQl
         1KjUZbeQZ/YTykvqlbMY4OuNNBdLTAMZc3itNMmubU3NPx3aX7QUfKvrcc1sbhji73k4
         rYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=3grWnhhAbTbLnTJOW3Oq0WlPusD5YaqSWIp1lNsFDtE=;
        b=Foj1Cwd92JS5CAXfH0VgYZfGYlrtJm0PqNgi4OWCXONxDxz61ZOU9yik3WUvhxppQ9
         RwevIeqEc82AoZTg2myYhWRr5hVDVbU+1YV903hjHpjw807rsnP577MqJKd+2UgKZMh+
         QK6sX4+rA4olZp9TWzgL3Xdhn3FEsq7TLECwcMZ4EDsM9c3iKHPDrOOfqyXC1UQp1Wix
         RpPiPUEsAWhm0j93Xu6stO/sRGEPyG4DdGUAiTsHSdoZ9hhaNT0NFruYJv+1MkHSqWmB
         T/sC3rSkyUD0RC2bRFRmlh0/7m1TZMNd1zIKsN/Jf2L3y4zWjWPsKW7fAwaKKJ9ZIkyq
         R9bQ==
X-Gm-Message-State: AOAM5308cRdhZMlVxAX75Dwbwt5TOfCydwMVnTMngVK3PPG3R+zxT1ts
        3HLl1wnWI01KVrp6YpyCBSw=
X-Google-Smtp-Source: ABdhPJwY5wbSJqP4riLl7M2Ak+9qB1TAP9QorFtwbSPKlvt2ytm/3ElI7xUNZbHgpNZXyVOFVkHR+Q==
X-Received: by 2002:a17:90b:38c1:: with SMTP id nn1mr733687pjb.65.1641867091282;
        Mon, 10 Jan 2022 18:11:31 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s35sm7851430pfw.193.2022.01.10.18.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 18:11:30 -0800 (PST)
Message-ID: <1f293656-49f5-ce02-1c59-a0f215306033@gmail.com>
Date:   Tue, 11 Jan 2022 10:11:21 +0800
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
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU
 virtualization
In-Reply-To: <CALMp9eQbiqjf_MMJP9Cc9=Ubm7qKv88BXtu3=7z8ax9W_1AY4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/1/2022 2:13 am, Jim Mattson wrote:
> On Sun, Jan 9, 2022 at 10:23 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 9/1/2022 9:23 am, Jim Mattson wrote:
>>> On Fri, Dec 10, 2021 at 7:48 PM Jim Mattson <jmattson@google.com> wrote:
>>>>
>>>> On Fri, Dec 10, 2021 at 6:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>>>
>>>>> On 12/10/21 20:25, Jim Mattson wrote:
>>>>>> In the long run, I'd like to be able to override this system-wide
>>>>>> setting on a per-VM basis, for VMs that I trust. (Of course, this
>>>>>> implies that I trust the userspace process as well.)
>>>>>>
>>>>>> How would you feel if we were to add a kvm ioctl to override this
>>>>>> setting, for a particular VM, guarded by an appropriate permissions
>>>>>> check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?
>>>>>
>>>>> What's the rationale for guarding this with a capability check?  IIRC
>>>>> you don't have such checks for perf_event_open (apart for getting kernel
>>>>> addresses, which is not a problem for virtualization).
>>>>
>>>> My reasoning was simply that for userspace to override a mode 0444
>>>> kernel module parameter, it should have the rights to reload the
>>>> module with the parameter override. I wasn't thinking specifically
>>>> about PMU capabilities.
>>
>> Do we have a precedent on any module parameter rewriting for privileger ?
>>
>> A further requirement is whether we can dynamically change this part of
>> the behaviour when the guest is already booted up.
>>
>>>
>>> Assuming that we trust userspace to decide whether or not to expose a
>>> virtual PMU to a guest (as we do on the Intel side), perhaps we could
>>> make use of the existing PMU_EVENT_FILTER to give us per-VM control,
>>> rather than adding a new module parameter for per-host control. If
>>
>> Various granularities of control are required to support vPMU production
>> scenarios, including per-host, per-VM, and dynamic-guest-alive control.
>>
>>> userspace calls KVM_SET_PMU_EVENT_FILTER with an action of
>>> KVM_PMU_EVENT_ALLOW and an empty list of allowed events, KVM could
>>> just disable the virtual PMU for that VM.
>>
>> AMD will also have "CPUID Fn8000_0022_EBX[NumCorePmc, 3:0]".
> 
> Where do you see this? Revision 3.33 (November 2021) of the AMD APM,
> volume 3, only goes as high as CPUID Fn8000_0021.

Try APM Revision: 4.04 (November 2021),  page 1849/3273,
"CPUID Fn8000_0022_EBX Extended Performance Monitoring and Debug".

Given the current ambiguity in this revision, the AMD folks will reveal more
details bout this field in the next revision.

> 
>>>
>>> Today, the semantics of an empty allow list are quite different from
>>> the proposed pmuv module parameter being false. However, it should be
>>> an easy conversion. Would anyone be concerned about changing the
>>> current semantics of an empty allow list? Is there a need for
>>> disabling PMU virtualization for legacy userspace implementations that
>>> can't be modified to ask for an empty allow list?
>>>
>>
>> AFAI, at least one user-space agent has integrated with it plus additional
>> "action"s.
>>
>> Once the API that the kernel presents to user space has been defined,
>> it's best not to change it and instead fall into remorse.
> 
> Okay.
> 
> I propose the following:
> 1) The new module parameter should apply to Intel as well as AMD, for
> situations where userspace is not trusted.
> 2) If the module parameter allows PMU virtualization, there should be
> a new KVM_CAP whereby userspace can enable/disable PMU virtualization.
> (Since you require a dynamic toggle, and there is a move afoot to
> refuse guest CPUID changes once a guest is running, this new KVM_CAP
> is needed on Intel as well as AMD).

Both hands in favour. Do you need me as a labourer, or you have a ready-made one ?

> 3) If the module parameter does not allow PMU virtualization, there
> should be no userspace override, since we have no precedent for
> authorizing that kind of override.

Uh, I thought you (Google) had a lot of these (interesting) use cases internally.

> 
>> "But I am not a decision maker. " :D
>>
>> Thanks,
>> Like Xu
>>
