Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7408769041C
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 10:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjBIJtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 04:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjBIJtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 04:49:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B16367C9
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 01:49:07 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id j23so1210899wra.0
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 01:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CTEOGPQnS0TIFLEvZd/nSW2p+ZjRxHWqIwAsKqfTz80=;
        b=V0SzVGtWKLJJvy1I/BjOPA575rNIE4m6Km+ONa3qI2SCaak0FMA6FvxgHXMklDM7wO
         pF6iG6q/zKW36VjoPOFaKba5yGdnzjSV+pwQBIm37wAnxVkbM+JekJCfSf1iVLstv1dQ
         Y4lRPVVsF1E4AjIdZi0qAATZCol4XpBW0Rt1SRp1dx/Z0EUjt4d2Th6whIcvM2DIhdj6
         gmtXzGOYRe0f2tAi+6cHRqwmhfOXcSUd4oiKTIj5FQpGu38Ed7qLLor7iqqBZVcQ9HF2
         6qW4ssTi8i2ixrcBB9hCZwjd/sOWDsCbK4wkZWLm0/mVrktu6uIatpNKzY56PKJ4jABH
         1s4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CTEOGPQnS0TIFLEvZd/nSW2p+ZjRxHWqIwAsKqfTz80=;
        b=HHYi+G7hjGQmqzCFX/q9AFZKkVODUjunyCFySzh9sDYErwzRoolfwd6/HG2sOxH9p1
         9nh9KbjPJ/lOiV4h53g2kdgX+rOKEJUk73IKfJiPK7OJbpANOHLC7lOLXqNKNt7jvWaZ
         ylX0E3HPcb8pUpAFn9W9VZdOvMYUaFaAlrgqgvu+uClFmA+cboC2nAsMnpf1aAv24SsF
         tgG+tni9IJy9V1Yh+rOGmH0EQHUSnZ8gYcdOuYNXwxd2gyZPjgYOPFJXc0aZIkjQ1dPV
         HjM4JmhaBP14cB2LdluFkhJiDEwzTDUb0Qa8/A34ih1ccleEbadBc0w78MQ4OOeAW0lx
         78/Q==
X-Gm-Message-State: AO0yUKVs2TuWjDBEZdqRXkYF+XWHxsVqSuyBunsidxhp+TbwE3ruee4f
        JsucTPra6/OsLFNWpuyu4ckh/A==
X-Google-Smtp-Source: AK7set/zlo+mWdVn4nhTrjKjNcfLDl/mIAyWU45AYYryQiWv4XyrxL+O2BeGHVWc87DSQWF/4zhCVg==
X-Received: by 2002:a5d:510a:0:b0:2c4:682:5639 with SMTP id s10-20020a5d510a000000b002c406825639mr4191498wrt.1.1675936146028;
        Thu, 09 Feb 2023 01:49:06 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:8009:2525:9580:8db2? ([2a02:6b6a:b566:0:8009:2525:9580:8db2])
        by smtp.gmail.com with ESMTPSA id m3-20020adfe0c3000000b002c4084d3472sm809755wri.58.2023.02.09.01.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 01:49:05 -0800 (PST)
Message-ID: <8e2f03e2-9517-aeb4-df60-b36ef3ff3a75@bytedance.com>
Date:   Thu, 9 Feb 2023 09:49:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v7 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     paulmck@kernel.org, dwmw2@infradead.org, tglx@linutronix.de
Cc:     kim.phillips@amd.com, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
 <20230209035300.GA3216394@paulmck-ThinkPad-P17-Gen-1>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <20230209035300.GA3216394@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/02/2023 03:53, Paul E. McKenney wrote:
