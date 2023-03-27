Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAF36CAAFA
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjC0QuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjC0QuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:50:10 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AB02D79
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:09 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l14so6102823pfc.11
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935809;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CteMDAzkrOKUdcbIvPON419eHbnDZdFOKMS6mt0sWZE=;
        b=NZQUMJm4UhSWq4HMnsWtalvxApw4dZHQUz288i4sRF4WGaZumUVTEMbqVJAFZ84jSb
         WbmQ30+apNxyzGO6yiVHQCHYO6SNgltix5W1Q1BR9otT7H1uQiU8icnM/sauEHn3kOMW
         TxhrZ9cQuW9RZUfqtiz6Q3NoZUWnaWedxQYfr6V+2/eXO2eVaJjMk+dSOt4HXZ9y/wR2
         uIHGjihEBkhv6Cg+jTfrO5LTyUx+safew3qHN4KAdERbXkarFy8Hf1Peiuix0+CCL4L+
         Wr+MCHq2StWede9u206lrINH0Qq6SDuG3xtHKxuCIps9op09h+4TG6AaRAiclUxgBeG6
         nihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935809;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CteMDAzkrOKUdcbIvPON419eHbnDZdFOKMS6mt0sWZE=;
        b=e/KxgvQV/2xbpkC1fl4d30z+QNPLhBNpb+U2+x83be9x1eCMFkTtEtp7tVwk6Clp/V
         fx0todGcdLpUxZ/HADk8vrcYzU/PIZatlOYatfMar3DY+jFKHvGGTJO+9hM7cMUDz92P
         G630Lo0dDubuhLD83DIVi41PjiUxhBDfjyEe/6QB7PNPAZoFMDo/s5daNLqrA2z2nYiW
         j1WoexLUt0F0Ml6kVaXpx7ITSvjjk887QBO8Cg520n8GL8MHYLfkyKfFuO2CJd+88oEX
         l2DxSrsFuLN4E+3SZTBgV+kxtGrY7EFS7+6P2mV7wVyr3UdVZa26b/hnKNmpOu6qT7DH
         ekfw==
X-Gm-Message-State: AAQBX9cT4Rvd24e3uma2ffDU/rJ1paU3zGYsFxUyOzLm9oZ0nb6uJ3vo
        Ex4i62kDXfnVE+3B+q+sqzRjsA==
X-Google-Smtp-Source: AKy350bLjud2+4aNJDUYz8on3CavSs/U3XeCm3794fOlo+5cZqKNXnQmdb8hboD4NZoSVUv6RquMIw==
X-Received: by 2002:a62:7b44:0:b0:625:e77b:93b2 with SMTP id w65-20020a627b44000000b00625e77b93b2mr10800860pfc.5.1679935808887;
        Mon, 27 Mar 2023 09:50:08 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:50:08 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Guo Ren <guoren@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -next v17 04/20] riscv: Clear vector regfile on bootup
Date:   Mon, 27 Mar 2023 16:49:24 +0000
Message-Id: <20230327164941.20491-5-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

