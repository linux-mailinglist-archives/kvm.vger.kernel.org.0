Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DFE15ADA5
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgBLQrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:47:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36631 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgBLQrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:47:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so3321933wma.1;
        Wed, 12 Feb 2020 08:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SKa1ymo+xngGE1G8vLfgl5ipgmzkjWe5i0UrcJ3bDbg=;
        b=ez55nzmnkWrb3vr0b+5+L+ycOVeUN9d3D+SLIAR0TxouAQE1Gbx+THHba3B2V2tBC6
         Pf9V4VLD1XaHpucds2KmvV9e6wXIwrhn4xRG3vqFSQkkGQXnW1Vrumz/wsrFUcRTmFes
         ehpHRlGdZaCLJXhPOscGWSI19bXg44OrRehMBiMVqWnV6kKnwzBwYMtcN7oGK5jugVRG
         cz5iGTm9KndW6u/O7PyF5heOTNl8XgXWGb5NXnxDi3YBJzkcKl2Hq4MKDunlIWznzIjy
         y+g2XO+QnsvfXrZPkeAXZ3iySAmvLwhniHxsZHpTwfa7kYgUFoY1XTP8PjwdanFLskg6
         OIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=SKa1ymo+xngGE1G8vLfgl5ipgmzkjWe5i0UrcJ3bDbg=;
        b=JyqoNiYhsx16pFBXsnK8UtEmituAHBFvUuCnhyYNX7yhI9Qpg/tJDaP/AD+Iblk5+/
         Xy57jSXsciPK9fyCPA2TyQa7lPizgZtmu1nv5G5QtDAQf5OcySJz2g2P8vvh+05Lnulq
         DtCQSpjfZgOZCItkkGQQeEY2FLepvCFXqO5KwaXqgKI7ZaBGMPRQsGhNIdn5prWS1hhj
         f+8zdR2HEU0lgIo2SZlGc+IAUzKdyMQTQFJ4ckWo7YiqcBA74xW4HzHgNcv0AOrupada
         7+kLcvVXKfN5/BHoiG5dBcTJZFslV3nf9Gft4eL1dexirXysyUt+Jhs2FzlVtE/3TbCI
         E/BA==
X-Gm-Message-State: APjAAAU60c5aWQcf8ZYdYY53MqU9LlNy2peS0G3UMjjVKyysMeNeMUGs
        FuUvAkfZbewKu+tlxJFawCOrk1Dk
X-Google-Smtp-Source: APXvYqxU40wrpOGbIh/LNi+TIAmqKs8utMpQWCPonG4hKQ8YbENmX1w/ToLcug8AO0gsvmkWOKBN2Q==
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr7684561wme.183.1581526036591;
        Wed, 12 Feb 2020 08:47:16 -0800 (PST)
Received: from donizetti.fritz.box ([151.30.86.140])
        by smtp.gmail.com with ESMTPSA id 16sm1436726wmi.0.2020.02.12.08.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 08:47:15 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rkrcmar@kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.6-rc2
Date:   Wed, 12 Feb 2020 17:47:14 +0100
Message-Id: <20200212164714.7733-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c4c3fdc9c43b77f1b99c71d6edda8e20d00c3e2d:

  docs: virt: guest-halt-polling.txt convert to ReST (2020-02-12 14:33:07 +0100)

----------------------------------------------------------------
A mix of cleanups and bugfixes, some of them slightly more invasive than usual
but still not worth waiting for 5.7.  On top of this, Mauro converted the
KVM documentation to rst format, which was very welcome, and Eric ported
the selftests infrastructure to nested AMD virtualization (which will come
in handy when adding nested live migration support, as it did for Intel).

----------------------------------------------------------------
Eric Auger (4):
      selftests: KVM: Replace get_{gdt,idt}_base() by get_{gdt,idt}()
      selftests: KVM: AMD Nested test infrastructure
      selftests: KVM: SVM: Add vmcall test
      selftests: KVM: Remove unused x86_register enum

Marc Zyngier (1):
      KVM: Disable preemption in kvm_get_running_vcpu()

