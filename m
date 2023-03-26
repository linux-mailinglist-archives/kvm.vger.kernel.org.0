Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57D56C9209
	for <lists+kvm@lfdr.de>; Sun, 26 Mar 2023 03:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCZBUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 21:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCZBUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 21:20:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57A6AD0C
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 18:19:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j18-20020a170902da9200b001a055243657so3510850plx.19
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 18:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679793599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QI/EqVJSbrviuXTqoZjivbQTyKLSha3AimdnquYMXWc=;
        b=XRKc51T8cnu7JDEWX9tAI7inG2D1iaT67CaXMzQVUYoEs0bP1hCXvbePNvag0nUWJ3
         lUWSQDZTMvn71SCpNmYwWg6NSqpDi6KmDCloaMDl3sCsrKxH7Kb/Yr7KCiO2OTTGgHCL
         hJM9NipRmFgbn7WqBKNlrYDUpJV+t/fZLnZK7OfjelP2XyHlVo9O151TgkT03iSxczm0
         iBAUnxoNbNJ70ax08svmq0VN5wjd8CvISdK6AQX64L5SGCx+fnI3891TxaPy1vFjD8E8
         RK5FkBLxP33q2OEPScBa5fadHqDlCyMjdyRQ8S+BTWLhhSYG/QChcSrYCoUVhvLQAoc8
         XgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QI/EqVJSbrviuXTqoZjivbQTyKLSha3AimdnquYMXWc=;
        b=chir+8WfaY+mdlLkCWp8gm1GdyE+stlCfY3Azd9aClk+mxH9bNT60H3u5xZYevecek
         GdibmT5kHUWGq7xT8ahFyzPi0kERjwvssGzbmCMkeGwRDcSJr8isQZePx74E1v50rMQV
         kMgmunfmAuShZbgP7W3JcXUQJltd533QLYmyXMYU+1jcORBcdlm0TE6wAIbfS+S6XzLt
         8FpnwsqmvVkH/2mWUDR7qBtMbUzFOcSN3kgHrQJFHVxx88KLYRlScSDZVRVjcbzMCqCh
         zvDqI8drBlOP/kFHoNZeV2wG8IFf4yI5IGsBRzn+6qu2CvRfEzh/DBfvjUoFuY0St1+3
         nGdg==
X-Gm-Message-State: AAQBX9ciBqy/+6urX7fXePStn8x+0uvZMwX0edggkK6el3iDyBE+saxX
        pi6PYtayTvo0aE8AgetJ9IUzMv39lOwr/xrMGy3+0GTnEGQ0pI7bEqsihjciWo/PJebpkh5fhX1
        CSG9384C3OGXK0fBDrcVVP/6ys5F70/7S6OYuxJMKIPU08d2or5Mt3RT0rQJzDRM7nsFI5Bg=
X-Google-Smtp-Source: AKy350YzdI6W2peL0PoLdiDUrbLBCuUczb8fA3S0s0TXKpTODOv4vqupPU3pSdRyK18yqYxPFmFAFTVFcG9zIn0KWA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:b94b:b0:19f:6f30:a3f6 with
 SMTP id h11-20020a170902b94b00b0019f6f30a3f6mr2661620pls.1.1679793599120;
 Sat, 25 Mar 2023 18:19:59 -0700 (PDT)
Date:   Sun, 26 Mar 2023 01:19:50 +0000
In-Reply-To: <20230326011950.405749-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230326011950.405749-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230326011950.405749-4-jingzhangos@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Enable writable for all fields in ID_DFR0_EL1
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.9 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All valid fields in ID_DFR0_EL1 are writable from usrespace with this
change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index e64152aa448b..7dc2fb8121f3 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -565,8 +565,22 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.set_user = set_id_dfr0_el1,
 		.visibility = aa32_id_visibility, },
 	  .ftr_bits = {
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_CopDbg_SHIFT, ID_DFR0_EL1_CopDbg_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_CopSDbg_SHIFT, ID_DFR0_EL1_CopSDbg_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_MMapDbg_SHIFT, ID_DFR0_EL1_MMapDbg_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_CopTrc_SHIFT, ID_DFR0_EL1_CopTrc_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_MMapTrc_SHIFT, ID_DFR0_EL1_MMapTrc_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_MProfDbg_SHIFT, ID_DFR0_EL1_MProfDbg_WIDTH, 0),
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_DFR0_EL1_PerfMon_SHIFT, ID_DFR0_EL1_PerfMon_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_TraceFilt_SHIFT, ID_DFR0_EL1_TraceFilt_WIDTH, 0),
 		ARM64_FTR_END, },
 	  .init = init_id_dfr0_el1,
 	},
-- 
2.40.0.348.gf938b09366-goog

