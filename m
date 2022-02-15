Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E324B77A1
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242453AbiBORVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 12:21:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiBORVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 12:21:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 487CA13D3A
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644945694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MJAI2/i3qbUEnuzeQbgr8jJpZHjNy09muYmO+N9B76s=;
        b=MGL/KV9TQKHZVMHx+ixR03hIHeWXg2q0uklR0V8wA7luHr5Fe3LdrylolyU34dX9t+Ri7o
        cSJwnQwVzBVENlqc27fyZefeR41ZhtxXuQwK8nQAoXX+y61fmyjpicGF2p6DSZ6YN9scho
        R0SxXkRu12wg03QojXf2YQdk9Nqm79s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-1pneWBbtNsayS6Obpmgdmg-1; Tue, 15 Feb 2022 12:21:33 -0500
X-MC-Unique: 1pneWBbtNsayS6Obpmgdmg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE9071006AA0;
        Tue, 15 Feb 2022 17:21:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F9D610A4B23;
        Tue, 15 Feb 2022 17:21:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.17-rc5
Date:   Tue, 15 Feb 2022 12:21:31 -0500
Message-Id: <20220215172131.3777266-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit dfd42facf1e4ada021b939b4e19c935dcdd55566:

  Linux 5.17-rc3 (2022-02-06 12:20:50 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 710c476514313c74045c41c0571bb5178fd16e3d:

  KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW (2022-02-14 07:44:51 -0500)

----------------------------------------------------------------
ARM:

* Read HW interrupt pending state from the HW

x86:

* Don't truncate the performance event mask on AMD

* Fix Xen runstate updates to be atomic when preempting vCPU

* Fix for AMD AVIC interrupt injection race

* Several other AMD fixes

----------------------------------------------------------------
This one missed rc4 closely.

David Woodhouse (1):
      KVM: x86/xen: Fix runstate updates to be atomic when preempting vCPU

Jim Mattson (2):
      KVM: x86/pmu: Don't truncate the PerfEvtSeln MSR when creating a perf event
      KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW

Marc Zyngier (1):
      KVM: arm64: vgic: Read HW interrupt pending state from the HW

Maxim Levitsky (10):
      KVM: x86: SVM: don't passthrough SMAP/SMEP/PKE bits in !NPT && !gCR0.PG case
      KVM: x86: nSVM: fix potential NULL derefernce on nested migration
      KVM: x86: nSVM: mark vmcb01 as dirty when restoring SMM saved state
      KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM
      KVM: x86: nSVM: expose clean bit support to the guest
      KVM: x86: nSVM: deal with L1 hypervisor that intercepts interrupts but lets L2 control them
      KVM: x86: lapic: don't touch irr_pending in kvm_apic_update_apicv when inhibiting it
      KVM: x86: SVM: move avic definitions from AMD's spec to svm.h
      KVM: SVM: extract avic_ring_doorbell
      KVM: SVM: fix race between interrupt delivery and AVIC inhibition

Muhammad Usama Anjum (1):
      selftests: kvm: Remove absent target file

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-5.17-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: SVM: set IRR in svm_deliver_interrupt

Sean Christopherson (1):
      Revert "svm: Add warning message for AVIC IPI invalid target"

 arch/arm64/kvm/vgic/vgic-mmio.c      |  2 +
 arch/x86/include/asm/msr-index.h     |  1 +
 arch/x86/include/asm/svm.h           | 36 +++++++++++++
 arch/x86/kvm/lapic.c                 |  7 ++-
 arch/x86/kvm/pmu.c                   |  7 +--
 arch/x86/kvm/svm/avic.c              | 93 +++++++++-------------------------
 arch/x86/kvm/svm/nested.c            | 26 +++++-----
 arch/x86/kvm/svm/svm.c               | 85 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h               | 15 ++----
 arch/x86/kvm/vmx/vmx.c               |  1 +
 arch/x86/kvm/x86.c                   |  4 +-
 arch/x86/kvm/xen.c                   | 97 +++++++++++++++++++++++++-----------
 tools/testing/selftests/kvm/Makefile |  1 -
 13 files changed, 232 insertions(+), 143 deletions(-)

