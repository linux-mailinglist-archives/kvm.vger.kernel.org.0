Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDA4583C29
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 12:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiG1Khi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 06:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbiG1Khg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 06:37:36 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F8C54AF2;
        Thu, 28 Jul 2022 03:37:35 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id c131so2569598ybf.9;
        Thu, 28 Jul 2022 03:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=R5GRzyLWs+KyMbdXBdTptcuy9ha+X73Z19JJ7UOEpCE=;
        b=HEeXWVO6HzwSL3EJQMtjdmuEPbvIAJAkhLFUbx5L2U3+hFa4qtH3ysIZ/aWJN3u1Cd
         f3lZPznV3aSU4a9MbnvU9V8MFzoHKUwh25waTrOu8esleSkmdPiNeB1OE678wgJf0s/4
         yP+4b9ZzQtpQRVoz9POujAMfntIQIOsCDiCKJIrIIgBIh1C2lbOwkObGeAvw6QSAOSjf
         wflMyYmVLLSjytdkSLvFuFfzIGRAoKvUOwrgqoBIOSuOTi+2VRTV+2b+oCKdWPAWNu4l
         HYYzfYBF9ZAT5rDA27ZNxb5mLe+osHVBSW0O4i3U5xh/Jwg7DMkjNUQf5dD1QJkZAcnc
         EuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=R5GRzyLWs+KyMbdXBdTptcuy9ha+X73Z19JJ7UOEpCE=;
        b=YQltTlJPyYKUTfi5DjMusJU7KNBNfT7pKxgqDCY45HadBFHPqzeXvXfZ0zlJVwh16K
         bRgMD5r3iuBpdSWTrIGmO7Y7jrNstg5ctVDJkDRLJ3HkVf4MP8ynTe/4BO0XRtq7baGQ
         tEL+S8RustXj7Wg9mp+bTpbVpOtzARW7cGq44zHDkfEh580bt2iwNyp0orNSHoQHFcNm
         XbQT+Lest8i5DJJq8v0+v++zR6iPlrb3YXaQUeviJNXGUOcDis8CYW2KkQ6lG/pjy/oi
         zmRspKnRRjyyrNTxcvCkkAoBr4vC3RGMuj4jaNEPSU8KGffTsvCweSCJ8jxcTkigoZKC
         dpKA==
X-Gm-Message-State: AJIora/YSxvx2x2Kh4kWvcb/68sXyVZXSifvdzsXUefi1TQrNY+OeJwj
        6YOyXoO0Olt3RKs+CJni8DRV30EnLsprdJt/sCw=
X-Google-Smtp-Source: AGRyM1v3Bo9vw3oWIFVzoPCic41LoSm7EYnbY07PIXF4WS5N4K1jDtBWGvcKWgA2kXROnocRCU55VXoMxa2AfLsKPds=
X-Received: by 2002:a25:3793:0:b0:671:82e0:e109 with SMTP id
 e141-20020a253793000000b0067182e0e109mr5190605yba.515.1659004655056; Thu, 28
 Jul 2022 03:37:35 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Thu, 28 Jul 2022 18:37:24 +0800
Message-ID: <CAPm50aLBuq+zH9VHNDGLiB6Kqwwapus+dFwNqiOm8kruzPnouQ@mail.gmail.com>
Subject: [PATCH v2] kvm: mmu: fix typos in struct kvm_arch
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>, dmatlack@google.com
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
