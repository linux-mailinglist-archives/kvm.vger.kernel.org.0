Return-Path: <kvm+bounces-40719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD94A5B7B6
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE9361896042
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF732206A3;
	Tue, 11 Mar 2025 04:03:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FE31F4C87;
	Tue, 11 Mar 2025 04:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741665826; cv=none; b=Y80iau0GLKMZmueqdDkktEehallB5VVzFeSWuRKB565fiQssAxiYLwrv3r56P6/gDCEBYUxaAehHFHTLy9eAvspBA7kPA2vsM4KskvhOgPn/zti1UQz5olUvm1rc4nb5YztA2e55hfddgWDFMc2MZyD40dxZCFcub00lGiJoBLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741665826; c=relaxed/simple;
	bh=ummS0YLZrl6/ek9FLrqOaWeDKWLnyo887hHkaiLIeCE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VEmvPdVT9C8ns8QAFAFXv3jMo5a1JeOQWMMrvWNMB/KTUhLkgWLCymUgW01pHOqF2Zr/ECCSxUtgcUMSIT/uJHhwEhiVztswL5tj0TC7H0ds/KIrQzB8XpoVYjT8OHi/evRE1dcCGr/lt5TDYJR6XqsyOO4whJN/xQehJpgv6+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ZBg4S5m9fz1f0Pm;
	Tue, 11 Mar 2025 11:59:20 +0800 (CST)
Received: from kwepemj500003.china.huawei.com (unknown [7.202.194.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 50EDE1A016C;
	Tue, 11 Mar 2025 12:03:41 +0800 (CST)
Received: from DESKTOP-KKJBAGG.huawei.com (10.174.178.32) by
 kwepemj500003.china.huawei.com (7.202.194.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Mar 2025 12:03:40 +0800
From: Zhenyu Ye <yezhenyu2@huawei.com>
To: <maz@kernel.org>, <yuzenghui@huawei.com>, <will@kernel.org>,
	<oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <joey.gouly@arm.com>
CC: <linux-kernel@vger.kernel.org>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <wangzhou1@hisilicon.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v1 5/5] arm64/config: add config to control whether enable HDBSS feature
Date: Tue, 11 Mar 2025 12:03:21 +0800
Message-ID: <20250311040321.1460-6-yezhenyu2@huawei.com>
X-Mailer: git-send-email 2.22.0.windows.1
In-Reply-To: <20250311040321.1460-1-yezhenyu2@huawei.com>
References: <20250311040321.1460-1-yezhenyu2@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemj500003.china.huawei.com (7.202.194.33)

From: eillon <yezhenyu2@huawei.com>

The HDBSS feature introduces new assembly registers
(HDBSSBR_EL2 and HDBSSPROD_EL2), which depends on the armv9.5-a
compilation support. So add ARM64_HDBSS config to control whether
enable the HDBSS feature.

Signed-off-by: eillon <yezhenyu2@huawei.com>
---
 arch/arm64/Kconfig                  | 19 +++++++++++++++++++
 arch/arm64/Makefile                 |  4 +++-
 arch/arm64/include/asm/cpufeature.h |  3 +++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 940343beb3d4..3458261eb14b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2237,6 +2237,25 @@ config ARM64_GCS
 
 endmenu # "v9.4 architectural features"
 
+menu "ARMv9.5 architectural features"
+
+config ARM64_HDBSS
+	bool "Enable support for Hardware Dirty state tracking Structure (HDBSS)"
+	default y
+	depends on AS_HAS_ARMV9_5
+	help
+	  Hardware Dirty state tracking Structure(HDBSS) enhances tracking
+	  translation table descriptors’ dirty state to reduce the cost of
+	  surveying for dirtied granules.
+
+	  The feature introduces new assembly registers (HDBSSBR_EL2 and
+	  HDBSSPROD_EL2), which depends on AS_HAS_ARMV9_5.
+
+config AS_HAS_ARMV9_5
+	def_bool $(cc-option,-Wa$(comma)-march=armv9.5-a)
+
+endmenu # "ARMv9.5 architectural features"
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2b25d671365f..f22507fb09b9 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -103,7 +103,9 @@ endif
 # freely generate instructions which are not supported by earlier architecture
 # versions, which would prevent a single kernel image from working on earlier
 # hardware.
-ifeq ($(CONFIG_AS_HAS_ARMV8_5), y)
+ifeq ($(CONFIG_AS_HAS_ARMV9_5), y)
+  asm-arch := armv9.5-a
+else ifeq ($(CONFIG_AS_HAS_ARMV8_5), y)
   asm-arch := armv8.5-a
 else ifeq ($(CONFIG_AS_HAS_ARMV8_4), y)
   asm-arch := armv8.4-a
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index c76d51506562..32e432827934 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -748,6 +748,9 @@ static inline bool system_supports_hdbss(void)
 	u64 mmfr1;
 	u32 val;
 
+	if (!IS_ENABLED(CONFIG_ARM64_HDBSS))
+		return false;
+
 	mmfr1 =	read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	val = cpuid_feature_extract_unsigned_field(mmfr1,
 						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
-- 
2.39.3


