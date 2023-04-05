Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE96D84C4
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 19:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjDERVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 13:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDERVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 13:21:52 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F1159E2
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 10:21:51 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54c08fa9387so578877b3.10
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 10:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BmqT+xEMzaVEM8H2cjQDaFd1fXb0znGEptEPZMK1zc4=;
        b=VaoW5e2K7xYhDTLa8brM9G6tOV8U/SCHghY7DZgkjotGqVe/L0gpvUYAopdgOIKd8i
         E7m1bHv3nJoii28MSfUEI+73TYEsKSoHuYTRHt3R/x/2gvi7f00Ezk0VzBr2Mp1kb6Gy
         25Zua8e1CGfAEMae/CJlEmxtoVp5FhlDnESnDaGc1jf0YQJ2MkSJlW7dCM+i9gyfzLT9
         XqZHkwghNLhqEVEhnba+A7j2lPZnEPNkzFxIaslaewi+2R/z5fK3KXAmbH98L9P8qr43
         Y5rPeLaJ8rAXi4Nmd+ZFIWIHnsw2L56+I8Ql2rejheXHpos0Oa/hts7D6JcH+D1ldefC
         FJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BmqT+xEMzaVEM8H2cjQDaFd1fXb0znGEptEPZMK1zc4=;
        b=rEX3uPs+dP5RMHfYZVoHvDfSVpz7TU251oeYhXzpZgnu6o8gjCQAVz8UzcpZLhwnbc
         zzMGehHY+XqZffdXMecU00Z/2q7DJkNOqUbxlmbNeMuZ4CLoVNFSQJNt6UI2tC3eMFQB
         QK1YC4A91s19PGE7/JZLFbTaIiliRPPqK6tW5MDSTyPjshLYl0ntFV8GO6xY4368ZHH1
         6TAz6sQ3lZ8du5rR+HBGH+1j61LtO6+eFUKyxCgu8M3LY98X0lJMD44i2q5mcOXa0TT7
         Ua6h7Xr/m9L5NZhdlf757VdbSgRs1NUQbdOWCnaa6wFbPpH29NibumgEEV70wE0EFyMB
         ZvEQ==
X-Gm-Message-State: AAQBX9cyVe42VvOIaxEIIgsf1eZbOY2n4cRoe6/mSwvRoSopQSNJ2elz
        FNWfHdMXHboHBbT08wCeIftIUbCmLJ6QkY+duePf5YMFI433okYec18IkdXKbhZ2buSSyaUtc6g
        oJxnf/I033STm6l54Bkk9v9DBycRPDRF6nRn5QlzwpsnyhJKYmxgraGOI2gP14eOo6cRXEfw=
X-Google-Smtp-Source: AKy350Yl8X0xPwh29QUUIXvQyLzR+bR8YP76SlbD780VXcZg+KLALOuHBR8wv/i0C87zpq60i2MDK/RFt2JkgJ35qw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:1370:b0:b75:e15a:a91b with
 SMTP id bt16-20020a056902137000b00b75e15aa91bmr2439474ybb.6.1680715310689;
 Wed, 05 Apr 2023 10:21:50 -0700 (PDT)
Date:   Wed,  5 Apr 2023 17:21:43 +0000
In-Reply-To: <20230405172146.297208-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230405172146.297208-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172146.297208-2-jingzhangos@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
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

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error if
userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 33968ada29bb..ca26fdabcf66 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -336,10 +336,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	u8 pmuver, host_pmuver;
+	u8 pmuver, host_pmuver, brps, ctx_cmps;
 	bool valid_pmu;
 	int ret;
 
+	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
+	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
 	/*
@@ -592,7 +597,7 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5, 2),
 	ID_UNALLOCATED(5, 3),
-- 
2.40.0.348.gf938b09366-goog

