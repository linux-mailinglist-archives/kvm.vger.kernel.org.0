Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7D9695823
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjBNFIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjBNFIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:18 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E8A9F;
        Mon, 13 Feb 2023 21:08:17 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r18so9509418pgr.12;
        Mon, 13 Feb 2023 21:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mkgmsTvgrYNtQjbDBDFN5kFcE4vbYJ1tv8oK7zxv5Y=;
        b=IVwxzEPNcnB0lWTwlDb9WHmZKTkrmo+9ulViN/KrtbCvhqnta+ItEZzq+KNj5v6la7
         F90BL2Ybq9J66h2StYYc/1cE+66I9MZn0Z/WxpEaeRTurkh6cEPJ/YQgzW/M8aIWpF6R
         BcgMXsMU2fvoJo4To+/rJB+MJpTSopkSehwrUX2Y0Q52k/IPrRp7pjCFjqAzYjJcSDy5
         PNX0+4SGQMNnH3yF4Fq1gNsftcrfLEJv+xEzNEQOLYNOBPCnLnn4vOkjvU9H9mTfkUiD
         QGhkGbI+kfhlKbbpyW68k456uXSPe1R5M5sI4/aasnYquZFbS7vSaH0D29D/sNF8+8yo
         mTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mkgmsTvgrYNtQjbDBDFN5kFcE4vbYJ1tv8oK7zxv5Y=;
        b=ZZGX3al/dYfCZvEdo2Y1ORr+xiR5lCZ+0QhDkLjd7sVmj+tj7Emn0+QlRfwrs3cmme
         qMmFkOcCSqMQ4fKEYKAM0N2Y8LbW5jkS3r4jX9AlirZY+E0ME8APjwS93DjFQDHf/ySK
         DcY/Y571HUIHVSBguPEWZpdFdCvzVzbleKH8lkinHsdxkyoCdLCNqeMBpwUfbydGfGFr
         EiS/Lv4lha9hmhY/P+fRjoEDU0cf9uu5Pv7G+CqkBSahMSbAaDjewuRia9y3g6i1M0yg
         2NEiGCTps1EUVRzgafAAAA5qYBOM/2zmEWnfNq35E7KIQyTG0cDO2m3oZsYSr8JfLyXv
         SkGA==
X-Gm-Message-State: AO0yUKVr4g3IDolxyE2AZVZ5h1DQlw9K+k5Ol5Bg9TvVeaKcgfOKoTlA
        E0+c0oBL+/tUJRuIIADXWeI=
X-Google-Smtp-Source: AK7set/Uu7RyP8nLCt9QdCPrB/9FUth6FO5/VR4eyPSQAX75gx4iU+CxmYKNVadfq74FW4Q8wdxn1w==
X-Received: by 2002:a62:4e08:0:b0:5a8:b4a5:ebf3 with SMTP id c8-20020a624e08000000b005a8b4a5ebf3mr1076430pfb.3.1676351297389;
        Mon, 13 Feb 2023 21:08:17 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:17 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: [PATCH v4 01/12] KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
Date:   Tue, 14 Feb 2023 13:07:46 +0800
Message-Id: <20230214050757.9623-2-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The name of function pmc_is_enabled() is a bit misleading. A PMC can
be disabled either by PERF_CLOBAL_CTRL or by its corresponding EVTSEL.
Append global semantics to its name.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7b6c3ba2c8e1..af541c913acd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -93,7 +93,7 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 #undef __KVM_X86_PMU_OP
 }
 
-static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
+static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
 {
 	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
 }
@@ -409,7 +409,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 
 	pmc_pause_counter(pmc);
 
-	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
+	if (!pmc_speculative_in_use(pmc) || !pmc_is_globally_enabled(pmc))
 		goto reprogram_complete;
 
 	if (!check_pmu_event_filter(pmc))
@@ -684,7 +684,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
 		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
-		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
+		if (!pmc || !pmc_is_globally_enabled(pmc) || !pmc_speculative_in_use(pmc))
 			continue;
 
 		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
-- 
2.39.1

