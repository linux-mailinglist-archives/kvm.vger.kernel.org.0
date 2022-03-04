Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4174C4CD217
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbiCDKLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbiCDKLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:11:31 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE9D1A906E
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:10:44 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id z8so4038751oix.3
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 02:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j4K802Y2y81gZsHnG8n5Upy6Gh/ZJaqULK4VvQ0lL1Y=;
        b=5Rc80sbO6imTYOal9B4/lAuGi6JYMVqmYfmLM8mb7Hqgr6t+mFbugXVIpkpuhQ1WmH
         Jxuz8s32PIz81a63RjuWWLotQcEWM1oM8QoY0Vqw0W811ORR6C7yQ4karCDuPfXPaeyd
         0xWqpXEgdbGYgjKpNl5e2pIpjQPPOFYd4TEzZ8rwHwTSuVcb3exLUaP7D53njeedYIcI
         bknCk4UdF7GVYAXJGyfpq9tovbeU1a9QADKY3r5eY4Edx2/rVUKNCUopgj2NTxvKgLfQ
         sECicwicnxpBIPlGjj+qpzagKEEtnUQW4wbo4YDdAcvJCBAGDLei5IeoYNBVE30VGTDn
         wRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j4K802Y2y81gZsHnG8n5Upy6Gh/ZJaqULK4VvQ0lL1Y=;
        b=eGyi6gFmF1/SzAgbU+cM8Hfbgpb01NHDwkUvKqAnp51JdhJTjI8gGdsg8ATW2G6zbw
         PE9U++51Yd1GpsIfLKegf6NPzA4IG90av1GyYRTNTjJMzEuaqtanK34Ovx52ABhbPg+C
         5sfH3mE6zpNkmrcNjWm4ns//Rdvum4zoWQOZbaUR7ACeQnWgTvxWgusGHvfcNuo+03lN
         dlkdYuIY4Nfm5Pv5FcYInzmFP8gzE6IoTaI4s6kfe8wNvtHHwBIMKrFJGFVdSqygctjU
         XdfWdKcH7eFr4qBiFMnQ9e3aKkgDKk8OzZy9BqRH0GCeaHpGwRe1V0TcxylvCDJbCmvD
         uuZA==
X-Gm-Message-State: AOAM533EHU94Ebz/Q3rSLhKa2iyaZtiLjWbAwHxaNOHo/VIwxDdkP+0w
        x2e1SxMTZ3Wk0GAFVFQh1HHOXQ==
X-Google-Smtp-Source: ABdhPJzfIQzVhVmvRiecIEwCqv8Dyk4654/cCdYq+UuzDs4cwgHCr4IGnDomEUsrDCKXIFlnySKnsQ==
X-Received: by 2002:a05:6808:1446:b0:2d5:281f:9cda with SMTP id x6-20020a056808144600b002d5281f9cdamr8698391oiv.13.1646388644171;
        Fri, 04 Mar 2022 02:10:44 -0800 (PST)
Received: from rivos-atish.. (adsl-70-228-75-190.dsl.akrnoh.ameritech.net. [70.228.75.190])
        by smtp.gmail.com with ESMTPSA id m26-20020a05680806da00b002d797266870sm2358769oih.9.2022.03.04.02.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 02:10:43 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [RFC PATCH kvmtool 3/3] riscv: Add Sstc extension support
Date:   Fri,  4 Mar 2022 02:10:23 -0800
Message-Id: <20220304101023.764631-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304101023.764631-1-atishp@rivosinc.com>
References: <20220304101023.764631-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sstc extension allows the guest OS to program the timer directly without
relying on the SBI call. The kernel detects the presence of Sstc extnesion
from the riscv,isa DT property. Add the Sstc extension to the device tree
if it is supported by the host.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 riscv/fdt.c             | 1 +
 riscv/include/asm/kvm.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 2e69bd219fe5..a2bea5e17749 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -18,6 +18,7 @@ struct isa_ext_info {
 };
 
 struct isa_ext_info isa_info_arr[] = {
+	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index e01678aa2a55..c7c313272c0b 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -97,6 +97,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_H,
 	KVM_RISCV_ISA_EXT_I,
 	KVM_RISCV_ISA_EXT_M,
+	KVM_RISCV_ISA_EXT_SSTC,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
-- 
2.30.2

