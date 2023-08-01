Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1228D76B876
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbjHAPU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbjHAPUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:23 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DD72112
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:18 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbbf96ebe1so45429105ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903217; x=1691508017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4m6WXeBLyRHr+QvNXIbI2jFxW3avFe83y+pcJg40hnI=;
        b=41CSSN+hrqV+uEQcg062xb3BDESzeeaZrpLGmBiFuxwUYBsb39Ajf4JSPo+BnqEgph
         GrjSldr+fqJbSsULyLROGCqdMwJ6TPcEvBoVqHSLOk+R/n87pDxRhy98pn9Hko3TkWy8
         hadEWh7vpkVun5nkli3CBu22HaEfMwDlFX4/lfrHcwM+vpthhZekf6YFpnphlxc8mcOZ
         /tCUu6i1UfO7pHCYc/bz3S3y5IA4/rdr1KqkE9ugV+EJbcsx5MsA6+N2bJ3L/D9HokGN
         sFSp0hvkwd7iT7Xnq8UDGuYPwZVC1ofE4o7p8U193EiPY3+mMfFzysmq6ICIwWSgnw6c
         bQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903217; x=1691508017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4m6WXeBLyRHr+QvNXIbI2jFxW3avFe83y+pcJg40hnI=;
        b=Cb85TliiGtW6jOVLVUivomRYNipFamKfoZVyAOgm33VQ8c6aKSknqgxMXzyigsvb+/
         tfdbty/2B9vfHSBsZrfWcjEGUT1rJffnSngMitXiEyvTCFXkQQ51jymmk/uSLhpmICl3
         xieTFN1xQ5cPD7iXQKmo1JoMO1+qdi+9xKspChb4pfsR3mQGY0x1gf4XWhTNe+nwfAwE
         R5m8Nl/bZoI/OjxXuIfEkJtA+XGRrIq6VUdmXmSLSLlJpMttFJ2zj7q3vVFWXEq/DE/p
         LVs5Mf0XDMurRzvvA4vdwhhrmFgN6v67L9vceZwL4hwgqcjLvkCdDubzympxgATG3SlL
         O3Jg==
X-Gm-Message-State: ABy/qLZL9n1QCDzIIcnbpwAwLFJG77JrGl1SZqdyT52Bi9oxDXQUmxUU
        RbcmEmfihXkAJKq+bKoHvRJTNzijZfE/u3QZXhMVOm7KN/zJr5p82eHfJPrgWDrZJeJDo2x2cQE
        3wT5A89lcWKQsdhBr3CtUi0reSVc+rTLTwbVdGBtkBnIDTaUyaNBQAi7gHzSsFqeDewTtM4M=
X-Google-Smtp-Source: APBJJlF5pQV//6JpAgPsrrwmu1eJKxYmdCqhfZm9zICtlUCY7L5aEFcjDBXXU7rrEPxZCvZlO/QmM5V89O0TvCqmmw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:7588:b0:1bc:1189:189 with SMTP
 id j8-20020a170902758800b001bc11890189mr53532pll.3.1690903217346; Tue, 01 Aug
 2023 08:20:17 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:19:59 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-4-jingzhangos@google.com>
Subject: [PATCH v7 03/10] KVM: arm64: Use guest ID register values for the
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
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
index d9317b640ba5..6eab45ce05d9 100644
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
2.41.0.585.gd2178a4bd4-goog

