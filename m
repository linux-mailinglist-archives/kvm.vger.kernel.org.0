Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB59B5999F0
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 12:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348368AbiHSKeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 06:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348294AbiHSKeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 06:34:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159733C8D8
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 03:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660905239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P/N3jznfyLCTntOiEbxHqyAxgiiPB/4urlbFDpUDuCk=;
        b=cjJ/fB1tOLYzb20d6TitVuUhJOogxgBtsnaXxOBfngCF3oDsTPPxwhgzhX31Yzcw05tDQl
        ucSJ2UzxUhmCTXoL1MmqBtIZFeOpLDKZTgEk7DSLHEMDZmd+i/fttn9DhScu6AGQ5crKFI
        nSBhf2OE6o4v2rb+FueQSn3xniQipYs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-_PU-VMFbOe-W8ww7JuJ7JQ-1; Fri, 19 Aug 2022 06:33:57 -0400
X-MC-Unique: _PU-VMFbOe-W8ww7JuJ7JQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CF888032E3;
        Fri, 19 Aug 2022 10:33:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7037C492C3B;
        Fri, 19 Aug 2022 10:33:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.0-rc2
Date:   Fri, 19 Aug 2022 06:33:57 -0400
Message-Id: <20220819103357.2346708-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 959d6c4ae238b28a163b1b3741fae05391227ad9:

  Merge tag 'kvmarm-fixes-6.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2022-08-19 05:43:53 -0400)

----------------------------------------------------------------
ARM:

* Fix unexpected sign extension of KVM_ARM_DEVICE_ID_MASK

* Tidy-up handling of AArch32 on asymmetric systems

x86:

* Fix "missing ENDBR" BUG for fastop functions

Generic:

* Some cleanup and static analyzer patches

* More fixes to KVM_CREATE_VM unwind paths

----------------------------------------------------------------
Chao Peng (2):
      KVM: Rename KVM_PRIVATE_MEM_SLOTS to KVM_INTERNAL_MEM_SLOTS
      KVM: Rename mmu_notifier_* to mmu_invalidate_*

Josh Poimboeuf (3):
      x86/ibt, objtool: Add IBT_NOSEAL()
      x86/kvm: Simplify FOP_SETCC()
      x86/kvm: Fix "missing ENDBR" BUG for fastop functions

Li kunyu (2):
      KVM: Drop unnecessary initialization of "npages" in hva_to_pfn_slow()
      KVM: Drop unnecessary initialization of "ops" in kvm_ioctl_create_device()

Oliver Upton (2):
      KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
      KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

Paolo Bonzini (2):
      KVM: MIPS: remove unnecessary definition of KVM_PRIVATE_MEM_SLOTS
      Merge tag 'kvmarm-fixes-6.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Sean Christopherson (3):
      KVM: Properly unwind VM creation if creating debugfs fails
      KVM: Unconditionally get a ref to /dev/kvm module when creating a VM
      KVM: Move coalesced MMIO initialization (back) into kvm_create_vm()

Yang Yingliang (1):
      KVM: arm64: Fix compile error due to sign extension

 arch/arm64/include/asm/kvm_host.h        |  4 ++
 arch/arm64/include/uapi/asm/kvm.h        |  6 +-
 arch/arm64/kvm/arm.c                     |  3 +-
 arch/arm64/kvm/guest.c                   |  2 +-
 arch/arm64/kvm/mmu.c                     |  8 +--
 arch/arm64/kvm/sys_regs.c                |  4 +-
 arch/mips/include/asm/kvm_host.h         |  2 -
 arch/mips/kvm/mmu.c                      | 12 ++--
 arch/powerpc/include/asm/kvm_book3s_64.h |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c    |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c   |  6 +-
 arch/powerpc/kvm/book3s_hv_nested.c      |  2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |  8 +--
 arch/powerpc/kvm/e500_mmu_host.c         |  4 +-
 arch/riscv/kvm/mmu.c                     |  4 +-
 arch/x86/include/asm/ibt.h               | 11 ++++
 arch/x86/include/asm/kvm_host.h          |  2 +-
 arch/x86/kvm/emulate.c                   | 26 ++-------
 arch/x86/kvm/mmu/mmu.c                   | 14 ++---
 arch/x86/kvm/mmu/paging_tmpl.h           |  4 +-
 include/linux/kvm_host.h                 | 66 +++++++++++-----------
 tools/objtool/check.c                    |  3 +-
 virt/kvm/kvm_main.c                      | 95 ++++++++++++++++----------------
 virt/kvm/pfncache.c                      | 17 +++---
 25 files changed, 157 insertions(+), 156 deletions(-)

