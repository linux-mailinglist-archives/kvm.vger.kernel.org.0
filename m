Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B5F43254A
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhJRRog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:44:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232969AbhJRRoc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 13:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634578940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Em+oRTdA4GVZjC/ULW7URfKqvr1mlrjM4r4OrqSpy/Q=;
        b=DfrKJlyC0SyizgH+10dJOiszSmpP4GqVdazkRRVplXjWdpyQpasx5DRQH2DOIWFqcp5ZBH
        G7NzionEyzXaXqMQJBMUFRjxEzeWEsMrf/vFDyvhnXHmPGfOyLxNirCjYrXY0SVtbffolt
        FagGjrG+z9KThp3gyvgNWh5yllTs9kI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-H8Co_SEhNBucqCJn2FTgdA-1; Mon, 18 Oct 2021 13:41:39 -0400
X-MC-Unique: H8Co_SEhNBucqCJn2FTgdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D1FB9F92C;
        Mon, 18 Oct 2021 17:41:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C13A96A8E5;
        Mon, 18 Oct 2021 17:41:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.15-rc7
Date:   Mon, 18 Oct 2021 13:41:37 -0400
Message-Id: <20211018174137.579907-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 7b0035eaa7dab9fd33d6658ad6a755024bdce26c:

  KVM: selftests: Ensure all migrations are performed when test is affined (2021-09-30 04:25:57 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 4934c52be82cb235d756c27c1cc769a0498607fb:

  KVM: SEV-ES: reduce ghcb_sa_len to 32 bits (2021-10-18 06:49:26 -0400)

----------------------------------------------------------------
Tools:
* kvm_stat: do not show halt_wait_ns since it is not a cumulative statistic

x86:
* clean ups and fixes for bus lock vmexit and lazy allocation of rmaps
* avoid warning with -Wbitwise-instead-of-logical
* avoid warning due to huge kvmalloc.  Temporarily disables accounting,
  will be fixed in 5.16 and backported to stable 5.15
* two fixes for SEV-ES (one more coming as soon as I get reviews)
* fix for static_key underflow

ARM:
* Properly refcount pages used as a concatenated stage-2 PGD
* Fix missing unlock when detecting the use of MTE+VM_SHARED

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: kvm_stat: do not show halt_wait_ns

Hao Xiang (1):
      KVM: VMX: Remove redundant handling of bus lock vmexit

Janosch Frank (1):
      KVM: s390: Function documentation fixes

Paolo Bonzini (7):
      Merge tag 'kvm-s390-master-5.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master
      KVM: SEV-ES: fix length of string I/O
      Merge tag 'kvmarm-fixes-5.15-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: replace large kvmalloc allocation with vmalloc
      KVM: X86: fix lazy allocation of rmaps
      KVM: x86: avoid warning with -Wbitwise-instead-of-logical
      KVM: SEV-ES: reduce ghcb_sa_len to 32 bits

Peter Gonda (1):
      KVM: SEV-ES: Set guest_state_protected after VMSA update

Quentin Perret (3):
      KVM: arm64: Fix host stage-2 PGD refcount
      KVM: arm64: Report corrupted refcount at EL2
      KVM: arm64: Release mmap_lock when using VM_SHARED with MTE

Sean Christopherson (2):
      Revert "KVM: x86: Open code necessary bits of kvm_lapic_set_base() at vCPU RESET"
      KVM: x86: WARN if APIC HW/SW disable static keys are non-zero on unload

 arch/arm64/kvm/hyp/include/nvhe/gfp.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 13 ++++++++++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 15 +++++++++++++++
 arch/arm64/kvm/mmu.c                  |  6 ++++--
 arch/s390/kvm/gaccess.c               | 12 ++++++++++++
 arch/s390/kvm/intercept.c             |  4 +++-
 arch/x86/kvm/lapic.c                  | 20 +++++++++++++-------
 arch/x86/kvm/mmu/page_track.c         |  3 +--
 arch/x86/kvm/mmu/spte.h               |  7 +++++--
 arch/x86/kvm/svm/sev.c                |  9 +++++++--
 arch/x86/kvm/svm/svm.h                |  2 +-
 arch/x86/kvm/vmx/vmx.c                | 15 +++++++++------
 arch/x86/kvm/x86.c                    |  7 ++++---
 include/linux/vmalloc.h               | 10 ++++++++++
 tools/kvm/kvm_stat/kvm_stat           |  2 +-
 virt/kvm/kvm_main.c                   |  4 ++--
 16 files changed, 100 insertions(+), 30 deletions(-)

