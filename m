Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C129749FA35
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 14:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbiA1NA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 08:00:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236635AbiA1NAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 08:00:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643374824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZNEPr8oQmUKQJeKIpiRO9tOqsGxy6978zb71oRUBDLY=;
        b=T1eWtFfa43Fs7XdcyGgTPyKS/6KZX1lgiFx5OJBbA3kJ6wSY4+Nh5UCANj6L2WdtA6Cs/f
        qeyMsmrY+XH4pfKhq8mplhk9AUAXnm0b7yLn2evVgZ7DcQDK6FVzex5B6YkhgmEv1ms5Tv
        T1QeDLkEZStzScAke6G70TT/73j35pw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-ynPTGkrUNlSw5bsr9gIxRQ-1; Fri, 28 Jan 2022 08:00:21 -0500
X-MC-Unique: ynPTGkrUNlSw5bsr9gIxRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31AC98144E4;
        Fri, 28 Jan 2022 13:00:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C33937B01F;
        Fri, 28 Jan 2022 13:00:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.17-rc2
Date:   Fri, 28 Jan 2022 08:00:19 -0500
Message-Id: <20220128130019.4123266-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit e2e83a73d7ce66f62c7830a85619542ef59c90e4:

  docs: kvm: fix WARNINGs from api.rst (2022-01-20 12:13:35 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 17179d0068b20413de2355f84c75a93740257e20:

  Merge tag 'kvmarm-fixes-5.17-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2022-01-28 07:45:15 -0500)

----------------------------------------------------------------
Two larger x86 series:

* Redo incorrect fix for SEV/SMAP erratum

* Windows 11 Hyper-V workaround

Other x86 changes:

* Various x86 cleanups

* Re-enable access_tracking_perf_test

* Fix for #GP handling on SVM

* Fix for CPUID leaf 0Dh in KVM_GET_SUPPORTED_CPUID

* Fix for ICEBP in interrupt shadow

* Avoid false-positive RCU splat

* Enable Enlightened MSR-Bitmap support for real

ARM:

* Correctly update the shadow register on exception injection when
running in nVHE mode

* Correctly use the mm_ops indirection when performing cache invalidation
from the page-table walker

* Restrict the vgic-v3 workaround for SEIS to the two known broken
implementations

Generic code changes:

* Dead code cleanup

There will be another pull request for ARM fixes next week, but
those patches need a bit more soak time.

----------------------------------------------------------------
David Matlack (1):
      KVM: selftests: Re-enable access_tracking_perf_test

Denis Valeev (1):
      KVM: x86: nSVM: skip eax alignment check for non-SVM instructions

Hou Wenlong (1):
      KVM: eventfd: Fix false positive RCU usage warning

Jim Mattson (1):
      KVM: VMX: Remove vmcs_config.order

Like Xu (3):
      KVM: x86/cpuid: Exclude unpermitted xfeatures sizes at KVM_GET_SUPPORTED_CPUID
      KVM: x86: Update vCPU's runtime CPUID on write to MSR_IA32_XSS
      KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any time

Marc Zyngier (3):
      KVM: arm64: pkvm: Use the mm_ops indirection for cache maintenance
      KVM: arm64: vgic-v3: Restrict SEIS workaround to known broken systems
      KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE

Paolo Bonzini (4):
      selftests: kvm: move vm_xsave_req_perm call to amx_test
      KVM: x86: add system attribute to retrieve full set of supported xsave states
      selftests: kvm: check dynamic bits against KVM_X86_XCOMP_GUEST_SUPP
      Merge tag 'kvmarm-fixes-5.17-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Peter Zijlstra (1):
      x86,kvm/xen: Remove superfluous .fixup usage

Quanfa Fu (1):
      KVM/X86: Make kvm_vcpu_reload_apic_access_page() static

Sean Christopherson (16):
      KVM: VMX: Zero host's SYSENTER_ESP iff SYSENTER is NOT used
      KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS blocking shadow
      KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests
      Revert "KVM: SVM: avoid infinite loop on NPF from bad address"
      KVM: SVM: Don't intercept #GP for SEV guests
      KVM: SVM: Explicitly require DECODEASSISTS to enable SEV support
      KVM: x86: Pass emulation type to can_emulate_instruction()
      KVM: SVM: WARN if KVM attempts emulation on #UD or #GP for SEV guests
      KVM: SVM: Inject #UD on attempted emulation for SEV guest w/o insn buffer
      KVM: SVM: Don't apply SEV+SMAP workaround on code fetch or PT access
      KVM: SVM: Don't kill SEV guest if SMAP erratum triggers in usermode
      KVM: x86: Forcibly leave nested virt when SMM state is toggled
      KVM: selftests: Don't skip L2's VMCALL in SMM test for SVM guest
      KVM: nVMX: WARN on any attempt to allocate shadow VMCS for vmcs02
      KVM: x86: Free kvm_cpuid_entry2 array on post-KVM_RUN KVM_SET_CPUID{,2}
      KVM: x86: Add a helper to retrieve userspace address from kvm_device_attr

Vitaly Kuznetsov (9):
      KVM: x86: Move CPUID.(EAX=0x12,ECX=1) mangling to __kvm_update_cpuid_runtime()
      KVM: SVM: hyper-v: Enable Enlightened MSR-Bitmap support for real
      KVM: SVM: drop unnecessary code in svm_hv_vmcb_dirty_nested_enlightenments()
      KVM: x86: Check .flags in kvm_cpuid_check_equal() too
      KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
      KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
      KVM: nVMX: Rename vmcs_to_field_offset{,_table}
      KVM: nVMX: Implement evmcs_field_offset() suitable for handle_vmread()
      KVM: nVMX: Allow VMREAD when Enlightened VMCS is in use

Wanpeng Li (1):
      KVM: LAPIC: Also cancel preemption timer during SET_LAPIC

Xianting Tian (1):
      KVM: remove async parameter of hva_to_pfn_remapped()

Xiaoyao Li (1):
      KVM: x86: Keep MSR_IA32_XSS unchanged for INIT

 Documentation/virt/kvm/api.rst                     |   4 +-
 arch/arm64/kvm/hyp/exception.c                     |   5 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  18 +--
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   3 +
 arch/arm64/kvm/vgic/vgic-v3.c                      |  17 +-
 arch/x86/include/asm/kvm_host.h                    |   5 +-
 arch/x86/include/uapi/asm/kvm.h                    |   3 +
 arch/x86/kvm/cpuid.c                               |  90 +++++++----
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/svm/nested.c                          |   9 +-
 arch/x86/kvm/svm/sev.c                             |   9 +-
 arch/x86/kvm/svm/svm.c                             | 177 ++++++++++++++-------
 arch/x86/kvm/svm/svm.h                             |   7 +-
 arch/x86/kvm/svm/svm_onhyperv.h                    |  12 +-
 arch/x86/kvm/vmx/capabilities.h                    |   1 -
 arch/x86/kvm/vmx/evmcs.c                           |   4 +-
 arch/x86/kvm/vmx/evmcs.h                           |  48 ++++--
 arch/x86/kvm/vmx/nested.c                          |  82 ++++++----
 arch/x86/kvm/vmx/vmcs12.c                          |   4 +-
 arch/x86/kvm/vmx/vmcs12.h                          |   6 +-
 arch/x86/kvm/vmx/vmx.c                             |  47 ++++--
 arch/x86/kvm/x86.c                                 |  94 +++++++++--
 arch/x86/kvm/xen.c                                 |  10 +-
 include/uapi/linux/kvm.h                           |   1 +
 tools/arch/x86/include/uapi/asm/kvm.h              |   3 +
 tools/include/uapi/linux/kvm.h                     |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../testing/selftests/kvm/include/kvm_util_base.h  |   1 -
 .../selftests/kvm/include/x86_64/processor.h       |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   7 -
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  27 +++-
 tools/testing/selftests/kvm/x86_64/amx_test.c      |   2 +
 tools/testing/selftests/kvm/x86_64/smm_test.c      |   1 -
 virt/kvm/eventfd.c                                 |   8 +-
 virt/kvm/kvm_main.c                                |   8 +-
 35 files changed, 490 insertions(+), 228 deletions(-)

