Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA24475825D
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjGRQpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjGRQpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:45:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0857010CB
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ccabb20111dso3030312276.3
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698733; x=1692290733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BJAEm87EHCeOWjKJA30wa69olvlB7/s8Sl9tx5zF2lQ=;
        b=tfkUfwMnUrklnQXtS24STivSqw+iQ+fA4TFwL7HBlnVEqzpPO8wCQ0LzpDSsOXDIpq
         x1/xbW5Lhl6F4kgls2JBqjroHcaQnRMYYJLqW0gMXBA7aLWFZfF7BOvE2ePSI4YJGRyq
         tywUlFjWuB1m0rig8gPtAG6ItxfiXWgZks/sD6CDikU55wFiKZseByVkSBlcnOcVegfQ
         +i69uPR777tzcJrLjb0dFAMyV7mgl0lLfmDOUSf99DAyjF20886gF+hjgJTC1GBY8SF/
         +MkAxzuIn0PQYGkJCzAuprDebJHw1S8ISx4qq165nToNntEQ+6B/I30mZedwjS5SCiro
         8iBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698733; x=1692290733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJAEm87EHCeOWjKJA30wa69olvlB7/s8Sl9tx5zF2lQ=;
        b=gpbKb2jxYIqPzVPttvX5R4XZCTvstGvg/6XXttNo8IZzzh+pWWlhSjMTwryZVFHGS/
         U1y3JeWWjF3JGD12plZsf3yJsfMPLU6PFWN0boK3VadNHb3pn7ckAZwJpA+rRp9oPznb
         7Z4N5zXDjWEIkydQPl7947S4rXSfl6gVSgU0YnOaFI24VThuHa2WHyH6CV7mHJHywn3j
         OoSsLk3Yb/v35LIymlSq9bY8jNxN8ceyOCXfawJubAgD/BRV8GvqsBrfwAoTejpK9XzY
         OjGMlOGo5J96SDDf7oWj/7/xocB5+mjyudNad2Bwe2MmMS/1FFV+qXZHQeaBEa2iRX7/
         VdOA==
X-Gm-Message-State: ABy/qLa6Q8pLoMJRTYEJUwW9nADbPXeE6RmV4REAU3hFSnUEKFig/hNx
        LIB0E7nB5Ji/tEqhcpPubZOhosz2+u4sUTWel/6zGp1kMY0SpCRQGM8Lop/Yxv4RGnizsBqe/9t
        StbQlwxhgOed4oXcXvM2a4rbIuwQjuRi38RvKD989VzkK0dIfTxVIbudq185iwxzytvq3X2w=
X-Google-Smtp-Source: APBJJlG7+TffRkqMu2lcoVZqj2J4kwXnhwITwWw6ib/WW3uqG7zZKtjT/gjSzmWi7SNVPapr4h2k9BU/V5PlgHmjwA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:9745:0:b0:ce9:4c77:bc0b with SMTP
 id h5-20020a259745000000b00ce94c77bc0bmr2571ybo.11.1689698732911; Tue, 18 Jul
 2023 09:45:32 -0700 (PDT)
Date:   Tue, 18 Jul 2023 16:45:19 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-4-jingzhangos@google.com>
Subject: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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
index 053d8057ff1e..f33aec83f1b4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2008,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2057,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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

