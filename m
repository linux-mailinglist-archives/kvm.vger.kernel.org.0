Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263FF4FB79A
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344448AbiDKJiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344443AbiDKJiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:00 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77AF17061;
        Mon, 11 Apr 2022 02:35:46 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h5so12745615pgc.7;
        Mon, 11 Apr 2022 02:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4TBdVKiMZGgqW7QCg6Hmi31rhc6KOuzjce0DwU5k9a4=;
        b=kRV08x7jnBBaAy8cGOSdHBNOy5+hfaeyDC2YtOZA73B6lL3hKkJAdKJ7Ye9JakgHjI
         XA8eZub1qer5QXTwiMlrxx/ZkobDfAs5Vs/+ift+jPL3bud/p2Go52nI64a5B0UuTkHo
         /DOWQefB3GLK2nyItBtzu5Bk/qL7tl7ZAZccy1BUmX0ZwKmluGdbdPpMfphorO/9WhUL
         GUH189vj0fYCNPUpokwf8APtIo9leeVhMCGZQ4Wm0YtXoJco/yRe3h0dyvZBWKw8dRkv
         il/VtAjQmF4maIqeFg2VPPmn9A4jvorSNqUFk6u5Fq0abNfcbK4yn6eLpbWO9OMF60ia
         ES6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4TBdVKiMZGgqW7QCg6Hmi31rhc6KOuzjce0DwU5k9a4=;
        b=3p1sqm8idD+bsCsCSoivr4OZHR38lLm1R1XT6rouuRi+R87jYsH1tQDVbFpnzIUMJp
         6j1Y+w3O6ZAW6TBLsUYrvqON+kMfjQS95H5G2qcJdToIOhRoU2YdgL84VvX5x2S+RVb6
         9B/tMYN6GpA84+zvkw8NWflqBFG66dlqLmlRCmWLpahQG0R9hPso9St8ZcqOdaqCdaH0
         wb11hdnKWyqzRUubayZhUGuMUpoSYuPyxMU94WAn4KMkmHfrHTyswpXtYpJ+703x+eh7
         pSwFAN0PffANvR7VToo5K8qgp+NS+r4u4EYiPSUMVuGl/5BDjIgOfaXvnrnmQs4r6VBF
         BMyA==
X-Gm-Message-State: AOAM533p8Sxo7xh5IEkvykgnogO32C4ttdvQj/6LCGV6iCjsaJ5a0cK+
        syvn/OqxK9tVIJXavLW8cXRwToi+ljc=
X-Google-Smtp-Source: ABdhPJziX2EdrB3pd2UFPUnclSEVJWo6jjiSs02Eb6LhxIQIGjOD6hplUQCezCbxooUB7S5k0+DypQ==
X-Received: by 2002:a05:6a00:1683:b0:4f7:e497:6a55 with SMTP id k3-20020a056a00168300b004f7e4976a55mr31692166pfc.21.1649669746076;
        Mon, 11 Apr 2022 02:35:46 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:35:45 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 01/11] KVM: x86/pmu: Update comments for AMD gp counters
Date:   Mon, 11 Apr 2022 17:35:27 +0800
Message-Id: <20220411093537.11558-2-likexu@tencent.com>
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

The obsolete comment could more accurately state that AMD platforms
have two base MSR addresses and two different maximum numbers
for gp counters, depending on the X86_FEATURE_PERFCTR_CORE feature.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 618f529f1c4d..b52676f86562 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -34,7 +34,9 @@
  *   However AMD doesn't support fixed-counters;
  * - There are three types of index to access perf counters (PMC):
  *     1. MSR (named msr): For example Intel has MSR_IA32_PERFCTRn and AMD
- *        has MSR_K7_PERFCTRn.
+ *        has MSR_K7_PERFCTRn and, for families 15H and later,
+ *        MSR_F15H_PERF_CTRn, where MSR_F15H_PERF_CTR[0-3] are
+ *        aliased to MSR_K7_PERFCTRn.
  *     2. MSR Index (named idx): This normally is used by RDPMC instruction.
  *        For instance AMD RDPMC instruction uses 0000_0003h in ECX to access
  *        C001_0007h (MSR_K7_PERCTR3). Intel has a similar mechanism, except
@@ -46,7 +48,8 @@
  *        between pmc and perf counters is as the following:
  *        * Intel: [0 .. INTEL_PMC_MAX_GENERIC-1] <=> gp counters
  *                 [INTEL_PMC_IDX_FIXED .. INTEL_PMC_IDX_FIXED + 2] <=> fixed
- *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters
+ *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] and, for families 15H
+ *          and later, [0 .. AMD64_NUM_COUNTERS_CORE-1] <=> gp counters
  */
 
 static struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
-- 
2.35.1

