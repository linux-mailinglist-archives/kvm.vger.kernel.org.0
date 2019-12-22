Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB5A128E46
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2019 15:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfLVOA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Dec 2019 09:00:59 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55744 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfLVOA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Dec 2019 09:00:59 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so13359366wmj.5;
        Sun, 22 Dec 2019 06:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=1DmSP52cJIOHJ0h9ZkPnnmG+iqTAhNBwbA4QxDziCHM=;
        b=D4a6V89xdTZ3PjBJ1BzmGo7o7y+X7HFI8LhIiF1iLPimGW2hd7QHH2PP4fK4RpincY
         1BYXtBghhMCgmqdHVo4P7745nmGtYKAJjBn7E+bYtOCrfrR/hBK+M0hynaD9Cn4sLYy8
         X9HYCa6mGf50dhI8C5Hp62yzterY0MKX78yCjMfFgVcciPEHjDHKqp+tIVrOYPWOUMT0
         qx59jOXGmwO4yotPGkK6RLTK2Wkk7GQL2LWFCAf/WRec/MdjkOBmIKpt3sshkZN2ww/+
         2m6rcB1f2KLmMhjvjt2OCcLXcDcViPGAwnfDyRvMouCbvB1FHMVWIexnsgz3YlaKNGgo
         7dpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=1DmSP52cJIOHJ0h9ZkPnnmG+iqTAhNBwbA4QxDziCHM=;
        b=M57c3mMYVDyz7ecUCLtqBvicfeDIWa0CeQXf/R6G+mVPfqxhAsHHlbmei9rngJBVEz
         /J+LB5yNPbvT/5hl2tPD4Bi6vfmNCBLqi0c3Culidjin5NMawXpYHsGpQ++KToia1u/w
         5Uk0cVmod4Mfh5KZXKJAikLRJUEnRdWD0JvGmxOz6j8cNwd6ylljfA2It9KKcl06GXRD
         5Ov3InJ9Gpy2+5B11TNjEk8CymUn7KuVRWBvrG7GyAtmCczIvs4BWDU7EY1NSNIHRioj
         BsQ701ADcLH6eYgji1HV/lMTBSbX6WBP5grxU37hrlMNcahjyJrx/c/IjjuDFzNId84C
         3B9A==
X-Gm-Message-State: APjAAAXE81KZwaYZWmOWIIBOV+Ec8bKa5mZl2wmKCDyIFv6eXmUFuC0K
        b3CZdNm6NZXrKTBK8RYxOf1AO31Q
X-Google-Smtp-Source: APXvYqwS72OxVT8F/n8koxi0XBK5hlqCcJhjcoSE1Q83P4krnNX424dw9IKtMF/4gkIwvmYJev+WqA==
X-Received: by 2002:a1c:f210:: with SMTP id s16mr3439943wmc.57.1577023256646;
        Sun, 22 Dec 2019 06:00:56 -0800 (PST)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id i10sm17106075wru.16.2019.12.22.06.00.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Dec 2019 06:00:55 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM patches for 5.5-rc3
Date:   Sun, 22 Dec 2019 15:00:54 +0100
Message-Id: <1577023254-13034-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 7d73710d9ca2564f29d291d0b3badc09efdf25e9:

  kvm: vmx: Stop wasting a page for guest_msrs (2019-12-04 12:23:27 +0100)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d68321dec1b2234fb32f423e32c3af5915eae36c:

  Merge tag 'kvm-ppc-fixes-5.5-1' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into kvm-master (2019-12-22 13:18:15 +0100)

----------------------------------------------------------------

PPC:
* Fix a bug where we try to do an ultracall on a system without an ultravisor.

KVM:
- Fix uninitialised sysreg accessor
- Fix handling of demand-paged device mappings
- Stop spamming the console on IMPDEF sysregs
- Relax mappings of writable memslots
- Assorted cleanups

MIPS:
- Now orphan, James Hogan is stepping down

x86:
- MAINTAINERS change, so long Radim and thanks for all the fish
- supported CPUID fixes for AMD machines without SPEC_CTRL

----------------------------------------------------------------
James Hogan (1):
      MAINTAINERS: Orphan KVM for MIPS

Jia He (1):
      KVM: arm/arm64: Remove excessive permission check in kvm_arch_prepare_memory_region

Jim Mattson (2):
      kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD
      kvm: x86: Host feature SSBD doesn't imply guest feature AMD_SSBD

Marc Zyngier (1):
      KVM: arm/arm64: Properly handle faulting of device mappings

Mark Rutland (2):
      KVM: arm64: Sanely ratelimit sysreg messages
      KVM: arm64: Don't log IMP DEF sysreg traps

Miaohe Lin (3):
      KVM: arm/arm64: Get rid of unused arg in cpu_init_hyp_mode()
      KVM: arm/arm64: vgic: Fix potential double free dist->spis in __kvm_vgic_destroy()
      KVM: arm/arm64: vgic: Use wrapper function to lock/unlock all vcpus in kvm_vgic_create()

Paolo Bonzini (3):
      Merge tag 'kvmarm-fixes-5.5-1' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master
      MAINTAINERS: remove Radim from KVM maintainers
      Merge tag 'kvm-ppc-fixes-5.5-1' of git://git.kernel.org/.../paulus/powerpc into kvm-master

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Don't do ultravisor calls on systems without ultravisor

Will Deacon (1):
      KVM: arm64: Ensure 'params' is initialised when looking up sys register

 MAINTAINERS                   |  6 ++----
 arch/arm64/kvm/sys_regs.c     | 25 ++++++++++++++++++-------
 arch/arm64/kvm/sys_regs.h     | 17 +++++++++++++++--
 arch/powerpc/kvm/book3s_hv.c  |  3 ++-
 arch/x86/kvm/cpuid.c          |  6 ++++--
 virt/kvm/arm/arm.c            |  4 ++--
 virt/kvm/arm/mmu.c            | 30 +++++++++++++++++-------------
 virt/kvm/arm/vgic/vgic-init.c | 20 +++++---------------
 8 files changed, 65 insertions(+), 46 deletions(-)
