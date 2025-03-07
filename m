Return-Path: <kvm+bounces-40350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 538E3A56E05
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 985063ABD8B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A29B23CF08;
	Fri,  7 Mar 2025 16:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KUi3BXLI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6366323BD12;
	Fri,  7 Mar 2025 16:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365535; cv=none; b=TyL/hbS0q8jTpIMsvK0MqwfgoCb0qeByIuslZ5EbTeeC+KVbVMhoYmdpS2+ggPrS/PVNcN0GBaskeBTDdAKsyzVuKFJWrhAKocCi6+aZAkX5lYd0gI5FTL2VjzaM34W3C0UdtiiovYW1t0/iw5H9LPUPy1+E22+XPywlWe5lldQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365535; c=relaxed/simple;
	bh=1VVRkZJh2auY7okOk/XeHGyOC8ItgKpelHUDvZ4TgRM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QzydIXwUd7iacfoFzcW6jV8SyKKiguEGMVJaI5AdpKdCmQWcIuN8OJzknovsCloJS0wq7J4hBxWZsm3oFtt9Yx5FsyVWjIUKZhWNo4pvQdrjW/D7mJXJ/iDz4ZHACreQ4IqJG3aFexz3Uq8hM/5PqGbcNuCAZflAznF601aXWtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KUi3BXLI; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365533; x=1772901533;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1VVRkZJh2auY7okOk/XeHGyOC8ItgKpelHUDvZ4TgRM=;
  b=KUi3BXLI76cIgpCJyo5T9a2nfxuqN46oggh4qfw2Sfxoe38A2S2pJ1h8
   1sX2QgJhGXZ++EzK1YTT+Un4ID0oRrWIOe1w1goqxxXlkPA5PgEx2LCmk
   xdx+xFalWcl8Tdw/9rcAjUdx4u3usWMsUyQwZMwT4qT3g99JhGH6y75u6
   dA7QuWYIIq2CLFwUhQAEdvZZyxjLhWUpMd75jwR2o2mrIv79N7W3nwdL+
   Dojhn+GiUayEySupVngXv1srecvQypxSdBuoNZDJm3XtidIPEVozQ4EoW
   +nSvPKPSQRtPrwbPdi7+Mw3dC2E0Hq+ecLelZiRmc7+d8qSYBjovTYz9t
   w==;
X-CSE-ConnectionGUID: cwxABDVaTBeFvLr+dG2I4w==
X-CSE-MsgGUID: JFGcHi8hSR6h2suQ55RmNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344342"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344342"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:38:53 -0800
X-CSE-ConnectionGUID: flIP6gWkTsibwbluGtV6hw==
X-CSE-MsgGUID: Ese1Mqt/RpuMPpxzQIj1ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397938"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:38:49 -0800
From: Chao Gao <chao.gao@intel.com>
To: chao.gao@intel.com,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de
Subject: [PATCH v3 00/10] Introduce CET supervisor state support
Date: Sat,  8 Mar 2025 00:41:13 +0800
Message-ID: <20250307164123.1613414-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

==Changelog==
v2->v3:
 - reorder patches to add fpu_guest_cfg first and then introduce dynamic kernel
   feature concept (Dave)
 - Revise changelog for all patches except the first and the last one (Dave)
 - Split up patches that do multiple things into separate patches.
 - collect tags for patch 1

v1->v2:
 - rebase onto the latest kvm-x86/next
 - Add performance data to the cover-letter
 - v1: https://lore.kernel.org/kvm/73802bff-833c-4233-9a5b-88af0d062c82@intel.com/

==Background==

This series spins off from CET KVM virtualization enabling series [1].
The purpose is to get these preparation work resolved ahead of KVM part
landing. There was a discussion about introducing CET supervisor state
support [2] [3].

CET supervisor state, i.e., IA32_PL{0,1,2}_SSP, are xsave-managed MSRs,
it can be enabled via IA32_XSS[bit 12]. KVM relies on host side CET
supervisor state support to fully enable guest CET MSR contents storage.
The benefits are: 1) No need to manually save/restore the 3 MSRs when
vCPU fpu context is sched in/out. 2) Omit manually swapping the three
MSRs at VM-Exit/VM-Entry for guest/host. 3) Make guest CET user/supervisor
states managed in a consistent manner within host kernel FPU framework.

==Solution==

This series tries to:
1) Fix existing issue regarding enabling guest supervisor states support.
2) Add CET supervisor state support in core kernel.
3) Introduce new FPU config for guest fpstate setup.

With the preparation work landed, for guest fpstate, we have xstate_bv[12]
== xcomp_bv[12] == 1 and CET supervisor state is saved/reloaded when
xsaves/xrstors executes on guest fpstate.
For non-guest/normal fpstate, we have xstate_bv[12] == xcomp_bv[12] == 0,
then HW can optimize xsaves/xrstors operations.

==Performance==

We measured context-switching performance with the benchmark [4] in following
three cases.

case 1: the baseline. i.e., this series isn't applied
case 2: baseline + this series. CET-S space is allocated for guest fpu only.
case 3: baseline + allocate CET-S space for all tasks. Hardware init
        optimization avoids writing out CET-S space on each XSAVES.

the data are as follows

case |IA32_XSS[12] | Space | RFBM[12] | Drop%	
-----+-------------+-------+----------+------
  1  |	   0	   | None  |	0     |  0.0%
  2  |	   1	   | None  |	0     |  0.2%
  3  |	   1	   | 24B?  |	1     |  0.2%

Case 2 and 3 have no difference in performnace. But case 2 is preferred because
it can save 24B of CET-S space for all non-vCPU threads with just a one-line
change:

+	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;

fpu_guest_cfg has its own merits. Regardless of the approach we take, using
different FPU configuration settings for the guest and the kernel improves
readability, decouples them from each other, and arguably enhances
extensibility.

[1]: https://lore.kernel.org/all/20240219074733.122080-1-weijiang.yang@intel.com/
[2]: https://lore.kernel.org/all/ZM1jV3UPL0AMpVDI@google.com/
[3]: https://lore.kernel.org/all/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/
[4]: https://github.com/antonblanchard/will-it-scale/blob/master/tests/context_switch1.c



Chao Gao (2):
  x86/fpu/xstate: Drop @perm from guest pseudo FPU container
  x86/fpu/xstate: Correct xfeatures cache in guest pseudo fpu container

Sean Christopherson (1):
  x86/fpu/xstate: Always preserve non-user xfeatures/flags in
    __state_perm

Yang Weijiang (7):
  x86/fpu/xstate: Correct guest fpstate size calculation
  x86/fpu/xstate: Introduce guest FPU configuration
  x86/fpu/xstate: Initialize guest perm with fpu_guest_cfg
  x86/fpu/xstate: Initialize guest fpstate with fpu_guest_config
  x86/fpu/xstate: Add CET supervisor xfeature support
  x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
  x86/fpu/xstate: Warn if CET supervisor state is detected in normal
    fpstate

 arch/x86/include/asm/fpu/types.h  | 31 +++++++++++++++------------
 arch/x86/include/asm/fpu/xstate.h | 11 ++++++----
 arch/x86/kernel/fpu/core.c        | 34 +++++++++++++++++-------------
 arch/x86/kernel/fpu/xstate.c      | 35 ++++++++++++++++++++++++-------
 arch/x86/kernel/fpu/xstate.h      |  2 ++
 5 files changed, 74 insertions(+), 39 deletions(-)

-- 
2.46.1


