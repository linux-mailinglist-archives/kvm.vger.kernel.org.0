Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F735170942
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBZUNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 15:13:23 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:54830 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbgBZUNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:13:22 -0500
Received: by mail-pg1-f202.google.com with SMTP id l17so265644pgh.21
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 12:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=juAXt12km2i38jzPz/B2i0wdAoJlFZOk1KJ1Ao5kVQE=;
        b=bEJ/WLERUZo3ivhXzYuTnPOA9PVkOMnuKD2qz7Sgn6ajrBEj62ZmJFuslY081CSDPw
         klqjoshGAmxT7x8hvlfX/bXIX3SUlp1WZxUAXxLL274JYgi/CJB5k+FKzBdgA3fyIDJF
         r7PUjhz6UJECn2Sztnpik9WyE9fEhXLQrsCXmnKB+l8SyFftbCmXbAh2QDWJNYeezty6
         JuhOIMopnjd7cVXVrJgjTZMfHldomHpIcaJ/Um5ufin0RtYvjmryZBdF5ftOvSbuopsC
         D+RGZFPETVBjSDMrdKy7oGl2kRqVljTRkKpRgiWZVvuLjp5reKhh35kgBpVz81nUsBPp
         bdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=juAXt12km2i38jzPz/B2i0wdAoJlFZOk1KJ1Ao5kVQE=;
        b=Gw/oaNnBGCgSxd9GMsu20lpgxrr9mo71rVRKhTtrCA/jdmauyxLnPmnhzzSKLFPw1R
         IIlYCxUq5o5r48n/aELrBIAwRXfUKtfrYtgtgXKeELimvCS733njHmPTMWVTFPIXZ0g4
         hsc3uULMALs9V86RZRR7Q7JpIhZbX3CN/PyxNAfQa+OjuBidWTvsiVcVVJAka6L/JWww
         BEHxlmmhQ3PcggP/nomTkic6EzBi8wYYWnIg44px0gFqtRsw5uCrgO6I0wAHtLVWU8xw
         uAMdkSZR/MDp0E8j81x/taVOtSvCJWa/AJP/38Bue52mZei783yPHJJrYNciQfc/cGTB
         MA2w==
X-Gm-Message-State: APjAAAXcyOCnR3MHFNsNjqygUTvEPh/7HejlEENI5r7FKOmvD1NASn31
        C2U79xTxOFPCotCjyXfJjdXVEv3LBxyU1AeWVLIKix8B0Wy8k78nbUyGtrd6xOaXQcJ3uIB9I4p
        ieSWTGngaE3hyxk3NEvG6e86qyDH4sOSV6IExtrRh+zmkVi0EcVnk6Q==
X-Google-Smtp-Source: APXvYqyFPMwO3UjdtV9KZS+Gmczt/6s35R5gwP1hWY2iDENsA0f8Wug5lB3xb2K4izUF2Wgc0QgUD3tjHg==
X-Received: by 2002:a63:d90c:: with SMTP id r12mr582562pgg.106.1582748000094;
 Wed, 26 Feb 2020 12:13:20 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:12:43 -0800
In-Reply-To: <20200226201243.86988-1-morbo@google.com>
Message-Id: <20200226201243.86988-8-morbo@google.com>
Mime-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com> <20200226201243.86988-1-morbo@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [kvm-unit-tests PATCH v3 7/7] x86: VMX: the "noclone" attribute is gcc-specific
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, oupton@google.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.25.1.481.gfbce0eb801-goog

