Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8658E47FAED
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 09:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhL0IRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 03:17:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:31598 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231358AbhL0IRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 03:17:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640593032; x=1672129032;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tCJzGvAoR9V3Cf25Th6SaPQVLQdtAnnLPINob5E2Vys=;
  b=CLSXoNF7DAYhlP6g9oHvqqHNlL25wbeXn08/h+oC8mbY1WOaOYL7uyKB
   n5MjyUOfcA8xE5vcoyZP/95gcA5nmA/VdanDXxOORd85F8zQs0SCuYddK
   g92KAAuC0ffcvQPc/PnJHVCYauF/MOROgSXkFtfYx9p+Lc/ZkUoSW/d8D
   kZLJF8BWwZCIA3fCLaOk+Wj8HRSZnnvbFjIsRhTgHHDcGxf+CYbhoEGCI
   Ld3X3cmk+1SxKfqhXhTfmC37k/wKgnSJ8Acplv1ht4005b7lYzPr2GZVT
   yf523CC+7ZyKHfKjSekbj0y7qYaLgMVd7wcND9FEMTMmS6pUnahNXTHQj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10209"; a="221182045"
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="221182045"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="523207964"
Received: from unknown (HELO hyperv-sh4.sh.intel.com) ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:16:56 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Garry <john.garry@huawei.com>,
        kvmarm@lists.cs.columbia.edu, kvm-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Marc Zyngier <maz@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>, x86@kernel.org
Subject: [PATCH 0/6] Improve KVM's interaction with CPU hotplug
Date:   Mon, 27 Dec 2021 16:15:06 +0800
Message-Id: <20211227081515.2088920-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM registers its CPU hotplug callback to CPU starting section. And in the
callback, KVM enables hardware virtualization on hotplugged CPUs if any VM
is running on existing CPUs.

There are two problems in the process:
1. KVM doesn't do compatibility checks before enabling hardware
virtualization on hotplugged CPUs. This may cause #GP if VMX isn't
supported or vmentry failure if some in-use VMX features are missing on
hotplugged CPUs. Both break running VMs.
2. Callbacks in CPU STARTING section cannot fail. So, even if KVM finds
some incompatible CPUs, its callback cannot block CPU hotplug.

This series improves KVM's interaction with CPU hotplug to avoid
incompatible CPUs breaking running VMs. Following changes are made:

1. move KVM's CPU hotplug callback to ONLINE section (suggested by Thomas)
2. do compatibility checks on hotplugged CPUs.
3. abort onlining incompatible CPUs if there is a running VM.

This series is a follow-up to the discussion about KVM and CPU hotplug
https://lore.kernel.org/lkml/3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com/T/

Note: this series is tested only on Intel systems.

Chao Gao (6):
  KVM: x86: Move check_processor_compatibility from init ops to runtime
    ops
  KVM: x86: Use kvm_x86_ops in kvm_arch_check_processor_compat
  KVM: Remove opaque from kvm_arch_check_processor_compat
  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
  KVM: x86: Remove WARN_ON in kvm_arch_check_processor_compat
  KVM: Do compatibility checks on hotplugged CPUs

 arch/arm64/kvm/arm.c            |  2 +-
 arch/mips/kvm/mips.c            |  2 +-
 arch/powerpc/kvm/powerpc.c      |  2 +-
 arch/riscv/kvm/main.c           |  2 +-
 arch/s390/kvm/kvm-s390.c        |  2 +-
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          |  4 +-
 arch/x86/kvm/vmx/evmcs.c        |  2 +-
 arch/x86/kvm/vmx/evmcs.h        |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 12 +++---
 arch/x86/kvm/x86.c              |  7 +---
 include/linux/cpuhotplug.h      |  2 +-
 include/linux/kvm_host.h        |  2 +-
 virt/kvm/kvm_main.c             | 74 ++++++++++++++++++++++++---------
 14 files changed, 74 insertions(+), 43 deletions(-)

-- 
2.25.1

