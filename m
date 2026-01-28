Return-Path: <kvm+bounces-69428-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBNIHhaZemms8QEAu9opvQ
	(envelope-from <kvm+bounces-69428-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:17:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2418A9E51
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D562D301913A
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19EC9342C9E;
	Wed, 28 Jan 2026 23:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VrepqyyD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B39B5B5AB
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 23:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769642259; cv=none; b=klB9BNUnc0Opa8bdXq4slDWTssAA4W/wT//XpXcJkBSyspcpdDJiD9/KT3y3BzK4z3YyKmz6WrXNbK74eQ4lWRyOQ5tJ6Ls4ifQ+O/5ISsayTm+aoREwsF73yD00XMu8F8ZCfg8gOKki39qKVPwONfDIdhZY/S9iqOhH7an0Bbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769642259; c=relaxed/simple;
	bh=gku6ATXVmNaAWbvDHzX9sEE21VzxY5sWy4J0/A/R56M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tKTBxLI5Mssu/65xedEJ35i6B8fzQFTKaWcceAG1G3OHNb6aCEJxEvU5BHNy9qRJIt939OlmSbrwXLo0wNaVkvf2ljz7dvBRDhwhHOkv5BeaiEm18HZpxP2KyHyPUQS1DwADREYHSDBvXuasHGQeG7pEJUFaYpR9c3xALU5sgcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VrepqyyD; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769642257; x=1801178257;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gku6ATXVmNaAWbvDHzX9sEE21VzxY5sWy4J0/A/R56M=;
  b=VrepqyyDm905mLCQMKCT1H/jEvgMlwHxu0q3iYByYg6WCyLSVnIVLR01
   Rsh9+a6dZqKbZuLQrA9h095dtSYTG+0+5RFIXyP0WCCRPeQ//n3X9FdFF
   ZO3GDGYlO2N71NwOZJ3wYk+8nLJ+Q6IZA0ISB3c+F6Ntm+0fCrAxFKaIx
   qsTIXfDEt5RmWloN3jgFovzdEDOlcQR95ycPTIv6zrQr7pXJer+zhDNn6
   lwZEJvvtjCgwXoYysAnXq/HdhugAE1gYOXZ4gp0w6xrQjBUsb7jCzZ5gb
   9l1G9ZuFPSEd7ae4gVFIcpUge1YWQ4o1EJiytE6a8ChIs//cIacs7l/gL
   A==;
X-CSE-ConnectionGUID: vyK+gFypQOC4oGRT9yCHHg==
X-CSE-MsgGUID: AGiYspgpRiO20SxjxconKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="73462305"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="73462305"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:37 -0800
X-CSE-ConnectionGUID: 0d9s5027QpCpyH0E/PDyLw==
X-CSE-MsgGUID: vkpbL/btRZGQR82jzvLBLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208001757"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:36 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V2 00/11] target/i386: Misc PMU, PEBS, and MSR fixes and improvements
Date: Wed, 28 Jan 2026 15:09:37 -0800
Message-ID: <20260128231003.268981-1-zide.chen@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69428-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: F2418A9E51
X-Rspamd-Action: no action

This series contains a set of fixes, cleanups, and improvements in
target/i386 related to PMU, legacy PEBS, and MSR handling.

The patches are grouped into a single series for review convenience.
Smoe of them are not tightly coupled and can be reviewed and applied
individually.

Technically, the PEBS-related changes could be split into a separate
series.  However, they touch closely related PMU and MSR code paths,
and keeping them together here makes review easier and helps avoid
potential merge conflicts.

Patch series overview:
Patches 1–5: Miscellaneous PMU/MSR fixes and cleanups.
Patches 8–9: Refactoring in preparation for pebs-fmt support.
Patches 6–7, 10–11: Complete legacy PEBS support in QEMU.

Changes since v1:
- Add two new patches to clean up and refactor LBR format handling.
- Introduce a new pebs-fmt command-line option.
- Add a patch to avoid exposing PEBS capabilities when not enabled.
- Trivial fixes and cleanups.

Dapeng Mi (3):
  target/i386: Don't save/restore PERF_GLOBAL_OVF_CTRL MSR
  target/i386: Support full-width writes for perf counters
  target/i386: Save/Restore DS based PEBS specfic MSRs

Zide Chen (8):
  target/i386: Disable unsupported BTS for guest
  target/i386: Gate enable_pmu on kvm_enabled()
  target/i386: Increase MSR_BUF_SIZE and split KVM_[GET/SET]_MSRS calls
  target/i386: Make some PEBS features user-visible
  target/i386: Clean up LBR format handling
  target/i386: Refactor LBR format handling
  target/i386: Add pebs-fmt CPU option
  target/i386: Disable guest PEBS capability when not enabled

 target/i386/cpu.c         | 130 ++++++++++++++++++++----------
 target/i386/cpu.h         |  29 ++++++-
 target/i386/kvm/kvm-cpu.c |   3 +
 target/i386/kvm/kvm.c     | 163 +++++++++++++++++++++++++++++++-------
 target/i386/machine.c     |  35 ++++++--
 5 files changed, 281 insertions(+), 79 deletions(-)

-- 
2.52.0


