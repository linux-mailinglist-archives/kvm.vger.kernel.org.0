Return-Path: <kvm+bounces-71519-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sAm9AVWUnGnRJQQAu9opvQ
	(envelope-from <kvm+bounces-71519-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:54:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9920317B249
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DD5B310FACA
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267F133B6CF;
	Mon, 23 Feb 2026 17:48:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F6333B6C3;
	Mon, 23 Feb 2026 17:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771868912; cv=none; b=RB9Wi92NsliZFICaTxVlqS3hrep0sn8U/ZIK424ouQxP20UewCnNjV4o9hlOXVSebVEFna4Ye4wHbXCUbvZmdBjTSzbuP7RwTkl20GBVVHEUC29vdYpJ7CSRaXBAkfLJ2gSErA2d5yI2/UN8AMlcMFTuhChJRGeNgo4rPO8cCqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771868912; c=relaxed/simple;
	bh=iGDW5vhq3Q6kZFtorZ0MiHnTnFizA2hhJE+6ztz9Y9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rlfzm0vLqBxSoRuniAKmJS9hOL4Y0y16+6YOVLOdsYIamuZLt4NbzayaQG6sItEAKAZEOe4lp/t1XieRiECSgYbeVsmLTxdteZST2y45O/EC3cyG17rYpJ9eaHpKespNxAtfl6eGm3RUK02NbD2Rsh/7mcNLcAkWdv5FoCAZlGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5099339;
	Mon, 23 Feb 2026 09:48:24 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5F8053F59E;
	Mon, 23 Feb 2026 09:48:28 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	broonie@kernel.org,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	yangyicong@hisilicon.com,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v13 8/8] arm64: Kconfig: add support for LSUI
Date: Mon, 23 Feb 2026 17:48:02 +0000
Message-Id: <20260223174802.458411-9-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223174802.458411-1-yeoreum.yun@arm.com>
References: <20260223174802.458411-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71519-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.975];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9920317B249
X-Rspamd-Action: no action

Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
previleged level to access to access user memory without clearing
PSTATE.PAN bit.

Add Kconfig option entry for FEAT_LSUI.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Kconfig | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..890a1bedbf4a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2215,6 +2215,26 @@ config ARM64_GCS
 
 endmenu # "ARMv9.4 architectural features"
 
+config AS_HAS_LSUI
+	def_bool $(as-instr,.arch_extension lsui)
+	help
+	  Supported by LLVM 20+ and binutils 2.45+.
+
+menu "ARMv9.6 architectural features"
+
+config ARM64_LSUI
+	bool "Support Unprivileged Load Store Instructions (LSUI)"
+	default y
+	depends on AS_HAS_LSUI && !CPU_BIG_ENDIAN
+	help
+	  The Unprivileged Load Store Instructions (LSUI) provides
+	  variants load/store instructions that access user-space memory
+	  from the kernel without clearing PSTATE.PAN bit.
+
+	  This feature is supported by LLVM 20+ and binutils 2.45+.
+
+endmenu # "ARMv9.6 architectural feature"
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


