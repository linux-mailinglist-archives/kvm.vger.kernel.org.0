Return-Path: <kvm+bounces-4617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EEE0815973
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88A38B226C6
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598A02D02B;
	Sat, 16 Dec 2023 13:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5I0L83g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9F524B37
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-35f71436397so11364925ab.3
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734239; x=1703339039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRVMX02osNfnVcXLC3xpkTbIfK+Z4yWztBHxsIia32o=;
        b=m5I0L83gKIPQ90MHx0CGAxZ9ZoxOLclzbAoK7clZ7xT8WNr9+PMhTTOm9Us2cMCTxW
         jmtqhBxrnV6F2jwTTOFLMurLlO6ZFSCT15qyiFy2xerx45+JTkKHgrOfUCWUtZzus6Xe
         9Ii0Kh5wpcX8mD5HbVELjvX2nHd+K6oJ42As2M1BsmWg+uadpZ8COR/VRywWaGYemWiI
         /69vCaVsjJHdO5IwvwB3qj8E8bqEivivNbtkKWVLrNKVfIKoJnzU1oIDymJ0G1TRGgOh
         VOtDcMw06MWE35J0wRy5mlLXaAKoRwfv1XSz+LswAqc/0RX8LGjofQ2re35fx6Yg4y5S
         EJkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734239; x=1703339039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PRVMX02osNfnVcXLC3xpkTbIfK+Z4yWztBHxsIia32o=;
        b=UkGgriFGqShd6Z1JHQleHA2mU4ob8R/stqrpARpUQsyb1DIVy0UAwcyQ7NyRKd5VFS
         15nQeiTcNePWOZbDUhkO/io2+5t6Rbfuvc0VbjhZ3uUextWawpnh5ZVSrm7PEa4/wkcr
         M570UbxKPSF99XcNguBwW/UGhA8FDgeIchGsZFWzuPVKzpU0pA2FC8hNlbpMiU6QzR+0
         OMnRSdVKcSF9yBYITrKBpGLEm/6SPjXPBkGNdanfgbA7ed9V70stCu5QffptL2mS6mc1
         1ReBwWbh1klJYabIslwppWDVbnIDuVrETvehD8Fy9mzDAUN0Za633obPHY6HPhk22eIz
         fpYw==
X-Gm-Message-State: AOJu0YxjwSZfauM9SrDYNQRB2yUikOM6jCy52uzGW7lbqDd2xWbe7Uql
	3tmKkfRKYYGs+gSw6G8bZuouVgrH/B0=
X-Google-Smtp-Source: AGHT+IH1fx2Hb5RHMeFLLDpdQE1XTJBwJdCP3XGMTXuAdBqA1zqG2tFOKqK6kZNNa55t1kUkfmsD6g==
X-Received: by 2002:a05:6e02:168d:b0:35f:8e55:29cd with SMTP id f13-20020a056e02168d00b0035f8e5529cdmr4218254ila.83.1702734239118;
        Sat, 16 Dec 2023 05:43:59 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:58 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 10/29] powerpc/sprs: Specify SPRs with data rather than code
Date: Sat, 16 Dec 2023 23:42:37 +1000
Message-ID: <20231216134257.1743345-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231216134257.1743345-1-npiggin@gmail.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A significant rework that builds an array of 'struct spr', where each
element describes an SPR. This makes various metadata about the SPR
like name and access type easier to carry and use.

Hypervisor privileged registers are described despite not being used
at the moment for completeness, but also the code might one day be
reused for a hypervisor-privileged test.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 643 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 450 insertions(+), 193 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 57e487ce..cd8b472d 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -28,231 +28,465 @@
 #include <asm/processor.h>
 #include <asm/barrier.h>
 
