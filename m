Return-Path: <kvm+bounces-4618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C67815974
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2A0F1F2344E
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FF730352;
	Sat, 16 Dec 2023 13:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxjZjJkt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF042FE0E
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1f060e059a3so1277834fac.1
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734243; x=1703339043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpz81cw6IXL/gUJKQ1JuTJJ/AYFIP4kGeCEMgz+hkck=;
        b=BxjZjJktH6KHJkuJaBZ4LI62CrzGaYqToXEIctsPwBBXO6/+9gZMrBpVITn6ikitZ3
         V4ymfetGX1HFW4tj4Z7Kvq+4fRYkimjguUZ26q31qUXJ1k8mMQmHJPXRao+rN2VKuOAk
         GZ4EIne5ro8Se/0YRyhubxSW84MJtAIBo1cgGwSV+1OgSLLH95L2RBuaJJETQlAqu19v
         Oz26abODTndeB3Bq5pKIwaCb92TKe0E13zXdt/8UuVEhAdvsG+sN8W2ADw8/BZEOiY+3
         iIWD5dgtIMHkhX5z5GP3NIqXCg4LgW6/dITRCLG/pIHr2RK36xJypw2aHop4kvcDj29L
         ijqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734243; x=1703339043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kpz81cw6IXL/gUJKQ1JuTJJ/AYFIP4kGeCEMgz+hkck=;
        b=N4YfcDBajNMVIraAzj+ZUF6biXv8CAdZ6FTcL6mMvqV2o+yQbxsKwLeil68BERps1i
         G3O0A2DqQzOlNml+e51v3N/fd9tPzrC0MrZ0B94htQ6z/bl/Et7fllgOWZc6/3G7eVMH
         QjU8/qFkjLQHDHBeNlxNwNH85yhwokBjsf56HwwDsfLUKxUNRCg1zERbjQyACaO3GIgh
         Dj8Wha+Y7EzwcDwrvSlwrRKaS1XRaKpqdbP29py18FpZWSewXO12TGj82U4U39BWKlcW
         Ip69bBWl8+4lV5KnFxkD41Y1looR6oibRuVfyZ2xWLAhAppc+p6uthgDdwq9zFSlhzes
         iPSg==
X-Gm-Message-State: AOJu0YxcHdHymGmwHrZ5b1qz5dC0AbaQQGXnA/r+cQ/uCD4Zv4EN5KCW
	1MsqkPokA/HnxSO2+RhML14EQJKMYao=
X-Google-Smtp-Source: AGHT+IFg2AwO310R8zzQQs+zdrgcP7ojgiF9wQHDegKwCO7gLz0TdBCsU9sq0SHJCCrdcD8pvmyKoQ==
X-Received: by 2002:a05:6870:2196:b0:1fb:75c:4002 with SMTP id l22-20020a056870219600b001fb075c4002mr15219516oae.98.1702734243197;
        Sat, 16 Dec 2023 05:44:03 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:02 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 11/29] powerpc/sprs: Don't fail changed SPRs that are used by the test harness
Date: Sat, 16 Dec 2023 23:42:38 +1000
Message-ID: <20231216134257.1743345-12-npiggin@gmail.com>
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

SPRs annotated with SPR_HARNESS can change between consecutive reads
because the test harness code has changed them. Avoid failing the
test in this case.

[XER was observed to change after the next changeset to use mdelay.]

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index cd8b472d..01041912 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -557,7 +557,7 @@ int main(int argc, char **argv)
 			if (before[i] >> 32)
 				pass = false;
 		}
-		if (!(sprs[i].type & SPR_ASYNC) && (before[i] != after[i]))
+		if (!(sprs[i].type & (SPR_HARNESS|SPR_ASYNC)) && (before[i] != after[i]))
 			pass = false;
 
 		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32))
-- 
2.42.0


