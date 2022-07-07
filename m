Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFA556A63E
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbiGGOzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiGGOy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:54:26 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E162F3B1
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 07:53:36 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 23so18952533pgc.8
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 07:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fD57yUsjliqe5212UC73jciMYLhocl/mJZza20iLtLM=;
        b=HREjwpOHYeWrU6A6/U2oDeo0YtAehYjc/ZJ9j7FbEluYn7HuC1dGywFpW5pQZNDQka
         po7tV7v+W6APFRZv3E5Sfh3p95lGBAzAkE34O2BGSXhBfW7ePf36VhZHZHGsu0jBEOuZ
         hYeotUD3v1d4C9iqVEIIc7oRDwXgVbgDme5nEHPHA+MZD8l92z2Wxrjt7vdQ9m7RMPI6
         ZQrulgBKu1vD8bC+KurYyKhVVsS2GdRNUUoP3phn64wR3QTNpbAFw+NJJq555EkiXyNx
         w1g+vBw0i2lj40prRY3F+h0PgZZgqgzbCT70rpqbdfb5MTs94SktHewWkRXOdHHm1G+Y
         44TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fD57yUsjliqe5212UC73jciMYLhocl/mJZza20iLtLM=;
        b=hkLagfbxDHo9OMsOccibK8wmJrxAlUgIzgAW4ExnDUoeVh1uISwkO8kpCKZhABV14b
         bkRqJgiwRz2SqyVPI+JG34z91RxznQvq5oB1rcz0/29QVnr3er2wwITM+tVL5pXm0Sro
         VzyKze+ZUf0hBru6FkHG8CcVJoaexecMlGbJ2mpjTxwV6XKTT51rJ298FSG2nB1g0rE0
         QMBc+TSEM1U4kKdmMDfsiwjThSIkU+aeWvJf6cjbbIBS1ACskXhddVJ04JKKdMaL5giO
         pEAgEHMN+PO01jhH8yTFvUtf2FRKESvNrlh96e5Dl+y4yb/POcntHZYNcnZFNDeYAqjb
         B7bQ==
X-Gm-Message-State: AJIora9kIw1k7RnmBuPuMqn73nVo4YfU/7q1ToeZPcm5OBjwk69ks1zm
        8bWOOjiwwpuTDhGrVjL+vrEfEA==
X-Google-Smtp-Source: AGRyM1vkT5xNsTOaWuTJFKrN6WLK7LJ8+AssTop+Ji1DBkYJgjBG9dfbv3kSkw24C7PkCVqpljI9wg==
X-Received: by 2002:a05:6a00:1688:b0:517:cf7b:9293 with SMTP id k8-20020a056a00168800b00517cf7b9293mr53059954pfc.7.1657205615717;
        Thu, 07 Jul 2022 07:53:35 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([223.226.40.162])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7951a000000b0052535e7c489sm27144231pfp.114.2022.07.07.07.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:53:35 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 4/5] RISC-V: KVM: Use PAGE_KERNEL_IO in kvm_riscv_gstage_ioremap()
Date:   Thu,  7 Jul 2022 20:22:47 +0530
Message-Id: <20220707145248.458771-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707145248.458771-1-apatel@ventanamicro.com>
References: <20220707145248.458771-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the host has Svpbmt extension, we should use page based memory
type 2 (i.e. IO) for IO mappings in the G-stage page table.

To achieve this, we replace use of PAGE_KERNEL with PAGE_KERNEL_IO
in the kvm_riscv_gstage_ioremap().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f7862ca4c4c6..bc545aef6034 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -361,7 +361,7 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	pfn = __phys_to_pfn(hpa);
 
 	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
-		pte = pfn_pte(pfn, PAGE_KERNEL);
+		pte = pfn_pte(pfn, PAGE_KERNEL_IO);
 
 		if (!writable)
 			pte = pte_wrprotect(pte);
-- 
2.34.1

