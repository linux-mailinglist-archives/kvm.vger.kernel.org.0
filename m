Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843CE44EF03
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 23:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhKLWGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 17:06:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234266AbhKLWGN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 17:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636754601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aHecVeHqCvAtGHYXk6Nr/Lq6X6UdkK02UVclA5l2QwU=;
        b=Yw4zvIPNN+hd8mNiyR8qcjEzo91kkzf38OVoKLdyXG2AShqs7NVlt6FnJxj8GS6yRMZ13r
        uJnFtTjQrwI5s+WAfGYYr6JyjKwT9rYcbP1haLwOo97QwS8TvGnz0WgACUZYd0A3IEc3nW
        NgQ3gL4I+IxfG2+MQDVXWHNB3RKh+a0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-d0ZG5qS7NwOr-8O_bHKLHg-1; Fri, 12 Nov 2021 17:03:18 -0500
X-MC-Unique: d0ZG5qS7NwOr-8O_bHKLHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B592875109;
        Fri, 12 Nov 2021 22:03:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B02185D9D3;
        Fri, 12 Nov 2021 22:03:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 5.16 merge window
Date:   Fri, 12 Nov 2021 17:03:15 -0500
Message-Id: <20211112220315.3995734-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit debe436e77c72fcee804fb867f275e6d31aa999c:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2021-11-10 17:05:37 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 84886c262ebcfa40751ed508268457af8a20c1aa:

  Merge tag 'kvmarm-fixes-5.16-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2021-11-12 16:01:55 -0500)

----------------------------------------------------------------
New x86 features:

* Guest API and guest kernel support for SEV live migration

* SEV and SEV-ES intra-host migration

Bugfixes and cleanups for x86:

* Fix misuse of gfn-to-pfn cache when recording guest steal time / preempted status

* Fix selftests on APICv machines

* Fix sparse warnings

* Fix detection of KVM features in CPUID

* Cleanups for bogus writes to MSR_KVM_PV_EOI_EN

* Fixes and cleanups for MSR bitmap handling

* Cleanups for INVPCID

* Make x86 KVM_SOFT_MAX_VCPUS consistent with other architectures

Bugfixes for ARM:

* Fix finalization of host stage2 mappings

* Tighten the return value of kvm_vcpu_preferred_target()

* Make sure the extraction of ESR_ELx.EC is limited to architected bits

----------------------------------------------------------------
Ashish Kalra (3):
      EFI: Introduce the new AMD Memory Encryption GUID.
      x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
      x86/kvm: Add kexec support for SEV Live Migration.

Brijesh Singh (2):
      x86/kvm: Add AMD SEV specific Hypercall3
      mm: x86: Invoke hypercall when page encryption status is changed

David Woodhouse (1):
      KVM: x86: Fix recording of guest steal time / preempted status

Jim Mattson (1):
      kvm: x86: Convert return type of *is_valid_rdpmc_ecx() to bool

Junaid Shahid (1):
      kvm: mmu: Use fast PF path for access tracking of huge pages when possible

Mark Rutland (1):
      KVM: arm64: Extract ESR_ELx.EC only

Maxim Levitsky (1):
      KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ active

Paolo Bonzini (8):
      Merge branch 'kvm-guest-sev-migration' into kvm-master
      KVM: generalize "bugged" VM to "dead" VM
      KVM: SEV: provide helpers to charge/uncharge misc_cg
      Merge branch 'kvm-sev-move-context' into kvm-master
      Merge branch 'kvm-5.16-fixes' into kvm-master
      KVM: x86: move guest_pv_has out of user_access section
      KVM: SEV: unify cgroup cleanup code for svm_vm_migrate_from
      Merge tag 'kvmarm-fixes-5.16-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master

Paul Durrant (1):
      KVM: x86: Make sure KVM_CPUID_FEATURES really are KVM_CPUID_FEATURES

Peter Gonda (5):
      KVM: SEV: Refactor out sev_es_state struct
      KVM: SEV: Add support for SEV intra host migration
      KVM: SEV: Add support for SEV-ES intra host migration
      selftest: KVM: Add open sev dev helper
      selftest: KVM: Add intra host migration tests

