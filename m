Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D35548F4F2
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 06:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiAOFY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jan 2022 00:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiAOFYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jan 2022 00:24:51 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9040C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:50 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id g12-20020a63200c000000b00342cd03227aso3120680pgg.19
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U//Fwfa6pex8Xxi6rdTvYagiuiOPgXXZOmW3GyzUdl4=;
        b=YKNUIbZ/03hpRzrlwvg3Z3DqjXiCN5Vi3Bub2S6XeCLHKAuCTzWez0EKBmTYlgeg4X
         N7aa6mmARUUsSu4lYvk9U+kjfOgIWQDYsXVPnOBb/KgaLu9sa/K44cz8HNYFNYzwEGDH
         wamP0cQEg2ez4a3SFz4dTO81ItwsGnyaxS3ssbp3BisVF1wnB8R78X2pINueV+MFsiiT
         6qS384Ksr/QFAH8Rum0MXmfOxn7fZEcyAV9d6MgY9EaT4bQWIzQIBi9kWgYu2nW8WbIX
         DuIP/xubZh6j3Ld6fSr3b8S/V2IqkrrICOhuv9GGK3zBYUSvy1p1SXtONGwp+383jdP0
         V0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U//Fwfa6pex8Xxi6rdTvYagiuiOPgXXZOmW3GyzUdl4=;
        b=sNX7OcW8cCWqBEd7J/j+JxnPq0TaBdwAOeE5ZhB3FxQWrXi1hS42N0IH+nPcCeVzTX
         Sz6S647sgRLtTxvafaQCqkwtd67sznw+6Ud2Zs1711z3HO9MLSwpMRLqW+3qSkn1wgjB
         rQb66ogiRfO7vnihlfjaZeMjoGRhN8zTY1djl8qk2Afn+GTgT6u7zJyT/pRHuc5XYtb+
         wMiiTex5jLGxhKrn4I711JFwUwMiYSaZw6busUYFs9EKYqx3WcgxX/A9+0jcr1lLZMn2
         9v49uo2iWHdZCx79YHdcoP2wUOvod+5oLJHTyiqDEdUrH52zG6ugWHcQ/NHaQgSu3Q7x
         o8wQ==
X-Gm-Message-State: AOAM533ZRCZB2sacSU914Q8/GnG6zU3U+d2zF08vBX/1Na2WOlkinpHK
        YyOXPyTWALfHRZVYcVpQZfax3GGPRTef8BSzy53wwrEkzPU2kUhztq57bWsefFi4o1mXT5cEsuo
        0UNAVNwmn2EGOa1GammYwW9QpVZCMAkmSASvSOtIiGiMG0uW4xnNZQdBZryyj5Ak=
X-Google-Smtp-Source: ABdhPJyqYdleD5aXKXCaOg9CmuzQg3mO7YBoDAj29b/Ku5PrWl5lRDKk71l/+XuoN3TQMKVZ2UtD6r55nZVI+A==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:d650:b0:149:c6b7:c02d with SMTP
 id y16-20020a170902d65000b00149c6b7c02dmr12957695plh.30.1642224290148; Fri,
 14 Jan 2022 21:24:50 -0800 (PST)
Date:   Fri, 14 Jan 2022 21:24:30 -0800
In-Reply-To: <20220115052431.447232-1-jmattson@google.com>
Message-Id: <20220115052431.447232-6-jmattson@google.com>
Mime-Version: 1.0
References: <20220115052431.447232-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v3 5/6] selftests: kvm/x86: Introduce x86_model()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        daviddunn@google.com, cloudliang@tencent.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the x86 model number from CPUID.01H:EAX.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index c5306e29edd4..b723163ca9ba 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -361,6 +361,11 @@ static inline unsigned int x86_family(unsigned int eax)
         return x86;
 }
 
+static inline unsigned int x86_model(unsigned int eax)
+{
+	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
+}
+
 struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
-- 
2.34.1.703.g22d0c6ccf7-goog

