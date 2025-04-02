Return-Path: <kvm+bounces-42420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14993A78577
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1728C16C979
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA58715D1;
	Wed,  2 Apr 2025 00:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C/XFW7bx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0269517D2;
	Wed,  2 Apr 2025 00:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743552880; cv=none; b=s7mI6HPsO1oM+GB5gBTRJJxLJPV++PYiPukzk/gVF+WGNJmSb0HIJ8w+NL8tjhYdgILa9Xs5+ptSYeLV06zzGRPQk3Eq2TQQTGuFFGP3F+OboSGx6S8gJMt+kqDIgpT/bsS+b30XMXTQBvUkiyzC8/BeSi/9SHy2dUXuFLj7sVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743552880; c=relaxed/simple;
	bh=VKuB5VNZHwmf7dVeG+0DyBeZXaTh+rkqmWf/X7UwzRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tu+xyloE73iLjlmdSHYjSLv4Ge1ozEFEapPPen71GcABF48OPJEKn+LOjpgM/HoNaaU0uoa+JOW2QZkT7/NOZwWeixfFz6r8vpm6xQNibhSisT20Q802VazmWWrmATk9h9ZrgYZ6xMmsIP+83UrNopOLdtW64BrDrWSN/TsXCp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C/XFW7bx; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743552878; x=1775088878;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VKuB5VNZHwmf7dVeG+0DyBeZXaTh+rkqmWf/X7UwzRo=;
  b=C/XFW7bxNq7Sar+X82Raslt95JEjcgPUE/w7FGncLYHpwe8aQPXGh17u
   4YAIvnG/OeZjso80mQ34kRECXrefceab0OtPmAhLAnqedYKntZ+ezc/ZB
   cHYrdwhEXmRS+keauQNOO7flvX3+Tl6+/7uVSVTIqL82B3W5FONNwYhEs
   MYpu4M/oVKR8IxnpAFmfohoxDhIqAiNhfV71iazM5NkqbsnUBX4zqkGf8
   pZxxJVN5A0I6kUn5W/qF3dewtypPMsUD4Ya00lPbbLqWd0KeIo25o4xbx
   95Ko2iqkMtaUozk+eM8wq0rDIiH1COsl0AsSGDBYuF1Q2Y04+f3wc6Vz5
   A==;
X-CSE-ConnectionGUID: 3Efw2bNxTNy2hBENwptWkA==
X-CSE-MsgGUID: TeYpEiQeQfiaI/USAhl2oA==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="44148826"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="44148826"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:14:37 -0700
X-CSE-ConnectionGUID: lGQPXFIrT3au0xWGF6osHg==
X-CSE-MsgGUID: pSAU9WFlQcyqmBkuHWOmeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="131673938"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:14:34 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	mikko.ylinen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 0/2] TDX attestation support
Date: Wed,  2 Apr 2025 08:15:55 +0800
Message-ID: <20250402001557.173586-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

TDX Guest-Host Communication Interface (GHCI) [0] spec defines two
TDVMCALLs for TDX attestation mechanism.

Paolo mentioned possibly wanting to include attestation in the initial TDX
support. Please consider it with that as the tentative plan. If it is not
included in the initial support, it would require an opt-in when the
support is added.

- TDG.VP.VMCALL<GetQuote>
  GetQuote is a doorbell-like interface used by TDX guests to request VMM
  to generate a TD-Quote signed by a service hosting TD-Quoting Enclave
  operating on the host.
- TDG.VP.VMCALL<SetupEventNotifyInterrupt>
  SetupEventNotifyInterrupt can be used by TDX guests to specify an
  interrupt vector as an event-notify vector for GetQuote operation, which
  may take several seconds. If a TDX guest has setup the event-notify
  vector, the host VMM injects an interrupt with the specified vector to
  the TDX guest on completion of the operation.

