Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828FD4F0047
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354236AbiDBKDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 06:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354232AbiDBKDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 06:03:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE09A154702
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 03:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648893703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LYm+0CN57sQSjMfbJWHKtXLX0EOoFZkZWVWS7mzLOeA=;
        b=UYbeZxqG652KIS5klhiu/hPbMnuAoeVrUNeEYrLkOs+o6DVYmxMOVHs0ulku74v4zOGY+B
        ARj+5Iiblla/A0YN7dasImaKm8HrXjvvVDnrW0I871an8LRrQPXBjjb3Kh9W/m1Uzty2qQ
        iY456GMmLEfBbC42A1Q0r7JrOxcCMpU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-R6-uAnFGP_GvO8V4GOIgLA-1; Sat, 02 Apr 2022 06:01:40 -0400
X-MC-Unique: R6-uAnFGP_GvO8V4GOIgLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F9FC3806708;
        Sat,  2 Apr 2022 10:01:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11A94112C063;
        Sat,  2 Apr 2022 10:01:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes and docs for Linux 5.18 merge window
Date:   Sat,  2 Apr 2022 06:01:39 -0400
Message-Id: <20220402100139.207620-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit c9b8fecddb5bb4b67e351bbaeaa648a6f7456912:

  KVM: use kvcalloc for array allocations (2022-03-21 09:28:41 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c15e0ae42c8e5a61e9aca8aac920517cf7b3e94e:

  KVM: x86: fix sending PV IPI (2022-04-02 05:37:27 -0400)

----------------------------------------------------------------
* Only do MSR filtering for MSRs accessed by rdmsr/wrmsr

* Documentation improvements

* Prevent module exit until all VMs are freed

* PMU Virtualization fixes

* Fix for kvm_irq_delivery_to_apic_fast() NULL-pointer dereferences

* Other miscellaneous bugfixes

----------------------------------------------------------------
David Matlack (2):
      KVM: Prevent module exit until all VMs are freed
      Revert "KVM: set owner of cpu and vm file operations"

David Woodhouse (2):
      KVM: avoid double put_page with gfn-to-pfn cache
      KVM: Remove dirty handling from gfn_to_pfn_cache completely

Hou Wenlong (2):
      KVM: x86/emulator: Emulate RDPID only if it is enabled in guest
      KVM: x86: Only do MSR filtering when access MSR by rdmsr/wrmsr

Jim Mattson (2):
      KVM: x86/pmu: Use different raw event masks for AMD and Intel
      KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Lai Jiangshan (4):
      KVM: X86: Change the type of access u32 to u64
      KVM: X86: Fix comments in update_permission_bitmask
      KVM: X86: Rename variable smap to not_smap in permission_fault()
      KVM: X86: Handle implicit supervisor access with SMAP

Li RongQing (1):
      KVM: x86: fix sending PV IPI

Like Xu (1):
      KVM: x86/pmu: Fix and isolate TSX-specific performance event logic

Maxim Levitsky (5):
      KVM: x86: mmu: trace kvm_mmu_set_spte after the new SPTE was set
      KVM: x86: SVM: fix avic spec based definitions again
      KVM: x86: SVM: move tsc ratio definitions to svm.h
      kvm: x86: SVM: remove unused defines
      KVM: x86: SVM: fix tsc scaling when the host doesn't support it

Nathan Chancellor (1):
      KVM: x86: Fix clang -Wimplicit-fallthrough in do_host_cpuid()

Paolo Bonzini (9):
      Documentation: kvm: fixes for locking.rst
      Documentation: kvm: include new locks
      Documentation: KVM: add separate directories for architecture-specific documentation
      Documentation: KVM: add virtual CPU errata documentation
      Documentation: KVM: add API issues section
      KVM: MMU: propagate alloc_workqueue failure
      KVM: x86: document limitations of MSR filtering
      KVM: MIPS: remove reference to trap&emulate virtualization
      KVM: x86/mmu: do compare-and-exchange of gPTE via the user address

Peter Gonda (1):
      KVM: SVM: Fix kvm_cache_regs.h inclusions for is_guest_mode()

Sean Christopherson (6):
      KVM: x86/mmu: Zap only TDP MMU leafs in zap range and mmu_notifier unmap
      KVM: Don't actually set a request when evicting vCPUs for GFN cache invd
      KVM: Use enum to track if cached PFN will be used in guest and/or host
      KVM: x86: Make APICv inhibit reasons an enum and cleanup naming
      KVM: x86: Add wrappers for setting/clearing APICv inhibits
      KVM: x86: Trace all APICv inhibit changes and capture overall status

Vitaly Kuznetsov (3):
      KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
      KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()
      KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated

Yi Wang (1):
      KVM: SVM: fix panic on out-of-bounds guest IRQ

Zhenzhong Duan (2):
      KVM: x86: cleanup enter_rmode()
      KVM: x86: Remove redundant vm_entry_controls_clearbit() call

 Documentation/virt/kvm/api.rst                     |  61 +++++++-
 Documentation/virt/kvm/index.rst                   |  26 +---
 Documentation/virt/kvm/locking.rst                 |  43 ++++--
 Documentation/virt/kvm/s390/index.rst              |  12 ++
 Documentation/virt/kvm/{ => s390}/s390-diag.rst    |   0
 Documentation/virt/kvm/{ => s390}/s390-pv-boot.rst |   0
 Documentation/virt/kvm/{ => s390}/s390-pv.rst      |   0
 Documentation/virt/kvm/vcpu-requests.rst           |  10 ++
 .../virt/kvm/{ => x86}/amd-memory-encryption.rst   |   0
 Documentation/virt/kvm/{ => x86}/cpuid.rst         |   0
 Documentation/virt/kvm/x86/errata.rst              |  39 +++++
 Documentation/virt/kvm/{ => x86}/halt-polling.rst  |   0
 Documentation/virt/kvm/{ => x86}/hypercalls.rst    |   0
 Documentation/virt/kvm/x86/index.rst               |  19 +++
 Documentation/virt/kvm/{ => x86}/mmu.rst           |   0
 Documentation/virt/kvm/{ => x86}/msr.rst           |   0
 Documentation/virt/kvm/{ => x86}/nested-vmx.rst    |   0
 .../virt/kvm/{ => x86}/running-nested-guests.rst   |   0
 Documentation/virt/kvm/{ => x86}/timekeeping.rst   |   0
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/x86/include/asm/kvm_host.h                    |  46 ++++--
 arch/x86/include/asm/svm.h                         |  14 +-
 arch/x86/kernel/kvm.c                              |   2 +-
 arch/x86/kvm/cpuid.c                               |   1 +
 arch/x86/kvm/emulate.c                             |   8 +-
 arch/x86/kvm/hyperv.c                              |  22 ++-
 arch/x86/kvm/i8254.c                               |   6 +-
 arch/x86/kvm/kvm_emulate.h                         |   3 +
 arch/x86/kvm/lapic.c                               |   4 +
 arch/x86/kvm/mmu.h                                 |  32 ++--
 arch/x86/kvm/mmu/mmu.c                             |  27 ++--
 arch/x86/kvm/mmu/paging_tmpl.h                     |  82 +++++------
 arch/x86/kvm/mmu/tdp_mmu.c                         |  72 ++++-----
 arch/x86/kvm/mmu/tdp_mmu.h                         |  12 +-
 arch/x86/kvm/pmu.c                                 |  18 +--
 arch/x86/kvm/svm/avic.c                            |  14 +-
 arch/x86/kvm/svm/pmu.c                             |   9 +-
 arch/x86/kvm/svm/svm.c                             |  36 ++---
 arch/x86/kvm/svm/svm.h                             |  15 +-
 arch/x86/kvm/svm/svm_onhyperv.c                    |   1 -
 arch/x86/kvm/trace.h                               |  22 +--
 arch/x86/kvm/vmx/pmu_intel.c                       |  14 +-
 arch/x86/kvm/vmx/vmx.c                             |  26 ++--
 arch/x86/kvm/x86.c                                 | 161 +++++++++++++--------
 arch/x86/kvm/xen.c                                 |   7 +-
 include/linux/kvm_host.h                           |  60 +++++---
 include/linux/kvm_types.h                          |  11 +-
 virt/kvm/kvm_main.c                                |  22 ++-
 virt/kvm/pfncache.c                                |  72 ++++-----
 49 files changed, 617 insertions(+), 414 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/index.rst
 rename Documentation/virt/kvm/{ => s390}/s390-diag.rst (100%)
 rename Documentation/virt/kvm/{ => s390}/s390-pv-boot.rst (100%)
 rename Documentation/virt/kvm/{ => s390}/s390-pv.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/amd-memory-encryption.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/cpuid.rst (100%)
 create mode 100644 Documentation/virt/kvm/x86/errata.rst
 rename Documentation/virt/kvm/{ => x86}/halt-polling.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/hypercalls.rst (100%)
 create mode 100644 Documentation/virt/kvm/x86/index.rst
 rename Documentation/virt/kvm/{ => x86}/mmu.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/msr.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/nested-vmx.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/running-nested-guests.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/timekeeping.rst (100%)

