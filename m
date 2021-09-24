Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA8041757D
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343893AbhIXNY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345943AbhIXNYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:49 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0081C08EADE
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:07 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id r5-20020adfb1c5000000b0015cddb7216fso8008371wra.3
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mlMa5h5NI5jeUNwNwY7Kha/NGSkd/By+lOHKgGZzb0o=;
        b=SWEU9RA66/WxWXSbnVeHag8LsLPsWo8oCMibTA60uonOa2NMI7kIs3aQaiEtrgWRHO
         DkA5OZF8LVYzQT/cr+FTPum/wkwXOpSGn6mBFh8390Hiu7bF6dK1T2mmYPopzXIWmMyg
         ByH+xHvE1XIot1qXxE5Yurw1SAV9R/bSIpEHsErE6bNWq+FTIeI0q3cHMP95HMCchKHy
         /07xpwd4F+PMcWHR7BQjwKn6vitYvJfybxPNVHcL9VT68KII8o60yJbc7fP7HXCzKda3
         0SaLPyDqoC4Fh2pYJUv7rcuaRI3FlofdyqHQc/x/5vPvpDmPLw8FioGLue3WQ2c6a5dA
         5IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mlMa5h5NI5jeUNwNwY7Kha/NGSkd/By+lOHKgGZzb0o=;
        b=wOgcC0JNRKoG+HH9K5v6wuPHPY3oK9qVjSIAY+aJNmOoDpodxBc2sV1zwL6KeVISKa
         h7lQUG4oZGm3Lq/xfBwaJho1YKQNXYp0dgb/Mou+hBkR0xcPJ86yY/qMwDMVWtfdqlxX
         Fl279MCxTRIwkLyJNE/pN1RlhT5KP51RNl+pPF7zQIp+S2Pbdit7tR7bcLxJHCBpMROB
         uk3h5c93DCgGkrnqeSo43tvBj2H4qNTRH1Jw2w7IZ5TGIgRl1DU9XMVonHDeobIuzP51
         AiWlsx05mqY2b1i/DyVi9jjISEuE+wtVnDGwRyOW5ik5Sv/iQX/T+84kwRUfHv7JmgJi
         4arg==
X-Gm-Message-State: AOAM532E0QSTRsIb/tDg6P9bR35D7Yhdkxl+DgB36brXppmgnzZLw54B
        U0m+uxXZUReq2QOMiyl97V43CkYAPg==
X-Google-Smtp-Source: ABdhPJx6zVX5jtlMJbOyL+BbcPj3DUM9DjQf7WdSun6TSGOTKmjY7ZrgMDMtNn5ZOQ8+TC/ja/ahR0SWWQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:598f:: with SMTP id n15mr11204398wri.74.1632488046306;
 Fri, 24 Sep 2021 05:54:06 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:31 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-3-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 02/30] [DONOTMERGE] Temporarily disable unused variable warning
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Later patches add variables and functions that won't be used
immediately.  Disable the warnings until the variables are used.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index ed669b2d705d..0278bd28bd97 100644
--- a/Makefile
+++ b/Makefile
@@ -504,7 +504,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
 		   -Werror=implicit-function-declaration -Werror=implicit-int \
 		   -Werror=return-type -Wno-format-security \
-		   -std=gnu89
+		   -std=gnu89 -Wno-unused-variable -Wno-unused-function
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
-- 
2.33.0.685.g46640cef36-goog

