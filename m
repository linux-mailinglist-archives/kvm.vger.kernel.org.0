Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272E4545A3D
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 04:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbiFJCtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 22:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbiFJCtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 22:49:06 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1F04BB86
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 19:49:03 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r71so23588143pgr.0
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 19:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZGlPHE+ZVcD3zZX1u6KPpu84KUaBjxnaxN7YpfDhOzw=;
        b=c37+rtYrRcQItTpXjQktCwv7I5M1vD3PShXdjyei0AVlKcvIzvLemATHoLdyr54IKo
         d+lnfrUycyZFb79VV6ICazRWusiqX8a2Sc7PG2FmTCQinuLg2egHXu0wSazsgWLDfhd0
         ahqmORKsXu5gf9swTI0uWqOUC8dKOTv/ND+6yqTgzusp3rO1ZaX5AO8j0H1PhOEZ/m4X
         2attves8aaooX0Sog2kQ1fxZW6INON67Ns1WroAiZX9ab3+NN6b1AfVxhoEoijLUhCMk
         q66ruQsUETjSx1yz3GFiuMRgwLQvN2i70sDvPs0G72enDtbUSvlMnSSBIwAzEJuAko6X
         TKHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZGlPHE+ZVcD3zZX1u6KPpu84KUaBjxnaxN7YpfDhOzw=;
        b=8HKfXfO3Yb7qQKCijq6+Q2pY3yce1eqLtdcre6XXnUU6lL9lZZJohfRpO/Ar7mnjFL
         wxl5eYQu1Bnv39UnqZtyneBEDIPq3UG+fQRLy5xuBd5davjC+JMwGK89FkVgkv29EphX
         dvmDEkDCu2ueRzik02Dp6Ra3Ubu1kM0Rjm+ay5HyWDSGiCs/5OstpC5aEyayyITiP1iy
         tRAc3hDahaexGJfvI2jEfV4CFL2ehiiN1S2h4WnR7lacZJBTmA7DVeDVM0CGBxwJSWjO
         0cD2qdmTSjCY6zuTBcS5HmoAppIqGSrSn7nU+5e9RjWLImSw6Zp3V3Oc0T94+4ZgbGb6
         p0dg==
X-Gm-Message-State: AOAM531NXgPc7mOnpd+1fpS8dMeVnH19epJhT6YZTdEWlk0Ya218Fa36
        3GkApAfeS3SNXvDNj5W/ZTHIZOjtN+5pwA==
X-Google-Smtp-Source: ABdhPJwU6oS6d6US258povw4Xp96VGgxQD9RsygJ1tfK1FYwECtjwKIiWGYOZyFCrtT8R0vPg2EOrA==
X-Received: by 2002:a63:90c8:0:b0:3fc:ad6f:6e96 with SMTP id a191-20020a6390c8000000b003fcad6f6e96mr37895527pge.256.1654829343277;
        Thu, 09 Jun 2022 19:49:03 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.23])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902714200b001621cd83e49sm17562711plm.92.2022.06.09.19.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 19:49:02 -0700 (PDT)
Message-ID: <ddff538b-81c4-6d96-bda8-6f614f1304fa@gmail.com>
Date:   Fri, 10 Jun 2022 10:48:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu
 is disabled
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-4-weijiang.yang@intel.com>
 <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
 <987d8a3d-19ef-094d-5c0e-007133362c30@intel.com>
 <CALMp9eT4JD-jTwOmpsayqZvheh4BvWB2aUiRAGsxNT145En6xg@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eT4JD-jTwOmpsayqZvheh4BvWB2aUiRAGsxNT145En6xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/2022 10:24 am, Jim Mattson wrote:
> On Thu, Jun 9, 2022 at 6:47 PM Yang, Weijiang <weijiang.yang@intel.com> wrote:
>>
>>
>> On 6/10/2022 8:14 AM, Like Xu wrote:
>>> On 9/6/2022 4:39 pm, Yang Weijiang wrote:
>>>> executing rdpmc leads to #GP,
>>>
>>> RDPMC still works on processors that do not support architectural
>>> performance monitoring.
>>>
>>> The #GP will violate ISA, and try to treat it as NOP (plus EAX=EDX=0)
>>> if !enable_pmu.
>>
>> After a quick check in SDM, I cannot find wordings supporting your above
>> comments, can you
>>
>> point me to it?
> 
> In volume 2,  under RDPMC...
> 
> o  If the processor does not support architectural performance
> monitoring (CPUID.0AH:EAX[7:0]=0), ECX[30:0] specifies the index of
> the PMC to be read. Setting ECX[31] selects “fast” read mode if
> supported. In this mode, RDPMC returns bits 31:0 of the PMC in EAX
> while clearing EDX to zero.

We also miss this part in the KVM code:

for (CPUID.0AH:EAX[7:0]=0), the width of general-purpose performance PMCs is 40 bits
while the widths of special-purpose PMCs are implementation specific.

We may consider the "specific implementation" as "at the discretion of KVM".

> 
> For more details, see the following sections of volume 3:
> 19.6.3 Performance Monitoring (Processors Based on Intel NetBurst
> Microarchitecture)
> 19.6.8 Performance Monitoring (P6 Family Processor)
> 19.6.9 Performance Monitoring (Pentium Processors)
> 
>> Another concern is, when !enable_pmu, should we make RDPMC "work" with
>> returning EAX=EDX=0?
>>
>> Or just simply inject #GP to VM in this case?
> 
> Unless KVM is running on a Prescott, it's going to be very difficult
> to emulate one of these three pre-architectural performance monitoring
> PMUs. There certainly isn't any code to do it today. In fact, there is

I don't think so. How arbitrary is this assertion.

We have user space like QEMU or GCP to set/unset cpuid.0xa fine-grained,
the combination of features will be more flexible in virtualization world.

> no code in KVM to virtualize the NetBurst PMU, even on Prescott.
> 
> I think Like is being overly pedantic (which is usually my role).

I am indeed greatly influenced by you. :D

> RDPMC should behave exactly the same way that RDMSR behaves when
> accessing the same counter. The last time I looked, RDMSR synthesizes
> #GP for PMC accesses when !enable_pmu.

The handling of the available MSR ranges and the available ISA instructions
(especially user space available) are different.

Users want to make sure their code (using RDPMC on whatever RDPMC-available 
guest) is robust.

The emulation of "use RDPMC if !enable_pmu" should be consistent with
the emulation of "use RDPMC to access an unsupported counter".

RDPMC Intel Operation:

MSCB = Most Significant Counter Bit (* Model-specific *)
IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported 
counter))
	THEN
		EAX := counter[31:0];
		EDX := ZeroExtend(counter[MSCB:32]);
	ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
		#GP(0);
FI;

Therefore, we will not have a #GP if !enable_pmu for legacy or future user space 
programs.
