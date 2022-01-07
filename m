Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935854871B5
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 05:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346044AbiAGENm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 23:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346021AbiAGENl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 23:13:41 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7EDC061245;
        Thu,  6 Jan 2022 20:13:41 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id iy13so4157298pjb.5;
        Thu, 06 Jan 2022 20:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=7HdhZW4JHX1aq2bQ3td3W2kojz45Mlhv/2YfJEHlrjY=;
        b=RrnoHvikMiCIKePOSsW14Yh2tzPZ7DGnDv3Pmo+jJd6Zj4To8Z0lDfWz+9L6NhfD+H
         SycnLgBmIgFVeHUyhY/qgPq6UC6OmN9usLXj0A26s5XPr5o7ycBZGqTHDGml3wCQrkl7
         aHLkxokDVmctmwC5oqxtNlYpAkfJw2q+NwL5CcS9ZQgInzulWVT64MSnzo/TvTlQMecd
         P2sEfAP9IOUJDTX7/C9uP8MS3xRBwxl1X39RlUj4oKLRvGYh1Ec0tk4j+aM6hi+tAuno
         TsGH6Ungh3YFKsRkUqF3NTT7b4mlc0CuN9lf26MpONNjb40XIXYhZWRKJgSTQTfZ4sM6
         GR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=7HdhZW4JHX1aq2bQ3td3W2kojz45Mlhv/2YfJEHlrjY=;
        b=ML2q1NtDPUZPyPspR3e+PQz7/CRPuK6t6ls4tMPTtwbudoqaH3k7rdFDAl9dAi9QhC
         BgMjc7mG/d9edW0iSqFp1DhUmyyIQ9qlWf1G3CFV/X3fciubhSkJyvHZSJMqDVG/EJZ0
         zmV5VQdhk5h69EtpLk5ou+YY4dGUyJXlGbNzM36GLah2EwdnYC6hE4xRgLnIS1QOXnCS
         NtDZvkMqvpdilF+F2TlJht3gomeHVMIel+bc1fmGEjC2Gyx7YYsxQyMfBqyzHghHCWSa
         THpfMoTuxk09a58JCSfWSv87S/NrU7h/5CxgtCDzM82Gz4zaMfzndi7/5VNv9fRpmE+j
         DetA==
X-Gm-Message-State: AOAM533om/sbWq1Y9dSj6RbtYn5K2vexTtRslPwK/AmKx+eV1797qsr9
        68zbbRy+6fr8J6vGTvnxCPX/hrQ8fFRQL0/GjEo=
X-Google-Smtp-Source: ABdhPJxUAWSOqK1ver/X0LzPVIcjSWAjsbTEvhmIIVdJ5kXb5RydEvGY+XsWMXkv4wGKDy3Jy32S1A==
X-Received: by 2002:a17:902:a60e:b0:14a:766:a8a0 with SMTP id u14-20020a170902a60e00b0014a0766a8a0mr1011609plq.60.1641528821082;
        Thu, 06 Jan 2022 20:13:41 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u35sm4060357pfg.157.2022.01.06.20.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 20:13:40 -0800 (PST)
Message-ID: <14821790-f8e5-0de0-183d-20c6feaed274@gmail.com>
Date:   Fri, 7 Jan 2022 12:13:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220106032118.34459-1-likexu@tencent.com>
 <YdcwXIANeB3fOWOI@google.com>
 <CALMp9eSv7ZQmVsb49iPbw0gkJhYgKPGsFuw6UtEeNZ3FsBwRwA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [DROP PATCH v2] KVM: x86/pmu: Make top-down.slots event
 unavailable in supported leaf
