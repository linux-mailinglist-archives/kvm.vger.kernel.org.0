Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A997834D5
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjHUVXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjHUVW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:22:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C478910E
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:56 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56438e966baso3995886a12.2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652976; x=1693257776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCgM+uWZENhfXGRSSt7pNwhlX4F4zmpaI/T3IJmgu5o=;
        b=ME+OOxRo2wdRa9p4+icKYcj/ax6VdiNcN4Ngg7bJBna4Tq/iZNml5vlDHc7/LBxLVH
         3JLVDXMCicie0QbeU9TMQNUHqMc6HrS9vGVA2Bhlxxb+JTEBon5AQeIKjYyKGaTuAnzk
         g90dm7F92eU6VFVPVpq2jc+yOP4k4HE+ah1WPpE+lL/I6pmbt5oummmE2cR7K9I63pUy
         2kVuK1c5vaaPcEvq+eq6X/XpUllvZwGjrFacNR2JwfFCz8wT7NvOVXhn3uln8qTvM/b9
         4eqjrDBxdUHZ+Nb/DMJHqnhj+QxCmrBgbH1SAyRH6vqQAvrbABNabTPxme4PpoV6+4H9
         Gykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652976; x=1693257776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dCgM+uWZENhfXGRSSt7pNwhlX4F4zmpaI/T3IJmgu5o=;
        b=B6fS6S7APMLgn+njc1z1ESPZA4E6Lfau/gOEa80jIcCpameky4JktENijayGuNLMrB
         cQUGArl5cF3RRIve5fVyyrkO2QxWWuHwiW9vm7s6fePNWTgkQJG2Ama0zJXlKIyWLVer
         fP6JvuKsRpCXGIQEPzT6oFXpVbjSgNbKf6HrXSVDVGk7+lf45i1NqIrvbjAFXhSIrSSP
         omHqeqTpR7FMfv6M4SLUSA1PSPczn7j+YQ6ffph2g1w6Z2XTACDThOEXkm/eO8zH9jLo
         T61v1Mb9CBGSs3B2ZSkQpY/8piklXs01+iDxclJdDXNc2LJT1fkDC8u+a4CNXR8zDYeB
         RFNw==
X-Gm-Message-State: AOJu0Yz1bF2RbtZ6DXyhakANBjLQwN2qT228594OACekueqFV0ev8yZ2
        z5u/KkfriThA3aVYAifk5euuOBz7wz0GrHYtn/6PahQDVczDMTOF4MfsPqvpQh7nWVMSuA1xmDU
        pXz6bk7hboK55N64Cc1iBeWuWVk7Xe1/cONCx5ap35o4Ucgu4rHnJ954ldGeIc386JUzTeeY=
X-Google-Smtp-Source: AGHT+IFEbSMkpzW4xRUg9/lecmYCKElY3+Z/nNrWGKno3Wd6qYB/hxIPVKLuWctd4B12O8psBSsfZbG8NCfYHLsFjw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:3488:0:b0:566:1c6:139b with SMTP
 id b130-20020a633488000000b0056601c6139bmr1238435pga.8.1692652976241; Mon, 21
 Aug 2023 14:22:56 -0700 (PDT)
Date:   Mon, 21 Aug 2023 14:22:37 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-6-jingzhangos@google.com>
Subject: [PATCH v9 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
from userspace with this change.
RES0 fields and those fields hidden by KVM are not writable.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index afade7186675..20fc38bad4e8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1931,6 +1931,8 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+#define ID_AA64DFR0_EL1_RES0_MASK (GENMASK(59, 56) | GENMASK(27, 24) | GENMASK(19, 16))
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2006,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(31, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2055,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = ~(ID_AA64DFR0_EL1_PMSVer_MASK | ID_AA64DFR0_EL1_RES0_MASK), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.42.0.rc1.204.g551eb34607-goog

