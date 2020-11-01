Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E688C2A1CD5
	for <lists+kvm@lfdr.de>; Sun,  1 Nov 2020 10:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgKAJYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 04:24:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbgKAJYd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 1 Nov 2020 04:24:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604222671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WlKpkrMPpM4b9Gdg8EmfsYDmclv1MRjoL1qgiPjBPKo=;
        b=e7JbKM9SxP9gEFxp37GA5626sZNr0E1cz7gBkMGXGO7i1y2AE1AjmbUtVLRmxIK8ZM38RV
        UHR5QuZE4aPuPvLGFfAed1YIY20nvbaxAcPLwo2z4v2I0ncBKNXuIEL8iI5PKNY6aJEFc1
        N9URnAOzi/Y6Zs5NcnLvreC21l1br6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-3DjQcdowMcu3IqaopbTLDg-1; Sun, 01 Nov 2020 04:24:29 -0500
X-MC-Unique: 3DjQcdowMcu3IqaopbTLDg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7EF01006C88;
        Sun,  1 Nov 2020 09:24:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 554D56EF77;
        Sun,  1 Nov 2020 09:24:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.10-rc2
Date:   Sun,  1 Nov 2020 04:24:27 -0500
Message-Id: <20201101092427.3999755-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec:

  Linux 5.10-rc1 (2020-10-25 15:14:11 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9478dec3b5e79a1431e2e2b911e32e52a11c6320:

  KVM: vmx: remove unused variable (2020-10-31 11:38:43 -0400)

----------------------------------------------------------------
ARM:
* selftest fix
* Force PTE mapping on device pages provided via VFIO
* Fix detection of cacheable mapping at S2
* Fallback to PMD/PTE mappings for composite huge pages
* Fix accounting of Stage-2 PGD allocation
* Fix AArch32 handling of some of the debug registers
* Simplify host HYP entry
* Fix stray pointer conversion on nVHE TLB invalidation
* Fix initialization of the nVHE code
* Simplify handling of capabilities exposed to HYP
* Nuke VCPUs caught using a forbidden AArch32 EL0

x86:
* new nested virtualization selftest
* Miscellaneous fixes
* make W=1 fixes
* Reserve new CPUID bit in the KVM leaves

----------------------------------------------------------------
Andrew Jones (1):
      KVM: selftests: Don't require THP to run tests

David Woodhouse (1):
      x86/kvm: Reserve KVM_FEATURE_MSI_EXT_DEST_ID

Gavin Shan (1):
      KVM: arm64: Use fallback mapping sizes for contiguous huge page sizes

Jim Mattson (1):
      KVM: selftests: test behavior of unmapped L2 APIC-access address

Marc Zyngier (4):
      KVM: arm64: Don't corrupt tpidr_el2 on failed HVC call
      KVM: arm64: Remove leftover kern_hyp_va() in nVHE TLB invalidation
      KVM: arm64: Drop useless PAN setting on host EL1 to EL2 transition
      KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and DBGVCR

Mark Rutland (3):
      KVM: arm64: Factor out is_{vhe,nvhe}_hyp_code()
      arm64: cpufeature: reorder cpus_have_{const, final}_cap()
      arm64: cpufeature: upgrade hyp caps to final

Paolo Bonzini (3):
      Merge tag 'kvmarm-fixes-5.10-1' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      KVM: x86: replace static const variables with macros
      KVM: vmx: remove unused variable

Qais Yousef (1):
      KVM: arm64: Handle Asymmetric AArch32 systems

Santosh Shukla (1):
      KVM: arm64: Force PTE mapping on fault resulting in a device mapping

Takashi Iwai (1):
      KVM: x86: Fix NULL dereference at kvm_msr_ignored_check()

Vitaly Kuznetsov (1):
      KVM: VMX: eVMCS: make evmcs_sanitize_exec_ctrls() work again

Will Deacon (2):
      KVM: arm64: Allocate stage-2 pgd pages with GFP_KERNEL_ACCOUNT
      KVM: arm64: Fix masks in stage2_pte_cacheable()

 Documentation/virt/kvm/cpuid.rst                   |   4 +
 arch/arm64/include/asm/cpufeature.h                |  40 ++++--
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/include/asm/virt.h                      |   9 +-
 arch/arm64/kernel/image-vars.h                     |   1 -
 arch/arm64/kvm/arm.c                               |  19 +++
 arch/arm64/kvm/hyp/nvhe/host.S                     |   2 -
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |  23 +++-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |   1 -
 arch/arm64/kvm/hyp/pgtable.c                       |   4 +-
 arch/arm64/kvm/mmu.c                               |  27 +++-
 arch/arm64/kvm/sys_regs.c                          |   6 +-
 arch/x86/include/uapi/asm/kvm_para.h               |   1 +
 arch/x86/kvm/mmu/mmu.c                             |  10 +-
 arch/x86/kvm/mmu/spte.c                            |  16 +--
 arch/x86/kvm/mmu/spte.h                            |  16 +--
 arch/x86/kvm/vmx/evmcs.c                           |   3 +-
 arch/x86/kvm/vmx/evmcs.h                           |   3 +-
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/kvm/x86.c                                 |   8 +-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  23 +++-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |   9 ++
 .../selftests/kvm/x86_64/vmx_apic_access_test.c    | 142 +++++++++++++++++++++
 26 files changed, 306 insertions(+), 76 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c

