Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BE2404045
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 22:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350608AbhIHUrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 16:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350572AbhIHUrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 16:47:05 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24085C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 13:45:57 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id x19-20020a05620a099300b003f64d79cbbaso5633180qkx.7
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 13:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ymeUDxCOSpBc//Fnk+ZR8CYIjCEY9GvLaXymBc8UYEI=;
        b=f5fpr/1key+gRM+45MYAxnvIPkPkx9nJmmCdTswHPqARi7qqJbxrycIgAJgDYfARE6
         21MnZL39AUDwllfwn6bQ3PBPxUYIw1gToogFTvwPw9QTLMct3tj/G0eTVCT2F0Y4yDyg
         QMgJMII4Eir/PxoF1YJWOxDpmIqGbQvtm62G5360K50VBwCwu4QcN/7+iQn39Nbeuurh
         i02aWioNTDBRnr6ZtrgQRaEDW+cXbQSQeD1y5MDzTrWsy/PypUNgGRJ9ZVY5u2zCBKgk
         bt9PfgVE1ZT7UCW0FsabwBnWdGlpawGFWQ+ZljVbAryqIFwfEqTdk3LJUlFydfC+TOzy
         wUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ymeUDxCOSpBc//Fnk+ZR8CYIjCEY9GvLaXymBc8UYEI=;
        b=n/OyQJImerD0SGqMCJfYAhlQ/zWs7DOr3afsP78P69Nz3TIidQ61GGZ6gk1GmNV4Vw
         5zr3hF6BXcFDOOLrW1xl5iKY/4crUvE4XQerhXbnl2Z6De7AO6A36dJBl1DpHQaMzsSq
         IVgrOcIQ1w7LByDKRMDpMBAI0UpICIKZ5mz4aAvc+Wo3QAn8nf1NaBpe6/gXwnW94KKA
         LGMklDD6U0Q6ZpE+fBv8oVJRMwZjNqTFefb3wGXPKoWpLIxQ5xPec7M8yTE7+i+Gw0Yt
         uDqF1NtIWmbOY83Ym0EuBaFv+RG8t9DoLGTD/jHjpJSq+bAcq0bhwm5JD82WZ7QZ7uaG
         faCQ==
X-Gm-Message-State: AOAM532po6IF2D9X1gDaFZeqMfVa6IyGlZZb0VK08Elx+qTbkcH4AlsU
        iKLsFD8Tj131Nx1O2TyjLZzGIVDG/bCIO8oWcxQsM53tdKhCcnuCk1ZtMrs2JIsuG997EYcCw76
        xRGpKSeE70nWLa4g1fjyFX8dcftkpamn7sUhaGwN/Mf4ge2614Aqi1g==
X-Google-Smtp-Source: ABdhPJwv5u0S0ZsBlci1nYX1H4m7hHqJ+R5AOoEJT4eqDICQH3PjgbrLIBFPGLXHq39Pd9I5n2Jnx6d3xA==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:2d44:9018:fc46:57b])
 (user=morbo job=sendgmr) by 2002:a0c:8503:: with SMTP id n3mr195545qva.48.1631133956300;
 Wed, 08 Sep 2021 13:45:56 -0700 (PDT)
Date:   Wed,  8 Sep 2021 13:45:37 -0700
In-Reply-To: <20210908204541.3632269-1-morbo@google.com>
Message-Id: <20210908204541.3632269-2-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com> <20210908204541.3632269-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v2 1/5] libcflag: define the "noinline" macro
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define "noline" macro to reduce the amount of typing for functions using
the "noinline" attribute.

Signed-off-by: Bill Wendling <morbo@google.com>
---
v2: Combine separate change with this series.
---
 lib/libcflat.h | 1 +
 x86/pmu_lbr.c  | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 97db9e3..a652c76 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -29,6 +29,7 @@
 #include <stdbool.h>
 
 #define __unused __attribute__((__unused__))
+#define noinline __attribute__((noinline))
 
 #define xstr(s...) xxstr(s)
 #define xxstr(s...) #s
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 3bd9e9f..5ff805a 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -16,14 +16,14 @@
 
 volatile int count;
 
-static __attribute__((noinline)) int compute_flag(int i)
+static noinline int compute_flag(int i)
 {
 	if (i % 10 < 4)
 		return i + 1;
 	return 0;
 }
 
-static __attribute__((noinline)) int lbr_test(void)
+static noinline int lbr_test(void)
 {
 	int i;
 	int flag;
-- 
2.33.0.309.g3052b89438-goog

