Return-Path: <kvm+bounces-4622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00663815978
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E8161F2332F
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6543430CFC;
	Sat, 16 Dec 2023 13:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CU2AXrRz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6225C30CED
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d04c097e34so11468165ad.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734259; x=1703339059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vrFiRWzr2/CWyKvsrLbnp0THJBKoGOpcOL5XEiuuKMg=;
        b=CU2AXrRzMjOeCx5SZaTBYs+8se/KB5SlpFi9PuDMstFcBcz2HAAvzOBrMNPquRxDOi
         WukfvoIUKRdDcR2mqycHQvSVUPWsUmbYhdmTnY9hTlAC7FaZcU7t4PziGxWN4nfsXXeb
         tstJpc/vA/KtBDVrwp5YdqBoZY+qXX7UmE1vX9l6NfQ/yp0Ry734i7WRQ7VWxtGwx9Rv
         /RwT2mcblJwVwdd1JB6Ntz0Sa+RLZMsrgvdSBMvYRREeByewj8X5ZakddxMzLGWELz0C
         lM4vZFpZRRlgYu41aYQiNSL9lZZtBsSf8FBPX34TltxlZwNCoBn73jvN4XzvsianOT3d
         iUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734259; x=1703339059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vrFiRWzr2/CWyKvsrLbnp0THJBKoGOpcOL5XEiuuKMg=;
        b=V0RrhIa9YjqnkMqbsyg1BweYC8GalnlkHEicmnCoR2sAMhHhTMpz/TJBtWVMf5IZ9Y
         ID20C2n5ZP03pHTVk1U18OrkUdFxQQh8SoE9wHpUHSvCTqRklYAOTPF2PNIk5BRVyUnp
         jMl3iw9KzA2QTSzcJA5g0wr1VgZt0EL4PftssZR7YKFV7zWkRPqJ31gpMa2ge0IbL4d9
         6QrODaP/BMhpA0EuE2dvn1SFGPDwaFLeeozrZh+ydXRQbBIrmaT3A1NKVcqdigr2p9Wb
         OhxvgMNqVk67V2c9OJG+okQn47RgXsOBIafeXvPzGEzkB6kbqsf7Qzu27jmeKiihUczl
         HY+A==
X-Gm-Message-State: AOJu0YxlmpvRLyFWXcCXXE4+GX7ndmR0rcuaBE90tqAv77d0ZzjLrhLA
	e/MkCSOs8MZNyEwQdrvh0um3Eqr8iMo=
X-Google-Smtp-Source: AGHT+IEUphZixwmMJqUyoYGpZGqVVIMHdGhX3EvY6ReMIxVXWqpGW5j1M00J54p6roVW6KWrXEc8XQ==
X-Received: by 2002:a17:902:ea12:b0:1d3:3881:c50f with SMTP id s18-20020a170902ea1200b001d33881c50fmr9861383plg.45.1702734259378;
        Sat, 16 Dec 2023 05:44:19 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:19 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 15/29] powerpc: Add support for more interrupts including HV interrupts
Date: Sat, 16 Dec 2023 23:42:42 +1000
Message-ID: <20231216134257.1743345-16-npiggin@gmail.com>
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

Interrupt vectors were not being populated for all architected
interrupt types, which could lead to crashes rather than a message for
unhandled interrupts.

0x20 sized vectors require some reworking of the code to fit. This
also adds support for HV / HSRR type interrupts which will be used in
a later change.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/ppc_asm.h |  3 ++
 powerpc/cstart64.S        | 79 ++++++++++++++++++++++++++++++++-------
 2 files changed, 68 insertions(+), 14 deletions(-)

diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
index 6299ff53..46b4be00 100644
--- a/lib/powerpc/asm/ppc_asm.h
+++ b/lib/powerpc/asm/ppc_asm.h
@@ -35,6 +35,9 @@
 
 #endif /* __BYTE_ORDER__ */
 
+#define SPR_HSRR0	0x13A
+#define SPR_HSRR1	0x13B
+
 /* Machine State Register definitions: */
 #define MSR_EE_BIT	15			/* External Interrupts Enable */
 #define MSR_SF_BIT	63			/* 64-bit mode */
diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 34e39341..b7514100 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -184,14 +184,6 @@ call_handler:
 	mfcr	r0
 	std	r0,_CCR(r1)
 
-	/* nip and msr */
-
-	mfsrr0	r0
-	std	r0, _NIP(r1)
-
-	mfsrr1	r0
-	std	r0, _MSR(r1)
-
 	/* restore TOC pointer */
 
 	LOAD_REG_IMMEDIATE(r31, SPAPR_KERNEL_LOAD_ADDR)
@@ -238,6 +230,7 @@ call_handler:
 
 .section .text.ex
 
+/* [H]VECTOR must not be more than 8 instructions to fit in 0x20 vectors */
 .macro VECTOR vec
 	. = \vec
 
@@ -246,19 +239,28 @@ call_handler:
 	subi	r1,r1, INT_FRAME_SIZE
 
 	/* save r0 and ctr to call generic handler */
-
 	SAVE_GPR(0,r1)
 
-	mfctr	r0
-	std	r0,_CTR(r1)
+	li	r0,\vec
+	std	r0,_TRAP(r1)
 
-	ld	r0, P_HANDLER(0)
-	mtctr	r0
+	b	handler_trampoline
+.endm
+
+.macro HVECTOR vec
+	. = \vec
+
+	mtsprg1	r1	/* save r1 */
+	mfsprg0	r1	/* get exception stack address */
+	subi	r1,r1, INT_FRAME_SIZE
+
+	/* save r0 and ctr to call generic handler */
+	SAVE_GPR(0,r1)
 
 	li	r0,\vec
 	std	r0,_TRAP(r1)
 
-	bctr
+	b	handler_htrampoline
 .endm
 
 	. = 0x100
@@ -268,12 +270,61 @@ __start_interrupts:
 VECTOR(0x100)
 VECTOR(0x200)
 VECTOR(0x300)
+VECTOR(0x380)
 VECTOR(0x400)
+VECTOR(0x480)
 VECTOR(0x500)
 VECTOR(0x600)
 VECTOR(0x700)
 VECTOR(0x800)
 VECTOR(0x900)
+HVECTOR(0x980)
+VECTOR(0xa00)
+VECTOR(0xc00)
+VECTOR(0xd00)
+HVECTOR(0xe00)
+HVECTOR(0xe20)
+HVECTOR(0xe40)
+HVECTOR(0xe60)
+HVECTOR(0xe80)
+HVECTOR(0xea0)
+VECTOR(0xf00)
+VECTOR(0xf20)
+VECTOR(0xf40)
+VECTOR(0xf60)
+HVECTOR(0xf80)
+
+handler_trampoline:
+	mfctr	r0
+	std	r0,_CTR(r1)
+
+	ld	r0, P_HANDLER(0)
+	mtctr	r0
+
+	/* nip and msr */
+	mfsrr0	r0
+	std	r0, _NIP(r1)
+
+	mfsrr1	r0
+	std	r0, _MSR(r1)
+
+	bctr
+
+handler_htrampoline:
+	mfctr	r0
+	std	r0,_CTR(r1)
+
+	ld	r0, P_HANDLER(0)
+	mtctr	r0
+
+	/* nip and msr */
+	mfspr	r0, SPR_HSRR0
+	std	r0, _NIP(r1)
+
+	mfspr	r0, SPR_HSRR1
+	std	r0, _MSR(r1)
+
+	bctr
 
 	.align 7
 	.globl __end_interrupts
-- 
2.42.0


