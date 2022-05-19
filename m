Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E5552CF60
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 11:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiESJ2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 05:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiESJ2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 05:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708DD5FF10
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 02:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0A2D61943
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1451CC385AA;
        Thu, 19 May 2022 09:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652952485;
        bh=Hsm84cvLLw0UdUjVNA4x0W0aGp3tiMGFkB/3CKSB3gs=;
        h=From:To:Cc:Subject:Date:From;
        b=XO3YqNbSxvaYS3Qjm/dntOZQNom0456jFv4cSZ4pmJdnAOLc5i1lMJ3tXB9Ht+kt4
         MPYhaTED5QV63D59mi6F19VTkO56O8hd1kByMSuKbC+VG2mPUHYbDvy5NX3JLbEsis
         WJp1YRgLq5HImFRSi41Dwh1kJpVhyl6BXwj0yaXFuXazG3qcD5RvAIL0iNA50V1Y+8
         MDZaA4Yrg+Bn0Y47OFNKVopWj+iB8cTXYXmFj5GoE034sFk7ANmb4fjOJb1VF1fhr7
         4SpqQwmbSQG0Oyjhm4s7eM7uaXMMLTZZ/Za3joh+Vls9MSuVgDFSvQ2X1hAubnTWy+
         sx8c48ARXeJtQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nrcRu-00CNF4-TP; Thu, 19 May 2022 10:28:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Wan Jiabing <wanjiabing@vivo.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 updates for 5.19
Date:   Thu, 19 May 2022 10:27:44 +0100
Message-Id: <20220519092744.992742-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, ardb@kernel.org, catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com, tabba@google.com, gshan@redhat.com, james.morse@arm.com, joey.gouly@arm.com, kaleshsingh@google.com, m.szyprowski@samsung.com, broonie@kernel.org, oupton@google.com, rananta@google.com, rdunlap@infradead.org, reijiw@google.com, ricarkol@google.com, sfr@canb.auug.org.au, suzuki.poulose@arm.com, szabolcs.nagy@arm.com, wanjiabing@vivo.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the bulk of the KVM/arm64 updates for 5.19. Major features are
guard pages for the EL2 stacks, save/restore of the guest-visible
hypercall configuration and PSCI suspend support. Further details in
the tag description.

Note that this PR contains a shared branch with the arm64 tree
containing the SME patches to resolve conflicts with the WFxT support
branch.

Please pull,

	M.

