Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8796FC3F7
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbjEIKd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbjEIKdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:33:18 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6C010A05
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:33:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-24df4ef05d4so5139929a91.2
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628382; x=1686220382;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2CmyEkggETxM6j+XfIPwTDc2gU78hVyVqaTRQMELVN4=;
        b=D/421YHEpIqNI2B2tC62nRVwKRwWISvXzmsVHqTnpPS7sWEA5oV1gg2yv1CEkeGvOm
         bu1OOQ6Yf89bbybbbU0wwjnQwiQVjiB/EhJ03s/W50aVstzO9WgbfPOMzwwsnKGKI0to
         MZQ2nQbm8+QMiWVOZnDBjVZcsGMvGpMmQnb1HigNlJb39UODk9qWFugpBSB2zx4VIkny
         sBXzjT4kXsh3egVScNVaKPzn/3b8PGUP2CoQ7prUfczz+/WdJZ1tjNK8fzTX0PNwwj78
         xL/z1eYT+/J+H40phb43402KErFEDLk32KMdSisouu6uFPJiGp8NE8k3YQV359BRYaP0
         u77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628382; x=1686220382;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CmyEkggETxM6j+XfIPwTDc2gU78hVyVqaTRQMELVN4=;
        b=hOCWpHOL1PIt45WBXdUegK8yKErbfulb1EvT4HbE4rbLiXqxscjcr+ZGPNJtyAQ0Px
         OzwbhP2fLFB65eQTPV9neUM0pZFmVijEgc4xH+w2Y9++/kgConwEpxZX9ObXkHG5AP85
         lb280aT5FNbuVb/7IFoucqAXXVmY8V4v2RQipyx6qOs8TKW0yVKu9kd4jPu0Rl9ceStf
         0yVCgY764aEfLOGqRYKwzBbBvMXAXQL8x2nZsRoqLdIzWVsNPiGtVfcIthUiCY6NY+3R
         1DzdSA7mq9ME4KLclrnyvnypa3T89Iog6FctfxWn/5g93HbnuUY7AE1m9LpnxwxDSWfA
         uG4g==
X-Gm-Message-State: AC+VfDwlLulNoS1KH4xycBny6yI2qWTt++Osm/YAf1+f3pbQjU756V5P
        xCSgcAvEChmb7wsA3e5nW6UZGg==
X-Google-Smtp-Source: ACHHUZ4Ly10PFLn+5gXRgXrwx2fNdl0W+ClxbNID56SqwDXqCRw4c0/ArwzFpS0/+IbhyeeqFQd3tg==
X-Received: by 2002:a17:90a:2b4a:b0:24e:49d4:bc42 with SMTP id y10-20020a17090a2b4a00b0024e49d4bc42mr13483367pjc.1.1683628381876;
        Tue, 09 May 2023 03:33:01 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:33:01 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v19 18/24] riscv: kvm: Add V extension to KVM ISA
Date:   Tue,  9 May 2023 10:30:27 +0000
Message-Id: <20230509103033.11285-19-andy.chiu@sifive.com>
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

From: Vincent Chen <vincent.chen@sifive.com>

Add V extension to KVM isa extension list to enable supporting of V
extension on VCPUs.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index f92790c9481a..8feb57c4c2e8 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -121,6 +121,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICBOZ,
 	KVM_RISCV_ISA_EXT_ZBB,
 	KVM_RISCV_ISA_EXT_SSAIA,
+	KVM_RISCV_ISA_EXT_V,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8bd9f2a8a0b9..f3282ff371ca 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -57,6 +57,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_H] = RISCV_ISA_EXT_h,
 	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
+	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
 
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),
-- 
2.17.1

