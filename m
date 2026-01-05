Return-Path: <kvm+bounces-67009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5511CF23EF
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 08:44:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E26E3024E74
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 07:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0321B2DAFDE;
	Mon,  5 Jan 2026 07:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e0ZUf1Zr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D60C2D24B7;
	Mon,  5 Jan 2026 07:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767599035; cv=none; b=ZC3rwRTzUeoS3lo9tJLWs/LIYHlWfuylRez9YMVo83CCmJWl6ad2BJmNDjiSJK7st8MgSWioM/n4KlogLcXTuek0f5Db7fGjoc77y2uwzztxcenUkxw4gVHKhbdyEcHr3ELN01Pt992GyQkpTKELXSSYL+/WBY88eJfAKCgFkog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767599035; c=relaxed/simple;
	bh=2lyOMnHQG82Sg13XtiSaQYdBLdtoxIGL7syXiKO2Jpw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d7oPrguOxkuhDkVCckbEtXeK4AXj7Oh7WaXyrKAfTBBfGPcW/yzGjpZ+WqOIpQXdhfB7HaUDzdJ1q12KqTMQzX04JFzysr85uH2gCkJro0MGNdRxyfqVRlKi2FII2292O+0dHscrvOII8KU7QJ93UM1OqRu73qP7NQihdxQKADM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e0ZUf1Zr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767599033; x=1799135033;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2lyOMnHQG82Sg13XtiSaQYdBLdtoxIGL7syXiKO2Jpw=;
  b=e0ZUf1ZrShbDfres7rhxbYlpwLMMznvWlxd7XJlHWDuJPQnxfs+e+fkx
   mvJ7WFQW0lIas8Cf0mQMNF8KGmmXlcuNLH0B3Uz/Ulp7n6p84ocSwz1ue
   TPytAVJPST2HPL42XnE8Y+C5IhPX5FG53W/mJc136vFqit0ZwXw25tUn9
   gOf1EehqnQp8Lt8AWH9bmPBgMw/XgoSrEzRImXLJgmMH6/Fug3lzvbVMg
   XwAyP5GaztvCWjXcCO+e119iSnb46Sc2BLpx1lFCe60+MdvGT3bdE2RBE
   awWEZeLYdd25DifJGgtdDvUKpFCwsm3O9AxbxqPvfFRRfZQQAb26KKLcZ
   g==;
X-CSE-ConnectionGUID: XEH04mXqS6+UvlNTk4Ieug==
X-CSE-MsgGUID: V9DDW7ROSrCSW1eyqB0aQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11661"; a="69012553"
X-IronPort-AV: E=Sophos;i="6.21,203,1763452800"; 
   d="scan'208";a="69012553"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2026 23:43:53 -0800
X-CSE-ConnectionGUID: ctEMZpJsQzqa1Xx68DyOWw==
X-CSE-MsgGUID: HaMOk6YKTdGw2y4VzoCuTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,203,1763452800"; 
   d="scan'208";a="239799052"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2026 23:43:53 -0800
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: vishal.l.verma@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	vannapurve@google.com,
	Chao Gao <chao.gao@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 0/3] Expose TDX Module version
Date: Sun,  4 Jan 2026 23:43:43 -0800
Message-ID: <20260105074350.98564-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi reviewers,

This series is quite straightforward and I believe it's well-polished.
Please consider providing your ack tags. However, since it depends on
two other series (listed below), please review those dependencies first if
you haven't already.

Changes in v2:
 - Print TDX Module version in demsg (Vishal)
 - Remove all descriptions about autogeneration (Rick)
 - Fix typos (Kai)
 - Stick with TDH.SYS.RD (Dave/Yilun)
 - Rebase onto Sean's VMXON v2 series

=== Problem & Solution === 

Currently, there is no user interface to get the TDX Module version.
However, in bug reporting or analysis scenarios, the first question
normally asked is which TDX Module version is on your system, to determine
if this is a known issue or a new regression.

To address this issue, this series exposes the TDX Module version as
sysfs attributes of the tdx_host device [*] and also prints it in dmesg
to keep a record.


=== Dependency ===

This series has two dependencies:

 1. Have TDX handle VMXON during bringup
    https://lore.kernel.org/kvm/20251206011054.494190-1-seanjc@google.com/#t
 2. TDX host virtual device (the first patch in the series below)
    https://lore.kernel.org/kvm/20251117022311.2443900-2-yilun.xu@linux.intel.com/

For your convenience, both dependencies and the series are also
available at

https://github.com/gaochaointel/linux-dev/tree/tdx-module-version-v2


Chao Gao (2):
  x86/virt/tdx: Retrieve TDX Module version
  coco/tdx-host: Expose TDX Module version

Vishal Verma (1):
  x86/virt/tdx: Print TDX Module version during init

 .../ABI/testing/sysfs-devices-faux-tdx-host   |  6 +++++
 arch/x86/include/asm/tdx_global_metadata.h    |  7 +++++
 arch/x86/virt/vmx/tdx/tdx.c                   |  9 +++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c   | 16 ++++++++++++
 drivers/virt/coco/tdx-host/tdx-host.c         | 26 ++++++++++++++++++-
 5 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-faux-tdx-host

-- 
2.47.3


