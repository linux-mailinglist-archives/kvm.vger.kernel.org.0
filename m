Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687AC447FA7
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbhKHMrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239649AbhKHMre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:34 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E34C061570;
        Mon,  8 Nov 2021 04:44:49 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y1so15683738plk.10;
        Mon, 08 Nov 2021 04:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rzbFgj/HRvczCJnHB2uTBb/82oB/oP3QBt5uIwR1NNQ=;
        b=m/yz/THQIg/FNZPGwFAFly/HWsCKic+H8ebbtHg/icizaBRs02d4AhjUBEfAYzC3mU
         gzb8sSAmR2jAEnBsK4gKsujrhLz18U3NBtg66tymiNcmrinqsnfQ3CyYGjpWecln9P37
         D1xeB7M8oNnzzBWFV2f1VZ62cl3vYXFZFN2AcybGCs9o70fmDy5p75KConQU72HyB40L
         8IpbDLtazTYZn6HcZit/ykQDuaHMaGgg+6MAEhKY8jkliB7YR5hCCx+T6T0cHNc2nFvs
         Flfr7fH62d9oXA3xAT1+dNT3J+m8JCe+eL5cQqTOqTjHu/+7mFTUIkkZTimUzdxYrvyH
         zI7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rzbFgj/HRvczCJnHB2uTBb/82oB/oP3QBt5uIwR1NNQ=;
        b=sjf7CGyM0vDBmf5nLDrgS399dW1TF3Gsr/Vk7qw5pt7wOq7inDvXCIgiI1LUQNKqWp
         nZntkG2u2b6eMFGYrHq2u5KC7cUxg7woX9WLT44STVa/vYmyVbeZr6O006gW20fMhm7+
         CHFUcSdgvc5HCxt1fkNCfIhnPPk4XgJw/+CvVowmIWoi6QiRKDM3XJZMYK4UGlXEZCA5
         vIbIur6J3gwvG4nSNxi9M9zzEFJ499vKd8U7zG48ygoneaV46zGMdvu6d7hMl0EGmDlL
         JSLpABbfxcn4qz5FJB9kYWVDq4uPVIU/eLwS+3gjZpLmkuv2HEgOPKaq287Ey8IUfWsb
         H1dg==
X-Gm-Message-State: AOAM533BU9cM20woVQ+zleMunZKny9Vh4z2rQiAsQVpNSPPmecczBh/1
        l3qp/E2V7QfBAa77LfVy+W3ntYofFWQ=
X-Google-Smtp-Source: ABdhPJzM3mjB6Xu7NtfZSVEtMjm8UBU8Thzfp/r1ZWZavHWyTAGXSTs8f9g4gzKr0wFKLIGJrx4YDA==
X-Received: by 2002:a17:90a:5303:: with SMTP id x3mr51365345pjh.226.1636375489385;
        Mon, 08 Nov 2021 04:44:49 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id y184sm9367160pfg.175.2021.11.08.04.44.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:49 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 07/15] KVM: SVM: Remove outdated comment in svm_load_mmu_pgd()
Date:   Mon,  8 Nov 2021 20:43:59 +0800
Message-Id: <20211108124407.12187-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The comment had been added in the commit 689f3bf21628 ("KVM: x86: unify
callbacks to load paging root") and its related code was removed later,
and it has nothing to do with the next line of code.

So the comment should be removed too.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3e7043173668..e3607fa025d3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4000,7 +4000,6 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 
 		hv_track_root_tdp(vcpu, root_hpa);
 
-		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
 		cr3 = vcpu->arch.cr3;
-- 
2.19.1.6.gb485710b

