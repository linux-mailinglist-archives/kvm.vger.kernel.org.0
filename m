Return-Path: <kvm+bounces-26066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9499A9701A0
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 12:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E611284F5D
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 10:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C20F15C123;
	Sat,  7 Sep 2024 10:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="x7zrx9+T";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ePpylAvi"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh3-smtp.messagingengine.com (fhigh3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCA115A86E;
	Sat,  7 Sep 2024 10:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725704236; cv=none; b=VbUlFNgClOpvSVLXYrgo7Hx4HOoP297SzaB9kHbB9iUw+QdjyfFucb2SoPA0FDVulU73nEiG7txr4oZ5Y9FIQVXrdBeUZl77ewisp1/juXeIACm+V7wtMjupD0wiE8FoYD0rX82bQLmaG54+QeQA9/jFopndrIQiXRnlxUQT/0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725704236; c=relaxed/simple;
	bh=Yuy5vb8N7sg9vNnOgBImg2bFSxqr24R7vO2r2PeHy7I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jj9Nmm4Q+60aRD/9p7/0+3c4h+N9yKasUoMPLtATE5qYMJ+IR31Wxka/0PBatka7GpAb9zqFHpmiD/mChqBt+yeGVQJBk+dmKnnH1iIziialHl7TJYpRcL/jCRcrdlhorUK0gGbiYEdVrfiUIVXyVkiims3uoe4c5P4vAhlwohs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=x7zrx9+T; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ePpylAvi; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id AB5C411402B4;
	Sat,  7 Sep 2024 06:17:13 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sat, 07 Sep 2024 06:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1725704233;
	 x=1725790633; bh=M3LRNb3so3CttnZ+QchME4peIjCeDSAzdbFQH8a41w0=; b=
	x7zrx9+TrLXnvkJW3WQCfbz0jVNqQXktyzc70fnUIYEJq/BkFzWE/HR5KEaDN3Gc
	LWA5KsyZtY0dedHneWXAD/VNwrxPg8yuzTecb1VzVotWKzKTEf3NzJSEiaiYxYDf
	kZ7jn/99viGxQXxQYWPUo0Tflk2AGvULP8NOBIpZS3tOfyy0YNzMV9zjOk4MPmaA
	BnP00d4nsT66zEnKKq4/a+UshB0laqoz1ws5X5QfkRdtnRllwma+MjtysgoGCNVS
	BkYEop63PohpfTfWqTseUeNjwrwmr7ntlHRGHmvEGLj/PaXydGRtUvI6ASBXhr1C
	bk7JD2z3c6DqGd1DBV327A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725704233; x=
	1725790633; bh=M3LRNb3so3CttnZ+QchME4peIjCeDSAzdbFQH8a41w0=; b=e
	PpylAviiZZQfvGAe92WtIfY32Yrj5gAaqZ8dgpZZJXbmhCweRJVAdziU+LGUdftA
	GJkhDZtYSzqalRAZDmpWKKrPqZdZh8zGC4+9TVP4nTaR9UlVmZexqbOZb0dEnmT5
	poG8b8E4sziK1GPMR7tmSrP7hyUOjV2+l1vef8VC63X+LZe9yjzAO9wrjUKTO9CE
	AiIR16Q39HZQJ32soA6Hwl0Q1r2cS7t0xJfGW8EHl7tInM5gGQSCKLCOUzgu3l0c
	l6fnsHCXWptAd4fiprNSC9RXp4blIaTfGcD5klVei4QtS5ir05OUEowCsJ7V3TdL
	2GMNkItL+Wwiqb1oZ3whw==
X-ME-Sender: <xms:KSjcZgTCW-zrHJsR9uN1Sa84f-Vid1W2dxCVq-xAubtT6146NmQ13w>
    <xme:KSjcZtxPB69u2N2UY-E5-hF-3ot6vUueOgc8npus3KniCQQcIWexKn6FBl7GIDVXj
    1b7jxsU4jww0ZpDatY>
X-ME-Received: <xmr:KSjcZt0ADXZWPS2j0VTnKSRn62r-JnKd46GPORmwvWNFRTh7FDSDkuBb_w62uYLDMFo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeifedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephfffufggtgfgkfhfjgfvvefosehtjeertdertdej
    necuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhi
    hgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepvdekiefhfeevkeeuveetfeelffek
    gedugefhtdduudeghfeuveegffegudekjeelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdr
    tghomhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtth
    hopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehl
    ihhnuhhtrhhonhhigidruggvpdhrtghpthhtoheptghhvghnhhhurggtrghisehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehvihhrvghshhdrkhhumhgrrheslhhinhgrrhhordho
    rhhgpdhrtghpthhtoheplhhoohhnghgrrhgthheslhhishhtshdrlhhinhhugidruggvvh
    dprhgtphhtthhopehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmpdhrtghp
    thhtohepthhssghoghgvnhgusegrlhhphhgrrdhfrhgrnhhkvghnrdguvgdprhgtphhtth
    hopehkvghrnhgvlhesgigvnhdtnhdrnhgrmhgvpdhrtghpthhtoheplhhinhhugidqmhhi
    phhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:KSjcZkBY76j2Q5eTUnJcAO8jeUu6s3s_AD8OTUSFroVvp6KpF6vtcQ>
    <xmx:KSjcZpjXdQ6UpWKzsJuYr0qIyhqaKsWkC1nLCXdhaFnj5MtT_L7T0A>
    <xmx:KSjcZgr45RhaRX3HtvMT97pflNYfP79p16UfF6zt9vdKvjZ9c9-PSg>
    <xmx:KSjcZsgpmf4klaHm62cFaKq31OnuIaEJtLUNSwsazl_HJyP1qtJn3Q>
    <xmx:KSjcZiYsg2yg1B7OpOLI6PISh2I0G6afMc3l5eQWaOuJnnsjjRiSSlH1>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Sep 2024 06:17:12 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Sat, 07 Sep 2024 11:17:05 +0100
