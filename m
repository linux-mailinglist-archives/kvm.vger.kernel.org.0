Return-Path: <kvm+bounces-37554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E867A2B9B3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 382083A6655
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C1C189BB0;
	Fri,  7 Feb 2025 03:26:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DF31552F5;
	Fri,  7 Feb 2025 03:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738898806; cv=none; b=TaQA6G5S6syj8XvPGUyscCYB5niC+KVL9oL0wh8+T1oJ0kY5iCX4RusmuoS7HriLwX4KYUg/vOJ1D8NlwF+vtk7RZrpNVr9giqPRvQ14qdeaML89WyQYIsWUR5tqJ5Eh+QdKttTpK7sO+k9G0HG1Sk8KbQKWMjsVnjtOV/xgcoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738898806; c=relaxed/simple;
	bh=nIg4KqlZLIE+9kHuoz8kq6iBTemjja4ssO61UhjLxdI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AO+O5hVvL35d4X1oLSMWu1J0YcJu5XwpjiTGVGCy2HsLvp/HqmTTBps3t1SOMqaaRthZvfGFfQ4OztS6OIW/rel7Qrl84KwApVAPvvnD6oeR8RlbctahAi67jJnpajiyJUbeV2lKid5el9OwPD0t/W0daNAWwheHU+ZvrmLiNlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Ax3eJrfaVnOjFuAA--.22411S3;
	Fri, 07 Feb 2025 11:26:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDx_MRqfaVn0JsDAA--.12326S3;
	Fri, 07 Feb 2025 11:26:34 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] LoongArch: KVM: Fix typo issue about GCFG feature detection
Date: Fri,  7 Feb 2025 11:26:32 +0800
Message-Id: <20250207032634.2333300-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250207032634.2333300-1-maobibo@loongson.cn>
References: <20250207032634.2333300-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDx_MRqfaVn0JsDAA--.12326S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This is typo issue about GCFG feature macro, comments is added for
these macro and typo issue is fixed here.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/loongarch.h | 26 ++++++++++++++++++++++++++
 arch/loongarch/kvm/main.c              |  4 ++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 52651aa0e583..1a65b5a7d54a 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -502,49 +502,75 @@
 #define LOONGARCH_CSR_GCFG		0x51	/* Guest config */
 #define  CSR_GCFG_GPERF_SHIFT		24
 #define  CSR_GCFG_GPERF_WIDTH		3
+/* Number PMU register started from PM0 passthrough to VM */
 #define  CSR_GCFG_GPERF			(_ULCAST_(0x7) << CSR_GCFG_GPERF_SHIFT)
+#define  CSR_GCFG_GPERFP_SHIFT		23
+/* Read-only bit: show PMU passthrough supported or not */
+#define  CSR_GCFG_GPERFP		(_ULCAST_(0x1) << CSR_GCFG_GPERFP_SHIFT)
 #define  CSR_GCFG_GCI_SHIFT		20
 #define  CSR_GCFG_GCI_WIDTH		2
 #define  CSR_GCFG_GCI			(_ULCAST_(0x3) << CSR_GCFG_GCI_SHIFT)
+/* All cacheop instructions will trap to host */
 #define  CSR_GCFG_GCI_ALL		(_ULCAST_(0x0) << CSR_GCFG_GCI_SHIFT)
+/* Cacheop instruction except hit invalidate will trap to host */
 #define  CSR_GCFG_GCI_HIT		(_ULCAST_(0x1) << CSR_GCFG_GCI_SHIFT)
+/* Cacheop instruction except hit and index invalidate will trap to host */
 #define  CSR_GCFG_GCI_SECURE		(_ULCAST_(0x2) << CSR_GCFG_GCI_SHIFT)
 #define  CSR_GCFG_GCIP_SHIFT		16
 #define  CSR_GCFG_GCIP			(_ULCAST_(0xf) << CSR_GCFG_GCIP_SHIFT)
+/* Read-only bit: show feature CSR_GCFG_GCI_ALL supported or not */
 #define  CSR_GCFG_GCIP_ALL		(_ULCAST_(0x1) << CSR_GCFG_GCIP_SHIFT)
+/* Read-only bit: show feature CSR_GCFG_GCI_HIT supported or not */
 #define  CSR_GCFG_GCIP_HIT		(_ULCAST_(0x1) << (CSR_GCFG_GCIP_SHIFT + 1))
+/* Read-only bit: show feature CSR_GCFG_GCI_SECURE supported or not */
 #define  CSR_GCFG_GCIP_SECURE		(_ULCAST_(0x1) << (CSR_GCFG_GCIP_SHIFT + 2))
 #define  CSR_GCFG_TORU_SHIFT		15
+/* Operation with CSR register unimplemented will trap to host */
 #define  CSR_GCFG_TORU			(_ULCAST_(0x1) << CSR_GCFG_TORU_SHIFT)
 #define  CSR_GCFG_TORUP_SHIFT		14
