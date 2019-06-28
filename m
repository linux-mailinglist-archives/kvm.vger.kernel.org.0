Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498E65A8CE
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 05:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfF2DxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 23:53:13 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38093 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfF2DxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 23:53:12 -0400
Received: by mail-pf1-f181.google.com with SMTP id y15so3928140pfn.5
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 20:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+9qYG8HpSyGgSBE+SHs7lVfiRzAcIP8cCs8Yp2gW3/M=;
        b=geBE2xNDJAdwhS0VoWpLBSNOSXluklWjtrIUHER3GhIk/GfmVUB/JES+Xn1KOBNTCb
         W3mYe7Xrrr9Ue7qYp/s31Z+qKYewJd9ZLx9/p2cCtJBIHVOdif1jAKj71cVz8+6OUncL
         QhUsodlg6PBx90Nw5CJsiU5mDeayV19ybEyX3C2k+/pWbd8qLrhXZVbe8roANR02cORT
         VROcT+gNoJbfYGe9uQ4N1YHEIDMzr3BX0T0lkb1AE4kr8BSQM8u7CTK1m+6UKm1sMOWh
         +XvXwcbwXknRwBa5JQkzPm91usGZXGrZD53JaFo6vEcS7opx58sa6ldq9fx6h4m/Xlbp
         wBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+9qYG8HpSyGgSBE+SHs7lVfiRzAcIP8cCs8Yp2gW3/M=;
        b=pjGOXBJo68SNOV3xcetq4x6jyNHd80aYCgmT0yOtEwz97gtze+sVR9/Rvxl2w9RD3X
         WA7/SlL8I+Se1NM1qU2FlzhV8hC8ocBQm+IgeklWUxrRNICKHuXFw9Dz9YSAYEYqphYU
         Gz/EWdzyIS8DX0dZHQZ5uLo1KNrectLL3Rsae4Hb8YzqR7vqsbxtINQmVURMo1T9s3AZ
         z5nSCecNsGm95aAnzTYSE7lGq0PImRBApRQOJgY92XDKi46h3aHSwGmYOwc0fmn86gIZ
         OGV7cbBab5FHsynbCmH4TW396naVo66bPFTSisJzkx1WuGRZyMltfE5UOJhHSZlC6u4c
         3NIA==
X-Gm-Message-State: APjAAAWGzaaKHqIiFNLNIOWTN7O1Lq7iUoZ6CSbms3X9q8RhwO0GRwqp
        ZMGfqivGoAHX4ZChwhZnpWU=
X-Google-Smtp-Source: APXvYqx/n9BIsat5VaTVFg7jRmSFl4XF+3JSbwGnOrPYcsNGT4Nam8wgqUXaV4sQT0dNUARdLKIIZg==
X-Received: by 2002:a63:78ca:: with SMTP id t193mr12374233pgc.10.1561780392006;
        Fri, 28 Jun 2019 20:53:12 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p27sm5597052pfq.136.2019.06.28.20.53.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 20:53:11 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 1/3] libcflat: use stdbool
Date:   Fri, 28 Jun 2019 13:30:17 -0700
Message-Id: <20190628203019.3220-2-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628203019.3220-1-nadav.amit@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid any future build errors, using stdbool instead of defining
bool.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/libcflat.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 7529958..b94d0ac 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -24,6 +24,7 @@
 #include <stddef.h>
 #include <stdint.h>
 #include <string.h>
+#include <stdbool.h>
 
 #define __unused __attribute__((__unused__))
 
@@ -53,10 +54,6 @@ typedef uint64_t	u64;
 typedef int64_t		s64;
 typedef unsigned long	ulong;
 
-typedef _Bool		bool;
-#define false 0
-#define true  1
-
 #if __SIZEOF_LONG__ == 8
 #  define __PRI32_PREFIX
 #  define __PRI64_PREFIX	"l"
-- 
2.17.1

