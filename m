Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710E25AC3BA
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 11:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiIDJ40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 05:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiIDJ4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 05:56:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5893F33374
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 02:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662285380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jimRioD4+++SuaoJblcBl1o/gjoraYSNzOcLbvs8+DQ=;
        b=hwgctmzxf3tvQMAR/7W4de11N/UkzrTujfneZEcA4aKtOQJAmw6LyxF4VtJtje1dv1V+ru
        /lx9K0lclhG2xjAdvyKL+fKZe3GgPnTrkdkyjs4Gy+gSHaFVmsRjb0sjg76zmBXcTqVYjS
        KqZZe04Xh8cqCPUPZra9Slw3ZzHJMr8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-xna6bcvkPUOpI1hzsdyM-Q-1; Sun, 04 Sep 2022 05:56:17 -0400
X-MC-Unique: xna6bcvkPUOpI1hzsdyM-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 140E938041C0;
        Sun,  4 Sep 2022 09:56:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB99FC15BB3;
        Sun,  4 Sep 2022 09:56:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.0-rc4
Date:   Sun,  4 Sep 2022 05:56:16 -0400
Message-Id: <20220904095616.3966213-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit b90cb1053190353cc30f0fef0ef1f378ccc063c5:

  Linux 6.0-rc3 (2022-08-28 15:05:29 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 29250ba51bc1cbe8a87e923f76978b87c3247a8c:

  Merge tag 'kvm-s390-master-6.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2022-09-01 19:21:27 -0400)

----------------------------------------------------------------
s390:

* PCI interpretation compile fixes

RISC-V:

* Fix unused variable warnings in vcpu_timer.c

* Move extern sbi_ext declarations to a header

x86:

* check validity of argument to KVM_SET_MP_STATE

* use guest's global_ctrl to completely disable guest PEBS

* fix a memory leak on memory allocation failure

* mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES

* fix build failure with Clang integrated assembler

* fix MSR interception

* Always flush TLBs when enabling dirty logging

----------------------------------------------------------------
Conor Dooley (2):
      riscv: kvm: vcpu_timer: fix unused variable warnings
      riscv: kvm: move extern sbi_ext declarations to a header

David Matlack (2):
      KVM: selftests: Fix KVM_EXCEPTION_MAGIC build with Clang
      KVM: selftests: Fix ambiguous mov in KVM_ASM_SAFE()

Jim Mattson (2):
      KVM: VMX: Heed the 'msr' argument in msr_write_intercepted()
      KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES

Junaid Shahid (2):
      kvm: x86: mmu: Drop the need_remote_flush() function
      kvm: x86: mmu: Always flush TLBs when enabling dirty logging

Like Xu (1):
      perf/x86/core: Completely disable guest PEBS via guest's global_ctrl

Miaohe Lin (1):
      KVM: x86: fix memoryleak in kvm_arch_vcpu_create()

Paolo Bonzini (3):
      KVM: x86: check validity of argument to KVM_SET_MP_STATE
      Merge tag 'kvm-riscv-fixes-6.0-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-s390-master-6.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Pierre Morel (1):
      KVM: s390: pci: Hook to access KVM lowlevel from VFIO

 arch/riscv/include/asm/kvm_vcpu_sbi.h              | 12 +++
 arch/riscv/kvm/vcpu_sbi.c                          | 12 +--
 arch/riscv/kvm/vcpu_timer.c                        |  4 -
 arch/s390/include/asm/kvm_host.h                   | 17 ++--
 arch/s390/kvm/pci.c                                | 12 ++-
 arch/s390/pci/Makefile                             |  2 +-
 arch/s390/pci/pci_kvm_hook.c                       | 11 +++
 arch/x86/events/intel/core.c                       |  3 +-
 arch/x86/kvm/mmu/mmu.c                             | 60 ++------------
 arch/x86/kvm/mmu/spte.h                            | 14 +++-
 arch/x86/kvm/vmx/vmx.c                             |  3 +-
 arch/x86/kvm/x86.c                                 | 92 +++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_zdev.c                   |  8 +-
 .../selftests/kvm/include/x86_64/processor.h       |  4 +-
 14 files changed, 151 insertions(+), 103 deletions(-)
 create mode 100644 arch/s390/pci/pci_kvm_hook.c

