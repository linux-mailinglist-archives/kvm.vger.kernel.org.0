Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4396F80E8
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjEEKkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 06:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjEEKkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 06:40:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D680E18FC1
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 03:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683283157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ek5eYAkFksx+RmQ32CfQbmmrzLYB+xDBvf+YH6tHX7c=;
        b=DQtVZgnXi8XRdmy+jsRV/UwtCvzxcc1kc0o+WbJW/ep0SxxflwYba9H9V0k74QFm39SjZo
        PXOgY62jqgPUMjLpY9YSRepaXJ7+OhgjfDUWINkr6fm0bAZNFPOHKlc4il7B2bU6XpyOGI
        8hlR/nP87cSq8xfkAur6hNtsRF88f1Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-CKHLd1_5N762sfXhuMycyA-1; Fri, 05 May 2023 06:39:14 -0400
X-MC-Unique: CKHLd1_5N762sfXhuMycyA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96B3C185A7A2;
        Fri,  5 May 2023 10:39:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A36F2026DFD;
        Fri,  5 May 2023 10:39:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM patches for Linux 6.4
Date:   Fri,  5 May 2023 06:39:12 -0400
Message-Id: <20230505103912.3270597-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 1a5304fecee523060f26e2778d9d8e33c0562df3:

  Merge tag 'parisc-for-6.4-1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux (2023-05-03 19:41:59 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 7a8016d95651fecce5708ed93a24a03a9ad91c80:

  Merge tag 'kvm-s390-next-6.4-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2023-05-05 06:15:09 -0400)

This includes the 6.4 changes for RISC-V, and a few bugfix patches for
other architectures.  For x86, this closes a longstanding performance
issue in the newer and (usually) more scalable page table management code.

If you wish, you can take a look at commit d4fba4dfdcce1 to see the RISC-V
conflicts and their resolution.

----------------------------------------------------------------
RISC-V:
- ONE_REG interface to enable/disable SBI extensions
- Zbb extension for Guest/VM
- AIA CSR virtualization

x86:
- Fix a long-standing TDP MMU flaw, where unloading roots on a vCPU can
  result in the root being freed even though the root is completely valid
  and can be reused as-is (with a TLB flush).

s390:
- A couple bugfixes.

----------------------------------------------------------------
Andrew Jones (1):
      RISC-V: KVM: Alphabetize selects

Anup Patel (10):
      RISC-V: KVM: Add ONE_REG interface to enable/disable SBI extensions
      RISC-V: KVM: Allow Zbb extension for Guest/VM
      RISC-V: Add AIA related CSR defines
      RISC-V: Detect AIA CSRs from ISA string
      RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
      RISC-V: KVM: Initial skeletal support for AIA
      RISC-V: KVM: Implement subtype for CSR ONE_REG interface
      RISC-V: KVM: Add ONE_REG interface for AIA CSRs
      RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
      RISC-V: KVM: Virtualize per-HART AIA CSRs

Claudio Imbrenda (2):
      KVM: s390: pv: fix asynchronous teardown for small VMs
      KVM: s390: fix race in gmap_make_secure()

David Matlack (1):
      KVM: RISC-V: Retry fault if vma_lookup() results become invalid

Paolo Bonzini (3):
      Merge tag 'kvm-riscv-6.4-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.4-2' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-s390-next-6.4-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Sean Christopherson (1):
      KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated

 arch/riscv/include/asm/csr.h          | 107 +++++++++-
 arch/riscv/include/asm/hwcap.h        |   8 +
 arch/riscv/include/asm/kvm_aia.h      | 127 +++++++++++
 arch/riscv/include/asm/kvm_host.h     |  14 +-
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
 arch/riscv/include/uapi/asm/kvm.h     |  51 ++++-
 arch/riscv/kernel/cpu.c               |   2 +
 arch/riscv/kernel/cpufeature.c        |   2 +
 arch/riscv/kvm/Kconfig                |  10 +-
 arch/riscv/kvm/Makefile               |   1 +
 arch/riscv/kvm/aia.c                  | 388 ++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/main.c                 |  22 +-
 arch/riscv/kvm/mmu.c                  |  28 ++-
 arch/riscv/kvm/vcpu.c                 | 194 +++++++++++++----
 arch/riscv/kvm/vcpu_insn.c            |   1 +
 arch/riscv/kvm/vcpu_sbi.c             | 247 ++++++++++++++++++++--
 arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
 arch/riscv/kvm/vm.c                   |   4 +
 arch/riscv/kvm/vmid.c                 |   4 +-
 arch/s390/kernel/uv.c                 |  32 +--
 arch/s390/kvm/pv.c                    |   5 +
 arch/s390/mm/gmap.c                   |   7 +
 arch/x86/kvm/mmu/tdp_mmu.c            | 121 +++++------
 23 files changed, 1208 insertions(+), 177 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia.h
 create mode 100644 arch/riscv/kvm/aia.c

