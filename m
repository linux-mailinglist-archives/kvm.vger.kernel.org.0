Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC19D52BC46
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbiERNZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbiERNZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625081B5FAB;
        Wed, 18 May 2022 06:25:21 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r71so2175126pgr.0;
        Wed, 18 May 2022 06:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xBJDPO61I3gQO/bIk0UDIpqOBCWbyudg+XjoFP7FP9A=;
        b=keX0WaI+LV/BlyfDcr9BDjkzRCbHRKJZjLtphA4b01LMVaetwqa4xD5OoNd5AfSFiI
         fh/tiVyzNmm6AejOOmAsVG0HC5+Gow8nfCtwur675txVYCYhNHNIrWspbGWGkuTxq+Ju
         3cRM2/Tp7iaCwGIsNGENYaCFFceNjlL7Q82tLL2wDRletJpe8L7ypsIK+TqBl4W+/+l8
         LhDRsVJfEAD5/cTbL73e2JcRcbdD9qm2u/3V88tQv6GyZACrHgAnlcxxebFZARXrFS7e
         1jv3FdNCFsHsAQT1GTjmAG8VUf6DF9/81H2vo8BZEVkL+/BfPwLbwOM3fR23KOzX0vmj
         J1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xBJDPO61I3gQO/bIk0UDIpqOBCWbyudg+XjoFP7FP9A=;
        b=xW/gmjao2NArw70aWcDAaSwzmGvhvrjl5P/hLFwmRl4sAwQkaUJJ0Pjvvbd0I8a2L/
         PXSotW5h8US1grYUOV6RCG42CLVIaxsJTKDdWe+a6yb+vq2R6mvRXv3imOihTgAEhLhM
         m6H/7tn1N0Llk8tpcGYwQYx1+d6JGvCUfVsHNQof5ZnPQOYKI8I4caToDpQ/1g5tcyYa
         TvxgKnKFxCVIbvVwYKvCslbRS0GoZMRjFV6TRdalc4TzdrgS8DAQ1c+Cl7llQAFMNI++
         4dNWHBTdq87sj6vzGAf657Ne6Mnql+P1vznnwcj/vM1WSm/ginWYlgO5gy5ATn1PrD3k
         guXQ==
X-Gm-Message-State: AOAM533snQ+l6UsGKbaodaCj+SCucTrvBap7mdma/coh8D7I5R3NRUkg
        jIxOL0EIjcWo2e5ZyWkzgtA=
X-Google-Smtp-Source: ABdhPJzxd5hvtnnjNdVX1po4z9RG9RwHDK6ykHHWMiswwQTeOKFwDbWh8EP1/G92tEEioEtQYLBiRQ==
X-Received: by 2002:a62:6411:0:b0:50a:81df:bfa6 with SMTP id y17-20020a626411000000b0050a81dfbfa6mr28226016pfb.26.1652880320820;
        Wed, 18 May 2022 06:25:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:20 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 01/11] KVM: x86/pmu: Update comments for AMD gp counters
Date:   Wed, 18 May 2022 21:25:02 +0800
Message-Id: <20220518132512.37864-2-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
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
index b5d0c36b869b..3e200b9610f9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -37,7 +37,9 @@ EXPORT_SYMBOL_GPL(kvm_pmu_cap);
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
@@ -49,7 +51,8 @@ EXPORT_SYMBOL_GPL(kvm_pmu_cap);
  *        between pmc and perf counters is as the following:
  *        * Intel: [0 .. INTEL_PMC_MAX_GENERIC-1] <=> gp counters
  *                 [INTEL_PMC_IDX_FIXED .. INTEL_PMC_IDX_FIXED + 2] <=> fixed
- *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters
+ *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] and, for families 15H
+ *          and later, [0 .. AMD64_NUM_COUNTERS_CORE-1] <=> gp counters
  */
 
 static struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
-- 
2.36.1

