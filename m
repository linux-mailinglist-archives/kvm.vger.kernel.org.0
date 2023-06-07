Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41BA726A0D
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjFGTqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjFGTqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:46:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F05101
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 12:46:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bad1c8dce48so10902133276.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 12:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167162; x=1688759162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GMvXXWaPKrwI8ANUMqyoY6XpdWuvZ2GGO8wtmAqxRv8=;
        b=44H05++tu/UWuqm3JuxpRf6vMLsECzczci0UyIUM3OThFWRiahAt92FfhRZhSbBwli
         8/1qfxGZ/VTr91tecb7st2f1w7Mt72fLDC0mU1zCkJiAIN7Mw7S6hlj8V2HdVsEihDHA
         PeILBnvUmqvJ0x1+JXeJCdoAS9EAyiy4jPlmRyYm6dBlIsDjr/9Xbu4BCkGDqs2l1fAY
         4wVh3IropgCq0jmNSAvgDdMkA6uKJ/X7wqGEoBknvm2MDi9mY5pYcLlv94VLhn6OjOOc
         ucZmGH8BIvzeugQBdnkUorBxJjwXODIhc/tDcFubiJ/6d25Kctx8gI/Xns5hEqSi7CLO
         RadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167162; x=1688759162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GMvXXWaPKrwI8ANUMqyoY6XpdWuvZ2GGO8wtmAqxRv8=;
        b=W7CBt5gQBnvyg8GMbxI8eLJJS+cual+oS2qh433g0pj/4Gj5TkGCzdV3dOEB/2y3Mv
         IMQV5GoyZeLfVAX4ZB9RlCLkR9+5ab4sJVrI/R9hLAD77UTNGDLfM+4vAQZhMLiE2LL+
         MFL338SXI4OFiEqLHc4UAWIhM0QzYNIJ5nI4MInZcNLGrh1gqvHkkKSfiUEy4xobcNli
         4r7srAyzWy32rQwt+MQoPg+ITQB9HKMb6GDb8peN/i8lz0PoeoieNKr0JuDJ74CXjTUe
         dvdG9zyEfXAqATKSPKjkR5PB3rxuyYRTduXm0DlZXaUBZScYDTR5TXp13YVPs6/Skxsc
         VkVA==
X-Gm-Message-State: AC+VfDwwrSY4TNUlOmLBiVz1ZzSnioU+A7DlGrvYL6INKbJ6U1+LcSAv
        w4H9VYX8pGA9jAYM2Uj1n1YnYsen4dFPYJ67t95UByCc2T2LCFew1KQ8VTsGhD7z+dIlqkKaWrW
        C2WUHnIsB+cPtGpYi7wi/KuWKUTiV2JSvafD5FkLWaWjpigqf57Piz7OTWgVgra8FyfnOZ0Q=
X-Google-Smtp-Source: ACHHUZ4KSb7sB8/bYxjIdGGm9lhaO9umaUIt7cTmZ1//R+CmbCUOZ0UJCj1y/ESSBxrH8CNkeqmF30Cs6PkVID1Mpw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:100c:b0:ba8:4ff5:3217 with
 SMTP id w12-20020a056902100c00b00ba84ff53217mr2467566ybt.3.1686167162151;
 Wed, 07 Jun 2023 12:46:02 -0700 (PDT)
Date:   Wed,  7 Jun 2023 19:45:52 +0000
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-3-jingzhangos@google.com>
Subject: [PATCH v4 2/4] KVM: arm64: Enable writable for ID_DFR0_EL1
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
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All valid fields in ID_DFR0_EL1 are writable from usrespace with this
change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a6299c796d03..3964a85a89fe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2017,7 +2017,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
-- 
2.41.0.rc0.172.g3f132b7071-goog

