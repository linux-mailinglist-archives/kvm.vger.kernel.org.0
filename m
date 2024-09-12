Return-Path: <kvm+bounces-26767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D33B4977319
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 22:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03F3E1C2400A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 20:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689CE13CFB7;
	Thu, 12 Sep 2024 20:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="p6WGuMAL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EnaehZy7"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DE31C175D;
	Thu, 12 Sep 2024 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726174586; cv=none; b=IHhDvrM+cpxKl9t9Zt5OgjxQyr++6QRetNHeLUjZ58fdtpEn2bs7xFPrRReu02rw9b3BFK4IHzI/nfMi2cvNEakC94ar+Ylb/FKojAREA8SczXJtnc0Yak0bQjg9KA/YAcVRDxF4LD4hduEGt4s+BR20Is41LDbYpGi8dx5iwHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726174586; c=relaxed/simple;
	bh=i4AJ5RF2F7OI7eD5fv5C6D25iOBzdui0AtoaoAfw5vM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MxP4bgHKG0Y2fxwNXQVEs9qOglTjHoWj34KZGYin+7KNz/AK7N1/0gENhJCNc6OiiBeEW//6q83yZehZqdusuXSlby0L9osea1T+RjS7UWInlGkENOHCjcuZ841qQ5TG3VFULqkHdCf83vZKPJb8FoElT2r2n3IiGbbhVxNxlJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=p6WGuMAL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EnaehZy7; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E462E114044C;
	Thu, 12 Sep 2024 16:56:23 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Thu, 12 Sep 2024 16:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1726174583;
	 x=1726260983; bh=0mJCOZlzKTUXs/wLWXfUe8O4l6+DQg+cH6HVgjtEBlY=; b=
	p6WGuMALWAJ+ECpFZtL4yXNAShUrv8H+3hYaGXa1O/r/mXRtTTxqMlbeZu1YzKq1
	dvUXA5MceQpO+JWojPjHbqsu0vlrKPNeCJaDbe3Oa0m2LuTtEto7BcLylQCt6mxL
	uzJixvsFnLhI/c4OMHdcEorKN5dp2g1Z3GPsmDUVHAydtnt0jCQKiMSy+1OzRgBQ
	S13++FSHm2xCaUsCndVaTdXHI6h1kALEJv88tHoUXle59x+3DK9jKRCS2Vp0g+cV
	QyJSM5cmyZKeO1nz2U9Br2/kBNWeSdjOEhj5s/JUPZ/4h2Jih22nw4uZ+wRqAt5k
	X0z0wdS5LGP6Mfn35YFBTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1726174583; x=
	1726260983; bh=0mJCOZlzKTUXs/wLWXfUe8O4l6+DQg+cH6HVgjtEBlY=; b=E
	naehZy7W6KYMo4389y+yuN97iCssCqtPWJ2qYWi158cqMxxPBa50H7pMEMvikCng
	nQNxmQLWsRwBTboMjsrJjqCP95Xt5gsyqgLUck20fwxPs/uf0F4hVDSzTP8IeA88
	4GS6i002/DGvtJOEIT177/XIx6MPkIXDNAVWcljFUdZ1s9AbWoI8rV5/r71weDR9
	3sUsd4+Wz8MXEA5WWpl+ORMYOwNS8Mkm567cO6CvzSf0KV2R/0QZ07/0sCc/wHT0
	vYigvqgpxYZrmn2D+VxzQjRG5UUaIlOu1QxmI435q0x1i8hAwJUURP8O3JIpMCbR
	vkmbXvB1PBCgwZALkDLzA==
X-ME-Sender: <xms:d1XjZrsUDEBZiHwRv78jBKY7QIHRZHgCsSGPXnuXh6JpL0T6K6-3Ug>
    <xme:d1XjZsfxHq4sqxj13qrb9Y37Bhmpy6irwPBHRQiOUYDBXOcXYx1v8PL6ulFaYDUHO
    RBPZL7zlvXelYG5QNU>
