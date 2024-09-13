Return-Path: <kvm+bounces-26868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA521978A04
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 22:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5B781C21774
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AAD61714C8;
	Fri, 13 Sep 2024 20:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="f3p75sk2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WJmLZp/3"
X-Original-To: kvm@vger.kernel.org
Received: from fout6-smtp.messagingengine.com (fout6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553F616BE1C;
	Fri, 13 Sep 2024 20:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726259582; cv=none; b=nf/RfJtnabWbCt55ofnIvEII0k16GlnJzINaBrEW+VQXpETBACQUC12YBL/OZMGIpAHPb4WoM3vJElT0NKdKYsl+G376DbyJl0Z0hLa1JUIiA2zPCrHMV67WmohOx8y/CtXBB7KIsdqI3o6An1/7NeUVIti0LMTdMP4XqbFqoDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726259582; c=relaxed/simple;
	bh=QR4DGLMUsuXkjf1A1LS7CFLwhFvqzfkt5ophtTS3Iko=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TWWIqO8sEI3WSNzI6fs5/Siq/LJu0tsCQIZePl+5AikmgHS4tVxlS/5DZKRf942eajq2QeR9aFM6iIwUIWEW0FzF4qPX6fS/qXT1Gq/ZoKxBPlqdvazRdJ+IWXFFQrX3WBoxMIl9S6pwuzho0fwEjaTkrsoib22C92srq+Kjuvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=f3p75sk2; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WJmLZp/3; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 8364413803C6;
	Fri, 13 Sep 2024 16:32:59 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 13 Sep 2024 16:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1726259579;
	 x=1726345979; bh=5yZhMf1etdNhnGTjDvT1Dwa0rJtLOxEPY0uZSbNmmL4=; b=
	f3p75sk2Kb/jxmV8o9K/xLUM6lPpIhcsK9Y8cj25Q0k1SgZC4FuJMQK3YDSFRjr5
	w4uBnUO2NToGZJhdsUg66oXRY6gWwCcrubdTkDGYqsiCes0hWVsMIyCQAmS3sGSm
	l8oIY1iZknDCG0LSorek5zO1syqSOcxUbXYGRLd/Q3VfcDpNY3ijytgcIeveWFUo
	Be9cEbIPtYh87rIg/dLMKvM3uzFU8n7zLLwBFYajcsDN0TKPJGY6umBIdOgaNJLE
	D0Bkuf0kmid3Qxp8CJ3I0fs4G7BSqyzVixVVxjl5J4w+k1A7mB12TZfazbGismwy
	Qiit4qbHLpFJmOj0Sih/Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1726259579; x=
	1726345979; bh=5yZhMf1etdNhnGTjDvT1Dwa0rJtLOxEPY0uZSbNmmL4=; b=W
	JmLZp/3CrIGOwNNk0q1OB+GIDYJhuZeqUG6aXBu+YA1sl7g2LbIk0OCAdnmAp9oR
	fdO0amiLCqyw/bFSBakPmREfpwE3tmEbtGFJWLhRBaWbaHsLZpfyifWYrbhmC1LH
	LmNGn7vTsXYdpbFdLt+4tFpOAW/vVnWunSJ17Fj944+A+m5sbXNkji+XYF5bewMD
	Mc/fPIUe360q8E9m4TvScXKzYVU/vZmK/goBZgOiX7Bb24YuNrqbRecZBOCP1L+c
	7elrfgcn5pv/mgtCOt+0aNYCt0RKxp3HCwKD3z1ZbyaBS3IjN28kOy+m4dkzjG6V
	wTn4+WnZ5Opcrp2IneE4g==
X-ME-Sender: <xms:e6HkZjdBl2jZywSZL8R3DBrkrHfG2l3IeWFtw-DnkUfmb0nwTZlkUA>
    <xme:e6HkZpNKqIX3higvLoIO7gZJhzP5vXLAoVRC3oYxGe1cPMWEhMcvDqOtdlZTA_48h
    fGCysZPlJJmdfEZoco>
X-ME-Received: <xmr:e6HkZsgqjExnIqqPPSRlQGwnyEfaAKDlfqW1o0poybtaWDZxJ3k9zm2WVlKp9fmMv6M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephfffufggtgfgkfhfjgfvvefosehtjeertdertdej
    necuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhi
    hgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepvdekiefhfeevkeeuveetfeelffek
    gedugefhtdduudeghfeuveegffegudekjeelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdr
    tghomhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtth
    hopegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhhvmhes
    vhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmihhpshesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehvihhrvghshhdrkhhumhgrrhes
    lhhinhgrrhhordhorhhgpdhrtghpthhtohepjhhirgiguhhnrdihrghnghesfhhlhihgoh
    grthdrtghomhdprhgtphhtthhopehlihhnuhigqdhpmhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehkvghrnhgvlhesgigvnhdtnhdrnhgrmhgvpdhrtghpthhtoh
    eprhgrfhgrvghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:e6HkZk9TYas-PwBmnKO3G0-3SKNklcXSlK4L7912NJpg5PTl3XBAkw>
    <xmx:e6HkZvs2YfQc2AK0xzYtLXPZg4Z_wIKU8J8PhrQCq5ZuZ5c_BuikXQ>
    <xmx:e6HkZjGHFD8rp8YnTt-CT9ms2aHNOiMsqd8Vgdh4B_qcNUuUC63yQg>
    <xmx:e6HkZmMn_d6ak3YVPQcNrKuRTlaRZJ9kICWM3o2GNv0xOC_-mUaAsA>
    <xmx:e6HkZoHGHTg3m17tffBXN6C7SWn_yi9_lHmXXsYJaqhmIL6RW6opc_oG>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Sep 2024 16:32:51 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Fri, 13 Sep 2024 21:32:07 +0100
Subject: [PATCH v3 4/4] MIPS: Loongson64: Use shared IOCSR header
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240913-iocsr-v3-4-81a57f60350d@flygoat.com>
References: <20240913-iocsr-v3-0-81a57f60350d@flygoat.com>
In-Reply-To: <20240913-iocsr-v3-0-81a57f60350d@flygoat.com>
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=10190;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=QR4DGLMUsuXkjf1A1LS7CFLwhFvqzfkt5ophtTS3Iko=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrQnC6P/O6s9UKzm2WQ3e9rm57PWl2XYsyQr71i1dgGjq
 YLnk1DbjlIWBjEuBlkxRZYQAaW+DY0XF1x/kPUHZg4rE8gQBi5OAZjIuhSGv4IevN9rN4uL1TRG
 hM35omJ576dNmvFklwdhSwJ+aF683c7IMLfgyeKzVybP01m26VHfXVGHbEbGZXaf/mxfvcZAvs3
 YhwEA
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

MIPS and LoongArch Loongson CPUs are sharing definition of
IOCSR registers, so it makes sense to use the same header
as well.

Align function names in loongson_regs.h with it's loongarch
equivalent and fix up macro names everywhere.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 .../include/asm/mach-loongson64/loongson_regs.h    | 58 ++++++----------------
 arch/mips/kvm/vz.c                                 |  2 +-
 arch/mips/loongson64/smp.c                         | 44 ++++++++--------
 drivers/platform/mips/cpu_hwmon.c                  |  7 ++-
 include/linux/loongson/iocsr.h                     |  5 +-
 5 files changed, 46 insertions(+), 70 deletions(-)

diff --git a/arch/mips/include/asm/mach-loongson64/loongson_regs.h b/arch/mips/include/asm/mach-loongson64/loongson_regs.h
index fec767507604..d8af16796dbe 100644
--- a/arch/mips/include/asm/mach-loongson64/loongson_regs.h
+++ b/arch/mips/include/asm/mach-loongson64/loongson_regs.h
@@ -5,12 +5,13 @@
 #ifndef _LOONGSON_REGS_H_
 #define _LOONGSON_REGS_H_
 
-#include <linux/types.h>
 #include <linux/bits.h>
+#include <linux/types.h>
 
 #include <asm/mipsregs.h>
 #include <asm/cpu.h>
 
+#ifndef __ASSEMBLY__
 static inline bool cpu_has_cfg(void)
 {
 	return ((read_c0_prid() & PRID_IMP_MASK) == PRID_IMP_LOONGSON_64G);
@@ -33,6 +34,7 @@ static inline u32 read_cpucfg(u32 reg)
 		);
 	return __res;
 }
