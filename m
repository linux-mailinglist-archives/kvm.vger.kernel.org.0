Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59246659A7F
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 17:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbiL3QZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 11:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiL3QZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 11:25:04 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08CF63FC
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:02 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id e11-20020a63d94b000000b0048988ed9a6cso10380273pgj.1
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cEH8j+eDdInggeGdIc/loNz3/XrV+zCztah1+1tBKz8=;
        b=BD6kfxRrY9FvlRtHWfIfmHRRmVBbzLmPnpj32fBGQSCrJxCH2J0tqJ/Py5qjcHFmAH
         62JfXnz2skfKmhcZfTvjOf2uJGaalr/bEYFjw/WiBzx8oBYnYHJgDgb0ESM8E500K96V
         quLgJCgNde2n3W+RhN+XDd6Lap9xvGVJoQCybyQWC4fjNaQSs0AJ896AKWLOPD3+ddGU
         xaA4ABMrtTWV5aT0OfZYasbF34qZhymAeKOc5MhV1vAm9so9yVGnPKEBx2u5F1nGPaK/
         rFV4Ob8EZC14WJ3mKVAWd1YAlGFutNBCJGVHmYmcH9c1yWIXnnMT6QeyPiNnOqgp/wGF
         1icg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cEH8j+eDdInggeGdIc/loNz3/XrV+zCztah1+1tBKz8=;
        b=x/LQINAIaTQUa9HnLl8dl5FciWBj0pO2GZ8oq/oCgDZJwZ/cRfNiHrlDln18hzKVCy
         nqqjuPWW/B9CYQMeOpvCa/4nXWUG325A5FwD9N/my2raHrMZqefdQBiPTUk+d66rXk5M
         gsu0ZpQf0ALCV++xovygH9C1w4L1M8Q4TNl/3SyKaCOoQLOcYVUooLFdxGSAb8cb1eTO
         SRRdDbKQQXxR+SvKzzSDt9QUGxcqlnFRjtFHJZQEkiikjkkGpS4euaF/gYYagIJ21YEV
         acZtPp/581LsRHte9l7V/ik5koUZ9YDDd8Rw1NHb191va2DE9Dt7badMlZZJdgXZFpG0
         SufQ==
X-Gm-Message-State: AFqh2kp8hfslOot2A722pQXhqnAsKDCxk8Qgl2nGf5lXFc91N+aqBtFX
        drZhwBnqPJN8cAUR6Mq8Z5XLAbfIE6S4uczEe/JK9G4BOhklX2z7fsF9/a2ZpbU3VcnAQcJoP/z
        PsWV9s7y4+MP1M8psxLredVEw1g8yyYkPI5L2/u7dG+89FEeExyI/m4XIi0Yflwwt70Rm
X-Google-Smtp-Source: AMrXdXtR65wIxjasOel5TTMC8ImzHGxt1iSe1zi3NwzEg1qNP1vdZAYKTNs9rCWcy1rniRe0kk/kfZzMfIqrMj28
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:5c86:b0:219:c1fb:5da8 with SMTP
 id r6-20020a17090a5c8600b00219c1fb5da8mr2802493pji.221.1672417502067; Fri, 30
 Dec 2022 08:25:02 -0800 (PST)
Date:   Fri, 30 Dec 2022 16:24:38 +0000
In-Reply-To: <20221230162442.3781098-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230162442.3781098-3-aaronlewis@google.com>
Subject: [PATCH v2 2/6] KVM: x86: Clear all supported AVX-512 xfeatures if
 they are not all set
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Be a good citizen and don't allow any of the supported AVX-512
xfeatures[1] to be set if they can't all be set.  That way userspace or
a guest doesn't fail if it attempts to set them in XCR0.

It's important to note that in order to set any of the AVX-512
xfeatures, the SSE[bit-1] and AVX[bit-2] must also be set.

[1] CPUID.(EAX=0DH,ECX=0):EAX.OPMASK[bit-5]
    CPUID.(EAX=0DH,ECX=0):EAX.ZMM_Hi256[bit-6]
    CPUID.(EAX=0DH,ECX=0):EAX.ZMM_Hi16_ZMM[bit-7]

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2431c46d456b4..89ad8cd865173 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -862,6 +862,10 @@ static u64 sanitize_xcr0(u64 xcr0) {
 	if ((xcr0 & mask) != mask)
 		xcr0 &= ~mask;
 
+	mask = XFEATURE_MASK_SSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512;
+	if ((xcr0 & mask) != mask)
+		xcr0 &= ~XFEATURE_MASK_AVX512;
+
 	return xcr0;
 }
 
-- 
2.39.0.314.g84b9a713c41-goog

