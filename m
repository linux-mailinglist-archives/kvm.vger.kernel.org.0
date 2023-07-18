Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E77875825E
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbjGRQpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbjGRQpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:45:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E130810E5
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57704a25be9so84888037b3.1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698735; x=1692290735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xS0acJp+aIDXIQPo5QGK2XMol5RfSj1wMM22zpXYALg=;
        b=mpfM8/gfGz4eL9WsvWX7/rl2c/XEF+3IZBy6xbn2Nm8YaKYfYszCxiqcQih3uvFcoZ
         CCyHfCbfF0C1cDKbjHnJg8h6J23K7kxuUTtJ2YnOHqiLn+Ru+xLOVynTE8kRKkZysCcj
         rztMqtpEyQoRu+XppWAh2poZ+EGId/gLbWI42NGF0ShR9KzVER18cTOPFLdxV82tVeld
         8Tqw3IFOH65ngjlOZQsGQT/K2L1pjDGDLrTuiyN/8eO4MrfQZbV6aa2KTfrWdTE/B9Z6
         ADI4mAL/zN61phUNkQRrWLgdAqJ1xeLa98MzOX4ZMdYlz7aeBdZLgI8tkYazrhZVJ459
         atQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698735; x=1692290735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xS0acJp+aIDXIQPo5QGK2XMol5RfSj1wMM22zpXYALg=;
        b=QnvJWzl99mFSF4P6Nf/FHA3N1dl0GEx62CFI0awVODAjf9e0UHRuCctk6Xm/tSRtwK
         0QjGERubmiTCD6EU94fsWtn6nPEyVO3FWRFN+BykvpaAvKs+qURHR68WEC3u8CJHdD0S
         GdPFicUN4C3D/0LvZFzcD/LzwOpE/zGzfq26T2rQN7SgKLgl23Mn4WyeVD7OorlBS9Jy
         xpSxABtBxC8cDePq6dcsFjsHXdth7tWc4UqxV+VWwmMlOogDlU62fKOSodEU3FBk15dd
         gDQMOU8tTvTgykhpl+oRChs9BxVJDrTrPVW2O+d0Tl0duM4pK34M365BHmq6PgeKpw/A
         6QLQ==
X-Gm-Message-State: ABy/qLZypSFLOWDGQhHoMpvQOp6StSZqG2Y/j/oiAKj1Ya1TzASy9qBJ
        BALWwfVInxbj8IF16KWspuQ8N/e0vezjndtJyIima8/+fz9qXMuN0N4KEHa6Y4XMhj4MaHuGkpl
        uQO7oCccwmgucT3wb92tdN5b6uhx++R8jb6RI5cH2TmZITCGW+hLDztItnYFjlQsMe06Kh2A=
X-Google-Smtp-Source: APBJJlEQmDSoHkGi9JQIAr4wuITHz7fAluVasMRt8k18NTKlsRsIsnD0bdJ4EqDubIUM0oQB7DLI1CT99QjPdZDFHQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:fe09:0:b0:57a:6019:62aa with SMTP
 id j9-20020a81fe09000000b0057a601962aamr237002ywn.5.1689698734735; Tue, 18
 Jul 2023 09:45:34 -0700 (PDT)
Date:   Tue, 18 Jul 2023 16:45:20 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-5-jingzhangos@google.com>
Subject: [PATCH v6 4/6] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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
index f33aec83f1b4..12b81ab27dbe 100644
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

