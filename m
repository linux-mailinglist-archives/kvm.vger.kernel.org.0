Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C87549D8D1
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 04:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbiA0DJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 22:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiA0DJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 22:09:10 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549F6C061747
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:10 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z20-20020aa791d4000000b004bd024eaf19so863410pfa.16
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rhk6j9gRndhFt7iP2TVyhddxWPk9PhYFxYC5q91Zsdg=;
        b=SlbmbPBXQl3T5K8eTfGmwRXq6TK2VXIVS9+ikrXB+LONl76upQutz96Nnbl3V8s4AK
         IsnEVOel9bzyKLraIAKq45m0mEXDhmGyD9mbeTpQnae4yLM6+08L/1Dsd3csDVHb+Iy7
         hfjk+5eAvMV6MCPp2WEwM/tCk6oD4iK3M8CbfHr8tQy5KsQd5OHlpXwNBKWTxhL+UNeE
         KkCqs13x0XwW2M1PFzdHP8ATcKS3W6+ZbUiktiW3h4Hza55o7irQFviycZDyEukr3Mar
         Bg9lPj2EYoewe+nx1A6b1sde0Fe5/OBJANfTm/bpDIFlt8PPULq67cWQVEbqDloBbPc8
         3ZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rhk6j9gRndhFt7iP2TVyhddxWPk9PhYFxYC5q91Zsdg=;
        b=0dRxdcn0JLDf6c/TD3rmOc/2nJbQq6tsFAS74G0uESBhSN+F/ehDqmSOqfHG2vFJCt
         1KeAgCpCXjej1BMa+mB+liYgg0A2rI5FjpgIO7Cb9yPQ20Higg/raoRGLFwngM1MwOA/
         +dYYSEnVxYuZVs+OmNSOXaS1kQgmylhWYr91+Wu3q23t7fJej2ZCVsDogAxWky6nS9AG
         i8VW99AFxOJFBRliF5CTEH0LUIbXAkNSOYZ5eO/FqaIVdSolCybhmzuZusjS1n4y2th1
         snW6Q9deB9yGqKKsDcmqtmlOPZcAHU941WgIPO2z8OEczgXWZZMWYjHq1PXrjRkQIL0/
         MJPw==
X-Gm-Message-State: AOAM533MgHL6MkRfgJluzqdiEz112VZQtlD1kap/JQ6mjRo10XEOqbrp
        hX8dHeHZvCty5WqN8pGIrEieo8rnX0x5z67GQhD2+abAYNzmceimVGUqu9OB2Nm8RHuQvC+URPD
        n/xTK2UTXpwW+ipdnXkVEBd97uibFYDanK6l9iM3zaYV8gqU23TWH7mRBc+/Rm7g=
X-Google-Smtp-Source: ABdhPJwZTHG96HGAEawR6UBfAwQW4vQacgQNfKo91OhKJ5XB4h7q2TSUyIekjn2aqbEm8YuK2Gbf0EWzVhIrtQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:10c6:: with SMTP id
 d6mr1723120pfu.42.1643252949597; Wed, 26 Jan 2022 19:09:09 -0800 (PST)
Date:   Wed, 26 Jan 2022 19:08:57 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 4/5] kvm: selftests: aarch64: fix some vgic related comments
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 10 ++++++----
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 0106fc464afe..f0230711fbe9 100644
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
@@ -503,7 +505,8 @@ static void guest_code(struct test_args *args)
 		test_injection_failure(args, f);
 	}
 
-	/* Restore the active state of IRQs. This would happen when live
+	/*
+	 * Restore the active state of IRQs. This would happen when live
 	 * migrating IRQs in the middle of being handled.
 	 */
 	for_each_supported_activate_fn(args, set_active_fns, f)
@@ -840,7 +843,8 @@ int main(int argc, char **argv)
 		}
 	}
 
-	/* If the user just specified nr_irqs and/or gic_version, then run all
+	/*
+	 * If the user just specified nr_irqs and/or gic_version, then run all
 	 * combinations.
 	 */
 	if (default_args) {
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index e4945fe66620..263bf3ed8fd5 100644
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
@@ -160,8 +161,9 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
 	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
-	/* Some registers like IROUTER are 64 bit long. Those are currently not
-	 * supported by readl nor writel, so just asserting here until then.
+	/*
+	 * This function does not support 64 bit accesses. Just asserting here
+	 * until we implement readq/writeq.
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

