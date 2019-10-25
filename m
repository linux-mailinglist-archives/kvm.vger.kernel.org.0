Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A04E4A3C
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 13:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502063AbfJYLqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 07:46:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52392 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730088AbfJYLqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 07:46:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id p21so1785710wmg.2;
        Fri, 25 Oct 2019 04:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ef0+hHhWKCL6Ca0t5L5+DnFrjs6xNw6+Odbfva8qwPs=;
        b=MweLNAF2NZ7iEpk6wMj4PgBgpG0sqWOQGUnZ5/A9SGuzDzfVMXAN5EOmXw054lnilC
         JpvmjXsT/o5JUWHkilzQ2uVNbpRohLVa7vT3MLWYjKbzLw0zfei+xFbAfcpkzUMVHcNT
         1yuGX4/2mATN/KrU26ulSjsIbQhVgWDlKT89ksOjIDjRWMF97PGryx1U/4GKJcCWlN3Q
         FEJIHXFkbTrYjPv+N/bdFEOW1ghAqmjl+ZUX4kwlH3mBK5/tH9GhXQEFjxOsG3Uf7DF1
         8rliUCEFFCibiUJens7WliBKOngilDkc+PKmVWT4F1ICYgPD7EDjpsafY4vWcdZi+n9Z
         dtiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=ef0+hHhWKCL6Ca0t5L5+DnFrjs6xNw6+Odbfva8qwPs=;
        b=HjcyKQ93uuk7clM+wMechRaJcC2vhSYsVuJ1ZqtCvh6g9dkz/QiXDvvezF6KqLtEaz
         N2zugzszywtnFlti8woXMZhdm7+o4bE5Gb45ErydCgjiGDlAWvq75PxJMhtrYTUOcoQy
         vmT3y/fzzQhiQvUuo9mr/joR0zH+wCYK/3jMAeOlIc5M/aZtzsFbrLsE3nBINXMJZCKo
         mdnhqwxtD+MiP01iT/N/+Q2sTaHI1ewLGoUYwmJcOV/Yc9HEnxV/4ktEZvtuvaIosegG
         LPu0ulnzKgw1A2tU/ldI6KESu2R6uJL2Ul5LO5rrCRZS7QT4SWXmDgWjq4Az2OUE5jr0
         rIzw==
X-Gm-Message-State: APjAAAVQo8HIMTdum7YuiiPOPiEoDpCAe3ds1wunF7VKuf3cWZ0fYQZN
        qaFpGRaZARq4eiO5pz21LNo=
X-Google-Smtp-Source: APXvYqxyiXMNCEwujviBcaGWHHKgI5g4AoZaYE7MQ718Qwr4MDjEGH3/HrmtiPExX3WW7QD0UVNFjg==
X-Received: by 2002:a1c:f305:: with SMTP id q5mr3127071wmq.137.1572003961887;
        Fri, 25 Oct 2019 04:46:01 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g69sm1881335wme.31.2019.10.25.04.46.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 04:46:01 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.4-rc5
Date:   Fri, 25 Oct 2019 13:45:59 +0200
Message-Id: <1572003959-43063-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 3b7c59a1950c75f2c0152e5a9cd77675b09233d6:

  Merge tag 'pinctrl-v5.4-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl (2019-10-22 06:40:07 -0400)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 671ddc700fd08b94967b1e2a937020e30c838609:

  KVM: nVMX: Don't leak L1 MMIO regions to L2 (2019-10-22 19:04:40 +0200)

----------------------------------------------------------------
Bugfixes for ARM, PPC and x86, plus selftest improvements.

----------------------------------------------------------------
Greg Kurz (1):
      KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use

Jim Mattson (2):
      kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID
      KVM: nVMX: Don't leak L1 MMIO regions to L2

Liran Alon (1):
      KVM: VMX: Remove specialized handling of unexpected exit-reasons

Marc Zyngier (4):
      KVM: arm64: pmu: Fix cycle counter truncation
      arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64 systems
      KVM: arm64: pmu: Set the CHAINED attribute before creating the in-kernel event
      KVM: arm64: pmu: Reset sample period on overflow handling

Miaohe Lin (1):
      KVM: SVM: Fix potential wrong physical id in avic_handle_ldr_update

Paolo Bonzini (3):
      kvm: clear kvmclock MSR on reset
      Merge tag 'kvmarm-fixes-5.4-2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      Merge tag 'kvm-ppc-fixes-5.4-1' of git://git.kernel.org/.../paulus/powerpc into HEAD

Vitaly Kuznetsov (5):
      selftests: kvm: synchronize .gitignore to Makefile
      selftests: kvm: vmx_set_nested_state_test: don't check for VMX support twice
      selftests: kvm: consolidate VMX support checks
      selftests: kvm: vmx_dirty_log_test: skip the test when VMX is not supported
      selftests: kvm: fix sync_regs_test with newer gccs

Wanpeng Li (1):
      KVM: Don't shrink/grow vCPU halt_poll_ns if host side polling is disabled

kbuild test robot (1):
      KVM: x86: fix bugon.cocci warnings

 arch/arm64/kvm/sys_regs.c                          |  4 ++
 arch/powerpc/kvm/book3s_xive.c                     | 24 +++++---
 arch/powerpc/kvm/book3s_xive.h                     | 12 ++++
 arch/powerpc/kvm/book3s_xive_native.c              |  6 +-
 arch/x86/include/asm/kvm_host.h                    |  2 +-
 arch/x86/kvm/cpuid.c                               |  2 +-
 arch/x86/kvm/lapic.c                               |  5 --
 arch/x86/kvm/lapic.h                               |  5 ++
 arch/x86/kvm/svm.c                                 |  6 +-
 arch/x86/kvm/vmx/nested.c                          | 64 ++++++++++++----------
 arch/x86/kvm/vmx/nested.h                          | 13 ++++-
 arch/x86/kvm/vmx/vmx.c                             | 12 ----
 arch/x86/kvm/x86.c                                 | 19 ++++---
 tools/testing/selftests/kvm/.gitignore             |  2 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  2 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 10 ++++
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  | 21 +++----
 .../kvm/x86_64/vmx_close_while_nested_test.c       |  6 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      |  2 +
 .../kvm/x86_64/vmx_set_nested_state_test.c         | 13 +----
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |  6 +-
 virt/kvm/arm/pmu.c                                 | 48 +++++++++++-----
 virt/kvm/kvm_main.c                                | 29 +++++-----
 23 files changed, 186 insertions(+), 127 deletions(-)
