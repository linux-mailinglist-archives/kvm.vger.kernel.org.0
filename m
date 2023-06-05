Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37477722294
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 11:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjFEJuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 05:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjFEJuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 05:50:20 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BD6BD;
        Mon,  5 Jun 2023 02:50:19 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-558b04141e2so985318eaf.0;
        Mon, 05 Jun 2023 02:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685958619; x=1688550619;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tdwcVZdaoW7TosGAkP5MUtQ1CLIdAVBMtQGHP5dQ97Y=;
        b=Sz2HZhAFjt2rnDllYzg9isU3HRYu56zhE2aHk0kWUSQ6NMsJUW/ZxNMHtRhBVQxI+X
         A5kw3Xthy1NWnhGiUToYhVKpnfIZqbkR3mn+a5pivLdlIFKgyHP80hD6rHA0xE6vDGC/
         xy4Hsq/TWVavDvnTU76d64OpM/6+2tyAV6JO907GaXf0SharLfDM+2EUoh5CovbKGNxW
         C95ZpQO/K7R0xitN8KXDJUwLKXg/hpc6ba8kQg3p46aFCDWXUk9BZg9ZhZi8AO2Ek/wU
         eJE7C5ZzUIApRgggtUDaLQF/NhY202HQuUDygtCE+b1GcbqzNCsPKqq1svAy+xEKUBU6
         50mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685958619; x=1688550619;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tdwcVZdaoW7TosGAkP5MUtQ1CLIdAVBMtQGHP5dQ97Y=;
        b=T0QCMqzLHVjtOcSDF+huIktgOHJXWpAZAAk0HwJnhQR0z/92uA0Yt4nLzVnsHeElqy
         7gVAkMQe62iuD3prou4KwZ2tatf00nCJQRE1DaD5sYlACDyc1WeGFkIv4RG6Qsor62gT
         2WhTPSuEh4v2lBc26Huao0nD69yruxBMhIycFQWlhoKrJu4nDgLt0MTAsnoF6GsHrP5X
         RthcxG0f8XzXy3Dc8Kz14Pd3rP7HV6IqUTZmhDdORS0Y59s1xI/0oX5s+09Zs2Mcqfeo
         GclO6vhlrFU2ivGQ05kPwC4jgOqpUAnWkzIFu0IQP9GYAuM1e6MXWhmZCghQbk1s/bB7
         BKvg==
X-Gm-Message-State: AC+VfDw+seL1625AA3bzXHYVM0QugcRPWbaAzZB0fLtMXcM0FYF2QAtr
        ZDVz8LlZAA2EzzI6Y/MmaPk=
X-Google-Smtp-Source: ACHHUZ6+m88LQ/iA48skVkGmZtJMXGUKulOzHQzVJg4ZloukJWAHYdmk2CmUy5tkexFvrsXuHcpWvQ==
X-Received: by 2002:a05:6359:29:b0:127:f2f6:ef35 with SMTP id en41-20020a056359002900b00127f2f6ef35mr9266432rwb.3.1685958618563;
        Mon, 05 Jun 2023 02:50:18 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 30-20020a630b1e000000b0050f85ef50d1sm5357933pgl.26.2023.06.05.02.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 02:50:17 -0700 (PDT)
Message-ID: <c9beecb6-be6b-198e-1bc7-848473972534@gmail.com>
Date:   Mon, 5 Jun 2023 17:50:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH v2 00/15] Introduce Architectural LBR for vPMU
To:     Sean Christopherson <seanjc@google.com>, xiong.y.zhang@intel.com
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kan.liang@linux.intel.com
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <Y9RUOvJ5dkCU9J8C@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y9RUOvJ5dkCU9J8C@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+xiongzha to follow up.

