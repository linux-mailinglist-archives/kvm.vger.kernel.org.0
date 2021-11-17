Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596BC4547C1
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbhKQNwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237665AbhKQNww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:52:52 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AD4C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:54 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so2188615wmd.1
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iWNIzZc0H7/CipjDA9PD3wNQwEROV8OE+nsn9cGzxWI=;
        b=PH3KtLt633NlKb1hJ7Vmx5FiJ0Lw9smprKIV2+g1qTX6yULCQ3xiOrhwQVg7DuebfJ
         IMYVomb/JLfVgWmh2vOwaHMjiF4jPdqMbStRTDNMA9zbvqP77iuHdPDzPrPgE/cAikD1
         vQtATT77Nglze3DRkDoFTDT+RA5MkfQNW3shjoslN/yfakcNmng/y0r398Rh26SjMsfp
         M3UQq8qI1zwxmAvtyM7GwXmS6tihHXIokviES6Qhw99KkQhVXnEfBkv8O9kSYrMw81Gy
         9EC5HimNa342UYV3gupflpikem1uX91U+NGbgmFWzbi+jAFjmIiirFuOxZg0xUgvSCbT
         kGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iWNIzZc0H7/CipjDA9PD3wNQwEROV8OE+nsn9cGzxWI=;
        b=5RYoVaBLq0HWAAWmJPuXjRy0gzeNI+j1NBX3mmlA5eTbIRNE06dqONtHqyo5iL+VSx
         F+ZcRmj0Bj5SDMGOIVjMQZvhFa+jChLhTjX8jOyruX8Sfw+MDP9xCcxsxa81mbvR/28Y
         G1XL01qA3JwPvFRjzyBkAcaL88msGYsVw8VACIjvUyP8s6XtiTsKYbvmnbDqt5HXJnso
         d4E9VffhCYphX/Irwxe9reWbUc0Fvn4r0oqJZxznr/GtGeMIZv6ZfKuKCpua0ADuEfef
         V3B8WVbo0uIYwioBzWDjAoeiWjHPIroxK3pfZHrVA9xmuX2n36nYOk/4zHQL5GxaSev2
         XCQA==
X-Gm-Message-State: AOAM530NhSgKV7FUeT8j907/RI2LbtL7lCEeJLG6b9gEzjE7VAJerzOA
        dlf7aWr2hE6v1hrvlG1DkiuuCmAWlrpDmQ==
X-Google-Smtp-Source: ABdhPJwOnL/jjPRSRPQ2liZeG/C81OtKx8GAuWWGLfww0dnng2VwaHiBlfYZahQ9FFR2uFjhvdnUJw==
X-Received: by 2002:a05:600c:2205:: with SMTP id z5mr17964471wml.40.1637156992520;
        Wed, 17 Nov 2021 05:49:52 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:49:52 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 02/12] x86: Move svm.h to lib/x86/
Date:   Wed, 17 Nov 2021 14:47:42 +0100
Message-Id: <20211117134752.32662-3-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

to share common definitions across testcases and lib/.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 {x86 => lib/x86}/svm.h | 0
 x86/svm.c              | 2 +-
 x86/svm_tests.c        | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {x86 => lib/x86}/svm.h (100%)

diff --git a/x86/svm.h b/lib/x86/svm.h
similarity index 100%
rename from x86/svm.h
rename to lib/x86/svm.h
diff --git a/x86/svm.c b/x86/svm.c
index 3f94b2a..7cfef9e 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -2,7 +2,7 @@
  * Framework for testing nested virtualization
  */
 
-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8ad6122..5cc4642 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1,4 +1,4 @@
-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
-- 
2.32.0

