Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA14F3B0C0D
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhFVSB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbhFVSBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:01:06 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9FAC0611BC
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:31 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v1-20020a372f010000b02903aa9be319adso19021446qkh.11
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gKgtnO0li3XctR1LlcZ0sfmT/BtRonO0rdROZiYa21Q=;
        b=Sex7lUeipn7tR+V0xF1ACQQZL4w0FGipBVhvq6RwEVTjOP3LMZ2SwGQeCkBG51CTy7
         J9seSG7oKa6S5aBAg+yP9LAAz0n8y0YYm1xzGnfCyGheGzdGzfkDHR4BVLfvgN9x5zg9
         I9VtGIP+0i3VJqaw7QDgV7feV49meyBvHZNcDAb4iG3oZnS1qh/xNl88MqnwQLrrQnj7
         M2K0KZSQmGA4zHYDfEkX2SUnKHmwKcULBMcyzKop+9KmdLUlvEMGaN07XrFJlZKPDJFe
         Bt1DmrpQr1goRbZh30CBFX7VtgM7JiJpvJg+fvHTp0AfaGhU3igcdKLznJ2hnwkWr/uU
         h+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gKgtnO0li3XctR1LlcZ0sfmT/BtRonO0rdROZiYa21Q=;
        b=mIVA1y2RtU+p/hzXOiHbeLGR4t3osrtsuusHZwXMAiGns1TrHxm/qEtwKf+9QqKnca
         e2Dq0dMS7s5p7T7kN8U2y4Qm3wHyvo0Obcy7OdLJNcV8vRjqf3lPzc9kTTLlAuYxsCHK
         sResi4z6/V26uzscTdII/A/I71wjZWJP45+7hpUOvuhRCteMHM7dT+8J7tcCvV5QdIl8
         /gIJXog0qH/gpPM52IOwV5Tu+PpQLU082rSaIkgvxk59bPoMYDiEc/ikAs644zw/FFvy
         OKvYCbe7vsMtGCXf55k7duL+QFdFRrIQiVkEawdobmP54/8SyM46G01jeZl0v4YBt30M
         pGxw==
X-Gm-Message-State: AOAM532umi1QsijT12irZkiuEbM+aGKhlfIVtUzS+R+aKPBhRDyIorbs
        AA4XTd6SxiwOU0gC1PijtHpq7HHvdcE=
X-Google-Smtp-Source: ABdhPJys+z26QeE5bNgr2NIiKY0ZWi/vGDPdyD4gOQRKlwQlOW+EMsJ9CEtp6QFg4/Uf9yZ6iWKymivS3iI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:2fd4:: with SMTP id v203mr5378244ybv.434.1624384710554;
 Tue, 22 Jun 2021 10:58:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:00 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 15/54] KVM: nSVM: Add a comment to document why nNPT uses
 vmcb01, not vCPU state
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a comment in the nested NPT initialization flow to call out that it
intentionally uses vmcb01 instead current vCPU state to get the effective
hCR4 and hEFER for L1's NPT context.

Note, despite nSVM's efforts to handle the case where vCPU state doesn't
reflect L1 state, the MMU may still do the wrong thing due to pulling
state from the vCPU instead of the passed in CR0/CR4/EFER values.  This
will be addressed in future commits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9f0e7ed672b2..33b2f9337e26 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -98,6 +98,12 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 	WARN_ON(mmu_is_nested(vcpu));
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
+
+	/*
+	 * L1's CR4 and EFER are stuffed into vmcb01 by the caller.  Note, when
+	 * called via KVM_SET_NESTED_STATE, that state may _not_ match current
+	 * vCPU state.  CR0.WP is explicitly ignored, while CR0.PG is required.
+	 */
 	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01.ptr->save.cr4,
 				svm->vmcb01.ptr->save.efer,
 				svm->nested.ctl.nested_cr3);
-- 
2.32.0.288.g62a8d224e6-goog

