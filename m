Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF8E772A7F
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjHGQWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjHGQW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:27 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6738171A
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:26 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5637a108d02so2638310a12.2
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425346; x=1692030146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zvko96XhFtpYYidvZOJTCgoG3opZmvwlh1PYr9fTkkI=;
        b=MYFOZWMXY1d3zc6ycPNIIfzeiRbUVH9rEU6myuvNiw20E0/VUtCIGhzIE0C+LdxMGM
         F5JgfQKr+tWfuLdARz61HjWK/zXr5L4lU83lCxcVYL94Dgv9pnKA5m1XAyixRzD0cp2T
         hULsuuUXwsgbA1pCkaSLOHoxq+GMEHVOTlZP0vgssmI10I0/+4oAFTwOgHiPP/rS/M8q
         5UCG5eN8M6vZqh/aEg8+AEGaPWH4qJE6D4q5/XM/XbdkAIHOQtHkkoyVRil5Go4Row5z
         nxCSfzjUSdluuwnCrJoAjmfuOC74VLARqJog4efxTutNg1f39R8zKu54lOGzFTeQSqmO
         utyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425346; x=1692030146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zvko96XhFtpYYidvZOJTCgoG3opZmvwlh1PYr9fTkkI=;
        b=aJ/orHjlcTq0OoMWUonWHGqC8wufis4m1m1BpuJMm+nXKpJQ7zq+3X6ddJLpafMlqk
         mDYrwRwqA4VkK9vLTPoF2P4ZbOvcpwj3MuI3y4pzVzclPZNiO3Vfe4L4RTA5Jz3efd1R
         3Oz7TvlufUNgfXzGgf312ICPnnx0MpolXFD6bSO9cRS/Y4fidrVlN2oJSTz2aKosGRVA
         mKVIq8RtTykvfbRRTCcjUYK0euBKhwPE6AS2yXvj3d6hawSl713/utlqB50GXX5yJryd
         FCsuN95u6YqPmyQBz0VFOOoqUssx01Qtz3jVYf+xOQptpCUSw+P5nMrsJ9QJqqrChB3r
         SC/Q==
X-Gm-Message-State: AOJu0YxkynsjqUjrTYWGezn5uIut4gbXmfcaOogQrPt+e/vkkrLOqMBd
        psEzWtImmT4259OqmNnva1Fq07VQ2JGRR+Hs3afdGrD5792zoad07Bd89KfGEuzrr68ZFETemCp
        hCb5PBToKvvTWqM7z6xQ8T/0FVCCTLw7VvvwBOxLJWs+7afPH2hPLakqZyVeEcUlnKkKAPts=
X-Google-Smtp-Source: AGHT+IF0luikMERZ5n3CMp2yFSmVcfgwmELbpWdGVUJ7uHnLdJhIRB6jZe3Nzpwz9XCDsQ4vNxF9J7MobIwiMfhDew==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:790e:0:b0:55b:c42d:e454 with SMTP
 id u14-20020a63790e000000b0055bc42de454mr44303pgc.11.1691425345621; Mon, 07
 Aug 2023 09:22:25 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:22:04 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-7-jingzhangos@google.com>
Subject: [PATCH v8 06/11] KVM: arm64: Bump up the default KVM sanitised debug
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

From: Oliver Upton <oliver.upton@linux.dev>

Since ID_AA64DFR0_EL1 and ID_DFR0_EL1 are now writable from userspace,
it is safe to bump up the default KVM sanitised debug version to v8p8.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5f6c2be12e44..879004fd37e5 100644
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
2.41.0.585.gd2178a4bd4-goog

