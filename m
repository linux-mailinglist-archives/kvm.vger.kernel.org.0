Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80ED49536D
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 18:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiATRjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 12:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiATRjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 12:39:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0259BC061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:39:13 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s8-20020a056a00178800b004c480752316so4275161pfg.7
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CTLiJ+83lYrDlIHsDATdvmKA2ZyAMqENkPuhv/61vCM=;
        b=e6mOfDZvTSolwbDSuNOJVSL+TxIsiCr+Gp2jFNaM8e8yk1g1GCGEv7o4hvFyEz49UP
         Jn8Bfz+oe9O6ba1+4JT+l786ax9I6MIGgQe3bqdMg0WCF8L3aZ6qVTSQYw0rNLOS+aY4
         O0nrHAwuCh6zKGOO6t6322kpF7Y3IhDNA51uDF6iCbxlwSp/tT1VRHAmUDFOJrN9Lsx8
         McF/zbTOJqCSPdIGZEFp8CF9gkuFAknybIn7/v8hxbHqb2uunxffVPTW+fJVpxfGzz8G
         KBOvGS/z8I1vTSaD59GHp5W9GoeSUhfG8vvdPfDO3ITmunu3qjfGQ5voPlj+sUbNlj7G
         xNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CTLiJ+83lYrDlIHsDATdvmKA2ZyAMqENkPuhv/61vCM=;
        b=6LbguzTHnC9ycnSv5KPhCM9Y/yTDloTs5utT5+ib6F9JpvNNOU6tzf/F4P3spPQKW1
         ANLw13uHzxx0qtmOHeOV/k4y/ukEbG7ff/48bxfRzcfhNjaSJO819v6Sa4zzqHBpDlCr
         omrySl0L+u/MatlLoNFaLu7ateZs8jurVKiIB4XyRqGKUheHfUzmTf9Dfy49WgepTdzj
         kwBoRHDpgl11NoMKC2AlkZkqRfO+1u13MKn5AskjsNT5NaSDm6k6V4K5T0k899nFwUyC
         xTY/8rlJ7xoXEv7MBKH8afmOIBieziFgueIQvZEh2gEz3CH/pL1N+XNThl2o6q1VViqM
         +CAA==
X-Gm-Message-State: AOAM531bWA2GuRCMXlg1EViQc8DW0Z5znCssjPL6G5XgUknVQ5/X1wQE
        WT+NAGfMoUa49xX6rMJ032qeQXsuVun+mN1oXZ84rclkbmDRuKRR/SBl4oZrYrcokvgXIqe6VxN
        Dv5Lbi94C7eiuHUi0pmmuCc7r5QCwHQSxR9aDG4IHnOZUMu1OVXea4EZc2fGjcVo=
X-Google-Smtp-Source: ABdhPJwjGcqXz/hYyuZbzxhUVMqRBrunnyekQcvGwkFdAnKhWY+rEeikvVJe5wKvJxCWz2VfZFrZMAAri7QrcQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:3546:: with SMTP id
 lt6mr6968371pjb.68.1642700352448; Thu, 20 Jan 2022 09:39:12 -0800 (PST)
Date:   Thu, 20 Jan 2022 09:39:05 -0800
In-Reply-To: <20220120173905.1047015-1-ricarkol@google.com>
Message-Id: <20220120173905.1047015-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220120173905.1047015-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 2/2] kvm: selftests: aarch64: fix some vgic related comments
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the formatting of some comments and the wording of one of them (in
gicv3_access_reg).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 11 +++++++----
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index e6c7d7f8fbd1..258bb5150a07 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
 	uint32_t prio, intid, ap1r;
 	int i;
 
-	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
+	/*
+	 * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
 	 * in descending order, so intid+1 can preempt intid.
 	 */
 	for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
@@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
 		gic_set_priority(intid, prio);
 	}
 
-	/* In a real migration, KVM would restore all GIC state before running
+	/*
+	 * In a real migration, KVM would restore all GIC state before running
 	 * guest code.
 	 */
 	for (i = 0; i < num; i++) {
@@ -503,7 +505,8 @@ static void guest_code(struct test_args args)
 		test_injection_failure(&args, f);
 	}
 
-	/* Restore the active state of IRQs. This would happen when live
+	/*
+	 * Restore the active state of IRQs. This would happen when live
 	 * migrating IRQs in the middle of being handled.
 	 */
 	for_each_supported_activate_fn(&args, set_active_fns, f)
@@ -837,7 +840,8 @@ int main(int argc, char **argv)
 		}
 	}
 
-	/* If the user just specified nr_irqs and/or gic_version, then run all
+	/*
+	 * If the user just specified nr_irqs and/or gic_version, then run all
 	 * combinations.
 	 */
 	if (default_args) {
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index e4945fe66620..93fc35b88410 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -19,7 +19,7 @@ struct gicv3_data {
 	unsigned int nr_spis;
 };
 
-#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
+#define sgi_base_from_redist(redist_base)	(redist_base + SZ_64K)
 #define DIST_BIT				(1U << 31)
 
 enum gicv3_intid_range {
@@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
 {
 	uint32_t val;
 
-	/* All other fields are read-only, so no need to read CTLR first. In
+	/*
+	 * All other fields are read-only, so no need to read CTLR first. In
 	 * fact, the kernel does the same.
 	 */
 	val = split ? (1U << 1) : 0;
@@ -160,8 +161,10 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
 	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
-	/* Some registers like IROUTER are 64 bit long. Those are currently not
-	 * supported by readl nor writel, so just asserting here until then.
+	/*
+	 * This function does not support 64 bit accesses as those are
+	 * currently not supported by readl nor writel, so just asserting here
+	 * until then.
 	 */
 	GUEST_ASSERT(reg_bits == 32);
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index b3a0fca0d780..79864b941617 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -150,7 +150,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 		attr += SZ_64K;
 	}
 
-	/* All calls will succeed, even with invalid intid's, as long as the
+	/*
+	 * All calls will succeed, even with invalid intid's, as long as the
 	 * addr part of the attr is within 32 bits (checked above). An invalid
 	 * intid will just make the read/writes point to above the intended
 	 * register space (i.e., ICPENDR after ISPENDR).
-- 
2.35.0.rc0.227.g00780c9af4-goog

