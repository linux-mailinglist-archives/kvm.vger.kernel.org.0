Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1AC47A117
	for <lists+kvm@lfdr.de>; Sun, 19 Dec 2021 16:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbhLSPDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Dec 2021 10:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhLSPDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Dec 2021 10:03:23 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CDCC061574;
        Sun, 19 Dec 2021 07:03:22 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id bm14so15260351edb.5;
        Sun, 19 Dec 2021 07:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5mMtDCLy2U7eCNCb3ooc8pht0zAzJqAqiGnOR/N8AcU=;
        b=XgPr58TRNB0C6ZKhz7XndENwl7j2CkLC86gmmPwzK7yrsqY/y1oMCnSqGk0d9mrZSB
         HVZqqgJADbn24rnSYYCc/QvPT0PCPIhzPrjzn3J4UELxF/qBqxc45HR1hrAUUh4UtMys
         OiZ4RgoRz3VzFAs9YBCAMDQO3SyCTX3lpvLbeo9g7yrgcet/EeoxUnFdrz1/xLeozYcb
         p9sR4ydamFPGLuS+Z9cOxg604MiBRYsiSkiSbvykCGj/M8GAB0Ifn65jaHtU0hCfIGg1
         XCItIIJHPUNCglMQLqVreRgU88q4HYCsSZxgKqku7QH5Po23r9mjrv0fitzQIkaQbj8+
         JZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5mMtDCLy2U7eCNCb3ooc8pht0zAzJqAqiGnOR/N8AcU=;
        b=GAjBIG3pJBgPRHT21/wc1f2Sm25tl0RAXmbS3BignzJ8d7Y2Cy5yIX76dZPzZiiEXb
         NArUjy4yKvF8cflNsgmPSwOvCnfhg+/8AAGycE3fk6+4YwGUEDWE27v1vLfBOWGYu++f
         gig7mxrCAc8B0RT9ft3mEBIjU7U8oF9gOfpr+5ejZRgEjZR7czf31uVQ3fCtLMuo4wK0
         p+MArcXEDiP5yvhErMzV6qLYgRSwWKZf+yVg384DhsGswF6xFlQCg1AYv3fJpjPQL0u/
         XJDwr/xfqHE1RC1pecGF1U0ihmHWADw1U01Ih0UaxZpCRfKW7C7CUxsGKRXIRKA4cPVL
         5qNA==
X-Gm-Message-State: AOAM530VR+GDnnuXsd3NEYZ6iU7H7zC22Bh3V0F5FVitGL1uWqSIIFil
        fOEpFK8r0i4eC8syV2AwYUs=
X-Google-Smtp-Source: ABdhPJwyG2OVdS1fX0XJvwNoziHSFQguNADgCYAN3Pio1A1MmdEP3qT1OsHMijhIbeljKvGrfBhA6g==
X-Received: by 2002:a05:6402:1702:: with SMTP id y2mr806112edu.372.1639926201428;
        Sun, 19 Dec 2021 07:03:21 -0800 (PST)
Received: from ubuntu.localdomain ([185.37.253.175])
        by smtp.gmail.com with ESMTPSA id qw20sm1266733ejc.185.2021.12.19.07.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 07:03:21 -0800 (PST)
From:   Quanfa Fu <quanfafu@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Quanfa Fu <quanfafu@gmail.com>
Subject: [PATCH] KVM/X86: Remove unneeded variable
Date:   Sun, 19 Dec 2021 23:03:07 +0800
Message-Id: <20211219150307.179306-1-quanfafu@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unneeded variable used to store return value.

No functional change intended.

Signed-off-by: Quanfa Fu <quanfafu@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2e1d012df22..7603db81b902 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2553,16 +2553,13 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa;
-	int r;
 
 	if (vcpu->arch.mmu->direct_map)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
 
-	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-
-	return r;
+	return kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 }
 
 static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
-- 
2.25.1

