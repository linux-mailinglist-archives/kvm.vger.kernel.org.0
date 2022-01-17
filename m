Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F314911A6
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 23:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243597AbiAQWMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 17:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243593AbiAQWMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 17:12:38 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2429FC06173E
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:38 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id br17so63005852lfb.6
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HExtPNOOGsZ27tIV7KyWHUbKgy1omlMDtnwSMdGi6kM=;
        b=B4aNyAvE0Tpz9J83UsSV5Oh+um5riktgd+wbEx7xqAreQxbL+3WlNyqDYq9cO4FBQ2
         zp+ysrm6AQ6jZaBz7mIq+Z1ZYCP+XwEe53uhQks/W4Qd94WXxN4TBdxIC3u0jZbYfPM2
         PsdPuLnyna9aevG2/g9MHuR8nK1J+9OH01+N0AIXlMEOMuVo7AExvJs8OVsyFZ0AU0k0
         CmNcO9q7nOzEgtYg2qgirHJ8ade0mBScp3TCiuPu3MUQZw7lhMBO7FMxbqdfI6zoLHnp
         ga9rBRqd0AdnKGUrp1Xts1pumSQ5Jga3raaQoPDozgqzIrk3Xz2zqgCbHL95TnQAC+XC
         16xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HExtPNOOGsZ27tIV7KyWHUbKgy1omlMDtnwSMdGi6kM=;
        b=V6bt0R2FsB9Xktz9u1AC+lphcMRqCqDqYBjSGYZFYzauudjA9M2yTWlCSSzMySopz/
         rfseE1Fq62jOxSZ1/9s3eVrBO33oB+oxWsdO/lax+xurhHqoCrl/7oetGY1f7y4E8eY8
         gu6v8sv/cKKs/d7vbBoAKeOCkRjk/sx2vo002hwl3H70LJgFZVjaHk3kyZg+zHKINDig
         bedXO9PTiAzVrpPFs153JeIF+qHMyc0qxTkPQuyO3uNwjqLz8b2/gvt5CcF/AZD2n2C3
         zVQZyRwdWIWPfBZubAPsVH2TK6CwnkRirT3uBnmdoXK0JwgYY9oWyie7GJm7an+MGu9f
         RERQ==
X-Gm-Message-State: AOAM531xtB/niYSP6vErj19KqrH7z0qA1AO+4R77ydy6i5vOOiM1NFWS
        IIHby930SToLN1UuB35fnGg8et5uw6Nlyw==
X-Google-Smtp-Source: ABdhPJyxu7XXNjhGpuNTwPVpvB2xd4mJ2wmce47hEFtr4Gq+7srnEc4CJ+7zzV+JrlIadjHDi7WS8w==
X-Received: by 2002:a05:6512:224a:: with SMTP id i10mr15162597lfu.318.1642457556437;
        Mon, 17 Jan 2022 14:12:36 -0800 (PST)
Received: from localhost.localdomain (88-115-234-133.elisa-laajakaista.fi. [88.115.234.133])
        by smtp.gmail.com with ESMTPSA id c32sm1458094ljr.107.2022.01.17.14.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 14:12:36 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 4/5] Makefile: Mark stack as not executable
Date:   Tue, 18 Jan 2022 00:12:02 +0200
Message-Id: <e90b5826343e0e5858db015df44e4eaa332bd938.1642457047.git.martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1642457047.git.martin.b.radev@gmail.com>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch modifies CFLAGS to mark the stack explicitly
as not executable.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index f251147..09ef282 100644
--- a/Makefile
+++ b/Makefile
@@ -380,8 +380,11 @@ DEFINES	+= -D_GNU_SOURCE
 DEFINES	+= -DKVMTOOLS_VERSION='"$(KVMTOOLS_VERSION)"'
 DEFINES	+= -DBUILD_ARCH='"$(ARCH)"'
 
+# The stack doesn't need to be executable
+SECURITY_HARDENINGS := -z noexecstack
+
 KVM_INCLUDE := include
-CFLAGS	+= $(CPPFLAGS) $(DEFINES) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
+CFLAGS	+= $(CPPFLAGS) $(DEFINES) $(SECURITY_HARDENINGS) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
 
 WARNINGS += -Wall
 WARNINGS += -Wformat=2
@@ -582,4 +585,4 @@ ifneq ($(MAKECMDGOALS),clean)
 
 KVMTOOLS-VERSION-FILE:
 	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
-endif
\ No newline at end of file
+endif
-- 
2.25.1

