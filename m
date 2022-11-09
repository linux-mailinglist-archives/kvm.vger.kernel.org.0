Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3768862339B
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 20:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiKITjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 14:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKITjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 14:39:01 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513E918B2A
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 11:38:58 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id g12so27422259wrs.10
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 11:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lh0nRP77OHPBfFy0WBZz6D0tz7ScfvXWOpoB+unsGmE=;
        b=XT5OpEcAC2vJgaagUXubYidHz4EnH3vTp6IDL5PXT/hagaNDKVWsad3/AIWLbzAo4O
         DOZvmdDpzRdb9mDIAOX/leK0v0Loqn6EjUleKllNnVU9SNVmKhZyeuk6dooCovbH96RT
         CzDzEJhC0rrOhNDVbegsmz4PKxwEnIDkwN6yVGZyS7iq+Je/iYCbGsTpjhytvVkb73OW
         xq9jPQJvhurPCa8tm9dYvd9LyvD5kdRBULt7I/gfW4r6nVKorAQ7unv9pQEHXiHBXgWS
         WC2JdSp4cRic5ooJPTufmSc7PpqeRU29ZluZPNdQw9wBCq6qfQk2sq1Nv9NPZ74qvZmI
         zDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lh0nRP77OHPBfFy0WBZz6D0tz7ScfvXWOpoB+unsGmE=;
        b=DRjYnt0csq+bX8s0Xw174+x9i340NPqWWU90TZWdd6YnwO0W95xVir+Oj4simRu8Dk
         NalNC9TwjcLliH4fQNIpM3ZgATxC/FuWfZmpTypqx8T4ptVIr5p9rwkg6nARWUmfj5Qg
         /2vtBetbrqwTbFgZQchMXVWP+aDsKux/wvjcAU5+fFhfDJXSo9yyEGYjPss4Rb6u5iZZ
         2ewANqeEWiSv7DQaB0p1M0H5AcL1//MjYaUKR01cfoNCvfI1+19Py02LmH84Y2HxB4bF
         sSRxvijiYTAM3EBBEbtsUTofulT+o4XEpHMBTkMWiXxks4AjmQIXT1YCgZpSgP5b0FHg
         Ai2g==
X-Gm-Message-State: ACrzQf2wy2q9+a+gkp82X7fh8XFWZjE50byTi4H0FeKo8yMry3NLZ1bb
        kx71hsw3edYS5Ks9J54tSEJd6Q==
X-Google-Smtp-Source: AMsMyM5Vv6j8+WGVmZnNA7DjnX36A/WyWoPzubWciasWpvIGo6jVmLL7077josfOvY5BLIa/A7nRRQ==
X-Received: by 2002:a5d:6088:0:b0:236:bd20:2d07 with SMTP id w8-20020a5d6088000000b00236bd202d07mr36906705wrt.165.1668022736766;
        Wed, 09 Nov 2022 11:38:56 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4d7:0:bc6a:614e:fac7:5a4c? ([2a02:6b6a:b4d7:0:bc6a:614e:fac7:5a4c])
        by smtp.gmail.com with ESMTPSA id p33-20020a05600c1da100b003c71358a42dsm3352830wms.18.2022.11.09.11.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 11:38:55 -0800 (PST)
