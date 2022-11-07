Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9CB61FD73
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbiKGSY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiKGSY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:24:28 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCDE28E10
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:24:04 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso6165183wms.4
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:user-agent:message-id:in-reply-to:date:references
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gTzkvGFwEKwQw/F2Z3wsS2AdiOgIB0jaZAkSMhc29Qo=;
        b=bpH85FqVDMoqSlvmQUVMqtKMAAnrIvj/DRgwR05ZohaO7CbSbgUK+zEaFX9X8xmDJo
         BguhUqsGh+2ohMFq5E46OhEHITv1RJWAkQsJHDE6v6+pNR+AwNY7dUm52ie6F0q9CAye
         sncIMwVJUb7OOcuPtZ0cgeR2Cv+mrH2T6JO5zRBDqRNO9Q2Nsn/J6jHeBtF8HbyF5yjL
         g5wEX4dyf2BKxbBLBwUpWd1WOIXW4QjsDzKpvIVz0HE2TfKr0Q/62XxwIzZtyevt5IVR
         oeuUvpyUJG6qc99P61jRyUYvOn8Rp9Xkx34MUDhC70IlrjhqPUQ562SGPI0T0hUml6/N
         zu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:message-id:in-reply-to:date:references
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTzkvGFwEKwQw/F2Z3wsS2AdiOgIB0jaZAkSMhc29Qo=;
        b=JFVTdAifJFsT1uvK+ztx2AhMH+aPLe+5Tv1F2/OtkkEU1QMJOv7I5BQxYC9hwUa2W6
         WSdl8m4eXwDeXE5n+H8kzQcoSIsAhhOfNu3v2v80hzlhHtPdk6IuUrkwDfsHlUMhRw4m
         tKLqjVLv/IO0/ooss6cQXYdl3rmJss2cIfJtLnOUWEZ/0TSuM4/4/C/XFrWVIRikHshE
         BBnfKFRkyffoxcdyY0aXkqNpyeuCCPn4rB3hhB/6sFcMGu/mmeoqOQWzSgNX+QcI5JEo
         kIKaud7ZubvRxpc5Ye2ftQCMOQxO0WvkD023hOwFm5mo8pTJFh8GH6dXkOVNvB64FF2Z
         SLXg==
X-Gm-Message-State: ACrzQf20XoYKF8Eo3Yf8/f/9sBrotm015BVCpZBgFm8ONkLhmcOPHm0T
        Gf6oFWzISFgGVf8xDbeE5IgEOA==
X-Google-Smtp-Source: AMsMyM4W3rCRgDCp/cmG06xoh4pvf1YZT/12uPUyVj/iz1+vsJvTSRWkwoDB4eUEqTI6URjyb3p5yw==
X-Received: by 2002:a05:600c:a05:b0:3b9:cecc:9846 with SMTP id z5-20020a05600c0a0500b003b9cecc9846mr43447084wmp.3.1667845443500;
        Mon, 07 Nov 2022 10:24:03 -0800 (PST)
Received: from localhost ([95.148.15.66])
        by smtp.gmail.com with ESMTPSA id m11-20020a5d4a0b000000b0022ca921dc67sm7795420wrq.88.2022.11.07.10.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 10:24:02 -0800 (PST)
From:   Punit Agrawal <punit.agrawal@bytedance.com>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, fam.zheng@bytedance.com,
        liangma@liangbit.com, punit.agrawal@bytedance.com
Subject: Re: [v2 0/6] KVM: arm64: implement vcpu_is_preempted check
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
Date:   Mon, 07 Nov 2022 18:24:02 +0000
In-Reply-To: <20221104062105.4119003-1-usama.arif@bytedance.com> (Usama Arif's
        message of "Fri, 4 Nov 2022 06:20:59 +0000")
Message-ID: <87wn861v3x.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Usama,

Usama Arif <usama.arif@bytedance.com> writes:

