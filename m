Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BE44CD0AB
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiCDJF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbiCDJFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:05:49 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E475B1A12BD;
        Fri,  4 Mar 2022 01:05:01 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s11so7067300pfu.13;
        Fri, 04 Mar 2022 01:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WrjUW5VLGNs/fY0Lc6IKYNBmqSUBL2TyqO/s8rY+hQQ=;
        b=TUmoVF1v9iIXg7VSU3l1VKdHTPYOK7Zm1Pz/u7Ow2RFx7FwGT+brHeWiSncd9H7VPN
         RPghFmIKE7keb3SEY+Uo2x+qxTlldF1JKumNcygWiGr8M2Y40k5KJgOQn6veeDYcWXBx
         JMJUj2LI2ggj7k4f2nWWBx/90kiE7aoxctb6TfuVz/smfDhlWWB9lPh+EXZGZIaWOTAY
         ySjaGj3OGX+Eifw3p0btfAtCyLn6CY2xwOn+OhcGkWEg6dkjayJ2x1T5PiSbAgU1mWYY
         fJYMNWKajYyZ6/mYCOA8bn0iaBW2ZVJx/7SPsM83JHgCCd36QC8Mm3VP0UeYJ0LwAqzw
         GO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WrjUW5VLGNs/fY0Lc6IKYNBmqSUBL2TyqO/s8rY+hQQ=;
        b=BXQnpl5yBNAJAhGXugAt3vP9s4lZRrvLR9F58ZlkL/8eU1EuYMyOX7IKPVq6aOP9nr
         hikz/fvvxir0nN8u/X+xTDF/+DCK9UaJQjZP/+H9wmRTEIlw2FQ87Foe7Krn85UXRpfa
         WfIIpX0iSyYdAqUFYPqUIuTmKixubfFOjes6NOfcbal/v5fGrwL125eZJFgcaSPv9UK4
         /2FBetXrdkJ/GA8tp6yN/tAVAWgKJJyK2m0RgBuGcG455r+GmUoet519SrX6dGn3GRdD
         1EzTenH6903HXpwBaWjSS20X27lnfb1BG36FzZF0AE5029hRJSS3noFZF+DfABDzCZIU
         weHw==
X-Gm-Message-State: AOAM531SuVjxNjNMUvdXMek8gEiHJ9AsAE3LTTpUMbej9w2qsVcMG0wV
        QDqsDuEfoamWpLeC5ZSMvNk=
X-Google-Smtp-Source: ABdhPJzj3dKFJm8Rzu69Fmgkt13NAeIAatzVx+EFyIuRCWPzHan1QQVTpRHbMzJ0e9J/PALcoBVbtQ==
X-Received: by 2002:a05:6a00:13a4:b0:4ce:118f:a822 with SMTP id t36-20020a056a0013a400b004ce118fa822mr42255390pfg.33.1646384701427;
        Fri, 04 Mar 2022 01:05:01 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:01 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 06/17] x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
Date:   Fri,  4 Mar 2022 17:04:16 +0800
Message-Id: <20220304090427.90888-7-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Peter Zijlstra (Intel)" <peterz@infradead.org>

The value of pebs_counter_mask will be accessed frequently
for repeated use in the intel_guest_get_msrs(). So it can be
optimized instead of endlessly mucking about with branches.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c | 14 ++++++--------
 arch/x86/events/perf_event.h |  1 +
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 820f9fb9339b..7f0bab2f70fd 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2911,10 +2911,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 * counters from the GLOBAL_STATUS mask and we always process PEBS
 	 * events via drain_pebs().
 	 */
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		status &= ~cpuc->pebs_enabled;
-	else
-		status &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	status &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
 
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
@@ -3960,10 +3957,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		arr[0].guest &= ~cpuc->pebs_enabled;
-	else
-		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
 	*nr = 1;
 
 	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
@@ -5667,6 +5661,7 @@ __init int intel_pmu_init(void)
 	x86_pmu.events_mask_len		= eax.split.mask_length;
 
 	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
+	x86_pmu.pebs_capable		= PEBS_COUNTER_MASK;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
@@ -5851,6 +5846,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.lbr_pt_coexist = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.get_event_constraints = glp_get_event_constraints;
@@ -6208,6 +6204,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
@@ -6250,6 +6247,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index bf23cbe4f6cf..9e1bef9c2b0c 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -825,6 +825,7 @@ struct x86_pmu {
 	void		(*pebs_aliases)(struct perf_event *event);
 	unsigned long	large_pebs_flags;
 	u64		rtm_abort_event;
+	u64		pebs_capable;
 
 	/*
 	 * Intel LBR
-- 
2.35.1

