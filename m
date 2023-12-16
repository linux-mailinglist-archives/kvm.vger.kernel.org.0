Return-Path: <kvm+bounces-4620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12821815976
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6E74B23A7E
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AD53065B;
	Sat, 16 Dec 2023 13:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCbWyARA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EED3064F
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6da5278c6fbso1083512a34.3
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734251; x=1703339051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p6mA8Da/KVG0j3mfhNeKOZZt/rV+ImlF7ZhUN6TmsOA=;
        b=OCbWyARAm5xRbVRe1j1ened1BvbHCVeeO36pWlT0LVOyS1CeVBBXxWH1z8NbOMdcOY
         Dq/WrES/5tDqvC2/yKXPoumOUl96g7Hpms/jwYwZKsTe312B/Wa1DoHqZFXFKZDuV6dK
         AfwphtkJqoSJglMyhUi0/SsxJXI8yuXSvdY05ZQqj/ORrfdDYaELdTyvX6PcCsVwAJJt
         m2lTbDeuGdzfMdy33NEfMoIlo0qhTb+Lh4aApgeF0fhKRQRmisnx1BBCebFmoDfXkN5+
         v2TxCw9ApwPslvICLrVSBRta60V59Adnoa2woplBi//bAUjOTag1kWetnalmDtpnKeFY
         SUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734251; x=1703339051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p6mA8Da/KVG0j3mfhNeKOZZt/rV+ImlF7ZhUN6TmsOA=;
        b=n3vEYXzrVL3qC6tQ3/iqd/TxjSImbaKnhdTTks/yDIKXx5axPIbfz5xEEs5UnTPDtO
         M9jzChOm0+4FqKSDsPRX39OxMI2ndQIa4Rdy2tUpctWWhSB5zl2qZHFdk/WRgeLpa5CM
         vb+vMzF5zIBhPwjYjkSaTALodX6sSKlEGfAdxlMl5iDV8vLrO7J7X9bVqAlfcy2GELzk
         d535B6fFS5QdN73OAEgbBFpN9pa6IEDdvHUcS0Tr4TdQq8+tPE5kyAH8zuZhDhQtvGi1
         hLVXxdqzcmCFoPC1SmHbi31+N5tHcrPyLN0N9ks313DKVJzEpFhpVUgVGrMTRQcsRdHe
         yDzw==
X-Gm-Message-State: AOJu0YxwvkBhRI4TTvIf1vb8zm2Gq4Q/rROOv/RmLzBEwgXnwrlEFiGm
	jvndYYLT7UK3xuMSQgpbFWZcqlkZGrI=
X-Google-Smtp-Source: AGHT+IEjYPcOHlmBgkrPnRtHPBF70ADKtRCD+zMFo2pxOXd6wfI8f9wseEgJGq4OIsCpDjMTpcAN9w==
X-Received: by 2002:a05:6808:118c:b0:3b9:d5ae:5d53 with SMTP id j12-20020a056808118c00b003b9d5ae5d53mr16252673oil.41.1702734251428;
        Sat, 16 Dec 2023 05:44:11 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:11 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 13/29] powerpc: Make interrupt handler error more readable
Date: Sat, 16 Dec 2023 23:42:40 +1000
Message-ID: <20231216134257.1743345-14-npiggin@gmail.com>
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

Installing the same handler twice reports a shifted trap vector
address which is hard to decipher. Print the unshifed address.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index aaf45b68..b4cd5b4c 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -26,7 +26,7 @@ void handle_exception(int trap, void (*func)(struct pt_regs *, void *),
 	trap >>= 8;
 
 	if (func && handlers[trap].func) {
-		printf("exception handler installed twice %#x\n", trap);
+		printf("exception handler installed twice %#x\n", trap << 5);
 		abort();
 	}
 	handlers[trap].func = func;
-- 
2.42.0


