Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FD0215CCD
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 19:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgGFRP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 13:15:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729386AbgGFRP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 13:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594055727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WIAp4BksQMI/icBTHgBCKYMTMos5fdTsYz6Un13kkXc=;
        b=CxicBgcSmeoHCXGkN008UBxAxkBOdRcDAI9X9WYRMr6kFu3jEbZvw6nDUxg/MpiyF5/iQK
        ZzSDNAK4SY0Zz8kctydpKX4g0v9H/DyhXLTCS2DIkSBjNrMUYMki+hOgd4OHyQM8SZSsDb
        VR22IfcfRaIb8+RoLP2/VtI7ykXgf2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-Hr9AEiglOwy8YY02x3x5rg-1; Mon, 06 Jul 2020 13:15:25 -0400
X-MC-Unique: Hr9AEiglOwy8YY02x3x5rg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44E78804001;
        Mon,  6 Jul 2020 17:15:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E39955C1B2;
        Mon,  6 Jul 2020 17:15:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.8-rc5
Date:   Mon,  6 Jul 2020 13:15:23 -0400
Message-Id: <20200706171523.12441-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit e4553b4976d1178c13da295cb5c7b21f55baf8f9:

  KVM: VMX: Remove vcpu_vmx's defunct copy of host_pkru (2020-06-23 06:01:29 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 8038a922cf9af5266eaff29ce996a0d1b788fc0d:

  Merge tag 'kvmarm-fixes-5.8-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2020-07-06 13:05:38 -0400)

----------------------------------------------------------------
Bugfixes and a one-liner patch to silence sparse.

----------------------------------------------------------------

I'm going on vacation so my next pull request should be for rc8
or 5.8-final.  If something really bad comes up, you might get
KVM changes straight from architecture maintainers, but things
seems calm on both the 5.7 and 5.8 fronts so that should not
happen.

Thanks,

Paolo

Alexandru Elisei (1):
      KVM: arm64: Annotate hyp NMI-related functions as __always_inline

Andrew Jones (1):
      KVM: arm64: pvtime: Ensure task delay accounting is enabled

Andrew Scull (1):
      KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Christian Borntraeger (1):
      KVM: s390: reduce number of IO pins to 1

Marc Zyngier (2):
      KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell
      KVM: arm64: PMU: Fix per-CPU access in preemptible context

Paolo Bonzini (5):
      Merge tag 'kvm-s390-master-5.8-3' of git://git.kernel.org/.../kvms390/linux into kvm-master
      KVM: x86: bit 8 of non-leaf PDPEs is not reserved
      Merge tag 'kvmarm-fixes-5.8-2' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master
      kvm: use more precise cast and do not drop __user
      Merge tag 'kvmarm-fixes-5.8-3' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master

Sean Christopherson (3):
      KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57 in 64-bit mode
      KVM: x86: Mark CR4.TSD as being possibly owned by the guest
      KVM: VMX: Use KVM_POSSIBLE_CR*_GUEST_BITS to initialize guest/host masks

Steven Price (1):
      KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect with SVE

Wanpeng Li (1):
      KVM: X86: Fix async pf caused null-ptr-deref

 arch/arm64/include/asm/arch_gicv3.h |  2 +-
 arch/arm64/include/asm/cpufeature.h |  2 +-
 arch/arm64/kvm/hyp-init.S           | 11 +++++++----
 arch/arm64/kvm/pmu.c                |  7 ++++++-
 arch/arm64/kvm/pvtime.c             | 15 ++++++++++++---
 arch/arm64/kvm/reset.c              | 10 +++++++---
 arch/arm64/kvm/vgic/vgic-v4.c       |  8 ++++++++
 arch/s390/include/asm/kvm_host.h    |  8 ++++----
 arch/x86/kvm/kvm_cache_regs.h       |  2 +-
 arch/x86/kvm/mmu/mmu.c              |  2 +-
 arch/x86/kvm/vmx/nested.c           |  4 ++--
 arch/x86/kvm/vmx/vmx.c              | 13 +++++--------
 arch/x86/kvm/x86.c                  |  5 +++++
 drivers/irqchip/irq-gic-v3-its.c    |  8 ++++++++
 virt/kvm/kvm_main.c                 |  3 ++-
 15 files changed, 70 insertions(+), 30 deletions(-)

