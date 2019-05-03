Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3D112DE0
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfECMon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:44:43 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:59972 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbfECMon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:44:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE9C4374;
        Fri,  3 May 2019 05:44:42 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94D073F220;
        Fri,  3 May 2019 05:44:39 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm updates for 5.2
Date:   Fri,  3 May 2019 13:43:31 +0100
Message-Id: <20190503124427.190206-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

This is the 5.2 pull request for KVM/arm. Pretty substential update
this time, as we finally have SVE support in guests, which makes the
bulk of the changes. Additionnaly, we have the ARMv8.3 Pointer
Authentication support for guests, and some better support for perf
modifiers.

Please pull,

	M.

The following changes since commit 8c2ffd9174779014c3fe1f96d9dc3641d9175f00:

  Linux 5.1-rc2 (2019-03-24 14:02:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v5.2

for you to fetch changes up to 9eecfc22e0bfc7a4c8ca007f083f0ae492d6e891:

  KVM: arm64: Fix ptrauth ID register masking logic (2019-05-01 17:21:51 +0100)

----------------------------------------------------------------
KVM/arm updates for 5.2

- guest SVE support
- guest Pointer Authentication support
- Better discrimination of perf counters between host and guests

----------------------------------------------------------------
Amit Daniel Kachhap (3):
      KVM: arm64: Add a vcpu flag to control ptrauth for guest
      KVM: arm64: Add userspace flag to enable pointer authentication
      KVM: arm64: Add capability to advertise ptrauth for guest

Andrew Murray (9):
      arm64: arm_pmu: Remove unnecessary isb instruction
      arm64: KVM: Encapsulate kvm_cpu_context in kvm_host_data
      arm64: KVM: Add accessors to track guest/host only counters
      arm64: arm_pmu: Add !VHE support for exclude_host/exclude_guest attributes
      arm64: KVM: Enable !VHE support for :G/:H perf event modifiers
      arm64: KVM: Enable VHE support for :G/:H perf event modifiers
      arm64: KVM: Avoid isb's by using direct pmxevtyper sysreg
      arm64: docs: Document perf event attributes
      arm64: KVM: Fix perf cycle counter support for VHE

Dave Martin (41):
      KVM: Documentation: Document arm64 core registers in detail
      arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task state flush
      KVM: arm64: Delete orphaned declaration for __fpsimd_enabled()
      KVM: arm64: Refactor kvm_arm_num_regs() for easier maintenance
      KVM: arm64: Add missing #includes to kvm_host.h
      arm64/sve: Clarify role of the VQ map maintenance functions
      arm64/sve: Check SVE virtualisability
      arm64/sve: Enable SVE state tracking for non-task contexts
      KVM: arm64: Add a vcpu flag to control SVE visibility for the guest
      KVM: arm64: Propagate vcpu into read_id_reg()
      KVM: arm64: Support runtime sysreg visibility filtering
      KVM: arm64/sve: System register context switch and access support
      KVM: arm64/sve: Context switch the SVE registers
      KVM: Allow 2048-bit register access via ioctl interface
      KVM: arm64: Add missing #include of <linux/string.h> in guest.c
      KVM: arm64: Factor out core register ID enumeration
      KVM: arm64: Reject ioctl access to FPSIMD V-regs on SVE vcpus
      KVM: arm64/sve: Add SVE support to register access ioctl interface
      KVM: arm64: Enumerate SVE register indices for KVM_GET_REG_LIST
      arm64/sve: In-kernel vector length availability query interface
      KVM: arm/arm64: Add hook for arch-specific KVM initialisation
      KVM: arm/arm64: Add KVM_ARM_VCPU_FINALIZE ioctl
      KVM: arm64/sve: Add pseudo-register for the guest's vector lengths
      KVM: arm64/sve: Allow userspace to enable SVE for vcpus
      KVM: arm64: Add a capability to advertise SVE support
      KVM: Document errors for KVM_GET_ONE_REG and KVM_SET_ONE_REG
      KVM: arm64/sve: Document KVM API extensions for SVE
      arm64/sve: Clarify vq map semantics
      KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to just set up SVE
      KVM: arm: Make vcpu finalization stubs into inline functions
      KVM: arm64/sve: sys_regs: Demote redundant vcpu_has_sve() checks to WARNs
      KVM: arm64/sve: Clean up UAPI register ID definitions
      KVM: arm64/sve: Miscellaneous tidyups in guest.c
      KVM: arm64/sve: Make register ioctl access errors more consistent
      KVM: arm64/sve: WARN when avoiding divide-by-zero in sve_reg_to_region()
      KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array sizing
      KVM: arm64/sve: Explain validity checks in set_sve_vls()
      KVM: arm/arm64: Clean up vcpu finalization function parameter naming
      KVM: Clarify capability requirements for KVM_ARM_VCPU_FINALIZE
      KVM: Clarify KVM_{SET,GET}_ONE_REG error code documentation
      KVM: arm64: Clarify access behaviour for out-of-range SVE register slice IDs

Kristina Martsenko (1):
      KVM: arm64: Fix ptrauth ID register masking logic

Marc Zyngier (1):
      arm64: KVM: Fix system register enumeration

Mark Rutland (1):
      KVM: arm/arm64: Context-switch ptrauth registers

 Documentation/arm64/perf.txt                   |  85 +++++
 Documentation/arm64/pointer-authentication.txt |  22 +-
 Documentation/virtual/kvm/api.txt              | 178 +++++++++++
 arch/arm/include/asm/kvm_emulate.h             |   2 +
 arch/arm/include/asm/kvm_host.h                |  26 +-
 arch/arm64/Kconfig                             |   6 +-
 arch/arm64/include/asm/fpsimd.h                |  29 +-
 arch/arm64/include/asm/kvm_asm.h               |   3 +-
 arch/arm64/include/asm/kvm_emulate.h           |  16 +
 arch/arm64/include/asm/kvm_host.h              | 101 +++++-
 arch/arm64/include/asm/kvm_hyp.h               |   1 -
 arch/arm64/include/asm/kvm_ptrauth.h           | 111 +++++++
 arch/arm64/include/asm/sysreg.h                |   3 +
 arch/arm64/include/uapi/asm/kvm.h              |  43 +++
 arch/arm64/kernel/asm-offsets.c                |   7 +
 arch/arm64/kernel/cpufeature.c                 |   2 +-
 arch/arm64/kernel/fpsimd.c                     | 179 +++++++----
 arch/arm64/kernel/perf_event.c                 |  50 ++-
 arch/arm64/kernel/signal.c                     |   5 -
 arch/arm64/kvm/Makefile                        |   2 +-
 arch/arm64/kvm/fpsimd.c                        |  17 +-
 arch/arm64/kvm/guest.c                         | 415 +++++++++++++++++++++++--
 arch/arm64/kvm/handle_exit.c                   |  36 ++-
 arch/arm64/kvm/hyp/entry.S                     |  15 +
 arch/arm64/kvm/hyp/switch.c                    |  80 ++++-
 arch/arm64/kvm/pmu.c                           | 239 ++++++++++++++
 arch/arm64/kvm/reset.c                         | 167 +++++++++-
 arch/arm64/kvm/sys_regs.c                      | 183 +++++++++--
 arch/arm64/kvm/sys_regs.h                      |  25 ++
 include/uapi/linux/kvm.h                       |   7 +
 virt/kvm/arm/arm.c                             |  40 ++-
 31 files changed, 1914 insertions(+), 181 deletions(-)
 create mode 100644 Documentation/arm64/perf.txt
 create mode 100644 arch/arm64/include/asm/kvm_ptrauth.h
 create mode 100644 arch/arm64/kvm/pmu.c
