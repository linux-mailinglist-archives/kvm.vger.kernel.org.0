Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05B3726A0C
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjFGTqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjFGTqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:46:02 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E106D1FE0
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 12:46:00 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5689bcc5f56so117021757b3.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 12:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167160; x=1688759160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hzxVwxnrNt+YQp7iV0J7o3+qKksOkJQBVAdrxipkKZg=;
        b=fMZYG2zR8/wyVaV7AOWU2176k/b30yDMKXHbC/LdYCNKxTdoLKCXlQ6JSsEJpKCovx
         u9u+W+rKoRyLy9Nud2MHk1nP4o/c3i4sFDaqNU5Tz18ncnoHJWBcV7YBp35rYblNSMrB
         Srt2tjPaFXVZin7mr/aGXsbIXt58qgfwgTEdJPUyg6mM2OwgX47KdIHSaIQqmi0eqIPL
         5v2P2BX/GBKy3oqa1yCJwfGXELL6EMogyVQSIkmTzCQjg5UWFxSp21LfjJpQZem0aQR2
         wMmq8AKiEtvscrwUGTY8A+yxh1qWK/2oPM6gQEZ/Tb/oHE/8BwS7FZkxI6PRefMOjJOI
         XiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167160; x=1688759160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hzxVwxnrNt+YQp7iV0J7o3+qKksOkJQBVAdrxipkKZg=;
        b=SFpqXKCnmFyM4XgkmlwWTObC9UCLtVRDsXgwdEWc2yUyqxqo1hiPaFIEd5qI0ODsjm
         w5t0Twq1Sb2BzuJTdKQGOYOyZU17S1ouGyOROEFt+/oMtQfdOE0vvT+tScsfnmecTlgl
         F9g3rxjb+zwC3x27Xru9xG1O6OHG6YU/cqVQySOQdWJzLnIuseXkfnmOCZ+KVv8KHU8a
         o3oNViAWc5hOwKIy5U+2R+keb0Cf4vEGoSTOWP4A2xJkjI3fzxKTSYuqkL6hFCHIfaes
         Vd0ST4HmN0yFToor8RnDn2bmciDpqLs5RmXUr0xpK8u0meHV6hs1kwGWOJn7jM0MpckM
         uEwQ==
X-Gm-Message-State: AC+VfDwBDs2jvK6LATiXXdXmLotzb1PJnkgzZPnTBVW50vcq/gzKxEQV
        mdeY5jVpRq5oiHB3hp2u8Cmj/6GtHvq1bxL23bSsPMJpHqNTB6yTb+AYLjGMShPitSCywSyDEi4
        lQP1HdKXcQSTpEIottXE8Gf3VKoKlxsU0IS7Andcbct59uo2frxBoqJJtPpfjF5qrKF+yI/0=
X-Google-Smtp-Source: ACHHUZ6V41FX37D247KNGDPz31teBiVq6V+3LyWxqzaVMHNbR4cZ9zys4EkzeS1q16KMxoLnqrscogFEIf4yfE0S0w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:ae17:0:b0:568:9bcc:5e16 with SMTP
 id m23-20020a81ae17000000b005689bcc5e16mr3400413ywh.2.1686167159720; Wed, 07
 Jun 2023 12:45:59 -0700 (PDT)
Date:   Wed,  7 Jun 2023 19:45:51 +0000
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-2-jingzhangos@google.com>
Subject: [PATCH v4 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
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
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/arm64/kvm/sys_regs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 50d4e25f42d3..a6299c796d03 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1539,9 +1539,14 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	u8 pmuver, host_pmuver;
+	u8 pmuver, host_pmuver, brps, ctx_cmps;
 	bool valid_pmu;
 
+	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
+	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
 	/*
@@ -2061,7 +2066,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.rc0.172.g3f132b7071-goog

