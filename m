Return-Path: <kvm+bounces-35257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5735AA0AD49
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60AED1886957
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18CCA54738;
	Mon, 13 Jan 2025 02:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l3sWBfUh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B0F125D5;
	Mon, 13 Jan 2025 02:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734249; cv=none; b=jC3iTEWeD/DbR/LSDceJHKPCNzvyT9nuH3KftCrEplvTpLVGv7Prr6Dzwn4tS46WouXo0r3DBmROuV+nWS9QrNf+wXEggBgrDTk+7R0ukNiOGJKDOcE22znrmKyfJTFSn6paZD42gXfBVhB1ysJrrlvn9mt4YDth/QyENdJa4xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734249; c=relaxed/simple;
	bh=V9zvQkVK5sBer3l68QZHnL6W8ELx875z82GHrIqeuJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SUPBnIafzpsNAqWYeeXraUxeAfRgxkpz3Ro5kQp+QEhnHP6Q85UIjeSSKACKqiknvlMLxotoZPuMLAqDSGqIYx0r2eP5n6GYklnj4FCGZO8Q+8QYM3S/lZW2y1tn0wXi8J5v/PTXgM6BNKZFnYWAqWmvsdpEomTogWReImjohvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l3sWBfUh; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734248; x=1768270248;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V9zvQkVK5sBer3l68QZHnL6W8ELx875z82GHrIqeuJ0=;
  b=l3sWBfUhIuTRTtl/YHYHKk4EWJaxHcL8Y+t0ICRJ3/6gb+JA5naWeJ+o
   sy/4akyHZjhBxg3VjI6YfPqGp3bhRka8rDcqnL0wIOURRqJQ/ZgSxS6Og
   0iReeIaCE1KG5hA4ZudFYnxaN5o320GQOvP/lVJFcKpArFtnntISjakkS
   zgm8iQFWpfrRFPiEaUTyWdsmnXo71DxlkFZPOLlQvZi6x8K7AIbbXaC46
   MMR9rAz2ASOeETjb2iJki+j8n5vY7LFcKbnQ4ZSzaujcK+QVUGoY8DW3m
   Rzy8LbmLsPaYwdmP2Pwp86udC7Dsy6SHB7n9+GuQYABeNixPbt4JaFfbY
   g==;
X-CSE-ConnectionGUID: xEL8w9vjRgKU7gsTHRYhww==
X-CSE-MsgGUID: v/LBSglYSam6w12Df9feBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="54522448"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="54522448"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:10:41 -0800
X-CSE-ConnectionGUID: e6pUvZfiTgCo0/gKfc8eMQ==
X-CSE-MsgGUID: SBGrxG3URiu6RNRcIdIaCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="135142116"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:10:28 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/7] KVM: TDX SEPT SEAMCALL retry
Date: Mon, 13 Jan 2025 10:09:25 +0800
Message-ID: <20250113020925.18789-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series aims to provide a clean solution to avoid the blind retries in
the previous hack [1] in "TDX MMU Part 2," following the initial
discussions to [2], further discussions in the RFC, and the PUCK [3].

A full analysis of the lock status for each SEAMCALL relevant to KVM is
available at [4].

This series categorizes the SEPT-related SEAMCALLs (used for page
installation and uninstallation) into three groups:

Group 1: tdh_mem_page_add().
       - Invoked only during TD build time.
       - Proposal: Return -EBUSY on TDX_OPERAND_BUSY.
       - Patch 1.

Group 2: tdh_mem_sept_add(), tdh_mem_page_aug().
       - Invoked for TD runtime page installation.
       - Proposal: Retry locally in the TDX EPT violation handler for
         RET_PF_RETRY.
       - Patches 2-3.

Group 3: tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove().
       - Invoked for page uninstallation, with KVM mmu_lock held for write.
       - Proposal: Kick off vCPUs and no vCPU entry on TDX_OPERAND_BUSY.
       - Patch 4.

Patches 5/6/7 are fixup patches:
Patch 5: Return -EBUSY instead of -EAGAIN when tdh_mem_sept_add() is busy.
Patch 6: Remove the retry loop for tdh_phymem_page_wbinvd_hkid().
Patch 7: Warn on force_immediate_exit in tdx_vcpu_run().

Code base: kvm-coco-queue 2f30b837bf7b.
Applies to the tail since the dependence on
commit 8e801e55ba8f ("KVM: TDX: Handle EPT violation/misconfig exit"),

Thanks
Yan

RFC --> v1:
- Split patch 1 in RFC into patches 1,2,3,5, and add new fixup patches 6/7.
- Add contention analysis of tdh_mem_page_add() in patch 1 log.
- Provide justification in patch 2 log and add checks for RET_PF_CONTINUE.
- Use "a per-VM flag wait_for_sept_zap + KVM_REQ_OUTSIDE_GUEST_MODE"
  instead of a arch-specific request to prevent vCPUs from TD entry in patch 4
  (Sean).

RFC: https://lore.kernel.org/all/20241121115139.26338-1-yan.y.zhao@intel.com
[1] https://lore.kernel.org/all/20241112073909.22326-1-yan.y.zhao@intel.com
[2] https://lore.kernel.org/kvm/20240904030751.117579-10-rick.p.edgecombe@intel.com/
[3] https://drive.google.com/drive/folders/1k0qOarKuZXpzRsKDtVeC5Lpl9-amJ6AJ?resourcekey=0-l9uVpVEBC34Uar1ReaqisQ
[4] https://lore.kernel.org/kvm/ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com

Yan Zhao (7):
  KVM: TDX: Return -EBUSY when tdh_mem_page_add() encounters
    TDX_OPERAND_BUSY
  KVM: x86/mmu: Return RET_PF* instead of 1 in kvm_mmu_page_fault()
  KVM: TDX: Retry locally in TDX EPT violation handler on RET_PF_RETRY
  KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal
  fixup! KVM: TDX: Implement hooks to propagate changes of TDP MMU
    mirror page table
  fixup! KVM: TDX: Implement hooks to propagate changes of TDP MMU
    mirror page table
  fixup! KVM: TDX: Implement TDX vcpu enter/exit path

 arch/x86/kvm/mmu/mmu.c          |  10 ++-
 arch/x86/kvm/mmu/mmu_internal.h |  12 ++-
 arch/x86/kvm/vmx/tdx.c          | 135 ++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/tdx.h          |   7 ++
 4 files changed, 134 insertions(+), 30 deletions(-)

-- 
2.43.2


