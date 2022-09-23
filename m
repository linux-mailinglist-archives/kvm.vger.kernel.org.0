Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990235E7DE2
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 17:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiIWPFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 11:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiIWPFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 11:05:50 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E798CACA1D;
        Fri, 23 Sep 2022 08:05:48 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id e18so412187wmq.3;
        Fri, 23 Sep 2022 08:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=3r/yr5fSpb6j1dJ1NTZWqEUklZpQbVEh5t98eAumgfs=;
        b=ARPJ5SeOThv6lXUFZOnjYGCTnHucPArVdqnncvyd6pGscjY/GPTchW6SJDlcKYOXO7
         Yg+1CFxfC7QL4PJ38H7pUWrzcVD0ENX+i1b/8iUYvgSbzY4YT43ypV8h3X7kzFGD5WKz
         mE5tBM0eKGPOLTSyYWyuudHAFHWgoQkhF9dIUxfU0fcbEcOliIbGaYs7aERPztEkSAkr
         /qpHGfVouNr+li8HP4d6HuMFWS+ckzfznc7WsuVOLJAWDpRm1GRNMeCDWCFT+b+V/jGb
         5NOI+kgNawP7SMiEZG17Nv828cm0pGR61HeaYCLUZkfyuFbyZ4oiIhyIlMAmqWe1f9RZ
         roLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=3r/yr5fSpb6j1dJ1NTZWqEUklZpQbVEh5t98eAumgfs=;
        b=t7ThkdMWcJ9r3c5A38o4nULh0L9jsSKKHejNm6pD6tvb6tGxQjkRZIkJB5VlIp64qi
         zj+SxJLRRfeETiDXySJoz7t32uOpY3H/sqfHNxB6QXI/S1Ta4/aokiHYK4aJDpN8OYqB
         c9u+vJgM2ajR++waGD9RAIGztZJA1uouvkAs/1nXB6Wwm3EyASFBc3UP+4+CTIt7nT2+
         rZId/+QVHkzdNAdyI7BB1ED/K+CJ6NvfHjwm5YsnDivgNs1D7G6g+zYZlSMiLMKM8Eta
         hsmaGsX5yPm9wpmB3amWNwTQvOEYvBniz9pkjx8aCpt8iEA62AjPTN0OyjbaZcpcn0+L
         WkCA==
X-Gm-Message-State: ACrzQf3bOUYpI4gbZU9s+yt/CljizCYajdohZvcERIJWXmZfaS4oZ09O
        wJviy6EHcBP55MypC1FHQxUbBATehgQcBOxq+vOV+Z0v+mttVw==
X-Google-Smtp-Source: AMsMyM7ZgwhvvhR8011BTEoj1gZCEiVOYW2sLXQXZ15Iku2UwISCK3RNjIc8BAxHC8UPVlcLtEjwnlWl4MhzqeZkj2Q=
X-Received: by 2002:a05:600c:524d:b0:3b4:91ee:933e with SMTP id
 fc13-20020a05600c524d00b003b491ee933emr6407119wmb.80.1663945547469; Fri, 23
 Sep 2022 08:05:47 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Fri, 23 Sep 2022 23:05:36 +0800
Message-ID: <CAPm50aL=0smbohhjAcK=ciUwcQJ=uAQP1xNQi52YsE7U8NFpEw@mail.gmail.com>
Subject: [RESEND PATCH v2] kvm: mmu: fix typos in struct kvm_arch
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
arch/x86/include/asm/kvm_host.h | 12 ++++++------
1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8281d64a431..e67b2f602fb2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1272,8 +1272,8 @@ struct kvm_arch {
        bool tdp_mmu_enabled;

        /*
-        * List of struct kvm_mmu_pages being used as roots.
-        * All struct kvm_mmu_pages in the list should have
+        * List of kvm_mmu_page structs being used as roots.
+        * All kvm_mmu_page structs in the list should have
         * tdp_mmu_page set.
         *
         * For reads, this list is protected by:
@@ -1292,8 +1292,8 @@ struct kvm_arch {
        struct list_head tdp_mmu_roots;

        /*
-        * List of struct kvmp_mmu_pages not being used as roots.
-        * All struct kvm_mmu_pages in the list should have
+        * List of kvm_mmu_page structs not being used as roots.
+        * All kvm_mmu_page structs in the list should have
         * tdp_mmu_page set and a tdp_mmu_root_count of 0.
         */
        struct list_head tdp_mmu_pages;
@@ -1303,9 +1303,9 @@ struct kvm_arch {
         * is held in read mode:
         *  - tdp_mmu_roots (above)
         *  - tdp_mmu_pages (above)
-        *  - the link field of struct kvm_mmu_pages used by the TDP MMU
+        *  - the link field of kvm_mmu_page structs used by the TDP MMU
         *  - lpage_disallowed_mmu_pages
-        *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
+        *  - the lpage_disallowed_link field of kvm_mmu_page structs used
         *    by the TDP MMU
         * It is acceptable, but not necessary, to acquire this lock when
         * the thread holds the MMU lock in write mode.
--
2.27.0
