Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E261E772A7E
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjHGQW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjHGQW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C9F172B
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:25 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bc4abfca29so28212855ad.3
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425345; x=1692030145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xxutBbfGAJNlYXBOxeWHmgbZQPEyXZB54Uqq0kRAHGs=;
        b=MWTqNbOKj3myoiLjMSizeKuQY/1TTY0jExT5xB/zlgozBZvD5HeSTWObVZ9tVEM5cm
         svvEzFsHDKyjsxkCsmH+auMwO7xlkVvRRkWxNrL5xoTvhM2HO6/s1xUFYR+CScSkuScM
         OI+otDdsoN9/cBqeK7BoPW5pETJOPqM7MrpjbYvtlSuuU6wF2GZrxv50MfzA4KYxMiJe
         ossyxyCVLwDN1vteLgK53wSRzs8hMdT8NSzlHvl1mvVonBgxVwPnjS5SxMpYLLBRXoW7
         5oTc2LvVvmCtFWlbisSK0wNVy/Jca6o/GA14JN6goN7GMDwa+invi3c+iczgIZRbgUHp
         9bgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425345; x=1692030145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xxutBbfGAJNlYXBOxeWHmgbZQPEyXZB54Uqq0kRAHGs=;
        b=Pg0VuvShAagddA3XbBWPSX+4NztPvI/XHjidjtHu/BrFQLqug6KteM1GO6W02DV+CN
         lKrCcgED9CzsqOfVH4ISZSwlseVFFuRlHDGQPJS0EKph+MN9MUbXGzUS1vjpq/ptAhTV
         lR2DEM34q+UcQNHqY/GepQPKRnPkvhOHudAVZdPuZdWp2sdND3bvcRUVOEOcHFtI4C9+
         9i+Un/3lubgXXRMPyCakbeO6m4UK3FccQP+AqeCArNDaEsm4ZwdsNyLwRMS+pa8lOSnV
         hCGDrSSvI4OzbtX9JHKx9Ko50SMq0MbzC5Kxl/FiJmIsctPYcdTmVHUImL4mNpIEIvH6
         3KIg==
X-Gm-Message-State: AOJu0YzJt0/4kAyzsY/jBPfXwci3r7XjhQBgA/jDS2Ea7tu1pR5sL5Iw
        +Sn8/EsG54bgZHapz0bTlGGftJij/MbrAyFv++2zZfVjLh1idGjJ8mcCCTdjmmA/7VL5P6/9wr9
        80q+SYa68P4uwMCVZt4RNL+irTJ47ChN+Ckkc9HLGSNnK2vUEiZrbqsRuu9O1G4PEELkh5so=
X-Google-Smtp-Source: AGHT+IG89VBNktN7XA1gkTE5xVbgGz8iasHHKTacDRwZZyNk+t4M2tS4x4zckgIQ/EwT9AkYrTdbks6AEBAQCcWudg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:22c2:b0:1b9:e338:a8b7 with
 SMTP id y2-20020a17090322c200b001b9e338a8b7mr41785plg.5.1691425343669; Mon,
 07 Aug 2023 09:22:23 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:22:03 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-6-jingzhangos@google.com>
Subject: [PATCH v8 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index afade7186675..5f6c2be12e44 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2006,7 +2006,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2055,7 +2055,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.585.gd2178a4bd4-goog

