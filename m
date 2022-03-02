Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CEA4CA2ED
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbiCBLOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241240AbiCBLOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:30 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D86A4BB87;
        Wed,  2 Mar 2022 03:13:47 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v4so1484288pjh.2;
        Wed, 02 Mar 2022 03:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3+cxr9PBA0y6OTGUTKyW/B0HETWf7xZdmsRbL9EBLSs=;
        b=Js9++clihsvhkNBrmdJC1S5A8OK7lMfVxmGstEIEsYxazlDLkVHoRPZ2tMB1PDEK2u
         m5pZNqxV2w4RMNxbHVGF4DzkW2aj5rgYN87sWwZSVG77YUMW+sKqz4rE9QnYluXrNBlD
         km9EhE7KvQXEgkutvuAsieriqid5RDmKADhSBu+Z3aM06J+3/zC+4SpW+1Eh0sJtlYRk
         WupcKaDH8rzbTxRUoY27/UvrJO/zyRLzWTt3L2XXx0yGnSkeOBa6CtTr6jIbBvuq6YYd
         Ts9TZjsdjkrDTq9WKuZtAmICGba1N6yGVb2XDcGjX1JuQ8CdJsp9fwpjPP89AxrCWfa7
         vFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3+cxr9PBA0y6OTGUTKyW/B0HETWf7xZdmsRbL9EBLSs=;
        b=AAtqYJpFCa6Do92qyQ8BLnEeWvYtKFHZlPF8xkj97d8IeRvooAb+n9zz8eMuTNOld7
         YXylhIxtzRby0xTuBabPiYTq45ZZrX/scIIQEKdMKEKXiLb56elfh98fzZz4LMnEsHgJ
         saFBlbs1PWpxrjVSD68O04bWoCQUJrh0Aq3A4g3ELuZrGx5OFleDBHEj9vKijFISHATB
         Qt5DmraoVb2XsxcpU/mKtK56/7uWLs57xGBjqCdMWD/nPSajlCd4EG7KwGTtVLDni3tz
         bf1j6KpyCuE4F5ShEPbFofr1K3i3XmEjb5WJhKRayi77Rzl784mw/b628P/RCy/nUui9
         dbiw==
X-Gm-Message-State: AOAM5335AtjlJgXDtuLIqgSMXPtEuYoblV/nWmWYwhR1ZW7t9ScGne0q
        XakhsXb+c5gujpwalgZ+2BU=
X-Google-Smtp-Source: ABdhPJzY/p1NcBfFzVLiPysuI/yRg6F4Vs6vG341aTbEKf0V2Gzo8sFF7I4TBZHo+DclH3qPYNuMZQ==
X-Received: by 2002:a17:902:e5ce:b0:151:9c5a:3c87 with SMTP id u14-20020a170902e5ce00b001519c5a3c87mr1048645plf.59.1646219626926;
        Wed, 02 Mar 2022 03:13:46 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:13:46 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 01/12] KVM: x86/pmu: Update comments for AMD gp counters
Date:   Wed,  2 Mar 2022 19:13:23 +0800
Message-Id: <20220302111334.12689-2-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302111334.12689-1-likexu@tencent.com>
References: <20220302111334.12689-1-likexu@tencent.com>
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
index b1a02993782b..3f09af678b2c 100644
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
 
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
-- 
2.35.1

