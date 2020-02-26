Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BCD16FB28
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgBZJpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:45:01 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:40356 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbgBZJpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:45:01 -0500
Received: by mail-pl1-f201.google.com with SMTP id y2so1599180plt.7
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cP9wqX9zD2QYAnoO8iF4RES2Unhc0okGozzqNVM7XW8=;
        b=EP8ktxywocUVJ4ej5D4iYSH9iUPGY4PibcySxzKGTh5bA/uY0HgOpHEd6iwccjhvrg
         WnzJQlcoSlfx4WqObOsofopXyHh7NCC1hD+F305EVCz0LsQEm1qSSk1ZovqBHqTKLy0D
         Ip8XV9fi2fOEpvmdICVcAQpLv33TivtZ/g39lZ4vq+qM6Qoy/tdsK+HW7GYpxY+jCQFR
         NrP20qLjgWWWi5/kpS6nK+tZjXTW0c5U35ueX1ovQSSef3yj885DWk9Aa6hqC/Iqd1pt
         NrYbA+01NucgrxVAfBRHATipEqQNlfw8qrwEX4vuYKyuh0y/r1SL5qPOCB4gOiNtTWhC
         F6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cP9wqX9zD2QYAnoO8iF4RES2Unhc0okGozzqNVM7XW8=;
        b=LeAv23AFtP53qpxtO56kRkbER7UJhp8Qf4m+I/ZBfwv28WNMTnQoDDNtj+h4qFVKB6
         oLn2KX8hSPAbkcjPaqM7wdWlaTgoAFIcqSWGbAA3O2kvkG0zplytjLjp32SFPbW7JMku
         vkhvR1cT/vxqGrPEOYIIQL26H6W7Z0sDDmkRwYrEW7uQCv9r8gJ/j46nOaCTk/GKEn2Q
         SGPo09u960981SIILBah7RyciBqQm4AGzfyHaTzz61cu+FbqaM6ZUw0rnmSwuwgRmrTL
         A914HwmdRdIqG6CxT1JYFcUP72Gp5TBnj6WLt4sjZxPBnmu7P5FOq4wNc6rE8ITQSMBY
         pUNw==
X-Gm-Message-State: APjAAAVELLszVbjHrzA8bTkm8/lx1H+G0igk0RweXecS8i5uLUQKSSU+
        dSC4Giy/Et/X2i3GELLhg/uvNvHEnhbOePXCfwv6AbDpouzjsFGALirppQG733sFdJfye/o9Gsh
        jRS2T/0qbxC5ffP+XDF+pMH+RPh2pBNInXmkcbizpSUSMvoxC+k+6kg==
X-Google-Smtp-Source: APXvYqyTJQYmcRl3J9RT+hOz8gZ6UkhpgnMwSgBGIwnIvLs6/1t+gbJ5JvCgoEExBYNSKM0vkrjN2Vb5NQ==
X-Received: by 2002:a63:7e52:: with SMTP id o18mr3091857pgn.46.1582710299978;
 Wed, 26 Feb 2020 01:44:59 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:28 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-10-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 5/7] svm: convert neg shift to unsigned shift
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
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
2.25.0.265.gbab2e86ba0-goog

