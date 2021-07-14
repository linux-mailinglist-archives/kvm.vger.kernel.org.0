Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D453C93E3
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 00:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbhGNWdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 18:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbhGNWdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 18:33:39 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16E1C061760
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 4-20020a17090a1a44b029016e8392f557so4506437pjl.5
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1SH2eHkvIHR7S+ZT3V2gNG/O07x0E5G53MVHIgpgwPY=;
        b=kt8Nh8lJ1edTeWYkzpihgo7GN4J/AtheIhIARrjOgNZVxctPLfA1eYOZq0zFkpBhEN
         evUmhJnKGCaQHX6sjoya8K8Pyh43kCukNJKfglTHmJ2AevoZNbxHJ0FZwzCppNLHUOYl
         o1wEb4lTIHS+iQKt+7e9w3F0gI/RqsZtYk8FX0AHvTEP8gnl+7q4VDZunYUF+2jTTWyC
         0Bo7DeecCyGxcZ14RBCvPuAwiIIfmjTzvrIu6U1STqUcgTvZiUpQP5YJk8OjseyLQwmC
         sl6imIed3IIPCUZXXVn0G1wWSCUu27HOUXGTKAHd3P9ZyMHD2B2d6Vbk+tQFSRGp9/JO
         76WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1SH2eHkvIHR7S+ZT3V2gNG/O07x0E5G53MVHIgpgwPY=;
        b=PmA2JvJdh4bEOe/GF2NSPnH6SY3g/RswFlIDtYRABfC/R45NqbaarY5O/CoxlXPfNk
         ULmiAy4jxYtPvEIdr17IFq0GVJYp/yLz5GkA8iMxFPR8nXj8YR+k1fBcLWWg5jdFTOEJ
         3QWJyxBiHi+hMynCd5OPDlrgxvZHuBLGphlLpPxMH5tEk/hj2vMhMhR9iLB+1n8IPLnT
         GOY23YMbHGvp9pec5tGAoop27vTjMMpLBsZBONsW7F6DDIERQo2ZaYKPCU2Fjf7ZT/zQ
         Un5I8pXpod/biaWDnIMcndp+u7RZmGezcvRB4ybW1H2Cnx6E5aQAdsuYqo/xbHAW+Clh
         pjEQ==
X-Gm-Message-State: AOAM533s42y0a7yX4W/4xMvz5Y2UbyD0ERPI/IRVa5VNaEzwLPPhxphu
        BnHEGMxHzgzb5prsTtvEZ+UbRtNC0fdaoluVP9IHsZpcZbP7c/zGVAVjFvWY2BzpxuzTdqKWkRO
        EqrqwQQ5GWE3Ec8JiB+TmDtegMD/XIdZVjO9vG4Jn31dcpYayNPCeXGlkkBjSkaSIUs93RMI=
X-Google-Smtp-Source: ABdhPJwz1IbPrreEDAIH+90UbrfitjSmpVp5MLZrVzwQp95bjjWThrfUyEw+d5hYgGBByjMlivLWjGsX4ZPYuqKp1g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:9895:b029:128:cdfb:f389 with
 SMTP id s21-20020a1709029895b0290128cdfbf389mr184973plp.45.1626301846186;
 Wed, 14 Jul 2021 15:30:46 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:30:33 +0000
