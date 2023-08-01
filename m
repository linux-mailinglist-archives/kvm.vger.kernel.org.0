Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E34076B87D
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjHAPUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjHAPU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:26 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393A61BFD
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:26 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-55bf2bf1cdeso5615391a12.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903225; x=1691508025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f1iJwrUwzrr4LImgyPThesTLhstaE6VPmgVvDL2bXp0=;
        b=5gd7OaRBrRYmMMIOxe18B8NXMNA1PK1Vvk4zSEoSg9JQcQOfWjTweZXq40eI9c+L1N
         Pjiy2HD7ipih05DuZXxzwty4Zw4J8+YSCFDSyWhYQhA/eRCTC3NQm/LNPt3/lxoIqT/H
         yEdDVYoCx3+f6eh5fJ3LuJn0o/Km7f1yoe+NQ9khAuuY1oAei/RTPdKYNFD0OwONNvvb
         kbXnJ3CRoz/wqDo4SV2g5RL02zHpUNdBV4qR9IumhIJdoJlaT5U/0IAW7sgDaA00TRO2
         /GMyXkKsKtW8TNrQmuN0DxVxyEryPcHsKqI8SVdchgkvx3neZaCiwBlrlr7BGR0ut5s5
         DjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903226; x=1691508026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f1iJwrUwzrr4LImgyPThesTLhstaE6VPmgVvDL2bXp0=;
        b=Rt74/rEXL8unWAalaJuUNIJzH7dIlqkR3bny3SBjxVIlKQ+QxahUt+zYFbx/YSuK+v
         8s7YKZ8cWhFQGelLfapFmBrLiAXiKEF+9COYjvpQTGDWjDX/x70EozNXWNGPHPgiqUST
         iDshLwWF6Wxr6Xdy0XaJ2e+wtZss8HFVosNRpFk8RDeNXRLMKGwdjJrNOrSTuFku/4It
         F1CV1VG4pwyRtrvFVP2UHeQ21bO6OMtSVhtktxD0HtQ2nZ0JzbNXXUIkGr6pqNLqV4/9
         6xpe9o21chxxpU/4tpeLVrkGOkFskrtSGUuSKGCpkoZYUBuk6WUZxDp9EmHhfe2n9/Br
         fmpg==
X-Gm-Message-State: ABy/qLaI9HQSRuyTvxGjvNQ85aRFbASTZH4losD8GQtS8SXbjjGOZGc3
        37bgvJC6jisGXMwI6+GF6qsGdcQBYh5BZgEMkMdtWZDQ4jOj6uwQ5V0cU2aSq+23sKLUDP2vwMX
        anNNSJmhcJ+e74NUT2Cv4b8nlRoRkrgS4VV6EZTb6XuejEasNvCh/j5+98Mx0DTrF5+6P0w4=
X-Google-Smtp-Source: APBJJlGHdElaUhiJW+cJ/Bn2gO8XjYZHEO/Zt8CW/zpfo34kurpBDGJ2kXAnPcGIqggba9Ii19yPInx1FB+5h5bOeg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:6dcf:0:b0:563:8dc4:c851 with SMTP
 id i198-20020a636dcf000000b005638dc4c851mr62368pgc.9.1690903225626; Tue, 01
 Aug 2023 08:20:25 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:20:03 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-8-jingzhangos@google.com>
Subject: [PATCH v7 07/10] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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

All valid fields in ID_AA64PFR0_EL1 are writable from usrespace
with this change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5a886ccb33fa..0a406058abb9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2041,7 +2041,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.585.gd2178a4bd4-goog

