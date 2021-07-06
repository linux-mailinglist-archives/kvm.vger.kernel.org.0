Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780A13BDCAB
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhGFSGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 14:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhGFSGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 14:06:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B022C06175F
        for <kvm@vger.kernel.org>; Tue,  6 Jul 2021 11:04:00 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 4-20020a17090a1a44b029016e8392f557so2137493pjl.5
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 11:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=06jK6cC8nKrdCzhGRJ/lK6pEF1PxjezbNVT/NfdNI74=;
        b=X1vH66OZZ1yQeAmG92wEDD060uD5MSRcVJENlPg1Y7dLlFOdSPlQDIoxMXAGGN7DFt
         4e1zAK/sXYwssb/f8k+NVEFCglpPjxFMNhp8LyDrYR36SvAe/4P4cvNGY1mhAtpOY1FU
         rOIq4fCPwGiCKgt3ovk/Bylet+U16yhHbakivwqLOCcRursdpR1tU37vkJK91COrTNhz
         t+uJToof5nszwFmGJ4J6hHJk0NJZ+Cgu1ZBTbi1H/bYOuQ7k8dLcc7X2RLYbALPTLUpd
         MjXZH4nlDa4vC8zHyDrCZkC30ITqTl+3hH9pR3VjKZZL9c8VMYrqDqSuCqWAZXnd2o7h
         GeWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=06jK6cC8nKrdCzhGRJ/lK6pEF1PxjezbNVT/NfdNI74=;
        b=e2aeI0wVV9BIZBiKNfQzv6lvulC7wX8/yATfc31E0U1vp+320EDfRQjkt3PpHgQUIq
         g59sXoBDijogPxrm2ZAFOphmVN9dRd5gfduaIkt4K2dKswu6i1Y7KlF/2Xg13hbi+rS0
         BL9PKOoyzddC0ztboL9AQPguNVqmwFrtj8X5HCsP6fbjINPj6d0kWUYrSbFmFIU7s9Rk
         4XO/IMTovy9HDk972UJvTow8DcCOQYoHJOEM+qAdXr4Z2RhUmo9rQf2IZak9/higmy+D
         eJSrDeja86GzFm53lOjl8swpMMuzi+6M2cXlTvcFuUojDtkpmwJHMiWlqqZ8JWCwI/y5
         TIEg==
X-Gm-Message-State: AOAM531plWdwIGZhmDr1+IPHUQgybPbHKpmCvrX5LFJoEyVCQgZ/Gc21
        ho4uRZpQxg6YqU9YgrpE1KFHWrr0GCPOEhXtJQS0gh+kCP4k3VgsoXFfFHUPEDj1uqPVfoj6Gad
        MFPd+0dDAJz4qQjFXMkoz3ejgF3Z4r4SrrtSu8hEEUodUZk2iLMVJS923MuvaULaQf+649YI=
X-Google-Smtp-Source: ABdhPJxlrH+MEIDJb4FUshzYpX/hhS7/TQ4b5J9Uzd5ETCu0EzGjPmshJqQu1rG4FKSSEJPJ2y+nfmXv2Bvf9BVWSA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:810b:0:b029:2fe:decd:c044 with
 SMTP id b11-20020aa7810b0000b02902fedecdc044mr21536341pfi.15.1625594639431;
 Tue, 06 Jul 2021 11:03:59 -0700 (PDT)
Date:   Tue,  6 Jul 2021 18:03:50 +0000
In-Reply-To: <20210706180350.2838127-1-jingzhangos@google.com>
Message-Id: <20210706180350.2838127-5-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v1 4/4] KVM: stats: Add halt polling related histogram stats
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

