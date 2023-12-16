Return-Path: <kvm+bounces-4634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 514A7815986
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDDC5B2416F
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACDE32C6B;
	Sat, 16 Dec 2023 13:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrJM6vPa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AFA328B1
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-35f761ef078so7649475ab.2
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734308; x=1703339108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=icClGOC13RpCndO6jcPh9sEaLH/R88jTwAqzXHDwgMY=;
        b=VrJM6vPaqSxLCfprEu3OuN5alR0dRkJVJs69w6akEyucDoOg9P2ARksvyBKnLf7e3x
         GWm8eGBN19mwbtD1agx6+bGp5peeWbSh0UHSrJsIilVtTIF2ZI08JqKVjD1AcKn3dk9d
         P9tFMnuNmW8600bCZ6/YpGMOepDoGKIV/J45dUfV3kjluMiA/XxluP3OluVqG9/9WdvC
         dBVCXgC2DwbEK+pGDeM/fholbSJM2se5D3u44AIGFQNZW5yWv3SezIiWJhVEyd+PvhHL
         W4cvas3PARzOSrYg1txOmh3n5jP5eTiAOrZuy7O+KrRwhD0KamMZ8UCtzE43yQvH4ekI
         jvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734308; x=1703339108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=icClGOC13RpCndO6jcPh9sEaLH/R88jTwAqzXHDwgMY=;
        b=S2kXCQo5cAAIhsChTTSNYsboOub4DiaW6FcMeKJlSwQI2b6DJFk8agTx9XlRq86lc2
         lNAP0+aUOENrct0RV2RkrvFvS4xNAWWa/7tRuuF9FTph3zhbroZLVmSVOC/E59dKUBEt
         M/bhTR6bEGNVHgm4H4zFdLdZ81+EHmHhvVo51yX6ucV9WigrGc4gtmhgQGhIfPjRTOsh
         oB/Dgl2bSOx2DDSwlio4jikAmsFLWnuPFwE3jcIwGhLJjWL+ejaJZkeqwnFnjDEHun6Q
         TEzMnzxX0tlXxvKn1qWDMYOfTQPFLTwxam+P0jEdZFyWZoAN017vwakqj4me0uPa/6+i
         rQRg==
X-Gm-Message-State: AOJu0YwHN0o8hGb4z9fbGE7sjhHvkq1ud7h/9sFL8v87k3hHauKOAYGe
	OY9xDTw2VftMizt+VhdLkCqdFcR3Res=
X-Google-Smtp-Source: AGHT+IGwXFyNUnZi+4S3PALNqxJ2TQNYMTTxNL950MVsIpVv59psCBNIdlrTYt/cp3QyHiZHmdxWFQ==
X-Received: by 2002:a05:6e02:1bad:b0:35d:62f2:1f45 with SMTP id n13-20020a056e021bad00b0035d62f21f45mr20860836ili.20.1702734308334;
        Sat, 16 Dec 2023 05:45:08 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:45:08 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 27/29] powerpc: Avoid using larx/stcx. in spinlocks when only one CPU is running
Date: Sat, 16 Dec 2023 23:42:54 +1000
Message-ID: <20231216134257.1743345-28-npiggin@gmail.com>
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

The test harness uses spinlocks if they are implemented with larx/stcx.
it can prevent some test scenarios such as testing migration of a
reservation.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/smp.h    |  1 +
 lib/powerpc/smp.c        |  6 ++++++
 lib/powerpc/spinlock.c   | 28 ++++++++++++++++++++++++++++
 lib/ppc64/asm/spinlock.h |  7 ++++++-
 powerpc/Makefile.common  |  1 +
 5 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 lib/powerpc/spinlock.c

diff --git a/lib/powerpc/asm/smp.h b/lib/powerpc/asm/smp.h
index 163bbeec..e2c03295 100644
--- a/lib/powerpc/asm/smp.h
+++ b/lib/powerpc/asm/smp.h
@@ -19,5 +19,6 @@ void local_ipi_disable(void);
 void send_ipi(int cpu_id);
 
 extern int nr_cpus_online;
+extern bool multithreaded;
 
 #endif /* _ASMPOWERPC_SMP_H_ */
diff --git a/lib/powerpc/smp.c b/lib/powerpc/smp.c
index 96e3219a..b473ba41 100644
--- a/lib/powerpc/smp.c
+++ b/lib/powerpc/smp.c
@@ -280,6 +280,8 @@ static void start_each_secondary(int fdtnode, u64 regval __unused, void *info)
 	datap->nr_started += start_core(fdtnode, datap->entry);
 }
 
+bool multithreaded = false;
+
 /*
  * Start all stopped cpus on the guest at entry with register 3 set to r3
  * We expect that we come in with only one thread currently started
@@ -293,8 +295,10 @@ bool start_all_cpus(secondary_entry_fn entry)
 
 	memset(start_secondary_cpus, 0xff, sizeof(start_secondary_cpus));
 
+	assert(!multithreaded);
 	assert(nr_cpus_online == 1);
 
+	multithreaded = true;
 	nr_started = 0;
 	nr_cpus_present = 0;
 	ret = dt_for_each_cpu_node(start_each_secondary, &data);
@@ -305,6 +309,8 @@ bool start_all_cpus(secondary_entry_fn entry)
 
 void stop_all_cpus(void)
 {
+	assert(multithreaded);
 	while (nr_cpus_online > 1)
 		cpu_relax();
+	multithreaded = false;
 }
diff --git a/lib/powerpc/spinlock.c b/lib/powerpc/spinlock.c
new file mode 100644
index 00000000..238549f1
--- /dev/null
+++ b/lib/powerpc/spinlock.c
@@ -0,0 +1,28 @@
+#include <asm/spinlock.h>
+#include <asm/smp.h>
+
+/*
+ * Skip the atomic when single-threaded, which helps avoid larx/stcx. in
+ * the harness when testing tricky larx/stcx. sequences (e.g., migration
+ * vs reservation).
+ */
+void spin_lock(struct spinlock *lock)
+{
+	if (!multithreaded) {
+		assert(lock->v == 0);
+		lock->v = 1;
+	} else {
+		while (__sync_lock_test_and_set(&lock->v, 1))
+			;
+	}
+}
+
+void spin_unlock(struct spinlock *lock)
+{
+	assert(lock->v == 1);
+	if (!multithreaded) {
+		lock->v = 0;
+	} else {
+		__sync_lock_release(&lock->v);
+	}
+}
diff --git a/lib/ppc64/asm/spinlock.h b/lib/ppc64/asm/spinlock.h
index f59eed19..b952386d 100644
--- a/lib/ppc64/asm/spinlock.h
+++ b/lib/ppc64/asm/spinlock.h
@@ -1,6 +1,11 @@
 #ifndef _ASMPPC64_SPINLOCK_H_
 #define _ASMPPC64_SPINLOCK_H_
 
-#include <asm-generic/spinlock.h>
+struct spinlock {
+	unsigned int v;
+};
+
+void spin_lock(struct spinlock *lock);
+void spin_unlock(struct spinlock *lock);
 
 #endif /* _ASMPPC64_SPINLOCK_H_ */
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index f9dd937a..caa807f2 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -47,6 +47,7 @@ cflatobjs += lib/powerpc/rtas.o
 cflatobjs += lib/powerpc/processor.o
 cflatobjs += lib/powerpc/handlers.o
 cflatobjs += lib/powerpc/smp.o
+cflatobjs += lib/powerpc/spinlock.o
 
 OBJDIRS += lib/powerpc
 
-- 
2.42.0


