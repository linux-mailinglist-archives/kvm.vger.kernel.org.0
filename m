Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF443F8FFB
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 23:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243597AbhHZVE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 17:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhHZVE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 17:04:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58721C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 14:04:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a62-20020a254d410000b0290592f360b0ccso4327972ybb.14
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 14:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=i2sGDuRku/FYfLWUl/wbmgS2ELZI7EvwMuHHuh47tJM=;
        b=XrEBuJb+Nfy2Qo6icEHSALmuN7GZvZRM4+JNX7C71uc8Sood823I44f90tbLlj46kB
         NJwx2LUbyJJoxU+7S9mFsRF6y2TXr57Ds0uA1y9B7w1SwQaQlelG2LXJMnLX4n+cR84t
         NAdIW0svtSj4i5WxOBrgt6OhVp00od9NJg0JQ6h5FH6YBd3RAb3RnTTqHlxIRaDXGAnN
         Wo58OlI9onkLPU+ZKXAkgoR8YResf4yveCzIq4dFeQQO5MyIfyFxER8tyoDfFyeppTcw
         MuD+noJc29zOqqV0ZvcSBIn0CH9xT0SxSAB5+a7xWBf/eH11vYYl3+sAzsvmBpT1OEUR
         fEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=i2sGDuRku/FYfLWUl/wbmgS2ELZI7EvwMuHHuh47tJM=;
        b=MkEAl230o32UVLv5Qiepd4qxGBbJ4X/BUp019mAKDZSuMts7+/B5JYTWojKz2CtLo1
         snCxcsL+xH2olGKJzGjFIZOMKIOG9W1fMZfGOGtoEzlEuCzAJR9vFiF0r6lYLBTTil8t
         NqtBMOs6rGySCxSr2lKUdrMxHWuPIWTE2QVH7woY88E6mzBQ5t06ADkeOKWoeH2g4nF3
         gYCBopVyW5WP2G0IlEY8lomSJ+8iu0SbEt3EETxwROApYo4/VGDkGFAmRk/JDRD3BAJc
         25oprNlCdmSELcLvze4h6oGGlArYx5+4Ie5Ol08JOrej5u7XsfsfyDJ3W0nanQHbAN5Z
         +p1g==
X-Gm-Message-State: AOAM533r6pC+EXEkCBUGPuWP5KcLw4CR9de+l+IZitu72BYBcVjm/0Z4
        Q/S7xERuYIzVS2LAPoMKAnwtiPUe9fKjQrQQcVi5LNKHsS6lPgLrGnHuolP9KV3rvYzP5960q+b
        LxsTI3dkioQtNZ4OzOgyFg9gOfxewfP+sxTdBENE9RlxUqrFpVcvqZA==
X-Google-Smtp-Source: ABdhPJwvP7VXrWFcmqt4Z2OgNHxg1TA6Kh0r57f42DpXfHDXhLN+5DbhofG2lcpW1QQX69XfpImFI93TBw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:1b91:1659:2490:68a1])
 (user=morbo job=sendgmr) by 2002:a25:c095:: with SMTP id c143mr920583ybf.179.1630011850572;
 Thu, 26 Aug 2021 14:04:10 -0700 (PDT)
Date:   Thu, 26 Aug 2021 14:04:06 -0700
Message-Id: <20210826210406.18490-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH] libcflag: define the "noinline" macro
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define "noline" macro to reduce the amount of typing for functions using
the "noinline" attribute.

Signed-off-by: Bill Wendling <morbo@google.com>
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
2.33.0.259.gc128427fd7-goog

