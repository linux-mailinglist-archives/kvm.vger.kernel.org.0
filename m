Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2767D4AA70A
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 07:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350638AbiBEGJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 01:09:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238891AbiBEGJZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Feb 2022 01:09:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644041365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CTujWjViNIykIXnrJ9Di78sXxHI4yOPC1t5GOAikn6E=;
        b=SIp/gDPBM5+WT0ClrfowOUvggpaGvtY4dLoEBtcPFx2kwN1n8DQUjQVZRMYjjVDcEJEEIu
        ujw82tt+s/rzQZC9RPuFaSBiSXZKXdYgys5kQ63Uv5v41Hv74rhglx+N7Fd/TEkITVeZnX
        a7JMv4jjQMjlUrV66WCkKBy+xpgZUgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-AEQl6MXGMVu60QH8VTbzkg-1; Sat, 05 Feb 2022 01:09:21 -0500
X-MC-Unique: AEQl6MXGMVu60QH8VTbzkg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70E04814245;
        Sat,  5 Feb 2022 06:09:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2252D6C1B3;
        Sat,  5 Feb 2022 06:09:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.17-rc3
Date:   Sat,  5 Feb 2022 01:09:19 -0500
Message-Id: <20220205060919.88656-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 26291c54e111ff6ba87a164d85d4a4e134b7315c:

  Linux 5.17-rc2 (2022-01-30 15:37:07 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 7e6a6b400db8048bd1c06e497e338388413cf5bc:

  Merge tag 'kvmarm-fixes-5.17-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2022-02-05 00:58:25 -0500)

----------------------------------------------------------------
ARM:

* A couple of fixes when handling an exception while a SError has been delivered

* Workaround for Cortex-A510's single-step erratum

RISCV:

* Make CY, TM, and IR counters accessible in VU mode

* Fix SBI implementation version

x86:

* Report deprecation of x87 features in supported CPUID

* Preparation for fixing an interrupt delivery race on AMD hardware

* Sparse fix

All except POWER and s390:

* Rework guest entry code to correctly mark noinstr areas and fix vtime'
  accounting (for x86, this was already mostly correct but not entirely;
  for ARM, MIPS and RISC-V it wasn't)

----------------------------------------------------------------
Anup Patel (1):
      RISC-V: KVM: Fix SBI implementation version

James Morse (3):
      KVM: arm64: Avoid consuming a stale esr value when SError occur
      KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs
      KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata

Janosch Frank (1):
      kvm: Move KVM_GET_XSAVE2 IOCTL definition at the end of kvm.h

Jim Mattson (1):
      KVM: x86: Report deprecated x87 features in supported CPUID

Mark Rutland (5):
      kvm: add guest_state_{enter,exit}_irqoff()
      kvm/mips: rework guest entry logic
      kvm/x86: rework guest entry logic
      kvm/arm64: rework guest entry logic
      kvm/riscv: rework guest entry logic

Mayuresh Chitale (1):
      RISC-V: KVM: make CY, TM, and IR counters accessible in VU mode

Paolo Bonzini (2):
      Merge tag 'kvm-riscv-fixes-5.17-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-fixes-5.17-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Sean Christopherson (2):
      KVM: x86: Move delivery of non-APICv interrupt into vendor code
      KVM: x86: Use ERR_PTR_USR() to return -EFAULT as a __user pointer

 Documentation/arm64/silicon-errata.rst  |   2 +
 arch/arm64/Kconfig                      |  16 +++++
 arch/arm64/kernel/cpu_errata.c          |   8 +++
 arch/arm64/kvm/arm.c                    |  51 ++++++++++-----
 arch/arm64/kvm/handle_exit.c            |   8 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  23 ++++++-
 arch/arm64/tools/cpucaps                |   5 +-
 arch/mips/kvm/mips.c                    |  50 ++++++++++++--
 arch/riscv/kvm/vcpu.c                   |  48 +++++++++-----
 arch/riscv/kvm/vcpu_sbi_base.c          |   3 +-
 arch/x86/include/asm/kvm-x86-ops.h      |   2 +-
 arch/x86/include/asm/kvm_host.h         |   3 +-
 arch/x86/kvm/cpuid.c                    |  13 ++--
 arch/x86/kvm/lapic.c                    |  10 +--
 arch/x86/kvm/svm/svm.c                  |  21 +++++-
 arch/x86/kvm/vmx/vmx.c                  |  21 +++++-
 arch/x86/kvm/x86.c                      |  10 +--
 arch/x86/kvm/x86.h                      |  45 -------------
 include/linux/kvm_host.h                | 112 +++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h                |   6 +-
 20 files changed, 336 insertions(+), 121 deletions(-)

