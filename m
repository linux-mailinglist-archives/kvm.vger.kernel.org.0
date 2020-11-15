Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0D52B35C0
	for <lists+kvm@lfdr.de>; Sun, 15 Nov 2020 16:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgKOP3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 10:29:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbgKOP3M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 15 Nov 2020 10:29:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605454151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rgstLvewQswHzH1bYuEdWL4wJXi1Onb1Pbf/B2GM9RA=;
        b=AT3+GmxZQk3AyC/8+r2CQoib26lpQUeWZoqz5FiOAiDzUlunteI4N2JJZCFQ/gL3Pz7lDb
        /pCK3cHOp0U6BCYOTdWraVIZ2Ud0eaHFU+OrgrxMQWGDc+HgdcUER2eUcBA6MLh98Kq0EA
        FaeNH+sLH3gGWY081srvny4I394WGlQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-sz4OOuA7O1KRgI6x5Vr_Aw-1; Sun, 15 Nov 2020 10:29:09 -0500
X-MC-Unique: sz4OOuA7O1KRgI6x5Vr_Aw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4B198049C1;
        Sun, 15 Nov 2020 15:29:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 856C65B4BB;
        Sun, 15 Nov 2020 15:29:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] More KVM fixes for 5.10-rc4
Date:   Sun, 15 Nov 2020 10:29:07 -0500
Message-Id: <20201115152907.1625371-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba:

  Merge tag 'fscrypt-for-linus' of git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt (2020-11-12 16:39:58 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c887c9b9ca62c051d339b1c7b796edf2724029ed:

  kvm: mmu: fix is_tdp_mmu_check when the TDP MMU is not in use (2020-11-15 08:55:43 -0500)

----------------------------------------------------------------
Fixes for ARM and x86, the latter especially for old processors
without two-dimensional paging (EPT/NPT).

----------------------------------------------------------------
Babu Moger (2):
      KVM: x86: Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch
      KVM: SVM: Update cr3_lm_rsvd_bits for AMD SEV guests

David Edmondson (1):
      KVM: x86: clflushopt should be treated as a no-op by emulation

Marc Zyngier (4):
      Merge tag 'v5.10-rc1' into kvmarm-master/next
      KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2 from userspace
      KVM: arm64: Unify trap handlers injecting an UNDEF
      KVM: arm64: Handle SCXTNUM_ELx traps

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-5.10-3' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      kvm: mmu: fix is_tdp_mmu_check when the TDP MMU is not in use

 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/sysreg.h   |   4 ++
 arch/arm64/kvm/arm.c              |  16 ++++++
 arch/arm64/kvm/sys_regs.c         | 111 +++++++++++++++++++++++---------------
 arch/x86/include/asm/kvm_host.h   |   1 +
 arch/x86/kvm/cpuid.c              |   2 +
 arch/x86/kvm/emulate.c            |   8 ++-
 arch/x86/kvm/mmu/tdp_mmu.c        |   7 +++
 arch/x86/kvm/svm/svm.c            |   8 +++
 arch/x86/kvm/x86.c                |   2 +-
 10 files changed, 115 insertions(+), 46 deletions(-)

