Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609E3300ECD
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 22:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbhAVVVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 16:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbhAVU0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:26:01 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CBCC061225
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:22 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b131so6631215ybc.3
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9YyrF+bNfu25OZDUV03DuKXOU6fNcwhwu/YWG0B3SQ8=;
        b=rkx40f1M9VAr0cpXIu1eyy0Dwe7m7iby0h03XkrYRYabaqizQuaf1H8qCwh/pj/OmP
         oVYOWprMssUUpaNEfGiWq/9j5wrdXdW/EuQJVKjcINwGtFviuakOht313AMOPbeKiZc/
         dTFYHUUrTyVTmrp+xiX8/FpOFDoGJ8KsRIrA8CBQvGsTlap/gQvcKGG5Z2RYEf/no5Hs
         t55FirMq2F32tcozXIjNPDaXjkjPyj0o8xnk4ZzQWOjHQFeWuCIgWPjlynyY5fPifDKa
         b7NvK7OFfmwENO6Dehg8Br8iYkO/P0IOhvLyyicQgj0H37Ib8pG6Qu/AlxOJ4XnG5+Jm
         p9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9YyrF+bNfu25OZDUV03DuKXOU6fNcwhwu/YWG0B3SQ8=;
        b=PxPZZDSK/a/Ks0ZwoYpAw1Wp9QISZPKKo1iVM4NnMBlkUMR5WhGfyrWZr43KKR2tzk
         OiIWjP6dESyZjmyRpdxFVLR2k9kBJg/BxUwSvuGvsz3gvbm8RPMjXX5M7MrGye5G8Fpz
         X/zf/9Sy/HyN6Qe1P/r5F3DU7m0aciuT7hulM6rGQbeOdA74ZukWqtZGOwWuocLn2uqJ
         aA/pU+/wgrTP7Ki3bLhtqvynPphsSwk4wSLkQ3UTNJfUlvu5Hy5NjuJ40IwYF6ByXTIR
         2qQ6fkXVvcKmRGGp+6N0Wg4IB5gfAjCoviMcvDIzytWvIxJMwxwl1lQZeJ3HRwcs5s8r
         LfeQ==
X-Gm-Message-State: AOAM531QqiciZ2UwZBDaoldISe3YptXhWq211dR9LsvCz+XUd3395yJQ
        d5WyvNXZ1MlG3c9TA8kWxXsMwtOMKoI=
X-Google-Smtp-Source: ABdhPJyql0wBNVi8A3QrBM2L9OyFhQYkW3e5KFrtuET9Bxef7hzsQORrwjs0oMpO64gWKMEfJwqbVZ8nTRU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:d80d:: with SMTP id p13mr9004983ybg.327.1611346941233;
 Fri, 22 Jan 2021 12:22:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:21:43 -0800
In-Reply-To: <20210122202144.2756381-1-seanjc@google.com>
Message-Id: <20210122202144.2756381-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210122202144.2756381-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 12/13] KVM: SVM: Remove an unnecessary prototype
 declaration of sev_flush_asids()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the forward declaration of sev_flush_asids(), which is only a few
lines above the function itself.

No functional change intended.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 15bdc97454ab..73da2af1e25d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -41,7 +41,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
-static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
-- 
2.30.0.280.ga3ce27912f-goog