-uint64_t before[1024], after[1024];
-
-/* Common SPRs for all PowerPC CPUs */
-static void set_sprs_common(uint64_t val)
+/* "Indirect" mfspr/mtspr which accept a non-constant spr number */
+static uint64_t __mfspr(unsigned spr)
 {
-	mtspr(9, val);		/* CTR */
-	// mtspr(273, val);	/* SPRG1 */  /* Used by our exception handler */
-	mtspr(274, val);	/* SPRG2 */
-	mtspr(275, val);	/* SPRG3 */
+	uint64_t tmp;
+	uint64_t ret;
+
+	asm volatile(
+"	bcl	20, 31, 1f		\n"
+"1:	mflr	%0			\n"
+"	addi	%0, %0, (2f-1b)		\n"
+"	add	%0, %0, %2		\n"
+"	mtctr	%0			\n"
+"	bctr				\n"
+"2:					\n"
+".LSPR=0				\n"
+".rept 1024				\n"
+"	mfspr	%1, .LSPR		\n"
+"	b	3f			\n"
+"	.LSPR=.LSPR+1			\n"
+".endr					\n"
+"3:					\n"
+	: "=&r"(tmp),
+	  "=r"(ret)
+	: "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
+	: "lr", "ctr");
+
+	return ret;
 }
 
-/* SPRs from PowerPC Operating Environment Architecture, Book III, Vers. 2.01 */
-static void set_sprs_book3s_201(uint64_t val)
+static void __mtspr(unsigned spr, uint64_t val)
 {
-	mtspr(18, val);		/* DSISR */
-	mtspr(19, val);		/* DAR */
-	mtspr(152, val);	/* CTRL */
-	mtspr(256, val);	/* VRSAVE */
-	mtspr(786, val);	/* MMCRA */
-	mtspr(795, val);	/* MMCR0 */
-	mtspr(798, val);	/* MMCR1 */
+	uint64_t tmp;
+
+	asm volatile(
+"	bcl	20, 31, 1f		\n"
+"1:	mflr	%0			\n"
+"	addi	%0, %0, (2f-1b)		\n"
+"	add	%0, %0, %2		\n"
+"	mtctr	%0			\n"
+"	bctr				\n"
+"2:					\n"
+".LSPR=0				\n"
+".rept 1024				\n"
+"	mtspr	.LSPR, %1		\n"
+"	b	3f			\n"
+"	.LSPR=.LSPR+1			\n"
+".endr					\n"
+"3:					\n"
+	: "=&r"(tmp)
+	: "r"(val),
+	  "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
+	: "lr", "ctr", "xer");
 }
 
