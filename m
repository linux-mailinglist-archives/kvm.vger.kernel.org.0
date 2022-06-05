Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2388753DA85
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349714AbiFEGdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349846AbiFEGdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:33:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1167138D84;
        Sat,  4 Jun 2022 23:33:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a10so10426356pju.3;
        Sat, 04 Jun 2022 23:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k6u1NoOEvXwJSKIzoGXM9388wPway6Xp+Y1moK1bhxQ=;
        b=Oe+NHUjWzyjI5Ssvs1op6RF7SojwDqU4VJxgWcBfZUvjr8L7poTUt0Qr4pIZqnmSgu
         N+WsOyRqHtZCZ5P9lsVZTFqv0aaKN/AUF1XcDC2L8UjcT4FI0sdvR6jzKwX8p3WtANfe
         /opiSKml8t9+WXzUOjtJAgaz3F8zTTSGrw6XuOWPvtMcXHlfYMR5mjTpIePBKpiq8JeF
         qvZU6nr/oFkW05XJk+DLiy6NKXM/xMAQLVz0avP1X0pKVnymz+1KUT6JU1pKcr8RERBz
         ei5lR3W/lNo17IVJe++GBAV0SzUzki0eGeOWqtsFyhJBGMlJIvL0JWytz0QbUQwq2RyT
         v1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k6u1NoOEvXwJSKIzoGXM9388wPway6Xp+Y1moK1bhxQ=;
        b=EnmkF+wJZy1hqxtP7CTJGCQP+jPoBjkS/rhDqE52J/Hy8zJSEnuVwBrnyyCugNPKeb
         p2EFV6xhO1ULpoGRPBXvIH8SD+EbX5vEyCJ4PLzlaRLiorKC3UvimyLXNTGOhSdAllKn
         TefaQiM4TYMMKHKYHavWMrNIF5tc9oTD2CcxHbGwUEF/VBMJFaQu8n8smWRZZrBqdcR1
         N3KyjJKljR5DdLxpSD4YSnvDlUkb6F80Kk2RirJBmMqsxCrHvzAD/JCuxAjlLawdkMIn
         bugcei9R1ocYzwEkzNfaXkyFxlJndDXCh8ROhzYF2nuSkY16GArSuNg0Ae/PlOzkSCRU
         UcLg==
X-Gm-Message-State: AOAM5320yrFose9tcUE69jpvTmMEW0EBBgvCHmU95um7aEB7+jcomKp4
        ZyKO0KowerDHk2Xj7fTxK/KUxpq+3ME=
X-Google-Smtp-Source: ABdhPJxy3PmT3XLu7ZvLfuPrbxGySAApXeGxPHIiOxjjF1aKIq+zxDeB6RxzSTbfBgsxWzasEVTTmw==
X-Received: by 2002:a17:90b:4a12:b0:1e3:15ef:81e1 with SMTP id kk18-20020a17090b4a1200b001e315ef81e1mr34274027pjb.246.1654410818489;
        Sat, 04 Jun 2022 23:33:38 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id 3-20020a630803000000b003c2f9540127sm7996265pgi.93.2022.06.04.23.33.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:33:38 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 3/6] KVM: X86/MMU: Update comments in paging_tmpl.h for the kinds of guest PTEs
Date:   Sun,  5 Jun 2022 14:34:14 +0800
Message-Id: <20220605063417.308311-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605063417.308311-1-jiangshanlai@gmail.com>
References: <20220605063417.308311-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Add EPT PTEs into the comments.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 2375bd5fd9f4..f4e02ba04744 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -16,8 +16,8 @@
  */
 
 /*
- * We need the mmu code to access both 32-bit and 64-bit guest ptes,
- * so the code in this file is compiled twice, once per pte size.
+ * We need the MMU code to access 32-bit, 64-bit PTEs and 64-bit EPT PTEs,
+ * so the code in this file is compiled three times, once per a kind of PTE.
  */
 
 #if PTTYPE == 64
-- 
2.19.1.6.gb485710b

