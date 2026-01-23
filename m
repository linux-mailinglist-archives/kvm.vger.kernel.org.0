Return-Path: <kvm+bounces-68986-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAcoFrOOc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68986-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:07:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D29BC777A4
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:07:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6461E3088FCE
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996FC354AE6;
	Fri, 23 Jan 2026 15:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OjqRi9un"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D842F39D7;
	Fri, 23 Jan 2026 15:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180429; cv=none; b=Va96tlgh1R7SUfoN9MQbk7H+HWRU5UjICL+NsriyOXhdDvoztzr0eKbgY2gF8KKr4fV+OGsf7K459HuvJ5NqX5v87iUxG5h9RF+tXCHQvKr70LglhYpzSSoMPRz4gK/mbS/sMsHGZQ/cqm584FUAyEh4Z1BjxLy/j7n7677q3kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180429; c=relaxed/simple;
	bh=2mas6uKv803snqoU3Os52DqiAqkG0aYWViBeCHLZ4pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eY3JxiEKE/ya86DKafLfNp7niGf5CYRV9E4k7U6v+Qpm44FkwLXLtv46RqAjHfro6y/Nbk71162Utp4JZ+rVDE0o0EKKnfZD4y7y5rJlW2dZMc70SwC5fmW0lcV62oPPiAe257gwVJhBCdDsLp2ODeWVA352JJrlfXF2b3CqOE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OjqRi9un; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180427; x=1800716427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2mas6uKv803snqoU3Os52DqiAqkG0aYWViBeCHLZ4pM=;
  b=OjqRi9unT3RafW0tnXr3t1CMgisQtmmnfz3apUNf4B5bvAaV+K2doWJp
   fwOD8LLww2vt3fyrZ7KdS61E9gpQ1GrCETCP9LWj71vqIgtdyQEmx2vT5
   Y2h1YRmsXZW/Pj+sBnGH4rjt+rGgryRrZCoRRM+PGTzpFgeDOxCokRGt0
   OjIeUFE1pVYP2I+0IWlAbXizkA9ZufkOH2NCQLyQov9L/XeiiSNa0Xhjt
   pHYna1JJeTtnvyGVrAcaP6M3GaeOrc5zWMI7JdVfi1ME07zeNLdEzndHD
   9TUi5df2RSeOFONyJsUfkkC5eK4umlAn1AvIaJyc0utvGCi4g41e4+8rQ
   A==;
X-CSE-ConnectionGUID: lNq6X3BZSKyy4uO8OQC8+Q==
X-CSE-MsgGUID: 4oH95j2fRA2imR8yIg5ZUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334422"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334422"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:14 -0800
X-CSE-ConnectionGUID: BfaFtyx5Sh2ljCfEgNKQ0g==
X-CSE-MsgGUID: 8olzq3EoQkKEcCv4HZZ1gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697133"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:14 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 12/26] x86/virt/seamldr: Verify availability of slots for TDX Module updates
Date: Fri, 23 Jan 2026 06:55:20 -0800
Message-ID: <20260123145645.90444-13-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68986-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D29BC777A4
X-Rspamd-Action: no action

The CPU keeps track of TCB versions for each TDX Module that has been
loaded. Since this tracking database has finite capacity, there's a maximum
number of module updates that can be performed. After each successful
update, the number reduces by one. Once it reaches zero, further updates
will fail until next reboot.

Before updating the TDX Module, ensure that the limit on TDX Module updates
has not been exceeded to prevent update failures in a later phase where TDs
have to be killed.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 88388aa0fb5f..d1d4f96c4963 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -83,6 +83,14 @@ EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");
  */
 int seamldr_install_module(const u8 *data, u32 size)
 {
+	const struct seamldr_info *info = seamldr_get_info();
+
+	if (!info)
+		return -EIO;
+
+	if (!info->num_remaining_updates)
+		return -ENOSPC;
+
 	if (!is_vmalloc_addr(data))
 		return -EINVAL;
 
-- 
2.47.3


