Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBE927A8A4
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 09:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgI1Hab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 03:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgI1Ha3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 03:30:29 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2240FC0613CE;
        Mon, 28 Sep 2020 00:30:29 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s31so96919pga.7;
        Mon, 28 Sep 2020 00:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlUXKNgJlmFS9LcdYBGGvIRXhDW1V51nJ7N32WE7Hns=;
        b=uU0aG6tZl03pavnDsfsz9AGoXD0qBwegzcxQsET0gXBcWMOCTOdlRafnaiW9DE08/r
         fnl1WYBR687CFhB8TuKZSk6ezmmMcxKOtGvQXubjVRo4vO2GrrCS6ATiXsJYNp8yPV7t
         fxXFouKmEW6q1HAhzoG43GF2oVwNrS1uS6n+wkvC3ugMLvMzRfZPVPMb24QaHsdjhWU8
         OsIIPr0Q3TstSTX9roHFZAxLALq4/6aYeNd7CypYDkw0MAhsyD41TNJftiZenuhfIhK/
         JA8AIvJYbhkP5KsB1TxAiItytzwBD5FVDg6eIKOD/8z8/ArEMn5/SOn3H1dbXEfgBYGx
         REmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlUXKNgJlmFS9LcdYBGGvIRXhDW1V51nJ7N32WE7Hns=;
        b=phvK6wCNxUwpVZbyOxa4AtLma4b+0/ins9Fg6XrTBLpJlDwV26TnM0kFAqxRdxisfZ
         41Sa4TzGtz3c97HRoH3dFYKV1qU+6Dz8HLsSsORaUXRNG/Z9R37qmXY5ZeTYH2RXFoWN
         3UN3neI8gvCnGALsFg7cpYavhshzH83KAAycDzP18Z87l8Ox1vkc+RGrfYHCoBdh/FBw
         29Bai+CoeP2HvmO1VtMGY8JHJrIPKhanqqlUyDbS3uTWd6qDhvh0hwsm/snK1084VNIu
         0bQzskqIzj58Shoh4xHERFLqxP7L2ob0d2TYwi9eTB204YmQbvnY06BpY5j2RDbAIzfV
         kOqQ==
X-Gm-Message-State: AOAM531gpW6JM9Oa6p/MeBm5VtFHDKxz+l1bzkemWkbKHrrlIfDfckr3
        bgII1Y3GnZC77cljAKKaaj166y8t2vg=
X-Google-Smtp-Source: ABdhPJxafmjcVScUQe1VHQdDZYlnHWwefJg3QusPt34Rq2D0SX7ZjiF/PO7sKgpDQ413pPEqyVXb8Q==
X-Received: by 2002:a17:902:a501:b029:d2:8ce6:f589 with SMTP id s1-20020a170902a501b02900d28ce6f589mr397225plq.11.1601278228612;
        Mon, 28 Sep 2020 00:30:28 -0700 (PDT)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id 22sm469920pfw.17.2020.09.28.00.30.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 00:30:28 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 2/2] kvm/x86: allow guest to toggle X86_CR4_FSGSBASE
Date:   Mon, 28 Sep 2020 16:30:47 +0800
Message-Id: <20200928083047.3349-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20200928083047.3349-1-jiangshanlai@gmail.com>
References: <20200928083047.3349-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

There is no reason to force VM-Exit on toggling
X86_CR4_FSGSBASE.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index ca0781b41df9..a889563ad02d 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,7 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
 
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
-- 
2.19.1.6.gb485710b

