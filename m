Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E548D007
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 02:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiAMBPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 20:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiAMBPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 20:15:01 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDEAC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:01 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id m13-20020a170902db0d00b0014a54b3db7aso4323948plx.14
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RygOBcbUT3WnO07lGCfOFuANEGLykoz7c71q7Uhky+Q=;
        b=le9nNfyKUMhTDpytN6QdQZw/+dzS69cJF6LrYvEMfNxBtZFNu+ulwzOG60RCXbz8gw
         JJRfPi5d1qJ4QMRVT7Zk3imu2HS24iXwgWfcz1QNXQY8+dJbV6XSItCyqIoFEd0+Tsas
         2rY1KncW59nUucFqKMnZKlERBNT1rDxBeOKxdjB/vOBTjbnsWwf+XRgM3NhIRDP+HUpq
         8mLA9NzRKyLNganv6tZ5cN6hAolDnAGaq6TRq/nD+OtsoYQmGLlVF1iEA8Rl4/fBRRof
         Mvan0PDZqYPxO9rP8bmgfShfuh4l3SWOQ7960/Opv1xGlntg3JEpiZ2N1v40GateEjS2
         5d+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RygOBcbUT3WnO07lGCfOFuANEGLykoz7c71q7Uhky+Q=;
        b=KmYsW7cCFc7ia/qDNZ9ggZ7Gt8KT4GfYU4ukQeqcDa8m7MafPiWLaQnIXWWUhXt1mg
         raiVV7h+EAyvfOwTqi/Hub2xZ3GaubmYnt4ULOivF7n2l+fOmPA6TK2Upe4+j2VWVPFW
         /5xpZ8ZOOELqdHLm7yfJnMFCDV69C/w7+/8cEu5IgGHmS+NwzO0+m86Nv8/Fc2+iPS9j
         rrtZmadvlIBDoDE0nCZjC3kXkLJCyVLe6t2tj/zNE72Wo7+UBcbjhXY6V1fMifwquyCs
         AOeHNcUHlnewrgcmcxzziA+f4twyZfBb7AB96WdFQ0rbDdO6eUU9Ww5toK1G3AKZ9TiV
         CRxg==
X-Gm-Message-State: AOAM532TBq0YxXSGLoKw/OxstUOYpVaObvYqOF8Iy6PsIvdEAw5/s25s
        tEW5loLNw50Co+Xu0fJ0LWLCKJGUJjPaeX+WDuB/4Gjyo/6ht2InRO6tmJ7AMQ4Qy3T8jYOCwAL
        j73UksiNe+yNhg6sw5aqVEpgKgLcgrsCaoBgeCXfJ2t5Ql0ePmsO8+/lT6KuSyd0=
X-Google-Smtp-Source: ABdhPJzJVrgykjDjT7Xea2wvNVQW4nBLCjcNSSPE27Yro0M7s7g4PQqv2WDOAoQgYiWWq8qgN7/N4VJXz/K7hg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a62:1c12:0:b0:4bc:6d81:b402 with SMTP id
 c18-20020a621c12000000b004bc6d81b402mr1976633pfc.40.1642036501088; Wed, 12
 Jan 2022 17:15:01 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:14:49 -0800
In-Reply-To: <20220113011453.3892612-1-jmattson@google.com>
Message-Id: <20220113011453.3892612-3-jmattson@google.com>
Mime-Version: 1.0
References: <20220113011453.3892612-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 2/6] selftests: kvm/x86: Parameterize the CPUID vendor string check
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor is_intel_cpu() to make it easier to reuse the bulk of the
code for other vendors in the future.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index eef7b34756d5..355a3f6f1970 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1198,10 +1198,10 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 	}
 }
 
-bool is_intel_cpu(void)
+static bool cpu_vendor_string_is(const char *vendor)
 {
+	const uint32_t *chunk = (const uint32_t *)vendor;
 	int eax, ebx, ecx, edx;
-	const uint32_t *chunk;
 	const int leaf = 0;
 
 	__asm__ __volatile__(
@@ -1210,10 +1210,14 @@ bool is_intel_cpu(void)
 		  "=c"(ecx), "=d"(edx)
 		: /* input */ "0"(leaf), "2"(0));
 
-	chunk = (const uint32_t *)("GenuineIntel");
 	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
 }
 
+bool is_intel_cpu(void)
+{
+	return cpu_vendor_string_is("GenuineIntel");
+}
+
 uint32_t kvm_get_cpuid_max_basic(void)
 {
 	return kvm_get_supported_cpuid_entry(0)->eax;
-- 
2.34.1.575.g55b058a8bb-goog

