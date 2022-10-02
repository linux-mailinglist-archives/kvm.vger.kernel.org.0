Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613865F2334
	for <lists+kvm@lfdr.de>; Sun,  2 Oct 2022 14:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiJBMmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Oct 2022 08:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJBMma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Oct 2022 08:42:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE442ED49
        for <kvm@vger.kernel.org>; Sun,  2 Oct 2022 05:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AA57B80D2F
        for <kvm@vger.kernel.org>; Sun,  2 Oct 2022 12:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8472DC433D6;
        Sun,  2 Oct 2022 12:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664714544;
        bh=EiChT6J1ECriC/ynvVZgo8VpoXFQ3CnkyvrhPojpX/4=;
        h=From:To:Cc:Subject:Date:From;
        b=k28+MPfoVlaKSs8vuZNpaE11BrlMvfQDPelMGFowGudsbvwnm8SZ4r5oi2agSZZW1
         JvC0+2PHRgAMmULZQsmhPy2RrARVUTGjHaC5M7RSj3ZO9L3Ac5wTKAuw52jSHo5woh
         Qfl2L0sujFOO3TY/UGbO9UAw7cLHTpBCNWzcXSA0OxQ96ucBSRIoKUs+h+Ua/JKiPo
         /cANukbGHPyo6sAq3wcviXM6QFmwNNAd69nGLH8BQLVX4Qpcutx6pc0lyCrOK5UPSF
         nBPM/9r68Ya57EVBvtt5h7m1xRZ1sgCMZYMz7udo9WO5fZjEyEyIkSZMXWgjbTVm/P
         S3elmTqv/7pxQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oeyIY-00E9PG-6w;
        Sun, 02 Oct 2022 13:42:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Elliot Berman <quic_eberman@quicinc.com>,
        Gavin Shan <gshan@redhat.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Peter Xu <peterx@redhat.com>,
        Reiji Watanabe <reijiw@google.com>,
        Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 updates for 6.1
Date:   Sun,  2 Oct 2022 13:42:19 +0100
Message-Id: <20221002124219.3902661-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, quic_eberman@quicinc.com, gshan@redhat.com, kristina.martsenko@arm.com, broonie@kernel.org, oliver.upton@linux.dev, peterx@redhat.com, reijiw@google.com, r09922117@csie.ntu.edu.tw, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please find below the rather small set of KVM/arm64 updates
for 6.1. This is mostly a set of fixes for existing features,
the most interesting one being Reiji's really good work tracking
an annoying set of bugs in our single-stepping implementation.
Also, I've included the changes making it possible to enable
the dirty-ring tracking on arm64. Full details in the tag.

Note that this pull-request comes with a branch shared with the
arm64 tree, in order to avoid some bad conflicts due to the
ongoing repainting of all the system registers.

Please pull,

	M.

