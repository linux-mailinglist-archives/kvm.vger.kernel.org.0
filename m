Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3257B38C277
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhEUJBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbhEUJAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:00:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3040CC0613CE;
        Fri, 21 May 2021 01:59:27 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 10so14458366pfl.1;
        Fri, 21 May 2021 01:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pvy4uR7MHK/1WKiYT47mbja8P4GqAFt1Aj7E8yW5uXM=;
        b=uSSyhsSraLlsFnFNoDpR1APM1+BRLdPiW2ejCY2rkmTVGpSatp0sZny9Y5G5kCR8TM
         TKLMI2QJyUjLm+N34G62FQ48ZT1inWFJjxfYjuAQj/eLBlMHF6h0MtIktCY4AReuwiVY
         YYtAcCgGfFMXWjat853OCaifrEkgqx5oNpXpsrtj7GRcHiIDchp1efUoz+5mEOBWK/U1
         qERDvMfR1x2F6futuol3O3YJTUHBkaeNjL+WvIEK068ueiXsT1hHqvA3x1K+/5qWFxuH
         hYvLARoWUwATKId0GOEBUY3yQ4zdE/YgvGHjbHiaMHpVJBvYlSrHsbbxZwTk9LLoDZxL
         zIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pvy4uR7MHK/1WKiYT47mbja8P4GqAFt1Aj7E8yW5uXM=;
        b=W9jUEEVKbttBl9j302SlJhAx7M4lSzWo4wwe3e9kzWxKK++QrxoCSdia9YogtTkEEK
         68lXFVMwnKEOGBiMWwY7FaGaK08onFpkV8jWle6BrT7S9KkHVwtOaa6Aej/f1/NRn8/g
         c9YH9QystjtJlLwn5FfNTDijg3EsSsSBWi0Fxj6NY+z0fTTOqRdB0Am8ehlI/fTcWZLk
         z2qv8rCheGLWINuVAhNzy4JxFcTj0JaF3seUOdC9LYL4lElm0b3LG1m4kl9YyBvvbvcA
         XcGMWYMOUn16JluCIOoLtoV3CkKSW+b5oYm5iAza738hJ0Md8OZTrCl4DEFX6Ywfq2LU
         cKsA==
X-Gm-Message-State: AOAM533eERLzguMGwUjSsSmKjzNs+oB6FJ4tl18G+/JPb+xJEL0ycgoO
        wc0gpp++8CIkFZk6+bx6xE0=
X-Google-Smtp-Source: ABdhPJyI3RixIPKBdANr/tzrhRQ72+6Ud//RYD9LHWOb1K8zzj+Dx5JObxX/9FxEakjEy2HXftKsvg==
X-Received: by 2002:a05:6a00:134b:b029:2bf:2c30:ebbd with SMTP id k11-20020a056a00134bb02902bf2c30ebbdmr9256070pfu.74.1621587566672;
        Fri, 21 May 2021 01:59:26 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id q3sm3914489pff.142.2021.05.21.01.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:59:26 -0700 (PDT)
From:   Joe Richey <joerichey94@gmail.com>
To:     trivial@kernel.org
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Sasha Levin <sashal@kernel.org>, Lei Cao <lei.cao@stratus.com>,
        Peter Xu <peterx@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH v2 6/7] tools headers UAPI: Sync pkt_sched.h with the kernel sources
Date:   Fri, 21 May 2021 01:58:47 -0700
Message-Id: <20210521085849.37676-7-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521085849.37676-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <20210521085849.37676-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

It looks like this process isn't automatic for some reason.

This prevents some perf tools warnings and removes use of the
BIT() macro which isn't present for UAPI headers.

Signed-off-by: Joe Richey <joerichey@google.com>
---
 tools/include/uapi/linux/pkt_sched.h | 122 ++++++++++++++++++++++++---
 1 file changed, 112 insertions(+), 10 deletions(-)

diff --git a/tools/include/uapi/linux/pkt_sched.h b/tools/include/uapi/linux/pkt_sched.h
index 5c903abc9fa5..79a699f106b1 100644
--- a/tools/include/uapi/linux/pkt_sched.h
+++ b/tools/include/uapi/linux/pkt_sched.h
@@ -2,6 +2,7 @@
 #ifndef __LINUX_PKT_SCHED_H
 #define __LINUX_PKT_SCHED_H
 
