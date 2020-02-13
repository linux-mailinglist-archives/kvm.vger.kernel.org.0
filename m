Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4FE15CD86
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 22:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgBMVsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 16:48:55 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52646 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgBMVsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 16:48:55 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so7911613wmc.2;
        Thu, 13 Feb 2020 13:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=zF1tlZSRa/LFYwLFggJhr6dooSiaUziOFm+pJFx4Zd0=;
        b=f0fPp0s3NXmUUEAw8xyR9iLbUTCkbZAv8x0jtym8E7TomkJp/GK9Xmpg2uOnmko0Ts
         OOPhayg/leez3t/lZ+FS22qW/QsbJsjG/5NVyQx1n8ElVfynT3PS8dHDz/bGHRwzlOIb
         J/GkGvLdr/6CN7LDy9IZd60gNzuLyEnwW3+t4VdR073+UYzp1g7tsiE2lgNAe8p74JOR
         n/upBrrJxsg7rT9l3OKFBDIps7D5Nqx+jpcPQq+SVethfyrpLV0h01D0G2XgerH2FAGO
         6zZNvJHnwZwr/KteczOUhTlM9ZX5qsilKEQsSzjw70/Ta8L6+HBSOo0pnguaqZM4jgqu
         8vDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=zF1tlZSRa/LFYwLFggJhr6dooSiaUziOFm+pJFx4Zd0=;
        b=S4VOP7jz4pDTHasALqdpKDfyiZBsNwljDHNqwfdSRjPFggJvJ6rCTBw7Ii6GEu9mya
         RjVrid6AME6niazoaB2kdRpCJOdkJmSw3KTf+iOylz8DkXru4R7mKpHd2BAVKiTkif3b
         1zVesT9agZgB5C5cqXkZoMOrg9BOFE4N52SjPAfHzforne/rACYvsiPNjkPf3BtWkA13
         +Vd1/cT6W3/ciAmLM26oVylQuGCUY4m8uWdb3GPtW2uXP/ogBx3uE8qMWK86WfcAwd5C
         WEil+CfvsOBjhejjB6rul6pzrNzi1u5C77hMS88+SdYOUirZhSo2p6OBLgnJMxWxybAn
         3cdw==
X-Gm-Message-State: APjAAAXyIiotb6ApOQjvSzLBVcWNFm4QF08pC+CrrCyQBo8ReJitaqnk
        9S0iimAtyBiSTfD3MoWDeOHd17hY
X-Google-Smtp-Source: APXvYqxEjvuuR4PPy3Z8hW9AJXtIst9ksHJVkuAH7cYHIYq8QN5Y/07nJPJ8ISIyGfqfFywvJWTjDw==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr89084wmh.99.1581630532373;
        Thu, 13 Feb 2020 13:48:52 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s23sm4553324wra.15.2020.02.13.13.48.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 13:48:51 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL v2] KVM changes for Linux 5.6-rc2
Date:   Thu, 13 Feb 2020 22:48:49 +0100
Message-Id: <1581630529-5236-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 120881b9e888689cbdb90a1dd1689684d8bc95f3:

  docs: virt: guest-halt-polling.txt convert to ReST (2020-02-12 20:10:08 +0100)

----------------------------------------------------------------
Bugfixes and improvements to selftests.  On top of this, Mauro converted the
KVM documentation to rst format, which was very welcome.

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

Oliver Upton (3):
      KVM: x86: Mask off reserved bit from #DB exception payload
      KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
      KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS

Paolo Bonzini (2):
      KVM: x86: do not reset microcode version on INIT or RESET
      KVM: x86: fix WARN_ON check of an unsigned less than zero

Sean Christopherson (3):
      KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP
      KVM: nVMX: Use correct root level for nested EPT shadow page tables
      KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging

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
 arch/x86/include/asm/kvm_host.h                    |   16 +-
 arch/x86/kvm/lapic.c                               |    3 -
 arch/x86/kvm/mmu.h                                 |   13 +
 arch/x86/kvm/mmu/mmu.c                             |   11 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    2 +-
 arch/x86/kvm/svm.c                                 |    2 +-
 arch/x86/kvm/vmx/nested.c                          |   33 +-
 arch/x86/kvm/vmx/vmx.c                             |    5 +-
 arch/x86/kvm/x86.c                                 |   42 +-
 tools/testing/selftests/kvm/Makefile               |    3 +-
 .../selftests/kvm/include/x86_64/processor.h       |   44 +-
 tools/testing/selftests/kvm/include/x86_64/svm.h   |  297 ++
 .../selftests/kvm/include/x86_64/svm_util.h        |   38 +
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |  161 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |    6 +-
 .../testing/selftests/kvm/x86_64/svm_vmcall_test.c |   79 +
 virt/kvm/arm/vgic/vgic-mmio.c                      |   12 -
 virt/kvm/kvm_main.c                                |   16 +-
 49 files changed, 4907 insertions(+), 3368 deletions(-)
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