+static uint64_t before[1024], after[1024];
+
+#define SPR_PR_READ	0x0001
+#define SPR_PR_WRITE	0x0002
+#define SPR_OS_READ	0x0010
+#define SPR_OS_WRITE	0x0020
+#define SPR_HV_READ	0x0100
+#define SPR_HV_WRITE	0x0200
+
+#define RW		0x333
+#define RO		0x111
+#define WO		0x222
+#define OS_RW		0x330
+#define OS_RO		0x110
+#define OS_WO		0x220
+#define HV_RW		0x300
+#define HV_RO		0x100
+#define HV_WO		0x200
+
+#define SPR_ASYNC	0x1000	/* May be updated asynchronously */
+#define SPR_INT		0x2000	/* May be updated by synchronous interrupt */
+#define SPR_HARNESS	0x4000	/* Test harness uses the register */
+
+struct spr {
+	const char	*name;
+	uint8_t		width;
+	uint16_t	access;
+	uint16_t	type;
+};
+
+/* SPRs common denominator back to PowerPC Operating Environment Architecture */
+static const struct spr sprs_common[1024] = {
+  [1] = {"XER",		64,	RW,		SPR_HARNESS, }, /* Compiler */
+  [8] = {"LR", 		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr */
+  [9] = {"CTR",		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr */
+ [18] = {"DSISR",	32,	OS_RW,		SPR_INT, },
+ [19] = {"DAR",		64,	OS_RW,		SPR_INT, },
+ [26] = {"SRR0",	64,	OS_RW,		SPR_INT, },
+ [27] = {"SRR1",	64,	OS_RW,		SPR_INT, },
+[268] = {"TB",		64,	RO	,	SPR_ASYNC, },
+[269] = {"TBU",		32,	RO,		SPR_ASYNC, },
+[272] = {"SPRG0",	64,	OS_RW,		SPR_HARNESS, }, /* Int stack */
+[273] = {"SPRG1",	64,	OS_RW,		SPR_HARNESS, }, /* Scratch */
+[274] = {"SPRG2",	64,	OS_RW, },
+[275] = {"SPRG3",	64,	OS_RW, },
+[287] = {"PVR",		32,	OS_RO, },
+};
+
+/* SPRs from PowerPC Operating Environment Architecture, Book III, Vers. 2.01 */
+static const struct spr sprs_201[1024] = {
+ [22] = {"DEC",		32,	OS_RW,		SPR_ASYNC, },
+ [25] = {"SDR1",	64,	HV_RW | OS_RO, },
+ [29] = {"ACCR",	64,	OS_RW, },
+[136] = {"CTRL",	32,	RO, },
+[152] = {"CTRL",	32,	OS_WO, },
+[259] = {"SPRG3",	64,	RO, },
+/* ASR, EAR omitted */
+[268] = {"TB",		64,	RO, },
+[269] = {"TBU",		32,	RO, },
+[284] = {"TBL",		32,	HV_WO, },
+[285] = {"TBU",		32,	HV_WO, },
+[310] = {"HDEC",	32,	HV_RW,		SPR_ASYNC, },
+[1013]= {"DABR",	64,	HV_RW | OS_RO, },
+[1023]= {"PIR",		32,	OS_RO, },
+};
+
+static const struct spr sprs_970_pmu[1024] = {
+/* POWER4+ PMU, should find PPC970 and confirm */
+[770] = {"MMCRA",	64,	RO, },
+[771] = {"PMC1",	32,	RO, },
+[772] = {"PMC2",	32,	RO, },
+[773] = {"PMC3",	32,	RO, },
+[774] = {"PMC4",	32,	RO, },
+[775] = {"PMC5",	32,	RO, },
+[776] = {"PMC6",	32,	RO, },
+[777] = {"PMC7",	32,	RO, },
+[778] = {"PMC8",	32,	RO, },
+[779] = {"MMCR0",	64,	RO, },
+[780] = {"SIAR",	64,	RO, },
+[781] = {"SDAR",	64,	RO, },
+[782] = {"MMCR1",	64,	RO, },
+[786] = {"MMCRA",	64,	OS_RW, },
+[787] = {"PMC1",	32,	OS_RW, },
+[788] = {"PMC2",	32,	OS_RW, },
+[789] = {"PMC3",	32,	OS_RW, },
+[790] = {"PMC4",	32,	OS_RW, },
+[791] = {"PMC5",	32,	OS_RW, },
+[792] = {"PMC6",	32,	OS_RW, },
+[793] = {"PMC7",	32,	OS_RW, },
+[794] = {"PMC8",	32,	OS_RW, },
+[795] = {"MMCR0",	64,	OS_RW, },
+[796] = {"SIAR",	64,	OS_RW, },
+[797] = {"SDAR",	64,	OS_RW, },
+[798] = {"MMCR1",	64,	OS_RW, },
+};
+
+/* These are common SPRs from 2.07S onward (POWER CPUs that support KVM HV) */
+static const struct spr sprs_power_common[1024] = {
+  [3] = {"DSCR",	64,	RW, },
+ [13] = {"AMR",		64,	RW, },
+ [17] = {"DSCR",	64,	OS_RW, },
+ [28] = {"CFAR",	64,	OS_RW,		SPR_ASYNC, }, /* Effectively async */
+ [29] = {"AMR",		64,	OS_RW, },
+ [61] = {"IAMR",	64,	OS_RW, },
+[136] = {"CTRL",	32,	RO, },
+[152] = {"CTRL",	32,	OS_WO, },
+[153] = {"FSCR",	64,	OS_RW, },
+[157] = {"UAMOR",	64,	OS_RW, },
+[159] = {"PSPB",	32,	OS_RW, },
+[176] = {"DPDES",	64,	HV_RW | OS_RO, },
+[180] = {"DAWR0",	64,	HV_RW, },
+[186] = {"RPR",		64,	HV_RW, },
+[187] = {"CIABR",	64,	HV_RW, },
+[188] = {"DAWRX0",	32,	HV_RW, },
+[190] = {"HFSCR",	64,	HV_RW, },
+[256] = {"VRSAVE",	32,	RW, },
+[259] = {"SPRG3",	64,	RO, },
+[284] = {"TBL",		32,	HV_WO, },
+[285] = {"TBU",		32,	HV_WO, },
+[286] = {"TBU40",	64,	HV_WO, },
+[304] = {"HSPRG0",	64,	HV_RW, },
+[305] = {"HSPRG1",	64,	HV_RW, },
+[306] = {"HDSISR",	32,	HV_RW,		SPR_INT, },
+[307] = {"HDAR",	64,	HV_RW,		SPR_INT, },
+[308] = {"SPURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
+[309] = {"PURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
+[313] = {"HRMOR",	64,	HV_RW, },
+[314] = {"HSRR0",	64,	HV_RW,		SPR_INT, },
+[315] = {"HSRR1",	64,	HV_RW,		SPR_INT, },
+[318] = {"LPCR",	64,	HV_RW, },
+[319] = {"LPIDR",	32,	HV_RW, },
+[336] = {"HMER",	64,	HV_RW, },
+[337] = {"HMEER",	64,	HV_RW, },
+[338] = {"PCR",		64,	HV_RW, },
+[349] = {"AMOR",	64,	HV_RW, },
+[446] = {"TIR",		64,	OS_RO, },
+[800] = {"BESCRS",	64,	RW, },
+[801] = {"BESCRSU",	32,	RW, },
+[802] = {"BESCRR",	64,	RW, },
+[803] = {"BESCRRU",	32,	RW, },
+[804] = {"EBBHR",	64,	RW, },
+[805] = {"EBBRR",	64,	RW, },
+[806] = {"BESCR",	64,	RW, },
+[815] = {"TAR",		64,	RW, },
+[848] = {"IC",		64,	HV_RW | OS_RO,	SPR_ASYNC, },
+[849] = {"VTB",		64,	HV_RW | OS_RO,	SPR_ASYNC, },
+[896] = {"PPR",		64,	RW, },
+[898] = {"PPR32",	32,	RW, },
+[1023]= {"PIR",		32,	OS_RO, },
+};
+
+static const struct spr sprs_tm[1024] = {
+#if 0
+	/* XXX: leave these out until enabling TM facility (and more testing) */
+[128] = {"TFHAR",	64,	RW, },
+[129] = {"TFIAR",	64,	RW, },
+[130] = {"TEXASR",	64,	RW, },
+[131] = {"TEXASRU",	32,	RW, },
+#endif
+};
+
 /* SPRs from PowerISA 2.07 Book III-S */
-static void set_sprs_book3s_207(uint64_t val)
-{
-	mtspr(3, val);		/* DSCR */
-	mtspr(13, val);		/* AMR */
-	mtspr(17, val);		/* DSCR */
-	mtspr(18, val);		/* DSISR */
-	mtspr(19, val);		/* DAR */
-	mtspr(29, val);		/* AMR */
-	mtspr(61, val);		/* IAMR */
-	// mtspr(152, val);	/* CTRL */  /* TODO: Needs a fix in KVM */
-	mtspr(153, val);	/* FSCR */
-	mtspr(157, val);	/* UAMOR */
-	mtspr(159, val);	/* PSPB */
-	mtspr(256, val);	/* VRSAVE */
-	// mtspr(272, val);	/* SPRG0 */ /* Used by our exception handler */
-	mtspr(769, val);	/* MMCR2 */
-	mtspr(770, val);	/* MMCRA */
-	mtspr(771, val);	/* PMC1 */
-	mtspr(772, val);	/* PMC2 */
-	mtspr(773, val);	/* PMC3 */
-	mtspr(774, val);	/* PMC4 */
-	mtspr(775, val);	/* PMC5 */
-	mtspr(776, val);	/* PMC6 */
-	mtspr(779, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);	/* MMCR0 */
-	mtspr(784, val);	/* SIER */
-	mtspr(785, val);	/* MMCR2 */
-	mtspr(786, val);	/* MMCRA */
-	mtspr(787, val);	/* PMC1 */
-	mtspr(788, val);	/* PMC2 */
-	mtspr(789, val);	/* PMC3 */
-	mtspr(790, val);	/* PMC4 */
-	mtspr(791, val);	/* PMC5 */
-	mtspr(792, val);	/* PMC6 */
-	mtspr(795, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);	/* MMCR0 */
-	mtspr(796, val);	/* SIAR */
-	mtspr(797, val);	/* SDAR */
-	mtspr(798, val);	/* MMCR1 */
-	mtspr(800, val);	/* BESCRS */
-	mtspr(801, val);	/* BESCCRSU */
-	mtspr(802, val);	/* BESCRR */
-	mtspr(803, val);	/* BESCRRU */
-	mtspr(804, val);	/* EBBHR */
-	mtspr(805, val);	/* EBBRR */
-	mtspr(806, val);	/* BESCR */
-	mtspr(815, val);	/* TAR */
-}
+static const struct spr sprs_207[1024] = {
+ [22] = {"DEC",		32,	OS_RW,		SPR_ASYNC, },
+ [25] = {"SDR1",	64,	HV_RW, },
+[177] = {"DHDES",	64,	HV_RW, },
+[283] = {"CIR",		32,	OS_RO, },
+[310] = {"HDEC",	32,	HV_RW,		SPR_ASYNC, },
+[312] = {"RMOR",	64,	HV_RW, },
+[339] = {"HEIR",	32,	HV_RW,		SPR_INT, },
+};
 
 /* SPRs from PowerISA 3.00 Book III */
-static void set_sprs_book3s_300(uint64_t val)
-{
-	set_sprs_book3s_207(val);
-	mtspr(48, val);		/* PIDR */
-	mtspr(144, val);	/* TIDR */
-	mtspr(823, val);	/* PSSCR */
-}
+static const struct spr sprs_300[1024] = {
+ [22] = {"DEC",		64,	OS_RW,		SPR_ASYNC, },
+ [48] = {"PIDR",	32,	OS_RW, },
+[144] = {"TIDR",	64,	OS_RW, },
+[283] = {"CIR",		32,	OS_RO, },
+[310] = {"HDEC",	64,	HV_RW,		SPR_ASYNC, },
+[339] = {"HEIR",	32,	HV_RW,		SPR_INT, },
+[464] = {"PTCR",	64,	HV_RW, },
+[816] = {"ASDR",	64,	HV_RW,		SPR_INT, },
+[823] = {"PSSCR",	64,	OS_RW, },
+[855] = {"PSSCR",	64,	HV_RW, },
+};
 
-/* SPRs from Power ISA Version 3.1B */
-static void set_sprs_book3s_31(uint64_t val)
-{
-	set_sprs_book3s_207(val);
-	mtspr(48, val);		/* PIDR */
-	/* 3.1 removes TIDR */
-	mtspr(823, val);	/* PSSCR */
-}
+/* SPRs from PowerISA 3.1B Book III */
+static const struct spr sprs_31[1024] = {
+ [22] = {"DEC",		64,	OS_RW,		SPR_ASYNC, },
+ [48] = {"PIDR",	32,	OS_RW, },
+[181] = {"DAWR1",	64,	HV_RW, },
+[189] = {"DAWRX1",	32,	HV_RW, },
+[310] = {"HDEC",	64,	HV_RW,		SPR_ASYNC, },
+[339] = {"HEIR",	64,	HV_RW,		SPR_INT, },
+[455] = {"HDEXCR",	32,	RO, },
+[464] = {"PTCR",	64,	HV_RW, },
+[468] = {"HASHKEYR",	64,	OS_RW, },
+[469] = {"HASHPKEYR",	64,	HV_RW, },
+[471] = {"HDEXCR",	64,	HV_RW, },
+[812] = {"DEXCR",	32,	RO, },
+[816] = {"ASDR",	64,	HV_RW,		SPR_INT, },
+[823] = {"PSSCR",	64,	OS_RW, },
+[828] = {"DEXCR",	64,	OS_RW, },
+[855] = {"PSSCR",	64,	HV_RW, },
+};
 
-static void set_sprs(uint64_t val)
+/* SPRs POWER9, POWER10 User Manual */
+static const struct spr sprs_power9_10[1024] = {
+[276] = {"SPRC",	64,	HV_RW, },
+[277] = {"SPRD",	64,	HV_RW, },
+[317] = {"TFMR",	64,	HV_RW, },
+[799] = {"IMC",		64,	HV_RW, },
+[850] = {"LDBAR",	64,	HV_RO, },
+[851] = {"MMCRC",	32,	HV_RW, },
+[853] = {"PMSR",	32,	HV_RO, },
+[861] = {"L2QOSR",	64,	HV_WO, },
+[881] = {"TRIG1",	64,	OS_WO, },
+[882] = {"TRIG2",	64,	OS_WO, },
+[884] = {"PMCR",	64,	HV_RW, },
+[885] = {"RWMR",	64,	HV_RW, },
+[895] = {"WORT",	64,	OS_RW, }, /* UM says 18-bits! */
+[921] = {"TSCR",	32,	HV_RW, },
+[922] = {"TTR",		64,	HV_RW, },
+[1006]= {"TRACE",	64,	WO, },
+[1008]= {"HID",		64,	HV_RW, },
+};
+
+/* This covers POWER8 and POWER9 PMUs */
+static const struct spr sprs_power_common_pmu[1024] = {
+[768] = {"SIER",	64,	RO, },
+[769] = {"MMCR2",	64,	RW, },
+[770] = {"MMCRA",	64,	RW, },
+[771] = {"PMC1",	32,	RW, },
+[772] = {"PMC2",	32,	RW, },
+[773] = {"PMC3",	32,	RW, },
+[774] = {"PMC4",	32,	RW, },
+[775] = {"PMC5",	32,	RW, },
+[776] = {"PMC6",	32,	RW, },
+[779] = {"MMCR0",	64,	RW, },
+[780] = {"SIAR",	64,	RO, },
+[781] = {"SDAR",	64,	RO, },
+[782] = {"MMCR1",	64,	RO, },
+[784] = {"SIER",	64,	OS_RW, },
+[785] = {"MMCR2",	64,	OS_RW, },
+[786] = {"MMCRA",	64,	OS_RW, },
+[787] = {"PMC1",	32,	OS_RW, },
+[788] = {"PMC2",	32,	OS_RW, },
+[789] = {"PMC3",	32,	OS_RW, },
+[790] = {"PMC4",	32,	OS_RW, },
+[791] = {"PMC5",	32,	OS_RW, },
+[792] = {"PMC6",	32,	OS_RW, },
+[795] = {"MMCR0",	64,	OS_RW, },
+[796] = {"SIAR",	64,	OS_RW, },
+[797] = {"SDAR",	64,	OS_RW, },
+[798] = {"MMCR1",	64,	OS_RW, },
+};
+
+static const struct spr sprs_power10_pmu[1024] = {
+[736] = {"SEIR2",	64,	RO, },
+[737] = {"SEIR3",	64,	RO, },
+[738] = {"MMCR3",	64,	RO, },
+[752] = {"SEIR2",	64,	OS_RW, },
+[753] = {"SEIR3",	64,	OS_RW, },
+[754] = {"MMCR3",	64,	OS_RW, },
+};
+
+static struct spr sprs[1024];
+
+static void setup_sprs(void)
 {
 	uint32_t pvr = mfspr(287);	/* Processor Version Register */
+	int i;
 
-	set_sprs_common(val);
+	for (i = 0; i < 1024; i++) {
+		if (sprs_common[i].name) {
+			memcpy(&sprs[i], &sprs_common[i], sizeof(struct spr));
+		}
+	}
 
 	switch (pvr >> 16) {
 	case 0x39:			/* PPC970 */
 	case 0x3C:			/* PPC970FX */
 	case 0x44:			/* PPC970MP */
-		set_sprs_book3s_201(val);
+		for (i = 0; i < 1024; i++) {
+			if (sprs_power_common[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common[i], sizeof(struct spr));
+			}
+			if (sprs_201[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_201[i], sizeof(struct spr));
+			}
+			if (sprs_970_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common_pmu[i], sizeof(struct spr));
+			}
+		}
 		break;
+
 	case 0x4b:			/* POWER8E */
 	case 0x4c:			/* POWER8NVL */
 	case 0x4d:			/* POWER8 */
-		set_sprs_book3s_207(val);
+		for (i = 0; i < 1024; i++) {
+			if (sprs_power_common[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common[i], sizeof(struct spr));
+			}
+			if (sprs_207[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_207[i], sizeof(struct spr));
+			}
+			if (sprs_tm[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_tm[i], sizeof(struct spr));
+			}
+			if (sprs_power_common_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common_pmu[i], sizeof(struct spr));
+			}
+		}
 		break;
+
 	case 0x4e:			/* POWER9 */
-		set_sprs_book3s_300(val);
+		for (i = 0; i < 1024; i++) {
+			if (sprs_power_common[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common[i], sizeof(struct spr));
+			}
+			if (sprs_300[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_300[i], sizeof(struct spr));
+			}
+			if (sprs_tm[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_tm[i], sizeof(struct spr));
+			}
+			if (sprs_power9_10[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power9_10[i], sizeof(struct spr));
+			}
+			if (sprs_power_common_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common_pmu[i], sizeof(struct spr));
+			}
+		}
 		break;
-	case 0x80:                      /* POWER10 */
-		set_sprs_book3s_31(val);
+
+	case 0x80:			/* POWER10 */
+		for (i = 0; i < 1024; i++) {
+			if (sprs_power_common[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common[i], sizeof(struct spr));
+			}
+			if (sprs_31[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_31[i], sizeof(struct spr));
+			}
+			if (sprs_power9_10[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power9_10[i], sizeof(struct spr));
+			}
+			if (sprs_power_common_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power_common_pmu[i], sizeof(struct spr));
+			}
+			if (sprs_power10_pmu[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power10_pmu[i], sizeof(struct spr));
+			}
+		}
 		break;
+
 	default:
-		puts("Warning: Unknown processor version!\n");
+		memcpy(sprs, sprs_common, sizeof(sprs));
+		puts("Warning: Unknown processor version, falling back to common SPRs!\n");
+		break;
 	}
 }
 