+#include <linux/const.h>
 #include <linux/types.h>
 
 /* Logical priority bands not depending on specific packet scheduler.
@@ -255,6 +256,9 @@ enum {
 	TCA_RED_PARMS,
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
+	TCA_RED_FLAGS,		/* bitfield32 */
+	TCA_RED_EARLY_DROP_BLOCK, /* u32 */
+	TCA_RED_MARK_BLOCK,	/* u32 */
 	__TCA_RED_MAX,
 };
 
@@ -267,12 +271,28 @@ struct tc_red_qopt {
 	unsigned char   Wlog;		/* log(W)		*/
 	unsigned char   Plog;		/* log(P_max/(qth_max-qth_min))	*/
 	unsigned char   Scell_log;	/* cell size for idle damping */
+
+	/* This field can be used for flags that a RED-like qdisc has
+	 * historically supported. E.g. when configuring RED, it can be used for
+	 * ECN, HARDDROP and ADAPTATIVE. For SFQ it can be used for ECN,
+	 * HARDDROP. Etc. Because this field has not been validated, and is
+	 * copied back on dump, any bits besides those to which a given qdisc
+	 * has assigned a historical meaning need to be considered for free use
+	 * by userspace tools.
+	 *
+	 * Any further flags need to be passed differently, e.g. through an
+	 * attribute (such as TCA_RED_FLAGS above). Such attribute should allow
+	 * passing both recent and historic flags in one value.
+	 */
 	unsigned char	flags;
 #define TC_RED_ECN		1
 #define TC_RED_HARDDROP		2
 #define TC_RED_ADAPTATIVE	4
+#define TC_RED_NODROP		8
 };
 
