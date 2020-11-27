Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A282C6985
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbgK0Qiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:38:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727936AbgK0Qix (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 11:38:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606495132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SAZDDMrXNdQFAZBn+CKA9ZaDVCs9UUciZaI7AEvpNhE=;
        b=NttPPvHSLEYIlINkC/eflL+H2JcL8vDFriUv33Zo6OsBngyngES+YPeJDR/ntm5OStyza+
        vJ/i9w2rqiVY7rPB+kGFxqnY2E3ByHWX2zPTe8JRKrL4P1wNpC9jvlDAqXFE2/9ALT1zLs
        1jVm1uWe1wWqZFZoA2Uxt+r6HSn0qZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-r38OCtYUNZGUMrxkJBLcwQ-1; Fri, 27 Nov 2020 11:38:48 -0500
X-MC-Unique: r38OCtYUNZGUMrxkJBLcwQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DDEC8049C3;
        Fri, 27 Nov 2020 16:38:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEB9D10021B3;
        Fri, 27 Nov 2020 16:38:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.10-rc6
Date:   Fri, 27 Nov 2020 11:38:46 -0500
Message-Id: <20201127163846.3233976-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit c887c9b9ca62c051d339b1c7b796edf2724029ed:

  kvm: mmu: fix is_tdp_mmu_check when the TDP MMU is not in use (2020-11-15 08:55:43 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9a2a0d3ca163fc645991804b8b032f7d59326bb5:

  kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting 5-level PT (2020-11-27 11:14:27 -0500)

----------------------------------------------------------------
ARM:
- Fix alignment of the new HYP sections
- Fix GICR_TYPER access from userspace

S390:
- do not reset the global diag318 data for per-cpu reset
- do not mark memory as protected too early
- fix for destroy page ultravisor call

x86:
- fix for SEV debugging
- fix incorrect return code
- fix for "noapic" with PIC in userspace and LAPIC in kernel
- fix for 5-level paging

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SVM: Fix offset computation bug in __sev_dbg_decrypt().

Chen Zhou (1):
      KVM: SVM: fix error return code in svm_create_vcpu()

Christian Borntraeger (2):
      s390/uv: handle destroy page legacy interface
      MAINTAINERS: add uv.c also to KVM/s390

Collin Walling (1):
      KVM: s390: remove diag318 reset code

Jamie Iles (1):
      KVM: arm64: Correctly align nVHE percpu data

Janosch Frank (1):
      KVM: s390: pv: Mark mm as protected after the set secure parameters and improve cleanup

Paolo Bonzini (5):
      Merge tag 'kvm-s390-master-5.10-1' of git://git.kernel.org/.../kvms390/linux into kvm-master
      Merge tag 'kvm-s390-master-5.10-2' of git://git.kernel.org/.../kvms390/linux into kvm-master
      Merge tag 'kvmarm-fixes-5.10-4' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master
      KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint
      KVM: x86: Fix split-irqchip vs interrupt injection window request

Sean Christopherson (1):
      MAINTAINERS: Update email address for Sean Christopherson

Vitaly Kuznetsov (1):
      kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting 5-level PT

Zenghui Yu (1):
      KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace

 .mailmap                           |  1 +
 MAINTAINERS                        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S  |  5 +++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 22 +++++++++-
 arch/s390/kernel/uv.c              |  9 +++-
 arch/s390/kvm/kvm-s390.c           |  4 +-
 arch/s390/kvm/pv.c                 |  3 +-
 arch/s390/mm/gmap.c                |  2 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/irq.c                 | 85 +++++++++++++++-----------------------
 arch/x86/kvm/lapic.c               |  2 +-
 arch/x86/kvm/mmu/mmu.c             |  2 +-
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/kvm/svm/svm.c             |  4 +-
 arch/x86/kvm/x86.c                 | 18 ++++----
 15 files changed, 91 insertions(+), 70 deletions(-)