X-ME-Received: <xmr:d1XjZuwTOl3tPm-zVR_hxXFUVT9mfRXGpczNNaBHk-4JpDBGFwctj4o8xp9fG0WFOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejfedgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhfffugggtgffkfhgjvfevofesthejredtredt
    jeenucfhrhhomheplfhirgiguhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflh
    ihghhorghtrdgtohhmqeenucggtffrrghtthgvrhhnpedvkeeihfefveekueevteefleff
    keegudeghfdtuddugefhueevgeffgedukeejleenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorght
    rdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtoheplhhoohhngh
    grrhgthheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhp
    mhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepthhssghoghgvnhgusegrlhhphhgrrdhfrhgr
    nhhkvghnrdguvgdprhgtphhtthhopehjihgrgihunhdrhigrnhhgsehflhihghhorghtrd
    gtohhmpdhrtghpthhtoheprhgrfhgrvghlsehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:d1XjZqPvEyoHrd2XBXM0pBYAV8xLSb5xASB2nNbeiHvcpalYgx-T2w>
    <xmx:d1XjZr8-UVQuOQ1d64AXkzWYYtTWqfSkWF9-3A3RT-FpKHBrUbB4Dw>
    <xmx:d1XjZqXt8d9xWMnOs9G91ng1PBgumne8fX2W4UO_LKZmEp85tZRGPQ>
    <xmx:d1XjZsf-PVLAvkVqYjPsikIYxMYhWUkMk3-WNhXwWBqMBrkQTATh6A>
    <xmx:d1XjZuU-kxaV_jg1BjaYIamQ-AOG82UzzYeRs22Spuxkhvt5G18pZucx>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Sep 2024 16:56:22 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Thu, 12 Sep 2024 21:55:54 +0100
Subject: [PATCH v2 1/4] LoongArch: Probe more CPU features from CPUCFG
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240912-iocsr-v2-1-e88f75b37da4@flygoat.com>
References: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com>
In-Reply-To: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com>
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5866;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=i4AJ5RF2F7OI7eD5fv5C6D25iOBzdui0AtoaoAfw5vM=;
 b=kA0DAAoWQ3EMfdd3KcMByyZiAGbjVXPIKT+9Y6vSW6ytcE1VAbFKPCahmiaY8Kj2QedcQFYRf
 Ih1BAAWCgAdFiEEVBAijrCB0aDX4Gr8Q3EMfdd3KcMFAmbjVXMACgkQQ3EMfdd3KcNE/gD/UJcn
 QauBvskhFJo2aBVmrzP+IItNKPTI+Fyj54bO67YA/RkHMTc9LsMYEpsF71wxGvMVOx0qQNvffeb
 Y6SoDFacO
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Probe ISA level, TLB, IOCSR information from CPUCFG to
improve kernel resilience to different core implementations.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/loongarch/include/asm/cpu.h       |  4 +++
 arch/loongarch/include/asm/loongarch.h |  3 +-
 arch/loongarch/kernel/cpu-probe.c      | 54 ++++++++++++++++++++++++----------
 3 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/include/asm/cpu.h
