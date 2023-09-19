Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9007A6A2B
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbjISRuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 13:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjISRuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 13:50:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA87E1A6
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:30 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59e758d6236so36179397b3.1
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695145830; x=1695750630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FfNGTxjW46m0vYg5JQZcFmeN0Q+crU/shufIChYdkI=;
        b=lsYPgEaENJhAm/UT5arGKGNsFrmMu/a+T4Iaske1Ha9/Pj93EjdFRl9MyclD93KjgT
         sRm11wGSCshnwi32Sgu4jccnYWIwP0WuOKN9OkkSCFesBc3ocaW8Ru5PH2jhuiUb1dG0
         LBk7Xp+igTWjCzGrfK7TKCHzpcIXZ9zIz8h+iMCeY8KivXLboAd1qtc+iHniZZp69+RM
         5vPpzz140NZVCRKDUpihvLZreKPBR56Ar+ESKPqvEi+TMqf91HoX8EyFE/AaITAhq0nd
         c5/xokj9hIIOr/FcWGXRdPcel6DDpKBAAAfXb9ewc3xCRGh0y13HlZn+mR/c6Nybuboh
         wCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695145830; x=1695750630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FfNGTxjW46m0vYg5JQZcFmeN0Q+crU/shufIChYdkI=;
        b=eRzh6Aoyq9nzRJmpSUAc/bh2Dxj95ERgymJuBAuiPMMsIqF3lYXfS4d8mYLQ36c4eU
         F7JAlh6HV1Pi2GobWkxafx0nT4bZ9IwGgY05jopBpr8w2WH9eCP45DoVryAJJZLEoqrw
         Mla0Z0jFkjBk0Dv8YF8Sf9r5ddy9WrxKzAU0Wi9uelR8rGMYWdp3L/1NcgLSbqfcKlsM
         wL/AxYGr41CLjS2SnIrY+dL4ByT6iqv949D7fCRDgdCqdnLvNd7eleam8Z0ZajB6Yuu5
         PYOX4R+ncNvVf9IQ9mpLuaClMccQOI1s3zbeq2u3ITU6j2wbSDybjwaMTodYswG61vXH
         V6wA==
X-Gm-Message-State: AOJu0Yys6MyDa1Wmfl+EDkQ2su0NC4YRKGGLcHG539zizCcVh77hoGDN
        ZS9mCwzwt3oN2G925+AABLuOTrenBbBB88jfSfJ6nZTtz/7PC8IPBbILWIx27B/9FBDuSWTSq1Y
        bWzL8ijKnTHDB3XOXRDQPJcOYTh+Zxio9pR+g2DhfeERMUE677jZ7aVguobRQQrLIltn12cI=
X-Google-Smtp-Source: AGHT+IHzfDyzqT0qS3LWIHvfZz7RLjnCjuKsmPhD/Jh5rsxGnZ1+liEskGzE0UZSm4JarDPcCE5W4ld3r7CjK2ykmA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:db07:0:b0:d81:78ec:c403 with SMTP
 id g7-20020a25db07000000b00d8178ecc403mr5069ybf.12.1695145829452; Tue, 19 Sep
 2023 10:50:29 -0700 (PDT)
Date:   Tue, 19 Sep 2023 10:50:15 -0700
In-Reply-To: <20230919175017.538312-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230919175017.538312-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919175017.538312-4-jingzhangos@google.com>
Subject: [PATCH v1 3/4] KVM: arm64: Use guest ID register values for the sake
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

Since KVM now supports per-VM ID registers, use per-VM ID register
values for the sake of emulation for DBGDIDR and LORegion.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cdb9976d8091..4dcc9272fbb8 100644
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
@@ -2445,8 +2445,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
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
2.42.0.459.ge4e396fd5e-goog

