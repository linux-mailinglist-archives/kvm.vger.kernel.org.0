Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23506652334
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbiLTOzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiLTOzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:55:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB792FA
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671548090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ko0kNgzYIZhZ7GeMVgSXuptscUvRr7VT4Xy66tEkl3E=;
        b=A3F4wz/V4WvSXoN/7aBe4O2X6sGTEsW/AUAUVKw0gvzvLZElXa0Ovs6HQDd01R5apneynJ
        FIxHgFsH8DVUIKZZgGYpvFrNCwErJAUSw6VY6z3wqmyxclmBrJV0J3zlaIA5gfaDx7HyqA
        lsw/P4esEvYJeFttlAIXx6001dXO4j4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-vgw5XObPNZOYOnHOttwghA-1; Tue, 20 Dec 2022 09:54:46 -0500
X-MC-Unique: vgw5XObPNZOYOnHOttwghA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62D4D1C25E84;
        Tue, 20 Dec 2022 14:54:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4708C112132C;
        Tue, 20 Dec 2022 14:54:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/RISC-V changes for Linux 6.2
Date:   Tue, 20 Dec 2022 09:54:45 -0500
Message-Id: <20221220145445.1221050-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 76dcd734eca23168cb008912c0f69ff408905235:

  Linux 6.1-rc8 (2022-12-04 14:48:12 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 6ebbdecff6ae00557a52539287b681641f4f0d33:

  RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and mimpid (2022-12-07 09:17:49 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.2

* Allow unloading KVM module

* Allow KVM user-space to set mvendorid, marchid, and mimpid

* Several fixes and cleanups

----------------------------------------------------------------
Anup Patel (9):
      RISC-V: KVM: Exit run-loop immediately if xfer_to_guest fails
      RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
      RISC-V: KVM: Remove redundant includes of asm/kvm_vcpu_timer.h
      RISC-V: KVM: Remove redundant includes of asm/csr.h
      RISC-V: KVM: Use switch-case in kvm_riscv_vcpu_set/get_reg()
      RISC-V: KVM: Move sbi related struct and functions to kvm_vcpu_sbi.h
      RISC-V: Export sbi_get_mvendorid() and friends
      RISC-V: KVM: Save mvendorid, marchid, and mimpid when creating VCPU
      RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and mimpid

Bo Liu (1):
      RISC-V: KVM: use vma_lookup() instead of find_vma_intersection()

Christophe JAILLET (1):
      RISC-V: KVM: Simplify kvm_arch_prepare_memory_region()

XiakaiPan (1):
      RISC-V: KVM: Add exit logic to main.c

 arch/riscv/include/asm/kvm_host.h     | 16 +++----
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  6 +++
 arch/riscv/include/uapi/asm/kvm.h     |  3 ++
 arch/riscv/kernel/sbi.c               |  3 ++
 arch/riscv/kvm/main.c                 |  6 +++
 arch/riscv/kvm/mmu.c                  |  6 +--
 arch/riscv/kvm/vcpu.c                 | 85 ++++++++++++++++++++++++++---------
 arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++---
 arch/riscv/kvm/vcpu_sbi_hsm.c         |  1 -
 arch/riscv/kvm/vcpu_sbi_replace.c     |  1 -
 arch/riscv/kvm/vcpu_sbi_v01.c         |  1 -
 11 files changed, 97 insertions(+), 44 deletions(-)

