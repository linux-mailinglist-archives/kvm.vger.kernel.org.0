Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A5E49B11F
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbiAYKDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbiAYJ7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:33 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B69EC06175B;
        Tue, 25 Jan 2022 01:59:32 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id j16so8192691plx.4;
        Tue, 25 Jan 2022 01:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j/rRmDiMdmGlDszyCo/+/fHqa/st5+5A7HjoH3NKV08=;
        b=cYnSfuu7cXdFeqfoM+hegTyG4JSAyN1qSNbeBX1V1k3y0Jlvzele4X5rrqc9MTA70F
         DzRy3+qKF2rm3varwe20/g098zxwHdokrfUwZEX4Wxogx8HSQ4T7sRoJWww7gUgESoOQ
         h3G2sIxGvdfDG5pJChVK8Imr40QYdabRIDM+8C8aldKJP7YyycSxpVny2yrr5bsB0mUy
         8M3P4MZOAJSiyn46N6gOGXSIHQYSWSAEvduVq3dYxskroY7W7zaqiKsMRGUr/A5komaF
         qGqADiMqXzL1IgljGbkw5dTH0oSZomXCmAXqtEA4ybI+rASYG3iW76UceqT8kMCWmTyM
         4TSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j/rRmDiMdmGlDszyCo/+/fHqa/st5+5A7HjoH3NKV08=;
        b=sAr1hl1fkusq4RnkvB1m6yt/tg7M1OWu1JoFx6nUoMATRPH4sYFBY2HEZrFdtukdQB
         25GIpJROHgb6dFNwl8tNyMp6bL64QmOBkLi7tYpR0Q6PS7A3NDPvSfYgHOa4ZhvHaNd4
         sARXegfG2FEc0x4gvWYY9BEkeHli/u8mYLaAQlQMhjxKJOEVqcQsT20ih7/HNH8Kp/L7
         6XSr77cM9qjHnANVEW1ZyhzlBJMJ/oYjewssThatKvjaBxwxGgISWJZz13xW9WOgCKxa
         S+CPib/GR5fGpcTF8uOIdOg4/cTQhzFIT9+hkQaRQknK76QXm3i8J5czXIdvCT2gSFh4
         5M1Q==
X-Gm-Message-State: AOAM53255f5/VaJgIiFq5ArNl6rmfLBFBz/6kakMVo57EXRA+2Xyf5WD
        ++AtOE4QqzaRvyVpJPQigGI=
X-Google-Smtp-Source: ABdhPJwLivPrqbSTiB4hpRIeQmhCIfmFOKjpzqLDUHj2ySIix16rb7GMsX2N9oGFO7SEmd9UopVAwg==
X-Received: by 2002:a17:902:dac6:b0:14b:51c2:5d6d with SMTP id q6-20020a170902dac600b0014b51c25d6dmr8068078plx.3.1643104772108;
        Tue, 25 Jan 2022 01:59:32 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:31 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/19] KVM: x86/svm: Remove unused "vcpu" of svm_check_exit_valid()
Date:   Tue, 25 Jan 2022 17:58:56 +0800
Message-Id: <20220125095909.38122-7-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm_vcpu *vcpu" parameter of svm_check_exit_valid()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6d31d357a83b..bc733dbadbdd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3120,7 +3120,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_to:", save->last_excp_to);
 }
 
-static bool svm_check_exit_valid(struct kvm_vcpu *vcpu, u64 exit_code)
+static bool svm_check_exit_valid(u64 exit_code)
 {
 	return (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
 		svm_exit_handlers[exit_code]);
@@ -3140,7 +3140,7 @@ static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 {
-	if (!svm_check_exit_valid(vcpu, exit_code))
+	if (!svm_check_exit_valid(exit_code))
 		return svm_handle_invalid_exit(vcpu, exit_code);
 
 #ifdef CONFIG_RETPOLINE
-- 
2.33.1

