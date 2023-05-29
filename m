Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6C9714C7D
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 16:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjE2OwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 10:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjE2OwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 10:52:01 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED04AD;
        Mon, 29 May 2023 07:51:59 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d41d8bc63so2693947b3a.0;
        Mon, 29 May 2023 07:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685371919; x=1687963919;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dGKdelMf9dMhN4W4Pp2tFWvZsGNtCJT4OnZHjwgV2UM=;
        b=nEqOTdCt/GAM48PVZyVfrB++hpWYM9PJWjjupvNMbVhAm/qQZnh0ZQLNQkGyN7kCP7
         j3XeRPEJrsJZFi08RQ1WWJiHtuKolsf/qGXf89+k5lCtAvVFXSqWfRPZ0EvZMgYIgQJ3
         KkokZNhDVVfOPzzgwefrn7jjFVzxJKfBFyohTkUd+eWo1+I7K8yBagRmZO/VZiA6HF0N
         rp3DVswo6/4Pc+IpqdiGL3MXAUr9HSNdKXWGRwF33ULF/Y3m4yhulfd+N5aTWAm4hPiv
         c2EEfWd3J4VCpnsmVCo0u5KwM5YCEwZ6w7lav8592jgtkJzrk6wc8KYr4zvLUhBDhNKw
         YgYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685371919; x=1687963919;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGKdelMf9dMhN4W4Pp2tFWvZsGNtCJT4OnZHjwgV2UM=;
        b=EoD5D7h/ZsxTOWGBOLKH4t0rPgwxYfV6H9ODGOQv/RLTiK3fdg8rEO6RDThuyZGDOi
         P459r4z7vQReSB5H6Nt7FZN+c+0CVRHibxPW+Xm7V1Pu5ln+sL3y6MnUDNvnCHaGiyAy
         HQoC/dT8zM4fk9sPURgFhHQM9wJSRhz7OiloHVBjNlTVeAQzzaFUQBmdn76ak5/Sl5/m
         NhIEnVfyhiTdiExnaC2zzamwwMhUuwqOcPPo7ShUC+vUKbKyoloZs97YmZ+ELqn0zy9X
         BBPfQymxedd990EukWdxQRjtQI6UfKyMKDf+mvI5L2E3AwfWwCOUFxUP1w35Ihs6pPFB
         tYeg==
X-Gm-Message-State: AC+VfDzoSgZFgkX4hqiYWdDoSYny2EdFLPiPNAQ7T5SxVe14qZBAx1by
        moAxHXjxBOeHRrzRwGbaGrzIAewL9VlxfLJz1/s=
X-Google-Smtp-Source: ACHHUZ63epL3L7h5fEsa33wfT1JCbUApQdVNyF5SSRse/iE5yubxKNfZts+dgYxIH9XOqK7274epPw==
X-Received: by 2002:a05:6a20:9151:b0:110:b0ab:879d with SMTP id x17-20020a056a20915100b00110b0ab879dmr7006226pzc.26.1685371918955;
        Mon, 29 May 2023 07:51:58 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n12-20020aa78a4c000000b0064fdf576421sm39875pfa.142.2023.05.29.07.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:51:58 -0700 (PDT)
Message-ID: <ec42501c-2e66-5248-5b97-4827344418f3@gmail.com>
Date:   Mon, 29 May 2023 22:51:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
 <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com> <ZG52cgmjgaqY8jvq@google.com>
 <CALMp9eR_xYapRm=zJ3OdAzBVFjpzeQWYv9nTs1ZstAsugEwWRQ@mail.gmail.com>
 <ZG6BrSXDnOdDvUZh@google.com>
 <CALMp9eQrDX6=gJzybegjzDJ665NCuWmESt-sZrKHcncnuENdpA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eQrDX6=gJzybegjzDJ665NCuWmESt-sZrKHcncnuENdpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/5/2023 5:32 am, Jim Mattson wrote:
