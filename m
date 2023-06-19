Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0B0734EB0
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjFSIyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjFSIxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:53:41 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F623AAA
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:52:36 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-54fac3b7725so1112379a12.3
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687164756; x=1689756756;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o32zhHPH9dlxXlg+cTuJYce/UWbfkcquDipPvOEOnS0=;
        b=rX4AYXOcRmpTowP6pa8hgvZgRZW/8ttJaztoyr9rPMgotBNE9djJAL8t8ahcEZ9rHD
         qICpWZZ7GXIYKIPBjOT1OM8oVmAXNh/ObbesLWgk6n/ydZCGQ5A1vNnK+Cy8tdiBxXf0
         SmxpPE3Bhaf2zXOXtJIl2CGHdZsd/pb5rOfu5IKDm8er8HfBTS1NiUlS9I4s0cTlvSBa
         PktcAeV2KOx0g3jTigvthGtI4MxXuFFcXv7yMeg9ANe38m1yM9FyhtkU+hxV0+S8r4b6
         Wn7574gsL8BDvPSFwNZLYLtcqWm2f36wU54mEf1PVomCGrNa1J9zxR8L24OFrOb5grPU
         v6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687164756; x=1689756756;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o32zhHPH9dlxXlg+cTuJYce/UWbfkcquDipPvOEOnS0=;
        b=BNAJFv3fN519l7iJT7mB35lDfby0idXuPx44MrN+D1yPfzzVMVI4uGRkqmWGqnwMtg
         vOL04nZtT/5EWMIiQYZjJ25xpwFbvbIKicRmfmQmLkUsL4rQ68/y0ShchfvQ6DDDzD6g
         li0ObxEkqT0xApigxtPRsVJZl9ceefeECotZf6Brkh/JVjTLluTAG5zseNKqwFTdbl1J
         0YT4lkQyTD7KNcqqd7o3r/kg7prjF8h8EzD0P7vQDcIYTxgA8cKeTZfg94/GsdwMXxMg
         Fe2E2VNKChCx0uNpiLaWog0qC6Y/dsUu3o+O+3FPcZ657bhWjnRBMfTBrzlInuoULLwW
         K4kg==
X-Gm-Message-State: AC+VfDxeABRh22ES4IDo7qm0J82XGgcocGr/a7viEGuzMlfmpuD4CI4F
        POfDPmlMgy4CHf3pGDWQuhQ=
X-Google-Smtp-Source: ACHHUZ457fDHQcHQZeJbaCaNYKn6K1hwnN2BhiUC7y/R6VnJXGQlOND+/7n93OHM9VShzMn04QLVFw==
X-Received: by 2002:a17:902:ec86:b0:1b0:378e:279f with SMTP id x6-20020a170902ec8600b001b0378e279fmr5972089plg.19.1687164755880;
        Mon, 19 Jun 2023 01:52:35 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t11-20020a1709028c8b00b001ae0152d280sm19799901plo.193.2023.06.19.01.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 01:52:35 -0700 (PDT)
Message-ID: <36d749a2-b349-e5f4-3683-a4d595bafec9@gmail.com>
Date:   Mon, 19 Jun 2023 16:52:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH v2 0/2] target/i386/kvm: fix two svm pmu virtualization
 bugs
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, zhenyuw@linux.intel.com
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        groug@kaod.org, lyan@digitalocean.com, qemu-devel@nongnu.org,
        kvm list <kvm@vger.kernel.org>
References: <20221202002256.39243-1-dongli.zhang@oracle.com>
 <895f5505-db8c-afa4-bfb1-26ecbe27690a@oracle.com>
 <eea7b6ba-c0bd-8a1e-b2a8-2f08c954628b@oracle.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <eea7b6ba-c0bd-8a1e-b2a8-2f08c954628b@oracle.com>
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

I think we've been stuck here too long. Sorry Dongli.

+zhenyu, could you get someone to follow up on this, or I will start working on 
that.

