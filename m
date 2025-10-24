Return-Path: <kvm+bounces-60961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D298FC04812
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:34:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 923574F354B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA64B22370D;
	Fri, 24 Oct 2025 06:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AYcNEwYP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83C52153D2
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287680; cv=none; b=NHeBdxTYrzIUUxbqh0Aa4OS99irjJ1eHw540cYp0hMiO2GKwnpQxzGBHCwG9msd1zXmiw4OlaOFibQcC+lXQm8z94O6AziD+7AXVJnURZZrRwenWQKwWFjqSg1ys9fZPylHlmrtltIQtm7kAv2BLTLTEcyRRw5GZ6FU31+cy2u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287680; c=relaxed/simple;
	bh=0vwFoNdFcHLi/HQ/rXcTxHECC2JAXDzG6T5GA7aPM9k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QI8gwaUFjq8oU7RsMcNhEnCnxg8bNsHRIKbadgrTsirmgf7Hhtj4lr6ki4iLi8+C2Wfb8wfckxRN4zbnkYsjYM+HWsMc+iyMQ+iF7NizLQfvomOGVs2iaFiI64tZEX+8SymZ8cyUqiwt1TBkQXX5kI4EsZFXsFS1RyOMYj4tUL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AYcNEwYP; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287678; x=1792823678;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0vwFoNdFcHLi/HQ/rXcTxHECC2JAXDzG6T5GA7aPM9k=;
  b=AYcNEwYPvFMp7NI0jct7mnCFnqQ6mWljXFof1qRM/dc/1Df8iauJljL2
   M1p/EWM3G57KpANbke4Kvs7ZvWr6WK4m6oLj45NFYONDZzORz5szDmDvz
   yirnxfvU/7VEHoJXNPyCUo9p9X9ppcRxx/PHOTkexlUTwdmrVPc3s45cB
   eGvHsHX+g2qIn+KcMTr6Ym4j9X+7Dw6qb/ppDQGsaC/uYusJRd316SUyM
   hDK/xmMPAnxjlv0qEoJggW89bcHzsst18GoDxC9arTZEztNrl6psaz4Tn
   2qfY0MqgXOLHjaobRguEKk9c/WC+H8yF3FRDHtvfQD6BS2UkYE/h9UbDB
   w==;
