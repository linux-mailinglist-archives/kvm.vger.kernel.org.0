Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40364FB7AC
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344511AbiDKJio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344518AbiDKJic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57942403C8;
        Mon, 11 Apr 2022 02:36:12 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso4676078pjj.1;
        Mon, 11 Apr 2022 02:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E35Tny3aapo99OcU9iMhnaaw6cc28XBGm/4M8KhWmFU=;
        b=YYNPTEgqrI02DS4XGOC9NtXc2q17hIIJKpN4PKYx9po/Oo9m3sB4FUOLFgzFJjMnin
         cnPY96HpXOoiX+WYiviP9QFaSpnPApquSLsEBiMd/MFUai7QaAw5Wev/eYy9703LwP0h
         ucUH6bzxMKRA+RrZfrL3zDRRCPARwKdsGXV2wU0QjBX3hcr185tK/jH1VVXrxkBA0kvw
         XvF+JWh23W1FTaJGfzi2EM8krSnZ/oxErvfnVV03SldZeZQSfUSlbQcdCFgPGvw9etZf
         4j/zgxzLJFT1w0Mke5Et0X3GhJbHfLTOoDaU0CcvFoECxU/mVMfzZctGbC+oB33dfSft
         UTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E35Tny3aapo99OcU9iMhnaaw6cc28XBGm/4M8KhWmFU=;
        b=7jpX88J0hlBVT2QOWeqkSBW+Bx3Dw9JJLOkJZQcLcfiFzD6jQg7hkTxZ0oKSBeAMUQ
         LA1NU5Hg+uv4IWKN3UAF43G67gz4GHu/JRk9GCAuD/3uDHgNGSqYIfJawGyeVO2/evmp
         tWaaU8ASbzqRK2afnI1DOftD0j2WQ4ANzZS3H1ognIQBYGJ2KQD69lvK9vmnUk/IS5G4
         0MkncR0msyrBp0A/uSe75geH+3rRYAKpkySFegCavhJd+c9NqPVtAblYwF8mvHlhURqI
         bsY1d7gmV0E+l6srYEWEuGWVNUjiZa+JOP5jVhxQttKNyP8Fe/BR2CJSv0eRlMnD1J+g
         X9/A==
X-Gm-Message-State: AOAM531Dro0bVQllmyrUIiPM0RYM1swqW8SuttUIrVq9Z7OlEaz/bRiz
        ZdWQbBSzZ2kRabIAXNqXFNw=
X-Google-Smtp-Source: ABdhPJx/8IfgHFVDc+lXCrEEwPkHiFg9uBDunKK7rRZCO3RfLX49CB8KOD50UZudxkrj3UY9eL9NBA==
X-Received: by 2002:a17:902:8ec3:b0:155:ff17:fb7 with SMTP id x3-20020a1709028ec300b00155ff170fb7mr30949368plo.135.1649669771280;
        Mon, 11 Apr 2022 02:36:11 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:36:11 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 09/11] perf: x86/core: Add interface to query perfmon_event_map[] directly
Date:   Mon, 11 Apr 2022 17:35:35 +0800
Message-Id: <20220411093537.11558-10-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411093537.11558-1-likexu@tencent.com>
References: <20220411093537.11558-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

Currently, we have [intel|knc|p4|p6]_perfmon_event_map on the Intel
platforms and amd_[f17h]_perfmon_event_map on the AMD platforms.

Early clumsy KVM code or other potential perf_event users may have
hard-coded these perfmon_maps (e.g., arch/x86/kvm/svm/pmu.c), so
it would not make sense to program a common hardware event based
on the generic "enum perf_hw_id" once the two tables do not match.

Let's provide an interface for callers outside the perf subsystem to get
the counter config based on the perfmon_event_map currently in use,
and it also helps to save bytes.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/core.c            | 11 +++++++++++
 arch/x86/include/asm/perf_event.h |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index eef816fc216d..091363bc545d 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2996,3 +2996,14 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
+
+u64 perf_get_hw_event_config(int hw_event)
+{
+	int max = x86_pmu.max_events;
+
+	if (hw_event < max)
+		return x86_pmu.event_map(array_index_nospec(hw_event, max));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_get_hw_event_config);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 58d9e4b1fa0a..09ab495d738a 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -477,6 +477,7 @@ struct x86_pmu_lbr {
 };
 
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
+extern u64 perf_get_hw_event_config(int hw_event);
 extern void perf_check_microcode(void);
 extern void perf_clear_dirty_counters(void);
 extern int x86_perf_rdpmc_index(struct perf_event *event);
@@ -486,6 +487,11 @@ static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	memset(cap, 0, sizeof(*cap));
 }
 
+static inline u64 perf_get_hw_event_config(int hw_event)
+{
+	return 0;
+}
+
 static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
 #endif
-- 
2.35.1

