Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CCC405CE4
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbhIISd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237355AbhIISd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:33:27 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB9AC061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:32:17 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id t18-20020a05620a0b1200b003f8729fdd04so5602648qkg.5
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=F7SA2+l7YnzWg3+wwA5w5eR2P61Jl46+Hled4U2BLZY=;
        b=as5BF0XFYaht0N8QuPA8BfrWeiS6rYipNqGi4wekckwccB+f+t4tmJjCkXtVvTysDO
         sKBN8ajNMezipAc6iLwR8Wpj2ZHE6Nt6xvDnemmF7WtDK4pfGmmH7Ub/74SocRZk1TqG
         0QRWgvrJkES0HV2v0IfFek1UOgYisGkm6Ob1zYHgbO9lG+bo3e1U635/IINDgW+4slfC
         xKC2SK7mXmpaFVTFNvDuIM4EHNuOWMSPUfQYHVSfLBeSil3A7NSw8jlxgPzbLFq3VqmB
         hfWUhT1nxOJ2y4LM2dgLWqRY0LHp9YnHORDEHYvAauVrsd/sZ3sicXkx+nI5q6BbdRuN
         TwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=F7SA2+l7YnzWg3+wwA5w5eR2P61Jl46+Hled4U2BLZY=;
        b=5gMxPkCqJGNohHf34Ydpncl74y7TWnwMo+yxtupB5EGqqwHLaAgFd9pWdUNiYdrvJY
         THRx8WzyarLZALcgYFI6YTXDIdsWLevO5aUmdlOd52WYrQl57ySa9NgQxWCF7yHGDP+y
         rsMD8n4QsLCvAHPbjB+5AKyf2MbvrTjdFVspAqp6QBK9lBYp2mCREmbjJTKcQKmCnJeS
         hEkdLdDSq/EruSU5hd6eQ6W9Wg8XQRO+gLWnlhzD/OetNWR2bzl5Qo4jN+l5eX4Hl9qk
         d5pU+Dh0y25nyzChPc0F/VWr3ZCrnjlGNokNKohkhRQjARUK4h5IBXDq7bq5pZltuGVg
         RjWQ==
X-Gm-Message-State: AOAM533BvpVPH3ywMXsulejAhOeQb7bgPmHqQeBcBchKChYsm9Jrv4JL
        0ns17kU7QzK/KKmFX+/npX1ltQ/j13s=
X-Google-Smtp-Source: ABdhPJxeuw+oP06jSa9Hn5T5scZUOh5Ds8T2+EHB6OxgjaI6Bg9ifmQc1IbU7N4WI94wcib+Ac515fD0Ugg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:295c:3114:eec1:f9f5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:706:: with SMTP id
 b6mr4257787qvz.29.1631212336932; Thu, 09 Sep 2021 11:32:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Sep 2021 11:32:03 -0700
In-Reply-To: <20210909183207.2228273-1-seanjc@google.com>
Message-Id: <20210909183207.2228273-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v3 3/7] lib: Move __unused attribute macro to compiler.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the __unused macro to linux/compiler.h to co-locate it with the
other macros that provide syntactic sugar around __attribute__.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/libcflat.h       | 2 --
 lib/linux/compiler.h | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index e619de1..39f4552 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -29,8 +29,6 @@
 #include <string.h>
 #include <stdbool.h>
 
-#define __unused __attribute__((__unused__))
-
 #define xstr(s...) xxstr(s)
 #define xxstr(s...) #s
 
diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 5937b7b..c7fc0cf 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -47,6 +47,7 @@
 
 #define __always_inline	inline __attribute__((always_inline))
 #define noinline __attribute__((noinline))
+#define __unused __attribute__((__unused__))
 
 static __always_inline void __read_once_size(const volatile void *p, void *res, int size)
 {
-- 
2.33.0.309.g3052b89438-goog

