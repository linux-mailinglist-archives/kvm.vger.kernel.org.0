Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8408B659A7D
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 17:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiL3QZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 11:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiL3QZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 11:25:01 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D820163FC
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:00 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id s76-20020a632c4f000000b0049ceb0f185eso3231515pgs.7
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MpDOjh28JsAURpTnDCHBXTn8SRkFcmuZMnLUukHdgGY=;
        b=HGyFmKbPz7YAmNGmGmlYBVFZWnojZVPDD4tYUvlWgQ5Ks3HZ1/ODD0SZJQsr+6Gr4D
         LrY5sn2QSd4PIXvXXZF1r7EwNFRKZ31PG+oaZwljCYCmxJCWXVWJjqtnTXVQBxAS7qsg
         haEzrdiR7SF2eU0+mMTsExEjBX3bnHWz1qbBna0ScTDg6Dn2DENgreS0ttev/SWcnNe/
         xP1q+ySlSnYGt5hOFiGjLejCjNb64P8gmJC8m+5J85Fai33M7d/j/ivnX763D6cNUHlk
         PwWR1asefPZMbEpwRj9Z2PENxeRc9v0PZ6Ok9umhZ5dOjaES1MgW435GZZicFOIY0tdJ
         hndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MpDOjh28JsAURpTnDCHBXTn8SRkFcmuZMnLUukHdgGY=;
        b=kUVsF62VJpsUzWeoghv/6w/Gs3/jpOVOxge+Y7uc3xTW9X/oYwbhJbLgnWlVqyy9Mr
         YybtHptiCvfgK0StcAypgZyPPgm1kp23T0WEYkLw3VFb8xSJeN8j834awdoDv1P5pTFu
         qlZJRlrK7iOyyVdvzZArtjwey5Kene7p3S1jasdJQha7mzOQV/KMNeYt/AqKMJTZBs6P
         wLheBYZZxSXUbHH67ud1Nk+R2MXo/BtGIR+47oHVXp/mPKP9QW5mTuzFmIYKbfeMiMFn
         Nl+dJXb0Jp9CYqsqd8b2fR5MD5xXNbEX/15chq4/6U/9yaJJW0MTKLi1K2UVB/+DOI08
         LYDw==
X-Gm-Message-State: AFqh2ko1hPmICGh9Hx2E30v/ktNdKryvvKp1aynURy4U52NEmiBl3R/l
        dgC1X3bex5sRGZDMogfd5Ng3XM2iyRB6ihAwl0GzzVRiK/66gMdNat2aMinlKiDGvnDPF2DYwMX
        WMsBUpsgv1Hjk0tZ6YWzU6wVrizY15ZkS7Zq4N1sSuOoAI5pva28Fkfj9AQF4KO6YQZzw
X-Google-Smtp-Source: AMrXdXsDV2jrkutrIIZQu2b6XbKlj80oZd7VAJGoSGgCQIwewPK6P+k7/c1jS1+TUG2V+DPEhEaSjrYWSEPD0DLO
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:2653:b0:189:cdc8:7261 with SMTP
 id je19-20020a170903265300b00189cdc87261mr2140432plb.168.1672417500198; Fri,
 30 Dec 2022 08:25:00 -0800 (PST)
Date:   Fri, 30 Dec 2022 16:24:37 +0000
In-Reply-To: <20221230162442.3781098-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230162442.3781098-2-aaronlewis@google.com>
Subject: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if they
 are not all set
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

Be a good citizen and don't allow any of the supported MPX xfeatures[1]
to be set if they can't all be set.  That way userspace or a guest
doesn't fail if it attempts to set them in XCR0.

[1] CPUID.(EAX=0DH,ECX=0):EAX.BNDREGS[bit-3]
    CPUID.(EAX=0DH,ECX=0):EAX.BNDCSR[bit-4]

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c4e8257629165..2431c46d456b4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -855,6 +855,16 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 	return 0;
 }
 
+static u64 sanitize_xcr0(u64 xcr0)
+{
+	u64 mask;
+
+	mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
+	if ((xcr0 & mask) != mask)
+		xcr0 &= ~mask;
+
+	return xcr0;
+}
+
 static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 {
 	struct kvm_cpuid_entry2 *entry;
@@ -982,6 +992,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
 		u64 permitted_xss = kvm_caps.supported_xss;
 
+		permitted_xcr0 = sanitize_xcr0(permitted_xcr0);
+
 		entry->eax &= permitted_xcr0;
 		entry->ebx = xstate_required_size(permitted_xcr0, false);
 		entry->ecx = entry->ebx;
-- 
2.39.0.314.g84b9a713c41-goog

