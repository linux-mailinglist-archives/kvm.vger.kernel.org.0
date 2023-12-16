Return-Path: <kvm+bounces-4614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4DE581596F
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 039031C21706
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F942DF92;
	Sat, 16 Dec 2023 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLK4yRWx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E612D797
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3ba00fe4e94so1300663b6e.1
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734227; x=1703339027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSpSWzn4652t77dC2if+1ZPCUxLXIz50XDP/r03Pb+U=;
        b=hLK4yRWxVJjjrr41EfDyO0n9ST+cC+7bwDrbjMY8ZezdgdRpQ9DkyJG5rQn6nT+ZbP
         jMh3bvuIq5E5YINvutk4+2gKIkjZdFwoA0PFJfeONewg5NUDBtrW6nKJsbnOzfrENUn9
         iCIBbXRhcjSx+jZ8avGHXfhCZTYQFnm53MzL7ogQTDex04RYa1/6Xlfek8C4+0Zbcc8x
         HOPfVWryXZOn2jujdnrsDVGdBXCch1URI8ehF25HTSnS6ZMxIp52CtdERzva6uCFHwh6
         P8DoV77RnWgPK2nbkuDxJNK6bxJVrStHIVBo0OtpTs4ihE0e6yQ6f7PUMvTt5hqaV4ev
         74Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734227; x=1703339027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mSpSWzn4652t77dC2if+1ZPCUxLXIz50XDP/r03Pb+U=;
        b=lKR1idNYuAj6nKgwbDbP2Ads4p1bn49wKxnIbRw7UP8kowrgPmsY+n/uiqipRCigJs
         SUIuKHSe7RYTdjmX4sT3zN29XJgf0ajw6zK1EkDx2QgAMAKoOiHyPfRmDIpsFntOLVTH
         NSTx1NgYhXtwCIQ1IWtlZB/iu78BrRfs1Sah0AJG+MSoS0vRV5k8a1+H21Ifnnkw6wrS
         d3dVwwQJ1X2TCaMpn+OmLQbwtSwUSOBP0qG/eC5WJ8h2d+Tcw8gOyNYLaRM4nYMIrJAd
         tPNDfmZ9xGvg3Dy+WOzKCMWzrhw9G4D2HJPRXiDFtYk6oaj4AQs6yFe2sOFUMNYw6dvV
         Xmbg==
X-Gm-Message-State: AOJu0YyJDSDvQ6+oFtYFj2OhiHmE5gR3ZFQuVWCm+HeaaT9uM+WE8lH1
	GRu69pam9ol9xnG/+U1khg58Y0NGM+Y=
X-Google-Smtp-Source: AGHT+IEXgq5oEUwnAtybLyjE6VtQ/SWrDJLNuWsTXXJoIvXOVDAykBdwexRdEdtoITO0ovmL8mYCTg==
X-Received: by 2002:a05:6808:3c89:b0:3b8:94c0:87fb with SMTP id gs9-20020a0568083c8900b003b894c087fbmr17350871oib.9.1702734226763;
        Sat, 16 Dec 2023 05:43:46 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:46 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 07/29] powerpc: Add a migration stress tester
Date: Sat, 16 Dec 2023 23:42:34 +1000
Message-ID: <20231216134257.1743345-8-npiggin@gmail.com>
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

This performs 1000 migrations a tight loop to flush out simple issues
in the multiple-migration code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/Makefile.common |  1 +
 powerpc/migrate.c       | 64 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)
 create mode 100644 powerpc/migrate.c

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index f8f47490..a7af225b 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -5,6 +5,7 @@
 #
 
 tests-common = \
+	$(TEST_DIR)/migrate.elf \
 	$(TEST_DIR)/selftest.elf \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
diff --git a/powerpc/migrate.c b/powerpc/migrate.c
new file mode 100644
index 00000000..a9f98c9f
--- /dev/null
+++ b/powerpc/migrate.c
@@ -0,0 +1,64 @@
+/*
+ * Stress Test Migration
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <util.h>
+#include <migrate.h>
+#include <alloc.h>
+#include <asm/handlers.h>
+#include <devicetree.h>
+#include <asm/hcall.h>
+#include <asm/processor.h>
+#include <asm/barrier.h>
+
+static bool do_migrate = false;
+
+static void test_migration(int argc, char **argv)
+{
+	int i;
+
+	for (i = 0; i < 1000; i++) {
+		if (do_migrate)
+			migrate();
+	}
+}
+
+struct {
+	const char *name;
+	void (*func)(int argc, char **argv);
+} hctests[] = {
+	{ "migration", test_migration },
+	{ NULL, NULL }
+};
+
+int main(int argc, char **argv)
+{
+	bool all;
+	int i;
+
+	all = argc == 1 || !strcmp(argv[1], "all");
+
+	for (i = 1; i < argc; i++) {
+		if (!strcmp(argv[i], "-w")) {
+			do_migrate = true;
+			if (!all && argc == 2)
+				all = true;
+		}
+	}
+
+	report_prefix_push("migration");
+
+	for (i = 0; hctests[i].name != NULL; i++) {
+		if (all || strcmp(argv[1], hctests[i].name) == 0) {
+			report_prefix_push(hctests[i].name);
+			hctests[i].func(argc, argv);
+			report_prefix_pop();
+		}
+	}
+
+	report_prefix_pop();
+
+	return report_summary();
+}
-- 
2.42.0


