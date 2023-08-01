Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5063D76C06D
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjHAW1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjHAW1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:27:06 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060EB2708
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:26:52 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6bb29b9044dso5642405a34.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928811; x=1691533611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOO1y6rFtOUhSmw3x6tvYmkLxmP/yHG5NyhRapfW0cw=;
        b=Kd2ObS4PBSVlc3KE0i7AOupNIkfPC0ojkymUuEs/RpkO7vw+pShEUn4xuiVqwfabzD
         FZ9JLaRVMxavQUj8C38DHrMaq3++WltjtYm8Z8E92/f66OfKLxSgG66NCbuo1MFyJ1cS
         KDkCTx06TvjUI1Yn1jyBlAgFnxsPFBB264zddxxbMpYsetlHE4tLVyFihpj+jewmc0tn
         Xhry03XR+F8kcm6YvPLhywmhHSKp3GX/I4QbCKJeWAWJNLyza7aVLbYs3YkPrkbRUQtn
         y75QrNhqLRkqpRUbNsCQeADseO8OdVK4aPJrFwu1gZoj4ArU/b/x4gJmk295AWswAf2s
         EW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928811; x=1691533611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kOO1y6rFtOUhSmw3x6tvYmkLxmP/yHG5NyhRapfW0cw=;
        b=iJkF1YKrTDG63EMZei36tOEwbtvwzPszmZYDu9TBrgVJThumK5/jirkctpqfNiT3Gk
         Yt/J9exIQq4TG3/axEp4E8hTHniG/hXeXexxZsUmOZRyET8/hPB8dwGMDJAZ99NjkD13
         wdQYfzSTSXUAHXyg468p5SJ7saflAH472njienDamjWDiProyyvqQW21syp0zrVN3z+b
         Ej8UzI18FhQVr99/hlCVqu1k+/BSr/AhRHePp5YWK0TrgPjskjNeXr9HYHxfLC+QBAU5
         cI02rRgmH+nBe63Q+iTaT2SseUTZlfsVSEc398Luw9OxOMxCL2FXBKKKPPjVpg6b6BlD
         H9iA==
X-Gm-Message-State: ABy/qLYzEuuvajQEFdDvZz2vgQvktNNkk8xlIJ/mE86ub71rLtiragLq
        xSu3+bcFECu5Y+cTyUvXhSrxog==
X-Google-Smtp-Source: APBJJlG4GWvMNowYo03XJ1piFonad21+/f7KwUq/B2gZi+XYLHHwgDZK/4ISSAWIkcafFvWJ1jjiDA==
X-Received: by 2002:a05:6830:1016:b0:6b9:9129:dddf with SMTP id a22-20020a056830101600b006b99129dddfmr16236457otp.16.1690928811545;
        Tue, 01 Aug 2023 15:26:51 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:51 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 6/9] RISC-V: KVM: avoid EBUSY when writing same ISA val
Date:   Tue,  1 Aug 2023 19:26:26 -0300
Message-ID: <20230801222629.210929-7-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801222629.210929-1-dbarboza@ventanamicro.com>
References: <20230801222629.210929-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_riscv_vcpu_set_reg_config() will return -EBUSY if the ISA config reg
is being written after the VCPU ran at least once.

The same restriction isn't placed in kvm_riscv_vcpu_get_reg_config(), so
there's a chance that we'll -EBUSY out on an ISA config reg write even
if the userspace intended no changes to it.

We'll allow the same form of 'lazy writing' that registers such as
zicbom/zicboz_block_size supports: avoid erroring out if userspace made
no changes to the ISA config reg.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 67e1e9b0fd7e..b0821f75cc61 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -187,6 +187,13 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
 			return -EINVAL;
 
+		/*
+		 * Return early (i.e. do nothing) if reg_val is the same
+		 * value retrievable via kvm_riscv_vcpu_get_reg_config().
+		 */
+		if (reg_val == (vcpu->arch.isa[0] & KVM_RISCV_BASE_ISA_MASK))
+			break;
+
 		if (!vcpu->arch.ran_atleast_once) {
 			/* Ignore the enable/disable request for certain extensions */
 			for (i = 0; i < RISCV_ISA_EXT_BASE; i++) {
-- 
2.41.0

