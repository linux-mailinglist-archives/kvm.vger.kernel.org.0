Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BB9C04D6
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 14:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfI0MII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 08:08:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45718 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfI0MIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 08:08:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so2416537wrm.12;
        Fri, 27 Sep 2019 05:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=z7/9s3BxxTpVOqUwSt5oErpICTF5+R9LsJXWbH8WU0Y=;
        b=T5eYcciSYy0hl1Z3CnsZPxVGZem+Tg/HkVuXzq/KvwM/AFoescyYYw6r1WB3gI/lFe
         GWcyFvru3jp/UEvNxbN/TDMDjlxejjh+vuoCqWp4UERerKMVpoEWz4YlHC39zTdo9eYD
         NC6I/kUXSWjRqFN/g8aOZZ/jGFuDmcVY4m+/LxQ5SSk896hDefx82NfIVAUcksYi6rIW
         QOXsylaw7hk7tVw6Sh/mGDFtgz4xbdYwZSo9yo6nezYWGpiLg9FYJ0Dgx4VOawdQYvi9
         dftyEs3q8F7yx+cdzlW/AmveYCSnCjWCGmvPyQbo0Jj9fEQ7ICrD3kuF/RJzT3WgMD0+
         ZCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=z7/9s3BxxTpVOqUwSt5oErpICTF5+R9LsJXWbH8WU0Y=;
        b=PKB0r5JkfPamoHyr6lmr798+HVdCAhEG3ezsVxfvIU9vYgRwQ0hIffO3w6O43cIn12
         /vc45QlghSbgAOIkEsNFZQxTd1iHiguWqzkepjWynivBG74YXwY9fAv+ZKfOVj9fD1tY
         K6RRCfo84dD7a95H0O6komUOT4OoI0q5/htZCVQhFUNNf3reH1I6G43h0XhCBT2BOESA
         u18/HO8P6p3tujxAep4Pd9HbZ3RJgFMEfWYwR7b4K3HakoJ5wHeOsUthd7GZRR1nfZls
         Doz43Lea7tK6/D1iPC7feGmCkmazkTOvr46/ECGOK58DLEWNFUU4ZrmIDqeSUbaPUAO1
         +EWA==
X-Gm-Message-State: APjAAAUpTf+lOFNQ9ji61e0lI/ui20lk8yIJ2n4Hpzuvo9jJYyHbU0Xa
        3CJEDBPPfOl96XS2qwTl9jQvBelM
X-Google-Smtp-Source: APXvYqw+xZvHs7FtPH3B/HBeRf5/Du++X8PfFvrm/lhIDVT+mM4s/DjbTVi4oRpmjBGenbqbu2SWlw==
X-Received: by 2002:adf:e612:: with SMTP id p18mr2623213wrm.218.1569586084352;
        Fri, 27 Sep 2019 05:08:04 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o188sm9540223wma.14.2019.09.27.05.08.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 05:08:03 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 5.4 merge window
Date:   Fri, 27 Sep 2019 14:08:02 +0200
Message-Id: <1569586082-13995-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 4c07e2ddab5b6b57dbcb09aedbda1f484d5940cc:

  Merge tag 'mfd-next-5.4' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd (2019-09-23 19:37:49 -0700)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to fd3edd4a9066f28de99a16685a586d68a9f551f8:

  KVM: nVMX: cleanup and fix host 64-bit mode checks (2019-09-25 19:22:33 +0200)

----------------------------------------------------------------
x86 KVM changes:
* The usual accuracy improvements for nested virtualization
* The usual round of code cleanups from Sean
* Added back optimizations that were prematurely removed in 5.2
  (the bare minimum needed to fix the regression was in 5.3-rc8,
  here comes the rest)
* Support for UMWAIT/UMONITOR/TPAUSE
* Direct L2->L0 TLB flushing when L0 is Hyper-V and L1 is KVM
* Tell Windows guests if SMT is disabled on the host
* More accurate detection of vmexit cost
* Revert a pvqspinlock pessimization

----------------------------------------------------------------
Jim Mattson (3):
      kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
      kvm: x86: Add "significant index" flag to a few CPUID leaves
      kvm: svm: Intercept RDPRU

Krish Sadhukhan (1):
      KVM: nVMX: Check Host Address Space Size on vmentry of nested guests

Marc Orr (1):
      kvm: nvmx: limit atomic switch MSRs

Paolo Bonzini (1):
      KVM: nVMX: cleanup and fix host 64-bit mode checks

Peter Xu (4):
      KVM: selftests: Move vm type into _vm_create() internally
      KVM: selftests: Create VM earlier for dirty log test
      KVM: selftests: Introduce VM_MODE_PXXV48_4K
      KVM: selftests: Remove duplicate guest mode handling

