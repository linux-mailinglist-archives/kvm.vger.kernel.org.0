Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4B46C9208
	for <lists+kvm@lfdr.de>; Sun, 26 Mar 2023 03:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjCZBUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 21:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZBT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 21:19:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328CFAD0C
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 18:19:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e5-20020a17090301c500b001a1aa687e4bso3522471plh.17
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 18:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679793597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AiMZEZjS/R3ipxVNHJJuMkHexwVTEkmCRRTtOI5qhNw=;
        b=KqTTT40bJR0BN34ySkmBfSuRZ9EgxGkBStd0Pv2hwquBjC03w54UHh/lcw2yxGA9C1
         8eU3hwKB+diiVW8mgMrcTntSOR+XpOEvUqV9tMV4BDtXtsB9uJ/KMMwYh55Ww52lrPos
         eSdDHtEd+AozRtUGd43QRI7LLxHj9yggf+Ukuk3JbiXzJE5tnp0H4EZkb96/WB6oarAM
         dw4iQUNfDV1HDm+AlbUSKsBIuNuk6QAJkzm0+NfPV0dluSru/hEO3KMKR55YA9eXkZDH
         KOoaGXQ8LESI7agnkg72WRtqLxljwC6WzOrFkv33VrSt1KdPZ/QKyPemO/wpG4K3AjBJ
         YDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AiMZEZjS/R3ipxVNHJJuMkHexwVTEkmCRRTtOI5qhNw=;
        b=SwO6t2wm1Z8mrazCvZk/YdbuZjdarOGbSi1cIzp88RL/60Sh0KhzLX+chCYAaGEcnN
         q/gK4C9h6dZy0L5SqC8xrijRwSdKUR3uHKipox0ZowrRPw1D5mtGsDuehHEUmjSQekS3
         vwNWrp5Cl91d2HtONLvwm5cTGzEQJvkuj2b7KXaG3WMS821KG3pIIbj18DV5Ixj+2rOw
         YLDQWr3+ezATYWGMbNMHwbZNjPDq7XwjW2jC3gc7lCS9i7MAHifJ+MhZFV5/6rFLb0TY
         76r6a+TMtLHbV+zWkkBM9IrAzJm6cQ0x6IxJkWy5X/P91/1holvqzw/qXqnBAVMyUK4v
         Zlhg==
X-Gm-Message-State: AAQBX9fT4FhQkvz824iiv++w+yE5FY5MrIeR2Vtjwgd4rF0plHRgLzIj
        Ktp8rPUam+xGyXC6LIQlEWMbHgeDhXBA+YUkYR3T0EndduAWWnojsinDJ8firtD47h4bNH+9CsJ
        jzp5Ghnc2zOVLZ47YvIe1H1g87LfuqMvOHfib5dkAPvhejHu4D9Li/Q3mU0ZIfEjHI/S5+nw=
X-Google-Smtp-Source: AKy350avbKAxOk+db38c6sX31fwyjmAlmiFXrdx0L1mTNt1HhUge0LRva3Myy/yf6APbwdmWYSewCKG/DZD9iJa/gA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:4d8a:b0:23f:6e7:f462 with SMTP
 id m10-20020a17090a4d8a00b0023f06e7f462mr2142071pjh.2.1679793597500; Sat, 25
 Mar 2023 18:19:57 -0700 (PDT)
Date:   Sun, 26 Mar 2023 01:19:49 +0000
In-Reply-To: <20230326011950.405749-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230326011950.405749-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230326011950.405749-3-jingzhangos@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Enable writable for remaining fields for ID_AA64DFR0_EL1
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

Enable writable from userspace for all remaining fields in
ID_AA64DFR0_EL1, which don't need special handlings for dependency.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 64691273980b..e64152aa448b 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -626,12 +626,32 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.get_user = get_id_reg,
 		.set_user = set_id_aa64dfr0_el1, },
 	  .ftr_bits = {
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_DebugVer_SHIFT, ID_AA64DFR0_EL1_DebugVer_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_TraceVer_SHIFT, ID_AA64DFR0_EL1_TraceVer_WIDTH, 0),
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_AA64DFR0_EL1_PMUVer_SHIFT, ID_AA64DFR0_EL1_PMUVer_WIDTH, 0),
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_AA64DFR0_EL1_BRPs_SHIFT, ID_AA64DFR0_EL1_BRPs_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_WRPs_SHIFT, ID_AA64DFR0_EL1_WRPs_WIDTH, 0),
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, ID_AA64DFR0_EL1_CTX_CMPs_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_PMSVer_SHIFT, ID_AA64DFR0_EL1_PMSVer_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_DoubleLock_SHIFT, ID_AA64DFR0_EL1_DoubleLock_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_TraceFilt_SHIFT, ID_AA64DFR0_EL1_TraceFilt_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_TraceBuffer_SHIFT, ID_AA64DFR0_EL1_TraceBuffer_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_MTPMU_SHIFT, ID_AA64DFR0_EL1_MTPMU_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_BRBE_SHIFT, ID_AA64DFR0_EL1_BRBE_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_HPMN0_SHIFT, ID_AA64DFR0_EL1_HPMN0_WIDTH, 0),
 		ARM64_FTR_END, },
 	  .init = init_id_aa64dfr0_el1,
 	},
-- 
2.40.0.348.gf938b09366-goog

