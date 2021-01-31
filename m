Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8F6309C56
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 14:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhAaNbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 08:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhAaLwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:52:21 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D444C06178C
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:38 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id f16so10240486wmq.5
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VqrmhVxmrVpTinVk4e74EOokFJxAnJGleMWOvxObkGo=;
        b=lyvsp3J4UkNurQZJVFz9o4JYa1UA1x5dEPXNh3rSqZoz/D+ftmCq5kSipCIzpP4yYJ
         nSMUwmKcyyFsbqMKa8oxpCNGlXb93gGlqm4bjingFBgZuIWD7AbI0OZpdaMufJDvHG9c
         qC5+dIBepWCX6LFsUMA77xsp6mvys75KRB+jURkPOHD/pN99OOtyoQ9btbVCGzoyfl6G
         MxbJzJi5FBOYnndo2ohyVKrRVbQ75AEh0rEWOFzVWJCmjvCGgSofwmaqh36oRozeOnfA
         jlgBJb1qNwvqao+3AOuUECbxkneAizqC36qIYrHOlMkRF5uKw5qN2ZdR2YCXPAzeFzfO
         Mz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=VqrmhVxmrVpTinVk4e74EOokFJxAnJGleMWOvxObkGo=;
        b=NMpnBKNpT3akhExhbmsyWRuJHfek+l++79VA/bWvWI5aB9Dx3d/jJ5jYmIb7TsTc7r
         oA2y7plb8YB2wtuJRizs3P09jFAy7TNlhzuKblGyBGbXNZELU9GwbFaPpTVuugAbWtK0
         cHOXH+mFbxcVIejBmvvg6ZOJ0Zwatnq6DCvio/8QpVB+8h1peUX8Sewg4pMUgVmshjoS
         HYYFVhM+POMd9BJ5fXRpygh9qNaYJrXjJ1teIl6gqjUotyEKsy3bnHfP8SlSn87twdoP
         p3Z5AtpKxfAkr91LikGGgVIvPT2M2EGDjVOhXG4h7zEH/HqnTdvi7SGLhKiIocdgjiLz
         OeTQ==
X-Gm-Message-State: AOAM531i2Bk2eJ8Ye65YVyiO/UOa7UOoXkqB5zMpjgGV00bLUJ1H/ftA
        +SRPf/GQs34o3femALNnbrayECOCP58=
X-Google-Smtp-Source: ABdhPJzlUZ0PoftyMhnvPgCuDfPl7bBhNXVdBlytKA4JLNnnwx1y1kPvC5kny0EUlqDJX52wkKjIyA==
X-Received: by 2002:a7b:c196:: with SMTP id y22mr10912502wmi.91.1612093836938;
        Sun, 31 Jan 2021 03:50:36 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id a17sm19517259wrx.63.2021.01.31.03.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:50:36 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 02/11] exec: Restrict TCG specific headers
Date:   Sun, 31 Jan 2021 12:50:13 +0100
Message-Id: <20210131115022.242570-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes when building with --disable-tcg on ARM:

  In file included from target/arm/helper.c:16:
  include/exec/helper-proto.h:42:10: fatal error: tcg-runtime.h: No such file or directory
     42 | #include "tcg-runtime.h"
        |          ^~~~~~~~~~~~~~~

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 include/exec/helper-proto.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/exec/helper-proto.h b/include/exec/helper-proto.h
index 659f9298e8f..740bff3bb4d 100644
--- a/include/exec/helper-proto.h
+++ b/include/exec/helper-proto.h
@@ -39,8 +39,10 @@ dh_ctype(ret) HELPER(name) (dh_ctype(t1), dh_ctype(t2), dh_ctype(t3), \
 
 #include "helper.h"
 #include "trace/generated-helpers.h"
+#ifdef CONFIG_TCG
 #include "tcg-runtime.h"
 #include "plugin-helpers.h"
+#endif /* CONFIG_TCG */
 
 #undef IN_HELPER_PROTO
 
-- 
2.26.2

