Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE7916F8B5
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBZHpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:45:09 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:32953 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgBZHpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:45:08 -0500
Received: by mail-pj1-f73.google.com with SMTP id d22so3007060pjz.0
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 23:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8HBWKlQYG3cu24wlZPhv8FmjF0s+tjjwCin6uZ9bx5M=;
        b=YC1fbhcW5B+/Tqz5q1XH59Ir37woGfBwArFpTS+g300ghGdVAeFy+s9jfd8kdIxPMz
         7S3owuhX5rGdNPUPdxMAP0N9EIlMc62d7NoCcFLRm4U6jqSlaAYX0DT/xX96fLbnYE/V
         POscfmeB/sh+6sjcJhE4s8byPNm0FrwuFNiWTuEjFZ0K38+Xrh4/7SZtYuNGTxK2v334
         wdgrNXW2AkQ+1RTJj9uhJLM2kqI8duz5MxN0jGkz33HTwAopK3AMux4ftD8gCoo5YZrx
         xzxP8OXCsNoTJpq0OCcZqGUujaUboM69iTAtZWjErMJM3XZ/a40yWyXrcskGUvzgh7+c
         ZPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8HBWKlQYG3cu24wlZPhv8FmjF0s+tjjwCin6uZ9bx5M=;
        b=HOtClCnS9+Z+WUHwMFST3kIQLL0eFzJ5NrSbWA7WV+gTIw8IDgfnp1rl9tt9kmKYQf
         uf1JhOsE8VyNvajrVcjsUtaONB9dUplYRlYlTvPzB6qVWSofl82fGLopjkZgY3Q7SPzC
         1HXxGZnOqwMYdyXGlX5iqH0ZTlYClf1KvP4Su6mB5N6tuQP0UM1WzkHEgTrd2PpOXL4f
         smVFoOXwIRSonslfiS7iNCOVkkjo18zAlwezJPHyQkDYv5c2psdxRqYqVLeNtMCKAfoD
         v0JgM7dFPDptOw+Vh44V2ksUlwVDtqRgtCUNPpUk+FYBFLsv5VdRcPCpBPv39zAfuC/I
         bZLg==
X-Gm-Message-State: APjAAAU2e37SWGqsXd5pPn7JPN6CW87g5iAXX7PBQzOu2U8qEOQ/s39Q
        C6uZogZ60NjtAO6r/Hq7WVSYhdx9Sgtsb/IVUkgNufVWlaCbVLqwHWcjk/EV0Ly3HnesNiI11jI
        wxSAB1l+0m5CwZD252wtqqLJnl1Jqlsoh6cbK4OKHKcnSHwlKjdSFjA==
X-Google-Smtp-Source: APXvYqyKuoqOSEuCd1dMT5Gj0tPCF63SaV/rlATHpwg4BViQ/y8XcZFUrvhJ4lA3WRQRnqxgN0NUUm9jSQ==
X-Received: by 2002:a63:f20d:: with SMTP id v13mr2552778pgh.34.1582703107715;
 Tue, 25 Feb 2020 23:45:07 -0800 (PST)
Date:   Tue, 25 Feb 2020 23:44:27 -0800
In-Reply-To: <20200226074427.169684-1-morbo@google.com>
Message-Id: <20200226074427.169684-8-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 7/7] x86: VMX: the "noclone" attribute is gcc-specific
From:   morbo@google.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

Don't use the "noclone" attribute for clang as it's not supported.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/vmx_tests.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ad8c002..ec88016 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4976,7 +4976,10 @@ extern unsigned char test_mtf1;
 extern unsigned char test_mtf2;
 extern unsigned char test_mtf3;
 
-__attribute__((noclone)) static void test_mtf_guest(void)
+#ifndef __clang__
+__attribute__((noclone))
+#endif
+static void test_mtf_guest(void)
 {
 	asm ("vmcall;\n\t"
 	     "out %al, $0x80;\n\t"
-- 
2.25.0.265.gbab2e86ba0-goog

