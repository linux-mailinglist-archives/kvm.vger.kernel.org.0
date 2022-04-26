Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7255107A5
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 20:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353362AbiDZS4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 14:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353114AbiDZS4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 14:56:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4661569E6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:53:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so3390941pjf.0
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Abl0bfYYrLlQ27vYh6a3IKNxFiISaIZQZeWkMU0B+HY=;
        b=vBrOC+clk/14uoGOtUn6c44gW3HFg6+QeB4YEt2tbdI3Rg4yeq77I+oddnQCUvlydX
         iqg0VvE+xjRD4sWxZ1mmoMfRyrVxDPrUtXKkDrNRWGiibUU5SffVNYDCOpqXJjxDdfm+
         /rqFvZzeeyDfpQ76ca7H7LzTLOeXPvHCD/pCuz5pOO8kXPjiAwdv46d+k1hN/PFWNd+S
         LE/PYTA7+dKF64/xYYMYdLWJgicaGpcdpGKTGGfp30OgMWLTSJq6OCxzp2iLWkNNeiSk
         DE2Xcjq/QTbTVXOE/59QHyVR17aRUr04hI760rCpzv0eJ487aQJHQthEkwcuJ3xj55vm
         C22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Abl0bfYYrLlQ27vYh6a3IKNxFiISaIZQZeWkMU0B+HY=;
        b=ubamSXI3bg7XX/CwHruYmg4oVRNwbebAY+A56LYp6lEL6QzKEkJ901eiBkEHzl4vja
         EY4NvOk18JEttAmKaB8M3tcRiZ06ZL4G9ctPb0+MvB8+cjnvGu9xcM7a3DpAW7a34qLL
         nod8SUAOlsxfAaw7dgpzEcJcVUGLyIkiP05Qi3jGzB4kz+LgMow5HNLf0qylPbTqzs9s
         VSssH2MjKVtpvgC4amCfO+GOpUXH8oWPvXCxDlJicd2+zDeX+VMCObfI5LZRVMYL/M+f
         nhnjRGj577aERK4OXegTtKtFY5Wm19/dNtXs5tzPliYEn5QIcfaK5H8GRz640LEZ5mnA
         hr1w==
X-Gm-Message-State: AOAM533s1sYfPHI1zqDQIXL3z+Fcj6+C3DJEGfsnukusuUYywCpjoecT
        LMARE8huvnBjDHx94Nw4/kGwNA==
X-Google-Smtp-Source: ABdhPJx/bBDnaGbhRf26Abl87DpdzPlrl9/ustlrU9hsLHOANPcCs60CUmoMIuPL0ZgfMH86wSd+tw==
X-Received: by 2002:a17:90a:884:b0:1d9:531c:9cd6 with SMTP id v4-20020a17090a088400b001d9531c9cd6mr16498367pjc.211.1650999188661;
        Tue, 26 Apr 2022 11:53:08 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id cl18-20020a17090af69200b001cd4989ff5asm3839664pjb.33.2022.04.26.11.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:53:08 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        devicetree@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v3 1/4] RISC-V: Add SSTC extension CSR details
Date:   Tue, 26 Apr 2022 11:52:42 -0700
Message-Id: <20220426185245.281182-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220426185245.281182-1-atishp@rivosinc.com>
References: <20220426185245.281182-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch just introduces the required CSR fields related to the
SSTC extension.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index e935f27b10fd..10f4e1c36908 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -227,6 +227,9 @@
 #define CSR_SIP			0x144
 #define CSR_SATP		0x180
 
+#define CSR_STIMECMP		0x14D
+#define CSR_STIMECMPH		0x15D
+
 #define CSR_VSSTATUS		0x200
 #define CSR_VSIE		0x204
 #define CSR_VSTVEC		0x205
@@ -236,6 +239,8 @@
 #define CSR_VSTVAL		0x243
 #define CSR_VSIP		0x244
 #define CSR_VSATP		0x280
+#define CSR_VSTIMECMP		0x24D
+#define CSR_VSTIMECMPH		0x25D
 
 #define CSR_HSTATUS		0x600
 #define CSR_HEDELEG		0x602
@@ -251,6 +256,8 @@
 #define CSR_HTINST		0x64a
 #define CSR_HGATP		0x680
 #define CSR_HGEIP		0xe12
+#define CSR_HENVCFG		0x60A
+#define CSR_HENVCFGH		0x61A
 
 #define CSR_MSTATUS		0x300
 #define CSR_MISA		0x301
@@ -312,6 +319,10 @@
 #define IE_TIE		(_AC(0x1, UL) << RV_IRQ_TIMER)
 #define IE_EIE		(_AC(0x1, UL) << RV_IRQ_EXT)
 
+/* ENVCFG related bits */
+#define HENVCFG_STCE	63
+#define HENVCFGH_STCE	31
+
 #ifndef __ASSEMBLY__
 
 #define csr_swap(csr, val)					\
-- 
2.25.1