The following changes since commit b90cb1053190353cc30f0fef0ef1f378ccc063c5:

  Linux 6.0-rc3 (2022-08-28 15:05:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.1

for you to fetch changes up to b302ca52ba8235ff0e18c0fa1fa92b51784aef6a:

  Merge branch kvm-arm64/misc-6.1 into kvmarm-master/next (2022-10-01 10:19:36 +0100)

----------------------------------------------------------------
KVM/arm64 updates for v6.1

- Fixes for single-stepping in the presence of an async
  exception as well as the preservation of PSTATE.SS

- Better handling of AArch32 ID registers on AArch64-only
  systems

- Fixes for the dirty-ring API, allowing it to work on
  architectures with relaxed memory ordering

- Advertise the new kvmarm mailing list

- Various minor cleanups and spelling fixes

----------------------------------------------------------------
Elliot Berman (1):
      KVM: arm64: Ignore kvm-arm.mode if !is_hyp_mode_available()

Gavin Shan (1):
      KVM: arm64: vgic: Remove duplicate check in update_affinity_collection()

Kristina Martsenko (3):
      arm64: cache: Remove unused CTR_CACHE_MINLINE_MASK
      arm64/sysreg: Standardise naming for ID_AA64MMFR1_EL1 fields
      arm64/sysreg: Convert ID_AA64MMFR1_EL1 to automatic generation

Marc Zyngier (12):
      Merge branch kvm-arm64/aarch32-raz-idregs into kvmarm-master/next
      Merge remote-tracking branch 'arm64/for-next/sysreg' into kvmarm-master/next
      Merge branch kvm-arm64/single-step-async-exception into kvmarm-master/next
      KVM: Use acquire/release semantics when accessing dirty ring GFN state
      KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
      KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
      KVM: Document weakly ordered architecture requirements for dirty ring
      KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release semantics
      KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available
      KVM: arm64: Advertise new kvmarm mailing list
      Merge branch kvm-arm64/dirty-log-ordered into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.1 into kvmarm-master/next

Mark Brown (31):
      arm64/sysreg: Remove stray SMIDR_EL1 defines
      arm64/sysreg: Describe ID_AA64SMFR0_EL1.SMEVer as an enumeration
      arm64/sysreg: Add _EL1 into ID_AA64MMFR0_EL1 definition names
      arm64/sysreg: Add _EL1 into ID_AA64MMFR2_EL1 definition names
      arm64/sysreg: Add _EL1 into ID_AA64PFR0_EL1 definition names
      arm64/sysreg: Add _EL1 into ID_AA64PFR1_EL1 constant names
      arm64/sysreg: Standardise naming of ID_AA64MMFR0_EL1.BigEnd
      arm64/sysreg: Standardise naming of ID_AA64MMFR0_EL1.ASIDBits
      arm64/sysreg: Standardise naming for ID_AA64MMFR2_EL1.VARange
      arm64/sysreg: Standardise naming for ID_AA64MMFR2_EL1.CnP
      arm64/sysreg: Standardise naming for ID_AA64PFR0_EL1 constants
      arm64/sysreg: Standardise naming for ID_AA64PFR0_EL1.AdvSIMD constants
      arm64/sysreg: Standardise naming for SSBS feature enumeration
      arm64/sysreg: Standardise naming for MTE feature enumeration
      arm64/sysreg: Standardise naming of ID_AA64PFR1_EL1 fractional version fields
      arm64/sysreg: Standardise naming of ID_AA64PFR1_EL1 BTI enumeration
      arm64/sysreg: Standardise naming of ID_AA64PFR1_EL1 SME enumeration
      arm64/sysreg: Convert HCRX_EL2 to automatic generation
      arm64/sysreg: Convert ID_AA64MMFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_AA64MMFR2_EL1 to automatic generation
      arm64/sysreg: Convert ID_AA64PFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_AA64PFR1_EL1 to automatic generation
      arm64/sysreg: Convert TIPDR_EL1 to automatic generation
      arm64/sysreg: Convert SCXTNUM_EL1 to automatic generation
      arm64/sysreg: Add defintion for ALLINT
      arm64/sysreg: Align field names in ID_AA64DFR0_EL1 with architecture
      arm64/sysreg: Add _EL1 into ID_AA64DFR0_EL1 definition names
      arm64/sysreg: Use feature numbering for PMU and SPE revisions
      arm64/sysreg: Convert ID_AA64FDR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_AA64DFR1_EL1 to automatic generation
      arm64/sysreg: Convert ID_AA64AFRn_EL1 to automatic generation

Oliver Upton (8):
      KVM: arm64: Use visibility hook to treat ID regs as RAZ
      KVM: arm64: Remove internal accessor helpers for id regs
      KVM: arm64: Drop raz parameter from read_id_reg()
      KVM: arm64: Spin off helper for calling visibility hook
      KVM: arm64: Add a visibility bit to ignore user writes
      KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
      KVM: selftests: Add test for AArch32 ID registers
      KVM: selftests: Update top-of-file comment in psci_test

Reiji Watanabe (4):
      KVM: arm64: Preserve PSTATE.SS for the guest while single-step is enabled
      KVM: arm64: Clear PSTATE.SS when the Software Step state was Active-pending
      KVM: arm64: selftests: Refactor debug-exceptions to make it amenable to new test cases
      KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP

Wei-Lin Chang (1):
      KVM: arm64: Fix comment typo in nvhe/switch.c

 Documentation/virt/kvm/api.rst                     |  17 +-
 MAINTAINERS                                        |   3 +-
 arch/arm64/include/asm/assembler.h                 |  10 +-
 arch/arm64/include/asm/cache.h                     |   4 -
 arch/arm64/include/asm/cpufeature.h                |  66 +--
 arch/arm64/include/asm/el2_setup.h                 |  18 +-
 arch/arm64/include/asm/hw_breakpoint.h             |   4 +-
 arch/arm64/include/asm/kvm_host.h                  |   4 +
 arch/arm64/include/asm/kvm_pgtable.h               |   6 +-
 arch/arm64/include/asm/sysreg.h                    | 211 ++--------
 arch/arm64/kernel/cpufeature.c                     | 238 +++++------
 arch/arm64/kernel/debug-monitors.c                 |   2 +-
 arch/arm64/kernel/head.S                           |  10 +-
 arch/arm64/kernel/hyp-stub.S                       |   8 +-
 arch/arm64/kernel/idreg-override.c                 |  10 +-
 arch/arm64/kernel/perf_event.c                     |   8 +-
 arch/arm64/kernel/proton-pack.c                    |   4 +-
 arch/arm64/kvm/arm.c                               |  15 +-
 arch/arm64/kvm/debug.c                             |  38 +-
 arch/arm64/kvm/guest.c                             |   1 +
 arch/arm64/kvm/handle_exit.c                       |   8 +-
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |  60 +--
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  38 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |  10 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   2 +-
 arch/arm64/kvm/pmu-emul.c                          |  16 +-
 arch/arm64/kvm/reset.c                             |  12 +-
 arch/arm64/kvm/sys_regs.c                          | 198 +++++----
 arch/arm64/kvm/sys_regs.h                          |  24 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   2 +-
 arch/arm64/mm/context.c                            |   6 +-
 arch/arm64/mm/init.c                               |   2 +-
 arch/arm64/mm/mmu.c                                |   2 +-
 arch/arm64/mm/proc.S                               |   4 +-
 arch/arm64/tools/sysreg                            | 449 ++++++++++++++++++++-
 arch/x86/kvm/Kconfig                               |   3 +-
 drivers/firmware/efi/libstub/arm64-stub.c          |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |   6 +-
 drivers/irqchip/irq-gic-v4.c                       |   2 +-
 include/uapi/linux/kvm.h                           |   1 +
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../selftests/kvm/aarch64/aarch32_id_regs.c        | 169 ++++++++
 .../selftests/kvm/aarch64/debug-exceptions.c       | 149 ++++++-
 tools/testing/selftests/kvm/aarch64/psci_test.c    |  10 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |   8 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +-
 virt/kvm/Kconfig                                   |  14 +
 virt/kvm/dirty_ring.c                              |   4 +-
 virt/kvm/kvm_main.c                                |   9 +-
 51 files changed, 1294 insertions(+), 604 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
