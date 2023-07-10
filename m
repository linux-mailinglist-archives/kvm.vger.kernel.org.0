Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A79B74DE1F
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjGJTYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjGJTYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:24:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D821B4
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:38 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-577323ba3d5so85247047b3.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017077; x=1691609077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NjXGqinFg6JbUCcCuD1314VDCv679WJcMyQaO6pNuqI=;
        b=riWsju77MCgLxcyPUA5zvABoTX1/n+uRhqXiNScFzay1HPX99z0tc697bB4UPgxFup
         v6vjFDK+OpdAh+ZfjD+AN7l24j6yRvX3XtBvROnruXBLFl2kWNA8PHx/58YzuBVEhk5A
         tzoGrsxzCwHBrSrfUBwlAu5r1zF87t1cTryo+Ov3gX8k5EDIk63Rk7uqhpoTmNfHtVXW
         iB6XkV+A/4mmcFig5KzmD1Tjd2NkDPiTGmGTlD/9MwaZtYufwCgye+a0Yei9/XK5XQg8
         xopGAsDxQTs9dWPaMe8zfQxyD4pigDfKPNFKYllHwZX0MpFq1iOzO70eUexC7njvYRQ6
         kegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017077; x=1691609077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NjXGqinFg6JbUCcCuD1314VDCv679WJcMyQaO6pNuqI=;
        b=OWK7Z6Iq9VpBTPFGh5mlFFEdxSlBmmrpDcst4ixmMhFRQLQx30kTk8wJZcXWD4rm/R
         2LbkaEkJXaqfFDWZEb8GavIfOTQQkKK47FmCnc7d5ApaVGJ2qpUGGSvTinmJvDlEFk4E
         PbvuNLXfeC4eS0hNtyHpdQkIZDShhj8i3Nfij3UmME4GRrBleJFUmX+6xB10o8v2zuLM
         zQPfsRno73eDDM9BTmj91bgvih+ug/Msu8J7JHSXG8yBZuk2DISG0jjnU6uItYnztO2o
         v55cc2fZFcF3mCMxnlZ6l9t6EEsTDUk5BX7YHiCrFjcA4CJ/aWCVeBAUncUYeGZ53YTD
         PUpg==
X-Gm-Message-State: ABy/qLYAg0IerlkWpbtcDxTBFcsPqx/RGGORI2cZxmJ9b7+Yq0RyzK50
        LMr2Run3Zu6xM/+EyWrBtmmHJZrYb69hg4rs9Y4QpSQOfoLfIZf1Vq861//CITWm8WSL1h6ztHf
        BkLdiRT0CwfY9KF871BdYU3ChGdDQa0s3UbwFS4KDFgsCF8mc4rR4zT/6whWSVRFCJvwDQZY=
X-Google-Smtp-Source: APBJJlFU/3p3XZytGnnz4g0xxHNMZggWlz1mMLZ78y9fLOkMhIqS/5mIom3amLly/wcRCruQ7qwxSVnY/RznFpLozw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:ab90:0:b0:bc4:a660:528f with SMTP
 id v16-20020a25ab90000000b00bc4a660528fmr143365ybi.5.1689017077178; Mon, 10
 Jul 2023 12:24:37 -0700 (PDT)
Date:   Mon, 10 Jul 2023 19:24:25 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-3-jingzhangos@google.com>
Subject: [PATCH v5 2/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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
index c1a5ec1a016e..0160ef9cfe18 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1980,7 +1980,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2029,7 +2029,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.255.g8b1d071c50-goog

