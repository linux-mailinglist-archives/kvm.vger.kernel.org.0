Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA6F75825B
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjGRQpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGRQpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:45:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062FE118
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b888bdacbcso30814125ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698729; x=1692290729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=IG7T43kRHhKHqmEiMzHxNeQ56Cb0139AlcIhz2Mi/+JW/VCHRl4rYafsJFi/e2JFEi
         mIvhqJWXlfvC82JAWuBBk2Xi24o18hCzneiWW6VW8aULpxR+CjOWv13HmkdpoJv3DurC
         L2DbZRk4IwjvXC9sEiXHpWWw4Pc4Jue5D+o42rmQouFteNkDuRc4NNc9C/siUP8Ry8P8
         D1oQnTyl/+aQ9787SxzIRkNdmje0ThG0RirnnIxVV7XnJB3HUNsYN5zxe8aZ/tadDsK4
         akk9re/Kek0AM0PZ7I9ayA5J3l4ygxCa63qtk6CUH6Sjsz6434l1UfEiaefJAIXWtM/D
         F3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698729; x=1692290729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T195FWXfqucyEBgiIGQAY+Lmu6WGEseWSNrrUvHiu4k=;
        b=l3xn/DTguCM+ay0nybZPz4NBKZgjoS4xnWsIG4/Uot0lJBHLW5GZgMefAQN6NKNoOS
         LSBU/Zue0faca0Flpjgu2CwN0pqEAezZOAOkIjbXXvimxCOGUqh84XIgQLXkV0kIZYik
         iDUkkbYeHLir19TMrHUPwZru9y7AdGXJMNnP9YXqpsVMAEc0uu7P09N5otVOfZEqtJtQ
         pUB0HczWgYBBGi8Koeyv02IB81QeNd8kpnY2F+UvEKcu2B9eQc8dBwIu6EFRJi2gKXWn
         EEbnWl6v74/Q23zlc+Q9UcDWzyEEQOUR5nuCZsCI8+ZmUHFXXOHdXvADwFw+8c/XjCPM
         0mhA==
X-Gm-Message-State: ABy/qLY+dliYpb9jr0z/jy6bvbxYEZ6Xjof/qjd5OxZ9taXvBVhW7FxM
        c0yTWYO6DWhDrreZxzTIvQ7wzmeYX7PoEPGHhz3mvPhGVnHAgIUm8idm41HB+kn8nCOACNzMeFV
        JTHuTQmwAuPxF3xz8D8xLWPBU1x5NYeFNToQdmQkrJBm+RZ1nAtEH+eGiQIeMxC51m+/ThmQ=
X-Google-Smtp-Source: APBJJlGDtopDEFCCENvpj9bk0ucRozmxIamafw8OCk4paTc3ega52yzZuM1x2wqjc5oWp4XpUi/NXDGnD1HR1/9cuQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c952:b0:1b7:edcd:8dcf with
 SMTP id i18-20020a170902c95200b001b7edcd8dcfmr1194pla.4.1689698728793; Tue,
 18 Jul 2023 09:45:28 -0700 (PDT)
Date:   Tue, 18 Jul 2023 16:45:17 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-2-jingzhangos@google.com>
Subject: [PATCH v6 1/6] KVM: arm64: Use guest ID register values for the sake
 of emulation
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since KVM now supports per-VM ID registers, use per-VM ID register
values for the sake of emulation for DBGDIDR and LORegion.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bd3431823ec5..c1a5ec1a016e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -379,7 +379,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
@@ -2429,8 +2429,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL1_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0xf) << 28) |
-- 
2.41.0.255.g8b1d071c50-goog

