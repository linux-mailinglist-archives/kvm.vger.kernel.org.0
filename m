Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A459E27A8A2
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 09:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgI1Ha0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 03:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1Ha0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 03:30:26 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217F6C0613CE;
        Mon, 28 Sep 2020 00:30:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u24so119627pgi.1;
        Mon, 28 Sep 2020 00:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SRDOrcOXo2fctkY7+23XpqsPfrMaqBHYhZz060zwT4Q=;
        b=UmOj2XUm/RnyvxN42kx1ehBHGEBvFHIY/zknL6770zTKMNoUrydl4/Z/5ORQASPRl0
         jvrZc+IPZRom//1jSEALkM7bGChyOpxeRouaw+BpUwmR2llvqmDSCSA7K60L0Jb9Kcsd
         Sy+P0p5yIsUAgdvNkXhLbhxEDNrMPKjjwmCbUq4OB5Kie5/MU2GkOlSFFA8K56GHI5Qy
         kWKB97zYkEp1wMWXuREglQnWlrWIcIoTLPVQ1OYTfWcfC/UOPOjstpm5KD4J2KX6JR5R
         uwYEkXwvUxC8vBxGfRLgVU5d+oKpV+rtC73Flcr/07L0YPanwHamHQaS7xEVUXKJXpBb
         9QJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SRDOrcOXo2fctkY7+23XpqsPfrMaqBHYhZz060zwT4Q=;
        b=jSMmN0UlLRehZJ9WxZSO0svcC866iEth/q4XUuUqCE/Fy8MGRg1WjJh6rRNEG47l2r
         9kXtfXzalV61Aata/wPQbcO50X78xWZaYcRwi19GsqtBbCm+d9aG5vQDf/jW70mtwX7J
         46qIUXKBTIsZhkHPMNEE8+4R8KRn4rtbHVZTmIynzHTzlBMhPFns1gqVcUrQqXVgTtZt
         4AUAERGEYih1G30sMBt5RCP1vj1LeJEB2bq+qOaZY3J2X1a9brVUu54a1oXNh3ysqCgQ
         H+nYCQx8tlB+idgqWYn52w+ZbCpVBpw+guoQ5MD21CT1zVaBmqgeIHAo+KTYasxskjEG
         PWgQ==
X-Gm-Message-State: AOAM532R4xr1vrcpv2Ooqrz4tOdq2egIpRdliMS3dmtzfbCb18OrELOG
        ZV31DNilws6nPQFMEWsD7UsxnqezQxk=
X-Google-Smtp-Source: ABdhPJxny9MXVCI132op9NYkIA8MXVFiisGYHhNHNTyyqp/XYfn+gM9mGiHpfaKbSxFqjd2bdXaOLA==
X-Received: by 2002:aa7:904a:0:b029:142:2501:35d8 with SMTP id n10-20020aa7904a0000b0290142250135d8mr347011pfo.56.1601278225528;
        Mon, 28 Sep 2020 00:30:25 -0700 (PDT)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id k7sm194840pjs.9.2020.09.28.00.30.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 00:30:25 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 1/2] kvm/x86: intercept guest changes to X86_CR4_LA57
Date:   Mon, 28 Sep 2020 16:30:46 +0800
Message-Id: <20200928083047.3349-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When shadowpaping is enabled, guest should not be allowed
to toggle X86_CR4_LA57. And X86_CR4_LA57 is a rarely changed
bit, so we can just intercept all the attempts to toggle it
no matter shadowpaping is in used or not.

Fixes: fd8cb433734ee ("KVM: MMU: Expose the LA57 feature to VM.")
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
  No test to toggle X86_CR4_LA57 in guest since I can't access to
  any CPU supports it. Maybe it is not a real problem.

 arch/x86/kvm/kvm_cache_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index cfe83d4ae625..ca0781b41df9 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,7 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD)
 
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
-- 
2.19.1.6.gb485710b

