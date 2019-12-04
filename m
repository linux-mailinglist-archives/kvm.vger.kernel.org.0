Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611BC112AC6
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 12:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfLDLyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 06:54:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37333 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbfLDLyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 06:54:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so8260971wru.4;
        Wed, 04 Dec 2019 03:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ytPbAgq8jfy9JeU4hgqnWTRgViqMNOx0ju4A9bE7cvc=;
        b=l50GFiDGVkOlKxLSE4U4bT28VrlDfrXZ0M72HBJVo2c/1IzoQjh94GnIObzj36mhjJ
         vX4kkubF5de83RdF861RMYSdCK4gW/Aoqah5Y8bSxEbj6ezEzKwbRUXbghYDoGlShEu+
         FwvEhKv6956hvUrm0LfIo+nfGvDObhKu7UJq2LG1jVqajSv+hZnKu05A6aez5ioAnMqP
         MrGd+jhNMPSTEuO2476WwH6F7xJ39Ng3X+U27XuzNfQr2CydNJXdOEj/voz0u1QPSpYQ
         itR6VxyRzu6m0YPBTeh43seIlZRMjK8J9wmPSGe7UHwSlC+mr1DQP4vCjVlqnGYPE+Op
         GUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=ytPbAgq8jfy9JeU4hgqnWTRgViqMNOx0ju4A9bE7cvc=;
        b=E5x1nhJUvd0rAZn6+uU9ocahzcb/R6FfW0QLooctpn5J0fVrGcJePQpLsZafWlnvGe
         xhReiUVS2Ng7PsdCXq6EhY1q5+4hub7Xtew1zejDfwIjSUYC+iGfRQsuU7U1MRvM+Qgz
         lBVdbooFR+xiUSCdIZeiizEuHiqnwzayzMwCJIA6eape5s8Asf6vhuwFEB/WOBbIPghA
         Z9k8wACFy+DjB6ysi3Z2vlM7bvMxLAm7UdYIh08SX4ks48QmVNeY3IZ+rPufFlirHWDY
         zma2voaG6Zr3s7ZNWBrBZeEG8CtMAucKj29r99lTuVpTCbpEJsT6+cbC5DgpcPs1oOdJ
         637g==
X-Gm-Message-State: APjAAAV1Gs6NPuuFgetzcpY50uUAQCf4TmWIfBoyIaWn0JatLJekt3Bb
        LUdlg61WJp+EIBDl/bT+mvoogg/S
X-Google-Smtp-Source: APXvYqz3dG4Uk+JSz8YAx7xiJc5jlmHdRe2HmLe/sUlEvyLgEHQc2Uo+Uu3QMzlav/L5W5CKrOzzDg==
X-Received: by 2002:a5d:5452:: with SMTP id w18mr3422738wrv.333.1575460468945;
        Wed, 04 Dec 2019 03:54:28 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w17sm8087952wrt.89.2019.12.04.03.54.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 03:54:28 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@kernel.org,
        kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for 5.5 merge window
Date:   Wed,  4 Dec 2019 12:54:27 +0100
Message-Id: <1575460467-29531-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 96710247298df52a4b8150a62a6fe87083093ff3:

  Merge tag 'kvm-ppc-next-5.5-2' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into HEAD (2019-11-25 11:29:05 +0100)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 7d73710d9ca2564f29d291d0b3badc09efdf25e9:

  kvm: vmx: Stop wasting a page for guest_msrs (2019-12-04 12:23:27 +0100)

----------------------------------------------------------------
* PPC secure guest support
* small x86 cleanup
* fix for an x86-specific out-of-bounds write on a ioctl (not guest triggerable,
  data not attacker-controlled)

----------------------------------------------------------------
Anshuman Khandual (1):
      powerpc: Ultravisor: Add PPC_UV config option

Bharata B Rao (6):
      mm: ksm: Export ksm_madvise()
      KVM: PPC: Book3S HV: Support for running secure guests
      KVM: PPC: Book3S HV: Shared pages support for secure guests
      KVM: PPC: Book3S HV: Radix changes for secure guest
      KVM: PPC: Book3S HV: Handle memory plug/unplug to secure VM
      KVM: PPC: Book3S HV: Support reset of secure guest

Jim Mattson (1):
      kvm: vmx: Stop wasting a page for guest_msrs

Paolo Bonzini (2):
      Merge tag 'kvm-ppc-uvmem-5.5-2' of git://git.kernel.org/.../paulus/powerpc into HEAD
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)

Peter Gonda (1):
      KVM x86: Move kvm cpuid support out of svm

Wainer dos Santos Moschetta (1):
      Documentation: kvm: Fix mention to number of ioctls classes

 Documentation/virt/kvm/api.txt              |  20 +-
 arch/powerpc/Kconfig                        |  17 +
 arch/powerpc/include/asm/hvcall.h           |   9 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  74 +++
 arch/powerpc/include/asm/kvm_host.h         |   6 +
 arch/powerpc/include/asm/kvm_ppc.h          |   1 +
 arch/powerpc/include/asm/ultravisor-api.h   |   6 +
 arch/powerpc/include/asm/ultravisor.h       |  36 ++
 arch/powerpc/kvm/Makefile                   |   3 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c      |  25 +
 arch/powerpc/kvm/book3s_hv.c                | 143 +++++
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 785 ++++++++++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c                  |  12 +
 arch/x86/kvm/cpuid.c                        |  10 +-
 arch/x86/kvm/svm.c                          |   7 -
 arch/x86/kvm/vmx/vmx.c                      |  12 +-
 arch/x86/kvm/vmx/vmx.h                      |   8 +-
 include/uapi/linux/kvm.h                    |   1 +
 mm/ksm.c                                    |   1 +
 19 files changed, 1156 insertions(+), 20 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_uvmem.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_uvmem.c
