Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59E84559DF
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344017AbhKRLQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343862AbhKRLOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:14:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0E7C0611A6;
        Thu, 18 Nov 2021 03:09:27 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m24so4913782pls.10;
        Thu, 18 Nov 2021 03:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YdfW8Ysp7XBeV8ztjWWa4B1sDAxYZYhnWqDn9ynnIjc=;
        b=hBlI2UjiYvGgt8fATl1AxekZFCzNUNKO5mUH+Rv83sZ1AxYQp8AwuHhWm0F4Wp+Y10
         nLbMefcT4QvRK5ZCNbNL1YHq7jOr6pGKGncBmi8DNcO+R4mLUJnL9qLjHnCo2qWRpRfS
         efHGRCezvu5dftNFiuuvySIOCtOqyKpDyeI4ARHx2prGvrd+bjlA/ci0SKC0rjW5pagi
         9pRrvKTWbNiJM17begN92SPTsR2kJLUp7JKzkzaTdq4frSwQoF/E1wT+761PMC7qXrlx
         4Raj7snrGpKBZZ4+QKl8ktV+VijNt9vUkEUAKV2MzaKmmUw3wHf8FBTm2jxr/hTcAFa1
         Rj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YdfW8Ysp7XBeV8ztjWWa4B1sDAxYZYhnWqDn9ynnIjc=;
        b=JbAAkhwHeB68LYCcHwMVtVQ/1DJ+M0onpCPBjFjApI5o/B+1tgn88aD86KWVI+s5H5
         eycxvL/USNxVMQGWT66POa0bgkDeOgh5/KPnL6MVylz2d1S9Wwe/CkrSgkqQ9t0AxJY9
         8CbIn/OenzrkbOOIXDCdXtGBeasVdwzRyr7voJ6bR336TpirUSk2vfnndvqB/zSZLn3i
         +OlEZnwU/vYbBvo8dQF4aBRzzMISKvHg0UHIc6ZaSdsrDv+TAK0+eGJ9DovZKlQu+Nsf
         5aevD09Qjx7D7GOaNvf1ZqIIIBFTABMF+ty1O60TW/6Nrc9wL6i+k6iqq5Lr0/L4ucVg
         KxjQ==
X-Gm-Message-State: AOAM531FGKOsIy/Cz6iOFw3rsvM/r0S008BOQD9xkPKYOenbiINdHxxf
        jF3ytwAg7HkjPoNEfLZClWImHEhpk3A=
X-Google-Smtp-Source: ABdhPJwh6mKtD+fwsCkurbQB+PShEkSx8rRBCbSHyaLiXoKD0oXPQwsBXEVMr0ES89UqFPANYAOgWA==
X-Received: by 2002:a17:90b:3a89:: with SMTP id om9mr9427252pjb.29.1637233767086;
        Thu, 18 Nov 2021 03:09:27 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id y18sm3423546pfa.142.2021.11.18.03.09.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:09:26 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 14/15] KVM: X86: Calculate quadrant when !role.gpte_is_8_bytes
Date:   Thu, 18 Nov 2021 19:08:13 +0800
Message-Id: <20211118110814.2568-15-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

role.quadrant is only valid when gpte size is 4 bytes and only be
calculated when gpte size is 4 bytes.

Although "vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL" also means
gpte size is 4 bytes, but using "!role.gpte_is_8_bytes" is clearer

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index db8b64971f25..6948f2d696c3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2083,7 +2083,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role.level = level;
 	role.direct = direct;
 	role.access = access;
-	if (!direct_mmu && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
+	if (!direct_mmu && !role.gpte_is_8_bytes) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
-- 
2.19.1.6.gb485710b