On 9/1/2023 9:19 am, Dongli Zhang wrote:
> Ping?
> 
> About [PATCH v2 2/2], the bad thing is that the customer will not be able to
> notice the issue, that is, the "Broken BIOS detected" in dmesg, immediately.
> 
> As a result, the customer VM many panic randomly anytime in the future (once
> issue is encountered) if "/proc/sys/kernel/unknown_nmi_panic" is enabled.
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> On 12/19/22 06:45, Dongli Zhang wrote:
>> Can I get feedback for this patchset, especially the [PATCH v2 2/2]?
>>
>> About the [PATCH v2 2/2], currently the issue impacts the usage of PMUs on AMD
>> VM, especially the below case:
>>
>> 1. Enable panic on nmi.
>> 2. Use perf to monitor the performance of VM. Although without a test, I think
>> the nmi watchdog has the same effect.
>> 3. A sudden system reset, or a kernel panic (kdump/kexec).
>> 4. After reboot, there will be random unknown NMI.
>> 5. Unfortunately, the "panic on nmi" may panic the VM randomly at any time.
>>
>> Thank you very much!
>>
>> Dongli Zhang
>>
>> On 12/1/22 16:22, Dongli Zhang wrote:
>>> This patchset is to fix two svm pmu virtualization bugs, x86 only.
>>>
>>> version 1:
>>> https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/
>>>
>>> 1. The 1st bug is that "-cpu,-pmu" cannot disable svm pmu virtualization.
>>>
>>> To use "-cpu EPYC" or "-cpu host,-pmu" cannot disable the pmu
>>> virtualization. There is still below at the VM linux side ...
>>>
>>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>>
>>> ... although we expect something like below.
>>>
>>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>>
>>> The 1st patch has introduced a new x86 only accel/kvm property
>>> "pmu-cap-disabled=true" to disable the pmu virtualization via
>>> KVM_PMU_CAP_DISABLE.
>>>
>>> I considered 'KVM_X86_SET_MSR_FILTER' initially before patchset v1.
>>> Since both KVM_X86_SET_MSR_FILTER and KVM_PMU_CAP_DISABLE are VM ioctl. I
>>> finally used the latter because it is easier to use.
>>>
>>>
>>> 2. The 2nd bug is that un-reclaimed perf events (after QEMU system_reset)
>>> at the KVM side may inject random unwanted/unknown NMIs to the VM.
>>>
>>> The svm pmu registers are not reset during QEMU system_reset.
>>>
>>> (1). The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
>>> is running "perf top". The pmu registers are not disabled gracefully.
>>>
>>> (2). Although the x86_cpu_reset() resets many registers to zero, the
>>> kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
>>> some pmu events are still enabled at the KVM side.
>>>
>>> (3). The KVM pmc_speculative_in_use() always returns true so that the events
>>> will not be reclaimed. The kvm_pmc->perf_event is still active.
>>>
>>> (4). After the reboot, the VM kernel reports below error:
>>>
>>> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
>>> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
>>>
>>> (5). In a worse case, the active kvm_pmc->perf_event is still able to
>>> inject unknown NMIs randomly to the VM kernel.
>>>
>>> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>>>
>>> The 2nd patch is to fix the issue by resetting AMD pmu registers as well as
>>> Intel registers.
>>>
>>>
>>> This patchset does not cover PerfMonV2, until the below patchset is merged
>>> into the KVM side.
>>>
>>> [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
>>> https://lore.kernel.org/all/20221111102645.82001-1-likexu@tencent.com/
>>>
>>>
>>> Dongli Zhang (2):
>>>        target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
>>>        target/i386/kvm: get and put AMD pmu registers
>>>
>>>   accel/kvm/kvm-all.c      |   1 +
>>>   include/sysemu/kvm_int.h |   1 +
>>>   qemu-options.hx          |   7 +++
>>>   target/i386/cpu.h        |   5 ++
>>>   target/i386/kvm/kvm.c    | 129 +++++++++++++++++++++++++++++++++++++++++-
>>>   5 files changed, 141 insertions(+), 2 deletions(-)
>>>
>>> Thank you very much!
>>>
>>> Dongli Zhang
>>>
>>>
> 
> 