X-CSE-ConnectionGUID: Wynq/dvEQbeseQhNQtw3Ow==
X-CSE-MsgGUID: +eYooGDOS/GPW02HYgiYJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86095539"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="86095539"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:34:38 -0700
X-CSE-ConnectionGUID: flYQLtPjRgi3m8pUAfNovA==
X-CSE-MsgGUID: sWKOiGYiRn6N2DE67vWT1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184275849"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:34:34 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 00/20] i386: Support CET for KVM
Date: Fri, 24 Oct 2025 14:56:12 +0800
Message-Id: <20251024065632.1448606-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This the v3 series to support CET (CET-SHSTK & CET-IBT) in QEMU, which
is based on the commit c0e80879c876 ("Merge tag 'pull-vfio-20251022' of
https://github.com/legoater/qemu into staging"). And you can also find
the code here:

https://gitlab.com/zhao.liu/qemu/-/commits/i386-cet-v1-10-22-2025

Compared to v2 [1] (posted two years ago), the basic CET support (
xstate/MSR/vmstate/CPUID) remains roughly unchanged. And I also noted
the change logs in the patches inherited from v2.

Thanks for your feedback!

Overview
========

Control-flow enforcement technology includes 2 x86-architectural
features:
 - CET shadow stack (CET-SHSTK or CET-SS).
 - CET indirect branch tracking (CET-IBT).

Intel has implemented both 2 features since Sapphire Rapids (P-core) &
Sierra Forest (E-core).

AMD also implemented shadow stack since Zen3 [2] - this series has
considerred only-shstk case and is supposed to work on AMD platform, but
I hasn't tested this on AMD.

The basic CET support (patch 11-17) includes:
 * CET-S & CET-U supervisor xstates support.
 * CET CPUIDs enumeration.
 * CET MSRs save & load.
 * CET guest SSP register (KVM treats this as a special internal
   register - KVM_REG_GUEST_SSP) save & load.
 * Vmstates for MSRs & guest SSP.

But before CET support, there's a lot of cleanup work needed for
supervisor xstate.

Before CET-S/CET-U, QEMU has already supports arch lbr as the 1st
supervisor xstate. Although arch LBR has not yet been merged into KVM
(still planned), this series cleans up supervisor state-related support
and avoids breaking the current arch LBR in QEMU - that's what patch
2-10 are doing.

Additionally, besides KVM, this series also supports CET for TDX.

[1]: https://lore.kernel.org/qemu-devel/20230720111445.99509-1-weijiang.yang@intel.com/
[2]: https://lore.kernel.org/all/20250908201750.98824-1-john.allen@amd.com/

Thanks and Best Regards,
Zhao
---
Chao Gao (1):
  i386/cpu: Fix supervisor xstate initialization

Chenyi Qiang (1):
  i386/tdx: Add CET SHSTK/IBT into the supported CPUID by XFAM

Yang Weijiang (5):
  i386/cpu: Enable xsave support for CET states
  i386/kvm: Add save/load support for CET MSRs
  i386/kvm: Add save/load support for KVM_REG_GUEST_SSP
  i386/machine: Add vmstate for cet-ss and cet-ibt
  i386/cpu: Advertise CET related flags in feature words

Zhao Liu (13):
  linux-headers: Update to v6.18-rc2
  i386/cpu: Clean up indent style of x86_ext_save_areas[]
  i386/cpu: Clean up arch lbr xsave struct and comment
  i386/cpu: Reorganize arch lbr structure definitions
  i386/cpu: Make ExtSaveArea store an array of dependencies
  i386/cpu: Add avx10 dependency for Opmask/ZMM_Hi256/Hi16_ZMM
  i386/cpu: Reorganize dependency check for arch lbr state
  i386/cpu: Drop pmu check in CPUID 0x1C encoding
  i386/cpu: Add missing migratable xsave features
  i386/cpu: Add CET support in CR4
  i386/cpu: Mark cet-u & cet-s xstates as migratable
  i386/cpu: Enable cet-ss & cet-ibt for supported CPU models
  i386/tdx: Fix missing spaces in tdx_xfam_deps[]

 include/standard-headers/linux/ethtool.h      |   1 +
 include/standard-headers/linux/fuse.h         |  22 +-
 .../linux/input-event-codes.h                 |   1 +
 include/standard-headers/linux/input.h        |  22 +-
 include/standard-headers/linux/pci_regs.h     |  10 +
 include/standard-headers/linux/virtio_ids.h   |   1 +
 include/standard-headers/linux/virtio_rtc.h   | 237 ++++++++++++++++++
 include/standard-headers/linux/virtio_spi.h   | 181 +++++++++++++
 linux-headers/asm-loongarch/kvm.h             |   1 +
 linux-headers/asm-riscv/kvm.h                 |  23 +-
 linux-headers/asm-riscv/ptrace.h              |   4 +-
 linux-headers/asm-x86/kvm.h                   |  34 +++
 linux-headers/asm-x86/unistd_64.h             |   1 +
 linux-headers/asm-x86/unistd_x32.h            |   1 +
 linux-headers/linux/kvm.h                     |   3 +
 linux-headers/linux/psp-sev.h                 |  10 +-
 linux-headers/linux/stddef.h                  |   1 -
 linux-headers/linux/vduse.h                   |   2 +-
 linux-headers/linux/vhost.h                   |   4 +-
 target/i386/cpu.c                             | 227 ++++++++++++-----
 target/i386/cpu.h                             |  99 ++++++--
 target/i386/helper.c                          |  12 +
 target/i386/kvm/kvm.c                         | 103 ++++++++
 target/i386/kvm/tdx.c                         |  20 +-
 target/i386/machine.c                         |  53 ++++
 25 files changed, 968 insertions(+), 105 deletions(-)
 create mode 100644 include/standard-headers/linux/virtio_rtc.h
 create mode 100644 include/standard-headers/linux/virtio_spi.h

-- 
2.34.1


