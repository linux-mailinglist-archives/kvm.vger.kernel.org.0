Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E96358AB37
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 15:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbiHENDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 09:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbiHENDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 09:03:02 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A753827FE4
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 06:02:59 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id tl27so4957277ejc.1
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 06:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=0XuiDf7ZoorVaLM+ZvCJPN0Mvu7jh9ql5l2EsEhr6Do=;
        b=JsBJZy5qI1My4jnleZ6nW8bQNRruNmU5La8PExjmrcUHXBadstNssmsT/mkIpSaie4
         VKWLmY2/yW0JdXBEHSIHRB93nAv+zHt/6UX6qViePP06c6hqboq3v4BW/Erx9P3XCJzj
         rgttPsyrThmV82/wk9C06ONY9SpYglBZjpQMSZ0UqI3/Y9zXOVTyU74XBKzdmoxK1xaM
         OSre9z8nHoV9yjG2Pb2uF2X7ZF0ixQ7o9eEsmuhbLW8G8+Omp/tuOXSOdBax5nUPydhq
         CrWpgp8fP+bJKBwk0Ed/yr4MI+g0WYiV9m+8nqqtYFP4L8T+LcV3b8mOt/8UhUjCbXVv
         qKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=0XuiDf7ZoorVaLM+ZvCJPN0Mvu7jh9ql5l2EsEhr6Do=;
        b=4ynpZ131J5PqpGjN73PB9aC9C5vlz5cW7Mtswj9VbTEAu755kmlGxjJaPnPYHQG39v
         jK3cAfhHEWdEM2tpaerSq7ko+ZqZmnKzq873nqnU+SLQU2Xn3RxiSrVpUh3AP0W5GFCw
         eRwPDsRBh+R08Tp751b/+DL1zTrTiPRZAR5TgYgwu50KZIvd9iuL1R4PGk93ZgR+JMtQ
         Cbe2oCPN+jX0iXhMvANs124LR2ZkgV76apYf2dHxv5p6oElKaf/Zzt+498Xvf0EI7w50
         e1G4Y/+pLx+IAMrXeitIKHZ50Cp7bhF2RFyWa9zX79rZ5RXaVgM0gYwejbaax6KZR8bL
         OmjQ==
X-Gm-Message-State: ACgBeo3nq+eCeZIW0pocUV/+R/l7UqqaBB3pSwjAeTZgu+Q5qtaRX2lF
        l7HgZTlrtZu9VUwUa3w/26Apmrq1OmWnhQ==
X-Google-Smtp-Source: AA6agR7lByrCnadveJD+BqR40UPm2GGfJ92K8HT36mw+5wkAGAvvn6OnKuKpOgVBxyPD9H74YT15mA==
X-Received: by 2002:a17:907:7ea7:b0:72b:6e6b:4895 with SMTP id qb39-20020a1709077ea700b0072b6e6b4895mr5100014ejc.338.1659704578006;
        Fri, 05 Aug 2022 06:02:58 -0700 (PDT)
Received: from localhost (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id j27-20020a056402239b00b0043d6ece495asm2039293eda.55.2022.08.05.06.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 06:02:57 -0700 (PDT)
From:   Andrew Jones <ajones@ventanamicro.com>
To:     kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>
Subject: [PATCH] RISC-V: KVM: Fix compile after merge
Date:   Fri,  5 Aug 2022 15:02:56 +0200
Message-Id: <20220805130256.683070-1-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The compiler usually complains that we've forgotten to dot our i's and
cross our t's, but this time it was complaining that we dotted our
commas. Undot the commas (a.k.a change ; to ,) to restore compilation.

Applies to kvm/queue.

Fixes: 24688433d2ef ("Merge remote-tracking branch 'kvm/next' into kvm-next-5.20")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f9edfe31656c..3a35b2d95697 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -352,8 +352,8 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	unsigned long pfn;
 	phys_addr_t addr, end;
 	struct kvm_mmu_memory_cache pcache = {
-		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0;
-		.gfp_zero = __GFP_ZERO;
+		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
+		.gfp_zero = __GFP_ZERO,
 	};
 
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
-- 
2.37.1

