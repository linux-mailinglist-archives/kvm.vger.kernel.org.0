Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B0A66DB22
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbjAQKbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbjAQKap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:30:45 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C49E305E9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:37 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so4464506wml.3
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JpU7YzXJFJIX52SQGOqq5aDKTgE96MJRn4JvPctjnfc=;
        b=vENXUr0lSMEu6Nv7aaAFjhX2Sxi3ZaryF30CVzGrvRcpP5d8q8j/Pjk86ywQ329dz6
         FQ6Boz2bwIPrl+OEgQf8xS9W/tfznM/EKUdslD+c2rihur9H/4y0l1ZSVlUbV8yYZoou
         Q3aizapyB7iXbee5shE+V7qYdCshXdBzp6GTWFe6L5yP2kiuTZU4wPbAziOpxVXRNIzC
         zuTU9xH3QWbO5cOpE4uCb6pncbigpW3XxoEsMwZtNFxipuDaN4/sttUO1MgfeyyAvCo5
         Eo62jdtTIvH835xR3yqhGEVRphqG9ktKe7NZaPrAC1PusygqJn1jjtRgmKkH04N0kVvH
         KaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JpU7YzXJFJIX52SQGOqq5aDKTgE96MJRn4JvPctjnfc=;
        b=jNTiopvHa23GgLk+ZycRo6c39tK5rpsJYqIQULZB2d4XL29QxtP+t0OcNoq5ACCWK6
         7Jc3KrKz/2qLQ8STZipnGZQf210/LTZG3gVdtbHECD/rL9iCTsLxsqTYBWhf/GmhWxa6
         S2ax3n3rKVbWqVRu9Zl1VzyHg7uKw2ipWuJVPYkgkhrVf0pxRZgwYYx0Z6slZJHYOXJy
         FWkGnBMLkd9/i8iF8h9fcSic3czj9LRDwwK+xgJNBtcMqc2piaul1W+WJi2o7BxcLDS+
         s1UvJGPpxj4IbfPyiP5/04/NHF8NNFFtw8fUjBTH1TCRpA9T/nsB21PQciytWo92CnbB
         rNHg==
X-Gm-Message-State: AFqh2koRNleMaQp79/4Dy3/gIfBeMYFZOhGSCx5LoOWT6XEd6pNkYRF5
        TVCx53eJFaGCymUYfYgO0aOm8w==
X-Google-Smtp-Source: AMrXdXuRbz/mM+OMtf0kKr+l3ZyDYz39gt1A5vPfxWCL+hWG7t+kmOSCYZtejR7auYD39M6wQmCCtQ==
X-Received: by 2002:a05:600c:2d84:b0:3d9:e8b3:57f9 with SMTP id i4-20020a05600c2d8400b003d9e8b357f9mr2728822wmg.8.1673951375860;
        Tue, 17 Jan 2023 02:29:35 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:17d8:e5ec:f870:7b46])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d452f000000b0028f9132e9ddsm28389844wra.39.2023.01.17.02.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:29:35 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, pbonzini@redhat.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v3 0/6] KVM: arm64: implement vcpu_is_preempted check
Date:   Tue, 17 Jan 2023 10:29:24 +0000
Message-Id: <20230117102930.1053337-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset adds support for vcpu_is_preempted in arm64, which allows the guest
to check if a vcpu was scheduled out, which is useful to know incase it was
holding a lock. vcpu_is_preempted is well integrated in core kernel code and can
be used to improve performance in locking (owner_on_cpu usage in mutex_spin_on_owner,
mutex_can_spin_on_owner, rtmutex_spin_on_owner and osq_lock) and scheduling
(available_idle_cpu which is used in several places in kernel/sched/fair.c
for e.g. in wake_affine to determine which CPU can run soonest).

This patchset shows significant improvement on overcommitted hosts (vCPUs > pCPUS),
as waiting for preempted vCPUs reduces performance.

