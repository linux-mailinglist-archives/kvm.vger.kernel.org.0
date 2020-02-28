Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C331735EA
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 12:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgB1LQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 06:16:36 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37124 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgB1LQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 06:16:35 -0500
Received: by mail-wm1-f66.google.com with SMTP id a141so2769311wme.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 03:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=VAKXZjZM/wZQW2c0BGuG9pHq04sQRkDdMI+raG9ELUM=;
        b=pfKgI+X1E0Ej49Z+/23UQHdasEGzF8YDWtmUa6yXrWNHptH8SdlPGl3/bxogo41qao
         5SJElK3yInB2eKcYb/j0w94vgjbuhABzPG8hW6DL3HYE2D1+e6Fn1LO4jOakilTQ5Q6v
         8THJmvURUGKpHyY7UyFMBLAtHWOBe260DbPgyVRYsSQ+UzJoix43FANpB3qNmqen8JPt
         llwPE1x4prI6rh+por4o0vBhUFwE/3QMUtdTyNX/VKMpvNhDhtaFY/4LnsJWG9o1TEtk
         OQOM9xJjpCqtOb/HvDt5YIPNCkpRq4cxNJ2wdnJomzfnm4O3W7zu9Zfnq61pz1c0Ix+T
         d8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=VAKXZjZM/wZQW2c0BGuG9pHq04sQRkDdMI+raG9ELUM=;
        b=AmYB5wF2+9hSwXBslBqG0n3hJ9Y+EXQApsuKe87MX3YE9UDXViWAWFsR2ZgH9F1n6Q
         p61pEVtDZ/h153ZScd0MKqe7rz8lL3CzaehhOae3KjvwjAHx6TCnv912j2rDhd544mI+
         P/DfUP1F9CnFGQ6F39pq/mB1iGOq40qmu2d6D6OB1cG3sDWncqceqOAP0eQwbeYzgUbe
         pGVuNgIZ3xFUYXt0dem2IAPqWEA+IRxqgBoa6bpnPU/G4MFklUz2duh4nGbSlU5MoXaL
         SZk1Z9h+bzqOuVWVS/nk1Ktgl1ytBNAn+IKhzRWNYX7mQ62mr+EWl7Mpmqnp/PFieHkt
         oTCw==
X-Gm-Message-State: APjAAAVBq5O0VVZFTmQAU7MNeoYqeW/que/LLa1ralLUyoRr/ZBbcgaE
        kKuk0pCsT3W3elrSnpk6ydo/ONCl
X-Google-Smtp-Source: APXvYqzAtJacrRI3km5UGtXuDc+eVJv6TvBBzUqc8W2oKlLVPt8p1O010XmG+KhWdNPR6ZXXmomBhQ==
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr4743922wmk.68.1582888593596;
        Fri, 28 Feb 2020 03:16:33 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 61sm12041380wrf.65.2020.02.28.03.16.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Feb 2020 03:16:33 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     morbo@google.com
Subject: [PATCH kvm-unit-tests] x86: VMX: the "noclone" attribute is not needed
Date:   Fri, 28 Feb 2020 12:16:31 +0100
Message-Id: <1582888591-51441-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't use the "noclone" attribute as it's not needed.
Also, clang does not support it.

Reported-by: Bill Wendling <morbo@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a7abd63..e2fa034 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4974,7 +4974,7 @@ extern unsigned char test_mtf1;
 extern unsigned char test_mtf2;
 extern unsigned char test_mtf3;
 
-__attribute__((noclone)) static void test_mtf_guest(void)
+static void test_mtf_guest(void)
 {
 	asm ("vmcall;\n\t"
 	     "out %al, $0x80;\n\t"
-- 
1.8.3.1

