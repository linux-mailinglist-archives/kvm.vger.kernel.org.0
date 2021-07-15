Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB93CA0DB
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 16:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbhGOOo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 10:44:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhGOOo4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 10:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626360123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7pcIJmX3PG+chVFQ1t6vFLhpa+n9TBg5nXXIlj2PiO4=;
        b=KX5iPY5S+ojK2XjqI2LvWuyzTT8S/GNtF8UCBcj7NvuzW2pFYtMYu/Ol0so5Txg5GqeXdZ
        ETeThzttoYV06vai0J/kGlyI7Q/YEL+lPoBWSVTBm2yUYdv0pXd8ZHra2MrY+U9QhUadJX
        SVgOf3jg3OfWUDlsZdcM6QN+B8v6KGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-TU3V0QtzOpi7WKDdyzvztA-1; Thu, 15 Jul 2021 10:42:01 -0400
X-MC-Unique: TU3V0QtzOpi7WKDdyzvztA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B94EA1023F4B;
        Thu, 15 Jul 2021 14:42:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6909960C9F;
        Thu, 15 Jul 2021 14:42:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.14-rc2
Date:   Thu, 15 Jul 2021 10:41:59 -0400
Message-Id: <20210715144159.1132260-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit b8917b4ae44d1b945f6fba3d8ee6777edb44633b:

  Merge tag 'kvmarm-5.14' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2021-06-25 11:24:24 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d951b2210c1ad2dc08345bb8d97e5a172a15261e:

  KVM: selftests: smm_test: Test SMM enter from L2 (2021-07-15 10:19:44 -0400)

----------------------------------------------------------------
* Allow again loading KVM on 32-bit non-PAE builds

* Fixes for host SMIs on AMD

* Fixes for guest SMIs on AMD

* Fixes for selftests on s390 and ARM

* Fix memory leak

* Enforce no-instrumentation area on vmentry when hardware
  breakpoints are in use.

----------------------------------------------------------------
Christian Borntraeger (2):
      KVM: selftests: introduce P44V64 for z196 and EC12
      KVM: selftests: do not require 64GB in set_memory_region_test

Kefeng Wang (1):
      KVM: mmio: Fix use-after-free Read in kvm_vm_ioctl_unregister_coalesced_mmio

Lai Jiangshan (1):
      KVM: X86: Disable hardware breakpoints unconditionally before kvm_x86->run()

Like Xu (1):
      KVM: x86/pmu: Clear anythread deprecated bit when 0xa leaf is unsupported on the SVM

Marc Zyngier (1):
      KVM: selftests: x86: Address missing vm_install_exception_handler conversions

Maxim Levitsky (3):
      KVM: SVM: #SMI interception must not skip the instruction
      KVM: SVM: remove INIT intercept handler
      KVM: SVM: add module param to control the #SMI interception

Paolo Bonzini (1):
      Merge tag 'kvm-s390-master-5.14-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Pavel Skripkin (1):
      kvm: debugfs: fix memory leak in kvm_create_vm_debugfs

Ricardo Koller (1):
      KVM: selftests: Address extra memslot parameters in vm_vaddr_alloc

Sean Christopherson (7):
      Revert "KVM: x86: WARN and reject loading KVM if NX is supported but not enabled"
      KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled
      KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR
      KVM: x86/mmu: Do not apply HPA (memory encryption) mask to GPAs
      KVM: SVM: Revert clearing of C-bit on GPA in #NPF handler
      KVM: SVM: Return -EFAULT if copy_to_user() for SEV mig packet header fails
      KVM: SVM: Fix sev_pin_memory() error checks in SEV migration utilities

Vitaly Kuznetsov (6):
      KVM: nSVM: Check the value written to MSR_VM_HSAVE_PA
      KVM: nSVM: Check that VM_HSAVE_PA MSR was set before VMRUN
      KVM: nSVM: Introduce svm_copy_vmrun_state()
      KVM: nSVM: Fix L1 state corruption upon return from SMM
      KVM: nSVM: Restore nested control upon leaving SMM
      KVM: selftests: smm_test: Test SMM enter from L2

Yu Zhang (1):
      KVM: VMX: Remove vmx_msr_index from vmx.h

 arch/x86/kvm/cpuid.c                                 | 30 +++++++++--
 arch/x86/kvm/mmu/mmu.c                               |  2 +
 arch/x86/kvm/mmu/paging.h                            | 14 +++++
 arch/x86/kvm/mmu/paging_tmpl.h                       |  4 +-
 arch/x86/kvm/mmu/spte.h                              |  6 ---
 arch/x86/kvm/svm/nested.c                            | 53 +++++++++++-------
 arch/x86/kvm/svm/sev.c                               | 14 ++---
 arch/x86/kvm/svm/svm.c                               | 77 ++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.h                               |  5 ++
 arch/x86/kvm/vmx/vmx.h                               |  2 -
 arch/x86/kvm/x86.c                                   |  8 +--
 tools/testing/selftests/kvm/include/kvm_util.h       |  3 +-
 tools/testing/selftests/kvm/lib/aarch64/processor.c  |  2 +-
 tools/testing/selftests/kvm/lib/guest_modes.c        | 16 ++++++
 tools/testing/selftests/kvm/lib/kvm_util.c           |  5 ++
 tools/testing/selftests/kvm/set_memory_region_test.c |  3 +-
 tools/testing/selftests/kvm/x86_64/hyperv_features.c |  2 +-
 tools/testing/selftests/kvm/x86_64/mmu_role_test.c   |  2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c        | 70 +++++++++++++++++++++---
 virt/kvm/coalesced_mmio.c                            |  2 +-
 virt/kvm/kvm_main.c                                  |  2 +-
 21 files changed, 258 insertions(+), 64 deletions(-)