> On Tue, Feb 07, 2023 at 11:04:27PM +0000, Usama Arif wrote:
>> Tested on v7, doing INIT/SIPI/SIPI in parallel brings down the time for
>> smpboot from ~700ms to 100ms (85% improvement) on a server with 128 CPUs
>> split across 2 NUMA nodes.
>>
>> The major change over v6 is keeping parallel smp support enabled in AMD.
>> APIC ID for parallel CPU bringup is now obtained from CPUID leaf 0x0B
>> (for x2APIC mode) otherwise CPUID leaf 0x1 (8 bits).
>>
>> The patch for reusing timer calibration for secondary CPUs is also removed
>> from the series as its not part of parallel smp bringup and needs to be
>> further thought about.
> 
> Running rcutorture on this got me the following NULL pointer dereference
> on scenario TREE01:
> 
> ------------------------------------------------------------------------
> 
> [   34.662066] smpboot: CPU 0 is now offline
> [   34.674075] rcu: NOCB: Cannot CB-offload offline CPU 25
> [   35.038003] rcu: De-offloading 5
> [   35.112997] rcu: Offloading 12
> [   35.716011] smpboot: Booting Node 0 Processor 0 APIC 0x0
> [   35.762685] BUG: kernel NULL pointer dereference, address: 0000000000000001
> [   35.764278] #PF: supervisor instruction fetch in kernel mode
> [   35.765530] #PF: error_code(0x0010) - not-present page
> [   35.766700] PGD 0 P4D 0
> [   35.767278] Oops: 0010 [#1] PREEMPT SMP PTI
> [   35.768223] CPU: 36 PID: 0 Comm: swapper/36 Not tainted 6.2.0-rc1-00206-g18a37610b632-dirty #3563
> [   35.770201] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> 
> ------------------------------------------------------------------------
> 
> Given an x86 system with KVM and qemu, this can be reproduced by running
> the following from the top-level directory in the Linux-kernel source
> tree:
> 
> 	tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --configs "TREE01 TINY01" --trust-make
> 
> Out of 15 runs, 14 blew up just after the first attempt to bring CPU
> 0 back online.  The 15th run blew up just after the second attempt to
> bring CPU 0 online, the first attempt having succeeded.
> 
> My guess is that the CONFIG_BOOTPARAM_HOTPLUG_CPU0=y Kconfig option is
> tickling this bug.  This Kconfig option has been added to the TREE01
> scenario in the -rcu tree's "dev" branch, which might mean that this test
> would pass on mainline.  But CONFIG_BOOTPARAM_HOTPLUG_CPU0=y is not new,
> only rcutorture's testing of it.
> 
> Thoughts?
> 
> 							Thanx, Paul

It looks like its because of the initial_gs, initial_stack and
early_gdt_descr not being setup properly for CPU0 hotplug, i.e. 
init_cpu_data isnt called in cpu0 hotplug case.

Its easy to test, just by doing
echo 0 > /sys/devices/system/cpu/cpu0/online;
echo 1 > /sys/devices/system/cpu/cpu0/online;

As a quick check, if we do something like below (probably there is a 
much better place to set these..), the above hotplug commands will work.

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3ec5182d9698..184135c47ee5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1080,6 +1080,7 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long 
start_ip, int apicid,
                                           wakeup_cpu0_nmi, 0, "wake_cpu0");

         if (!boot_error) {
+               initial_gs = per_cpu_offset(cpu);
                 enable_start_cpu0 = 1;
                 *cpu0_nmi_registered = 1;
                 id = apic->dest_mode_logical ? cpu0_logical_apicid : 
apicid;
@@ -1188,10 +1189,14 @@ static int do_boot_cpu(int apicid, int cpu, 
struct task_struct *idle,
                 boot_error = apic->wakeup_secondary_cpu_64(apicid, 
start_ip);
         else if (apic->wakeup_secondary_cpu)
                 boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
-       else
+       else {
+               if(!cpu) {
+                       early_gdt_descr.address = (unsigned 
long)get_cpu_gdt_rw(cpu);
+                       initial_stack  = idle->thread.sp;
+               }
                 boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
                                                      cpu0_nmi_registered);
-
+       }
         return boot_error;
  }



