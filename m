Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B51F3B4E06
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfIQMkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 08:40:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49694 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728168AbfIQMkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 08:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568724052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=fZFqB/vEzGAt7ktglfnPM4EYstI/gJ/8iaZDYhzdYVo=;
        b=L3IbdnoUbOgdgR+USa6bZZDT5GBJt95Z4OIJubLOZNoeZ3WGPY18Kf2xhTkBCtfz10bCAc
        C+hXS0fwioGFvvSdmfXJFkUcfbR5lBK4dN3h48dLmRUkRrf8MEt91Dw/x6ITyyW2BwcY9k
        Bnz0YiloItU3kiPsFd5KVIQF7wmSLSE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-_XDUxOUkO4i1avFpWfZXhA-1; Tue, 17 Sep 2019 08:39:44 -0400
Received: by mail-wr1-f70.google.com with SMTP id w10so1273533wrl.5
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 05:39:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r4IenELIElJC+2Y89jzdksnturr4HnfpL2WsX+2BBtg=;
        b=kA2WOOEMCwsgCJrcjZKN+GIzPz12sIs6QaUXPQ0mqFAUu8kJ2yWNK4MDYHNrT2kluW
         X0cvTMMsq6yCyVesNcy3lmnk7jw6brrsQdk6qtViDI8zL1PqJs4Jnmz9LrKas1fscHDS
         CGU0e5dTGK+eGWfrm12IfwNfYXAc5BGpoLXh5cP2d2iZBI1NNxRVxdtVyq48ZTOYerpk
         fnPs5egdsRRxQfWZf1M0BLj3gDH6lcWViFrh4WzHwBj5VJI9G6dimg6Zr+ddpn0XbHDJ
         qBQGSG2r8Gd5C78knkkPAjBRm5KnlhndloQx3fEOv/tn8EkWdUPNefQTKY+vnmGiePP2
         0YlA==
X-Gm-Message-State: APjAAAVnoGXIEP3QHbWCnkKcbQBp65vqDIJ/tuNvSU5mVh5O4CUujtP3
        yBNOOZnfEbW3rCdKW9+hgZKzeFM+OL+0iG59RJxTAAwaRjsMBliUyprXwN+AKShXrm3bTlwNUGZ
        R284kmiX1bBXH
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr2728927wrx.156.1568723983487;
        Tue, 17 Sep 2019 05:39:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzaBnDTsPNA5kf0yTT7L440FDa6rgwuYYGO5egrbPg4F3ClVwsnCFs5WG83eXzF1/KNJ2PjtA==
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr2728911wrx.156.1568723983152;
        Tue, 17 Sep 2019 05:39:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id e17sm2447445wma.15.2019.09.17.05.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 05:39:42 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190821182004.102768-1-jmattson@google.com>
 <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
 <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
 <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
