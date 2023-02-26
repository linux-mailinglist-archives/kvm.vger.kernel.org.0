Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29056A3433
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 21:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjBZU7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 15:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBZU7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 15:59:48 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD43E38D
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 12:59:20 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id e37so1792695wri.10
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 12:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LKLwBPFLhwlO9HAOrLQrwtZBADgc5YAxyu66Xz5w96Q=;
        b=a8iyvPBF+jC44yA1E18ldnFQ45OhLookoHXkl4+VfO+FZWarQFq+FCnVnoMGvnaa69
         KPH++0f1sKAcMWPw1UypoaiD3no5mfdpr0F+R43p9510FaydEyLhrbApxHIZwwTVCV8E
         ySnhiN49eo4MxlnQ3HmjAhb9C/PKrlLi2dwkY7kMkvCJ8qKe1hqDy/MPw4XQbjKVZigI
         t8AssDX88yIdhhBpTqS7+sRdF9aS+HZoOp8SSUSD4CKlh4y7nPDHyPD9YbxdC6boJwKT
         yAK2eQesQVBuwtW+ex8qxqQ374I9jp5SBbrDVk0t8Zm+s3sdi6nt39Zh1StfD8W7BU8g
         14OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LKLwBPFLhwlO9HAOrLQrwtZBADgc5YAxyu66Xz5w96Q=;
        b=E899UlRxRWTUwpncuWGB2qKf/HDmImTVcPZf1FKKLs+sC44924v4DABC4L4gJBpaJp
         vPjZkTdhclXBfLgSZ7KXnGVZobK4LCtJS14BveOSi/XLNzdYpSHF22sOB8IN8R/v0Duv
         Jh8WEBqp8YZluVs2ei3EKAAvPofNO5MAlKe+InnBwoWxSapICNz0HFBRu9260boAYMHH
         qgc0L6t8Z2CkrtFqFURSckMN42EELQSwD5Ue4z8tyRKTs+cxjvfGnSsBZH/KjCb/V2rO
         pPuAUrT4TpVWDR9m4L82Itvnzpq/7oD347fZkUtW5q5mTCUMUnoxYog8BExls84lk+D/
         Aw2A==
X-Gm-Message-State: AO0yUKXzckedMLjVjtk/fTpiAQz5gdoCHYuJw9RZJQDi79iVbY8X6L4R
        9ybRzTcVg5uwZPRyg0I76J+IoA==
X-Google-Smtp-Source: AK7set+nV2f+k6MLTCnVZHcHto0dT3XrEBI2eiwbMb6R0hiIQcfRiEbJYgC89fUV4UgoDD8vkX8hjQ==
X-Received: by 2002:adf:dc09:0:b0:2ca:f86a:9643 with SMTP id t9-20020adfdc09000000b002caf86a9643mr1723437wri.0.1677445158977;
        Sun, 26 Feb 2023 12:59:18 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:6caa:9121:bec9:a2a9? ([2a02:6b6a:b566:0:6caa:9121:bec9:a2a9])
        by smtp.gmail.com with ESMTPSA id t3-20020a5d6903000000b002c56af32e8csm5279871wru.35.2023.02.26.12.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 12:59:18 -0800 (PST)
Message-ID: <819d8fa2-b73e-e32f-5442-452aa2c0d752@bytedance.com>
Date:   Sun, 26 Feb 2023 20:59:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v12 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
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
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <5650744.DvuYhMxLoT@natalenko.name>
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



