Return-Path: <kvm+bounces-4623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4D3815979
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD2C3281A76
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98F230F8A;
	Sat, 16 Dec 2023 13:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/6a0b5I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FB630CED
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6d9f069e9b0so1396397a34.3
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734263; x=1703339063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRUnkU+g7qRtG9MV7NCG/L4yfLCIdw5pgzKA9HKUSKU=;
        b=X/6a0b5I5KBo0NBR4HWRffp+lUly2cTxdGVJSREdbygyZs6k4esx0mgp5gY4F0OGYw
         3CUw2pSSUCImoeeiblFZ4Kt9ReJkt0qXKlVV/w/Dm1zWWHsc0tn5/AgzgxcVuviMnLVc
         KBDDrSp4VNG0C6Lv4ByCZzDRhpfY/L1a4051hOoVYyq+jOJlDpLuzT2/qMK7lqGrbCGn
         up+Hj7+IbebvFfH3o92kpuLRs4VjCS94AKB9/3qGfUbzDfgf2dajZCbZFDLzm+CIBbC8
         RnF7lJbQMdye7VpV/ko7XdsS+5CkfBNg03mxzWM11GgDEN7YMOb68OaDJ8petzTyyj0k
         EO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734263; x=1703339063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GRUnkU+g7qRtG9MV7NCG/L4yfLCIdw5pgzKA9HKUSKU=;
        b=lOI77KJrV5gbLpNqC5SK4TfjRII38mar3tMkDYcUwsP9VcTM2PtW26B/c98F0B03RX
         9czegNEhgwMVAFWuHmZLAa3NBhPtCvWOgJpkkY005pGdyqFsaT/y3XNNlBFfqaDOeX/L
         NXVXM8kt+6k9l0DkSqqp7w4AAZnCyTc33nwY0/k0wDIfjJBJGCKzwTDoZObUlDRf6JKr
         zkyqC5qB545csKbHXQtQGE9GIojDWygtkA6N4k/H1N66tNUY2/I5vbXCMlPi0K5ZgdTZ
         PyPzLb3YIfP1fxAsM2ozzVQCBTvjtmuUgjpdvVO2NTP+hjh0GUjWNtPiLmkbyOYJyiIn
         ZhpQ==
X-Gm-Message-State: AOJu0Yw+kRe/OzvAwIAXpntFHzLXc/Asc0s6pbziV8r544oOkW8quEPA
	5fxpKIxpLPgP1Bz6UOvs3hLVDF7afL4=
X-Google-Smtp-Source: AGHT+IFal2Q0T3a8RPC2sdfwbSB1Hzulx2S6zDy81QrBYbZwS1rlFsrVCGPsN4M43mq4C0EJYqZ1gA==
X-Received: by 2002:a05:6830:1499:b0:6d9:e7db:7b60 with SMTP id s25-20020a056830149900b006d9e7db7b60mr14145763otq.12.1702734263452;
        Sat, 16 Dec 2023 05:44:23 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:23 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 16/29] powerpc: Set .got section alignment to 256 bytes
Date: Sat, 16 Dec 2023 23:42:43 +1000
Message-ID: <20231216134257.1743345-17-npiggin@gmail.com>
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

Modern powerpc64 toolchains require the .got section have alignment of
256 bytes. Incorrect alignment ends up causing the .data section ELF
load address to move by 8 bytes from its file offset, relative to
previous sections. This is not a problem for the QEMU bios loader used
by the pseries machine, but it is a problem for the powernv machine
using skiboot as the bios and the test programs as a kernel, because the
skiboot ELF loader is crippled:

  * Note that we execute the kernel in-place, we don't actually
  * obey the load informations in the headers. This is expected
  * to work for the Linux Kernel because it's a fairly dumb ELF
  * but it will not work for any ELF binary.

This causes all references to data to be incorrect. Aligning the .got
to 256 bytes prevents this offset skew and allows the skiboot "flat"
loader to work. [I don't know why the .got alignment can cause this
difference in linking.]

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/flat.lds | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/powerpc/flat.lds b/powerpc/flat.lds
index 5eed368d..e07b91c1 100644
--- a/powerpc/flat.lds
+++ b/powerpc/flat.lds
@@ -41,8 +41,7 @@ SECTIONS
     /*
      * tocptr is tocbase + 32K, allowing toc offsets to be +-32K
      */
-    tocptr = . + 32K;
-    .got : { *(.toc) *(.got) }
+    .got : ALIGN(256) { tocptr = . + 32K; *(.toc .got) }
     . = ALIGN(64K);
     edata = .;
     . += 64K;
-- 
2.42.0


