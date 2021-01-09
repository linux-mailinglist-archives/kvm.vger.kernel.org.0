Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68DE2EFD4F
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 04:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhAIDKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 22:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbhAIDKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 22:10:19 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0403C061573;
        Fri,  8 Jan 2021 19:09:38 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j1so6689141pld.3;
        Fri, 08 Jan 2021 19:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fQoQ591DRcLcx1zBs38ERO9HILV+4vRtO0mx9yq+xxk=;
        b=tK95k3WSzIGI2ktKiBx/Yc2pT7JqIGFuxCw9xB4BZuzRqqVyOjo5wqbw2kJa+N9TAj
         3QTR1pST+DQNZBN4e/mKgdsIH2xNsWQ+yShoDArGGiLmot5XUFUTOffPFVRSxiAghoKc
         XiJ3KGdV/Eoe7t9BN/4LTx90ecVcH0u6p22e1EqURknTRS01ft2TW9oq/qCq3ggKdWfQ
         HC0nOPLfqpZH7PErVqqQHy1TRcromD8X3xGDHWmfZdQqABwFQMXP6Spl+T9kcbRTjCZx
         425ZxzG7mEYTpG1/l+aFIf58+fl75ExTQMgtrrkBMc9BjIYBhMXcizVYShC6zQkLIDrH
         zASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fQoQ591DRcLcx1zBs38ERO9HILV+4vRtO0mx9yq+xxk=;
        b=HfEn/G611Ix6hH6eAEYpsuKAK+8diz1oj/vbhJSkmrmP/mINSaawb345clTqICsT1L
         eOTVU6M/OVecxsQfn0s3DHXnmHQc5Cg1/BkuUieDhdX1p/MFiuI7vRfjP5i19UogwOnd
         POVafrX61N6Wedn7IGq9PmDAiLLxIzV/wmM8e+gsLBte07fgOMss71P7ynILsP5mMR+V
         FICJXS7zqcGfTFSOKXkdeOirrY1QtKTCI+jmCZWy2pYyAV7YUrCTIg7MdsvPae4ba7CL
         ityOTj3UOL7ZqOyzaniRbHfsrmmrLsQKIcfTdpMyc72NRNMSoqFEg4sLCPY1HCmBNDAH
         KvgQ==
X-Gm-Message-State: AOAM533ESsJqMKh6ce3bwnemkBTnkbAHhi1TuSXSP1g8ybkGatsX2ogP
        dP5HuwHD0ddOQ0DeFdvW+bE=
X-Google-Smtp-Source: ABdhPJzZtqIcJB2oop8heybvKQtx+XyKUJjT/k/OeanQ/dLSyo21ZUmO1VK/VMQtHgGn5L0F/j8NqA==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr7034337pjs.18.1610161778311;
        Fri, 08 Jan 2021 19:09:38 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC.domain.name ([122.171.171.27])
        by smtp.gmail.com with ESMTPSA id 9sm10258074pfn.188.2021.01.08.19.09.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Jan 2021 19:09:37 -0800 (PST)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] kvm: x86: Mark __kvm_vcpu_halt() as static
Date:   Sat,  9 Jan 2021 08:39:32 +0530
Message-Id: <1610161772-5144-1-git-send-email-jrdr.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel test robot throws below warning ->

>> arch/x86/kvm/x86.c:7979:5: warning: no previous prototype for
>> '__kvm_vcpu_halt' [-Wmissing-prototypes]
    7979 | int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int
reason)
         |     ^~~~~~~~~~~~~~~

Marking __kvm_vcpu_halt() as static as it is used inside this file.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 61499e1..c2fdf14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -109,6 +109,7 @@
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
+static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason);
 
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
@@ -7976,7 +7977,7 @@ void kvm_arch_exit(void)
 	kmem_cache_destroy(x86_fpu_cache);
 }
 
-int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
+static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
-- 
1.9.1

