Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CA77834D2
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjHUVWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjHUVWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:22:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D31E10E
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:53 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c08a15fcf4so7064885ad.3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652973; x=1693257773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/7e7+T+7gGeD+hfC7oK94gmG9hjXKCpcMKW6ZDA6Zbw=;
        b=iFeDu9lGpTFqqe6yS3esBa0r/SatkqXvSMjXcodvT3yrjmtXGQ2h4kie6ZIgEtzpdu
         6PU4FgjsNgeAwZgLiS6mcnd97gdYo6r4F/j3uQJvUrzyALYbHoop9O0/vvNoxw18dIlE
         BzVSIMmGJ1+tWptyFy0Qd3ynKx6VwnONL08nzjlBB6H2zMyl5ho0yBIG924GY5bEaW9i
         aXPUYuNygB74URXOnMAK5QGwafnd64F91m6eO1s+8SOOLDN4VhqPExlDDFidzKYS0kkc
         eTcih5DGioYA7lltyS5P9rY0mfhzkfdDX34wUgL6K2cXzB1kpIr5qQYJe7MQ7xHJu9WS
         ww5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652973; x=1693257773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7e7+T+7gGeD+hfC7oK94gmG9hjXKCpcMKW6ZDA6Zbw=;
        b=aIhf9VezZEqPrvE/i+Xyur2qh5mTRLvma3tX00g/fbgCXG+UyEEijDxHWINNFvCbmQ
         TW6OCioaxKm9ADDoTBpuEozoWrGcJnnZukeywkR6SrQiwtCXSJZy4Fn2z8WCA8MBhpZD
         XS7vczOVZ/RDeEF7raB1DBGIFDaE/DLzGrg3cx8hU0sbVsDI+qaFw3ZsRuBvzGTmUcms
         2NHFHtUUo7pE91OFv1a2y/S7M2aKSH2P5Xd4M0RG8qOY+Zn2EODxq1ylrOzOioigL2KT
         PrvYbjcYRdY1raZIvjuEEcOEW4tj5hQJAFvSZKlDSOXIauhNClFV5oRtdL9bnoPx44oT
         GSEA==
X-Gm-Message-State: AOJu0YxSYe5y6/SGrkB6CCtfInsoDCKg1K5UcMpCuf8DyIcLYmuNolzO
        NkjdNsVI0Sk0p8VC4whCqDHvQPlrBUmWCIuIJUHn4q6HrayDrKsebRn0TFfSjMXHf5slqSNv3BR
        nqMDNTVjSTc95m1SMDmdUjIw0CEquKdXlvvrEX/dK6ifLKzuoGuzv6z4ZsuETgv0YorHLnVs=
X-Google-Smtp-Source: AGHT+IEwLjGrqVvblbAjrv7R7DKyqfbxYUNAxq1ht70WxGu39YS8/s2eB5c/lYBUlVlBXLjiJ9UutGkqmPcLZiFd4w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:230c:b0:1b9:e338:a8b7 with
 SMTP id d12-20020a170903230c00b001b9e338a8b7mr3857028plh.5.1692652972740;
 Mon, 21 Aug 2023 14:22:52 -0700 (PDT)
Date:   Mon, 21 Aug 2023 14:22:35 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-4-jingzhangos@google.com>
Subject: [PATCH v9 03/11] KVM: arm64: Use guest ID register values for the
 sake of emulation
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since KVM now supports per-VM ID registers, use per-VM ID register
values for the sake of emulation for DBGDIDR and LORegion.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 216905840c92..42c4d71f40f3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -379,7 +379,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
@@ -2429,8 +2429,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL1_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0xf) << 28) |
-- 
2.42.0.rc1.204.g551eb34607-goog

