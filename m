Return-Path: <kvm+bounces-32790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F559DF48F
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 04:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2622DB211C7
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 03:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556CC33086;
	Sun,  1 Dec 2024 03:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SLLzP2oK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAD317BD9;
	Sun,  1 Dec 2024 03:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733025119; cv=none; b=aLQTwoOxYbtptggWfYkzcHwpR4PyhHjlTuVTQeK+qX+thUf0Q4O9iFYFBrPEvwhn8BVrm+PerUvpRE/6uDu6r+iIM1zCNaUsvVfAXhQ0y7z5Fo6mQF7MUbhBE1bmjw+JTd6IiuuR+LhtmiGUEw7Ka5ua6jZToDTwK3qKa72Mr7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733025119; c=relaxed/simple;
	bh=vGQflEwPvwJ0Lzq/VzKUMmpY6cfV6p22GJrcn1WxeZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r3IbNGP25Zxz8P+//6+ZoE4SlJsw7FW2fuwfMtl0oo5+x+8BrX05Ka+kfBh1VwY5SmfxCNO50DtxQdeothY9JT5iEfk5lQyZqVeC58cnGL+eQ/j8Y4Wsmxw8LLZ/uszCSEI1lz6wKEa32CfAbMqBP4rH3/ShfvvqnTLelft3KFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SLLzP2oK; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733025117; x=1764561117;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vGQflEwPvwJ0Lzq/VzKUMmpY6cfV6p22GJrcn1WxeZs=;
  b=SLLzP2oKZou9WaVdSXGQNriFxbils4qrpNLhcgvfqE406Nd9+vUwR/vk
   HVgS838YgInMhNtO6zrhXdRJP2KUkhiNBHj53iOmMYsp1MKzA5Oy13kbu
   JaoHj6FKMAjEUuoVtVOx53iaY6wo2fdQBn2DwOjv54syamnnDVcT4zJoz
   Uuz3dz3o2fo9Gk9J0S16vqXFQRCI8QRw6+FCUSxF+Q+h/O/OxKWy/flzE
   0DkUUbm2Vum7GuUixIfR4Nfj/6WPfbRLqGxih9a+8zoqDPkdxtPhNOOOm
   W4GOKDDRF1O8ZRZLfx6jRHxSWbqK3qSXiFCtco13hQMWGKAmx9FOssq5g
   A==;
X-CSE-ConnectionGUID: ZPWbcjMURTO3EXaxuRcV+A==
X-CSE-MsgGUID: YohPrQdeT2iwZqNI8HFPDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11272"; a="50725092"
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="50725092"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:51:57 -0800
X-CSE-ConnectionGUID: 7JKxVE+vQ+eo4onj1Ay9WA==
X-CSE-MsgGUID: +CPfsHgBTIivubTZssYVvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="93257477"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:51:53 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	michael.roth@amd.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 0/7] KVM: TDX: TDX hypercalls may exit to userspace
Date: Sun,  1 Dec 2024 11:53:49 +0800
Message-ID: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

When executing in the TD, TDX can exit to the host VMM (KVM) for many
reasons. These reasons are analogous to the exit reasons for VMX. Some of
the exits will be handled within KVM in later changes. This series handles
just the TDX exits that may be passed to userspace to handle, which are all
via the TDCALL exit code. Although, these userspace exits have the same TDX
exit code, they result in several different types of exits to userspace.

This patch set is one of several patch sets that are all needed to provide
the ability to run a functioning TD VM. The goal of this patch set is to
facilitate the review and finalization of the uAPI between KVM and userspace
VMMs (e.g., QEMU). We would like get maintainers/reviewers feedback of the
implementation (i.e. the design of individual KVM exits instead of one raw
TDX exit), but we don't think it is ready for kvm-coco-queue yet.

Base of this series
===================
This series is based off of a kvm-coco-queue commit and some pre-req series:
1. commit ee69eb746754 ("KVM: x86/mmu: Prevent aliased memslot GFNs") (in
   kvm-coco-queue).
2. v7 of "TDX host: metadata reading tweaks and bug fixes and info dump" [0]
3. v1 of "KVM: VMX: Initialize TDX when loading KVM module" [1]
4. v2 of “TDX vCPU/VM creation” [2]
5. v2 of "TDX KVM MMU part 2" [3]
6  v1 of "TDX vcpu enter/exit" [4] with a few fixups based on review feedbacks.
7. v4 of "KVM: x86: Prep KVM hypercall handling for TDX" [5]

TDX hypercalls
==============
The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL) for the
guest TDs to make hypercall to VMM.  When a guest TD issues a TDVMCALL, it
exits to VMM with a new exit reason.  The arguments from the guest TD and
return values from the VMM are passed through the guest registers.  The
ABI details for the guest TD hypercalls are specified in the TDX Guest-Host
Communication Interface (GHCI) specification [6].

