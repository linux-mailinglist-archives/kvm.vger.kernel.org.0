Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53BF6BE96C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 13:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjCQMhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 08:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjCQMhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 08:37:50 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0034C6C6AB
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:06 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso5045195pjb.3
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679056615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5GaYgdhktF8TYNBWSQyuRZrMerFrhgeB6K29Y/bo4c=;
        b=NfGn0gSVQIIK7W/MvVQvB0ERfmSTuqBskqiWyfFiuGnSQfeK/xvnUOCul1CBSDKRyl
         klzj3bbuufpgfpm6Hs9G7jk5lOjIO/fOuvxns4rnITqIbCYhgXXs2p9M5dYzcZqOF+9t
         XKStNdpx14/jJfqEstq+luT1nFHPTdJwcQlVRrpGIWyO15Khn2LHz0zepyQOtieZ2n0J
         CN74IvNFPo3LksPAgcUo0znFuXeHLDOGxijw8zwlh99VJCkdafDCDkWnhAeMbUKD5HCL
         Du7Fl1FiF08v304U3Pp9PqhDKXK/pnWVw4fr6srsT20IJ1ctQfcIPLrsXQF6bJjywIA1
         /hKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679056615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5GaYgdhktF8TYNBWSQyuRZrMerFrhgeB6K29Y/bo4c=;
        b=rokC2HjHAWMn0nDNHDshlLPP+7Thk0u+QLaJc1iaC51dbDgRVvGsuEmhzdBe0BJzlV
         5IKfdWG0gtoQD0TbG6Tal7mKXjzyGRw7hNSbI6d5Vn++AVqISYRM0KMY9fceccoE8eUV
         3Qq0rHBq6r83z+fxuLj6XL/0hlNi8CmbLBy1kS5N9F1JBVmmneBo6nZ1JJh1MbJZOXF+
         J6Gi3Cq0+wt9E+K9sUIAKJcyWcS3lhThygAEmgv6V5k7iYDtwyrzQvAX4amsgVeTW1xT
         ZYiW6CbOSWri0fIYXmKAcsCnpMJvN5LHTA7GxVGmVf/6Goisqq6znbZE6z/ev0StRJCe
         Ua5w==
X-Gm-Message-State: AO0yUKXoJAlRlXYypICm7ZMazPFsK21acnaAwaiOoVmmC5SvQrwoVGAa
        EDHI8k1YaLWo5SwE+93WX0au07Ayyvg=
X-Google-Smtp-Source: AK7set/7hpdUMBIg9Dlq45A7buY5yeTNA4aE2OXrHG/ErUrAhwf4QzdXJ0aU4Xz+wBIkJ5jrrjD3Bw==
X-Received: by 2002:a17:90b:1d06:b0:230:af67:b847 with SMTP id on6-20020a17090b1d0600b00230af67b847mr8309543pjb.31.1679056614724;
        Fri, 17 Mar 2023 05:36:54 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902b28400b001a19d4592e1sm1430990plr.282.2023.03.17.05.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 05:36:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 6/7] powerpc/sprs: Specify SPRs with data rather than code
Date:   Fri, 17 Mar 2023 22:36:13 +1000
Message-Id: <20230317123614.3687163-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317123614.3687163-1-npiggin@gmail.com>
References: <20230317123614.3687163-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A significant rework that builds an array of 'struct spr', where each
element describes an SPR. This makes various metadata about the SPR
like name and access type easier to carry and use.

Hypervisor privileged registers are described despite not being used
at the moment for completeness, but also the code might one day be
reused for a hypervisor-privileged test.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
This ended up a little over-engineered perhaps, but there are lots of
SPRs, lots of access types, lots of changes between processor and ISA
versions, and lots of places they are implemented and used, so lots of
room for mistakes. There is not a good system in place to easily
see that userspace, supervisor, etc., switches perform all the right
SPR context switching so this is a nice test case to have.

The sprs test quickly caught a few QEMU TCG SPR bugs which really
demonstrates its value and motivated me to improve the SPR coverage
a little.