Mauro Carvalho Chehab (28):
      docs: kvm: add arm/pvtime.rst to index.rst
      docs: virt: convert UML documentation to ReST
      docs: virt: user_mode_linux.rst: update compiling instructions
      docs: virt: user_mode_linux.rst: fix URL references
      docs: virt: convert halt-polling.txt to ReST format
      docs: virt: Convert msr.txt to ReST format
      docs: kvm: devices/arm-vgic-its.txt to ReST format
      docs: kvm: devices/arm-vgit-v3.txt to ReST
      docs: kvm: convert devices/arm-vgit.txt to ReST
      docs: kvm: convert devices/mpic.txt to ReST
      docs: kvm: convert devices/s390_flic.txt to ReST
      docs: kvm: convert devices/vcpu.txt to ReST
      docs: kvm: convert devices/vfio.txt to ReST
      docs: kvm: convert devices/vm.txt to ReST
      docs: kvm: convert devices/xics.txt to ReST
      docs: kvm: convert devices/xive.txt to ReST
      docs: kvm: Convert api.txt to ReST format
      docs: kvm: convert arm/hyp-abi.txt to ReST
      docs: kvm: arm/psci.txt: convert to ReST
      docs: kvm: Convert hypercalls.txt to ReST format
      docs: kvm: Convert locking.txt to ReST format
      docs: kvm: Convert mmu.txt to ReST format
      docs: kvm: Convert nested-vmx.txt to ReST format
      docs: kvm: Convert ppc-pv.txt to ReST format
      docs: kvm: Convert s390-diag.txt to ReST format
      docs: kvm: Convert timekeeping.txt to ReST format
      docs: kvm: review-checklist.txt: rename to ReST
      docs: virt: guest-halt-polling.txt convert to ReST

Miaohe Lin (3):
      KVM: x86: remove duplicated KVM_REQ_EVENT request
      KVM: apic: reuse smp_wmb() in kvm_make_request()
      KVM: nVMX: Fix some comment typos and coding style

Oliver Upton (4):
      KVM: x86: Mask off reserved bit from #DB exception payload
      KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
      KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS
      KVM: nVMX: Emulate MTF when performing instruction emulation

Paolo Bonzini (2):
      KVM: x86: do not reset microcode version on INIT or RESET
      KVM: x86: fix WARN_ON check of an unsigned less than zero

Peter Xu (4):
      KVM: Provide kvm_flush_remote_tlbs_common()
      KVM: MIPS: Drop flush_shadow_memslot() callback
      KVM: MIPS: Replace all the kvm_flush_remote_tlbs() references
      KVM: MIPS: Define arch-specific kvm_flush_remote_tlbs()