Sean Christopherson (30):
      KVM: x86: Manually flush collapsible SPTEs only when toggling flags
      KVM: x86: Relocate MMIO exit stats counting
      KVM: x86: Clean up handle_emulation_failure()
      KVM: x86: Refactor kvm_vcpu_do_singlestep() to remove out param
      KVM: x86: Don't attempt VMWare emulation on #GP with non-zero error code
      KVM: x86: Move #GP injection for VMware into x86_emulate_instruction()
      KVM: x86: Add explicit flag for forced emulation on #UD
      KVM: x86: Move #UD injection for failed emulation into emulation code
      KVM: x86: Exit to userspace on emulation skip failure
      KVM: x86: Handle emulation failure directly in kvm_task_switch()
      KVM: x86: Move triple fault request into RM int injection
      KVM: VMX: Remove EMULATE_FAIL handling in handle_invalid_guest_state()
      KVM: x86: Remove emulation_result enums, EMULATE_{DONE,FAIL,USER_EXIT}
      KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on EPT misconfig
      KVM: x86: Add comments to document various emulation types
      KVM: x86/mmu: Treat invalid shadow pages as obsolete
      KVM: x86/mmu: Use fast invalidate mechanism to zap MMIO sptes
      KVM: x86/mmu: Revert "Revert "KVM: MMU: show mmu_valid_gen in shadow page related tracepoints""
      KVM: x86/mmu: Revert "Revert "KVM: MMU: add tracepoint for kvm_mmu_invalidate_all_pages""
      KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""
      KVM: x86/mmu: Revert "Revert "KVM: MMU: collapse TLB flushes when zap all pages""
      KVM: x86/mmu: Revert "Revert "KVM: MMU: reclaim the zapped-obsolete page first""
      KVM: x86/mmu: Revert "KVM: x86/mmu: Remove is_obsolete() call"
      KVM: x86/mmu: Explicitly track only a single invalid mmu generation
      KVM: x86/mmu: Skip invalid pages during zapping iff root_count is zero
      KVM: x86: Check kvm_rebooting in kvm_spurious_fault()
      KVM: VMX: Optimize VMX instruction error and fault handling
      KVM: VMX: Add error handling to VMREAD helper
      KVM: x86: Drop ____kvm_handle_fault_on_reboot()
      KVM: x86: Don't check kvm_rebooting in __kvm_handle_fault_on_reboot()

Tao Xu (3):
      KVM: x86: Add support for user wait instructions
      KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
      KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit

Tianyu Lan (2):
      x86/Hyper-V: Fix definition of struct hv_vp_assist_page
      KVM/Hyper-V: Add new KVM capability KVM_CAP_HYPERV_DIRECT_TLBFLUSH

Vitaly Kuznetsov (8):
      KVM/Hyper-V/VMX: Add direct tlb flush support
      KVM: x86: svm: remove unneeded nested_enable_evmcs() hook
      KVM: x86: announce KVM_CAP_HYPERV_ENLIGHTENED_VMCS support only when it is available
      cpu/SMT: create and export cpu_smt_possible()
      KVM: x86: hyper-v: set NoNonArchitecturalCoreSharing CPUID bit when SMT is impossible
      KVM: selftests: hyperv_cpuid: add check for NoNonArchitecturalCoreSharing bit
      KVM: selftests: fix ucall on x86
      KVM: vmx: fix build warnings in hv_enable_direct_tlbflush() on i386

Wanpeng Li (3):
      KVM: hyperv: Fix Direct Synthetic timers assert an interrupt w/o lapic_in_kernel
      KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
      Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"

 Documentation/virt/kvm/api.txt                     |  13 +
 arch/x86/include/asm/hyperv-tlfs.h                 |  31 ++-
 arch/x86/include/asm/kvm_host.h                    |  64 +++--
 arch/x86/include/asm/svm.h                         |   1 +
 arch/x86/include/asm/vmx.h                         |   2 +
 arch/x86/include/uapi/asm/svm.h                    |   1 +
 arch/x86/include/uapi/asm/vmx.h                    |   6 +-
 arch/x86/kernel/cpu/umwait.c                       |   6 +
 arch/x86/kvm/cpuid.c                               |   8 +-
 arch/x86/kvm/hyperv.c                              |  16 +-
 arch/x86/kvm/lapic.c                               |  28 +-
 arch/x86/kvm/lapic.h                               |   1 -
 arch/x86/kvm/mmu.c                                 | 145 +++++-----
 arch/x86/kvm/mmutrace.h                            |  42 ++-
 arch/x86/kvm/svm.c                                 |  79 +++---
 arch/x86/kvm/vmx/capabilities.h                    |   6 +
 arch/x86/kvm/vmx/evmcs.h                           |   2 +
 arch/x86/kvm/vmx/nested.c                          |  70 ++++-
 arch/x86/kvm/vmx/ops.h                             |  93 ++++---
 arch/x86/kvm/vmx/vmx.c                             | 306 ++++++++++++++-------
 arch/x86/kvm/vmx/vmx.h                             |   9 +
 arch/x86/kvm/x86.c                                 | 197 ++++++++-----
 arch/x86/kvm/x86.h                                 |   2 +-
 include/linux/cpu.h                                |   2 +
 include/uapi/linux/kvm.h                           |   1 +
 kernel/cpu.c                                       |  11 +-
 kernel/locking/qspinlock_paravirt.h                |   2 +-
 tools/objtool/check.c                              |   1 -
 tools/testing/selftests/kvm/dirty_log_test.c       |  79 ++----
 tools/testing/selftests/kvm/include/kvm_util.h     |  18 +-
 .../selftests/kvm/include/x86_64/processor.h       |   3 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  67 ++++-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  30 +-
 tools/testing/selftests/kvm/lib/x86_64/ucall.c     |   2 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |  27 ++
 36 files changed, 906 insertions(+), 468 deletions(-)