Add simple stats halt_wait_ns to record the time a VCPU has spent on
waiting for all architectures (not just powerpc).
Add three log histogram stats to record the distribution of time spent
on successful polling, failed polling and VCPU wait.
halt_poll_success_hist: Distribution of time spent before a successful
polling.
halt_poll_fail_hist: Distribution of time spent before a failed polling.
halt_wait_hist: Distribution of time a VCPU has spent on waiting.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/powerpc/include/asm/kvm_host.h |  1 -
 arch/powerpc/kvm/book3s.c           |  1 -
 arch/powerpc/kvm/book3s_hv.c        | 20 +++++++++++++++++---
 arch/powerpc/kvm/booke.c            |  1 -
 include/linux/kvm_host.h            |  9 ++++++++-
 include/linux/kvm_types.h           |  4 ++++
 virt/kvm/kvm_main.c                 | 19 +++++++++++++++++++
 7 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 9f52f282b1aa..4931d03e5799 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -103,7 +103,6 @@ struct kvm_vcpu_stat {
 	u64 emulated_inst_exits;
 	u64 dec_exits;
 	u64 ext_intr_exits;
-	u64 halt_wait_ns;
 	u64 halt_successful_wait;
 	u64 dbell_exits;
 	u64 gdbell_exits;
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 5cc6e90095b0..b785f6772391 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -69,7 +69,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
 	STATS_DESC_COUNTER(VCPU, dec_exits),
 	STATS_DESC_COUNTER(VCPU, ext_intr_exits),
-	STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
 	STATS_DESC_COUNTER(VCPU, halt_successful_wait),
 	STATS_DESC_COUNTER(VCPU, dbell_exits),
 	STATS_DESC_COUNTER(VCPU, gdbell_exits),
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index cd544a46183e..103f998cee75 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4144,19 +4144,33 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 
 	/* Attribute wait time */
 	if (do_sleep) {
-		vc->runner->stat.halt_wait_ns +=
+		vc->runner->stat.generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(start_wait);
+		kvm_stats_log_hist_update(
+				vc->runner->stat.generic.halt_wait_hist,
+				LOGHIST_SIZE_LARGE,
+				ktime_to_ns(cur) - ktime_to_ns(start_wait));
 		/* Attribute failed poll time */
-		if (vc->halt_poll_ns)
+		if (vc->halt_poll_ns) {
 			vc->runner->stat.generic.halt_poll_fail_ns +=
 				ktime_to_ns(start_wait) -
 				ktime_to_ns(start_poll);
+			kvm_stats_log_hist_update(
+				vc->runner->stat.generic.halt_poll_fail_hist,
+				LOGHIST_SIZE_LARGE, ktime_to_ns(start_wait) -
+				ktime_to_ns(start_poll));
+		}
 	} else {
 		/* Attribute successful poll time */
-		if (vc->halt_poll_ns)
+		if (vc->halt_poll_ns) {
 			vc->runner->stat.generic.halt_poll_success_ns +=
 				ktime_to_ns(cur) -
 				ktime_to_ns(start_poll);
+			kvm_stats_log_hist_update(
+				vc->runner->stat.generic.halt_poll_success_hist,
+				LOGHIST_SIZE_LARGE,
+				ktime_to_ns(cur) - ktime_to_ns(start_poll));
+		}
 	}
 
 	/* Adjust poll time */
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 5ed6c235e059..977801c83aff 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -67,7 +67,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
 	STATS_DESC_COUNTER(VCPU, dec_exits),
 	STATS_DESC_COUNTER(VCPU, ext_intr_exits),
-	STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
 	STATS_DESC_COUNTER(VCPU, halt_successful_wait),
 	STATS_DESC_COUNTER(VCPU, dbell_exits),
 	STATS_DESC_COUNTER(VCPU, gdbell_exits),
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 356af173114d..268a0ccc9c5f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1369,7 +1369,14 @@ struct _kvm_stats_desc {
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_poll_invalid),		       \
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),		       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_success_hist,     \
+			LOGHIST_SIZE_LARGE),				       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
+			LOGHIST_SIZE_LARGE),				       \
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns),		       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
+			LOGHIST_SIZE_LARGE)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index cc88cd676775..7838a42932c8 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -103,6 +103,10 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_wakeup;
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
+	u64 halt_poll_success_hist[LOGHIST_SIZE_LARGE];
+	u64 halt_poll_fail_hist[LOGHIST_SIZE_LARGE];
+	u64 halt_wait_ns;
+	u64 halt_wait_hist[LOGHIST_SIZE_LARGE];
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3dcc2abbfc60..840b5bece080 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3093,12 +3093,24 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				++vcpu->stat.generic.halt_successful_poll;
 				if (!vcpu_valid_wakeup(vcpu))
 					++vcpu->stat.generic.halt_poll_invalid;
+
+				kvm_stats_log_hist_update(
+				      vcpu->stat.generic.halt_poll_success_hist,
+				      LOGHIST_SIZE_LARGE,
+				      ktime_to_ns(ktime_get()) -
+				      ktime_to_ns(start));
 				goto out;
 			}
 			poll_end = cur = ktime_get();
 		} while (kvm_vcpu_can_poll(cur, stop));
+
+		kvm_stats_log_hist_update(
+				vcpu->stat.generic.halt_poll_fail_hist,
+				LOGHIST_SIZE_LARGE,
+				ktime_to_ns(ktime_get()) - ktime_to_ns(start));
 	}
 
+
 	prepare_to_rcuwait(&vcpu->wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -3111,6 +3123,13 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	}
 	finish_rcuwait(&vcpu->wait);
 	cur = ktime_get();
+	if (waited) {
+		vcpu->stat.generic.halt_wait_ns +=
+			ktime_to_ns(cur) - ktime_to_ns(poll_end);
+		kvm_stats_log_hist_update(vcpu->stat.generic.halt_wait_hist,
+				LOGHIST_SIZE_LARGE,
+				ktime_to_ns(cur) - ktime_to_ns(poll_end));
+	}
 out:
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
-- 
2.32.0.93.g670b81a890-goog

