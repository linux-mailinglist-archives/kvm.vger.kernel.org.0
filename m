Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8164BE1DB
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356842AbiBULwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:52:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356815AbiBULwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:52:38 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12DD14092;
        Mon, 21 Feb 2022 03:52:15 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id cp23-20020a17090afb9700b001bbfe0fbe94so5465580pjb.3;
        Mon, 21 Feb 2022 03:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EYBik5vKaVIFlZo9J6mMazAMK3LoDIpMsWLZXB13uOk=;
        b=XUZEfY+Ss2SFYwmWtaY/gWqO79WtoY85K3q0Yp2TErFkdDmhWcGOaaMyUFRTQvr8Aq
         B7YIpwRSX+Kx9/3L4RrBhqEc617owD7vlcdsdkrpXEPZMkkK8x8P8S1GEApl3LWbRdXW
         1bEzTbGuvKxZ2ME3F2BdteMkSfjJvj/IuR4jrsIMKbwGrYbRWAHOaiyo65xDElhRbn91
         tk1xzLL2lVNKtKt2oRMccHdw7R7Uw7cmJUVm1PnaDDNfMoguZkMponcrbLpRzts/wtUE
         BUbfFZCqiGu/vRHO9Cc+T7kyWUQbHeXDTv9GJHyLaGeKMfgGpYHTu/LV1S95m8WsX/mQ
         m9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EYBik5vKaVIFlZo9J6mMazAMK3LoDIpMsWLZXB13uOk=;
        b=MN6pVRwMCCgpmQJtrxoTB4jRDO7QJYYgmcS/rtTXEtNM2gjfaeiLqpyXxYztR7zEJj
         2dcXTRofuZgpKo7RE22jxF4qM1crIgJkwfT1jVl0ATPlCcGgFd2PdaitXlQAcFqaiSOI
         pJDZiL1h6WB3i5o7Bz//Hu83WZZ+pv9CX32AcaPRglLPe58N/RNCATn28RJ57Zn/0+8I
         tqYQBYxVJHBYrdiOxzfDMWnskdF2BvfXjNQHwkB4C0+0wdqZ9x36B+F+GADHxeFk5XUP
         KnkcselHNZ4H7nzmz41lpWHP8ojQHrCBwAKkL03eEVahPGhGv5bikmpPui0c2h87W0xp
         Yjbw==
X-Gm-Message-State: AOAM53282V3IqOwPCoi13i+NSJ/InWVT180drozrBCqsMrksNkvfAlbJ
        7jtmSwEXYI+/8pCTeNRqsSY=
X-Google-Smtp-Source: ABdhPJzW8PYu6tcMgeUsv9MU18EFHVzlEfNHpTPotSZi8BK71ITydrRJUxb/b6zaRKichRFFjcR1GQ==
X-Received: by 2002:a17:90b:33c4:b0:1b9:3aa6:e3e0 with SMTP id lk4-20020a17090b33c400b001b93aa6e3e0mr25615714pjb.182.1645444335308;
        Mon, 21 Feb 2022 03:52:15 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:15 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 01/11] KVM: x86/pmu: Update comments for AMD gp counters
Date:   Mon, 21 Feb 2022 19:51:51 +0800
Message-Id: <20220221115201.22208-2-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
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
 arch/x86/kvm/pmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b1a02993782b..c4692f0ff87e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -34,7 +34,7 @@
  *   However AMD doesn't support fixed-counters;
  * - There are three types of index to access perf counters (PMC):
  *     1. MSR (named msr): For example Intel has MSR_IA32_PERFCTRn and AMD
- *        has MSR_K7_PERFCTRn.
+ *        has MSR_F15H_PERF_CTRn or MSR_K7_PERFCTRn.
  *     2. MSR Index (named idx): This normally is used by RDPMC instruction.
  *        For instance AMD RDPMC instruction uses 0000_0003h in ECX to access
  *        C001_0007h (MSR_K7_PERCTR3). Intel has a similar mechanism, except
@@ -46,7 +46,8 @@
  *        between pmc and perf counters is as the following:
  *        * Intel: [0 .. INTEL_PMC_MAX_GENERIC-1] <=> gp counters
  *                 [INTEL_PMC_IDX_FIXED .. INTEL_PMC_IDX_FIXED + 2] <=> fixed
- *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters
+ *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] or
+ *                 [0 .. AMD64_NUM_COUNTERS_CORE-1] <=> gp counters
  */
 
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
-- 
2.35.0