-static void get_sprs_common(uint64_t *v)
-{
-	v[9] = mfspr(9);	/* CTR */
-	// v[273] = mfspr(273);	/* SPRG1 */ /* Used by our exception handler */
-	v[274] = mfspr(274);	/* SPRG2 */
-	v[275] = mfspr(275);	/* SPRG3 */
-}
-
-static void get_sprs_book3s_201(uint64_t *v)
-{
-	v[18] = mfspr(18);	/* DSISR */
-	v[19] = mfspr(19);	/* DAR */
-	v[136] = mfspr(136);	/* CTRL */
-	v[256] = mfspr(256);	/* VRSAVE */
-	v[786] = mfspr(786);	/* MMCRA */
-	v[795] = mfspr(795);	/* MMCR0 */
-	v[798] = mfspr(798);	/* MMCR1 */
-}
-
-static void get_sprs_book3s_207(uint64_t *v)
-{
-	v[3] = mfspr(3);	/* DSCR */
-	v[13] = mfspr(13);	/* AMR */
-	v[17] = mfspr(17);	/* DSCR */
-	v[18] = mfspr(18);	/* DSISR */
-	v[19] = mfspr(19);	/* DAR */
-	v[29] = mfspr(29);	/* AMR */
-	v[61] = mfspr(61);	/* IAMR */
-	// v[136] = mfspr(136);	/* CTRL */  /* TODO: Needs a fix in KVM */
-	v[153] = mfspr(153);	/* FSCR */
-	v[157] = mfspr(157);	/* UAMOR */
-	v[159] = mfspr(159);	/* PSPB */
-	v[256] = mfspr(256);	/* VRSAVE */
-	v[259] = mfspr(259);	/* SPRG3 (read only) */
-	// v[272] = mfspr(272);	/* SPRG0 */  /* Used by our exception handler */
-	v[769] = mfspr(769);	/* MMCR2 */
-	v[770] = mfspr(770);	/* MMCRA */
-	v[771] = mfspr(771);	/* PMC1 */
-	v[772] = mfspr(772);	/* PMC2 */
-	v[773] = mfspr(773);	/* PMC3 */
-	v[774] = mfspr(774);	/* PMC4 */
-	v[775] = mfspr(775);	/* PMC5 */
-	v[776] = mfspr(776);	/* PMC6 */
-	v[779] = mfspr(779);	/* MMCR0 */
-	v[780] = mfspr(780);	/* SIAR (read only) */
-	v[781] = mfspr(781);	/* SDAR (read only) */
-	v[782] = mfspr(782);	/* MMCR1 (read only) */
-	v[784] = mfspr(784);	/* SIER */
-	v[785] = mfspr(785);	/* MMCR2 */
-	v[786] = mfspr(786);	/* MMCRA */
-	v[787] = mfspr(787);	/* PMC1 */
-	v[788] = mfspr(788);	/* PMC2 */
-	v[789] = mfspr(789);	/* PMC3 */
-	v[790] = mfspr(790);	/* PMC4 */
-	v[791] = mfspr(791);	/* PMC5 */
-	v[792] = mfspr(792);	/* PMC6 */
-	v[795] = mfspr(795);	/* MMCR0 */
-	v[796] = mfspr(796);	/* SIAR */
-	v[797] = mfspr(797);	/* SDAR */
-	v[798] = mfspr(798);	/* MMCR1 */
-	v[800] = mfspr(800);	/* BESCRS */
-	v[801] = mfspr(801);	/* BESCCRSU */
-	v[802] = mfspr(802);	/* BESCRR */
-	v[803] = mfspr(803);	/* BESCRRU */
-	v[804] = mfspr(804);	/* EBBHR */
-	v[805] = mfspr(805);	/* EBBRR */
-	v[806] = mfspr(806);	/* BESCR */
-	v[815] = mfspr(815);	/* TAR */
-}
-
-static void get_sprs_book3s_300(uint64_t *v)
+static void get_sprs(uint64_t *v)
 {
-	get_sprs_book3s_207(v);
-	v[48] = mfspr(48);	/* PIDR */
-	v[144] = mfspr(144);	/* TIDR */
-	v[823] = mfspr(823);	/* PSSCR */
-}
+	int i;
 
