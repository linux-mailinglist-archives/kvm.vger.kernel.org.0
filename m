Return-Path: <kvm+bounces-821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 709C57E2FB6
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 23:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9876A1C2099D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 22:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE812EB1E;
	Mon,  6 Nov 2023 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dlS8DLbi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED4A2EB09
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 22:19:01 +0000 (UTC)
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B6C1BC
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:19:00 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-3b56b618217so3018411b6e.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 14:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699309140; x=1699913940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwzHdCviQ65RDktZk0sYRv7bUKUvh9rHa406X9SjzMI=;
        b=dlS8DLbih+bidJz+t4x46mxqw/2g8sX5/6YNiWX4GiuvZiUL7naWeuQG1X3dgDcgP6
         CkgNugeLk0okZ+ORTSHgAM9D0ul7z31OJel7SuGQha6S/PZwn7CM2HuQWJngesMSm+0x
         lBjYkfmAnDgoJ8q86MnjKWYcwTtVhrBmYLAfCjUciIQEau9o0G0cN1ZHzi9NF1rNXp4O
         asrMGLPjdQfafaFGKTgBr8G5WkG2h4tP/n1ZsttMOOkvzr6Z0hHSLDOewxL76MUytwHJ
         EbmEGwAx65PRjTlQ0uo8fpO7eBE24W4XA7g4uHxivNjpHmmFm4NmJ9Kd2ifa6OdIbPkm
         DdBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699309140; x=1699913940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwzHdCviQ65RDktZk0sYRv7bUKUvh9rHa406X9SjzMI=;
        b=hBFy5Owp25JJb0qR3gcoiVOCRaxb3exAvujaeK4+547vhnaEbuNEKoSgu5c6BUFiWV
         JvPzmnblyyP70Dhoe+fT0sTYkhUVkBTJ1dbBa7TQeSS8Et0BFpuRbr30pIQyEd6dYEJD
         iolJrr9tjIMbVFkIL3c326jcqfGrU+Q60Ah1AnBaD1rKmreeXSPZub8bDT4+0uqw4Ytk
         yd1JOmLAz7QvyVo4uKNQKEoEP/W1ElKABJjcLRr26aNEPgFK8GTJ5iCvghDxbdq9znv8
         P5e+DiqzhT9h0yxwE2lBN3bu2sSiFqtC+xod4Bn0b6UTSpFUOWe8tFprJQow9+REs/u3
         Mdvg==
X-Gm-Message-State: AOJu0Yxs+DRXYlV7dSb0op082qSJl+SevINa6Oi+66KI9EeZCCJPqb5H
	+YswfdXe9HE/acE+tkX+VbM=
X-Google-Smtp-Source: AGHT+IEUU4SICVu9QQn1tzyb0qeaJMuCcShTiUWZgdopjkoKzzJ23buM6OIkoXCuSWTLXUcircgERA==
X-Received: by 2002:a05:6808:2394:b0:3a6:fb16:c782 with SMTP id bp20-20020a056808239400b003a6fb16c782mr39232442oib.30.1699309139914;
        Mon, 06 Nov 2023 14:18:59 -0800 (PST)
Received: from paxos.mtv.corp.google.com ([2620:15c:9d:2:b062:65c9:e9d5:831b])
        by smtp.gmail.com with ESMTPSA id h15-20020a056a00218f00b006c3467ae25asm6000167pfi.206.2023.11.06.14.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 14:18:59 -0800 (PST)
From: Lepton Wu <ytht.net@gmail.com>
To: brijesh.singh@amd.com
Cc: tglx@linutronix.de,
	kvm@vger.kernel.org,
	Lepton Wu <ytht.net@gmail.com>
Subject: [PATCH v2] x86/mm: Guard adding .bbs..decrypted section with CONFIG_AMD_MEM_ENCRYPT
Date: Mon,  6 Nov 2023 14:16:52 -0800
Message-ID: <20231106221831.3200581-1-ytht.net@gmail.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
In-Reply-To: <20231106220528.3193206-1-ytht.net@gmail.com>
References: <20231106220528.3193206-1-ytht.net@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit b3f0907c71e0 ("x86/mm: Add .bss..decrypted section to hold shared variables")
adds almost 2M memory usage on some kernels without CONFIG_AMD_MEM_ENCRYPT.
Fix it by guarding it with CONFIG_AMD_MEM_ENCRYPT.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>
---
 arch/x86/kernel/vmlinux.lds.S | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 54a5596adaa6..d39798a23f86 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -69,6 +69,8 @@ jiffies = jiffies_64;
 #define ALIGN_ENTRY_TEXT_BEGIN	. = ALIGN(PMD_SIZE);
 #define ALIGN_ENTRY_TEXT_END	. = ALIGN(PMD_SIZE);
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+
 /*
  * This section contains data which will be mapped as decrypted. Memory
  * encryption operates on a page basis. Make this section PMD-aligned
@@ -88,6 +90,12 @@ jiffies = jiffies_64;
 
 #else
 
+#define BSS_DECRYPTED
+
+#endif
+
+#else
+
 #define X86_ALIGN_RODATA_BEGIN
 #define X86_ALIGN_RODATA_END					\
 		. = ALIGN(PAGE_SIZE);				\
-- 
2.42.0.869.gea05f2083d-goog