Subject: [PATCH 3/5] LoongArch: cpu-probe: Move IOCSR probing out of
 cpu_probe_common
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240907-iocsr-v1-3-0c99b3334444@flygoat.com>
References: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
In-Reply-To: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3768;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=Yuy5vb8N7sg9vNnOgBImg2bFSxqr24R7vO2r2PeHy7I=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrQ7Gko++wMDu9nK155d1fMzSrEx9cyjbJezW47y7b939
 eJPE4YnHaUsDGJcDLJiiiwhAkp9GxovLrj+IOsPzBxWJpAhDFycAjCRaXoM/2NVn36aJLcucY+Z
 hcNSpotmayZ2Pp8yYcf65Tr7t5R1zA5hZHjLKcS1V7n2zuYN13awaVjb5C0o71/QzGP5ws7Y+Pm
 6fkYA
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

IOCSR register definition appears to be a platform specific
spec instead of architecture spec, even for Loongson CPUs
there is no guarantee that IOCSR will always present.

Thus it's dangerous to perform IOCSR probing without checking
CPU type and instruction availability.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/loongarch/kernel/cpu-probe.c | 63 ++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 6a82ceb6e321..968b5a35a0d2 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -173,22 +173,6 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 	if (config & CPUCFG6_PMP)
 		c->options |= LOONGARCH_CPU_PMP;
 
-	config = iocsr_read32(LOONGARCH_IOCSR_FEATURES);
-	if (config & IOCSRF_CSRIPI)
-		c->options |= LOONGARCH_CPU_CSRIPI;
-	if (config & IOCSRF_EXTIOI)
-		c->options |= LOONGARCH_CPU_EXTIOI;
-	if (config & IOCSRF_FREQSCALE)
-		c->options |= LOONGARCH_CPU_SCALEFREQ;
-	if (config & IOCSRF_FLATMODE)
-		c->options |= LOONGARCH_CPU_FLATMODE;
-	if (config & IOCSRF_EIODECODE)
-		c->options |= LOONGARCH_CPU_EIODECODE;
-	if (config & IOCSRF_AVEC)
-		c->options |= LOONGARCH_CPU_AVECINT;
-	if (config & IOCSRF_VM)
-		c->options |= LOONGARCH_CPU_HYPERVISOR;
-
 	config = csr_read32(LOONGARCH_CSR_ASID);
 	config = (config & CSR_ASID_BIT) >> CSR_ASID_BIT_SHIFT;
 	asid_mask = GENMASK(config - 1, 0);
@@ -231,16 +215,8 @@ static char cpu_full_name[MAX_NAME_LEN] = "        -        ";
 
 static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int cpu)
 {
-	uint64_t *vendor = (void *)(&cpu_full_name[VENDOR_OFFSET]);
-	uint64_t *cpuname = (void *)(&cpu_full_name[CPUNAME_OFFSET]);
 	const char *core_name = "Unknown";
 
-	if (!__cpu_full_name[cpu])
-		__cpu_full_name[cpu] = cpu_full_name;
-
-	*vendor = iocsr_read64(LOONGARCH_IOCSR_VENDOR);
-	*cpuname = iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
-
 	switch (c->processor_id & PRID_SERIES_MASK) {
 	case PRID_SERIES_LA132:
 		c->cputype = CPU_LOONGSON32;
@@ -283,6 +259,36 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
 	pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu], core_name);
 }
 
+static inline void iocsr_probe_loongson(struct cpuinfo_loongarch *c, unsigned int cpu)
+{
+	uint64_t *vendor = (void *)(&cpu_full_name[VENDOR_OFFSET]);
+	uint64_t *cpuname = (void *)(&cpu_full_name[CPUNAME_OFFSET]);
+	unsigned int config;
+
+	*vendor = iocsr_read64(LOONGARCH_IOCSR_VENDOR);
+	*cpuname = iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
+
+	if (!__cpu_full_name[cpu])
+		__cpu_full_name[cpu] = cpu_full_name;
+
+	config = iocsr_read32(LOONGARCH_IOCSR_FEATURES);
+	if (config & IOCSRF_CSRIPI)
+		c->options |= LOONGARCH_CPU_CSRIPI;
+	if (config & IOCSRF_EXTIOI)
+		c->options |= LOONGARCH_CPU_EXTIOI;
+	if (config & IOCSRF_FREQSCALE)
+		c->options |= LOONGARCH_CPU_SCALEFREQ;
+	if (config & IOCSRF_FLATMODE)
+		c->options |= LOONGARCH_CPU_FLATMODE;
+	if (config & IOCSRF_EIODECODE)
+		c->options |= LOONGARCH_CPU_EIODECODE;
+	if (config & IOCSRF_AVEC)
+		c->options |= LOONGARCH_CPU_AVECINT;
+	if (config & IOCSRF_VM)
+		c->options |= LOONGARCH_CPU_HYPERVISOR;
+
+}
+
 #ifdef CONFIG_64BIT
 /* For use by uaccess.h */
 u64 __ua_limit;
@@ -331,6 +337,15 @@ void cpu_probe(void)
 		break;
 	}
 
+	if (c->options & LOONGARCH_CPU_IOCSR) {
+		switch (c->cputype) {
+		case CPU_LOONGSON32:
+		case CPU_LOONGSON64:
+			iocsr_probe_loongson(c, cpu);
+			break;
+		}
+	}
+
 	BUG_ON(!__cpu_family[cpu]);
 	BUG_ON(c->cputype == CPU_UNKNOWN);
 

-- 
2.46.0


