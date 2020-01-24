Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDE71479AA
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 09:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgAXIvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 03:51:09 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33807 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAXIvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 03:51:09 -0500
Received: by mail-wm1-f68.google.com with SMTP id s144so3592721wme.1;
        Fri, 24 Jan 2020 00:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=kKTpSe2SaSEyXCdh9QLkR7mYGqSy34t2TTsozXj1tMk=;
        b=PLx6tZ7BRNarGA3y/pH+yOQV5kK1Owzj4nw505iXbHyr3X0mjfTyFH5Jfw/TOi/gNX
         dyIneGCvmIQks9TCpcP7VIwaYxL3d1qvKHkGPz/DiNZXbR6Aj7W6dTOHd3cp7ij53fHa
         m+uLZ7p6AYP9gsGA1gsFEkby+386mNHbW7KewXlCkhokcJDMNGlMwlWjNuE9275EzW2t
         l/L/2pHBVLQutILiIcCj4i7sCh2C+ctlst7FiWiXvip/knCTCRgdlhzqaGgQ/PBTONlN
         cH3ocibrMfKJGcyRyHlyWWXda8godZJpfB9zKNSfwAMIvXj/Zix/icgt2ZWpwUJ+dIdC
         CulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=kKTpSe2SaSEyXCdh9QLkR7mYGqSy34t2TTsozXj1tMk=;
        b=rnHYfrvIZhWrq42a2Ed6pFG3Mg8+2hOlrj2OCF5lMUWS6mCXN8TwBoKr9YAbjKwTP7
         tT1fhDyTw+KaxmTFb+BBvcoDaffQv3reAU7Oy6LyecbVMwxnW+Rv5O4IJ/WwzcADevj2
         LvXKOSs2yCpAcizsYos2bLZWHY51BRcymHp3cPNZGZ2JUWsqWwPKMXAhCX+2HdQiTYhu
         SGXh3f+gHLqeYhy9E4xmDdsDWjQoG04d0FSgwNU7nohZx0hiMa3tjYPEYCTuXfx/kc/W
         J6KdYVvbD5SuuURoRKrI8c54c1TaTJfR7LrKfBwT4gR9ovzDOPkNLXHNWGLkGudQbHRv
         xaaQ==
X-Gm-Message-State: APjAAAU6OmFxQ35jNGbbTAUyWT0B2Df0Txhaa5MNxFpr86WqsnHjFt2h
        pC2wm7HshyU4612bfIXkZMhDsd13
X-Google-Smtp-Source: APXvYqxZD/4yDV+ILxmbPxnChfFi60uvl3bEnm7jADz9aXBbfHBmAxOEoeXg246AukJzSe4m7QhDwQ==
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr2226507wmc.111.1579855866591;
        Fri, 24 Jan 2020 00:51:06 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s139sm5933048wme.35.2020.01.24.00.51.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jan 2020 00:51:05 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH] selftests: use $(MAKE) instead of "make"
Date:   Fri, 24 Jan 2020 09:51:03 +0100
Message-Id: <1579855863-56484-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This avoids a warning:

    make[1]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.

Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/lib.mk | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 1c8a1963d03f..99c25dcbdfb0 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -47,9 +47,9 @@ ARCH		?= $(SUBARCH)
 khdr:
 ifndef KSFT_KHDR_INSTALL_DONE
 ifeq (1,$(DEFAULT_INSTALL_HDR_PATH))
-	make --no-builtin-rules ARCH=$(ARCH) -C $(top_srcdir) headers_install
+	$(MAKE) --no-builtin-rules ARCH=$(ARCH) -C $(top_srcdir) headers_install
 else
-	make --no-builtin-rules INSTALL_HDR_PATH=$$OUTPUT/usr \
+	$(MAKE) --no-builtin-rules INSTALL_HDR_PATH=$$OUTPUT/usr \
 		ARCH=$(ARCH) -C $(top_srcdir) headers_install
 endif
 endif
-- 
1.8.3.1

