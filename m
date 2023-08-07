Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17161772A80
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjHGQWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjHGQW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E134171A
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56477bea06fso2951277a12.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425348; x=1692030148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zsRHDCZY2W1L20MGQ1R2mKjwnOTJ8T3owj8sO8mRlH0=;
        b=Lo0E//61177od2WAoVfq+xQ79cs764g790tml6vdUpHtmVPMR02pooapjGQSgWtCcM
         Cx1vEMZRBUUrjZ7ayxet0HI14zqmC5maVvKgVvZvjc7eaBfpvzX5j2Km4GdtHS5hOZOa
         znsHZB5MnwwIDUFfx/u95jZvbgWxbmPKDzyZbTtD/QcZWsjSd/FtUWHQ5Rb7HNpySYN8
         EC1RC3lvPNpWa+ldxgNPYApAvciRUmGzKYU84PPSnqRSfFLmW3Nq/Dl6pJMwHvNYoQWT
         NJT5GMw3UVh/SiLiaCwCcUoGcyLbkCZAyWIwvhjr3oCX6ASzASRC9U/cRvv8vAo9ejTp
         P7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425348; x=1692030148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zsRHDCZY2W1L20MGQ1R2mKjwnOTJ8T3owj8sO8mRlH0=;
        b=lmKjukhgTICB2zUrAF54oYaz+FriI9DHw01NLgjyZpohxQvvSHvETazFa6kort9ZCg
         lx6P5qagK2Z5//1yMlVncVVuYKQWswWEWCKKKd6YqT/IjnzvVBDa9l1ZI1+rzMWNk/db
         eS69f1pEOUzAuHsV7TfRzukk1rBlqRmgC8D60eLcaB6fNGdDkXXCEbUv3xvhLhctcuQz
         eQXWpc/fHJgLOH/v6XZQJBEKxWo6Z3c4Xgdc2qgLStOD7wZKNbwofUBS9rkK/CHXPbrs
         Cq1l2Swon8fSrfZuEgi53GbjbUm5hzPkmnLXRf0HVs1XhQLvCT9RGihv/J921T+BNXJ2
         OCNg==
X-Gm-Message-State: AOJu0Yx1B9fkJN96Qk7Ya1gjBrrE/zyW2AH2Z6bQlIcPyKiF49+PfzCK
        4nNIeR0gqGQOWa3Rz9c/vSyDCUFHhXBd6uuFP+HUUcSYaaZAjxUX0OcD+/K7tRWnyVU0k2JSiAw
        sQSHcb3+QgLTjBd4lcPKZsc7a8NAFpHR0PAAiehI9re/BJdL6PGQ4vMCCthNsXlmQIY8LFuA=
X-Google-Smtp-Source: AGHT+IG3XnLIiKJ/NUMDcWl6umTr9qjJJRjx5yVZZ6JF18BZmo4OJCxIDtWTWTVmYGcfj/jYasJjX0lUk38VyXqTvg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:b504:0:b0:564:9d36:f3e7 with SMTP
 id y4-20020a63b504000000b005649d36f3e7mr49888pge.0.1691425347349; Mon, 07 Aug
 2023 09:22:27 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:22:05 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-8-jingzhangos@google.com>
Subject: [PATCH v8 07/11] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index 879004fd37e5..392613bec560 100644
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

