Return-Path: <kvm+bounces-4632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98066815983
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8A5E1C216FF
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79CF328BF;
	Sat, 16 Dec 2023 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WDpw4QRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF16328B1
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3ba40df6881so1106401b6e.2
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734300; x=1703339100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jIIu4k1XdoD66DJz5iUSnakIVIOcqcRlWNFj942LOXM=;
        b=WDpw4QRO9jUnobtgMXxlv5JkxTahnZHA4/vA+FB7KEA4ACvYAH/FB+MTDE6M5rsXEt
         2YHSRAfcWuW2F8xN64pPmoUrb98LuPbgdaNYNd4Ir9zI2TlS2UqPvSTnCcyDP0GEyHTe
         6mwdBtUfnNI9W1zPb9IuRGfAWZZXN9dgqwbZuVMMXrQp9dgEu7Xx5H3ZUzru/1DK7TT4
         drO163YrcPeHNJfuwINBMDfXx3hnYqgR+8x4qkHtDvMtnvJ8TPY4D/wYPfl1iFR9PPM7
         BHRCqu3vpGReaLbi0NIbzkd7unIylWJ96FO+t94vFQWnMWI/4EU8S/9XxM0156pH55ht
         +zFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734300; x=1703339100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jIIu4k1XdoD66DJz5iUSnakIVIOcqcRlWNFj942LOXM=;
        b=UD08eCLJQqIhXdppesaumlTSU4uCBU9Cdoaa5WXtsAZlt8W7o7w/B5J6XvmRf2OhFN
         djrSUwuzOdxARWFRgEY6KR4yDkU1XRaiQkqU+1IJxJ1v6Em6XmE2qcxYHbc0fM9ZXG8X
         cy8y9walt8bqDcLf/LCN1HCAqhEiZgshrIMb7j0kBAqQQ2F0YOPCiePw6IfseiHNeqN6
         KVnetW0X2Kpxs7ZvMfll59v5Mw8+X6nxDRHMyLGmTxqV8mS4gqIVXV9oCndDbt/8So6X
         bHVVCyxN8eturLv0w/OqGwYdI3Y8EJ8NzZpLze2cdQw5D76zEl0z4K2JhFovt77Bqb2z
         B89A==
X-Gm-Message-State: AOJu0YxgJkT6R523qMI5QznSh+Aiph54VQxvzg0RdQt4W6XHjnn5m/ZA
	DUeQs4Vto8o4QGESkELZ1gA6NPFtD+A=
X-Google-Smtp-Source: AGHT+IHJOKiM9Jo+CuiopYhXPeFgP4kPzPOS4kJBDYzhDg7A0gW+rQs7I35NTd6/xn35XZmeFd4Xkg==
X-Received: by 2002:a05:6808:1b0f:b0:3ba:30dc:56c8 with SMTP id bx15-20020a0568081b0f00b003ba30dc56c8mr6512067oib.37.1702734300114;
        Sat, 16 Dec 2023 05:45:00 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:59 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 25/29] powerpc: Add rtas stop-self support
Date: Sat, 16 Dec 2023 23:42:52 +1000
Message-ID: <20231216134257.1743345-26-npiggin@gmail.com>
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

In preparation for improved SMP support, add stop-self support to the
harness. This is non-trivial because it requires an unlocked rtas
call: a CPU can't be holding a spin lock when it goes offline or it
will deadlock other CPUs. rtas permits stop-self to be called without
serialising all other rtas operations.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/rtas.h |  2 ++
 lib/powerpc/rtas.c     | 78 +++++++++++++++++++++++++++++++++---------
 2 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/lib/powerpc/asm/rtas.h b/lib/powerpc/asm/rtas.h
