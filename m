Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552277567E9
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 17:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjGQP2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 11:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbjGQP16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 11:27:58 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FEA2128
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b89e3715acso22502555ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607647; x=1692199647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=kOoTOacFJO9+uHVWHHqMzZUX8/dwgTKGK16Eo5ITJVuv8lBgElCfJCMjxew+K8LFhS
         0GysunMasR920l3SSl3P1E9H6MG66vreYE/A/hoaEEJom/uKr7dGst7zkry0m4tU49E3
         tvH8jPnZrUJ3n4XKLeUkSZ/GdivDj+baCykn44EudzfpfOvTXDaDSw3twySIRBSrD8pS
         uorNxDt+Xg1bfg7pWfLzylmCrMXSCayowem3n4taDuSjy3E+hAsxqwYdpbZBKJsCKwNW
         jwfXjyOrHVd8AasOuj+dAbxTjBnEw2867xWLAV6e4Fexi+xj9wlHjDFJehhW18rNQh2o
         EnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607647; x=1692199647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=U5XbE4md0EwwSDYJpbDbv0dG2ueGLl2+J6OMKLTB5xt03gprGj+pJt2cS3WBVjmoBi
         uk45kkNMDGunEuugEehPCJOYk63DIN4M0zgmZ/41JLdcsWLCo144EVInCo//JqVc9IK6
         lM1x9CFAEUJCl890JXO1Q3PqfypJbzH3G59GXDsBL1t4rDFwhudCKlkKcVIKz+S4Vsqq
         oJ5UBM08ZTJVdt//ayWWj295cVdmNzg+m6jsmvHwKiCtt4EIDEYThTzdjZu5hRwOjRSC
         A1SddZJw8xNtk0JbHZKx1Cg4q1XXqnnXqUeKZ5lBsT8ZjmhzSFzpouMVV2J8tUv1ncea
         Be5w==
X-Gm-Message-State: ABy/qLZEuQrDgtvz6s4reWiYhWTfbtXX6A5iCSLXu8SPHD11rD+j8GHw
        DBBA2ZkZ7a+Sb13B3aEwraglsfCu/WTGQ+GlbKuYtyU6VuCBrtSAkfli2X83mkgSXXsZR1h811y
        3MwMmOd0odfRGh6gpGyN7snCuTO80PvI3TDaRr6rvqQ37z3N8FEbGTpGDHIhPh1wrTw3esuY=
X-Google-Smtp-Source: APBJJlHIl7j3tQllnrhzxMlMfd0kK1zkhxUn4crAb5Cbfzt/zjRHX6e+NgOaoE/NYrO8gVVSsE2pUunvbNtvgstR8g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:d503:b0:1b8:8c7:31e6 with SMTP
 id b3-20020a170902d50300b001b808c731e6mr83plg.1.1689607646689; Mon, 17 Jul
 2023 08:27:26 -0700 (PDT)
Date:   Mon, 17 Jul 2023 15:27:18 +0000
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-2-jingzhangos@google.com>
Subject: [PATCH v6 1/5] KVM: arm64: Use guest ID register values for the sake
 of emulation
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
index bd3431823ec5..c1a5ec1a016e 100644
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
2.41.0.255.g8b1d071c50-goog

