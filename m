Return-Path: <kvm+bounces-43766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5FFA96159
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C31817BA1C
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E192725DCF8;
	Tue, 22 Apr 2025 08:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="MammLggy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA525523A;
	Tue, 22 Apr 2025 08:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310232; cv=none; b=oVyxq1jb724EhMhFpNr/+tJTvQQIBzJYZopCHQmq6mq5LbmjMccvY5aJ9EMLjCH19E/u1ndto7/o+DwQeUN2W5VH/EnSHcHoBq92z5F/84MX2qFhYS4WxuG+T4iYJhMmzAtsn7NWlix6rnraqMzXqSNgS3ExGYwBkP0/zdLJzuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310232; c=relaxed/simple;
	bh=0jV3ofUmR+OUsR5zy184TvIYTOx/7QK6tGc17DPJNNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhvIjon7iGWAnJd90vf+dq3Wv3nt5p6aXZTM6zdRkR/R1f2nWpECF12lxdDPWzhjiRLFi4QJzI/4yxbgr0wzUEyQp/VL/wek5a4Y2KMCwMYLL19lUNS7sEOfypeygBcpSE4yrbbYtEgVRvQusibjt9KDRUZBRpu08k8Nuq+2FIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=MammLggy; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9g1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:18 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9g1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310199;
	bh=KjomXZ5P3Zbm1klfdzn3LReOwRDs2PdqfVOgUPEXtew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MammLggyo/MjNNAwAcGt2FRRqSlsggJGU25zpYplrm30iO3Y/UZa+69mVrL7h5AdS
	 +QF2vmuyoTUyD+PdpH0lcuLBEfsSmWJnEV4E43GwV3sP/7cQrcCY/s75xekunodRVa
	 MBCN8M8aF0nhj0PDdRAf4MrLwGcINYVauVcmEuaMv8xJCquK+hO/zGDpXej860AYjg
	 NOT8SBUSpQ3ULjUuZ/sIg7bsPjGu5PLZtigXd69vD9lGPI77KfO9GCa1dmtAwL41Tk
	 B7LFh5ljq9pZHluYM3LgLnmCHGK++CYmGWll/VVGfqOlZWhC1wu5qdivPclw361f2G
	 tQVJYMIZbWMzA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 28/34] x86/msr: Rename native_write_msr_safe() to native_wrmsrq_safe()
Date: Tue, 22 Apr 2025 01:22:09 -0700
Message-ID: <20250422082216.1954310-29-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h | 4 ++--
 arch/x86/kvm/svm/svm.c     | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 72a1c3301d46..a1c63bed14be 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -366,7 +366,7 @@ static __always_inline int rdmsrq_safe(u32 msr, u64 *val)
  *                         __native_wrmsrq()   -----------------------
  *                            /     \                                |
  *                           /       \                               |
- *        native_wrmsrq_no_trace()    native_write_msr_safe()        |
+ *        native_wrmsrq_no_trace()    native_wrmsrq_safe()           |
  *                   /        \                                      |
  *                  /          \                                     |
  * native_wrmsr_no_trace()    native_wrmsrq()                        |
@@ -480,7 +480,7 @@ static inline void notrace native_wrmsrq(u32 msr, u64 val)
 		do_trace_write_msr(msr, val, 0);
 }
 
-static inline int notrace native_write_msr_safe(u32 msr, u64 val)
+static inline int notrace native_wrmsrq_safe(u32 msr, u64 val)
 {
 	int err = __native_wrmsrq(msr, val, EX_TYPE_WRMSR_SAFE) ? -EIO : 0;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 838606f784c9..01dd3cd20730 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -486,7 +486,7 @@ static void svm_init_erratum_383(void)
 
 	val |= (1ULL << 47);
 
-	native_write_msr_safe(MSR_AMD64_DC_CFG, val);
+	native_wrmsrq_safe(MSR_AMD64_DC_CFG, val);
 
 	erratum_383_found = true;
 }
@@ -2159,11 +2159,11 @@ static bool is_erratum_383(void)
 
 	/* Clear MCi_STATUS registers */
 	for (i = 0; i < 6; ++i)
-		native_write_msr_safe(MSR_IA32_MCx_STATUS(i), 0);
+		native_wrmsrq_safe(MSR_IA32_MCx_STATUS(i), 0);
 
 	if (!native_read_msr_safe(MSR_IA32_MCG_STATUS, &value)) {
 		value &= ~(1ULL << 2);
-		native_write_msr_safe(MSR_IA32_MCG_STATUS, value);
+		native_wrmsrq_safe(MSR_IA32_MCG_STATUS, value);
 	}
 
 	/* Flush tlb to evict multi-match entries */
-- 
2.49.0