In-Reply-To: <20210714223033.742261-1-jingzhangos@google.com>
Message-Id: <20210714223033.742261-7-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210714223033.742261-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 6/6] KVM: stats: Add halt polling related histogram stats
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add three log histogram stats to record the distribution of time spent
on successful polling, failed polling and VCPU wait.
halt_poll_success_hist: Distribution of spent time for a successful poll.
halt_poll_fail_hist: Distribution of spent time for a failed poll.
halt_wait_hist: Distribution of time a VCPU has spent on waiting.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/powerpc/kvm/book3s_hv.c | 16 ++++++++++++++--
 include/linux/kvm_host.h     | 13 ++++++++++++-
 include/linux/kvm_types.h    |  5 +++++
 virt/kvm/kvm_main.c          | 12 ++++++++++++
 4 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 92698a5e54fd..c75a5f46d31d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4146,17 +4146,29 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	if (do_sleep) {
 		vc->runner->stat.generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(start_wait);
+		halt_poll_hist_update(
+				vc->runner->stat.generic.halt_wait_hist,
+				ktime_to_ns(cur) - ktime_to_ns(start_wait));
 		/* Attribute failed poll time */
-		if (vc->halt_poll_ns)
+		if (vc->halt_poll_ns) {
 			vc->runner->stat.generic.halt_poll_fail_ns +=
 				ktime_to_ns(start_wait) -
 				ktime_to_ns(start_poll);
+			halt_poll_hist_update(
+				vc->runner->stat.generic.halt_poll_fail_hist,
+				ktime_to_ns(start_wait) -
+				ktime_to_ns(start_poll));
+		}
 	} else {
 		/* Attribute successful poll time */
-		if (vc->halt_poll_ns)
+		if (vc->halt_poll_ns) {
 			vc->runner->stat.generic.halt_poll_success_ns +=
 				ktime_to_ns(cur) -
 				ktime_to_ns(start_poll);
+			halt_poll_hist_update(
+				vc->runner->stat.generic.halt_poll_success_hist,
+				ktime_to_ns(cur) - ktime_to_ns(start_poll));
+		}
 	}
 
 	/* Adjust poll time */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2414f3c7e6f7..e0db0216e627 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1370,7 +1370,13 @@ struct _kvm_stats_desc {
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),		       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns)
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns),		       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_success_hist,     \
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
+			HALT_POLL_HIST_COUNT)
 
 extern struct dentry *kvm_debugfs_dir;
 
@@ -1387,6 +1393,11 @@ extern const struct _kvm_stats_desc kvm_vm_stats_desc[];
 extern const struct kvm_stats_header kvm_vcpu_stats_header;
 extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
 
+static inline void halt_poll_hist_update(u64 *hist, u64 value)
+{
+	kvm_stats_log_hist_update(hist, HALT_POLL_HIST_COUNT, value);
+}
+
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 {
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index d70f8f475da1..e073cfcabf8c 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -91,6 +91,8 @@ struct kvm_mmu_memory_cache {
 #define LOGHIST_BUCKET_COUNT_LARGE		32
 #define LOGHIST_BUCKET_COUNT_XLARGE		64
 
+#define HALT_POLL_HIST_COUNT			LOGHIST_BUCKET_COUNT_LARGE
+
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
 };
@@ -103,6 +105,9 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
 	u64 halt_wait_ns;
+	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
+	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
+	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 88bf17e7bf51..5fcdffd7d66a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3108,12 +3108,22 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				++vcpu->stat.generic.halt_successful_poll;
 				if (!vcpu_valid_wakeup(vcpu))
 					++vcpu->stat.generic.halt_poll_invalid;
+
+				halt_poll_hist_update(
+				      vcpu->stat.generic.halt_poll_success_hist,
+				      ktime_to_ns(ktime_get()) -
+				      ktime_to_ns(start));
 				goto out;
 			}
 			poll_end = cur = ktime_get();
 		} while (kvm_vcpu_can_poll(cur, stop));
+
+		halt_poll_hist_update(
+				vcpu->stat.generic.halt_poll_fail_hist,
+				ktime_to_ns(ktime_get()) - ktime_to_ns(start));
 	}
 
+
 	prepare_to_rcuwait(&vcpu->wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -3129,6 +3139,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	if (waited) {
 		vcpu->stat.generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(poll_end);
+		halt_poll_hist_update(vcpu->stat.generic.halt_wait_hist,
+				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
 out:
 	kvm_arch_vcpu_unblocking(vcpu);
-- 
2.32.0.402.g57bb445576-goog

