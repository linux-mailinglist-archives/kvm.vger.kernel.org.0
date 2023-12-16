Return-Path: <kvm+bounces-4630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4CE815981
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F11081C21703
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E4C321A5;
	Sat, 16 Dec 2023 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWI4I6P3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D9831A93
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7b71e389fb2so76702239f.3
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734292; x=1703339092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPkcaUzKxytkonjooxhvo4BYjg5Jry+HGs3Qd6LiJpQ=;
        b=PWI4I6P3oSKmL9TuV0w6AqO7F+pix6/PDrYRZwsx+ckmlkVkJ18L61CPzu3WYCwhQZ
         BO+zCQ37jJed4I/MmDurhEcdGplbgxtFKshS+pE0dnj9ADRvEt9fJJY4tH1MJSRcp3/I
         J/DnqZnm0blpXlGLs2KNDNO46s89ndE9LRQHemrQ+tDfp2LsZlkt6/qi1dFguyzzVFya
         bLF0YJ5aZvC9a2Wp+8DwL3Fm9Va+pxgtzuyK1i7qy52sphyQcyfQH11wPHjbb4ydngpD
         FlVdaIXHDo2a0qLdm1u9ZFkeqKAcV58sCoK8Ty8dX1XLARqjnUBQ8rDz+8iwLlDK2ZVg
         n3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734292; x=1703339092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PPkcaUzKxytkonjooxhvo4BYjg5Jry+HGs3Qd6LiJpQ=;
        b=vq/U6pjcOfuRp0JB3qyahlAE/uR+b48n4WfXAAeDPtmClzgRCQYRAUT9LD03BnxRCL
         NL9D/Ce8YbynMBD11n20QXosTEPaPLVGpKSTAVX7rrf3yAAlt9Fj/Q2yBrgBMQ2Po6hr
         21aapWaaWLa5eTF6+JSBbZ+UU4QZ72YkKw15tdN/1lzpgiJFThP7v45TOMO1GUIAt0KB
         TpUOVmbmz07dfj35tsL19n2XQBURVo2loIqoT7kQ5/wUZVYIA55WkeXhHdj88wCmYPx9
         QLpxpPl2lUOsQ1LFvTaSnxWuNruZX4FwxAV7XSIViF1kzFpNKorfKshaWxYin/2FoZ4Y
         XMmw==
X-Gm-Message-State: AOJu0Yy/4Cj80O4nyIk88tilTd5JcCIX47R70sDg+XbZ2ISFS2e1Ts/5
	CO/fcoOR3V1CI/MAmk1d3EqSNL6n7ts=
X-Google-Smtp-Source: AGHT+IFECrMd75Jj2Fqwzp9XTq/Dd6QJtX9ArtySdSfP6W0dZ6qsjyDdAG7/mhGOU4gF8mGx1p0v6g==
X-Received: by 2002:a05:6e02:1609:b0:35c:8f50:acd3 with SMTP id t9-20020a056e02160900b0035c8f50acd3mr23320332ilu.18.1702734291871;
        Sat, 16 Dec 2023 05:44:51 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:51 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 23/29] powerpc/sprs: Test hypervisor registers on powernv machine
Date: Sat, 16 Dec 2023 23:42:50 +1000
Message-ID: <20231216134257.1743345-24-npiggin@gmail.com>
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

This enables HV privilege registers to be tested with the powernv
machine.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 313698e0..daaae3bc 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -199,16 +199,16 @@ static const struct spr sprs_power_common[1024] = {
 [190] = {"HFSCR",	64,	HV_RW, },
 [256] = {"VRSAVE",	32,	RW, },
 [259] = {"SPRG3",	64,	RO, },
-[284] = {"TBL",		32,	HV_WO, },
-[285] = {"TBU",		32,	HV_WO, },
-[286] = {"TBU40",	64,	HV_WO, },
+[284] = {"TBL",		32,	HV_WO, }, /* Things can go a bit wonky with */
+[285] = {"TBU",		32,	HV_WO, }, /* Timebase changing. Should save */
+[286] = {"TBU40",	64,	HV_WO, }, /* and restore it. */
 [304] = {"HSPRG0",	64,	HV_RW, },
 [305] = {"HSPRG1",	64,	HV_RW, },
 [306] = {"HDSISR",	32,	HV_RW,		SPR_INT, },
 [307] = {"HDAR",	64,	HV_RW,		SPR_INT, },
 [308] = {"SPURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
 [309] = {"PURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
-[313] = {"HRMOR",	64,	HV_RW, },
+[313] = {"HRMOR",	64,	HV_RW,		SPR_HARNESS, }, /* Harness can't cope with HRMOR changing */
 [314] = {"HSRR0",	64,	HV_RW,		SPR_INT, },
 [315] = {"HSRR1",	64,	HV_RW,		SPR_INT, },
 [318] = {"LPCR",	64,	HV_RW, },
@@ -306,7 +306,7 @@ static const struct spr sprs_power9_10[1024] = {
 [921] = {"TSCR",	32,	HV_RW, },
 [922] = {"TTR",		64,	HV_RW, },
 [1006]= {"TRACE",	64,	WO, },
-[1008]= {"HID",		64,	HV_RW, },
+[1008]= {"HID",		64,	HV_RW,		SPR_HARNESS, }, /* At least HILE would be unhelpful to change */
 };
 
 /* This covers POWER8 and POWER9 PMUs */
@@ -350,6 +350,22 @@ static const struct spr sprs_power10_pmu[1024] = {
 
 static struct spr sprs[1024];
 
+static bool spr_read_perms(int spr)
+{
+	if (machine_is_powernv())
+		return !!(sprs[spr].access & SPR_HV_READ);
+	else
+		return !!(sprs[spr].access & SPR_OS_READ);
+}
+
+static bool spr_write_perms(int spr)
+{
+	if (machine_is_powernv())
+		return !!(sprs[spr].access & SPR_HV_WRITE);
+	else
+		return !!(sprs[spr].access & SPR_OS_WRITE);
+}
+
 static void setup_sprs(void)
 {
 	uint32_t pvr = mfspr(287);	/* Processor Version Register */
@@ -466,7 +482,7 @@ static void get_sprs(uint64_t *v)
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (!(sprs[i].access & SPR_OS_READ))
+		if (!spr_read_perms(i))
 			continue;
 		v[i] = __mfspr(i);
 	}
@@ -477,8 +493,9 @@ static void set_sprs(uint64_t val)
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (!(sprs[i].access & SPR_OS_WRITE))
+		if (!spr_write_perms(i))
 			continue;
+
 		if (sprs[i].type & SPR_HARNESS)
 			continue;
 		__mtspr(i, val);
@@ -540,7 +557,7 @@ int main(int argc, char **argv)
 	for (i = 0; i < 1024; i++) {
 		bool pass = true;
 
-		if (!(sprs[i].access & SPR_OS_READ))
+		if (!spr_read_perms(i))
 			continue;
 
 		if (sprs[i].width == 32) {
-- 
2.42.0


