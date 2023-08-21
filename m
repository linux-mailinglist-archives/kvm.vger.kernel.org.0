Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AA37834D7
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjHUVXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjHUVXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:23:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F44210E
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bf58d92bd9so25838105ad.3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652979; x=1693257779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Gl7xTSJXiv4/axuMn6kp2mV+4Fk1KiUUIgvbh7eheo=;
        b=dBmoJcaxPEM+S8Rn2IOpXDmI0wJ8RR+wB0UBfR/W6QG540TqGAKxCkRcmz3UihsVua
         HtFeCUbkMb1DenY28ILYoCzbax8DrZK2PhyBUXIlCv3S25wFCJJJaSq9H0NFXgynZcDP
         ErBnDTnHJAL96aI8t1eZSZRPPVS29TWFUUxjDjOqfqzu/g9OMLactsSsU5aUFTsjIBp9
         quRsZiIAlueOUw6PyVwYF4uuAXBnxEtyOq0zISmqO6PnUow77r9Zy/SnGFZGSZHNJeRB
         97QamTERrlRrLT9GbQlqpkxxHVRkbWtbEgixTCMVu89zTVZiPWUs8O3HanznDT1cV5/H
         e3hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652979; x=1693257779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Gl7xTSJXiv4/axuMn6kp2mV+4Fk1KiUUIgvbh7eheo=;
        b=iA3n1DP3vf3OlXwbyTb/pWt3ECv8PDipCD262LAoxgvF01OJf2h+4m3QvB1NVaZuUh
         I3bJCz1VvDYcZb8Zx+dyBdi6tv6vbwu+vHwTdOuDW+fNTs+lJM2RIlN6GVrUjWnlapvP
         xba8s42pOU3ao6tyjocek4G3+OvVPb0MTtPOvFA+7Vdb7yM0SjNFXMj63NZuc8RgLE1y
         okzLTBHVHJNBCm3mcmqtoUaV1Wn8R2Rd9Zi9UwYuxkwim8gD0uygJ3S4mfxjHKltpuQI
         1RhNA8eeGV1A70j2TH1wIG/ZyxiInlXx6zFqrQgi6zBcCCz957Vtg092nxEt6h3W5MBR
         jszg==
X-Gm-Message-State: AOJu0YwkZ77SbNbJQ3z8FR2eQbHQOqnvumRC2AZUCmKaU6+inVNWh0Tl
        p9EWBm4SfS0E+y5uH92+QSKjmn0Mbjeki/1jZWRr3QyaZHbkL3anaNVzCPi1yzHq7u4wtBfdXx7
        V6ndGUiolV0EK/VqmNAjrXFsFRrJNN2svLE62EWqGiN/kjRPibfAIxTm97d97kEAiHWf7+MY=
X-Google-Smtp-Source: AGHT+IF9FbTQRPdiHLCbnz33sY6UbDj9S6Y26IR0MYTkI5YWtozk6eb4WUf0X+aSfF3eceyT5iizkkBpkhREQrbrwA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:41d0:b0:1bb:c7c6:3462 with
 SMTP id u16-20020a17090341d000b001bbc7c63462mr3891383ple.8.1692652978227;
 Mon, 21 Aug 2023 14:22:58 -0700 (PDT)
Date:   Mon, 21 Aug 2023 14:22:38 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-7-jingzhangos@google.com>
Subject: [PATCH v9 06/11] KVM: arm64: Bump up the default KVM sanitised debug
 version to v8p8
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

From: Oliver Upton <oliver.upton@linux.dev>

Since ID_AA64DFR0_EL1 and ID_DFR0_EL1 are now writable from userspace,
it is safe to bump up the default KVM sanitised debug version to v8p8.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 20fc38bad4e8..cee5f879df19 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1489,8 +1489,7 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 
-	/* Limit debug to ARMv8.0 */
-	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, IMP);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 
 	/*
 	 * Only initialize the PMU version if the vCPU was configured with one.
@@ -1550,6 +1549,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
 
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
+
 	return val;
 }
 
-- 
2.42.0.rc1.204.g551eb34607-goog

