Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA842EF5B9
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 17:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbhAHQaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 11:30:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbhAHQaW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Jan 2021 11:30:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610123335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=S8FoM+RpRgtpip5lz5oEOsceIPoTtMA/todm6XH5iAs=;
        b=WN+si0Kma2CJgFYAB3FJOvfNzMpSNQxf4XBr0EaS0U8RXSsVpObednpcHMOkXzJCtN2y2x
        B7fs3y2pQU93Mqq+LmLbxxARvkaDZ4v1A7q7XlBMt4aL7s4qGB11GwfdIC603uSemrsm5h
        nkNLIzpStFz8uB96zX81AeevXF2Tuu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-5xcr-r1tMDOhWtfWYCq-zQ-1; Fri, 08 Jan 2021 11:28:51 -0500
X-MC-Unique: 5xcr-r1tMDOhWtfWYCq-zQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D5938030A2;
        Fri,  8 Jan 2021 16:28:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E17CD5C8AA;
        Fri,  8 Jan 2021 16:28:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.11-rc3
Date:   Fri,  8 Jan 2021 11:28:49 -0500
Message-Id: <20210108162849.49465-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit d45f89f7437d0f2c8275b4434096164db106384d:

  KVM: SVM: fix 32-bit compilation (2020-12-16 13:08:21 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 872f36eb0b0f4f0e3a81ea1e51a6bdf58ccfdc6e:

  KVM: x86: __kvm_vcpu_halt can be static (2021-01-08 05:54:44 -0500)

----------------------------------------------------------------
x86:
* Fixes for the new scalable MMU
* Fixes for migration of nested hypervisors on AMD
* Fix for clang integrated assembler
* Fix for left shift by 64 (UBSAN)
* Small cleanups
* Straggler SEV-ES patch

ARM:
* VM init cleanups
* PSCI relay cleanups
* Kill CONFIG_KVM_ARM_PMU
* Fixup __init annotations
* Fixup reg_to_encoding()
* Fix spurious PMCR_EL0 access

* selftests cleanups

----------------------------------------------------------------
Alexandru Elisei (5):
      KVM: Documentation: Add arm64 KVM_RUN error codes
      KVM: arm64: arch_timer: Remove VGIC initialization check
      KVM: arm64: Move double-checked lock to kvm_vgic_map_resources()
      KVM: arm64: Update comment in kvm_vgic_map_resources()
      KVM: arm64: Remove redundant call to kvm_pmu_vcpu_reset()

Andrew Jones (3):
      KVM: selftests: Factor out guest mode code
      KVM: selftests: Use vm_create_with_vcpus in create_vm
      KVM: selftests: Implement perf_test_util more conventionally

Ben Gardon (2):
      KVM: x86/mmu: Ensure TDP MMU roots are freed after yield
      KVM: x86/mmu: Clarify TDP MMU page list invariants

David Brazdil (6):
      KVM: arm64: Prevent use of invalid PSCI v0.1 function IDs
      KVM: arm64: Use lm_alias in nVHE-only VA conversion
      KVM: arm64: Skip computing hyp VA layout for VHE
      KVM: arm64: Minor cleanup of hyp variables used in host
      KVM: arm64: Remove unused includes in psci-relay.c
      KVM: arm64: Move skip_host_instruction to adjust_pc.h

Lai Jiangshan (1):
      kvm: check tlbs_dirty directly

Marc Zyngier (6):
      KVM: arm64: Don't access PMCR_EL0 when no PMU is available
      KVM: arm64: Declutter host PSCI 0.1 handling
      KVM: arm64: Consolidate dist->ready setting into kvm_vgic_map_resources()
      KVM: arm64: Fix hyp_cpu_pm_{init,exit} __init annotation
      KVM: arm64: Remove spurious semicolon in reg_to_encoding()
      KVM: arm64: Replace KVM_ARM_PMU with HW_PERF_EVENTS

Maxim Levitsky (3):
      KVM: nSVM: correctly restore nested_run_pending on migration
      KVM: nSVM: mark vmcb as dirty when forcingly leaving the guest mode
      KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit

Nathan Chancellor (1):
      KVM: SVM: Add register operand to vmsave call in sev_es_vcpu_load

Paolo Bonzini (4):
      Merge branch 'kvm-master' into kvm-next
      KVM: x86: fix shift out of bounds reported by UBSAN
      Merge tag 'kvmarm-fixes-5.11-1' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      KVM: x86: __kvm_vcpu_halt can be static

Sean Christopherson (5):
      KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()
      KVM: x86/mmu: Get root level from walkers when retrieving MMIO SPTE
      KVM: x86/mmu: Use raw level to index into MMIO walks' sptes array
      KVM: x86/mmu: Optimize not-present/MMIO SPTE check in get_mmio_spte()
      MAINTAINERS: Really update email address for Sean Christopherson

Shannon Zhao (1):
      arm64: cpufeature: remove non-exist CONFIG_KVM_ARM_HOST

Stephen Zhang (1):
      KVM: x86: change in pv_eoi_get_pending() to make code more readable

Tom Lendacky (1):
      KVM: SVM: Add support for booting APs in an SEV-ES guest

Uros Bizjak (1):
      KVM/SVM: Remove leftover __svm_vcpu_run prototype from svm.c

 Documentation/virt/kvm/api.rst                     |   9 +-
 MAINTAINERS                                        |   2 +-
 arch/arm64/include/asm/kvm_host.h                  |  23 +++
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kernel/smp.c                            |   2 +-
 arch/arm64/kvm/Kconfig                             |   8 -
 arch/arm64/kvm/Makefile                            |   2 +-
 arch/arm64/kvm/arch_timer.c                        |   7 +-
 arch/arm64/kvm/arm.c                               |  32 ++--
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h         |   9 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c                  |   6 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |  59 +++-----
 arch/arm64/kvm/pmu-emul.c                          |   2 -
 arch/arm64/kvm/sys_regs.c                          |   6 +-
 arch/arm64/kvm/va_layout.c                         |   7 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  11 +-
 arch/arm64/kvm/vgic/vgic-v2.c                      |  20 +--
 arch/arm64/kvm/vgic/vgic-v3.c                      |  21 +--
 arch/x86/include/asm/kvm_host.h                    |  19 ++-
 arch/x86/kvm/lapic.c                               |   4 +-
 arch/x86/kvm/mmu.h                                 |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  53 ++++---
 arch/x86/kvm/mmu/tdp_mmu.c                         | 113 +++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h                         |   4 +-
 arch/x86/kvm/svm/nested.c                          |   8 +
 arch/x86/kvm/svm/sev.c                             |  24 ++-
 arch/x86/kvm/svm/svm.c                             |  12 +-
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/kvm/vmx/nested.c                          |   2 +
 arch/x86/kvm/vmx/vmx.c                             |   2 +
 arch/x86/kvm/x86.c                                 |  30 +++-
 include/kvm/arm_pmu.h                              |   2 +-
 include/uapi/linux/kvm.h                           |   2 +
 tools/testing/selftests/kvm/Makefile               |   2 +-
 tools/testing/selftests/kvm/demand_paging_test.c   | 118 ++++-----------
 tools/testing/selftests/kvm/dirty_log_perf_test.c  | 145 ++++++------------
 tools/testing/selftests/kvm/dirty_log_test.c       | 125 +++++----------
 tools/testing/selftests/kvm/include/guest_modes.h  |  21 +++
 tools/testing/selftests/kvm/include/kvm_util.h     |   9 ++
 .../testing/selftests/kvm/include/perf_test_util.h | 167 ++-------------------
 tools/testing/selftests/kvm/lib/guest_modes.c      |  70 +++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   9 +-
 tools/testing/selftests/kvm/lib/perf_test_util.c   | 134 +++++++++++++++++
 virt/kvm/kvm_main.c                                |   3 +-
 45 files changed, 667 insertions(+), 655 deletions(-)

