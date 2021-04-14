Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC4C35F557
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 15:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351648AbhDNNoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 09:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351623AbhDNNos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 09:44:48 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 278D2611F2;
        Wed, 14 Apr 2021 13:44:27 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lWfof-007RSZ-GQ; Wed, 14 Apr 2021 14:44:25 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, nathan@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 5/5] perf: Get rid of oprofile leftovers
Date:   Wed, 14 Apr 2021 14:44:09 +0100
Message-Id: <20210414134409.1266357-6-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414134409.1266357-1-maz@kernel.org>
References: <20210414134409.1266357-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, mark.rutland@arm.com, will@kernel.org, dalias@libc.org, ysato@users.sourceforge.jp, peterz@infradead.org, acme@kernel.org, borntraeger@de.ibm.com, hca@linux.ibm.com, nathan@kernel.org, viresh.kumar@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

perf_pmu_name() and perf_num_counters() are unused. Drop them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/perf_event.h | 2 --
 kernel/events/core.c       | 5 -----
 2 files changed, 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3f7f89ea5e51..51154ed9a206 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -951,8 +951,6 @@ extern void perf_event_itrace_started(struct perf_event *event);
 extern int perf_pmu_register(struct pmu *pmu, const char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
-extern int perf_num_counters(void);
-extern const char *perf_pmu_name(void);
 extern void __perf_event_task_sched_in(struct task_struct *prev,
 				       struct task_struct *task);
 extern void __perf_event_task_sched_out(struct task_struct *prev,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 03db40f6cba9..88cb0ba5690b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -580,11 +580,6 @@ static u64 perf_event_time(struct perf_event *event);
 
 void __weak perf_event_print_debug(void)	{ }
 
-extern __weak const char *perf_pmu_name(void)
-{
-	return "pmu";
-}
-
 static inline u64 perf_clock(void)
 {
 	return local_clock();
-- 
2.29.2

