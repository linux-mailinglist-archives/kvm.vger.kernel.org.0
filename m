Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA362ECEA6
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 12:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbhAGLV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 06:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbhAGLV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 06:21:58 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3407221E9;
        Thu,  7 Jan 2021 11:21:17 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kxTLv-005p1o-Sg; Thu, 07 Jan 2021 11:21:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qian Cai <qcai@redhat.com>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.11, take #1
Date:   Thu,  7 Jan 2021 11:20:43 +0000
Message-Id: <20210107112101.2297944-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com, mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com, shannon.zhao@linux.alibaba.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Happy New Year!

Here's a first set of fixes for 5.11, most of which are just
cleanups. I may have some more meaty stuff next week, but let's ease
back into it as gently as possible...

Please pull,

	M.

The following changes since commit 3a514592b698588326924625b6948a10c35fadd5:

  Merge remote-tracking branch 'origin/kvm-arm64/psci-relay' into kvmarm-master/next (2020-12-09 10:00:24 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.11-1

for you to fetch changes up to 45ba7b195a369f35cb39094fdb32efe5908b34ad:

  arm64: cpufeature: remove non-exist CONFIG_KVM_ARM_HOST (2021-01-05 13:22:07 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.11, take #1

- VM init cleanups
- PSCI relay cleanups
- Kill CONFIG_KVM_ARM_PMU
- Fixup __init annotations
- Fixup reg_to_encoding()
- Fix spurious PMCR_EL0 access

----------------------------------------------------------------
Alexandru Elisei (5):
      KVM: Documentation: Add arm64 KVM_RUN error codes
      KVM: arm64: arch_timer: Remove VGIC initialization check
      KVM: arm64: Move double-checked lock to kvm_vgic_map_resources()
      KVM: arm64: Update comment in kvm_vgic_map_resources()
      KVM: arm64: Remove redundant call to kvm_pmu_vcpu_reset()

David Brazdil (6):
      KVM: arm64: Prevent use of invalid PSCI v0.1 function IDs
      KVM: arm64: Use lm_alias in nVHE-only VA conversion
      KVM: arm64: Skip computing hyp VA layout for VHE
      KVM: arm64: Minor cleanup of hyp variables used in host
      KVM: arm64: Remove unused includes in psci-relay.c
      KVM: arm64: Move skip_host_instruction to adjust_pc.h

Marc Zyngier (6):
      KVM: arm64: Don't access PMCR_EL0 when no PMU is available
      KVM: arm64: Declutter host PSCI 0.1 handling
      KVM: arm64: Consolidate dist->ready setting into kvm_vgic_map_resources()
      KVM: arm64: Fix hyp_cpu_pm_{init,exit} __init annotation
      KVM: arm64: Remove spurious semicolon in reg_to_encoding()
      KVM: arm64: Replace KVM_ARM_PMU with HW_PERF_EVENTS

Shannon Zhao (1):
      arm64: cpufeature: remove non-exist CONFIG_KVM_ARM_HOST

 Documentation/virt/kvm/api.rst             |  9 ++++-
 arch/arm64/include/asm/kvm_host.h          | 23 ++++++++++++
 arch/arm64/kernel/cpufeature.c             |  2 +-
 arch/arm64/kernel/smp.c                    |  2 +-
 arch/arm64/kvm/Kconfig                     |  8 ----
 arch/arm64/kvm/Makefile                    |  2 +-
 arch/arm64/kvm/arch_timer.c                |  7 ++--
 arch/arm64/kvm/arm.c                       | 32 +++++++++-------
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  9 +++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 12 +-----
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c          |  6 +--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c       | 59 +++++++++++-------------------
 arch/arm64/kvm/pmu-emul.c                  |  2 -
 arch/arm64/kvm/sys_regs.c                  |  6 ++-
 arch/arm64/kvm/va_layout.c                 |  7 ++--
 arch/arm64/kvm/vgic/vgic-init.c            | 11 +++++-
 arch/arm64/kvm/vgic/vgic-v2.c              | 20 +++-------
 arch/arm64/kvm/vgic/vgic-v3.c              | 21 +++--------
 include/kvm/arm_pmu.h                      |  2 +-
 19 files changed, 122 insertions(+), 118 deletions(-)
