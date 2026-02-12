Return-Path: <kvm+bounces-70971-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJKIGtjljWms8QAAu9opvQ
	(envelope-from <kvm+bounces-70971-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:38:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E467612E4F4
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9837930CDF82
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D5D35FF62;
	Thu, 12 Feb 2026 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRdid3Y0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AAF35E548;
	Thu, 12 Feb 2026 14:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906982; cv=none; b=rhx4u2A8xk02WEbOsO5pozQ0zF6YRIkofGiI9FevLaNzkK4C9qrAGy4pyka8OS9uQK2PyoWoD67QpYO3qcZuP5FDWOiBHcXw8wnkvQPjtZhz845jQogXNFHBJCtvtNUfuD6Ta33jXICMYUWRQu4dP3CKN5dA+D88AaqRBPW24nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906982; c=relaxed/simple;
	bh=2w/n4WgRXjgVeghR9JMhpN0xb91wx8vFJINQcVtlIN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPKR/EImsGVU+zOHLO3kE17XIVpc1/BWPYE0muxrLOVhhceeHRj9E3Z2Nu5JiFFiW0LqEuYQdlzQ/lucoI3RDKchoKIcAIzSGnt9sRpGGypKz5pZ9dgZQgXcoL0TF8XAoAn08Z3spQNpKg+HcT0RA8gdPMooirxepBHEfuvxg1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRdid3Y0; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906980; x=1802442980;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2w/n4WgRXjgVeghR9JMhpN0xb91wx8vFJINQcVtlIN4=;
  b=FRdid3Y0vqkh1eqByDCerOtHElEJ7x1RKXIIvc/GObwJ0FVmFhBk9eA8
   oB21MKa80CoX3lusmpPBTV5qFz3JGzodMRjalUEOdhbuzChB3w2+xozsF
   MKj+bmiQqgp0rhindQNPz3uWmPbhZGvEoizS6AtYxfxD/g4xcudoLIwbx
   SYi3AsaXq2ioTcSXKZddbUEcNi4cU5o+agwZ0x3YqFilwA4ZmobnxRuHx
   GqNQdYvAvt8EeNScB6Z13JOd44GhCvOp5n+ZhTCjPsRiSUCw45Kxi1SxQ
   nCSoYXGABQP2B4+v0f6hYhcjsD2GMaEEEZT90ruVPt58HI8odXLfPFSrX
   w==;
X-CSE-ConnectionGUID: kWMQWwDJQ36hzx4OMnaL7w==
X-CSE-MsgGUID: UGBM/EqkRZCxGM3BtE/rSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662810"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662810"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:20 -0800
X-CSE-ConnectionGUID: w2WA76lASOid76bByge6hA==
X-CSE-MsgGUID: WDPwiLdXQJKbFxEsSdpo7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428245"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:19 -0800
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
	binbin.wu@linux.intel.com,
	tony.lindgren@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 09/24] x86/virt/seamldr: Check update limit before TDX Module updates
Date: Thu, 12 Feb 2026 06:35:12 -0800
Message-ID: <20260212143606.534586-10-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212143606.534586-1-chao.gao@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70971-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: E467612E4F4
X-Rspamd-Action: no action

TDX maintains a log about each TDX Module which has been loaded. This
log has a finite size which limits the number of TDX Module updates
which can be performed.

After each successful update, the remaining updates reduces by one. Once
it reaches zero, further updates will fail until next reboot.

Before updating the TDX Module, verify that the update limit has not been
exceeded. Otherwise, P-SEAMLDR will detect this violation after the old TDX
Module is gone and all TDs will be killed.

Note that userspace should perform this check before updates. Perform this
check in kernel as well to make the update process more robust.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 694243f1f220..733b13215691 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -52,6 +52,16 @@ EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");
  */
 int seamldr_install_module(const u8 *data, u32 size)
 {
+	struct seamldr_info info;
+	int ret;
+
+	ret = seamldr_get_info(&info);
+	if (ret)
+		return ret;
+
+	if (!info.num_remaining_updates)
+		return -ENOSPC;
+
 	if (WARN_ON_ONCE(!is_vmalloc_addr(data)))
 		return -EINVAL;
 
-- 
2.47.3


