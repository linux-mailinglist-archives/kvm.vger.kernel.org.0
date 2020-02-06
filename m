Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B381154733
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgBFPKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:10:40 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45323 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbgBFPKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 10:10:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id a6so7592925wrx.12;
        Thu, 06 Feb 2020 07:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=y0Ojwov/p4Jd1JXFXjHbwQfCbylx1jkuhxgufPLa1OA=;
        b=pDMRkwPJqrBih1TASmqx/inhRtwNlegH4FgcuQa+x+0CuZ1W4in1lZNkwWLXutEDYZ
         12nmARn2+gmNSdGIYBSmmQsMzLOAe9RrR0CUvsiT9GjIrSAmwCHjAWtjWtxxYwIIFcLI
         8D0lrNW0ARRm/4Y9m4gA2FOU5ULq0CPMfBtQiRIdgjKwmvGaPIWP/ut6kBSxt5RPrlA6
         Zkcixz2Afs8bnRPmo7sQrszeJPHFJA7lHDpp9YH9TAgizTAipHcgahKaS8mOTifKnbYM
         gc+xXupHP0pkrL8u98nyQoQc7JmnVs2PkGRc70RMfiwNaR0i1JHXpwVAoNlJfKdsIQsz
         HUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=y0Ojwov/p4Jd1JXFXjHbwQfCbylx1jkuhxgufPLa1OA=;
        b=E+49KTC9RKh9L2FBcp2YK1dUMp1AaCXZc8lj95NeLkjk3Cn2VK3A/DDGozUCk3yost
         yUj5cL7iuHlDDZHRaQJ7DUfRM1MejcyDu8kjn37I+O8dcz2KjZF1kMrR+6Kd7rgBz+2q
         530/E3vU5QQnj51Xth/REkS8Zj9lq+ZVzp58gA6Trrj1eLOSBcs2Op5y0KcwmcywfbNe
         KqlJTxm0lV3VNRYHgCkDPxveM+4yeYHuoHWUf496SyxCzE6fsHJKEnm93HhGWtIl9cMl
         QBFGtQifpu0NzkVSriRE9Gt9OHyb7TPifeQbbMVTBBRXWg03cVv2fr36GWbcE6c4EKFz
         kKjQ==
X-Gm-Message-State: APjAAAWWrTFz02E5kMH9UK8u1oy7dygbXCGOLEb38WBK6+oHceS/BVP+
        Js8QFTXErhJtleHK5gWp2MAZ4pIL
X-Google-Smtp-Source: APXvYqx2ijJjkVCaZvijNI6ErmO4C3TqUYvFIXxr/sRwhZDfu7TKh1eWF55YylJGpsaCn1bwx5lUMA==
X-Received: by 2002:adf:ca07:: with SMTP id o7mr4135355wrh.49.1581001834954;
        Thu, 06 Feb 2020 07:10:34 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r5sm4471032wrt.43.2020.02.06.07.10.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Feb 2020 07:10:34 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for 5.6 merge window
Date:   Thu,  6 Feb 2020 16:10:31 +0100
Message-Id: <1581001831-17609-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit e813e65038389b66d2f8dd87588694caf8dc2923:

  Merge tag 'kvm-5.6-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2020-01-31 09:30:41 -0800)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-5.6-2

for you to fetch changes up to a8be1ad01b795bd2a13297ddbaecdb956ab0efd0:

  KVM: vmx: delete meaningless vmx_decache_cr0_guest_bits() declaration (2020-02-05 16:44:06 +0100)

----------------------------------------------------------------
s390:
* fix register corruption
* ENOTSUPP/EOPNOTSUPP mixed
* reset cleanups/fixes
* selftests

x86:
* Bug fixes and cleanups
* AMD support for APIC virtualization even in combination with
  in-kernel PIT or IOAPIC.

MIPS:
* Compilation fix.

Generic:
* Fix refcount overflow for zero page.

----------------------------------------------------------------
Ben Gardon (2):
      kvm: mmu: Replace unsigned with unsigned int for PTE access
      kvm: mmu: Separate generating and setting mmio ptes

Christian Borntraeger (2):
      KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups
      KVM: s390: do not clobber registers during guest reset/store status

Eric Hankland (1):
      KVM: x86: Fix perfctr WRMSR for running counters

Janosch Frank (4):
      KVM: s390: Cleanup initial cpu reset
      KVM: s390: Add new reset vcpu API
      selftests: KVM: Add fpu and one reg set/get library functions
      selftests: KVM: s390x: Add reset tests