index 843f9c4ec980..251a15439cff 100644
--- a/arch/loongarch/include/asm/cpu.h
+++ b/arch/loongarch/include/asm/cpu.h
@@ -100,6 +100,8 @@ enum cpu_type_enum {
 #define CPU_FEATURE_HYPERVISOR		25	/* CPU has hypervisor (running in VM) */
 #define CPU_FEATURE_PTW			26	/* CPU has hardware page table walker */
 #define CPU_FEATURE_AVECINT		27	/* CPU has avec interrupt */
+#define CPU_FEATURE_IOCSR		28	/* CPU has IOCSR */
+#define CPU_FEATURE_LSPW		29	/* CPU has LSPW */
 
 #define LOONGARCH_CPU_CPUCFG		BIT_ULL(CPU_FEATURE_CPUCFG)
 #define LOONGARCH_CPU_LAM		BIT_ULL(CPU_FEATURE_LAM)
@@ -129,5 +131,7 @@ enum cpu_type_enum {
 #define LOONGARCH_CPU_HYPERVISOR	BIT_ULL(CPU_FEATURE_HYPERVISOR)
 #define LOONGARCH_CPU_PTW		BIT_ULL(CPU_FEATURE_PTW)
 #define LOONGARCH_CPU_AVECINT		BIT_ULL(CPU_FEATURE_AVECINT)
+#define LOONGARCH_CPU_IOCSR		BIT_ULL(CPU_FEATURE_IOCSR)
+#define LOONGARCH_CPU_LSPW		BIT_ULL(CPU_FEATURE_LSPW)
 
 #endif /* _ASM_CPU_H */
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 631d249b3ef2..23af28f00c3c 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -60,8 +60,7 @@
 #define  CPUCFG0_PRID			GENMASK(31, 0)
 
 #define LOONGARCH_CPUCFG1		0x1
-#define  CPUCFG1_ISGR32			BIT(0)
-#define  CPUCFG1_ISGR64			BIT(1)
+#define  CPUCFG1_ISA			GENMASK(1, 0)
 #define  CPUCFG1_PAGING			BIT(2)
 #define  CPUCFG1_IOCSR			BIT(3)
 #define  CPUCFG1_PABITS			GENMASK(11, 4)
diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 14f0449f5452..5dc8ca3c4387 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -92,11 +92,29 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 	unsigned long asid_mask;
 
 	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
-		     LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
+		     LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
 
 	elf_hwcap = HWCAP_LOONGARCH_CPUCFG;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG1);
+
+	switch (config & CPUCFG1_ISA) {
+	case 0:
+		set_isa(c, LOONGARCH_CPU_ISA_LA32R);
+		break;
+	case 1:
+		set_isa(c, LOONGARCH_CPU_ISA_LA32S);
+		break;
+	case 2:
+		set_isa(c, LOONGARCH_CPU_ISA_LA64);
+		break;
+	default:
+		pr_warn("Warning: unknown ISA level\n");
+	}
+	if (config & CPUCFG1_PAGING)
+		c->options |= LOONGARCH_CPU_TLB;
+	if (config & CPUCFG1_IOCSR)
+		c->options |= LOONGARCH_CPU_IOCSR;
 	if (config & CPUCFG1_UAL) {
 		c->options |= LOONGARCH_CPU_UAL;
 		elf_hwcap |= HWCAP_LOONGARCH_UAL;
@@ -157,6 +175,8 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 		elf_hwcap |= HWCAP_LOONGARCH_LBT_MIPS;
 	}
 #endif
+	if (config & CPUCFG2_LSPW)
+		c->options |= LOONGARCH_CPU_LSPW;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG6);
 	if (config & CPUCFG6_PMP)
@@ -222,6 +242,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 {
 	uint64_t *vendor = (void *)(&cpu_full_name[VENDOR_OFFSET]);
 	uint64_t *cpuname = (void *)(&cpu_full_name[CPUNAME_OFFSET]);
+	const char *core_name = "Unknown";
 
 	if (!__cpu_full_name[cpu])
 		__cpu_full_name[cpu] = cpu_full_name;
@@ -232,40 +253,43 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 	switch (c->processor_id & PRID_SERIES_MASK) {
 	case PRID_SERIES_LA132:
 		c->cputype = CPU_LOONGSON32;
-		set_isa(c, LOONGARCH_CPU_ISA_LA32S);
 		__cpu_family[cpu] = "Loongson-32bit";
-		pr_info("32-bit Loongson Processor probed (LA132 Core)\n");
+		core_name = "LA132";
 		break;
 	case PRID_SERIES_LA264:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA264 Core)\n");
+		core_name = "LA264";
 		break;
 	case PRID_SERIES_LA364:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA364 Core)\n");
+		core_name = "LA364";
 		break;
 	case PRID_SERIES_LA464:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA464 Core)\n");
+		core_name = "LA464";
 		break;
 	case PRID_SERIES_LA664:
 		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
 		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (LA664 Core)\n");
+		core_name = "LA664";
 		break;
 	default: /* Default to 64 bit */
-		c->cputype = CPU_LOONGSON64;
-		set_isa(c, LOONGARCH_CPU_ISA_LA64);
-		__cpu_family[cpu] = "Loongson-64bit";
-		pr_info("64-bit Loongson Processor probed (Unknown Core)\n");
+		if (c->isa_level & LOONGARCH_CPU_ISA_LA64) {
+			c->cputype = CPU_LOONGSON64;
+			__cpu_family[cpu] = "Loongson-64bit";
+		} else if (c->isa_level & LOONGARCH_CPU_ISA_LA32S) {
+			c->cputype = CPU_LOONGSON32;
+			__cpu_family[cpu] = "Loongson-32bit";
+		} else if (c->isa_level & LOONGARCH_CPU_ISA_LA32R) {
+			c->cputype = CPU_LOONGSON32;
+			__cpu_family[cpu] = "Loongson-32bit Reduced";
+		}
 	}
+
+	pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu], core_name);
 }
 
 #ifdef CONFIG_64BIT

-- 
2.46.0


