Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56602658FF0
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 18:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbiL2Rey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 12:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiL2Reo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 12:34:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E27BE0B
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 09:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672335237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cSN4qRzkjG7moedM70V1xHmUGsUwaFVTnRTOfqVw+jc=;
        b=TvB3eGVP74awK4VoaIjTkxsXUJtR1hc/px1qSQ1PFUwnWgQpDS2SHVsjr7/o7wnN6Ws/g/
        X6PIxIMcwdSp4YWki9Q9+3d8rqoWuRg9ggRU1ykelZAQl4J8gLPt2avOJE/0QsCtR7GBfR
        oCvHo5K7CAGExFCLLnNwK/SBPQg4qWs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-_ftLoMbONAS1BnvIxiU_7w-1; Thu, 29 Dec 2022 12:33:55 -0500
X-MC-Unique: _ftLoMbONAS1BnvIxiU_7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44B601C07581;
        Thu, 29 Dec 2022 17:33:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26A7B53A3;
        Thu, 29 Dec 2022 17:33:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.2-rc2
Date:   Thu, 29 Dec 2022 12:33:54 -0500
Message-Id: <20221229173354.1769443-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 1b929c02afd37871d5afb9d498426f83432e71c2:

  Linux 6.2-rc1 (2022-12-25 13:41:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a5496886eb130ea08b1a5cd5c284543909bde749:

  Merge branch 'kvm-late-6.1-fixes' into HEAD (2022-12-28 07:19:14 -0500)

----------------------------------------------------------------
Changes that were posted too late for 6.1, or after the release.

x86:

* several fixes to nested VMX execution controls

* fixes and clarification to the documentation for Xen emulation

* do not unnecessarily release a pmu event with zero period

* MMU fixes

* fix Coverity warning in kvm_hv_flush_tlb()

selftests:

* fixes for the ucall mechanism in selftests

* other fixes mostly related to compilation with clang

----------------------------------------------------------------
Adamos Ttofari (1):
      KVM: x86: ioapic: Fix level-triggered EOI and userspace I/OAPIC reconfigure race

David Woodhouse (3):
      KVM: x86/xen: Use kvm_read_guest_virt() instead of open-coding it badly
      KVM: x86/xen: Add KVM_XEN_INVALID_GPA and KVM_XEN_INVALID_GFN to uapi
      KVM: x86/xen: Documentation updates and clarifications

Lai Jiangshan (2):
      kvm: Remove the unused macro KVM_MMU_READ_{,UN}LOCK()
      kvm: x86/mmu: Remove duplicated "be split" in spte.h

Like Xu (1):
      KVM: x86/pmu: Prevent zero period event from being repeatedly released

Lukas Bulwahn (1):
      MAINTAINERS: adjust entry after renaming the vmx hyperv files

Michal Luczaj (2):
      KVM: x86/xen: Fix memory leak in kvm_xen_write_hypercall_page()
      KVM: x86/xen: Simplify eventfd IOCTLs

Oliver Upton (2):
      KVM: arm64: selftests: Don't identity map the ucall MMIO hole
      KVM: selftests: Mark correct page as mapped in virt_map()

Paolo Bonzini (6):
      KVM: selftests: document the default implementation of vm_vaddr_populate_bitmap
      KVM: x86/xen: Fix SRCU/RCU usage in readers of evtchn_ports
      KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
      Documentation: kvm: clarify SRCU locking order
      KVM: selftests: restore special vmmcall code layout needed by the harness
      Merge branch 'kvm-late-6.1-fixes' into HEAD

Peng Hao (1):
      KVM: x86: Simplify kvm_apic_hw_enabled

Sean Christopherson (22):
      KVM: x86: Sanity check inputs to kvm_handle_memory_failure()
      KVM: selftests: Zero out valid_bank_mask for "all" case in Hyper-V IPI test
      KVM: nVMX: Document that ignoring memory failures for VMCLEAR is deliberate
      KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1
      KVM: nVMX: Don't stuff secondary execution control if it's not supported
      KVM: x86/mmu: Don't attempt to map leaf if target TDP MMU SPTE is frozen
      KVM: x86/mmu: Map TDP MMU leaf SPTE iff target level is reached
      KVM: x86/mmu: Re-check under lock that TDP MMU SP hugepage is disallowed
      KVM: x86/mmu: Don't install TDP MMU SPTE if SP has unexpected level
      KVM: selftests: Define literal to asm constraint in aarch64 as unsigned long
      KVM: selftests: Delete dead code in x86_64/vmx_tsc_adjust_test.c
      KVM: selftests: Fix divide-by-zero bug in memslot_perf_test
      KVM: selftests: Use pattern matching in .gitignore
      KVM: selftests: Fix a typo in x86-64's kvm_get_cpu_address_width()
      KVM: selftests: Rename UNAME_M to ARCH_DIR, fill explicitly for x86
      KVM: selftests: Use proper function prototypes in probing code
      KVM: selftests: Probe -no-pie with actual CFLAGS used to compile
      KVM: selftests: Explicitly disable builtins for mem*() overrides
      KVM: selftests: Include lib.mk before consuming $(CC)
      KVM: selftests: Disable "gnu-variable-sized-type-not-at-end" warning
      KVM: selftests: Use magic value to signal ucall_alloc() failure
      KVM: Delete extra block of "};" in the KVM API documentation

Vitaly Kuznetsov (1):
      KVM: x86: hyper-v: Fix 'using uninitialized value' Coverity warning

 Documentation/virt/kvm/api.rst                     |  46 ++++---
 Documentation/virt/kvm/locking.rst                 |  19 ++-
 MAINTAINERS                                        |   2 +-
 arch/x86/kvm/hyperv.c                              |  63 +++++----
 arch/x86/kvm/irq_comm.c                            |   5 +-
 arch/x86/kvm/lapic.h                               |   4 +-
 arch/x86/kvm/mmu/spte.h                            |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  25 +++-
 arch/x86/kvm/pmu.c                                 |   3 +-
 arch/x86/kvm/pmu.h                                 |   3 +-
 arch/x86/kvm/vmx/nested.c                          |  20 ++-
 arch/x86/kvm/vmx/vmx.c                             |   7 +
 arch/x86/kvm/x86.c                                 |   3 +
 arch/x86/kvm/xen.c                                 | 144 +++++++++++----------
 include/uapi/linux/kvm.h                           |   3 +
 tools/testing/selftests/kvm/.gitignore             |  91 +------------
 tools/testing/selftests/kvm/Makefile               |  64 ++++-----
 .../selftests/kvm/aarch64/page_fault_test.c        |   2 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |   6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  13 +-
 tools/testing/selftests/kvm/lib/ucall_common.c     |  16 ++-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   2 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |   3 +
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c    |   3 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |  13 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |   5 -
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |   6 +
 virt/kvm/kvm_mm.h                                  |   4 -
 28 files changed, 290 insertions(+), 287 deletions(-)

