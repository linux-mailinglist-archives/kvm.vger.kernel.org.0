Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD08491F73
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 07:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbiARGoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 01:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiARGoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 01:44:02 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8057C061574;
        Mon, 17 Jan 2022 22:44:01 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z17-20020a17090ab11100b001b4d8817e04so581347pjq.2;
        Mon, 17 Jan 2022 22:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=4bpmOgt/gpV18xC/Lm4YqnmxGFHSfA78GgSMRQgOC0Q=;
        b=QMDE+zLbbWV9VXClaXW49hbPjeTklNYmL0y+iH2a329EX3pXjHZmdpg0YqapUJ47KH
         HmzQmTFBFBXQ6lZjwCwaJGqiWkF+hH0iSjr/6W9Fn+do6HM1Dnz0CPZF6R9AYQZvMmUA
         Q/8qTRl/95oXSBRJqLAkYBHNP72vA+uoxx3YTdgKaGFxxKgDIFnXE/XdpjSXgQ1iHY8E
         mPZDy3TQC6lQjOS3zjI3tw4Sml2bdPlwtmDrPXyIkaNCoIwfBdaFh+o6svr/mgP4ClfW
         TQ6EXfwfameHLAE6uyUBpcKXTTf5EPJzevOm1EarUy1x2yeyKL6hVppUCyjYbRHng1WQ
         EEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=4bpmOgt/gpV18xC/Lm4YqnmxGFHSfA78GgSMRQgOC0Q=;
        b=CvQCq8Onh9e5f513Ob3Cg3wnAcU5lajhlaJcM2Blxmy38bThlLMuQ9p5CTl7bPQgLH
         k7j6s8KGTzVQqKvSMvtHW1o8V80SKD9m78SAtEzxJF3ePVeDvYrvaFo/hBgV9FfSH8o8
         Hh5pJ3pHeLYm4NLPuXsj2rvsRDyEurap/hlN0nXAq/U8fcQCLtcWuYqVRFR4OTVWjZEf
         DjY2Xs0+KQNhX5dOXHwpNMVup/tm9KjO/+DpXgrZ17ZQ1JlU3STzjMU4Lvsrwijb931y
         OAbHq0UGfU6+2KppMmo63hScYNS6Fc6k5gDU4q3j8z2D4gShSxnCHo8dAE3WbB7pj15e
         AlZQ==
X-Gm-Message-State: AOAM533ge6cYi6NM3IF/5BlLkd3LmU1WlsYB+uOIZNGRIBsr/lbApigu
        IoY5qMmCyVlK0M7UZckPThQ=
X-Google-Smtp-Source: ABdhPJxLbxSlwatC2rPK8Tosko3CojWB7nKuF/CHqa0jqe+VsRsjIYM97owLiMR4dmycBco+DGEixA==
X-Received: by 2002:a17:902:8c96:b0:149:88bb:ac54 with SMTP id t22-20020a1709028c9600b0014988bbac54mr26289859plo.18.1642488241515;
        Mon, 17 Jan 2022 22:44:01 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n26sm13608139pgb.91.2022.01.17.22.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 22:44:01 -0800 (PST)
Message-ID: <5ca97b8f-facd-b1dc-f671-51569ad17284@gmail.com>
Date:   Tue, 18 Jan 2022 14:43:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jing Liu <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117074531.76925-1-likexu@tencent.com>
 <301d4800-5eab-6e21-e8c1-2f87789fc4b9@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH] KVM: x86/cpuid: Clear XFD for component i if the base
 feature is missing
In-Reply-To: <301d4800-5eab-6e21-e8c1-2f87789fc4b9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/1/2022 1:31 am, Paolo Bonzini wrote:
> On 1/17/22 08:45, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> According to Intel extended feature disable (XFD) spec, the sub-function i
>> (i > 1) of CPUID function 0DH enumerates "details for state component i.
>> ECX[2] enumerates support for XFD support for this state component."
>>
>> If KVM does not report F(XFD) feature (e.g. due to CONFIG_X86_64),
>> then the corresponding XFD support for any state component i
>> should also be removed. Translate this dependency into KVM terms.
>>
>> Fixes: 690a757d610e ("kvm: x86: Add CPUID support for Intel AMX")
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index c55e57b30e81..e96efef4f048 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -886,6 +886,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array 
>> *array, u32 function)
>>                   --array->nent;
>>                   continue;
>>               }
>> +
>> +            if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
>> +                entry->ecx &= ~BIT_ULL(2);
>>               entry->edx = 0;
>>           }
>>           break;
> 
> Generally this is something that is left to userspace.  Apart from the usecase 
> of "call KVM_GET_SUPPORTED_CPUID and pass it to KVM_SET_CPUID2", userspace 
> should know what any changed bits mean.
> 
> Paolo
> 

I totally agree that setting the appropriate CPUID bits for a feature is a user 
space thing.

But this patch is more focused on fixing a different type of problem, which is
that the capabilities exposed by KVM should not *contradict each other* :

	a user space may be confused with the current code base :
	- why KVM does not have F(XFD) feature (MSR_IA32_XFD and XFD_ERR non-exit),
	- but KVM reports XFD support for state component i individually;

This is like KVM reporting PEBS when no PMU capacity is reported (due to module 
param).

Does this clarification help ?

Thanks,
Like Xu