On 26/02/2023 18:31, Oleksandr Natalenko wrote:
> Hello.
> 
> On neděle 26. února 2023 12:07:51 CET Usama Arif wrote:
>> The main code change over v11 is the build error fix by Brian Gerst and
>> acquiring tr_lock in trampoline_64.S whenever the stack is setup.
>>
>> The git history is also rewritten to move the commits that removed
>> initial_stack, early_gdt_descr and initial_gs earlier in the patchset.
>>
>> Thanks,
>> Usama
>>
>> Changes across versions:
>> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
>> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>>      in preparation for more parallelisation.
>> v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
>>      avoid scribbling on initial_gs in common_cpu_up(), and to allow all
>>      24 bits of the physical X2APIC ID to be used. That patch still needs
>>      a Signed-off-by from its original author, who once claimed not to
>>      remember writing it at all. But now we've fixed it, hopefully he'll
>>      admit it now :)
>> v5: rebase to v6.1 and remeasure performance, disable parallel bringup
>>      for AMD CPUs.
>> v6: rebase to v6.2-rc6, disabled parallel boot on amd as a cpu bug and
>>      reused timer calibration for secondary CPUs.
>> v7: [David Woodhouse] iterate over all possible CPUs to find any existing
>>      cluster mask in alloc_clustermask. (patch 1/9)
>>      Keep parallel AMD support enabled in AMD, using APIC ID in CPUID leaf
>>      0x0B (for x2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.
>>      Included sanity checks for APIC id from 0x0B. (patch 6/9)
>>      Removed patch for reusing timer calibration for secondary CPUs.
>>      commit message and code improvements.
>> v8: Fix CPU0 hotplug by setting up the initial_gs, initial_stack and
>>      early_gdt_descr.
>>      Drop trampoline lock and bail if APIC ID not found in find_cpunr.
>>      Code comments improved and debug prints added.
>> v9: Drop patch to avoid repeated saves of MTRR at boot time.
>>      rebased and retested at v6.2-rc8.
>>      added kernel doc for no_parallel_bringup and made do_parallel_bringup
>>      __ro_after_init.
>> v10: Fixed suspend/resume not working with parallel smpboot.
>>       rebased and retested to 6.2.
>>       fixed checkpatch errors.
>> v11: Added patches from Brian Gerst to remove the global variables initial_gs,
>>       initial_stack, and early_gdt_descr from the 64-bit boot code
>>       (https://lore.kernel.org/all/20230222221301.245890-1-brgerst@gmail.com/).
>> v12: Fixed compilation errors, acquire tr_lock for every stack setup in
>>       trampoline_64.S.
>>       Rearranged commits for a cleaner git history.
>>
>> Brian Gerst (3):
>>    x86/smpboot: Remove initial_stack on 64-bit
>>    x86/smpboot: Remove early_gdt_descr on 64-bit
>>    x86/smpboot: Remove initial_gs
>>
>> David Woodhouse (8):
>>    x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
>>    cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
>>    cpu/hotplug: Add dynamic parallel bringup states before
>>      CPUHP_BRINGUP_CPU
>>    x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>>    x86/smpboot: Split up native_cpu_up into separate phases and document
>>      them
>>    x86/smpboot: Support parallel startup of secondary CPUs
>>    x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>>    x86/smpboot: Serialize topology updates for secondary bringup
>>
>>   .../admin-guide/kernel-parameters.txt         |   3 +
>>   arch/x86/include/asm/processor.h              |   6 +-
>>   arch/x86/include/asm/realmode.h               |   4 +-
>>   arch/x86/include/asm/smp.h                    |  15 +-
>>   arch/x86/include/asm/topology.h               |   2 -
>>   arch/x86/kernel/acpi/sleep.c                  |  15 +-
>>   arch/x86/kernel/apic/apic.c                   |   2 +-
>>   arch/x86/kernel/apic/x2apic_cluster.c         | 126 ++++---
>>   arch/x86/kernel/asm-offsets.c                 |   1 +
>>   arch/x86/kernel/cpu/common.c                  |   6 +-
>>   arch/x86/kernel/head_64.S                     | 129 +++++--
>>   arch/x86/kernel/smpboot.c                     | 350 +++++++++++++-----
>>   arch/x86/realmode/init.c                      |   3 +
>>   arch/x86/realmode/rm/trampoline_64.S          |  27 +-
>>   arch/x86/xen/smp_pv.c                         |   4 +-
>>   arch/x86/xen/xen-head.S                       |   2 +-
>>   include/linux/cpuhotplug.h                    |   2 +
>>   include/linux/smpboot.h                       |   7 +
>>   kernel/cpu.c                                  |  31 +-
>>   kernel/smpboot.h                              |   2 -
>>   20 files changed, 537 insertions(+), 200 deletions(-)
> 
> With `CONFIG_FORCE_NR_CPUS=y` this results in:
> 
> ```
> ld: vmlinux.o: in function `secondary_startup_64_no_verify':
> (.head.text+0x10c): undefined reference to `nr_cpu_ids'
> ```
> 
> That's because in `arch/x86/kernel/head_64.S` `secondary_startup_64_no_verify()` refers to `nr_cpu_ids` under `#ifdef CONFIG_SMP`, but this symbol is available under the following conditions:
> 
> ```
> 38 #if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
> 39 #define nr_cpu_ids ((unsigned int)NR_CPUS)
> 40 #else
> 41 extern unsigned int nr_cpu_ids;
> 42 #endif
> 
> 1090 #if (NR_CPUS > 1) && !defined(CONFIG_FORCE_NR_CPUS)
> 1091 /* Setup number of possible processor ids */
> 1092 unsigned int nr_cpu_ids __read_mostly = NR_CPUS;
> 1093 EXPORT_SYMBOL(nr_cpu_ids);
> 1094 #endif
> ```
> 
> So having `CONFIG_SMP=y` and, for instance, `CONFIG_NR_CPUS=320`, it is possible to compile out `EXPORT_SYMBOL(nr_cpu_ids);` if `CONFIG_FORCE_NR_CPUS=y` is set.
> 

I think something like below diff should work in all scenarios?

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c2aa0aa26b45..e3727dab9cab 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -35,7 +35,7 @@ typedef struct cpumask { DECLARE_BITMAP(bits, 
NR_CPUS); } cpumask_t;
   */
  #define cpumask_pr_args(maskp)         nr_cpu_ids, cpumask_bits(maskp)

-#if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
+#if ((NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)) && 
!defined(CONFIG_SMP)
  #define nr_cpu_ids ((unsigned int)NR_CPUS)
  #else
  extern unsigned int nr_cpu_ids;
@@ -43,7 +43,7 @@ extern unsigned int nr_cpu_ids;

  static inline void set_nr_cpu_ids(unsigned int nr)
  {
-#if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
+#if ((NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)) && 
!defined(CONFIG_SMP)
         WARN_ON(nr != nr_cpu_ids);
  #else
         nr_cpu_ids = nr;
diff --git a/kernel/smp.c b/kernel/smp.c
index 06a413987a14..a051b16d4a24 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -1087,11 +1087,9 @@ static int __init maxcpus(char *str)

  early_param("maxcpus", maxcpus);

-#if (NR_CPUS > 1) && !defined(CONFIG_FORCE_NR_CPUS)
  /* Setup number of possible processor ids */
  unsigned int nr_cpu_ids __read_mostly = NR_CPUS;
  EXPORT_SYMBOL(nr_cpu_ids);
-#endif

  /* An arch may set nr_cpu_ids earlier if needed, so this would be 
redundant */
  void __init setup_nr_cpu_ids(void)