> On Wed, May 24, 2023 at 2:29 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Wed, May 24, 2023, Jim Mattson wrote:
>>> On Wed, May 24, 2023 at 1:41 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>
>>>> On Wed, Apr 26, 2023, Sandipan Das wrote:
>>>>> Hi Sean, Like,
>>>>>
>>>>> On 4/19/2023 7:11 PM, Like Xu wrote:
>>>>>>> Heh, it's very much explicable, it's just not desirable, and you and I would argue
>>>>>>> that it's also incorrect.
>>>>>>
>>>>>> This is completely inaccurate from the end guest pmu user's perspective.
>>>>>>
>>>>>> I have a toy that looks like virtio-pmu, through which guest users can get hypervisor performance data.
>>>>>> But the side effect of letting the guest see the VMRUN instruction by default is unacceptable, isn't it ?
>>>>>>
>>>>>>>
>>>>>>> AMD folks, are there plans to document this as an erratum?ï¿½ I agree with Like that
>>>>>>> counting VMRUN as a taken branch in guest context is a CPU bug, even if the behavior
>>>>>>> is known/expected.
>>>>>>
>>>>>
>>>>> This behaviour is architectural and an erratum will not be issued. However, for clarity, a future
>>>>> release of the APM will include additional details like the following:
>>>>>
>>>>>    1) From the perspective of performance monitoring counters, VMRUNs are considered as far control
>>>>>       transfers and VMEXITs as exceptions.
>>>>>
>>>>>    2) When the performance monitoring counters are set up to count events only in certain modes
>>>>>       through the "OsUserMode" and "HostGuestOnly" bits, instructions and events that change the
>>>>>       mode are counted in the target mode. For example, a SYSCALL from CPL 3 to CPL 0 with a
>>>>>       counter set to count retired instructions with USR=1 and OS=0 will not cause an increment of
>>>>>       the counter. However, the SYSRET back from CPL 0 to CPL 3 will cause an increment of the
>>>>>       counter and the total count will end up correct. Similarly, when counting PMCx0C6 (retired
>>>>>       far control transfers, including exceptions and interrupts) with Guest=1 and Host=0, a VMRUN
>>>>>       instruction will cause an increment of the counter. However, the subsequent VMEXIT that occurs,
>>>>>       since the target is in the host, will not cause an increment of the counter and so the total
>>>>>       count will end up correct.
>>>>
>>>> The count from the guest's perspective does not "end up correct".  Unlike SYSCALL,
>>>> where _userspace_ deliberately and synchronously executes a branch instruction,
>>>> VMEXIT and VMRUN are supposed to be transparent to the guest and can be completely
>>>> asynchronous with respect to guest code execution, e.g. if the host is spamming
>>>> IRQs, the guest will see a potentially large number of bogus (from it's perspective)
>>>> branches retired.
>>>
>>> The reverse problem occurs when a PMC is configured to count "CPUID
>>> instructions retired." Since KVM intercepts CPUID and emulates it, the
>>> PMC will always read 0, even if the guest executes a tight loop of
>>> CPUID instructions.

Unlikely. KVM will count any emulated instructions based on kvm_pmu_incr_counter().
Did I miss some conditions ?

>>>
>>> The PMU is not virtualizable on AMD CPUs without significant
>>> hypervisor corrections. I have to wonder if it's really worth the
>>> effort.

I used to think so, until I saw the AMD64_EVENTSEL_GUESTONLY bit.
Hardware architects are expected to put more effort into this area.

>>
>> Per our offlist chat, my understanding is that there are caveats with vPMUs that
>> it's simply not feasible for a hypervisor to handle.  I.e. virtualizing any x86
>> PMU with 100% accuracy isn't happening anytime soon.

Indeed, and any more detailed complaints ?

>>
>> The way forward is likely to evaluate each caveat on a case-by-case basis to
>> determine whether or not the cost of the fixup in KVM is worth the benefit to
>> the guest.  E.g. emulating "CPUID instructions retired" seems like it would be
>> fairly straightforward.  AFAICT, fixing up the VMRUN stuff is quite difficult though.
> 
> Yeah. The problem with fixing up "CPUID instructions retired" is
> tracking what the event encoding is for every F/M/S out there. It's
> not worth it.

I don't think it's feasible to emulate 100% accuracy on Intel. For guest pmu
users, it is motivated by wanting to know how effective they are running on
the current pCPU, and any vPMU eimulation behavior that helps this
understanding would be valuable.
