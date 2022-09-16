Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74F05BA6F5
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 08:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiIPGnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 02:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiIPGno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 02:43:44 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E5EA2D88
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 23:43:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o70-20020a17090a0a4c00b00202f898fa86so10023635pjo.2
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 23:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=XafrQyV1Y8bilPnzIvj7YCctN4S0mQCoBp5K3q3Hq6I=;
        b=EAlsYtP0KasPGOytwKFV6O5CquVzTo7QRBtT0F9wTkJgFbhHmTXF9mHkuoiF3UJtBI
         imyOMALyT3iPmVwPIpPTcHWwRka+TRPpLd/NXyFAHy5FmuEBrF9fOOOQ0X0b858kFYs8
         Fjm+HYATR8D6me9coHOPcfM/RTWhRGArVjhUe0BuavtjP3EpCERi7Zqbkx3iqfnMB0uQ
         no1WSBy5t7t5tmJfXwz79whqYF1wn3nrJKcA1RVdDI/YPDMH/g0rckdqfIG9NHX/wpN0
         A6djnTVJoegqDk1ONijMPo0pteuoEsn76LI6rnOKbIKpU1fyYqItzqyzrgdid1+u2af+
         3MZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=XafrQyV1Y8bilPnzIvj7YCctN4S0mQCoBp5K3q3Hq6I=;
        b=uYZiYaj2CVK2G7ANDcsWt/xFfeMjkDRkEdJNkCA7gDoLKMBfUdrBJsxWG9JjiNfqeN
         xvdbtuiEA6Lb/8r1SVD6oC/6wrQNFV8H88PK5DveFIz29tfq96SoQBP/dQFEmzT+4vuh
         apcKrly47zPHtV4LE+Fa1KZ6y86ZAaRR4HozmQdYJkvRLy5P8uhSndWIahEM2tksIO3W
         NNPnYnUgR9QPDnJFmRqkWiVysuPZNwwDOjEYaVbKXFVXwTOi3ylhkKcCojtwuy/BViXj
         LDArdYB8nNX6bd9xvwR7XKMqr6r7UZHotyiGgb07FcFLTC4I6EbpcKbirZcNBPs3N8/r
         mLUg==
X-Gm-Message-State: ACrzQf0Cogo2btv7MdaF5+TrSPNfV0VsO9a53yf5nEvAv0nd1iFdvI+J
        sxF93r6C2voFHG7ua5hHEgqdyA==
X-Google-Smtp-Source: AMsMyM7cVJjO5hXpd9uJ6kurm9SpzSp4DpC+0Gpjd7g1HRdik9EjITEzUUx/nF+Ul6IfwHBhfvUJIA==
X-Received: by 2002:a17:903:2015:b0:178:8022:ff1 with SMTP id s21-20020a170903201500b0017880220ff1mr2332456pla.18.1663310622963;
        Thu, 15 Sep 2022 23:43:42 -0700 (PDT)
Received: from ThinkPad-T490.dc1.ventanamicro.com ([182.70.62.242])
        by smtp.googlemail.com with ESMTPSA id p4-20020aa79e84000000b0053ea0e55574sm13501724pfq.187.2022.09.15.23.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 23:43:42 -0700 (PDT)
From:   Mayuresh Chitale <mchitale@ventanamicro.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Mayuresh Chitale <mchitale@ventanamicro.com>, kvm@vger.kernel.org,
        Anup Patel <anup@brainfault.org>
Subject: [PATCH kvmtool 1/1] riscv: Add zihintpause extension support
Date:   Fri, 16 Sep 2022 12:13:24 +0530
Message-Id: <20220916064324.28229-2-mchitale@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916064324.28229-1-mchitale@ventanamicro.com>
References: <20220916064324.28229-1-mchitale@ventanamicro.com>
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

The zihintpause extension allows software to use the PAUSE instruction to
reduce energy consumption while executing spin-wait code sequences. Add the
zihintpause extension to the device tree if it is supported by the host.

Signed-off-by: Mayuresh Chitale <mchitale@ventanamicro.com>
---
 riscv/fdt.c             | 2 ++
 riscv/include/asm/kvm.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index e3d7717..7997edc 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -19,6 +19,8 @@ struct isa_ext_info {
 struct isa_ext_info isa_info_arr[] = {
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
+	{"Zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
+
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 7351417..f6f7963 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -98,6 +98,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_M,
 	KVM_RISCV_ISA_EXT_SVPBMT,
 	KVM_RISCV_ISA_EXT_SSTC,
+	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
-- 
2.34.1