There are two types of hypercalls defined in the GHCI specification:
- Standard TDVMCALLs: When input of R10 from guest TD is set to 0, it
  indicates that the TDVMCALL sub-function used in R11 is defined in GHCI
  specification.
- Vendor-Specific TDVMCALLs: When input of R10 from guest TD is non-zero,
  it indicates a vendor-specific TDVMCALL. For KVM hypercalls from guest
  TDs, KVM uses R10 as KVM hypercall number and R11-R14 as 4 arguments,
  with the error code returned in R10.

KVM hypercalls
--------------
This series supports KVM hypercalls from guest TDs following the 
vendor-specific interface described above.  The KVM_HC_MAP_GPA_RANGE
hypercall will need to exit to userspace for handling.

Standard TDVMCALLs exiting to userspace
---------------------------------------
To support basic functionality of TDX,  this series includes the following
standard TDVMCALL sub-functions, which reuse exist exit reasons when they
need to exit to userspace for handling:
- TDG.VP.VMCALL<MapGPA> reuses exit reason KVM_EXIT_HYPERCALL with the
  hypercall number KVM_HC_MAP_GPA_RANGE.
- TDG.VP.VMCALL<ReportFatalError> reuses exit reason KVM_EXIT_SYSTEM_EVENT
  with a new event type KVM_SYSTEM_EVENT_TDX_FATAL.
- TDG.VP.VMCALL<Instruction.IO> reuses exit reason KVM_EXIT_IO.
- TDG.VP.VMCALL<#VE.RequestMMIO> reuses exit reason KVM_EXIT_MMIO.

Support for TD attestation is currently excluded from the TDX basic enabling,
so handling for TDG.VP.VMCALL<SetupEventNotifyInterrupt> and 
TDG.VP.VMCALL<GetQuote> is not included in this patch series.

Notable changes since v19
=========================
There are a several minor changes across the patches. A few more structural
changes are highlighted below.

Move out NMI, exception and external interrupt handling code
------------------------------------------------------------
Since this series is focusing on the hypercall that may exit to userspace,
the code for handling NMI, exception and external interrupt has been moved
out from "KVM: TDX: Add a place holder to handle TDX VM exit" to a future
series focusing on interrupts.

Remove the use of union tdx_exit_reason
---------------------------------------
As suggested by Sean, the use of union tdx_exit_reason has been removed.
The VMX exit reason is used only when the return value of TDH.VP.ENTER has
a valid VMX exit reason.
https://lore.kernel.org/kvm/ZfSExlemFMKjBtZb@google.com/ 

Remove the KVM exit reason KVM_EXIT_TDX
---------------------------------------
Each TDX hypercall needing to exit to userspace now has dedicated exit
reason.  No new exit reasons are added in this series; existing exit reasons
are reused though.

Repos
=====
The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-11-20-exits-userspace

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v6.1

Testing 
======= 
It has been tested as part of the development branch for the TDX base
series. The testing consisted of TDX kvm-unit-tests and booting a Linux
TD, and TDX enhanced KVM selftests.

[0] https://lore.kernel.org/kvm/cover.1731318868.git.kai.huang@intel.com
[1] https://lore.kernel.org/kvm/cover.1730120881.git.kai.huang@intel.com
[2] https://lore.kernel.org/kvm/20241030190039.77971-1-rick.p.edgecombe@intel.com
[3] https://lore.kernel.org/kvm/20241112073327.21979-1-yan.y.zhao@intel.com
[4] https://lore.kernel.org/kvm/20241121201448.36170-1-adrian.hunter@intel.com
[5] https://lore.kernel.org/kvm/20241128004344.4072099-1-seanjc@google.com
[6] https://cdrdv2.intel.com/v1/dl/getContent/726792

Binbin Wu (2):
  KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
  KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>

Isaku Yamahata (4):
  KVM: TDX: Add a place holder to handle TDX VM exit
  KVM: TDX: Add a place holder for handler of TDX hypercalls
    (TDG.VP.VMCALL)
  KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
  KVM: TDX: Handle TDX PV port I/O hypercall

Sean Christopherson (1):
  KVM: TDX: Handle TDX PV MMIO hypercall

 Documentation/virt/kvm/api.rst    |   8 +
 arch/x86/include/asm/shared/tdx.h |   1 +
 arch/x86/include/asm/tdx.h        |   1 +
 arch/x86/include/uapi/asm/vmx.h   |   4 +-
 arch/x86/kvm/vmx/main.c           |  25 +-
 arch/x86/kvm/vmx/tdx.c            | 578 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h            |   3 +
 arch/x86/kvm/vmx/tdx_errno.h      |   3 +
 arch/x86/kvm/vmx/x86_ops.h        |   8 +
 arch/x86/kvm/x86.c                |   1 +
 include/uapi/linux/kvm.h          |   1 +
 virt/kvm/kvm_main.c               |   1 +
 12 files changed, 630 insertions(+), 4 deletions(-)

-- 
2.46.0


