Return-Path: <kvm+bounces-4608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F025815969
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B9DD28558B
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF31D2DF84;
	Sat, 16 Dec 2023 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5B9vYhj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69282C69C
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6d099d316a8so1517470b3a.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734202; x=1703339002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cu8pXvZrMvEyGfJqwo7jShQ/A2yK8wN3uOSg+62bGgw=;
        b=Z5B9vYhjiLmxUXHUBcPvztrdpHTo9mQPOHepuPtQAy7BfqHmdNsk+26D/CcebHqKro
         cEO66Vms0tJDf7ZZu12Kf14yX2YoxSHRG0M6rE/CKJcUaMbVrLk8sCqaq6eAi3XIheBX
         vlvnrSX/rpcwchhkgCrEML6CeHL8s/rE5jk0EqgGFe3ljiRWdzoJ5J1OyzrlHOuPxtMh
         vWKCNliRnRin2BaNHcUkku84Ej0jfBSH/NrQNmWkpZhHG/F+ESmn34unxn5jxNwepoOc
         N35SQ0BmesRaWXEtEY3Eg+hCWCeMe53teCdHC9XJFK9RhMaoBCs8jqUu242VaazuNmnl
         QDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734202; x=1703339002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cu8pXvZrMvEyGfJqwo7jShQ/A2yK8wN3uOSg+62bGgw=;
        b=OqmPZzTp5DbkuAd/gb8UduZdTPrqN7QIhvsyhUGErHc9O8ZrPZTQkQqD9ox3enDfre
         1TbNPWoyXmyfKzaZUuPvzpmmb5XVt/OIOJbnN7s3ivIIrsEFZ6ox7SX1Gr8Ivdw5OSiB
         i4yVsrI+k22Cp4PupKM+UCX/uila2L6eyb/bcnjqFaQbsBTwBfmPZ9geuRi4GZxsE8ne
         OM2d1cCako3K0F/WaZ/AWtPvMwcLfjXtv8FXKkRZL+qYJnkWDBtnz3gKehG7dyG6kK83
         NgrLsUaL793XrYGFE5mAXEp6HxPOXaOiTyF81IW0rNRb5cUGD9LZ3F17nSxaCD1+F7Kg
         0cBw==
X-Gm-Message-State: AOJu0YxXR9fezjTbOYuP7b/0o3BPJL53fr+IEAb4E7fnuGps1pSk9K4f
	qiuTn1zeqwGrvo0aRswWUrGvBcCq5BY=
X-Google-Smtp-Source: AGHT+IEiHRMq62KMzmdGnFRpRmshtiSJoLYOJvPsJPszWrTjzN8bYf1c0gnjybqQW4DZYo2pugFxdA==
X-Received: by 2002:a05:6a20:4caa:b0:18f:97c:617c with SMTP id fq42-20020a056a204caa00b0018f097c617cmr10932258pzb.121.1702734202709;
        Sat, 16 Dec 2023 05:43:22 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:22 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 01/29] arch-run: Clean up temporary files properly
Date: Sat, 16 Dec 2023 23:42:28 +1000
Message-ID: <20231216134257.1743345-2-npiggin@gmail.com>
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

Migration files weren't being removed when tests were interrupted.
This seems to improve the situation.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0864360..f22ead6f 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -134,12 +134,14 @@ run_migration ()
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
+
+	# race here between file creation and trap
+	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
+	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
+
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
@@ -211,8 +213,8 @@ run_panic ()
 
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${qmp}' RETURN EXIT
+	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
+	trap "rm -f ${qmp}" RETURN EXIT
 
 	# start VM stopped so we don't miss any events
 	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
-- 
2.42.0


