Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A47468ADC8
	for <lists+kvm@lfdr.de>; Sun,  5 Feb 2023 02:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjBEBP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 20:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBEBPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 20:15:25 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B1325956
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 17:15:23 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r8so8898956pls.2
        for <kvm@vger.kernel.org>; Sat, 04 Feb 2023 17:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=svaTyE5mZPQK0qWqzG6qY2crbRN9D/vpOsNYpHocwpY=;
        b=gsng0y6b+AGD/5yODn6xEf/wZoWYJOD5Gf5dOoVUAUuw55w6QXEjMvlLuSKejiLNML
         cDkd4YZmw/GNpKLKyn1PaOw9u5LLTGzAGmMTf/BNMKND+y/XP9U9N8mAUoxLzEl4s6nm
         yLeSJuZIKNxYd8De0i8D9OezYUrui5RqAh6ronWtLh9lp23xkvMW2aCgJZ1a6icMjY8M
         QdG+rFJX9bkCGuWL5oDpeHHoPDWAEnxHMSHOmdA/ei4t6ccUkmR/2EFerPMk46RGp6nw
         uX4c0SpR9Qs3gdd3eJTkmhjLQrGe6Qvibwnki9k5Y1xW+eo0tmMog1Z285RcFXu1E9Wc
         wWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=svaTyE5mZPQK0qWqzG6qY2crbRN9D/vpOsNYpHocwpY=;
        b=D9I/FBjHIxKAOu3qw4TLf4x70YUl78tnwtNlNn5hplrSfAcVKanQI90nAqNr7K1s9w
         nRBO5LbdmlrPidtr8qwkDTVZ71PTg+EDRlOKkmu3+eIFsZ+qMo1SA7t9pA9yFcglR3NX
         TVtotov8xPobvsqbpCBCMe+maXs5iyJWjDH/2h4actEIJozBcKxCsDbWZBP+v+lT/Gq8
         2U5ZHD/K7oJGUq5CcDaE2OtrHIffzwEARrHloFKw1gnmCuBszCJTuvU6YWWFfPtF7gpp
         Xp4In5Y5gWUi11pLQYJNMA4BT6alfk8TYlTK2EW9CiZKzCAZkKh3KgahuzKYN51Xg3oD
         T/Aw==
X-Gm-Message-State: AO0yUKVzJpVyN+4JNiwb+ZiM9PlJnzWAk+mHbMOwKWcU+Y52dfQ15KTo
        6sqGgHgLeIPH70/XtZv00whYXQ==
X-Google-Smtp-Source: AK7set8vbTdSCopsmxeeMPsAjktXPQFukNImkghNnkBCx+7kgE6y+NH6yD/PIl8Wzl4UIAePqxNbSQ==
X-Received: by 2002:a17:90a:1a49:b0:230:8956:79f6 with SMTP id 9-20020a17090a1a4900b00230895679f6mr4741945pjl.38.1675559722699;
        Sat, 04 Feb 2023 17:15:22 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id c7-20020a17090a020700b0023080c4c3bcsm2721917pjc.31.2023.02.04.17.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 17:15:22 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v5 00/14] KVM perf support 
Date:   Sat,  4 Feb 2023 17:15:01 -0800
Message-Id: <20230205011515.1284674-1-atishp@rivosinc.com>
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

This series extends perf support for KVM. The KVM implementation relies
on the SBI PMU extension and trap n emulation of hpmcounter CSRs.
The KVM implementation exposes the virtual counters to the guest and internally
manage the counters using kernel perf counters. 

This series doesn't support the counter overflow as the Sscofpmf extension
doesn't allow trap & emulation mechanism of scountovf CSR yet. The required
changes to allow that are being under discussions. Supporting overflow interrupt
also requires AIA interrupt filtering support.

1. PATCH 1-5 are generic KVM/PMU driver improvements.
2. PATCH 9 disables hpmcounter for now. It will be enabled to maintain ABI
requirement once the ONE reg interface is settled. 

perf stat works in kvm guests with this series. 

Here is example of running perf stat in a guest running in KVM.

===========================================================================
/ # /host/apps/perf stat -e instructions -e cycles -e r8000000000000005 \
> -e r8000000000000006 -e r8000000000000007 -e r8000000000000008 \
> -e r800000000000000a perf bench sched messaging -g 10 -l 10