+#endif
 
 /* Bit Domains for CFG registers */
 #define LOONGSON_CFG0	0x0
@@ -131,6 +133,7 @@ static inline u32 read_cpucfg(u32 reg)
 #define LOONGSON_CFG7_GCCAEQRP	BIT(0)
 #define LOONGSON_CFG7_UCAWINP	BIT(1)
 
+#ifndef __ASSEMBLY__
 static inline bool cpu_has_csr(void)
 {
 	if (cpu_has_cfg())
@@ -139,7 +142,10 @@ static inline bool cpu_has_csr(void)
 	return false;
 }
 
-static inline u32 csr_readl(u32 reg)
+#define cpu_has_iocsr()	cpu_has_csr()
+
+/* For MIPS/Loongson IOCSR and Core CSR are accessed same way */
+static inline u32 csr_read32(u32 reg)
 {
 	u32 __res;
 
@@ -158,7 +164,7 @@ static inline u32 csr_readl(u32 reg)
 	return __res;
 }
 
-static inline u64 csr_readq(u32 reg)
+static inline u64 csr_read64(u32 reg)
 {
 	u64 __res;
 
@@ -177,7 +183,7 @@ static inline u64 csr_readq(u32 reg)
 	return __res;
 }
 
-static inline void csr_writel(u32 val, u32 reg)
+static inline void csr_write32(u32 val, u32 reg)
 {
 	/* WRCSR reg, val */
 	__asm__ __volatile__(
@@ -193,7 +199,7 @@ static inline void csr_writel(u32 val, u32 reg)
 		);
 }
 
