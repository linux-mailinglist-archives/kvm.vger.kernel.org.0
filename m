Return-Path: <kvm+bounces-52254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E494B03346
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 00:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02BA11773F1
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 22:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A448A1F91F6;
	Sun, 13 Jul 2025 22:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JjHvs7+Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2765418D;
	Sun, 13 Jul 2025 22:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752445236; cv=none; b=MPUxYnLZjoa160XvBQUetkI5wZEwnXz9YPCjZSzsULP3lf772xEqLWPyA223j3TPgafhcXsUKnDqDBKDS5hVrI8vcRG189niVA2ScuDY3ZKD+IOpXvupFe/fxUIQvNv7u4AqAykhg6AenOr/zad7tSG6DYxZMsuWW3G9650YD+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752445236; c=relaxed/simple;
	bh=eArfhUQfEtAXrXKwC7znqZvVrHEkRv4jUUGfVQYqq1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=khu0QIuQqOZs+ev+cNrVNKY6nqVeMttBhEqWCWfq2cVSx5cL9GpCHHg57ENUNC66U9Xr+qa9GVRjMMyIU8qOcy5XS64rLbUdY/k/qiRAbqoC70Dhu+GxvjH55CTSNBRxpOAnG1kwALHYhZfkFVuPS9yjq0ZPwvuSHtCf5WOu/To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JjHvs7+Q; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752445235; x=1783981235;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eArfhUQfEtAXrXKwC7znqZvVrHEkRv4jUUGfVQYqq1Y=;
  b=JjHvs7+QZDLHE1LjPeTnjr00GhoXjhjSVjSto/XH4ozyFCJuAXSz4/y8
   xj0SfGhCiQt5iJtNPZnw+CzHCbj7pvWBWBahksS/8X7vJ7eXp0lzGeXUm
   0VanOTeWtY5lRDzSA65P+00yqwgS6Me2dnbzL6FasWQo9iTkGN9uLaeEo
   wFaw070HQN3a3pfzCcDVi6/fBBgaW02AsJ01ZuCoLF0Tq+dGJJyPCaQ/7
   Oxu5ReQWoSxPQkJ5pfVqWlw2hZzEbR2zqDtfUJ+RxhK+CezPNhIgzyeZK
   YyjboxXc+HOkbYNF1HspPf7M4J5tjaClbSY56dB1jcJfjwP6k3WENDsKF
   w==;
X-CSE-ConnectionGUID: gMhucptLScqCln5NHJUFAQ==
X-CSE-MsgGUID: k04uyHPPTeOH80lm+y03Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="80077237"
X-IronPort-AV: E=Sophos;i="6.16,309,1744095600"; 
   d="scan'208";a="80077237"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 15:20:35 -0700
X-CSE-ConnectionGUID: gmT0oReyQX2B+azLpJVtTA==
X-CSE-MsgGUID: wg7pRoNwTNudRz+bGF4oUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,309,1744095600"; 
   d="scan'208";a="156891910"
Received: from gpacheco-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.7])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 15:20:31 -0700
From: Kai Huang <kai.huang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	nikunj@amd.com,
	bp@alien8.de,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	rick.p.edgecombe@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Improve KVM_SET_TSC_KHZ handling for CoCo VMs
Date: Mon, 14 Jul 2025 10:20:18 +1200
Message-ID: <cover.1752444335.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series follows Sean's suggestions [1][2] to:

 - Reject vCPU scope KVM_SET_TSC_KHZ ioctl for TSC protected vCPU
 - Reject VM scope KVM_SET_TSC_KHZ ioctl when vCPUs have been created

.. in the discussion of SEV-SNP Secure TSC support series.

v1 -> v2:
 - Protect kvm->create_vcpus check using kvm->lock. - Chao.
 - Add documentation update to each patch.  -Nikunj.
 - Collect RB (Xiaoyao, Nikunj).
 - Switched the patch order to make documentation update easier.

 v1: https://lore.kernel.org/kvm/cover.1752038725.git.kai.huang@intel.com/

Hi Xiaoyao, Nikunj, I added your RB anyway, so let me know if you have
concern :-)

This series has been sanity tested with TDX guests using today's Qemu:

 - With this series Qemu can still run TDX guests successfully.
 - With some hack to the Qemu, both VM and vCPU scope KVM_SET_TSC_KHZ
   ioctls failed as expected.

Kai Huang (2):
  KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created
  KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC protected guest

 Documentation/virt/kvm/api.rst |  9 ++++++++-
 arch/x86/kvm/x86.c             | 13 ++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)


base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
-- 
2.50.0


