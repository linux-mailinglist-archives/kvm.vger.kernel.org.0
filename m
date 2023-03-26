Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2FE6C9206
	for <lists+kvm@lfdr.de>; Sun, 26 Mar 2023 03:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCZBT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 21:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjCZBT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 21:19:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF52CAD06
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 18:19:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so5320000ybg.21
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 18:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679793596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a1CzuRLzajO5nAP1hv6J1qOtlciV+j70IY9I3nmlEKs=;
        b=V4R4aNUZdOj8e+zq2t67IQd74cvL7qKsnXzaFVNMRiCBV68q4lKbKBe+tDtYxSlyUD
         gcL3G0ty4QGoU+io8QvDzhV9r2eEF9pnC84GQZAqojcLjpmUDjip/oj6qNAMj03D+u9E
         DHECVaPKZJTZ4zrYcPvpBDb5X45BxLr+vhqxOwpBdW8venbuRmwSTvGzW50neo4UqjQE
         sFVY+6imDq8+LkSv0thegzxwdzY+Md73ySuY6Kt7p27zCqqXX6XGiLRxfutKMw6PkNN/
         BaHddqxEUd6N4/W1kxh753D3H4as0R18+OP52W4yM1Eywm6NDvhiemn2zygWXoT7vlth
         QOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1CzuRLzajO5nAP1hv6J1qOtlciV+j70IY9I3nmlEKs=;
        b=h1wtoBYxxu9sErE9yR08zvTTE1Q/aONxZzVnW5MI+kTt2nyUJsiQcJvAln6ilD52pI
         Mo2kdereZeLdCRUbmRUeRj2v34X5cRwf0zxiMYSPPUE7IxHwasE1MJmkiZOU61kFeO9f
         sGoQK3XwAHJ6L6r0CeQY8cFywdXuIT/+3pmiCgVH83LihTCfA8TJYqvI+pbNMLxDTF9h
         z2xb7pt6y7Ylmt4+HAEg5u99dSUjnxV9mDz5eAsR6WA63oUZGjdQtTxMvnWwFnh/NU7B
         ra3LxoAIGwBm82cpVVnFT6oXspnyXRbv3UpTIEO0GTfJK48q80AWmAgPiQz7WaPuMxao
         G1AA==
X-Gm-Message-State: AAQBX9dCA8+kdl//d4jc8YiAYa82q3Jgvt0vJP3SzIvDPGey7zjPmuLs
        VdVpoe1T+5UeT2k9BffdNHYaW0AB7warU2zeblDwV6pMyulE8NOUQ9yPFnJq/nc57d6T+sufQQM
        0iRRsadn7702sZdAF90gMYXK7AfLEXIAEBUWrmd7B3nrLh1Hb8lYNGb8PWMx5MlzA2+tFR8w=
X-Google-Smtp-Source: AKy350YH+y1b+mbI36VPG5J8rICwEplkCoAuYpdy1UPWDxxU1AKvzeIhGBxGH7chIyIqq4l8Xk90ZzQpMLeK5XatWA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:1586:b0:b68:7b14:186b with
 SMTP id k6-20020a056902158600b00b687b14186bmr3114221ybu.1.1679793595845; Sat,
 25 Mar 2023 18:19:55 -0700 (PDT)
Date:   Sun, 26 Mar 2023 01:19:48 +0000
In-Reply-To: <20230326011950.405749-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230326011950.405749-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230326011950.405749-2-jingzhangos@google.com>
Subject: [PATCH v1 1/3] KVM: arm64: Enable writable for BRPs and CTX_CMPs for ID_AA64DFR0_EL1
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error if
userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 726b810b6e06..64691273980b 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -362,10 +362,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	u8 pmuver, host_pmuver;
+	u8 pmuver, host_pmuver, brps, ctx_cmps;
 	bool valid_pmu;
 	int ret;
 
+	brps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs), val);
+	ctx_cmps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_CTX_CMPs), val);
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
 	/*
@@ -623,6 +628,10 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	  .ftr_bits = {
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_AA64DFR0_EL1_PMUVer_SHIFT, ID_AA64DFR0_EL1_PMUVer_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_BRPs_SHIFT, ID_AA64DFR0_EL1_BRPs_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, ID_AA64DFR0_EL1_CTX_CMPs_WIDTH, 0),
 		ARM64_FTR_END, },
 	  .init = init_id_aa64dfr0_el1,
 	},
-- 
2.40.0.348.gf938b09366-goog