-static inline void csr_writeq(u64 val, u32 reg)
+static inline void csr_write64(u64 val, u32 reg)
 {
 	/* DWRCSR reg, val */
 	__asm__ __volatile__(
@@ -209,43 +215,10 @@ static inline void csr_writeq(u64 val, u32 reg)
 		);
 }
 
-/* Public CSR Register can also be accessed with regular addresses */
-#define CSR_PUBLIC_MMIO_BASE 0x1fe00000
-
-#define MMIO_CSR(x)		(void *)TO_UNCAC(CSR_PUBLIC_MMIO_BASE + x)
-
-#define LOONGSON_CSR_FEATURES	0x8
-#define LOONGSON_CSRF_TEMP	BIT(0)
-#define LOONGSON_CSRF_NODECNT	BIT(1)
-#define LOONGSON_CSRF_MSI	BIT(2)
-#define LOONGSON_CSRF_EXTIOI	BIT(3)
-#define LOONGSON_CSRF_IPI	BIT(4)
-#define LOONGSON_CSRF_FREQ	BIT(5)
-
-#define LOONGSON_CSR_VENDOR	0x10 /* Vendor name string, should be "Loongson" */
-#define LOONGSON_CSR_CPUNAME	0x20 /* Processor name string */
-#define LOONGSON_CSR_NODECNT	0x408
-#define LOONGSON_CSR_CPUTEMP	0x428
-
-/* PerCore CSR, only accessible by local cores */
-#define LOONGSON_CSR_IPI_STATUS	0x1000
-#define LOONGSON_CSR_IPI_EN	0x1004
-#define LOONGSON_CSR_IPI_SET	0x1008
-#define LOONGSON_CSR_IPI_CLEAR	0x100c
-#define LOONGSON_CSR_IPI_SEND	0x1040
-#define CSR_IPI_SEND_IP_SHIFT	0
-#define CSR_IPI_SEND_CPU_SHIFT	16
-#define CSR_IPI_SEND_BLOCK	BIT(31)
-
-#define LOONGSON_CSR_MAIL_BUF0		0x1020
-#define LOONGSON_CSR_MAIL_SEND		0x1048
-#define CSR_MAIL_SEND_BLOCK		BIT_ULL(31)
-#define CSR_MAIL_SEND_BOX_LOW(box)	(box << 1)
-#define CSR_MAIL_SEND_BOX_HIGH(box)	((box << 1) + 1)
-#define CSR_MAIL_SEND_BOX_SHIFT		2
-#define CSR_MAIL_SEND_CPU_SHIFT		16
-#define CSR_MAIL_SEND_BUF_SHIFT		32
-#define CSR_MAIL_SEND_H32_MASK		0xFFFFFFFF00000000ULL
+#define iocsr_read32(reg)	csr_read32(reg)
+#define iocsr_read64(reg)	csr_read64(reg)
+#define iocsr_write32(val, reg)	csr_write32(val, reg)
+#define iocsr_write64(val, reg)	csr_write64(val, reg)
 
 static inline u64 drdtime(void)
 {
@@ -264,5 +237,6 @@ static inline u64 drdtime(void)
 		);
 	return val;
 }
