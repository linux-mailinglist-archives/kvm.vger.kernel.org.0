Return-Path: <kvm+bounces-4625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1150681597C
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:45:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B922A282773
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D0A31598;
	Sat, 16 Dec 2023 13:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVXJeOLD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E62B30FBD
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6cebbf51742so1155651b3a.1
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734271; x=1703339071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOKTCvhQ6ipHH9JB0uDwBswIVZydiLt1fgVOnkOxwyk=;
        b=DVXJeOLDEeo9pTBoApjn4BWDZq1iVnMiaBiF7MyORRRPqMojM7j8eiXKGnBGwVFzK5
         GK+emd9dbco5MjnT+GSLdIuI2R/oJVTTyNwBee/cICh4hcCPYN9zKODbg7GFqTiMrwRy
         n+6qP78kxLAMBt6FY9Ze5a0Gb5fr38jqWtKXGvnwx5Api44yYudmDDMvPR6KqpG0fH7v
         JRZs4A+H5p8kWiHwsdxatf1+evRt3tqr20TSz/aU/C/BnlIy+yaTqOkHEyDleXK32vP2
         quiqRbRtw/D4z09gXA6/BgIW9N8trXmCgLqAmvtKjBiUpB5+MV+eeFSUHT3potHQ+DFG
         JgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734271; x=1703339071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOKTCvhQ6ipHH9JB0uDwBswIVZydiLt1fgVOnkOxwyk=;
        b=EuoPdVYhKc6ZcVeZm4xH4YT8LaRc1konDvjarf1OkJBIdQMOnx5q3BWAgwUEp4LLVF
         B6TsUIQK8bfSTmbjqgQDi3hyLRGopfQfDKoMHYhO6a5HG84TaGjlCLoyEA1opCo5HpEi
         zwSwQmwAvisxboUNsntgKMuaICzHQbKC7PiOTCf//uC0tTxhMKLL3XTeWw4mAL+f85yK
         YjPNOMoWALzOmO2MUVphvDriLCrkWVsX6SqZQvuuiVn6Y1pG6Z6S3fqEr5Yj4/K4UCWO
         bIh2bX6se9Yb3WDFKXRvKCGnnpGymguaER8nn2EkfOGBxBUpvl3ICqyHmHCcLBD4ECro
         NgFQ==
X-Gm-Message-State: AOJu0YwYXN4OthJkGOHfRyoQywEPvXdvGQEmUaf/g6VfIjc3Ga6R8shg
	p9SBIv071GZRn3yLxGOQDJSqHv4hCMU=
X-Google-Smtp-Source: AGHT+IG7hj9sLGXeYZkKkH5H5pl8t2utTIqzTJglNneFlWrNdlyX5SMkMWDraLPFpWFBSb4KQOkLhQ==
X-Received: by 2002:a05:6a00:181f:b0:6ce:4587:4d7b with SMTP id y31-20020a056a00181f00b006ce45874d7bmr18751595pfa.24.1702734271361;
        Sat, 16 Dec 2023 05:44:31 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:31 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 18/29] powerpc: Fix stack backtrace termination
Date: Sat, 16 Dec 2023 23:42:45 +1000
Message-ID: <20231216134257.1743345-19-npiggin@gmail.com>
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

The backtrace handler terminates when it sees a NULL caller address,
but the powerpc stack setup does not keep such a NULL caller frame
at the start of the stack.

This happens to work on pseries because the memory at 0 is mapped and
it contains 0 at the location of the return address pointer if it
were a stack frame. But this is fragile, and does not work with powernv
where address 0 contains firmware instructions.

Use the existing dummy frame on stack as the NULL caller, and create a
new frame on stack for the entry code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index e18ae9a2..14ab0c6c 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -46,8 +46,16 @@ start:
 	add	r1, r1, r31
 	add	r2, r2, r31
 
+	/* Zero backpointers in initial stack frame so backtrace() stops */
+	li	r0,0
+	std	r0,0(r1)
+	std	r0,16(r1)
+
+	/* Create entry frame */
+	stdu	r1,-INT_FRAME_SIZE(r1)
+
 	/* save DTB pointer */
-	std	r3, 56(r1)
+	SAVE_GPR(3,r1)
 
 	/*
 	 * Call relocate. relocate is C code, but careful to not use
@@ -101,7 +109,7 @@ start:
 	stw	r4, 0(r3)
 
 	/* complete setup */
-1:	ld	r3, 56(r1)
+1:	REST_GPR(3, r1)
 	bl	setup
 
 	/* run the test */
-- 
2.42.0


