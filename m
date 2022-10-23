Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E682E609536
	for <lists+kvm@lfdr.de>; Sun, 23 Oct 2022 19:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiJWRnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 13:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJWRnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 13:43:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A786C775
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 10:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666547019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3vt+KZx63WgRri2q1BTlkYWROLUWRToSyczWPx/yZ74=;
        b=c39iViAMb4D0H3GDurZipu7pEoYiW0vVTqfaiBC+W4T1CD7rJa0QxSvWRpjS4yq1iAn4ix
        HkdFxEHdC7m9Pd1uOJLuZHC+jlbvrCfotrX3mCy9WvV28exDv7RJb+cnxvUZkoTOiNnOuH
        Zxtf6+fS8rl1BJEMd2zpTT47sonGqQE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-YCYfz7G_Pk6jI4VlTPAnNg-1; Sun, 23 Oct 2022 13:43:35 -0400
X-MC-Unique: YCYfz7G_Pk6jI4VlTPAnNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD22C38041D5;
        Sun, 23 Oct 2022 17:43:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD83739DB3;
        Sun, 23 Oct 2022 17:43:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM patches for Linux 6.1-rc2
Date:   Sun, 23 Oct 2022 13:43:07 -0400
Message-Id: <20221023174307.1868939-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9abf2313adc1ca1b6180c508c25f22f9395cc780:

  Linux 6.1-rc1 (2022-10-16 15:36:24 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9aec606c1609a5da177b579475a73f6c948e034a:

  tools: include: sync include/api/linux/kvm.h (2022-10-22 07:54:19 -0400)

----------------------------------------------------------------
RISC-V:

- Fix compilation without RISCV_ISA_ZICBOM

- Fix kvm_riscv_vcpu_timer_pending() for Sstc

ARM:

- Fix a bug preventing restoring an ITS containing mappings
  for very large and very sparse device topology

- Work around a relocation handling error when compiling
  the nVHE object with profile optimisation

- Fix for stage-2 invalidation holding the VM MMU lock
  for too long by limiting the walk to the largest
  block mapping size

- Enable stack protection and branch profiling for VHE

- Two selftest fixes

x86:

- add compat implementation for KVM_X86_SET_MSR_FILTER ioctl

selftests:

- synchronize includes between include/uapi and tools/include/uapi

----------------------------------------------------------------

As a heads up, next week I will have a relatively large pull
request in number of patches, with a series fixing various issues in
virt/kvm/pfncache.c.

Paolo

Alexander Graf (3):
      kvm: Add support for arch compat vm ioctls
      KVM: x86: Copy filter arg outside kvm_vm_ioctl_set_msr_filter()
      KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER

Andrew Jones (1):
      RISC-V: Fix compilation without RISCV_ISA_ZICBOM

Anup Patel (1):
      RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc

Denis Nikitin (1):
      KVM: arm64: nvhe: Fix build with profile optimization

Eric Ren (1):
      KVM: arm64: vgic: Fix exit condition in scan_its_table()

Gavin Shan (1):
      KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test

Oliver Upton (2):
      KVM: arm64: Work out supported block level at compile time
      KVM: arm64: Limit stage2_apply_range() batch size to largest block

Paolo Bonzini (4):
      Merge tag 'kvmarm-fixes-6.1-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvmarm-fixes-6.1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-fixes-6.1-1' of https://github.com/kvm-riscv/linux into HEAD
      tools: include: sync include/api/linux/kvm.h

Vincent Donnefort (1):
      KVM: arm64: Enable stack protection and branch profiling for VHE

Zenghui Yu (1):
      KVM: arm64: selftests: Fix multiple versions of GIC creation

 arch/arm64/include/asm/kvm_pgtable.h               | 18 +++--
 arch/arm64/include/asm/stage2_pgtable.h            | 20 -----
 arch/arm64/kvm/hyp/Makefile                        |  5 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                   |  7 ++
 arch/arm64/kvm/mmu.c                               |  9 ++-
 arch/arm64/kvm/vgic/vgic-its.c                     |  5 +-
 arch/riscv/include/asm/cacheflush.h                |  8 --
 arch/riscv/include/asm/kvm_vcpu_timer.h            |  1 +
 arch/riscv/kvm/vcpu.c                              |  3 +
 arch/riscv/kvm/vcpu_timer.c                        | 17 ++++-
 arch/riscv/mm/cacheflush.c                         | 38 ++++++++++
 arch/riscv/mm/dma-noncoherent.c                    | 41 ----------
 arch/x86/kvm/x86.c                                 | 87 ++++++++++++++++++----
 include/linux/kvm_host.h                           |  2 +
 tools/include/uapi/linux/kvm.h                     |  1 +
 tools/testing/selftests/kvm/aarch64/vgic_init.c    |  4 +-
 .../kvm/memslot_modification_stress_test.c         |  2 +-
 virt/kvm/kvm_main.c                                | 11 +++
 18 files changed, 180 insertions(+), 99 deletions(-)