Thanks,
Nick
---
 powerpc/sprs.c | 586 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 391 insertions(+), 195 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index b633ea8..257903a 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -82,231 +82,404 @@ static void mtspr(unsigned spr, uint64_t val)
 	: "lr", "ctr", "xer");
 }
 
-uint64_t before[1024], after[1024];
+static uint64_t before[1024], after[1024];
 
-/* Common SPRs for all PowerPC CPUs */
-static void set_sprs_common(uint64_t val)
-{
-	// mtspr(9, val);	/* CTR */ /* Used by mfspr/mtspr */
-	// mtspr(273, val);	/* SPRG1 */  /* Used by our exception handler */
-	mtspr(274, val);	/* SPRG2 */
-	mtspr(275, val);	/* SPRG3 */
-}
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
 
 /* SPRs from PowerPC Operating Environment Architecture, Book III, Vers. 2.01 */
-static void set_sprs_book3s_201(uint64_t val)
-{
-	mtspr(18, val);		/* DSISR */
-	mtspr(19, val);		/* DAR */
-	mtspr(152, val);	/* CTRL */
-	mtspr(256, val);	/* VRSAVE */
-	mtspr(786, val);	/* MMCRA */
-	mtspr(795, val);	/* MMCR0 */
-	mtspr(798, val);	/* MMCR1 */
-}
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
+[310] = {"HDEC",	32,	HV_RW, },
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
+[128] = {"TFHAR",	64,	RW, },
+[129] = {"TFIAR",	64,	RW, },
+[130] = {"TEXASR",	64,	RW, },
+[131] = {"TEXASRU",	32,	RW, },
+};
 
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
+[339] = {"HEIR",	32,	HV_RW, },
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
+[339] = {"HEIR",	32,	HV_RW, },
+[464] = {"PTCR",	64,	HV_RW, },
+[816] = {"ASDR",	64,	HV_RW,		SPR_INT},
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
+[339] = {"HEIR",	64,	HV_RW, },
+[455] = {"HDEXCR",	32,	RO, },
+[464] = {"PTCR",	64,	HV_RW, },
+[468] = {"HASHKEYR",	64,	OS_RW, },
+[469] = {"HASHPKEYR",	64,	HV_RW, },
+[471] = {"HDEXCR",	64,	HV_RW, },
+[812] = {"DEXCR",	32,	RO, },
+[816] = {"ASDR",	64,	HV_RW,		SPR_INT},
+[823] = {"PSSCR",	64,	OS_RW, },
+[828] = {"DEXCR",	64,	OS_RW, },
+[855] = {"PSSCR",	64,	HV_RW, },
+};
 
-static void set_sprs(uint64_t val)
+/* SPRs POWER10 User Manual */
+static const struct spr sprs_power10[1024] = {
+[276] = {"SPRC",	64,	HV_RW, },
+[266] = {"SPRD",	64,	HV_RW, },
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
+			if (sprs_power10[i].name) {
+				assert(!sprs[i].name);
+				memcpy(&sprs[i], &sprs_power10[i], sizeof(struct spr));
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
-	v[9] = mfspr(9);	/* CTR */ /* Used by mfspr/mtspr */
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
+		v[i] = mfspr(i);
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
+			mtspr(i, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);
+		} else {
+			mtspr(i, val);
+		}
 	}
 }
 
@@ -343,7 +516,9 @@ int main(int argc, char **argv)
 		}
 	}
 
-	printf("Settings SPRs to %#lx...\n", pat);
+	setup_sprs();
+
+	printf("Setting SPRs to 0x%lx...\n", pat);
 	set_sprs(pat);
 
 	memset(before, 0, sizeof(before));
@@ -355,16 +530,37 @@ int main(int argc, char **argv)
 		migrate_once();
 	} else {
 		sleep(0x10000000);
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
+		if (sprs[i].width == 32)
+			report(pass, "%-10s(%4d):\t        0x%010lx <==>         0x%010lx",
+				sprs[i].name, i,
+				before[i], after[i]);
+		else
+			report(pass, "%-10s(%4d):\t0x%018lx <==> 0x%018lx",
+				sprs[i].name, i,
+				before[i], after[i]);
 	}
 
 	return report_summary();
-- 
2.37.2