Sean Christopherson (6):
      KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP
      KVM: nVMX: Use correct root level for nested EPT shadow page tables
      KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging
      KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
      KVM: nVMX: Rename EPTP validity helper and associated variables
      KVM: nVMX: Drop unnecessary check on ept caps for execute-only

 .../guest-halt-polling.rst}                        |   12 +-
 Documentation/virt/index.rst                       |    2 +
 Documentation/virt/kvm/{api.txt => api.rst}        | 3350 ++++++++++++--------
 .../virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst}      |   28 +-
 Documentation/virt/kvm/arm/index.rst               |   12 +
 Documentation/virt/kvm/arm/{psci.txt => psci.rst}  |   46 +-
 .../devices/{arm-vgic-its.txt => arm-vgic-its.rst} |  106 +-
 .../devices/{arm-vgic-v3.txt => arm-vgic-v3.rst}   |  132 +-
 .../kvm/devices/{arm-vgic.txt => arm-vgic.rst}     |   89 +-
 Documentation/virt/kvm/devices/index.rst           |   19 +
 .../virt/kvm/devices/{mpic.txt => mpic.rst}        |   11 +-
 .../kvm/devices/{s390_flic.txt => s390_flic.rst}   |   70 +-
 Documentation/virt/kvm/devices/vcpu.rst            |  114 +
 Documentation/virt/kvm/devices/vcpu.txt            |   76 -
 .../virt/kvm/devices/{vfio.txt => vfio.rst}        |   25 +-
 Documentation/virt/kvm/devices/{vm.txt => vm.rst}  |  206 +-
 .../virt/kvm/devices/{xics.txt => xics.rst}        |   28 +-
 .../virt/kvm/devices/{xive.txt => xive.rst}        |  152 +-
 .../kvm/{halt-polling.txt => halt-polling.rst}     |   90 +-
 .../virt/kvm/{hypercalls.txt => hypercalls.rst}    |  129 +-
 Documentation/virt/kvm/index.rst                   |   16 +
 Documentation/virt/kvm/locking.rst                 |  243 ++
 Documentation/virt/kvm/locking.txt                 |  215 --
 Documentation/virt/kvm/{mmu.txt => mmu.rst}        |   62 +-
 Documentation/virt/kvm/{msr.txt => msr.rst}        |  147 +-
 .../virt/kvm/{nested-vmx.txt => nested-vmx.rst}    |   37 +-
 Documentation/virt/kvm/{ppc-pv.txt => ppc-pv.rst}  |   26 +-
 .../{review-checklist.txt => review-checklist.rst} |    3 +
 .../virt/kvm/{s390-diag.txt => s390-diag.rst}      |   13 +-
 .../virt/kvm/{timekeeping.txt => timekeeping.rst}  |  223 +-
 ...UserModeLinux-HOWTO.txt => user_mode_linux.rst} | 1810 +++++------
 arch/mips/include/asm/kvm_host.h                   |    7 -
 arch/mips/kvm/Kconfig                              |    1 +
 arch/mips/kvm/mips.c                               |   22 +-
 arch/mips/kvm/trap_emul.c                          |   15 +-
 arch/mips/kvm/vz.c                                 |   14 +-
 arch/x86/include/asm/kvm_host.h                    |   17 +-
 arch/x86/include/uapi/asm/kvm.h                    |    1 +
 arch/x86/kvm/lapic.c                               |    3 -
 arch/x86/kvm/mmu.h                                 |   13 +
 arch/x86/kvm/mmu/mmu.c                             |   11 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    2 +-
 arch/x86/kvm/svm.c                                 |    3 +-
 arch/x86/kvm/vmx/nested.c                          |  104 +-
 arch/x86/kvm/vmx/nested.h                          |    9 +-
 arch/x86/kvm/vmx/vmx.c                             |   42 +-
 arch/x86/kvm/vmx/vmx.h                             |    3 +
 arch/x86/kvm/x86.c                                 |   44 +-
 include/linux/kvm_host.h                           |   11 +-
 tools/testing/selftests/kvm/Makefile               |    3 +-
 .../selftests/kvm/include/x86_64/processor.h       |   44 +-
 tools/testing/selftests/kvm/include/x86_64/svm.h   |  297 ++
 .../selftests/kvm/include/x86_64/svm_util.h        |   38 +
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |  161 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |    6 +-
 .../testing/selftests/kvm/x86_64/svm_vmcall_test.c |   79 +
 virt/kvm/arm/vgic/vgic-mmio.c                      |   12 -
 virt/kvm/kvm_main.c                                |   22 +-
 58 files changed, 5036 insertions(+), 3440 deletions(-)
 rename Documentation/{virtual/guest-halt-polling.txt => virt/guest-halt-polling.rst} (91%)
 rename Documentation/virt/kvm/{api.txt => api.rst} (71%)
 rename Documentation/virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} (79%)
 create mode 100644 Documentation/virt/kvm/arm/index.rst
 rename Documentation/virt/kvm/arm/{psci.txt => psci.rst} (60%)
 rename Documentation/virt/kvm/devices/{arm-vgic-its.txt => arm-vgic-its.rst} (71%)
 rename Documentation/virt/kvm/devices/{arm-vgic-v3.txt => arm-vgic-v3.rst} (77%)
 rename Documentation/virt/kvm/devices/{arm-vgic.txt => arm-vgic.rst} (66%)
 create mode 100644 Documentation/virt/kvm/devices/index.rst
 rename Documentation/virt/kvm/devices/{mpic.txt => mpic.rst} (91%)
 rename Documentation/virt/kvm/devices/{s390_flic.txt => s390_flic.rst} (87%)
 create mode 100644 Documentation/virt/kvm/devices/vcpu.rst
 delete mode 100644 Documentation/virt/kvm/devices/vcpu.txt
 rename Documentation/virt/kvm/devices/{vfio.txt => vfio.rst} (72%)
 rename Documentation/virt/kvm/devices/{vm.txt => vm.rst} (61%)
 rename Documentation/virt/kvm/devices/{xics.txt => xics.rst} (84%)
 rename Documentation/virt/kvm/devices/{xive.txt => xive.rst} (62%)
 rename Documentation/virt/kvm/{halt-polling.txt => halt-polling.rst} (64%)
 rename Documentation/virt/kvm/{hypercalls.txt => hypercalls.rst} (55%)
 create mode 100644 Documentation/virt/kvm/locking.rst
 delete mode 100644 Documentation/virt/kvm/locking.txt
 rename Documentation/virt/kvm/{mmu.txt => mmu.rst} (94%)
 rename Documentation/virt/kvm/{msr.txt => msr.rst} (74%)
 rename Documentation/virt/kvm/{nested-vmx.txt => nested-vmx.rst} (90%)
 rename Documentation/virt/kvm/{ppc-pv.txt => ppc-pv.rst} (91%)
 rename Documentation/virt/kvm/{review-checklist.txt => review-checklist.rst} (95%)
 rename Documentation/virt/kvm/{s390-diag.txt => s390-diag.rst} (90%)
 rename Documentation/virt/kvm/{timekeeping.txt => timekeeping.rst} (85%)
 rename Documentation/virt/uml/{UserModeLinux-HOWTO.txt => user_mode_linux.rst} (74%)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/svm.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
