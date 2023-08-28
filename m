Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E9778A85F
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 10:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjH1I5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 04:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjH1I5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 04:57:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205D4BF
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 01:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0D7263241
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 08:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E064FC433C8;
        Mon, 28 Aug 2023 08:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693213042;
        bh=oq7lotxiOG6rp/fU9NGgOcEsPBS3rd1oTL/ij/e1qnM=;
        h=From:To:Cc:Subject:Date:From;
        b=BfGnjVeKoLWZ7sFj+HJSKAir3gL46tRoz7ilIV4r/mOpR6bXduBVck7yk1/KkdARa
         pVBGl29NWv7B122P7uaOBiCD3ddSsyB2/H3qmsxhXMmg7bdwO8pyER95++NnSiux1a
         7QDNydm//98VNz1Rl50Iab+y2z8EogO9Jpz9qFxz5xahexVbUrD1tOdJJSy+mWJRgB
         q548VLyG0L9T4FjyUXEPm3g/ek39TbPy2Hiz2iaox3DD9AqTJFVXbhzCVAME1ayZ7Q
         JrU7IQ2gV5qJESnW2lKG6zbjl6wsZLucKeewLzGKLXGC3tNEAEAgjwtWWCYOxeEs6J
         /83s2ewaECk3g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qaY3i-008fYE-RE;
        Mon, 28 Aug 2023 09:57:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Anup Patel <anup@brainfault.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Matlack <dmatlack@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Jing Zhang <jingzhangos@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Leo Yan <leo.yan@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Reiji Watanabe <reijiw@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Will Deacon <will@kernel.org>,
        Yue Haibing <yuehaibing@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Zenghui Yu <zenghui.yu@linux.dev>,
        James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 updates for Linux v6.6
Date:   Mon, 28 Aug 2023 09:57:11 +0100
Message-Id: <20230828085711.4000711-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexander.stein@ew.tq-group.com, anup@brainfault.org, catalin.marinas@arm.com, dmatlack@google.com, eric.auger@redhat.com, tabba@google.com, gshan@redhat.com, shijie@os.amperecomputing.com, jingzhangos@google.com, kaleshsingh@google.com, leo.yan@linaro.org, broonie@kernel.org, mark.rutland@arm.com, miguel.luis@oracle.com, oliver.upton@linux.dev, philmd@linaro.org, rananta@google.com, rdunlap@infradead.org, reijiw@google.com, seanjc@google.com, shahuang@redhat.com, suzuki.poulose@arm.com, vdonnefort@google.com, will@kernel.org, yuehaibing@huawei.com, yuzenghui@huawei.com, zenghui.yu@linux.dev, james.morse@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the set of KVM/arm64 updates for 6.6. The highlight is the
support for range-based TLB invalidation, something that should help
cloud-type workloads, which are basically limited to moving the VMs
around rather than running guest code... ;-)

We also have a pretty large nested virtualisation update, with the
description of a zillion trap bits. The rest is the usual mix of
cleanups, bug fixes, and minor improvements (details in the tag
below).

Please pull,

	M.

The following changes since commit 6eaae198076080886b9e7d57f4ae06fa782f90ef:

  Linux 6.5-rc3 (2023-07-23 15:24:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.6

for you to fetch changes up to 1f66f1246bfa08aaf13db897736de49cbeaf72a1:

  Merge branch kvm-arm64/6.6/misc into kvmarm-master/next (2023-08-28 09:30:32 +0100)

----------------------------------------------------------------
KVM/arm64 updates for Linux 6.6

- Add support for TLB range invalidation of Stage-2 page tables,
  avoiding unnecessary invalidations. Systems that do not implement
  range invalidation still rely on a full invalidation when dealing
  with large ranges.

- Add infrastructure for forwarding traps taken from a L2 guest to
  the L1 guest, with L0 acting as the dispatcher, another baby step
  towards the full nested support.

- Simplify the way we deal with the (long deprecated) 'CPU target',
  resulting in a much needed cleanup.

- Fix another set of PMU bugs, both on the guest and host sides,
  as we seem to never have any shortage of those...

- Relax the alignment requirements of EL2 VA allocations for
  non-stack allocations, as we were otherwise wasting a lot of that
  precious VA space.

- The usual set of non-functional cleanups, although I note the lack
  of spelling fixes...

----------------------------------------------------------------
David Matlack (3):
      KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
      KVM: Allow range-based TLB invalidation from common code
      KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common code

Fuad Tabba (1):
      KVM: arm64: Remove redundant kvm_set_pfn_accessed() from user_mem_abort()

Marc Zyngier (35):
      Merge branch kvm-arm64/6.6/generic-vcpu into kvmarm-master/next
      arm64: Add missing VA CMO encodings
      arm64: Add missing ERX*_EL1 encodings
      arm64: Add missing DC ZVA/GVA/GZVA encodings
      arm64: Add TLBI operation encodings
      arm64: Add AT operation encodings
      arm64: Add debug registers affected by HDFGxTR_EL2
      arm64: Add missing BRB/CFP/DVP/CPP instructions
      arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
      KVM: arm64: Correctly handle ACCDATA_EL1 traps
      KVM: arm64: Add missing HCR_EL2 trap bits
      KVM: arm64: nv: Add FGT registers
      KVM: arm64: Restructure FGT register switching
      KVM: arm64: nv: Add trap forwarding infrastructure
      KVM: arm64: nv: Add trap forwarding for HCR_EL2
      KVM: arm64: nv: Expose FEAT_EVT to nested guests
      KVM: arm64: nv: Add trap forwarding for MDCR_EL2
      KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
      KVM: arm64: nv: Add fine grained trap forwarding infrastructure
      KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
      KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
      KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
      KVM: arm64: nv: Add SVC trap forwarding
      KVM: arm64: nv: Expand ERET trap forwarding to handle FGT
      KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
      KVM: arm64: nv: Expose FGT to nested guests
      KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
      KVM: arm64: nv: Add support for HCRX_EL2
      KVM: arm64: pmu: Resync EL0 state on counter rotation
      KVM: arm64: pmu: Guard PMU emulation definitions with CONFIG_KVM
      KVM: arm64: nv: Add trap description for SPSR_EL2 and ELR_EL2
      Merge branch kvm-arm64/nv-trap-forwarding into kvmarm-master/next
      Merge branch kvm-arm64/tlbi-range into kvmarm-master/next
      Merge branch kvm-arm64/6.6/pmu-fixes into kvmarm-master/next
      Merge branch kvm-arm64/6.6/misc into kvmarm-master/next

Mark Brown (1):
      arm64: Add feature detection for fine grained traps

Oliver Upton (4):
      KVM: arm64: Delete pointless switch statement in kvm_reset_vcpu()
      KVM: arm64: Remove pointless check for changed init target
      KVM: arm64: Replace vCPU target with a configuration flag
      KVM: arm64: Always return generic v8 as the preferred target

Raghavendra Rao Ananta (11):
      KVM: Declare kvm_arch_flush_remote_tlbs() globally
      KVM: arm64: Use kvm_arch_flush_remote_tlbs()
      KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
      arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
      arm64: tlb: Implement __flush_s2_tlb_range_op()
      KVM: arm64: Implement __kvm_tlb_flush_vmid_range()
      KVM: arm64: Define kvm_tlb_flush_vmid_range()
      KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
      KVM: arm64: Flush only the memslot after write-protect
      KVM: arm64: Invalidate the table entries upon a range
      KVM: arm64: Use TLBI range-based instructions for unmap

Randy Dunlap (1):
      KVM: arm64: nv: Select XARRAY_MULTI to fix build error

Reiji Watanabe (4):
      KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer
      KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
      KVM: arm64: PMU: Don't advertise the STALL_SLOT event
      KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}