The following changes since commit 672c0c5173427e6b3e2a9bbb7be51ceeec78093a:

  Linux 5.18-rc5 (2022-05-01 13:57:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.19

for you to fetch changes up to 5c0ad551e9aa6188f2bda0977c1cb6768a2b74ef:

  Merge branch kvm-arm64/its-save-restore-fixes-5.19 into kvmarm-master/next (2022-05-16 17:48:36 +0100)

----------------------------------------------------------------
KVM/arm64 updates for 5.19

- Add support for the ARMv8.6 WFxT extension

- Guard pages for the EL2 stacks

- Trap and emulate AArch32 ID registers to hide unsupported features

- Ability to select and save/restore the set of hypercalls exposed
  to the guest

- Support for PSCI-initiated suspend in collaboration with userspace

- GICv3 register-based LPI invalidation support

- Move host PMU event merging into the vcpu data structure

- GICv3 ITS save/restore fixes

- The usual set of small-scale cleanups and fixes

----------------------------------------------------------------
Alexandru Elisei (3):
      KVM: arm64: Hide AArch32 PMU registers when not available
      KVM: arm64: Don't BUG_ON() if emulated register table is unsorted
      KVM: arm64: Print emulated register table name when it is unsorted

Ard Biesheuvel (1):
      KVM: arm64: Avoid unnecessary absolute addressing via literals

Fuad Tabba (4):
      KVM: arm64: Wrapper for getting pmu_events
      KVM: arm64: Repack struct kvm_pmu to reduce size
      KVM: arm64: Pass pmu events to hyp via vcpu
      KVM: arm64: Reenable pmu in Protected Mode

Kalesh Singh (6):
      KVM: arm64: Introduce hyp_alloc_private_va_range()
      KVM: arm64: Introduce pkvm_alloc_private_va_range()
      KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
      KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
      KVM: arm64: Detect and handle hypervisor stack overflows
      KVM: arm64: Symbolize the nVHE HYP addresses

Marc Zyngier (30):
      arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
      arm64: Add RV and RN fields for ESR_ELx_WFx_ISS
      arm64: Add HWCAP advertising FEAT_WFXT
      arm64: Add wfet()/wfit() helpers
      arm64: Use WFxT for __delay() when possible
      KVM: arm64: Simplify kvm_cpu_has_pending_timer()
      KVM: arm64: Introduce kvm_counter_compute_delta() helper
      KVM: arm64: Handle blocking WFIT instruction
      KVM: arm64: Offer early resume for non-blocking WFxT instructions
      KVM: arm64: Expose the WFXT feature to guests
      KVM: arm64: Fix new instances of 32bit ESRs
      Merge remote-tracking branch 'arm64/for-next/sme' into kvmarm-master/next
      Merge branch kvm-arm64/wfxt into kvmarm-master/next
      Merge branch kvm-arm64/hyp-stack-guard into kvmarm-master/next
      Merge branch kvm-arm64/aarch32-idreg-trap into kvmarm-master/next
      Documentation: Fix index.rst after psci.rst renaming
      irqchip/gic-v3: Exposes bit values for GICR_CTLR.{IR, CES}
      KVM: arm64: vgic-v3: Expose GICR_CTLR.RWP when disabling LPIs
      KVM: arm64: vgic-v3: Implement MMIO-based LPI invalidation
      KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR, CES} as a new GICD_IIDR revision
      KVM: arm64: vgic-v3: List M1 Pro/Max as requiring the SEIS workaround
      KVM: arm64: Hide KVM_REG_ARM_*_BMAP_BIT_COUNT from userspace
      KVM: arm64: pmu: Restore compilation when HW_PERF_EVENTS isn't selected
      KVM: arm64: Fix hypercall bitmap writeback when vcpus have already run
      Merge branch kvm-arm64/hcall-selection into kvmarm-master/next
      Merge branch kvm-arm64/psci-suspend into kvmarm-master/next
      Merge branch kvm-arm64/vgic-invlpir into kvmarm-master/next
      Merge branch kvm-arm64/per-vcpu-host-pmu-data into kvmarm-master/next
      Merge branch kvm-arm64/misc-5.19 into kvmarm-master/next
      Merge branch kvm-arm64/its-save-restore-fixes-5.19 into kvmarm-master/next

Mark Brown (25):
      arm64/sme: Provide ABI documentation for SME
      arm64/sme: System register and exception syndrome definitions
      arm64/sme: Manually encode SME instructions
      arm64/sme: Early CPU setup for SME
      arm64/sme: Basic enumeration support
      arm64/sme: Identify supported SME vector lengths at boot
      arm64/sme: Implement sysctl to set the default vector length
      arm64/sme: Implement vector length configuration prctl()s
      arm64/sme: Implement support for TPIDR2
      arm64/sme: Implement SVCR context switching
      arm64/sme: Implement streaming SVE context switching
      arm64/sme: Implement ZA context switching
      arm64/sme: Implement traps and syscall handling for SME
      arm64/sme: Disable ZA and streaming mode when handling signals
      arm64/sme: Implement streaming SVE signal handling
      arm64/sme: Implement ZA signal handling
      arm64/sme: Implement ptrace support for streaming mode SVE registers
      arm64/sme: Add ptrace support for ZA
      arm64/sme: Disable streaming mode and ZA when flushing CPU state
      arm64/sme: Save and restore streaming mode over EFI runtime calls
      KVM: arm64: Hide SME system registers from guests
      KVM: arm64: Trap SME usage in guest
      KVM: arm64: Handle SME host state when running guests
      arm64/sme: Provide Kconfig for SME
      arm64/sme: Add ID_AA64SMFR0_EL1 to __read_sysreg_by_encoding()

