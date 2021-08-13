Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2123EBD72
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhHMUfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhHMUff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:35:35 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D39C061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:08 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v3-20020a17090ac903b029017912733966so6267490pjt.2
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S3drmdojS3tjpD4MuJKoM16ldFAYxygNIUpx/iPPVnU=;
        b=SuiFYEq5O1m0VFxPXiDuqAik9EqRfAJj4/pO11xjhgKQqYkGzZPSnrT+zPaofTXSJY
         0x98iif+eeEkS91w3/gboHCXIPxM62S0s+COH9Q9USLaVJbITSZKEmphkAqzafYawZ6t
         CR+OuT/CCErzjuqd/KA4M4kRPv+z8OtQ59dP/EG7hmKqUeE4hrqoGIXb066ZVKVLLn3D
         d5q8s2B2dRTZVNv9nGX8em72T8KvQsUzsttmcGqUGV/5IUq2hiPtqICy1GrtNuTnoKL1
         vXSAAohW1INpYmqRDNEz7pJXm6dKlb+yBfCMyUWMJ+ZCrylqOXbxESEPuXo2bbto+qv1
         ll2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S3drmdojS3tjpD4MuJKoM16ldFAYxygNIUpx/iPPVnU=;
        b=mlvxCBbgY5nL6wX25DUx10ivytqqZpdhzUVIh646snqeq6p9kYZ1o9eXdP4j9KHx9r
         u7BqkTHQDFzTNHWBN7rp4UYFErWrAKN5WDO6VOPuG2TV70VVHLJD6Sg9J1iDQcVNnodN
         XWcGeoKFaan1eqOLbxYh03zV56gejD8FOrdV9FdWF6m1vFrEKTt26dFJZajPwTVVjb+S
         unpzvtlw1m+2xKWnGFU7lQGC6/ewIXx4LBMLswaUTQtlbuj8Zi/mR2f+jox/JowyAxx6
         6+zh8FroxF3I/QWXkYlbyT+UH2J/x1DQ/4Z/MeKJetUZHEaz3A0ri5bSs+twV4rUvlar
         xVLw==
X-Gm-Message-State: AOAM530KrOkwVdISBLA42YmcCFnVWIsNU81V/FNN+ieyqvaPN14YiqJm
        LLHiLFpp0I3SDlwgJbNc4tG5aNF38tGmEg==
X-Google-Smtp-Source: ABdhPJzmm7dPA/K2fqnu8UGovpr8qoKpJM7HsaEpcrl1LdAApW7BTNcc0ju2QgNdROO/YUtXzKSeKJmT3KvrOA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:8283:0:b0:3e0:f3f3:839d with SMTP id
 w125-20020a628283000000b003e0f3f3839dmr4116999pfd.37.1628886908129; Fri, 13
 Aug 2021 13:35:08 -0700 (PDT)
Date:   Fri, 13 Aug 2021 20:34:59 +0000
In-Reply-To: <20210813203504.2742757-1-dmatlack@google.com>
Message-Id: <20210813203504.2742757-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [RFC PATCH 1/6] KVM: x86/mmu: Rename try_async_pf to kvm_faultin_pfn
 in comment
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

try_async_pf was renamed just before the comment was added and it never
got updated.

Fixes: 0ed0de3de2d9 ("KVM: MMU: change try_async_pf() arguments to kvm_page_fault")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ce369a533800..2c726b255fa8 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -158,7 +158,7 @@ struct kvm_page_fault {
 	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
 	gfn_t gfn;
 
-	/* Outputs of try_async_pf.  */
+	/* Outputs of kvm_faultin_pfn.  */
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

