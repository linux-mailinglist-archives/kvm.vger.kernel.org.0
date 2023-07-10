Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E934774DE21
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjGJTYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjGJTYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:24:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDE0127
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57003dac4a8so85196627b3.1
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017081; x=1691609081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gk6Eirn5+X3nUAq9ec4RcBoQ+OOnriAJ9kIWX3vd7n8=;
        b=6yhBmxLd54UFd+7UosOkhtC1yZtaJfyjSwqd7QsKub+w3plBkYJTIb2IwzdzmkGe9E
         zH1XAU69YBWsEi5v7PyiygVcwUsdmGeK59qRWNhKjpzXIKEsOrhG3b5C7sPPVdLLYVUJ
         lN7g4rJ3TvJ5eSiSmAD1EW4z465s7oSkNbUVgYJV8Hn1luXbmbEOXqHl7Rc1bVoBXFAU
         cTFv8j1wxQNdGHcs3hr/h610kcTu/4zXd9JE3swftGBnSa2XpF1I1hVY61slterq39+A
         Ncf4P7nnr5DHH6ishg6E7ywNjAN0/RaiFLUxivulGmCjXmNAEnqwTPBSa0YA/PFJ32bT
         0+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017081; x=1691609081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gk6Eirn5+X3nUAq9ec4RcBoQ+OOnriAJ9kIWX3vd7n8=;
        b=VKpiATOKAgpJjQu1d4G68Iq/YypAc1D0jnaAwf6pqeoN6yk4Or0mzdNZ7pWI7e6p2P
         2UtOW+qDZucPjCzvgbfVyVUJGA6FzWHn/DLbHprt7BzaRuzxFso1ywXBvKHTGBOBJ0MY
         DztnblsSIay6JvUMYoV/Kv6i44k4MvB1D7oDz65Rlf6+JbOzgyr/4Lgi4Z2HKuP06++u
         zvjILocCXutazjY0klHbHgzipeBi+cPEUApoxOzOAVvCPhEE9/c3fvpi/6aF/JoCKkJU
         OZQfksZuH9wfYzMyIfp+ihkt/iVwXrTLXxFEveOM94vB0EJYujWRBNu7JGEHYlcWnPUC
         WiJw==
X-Gm-Message-State: ABy/qLZm6CXCbbdz747aXidwHftys1z/Ynm4F/fQkjHw9E2G37E/jM8C
        ZK0o3Q2Ju9hNnl+BmPQ4Y2x97cv3TSth7Yfl63HyAHElYFSutu2lARlBEpS0D0gJDG+Knxosg+r
        EvIoIfj+4KbYAcffoVnTjjG47nS0hW/zEYXL0Bo2+HdjhAvdzrpsDQvI1M/CeWELFEdgGs5I=
X-Google-Smtp-Source: APBJJlEyAOiilEAjTAf9LR5RX+k+0UPGMjGR8SkJvffevoDae5RhTEQQuHeKVSmDE6ilWmcPmE/Te8Fp11JLgQ9htQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a5b:88:0:b0:c2c:1b68:99b0 with SMTP id
 b8-20020a5b0088000000b00c2c1b6899b0mr173883ybp.5.1689017081007; Mon, 10 Jul
 2023 12:24:41 -0700 (PDT)
Date:   Mon, 10 Jul 2023 19:24:27 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-5-jingzhangos@google.com>
Subject: [PATCH v5 4/6] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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
index c44504038ae9..967ecd57a86a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2026,7 +2026,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.255.g8b1d071c50-goog

