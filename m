Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39944772A81
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjHGQWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjHGQWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766FC1737
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d4db064e4e2so2539038276.3
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425349; x=1692030149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ATBSjF6qBqdfdnd8w2mF20Dlf6Vur3R3tLd+6Z/cyMs=;
        b=i1eNS32wMwVyxs4WKb9JGC7F2FXkcX+IHurd54K2c03M6iCgApXHP/+RKzyS+vv9kJ
         KOn62RNuqlSIEMtJcGRrj97bkcJdDhxmkiTBjmvykmIEfhfS2APKbtyCwxuYaemi8/+r
         REjk8j/3KhEZALMyBaCBZWMV6Z17y2flSpLpiZM/IRcLJ6EtpxURNEyJUs1YxOnkPUD4
         jLoMqWjnSwLseg5pRypEjfwZmRVeN1FEDMu3FOUKren26JqSnQ6KrrvNoXjjNx7dgRH+
         eOBmxABe/GWihxsBandBo6jAJ5IxtTXfA1qiWdaSY9e/f/6rrdGQtxWPx3M3e0Gt+2Zy
         K6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425349; x=1692030149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ATBSjF6qBqdfdnd8w2mF20Dlf6Vur3R3tLd+6Z/cyMs=;
        b=TM1zf6EvAR9nW5JlumiT+2QhAa3HZurS4kjtmwo/H7Nvx35GuWcpCdJhZ6Bf+2tRKe
         FpuRpcBe9M9kbvK6yv6Zq4eGiOaGAbKVsZU2B+Mfc/uw8FqTBONUV7AorL4JIDRkV6a3
         YESRLhQjxGpZuCURLLfrgv5bdaT/Wz32qbLSWdVqbwV1KrUELg4FNWmeW9KkwRXJuimX
         Q0tnNBEOXk9oWBMiJzskF11qmzN1xiwhWmkJauirxhbCYIdDFhDryUt82ego55eIWFGK
         f2iU4LSqAP6fTrhr+E6DJxpMakk+chuaVdaYgsKu4bvKGhB0wjMkkPgD02iIUjqXdJwR
         a7Yg==
X-Gm-Message-State: AOJu0YxfRbous/387gpklKShVITTRg2aiqJS9OnwOzl9cQhD0GBfVQyN
        o9kdryDwFmaHKhBkLVZtw7WbEIG7FyYZo7T+LbNyalwxj5uIy8ExdzQpFw6FchTvtPECap/+r9N
        xwG5JTAlgDMkjeS5oqlb34SvZgqqtA05uWNUcQrn6dR3rSjYH2C1BJqVBovvj0w8spfSiBbQ=
X-Google-Smtp-Source: AGHT+IHshu44rw+o8SIUK+hYUQLk5w4Kgcs1lJhicK+bcq3hGbMtuNeTuBpA8+ho5ibjdKGHRmegILAIqvRMvxhB1w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:23d6:0:b0:d4c:f456:d54f with SMTP
 id j205-20020a2523d6000000b00d4cf456d54fmr32913ybj.8.1691425349461; Mon, 07
 Aug 2023 09:22:29 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:22:06 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-9-jingzhangos@google.com>
Subject: [PATCH v8 08/11] KVM: arm64: Refactor helper Macros for idreg desc
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 392613bec560..85b5312bdee6 100644
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