Oliver Upton (21):
      KVM: arm64: Return a bool from emulate_cp()
      KVM: arm64: Don't write to Rt unless sys_reg emulation succeeds
      KVM: arm64: Wire up CP15 feature registers to their AArch64 equivalents
      KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
      KVM: arm64: Start trapping ID registers for 32 bit guests
      selftests: KVM: Rename psci_cpu_on_test to psci_test
      selftests: KVM: Create helper for making SMCCC calls
      KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
      KVM: arm64: Dedupe vCPU power off helpers
      KVM: arm64: Track vCPU power state using MP state values
      KVM: arm64: Rename the KVM_REQ_SLEEP handler
      KVM: arm64: Return a value from check_vcpu_requests()
      KVM: arm64: Add support for userspace to suspend a vCPU
      KVM: arm64: Implement PSCI SYSTEM_SUSPEND
      selftests: KVM: Rename psci_cpu_on_test to psci_test
      selftests: KVM: Create helper for making SMCCC calls
      selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
      selftests: KVM: Refactor psci_test to make it amenable to new tests
      selftests: KVM: Test SYSTEM_SUSPEND PSCI call
      KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
      KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE

Raghavendra Rao Ananta (9):
      KVM: arm64: Factor out firmware register handling from psci.c
      KVM: arm64: Setup a framework for hypercall bitmap firmware registers
      KVM: arm64: Add standard hypervisor firmware register
      KVM: arm64: Add vendor hypervisor firmware register
      Docs: KVM: Rename psci.rst to hypercalls.rst
      Docs: KVM: Add doc for the bitmap firmware registers
      tools: Import ARM SMCCC definitions
      selftests: KVM: aarch64: Introduce hypercall ABI test
      selftests: KVM: aarch64: Add the bitmap firmware registers to get-reg-list

Randy Dunlap (1):
      KVM: arm64: nvhe: Eliminate kernel-doc warnings

Ricardo Koller (4):
      KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
      KVM: arm64: vgic: Add more checks when restoring ITS tables
      KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
      KVM: arm64: vgic: Undo work in failed ITS restores

Stephen Rothwell (1):
      Documentation: KVM: Fix title level for PSCI_SUSPEND

