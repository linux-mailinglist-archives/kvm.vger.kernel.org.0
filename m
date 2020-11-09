Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28762AC553
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 20:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbgKITrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 14:47:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729871AbgKITrp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 14:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604951263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iirdq/1QAXSS1CYrhUM7nQnhEWfqB2KCd2Phwct/ZcQ=;
        b=Aq6w4iL2V/EIBBF+QFjfKDZQS+HrxjMBUG5wi2aBb70WroroSIdqv9HanpkqTqOaro9/Ru
        g0JLXdsY/N8GBVUCQ1+yHi74veLaWLauN0kACfQ+dlhPktAKfNWEUgoMHt1pkXHWBd8Ysh
        I5q30HkopvfCWRNkjPwfvTuZW3pa6KI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-8_nzRj1DMR-Q5o7iVbJLhw-1; Mon, 09 Nov 2020 14:47:41 -0500
X-MC-Unique: 8_nzRj1DMR-Q5o7iVbJLhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C45AB1074652;
        Mon,  9 Nov 2020 19:47:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EAAB5B4BB;
        Mon,  9 Nov 2020 19:47:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes and selftests for 5.10-rc4
Date:   Mon,  9 Nov 2020 14:47:39 -0500
Message-Id: <20201109194739.1035120-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9478dec3b5e79a1431e2e2b911e32e52a11c6320:

  KVM: vmx: remove unused variable (2020-10-31 11:38:43 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 6d6a18fdde8b86b919b740ad629153de432d12a8:

  KVM: selftests: allow two iterations of dirty_log_perf_test (2020-11-09 09:45:17 -0500)

----------------------------------------------------------------
ARM:
- Fix compilation error when PMD and PUD are folded
- Fix regression in reads-as-zero behaviour of ID_AA64ZFR0_EL1
- Add aarch64 get-reg-list test

x86:
- fix semantic conflict between two series merged for 5.10
- fix (and test) enforcement of paravirtual cpuid features

Generic:
- various cleanups to memory management selftests
- new selftests testcase for performance of dirty logging

----------------------------------------------------------------

In case the selftests changes are too big, I placed them on top so they
can easily be deferred to 5.11.

Thanks,

Paolo

Aaron Lewis (3):
      selftests: kvm: Fix the segment descriptor layout to match the actual layout
      selftests: kvm: Clear uc so UCALL_NONE is being properly reported
      selftests: kvm: Add exception handling to selftests

Andrew Jones (9):
      KVM: arm64: Don't hide ID registers from userspace
      KVM: arm64: Consolidate REG_HIDDEN_GUEST/USER
      KVM: arm64: Check RAZ visibility in ID register accessors
      KVM: arm64: Remove AA64ZFR0_EL1 accessors
      KVM: selftests: Add aarch64 get-reg-list test
      KVM: selftests: Add blessed SVE registers to get-reg-list
      KVM: selftests: Drop pointless vm_create wrapper
      KVM: selftests: Make the per vcpu memory size global
      KVM: selftests: Make the number of vcpus global

Ben Gardon (5):
      KVM: selftests: Factor code out of demand_paging_test
      KVM: selftests: Remove address rounding in guest code
      KVM: selftests: Simplify demand_paging_test with timespec_diff_now
      KVM: selftests: Add wrfract to common guest code
      KVM: selftests: Introduce the dirty log perf test

Gavin Shan (1):
      KVM: arm64: Fix build error in user_mem_abort()

Li RongQing (1):
      KVM: x86/mmu: fix counting of rmap entries in pte_list_add

Maxim Levitsky (1):
      KVM: x86: use positive error values for msr emulation that causes #GP

Oliver Upton (4):
      kvm: x86: reads of restricted pv msrs should also result in #GP
      kvm: x86: ensure pv_cpuid.features is initialized when enabling cap
      kvm: x86: request masterclock update any time guest uses different msr
      selftests: kvm: test enforcement of paravirtual cpuid features

Pankaj Gupta (1):
      KVM: x86: handle MSR_IA32_DEBUGCTLMSR with report_ignored_msrs

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-5.10-2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      KVM: selftests: allow two iterations of dirty_log_perf_test

Peter Xu (4):
      KVM: Documentation: Update entry for KVM_X86_SET_MSR_FILTER
      KVM: Documentation: Update entry for KVM_CAP_ENFORCE_PV_CPUID
      KVM: selftests: Always clear dirty bitmap after iteration
      KVM: selftests: Use a single binary for dirty/clear log test

 Documentation/virt/kvm/api.rst                     |   5 +-
 arch/arm64/kvm/mmu.c                               |   2 +
 arch/arm64/kvm/sys_regs.c                          | 108 +--
 arch/arm64/kvm/sys_regs.h                          |  16 +-
 arch/x86/kvm/cpuid.c                               |  23 +-
 arch/x86/kvm/cpuid.h                               |   1 +
 arch/x86/kvm/mmu/mmu.c                             |  12 +-
 arch/x86/kvm/x86.c                                 |  72 +-
 arch/x86/kvm/x86.h                                 |   8 +-
 tools/testing/selftests/kvm/.gitignore             |   4 +
 tools/testing/selftests/kvm/Makefile               |  25 +-
 .../selftests/kvm/aarch64/get-reg-list-sve.c       |   3 +
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 841 +++++++++++++++++++++
 tools/testing/selftests/kvm/clear_dirty_log_test.c |   6 -
 tools/testing/selftests/kvm/demand_paging_test.c   | 269 ++-----
 tools/testing/selftests/kvm/dirty_log_perf_test.c  | 376 +++++++++
 tools/testing/selftests/kvm/dirty_log_test.c       | 191 ++++-
 tools/testing/selftests/kvm/include/kvm_util.h     |   7 +-
 .../testing/selftests/kvm/include/perf_test_util.h | 198 +++++
 tools/testing/selftests/kvm/include/test_util.h    |   2 +
 .../selftests/kvm/include/x86_64/processor.h       |  38 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   4 +
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  67 +-
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   2 +
 tools/testing/selftests/kvm/lib/s390x/processor.c  |   4 +
 tools/testing/selftests/kvm/lib/s390x/ucall.c      |   3 +
 tools/testing/selftests/kvm/lib/test_util.c        |  22 +-
 tools/testing/selftests/kvm/lib/x86_64/handlers.S  |  81 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 146 +++-
 tools/testing/selftests/kvm/lib/x86_64/ucall.c     |   3 +
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   | 234 ++++++
 32 files changed, 2383 insertions(+), 393 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list.c
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
 create mode 100644 tools/testing/selftests/kvm/dirty_log_perf_test.c
 create mode 100644 tools/testing/selftests/kvm/include/perf_test_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c

