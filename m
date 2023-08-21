Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7707834D8
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjHUVXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjHUVXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:23:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BECC7
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:23:00 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-26d52dc97e3so3425060a91.2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652980; x=1693257780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hGowuOdlgc/g3u8U9EhceRoch6MKJG6leI2ZQ+fj9oY=;
        b=03bvAlvTUehe1uNIygFjSACoQV5XNjS+eQzJfURH/Y0uyMFVuiLMbXKLjkwJv+5c2y
         wO6ojiA3clpunb2gqxUvlqlsCSexjofZ/Eyspj/EnKYXhP5Ma4lHumDpsDRNxnnpQlkI
         lt7Tg4JU7TYDwCJPTiUatOnoVNZqNRnGgFVSJm4dWtkyQOpTqHxQa/FFhmoqQo85Y4Xq
         udROwtOJlZWZ3tfB5vAYhbPCRzypEQRSHtiBB6SNL4T2gt0cobUvf3KCC5UdtX6AM1Nm
         ghYVmJ3bglWMB0njGTHNPz6RQO2iWWyfQIVCbU49tN/fmZPPDffPoOwUbtWR/MZQ6blm
         549A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652980; x=1693257780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hGowuOdlgc/g3u8U9EhceRoch6MKJG6leI2ZQ+fj9oY=;
        b=hlJIes43Fk2YGHyAjHQMidkEWBUkzGyG90HIXQe2FrCLIXzCQ7bmomIfYGyCX8+5wU
         Ez61l7FL9wkqt4oDQTl5XJO1yUbfmgQvghjtjPqERiP7hGD3QukPE6AnuZwdHJiVcUMX
         OeY/8Mlsg4hZskr+scx5sDH+4oUgqZ19wzu2QCKM+0j90SsbGgRDMKHrDnmjazGTqh4T
         PSfZ0zRhLA+HMeEsjTJPxIvnJ4WFgdHubBOrV19YWiisNgGXOtUImAIY/tyRpEo470jM
         ohwf6LzXNLExUkWXQi44KfmGVhgSk1KjcwJCbSKs69LoJg4OKRHNqdXsuWeuna2N8Koj
         C+4Q==
X-Gm-Message-State: AOJu0Yyx7Wy4zurBEP5Fey5z/1fAvb667I58cPcGVp8A/b8x1VPrVqUh
        y1LbxkoEiBw3fJO5cySAAZAU2bmO5glT31gHD25W0I6ufG2Q8AwnC8N1KjR+CSlVERrt9GNiL0i
        l45i8N5WLWIuYd3uqDfm2I+91AqnOEr520ClrD0SE6K2Ad5TI7krjSw+r4bGYsrffT0D99+4=
X-Google-Smtp-Source: AGHT+IHWAYCWcuqlky3Jlh/tA/tztTBvpOQ6Ky5fN+7+GItW2NvM/yxfZvHjSk78Kd9MgfkgDAvMSeqcrtbGplRwbQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:c690:b0:268:1dd8:33f0 with
 SMTP id n16-20020a17090ac69000b002681dd833f0mr1930362pjt.1.1692652980138;
 Mon, 21 Aug 2023 14:23:00 -0700 (PDT)
Date:   Mon, 21 Aug 2023 14:22:39 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-8-jingzhangos@google.com>
Subject: [PATCH v9 07/11] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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
        Shaoqin Huang <shahuang@redhat.com>,
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

All valid fields in ID_AA64PFR0_EL1 are writable from userspace
with this change except AMU field which isn't exposed by KVM.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cee5f879df19..bf716f646872 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2043,7 +2043,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = ~ID_AA64PFR0_EL1_AMU_MASK, },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.42.0.rc1.204.g551eb34607-goog