-static void get_sprs_book3s_31(uint64_t *v)
-{
-	get_sprs_book3s_207(v);
-	v[48] = mfspr(48);	/* PIDR */
-	v[823] = mfspr(823);	/* PSSCR */
+	for (i = 0; i < 1024; i++) {
+		if (!(sprs[i].access & SPR_OS_READ))
+			continue;
+		v[i] = __mfspr(i);
+	}
 }
 
-static void get_sprs(uint64_t *v)
+static void set_sprs(uint64_t val)
 {
-	uint32_t pvr = mfspr(287);	/* Processor Version Register */
-
-	get_sprs_common(v);
+	int i;
 
-	switch (pvr >> 16) {
-	case 0x39:			/* PPC970 */
-	case 0x3C:			/* PPC970FX */
-	case 0x44:			/* PPC970MP */
-		get_sprs_book3s_201(v);
-		break;
-	case 0x4b:			/* POWER8E */
-	case 0x4c:			/* POWER8NVL */
-	case 0x4d:			/* POWER8 */
-		get_sprs_book3s_207(v);
-		break;
-	case 0x4e:			/* POWER9 */
-		get_sprs_book3s_300(v);
-		break;
-	case 0x80:                      /* POWER10 */
-		get_sprs_book3s_31(v);
-		break;
+	for (i = 0; i < 1024; i++) {
+		if (!(sprs[i].access & SPR_OS_WRITE))
+			continue;
+		if (sprs[i].type & SPR_HARNESS)
+			continue;
+		if (!strcmp(sprs[i].name, "MMCR0")) {
+			/* XXX: could use a comment or better abstraction! */
+			__mtspr(i, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);
+		} else {
+			__mtspr(i, val);
+		}
 	}
 }
 
@@ -289,7 +523,9 @@ int main(int argc, char **argv)
 		}
 	}
 