On 28/1/2023 6:46 am, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> Intel CPU model-specific LBR(Legacy LBR) has evolved to Architectural
>> LBR(Arch LBR [0]), it's the replacement of legacy LBR on new platforms.
>> The native support patches were merged into 5.9 kernel tree, and this
>> patch series is to enable Arch LBR in vPMU so that guest can benefit
>> from the feature.
>>
>> The main advantages of Arch LBR are [1]:
>> - Faster context switching due to XSAVES support and faster reset of
>>    LBR MSRs via the new DEPTH MSR
>> - Faster LBR read for a non-PEBS event due to XSAVES support, which
>>    lowers the overhead of the NMI handler.
>> - Linux kernel can support the LBR features without knowing the model
>>    number of the current CPU.
>>
>>  From end user's point of view, the usage of Arch LBR is the same as
>> the Legacy LBR that has been merged in the mainline.
>>
>> Note, in this series, there's one restriction for guest Arch LBR, i.e.,
>> guest can only set its LBR record depth the same as host's. This is due
>> to the special behavior of MSR_ARCH_LBR_DEPTH:
>> 1) On write to the MSR, it'll reset all Arch LBR recording MSRs to 0s.
>> 2) XRSTORS resets all record MSRs to 0s if the saved depth mismatches
>> MSR_ARCH_LBR_DEPTH.
>> Enforcing the restriction keeps KVM Arch LBR vPMU working flow simple
>> and straightforward.
>>
>> Paolo refactored the old series and the resulting patches became the
>> base of this new series, therefore he's the author of some patches.
> 
> To be very blunt, this series is a mess.  I don't want to point fingers as there
> is plenty of blame to go around.  The existing LBR support is a confusing mess,
> vPMU as a whole has been neglected for too long, review feedback has been relatively
> non-existent, and I'm sure some of the mess is due to Paolo trying to hastily fix
> things up back when this was temporarily queued.
> 
> However, for arch LBR support to be merged, things need to change.
> 
> First and foremost, the existing LBR support needs to be documented.  Someone,
> I don't care who, needs to provide a detailed writeup of the contract between KVM
> and perf.  Specifically, I want to know:
> 
>    1. When exactly is perf allowed to take control of LBR MRS.  Task switch?  IRQ?
>       NMI?
> 
>    2. What is the expected behavior when perf is using LBRs?  Is the guest supposed
>       to be traced?
> 
>    3. Why does KVM snapshot DEBUGCTL with IRQs enabled, but disables IRQs when
>       accessing LBR MSRs?
> 
> It doesn't have to be polished, e.g. I'll happily wordsmith things into proper
> documentation, but I want to have a very clear understanding of how LBR support
> is _intended_ to function and how it all _actually_ functions without having to
> make guesses.

This is a very good topic for LPC KVM Microconference.

Many thanks to Sean for ranting about something that only I was thinking
about before. Having host and guest be able to use PMU at the same time
in peace (hybrid profiling mode) is a very use-case worthy goal rather than
introducing exclusivity, and it's clear that kvm+perf lacks reasonable and
well-documented support when there is host perf user interference.

Ref: https://lpc.events/event/17/page/200-proposed-microconferences#kvm

> 
> And depending on the answers, I want to revisit KVM's LBR implementation before
> tackling arch LBRs.  Letting perf usurp LBRs while KVM has the vCPU loaded is
> frankly ridiculous.  Just have perf set a flag telling KVM that it needs to take
> control of LBRs and have KVM service the flag as a request or something.  Stealing
> the LBRs back in IRQ context adds a stupid amount of complexity without much value,
> e.g. waiting a few branches for KVM to get to a safe place isn't going to meaningfully
> change the traces.  If that can't actually happen, then why on earth does KVM need
> to disable IRQs to read MSRs?
> 
> And AFAICT, since KVM unconditionally loads the guest's DEBUGCTL, whether or not
> guest branches show up in the LBRs when the host is tracing is completely up to
> the whims of the guest.  If that's correct, then again, what's the point of the
> dance between KVM and perf?
> 
> Beyond the "how does this work" issues, there needs to be tests.  At the absolute
> minimum, there needs to be selftests showing that this stuff actually works, that
> save/restore (migration) works, that the MSRs can/can't be accessed when guest
> CPUID is (in)correctly configured, etc. And I would really, really like to have
> tests that force contention between host and guests, e.g. to make sure that KVM
> isn't leaking host state or outright exploding, but I can understand that those
> types of tests would be very difficult to write.
> 
> I've pushed a heavily reworked, but definitely broken, version to
> 
>    git@github.com:sean-jc/linux.git x86/arch_lbrs
> 
> It compiles, but it's otherwise untested and there are known gaps.  E.g. I omitted
> toggling load+clear of ARCH_LBR_CTL because I couldn't figure out the intended
> behavior.
