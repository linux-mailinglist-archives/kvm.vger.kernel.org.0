Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA66F76B878
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbjHAPU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbjHAPUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:23 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328852113
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bba9a0da10so40413945ad.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903221; x=1691508021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5CnHym/u4lCc+2ZRHUcKoPxTfNqi1z6j2L8Et7c5ypg=;
        b=ITQmxLoYmO8h9hfwALbwL2rbBiAv0WLTDqVVXqQ68Kx3CrRI2YuJDvikKqxD98orlv
         asBoUJOWDE/bC378g+AcV7451TxIqgjUWQoongTCjB6tBtusYCGinPnTxb8547akp1iy
         7xfjc5EQNTUSFk/UM3dVuwC9GH3YS8wLhgVdHaJ1rj+9Z0dOK9ZsPNHXPZkaJ+wIm1zI
         pflTA6JfCQ5Cn1EKiIj4ULclDADFcWUGls/+h1FWcEC574Su2y04w9J8m81XMUW0eBGx
         whjUwbBD1KqWHEUQm8NzZIKN4o6U5CQYuyrnQnuU87g9I+ZajU9x2fLC8hsIjBTegaEa
         FOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903221; x=1691508021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5CnHym/u4lCc+2ZRHUcKoPxTfNqi1z6j2L8Et7c5ypg=;
        b=ZRbqrIyQpHdgEDUsd9sJchaJa9bIkIV1wAhBOeQj0st0+r4pjN8JOsJ7AW5vpGj2sI
         2y3A4smMT+yPgj7EA3kmqM+t6sUZ4cEcXor09Y/2Bv7548Ma8Qh8nY5dSswJLWxfosLB
         jtcFI3OqqQ/8087abRtNFopzylkmFzZISyi53Ow995jVZphgCDnUrtilVz4yTkJZiq3J
         1V1kK0txzSieUJ6XJpmhSqlSULXC4+PmdJ4zdyAeffEKL8zPMlCHA1VPRvwFChO7I78V
         agpMPPMrEO/f0qJlhN9E0hEy2ojeM7pZmBj/yLXm58LUZECA6rFo8EEeBfJOemegshWd
         2JRw==
X-Gm-Message-State: ABy/qLap23Gqzqg+EnWmOR/r3N+dEwl8TZvIOodAikI6lnWuxgg7zNy3
        QUDeWkYqHuG3Pk85ujayNXA0KGeMkIg7e6Q/MV9Gs8Vgp61BAv+O1aUzCO/ELJ5F+Iz3ER6SYbg
        9laM+AkicEz1asj93UahhDHkidNrX3lFDCDdf8ZRKdGc1slt4j4elBLRJJCEHl0tm8+RY3jE=
X-Google-Smtp-Source: APBJJlEnPwgkTgMCnI54ZmtyPE3ZmqrSTb8N+c2ZmA4uLAPIPk28sPLKkYPRVyGSa7M9V2JcblPYsgrU4Lh3MjT/iQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:da83:b0:1b3:c62d:71b5 with
 SMTP id j3-20020a170902da8300b001b3c62d71b5mr60476plx.0.1690903221091; Tue,
 01 Aug 2023 08:20:21 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:20:01 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-6-jingzhangos@google.com>
Subject: [PATCH v7 05/10] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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

All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
from usrespace with this change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7fcbc317f100..2183cd3af472 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2006,7 +2006,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2055,7 +2055,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.585.gd2178a4bd4-goog