Miaohe Lin (2):
      KVM: nVMX: delete meaningless nested_vmx_run() declaration
      KVM: vmx: delete meaningless vmx_decache_cr0_guest_bits() declaration

Paolo Bonzini (7):
      KVM: x86: remove get_enable_apicv from kvm_x86_ops
      KVM: SVM: allow AVIC without split irqchip
      KVM: x86: reorganize pvclock_gtod_data members
      KVM: x86: use raw clock values consistently
      KVM: SVM: relax conditions for allowing MSR_IA32_SPEC_CTRL accesses
      Merge tag 'kvm-s390-next-5.6-1' of git://git.kernel.org/.../kvms390/linux into HEAD
      x86: vmxfeatures: rename features for consistency with KVM and manual

Pierre Morel (1):
      selftests: KVM: testing the local IRQs resets

Sean Christopherson (5):
      KVM: x86: Take a u64 when checking for a valid dr7 value
      KVM: MIPS: Fix a build error due to referencing not-yet-defined function
      KVM: MIPS: Fold comparecount_func() into comparecount_wakeup()
      KVM: nVMX: Remove stale comment from nested_vmx_load_cr3()
      KVM: x86: Mark CR4.UMIP as reserved based on associated CPUID bit

Suravee Suthikulpanit (15):
      kvm: lapic: Introduce APICv update helper function
      kvm: x86: Introduce APICv inhibit reason bits
      kvm: x86: Add support for dynamic APICv activation
      kvm: x86: Add APICv (de)activate request trace points
      kvm: x86: svm: Add support to (de)activate posted interrupts
      KVM: svm: avic: Add support for dynamic setup/teardown of virtual APIC backing page
      kvm: x86: Introduce APICv x86 ops for checking APIC inhibit reasons
      kvm: x86: Introduce x86 ops hook for pre-update APICv
      svm: Add support for dynamic APICv
      kvm: x86: hyperv: Use APICv update request interface
      svm: Deactivate AVIC when launching guest with nested SVM support
      svm: Temporarily deactivate AVIC during ExtINT handling
      kvm: i8254: Deactivate APICv when using in-kernel PIT re-injection mode.
      kvm: ioapic: Refactor kvm_ioapic_update_eoi()
      kvm: ioapic: Lazy update IOAPIC EOI

Thadeu Lima de Souza Cascardo (1):
      x86/kvm: do not setup pv tlb flush when not paravirtualized

Vitaly Kuznetsov (2):
      x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
      x86/kvm/hyper-v: don't allow to turn on unsupported VMX controls for nested guests

Zhuang Yanying (1):
      KVM: fix overflow of zero page refcount with ksm running

 Documentation/virt/kvm/api.txt                 |  43 ++++++
 arch/mips/kvm/mips.c                           |  37 ++---
 arch/s390/include/asm/kvm_host.h               |   5 +
 arch/s390/kvm/interrupt.c                      |   6 +-
 arch/s390/kvm/kvm-s390.c                       |  92 +++++++-----
 arch/x86/include/asm/kvm_host.h                |  18 ++-
 arch/x86/include/asm/vmx.h                     |   6 +-
 arch/x86/include/asm/vmxfeatures.h             |   6 +-
 arch/x86/kernel/kvm.c                          |   3 +
 arch/x86/kvm/hyperv.c                          |   5 +-
 arch/x86/kvm/i8254.c                           |  12 ++
 arch/x86/kvm/ioapic.c                          | 149 ++++++++++++-------
 arch/x86/kvm/lapic.c                           |  22 ++-
 arch/x86/kvm/lapic.h                           |   1 +
 arch/x86/kvm/mmu/mmu.c                         |  37 +++--
 arch/x86/kvm/svm.c                             | 166 ++++++++++++++++++---
 arch/x86/kvm/trace.h                           |  19 +++
 arch/x86/kvm/vmx/evmcs.c                       |  85 ++++++++++-
 arch/x86/kvm/vmx/evmcs.h                       |   3 +
 arch/x86/kvm/vmx/nested.c                      |  13 +-
 arch/x86/kvm/vmx/pmu_intel.c                   |   9 +-
 arch/x86/kvm/vmx/vmx.c                         |  34 +++--
 arch/x86/kvm/x86.c                             | 139 +++++++++++------
 arch/x86/kvm/x86.h                             |   2 +-
 include/uapi/linux/kvm.h                       |   5 +
 tools/testing/selftests/kvm/Makefile           |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c     |  36 +++++
 tools/testing/selftests/kvm/s390x/resets.c     | 197 +++++++++++++++++++++++++
 virt/kvm/kvm_main.c                            |   1 +
 30 files changed, 925 insertions(+), 233 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/resets.c
