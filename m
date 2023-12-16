Return-Path: <kvm+bounces-4627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F375B81597E
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1B65284989
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02DD31759;
	Sat, 16 Dec 2023 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNZEW0io"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14E831747
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-20389ff9cc8so495872fac.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734279; x=1703339079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fm10TTUq6mWW/19mEp6XGWD63KvKGyPKlCPKzISaymg=;
        b=PNZEW0ioBQ0wZoZ5h7bcWuxV4iwQOPpPb4cumlhWkSKbb9XrQyQ0nMpaRxWIlwhWYx
         AxUeeWPyzOcrhm5qBF/pNCvgs/5ISrwmnpxnxJOYwk0NVzRB9XBPqJT213ILtlwTakBE
         TcWbTKRTzJbZZ+1NDjO0Ad38kOYgfXk1Gx4r287CAju1U1fI4r3pdFwnNH4/OdPO59Sv
         Ftdt71V1jycjunmsveQjvEdF0rdB9pZ6mqdqhH1Ynt72VSBNc0U2E2AabW44WBXwS3BK
         bGKyMOv3TvwQtewZFuuEC3MDEyUohI5UXdbeqm6HcHIjJi/3YGGADShV1qhBo1oMiSm4
         1eTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734279; x=1703339079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fm10TTUq6mWW/19mEp6XGWD63KvKGyPKlCPKzISaymg=;
        b=cZaRVBkcWKQbszsPEoMTyIYXaAOYN7aqQQflQENTOpt4ztV+olt4XDxDIiDiFeojOw
         729vWo5uUMqKvwiK/JDUho0OIUydo/5BAYgKNw8A5BGSjZc2uRplKd4bLubZvZVymlmn
         o9dO/LcBGgk6Ko0gYX9icJi/L9n0n+hwJc94Rfh3YlYWMZBi4nKNhYRj+PBOCnNExYCA
         sV6nqRQkVPt08hx35EivLKxsBki/njAGnKf/inH7ReVcuZcH9J4+c3Qh0ANqKcZdzyd3
         ioX5G2pGuWs86g6tqdP5vtW8bO0fwADo/42gCMIGlQtXo2Jp/F+yu7ZxgusDWQU1B46f
         Z2mg==
X-Gm-Message-State: AOJu0YyvePY9V6+NaCCTdtlF2ysJg9IIS//XFqzxqDMLGZEg+aU0s/Pu
	3ZK3YEbK7KHhsJPq4LRSlHY4c9g1nVs=
X-Google-Smtp-Source: AGHT+IEu7RSyMnW4RxFNlfg1dfk2N4v3nEjECprIufH7yM1SIl3U9tY/jVgdlxjeUNU+LDNh59sadg==
X-Received: by 2002:a05:6870:206:b0:203:8daa:2c2f with SMTP id j6-20020a056870020600b002038daa2c2fmr1577687oad.45.1702734279517;
        Sat, 16 Dec 2023 05:44:39 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:39 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 20/29] scripts: Accommodate powerpc powernv machine differences
Date: Sat, 16 Dec 2023 23:42:47 +1000
Message-ID: <20231216134257.1743345-21-npiggin@gmail.com>
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

The QEMU powerpc powernv machine has minor differences that must be
accommodated for in output parsing:

- Summary parsing must search more lines of output for the summary
  line, to accommodate OPAL message on shutdown.
- Premature failure testing must tolerate case differences in kernel
  load error message.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/runtime.bash | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 0803d02a..96756a0d 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -9,7 +9,7 @@ FAIL() { echo -ne "\e[31mFAIL\e[0m"; }
 extract_summary()
 {
     local cr=$'\r'
-    tail -3 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
+    tail -5 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
 }
 
 # We assume that QEMU is going to work if it tried to load the kernel
@@ -18,7 +18,7 @@ premature_failure()
     local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
+        grep -q -e "[Cc]ould not \(load\|open\) kernel" -e "error loading" &&
         return 1
 
     RUNTIME_log_stderr <<< "$log"
-- 
2.42.0


