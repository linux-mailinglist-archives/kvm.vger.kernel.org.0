Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A4E57658F
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 19:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiGOQ7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 12:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235134AbiGOQ7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 12:59:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7B684199F
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657904359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vfDWRpNN3ne55fkFR/lVuehQG9VFjVLVsyg99HNZrAk=;
        b=NljX6OvzzuuYCqOyC8WDMqPoKLrDqhQa2FPcNc4b0rzQmtyVonAAmaY8eTn91ofQxbJIt7
        uU7w9NAsrVu4v/p2TCMauvDn/cHEdiB1d16cWMAVkGIB1lnJZyIC4AR+2IPKZCjjSE901V
        K43HB1AVQifO7Tak8bJW15O+RTAfL3I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-YZWf_FxZMb6N1xF9fP3_VA-1; Fri, 15 Jul 2022 12:59:16 -0400
X-MC-Unique: YZWf_FxZMb6N1xF9fP3_VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E785299E769;
        Fri, 15 Jul 2022 16:59:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EB5040E8B08;
        Fri, 15 Jul 2022 16:59:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.19-rc7
Date:   Fri, 15 Jul 2022 12:59:15 -0400
Message-Id: <20220715165915.1464140-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 4a57a8400075bc5287c5c877702c68aeae2a033d:

  vf/remap: return the amount of bytes actually deduplicated (2022-07-13 12:08:14 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 79629181607e801c0b41b8790ac4ee2eb5d7bc3e:

  KVM: emulate: do not adjust size of fastop and setcc subroutines (2022-07-15 07:49:40 -0400)

----------------------------------------------------------------
RISC-V:

* Fix missing PAGE_PFN_MASK

* Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()

x86:

* Fix for nested virtualization when TSC scaling is active

* Estimate the size of fastcc subroutines conservatively, avoiding disastrous
  underestimation when return thunks are enabled

* Avoid possible use of uninitialized fields of 'struct kvm_lapic_irq'

Generic:

* Mark as such the boolean values available from the statistics file descriptors

* Clarify statistics documentation

----------------------------------------------------------------
Alexandre Ghiti (1):
      riscv: Fix missing PAGE_PFN_MASK

Anup Patel (1):
      RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()

Paolo Bonzini (5):
      Merge tag 'kvm-riscv-fixes-5.19-2' of https://github.com/kvm-riscv/linux into HEAD
      kvm: stats: tell userspace which values are boolean
      Documentation: kvm: clarify histogram units
      Merge commit 'kvm-vmx-nested-tsc-fix' into kvm-master
      KVM: emulate: do not adjust size of fastop and setcc subroutines

Thadeu Lima de Souza Cascardo (1):
      x86/kvm: fix FASTOP_SIZE when return thunks are enabled

Vitaly Kuznetsov (2):
      KVM: nVMX: Always enable TSC scaling for L2 when it was enabled for L1
      KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()

 Documentation/virt/kvm/api.rst      | 17 +++++++++++++----
 arch/riscv/include/asm/pgtable-64.h | 12 ++++++------
 arch/riscv/include/asm/pgtable.h    |  6 +++---
 arch/riscv/kvm/mmu.c                |  2 +-
 arch/riscv/kvm/vcpu.c               |  2 ++
 arch/x86/kvm/emulate.c              | 15 +++++++--------
 arch/x86/kvm/vmx/nested.c           |  1 -
 arch/x86/kvm/x86.c                  | 20 +++++++++++---------
 include/linux/kvm_host.h            | 11 ++++++++++-
 include/uapi/linux/kvm.h            |  1 +
 10 files changed, 54 insertions(+), 33 deletions(-)

