Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A2A3101F4
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhBEA7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbhBEA7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:59:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90E1C0617A9
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:58:01 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id p22so5058489ybc.18
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xmoOsBXeKXyFHJhpz5rFcXr9QRcBzbbStA2Fiq93tIU=;
        b=wCMPxs0PrpuNr8nfx/4FS1qEX8ZzYAe7KC0Uo6nkACkwu8rj47EqilzFxXE090d0y1
         la8uV57prnbyjLMr6TODEjeCwNOXG9JOh4S69cQYJAYkAfJi0LbQ8gMwijcbP70AS2rd
         D0hKwhwWoEFZNLTp1+H6o/GZ/SmVPmW0D5GGPsv1dfSgCzGcVLYda7FFjxp4qV2e1cwp
         WDrsNp9dAUAcxvmsCq7qU12BXdgH+2HOY2wMITvkwhbJbFgzFdfAEXt0r0uJFq6vPGSz
         fpNf+Svt+/LmDpGgNv3WdJ+Y9t94ogGLFgB6sBSWrQ3Kgfz2Jb+YzB9PKhe8EU7QnDFW
         9Cjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xmoOsBXeKXyFHJhpz5rFcXr9QRcBzbbStA2Fiq93tIU=;
        b=IK08fNZ7+e56YvsIITOez7rWk9egTidk/yxBzv79q1J4uqN2pA9toKBwn020ZkhTN7
         EVU37uC6qY46g2QfF3jtD3xSjWxUs2FC25jYjo7/W38tvVmkE1gr9WogpVkiYUq2pugX
         uWI8xk4o9Dpwzi8DJ/O7JIhQww4HnBWQUNAGapL4ks0yYNlefGGrlNNAO93AeIGf5b9R
         QxOY0JZ1ipBgC/xsqVhVlLId7FateczEVOci8RgW7zaumDJQyW1QrtmLOxRDJmWM9pLy
         lb4lcQAcWVVU95RhO7pePSqgHkOdpGVQaIAlf/K0YzL6qTjKSWkpVshyIKBoxQGEymon
         MvXw==
X-Gm-Message-State: AOAM531bSk4XF2AjqJ2hSt6tiTJ9BNoZLnToACWHinmAzxcAOVa7oTEf
        PBxJiBEfXgwAfMykymO6ce5b6Fz0xyc=
X-Google-Smtp-Source: ABdhPJx7UxzEEIY1n6OFyRn/JEvWsi7uz9xz7/HlcHEiBzyHXPLNwaVHL6yFNgHyJ8RziyoBtnA0PEZoI2c=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a05:6902:706:: with SMTP id
 k6mr2776341ybt.87.1612486681153; Thu, 04 Feb 2021 16:58:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 16:57:43 -0800
In-Reply-To: <20210205005750.3841462-1-seanjc@google.com>
Message-Id: <20210205005750.3841462-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210205005750.3841462-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 2/9] KVM: SVM: Remove an unnecessary forward declaration
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop a defunct forward declaration of svm_complete_interrupts().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3fac9e77cca3..8c2ed1633350 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -205,8 +205,6 @@ bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
-static void svm_complete_interrupts(struct vcpu_svm *svm);
-
 static unsigned long iopm_base;
 
 struct kvm_ldttss_desc {
-- 
2.30.0.365.g02bc693789-goog

