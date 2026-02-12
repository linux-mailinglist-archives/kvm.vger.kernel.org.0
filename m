Return-Path: <kvm+bounces-70983-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WDQPIx/njWkm8gAAu9opvQ
	(envelope-from <kvm+bounces-70983-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:43:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A3AC412E605
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C7CEE3064111
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3639365A1C;
	Thu, 12 Feb 2026 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PGOtdkV2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA553644D0;
	Thu, 12 Feb 2026 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906994; cv=none; b=chOnacbxRBxAIsAe6a+iyGYdUqPFBD7+ZErxJESar1KK8YBL0QqvudqRoxmuS405rUYvQEHGjd+w5caxWoSxWcQPsvHUqwGk1nTKNb5+ZMNB3aQeJn8QOqKJpJtTLJdxZPpZcws1o5roD1vbYOYnRwRLsWsyX3j3q8U6QpilcvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906994; c=relaxed/simple;
	bh=/dAN6pjPYkAlspD1dSRRcEHHqjm+lR6Zi8ZYkj93Ua8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyamiJZcd9ekheyt5GRJrbSd2yYFVH3GsDEpgg7CLrzNLoLNyR0tjWd3jMS7SmxN6kaKo2iI4kPNWiv8SjEXjiXm7yCYSJ5eeg6CdIXhg4iSRoappGnMQkkFujscoh74AXbqMKF2qS+cnmP5YDob08wSqeXg0ZWVDUGVyJgAC28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PGOtdkV2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906992; x=1802442992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/dAN6pjPYkAlspD1dSRRcEHHqjm+lR6Zi8ZYkj93Ua8=;
  b=PGOtdkV29i7xG+Zl2lzJEo9/YWSmA5pJLuW1WNgSImOj5tc5BJfVUCo0
   /ylJQr7x7DyYh2nWIFneG2WdxtpcXhkMaOWLY0DOrldVCctiLpaug5Rgg
   oQAY6a72QUjnOZa2PWpDcrwUjl5SVUxX5LNm3kPNGZGvTD1njq2gt9Fk9
   aackB3s85D9iPGHA+iVOGh7dilhDPJEhvmDI3oQf0jBH6+VUVV1/3DrGt
   VO23Rv/bRd+dSD38zDBoZGyIxlO4Uwhz0wEuw5t2KwV0MhQYJW/FXn7M2
   3ZRIrGg8hDE3NVOuKZCYMoLgr/ibxT99EjhuPDbTSTEqP87JJKzcFTOsn
   g==;
X-CSE-ConnectionGUID: C4grW9s+TXyY0AuIr+YiTQ==
X-CSE-MsgGUID: p/YXFP+uT/K/C90OnMucPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662924"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662924"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:31 -0800
X-CSE-ConnectionGUID: VJxnIGBZRBaT+DKh5UJYAw==
X-CSE-MsgGUID: 9QdBvV5XR6uJ44/RjkvytQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428308"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:31 -0800
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
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v4 22/24] coco/tdx-host: Document TDX Module update expectations
Date: Thu, 12 Feb 2026 06:35:25 -0800
Message-ID: <20260212143606.534586-23-chao.gao@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70983-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: A3AC412E605
X-Rspamd-Action: no action

The TDX Module update protocol facilitates compatible runtime updates.

Document the compatibility criteria and indicators of various update
failures, including violations of the compatibility criteria.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
v4
 - Drop "compat_capable" kernel ABI [Dan]
 - Document Linux compatibility expectations and results of violating
   them [Dan]
---
 .../ABI/testing/sysfs-devices-faux-tdx-host   | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
index 88a9c0b2bdfe..fefe762998db 100644
--- a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
+++ b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
@@ -27,3 +27,56 @@ Description:	(RO) Report the number of remaining updates. TDX maintains a
 		Interface Specification, Revision 343755-003, Chapter 3.3
 		"SEAMLDR_INFO" and Chapter 4.2 "SEAMLDR.INSTALL" for more
 		information.
+
+What:		/sys/devices/faux/tdx_host/firmware/tdx_module
+Contact:	linux-coco@lists.linux.dev
+Description:	(Directory) The tdx_module directory implements the fw_upload
+		sysfs ABI, see Documentation/ABI/testing/sysfs-class-firmware
+		for the general description of the attributes @data, @cancel,
+		@error, @loading, @remaining_size, and @status. This ABI
+		facilitates "Compatible TDX Module Updates". A compatible update
+		is one that meets the following criteria:
+
+		   Does not interrupt or interfere with any current TDX
+		   operation or TD VM.
+
+		   Does not invalidate any previously consumed Module metadata
+		   values outside of the TEE_TCB_SVN_2 field (updated Security
+		   Version Number) in TD Quotes.
+
+		   Does not require validation of new Module metadata fields. By
+		   implication, new Module features and capabilities are only
+		   available by installing the Module at reboot (BIOS or EFI
+		   helper loaded).
+
+		See tdx_host/firmware/tdx_module/error for information on
+		compatibility check failures and how to prevent them.
+
+What:		/sys/devices/faux/tdx_host/firmware/tdx_module/error
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) See Documentation/ABI/testing/sysfs-class-firmware for
+		baseline expectations for this file. The <ERROR> part in the
+		<STATUS>:<ERROR> format can be:
+
+		   "device-busy": Compatibility checks failed or not all CPUs
+		                  are online
+
+		   "flash-wearout": The number of updates reached the limit.
+
+		   "read-write-error": Memory allocation failed.
+
+		   "hw-error": Cannot communicate with P-SEAMLDR or TDX Module.
+
+		   "firmware-invalid": The provided TDX Module update is invalid
+		                       or other unexpected errors occurred.
+
+		"hw-error" or "firmware-invalid" may be fatal, causing all TDs
+		and the TDX Module to be lost and preventing further TDX
+		operations. This occurs when reading
+		/sys/devices/faux/tdx_host/version returns -ENXIO. For other
+		errors, TDs and the (previous) TDX Module stay running.
+
+		See tdxctl [1] documentation for how to detect compatible
+		updates and whether the current platform components catch errors
+		or let them leak and cause potential TD attestation failures.
+		[1]: <TBD - tdxctl link>
-- 
2.47.3


