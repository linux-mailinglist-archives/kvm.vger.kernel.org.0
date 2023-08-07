Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC10A772A7B
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjHGQW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjHGQWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:25 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFF410CF
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:20 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-564a569e992so4240788a12.0
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425340; x=1692030140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SAQkX4jZeXwDCfCgjX41xn0J3qXI3kH8GLigtCxFkz8=;
        b=pDRm5CwavMR5jRpKD72ZUrsmD+2CLXvNIWstiXvmaRSSv7VK9Ts1ilDrGzHa/pUMUs
         W41Lc9xthBr1KwrEx+S+B4JjTjY+B4oAecXuJoJsGZ69NSTt6VPHiEgQN+rGoTD0AKpA
         S7G3jOomUeUH/oY6Pb+bc3DkpgGxtE7jkrU7rJTDn/ci0NzxKtcd/3F8LO/PCF2Xbo0I
         aT5ovgsjkbukUEgkhucP1zLUPBnf95fhokQO344RQWVsfoXa/q4tMSQQngs8OJplCmeU
         0r7p10s3bJrdwIlkodk0DdvtFe9gVKls+olA5YCzdc5THcH8b5ngMTGplo+KP1/aBZ0u
         5Q3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425340; x=1692030140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAQkX4jZeXwDCfCgjX41xn0J3qXI3kH8GLigtCxFkz8=;
        b=H4Y6xxTa9fROwqmZULb4vVcN4Vqtp8jYcj4zgW9WZI91fYp1eX/v8NgN05es/eyYrh
         jEZVTUTuvDwyoR2GiuW3lTpChzgIqWwsHUM4jpeVY+BTxixKAO0w8jH8N4En8NItdB5j
         UI7B8vdmfsFqutLLf9IVErIvrxUEE4fgu0lby7FsuM/1oLwt2+vRzQFoozez6EJ98Vgu
         ytbPuZvn0GhyMmN2B7NJ/m93GBipIPZZHuF6fY42rbTzMdIo7Kk5i5rFXSrZ6ltU1/tR
         5J2oiWtNTs5TYq7hT3j4WgaTWJRBKSrZDyP+x9CLN0jvn7mUhVmASspTWEr5H3cIZrdX
         E08w==
X-Gm-Message-State: AOJu0YzXlwqFdmBNjAVeczE82afV92f61EbUMyROHW1SDiahOAAURvXM
        XFvpm1X1Rl+Yzb8XZLLCtMUqABhytk81Zi9CFGBXZbO1iChb5Yn8dKePoeasPNjHOHos62/8zvK
        XnmrU3i74TQvVkAaxQI2Jg83aIQUyRuCsaB5inRV3SHUTGaDVwjq1s0GEGYocxXWs1jKwAGc=
X-Google-Smtp-Source: AGHT+IFFZxfoYywV7ZmGAj6x9E0RwK9qKQGx056gmXPqflmg3y3hhcRV+6dVUsAA9/fEaJG2keYm3J+S4fX0jbR1Pg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:3646:0:b0:563:e937:5e87 with SMTP
 id d67-20020a633646000000b00563e9375e87mr42124pga.5.1691425339660; Mon, 07
 Aug 2023 09:22:19 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:22:01 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-4-jingzhangos@google.com>
Subject: [PATCH v8 03/11] KVM: arm64: Use guest ID register values for the
 sake of emulation
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

Since KVM now supports per-VM ID registers, use per-VM ID register
values for the sake of emulation for DBGDIDR and LORegion.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 216905840c92..42c4d71f40f3 100644
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
2.41.0.585.gd2178a4bd4-goog

