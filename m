Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B596FC3E6
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbjEIKbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbjEIKbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:31:44 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44868DD93
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:31:39 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5208be24dcbso4005736a12.1
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628299; x=1686220299;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PG+A+9/fIV/ExGi75FEqrU6haa3ykbx364k88CAqjOs=;
        b=B9+GWY5AxyRstg0w2rDdp310x+FpVxN/5CyJUkdglxX17elf8YdK5332Ef/a8by+tt
         RYIViO4Uq7YrL3M8ZuFC8G/dtupwplGp2Kj1+GsdWWsduEQgfMVPiaUs4T4aI/6EpQmP
         A7zGjGB8fjBmU7ldGuZqLmIKodSLyzdnZYjE7cv8xyhQQigXE11lJQB3ErstpwC9JdgR
         0Sb/LgTEWCNLBOm3ypPPMhonQ12RL6arBExtZyPdEwehNjh3nKgJcnEEQTssHUrGDi/y
         4ofwA48T29MiRMt5WyZwXfzIFJpc/DlBGA/9qMQhnAduvI5P06wM8xCAt/i6iHhxVD4I
         Zkzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628299; x=1686220299;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PG+A+9/fIV/ExGi75FEqrU6haa3ykbx364k88CAqjOs=;
        b=Awc9oCtZh7z3XrysdLezoKZWTOkbRMY7KY2Unj6/WKYn7Z7pZoG8gbX21K/dOjd13X
         qrX62Ia7itso+1lly7AWxV8m8hMuyaKO1QiWqDvey1vPvo2Kuj9v2fPv6TI49RSsAUME
         Hf5fJa/G9M4TRA0tw3FprEEx+CmbfrD8dDcsZEA/EnUQVOwGJ3/pLGuTffTyeh+O16pC
         YrOj6Oe+L2d5+Xmgy8U6D1cecpPvYTE2FR9sFDQNgzDQZHppoPwPhLJ85LtgpuhonHts
         3ahjUUJpj2RUNJP5TTCr4ryRqWlgH/+tTOPZA8aK1CstNCm3KzJuME+ApXn700pns3/Q
         1Y3A==
X-Gm-Message-State: AC+VfDzc6/win4ZblrvmOMl+xerhGrN5ccuH4uokOXgExPPuO1Y6mzoQ
        +3QBRAa7WmSAVJ7nE7Vcuz3yUA==
X-Google-Smtp-Source: ACHHUZ5CLHLIAeI1mcgv08ZYoV9tvksZf4THmfiw41Juia/dv6ItXzsNsWolGM5RhjaOcyfX1QYZAw==
X-Received: by 2002:a17:902:ceca:b0:1a6:5fa2:3293 with SMTP id d10-20020a170902ceca00b001a65fa23293mr16306391plg.56.1683628298789;
        Tue, 09 May 2023 03:31:38 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:31:38 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH -next v19 05/24] riscv: Clear vector regfile on bootup
Date:   Tue,  9 May 2023 10:30:14 +0000
Message-Id: <20230509103033.11285-6-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

clear vector registers on boot if kernel supports V.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/kernel/head.S | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 4bf6c449d78b..3fd6a4bd9c3e 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -392,7 +392,7 @@ ENTRY(reset_regs)
 #ifdef CONFIG_FPU
 	csrr	t0, CSR_MISA
 	andi	t0, t0, (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D)
-	beqz	t0, .Lreset_regs_done
+	beqz	t0, .Lreset_regs_done_fpu
 
 	li	t1, SR_FS
 	csrs	CSR_STATUS, t1
@@ -430,8 +430,31 @@ ENTRY(reset_regs)
 	fmv.s.x	f31, zero
 	csrw	fcsr, 0
 	/* note that the caller must clear SR_FS */
+.Lreset_regs_done_fpu:
 #endif /* CONFIG_FPU */
-.Lreset_regs_done:
+
+#ifdef CONFIG_RISCV_ISA_V
+	csrr	t0, CSR_MISA
+	li	t1, COMPAT_HWCAP_ISA_V
+	and	t0, t0, t1
+	beqz	t0, .Lreset_regs_done_vector
+
+	/*
+	 * Clear vector registers and reset vcsr
+	 * VLMAX has a defined value, VLEN is a constant,
+	 * and this form of vsetvli is defined to set vl to VLMAX.
+	 */
+	li	t1, SR_VS
+	csrs	CSR_STATUS, t1
+	csrs	CSR_VCSR, x0
+	vsetvli t1, x0, e8, m8, ta, ma
+	vmv.v.i v0, 0
+	vmv.v.i v8, 0
+	vmv.v.i v16, 0
+	vmv.v.i v24, 0
+	/* note that the caller must clear SR_VS */
+.Lreset_regs_done_vector:
+#endif /* CONFIG_RISCV_ISA_V */
 	ret
 END(reset_regs)
 #endif /* CONFIG_RISCV_M_MODE */
-- 
2.17.1

