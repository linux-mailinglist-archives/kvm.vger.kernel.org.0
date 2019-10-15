Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D964D814A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 22:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389344AbfJOUqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 16:46:10 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:38315 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfJOUqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 16:46:10 -0400
Received: by mail-pf1-f201.google.com with SMTP id d126so16864429pfd.5
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 13:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BaoYZBJuvyQJEKwW7QcwZniyRVyyFXFGu3N+2oefdI4=;
        b=akpXFrQtQRw+JDbGYWn5Xm7OAKb1UeuOypfwTXgSW/txPdvmr3OQUp1SmorUYVs28t
         lYA5v4ztyZO+m6+NC+rG+81T3ZVG/74uxOZmieYOQPQPLPA7SbW3xpVwdVCP56Xy0Cc5
         PVpiPBKsn02WBtxUd9MuSiFvuBgfEAwHNLKchwvV7efibNSIfYkk5XmDSSVrqcwgzycm
         PxF4I7hNzzJUX0VMJA9BjVTIFw3e5mdjoeM+iUzB9Wgj7gQw2n2QrWOomLnO7h8ruOE5
         blALaHFJy79553/WKa4QFBpZdEWUVMz4ds03YtJm575LDZHsU8XlQP352spF1gvdfD6J
         uUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BaoYZBJuvyQJEKwW7QcwZniyRVyyFXFGu3N+2oefdI4=;
        b=ryXH5jgI/bJZx9nxQK/U0tZdZal4ZoYac5wrbdNiK5HDq52qa/kKUYLw2cnO7cHBpj
         in/ZjIxLwLZ9w0sLEF8AJY/WWuDrAqwSUQYaC1Ba+auyVAx8utAQhLVzX1QihDgXgPJZ
         DUBdlgc1MPDIELbrvcGM1hgAyo4vBT1xZ3+ooTaU6icXjlFfXrCVY5VrTo4VeMozRGbk
         H6OoiwrmEwoSoSEZwnW5is5Ztm/XINmLkYTcd3GKZnDGvgTwo/9fRXAsC8Y5XdQABhwL
         dvDmDuXN0FhvOorS5zDpYyGm9bl6ZFZL8B4REVD2+9wy+dG7erMwfDqQtO4QB7tlejA1
         Juow==
X-Gm-Message-State: APjAAAUVAeTPN5TrH7tyFuvkByrvBsx/1hh9ZT6ldOd/5oPnZVegZM3d
        BcHg+7y13fLXch0LqnlL2oldT6HGLldWQL9wtU4hDEMiKJmYEcps0seV85f4lKImdOkJbdEtO0P
        KfdKx5L36ifrsmggfyFvh83JRifp5Q3ORE19afXBmfSl/VYdazzKiZw==
X-Google-Smtp-Source: APXvYqyCyp05ENFcLxZqTw6xD3js0aOsy4EwKYGsEtW9RV2RiXrSJ7wjw0uTADZRQmu7OJFq1PhuwNykjg==
X-Received: by 2002:a63:78cc:: with SMTP id t195mr12814139pgc.304.1571172369083;
 Tue, 15 Oct 2019 13:46:09 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:46:01 -0700
In-Reply-To: <20191012074454.208377-1-morbo@google.com>
Message-Id: <20191015204603.47845-1-morbo@google.com>
Mime-Version: 1.0
References: <20191012074454.208377-1-morbo@google.com>
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

