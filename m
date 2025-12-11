Return-Path: <kvm+bounces-65718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0A0CB4E5B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D431300B9B1
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D5529C351;
	Thu, 11 Dec 2025 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BoL16RoV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6FA296BBA
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435510; cv=none; b=i9wXjIJjkClvWMfEioe4B8Xhhiw+kbpNmd0lBptNmyGolnzXzkhxGflYSlYLER8MiWS7s+Ri7BK37zOI5T25Ft1Kokf/52YaoiQ2ZUDPvROcHkZXsmnMv4/UL0NzuMFGsbs1VEblgaJ6m5we87jFAKEMXA6ga1fcd/NFAb3Wz3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435510; c=relaxed/simple;
	bh=tsw5t+Ji+q9rUQAu29JiPo8AKxg5zcGSfYSkL5PtPKQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=VO8n1OmvHo5VBGC2HGZkfHKbimkxMIDt9/OyEJRSTd8ZSO0INpn/4btTp0uM8G3TCsYeKltfm1ms5L32GOH5sqFaTtDAyDBlQlVdqY/EYReyfd2QnX2cZc1lYjK4HnUKh8tC7fYxu7akVupkOfwdGH1pugq2Seg/TRwWk3zdURw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BoL16RoV; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435509; x=1796971509;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tsw5t+Ji+q9rUQAu29JiPo8AKxg5zcGSfYSkL5PtPKQ=;
  b=BoL16RoV4+FHHp2YfW0ZGySl3UyewCclJOWJzkE9UL3AQ7VZJOFZMttY
   H9pU0NY9WGsyRM2Yghhiu4et867JcE+VtQ362Gh2VIAMzOXP12pETGGBe
   sIgobedRByIsV5367wgzXQ5/dTUeXoxQyNDcj28xcpFLAteL6FgKi7KPf
   hsk4C8OCGbCJsN+mmnrsh3/3OSYP3BA6fqRy3PooApQBp1BieZi/ip15h
   3O1a3gM+jDDW+ulJAMTcYLV8VUnbKHMKq/uMpRqS4/9N1jTjWe+py5kVP
   cfMHuZ4jaTSGFpwbVAxqNpnJM1PtJQt3CVqoPP4/1jbB1TZq5NVP0SPn9
   g==;
X-CSE-ConnectionGUID: g8BCA1+2TxS9yDcHf10tRg==
X-CSE-MsgGUID: ARjORS0nSfaQHxTPITXVJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584417"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584417"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:09 -0800
X-CSE-ConnectionGUID: zjWLogr3R+ekPbc4O2nGaw==
X-CSE-MsgGUID: oeVQQGVCQqaN10bhDO6xag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196494885"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:05 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 0/9] i386/cpu: Support APX for KVM
Date: Thu, 11 Dec 2025 15:09:33 +0800
Message-Id: <20251211070942.3612547-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This series adds APX (Advanced Performance Extensions) support in QEMU
to enable APX in Guest based on KVM (RFC v1 [1]).

This series is based on CET v5:

https://lore.kernel.org/qemu-devel/20251211060801.3600039-1-zhao1.liu@intel.com/

And you can also find the code here:

https://gitlab.com/zhao.liu/qemu/-/commits/i386-all-for-dmr-v2.1-12-10-2025

Compared with v1 [2], v2 adds:
 * HMP support ("print" & "info registers").
 * gdbstub support.

Thanks for your review!


Overview
========

Intel Advanced Performance Extensions (Intel APX) expands the Intel 64
instruction set architecture with access to more registers (16
additional general-purpose registers (GPRs) R16–R31) and adds various
new features that improve general-purpose performance. The extensions
are designed to provide efficient performance gains across a variety of
workloads without significantly increasing silicon area or power
consumption of the core.

APX spec link (rev.07) is:
https://cdrdv2.intel.com/v1/dl/getContent/861610

At QEMU side, the enabling work mainly includes three parts:

1. save/restore/migrate the xstate of APX.
   * APX xstate is a user xstate, but it reuses MPX xstate area in
     un-compacted XSAVE buffer.
   * To address this, QEMU will reject both APX and MPX if their CPUID
     feature bits are set at the same (in Patch 1).

2. add related CPUIDs support in feature words.

3. debug support, including HMP & gdbstub.


Change Log
==========

Changes sicne v1:
 * Expend current GPR array (CPUX86State.regs) to 32 elements instead of
   a new array.
 * HMP support ("print" & "info registers").
 * gdbstub support.

[1]: KVM RFC: https://lore.kernel.org/kvm/20251110180131.28264-1-chang.seok.bae@intel.com/
[2]: QEMU APX v1: https://lore.kernel.org/qemu-devel/20251118065817.835017-1-zhao1.liu@intel.com/

Thanks and Best Regards,
Zhao
---
Zhao Liu (6):
  i386/machine: Use VMSTATE_UINTTL_SUB_ARRAY for vmstate of
    CPUX86State.regs
  i386/gdbstub: Add APX support for gdbstub
  i386/cpu-dump: Dump entended GPRs for APX supported guest
  i386/monitor: Support EGPRs in hmp_print
  i386/cpu: Support APX CPUIDs
  i386/cpu: Mark APX xstate as migratable

Zide Chen (3):
  i386/cpu: Add APX EGPRs into xsave area
  i386/cpu: Cache EGPRs in CPUX86State
  i386/cpu: Add APX migration support

 configs/targets/x86_64-softmmu.mak |  2 +-
 gdb-xml/i386-64bit-apx.xml         | 26 +++++++++++
 include/migration/cpu.h            |  4 ++
 target/i386/cpu-dump.c             | 30 +++++++++++--
 target/i386/cpu.c                  | 68 ++++++++++++++++++++++++++++-
 target/i386/cpu.h                  | 48 +++++++++++++++++++--
 target/i386/gdbstub.c              | 69 +++++++++++++++++++++++++++++-
 target/i386/machine.c              | 27 +++++++++++-
 target/i386/monitor.c              | 16 +++++++
 target/i386/xsave_helper.c         | 16 +++++++
 10 files changed, 293 insertions(+), 13 deletions(-)
 create mode 100644 gdb-xml/i386-64bit-apx.xml

-- 
2.34.1


