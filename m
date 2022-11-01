Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB081614C87
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiKAOZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiKAOZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:25:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D49DF0D
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667312675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tpOFLxTe7Kkz8qL3oBROQ/GDsicH22WhCPfmidi/qs8=;
        b=i9FxLZ1mF0v8TBM6VssRvGv2PNjm09lrrmoshpbaIWSL/Etu4L2xCVILUqvAd4KEyK1yL7
        eftHzz3Yb2uXr/RsvpI9HMI+tXyYSZ0WNNG/+PYqGjRBWu+T77KF2utK4Imv6kPNUkxflC
        LAcVFKEzB/24NweZ3CCCwF2SCZd2+v0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-cAdY8F_7PISEopyP4aGXWA-1; Tue, 01 Nov 2022 10:24:32 -0400
X-MC-Unique: cAdY8F_7PISEopyP4aGXWA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 003C1857F90;
        Tue,  1 Nov 2022 14:24:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D80382028DC1;
        Tue,  1 Nov 2022 14:24:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 6.1-rc4
Date:   Tue,  1 Nov 2022 10:24:31 -0400
Message-Id: <20221101142431.3635848-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9aec606c1609a5da177b579475a73f6c948e034a:

  tools: include: sync include/api/linux/kvm.h (2022-10-22 07:54:19 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 7353633814f6e5b4899fb9ee1483709d6bb0e1cd:

  KVM: x86/xen: Fix eventfd error handling in kvm_xen_eventfd_assign() (2022-10-28 06:47:26 -0400)

----------------------------------------------------------------
x86:

- fix lock initialization race in gfn-to-pfn cache (+selftests)

- fix two refcounting errors

- emulator fixes

- mask off reserved bits in CPUID

- fix bug with disabling SGX

RISC-V:

- update MAINTAINERS

----------------------------------------------------------------
Eiichi Tsukata (1):
      KVM: x86/xen: Fix eventfd error handling in kvm_xen_eventfd_assign()

Emanuele Giuseppe Esposito (1):
      KVM: VMX: fully disable SGX if SECONDARY_EXEC_ENCLS_EXITING unavailable

Hou Wenlong (2):
      KVM: x86: Reduce refcount if single_open() fails in kvm_mmu_rmaps_stat_open()
      KVM: debugfs: Return retval of simple_attr_open() if it fails

Jim Mattson (5):
      KVM: x86: Mask off reserved bits in CPUID.80000001H
      KVM: x86: Mask off reserved bits in CPUID.80000006H
      KVM: x86: Mask off reserved bits in CPUID.80000008H
      KVM: x86: Mask off reserved bits in CPUID.8000001AH
      KVM: x86: Mask off reserved bits in CPUID.8000001FH

Maxim Levitsky (5):
      KVM: x86: emulator: em_sysexit should update ctxt->mode
      KVM: x86: emulator: introduce emulator_recalc_and_set_mode
      KVM: x86: emulator: update the emulation mode after rsm
      KVM: x86: emulator: update the emulation mode after CR0 write
      KVM: x86: smm: number of GPRs in the SMRAM image depends on the image format

Michal Luczaj (2):
      KVM: Initialize gfn_to_pfn_cache locks in dedicated helper
      KVM: selftests: Add tests in xen_shinfo_test to detect lock races

Palmer Dabbelt (1):
      MAINTAINERS: git://github -> https://github.com for kvm-riscv

Sean Christopherson (3):
      KVM: x86: Exempt pending triple fault from event injection sanity check
      KVM: Reject attempts to consume or refresh inactive gfn_to_pfn_cache
      KVM: selftests: Mark "guest_saw_irq" as volatile in xen_shinfo_test

 MAINTAINERS                                        |   2 +-
 arch/x86/kvm/cpuid.c                               |  11 +-
 arch/x86/kvm/debugfs.c                             |   7 +-
 arch/x86/kvm/emulate.c                             | 108 +++++++++++-----
 arch/x86/kvm/vmx/vmx.c                             |   5 +
 arch/x86/kvm/x86.c                                 |  27 +++-
 arch/x86/kvm/xen.c                                 |  64 +++++-----
 include/linux/kvm_host.h                           |  24 +++-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 142 ++++++++++++++++++++-
 virt/kvm/kvm_main.c                                |  13 +-
 virt/kvm/pfncache.c                                |  62 ++++++---
 11 files changed, 362 insertions(+), 103 deletions(-)