Shaoqin Huang (1):
      KVM: arm64: Use the known cpu id instead of smp_processor_id()

Vincent Donnefort (1):
      KVM: arm64: Remove size-order align in the nVHE hyp private VA range

Yue Haibing (1):
      KVM: arm64: Remove unused declarations

Zenghui Yu (1):
      KVM: arm64: Drop HCR_VIRT_EXCP_MASK

 arch/arm/include/asm/arm_pmuv3.h        |    2 +
 arch/arm64/include/asm/kvm_arm.h        |   51 +-
 arch/arm64/include/asm/kvm_asm.h        |    3 +
 arch/arm64/include/asm/kvm_host.h       |   24 +-
 arch/arm64/include/asm/kvm_mmu.h        |    1 +
 arch/arm64/include/asm/kvm_nested.h     |    2 +
 arch/arm64/include/asm/kvm_pgtable.h    |   10 +
 arch/arm64/include/asm/sysreg.h         |  268 ++++-
 arch/arm64/include/asm/tlbflush.h       |  124 ++-
 arch/arm64/kernel/cpufeature.c          |    7 +
 arch/arm64/kvm/Kconfig                  |    2 +-
 arch/arm64/kvm/arm.c                    |   65 +-
 arch/arm64/kvm/emulate-nested.c         | 1852 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/guest.c                  |   15 -
 arch/arm64/kvm/handle_exit.c            |   29 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  127 ++-
 arch/arm64/kvm/hyp/include/nvhe/mm.h    |    1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |   11 +
 arch/arm64/kvm/hyp/nvhe/mm.c            |   83 +-
 arch/arm64/kvm/hyp/nvhe/setup.c         |   27 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |    2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c           |   30 +
 arch/arm64/kvm/hyp/pgtable.c            |   63 +-
 arch/arm64/kvm/hyp/vhe/tlb.c            |   28 +
 arch/arm64/kvm/mmu.c                    |  102 +-
 arch/arm64/kvm/nested.c                 |   11 +-
 arch/arm64/kvm/pmu-emul.c               |   37 +-
 arch/arm64/kvm/pmu.c                    |   18 +
 arch/arm64/kvm/reset.c                  |   25 +-
 arch/arm64/kvm/sys_regs.c               |   15 +
 arch/arm64/kvm/trace_arm.h              |   26 +
 arch/arm64/kvm/vgic/vgic.h              |    2 -
 arch/arm64/tools/cpucaps                |    1 +
 arch/arm64/tools/sysreg                 |  129 +++
 arch/mips/include/asm/kvm_host.h        |    3 +-
 arch/mips/kvm/mips.c                    |   12 +-
 arch/riscv/kvm/mmu.c                    |    6 -
 arch/x86/include/asm/kvm_host.h         |    6 +-
 arch/x86/kvm/mmu/mmu.c                  |   28 +-
 arch/x86/kvm/mmu/mmu_internal.h         |    3 -
 arch/x86/kvm/x86.c                      |    2 +-
 drivers/perf/arm_pmuv3.c                |    2 +
 include/kvm/arm_pmu.h                   |    4 +-
 include/linux/kvm_host.h                |   24 +-
 virt/kvm/Kconfig                        |    3 -
 virt/kvm/kvm_main.c                     |   35 +-
 46 files changed, 2993 insertions(+), 328 deletions(-)
