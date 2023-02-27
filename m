Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948576A3B3C
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 07:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjB0GZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 01:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjB0GZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 01:25:48 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1A2E39D
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 22:25:20 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so6300569wmb.3
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 22:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pujNXX8uuARxDMs7pbFXDg7/dOOWF+JdqAd/evz5sDw=;
        b=V/TQUDCB7rv+cw2TdL91bDE+dJA9qCsk1vIRb+G8donI4hviuj4sENzQNlfbda6xuZ
         bpJpYl5lnDv80kETsiwB2d5gY960gG7kJ5XnZAXufJq9VHtNndT86oBtCKefKus+jkdq
         yCNwhvbZS/52ahk+GkEuR6wc7P9Gj9whKOD3ogaT/zgabuacRAg7bvTh8xs5ILdiLhhf
         wJSG3NhYUJ7de+v53m7uuofPwChyMcoaFSVT5mX2cXChjRwzhv58q+8+5NNhaX/Iz+z5
         KdRmpV9SwXAidC2dvqrRQcMOlUlbhwBNUMpB6E6Ygz6NfOcWp95teXZRZnyX22heMEWZ
         L4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pujNXX8uuARxDMs7pbFXDg7/dOOWF+JdqAd/evz5sDw=;
        b=JZOZxNv/5EYF90xKGogyB5PAF439ys65QeOMyIGgcfu7QELNPAmqzCz4wHHhEY/Fbb
         w15InHIZ18zfPd7DGjnRJ8Gk1kLbWiezFWA0MlaBP6LHZzq3jWSJT1c8NTw+ubg6Ba7j
         hcbOQb1llC+j7ACEdMW8Bdmq5njtognaoPav1XZFO7MVgNyPYUOe/z228V3fnfKd4LVQ
         k2MZaQTuYsomCRPVtkLyBvo/A1D06PWbPWY9F+6Os7nRNZYQfch1Sr7NECIEH0uQw+Tt
         qn9a7yW7kFj+iD8/loWF7PWV4nM5LahxN8UbGH0EWEWt8Msdtb6v4uVD8KXmGYdKQkQ0
         m5dw==
X-Gm-Message-State: AO0yUKXWAW/YsRiOof1IAe5mXYzDAKnNAGGxLHpaXelBUbeS8+/xReug
        csVJr6t1tFyPC7L/Jf/zNpo9/w==
X-Google-Smtp-Source: AK7set9YZptaNcpM2tUhWp+/BQsYtKzhcp9G3+jskEjqOHmg8u8jmWKIT60vbUussgRUnDc9Y5ar5w==
X-Received: by 2002:a05:600c:810:b0:3db:2e06:4091 with SMTP id k16-20020a05600c081000b003db2e064091mr18520089wmp.37.1677479118687;
        Sun, 26 Feb 2023 22:25:18 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:6caa:9121:bec9:a2a9? ([2a02:6b6a:b566:0:6caa:9121:bec9:a2a9])
        by smtp.gmail.com with ESMTPSA id t23-20020a05600c2f9700b003e2232d0960sm7877010wmn.23.2023.02.26.22.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 22:25:18 -0800 (PST)
Message-ID: <c795e967-b69d-33fd-b333-b0f8e0636b5b@bytedance.com>
Date:   Mon, 27 Feb 2023 06:25:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v12 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        tglx@linutronix.de, kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <5650744.DvuYhMxLoT@natalenko.name>
 <819d8fa2-b73e-e32f-5442-452aa2c0d752@bytedance.com>
 <EB27C1C4-7246-4557-A6B3-EBBC9E8FC69F@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <EB27C1C4-7246-4557-A6B3-EBBC9E8FC69F@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/02/2023 06:13, David Woodhouse wrote:
