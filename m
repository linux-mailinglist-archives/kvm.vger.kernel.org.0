Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1962049217C
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 09:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344806AbiARIm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 03:42:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344780AbiARImv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 03:42:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642495371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TarkNDGLeLClM9Er8y1qKxBwUxhfzivs6AuUpW/f/WM=;
        b=QjhwlwQtcHhqAaCgqnoqD/DNILcT9Uug8JEdrVijHrXkUDrXcpViaEChgX+Mo10iFIIXaz
        qk8/jGjPl4B1/8yWvuplNlF5meh3AMkKnCV14Yj8+fTPb3x4aVcUUhv1T4S/5/VI/i0ynn
        EmFfDSiVre06uzsvivmWAyy5r5OBuPc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-oJ_eDlqCPTWz831Oe60G0w-1; Tue, 18 Jan 2022 03:42:46 -0500
X-MC-Unique: oJ_eDlqCPTWz831Oe60G0w-1
Received: by mail-wm1-f71.google.com with SMTP id bg16-20020a05600c3c9000b0034bea12c043so1273619wmb.7
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 00:42:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TarkNDGLeLClM9Er8y1qKxBwUxhfzivs6AuUpW/f/WM=;
        b=Oh92xQZBXIhsHhzHAFMGTl7UZK9IDCEuBE3RNdKSj6alzllWtGAVTq/Z4xr4k+qCfJ
         UIt6oyLbKNS4hYyG3tkRQoaVprsCjEgqzcxrmb2lGOdXcrJAsgRXz3tIjZcmTG5Vyicl
         27wJrhxHGsr9mz/1guT+J3LPx5N7h+dhOuNKS/j8pn0G/+1wqpsfwO3BVp91gbOsVEm7
         pUs/0FjuEqJ8oQZmPrJYf6HK83m0fQrYeqJR0j8MDN1qR04smikVBkc40TH8zA3ISJSz
         gPVj8WmcW4WO+B53+b57Nfgry5Hn+xee0+fa/uEryld2EnhN1FG/iNsvLg1OyQD1H7Hu
         9WQA==
X-Gm-Message-State: AOAM532dtPFv7iOw1+pLkTq/pmPmvr+yiNiXPUYA496Tonxet/rg4YEw
        SRKpFQvhK0LTUprYA0zd5IIjYkiU2t4Vpmsccl3d6MbaBNV+j85lv8HhpDeVzvKITbDHHYt5LoL
        h+rbpDmBDzohT
X-Received: by 2002:a05:6000:1543:: with SMTP id 3mr18770619wry.98.1642495364922;
        Tue, 18 Jan 2022 00:42:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwAyGvXU5HDKLWFwFpIrTCSK9QY6AaJIsN90njgmJzG/VSlbLny/iJ4sPFZNRRBlJuknO62zg==
X-Received: by 2002:a05:6000:1543:: with SMTP id 3mr18770585wry.98.1642495364639;
        Tue, 18 Jan 2022 00:42:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id i8sm7620259wry.33.2022.01.18.00.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 00:42:44 -0800 (PST)
Message-ID: <98424056-829b-ed80-73f3-ead0bef1e7ab@redhat.com>
Date:   Tue, 18 Jan 2022 09:42:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86/cpuid: Clear XFD for component i if the base
 feature is missing
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Jing Liu <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117074531.76925-1-likexu@tencent.com>
 <301d4800-5eab-6e21-e8c1-2f87789fc4b9@redhat.com>
 <5ca97b8f-facd-b1dc-f671-51569ad17284@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5ca97b8f-facd-b1dc-f671-51569ad17284@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 07:43, Like Xu wrote:
> On 18/1/2022 1:31 am, Paolo Bonzini wrote:
>> On 1/17/22 08:45, Like Xu wrote:
>>> From: Like Xu <likexu@tencent.com>
>>>
>>> According to Intel extended feature disable (XFD) spec, the 
>>> sub-function i
>>> (i > 1) of CPUID function 0DH enumerates "details for state component i.
>>> ECX[2] enumerates support for XFD support for this state component."
>>>
>>> If KVM does not report F(XFD) feature (e.g. due to CONFIG_X86_64),
>>> then the corresponding XFD support for any state component i
>>> should also be removed. Translate this dependency into KVM terms.
>>>
>>> Fixes: 690a757d610e ("kvm: x86: Add CPUID support for Intel AMX")
>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>> ---
>>>   arch/x86/kvm/cpuid.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index c55e57b30e81..e96efef4f048 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -886,6 +886,9 @@ static inline int __do_cpuid_func(struct 
>>> kvm_cpuid_array *array, u32 function)
>>>                   --array->nent;
>>>                   continue;
>>>               }
>>> +
>>> +            if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
>>> +                entry->ecx &= ~BIT_ULL(2);
>>>               entry->edx = 0;
>>>           }
>>>           break;
>>
>> Generally this is something that is left to userspace.  Apart from the 
>> usecase of "call KVM_GET_SUPPORTED_CPUID and pass it to 
>> KVM_SET_CPUID2", userspace should know what any changed bits mean.
>>
>> Paolo
>>
> 
> I totally agree that setting the appropriate CPUID bits for a feature is 
> a user space thing.
> 
> But this patch is more focused on fixing a different type of problem, 
> which is
> that the capabilities exposed by KVM should not *contradict each other* :
> 
>      a user space may be confused with the current code base :
>      - why KVM does not have F(XFD) feature (MSR_IA32_XFD and XFD_ERR 
> non-exit),
>      - but KVM reports XFD support for state component i individually;

Got it.  Yeah, the patch makes sense for the sake of CONFIG_X86_64.

Paolo

> This is like KVM reporting PEBS when no PMU capacity is reported (due to 
> module param).


