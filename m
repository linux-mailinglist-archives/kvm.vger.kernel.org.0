Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2487D3DA68E
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 16:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhG2Oho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 10:37:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237035AbhG2Ohn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 10:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627569459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/IcxmlbvqIO6obnOTeLHYAt4yB5x0e2oIHdv+LJqJUM=;
        b=OkhRIMRlKHK38Zsu/aSvYaqQaUDBrpgbZfspkZxwNefiICkPn47HQjtAw5+78L7IK17808
        UemnsHSgbUuJrVyVlBXVYRHhB63qlMs/c1JXCMQwaaQo1WZO4PB+Wa+hWg91CnUjr5uepE
        fP2s4m30B0OPpbjJfH5CMzoeQAi2c0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-EJvzcQfnOieP2E7kCWhRMw-1; Thu, 29 Jul 2021 10:37:38 -0400
X-MC-Unique: EJvzcQfnOieP2E7kCWhRMw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15B701008060;
        Thu, 29 Jul 2021 14:37:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6ACF60864;
        Thu, 29 Jul 2021 14:37:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.14-rc4
Date:   Thu, 29 Jul 2021 10:37:36 -0400
Message-Id: <20210729143736.2012671-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 2734d6c1b1a089fb593ef6a23d4b70903526fe0c:

  Linux 5.14-rc2 (2021-07-18 14:13:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 8750f9bbda115f3f79bfe43be85551ee5e12b6ff:

  KVM: add missing compat KVM_CLEAR_DIRTY_LOG (2021-07-27 16:59:01 -0400)

----------------------------------------------------------------
ARM:

- Fix MTE shared page detection

- Enable selftest's use of PMU registers when asked to

s390:

- restore 5.13 debugfs names

x86:

- fix sizes for vcpu-id indexed arrays

- fixes for AMD virtualized LAPIC (AVIC)

- other small bugfixes

Generic:

- access tracking performance test

- dirty_log_perf_test command line parsing fix

- Fix selftest use of obsolete pthread_yield() in favour of sched_yield()

- use cpu_relax when halt polling

- fixed missing KVM_CLEAR_DIRTY_LOG compat ioctl

----------------------------------------------------------------
Andrew Jones (2):
      KVM: selftests: change pthread_yield to sched_yield
      KVM: arm64: selftests: get-reg-list: actually enable pmu regs in pmu sublist

Christian Borntraeger (1):
      KVM: s390: restore old debugfs names

David Matlack (2):
      KVM: selftests: Fix missing break in dirty_log_perf_test arg parsing
      KVM: selftests: Introduce access_tracking_perf_test

Juergen Gross (1):
      x86/kvm: fix vcpu-id indexed array sizes

Li RongQing (1):
      KVM: use cpu_relax when halt polling

Marc Zyngier (1):
      KVM: arm64: Fix detection of shared VMAs on guest fault

Mauro Carvalho Chehab (1):
      docs: virt: kvm: api.rst: replace some characters

Maxim Levitsky (3):
      KVM: SVM: svm_set_vintr don't warn if AVIC is active but is about to be deactivated
      KVM: SVM: tweak warning about enabled AVIC on nested entry
      KVM: SVM: use vmcb01 in svm_refresh_apicv_exec_ctrl

Paolo Bonzini (3):
      Merge tag 'kvmarm-fixes-5.14-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: SVM: delay svm_vcpu_init_msrpm after svm->vmcb is initialized
      KVM: add missing compat KVM_CLEAR_DIRTY_LOG

Vitaly Kuznetsov (4):
      KVM: nSVM: Rename nested_svm_vmloadsave() to svm_copy_vmloadsave_state()
      KVM: nSVM: Swap the parameter order for svm_copy_vmrun_state()/svm_copy_vmloadsave_state()
      KVM: Documentation: Fix KVM_CAP_ENFORCE_PV_FEATURE_CPUID name
      KVM: x86: Check the right feature bit for MSR_KVM_ASYNC_PF_ACK access

 Documentation/virt/kvm/api.rst                     |  30 +-
 arch/arm64/kvm/mmu.c                               |   2 +-
 arch/s390/include/asm/kvm_host.h                   |  18 +-
 arch/s390/kvm/diag.c                               |  18 +-
 arch/s390/kvm/kvm-s390.c                           |  18 +-
 arch/x86/kvm/ioapic.c                              |   2 +-
 arch/x86/kvm/ioapic.h                              |   4 +-
 arch/x86/kvm/svm/avic.c                            |   2 +-
 arch/x86/kvm/svm/nested.c                          |  10 +-
 arch/x86/kvm/svm/svm.c                             |  26 +-
 arch/x86/kvm/svm/svm.h                             |   6 +-
 arch/x86/kvm/svm/svm_onhyperv.h                    |   2 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |   3 +-
 .../selftests/kvm/access_tracking_perf_test.c      | 429 +++++++++++++++++++++
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |   1 +
 tools/testing/selftests/kvm/steal_time.c           |   2 +-
 virt/kvm/kvm_main.c                                |  29 ++
 20 files changed, 537 insertions(+), 71 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/access_tracking_perf_test.c

