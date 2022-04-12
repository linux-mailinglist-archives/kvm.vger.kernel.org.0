Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605714FE6CD
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358106AbiDLR3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358093AbiDLR3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:29:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 216DC532D0
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649784414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s4Lt1xewNBZXG5/FcRdJnajbH6pCOsyU2JZpMOz87cw=;
        b=gG3PkEmt1i/ce95cDtm5qPS4aGhuSMStE9uV80/WspddVLhamM7vB3uYcPLRAkVN3D4DrA
        ypci2MrWyzHJsIKEAq4s18Dc5YswV2Ru1zlrm5a//9/IkIyRYHoINNdIKuirgZwHRAcmzG
        D7imjTZMJ6W8EUWqhCVzWARNTC4mirM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-mgW3sfY1NaOkHJZKbxySFA-1; Tue, 12 Apr 2022 13:26:49 -0400
X-MC-Unique: mgW3sfY1NaOkHJZKbxySFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7B303C01B90;
        Tue, 12 Apr 2022 17:26:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AB6E40D0160;
        Tue, 12 Apr 2022 17:26:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.18-rc3
Date:   Tue, 12 Apr 2022 13:26:48 -0400
Message-Id: <20220412172648.1060942-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 42dcbe7d8bac997eef4c379e61d9121a15ed4e36:

  KVM: x86: hyper-v: Avoid writing to TSC page without an active vCPU (2022-04-11 13:29:51 -0400)

----------------------------------------------------------------
x86:

* Miscellaneous bugfixes

* A small cleanup for the new workqueue code

* Documentation syntax fix

RISC-V:

* Remove hgatp zeroing in kvm_arch_vcpu_put()

* Fix alignment of the guest_hang() in KVM selftest

* Fix PTE A and D bits in KVM selftest

* Missing #include in vcpu_fp.c

ARM:

* Some PSCI fixes after introducing PSCIv1.1 and SYSTEM_RESET2

* Fix the MMU write-lock not being taken on THP split

* Fix mixed-width VM handling

* Fix potential UAF when debugfs registration fails

* Various selftest updates for all of the above

----------------------------------------------------------------
Andrew Jones (1):
      KVM: selftests: get-reg-list: Add KVM_REG_ARM_FW_REG(3)

Anup Patel (3):
      RISC-V: KVM: Don't clear hgatp CSR in kvm_arch_vcpu_put()
      KVM: selftests: riscv: Set PTE A and D bits in VS-stage page table
      KVM: selftests: riscv: Fix alignment of the guest_hang() function

Bagas Sanjaya (1):
      Documentation: kvm: Add missing line break in api.rst

Heiko Stuebner (1):
      RISC-V: KVM: include missing hwcap.h into vcpu_fp

Like Xu (2):
      selftests: kvm: add tsc_scaling_sync to .gitignore
      Documentation: KVM: Add SPDX-License-Identifier tag

Lv Ruyi (1):
      KVM: x86/mmu: remove unnecessary flush_workqueue()

Oliver Upton (7):
      KVM: arm64: Generally disallow SMC64 for AArch32 guests
      KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
      KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler
      KVM: arm64: Don't split hugepages outside of MMU write lock
      KVM: Don't create VM debugfs files outside of the VM directory
      selftests: KVM: Don't leak GIC FD across dirty log test iterations
      selftests: KVM: Free the GIC FD when cleaning up in arch_timer

Paolo Bonzini (3):
      KVM: avoid NULL pointer dereference in kvm_dirty_ring_push
      Merge tag 'kvmarm-fixes-5.18-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-fixes-5.18-1' of https://github.com/kvm-riscv/linux into HEAD

Peter Gonda (1):
      KVM: SEV: Add cond_resched() to loop in sev_clflush_pages()

Reiji Watanabe (2):
      KVM: arm64: mixed-width check should be skipped for uninitialized vCPUs
      KVM: arm64: selftests: Introduce vcpu_width_config

Sean Christopherson (1):
      KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded

Suravee Suthikulpanit (1):
      KVM: SVM: Do not activate AVIC for SEV-enabled guest

Vitaly Kuznetsov (1):
      KVM: x86: hyper-v: Avoid writing to TSC page without an active vCPU

Yu Zhe (1):
      KVM: arm64: vgic: Remove unnecessary type castings

 Documentation/virt/kvm/api.rst                     |   1 +
 Documentation/virt/kvm/vcpu-requests.rst           |   2 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |   2 +
 Documentation/virt/kvm/x86/errata.rst              |   2 +-
 .../virt/kvm/x86/running-nested-guests.rst         |   2 +
 arch/arm64/include/asm/kvm_emulate.h               |  27 +++--
 arch/arm64/include/asm/kvm_host.h                  |  10 ++
 arch/arm64/kvm/mmu.c                               |  11 +-
 arch/arm64/kvm/psci.c                              |  31 +++---
 arch/arm64/kvm/reset.c                             |  65 +++++++----
 arch/arm64/kvm/vgic/vgic-debug.c                   |  10 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   2 +-
 arch/riscv/kvm/vcpu.c                              |   2 -
 arch/riscv/kvm/vcpu_fp.c                           |   1 +
 arch/x86/include/asm/kvm_host.h                    |  10 +-
 arch/x86/kvm/hyperv.c                              |  40 ++-----
 arch/x86/kvm/hyperv.h                              |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  20 +++-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   2 +-
 arch/x86/kvm/svm/avic.c                            |   3 +-
 arch/x86/kvm/svm/sev.c                             |   3 +
 arch/x86/kvm/x86.c                                 |  27 ++++-
 tools/testing/selftests/kvm/.gitignore             |   2 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  15 ++-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  14 ++-
 .../selftests/kvm/aarch64/vcpu_width_config.c      | 122 +++++++++++++++++++++
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  34 +++++-
 .../selftests/kvm/include/riscv/processor.h        |   4 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   2 +-
 virt/kvm/kvm_main.c                                |  12 +-
 31 files changed, 357 insertions(+), 124 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c

