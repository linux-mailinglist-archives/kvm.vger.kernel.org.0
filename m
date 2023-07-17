Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24667567F8
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 17:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjGQP2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 11:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjGQP2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 11:28:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CEF10D
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:32 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f06f7cc74so2087281a12.1
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607651; x=1692199651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=htAmYufdlwdQkrnMh1FolzMt6QFv3wnBH4tKRrY9pOY=;
        b=fBP8cHTuz+eL2tUd8pLWpazwaHoO7ksxEDvBnIeAhsZQ/jJIp1FIx9KNzdYN7pC6O3
         WOvB6RVwTVvroBlA1GB6GnsLSUqE51r2IjTB0qniqulTFYdOLY6G2BjlBGbwKQ/weZBp
         9rg7igiMH8xTMHUpa0xrNEGCfXEGjAKEzor9uvDKFxZysw6Z7DoaH6c1wFtLjGVuULP2
         NAe3rdfErhsCnQta5PT75agZ7TOlkPgvsCL+XEjFwFjInRWNcosqIjZQ9zHwmVE+BTpH
         UTFjSZgOzDxPGwYrdbsHAV18g4nvod2jhEfUuGz6ZwygER0cfqrWkJhVIH1mLUcXVUGY
         6dQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607651; x=1692199651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=htAmYufdlwdQkrnMh1FolzMt6QFv3wnBH4tKRrY9pOY=;
        b=iq3IV5dIAs+nhhkI7Whu+1FeMplasrtwzDIfmk+v7NKN/sutKJcUXEMUEQJw0robXR
         xgvOma4Uz4UGjcww19DCmePOlt9Rl1EAp2j4kUehQOmU7o8EZoG9NMkrtl7mzbiHP3R5
         bZet/1L2i59Yu/pLjUcWJU8Oqt43ILvx5IRjpmvX5G+nG12OT9AHWbB8/uOABOVhrntO
         L9M9Y6vos2CIAbDwLVsQNwn6zgLQB9HofJSuULKuKnSQQSqvNEn8r7fEjYZhrIMyTSPh
         RNlNh8Mvdr2t7+MAnmE3JjWs7YYuHGuyb7oDZ+7b3Ttf9FyOhVyH3Z3xXen1sv0YE787
         kb9A==
X-Gm-Message-State: ABy/qLbFcoc5Dj8DhgWnoZsT5FvjBNq0usPmxxDYvaS/cgSHr+l5XpuQ
        kDaoeVH9v9K+vwKAt4NvQyEcsQKX8F1C1U98LcRib8/pmwvYGE00SrimKY42/RleFfjq+JQyB+Y
        wHw/wA2wtWMSI74L5zu/ioTcchgD6eOrv05rgi3DpzSIHhN5wnSRB0eIckHWdwAZNTMD4Aak=
X-Google-Smtp-Source: APBJJlE41/UjvsOG1TZzYJvdATulWzSMytTnqO57v82maNIOWtlfxzc2uU+pqpIqGecJ69SQhQSekQZWgk8UhJbyIQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:e403:0:b0:55b:4410:aafb with SMTP
 id a3-20020a63e403000000b0055b4410aafbmr118243pgi.3.1689607650529; Mon, 17
 Jul 2023 08:27:30 -0700 (PDT)
Date:   Mon, 17 Jul 2023 15:27:20 +0000
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-4-jingzhangos@google.com>
Subject: [PATCH v6 3/5] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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
index 053d8057ff1e..fab525508510 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2042,7 +2042,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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

