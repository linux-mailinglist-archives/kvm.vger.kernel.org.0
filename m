Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4129E507E39
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 03:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358759AbiDTBf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 21:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358747AbiDTBfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 21:35:53 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5262BB0B
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:33:09 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so191180pga.0
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bQGz28Ui4S/iukqjTafR3gtWfXZeyNKknhgIBizer1w=;
        b=Ml9jMffdoy/2q7KFGepfvYHABxn+GEgv6sFYcp7cRyRu9aeoki9WAtEKAWMRAnc04b
         yEJH2yveccXmJIT0A2KILfR4/dg8uWdcp7hvfDh/vJlBov71W0uNrMeCwwIVI9EjpxK1
         fvrh9xZIKnqtiJrAaoHbfYx2E1eFlL3KCfwHzfYTZ9YR7LzBBs09DE1U5SWdV9IpfHqR
         PnJpmAllJD3NC0fYdqwcemLqg28r6Z4dErbLY2yrH5Ejcpj51TwdGju+84Up0oB0+2ak
         eF2hLnIWyphii/a1xhm8Nvs77zvRqi8ax9kGVCkMdeBRFw2H8/xHKsFa6g5UfjI0U/ST
         fR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bQGz28Ui4S/iukqjTafR3gtWfXZeyNKknhgIBizer1w=;
        b=7uulHSQqBTcereKKsrMr3o1Gij6zy0rlCwVe6PA2rdjSeRGiJdOTmji6xT/N+HXLh6
         EE+4gI2IuxOARlad2BoWL2J4cyKGAgWo+ob5Ns5vt9m0LRmX0O/XoeVBOqvRblyOO17W
         arq2RkOPBFb+bLA8t5L5NXzdtILQSLh3Rrg/D+ovopxsoP2pMPx31siWU4RchxY0TIUm
         cDXpxZuEuwgmLcMtWZi9ILGouutqlSPYKgdp0SGTGQk2lxT2zWUcNW0yqjq8SiALlDf/
         ulI26gG9kZBZySpQrSzoK0b8jM7IxtT1OVpUT5+u8WLPqaww/uJmr2I6eOF0/MUiAnSO
         5oww==
X-Gm-Message-State: AOAM530ifn/hLx4kG0sJjC771cBbhbLL7YUPyZLVGo4DNs9GaIGc7NWs
        oG8wloEHsYCNgxORlPGA9a4k66NtgtSn3Q==
X-Google-Smtp-Source: ABdhPJzxTpZ+2xwx1gMkeidRVI2UERYeMHLYI3TWIyQPEGUnycJdzAomsob4aGhDIn3i1GIkK78eYA==
X-Received: by 2002:a65:5286:0:b0:398:dad:c3d8 with SMTP id y6-20020a655286000000b003980dadc3d8mr17233342pgp.228.1650418388951;
        Tue, 19 Apr 2022 18:33:08 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r13-20020a635d0d000000b003aa482388dbsm2484863pgb.9.2022.04.19.18.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 18:33:08 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     kvm@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        devicetree@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>, kvm-riscv@lists.infradead.org
Subject: [PATCH 2/2] RISC-V: KVM: Restrict the extensions that can be disabled
Date:   Tue, 19 Apr 2022 18:32:58 -0700
Message-Id: <20220420013258.3639264-3-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420013258.3639264-1-atishp@rivosinc.com>
References: <20220420013258.3639264-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the config reg register allows to disable all allowed
single letter ISA extensions. It shouldn't be the case as vmm
shouldn't be able disable base extensions (imac).
These extensions should always be enabled as long as they are enabled
in the host ISA.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 2e25a7b83a1b..14dd801651e5 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -38,12 +38,16 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
-#define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
-				 riscv_isa_extension_mask(c) | \
-				 riscv_isa_extension_mask(d) | \
-				 riscv_isa_extension_mask(f) | \
-				 riscv_isa_extension_mask(i) | \
-				 riscv_isa_extension_mask(m))
+#define KVM_RISCV_ISA_DISABLE_ALLOWED	(riscv_isa_extension_mask(d) | \
+					riscv_isa_extension_mask(f))
+
+#define KVM_RISCV_ISA_DISABLE_NOT_ALLOWED	(riscv_isa_extension_mask(a) | \
+						riscv_isa_extension_mask(c) | \
+						riscv_isa_extension_mask(i) | \
+						riscv_isa_extension_mask(m))
+
+#define KVM_RISCV_ISA_ALLOWED (KVM_RISCV_ISA_DISABLE_ALLOWED | \
+			       KVM_RISCV_ISA_DISABLE_NOT_ALLOWED)
 
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -217,9 +221,10 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 	switch (reg_num) {
 	case KVM_REG_RISCV_CONFIG_REG(isa):
 		if (!vcpu->arch.ran_atleast_once) {
-			vcpu->arch.isa = reg_val;
+			/* Ignore the disable request for these extensions */
+			vcpu->arch.isa = reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
 			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
-			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
+			vcpu->arch.isa &= KVM_RISCV_ISA_DISABLE_ALLOWED;
 			kvm_riscv_vcpu_fp_reset(vcpu);
 		} else {
 			return -EOPNOTSUPP;
-- 
2.25.1

