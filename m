Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B7C1C88F4
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgEGLx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:53:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26401 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725948AbgEGLx1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 07:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=oJNhrRBC0c+BFGHFCS+s7JJ0R5CeLnnrd6LkdO80vW4=;
        b=JkaYZiam3G6JGPcqod1r+SrcRaaWkpkTZsLidhZxsCjsU7LPohv4i22LWTzDnrTdOI9Ml8
        pneeBU5vMVQ4UsI7a8yqtmp/pHVWxHHhzkcV1y15YZFRU1TroYkeutnhzy7G3phn7+/icZ
        Q6S8Yb9ywKFPXnj/oJf9GFE/ui3P9mQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-KMK427m6N2a7db-dpEdpog-1; Thu, 07 May 2020 07:53:23 -0400
X-MC-Unique: KMK427m6N2a7db-dpEdpog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA47480058A;
        Thu,  7 May 2020 11:53:22 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 599246ACE6;
        Thu,  7 May 2020 11:53:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.7-rc5
Date:   Thu,  7 May 2020 07:53:22 -0400
Message-Id: <20200507115322.495846-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 00a6a5ef39e7db3648b35c86361058854db84c83:

  Merge tag 'kvm-ppc-fixes-5.7-1' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into kvm-master (2020-04-21 09:39:55 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2673cb6849722a4ffd74c27a9200a9ec43f64be3:

  Merge tag 'kvm-s390-master-5.7-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2020-05-06 08:09:17 -0400)

----------------------------------------------------------------
Bugfixes, mostly for ARM and AMD, and more documentation.

----------------------------------------------------------------

Slightly bigger than usual because I couldn't send out what was pending
for rc4, but there is nothing worrisome going on.  I have more
fixes pending for guest debugging support (gdbstub) but I will send them
next week.

Thanks,

Paolo

Christian Borntraeger (1):
      KVM: s390: Remove false WARN_ON_ONCE for the PQAP instruction

Fangrui Song (1):
      KVM: arm64: Delete duplicated label in invalid_vector

Kashyap Chamarthy (1):
      docs/virt/kvm: Document configuring and running nested guests

Marc Zyngier (11):
      KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER
      KVM: arm64: PSCI: Narrow input registers when using 32bit functions
      KVM: arm64: PSCI: Forbid 64bit functions for 32bit guests
      KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER read
      KVM: arm: vgic: Only use the virtual state when userspace accesses enable bits
      KVM: arm: vgic-v2: Only use the virtual state when userspace accesses pending bits
      Merge branch 'kvm-arm64/psci-fixes-5.7' into kvmarm-master/master
      Merge branch 'kvm-arm64/vgic-fixes-5.7' into kvmarm-master/master
      KVM: arm64: Save/restore sp_el0 as part of __guest_enter
      KVM: arm64: vgic-v4: Initialize GICv4.1 even in the absence of a virtual ITS
      KVM: arm64: Fix 32bit PC wrap-around

Paolo Bonzini (6):
      KVM: SVM: fill in kvm_run->debug.arch.dr[67]
      Merge tag 'kvmarm-fixes-5.7-1' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master
      Merge tag 'kvmarm-fixes-5.7-2' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master
      kvm: ioapic: Restrict lazy EOI update to edge-triggered interrupts
      kvm: x86: Use KVM CPU capabilities to determine CR4 reserved bits
      Merge tag 'kvm-s390-master-5.7-3' of git://git.kernel.org/.../kvms390/linux into HEAD

Peter Xu (2):
      KVM: selftests: Fix build for evmcs.h
      KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly

Sean Christopherson (2):
      KVM: nVMX: Replace a BUG_ON(1) with BUG() to squash clang warning
      KVM: VMX: Explicitly clear RFLAGS.CF and RFLAGS.ZF in VM-Exit RSB path

Suravee Suthikulpanit (1):
      KVM: x86: Fixes posted interrupt check for IRQs delivery modes

Zenghui Yu (2):
      KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu destroy
      KVM: arm64: vgic-its: Fix memory leak on the error path of vgic_add_lpi()

 Documentation/virt/kvm/index.rst                 |   2 +
 Documentation/virt/kvm/running-nested-guests.rst | 276 +++++++++++++++++++++++
 arch/arm64/kvm/guest.c                           |   7 +
 arch/arm64/kvm/hyp/entry.S                       |  23 ++
 arch/arm64/kvm/hyp/hyp-entry.S                   |   1 -
 arch/arm64/kvm/hyp/sysreg-sr.c                   |  17 +-
 arch/powerpc/kvm/powerpc.c                       |   1 +
 arch/s390/kvm/kvm-s390.c                         |   1 +
 arch/s390/kvm/priv.c                             |   4 +-
 arch/x86/include/asm/kvm_host.h                  |   4 +-
 arch/x86/kvm/ioapic.c                            |  10 +-
 arch/x86/kvm/svm/svm.c                           |   2 +
 arch/x86/kvm/vmx/nested.c                        |   2 +-
 arch/x86/kvm/vmx/vmenter.S                       |   3 +
 arch/x86/kvm/x86.c                               |  21 +-
 tools/testing/selftests/kvm/include/evmcs.h      |   4 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c     |   3 +
 virt/kvm/arm/hyp/aarch32.c                       |   8 +-
 virt/kvm/arm/psci.c                              |  40 ++++
 virt/kvm/arm/vgic/vgic-init.c                    |  19 +-
 virt/kvm/arm/vgic/vgic-its.c                     |  11 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c                 |  16 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                 |  31 +--
 virt/kvm/arm/vgic/vgic-mmio.c                    | 228 ++++++++++++++-----
 virt/kvm/arm/vgic/vgic-mmio.h                    |  19 ++
 25 files changed, 628 insertions(+), 125 deletions(-)
 create mode 100644 Documentation/virt/kvm/running-nested-guests.rst