-	printf("Settings SPRs to %#lx...\n", pat);
+	setup_sprs();
+
+	printf("Setting SPRs to 0x%lx...\n", pat);
 	set_sprs(pat);
 
 	memset(before, 0, sizeof(before));
@@ -301,16 +537,37 @@ int main(int argc, char **argv)
 		migrate_once();
 	} else {
 		msleep(2000);
+
+		/* Taking a dec updates SRR0, SRR1, SPRG1, so don't fail. */
+		sprs[26].type |= SPR_ASYNC;
+		sprs[27].type |= SPR_ASYNC;
+		sprs[273].type |= SPR_ASYNC;
 	}
 
 	get_sprs(after);
 
 	puts("Checking SPRs...\n");
 	for (i = 0; i < 1024; i++) {
-		if (before[i] != 0 || after[i] != 0)
-			report(before[i] == after[i],
-			       "SPR %d:\t%#018lx <==> %#018lx", i, before[i],
-			       after[i]);
+		bool pass = true;
+
+		if (!(sprs[i].access & SPR_OS_READ))
+			continue;
+
+		if (sprs[i].width == 32) {
+			if (before[i] >> 32)
+				pass = false;
+		}
+		if (!(sprs[i].type & SPR_ASYNC) && (before[i] != after[i]))
+			pass = false;
+
+		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32))
+			report(pass, "%-10s(%4d):\t        0x%08lx <==>         0x%08lx",
+				sprs[i].name, i,
+				before[i], after[i]);
+		else
+			report(pass, "%-10s(%4d):\t0x%016lx <==> 0x%016lx",
+				sprs[i].name, i,
+				before[i], after[i]);
 	}
 
 	return report_summary();
-- 
2.42.0