Date:   Tue, 17 Sep 2019 14:39:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: _XDUxOUkO4i1avFpWfZXhA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/19 22:43, Jim Mattson wrote:
> On Fri, Sep 6, 2019 at 2:08 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Fri, Sep 6, 2019 at 1:43 PM Krish Sadhukhan
>> <krish.sadhukhan@oracle.com> wrote:
>>>
>>>
>>> On 9/6/19 1:30 PM, Jim Mattson wrote:
>>>> On Fri, Sep 6, 2019 at 12:59 PM Krish Sadhukhan
>>>> <krish.sadhukhan@oracle.com> wrote:
>>>>>
>>>>> On 9/6/19 9:48 AM, Jim Mattson wrote:
>>>>>
>>>>> On Wed, Aug 21, 2019 at 11:20 AM Jim Mattson <jmattson@google.com> wr=
ote:
>>>>>
>>>>> These MSRs should be enumerated by KVM_GET_MSR_INDEX_LIST, so that
>>>>> userspace knows that these MSRs may be part of the vCPU state.
>>>>>
>>>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>>>> Reviewed-by: Eric Hankland <ehankland@google.com>
>>>>> Reviewed-by: Peter Shier <pshier@google.com>
>>>>>
>>>>> ---
>>>>>   arch/x86/kvm/x86.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>>>>   1 file changed, 41 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>> index 93b0bd45ac73..ecaaa411538f 100644
>>>>> --- a/arch/x86/kvm/x86.c
>>>>> +++ b/arch/x86/kvm/x86.c
>>>>> @@ -1140,6 +1140,42 @@ static u32 msrs_to_save[] =3D {
>>>>>          MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>>>>>          MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>>>>>          MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
>>>>> +       MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
>>>>> +       MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 =
+ 3,
>>>>> +       MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
>>>>> +       MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 6, MSR_ARCH_PERFMON_PERFCTR0 + 7,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 1=
1,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 1=
3,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 1=
5,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 1=
7,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 18, MSR_ARCH_PERFMON_PERFCTR0 + 1=
9,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 20, MSR_ARCH_PERFMON_PERFCTR0 + 2=
1,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 22, MSR_ARCH_PERFMON_PERFCTR0 + 2=
3,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 24, MSR_ARCH_PERFMON_PERFCTR0 + 2=
5,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 26, MSR_ARCH_PERFMON_PERFCTR0 + 2=
7,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 28, MSR_ARCH_PERFMON_PERFCTR0 + 2=
9,
>>>>> +       MSR_ARCH_PERFMON_PERFCTR0 + 30, MSR_ARCH_PERFMON_PERFCTR0 + 3=
1,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + =
3,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + =
5,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 6, MSR_ARCH_PERFMON_EVENTSEL0 + =
7,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + =
9,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 +=
 11,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 +=
 13,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 +=
 15,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 +=
 17,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 18, MSR_ARCH_PERFMON_EVENTSEL0 +=
 19,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 20, MSR_ARCH_PERFMON_EVENTSEL0 +=
 21,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 22, MSR_ARCH_PERFMON_EVENTSEL0 +=
 23,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 24, MSR_ARCH_PERFMON_EVENTSEL0 +=
 25,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 26, MSR_ARCH_PERFMON_EVENTSEL0 +=
 27,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 28, MSR_ARCH_PERFMON_EVENTSEL0 +=
 29,
>>>>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 30, MSR_ARCH_PERFMON_EVENTSEL0 +=
 31,
>>>>>   };
>>>>>
>>>>>
>>>>> Should we have separate #defines for the MSRs that are at offset from=
 the base MSR?
>>>> How about macros that take an offset argument, rather than a whole
>>>> slew of new macros?
>>>
>>>
>>> Yes, that works too.
>>>
>>>
>>>>
>>>>>   static unsigned num_msrs_to_save;
>>>>> @@ -4989,6 +5025,11 @@ static void kvm_init_msr_list(void)
>>>>>          u32 dummy[2];
>>>>>          unsigned i, j;
>>>>>
>>>>> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED !=3D 4,
>>>>> +                        "Please update the fixed PMCs in msrs_to_sav=
e[]");
>>>>> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_GENERIC !=3D 32,
>>>>> +                        "Please update the generic perfctr/eventsel =
MSRs in msrs_to_save[]");
>>>>>
>>>>>
>>>>> Just curious how the condition can ever become false because we are c=
omparing two static numbers here.
>>>> Someone just has to change the macros. In fact, I originally developed
>>>> this change on a version of the kernel where INTEL_PMC_MAX_FIXED was
>>>> 3, and so I had:
>>>>
>>>>> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED !=3D 3,
>>>>> +                        "Please update the fixed PMCs in msrs_to_sav=
e[]")
>>>> When I cherry-picked the change to Linux tip, the BUILD_BUG_ON fired,
>>>> and I updated the fixed PMCs in msrs_to_save[].
>>>>
>>>>> +
>>>>>          for (i =3D j =3D 0; i < ARRAY_SIZE(msrs_to_save); i++) {
>>>>>                  if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]=
) < 0)
>>>>>                          continue;
>>>>> --
>>>>> 2.23.0.187.g17f5b7556c-goog
>>>>>
>>>>> Ping.
>>>>>
>>>>>
>>>>> Also, since these MSRs are Intel-specific, should these be enumerated=
 via 'intel_pmu_ops' ?
>>>> msrs_to_save[] is filtered to remove MSRs that aren't supported on the
>>>> host. Or are you asking something else?
>>>
>>>
>>> I am referring to the fact that we are enumerating Intel-specific MSRs
>>> in the generic KVM code. Should there be some sort of #define guard to
>>> not compile the code on AMD ?
>>
>> No. msrs_to_save[] contains *all* MSRs that may be relevant on some
>> platform. Notice that it already includes AMD-only MSRs (e.g.
>> MSR_VM_HSAVE_PA) and Intel-only MSRs (e.g. MSR_IA32_BNDCFGS). The MSRs
>> that are not relevant are filtered out in kvm_init_msr_list().
>>
>> This list probably should include the AMD equivalents as well, but I
>> haven't looked into the AMD vPMU yet.
>=20
> Ping.
>=20

Queued, thanks.

Paolo

