Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D6D3A4B7C
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFKX7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 19:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFKX7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 19:59:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D8FC0617AF
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:57:23 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id s5-20020aa78d450000b02902ace63a7e93so4103541pfe.8
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i1zHBOsNGSrxOcZYJqlAY/e1Hza/FbWWdMuJU4RiDNc=;
        b=hDLoqHOtwGIzUTGUZo1mxmDxAY/g2dQfAeKdPG+AuFoxWQ+Z3gD5uW6KCOxKSRySae
         znNwOAvAhUtW8PjbVNLrnfhWy6X4EUVfpJ/ag1wBed0VietviZpnll6M6atgfH5AjUyu
         5audtRBN88eflM1rmAOIAsAkEyvce2qAjCcy+DvLPL96t3oNXqR58z4LlJgjbaMGuPN4
         UDXKBK+InRVVtcEAbXs/GMqbSEbLipgeWVqYhYYKwBmUd/I2JBx9qNslghFuSCZXyGCo
         lE7YSIEUpXjEJgPKE68e2H6A1098UBTXjzwzZRP6ZCQfj/SDROh/V3vg9ZmlDfPALGjK
         ycOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i1zHBOsNGSrxOcZYJqlAY/e1Hza/FbWWdMuJU4RiDNc=;
        b=AIPtUsee9l6qsSVBkWnJA/zvEjsXbwydOE6TYxGjCJ/va3nnZJRWiWkqGDD4XNS5jG
         l8KX11dQrqrbkzkoyGqLUjRqSgI8f6RZ4TC+65q5liiSKSfNHZoMl72LxXJw/lz1gGoZ
         OSrNXzLbuSUAGkzjk959wiLUL//0MhFZQ+zFtfY3ODcaPJC8vNgN9zhoja4zlLOZi2sc
         ho7zmPhpXj1y7+cv/FZ6vgWdI30vPjHowKYWfqaZmUmIS6Wfwk/byicGBTgc3vSQFPgS
         NniVLRnleaOIvsjtexOSrKwJB64suUFitM0cbvTvcenbNXlfedPhJZ9EByY0N/FwaCnw
         SKhQ==
X-Gm-Message-State: AOAM531f/2W27vqqaO4EVIRlREIbydaqAXLV5yJjMjjyScmsDk2MZ2fa
        Napb3G914C/ajVVrPKGU8uFtyLWgN3D/iHe5diKw7L3WurHDt0Ta4v6gvLiBVw+VDLI28avngIl
        O/vXzzcLMx092k5NbCOO4v6ppY1Zdqgv4j+s0XzFzkIqGDZNpM48JHV2xIHOWV90=
X-Google-Smtp-Source: ABdhPJxsY32FiO+oAV8qTyWboUJGY5vM1rLhdeRMlzAqWQpzIHgc+JiDYT2Sbu7j8ok0F6jTnQHjb4BZhg4Yjg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:a393:: with SMTP id
 x19mr696266pjp.1.1623455842082; Fri, 11 Jun 2021 16:57:22 -0700 (PDT)
Date:   Fri, 11 Jun 2021 23:56:55 +0000
In-Reply-To: <20210611235701.3941724-1-dmatlack@google.com>
Message-Id: <20210611235701.3941724-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 2/8] KVM: x86/mmu: Rename cr2_or_gpa to gpa in fast_page_fault
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fast_page_fault is only called from direct_page_fault where we know the
address is a gpa.

Fixes: 736c291c9f36 ("KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eccd889d20a5..1d0fe1445e04 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3007,8 +3007,7 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
 /*
  * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
  */
-static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-			   u32 error_code)
+static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -3024,7 +3023,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	do {
 		u64 new_spte;
 
-		for_each_shadow_entry_lockless(vcpu, cr2_or_gpa, iterator, spte)
+		for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
 			if (!is_shadow_present_pte(spte))
 				break;
 
@@ -3103,8 +3102,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, cr2_or_gpa, error_code, iterator.sptep,
-			      spte, ret);
+	trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
-- 
2.32.0.272.g935e593368-goog

