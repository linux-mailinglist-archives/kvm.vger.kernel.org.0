Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7396E6D3B22
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 02:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjDCAhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 20:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjDCAhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 20:37:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1E5A275
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 17:37:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b124-20020a253482000000b00b72947f6a54so27293642yba.14
        for <kvm@vger.kernel.org>; Sun, 02 Apr 2023 17:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680482249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DpiYHNHtrOBdSzxOB0HhqYUe3wXm51WnVubK0bjlBk=;
        b=GtTKA0ObjbHcJ3EjXiXnMdv+2ZaEbqCaQyY6Y2xmUW3oIzLw8aDaP6wUbPYp2AT5wL
         8Z/Zctn+lxDa1DR+ePaq1tLF8re2Pytt0u+HA1gwaoRad+Jm/391vzYqG22OsIjzpxTh
         ntz0XRxDNS1S5DRgPwb36ewWn6jBfIGYctNaxyzh+ItzwzqEffquN2XqJoCUNQukMOmi
         fnpN9LSPjcexhRDqamgGDXz4X+AYtVn33gB49GvptmZuzh+jLpg8c+L1xVezZ+2wUHZ8
         YO89kKmSfS/Ttre5kh61VwQyzTlSJt8/Z8EaWInlc0KFDPQbYkr8+6WwbpH5f+HvSzx7
         YQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680482249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DpiYHNHtrOBdSzxOB0HhqYUe3wXm51WnVubK0bjlBk=;
        b=DaVS+NIK68AR2Nosdy178SwidKKtTdZJtGfoZve3n/3xK+2Q6rn2oWrC2dV82ajI/1
         QsZW3IJWRnrz+Kk6LKtwjirK5B1Ve5JXkPezMgFcIkuWznwtKyHDktUeyDkdn9Vj+DF0
         qatmYqT019/RDt5o0MknvtQiYWN+gLAwnrbHBo/UVmKGg9KrSu5onEPdR7Iu9UPNJGxn
         cT0IwoEvUYwLujQixEtM9EuO/LhNDdHwTJWCoIrlmzX9L8b0na279QO6mIw1MWTvl5Ft
         of+543CUnXpCP4oJ515rcEY0IZyFtrEZHS1kXa4QedIiKfZQ405zqpW39CdX11X0QTDK
         i1sg==
X-Gm-Message-State: AAQBX9fCLY926/iuK7IbsG6YELVkHQSM7ugJP07WZ9eI3NpXGGbsUba2
        /1luR7I/PAqbvzGa536RCx728yszRRcFWUVnuk9Yds2CtHRh9TNe0b0Gslz2M2dw7WNSVFqibCx
        Pom9PUvzgyIP7N/ATmG2uQB1aBgQMQCU+Nm2PpqfmM97KwgkxnR7qHKQpX+jpA/9jTbHmHAs=
X-Google-Smtp-Source: AKy350av+d6VbgmFzuOft067V0HLrX54LmHyG0tsHYmBgkFAW7aECB/LZb1/44Vo5tN6sgirn8HdCBXK/wU5j8gvWQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:110b:b0:b7d:4c96:de0 with
 SMTP id o11-20020a056902110b00b00b7d4c960de0mr10519688ybu.5.1680482249727;
 Sun, 02 Apr 2023 17:37:29 -0700 (PDT)
Date:   Mon,  3 Apr 2023 00:37:23 +0000
In-Reply-To: <20230403003723.3199828-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230403003723.3199828-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403003723.3199828-3-jingzhangos@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: Enable writable for ID_DFR0_EL1
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

All valid fields in ID_DFR0_EL1 are writable from usrespace with this
change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 7ca76a167c90..17f134d343e3 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -451,28 +451,28 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	if (valid_pmu) {
-		mutex_lock(&vcpu->kvm->arch.config_lock);
-		ret = set_id_reg(vcpu, rd, val);
-		if (ret) {
-			mutex_unlock(&vcpu->kvm->arch.config_lock);
-			return ret;
-		}
+	if (!valid_pmu) {
+		/* Ignore the PerfMon field in val */
+		perfmon = FIELD_GET(ID_DFR0_EL1_PerfMon_MASK, read_id_reg(vcpu, rd));
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
+	}
 
-		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
-			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	ret = set_id_reg(vcpu, rd, val);
+	if (ret) {
 		mutex_unlock(&vcpu->kvm->arch.config_lock);
-	} else {
-		/* We can only differ with PerfMon, and anything else is an error */
-		val ^= read_id_reg(vcpu, rd);
-		val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-		if (val)
-			return -EINVAL;
+		return ret;
+	}
 
+	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+
+	if (!valid_pmu)
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
-	}
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return 0;
 }
@@ -560,7 +560,7 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.set_user = set_id_dfr0_el1,
 		.visibility = aa32_id_visibility, },
 	  .ftr_bits = ftr_id_dfr0,
-	  .writable_mask = ID_DFR0_EL1_PerfMon_MASK,
+	  .writable_mask = GENMASK(63, 0),
 	  .read_kvm_sanitised_reg = read_sanitised_id_dfr0_el1,
 	},
 	ID_HIDDEN(ID_AFR0_EL1),
-- 
2.40.0.348.gf938b09366-goog

