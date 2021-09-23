Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCC94165D4
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242901AbhIWTR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242823AbhIWTR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:17:56 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725F8C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:24 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id bj32-20020a05620a192000b00433162e24d3so22122632qkb.8
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v6kM0fZgFnMyPqKLqGMM9XheburKn9OIi6ceURW+v10=;
        b=SxvLmQcN/i/qz9DPGEK003POrfs0mMcW82MLGenxyYOgKsjnbvZtZQ6Wpgks5XGJOE
         W5asMYsTjt+s3OgBeqJ2/1yKPGljqkXFAywEZ5hwj1p7R/XU1oh6zk2GtVfHXXFI0FE6
         ZvXmp5RhKJ1e2Lm/7c8z2l1DhzVC9T2fsO7DHaJi3H3c+3TvoGK8wy7SodQzP26Hv5L4
         jmO1VTEJLN9+zfEISbyg9chov7GbnmmMpRX3gpIqPrW8t0UkHQqf73l6CwsXApPsVoO9
         V37FzJS89cVsBUauJ9ca3SeLYfUom+mQRXoI6m9PNVKiDipyUpSU/M+9AEPlHUrPdLTi
         cMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v6kM0fZgFnMyPqKLqGMM9XheburKn9OIi6ceURW+v10=;
        b=IRQWlq1NOy0xnK7Got1VbBIYV6c1ATuLGVwh1kx2GuAnv+6H1U6oryNik4EgP+ugJI
         pJBwqZaVVo8xVriQBi0JTjqFS0OU7H8IwzBBJOnzgznpO8s3q1isEJCphsAEXWj73DKX
         UgLydoVlxhgxwwKizwqgOgXIACRKxcHfI5YqREnUu0crao8OhQ/03F3MYv6vW3WeDOUA
         G41gNZo1JGV9Fy/O+nBo5zutYihrwoLd5AV76/q89s1npAFuDFEFfdc0qTvP9mS8pqus
         zxxGBgQYrUTOj/t9i6SrHdZWVcdHHTK9L9ns4AzPSCjhHwwI4uCNFqF/8WwtXi8l8frX
         bQ6A==
X-Gm-Message-State: AOAM530qLejHYupQiE0zAu5y/gmvK1rrNqxUGW7F9XTDZ1Z5+ci0ZKxg
        A30w5hnG1xwYQLXeNhQsTVrQLalBdfA=
X-Google-Smtp-Source: ABdhPJzkNSt2TQe/+BhleFUDyUx1HG5HAWzMvUvoxORmPFlzErhgqo3pu+ogu/d1eiq9Dtg0dRjls5m0EPU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1271:: with SMTP id
 r17mr5988466qvv.48.1632424583699; Thu, 23 Sep 2021 12:16:23 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:06 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-8-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 07/11] selftests: KVM: Rename psci_cpu_on_test to psci_test
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are other interactions with PSCI worth testing; rename the PSCI
test to make it more generic.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore                          | 2 +-
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c}   | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/testing/selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 98053d3afbda..a11b89be744b 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
-/aarch64/psci_cpu_on_test
+/aarch64/psci_test
 /aarch64/vgic_init
 /s390x/memop
 /s390x/resets
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5d05801ab816..6907ee8f3239 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -86,7 +86,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
rename to tools/testing/selftests/kvm/aarch64/psci_test.c
-- 
2.33.0.685.g46640cef36-goog

