Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FB163AD6B
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 17:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiK1QPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 11:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiK1QPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 11:15:03 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1141D334
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:14:51 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id b4so10937904pfb.9
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NydSuZRA0dQJSw5CpEPlhY7ambuW6DYL2PJN724q2rI=;
        b=AVabAj97DTRMDHk26gRQuTTvqQGRoIDt2H/tGtRwd8LHgE1VEctsODHZScQIhJkXYN
         E0Q5igJWPbdFexk1mtJJfhVtldDVKyXylDiKWPpzJwgCUWR8VotqizkG0gRjy6dBWXmr
         tUXyyg0cpn/OrwFExlEBj5gt7vMuR4MBNbYnE21OEAyhKvyHCToWXJsstFTI17y0Bwl2
         Z4i4NbmR8QAdxRhzMRr30V9dBUvW+RI1+0eFo9jfBOknZoUfazzUD74HPDxwOUVjMSj1
         DoBDubwRU1TQhiAP5lhcLkA4+Km9UT/0dOD27oFlWZvFr8pkN9LlxPKvsXsAIqo447Z6
         UOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NydSuZRA0dQJSw5CpEPlhY7ambuW6DYL2PJN724q2rI=;
        b=C6FOUXNpirbCZEpMZUFFQepUptCkCfaUVCApn6tnOTQ8EHZ9/URffxkyotz/cSuP8P
         7Lm6r7+7yIPnV0mmcBceml2UQH1MjacgqUwcRGjLUGHZK0lRvr/A06xBfYVKvrJCTblX
         pZkEvAHaYHSKjPDpsJidTCmcpzyCsXGiyne3OeWmG+eq134/NaNqIius3k3bYYz4j63Q
         qwQMa06HPWuB05JXOCp2zKOxr9CMEMSsfQmLspIBv1jlX4hzyRu+bPypxwHqPsosOZFT
         ueZJ4gbTNnbrl7NVGEe8AohZ/krrp0cEIaj02a8GmnKN+ezLnm3B1K2ARql7LCSaGH0t
         p6Cg==
X-Gm-Message-State: ANoB5plDPjpfVXSMxnMdNvRMvXSHH09b9pWcXo6dr4ln8xWjhESIlF0L
        fevTvOgiQ4HyVqOr03aokSmSZQ==
X-Google-Smtp-Source: AA0mqf4p10ZMWAzeqgtd0+xVNsa9fT5Xes0NR7/AU5l0dqEK0XcOVjDvxuhH8ACyPhvnJBlmgYcabg==
X-Received: by 2002:a65:5a4c:0:b0:477:ba9d:ef8 with SMTP id z12-20020a655a4c000000b00477ba9d0ef8mr23807987pgs.98.1669652091114;
        Mon, 28 Nov 2022 08:14:51 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.85.0])
        by smtp.gmail.com with ESMTPSA id k145-20020a628497000000b0056246403534sm8210805pfd.88.2022.11.28.08.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:14:50 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 4/9] RISC-V: KVM: Use switch-case in kvm_riscv_vcpu_set/get_reg()
Date:   Mon, 28 Nov 2022 21:44:19 +0530
Message-Id: <20221128161424.608889-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128161424.608889-1-apatel@ventanamicro.com>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should use switch-case in kvm_riscv_vcpu_set/get_reg() functions
because the else-if ladder is quite big now.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 982a3f5e7130..68c86f632d37 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -544,22 +544,26 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
 static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 				  const struct kvm_one_reg *reg)
 {
-	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
+	switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
+	case KVM_REG_RISCV_CONFIG:
 		return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
+	case KVM_REG_RISCV_CORE:
 		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
+	case KVM_REG_RISCV_CSR:
 		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+	case KVM_REG_RISCV_TIMER:
 		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_F)
+	case KVM_REG_RISCV_FP_F:
 		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
 						 KVM_REG_RISCV_FP_F);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_D)
+	case KVM_REG_RISCV_FP_D:
 		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
 						 KVM_REG_RISCV_FP_D);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_ISA_EXT)
+	case KVM_REG_RISCV_ISA_EXT:
 		return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
+	default:
+		break;
+	}
 
 	return -EINVAL;
 }
@@ -567,22 +571,26 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 				  const struct kvm_one_reg *reg)
 {
-	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
+	switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
+	case KVM_REG_RISCV_CONFIG:
 		return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
+	case KVM_REG_RISCV_CORE:
 		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
+	case KVM_REG_RISCV_CSR:
 		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+	case KVM_REG_RISCV_TIMER:
 		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_F)
+	case KVM_REG_RISCV_FP_F:
 		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
 						 KVM_REG_RISCV_FP_F);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_D)
+	case KVM_REG_RISCV_FP_D:
 		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
 						 KVM_REG_RISCV_FP_D);
-	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_ISA_EXT)
+	case KVM_REG_RISCV_ISA_EXT:
 		return kvm_riscv_vcpu_get_reg_isa_ext(vcpu, reg);
+	default:
+		break;
+	}
 
 	return -EINVAL;
 }
-- 
2.34.1

