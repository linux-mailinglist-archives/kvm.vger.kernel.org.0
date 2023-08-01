Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBD476B87E
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbjHAPUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbjHAPUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:30 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85C81FCB
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58456435437so68143317b3.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903228; x=1691508028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qCRHZVqddoTSJorH44HmZhNcqs8I6hBKdRtCxXPKdcc=;
        b=ePkYS21z2/X3ob7jSeC/nK45+fRe3ruhhAvWk7R/IgpeDZzNSYUvR8Cqquf1co6H0Q
         vNa9fK7rDmvnx13XMhJt9C8EDK56RtwWoXTWoQjZbsT0MJVbtXHmmrlLKOasGoQPfVwW
         ASXLd9KcfTKKBkm8dgWy/rOtVT9lvslKAZdEiSgx+L+X3OQdWZgOxzEz0ZBh6JBv+phY
         FAdIltq5ly5PdXtw8sIx/lL+YOh6CSJ5sa9WagZpdXbKUBFiAEdsTAaX/xa/kNlSZHO0
         EoUltfBxFaRkgbFIZu/SUWLX+uqeyW8L4Cr9YO5FwQUM+mIvXJH+X4O6K/ouA+dXTbd8
         jYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903228; x=1691508028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qCRHZVqddoTSJorH44HmZhNcqs8I6hBKdRtCxXPKdcc=;
        b=kWGRZzJQFrV9s4a7NTekhyDudyBXGwjbNUQrLAEzIDcWd07SYvuj0txKLWWws3TW5s
         p7BE15jEGAYLhRMh92JNa2ep7RZFjo+6BO5vBSChDvA6Y0IDbhcnV6yvJA+FDTsb/XwY
         VRVRJkm3UVaVWgK5CNl5PTNXo4wEj9mSOwpJ1+mRQ51PkNaQhzJTl/jes/mseJB//l0o
         ADfy93fvvxz/SVJpRUXh++F1Pe2yYy5yoPWPRvGIpWLHYi+zX3AD3+hyDhg81OvLEQex
         4tgCzQ/er4Tcd47ak8gGuVhXkS+F4tPt8Tt/3Ie+kTInZ/ShzLnNTvVH8ITznD+t6KgK
         fsTA==
X-Gm-Message-State: ABy/qLYH6xfFgzRRVpn6oDCGQHSNF2XiCd5MsqCWBxaHglVIjemnphtt
        k5I4A/ZITn/kjSniCXosOikT0gEdzCcxrWETqsaTXQruTXsdrF+oxqImHaIMI3FzMJXHND3LQ3P
        mHdHjE41dQe2jPM9j6bFg0MG1euHy3iOTT/Uz5aU/eUWW0SPeAVMDJxm5lLmCRX4JXBMoeMM=
X-Google-Smtp-Source: APBJJlEnpgyitr9PUTByZOiYn2bZXCXM8oRbrFOt19UqT5CZCMNf1UqGqdwhB7FXBYLGi3iq9DArG2kfHOXto4DNyA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:ab86:0:b0:d0d:a7bc:4040 with SMTP
 id v6-20020a25ab86000000b00d0da7bc4040mr92863ybi.0.1690903227620; Tue, 01 Aug
 2023 08:20:27 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:20:04 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-9-jingzhangos@google.com>
Subject: [PATCH v7 08/10] KVM: arm64: Refactor helper Macros for idreg desc
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

Add some helpers to ease the declaration for idreg desc.
These Macros will be heavily used for future commits enabling writable
for idregs.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 79 ++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0a406058abb9..9ca23cfec9e5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1844,27 +1844,37 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
  * from userspace.
  */
 
-/* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
-	.val = 0,				\
+#define ID_DESC(name, _set_user, _visibility, _reset, mask) {	\
+	SYS_DESC(SYS_##name),					\
+	.access	= access_id_reg,				\
+	.get_user = get_id_reg,					\
+	.set_user = _set_user,					\
+	.visibility = _visibility,				\
+	.reset = _reset,					\
+	.val = mask,						\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define AA32_ID_SANITISED(name) {		\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = aa32_id_visibility,	\
-	.reset = kvm_read_sanitised_id_reg,	\
-	.val = 0,				\
-}
+#define _ID_SANITISED(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, id_visibility, _reset, 0)
+#define ID_SANITISED(name) \
+	_ID_SANITISED(name, set_id_reg, kvm_read_sanitised_id_reg)
+
+#define _ID_SANITISED_W(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, id_visibility, _reset, GENMASK(63, 0))
+#define ID_SANITISED_W(name) \
+	_ID_SANITISED_W(name, set_id_reg, kvm_read_sanitised_id_reg)
+
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define _AA32_ID_SANITISED(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, aa32_id_visibility, _reset, 0)
+#define AA32_ID_SANITISED(name) \
+	_AA32_ID_SANITISED(name, set_id_reg, kvm_read_sanitised_id_reg)
+
+#define _AA32_ID_SANITISED_W(name, _set_user, _reset) \
+	ID_DESC(name, _set_user, aa32_id_visibility, _reset, GENMASK(63, 0))
+#define AA32_ID_SANITISED_W(name) \
+	_AA32_ID_SANITISED_W(name, set_id_reg, kvm_read_sanitised_id_reg)
 
 /*
  * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
@@ -1886,15 +1896,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
  * For now, these are exposed just like unallocated ID regs: they appear
  * RAZ for the guest.
  */
-#define ID_HIDDEN(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access = access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = raz_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
-	.val = 0,				\
-}
+#define ID_HIDDEN(name) \
+	ID_DESC(name, set_id_reg, raz_visibility, kvm_read_sanitised_id_reg, 0)
 
 static bool access_sp_el1(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
@@ -2001,13 +2004,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility,
-	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = GENMASK(63, 0), },
+	_AA32_ID_SANITISED_W(ID_DFR0_EL1, set_id_dfr0_el1, read_sanitised_id_dfr0_el1),
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2036,12 +2033,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
-	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = GENMASK(63, 0), },
+	_ID_SANITISED_W(ID_AA64PFR0_EL1, set_id_reg, read_sanitised_id_aa64pfr0_el1),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
@@ -2051,12 +2043,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_aa64dfr0_el1,
-	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = GENMASK(63, 0), },
+	_ID_SANITISED_W(ID_AA64DFR0_EL1, set_id_aa64dfr0_el1, read_sanitised_id_aa64dfr0_el1),
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.585.gd2178a4bd4-goog