Quentin Perret (1):
      KVM: arm64: Fix host stage-2 finalization

Randy Dunlap (1):
      KVM: arm64: nvhe: Fix a non-kernel-doc comment

Sean Christopherson (6):
      KVM: x86/mmu: Properly dereference rcu-protected TDP MMU sptep iterator
      KVM: x86: Add helper to consolidate core logic of SET_CPUID{2} flows
      KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in use
      KVM: nVMX: Handle dynamic MSR intercept toggling
      KVM: VMX: Macrofy the MSR bitmap getters and setters
      KVM: nVMX: Clean up x2APIC MSR handling for L2

Vipin Sharma (2):
      KVM: VMX: Add a helper function to retrieve the GPR index for INVPCID, INVVPID, and INVEPT
      KVM: Move INVPCID type check from vmx and svm to the common kvm_handle_invpcid()

Vitaly Kuznetsov (3):
      KVM: x86: Rename kvm_lapic_enable_pv_eoi()
      KVM: x86: Don't update vcpu->arch.pv_eoi.msr_val when a bogus value was written to MSR_KVM_PV_EOI_EN
      KVM: x86: Drop arbitrary KVM_SOFT_MAX_VCPUS

YueHaibing (1):
      KVM: arm64: Change the return type of kvm_vcpu_preferred_target()

 Documentation/virt/kvm/api.rst                     |  14 +
 arch/arm64/include/asm/esr.h                       |   1 +
 arch/arm64/include/asm/kvm_host.h                  |   2 +-
 arch/arm64/kvm/arm.c                               |   5 +-
 arch/arm64/kvm/guest.c                             |   7 +-
 arch/arm64/kvm/hyp/hyp-entry.S                     |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  14 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   6 +-
 arch/x86/include/asm/kvm_para.h                    |  12 +
 arch/x86/include/asm/mem_encrypt.h                 |   4 +
 arch/x86/include/asm/paravirt.h                    |   6 +
 arch/x86/include/asm/paravirt_types.h              |   1 +
 arch/x86/include/asm/processor.h                   |   5 +-
 arch/x86/include/asm/set_memory.h                  |   1 +
 arch/x86/include/uapi/asm/kvm_para.h               |   1 +
 arch/x86/kernel/kvm.c                              | 109 +++++++-
 arch/x86/kernel/paravirt.c                         |   1 +
 arch/x86/kvm/cpuid.c                               |  93 +++++--
 arch/x86/kvm/hyperv.c                              |   4 +-
 arch/x86/kvm/lapic.c                               |  23 +-
 arch/x86/kvm/lapic.h                               |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  10 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   2 +-
 arch/x86/kvm/pmu.c                                 |   2 +-
 arch/x86/kvm/pmu.h                                 |   4 +-
 arch/x86/kvm/svm/avic.c                            |   3 +-
 arch/x86/kvm/svm/pmu.c                             |   5 +-
 arch/x86/kvm/svm/sev.c                             | 299 +++++++++++++++++----
 arch/x86/kvm/svm/svm.c                             |  14 +-
 arch/x86/kvm/svm/svm.h                             |  28 +-
 arch/x86/kvm/vmx/nested.c                          | 166 +++++-------
 arch/x86/kvm/vmx/pmu_intel.c                       |   7 +-
 arch/x86/kvm/vmx/vmx.c                             |  73 +----
 arch/x86/kvm/vmx/vmx.h                             |  33 +++
 arch/x86/kvm/x86.c                                 | 147 +++++++---
 arch/x86/mm/mem_encrypt.c                          |  72 ++++-
 arch/x86/mm/pat/set_memory.c                       |   6 +
 include/linux/efi.h                                |   1 +
 include/linux/kvm_host.h                           |  12 +-
 include/uapi/linux/kvm.h                           |   1 +
 tools/testing/selftests/kvm/Makefile               |   3 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h        |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  24 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |  13 +
 .../selftests/kvm/x86_64/sev_migrate_tests.c       | 203 ++++++++++++++
 virt/kvm/kvm_main.c                                |  10 +-
 49 files changed, 1088 insertions(+), 370 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c