This patch series adds the support for TDX attestation on KVM side. KVM
forwards the requests to userspace VMM after sanity checks.  Instead of
using a single KVM_EXIT_TDX, it's preferred that each TDVMCALL that KVM
wants to forward needs a dedicated KVM_EXIT_<reason> and associated struct
in the exit union [1].  The TDVMCALLs supported in [2] reuse the existing
KVM exit reasons.  For TDX attestation support, add two TDX specific KVM
exit reasons based on the discussion in the PUCK meeting on 2025.02.19 [3].
After returning from userspace, KVM sets the return code specified by
userspace before resuming the vCPU.

Note that AMD has taken 40 for KVM_EXIT_SNP_REQ_CERTS in the patch [4]
under review, to avoid conflict, use number 41 for KVM_EXIT_TDX_GET_QUOTE
and number 42 for KVM_EXIT_TDX_SETUP_EVENT_NOTIFY.

Opens
=====
Linux TDX guests don't use SetupEventNotifyInterrupt for TD attestation
currently. If no other TDX guests use it, the support for
SetupEventNotifyInterrupt could be dropped. But it would require an opt-in
if the support is added later.

In this patch series, KVM does sanity checks for the TDVMCALLs so that
different userspace VMMs can save the code for sanity checks. But it could
be dropped if it's preferred to keep KVM code simpler and let the userspace
VMMs take the responsibility.


Base of this series
===================
This series is based on kvm-coco-queue with the commit:
- 'b7f073baa6ad' ("KVM: SVM: Enable Secure TSC for SNP guests")


Notable changes since v19 [5]
=============================
The KVM exit reason to userspace for the two TDVMCALLs was KVM_EXIT_TDX in
v19 and Sean suggested to use a dedicated KVM_EXIT_<reason> for each
TDVMCALL that exits to userspace [1].  The attestation support was dropped
in the TDX userspace exit series [6].  Now, it's changed to use two new TDX
specific KVM exit reasons KVM_EXIT_TDX_GET_QUOTE and
KVM_EXIT_TDX_SETUP_EVENT_NOTIFY.


Repos
=====
The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2025-04-01

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-wip-2025-03-19

It requires TDX module 1.5.06.00.0744 [7], or later.
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").


Testing
=======
This patch series has been tested as part of the development branch for the
TDX base series.  The testing consisted of TDX kvm-unit-tests and booting a
Linux TD, and TDX enhanced KVM selftests.  It also passed the TDX related
test cases defined in the LKVS test suite as described in:
https://github.com/intel/lkvs/blob/main/KVM/docs/lkvs_on_avocado.md

The functionality of GetQuote has been tested with the Quote Generation
Service deployed on the host, thanks to Mikko Ylinen.

Two KVM selftests patches below were used to test the flows of GetQuote and
SetupEventNotifyInterrupt as well:
https://github.com/intel/tdx/commit/9f059b6b40d957364aeeefbbf743d080feaed501
https://github.com/intel/tdx/commit/4dd797afe5bccb7a36475aae9df8f71eabb7676a


[0] https://cdrdv2.intel.com/v1/dl/getContent/726792
[1] https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com
[2] https://lore.kernel.org/kvm/20250222014225.897298-1-binbin.wu@linux.intel.com
[3] https://drive.google.com/file/d/1fk957DWsyqWk-K-FqhBxdUtgrQYcZrqH/view?usp=drive_link&resourcekey=0-JFJuzmaZIux6_D6lhcxT7Q
[4] https://lore.kernel.org/kvm/20250219151505.3538323-2-michael.roth@amd.com
[5] https://lore.kernel.org/kvm/b9fbb0844fc6505f8fb1e9a783615b299a5a5bb3.1708933498.git.isaku.yamahata@intel.com/
[6] https://lore.kernel.org/kvm/20250222014225.897298-1-binbin.wu@linux.intel.com
[7] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06

Binbin Wu (2):
  KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
  KVM: TDX: Handle TDG.VP.VMCALL<SetupEventNotifyInterrupt>

 Documentation/virt/kvm/api.rst    | 39 +++++++++++++++++++++
 arch/x86/include/asm/shared/tdx.h |  1 +
 arch/x86/kvm/vmx/tdx.c            | 56 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          | 13 +++++++
 4 files changed, 109 insertions(+)

-- 
2.46.0


