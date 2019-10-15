Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61A9D8140
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 22:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389266AbfJOUpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 16:45:12 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:41727 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfJOUpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 16:45:11 -0400
Received: by mail-yw1-f74.google.com with SMTP id y70so17070682ywd.8
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 13:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BaoYZBJuvyQJEKwW7QcwZniyRVyyFXFGu3N+2oefdI4=;
        b=aPdtL5U6tR3YXhZ6VuXKWfkJVMFZlZeMUmh5DgRY2b+YJyPVXfvOteZIGTM6nB8kWX
         XA4wlS+XUuEIiE2WS+xzJd7G2L4o1uf4nPrjG5H9iedKie7abG5Nc+fX+78F1joRvKHB
         tXiDrgzpIkhyYq678d61L4F+OULqgwA5mO5F9SXiGPRsewP12aG39djFonA+7O7H89kh
         y9+M9DWHnMe/q4Rm7dvXrk16RR+bfzi3BaC1q+QPqa7amsJf6Vq8WnXUZqPDLuZ17XKt
         WRte/g4zzq8vJvF5k32fQAZTE+ywegtU2HtHmgwZsz2ER83nWBOQX5C2JNy+1VqM0FCe
         mbLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BaoYZBJuvyQJEKwW7QcwZniyRVyyFXFGu3N+2oefdI4=;
        b=D3Pv+devYClxI2nm1ESmovMtuBfSsZcI+4tTak/L7C9pLpuERAoZuX2SrYu4PMV1FW
         ch7bgeW0wYtmNqnwCCescexY6mSNkHSht2qmdu60fO5EM49RTtDSMdTNg+VteT++zrLB
         QIFJELW51qAUZIjsIIVzFz+mP4dMlgLVwax0UjA/CDR3WSeH/gNrk3LTGUy4YgVHBM4P
         EDX65cbW1xCoR1b5D0DcV9V7LvVCpE/ZJctlBgZx5jnGozLcNo0irrMrhjEZVQjfXlXQ
         AOPaL/Dlq1jrUgOoopGoY6W0RqhCLPAG7yeY3NWl3TkAwdmlGU0LOP9SxdF3OE+CDRkK
         BlUQ==
X-Gm-Message-State: APjAAAV3K9VxGBzRSJvEyxChsyuDF9DQvCiUXvgjMtOFVZ2gTaXRwOT4
        97+xjWO4YAIUbNxBy9/OevUYY1d8NuS9iI6I+bteo7idXTM5AIFLlFd4lQsIYANBUMgK9BzACfk
        FRYYXn4t2VB4bXkMs12N/WJ22WDEnMwL0a6jPZSYEdDDjaAPr2IM5HA==
X-Google-Smtp-Source: APXvYqym9f/1xr4NKCIpVb79zh2UVPHacIf9saOCXW4q3yUNcnD/88A8nYN4HMLE1ytrmz27KdOKP9eSkA==
X-Received: by 2002:a25:790a:: with SMTP id u10mr25895639ybc.273.1571172310555;
 Tue, 15 Oct 2019 13:45:10 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:45:04 -0700
Message-Id: <20191015204506.46872-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests v2 PATCH 0/2] Clang compilation fixes
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        thuth@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The attached patches have fixes for clang compilation and some failures
seen from the previous "report()" fix.

The first, changing the "report()" function to accept an "enum status"
instead of "unsigned pass" is under discussion, with others making
alternative suggestions. I add the patch here for completeness, but you
may want to wait until the discussion has settled.

The second, using "less than" to compare two global objects' addresses
for inequality, should be less controversial. 

This replaces the previous two patches I sent. I apologize for the
spammage.

    [kvm-unit-tests PATCH 1/2] Use a status enum for reporting pass/fail
    [kvm-unit-tests PATCH 2/2] x86: use pointer for end of exception table

Bill Wendling (2):
  lib: use a status enum for reporting pass/fail
  x86: don't compare two global objects' addrs for inequality

 lib/libcflat.h | 13 +++++++++++--
 lib/report.c   | 24 ++++++++++++------------
 lib/x86/desc.c |  2 +-
 3 files changed, 24 insertions(+), 15 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

