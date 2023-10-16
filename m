Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DFC7CB6B7
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 00:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjJPWv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 18:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbjJPWv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 18:51:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99370EB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 15:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697496642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VENdWJ/1K/LhZn05aMbcDMWsUZa2DzjCrYdCwNyN6Jk=;
        b=SU4wQx3DbHg4e55vfjVAf4+3ERquFHtkjeRHeGhTP7g5wzV4HU/Mct9iR4T1tButjeLWni
        j15h15wFZDjCoz5FOK9rc3NT60lO/rRURvr0eZZ/Sx08/s7UzQu6OKFogEJfZhldNQU/s2
        uS61MAz2JCBDHChoJ1TT9m30vPmy/3o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-DeF4ZF5lOd6b04SejMqsSA-1; Mon, 16 Oct 2023 18:50:39 -0400
X-MC-Unique: DeF4ZF5lOd6b04SejMqsSA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC9478E8C64;
        Mon, 16 Oct 2023 22:50:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DEC1492BFA;
        Mon, 16 Oct 2023 22:50:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.6-rc7
Date:   Mon, 16 Oct 2023 18:50:38 -0400
Message-Id: <20231016225038.2829334-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 401644852d0b2a278811de38081be23f74b5bb04:

  Merge tag 'fs_for_v6.6-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs (2023-10-11 14:21:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2b3f2325e71f09098723727d665e2e8003d455dc:

  Merge tag 'kvm-x86-selftests-6.6-fixes' of https://github.com/kvm-x86/linux into HEAD (2023-10-15 08:25:18 -0400)

----------------------------------------------------------------
ARM:

- Fix the handling of the phycal timer offset when FEAT_ECV
  and CNTPOFF_EL2 are implemented.

- Restore the functionnality of Permission Indirection that
  was broken by the Fine Grained Trapping rework

- Cleanup some PMU event sharing code

MIPS:

- Fix W=1 build.

s390:

- One small fix for gisa to avoid stalls.

x86:

- Truncate writes to PMU counters to the counter's width to avoid spurious
  overflows when emulating counter events in software.

- Set the LVTPC entry mask bit when handling a PMI (to match Intel-defined
  architectural behavior).

- Treat KVM_REQ_PMI as a wake event instead of queueing host IRQ work to
  kick the guest out of emulated halt.

- Fix for loading XSAVE state from an old kernel into a new one.

- Fixes for AMD AVIC

selftests:

- Play nice with %llx when formatting guest printf and assert statements.

- Clean up stale test metadata.

- Zero-initialize structures in memslot perf test to workaround a suspected
  "may be used uninitialized" false positives from GCC.

----------------------------------------------------------------
Anshuman Khandual (1):
      KVM: arm64: pmu: Drop redundant check for non-NULL kvm_pmu_events

Jim Mattson (2):
      KVM: x86: Mask LVTPC when handling a PMI
      KVM: x86/pmu: Synthesize at most one PMI per VM-exit

Joey Gouly (2):
      KVM: arm64: Add nPIR{E0}_EL1 to HFG traps
      KVM: arm64: POR{E0}_EL1 do not need trap handlers

Like Xu (1):
      KVM: selftests: Remove obsolete and incorrect test case metadata

Marc Zyngier (1):
      KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2

Maxim Levitsky (3):
      x86: KVM: SVM: always update the x2avic msr interception
      x86: KVM: SVM: add support for Invalid IPI Vector interception
      x86: KVM: SVM: refresh AVIC inhibition in svm_leave_nested()

Michael Mueller (1):
      KVM: s390: fix gisa destroy operation might lead to cpu stalls

Paolo Bonzini (5):
      Merge tag 'kvm-s390-master-6.6-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      KVM: MIPS: fix -Wunused-but-set-variable warning
      Merge tag 'kvmarm-fixes-6.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-pmu-6.6-fixes' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.6-fixes' of https://github.com/kvm-x86/linux into HEAD

Roman Kagan (1):
      KVM: x86/pmu: Truncate counter value to allowed width on write

Sean Christopherson (7):
      KVM: selftests: Treat %llx like %lx when formatting guest printf
      KVM: selftests: Zero-initialize entire test_result in memslot perf test
      x86/fpu: Allow caller to constrain xfeatures when copying to uabi buffer
      KVM: x86: Constrain guest-supported xfeatures only at KVM_GET_XSAVE{2}
      KVM: selftests: Touch relevant XSAVE state in guest for state test
      KVM: selftests: Load XSAVE state into untouched vCPU during state test
      KVM: selftests: Force load all supported XSAVE state in state test

Tom Lendacky (1):
      KVM: SVM: Fix build error when using -Werror=unused-but-set-variable

 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/kvm/arch_timer.c                        |  13 +--
 arch/arm64/kvm/emulate-nested.c                    |   2 +
 arch/arm64/kvm/hyp/vhe/switch.c                    |  44 +++++++++
 arch/arm64/kvm/pmu.c                               |   4 +-
 arch/arm64/kvm/sys_regs.c                          |   4 +-
 arch/mips/kvm/mmu.c                                |   3 +-
 arch/s390/kvm/interrupt.c                          |  16 ++-
 arch/x86/include/asm/fpu/api.h                     |   3 +-
 arch/x86/include/asm/kvm_host.h                    |   1 -
 arch/x86/include/asm/svm.h                         |   1 +
 arch/x86/kernel/fpu/core.c                         |   5 +-
 arch/x86/kernel/fpu/xstate.c                       |  12 +--
 arch/x86/kernel/fpu/xstate.h                       |   3 +-
 arch/x86/kvm/cpuid.c                               |   8 --
 arch/x86/kvm/lapic.c                               |   8 +-
 arch/x86/kvm/pmu.c                                 |  27 +----
 arch/x86/kvm/pmu.h                                 |   6 ++
 arch/x86/kvm/svm/avic.c                            |   5 +-
 arch/x86/kvm/svm/nested.c                          |   3 +
 arch/x86/kvm/svm/pmu.c                             |   2 +-
 arch/x86/kvm/svm/svm.c                             |   5 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   4 +-
 arch/x86/kvm/x86.c                                 |  40 +++++---
 include/kvm/arm_arch_timer.h                       |   7 ++
 tools/testing/selftests/kvm/include/ucall_common.h |   2 -
 .../selftests/kvm/include/x86_64/processor.h       |  23 +++++
 tools/testing/selftests/kvm/lib/guest_sprintf.c    |   7 ++
 tools/testing/selftests/kvm/lib/x86_64/apic.c      |   2 -
 tools/testing/selftests/kvm/memslot_perf_test.c    |   9 +-
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |   2 -
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |   2 -
 .../selftests/kvm/x86_64/nx_huge_pages_test.sh     |   1 -
 tools/testing/selftests/kvm/x86_64/state_test.c    | 110 ++++++++++++++++++++-
 .../selftests/kvm/x86_64/tsc_scaling_sync.c        |   4 -
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |   4 -
 36 files changed, 276 insertions(+), 120 deletions(-)

