Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004CF5824FC
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 12:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiG0K6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 06:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiG0K6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 06:58:21 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A42048E81;
        Wed, 27 Jul 2022 03:58:19 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-31f445bd486so52428177b3.13;
        Wed, 27 Jul 2022 03:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+nM0z4zkbNurHCJ2O2FDuPzoZOWUDunYm+zsnrOGmOE=;
        b=NvHxgA64TcVZWVj0Zkp373TEvfX6smG1F5OWG4WUxxCekfTLQ04NEvTwW8P24I453J
         QtvqVi/T9qSQB7cong2b02CEE00lObQU5/mAF/utGBDNKuQeqgHdDIbAvcjC1S7XOLHM
         5Xxyk+noB1q0hzEcyF4ulpmplBnloYaJiIhDk7K5EL9NY+/5/NZYSuxfttyMJjfRRnoS
         ogMWCgfP+9mtKLlF//nlKyHpDEbRFFRsA8c2YPVvZ+Tf39pRiDJtQpA/baXGS1LnOlS1
         XXtT25jPfiYI0fU5xAm4WwH1sUYMXetN8uqaYHosmsNGmrgkfi+/5Gdc8VKmMlHjiIOo
         eBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+nM0z4zkbNurHCJ2O2FDuPzoZOWUDunYm+zsnrOGmOE=;
        b=ZWjkhr3Oo5tBLz+LicJsZSyiP4y0iQ7tijqK3noIb4znRCwzG/j3tlXZBQR3xNPJGx
         pMcQRa3VQRvVEo368BYahp390mxBbLLFlV+xSqcKLSpZyk020iuDlA9SNNdr2NEqH+sg
         emVeiB32/LK2VS0RPQ+7/8PntkB73J0N6rJ2gjq9XFneyVxGNG0yxf7YJoI15c5Tj45p
         H0MSW7HMUqjwlVkznQYWjbQxlgqW/Cx65ZGwHG0I+O3NxcGGcpRJNB4cqENImuPuJbZG
         zdNEGwL9qdRSvdqBIVfvTmhOdnViYGd6UpNdHhlHoOzbKLEJ0ggxaE625gVhNSM4bm3b
         f2Lw==
X-Gm-Message-State: AJIora9AlkCDo8r+pZw+Yc0grGtyqoAkFtRYJoW0Ff+lgPdwTZbFjI2S
        3EIaNXEbUFdjxZ0ijN1cEfKxcdKs3ck3URmCEHA=
X-Google-Smtp-Source: AGRyM1vSTOkM799B3+gTj3tXbYxz9DCPkHcK7bX/iUgAJ9R8CP3G8uzIC8Ihwikmuhuxsn2nmP9hJd55onmZnRuxJL8=
X-Received: by 2002:a81:1b97:0:b0:2db:640f:49d8 with SMTP id
 b145-20020a811b97000000b002db640f49d8mr18215415ywb.326.1658919498562; Wed, 27
 Jul 2022 03:58:18 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Wed, 27 Jul 2022 18:58:07 +0800
Message-ID: <CAPm50aKursUrDpgqLt7RT-VoSfBJswsnR2w1sVAt5mburmdd8g@mail.gmail.com>
Subject: [PATCH] kvm: mmu: fix typos in struct kvm_arch
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

No 'kvmp_mmu_pages', it should be 'kvm_mmu_page'. And
struct kvm_mmu_pages and struct kvm_mmu_page are different structures,
here should be kvm_mmu_page.
kvm_mmu_pages is defined in arch/x86/kvm/mmu/mmu.c.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8281d64a431..205a9f374e14 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1272,8 +1272,8 @@ struct kvm_arch {
        bool tdp_mmu_enabled;

        /*
-        * List of struct kvm_mmu_pages being used as roots.
-        * All struct kvm_mmu_pages in the list should have
+        * List of struct kvm_mmu_page being used as roots.
+        * All struct kvm_mmu_page in the list should have
         * tdp_mmu_page set.
         *
         * For reads, this list is protected by:
@@ -1292,8 +1292,8 @@ struct kvm_arch {
        struct list_head tdp_mmu_roots;

        /*
-        * List of struct kvmp_mmu_pages not being used as roots.
-        * All struct kvm_mmu_pages in the list should have
+        * List of struct kvm_mmu_page not being used as roots.
+        * All struct kvm_mmu_page in the list should have
         * tdp_mmu_page set and a tdp_mmu_root_count of 0.
         */
        struct list_head tdp_mmu_pages;
--
2.27.0