In-Reply-To: <CALMp9eSv7ZQmVsb49iPbw0gkJhYgKPGsFuw6UtEeNZ3FsBwRwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/1/2022 4:12 am, Jim Mattson wrote:
> On Thu, Jan 6, 2022 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Thu, Jan 06, 2022, Like Xu wrote:
>>> From: Like Xu <likexu@tencent.com>
>>>
>>> When we choose to disable the fourth fixed counter TOPDOWN.SLOTS,
>>> we also need to comply with the specification and set 0AH.EBX.[bit 7]
>>> to 1 if the guest (e.g. on the ICX) has a value of 0AH.EAX[31:24] > 7.
>>>
>>> Fixes: 2e8cd7a3b8287 ("kvm: x86: limit the maximum number of vPMU fixed counters to 3")
>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>> ---
>>> v1 -> v2 Changelog:
>>> - Make it simpler to keep forward compatibility; (Sean)
>>> - Wrap related comment at ~80 chars; (Sean)
>>>
>>> Previous:
>>> https://lore.kernel.org/kvm/20220105050711.67280-1-likexu@tencent.com/
>>>
>>>   arch/x86/kvm/cpuid.c | 12 ++++++++++++
>>>   1 file changed, 12 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 0b920e12bb6d..4fe17a537084 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -782,6 +782,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>                eax.split.mask_length = cap.events_mask_len;
>>>
>>>                edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
>>> +
>>> +             /*
>>> +              * The 8th Intel architectural event (Topdown Slots) will be supported
>>
>> Nit, the "8th" part is unnecessary information.
>>
>>> +              * if the 4th fixed counter exists && EAX[31:24] > 7 && EBX[7] = 0.
>>> +              *
>>> +              * Currently, KVM needs to set EAX[31:24] < 8 or EBX[7] == 1
>>> +              * to make this event unavailable in a consistent way.
>>> +              */
>>
>> This comment is now slightly stale.  It also doesn't say why the event is made
>> unavailable.
>>
>>> +             if (edx.split.num_counters_fixed < 4 &&
>>
>> Rereading the changelog and the changelog of the Fixed commit, I don't think KVM
>> should bother checking num_counters_fixed.  IIUC, cap.events_mask[7] should already
>> be '1' if there are less than 4 fixed counters in hardware, but at the same time
>> there's no harm in being a bit overzealous.  That would help simplifiy the comment
>> as there's no need to explain why num_counters_fixed is checked, e.g. the fact that
>> Topdown Slots uses the 4th fixed counter is irrelevant with respect to the legality
>> of setting EBX[7]=1 to hide an unsupported event.
> 
> I was under the impression that the CPUID.0AH:EBX bits were
> independent of the fixed counters. That is, if CPUID.0AH:EAX[31:24] >
> 7 and CPUID.0AH:EBX[7] is clear, then one should be able to program a
> general purpose counter with event selector A4H and umask 01H,
> regardless of whether or not fixed counter 4 exists.

The impression stepped on my toes. This patch is pointless and magnifies my 
clumsiness.

Now the self-contradiction comes to the CLX and older platforms,

	0xA. EAX. Bits 31 - 24: Length of EBX bit vector to enumerate architectural
	performance monitoring events. Architectural event x is supported
	if EBX[x]=0 && EAX[31:24]>x.

however actually for CLX, its CPUID.0xA.EBX[7] = 0 && EAX[31:24] = 0x7 and
we can do exactly the following on a CLX without fixed ctr3

	$ perf stat -e cpu/event=0xa4,umask=0x01/ ls
  	Performance counter stats for 'ls':
          	2,448,185      cpu/event=0xa4,umask=0x01/

So in the context of Intel, we have a performance event that can share the
architectural encoding, but it is not an architectural-defined event.

This is strange, did I miss something somewhere ?

> 
>>
>>                  /*
>>                   * Hide Intel's Topdown Slots architectural event, it's not yet
>>                   * supported by KVM.
>>                   */
>>                  if (eax.split.mask_length > 7)
>>                          cap.events_mask |= BIT_ULL(7);
>>
>>> +                 eax.split.mask_length > 7)
>>> +                     cap.events_mask |= BIT_ULL(7);
>>> +
>>>                edx.split.bit_width_fixed = cap.bit_width_fixed;
>>>                if (cap.version)
>>>                        edx.split.anythread_deprecated = 1;
>>> --
>>> 2.33.1
>>>