> This patchset adds support for vcpu_is_preempted in arm64, which allows the guest
> to check if a vcpu was scheduled out, which is useful to know incase it was
> holding a lock. vcpu_is_preempted can be used to improve
> performance in locking (see owner_on_cpu usage in mutex_spin_on_owner,
> mutex_can_spin_on_owner, rtmutex_spin_on_owner and osq_lock) and scheduling
> (see available_idle_cpu which is used in several places in kernel/sched/fair.c
> for e.g. in wake_affine to determine which CPU can run soonest):
>
> This patchset shows improvement on overcommitted hosts (vCPUs > pCPUS), as waiting
> for preempted vCPUs reduces performance.
>
> This patchset is inspired from the para_steal_clock implementation and from the
> work originally done by Zengruan Ye:
> https://lore.kernel.org/linux-arm-kernel/20191226135833.1052-1-yezengruan@huawei.com/.
>
> All the results in the below experiments are done on an aws r6g.metal instance
> which has 64 pCPUs.
>
> The following table shows the index results of UnixBench running on a 128 vCPU VM
> with (6.0.0+vcpu_is_preempted) and without (6.0.0 base) the patchset.
> TestName                                6.0.0 base  6.0.0+vcpu_is_preempted    % improvement for vcpu_is_preempted
> Dhrystone 2 using register variables    187761      191274.7                   1.871368389
> Double-Precision Whetstone              96743.6     98414.4                    1.727039308
> Execl Throughput                        689.3       10426                      1412.548963
> File Copy 1024 bufsize 2000 maxblocks   549.5       3165                       475.978162
> File Copy 256 bufsize 500 maxblocks     400.7       2084.7                     420.2645371
> File Copy 4096 bufsize 8000 maxblocks   894.3       5003.2                     459.4543218
> Pipe Throughput                         76819.5     78601.5                    2.319723508
> Pipe-based Context Switching            3444.8      13414.5                    289.4130283
> Process Creation                        301.1       293.4                      -2.557289937
> Shell Scripts (1 concurrent)            1248.1      28300.6                    2167.494592
> Shell Scripts (8 concurrent)            781.2       26222.3                    3256.669227
> System Call Overhead                    3426        3729.4                     8.855808523
>
> System Benchmarks Index Score           3053        11534                      277.7923354
>
> This shows a 277% overall improvement using these patches.
>
> The biggest improvement is in the shell scripts benchmark, which forks a lot of processes.
> This acquires rwsem lock where a large chunk of time is spent in base 6.0.0 kernel.
> This can be seen from one of the callstack of the perf output of the shell
> scripts benchmark on 6.0.0 base (pseudo NMI enabled for perf numbers below):
> - 33.79% el0_svc
>    - 33.43% do_el0_svc
>       - 33.43% el0_svc_common.constprop.3
>          - 33.30% invoke_syscall
>             - 17.27% __arm64_sys_clone
>                - 17.27% __do_sys_clone
>                   - 17.26% kernel_clone
>                      - 16.73% copy_process
>                         - 11.91% dup_mm
>                            - 11.82% dup_mmap
>                               - 9.15% down_write
>                                  - 8.87% rwsem_down_write_slowpath
>                                     - 8.48% osq_lock
>
> Just under 50% of the total time in the shell script benchmarks ends up being
> spent in osq_lock in the base 6.0.0 kernel:
>   Children      Self  Command   Shared Object        Symbol
>    17.19%    10.71%  sh      [kernel.kallsyms]  [k] osq_lock
>     6.17%     4.04%  sort    [kernel.kallsyms]  [k] osq_lock
>     4.20%     2.60%  multi.  [kernel.kallsyms]  [k] osq_lock
>     3.77%     2.47%  grep    [kernel.kallsyms]  [k] osq_lock
>     3.50%     2.24%  expr    [kernel.kallsyms]  [k] osq_lock
>     3.41%     2.23%  od      [kernel.kallsyms]  [k] osq_lock
>     3.36%     2.15%  rm      [kernel.kallsyms]  [k] osq_lock
>     3.28%     2.12%  tee     [kernel.kallsyms]  [k] osq_lock
>     3.16%     2.02%  wc      [kernel.kallsyms]  [k] osq_lock
>     0.21%     0.13%  looper  [kernel.kallsyms]  [k] osq_lock
>     0.01%     0.00%  Run     [kernel.kallsyms]  [k] osq_lock
>
> and this comes down to less than 1% total with 6.0.0+vcpu_is_preempted kernel:
>   Children      Self  Command   Shared Object        Symbol
>      0.26%     0.21%  sh      [kernel.kallsyms]  [k] osq_lock
>      0.10%     0.08%  multi.  [kernel.kallsyms]  [k] osq_lock
>      0.04%     0.04%  sort    [kernel.kallsyms]  [k] osq_lock
>      0.02%     0.01%  grep    [kernel.kallsyms]  [k] osq_lock
>      0.02%     0.02%  od      [kernel.kallsyms]  [k] osq_lock
>      0.01%     0.01%  tee     [kernel.kallsyms]  [k] osq_lock
>      0.01%     0.00%  expr    [kernel.kallsyms]  [k] osq_lock
>      0.01%     0.01%  looper  [kernel.kallsyms]  [k] osq_lock
>      0.00%     0.00%  wc      [kernel.kallsyms]  [k] osq_lock
>      0.00%     0.00%  rm      [kernel.kallsyms]  [k] osq_lock
>
> To make sure, there is no change in performance when vCPUs < pCPUs, UnixBench
> was run on a 32 CPU VM. The kernel with vcpu_is_preempted implemented
> performed 0.9% better overall than base kernel, and the individual benchmarks
> were within +/-2% improvement over 6.0.0 base.
> Hence the patches have no negative affect when vCPUs < pCPUs.
>
>
> The other method discussed in https://lore.kernel.org/linux-arm-kernel/20191226135833.1052-1-yezengruan@huawei.com/
> was pv conditional yield by Marc Zyngier and Will Deacon to reduce vCPU reschedule
> if the vCPU will exit immediately.
> (https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy).
> The patches were ported to 6.0.0 kernel and tested with UnixBench with a 128 vCPU VM:
>
> TestName                                6.0.0 base  6.0.0+pvcy      % improvement for pvcy
> Dhrystone 2 using register variables    187761      183128          -2.467498575
> Double-Precision Whetstone              96743.6     96645           -0.101918887
> Execl Throughput                        689.3       1019.8          47.9471928
> File Copy 1024 bufsize 2000 maxblocks   549.5       2029.7          269.3721565
> File Copy 256 bufsize 500 maxblocks     400.7       1439.4          259.2213626
> File Copy 4096 bufsize 8000 maxblocks   894.3       3434.1          283.9986582
> Pipe Throughput                         76819.5     74268.8         -3.320380893
> Pipe-based Context Switching            3444.8      5963.3          73.11019508
> Process Creation                        301.1       163.2           -45.79873796
> Shell Scripts (1 concurrent)            1248.1      1859.7          49.00248378
> Shell Scripts (8 concurrent)            781.2       1171            49.89759345
> System Call Overhead                    3426        3194.4          -6.760070053
>
> System Benchmarks Index Score           3053        4605            50.83524402
>
> pvcy shows a smaller overall improvement (50%) compared to vcpu_is_preempted (277%).
> Host side flamegraph analysis shows that ~60% of the host time when using pvcy
> is spent in kvm_handle_wfx, compared with ~1.5% when using vcpu_is_preempted,
> hence vcpu_is_preempted shows a larger improvement.
>
> It might be that pvcy can be used in combination with vcpu_is_preempted, but this
> series is to start a discussion on vcpu_is_preempted as it shows a much bigger
> improvement in performance and its much easier to review vcpu_is_preempted standalone.

Looking at both the patchsets - this one and the pvcy, it looks to me
that vcpu_is_preempted() and the pvcy patches are somewhat
orthogonal. The former is optimizing mutex and rwsem in their optimistic
spinning phase while the latter is going after spinlocks (via wfe).

Unless I'm missing something the features are not necessarily comparable
on the same workloads - unixbench is probably mutex heavy and doesn't
show as much benefit with just the pvcy changes. I wonder if it's easy
to have both the features enabled to see this in effect.

I've left some comments on the patches; but no need to respin just
yet. Let's see if there is any other feedback.

Thanks,
Punit

[...]

