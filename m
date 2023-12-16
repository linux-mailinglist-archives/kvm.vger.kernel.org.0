Return-Path: <kvm+bounces-4624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E8281597B
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3194E281635
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2A130FAC;
	Sat, 16 Dec 2023 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLRvr5E9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5AE30FA0
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2039cb39b32so146245fac.3
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734267; x=1703339067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/q9+SOTNgxejygyzTqb3f6ILvTs7v7L66VeB6SlNtM=;
        b=cLRvr5E9ndMrr02eevCMbckbkR6vBCkAwS4PkRO9T5jz3qqqvtENwXtO6V9sB7u9UX
         /vtLTN0Rn2DY6Qax9xCmu1Ux2J49irSgy8dbDWpFz7G60szenYvgdFhJmS/8vC9N1WCH
         EaW8xOsjGFWe6Vu9c8StpUYXx8n0R1cLCJBTxMjED5p2PxTkTLxu+3dlGoc1IUzCrUZ3
         7SAohlEQ9lT10hkTiX64y5gGOzkQhNBBOmIo03aSnc2cuoDxbXFnWrayX4yYaFdTSIOm
         KXmCyhjhA+FyjHjK6zljv+ik5kYEMgKkAXvxpDILKiIMDx8uBR7a6wtqsINgRTDTubt2
         qQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734267; x=1703339067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x/q9+SOTNgxejygyzTqb3f6ILvTs7v7L66VeB6SlNtM=;
        b=UKmsSOzMziSnd5aY3cAmuMMcJCNkDI6glM+Edwh/HNAfoCIVojgIZ4Ys2YMjwdLZgu
         WOBGvUe4ls+SJKJdkulZ7xeDcavdXzKnhp4VALXy0wyXIGyMg5YyvuuoMOkyAz1J+SBd
         F9bzVUdsth3874GurlQGw1zoADimfV4G1wv47mikXNz43YYJXs5jvt6d3PE/j/FxzKQ7
         q8TUfS88h7tyguXkSXKjoUvfXG9pnbj7lTwENcnBZiaUPTzLmA2Lk+9vyPPPCvQW3gIJ
         bF6rH3w+bNBxGy6sU5xK4kX4pTFGXYiaF+2Y3gSiikGUSjvuvbaUb3D8qrVOG9/viGKq
         ma5w==
X-Gm-Message-State: AOJu0YyOeZ8AtT4y0ToiIpv2lSNlGqtnfplB3533b4ZHzj3g/ZuhwrKv
	ZxBIibumDHn2yJsSC/LKRxjaXt1a2GQ=
X-Google-Smtp-Source: AGHT+IFO3S6GTU9B8coHknBBHNQlHDEePwVqxJzCwvKeJib5aGrsNWRA85MGzG8yqLEVBKRdInLFkw==
X-Received: by 2002:a05:6870:a452:b0:203:5a17:7d8f with SMTP id n18-20020a056870a45200b002035a177d8fmr4204496oal.100.1702734267474;
        Sat, 16 Dec 2023 05:44:27 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:27 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 17/29] powerpc: Discover runtime load address dynamically
Date: Sat, 16 Dec 2023 23:42:44 +1000
Message-ID: <20231216134257.1743345-18-npiggin@gmail.com>
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

The next change will load the kernels at different addresses depending
on test options, so this needs to be reverted back to dynamic
discovery.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index b7514100..e18ae9a2 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -33,9 +33,14 @@ start:
 	 * We were loaded at QEMU's kernel load address, but we're not
 	 * allowed to link there due to how QEMU deals with linker VMAs,
 	 * so we just linked at zero. This means the first thing to do is
-	 * to find our stack and toc, and then do a relocate.
+	 * to find our stack and toc, and then do a relocate. powernv and
+	 * pseries load addresses are not the same, so find the address
+	 * dynamically:
 	 */
-	LOAD_REG_IMMEDIATE(r31, SPAPR_KERNEL_LOAD_ADDR)
+	bl	0f
+0:	mflr	r31
+	subi	r31, r31, 0b - start	/* QEMU's kernel load address */
+
 	ld	r1, (p_stack - start)(r31)
 	ld	r2, (p_toc - start)(r31)
 	add	r1, r1, r31
@@ -114,8 +119,11 @@ p_toc:		.llong  tocptr
 p_dyn:		.llong  dynamic_start
 
 .text
+start_text:
 .align 3
+p_toc_text:	.llong	tocptr
 
+.align 3
 .globl hcall
 hcall:
 	sc	1
@@ -185,9 +193,10 @@ call_handler:
 	std	r0,_CCR(r1)
 
 	/* restore TOC pointer */
-
-	LOAD_REG_IMMEDIATE(r31, SPAPR_KERNEL_LOAD_ADDR)
-	ld	r2, (p_toc - start)(r31)
+	bl	0f
+0:	mflr	r31
+	subi	r31, r31, 0b - start_text
+	ld	r2, (p_toc_text - start_text)(r31)
 
 	/* FIXME: build stack frame */
 
-- 
2.42.0


