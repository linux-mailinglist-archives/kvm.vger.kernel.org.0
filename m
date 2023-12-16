Return-Path: <kvm+bounces-4613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72AA981596E
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5B1C1C21761
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6842D02B;
	Sat, 16 Dec 2023 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGqXpiU4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CC830644
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3ba2dc0f6b7so1362643b6e.2
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734223; x=1703339023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JpfFN7ncIBGdqptU1/FlLtsZ9ai1Z65NxzA1SGKGTcY=;
        b=jGqXpiU4MlYwbatGvJgufim8yearXALC6Zlr9xhsh0NtvguWRW2W/UHzybv5bxM6+L
         rYALhJ4f+Jf0O+olYkXB9FLH8N7tq/ac5OHeqJtTLzk7Q3v8bHN7KQk0GP2x9yodPjYR
         pn1xc+DC1HlWVsvv4gOGWzKBdV9CCSRvh3S2XZPY18klV773Bec+eKCnwXK9KtZ5NbBQ
         d8eqJgG2ap65sVXhqSCMej5PyB+5b7kgwiRMCRX8LrBGfle8g+5NHa3D8RY8PZosECsW
         kiAkiDUSPplwDDR4b3W0x5xWjcnkVcPWGoK6I9kfzh4RqJWeqxq1w7oTMoQoyjTzkeOF
         kiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734223; x=1703339023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JpfFN7ncIBGdqptU1/FlLtsZ9ai1Z65NxzA1SGKGTcY=;
        b=gceQDE3C4eJoW4hy6O59GtHv4+GJ+sePk1EXVGpJcqZ6Mvut/BtMj6qy0GOEcfGRDS
         MErFtyt1qBk3157+Mn9jIhSFqxBGPpJehzOJLjVdVDwnCeWOgxxQjRvL8IiH6whvHv7b
         JxMH/fl/P9E9q7u6zH20g9UYZv8UPMiqrdqgtLKuH7kHhCUIAtxSAKQlfn/0VmOz+PTl
         hNRwUeU4cFYMGxoOZXH6AiD7Hiw39itS+YF2Yyqh0N8MKkMGYGetVl5bwgbt9YxG6ccY
         WLKQuCk2T9PyE/pGoUPgVQDz+jMWC47iu8tP9+ghBtuvgWA5pHhkPOI8v3jg+tIXcULP
         wpNw==
X-Gm-Message-State: AOJu0Yx93tcOTD1LUOoWJ1xXbsWfd46WSS8VgD8GARMAJ0RsBLlvl0x7
	0mRRfURedxK0qkDiHyWecvkRQNKuuYI=
X-Google-Smtp-Source: AGHT+IEkJDNpkM5EzOkYJcQ3oxV5ZV3nPBZfSSeW1HAIQIfme0McmXAezwp9oz3Ir5CrRRUmZSL72A==
X-Received: by 2002:a05:6808:384f:b0:3ba:175:f190 with SMTP id ej15-20020a056808384f00b003ba0175f190mr21493280oib.53.1702734222737;
        Sat, 16 Dec 2023 05:43:42 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:42 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 06/29] powerpc: Quiet QEMU TCG pseries capability warnings
Date: Sat, 16 Dec 2023 23:42:33 +1000
Message-ID: <20231216134257.1743345-7-npiggin@gmail.com>
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

Quieten this console spam.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/run | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/powerpc/run b/powerpc/run
index b353169f..e469f1eb 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -21,6 +21,11 @@ fi
 
 M='-machine pseries'
 M+=",accel=$ACCEL$ACCEL_PROPS"
+
+if [[ "$ACCEL" == "tcg" ]] ; then
+	M+=",cap-cfpc=broken,cap-sbbc=broken,cap-ibs=broken,cap-ccf-assist=off"
+fi
+
 command="$qemu -nodefaults $M -bios $FIRMWARE"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
-- 
2.42.0