Message-ID: <d39f639b-cd5c-15f4-e6cb-5e2525992acf@bytedance.com>
Date:   Wed, 9 Nov 2022 19:38:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [v2 0/6] KVM: arm64: implement vcpu_is_preempted check
Content-Language: en-US
To:     Punit Agrawal <punit.agrawal@bytedance.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, fam.zheng@bytedance.com, liangma@liangbit.com
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <87wn861v3x.fsf@stealth>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <87wn861v3x.fsf@stealth>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/11/2022 18:24, Punit Agrawal wrote:
> Hi Usama,
> 
> Usama Arif <usama.arif@bytedance.com> writes:
> 
>> This patchset adds support for vcpu_is_preempted in arm64, which allows the guest
>> to check if a vcpu was scheduled out, which is useful to know incase it was
>> holding a lock. vcpu_is_preempted can be used to improve
>> performance in locking (see owner_on_cpu usage in mutex_spin_on_owner,
>> mutex_can_spin_on_owner, rtmutex_spin_on_owner and osq_lock) and scheduling
>> (see available_idle_cpu which is used in several places in kernel/sched/fair.c
>> for e.g. in wake_affine to determine which CPU can run soonest):
>>
>> This patchset shows improvement on overcommitted hosts (vCPUs > pCPUS), as waiting
>> for preempted vCPUs reduces performance.
>>
>> This patchset is inspired from the para_steal_clock implementation and from the
>> work originally done by Zengruan Ye:
>> https://lore.kernel.org/linux-arm-kernel/20191226135833.1052-1-yezengruan@huawei.com/.
>>
>> All the results in the below experiments are done on an aws r6g.metal instance
>> which has 64 pCPUs.
>>
>> The following table shows the index results of UnixBench running on a 128 vCPU VM
>> with (6.0.0+vcpu_is_preempted) and without (6.0.0 base) the patchset.
>> TestName                                6.0.0 base  6.0.0+vcpu_is_preempted    % improvement for vcpu_is_preempted
>> Dhrystone 2 using register variables    187761      191274.7                   1.871368389
>> Double-Precision Whetstone              96743.6     98414.4                    1.727039308
>> Execl Throughput                        689.3       10426                      1412.548963
>> File Copy 1024 bufsize 2000 maxblocks   549.5       3165                       475.978162
>> File Copy 256 bufsize 500 maxblocks     400.7       2084.7                     420.2645371
>> File Copy 4096 bufsize 8000 maxblocks   894.3       5003.2                     459.4543218
>> Pipe Throughput                         76819.5     78601.5                    2.319723508
>> Pipe-based Context Switching            3444.8      13414.5                    289.4130283
>> Process Creation                        301.1       293.4                      -2.557289937
>> Shell Scripts (1 concurrent)            1248.1      28300.6                    2167.494592
>> Shell Scripts (8 concurrent)            781.2       26222.3                    3256.669227
>> System Call Overhead                    3426        3729.4                     8.855808523
>>
>> System Benchmarks Index Score           3053        11534                      277.7923354
>>
>> This shows a 277% overall improvement using these patches.
>>
>> The biggest improvement is in the shell scripts benchmark, which forks a lot of processes.
>> This acquires rwsem lock where a large chunk of time is spent in base 6.0.0 kernel.
>> This can be seen from one of the callstack of the perf output of the shell
>> scripts benchmark on 6.0.0 base (pseudo NMI enabled for perf numbers below):
>> - 33.79% el0_svc
>>     - 33.43% do_el0_svc
>>        - 33.43% el0_svc_common.constprop.3
>>           - 33.30% invoke_syscall
>>              - 17.27% __arm64_sys_clone
>>                 - 17.27% __do_sys_clone
>>                    - 17.26% kernel_clone
>>                       - 16.73% copy_process
>>                          - 11.91% dup_mm
>>                             - 11.82% dup_mmap
>>                                - 9.15% down_write
>>                                   - 8.87% rwsem_down_write_slowpath
>>                                      - 8.48% osq_lock
>>
>> Just under 50% of the total time in the shell script benchmarks ends up being
>> spent in osq_lock in the base 6.0.0 kernel:
>>    Children      Self  Command   Shared Object        Symbol
>>     17.19%    10.71%  sh      [kernel.kallsyms]  [k] osq_lock
>>      6.17%     4.04%  sort    [kernel.kallsyms]  [k] osq_lock
>>      4.20%     2.60%  multi.  [kernel.kallsyms]  [k] osq_lock
>>      3.77%     2.47%  grep    [kernel.kallsyms]  [k] osq_lock
>>      3.50%     2.24%  expr    [kernel.kallsyms]  [k] osq_lock
>>      3.41%     2.23%  od      [kernel.kallsyms]  [k] osq_lock
>>      3.36%     2.15%  rm      [kernel.kallsyms]  [k] osq_lock
>>      3.28%     2.12%  tee     [kernel.kallsyms]  [k] osq_lock
>>      3.16%     2.02%  wc      [kernel.kallsyms]  [k] osq_lock
>>      0.21%     0.13%  looper  [kernel.kallsyms]  [k] osq_lock
>>      0.01%     0.00%  Run     [kernel.kallsyms]  [k] osq_lock
>>
>> and this comes down to less than 1% total with 6.0.0+vcpu_is_preempted kernel:
>>    Children      Self  Command   Shared Object        Symbol
>>       0.26%     0.21%  sh      [kernel.kallsyms]  [k] osq_lock
>>       0.10%     0.08%  multi.  [kernel.kallsyms]  [k] osq_lock
>>       0.04%     0.04%  sort    [kernel.kallsyms]  [k] osq_lock
>>       0.02%     0.01%  grep    [kernel.kallsyms]  [k] osq_lock
>>       0.02%     0.02%  od      [kernel.kallsyms]  [k] osq_lock
>>       0.01%     0.01%  tee     [kernel.kallsyms]  [k] osq_lock
>>       0.01%     0.00%  expr    [kernel.kallsyms]  [k] osq_lock
>>       0.01%     0.01%  looper  [kernel.kallsyms]  [k] osq_lock
>>       0.00%     0.00%  wc      [kernel.kallsyms]  [k] osq_lock
>>       0.00%     0.00%  rm      [kernel.kallsyms]  [k] osq_lock
>>
>> To make sure, there is no change in performance when vCPUs < pCPUs, UnixBench
>> was run on a 32 CPU VM. The kernel with vcpu_is_preempted implemented
>> performed 0.9% better overall than base kernel, and the individual benchmarks
>> were within +/-2% improvement over 6.0.0 base.
>> Hence the patches have no negative affect when vCPUs < pCPUs.
>>
>>
>> The other method discussed in https://lore.kernel.org/linux-arm-kernel/20191226135833.1052-1-yezengruan@huawei.com/
>> was pv conditional yield by Marc Zyngier and Will Deacon to reduce vCPU reschedule
>> if the vCPU will exit immediately.
>> (https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy).
>> The patches were ported to 6.0.0 kernel and tested with UnixBench with a 128 vCPU VM:
>>
>> TestName                                6.0.0 base  6.0.0+pvcy      % improvement for pvcy
>> Dhrystone 2 using register variables    187761      183128          -2.467498575
>> Double-Precision Whetstone              96743.6     96645           -0.101918887
>> Execl Throughput                        689.3       1019.8          47.9471928
>> File Copy 1024 bufsize 2000 maxblocks   549.5       2029.7          269.3721565
>> File Copy 256 bufsize 500 maxblocks     400.7       1439.4          259.2213626
>> File Copy 4096 bufsize 8000 maxblocks   894.3       3434.1          283.9986582
>> Pipe Throughput                         76819.5     74268.8         -3.320380893
>> Pipe-based Context Switching            3444.8      5963.3          73.11019508
>> Process Creation                        301.1       163.2           -45.79873796
>> Shell Scripts (1 concurrent)            1248.1      1859.7          49.00248378
>> Shell Scripts (8 concurrent)            781.2       1171            49.89759345
>> System Call Overhead                    3426        3194.4          -6.760070053
>>
>> System Benchmarks Index Score           3053        4605            50.83524402
>>
>> pvcy shows a smaller overall improvement (50%) compared to vcpu_is_preempted (277%).
>> Host side flamegraph analysis shows that ~60% of the host time when using pvcy
>> is spent in kvm_handle_wfx, compared with ~1.5% when using vcpu_is_preempted,
>> hence vcpu_is_preempted shows a larger improvement.
>>
>> It might be that pvcy can be used in combination with vcpu_is_preempted, but this
>> series is to start a discussion on vcpu_is_preempted as it shows a much bigger
>> improvement in performance and its much easier to review vcpu_is_preempted standalone.
> 
> Looking at both the patchsets - this one and the pvcy, it looks to me
> that vcpu_is_preempted() and the pvcy patches are somewhat
> orthogonal. The former is optimizing mutex and rwsem in their optimistic
> spinning phase while the latter is going after spinlocks (via wfe).
> 
> Unless I'm missing something the features are not necessarily comparable
> on the same workloads - unixbench is probably mutex heavy and doesn't
> show as much benefit with just the pvcy changes. I wonder if it's easy
> to have both the features enabled to see this in effect.
> 
> I've left some comments on the patches; but no need to respin just
> yet. Let's see if there is any other feedback.
> 
> Thanks,
> Punit
> 

There was a small bug in v2, where pv_lock_init was called too early in 
the boot in setup_arch, hence pvlock_vcpu_state was not initialized for 
vCPU 0 (the state was initialized for vCPUs 1-127 during secondary core 
boot, hence the rest of the vCPUs were using pvlock correctly). I will 
send the next revision making it an early_initcall along with addressing 
Punits' comments, but will wait for further comments on v2 before 
sending it. I have tested it with early_initcall and didnt see a 
significant change in performance (which is expected as only 1 out of 
128 vCPUs wasnt using pvlock correctly).

I tried pvcy+vcpu_is_preempted patches together and I see a slight 
reduction in performance over pvcy only.
As a summary, with the above changes to move to early_initcall included 
the overall Unixbench score improvements are:

Change over 6.0.0 base kernel                 % improvement over base
vcpu_is_preempted                             279%
pvcy                                          51%
pvcy+vcpu_is_preempted                        37%

Thanks,
Usama


> [...]
> 
