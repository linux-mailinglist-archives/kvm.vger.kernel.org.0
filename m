Return-Path: <kvm+bounces-4616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB622815972
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76DE9281E88
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354DE30108;
	Sat, 16 Dec 2023 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iqP2WwbA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B7E2E83D
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-35d67870032so11309455ab.2
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734235; x=1703339035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4MYz5+++UNHk8JuT6NkzYqZbnD7njBUOAwzQa6uCUHU=;
        b=iqP2WwbABQD2UB5lqpMbnGtNTUwXskKBBsNbOvl0DgBqbhkELiU1GDbhFoZKGgj2uU
         ON7VGOyz96mwfAMp7xGeK3ei/gW0iavGeMaGVVvLVjh4tSLcBbhf9cOCVSUOS5vQp4Ml
         T91W9L3/t7tVUxenHorhrZ1gtkahlBvWW8B9/v7NOd/Z/Snb87GXTXjwo9ciMbbAuqK+
         hKpG9JLUZzhlQ/0JGNenEsNxzeD3FkZuVBKSXj/mv07fkoWoDOQ3ZDl4uXebjY/SinOf
         4E3F1Nor7NUIa40o49P5wCPAr1itlirREWJRP0inIqMK3+wZFj6JhVNWLSoqlvGrB2Nx
         fb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734235; x=1703339035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MYz5+++UNHk8JuT6NkzYqZbnD7njBUOAwzQa6uCUHU=;
        b=d7Pf/iwWfjOPCqdkPD/MZTNK/z+woRfIpelm09RcPS/ASyaV13ZIR12/hiG69hRdtl
         eEh8BWiZQlHoVqGLJPDIoZg+cv7BhSt6uHgVZsnyrz0Urr+2LDp63BiCfyr4zvqUVTEE
         LOeXTFEQSGu1aUCJuUEO7cAwgEbLG/Y00o03bhhuCWjWdY395+xOFOrqXoEwB2ZsDqZ4
         R+MDQ9j7eXEsN22vM+GMXZYNZhE3AsPMxI7+ckGyMRerrRWC+tAR4bq+JNzV5nFEJhvR
         NSUwvZseYw95jL3kfanBoZ3SS97GMh6yOl6qNygpUwdkDlVqPfAeRB+Ha8ZT301JM3g1
         WlEg==
X-Gm-Message-State: AOJu0YxARSjQ7QV6dz81eoiMBsJR1e1+u2gTq9X2ZjQ/wQbyox17hLcR
	JuMp2pAjhUqACG3jjebkFbNCneWOrxU=
X-Google-Smtp-Source: AGHT+IEPrGjIGT5jrkjhBZTxwAQfWv371FWVrlYl7wV2CfXjcUfMNPWI0OqNqcFmILfPaMrcHs74Vw==
X-Received: by 2002:a05:6e02:320f:b0:35f:847c:1e4c with SMTP id cd15-20020a056e02320f00b0035f847c1e4cmr6037968ilb.89.1702734234953;
        Sat, 16 Dec 2023 05:43:54 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:54 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 09/29] powerpc: Fix interrupt stack alignment
Date: Sat, 16 Dec 2023 23:42:36 +1000
Message-ID: <20231216134257.1743345-10-npiggin@gmail.com>
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

ppc64 requires the stack to be 16-byte aligned but the interrupt
stack frame has 8-byte aligned size. Add padding to fix.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/setup.c    | 3 +++
 lib/ppc64/asm/ptrace.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 1be4c030..d98f66fa 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -18,6 +18,7 @@
 #include <argv.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/ptrace.h>
 #include <asm/hcall.h>
 #include "io.h"
 
@@ -195,6 +196,8 @@ void setup(const void *fdt)
 		freemem += initrd_size;
 	}
 
+	assert(STACK_INT_FRAME_SIZE % 16 == 0);
+
 	/* call init functions */
 	cpu_init();
 
diff --git a/lib/ppc64/asm/ptrace.h b/lib/ppc64/asm/ptrace.h
index 076c9d9c..12de7499 100644
--- a/lib/ppc64/asm/ptrace.h
+++ b/lib/ppc64/asm/ptrace.h
@@ -14,6 +14,7 @@ struct pt_regs {
 	unsigned long xer;
 	unsigned long ccr;
 	unsigned long trap;
+	unsigned long _pad; /* stack must be 16-byte aligned */
 };
 
 #define STACK_INT_FRAME_SIZE    (sizeof(struct pt_regs) + \
-- 
2.42.0


