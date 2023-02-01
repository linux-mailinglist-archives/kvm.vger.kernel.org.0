Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB14E68687E
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 15:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjBAOkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 09:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjBAOkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 09:40:14 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB6AC644
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 06:40:12 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id q8so12832309wmo.5
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 06:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ntqD2+JXvdh0eVlKapCiL5KQqPWBOr/MM6KuL8nVXn8=;
        b=uQLHiaQ7A/DFeUxgi+JDnmQc11d51gg6i8PiotXoZFfqWNXsZWSTp1Nm6gzHhuoaQB
         SaQ3xOzci4arbzweFCCwzHblApQbSZZoIsFfx1/CbvtYtKAXxUwkkr15KdoYeKHT6+gk
         q54ZXGalW4J05i/Nj75nQWgwGcDYgjSQy/qJ9cSJ+/huMkYfWgHH3P1w/jyxtovcTZtD
         NIvr4dp+Gwk98ruC1EZm7VmgUHqleaQtsZHkJV2oBBfZSzq4Ie6/e2Wq++6N3f4o040c
         TnrTs3fDscpAgM7mj03EJmM1yUX3Op11satjIue8hnY6h9xg7O1oSLT03CRfsRw0vXK8
         6zLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ntqD2+JXvdh0eVlKapCiL5KQqPWBOr/MM6KuL8nVXn8=;
        b=QpqJH2ZXwnLz3FCQgRZIWnMKU/v9u0QUikyw6yO9P86vK9YeKPZUeq+frXojdNBuMF
         Aqn7bVqDf4aiha3DTrGQFWRl7zifGKpGYP20ORXqBEB3zXN3iJmDPxKRY8c7i3Jlmad2
         22EnAvMnWv4u1DFyrMEVB+X3RBP1+m8lxwa0UNPv15FU4JdhU+DaNR/n6NnNPhub/M3S
         5R4/dRF3tF4MJpFIOMTL3WdOzt/fPqcIdVaqyhTpLVER6NYMQjJg/Jwyv4Qb04Z9Qt85
         MBJ4Ivp89GbkYic+pHT+smrw+LMEtXMUE19LOMPoisM0gVKaOjTXEsaUsqNb/BwXdopl
         GBYQ==
X-Gm-Message-State: AO0yUKWdI/Jq7BNdO1TEqFYb/XcLARKqsazWJw8g5iEExAQmFWhHH8ag
        nXwHM3n6E4vy5FzcZQq5Q2NsoQ==
X-Google-Smtp-Source: AK7set8CH2pFHo/EOLHu4jCReTo9hfE+OIR2c8OVbzsL2VHrYohdwGOPlboTAjqO6SFBSnZ8xPZfVg==
X-Received: by 2002:a05:600c:4f93:b0:3dc:5823:d6c0 with SMTP id n19-20020a05600c4f9300b003dc5823d6c0mr2509942wmq.6.1675262411008;
        Wed, 01 Feb 2023 06:40:11 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:7611:c340:3d8d:d46c? ([2a02:6b6a:b566:0:7611:c340:3d8d:d46c])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c3b8900b003d9aa76dc6asm2205329wms.0.2023.02.01.06.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 06:40:10 -0800 (PST)
Message-ID: <ff876008-b642-4dbc-aa41-1639905e08b6@bytedance.com>
Date:   Wed, 1 Feb 2023 14:40:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Fam Zheng <fam.zheng@bytedance.com>,
        Punit Agrawal <punit.agrawal@bytedance.com>,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20220201205328.123066-1-dwmw2@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <20220201205328.123066-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/02/2022 20:53, David Woodhouse wrote:
> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
> them shaves about 80% off the AP bringup time on a 96-thread 2-socket
> Skylake box (EC2 c5.metal) — from about 500ms to 100ms.
> 
> There are more wins to be had with further parallelisation, but this is
> the simple part.
> 

Hi,

We are interested in reducing the boot time of servers (with kexec), and 
smpboot takes up a significant amount of time while booting. When 
testing the patch series (rebased to v6.1) on a server with 128 CPUs 
split across 2 NUMA nodes, it brought down the smpboot time from ~700ms 
to 100ms. Adding another cpuhp state for do_wait_cpu_initialized to make 
sure cpu_init is reached (as done in v1 of the series + using the 
cpu_finishup_mask) brought it down further to ~30ms.

I just wanted to check what was needed to progress the patch series 
further for review? There weren't any comments on v4 of the patch so I 
couldn't figure out what more is needed. I think its quite useful to 
have this working so would be really glad help in anything needed to 
restart the review.

Thanks!
Usama



> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>      in preparation for more parallelisation.
> v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
>      avoid scribbling on initial_gs in common_cpu_up(), and to allow all
>      24 bits of the physical X2APIC ID to be used. That patch still needs
>      a Signed-off-by from its original author, who once claimed not to
>      remember writing it at all. But now we've fixed it, hopefully he'll
>      admit it now :)
> 
> David Woodhouse (8):
>        x86/apic/x2apic: Fix parallel handling of cluster_mask
>        cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
>        cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
>        x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>        x86/smpboot: Split up native_cpu_up into separate phases and document them
>        x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>        x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
>        x86/smpboot: Serialize topology updates for secondary bringup
> 
> Thomas Gleixner (1):
>        x86/smpboot: Support parallel startup of secondary CPUs
> 
> [dwoodhou@i7 linux-2.6]$ git diff --stat  v5.17-rc2..share/parallel-5.17-part1
>   arch/x86/include/asm/realmode.h       |   3 +
>   arch/x86/include/asm/smp.h            |  13 +-
>   arch/x86/include/asm/topology.h       |   2 -
>   arch/x86/kernel/acpi/sleep.c          |   1 +
>   arch/x86/kernel/apic/apic.c           |   2 +-
>   arch/x86/kernel/apic/x2apic_cluster.c | 108 ++++++-----
>   arch/x86/kernel/cpu/common.c          |   6 +-
>   arch/x86/kernel/cpu/mtrr/mtrr.c       |   9 +
>   arch/x86/kernel/head_64.S             |  73 ++++++++
>   arch/x86/kernel/smpboot.c             | 325 ++++++++++++++++++++++++----------
>   arch/x86/realmode/init.c              |   3 +
>   arch/x86/realmode/rm/trampoline_64.S  |  14 ++
>   arch/x86/xen/smp_pv.c                 |   4 +-
>   include/linux/cpuhotplug.h            |   2 +
>   include/linux/smpboot.h               |   7 +
>   kernel/cpu.c                          |  27 ++-
>   kernel/smpboot.c                      |   2 +-
>   kernel/smpboot.h                      |   2 -
>   18 files changed, 442 insertions(+), 161 deletions(-)
> 
> 
> 
> 