+#endif
 
 #endif
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 99d5a71e4300..4964c1922b23 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2977,7 +2977,7 @@ static int kvm_vz_hardware_enable(void)
 #ifdef CONFIG_CPU_LOONGSON64
 	/* Control guest CCA attribute */
 	if (cpu_has_csr())
-		csr_writel(csr_readl(0xffffffec) | 0x1, 0xffffffec);
+		csr_write32(csr_read32(0xffffffec) | 0x1, 0xffffffec);
 #endif
 
 	return 0;
diff --git a/arch/mips/loongson64/smp.c b/arch/mips/loongson64/smp.c
index 147acd972a07..0cf03377edf0 100644
--- a/arch/mips/loongson64/smp.c
+++ b/arch/mips/loongson64/smp.c
@@ -7,6 +7,7 @@
 #include <irq.h>
 #include <linux/init.h>
 #include <linux/cpu.h>
+#include <linux/loongson/iocsr.h>
 #include <linux/sched.h>
 #include <linux/sched/hotplug.h>
 #include <linux/sched/task_stack.h>
@@ -19,7 +20,6 @@
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <loongson.h>
-#include <loongson_regs.h>
 #include <workarounds.h>
 
 #include "smp.h"
@@ -45,19 +45,19 @@ static void csr_mail_send(uint64_t data, int cpu, int mailbox)
 {
 	uint64_t val;
 
-	/* send high 32 bits */
-	val = CSR_MAIL_SEND_BLOCK;
-	val |= (CSR_MAIL_SEND_BOX_HIGH(mailbox) << CSR_MAIL_SEND_BOX_SHIFT);
-	val |= (cpu << CSR_MAIL_SEND_CPU_SHIFT);
-	val |= (data & CSR_MAIL_SEND_H32_MASK);
-	csr_writeq(val, LOONGSON_CSR_MAIL_SEND);
-
-	/* send low 32 bits */
-	val = CSR_MAIL_SEND_BLOCK;
-	val |= (CSR_MAIL_SEND_BOX_LOW(mailbox) << CSR_MAIL_SEND_BOX_SHIFT);
-	val |= (cpu << CSR_MAIL_SEND_CPU_SHIFT);
-	val |= (data << CSR_MAIL_SEND_BUF_SHIFT);
-	csr_writeq(val, LOONGSON_CSR_MAIL_SEND);
+	/* Send high 32 bits */
+	val = IOCSR_MBUF_SEND_BLOCKING;
+	val |= (IOCSR_MBUF_SEND_BOX_HI(mailbox) << IOCSR_MBUF_SEND_BOX_SHIFT);
+	val |= (cpu << IOCSR_MBUF_SEND_CPU_SHIFT);
+	val |= (data & IOCSR_MBUF_SEND_H32_MASK);
+	iocsr_write64(val, LOONGSON_IOCSR_MBUF_SEND);
+
+	/* Send low 32 bits */
+	val = IOCSR_MBUF_SEND_BLOCKING;
+	val |= (IOCSR_MBUF_SEND_BOX_LO(mailbox) << IOCSR_MBUF_SEND_BOX_SHIFT);
+	val |= (cpu << IOCSR_MBUF_SEND_CPU_SHIFT);
+	val |= (data << IOCSR_MBUF_SEND_BUF_SHIFT);
+	iocsr_write64(val, LOONGSON_IOCSR_MBUF_SEND);
 };
 
 static u32 csr_ipi_read_clear(int cpu)
@@ -65,9 +65,9 @@ static u32 csr_ipi_read_clear(int cpu)
 	u32 action;
 
 	/* Load the ipi register to figure out what we're supposed to do */
-	action = csr_readl(LOONGSON_CSR_IPI_STATUS);
+	action = iocsr_read32(LOONGSON_IOCSR_IPI_STATUS);
 	/* Clear the ipi register to clear the interrupt */
-	csr_writel(action, LOONGSON_CSR_IPI_CLEAR);
+	iocsr_write32(action, LOONGSON_IOCSR_IPI_CLEAR);
 
 	return action;
 }