# Running 'sched/messaging' benchmark:
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 7.769 [sec]
                 
 Performance counter stats for 'perf bench sched messaging -g 10 -l 10':

       73556259604      cycles
       73387266056      instructions              #    1.00  insn per cycle
                 0      dTLB-store-misses
                 0      iTLB-load-misses
                 0      r8000000000000005
              2595      r8000000000000006
              2272      r8000000000000007
                10      r8000000000000008
                 0      r800000000000000a

      12.173720400 seconds time elapsed

       1.002716000 seconds user
      21.931047000 seconds sys


Note: The SBI_PMU_FW_SET_TIMER (eventid : r8000000000000005) is zero
as kvm guest supports sstc now. 

This series can be found here as well.
https://github.com/atishp04/linux/tree/kvm_perf_v5

TODO:
1. Add sscofpmf support.
2. Add One reg interface for the following operations:
	1. Enable/Disable PMU (should it at VM level rather than vcpu ?)
	2. Number of hpmcounter and width of the counters
	3. Init PMU
	4. Allow guest user to access cycle & instret without trapping
3. Move counter mask to a bitmask instead of unsigned long so that it can work
   for RV32 systems where number of total counters are more than 32.
   This will also accomodate future systems which may define maximum counters
   to be more than 64. 

Changes from v4->v5:
1. Few checkpatch --strict error fixes.
2. Some other minor nit comment addressed.
3. Fixed an issue around counter indexing.

Changes from v3->v4:
1. Addressed all the comments on v3.
2. Modified the vcpu_pmu_init to void return type.
3. Redirect illegal instruction trap to guest for invalid hpmcounter access
   instead of exiting to the userpsace.
4. Got rid of unecessary error messages.

Changes v2->v3:
1. Changed the exported functions to GPL only export.
2. Addressed all the nit comments on v2.
3. Split non-kvm related changes into separate patches.
4. Reorgainze the PATCH 11 and 10 based on Drew's suggestions.

Changes from v1->v2:
1. Addressed comments from Andrew.
2. Removed kvpmu sanity check.
3. Added a kvm pmu init flag and the sanity check to probe function.
4. Improved the linux vs sbi error code handling.
 

Atish Patra (14):
perf: RISC-V: Define helper functions expose hpm counter width and
count
perf: RISC-V: Improve privilege mode filtering for perf
RISC-V: Improve SBI PMU extension related definitions
RISC-V: KVM: Define a probe function for SBI extension data structures
RISC-V: KVM: Return correct code for hsm stop function
RISC-V: KVM: Modify SBI extension handler to return SBI error code
RISC-V: KVM: Add skeleton support for perf
RISC-V: KVM: Add SBI PMU extension support
RISC-V: KVM: Make PMU functionality depend on Sscofpmf
RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
RISC-V: KVM: Implement trap & emulate for hpmcounters
RISC-V: KVM: Implement perf support without sampling
RISC-V: KVM: Support firmware events
RISC-V: KVM: Increment firmware pmu events

arch/riscv/include/asm/kvm_host.h     |   4 +
arch/riscv/include/asm/kvm_vcpu_pmu.h | 111 +++++
arch/riscv/include/asm/kvm_vcpu_sbi.h |  13 +-
arch/riscv/include/asm/sbi.h          |   7 +-
arch/riscv/kvm/Makefile               |   1 +
arch/riscv/kvm/main.c                 |   3 +-
arch/riscv/kvm/tlb.c                  |   4 +
arch/riscv/kvm/vcpu.c                 |   7 +
arch/riscv/kvm/vcpu_insn.c            |   4 +-
arch/riscv/kvm/vcpu_pmu.c             | 627 ++++++++++++++++++++++++++
arch/riscv/kvm/vcpu_sbi.c             |  72 ++-
arch/riscv/kvm/vcpu_sbi_base.c        |  27 +-
arch/riscv/kvm/vcpu_sbi_hsm.c         |  28 +-
arch/riscv/kvm/vcpu_sbi_pmu.c         |  87 ++++
arch/riscv/kvm/vcpu_sbi_replace.c     |  50 +-
arch/riscv/kvm/vcpu_sbi_v01.c         |  17 +-
drivers/perf/riscv_pmu_sbi.c          |  64 ++-
include/linux/perf/riscv_pmu.h        |   5 +
18 files changed, 1021 insertions(+), 110 deletions(-)
create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
create mode 100644 arch/riscv/kvm/vcpu_pmu.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c

--
2.25.1

