Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7EA3235B1
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 03:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhBXCaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 21:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhBXCaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 21:30:22 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75011C06174A;
        Tue, 23 Feb 2021 18:29:42 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cx11so290248pjb.4;
        Tue, 23 Feb 2021 18:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IajG/oRx8DIcPZiXA2gvIdGxbCLN+T0yMKe3hbjtvHY=;
        b=WZ9ZVIVbhgU9SCIeRL7TJpUayGh+VpyEEWCoPIqYi0RIuD/hvg6Vh3oA3wlAGtRTFn
         p7/rPV2tKcX6kvjrQi3QFWmrYwt/HeU5StRtsKLXQ8dwCl2s2l1o4GpzVApHI1jVb+rb
         h0gg2vgaxjQJQBeC4uQN+cIC6gKQwRYzakqB8LXSE8IJfRfXSmIRyowot+x8xISfTn8g
         nWQa5DiYf21D7SAvvOfRmICEyla1gpH8PA9AGCIubCB/dDswbFMxSbBYlL56pWpti1Zx
         fmjmNpEIuBMroKpYPZM7NHeT9S6RHtXcMy5yifbB0yxMQ+85/X0v3eGA2niYyJCrv4oQ
         ShgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IajG/oRx8DIcPZiXA2gvIdGxbCLN+T0yMKe3hbjtvHY=;
        b=eYOPcN1OncyLFcZkbC1Q5mQkB/KdomphuEhfFJaISs6kGVBFzcDUnwYvc27Z0rSyjl
         U03egM/pDxhVJksSclIyjw6fnunpuD56uk9hystp3VO/6Hg5uugsOlq/c3ekRlEGfeOy
         0BdTWLHJOlIwUkMry7ogzah8o03Oronz4CCCmVFEkZWJgPgYGwb0eypbntV/Y6xiQWlf
         kJrUCwnJ0JbygltwMdsbjrdDb32HkbHaE4rAIONdiJgyZZuLWufsR+202fsTk/9EInhp
         +EEe4+1dnL2u2MSJDCEYpWTTtKu6vhi8nSX++z5rxKLYAZ2nceaSgQbEVl/1Yd0hjaBS
         K/Sg==
X-Gm-Message-State: AOAM531slw2RCE63V7VkI7/uVBQtrGlrM+Xq1+aSl4Z8xHxMny0aP+Wd
        Vv88JlexCobANVyb/Dwu9Ujsp921fiTmmg==
X-Google-Smtp-Source: ABdhPJxaf1+fVqWgvbh/vW3PyzmVkyvu9VCjv5RZq5CIjP+dEEFF/Bk8dwOYmRbg1wYdJgWdy0Qzbg==
X-Received: by 2002:a17:902:7592:b029:e2:e80f:6893 with SMTP id j18-20020a1709027592b02900e2e80f6893mr30661718pll.61.1614133782016;
        Tue, 23 Feb 2021 18:29:42 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id u128sm511452pfc.192.2021.02.23.18.29.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Feb 2021 18:29:41 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] KVM: x86: Remove the best->function == 0x7 assignment
Date:   Wed, 24 Feb 2021 10:29:31 +0800
Message-Id: <20210224022931.14094-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_update_cpuid_runtime(), there is no need the best->function
== 0x7 assignment, because there is e->function == function in
cpuid_entry2_find().

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c8f2592ccc99..eb7a01b1907b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -120,7 +120,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 7, 0);
-	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
+	if (best && boot_cpu_has(X86_FEATURE_PKU))
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
-- 
2.29.0