> 
> 
> On 26 February 2023 20:59:17 GMT, Usama Arif <usama.arif@bytedance.com> wrote:
>>
>>
>> On 26/02/2023 18:31, Oleksandr Natalenko wrote:
>>> Hello.
>>>
>>> On neděle 26. února 2023 12:07:51 CET Usama Arif wrote:
>>>> The main code change over v11 is the build error fix by Brian Gerst and
>>>> acquiring tr_lock in trampoline_64.S whenever the stack is setup.
>>>>
>>>> The git history is also rewritten to move the commits that removed
>>>> initial_stack, early_gdt_descr and initial_gs earlier in the patchset.
>>>>
>>>> Thanks,
>>>> Usama
>>>>
>>>> Changes across versions:
>>>> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
>>>> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>>>>       in preparation for more parallelisation.
>>>> v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
>>>>       avoid scribbling on initial_gs in common_cpu_up(), and to allow all
>>>>       24 bits of the physical X2APIC ID to be used. That patch still needs
>>>>       a Signed-off-by from its original author, who once claimed not to
>>>>       remember writing it at all. But now we've fixed it, hopefully he'll
>>>>       admit it now :)
>>>> v5: rebase to v6.1 and remeasure performance, disable parallel bringup
>>>>       for AMD CPUs.
>>>> v6: rebase to v6.2-rc6, disabled parallel boot on amd as a cpu bug and
>>>>       reused timer calibration for secondary CPUs.
>>>> v7: [David Woodhouse] iterate over all possible CPUs to find any existing
>>>>       cluster mask in alloc_clustermask. (patch 1/9)
>>>>       Keep parallel AMD support enabled in AMD, using APIC ID in CPUID leaf
>>>>       0x0B (for x2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.
>>>>       Included sanity checks for APIC id from 0x0B. (patch 6/9)
>>>>       Removed patch for reusing timer calibration for secondary CPUs.
>>>>       commit message and code improvements.
>>>> v8: Fix CPU0 hotplug by setting up the initial_gs, initial_stack and
>>>>       early_gdt_descr.
>>>>       Drop trampoline lock and bail if APIC ID not found in find_cpunr.
>>>>       Code comments improved and debug prints added.
>>>> v9: Drop patch to avoid repeated saves of MTRR at boot time.
>>>>       rebased and retested at v6.2-rc8.
>>>>       added kernel doc for no_parallel_bringup and made do_parallel_bringup
>>>>       __ro_after_init.
>>>> v10: Fixed suspend/resume not working with parallel smpboot.
>>>>        rebased and retested to 6.2.
>>>>        fixed checkpatch errors.
>>>> v11: Added patches from Brian Gerst to remove the global variables initial_gs,
>>>>        initial_stack, and early_gdt_descr from the 64-bit boot code
>>>>        (https://lore.kernel.org/all/20230222221301.245890-1-brgerst@gmail.com/).
>>>> v12: Fixed compilation errors, acquire tr_lock for every stack setup in
>>>>        trampoline_64.S.
>>>>        Rearranged commits for a cleaner git history.
>>>>
>>>> Brian Gerst (3):
>>>>     x86/smpboot: Remove initial_stack on 64-bit
>>>>     x86/smpboot: Remove early_gdt_descr on 64-bit
>>>>     x86/smpboot: Remove initial_gs
>>>>
>>>> David Woodhouse (8):
>>>>     x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
>>>>     cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
>>>>     cpu/hotplug: Add dynamic parallel bringup states before
>>>>       CPUHP_BRINGUP_CPU
>>>>     x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>>>>     x86/smpboot: Split up native_cpu_up into separate phases and document
>>>>       them
>>>>     x86/smpboot: Support parallel startup of secondary CPUs
>>>>     x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>>>>     x86/smpboot: Serialize topology updates for secondary bringup
>>>>
>>>>    .../admin-guide/kernel-parameters.txt         |   3 +
>>>>    arch/x86/include/asm/processor.h              |   6 +-
>>>>    arch/x86/include/asm/realmode.h               |   4 +-
>>>>    arch/x86/include/asm/smp.h                    |  15 +-
>>>>    arch/x86/include/asm/topology.h               |   2 -
>>>>    arch/x86/kernel/acpi/sleep.c                  |  15 +-
>>>>    arch/x86/kernel/apic/apic.c                   |   2 +-
>>>>    arch/x86/kernel/apic/x2apic_cluster.c         | 126 ++++---
>>>>    arch/x86/kernel/asm-offsets.c                 |   1 +
>>>>    arch/x86/kernel/cpu/common.c                  |   6 +-
>>>>    arch/x86/kernel/head_64.S                     | 129 +++++--
>>>>    arch/x86/kernel/smpboot.c                     | 350 +++++++++++++-----
>>>>    arch/x86/realmode/init.c                      |   3 +
>>>>    arch/x86/realmode/rm/trampoline_64.S          |  27 +-
>>>>    arch/x86/xen/smp_pv.c                         |   4 +-
>>>>    arch/x86/xen/xen-head.S                       |   2 +-
>>>>    include/linux/cpuhotplug.h                    |   2 +
>>>>    include/linux/smpboot.h                       |   7 +
>>>>    kernel/cpu.c                                  |  31 +-
>>>>    kernel/smpboot.h                              |   2 -
>>>>    20 files changed, 537 insertions(+), 200 deletions(-)
>>>
>>> With `CONFIG_FORCE_NR_CPUS=y` this results in:
>>>
>>> ```
>>> ld: vmlinux.o: in function `secondary_startup_64_no_verify':
>>> (.head.text+0x10c): undefined reference to `nr_cpu_ids'
>>> ```
>>>
>>> That's because in `arch/x86/kernel/head_64.S` `secondary_startup_64_no_verify()` refers to `nr_cpu_ids` under `#ifdef CONFIG_SMP`, but this symbol is available under the following conditions:
>>>
>>> ```
>>> 38 #if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
>>> 39 #define nr_cpu_ids ((unsigned int)NR_CPUS)
>>> 40 #else
>>> 41 extern unsigned int nr_cpu_ids;
>>> 42 #endif
>>>
>>> 1090 #if (NR_CPUS > 1) && !defined(CONFIG_FORCE_NR_CPUS)
>>> 1091 /* Setup number of possible processor ids */
>>> 1092 unsigned int nr_cpu_ids __read_mostly = NR_CPUS;
>>> 1093 EXPORT_SYMBOL(nr_cpu_ids);
>>> 1094 #endif
>>> ```
>>>
>>> So having `CONFIG_SMP=y` and, for instance, `CONFIG_NR_CPUS=320`, it is possible to compile out `EXPORT_SYMBOL(nr_cpu_ids);` if `CONFIG_FORCE_NR_CPUS=y` is set.
>>>
>>
>> I think something like below diff should work in all scenarios?
> 
> I'd've changed the asm side to use the constant limit.

Yup, just needed the morning coffee :) Had sent the proper fix in 
https://lore.kernel.org/all/5e8ad90a-1dc6-95c2-e020-5e95da6f9eda@bytedance.com/#t

I guess the diff is still small over v12 (including the cosmetic 
changes) to send out a new version so soon, probably better to wait a 
couple of days incase something else comes up as well?

Thanks,
Usama