Wan Jiabing (1):
      arm64/sme: Fix NULL check after kzalloc

 Documentation/arm64/cpu-feature-registers.rst      |   2 +
 Documentation/arm64/elf_hwcaps.rst                 |  37 ++
 Documentation/arm64/index.rst                      |   1 +
 Documentation/arm64/sme.rst                        | 428 +++++++++++++++
 Documentation/arm64/sve.rst                        |  70 ++-
 Documentation/virt/kvm/api.rst                     |  94 +++-
 Documentation/virt/kvm/arm/hypercalls.rst          | 138 +++++
 Documentation/virt/kvm/arm/index.rst               |   2 +-
 Documentation/virt/kvm/arm/psci.rst                |  77 ---
 arch/arm64/Kconfig                                 |  11 +
 arch/arm64/include/asm/barrier.h                   |   4 +
 arch/arm64/include/asm/cpu.h                       |   4 +
 arch/arm64/include/asm/cpufeature.h                |  24 +
 arch/arm64/include/asm/cputype.h                   |   8 +
 arch/arm64/include/asm/el2_setup.h                 |  64 ++-
 arch/arm64/include/asm/esr.h                       |  21 +-
 arch/arm64/include/asm/exception.h                 |   1 +
 arch/arm64/include/asm/fpsimd.h                    | 123 ++++-
 arch/arm64/include/asm/fpsimdmacros.h              |  87 +++
 arch/arm64/include/asm/hwcap.h                     |   9 +
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_asm.h                   |   1 +
 arch/arm64/include/asm/kvm_emulate.h               |   7 -
 arch/arm64/include/asm/kvm_host.h                  |  45 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   3 +
 arch/arm64/include/asm/processor.h                 |  26 +-
 arch/arm64/include/asm/sysreg.h                    |  67 +++
 arch/arm64/include/asm/thread_info.h               |   2 +
 arch/arm64/include/uapi/asm/hwcap.h                |   9 +
 arch/arm64/include/uapi/asm/kvm.h                  |  34 ++
 arch/arm64/include/uapi/asm/ptrace.h               |  69 ++-
 arch/arm64/include/uapi/asm/sigcontext.h           |  55 +-
 arch/arm64/kernel/cpufeature.c                     | 120 +++++
 arch/arm64/kernel/cpuinfo.c                        |  14 +
 arch/arm64/kernel/entry-common.c                   |  11 +
 arch/arm64/kernel/entry-fpsimd.S                   |  36 ++
 arch/arm64/kernel/fpsimd.c                         | 585 +++++++++++++++++++--
 arch/arm64/kernel/process.c                        |  44 +-
 arch/arm64/kernel/ptrace.c                         | 358 +++++++++++--
 arch/arm64/kernel/signal.c                         | 188 ++++++-
 arch/arm64/kernel/syscall.c                        |  29 +-
 arch/arm64/kernel/traps.c                          |   1 +
 arch/arm64/kvm/Makefile                            |   4 +-
 arch/arm64/kvm/arch_timer.c                        |  47 +-
 arch/arm64/kvm/arm.c                               | 158 +++++-
 arch/arm64/kvm/fpsimd.c                            |  43 +-
 arch/arm64/kvm/guest.c                             |  10 +-
 arch/arm64/kvm/handle_exit.c                       |  49 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |   6 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |  32 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  18 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |  78 ++-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  31 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  87 +--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   3 -
 arch/arm64/kvm/hyp/vhe/switch.c                    |  11 +-
 arch/arm64/kvm/hypercalls.c                        | 327 +++++++++++-
 arch/arm64/kvm/mmu.c                               |  68 ++-
 arch/arm64/kvm/pmu-emul.c                          |   3 +-
 arch/arm64/kvm/pmu.c                               |  40 +-
 arch/arm64/kvm/psci.c                              | 248 ++-------
 arch/arm64/kvm/sys_regs.c                          | 305 ++++++++---
 arch/arm64/kvm/sys_regs.h                          |   9 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   7 +-
 arch/arm64/kvm/vgic/vgic-its.c                     | 160 ++++--
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |  18 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 | 125 ++++-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   4 +
 arch/arm64/kvm/vgic/vgic.h                         |  10 +
 arch/arm64/lib/delay.c                             |  12 +-
 arch/arm64/tools/cpucaps                           |   3 +
 include/kvm/arm_arch_timer.h                       |   2 -
 include/kvm/arm_hypercalls.h                       |   8 +
 include/kvm/arm_pmu.h                              |  34 +-
 include/kvm/arm_psci.h                             |   7 -
 include/kvm/arm_vgic.h                             |   8 +-
 include/linux/irqchip/arm-gic-v3.h                 |   2 +
 include/uapi/linux/elf.h                           |   2 +
 include/uapi/linux/kvm.h                           |   4 +
 include/uapi/linux/prctl.h                         |   9 +
 kernel/sys.c                                       |  12 +
 scripts/kallsyms.c                                 |   3 +-
 tools/include/linux/arm-smccc.h                    | 193 +++++++
 tools/testing/selftests/kvm/.gitignore             |   3 +-
 tools/testing/selftests/kvm/Makefile               |   3 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |   8 +
 tools/testing/selftests/kvm/aarch64/hypercalls.c   | 336 ++++++++++++
 .../selftests/kvm/aarch64/psci_cpu_on_test.c       | 121 -----
 tools/testing/selftests/kvm/aarch64/psci_test.c    | 213 ++++++++
 .../selftests/kvm/include/aarch64/processor.h      |  22 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  25 +
 tools/testing/selftests/kvm/steal_time.c           |  13 +-
 92 files changed, 4949 insertions(+), 908 deletions(-)
 create mode 100644 Documentation/arm64/sme.rst
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
 delete mode 100644 Documentation/virt/kvm/arm/psci.rst
 create mode 100644 tools/include/linux/arm-smccc.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c
