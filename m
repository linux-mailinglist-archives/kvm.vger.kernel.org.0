Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCCE54ABE0
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 10:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbiFNIgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 04:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239270AbiFNIf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 04:35:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EBD93DA55
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 01:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655195756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UXZdGN4B5WR+HokB4bvG7NAu5UijaXumZB4FPqVWwNc=;
        b=Kgj1WbFWpnZM8zi47xwbQUfkPI/eudaJjM4S0N2uVHrp7NI4537JEUesw9MQrt+BSC1C0Q
        YE5aY3vbhRDAfboYN/uo3Z+Kj5g8gzo6Ssw058ttxokCcwV1vi32iizCyZgUiwxC2AeepO
        GauO9GLobFkN1uh2xaO69VxBXVkzcMs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-pqy-A3KoPRuemZ1Sg9ABjw-1; Tue, 14 Jun 2022 04:35:52 -0400
X-MC-Unique: pqy-A3KoPRuemZ1Sg9ABjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D396185A7BA;
        Tue, 14 Jun 2022 08:35:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F063400DF1D;
        Tue, 14 Jun 2022 08:35:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] More KVM changes for Linux 5.19-rc3
Date:   Tue, 14 Jun 2022 04:35:52 -0400
Message-Id: <20220614083552.1559600-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6cd88243c7e03845a450795e134b488fc2afb736:

  KVM: x86: do not report a vCPU as preempted outside instruction boundaries (2022-06-08 04:21:07 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e0f3f46e42064a51573914766897b4ab95d943e3:

  KVM: selftests: Restrict test region to 48-bit physical addresses when using nested (2022-06-09 10:52:27 -0400)

While last week's pull request contained miscellaneous fixes for x86, this
one covers other architectures, selftests changes, and a bigger series
for APIC virtualization bugs that were discovered during 5.20 development.
The idea is to base 5.20 development for KVM on top of this tag.

Paolo

----------------------------------------------------------------
ARM64:

* Properly reset the SVE/SME flags on vcpu load

* Fix a vgic-v2 regression regarding accessing the pending
state of a HW interrupt from userspace (and make the code
common with vgic-v3)

* Fix access to the idreg range for protected guests

* Ignore 'kvm-arm.mode=protected' when using VHE

* Return an error from kvm_arch_init_vm() on allocation failure

* A bunch of small cleanups (comments, annotations, indentation)

RISC-V:

* Typo fix in arch/riscv/kvm/vmid.c

* Remove broken reference pattern from MAINTAINERS entry

x86-64:

* Fix error in page tables with MKTME enabled

* Dirty page tracking performance test extended to running a nested
  guest

* Disable APICv/AVIC in cases that it cannot implement correctly

----------------------------------------------------------------
David Matlack (11):
      KVM: selftests: Replace x86_page_size with PG_LEVEL_XX
      KVM: selftests: Add option to create 2M and 1G EPT mappings
      KVM: selftests: Drop stale function parameter comment for nested_map()
      KVM: selftests: Refactor nested_map() to specify target level
      KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to vmx.h
      KVM: selftests: Add a helper to check EPT/VPID capabilities
      KVM: selftests: Drop unnecessary rule for STATIC_LIBS
      KVM: selftests: Link selftests directly with lib object files
      KVM: selftests: Clean up LIBKVM files in Makefile
      KVM: selftests: Add option to run dirty_log_perf_test vCPUs in L2
      KVM: selftests: Restrict test region to 48-bit physical addresses when using nested

Julia Lawall (1):
      RISC-V: KVM: fix typos in comments

Lukas Bulwahn (1):
      MAINTAINERS: Limit KVM RISC-V entry to existing selftests

Marc Zyngier (7):
      KVM: arm64: Always start with clearing SVE flag on load
      KVM: arm64: Always start with clearing SME flag on load
      KVM: arm64: Don't read a HW interrupt pending state in user context
      KVM: arm64: Replace vgic_v3_uaccess_read_pending with vgic_uaccess_read_pending
      KVM: arm64: Warn if accessing timer pending state outside of vcpu context
      KVM: arm64: Handle all ID registers trapped for a protected VM
      KVM: arm64: Drop stale comment

Maxim Levitsky (7):
      KVM: x86: document AVIC/APICv inhibit reasons
      KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base
      KVM: x86: SVM: remove avic's broken code that updated APIC ID
      KVM: x86: SVM: fix avic_kick_target_vcpus_fast
      KVM: x86: disable preemption while updating apicv inhibition
      KVM: x86: disable preemption around the call to kvm_arch_vcpu_{un|}blocking
      KVM: x86: SVM: drop preempt-safe wrappers for avic_vcpu_load/put

Paolo Bonzini (3):
      Merge tag 'kvm-riscv-fixes-5.19-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-fixes-5.19-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: x86: SVM: fix nested PAUSE filtering when L0 intercepts PAUSE

Will Deacon (4):
      KVM: arm64: Return error from kvm_arch_init_vm() on allocation failure
      KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
      KVM: arm64: Extend comment in has_vhe()
      KVM: arm64: Remove redundant hyp_assert_lock_held() assertions

Yuan Yao (1):
      KVM: x86/mmu: Set memory encryption "value", not "mask", in shadow PDPTRs

sunliming (1):
      KVM: arm64: Fix inconsistent indenting

 Documentation/admin-guide/kernel-parameters.txt    |   1 -
 MAINTAINERS                                        |   1 -
 arch/arm64/include/asm/kvm_host.h                  |   5 -
 arch/arm64/include/asm/virt.h                      |   3 +
 arch/arm64/kernel/cpufeature.c                     |  10 +-
 arch/arm64/kvm/arch_timer.c                        |   3 +
 arch/arm64/kvm/arm.c                               |  10 +-
 arch/arm64/kvm/fpsimd.c                            |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   4 -
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |  42 ++++-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   4 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  40 +----
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  40 ++++-
 arch/arm64/kvm/vgic/vgic-mmio.h                    |   3 +
 arch/arm64/kvm/vmid.c                              |   2 +-
 arch/riscv/kvm/vmid.c                              |   2 +-
 arch/x86/include/asm/kvm_host.h                    |  67 +++++++-
 arch/x86/kvm/lapic.c                               |  27 +++-
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/svm/avic.c                            | 171 +++++++++------------
 arch/x86/kvm/svm/nested.c                          |  39 ++---
 arch/x86/kvm/svm/svm.c                             |   8 +-
 arch/x86/kvm/svm/svm.h                             |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |   4 +-
 arch/x86/kvm/x86.c                                 |   2 +
 tools/testing/selftests/kvm/Makefile               |  49 ++++--
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  10 +-
 .../testing/selftests/kvm/include/perf_test_util.h |   9 ++
 .../selftests/kvm/include/x86_64/processor.h       |  25 +--
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |   6 +
 tools/testing/selftests/kvm/lib/perf_test_util.c   |  53 ++++++-
 .../selftests/kvm/lib/x86_64/perf_test_util.c      | 112 ++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  31 ++--
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 149 +++++++++++-------
 .../testing/selftests/kvm/max_guest_memory_test.c  |   2 +-
 tools/testing/selftests/kvm/x86_64/mmu_role_test.c |   2 +-
 virt/kvm/kvm_main.c                                |   8 +-
 37 files changed, 640 insertions(+), 312 deletions(-)