@@ -77,22 +77,22 @@ static void csr_ipi_write_action(int cpu, u32 action)
 	unsigned int irq = 0;
 
 	while ((irq = ffs(action))) {
-		uint32_t val = CSR_IPI_SEND_BLOCK;
+		uint32_t val = IOCSR_IPI_SEND_BLOCKING;
 		val |= (irq - 1);
-		val |= (cpu << CSR_IPI_SEND_CPU_SHIFT);
-		csr_writel(val, LOONGSON_CSR_IPI_SEND);
+		val |= (cpu << IOCSR_IPI_SEND_CPU_SHIFT);
+		iocsr_write32(val, LOONGSON_IOCSR_IPI_SEND);
 		action &= ~BIT(irq - 1);
 	}
 }
 
 static void csr_ipi_write_enable(int cpu)
 {
-	csr_writel(0xffffffff, LOONGSON_CSR_IPI_EN);
+	iocsr_write32(0xffffffff, LOONGSON_IOCSR_IPI_EN);
 }
 
 static void csr_ipi_clear_buf(int cpu)
 {
-	csr_writeq(0, LOONGSON_CSR_MAIL_BUF0);
+	iocsr_write64(0, LOONGSON_IOCSR_MBUF0);
 }
 
 static void csr_ipi_write_buf(int cpu, struct task_struct *idle)
@@ -169,7 +169,7 @@ static void legacy_ipi_write_buf(int cpu, struct task_struct *idle)
 
 static void csr_ipi_probe(void)
 {
-	if (cpu_has_csr() && csr_readl(LOONGSON_CSR_FEATURES) & LOONGSON_CSRF_IPI) {
+	if (cpu_has_iocsr() && iocsr_read32(LOONGSON_IOCSR_FEATURES) & IOCSRF_CSRIPI) {
 		ipi_read_clear = csr_ipi_read_clear;
 		ipi_write_action = csr_ipi_write_action;
 		ipi_write_enable = csr_ipi_write_enable;
diff --git a/drivers/platform/mips/cpu_hwmon.c b/drivers/platform/mips/cpu_hwmon.c
index 2ac2f31090f9..9b0b39a39d13 100644
--- a/drivers/platform/mips/cpu_hwmon.c
+++ b/drivers/platform/mips/cpu_hwmon.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/err.h>
+#include <linux/loongson/iocsr.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/jiffies.h>
@@ -9,7 +10,6 @@
 #include <loongson.h>
 #include <boot_param.h>
 #include <loongson_hwmon.h>
-#include <loongson_regs.h>
 
 static int csr_temp_enable;
 
@@ -24,7 +24,7 @@ int loongson3_cpu_temp(int cpu)
 	u32 reg, prid_rev;
 
 	if (csr_temp_enable) {
-		reg = (csr_readl(LOONGSON_CSR_CPUTEMP) & 0xff);
+		reg = (iocsr_read32(LOONGSON_IOCSR_CPUTEMP) & 0xff);
 		goto out;
 	}
 
@@ -136,8 +136,7 @@ static int __init loongson_hwmon_init(void)
 	pr_info("Loongson Hwmon Enter...\n");
 
 	if (cpu_has_csr())
-		csr_temp_enable = csr_readl(LOONGSON_CSR_FEATURES) &
-				  LOONGSON_CSRF_TEMP;
+		csr_temp_enable = iocsr_read32(LOONGSON_IOCSR_FEATURES) & IOCSRF_TEMP;
 
 	if (!csr_temp_enable && !loongson_chiptemp[0])
 		return -ENODEV;
diff --git a/include/linux/loongson/iocsr.h b/include/linux/loongson/iocsr.h
index 6654a904bcbe..15e70e6e132e 100644
--- a/include/linux/loongson/iocsr.h
+++ b/include/linux/loongson/iocsr.h
@@ -10,9 +10,12 @@
 #include <linux/bits.h>
 #include <linux/types.h>
 
-#ifdef CONFIG_LOONGARCH
+#if defined(CONFIG_LOONGARCH)
 #include <asm/loongarch.h>
 #endif
+#if defined(CONFIG_MIPS) && defined(CONFIG_MACH_LOONGSON64)
+#include <loongson_regs.h>
+#endif
 
 #define LOONGSON_IOCSR_FEATURES	0x8
 #define  IOCSRF_TEMP			BIT_ULL(0)

-- 
2.46.0