+#define TC_RED_HISTORIC_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
+
 struct tc_red_xstats {
 	__u32           early;          /* Early drops */
 	__u32           pdrop;          /* Drops due to queue limits */
@@ -894,6 +914,12 @@ enum {
 
 	TCA_FQ_CE_THRESHOLD,	/* DCTCP-like CE-marking threshold */
 
+	TCA_FQ_TIMER_SLACK,	/* timer slack */
+
+	TCA_FQ_HORIZON,		/* time horizon in us */
+
+	TCA_FQ_HORIZON_DROP,	/* drop packets beyond horizon, or cap their EDT */
+
 	__TCA_FQ_MAX
 };
 
@@ -913,6 +939,8 @@ struct tc_fq_qd_stats {
 	__u32	throttled_flows;
 	__u32	unthrottle_latency_ns;
 	__u64	ce_mark;		/* packets above ce_threshold */
+	__u64	horizon_drops;
+	__u64	horizon_caps;
 };
 
 /* Heavy-Hitter Filter */
@@ -950,19 +978,56 @@ enum {
 	TCA_PIE_BETA,
 	TCA_PIE_ECN,
 	TCA_PIE_BYTEMODE,
+	TCA_PIE_DQ_RATE_ESTIMATOR,
 	__TCA_PIE_MAX
 };
 #define TCA_PIE_MAX   (__TCA_PIE_MAX - 1)
 
 struct tc_pie_xstats {
-	__u32 prob;             /* current probability */
-	__u32 delay;            /* current delay in ms */
-	__u32 avg_dq_rate;      /* current average dq_rate in bits/pie_time */
-	__u32 packets_in;       /* total number of packets enqueued */
-	__u32 dropped;          /* packets dropped due to pie_action */
-	__u32 overlimit;        /* dropped due to lack of space in queue */
-	__u32 maxq;             /* maximum queue size */
-	__u32 ecn_mark;         /* packets marked with ecn*/
+	__u64 prob;			/* current probability */
+	__u32 delay;			/* current delay in ms */
+	__u32 avg_dq_rate;		/* current average dq_rate in
+					 * bits/pie_time
+					 */
+	__u32 dq_rate_estimating;	/* is avg_dq_rate being calculated? */
+	__u32 packets_in;		/* total number of packets enqueued */
+	__u32 dropped;			/* packets dropped due to pie_action */
+	__u32 overlimit;		/* dropped due to lack of space
+					 * in queue
+					 */
+	__u32 maxq;			/* maximum queue size */
+	__u32 ecn_mark;			/* packets marked with ecn*/
+};
+
+/* FQ PIE */
+enum {
+	TCA_FQ_PIE_UNSPEC,
+	TCA_FQ_PIE_LIMIT,
+	TCA_FQ_PIE_FLOWS,
+	TCA_FQ_PIE_TARGET,
+	TCA_FQ_PIE_TUPDATE,
+	TCA_FQ_PIE_ALPHA,
+	TCA_FQ_PIE_BETA,
+	TCA_FQ_PIE_QUANTUM,
+	TCA_FQ_PIE_MEMORY_LIMIT,
+	TCA_FQ_PIE_ECN_PROB,
+	TCA_FQ_PIE_ECN,
+	TCA_FQ_PIE_BYTEMODE,
+	TCA_FQ_PIE_DQ_RATE_ESTIMATOR,
+	__TCA_FQ_PIE_MAX
+};
+#define TCA_FQ_PIE_MAX   (__TCA_FQ_PIE_MAX - 1)
+
+struct tc_fq_pie_xstats {
+	__u32 packets_in;	/* total number of packets enqueued */
+	__u32 dropped;		/* packets dropped due to fq_pie_action */
+	__u32 overlimit;	/* dropped due to lack of space in queue */
+	__u32 overmemory;	/* dropped due to lack of memory in queue */
+	__u32 ecn_mark;		/* packets marked with ecn */
+	__u32 new_flow_count;	/* count of new flows created by packets */
+	__u32 new_flows_len;	/* count of flows in new list */
+	__u32 old_flows_len;	/* count of flows in old list */
+	__u32 memory_usage;	/* total memory across all queues */
 };
 
 /* CBS */
@@ -989,8 +1054,9 @@ struct tc_etf_qopt {
 	__s32 delta;
 	__s32 clockid;
 	__u32 flags;
-#define TC_ETF_DEADLINE_MODE_ON	BIT(0)
-#define TC_ETF_OFFLOAD_ON	BIT(1)
+#define TC_ETF_DEADLINE_MODE_ON	_BITUL(0)
+#define TC_ETF_OFFLOAD_ON	_BITUL(1)
+#define TC_ETF_SKIP_SOCK_CHECK	_BITUL(2)
 };
 
 enum {
@@ -1022,6 +1088,7 @@ enum {
 	TCA_CAKE_INGRESS,
 	TCA_CAKE_ACK_FILTER,
 	TCA_CAKE_SPLIT_GSO,
+	TCA_CAKE_FWMARK,
 	__TCA_CAKE_MAX
 };
 #define TCA_CAKE_MAX	(__TCA_CAKE_MAX - 1)
@@ -1148,6 +1215,19 @@ enum {
 
 #define TCA_TAPRIO_SCHED_MAX (__TCA_TAPRIO_SCHED_MAX - 1)
 
+/* The format for the admin sched (dump only):
+ * [TCA_TAPRIO_SCHED_ADMIN_SCHED]
+ *   [TCA_TAPRIO_ATTR_SCHED_BASE_TIME]
+ *   [TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST]
+ *     [TCA_TAPRIO_ATTR_SCHED_ENTRY]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_CMD]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_GATES]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
+ */
+
+#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	_BITUL(0)
+#define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	_BITUL(1)
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1156,9 +1236,31 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY, /* single entry */
 	TCA_TAPRIO_ATTR_SCHED_CLOCKID, /* s32 */
 	TCA_TAPRIO_PAD,
+	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
+	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
+	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
+	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
+	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
 #define TCA_TAPRIO_ATTR_MAX (__TCA_TAPRIO_ATTR_MAX - 1)
 
+/* ETS */
+
+#define TCQ_ETS_MAX_BANDS 16
+
+enum {
+	TCA_ETS_UNSPEC,
+	TCA_ETS_NBANDS,		/* u8 */
+	TCA_ETS_NSTRICT,	/* u8 */
+	TCA_ETS_QUANTA,		/* nested TCA_ETS_QUANTA_BAND */
+	TCA_ETS_QUANTA_BAND,	/* u32 */
+	TCA_ETS_PRIOMAP,	/* nested TCA_ETS_PRIOMAP_BAND */
+	TCA_ETS_PRIOMAP_BAND,	/* u8 */
+	__TCA_ETS_MAX,
+};
+
+#define TCA_ETS_MAX (__TCA_ETS_MAX - 1)
+
 #endif
-- 
2.31.1

