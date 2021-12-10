Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A0246FDA4
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbhLJJ2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbhLJJ2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:28:35 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E957C061746;
        Fri, 10 Dec 2021 01:25:01 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x131so7906489pfc.12;
        Fri, 10 Dec 2021 01:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cusxSY5dMLoUC+dS6eYXkKfX2IuAJbTvzR7oGab+ZMw=;
        b=eWVhTC0pQEwUQhbkJBYVQIhYLcH2goEf1e2s8UCz+3Qf+3u6Q5xR1tItoxNUsCBItO
         eYIvCMNyJ0j2WgjAItXkuHBVhQUfUfbKjpnGl3uc26oU4izHJPQX6kzucmhqoKQjnteS
         Kx7lnYwZKFcfeZCDurJO5wPQI+ifD1o4V9ti3jouPbqsq7V3Y+PAGAAFl/K0Yb9J8yTg
         Pdp4cASHAzT3j08ybgdBT8/sLwoy9ofV810e3Xi60ZerQHbSRTt7D2by7jKYPe4AqHCj
         4GROctbr2jjOAL893l13aHz4MQGiQwn6YBh7Tk6V5D2rDA8YOewd3ZVXGBDv6R31ZqFF
         FaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cusxSY5dMLoUC+dS6eYXkKfX2IuAJbTvzR7oGab+ZMw=;
        b=j2vixIeR/dym7T0vTN3vzYUYVO7gO9ygtADTtnIEQw/f8uz5CTuH0xy0lTyy2E2oCs
         MuoE9db53xzv8HVfVUfoMUnmZ78+8GRNnx7zLJjixT++844YrrxnaXLaq04VScrlc+W9
         NRSLI62BbBms8MuWt8DJLIAdnI8WYFmPhfGelsTn7lMwujqu06GXXamcsc/xl594CmnQ
         FEckTBZe3DycMw5o85wwzpyHx4k4uN63yqg5KZmMN5hPqB4Cg82WWQHGtcU8fGHiGbzB
         gSNVDbiRhG5EMCuA+TJyBmHJYPgzTkw0MvpFvdT/We1o7Cheg5OCNi5wiOK6vN7kFV1B
         pyXg==
X-Gm-Message-State: AOAM531FWpXt2T5aYyRtyRGzeJ13HHRlnscRsGCbmsNqa/OEzVZoj6zV
        LsBQr1Sd3o47g8TF521cKbL2Q7c8mIg=
X-Google-Smtp-Source: ABdhPJyIg1UiHF+RqGBaoJDEBB+4YuNCo6VMWX+Xl/rXJ+RNRtwLGfLtgPWb3Lbr0zAYF69jlPyShA==
X-Received: by 2002:a63:33cc:: with SMTP id z195mr38493658pgz.339.1639128300468;
        Fri, 10 Dec 2021 01:25:00 -0800 (PST)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id h5sm2878355pfc.113.2021.12.10.01.24.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:25:00 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 1/6] KVM: X86: Check root_level only in fast_pgd_switch()
Date:   Fri, 10 Dec 2021 17:25:03 +0800
Message-Id: <20211210092508.7185-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211210092508.7185-1-jiangshanlai@gmail.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

If root_level >= 4, shadow_root_level must be >= 4 too.
Checking only root_level can reduce a check.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 11b06d536cc9..846a2e426e0b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4136,8 +4136,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
 	 * later if necessary.
 	 */
-	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
-	    mmu->root_level >= PT64_ROOT_4LEVEL)
+	if (mmu->root_level >= PT64_ROOT_4LEVEL)
 		return cached_root_available(vcpu, new_pgd, new_role);
 
 	return false;
-- 
2.19.1.6.gb485710b