+/* Read-only bit: show feature CSR_GCFG_TORU supported or not */
 #define  CSR_GCFG_TORUP			(_ULCAST_(0x1) << CSR_GCFG_TORUP_SHIFT)
 #define  CSR_GCFG_TOP_SHIFT		13
+/* Modificattion with CRMD.PLV will trap to host */
 #define  CSR_GCFG_TOP			(_ULCAST_(0x1) << CSR_GCFG_TOP_SHIFT)
 #define  CSR_GCFG_TOPP_SHIFT		12
+/* Read-only bit: show feature CSR_GCFG_TOP supported or not */
 #define  CSR_GCFG_TOPP			(_ULCAST_(0x1) << CSR_GCFG_TOPP_SHIFT)
 #define  CSR_GCFG_TOE_SHIFT		11
+/* ertn instruction will trap to host */
 #define  CSR_GCFG_TOE			(_ULCAST_(0x1) << CSR_GCFG_TOE_SHIFT)
 #define  CSR_GCFG_TOEP_SHIFT		10
+/* Read-only bit: show feature CSR_GCFG_TOE supported or not */
 #define  CSR_GCFG_TOEP			(_ULCAST_(0x1) << CSR_GCFG_TOEP_SHIFT)
 #define  CSR_GCFG_TIT_SHIFT		9
+/* Timer instruction such as rdtime/TCFG/TVAL will trap to host */
 #define  CSR_GCFG_TIT			(_ULCAST_(0x1) << CSR_GCFG_TIT_SHIFT)
 #define  CSR_GCFG_TITP_SHIFT		8
+/* Read-only bit: show feature CSR_GCFG_TIT supported or not */
 #define  CSR_GCFG_TITP			(_ULCAST_(0x1) << CSR_GCFG_TITP_SHIFT)
 #define  CSR_GCFG_SIT_SHIFT		7
+/* All privilege instruction will trap to host */
 #define  CSR_GCFG_SIT			(_ULCAST_(0x1) << CSR_GCFG_SIT_SHIFT)
 #define  CSR_GCFG_SITP_SHIFT		6
+/* Read-only bit: show feature CSR_GCFG_SIT supported or not */
 #define  CSR_GCFG_SITP			(_ULCAST_(0x1) << CSR_GCFG_SITP_SHIFT)
 #define  CSR_GCFG_MATC_SHITF		4
 #define  CSR_GCFG_MATC_WIDTH		2
 #define  CSR_GCFG_MATC_MASK		(_ULCAST_(0x3) << CSR_GCFG_MATC_SHITF)
+/* Cache attribute comes from GVA->GPA mapping */
 #define  CSR_GCFG_MATC_GUEST		(_ULCAST_(0x0) << CSR_GCFG_MATC_SHITF)
+/* Cache attribute comes from GPA->HPA mapping */
 #define  CSR_GCFG_MATC_ROOT		(_ULCAST_(0x1) << CSR_GCFG_MATC_SHITF)
+/* Cache attribute comes from weaker one of GVA->GPA and GPA->HPA mapping */
 #define  CSR_GCFG_MATC_NEST		(_ULCAST_(0x2) << CSR_GCFG_MATC_SHITF)
 #define  CSR_GCFG_MATP_NEST_SHIFT	2
+/* Read-only bit: show feature CSR_GCFG_MATC_NEST supported or not */
 #define  CSR_GCFG_MATP_NEST		(_ULCAST_(0x1) << CSR_GCFG_MATP_NEST_SHIFT)
 #define  CSR_GCFG_MATP_ROOT_SHIFT	1
+/* Read-only bit: show feature CSR_GCFG_MATC_ROOT supported or not */
 #define  CSR_GCFG_MATP_ROOT		(_ULCAST_(0x1) << CSR_GCFG_MATP_ROOT_SHIFT)
 #define  CSR_GCFG_MATP_GUEST_SHIFT	0
+/* Read-only bit: show feature CSR_GCFG_MATC_GUEST suppoorted or not */
 #define  CSR_GCFG_MATP_GUEST		(_ULCAST_(0x1) << CSR_GCFG_MATP_GUEST_SHIFT)
 
 #define LOONGARCH_CSR_GINTC		0x52	/* Guest interrupt control */
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index bf9268bf26d5..f6d3242b9234 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -303,9 +303,9 @@ int kvm_arch_enable_virtualization_cpu(void)
 	 * TOE=0:       Trap on Exception.
 	 * TIT=0:       Trap on Timer.
 	 */
-	if (env & CSR_GCFG_GCIP_ALL)
+	if (env & CSR_GCFG_GCIP_SECURE)
 		gcfg |= CSR_GCFG_GCI_SECURE;
-	if (env & CSR_GCFG_MATC_ROOT)
+	if (env & CSR_GCFG_MATP_ROOT)
 		gcfg |= CSR_GCFG_MATC_ROOT;
 
 	write_csr_gcfg(gcfg);
-- 
2.39.3


