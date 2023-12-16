Return-Path: <kvm+bounces-4621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90217815977
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 179B5B23B99
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E9D3067D;
	Sat, 16 Dec 2023 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l20ftlER"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A533064F
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5cd82917ecfso229254a12.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734255; x=1703339055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LTJ7yfoalNlVXaP2XnSBJMkrcxD46lotdXo+rGR5gY=;
        b=l20ftlERXW20hBW19AUoz5tNg5Q51sWU1e2RVtMsPw2IpHKcudof5I5wowpRAJ2e8t
         X3MDxwHhLX45Pab124b7f5ctlQrwg6iqN5S2MYUmWkn0Uq6PpcddBGjWyvZt+Hl3MKCO
         XX19I+5n/V7Kef1Ba52FRur2JZ9M+vSk1wUbBUH53nivpmd5i4+nWcivGf21KHyNJQJI
         kHX/okmzQmyMg32IWxmimLSc4ILSEG1VZcHMxrWj/3C/OpZB98bfDgVCoM+k/2LHLMf/
         YtVNAIFbXLlwl0q+j8Yb8Ci7h2iDTjkCDNfEQzNdYQkPvID8C7/WhEsihvG3nroLMuZb
         cvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734255; x=1703339055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1LTJ7yfoalNlVXaP2XnSBJMkrcxD46lotdXo+rGR5gY=;
        b=KAT0nLsyGzLYM3AwrQG1b99LBHdNmkOnhhDj9D93S60PhggZNnbO/S/b89KYetltu8
         0dqlAoMKFikCvptHjishPV7c7xVvJJxiImky1CrXwIxde5rKWH2N5z6JA0KCCQgWPZt9
         GAS/symVghvPBhaahD1/Shl8uO7BywjXgiJJhzkhOX2yDja7DyKjzejDIICa/8gXfQrD
         mYytFoxTuMnH5j6QYgRp1Oo/5ulJG8tKT38PTCv5Y8RW/209aLhG5rXbp7OPtmvTUdfr
         UJ9HcvOIRUWPG+oDRow3XXkGopUgUjn/Vl5ubVrtdSI9r7fbnhJGJv4uhR3ExnYMYUM5
         XCoA==
X-Gm-Message-State: AOJu0Yx71xXYOY5Cgif22q68Cpi3CB4LUBeOl30F41nwrCXFqTxF+sht
	vlY80xsqbPd7uaxZFYqZsO6sNM/jqSk=
X-Google-Smtp-Source: AGHT+IHm5PgsAe3mbsod6sKyHlyDb0fTItwc5+r26VfZ2zu5GEVfquaQMCfX879dAID5xru4PfL1Gw==
X-Received: by 2002:a05:6a20:320f:b0:18f:97c:6177 with SMTP id hl15-20020a056a20320f00b0018f097c6177mr13502828pzc.116.1702734255455;
        Sat, 16 Dec 2023 05:44:15 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:15 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 14/29] powerpc: Expand exception handler vector granularity
Date: Sat, 16 Dec 2023 23:42:41 +1000
Message-ID: <20231216134257.1743345-15-npiggin@gmail.com>
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

Exception handlers are currently indexed in units of 0x100, but
powerpc can have vectors that are aligned to as little as 0x20
bytes. Increase granularity of the handler functions before
adding support for those vectors.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/processor.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index b4cd5b4c..b224fc8e 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -16,19 +16,25 @@
 static struct {
 	void (*func)(struct pt_regs *, void *data);
 	void *data;
-} handlers[16];
+} handlers[128];
 
+/*
+ * Exception handlers span from 0x100 to 0x1000 and can have a granularity
+ * of 0x20 bytes in some cases. Indexing spans 0-0x1000 with 0x20 increments
+ * resulting in 128 slots.
+ */
 void handle_exception(int trap, void (*func)(struct pt_regs *, void *),
 		      void * data)
 {
-	assert(!(trap & ~0xf00));
+	assert(!(trap & ~0xfe0));
 
-	trap >>= 8;
+	trap >>= 5;
 
 	if (func && handlers[trap].func) {
 		printf("exception handler installed twice %#x\n", trap << 5);
 		abort();
 	}
+
 	handlers[trap].func = func;
 	handlers[trap].data = data;
 }
@@ -37,9 +43,9 @@ void do_handle_exception(struct pt_regs *regs)
 {
 	unsigned char v;
 
-	v = regs->trap >> 8;
+	v = regs->trap >> 5;
 
-	if (v < 16 && handlers[v].func) {
+	if (v < 128 && handlers[v].func) {
 		handlers[v].func(regs, handlers[v].data);
 		return;
 	}
-- 
2.42.0


