Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD69558F8A2
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 09:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiHKH4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 03:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiHKHz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 03:55:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D820312D04
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 00:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660204556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iVXrwd35fMsbVFUzhqFqFRUwBHy2TM6hy8L8OrvAwkQ=;
        b=N2Ejgm2Xge+dS7Z2sUItQXMtGvFCAasQgks6CLSIjX1neZLIXsQxTzHg/S+Ja+vDmTeXcE
        TYPTARxbG6ZCMbYtqpWgtpfXDDQmQanfjPfAENUGuvjkHCGWxNY5A+jGaQDepjdpbS0iVm
        9e7RZeJ33knkmhGepaSHFIxjQbdhZYo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-gx9w36wYO2WA-Vp_6awxnQ-1; Thu, 11 Aug 2022 03:55:55 -0400
X-MC-Unique: gx9w36wYO2WA-Vp_6awxnQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B759119705A7;
        Thu, 11 Aug 2022 07:55:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A7D140D2827;
        Thu, 11 Aug 2022 07:55:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 5.20 merge window
Date:   Thu, 11 Aug 2022 03:55:54 -0400
Message-Id: <20220811075554.198111-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6614a3c3164a5df2b54abb0b3559f51041cf705b:

  Merge tag 'mm-stable-2022-08-03' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2022-08-05 16:32:45 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 19a7cc817a380f7a412d7d76e145e9e2bc47e52f:

  KVM: x86/MMU: properly format KVM_CAP_VM_DISABLE_NX_HUGE_PAGES capability table (2022-08-11 02:35:37 -0400)

----------------------------------------------------------------
* Xen timer fixes

* Documentation formatting fixes

* Make rseq selftest compatible with glibc-2.35

* Fix handling of illegal LEA reg, reg

* Cleanup creation of debugfs entries

* Fix steal time cache handling bug

* Fixes for MMIO caching

* Optimize computation of number of LBRs

* Fix uninitialized field in guest_maxphyaddr < host_maxphyaddr path

----------------------------------------------------------------
Bagas Sanjaya (2):
      Documentation: KVM: extend KVM_CAP_VM_DISABLE_NX_HUGE_PAGES heading underline
      KVM: x86/MMU: properly format KVM_CAP_VM_DISABLE_NX_HUGE_PAGES capability table

Coleman Dietsch (2):
      KVM: x86/xen: Initialize Xen timer only once
      KVM: x86/xen: Stop Xen timer before changing IRQ

Gavin Shan (2):
      KVM: selftests: Make rseq compatible with glibc-2.35
      KVM: selftests: Use getcpu() instead of sched_getcpu() in rseq_test

Michal Luczaj (1):
      KVM: x86: emulator: Fix illegal LEA handling

Mingwei Zhang (1):
      KVM: x86/mmu: rename trace function name for asynchronous page fault

Oliver Upton (5):
      KVM: Shove vm stats_id init into kvm_create_vm()
      KVM: Shove vcpu stats_id init into kvm_vcpu_init()
      KVM: Get an fd before creating the VM
      KVM: Pass the name of the VM fd to kvm_create_vm_debugfs()
      KVM: Actually create debugfs in kvm_create_vm()

Paolo Bonzini (3):
      selftests: kvm: fix compilation
      KVM: x86: revalidate steal time cache if MSR value changes
      KVM: x86: do not report preemption if the steal time cache is stale

Sean Christopherson (9):
      KVM: x86: Bug the VM if an accelerated x2APIC trap occurs on a "bad" reg
      KVM: x86: Tag kvm_mmu_x86_module_init() with __init
      KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change
      KVM: SVM: Disable SEV-ES support if MMIO caching is disable
      KVM: x86/mmu: Add sanity check that MMIO SPTE mask doesn't overlap gen
      KVM: selftests: Test all possible "invalid" PERF_CAPABILITIES.LBR_FMT vals
      KVM: x86: Refresh PMU after writes to MSR_IA32_PERF_CAPABILITIES
      KVM: VMX: Use proper type-safe functions for vCPU => LBRs helpers
      KVM: VMX: Adjust number of LBR records for PERF_CAPABILITIES at refresh

Yu Zhang (1):
      KVM: X86: avoid uninitialized 'fault.async_page_fault' from fixed-up #PF

 Documentation/virt/kvm/api.rst                     | 10 +--
 arch/x86/include/asm/kvm_host.h                    |  2 +-
 arch/x86/kvm/emulate.c                             |  6 +-
 arch/x86/kvm/lapic.c                               |  8 ++-
 arch/x86/kvm/mmu.h                                 |  2 +
 arch/x86/kvm/mmu/mmu.c                             |  8 ++-
 arch/x86/kvm/mmu/spte.c                            | 28 ++++++++
 arch/x86/kvm/mmu/spte.h                            | 17 ++++-
 arch/x86/kvm/svm/sev.c                             | 10 +++
 arch/x86/kvm/svm/svm.c                             |  9 ++-
 arch/x86/kvm/vmx/pmu_intel.c                       | 12 +---
 arch/x86/kvm/vmx/vmx.h                             | 29 +++++---
 arch/x86/kvm/x86.c                                 | 13 ++--
 arch/x86/kvm/xen.c                                 | 31 +++++----
 include/trace/events/kvm.h                         |  2 +-
 tools/testing/selftests/kvm/Makefile               |  7 +-
 tools/testing/selftests/kvm/rseq_test.c            | 58 ++++++++--------
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       | 17 +++--
 virt/kvm/kvm_main.c                                | 81 ++++++++++++----------
 19 files changed, 221 insertions(+), 129 deletions(-)

