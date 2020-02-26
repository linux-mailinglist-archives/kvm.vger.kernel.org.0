Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683EB170940
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgBZUNQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 15:13:16 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:55191 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:13:16 -0500
Received: by mail-pl1-f201.google.com with SMTP id s13so320783plr.21
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 12:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ToWeorAUFnUXwAhb7jaBBmGub+OaoJimWpyK5/Q9FSo=;
        b=fFQpNZdUYsBG0yoNSuVwfOheETmUiVXL4UgudFnyHagIFn53mTMuoz+P0bCQ+HGzwC
         8SMMMXZEJ2pBZeIj8SZEZ4O0Cj/kpZ2fVOqMChVU7Aj7Rpm6tZx4ypdA+RkKSdJCfcgX
         CyGO/EjYqdhlYZZ50LFD6URmB2Kzmvb/KTI6R4JpM4ygxBe9YRAUYI5q211ZPxrI1pU7
         yDHpZSeaCikg2GDVD3w9jlJWS3b2Kf705Oo7d+K29+9fcG2pe58a8GaOthb1dCboR+LE
         O4/l2poRzSScK6aADyu6QCKpFBMg/W+s9V+xGe9jncDzqpA1b6Mqv/uKc01zeXThCXKT
         ZsCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ToWeorAUFnUXwAhb7jaBBmGub+OaoJimWpyK5/Q9FSo=;
        b=dEut22CTAAc6miwDxEZvwBJUY5H/1aS2LiMshCc0VnPitQdgmmLDlgAejp7b8Cjeb5
         NEdrPTK/SFWPzhSDvWXT0Xu89vdnAznl1ja1Ojva3D3o3Ujc6wr3Sn7hWM+IuAFpMkhf
         zPaunvg0BFVnfM4mJmt+clxtTFiyOGOirQ4zZxEhzINK21K2e88qcP9EfsHKy3obciqw
         ZT7jlicnhU09TdO3dwe3pZy8tvsSf5Vq9GlRhssxOQc1q8RFZYIikmFiYRFMrZ7H3mAK
         Iz0yP8laeoF4DaUvdUYg4fikOcpCYc/LIwxHTx7vevdajET41kqNSFLbyhETyuJYtdJ1
         O0Zw==
X-Gm-Message-State: APjAAAULxh/h4XvsZCY9QFsgT64YqXERWJEgN/rkbtxCAepBkk5t2vGY
        nCCg65PmyShqQ2eJ5prymYdcylQGmbm/nM7rhiBaU//wpXfhmAKyFne1Nlx0IC4gz2upw/w1tbC
        pLagrpqnD4ajuLCV2ndhMrsxnffHnk0tSE/Eyj5t08KKi2IlhGk5Hrw==
X-Google-Smtp-Source: APXvYqwl82W7+I6hrIYSq0LLhCkLCaPYYqDUcSxPSoUtm6xQ/iFxztxwS1tLpqxwsY7kxLldWi2TOib2jA==
X-Received: by 2002:a63:4e63:: with SMTP id o35mr480111pgl.279.1582747995137;
 Wed, 26 Feb 2020 12:13:15 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:12:41 -0800
In-Reply-To: <20200226201243.86988-1-morbo@google.com>
Message-Id: <20200226201243.86988-6-morbo@google.com>
Mime-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com> <20200226201243.86988-1-morbo@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [kvm-unit-tests PATCH v3 5/7] svm: convert neg shift to unsigned shift
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, oupton@google.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shifting a negative signed value is undefined. Use a shift of an
unsigned value instead.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index ae85194..17be4b0 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -1148,7 +1148,7 @@ static bool npt_rw_l1mmio_check(struct test *test)
 }
 
 #define TSC_ADJUST_VALUE    (1ll << 32)
-#define TSC_OFFSET_VALUE    (-1ll << 48)
+#define TSC_OFFSET_VALUE    (~0ull << 48)
 static bool ok;
 
 static void tsc_adjust_prepare(struct test *test)
-- 
2.25.1.481.gfbce0eb801-goog