If merged, vcpu_is_preempted could also be used to optimize IPI performance (along
with directed yield to target IPI vCPU) similar to how its done in x86
(https://lore.kernel.org/all/1560255830-8656-2-git-send-email-wanpengli@tencent.com/)

All the results in the below experiments are done on an aws r6g.metal instance
which has 64 pCPUs.

The following table shows the index results of UnixBench running on a 128 vCPU VM
with (6.0+vcpu_is_preempted) and without (6.0 base) the patchset.
TestName                                6.0 base    6.0+vcpu_is_preempted      % improvement for vcpu_is_preempted
Dhrystone 2 using register variables    187761      191274.7                   1.871368389
Double-Precision Whetstone              96743.6     98414.4                    1.727039308
Execl Throughput                        689.3       10426                      1412.548963
File Copy 1024 bufsize 2000 maxblocks   549.5       3165                       475.978162
File Copy 256 bufsize 500 maxblocks     400.7       2084.7                     420.2645371
File Copy 4096 bufsize 8000 maxblocks   894.3       5003.2                     459.4543218
Pipe Throughput                         76819.5     78601.5                    2.319723508
Pipe-based Context Switching            3444.8      13414.5                    289.4130283
Process Creation                        301.1       293.4                      -2.557289937
Shell Scripts (1 concurrent)            1248.1      28300.6                    2167.494592
Shell Scripts (8 concurrent)            781.2       26222.3                    3256.669227
System Call Overhead                    3426        3729.4                     8.855808523

System Benchmarks Index Score           3053        11534                      277.7923354

This shows a 278% overall improvement using these patches.

The biggest improvement is in the shell scripts benchmark, which forks a lot of processes.
This acquires rwsem lock where a large chunk of time is spent in base kernel.
This can be seen from one of the callstack of the perf output of the shell
scripts benchmark on base (pseudo NMI enabled for perf numbers below):
- 33.79% el0_svc
   - 33.43% do_el0_svc
      - 33.43% el0_svc_common.constprop.3
         - 33.30% invoke_syscall
            - 17.27% __arm64_sys_clone
               - 17.27% __do_sys_clone
                  - 17.26% kernel_clone
                     - 16.73% copy_process
                        - 11.91% dup_mm
                           - 11.82% dup_mmap
                              - 9.15% down_write
                                 - 8.87% rwsem_down_write_slowpath
                                    - 8.48% osq_lock

Just under 50% of the total time in the shell script benchmarks ends up being
spent in osq_lock in the base kernel:
  Children      Self  Command   Shared Object        Symbol
   17.19%    10.71%  sh      [kernel.kallsyms]  [k] osq_lock
    6.17%     4.04%  sort    [kernel.kallsyms]  [k] osq_lock
    4.20%     2.60%  multi.  [kernel.kallsyms]  [k] osq_lock
    3.77%     2.47%  grep    [kernel.kallsyms]  [k] osq_lock
    3.50%     2.24%  expr    [kernel.kallsyms]  [k] osq_lock
    3.41%     2.23%  od      [kernel.kallsyms]  [k] osq_lock
    3.36%     2.15%  rm      [kernel.kallsyms]  [k] osq_lock
    3.28%     2.12%  tee     [kernel.kallsyms]  [k] osq_lock
    3.16%     2.02%  wc      [kernel.kallsyms]  [k] osq_lock
    0.21%     0.13%  looper  [kernel.kallsyms]  [k] osq_lock
    0.01%     0.00%  Run     [kernel.kallsyms]  [k] osq_lock

and this comes down to less than 1% total with 6.0+vcpu_is_preempted kernel:
  Children      Self  Command   Shared Object        Symbol
     0.26%     0.21%  sh      [kernel.kallsyms]  [k] osq_lock
     0.10%     0.08%  multi.  [kernel.kallsyms]  [k] osq_lock
     0.04%     0.04%  sort    [kernel.kallsyms]  [k] osq_lock
     0.02%     0.01%  grep    [kernel.kallsyms]  [k] osq_lock
     0.02%     0.02%  od      [kernel.kallsyms]  [k] osq_lock
     0.01%     0.01%  tee     [kernel.kallsyms]  [k] osq_lock
     0.01%     0.00%  expr    [kernel.kallsyms]  [k] osq_lock
     0.01%     0.01%  looper  [kernel.kallsyms]  [k] osq_lock
     0.00%     0.00%  wc      [kernel.kallsyms]  [k] osq_lock
     0.00%     0.00%  rm      [kernel.kallsyms]  [k] osq_lock

To make sure, there is no change in performance when vCPUs < pCPUs, UnixBench
was run on a 32 CPU VM. The kernel with vcpu_is_preempted implemented
performed 0.9% better overall than base kernel, and the individual benchmarks
were within +/-2% improvement over 6.0 base.
Hence the patches have no negative affect when vCPUs < pCPUs.

The respective QEMU change to test this is at
https://github.com/uarif1/qemu/commit/2da2c2927ae8de8f03f439804a0dad9cf68501b6.

Looking forward to your response!
Thanks,
Usama
---
v2->v3
- Updated the patchset from 6.0 to 6.2-rc3
- Made pv_lock_init an early_initcall
- Improved documentation
- Changed pvlock_vcpu_state to aligned struct
- Minor improvevments

RFC->v2
- Fixed table and code referencing in pvlock documentation
- Switched to using a single hypercall similar to ptp_kvm and made check
  for has_kvm_pvlock simpler

Usama Arif (6):
  KVM: arm64: Document PV-lock interface
  KVM: arm64: Add SMCCC paravirtualised lock calls
  KVM: arm64: Support pvlock preempted via shared structure
  KVM: arm64: Provide VCPU attributes for PV lock
  KVM: arm64: Support the VCPU preemption check
  KVM: selftests: add tests for PV time specific hypercall

 Documentation/virt/kvm/arm/hypercalls.rst     |   3 +
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/pvlock.rst         |  54 +++++++++
 Documentation/virt/kvm/devices/vcpu.rst       |  25 ++++
 arch/arm64/include/asm/kvm_host.h             |  25 ++++
 arch/arm64/include/asm/paravirt.h             |   2 +
 arch/arm64/include/asm/pvlock-abi.h           |  15 +++
 arch/arm64/include/asm/spinlock.h             |  16 ++-
 arch/arm64/include/uapi/asm/kvm.h             |   3 +
 arch/arm64/kernel/paravirt.c                  | 113 ++++++++++++++++++
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |   8 ++
 arch/arm64/kvm/guest.c                        |   9 ++
 arch/arm64/kvm/hypercalls.c                   |   8 ++
 arch/arm64/kvm/pvlock.c                       | 100 ++++++++++++++++
 include/linux/arm-smccc.h                     |   8 ++
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   1 +
 tools/include/linux/arm-smccc.h               |   8 ++
 .../selftests/kvm/aarch64/hypercalls.c        |   2 +
 20 files changed, 403 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
 create mode 100644 arch/arm64/include/asm/pvlock-abi.h
 create mode 100644 arch/arm64/kvm/pvlock.c

-- 
2.25.1