index 6fb407a1..364bf935 100644
--- a/lib/powerpc/asm/rtas.h
+++ b/lib/powerpc/asm/rtas.h
@@ -23,8 +23,10 @@ struct rtas_args {
 extern void rtas_init(void);
 extern int rtas_token(const char *service, uint32_t *token);
 extern int rtas_call(int token, int nargs, int nret, int *outputs, ...);
+extern int rtas_call_unlocked(struct rtas_args *args, int token, int nargs, int nret, int *outputs, ...);
 
 extern void rtas_power_off(void);
+extern void rtas_stop_self(void);
 #endif /* __ASSEMBLY__ */
 
 #define RTAS_MSR_MASK 0xfffffffffffffffe
diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
index 41c0a243..b77a60b0 100644
--- a/lib/powerpc/rtas.c
+++ b/lib/powerpc/rtas.c
@@ -87,40 +87,86 @@ int rtas_token(const char *service, uint32_t *token)
 	return 0;
 }
 
-int rtas_call(int token, int nargs, int nret, int *outputs, ...)
+static void __rtas_call(struct rtas_args *args)
 {
-	va_list list;
-	int ret, i;
+	enter_rtas(__pa(args));
+}
 
-	spin_lock(&rtas_lock);
+static int rtas_call_unlocked_va(struct rtas_args *args,
+			  int token, int nargs, int nret, int *outputs,
+			  va_list list)
+{
+	int ret, i;
 
-	rtas_args.token = cpu_to_be32(token);
-	rtas_args.nargs = cpu_to_be32(nargs);
-	rtas_args.nret = cpu_to_be32(nret);
-	rtas_args.rets = &rtas_args.args[nargs];
+	args->token = cpu_to_be32(token);
+	args->nargs = cpu_to_be32(nargs);
+	args->nret = cpu_to_be32(nret);
+	args->rets = &args->args[nargs];
 
-	va_start(list, outputs);
 	for (i = 0; i < nargs; ++i)
-		rtas_args.args[i] = cpu_to_be32(va_arg(list, u32));
-	va_end(list);
+		args->args[i] = cpu_to_be32(va_arg(list, u32));
 
 	for (i = 0; i < nret; ++i)
-		rtas_args.rets[i] = 0;
+		args->rets[i] = 0;
 
-	enter_rtas(__pa(&rtas_args));
+	__rtas_call(args);
 
 	if (nret > 1 && outputs != NULL)
 		for (i = 0; i < nret - 1; ++i)
-			outputs[i] = be32_to_cpu(rtas_args.rets[i + 1]);
+			outputs[i] = be32_to_cpu(args->rets[i + 1]);
+
+	ret = nret > 0 ? be32_to_cpu(args->rets[0]) : 0;
+
+	return ret;
+}
+
+int rtas_call_unlocked(struct rtas_args *args, int token, int nargs, int nret, int *outputs, ...)
+{
+	va_list list;
+	int ret;
 
-	ret = nret > 0 ? be32_to_cpu(rtas_args.rets[0]) : 0;
+	va_start(list, outputs);
+	ret = rtas_call_unlocked_va(args, token, nargs, nret, outputs, list);
+	va_end(list);
+
+	return ret;
+}
+
+int rtas_call(int token, int nargs, int nret, int *outputs, ...)
+{
+	va_list list;
+	int ret;
+
+	spin_lock(&rtas_lock);
+
+	va_start(list, outputs);
+	ret = rtas_call_unlocked_va(&rtas_args, token, nargs, nret, outputs, list);
+	va_end(list);
 
 	spin_unlock(&rtas_lock);
+
 	return ret;
 }
 
+void rtas_stop_self(void)
+{
+	struct rtas_args args;
+	uint32_t token;
+	int ret;
+
+	ret = rtas_token("stop-self", &token);
+	if (ret) {
+		puts("RTAS stop-self not available\n");
+		return;
+	}
+
+	ret = rtas_call_unlocked(&args, token, 0, 1, NULL);
+	printf("RTAS stop-self returnd %d\n", ret);
+}
+
 void rtas_power_off(void)
 {
+	struct rtas_args args;
 	uint32_t token;
 	int ret;
 
@@ -130,6 +176,6 @@ void rtas_power_off(void)
 		return;
 	}
 
-	ret = rtas_call(token, 2, 1, NULL, -1, -1);
+	ret = rtas_call_unlocked(&args, token, 2, 1, NULL, -1, -1);
 	printf("RTAS power-off returned %d\n", ret);
 }
-- 
2.42.0


