Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B9A134FC
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 23:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfECVqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 17:46:18 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36037 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfECVqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 17:46:18 -0400
Received: by mail-oi1-f195.google.com with SMTP id l203so5576959oia.3;
        Fri, 03 May 2019 14:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bo6sBLi3JhZAeEGfciYpjSPPKO3J0vi9Fr74oujyIxM=;
        b=dXmPRn8cGAUoI3psj7jsrfYRmNyQlr9nugok5pw67O96fswh4EZKHlSCd5l2t3mxDW
         GIIx+NsacBXQIHSvOv6nxChU2gnE/1xuLI9a4I031+0/oRmeeKVHDBuCG1kfa+7ll8/i
         1fMYG1RnaJ64ONwWeSYfIzWW3W7q6ld6WIAtpwp01wiu9T+UDLOyrEBr53EE1ZEUhVS4
         Pp70k443jj/lsuDKVWoIrakwT9QDzsBYZZpg0HQulVUPNrajWD/iv2ES7027bn2wTG/B
         lQub0R0n7U/z7jtsUnq//ie8qptebqLLlF3mL6PDNVPSWiAiHTagNulxB7bIEPnI71Ga
         ah2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Bo6sBLi3JhZAeEGfciYpjSPPKO3J0vi9Fr74oujyIxM=;
        b=a+TAy9TwEqQOTKbo4JYoNcSp7OVuRf/Is3tjrbj8uDoobFNJrBiGuMCfCE/mS8DnbR
         h0jFiHGj2rrpRk6VaWOVDSYDikeO7vrngBDQlAcWknTdi7zEx/0GDbyJCZ9V+eMsF3WZ
         WNX1OxoFVtOdfDnRaSi4RWivdVGDxPCUNsCSUCbE86woQeKDGB6mfTKbdzEHnuuCLwO8
         xEbBBlJz9cc3Y/Hjc/p19GH/JXS7CXjAegxIiXunZ1FW1Cbva+VR/R4HTGAR6fm4DxBH
         JIUEF3Q4PKGaN1IfHTbt7YKpiFSPp8EYJ4FA/eC4Ge9AGOl3h1SQsaEvFN0vohELtbOF
         WoKg==
X-Gm-Message-State: APjAAAVHT9gQBGhI8eujUEvOCdbcxP3Zr0XhrcsMGEIy0OXs1HW84g3y
        mu2pobXxlkxqPw+HK2TYHLc=
X-Google-Smtp-Source: APXvYqzovcMs75Fs3FQhGnu/IWyqyV5NiI8nTjwqxe3xd3H8UcGq6HBR7Ex64AkJiwwIBnIG4cdwzg==
X-Received: by 2002:aca:5046:: with SMTP id e67mr600074oib.115.1556919976896;
        Fri, 03 May 2019 14:46:16 -0700 (PDT)
Received: from localhost.localdomain ([23.92.204.198])
        by smtp.gmail.com with ESMTPSA id h129sm1388633oia.12.2019.05.03.14.46.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 14:46:16 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@kernel.org,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.1-rc8 or final
Date:   Fri,  3 May 2019 15:46:14 -0600
Message-Id: <20190503214614.21250-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 7a223e06b1a411cef6c4cd7a9b9a33c8d225b10e:

  KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing (2019-04-16 15:38:08 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e8ab8d24b488632d07ce5ddb261f1d454114415b:

  KVM: nVMX: Fix size checks in vmx_set_nested_state (2019-05-01 00:43:44 +0200)

----------------------------------------------------------------
* PPC and ARM bugfixes from submaintainers
* Fix old Windows versions on AMD (recent regression)
* Fix old Linux versions on processors without EPT
* Fixes for LAPIC timer optimizations

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      KVM: PPC: Book3S: Protect memslots while validating user address

Andrew Jones (2):
      KVM: arm/arm64: Ensure vcpu target is unset on reset failure
      Documentation: kvm: fix dirty log ioctl arch lists

Christoffer Dall (1):
      KVM: arm/arm64: Don't emulate virtual timers on userspace ioctls

Jim Mattson (1):
      KVM: nVMX: Fix size checks in vmx_set_nested_state

Liran Alon (1):
      KVM: x86: Consider LAPIC TSC-Deadline timer expired if deadline too short

Marc Zyngier (1):
      KVM: arm/arm64: vgic-v3: Retire pending interrupts on disabling LPIs

Paolo Bonzini (3):
      Merge tag 'kvm-ppc-fixes-5.1-1' of git://git.kernel.org/.../paulus/powerpc into HEAD
      KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned size
      Merge tag 'kvmarm-fixes-for-5.1-2' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master

Rick Edgecombe (1):
      KVM: VMX: Move RSB stuffing to before the first RET after VM-Exit

Sean Christopherson (6):
      KVM: lapic: Disable timer advancement if adaptive tuning goes haywire
      KVM: lapic: Track lapic timer advance per vCPU
      KVM: lapic: Allow user to disable adaptive tuning of timer advancement
      KVM: lapic: Convert guest TSC to host time domain if necessary
      KVM: x86: Whitelist port 0x7e for pre-incrementing %rip
      KVM: lapic: Check for in-kernel LAPIC before deferencing apic pointer

Suraj Jitindar Singh (1):
      KVM: PPC: Book3S HV: Perserve PSSCR FAKE_SUSPEND bit on guest exit

Suzuki K Poulose (1):
      kvm: arm: Skip stage2 huge mappings for unaligned ipa backed by THP

Vitaly Kuznetsov (3):
      x86: kvm: hyper-v: deal with buggy TLB flush requests from WS2012
      x86/kvm/mmu: reset MMU context when 32-bit guest switches PAE
      KVM: selftests: make hyperv_cpuid test pass on AMD

Wei Huang (1):
      KVM: arm/arm64: arch_timer: Fix CNTP_TVAL calculation

 Documentation/virtual/kvm/api.txt                 | 11 ++--
 arch/powerpc/kvm/book3s_64_vio.c                  |  6 +-
 arch/powerpc/kvm/book3s_hv.c                      |  4 +-
 arch/x86/include/asm/kvm_host.h                   |  1 +
 arch/x86/include/uapi/asm/kvm.h                   |  1 +
 arch/x86/kvm/hyperv.c                             | 11 +++-
 arch/x86/kvm/lapic.c                              | 73 ++++++++++++++++-------
 arch/x86/kvm/lapic.h                              |  4 +-
 arch/x86/kvm/mmu.c                                |  1 +
 arch/x86/kvm/vmx/nested.c                         |  4 +-
 arch/x86/kvm/vmx/vmenter.S                        | 12 ++++
 arch/x86/kvm/vmx/vmx.c                            |  7 +--
 arch/x86/kvm/x86.c                                | 36 ++++++++---
 arch/x86/kvm/x86.h                                |  2 -
 tools/testing/selftests/kvm/dirty_log_test.c      |  9 ++-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c |  9 ++-
 virt/kvm/arm/arch_timer.c                         | 17 +++---
 virt/kvm/arm/arm.c                                | 11 +++-
 virt/kvm/arm/mmu.c                                |  6 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  |  3 +
 virt/kvm/arm/vgic/vgic.c                          | 21 +++++++
 virt/kvm/arm/vgic/vgic.h                          |  1 +
 virt/kvm/kvm_main.c                               |  7 ++-
 23 files changed, 192 insertions(+), 65 deletions(-)
