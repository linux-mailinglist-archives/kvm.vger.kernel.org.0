Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E00D40FEB1
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 19:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbhIQRiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 13:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbhIQRiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 13:38:22 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE50C061574
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 10:37:00 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 21-20020a370815000000b003d5a81a4d12so69555005qki.3
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 10:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=j3hYscMbXUl4Blxte5huLmi9fE1/+32DfcMIllD4jkk=;
        b=OJN+r2xSncvTtnDY7D1o8fb7GCsFa7p+mMPRtRymF/JdogiC8RlUMKUSPI63y5o/K1
         gME6uNvi5jDTxwYtbwId4Mq2szkOJl6TjIwhr1zNcmZzUX7YMSElrU6G8g8P1aimYn1M
         EEVmyepq9RcopReUJzq3YfsAd7TY19qZnyfwHrNfB25vU8thvzl0IgmFfW+zGVG7HOI1
         s1GCoMT8So3mDkwF2FSax3gmrEQEzlz5NMkPLNlwEP21Wc2vOWPDsDy2QDZGaWT0ClXk
         vTb6uEzPENbRR0rtc6llBWh47pCYtpn/M2p9khvoictU1Ly7IeU9fceQ54Ig/Da/dhj0
         aibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=j3hYscMbXUl4Blxte5huLmi9fE1/+32DfcMIllD4jkk=;
        b=rJI0/l2dER27XV1v5RtPLkmSt37bNw+LO2GeRD/1ihCriRzjXqSASKCiPnQlK5kXXz
         uaC2YU8u91oP0c1WWGF/lquJAQLhZlu6TjIj1GckcFcuIZXO3ilTStLEdUhJBUsqLGyE
         Z2JZ9wCxRKPfzulXvNK28UjWRZgiOosnSBMe4JzHv72wo0adsICo9HYBq91oaDV0nZOd
         /R0w9OR2d3CmA9GEiShGc1HD3fYk7BdA9VT8iKVYSS6Bu0zV+C+hTyVc9wmZ3t5BuK5F
         yOqMRR9slY4VO7yYK0hcwJMXjs1eCkWpbT/5IREMk0mrb0lxj7Rr/UvCrAXhIsGRpMVf
         s9Qg==
X-Gm-Message-State: AOAM530jKRm9eb8xPDLVzM+9leiF7bJ4Jf2BHJBVXYDzEgg2w8lL4/KX
        /kIoAdFJ2Ye7ewC2cd95GOOSVQUxT6PC3Q==
X-Google-Smtp-Source: ABdhPJykwnKgUFCaLS861ZdYxYSIk5LCg6mxDChItfFD2Seq3T7CS2CzEbovyO9jV6tHrrGdzqwlGfPkm77vMQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:c184:: with SMTP id
 r126mr13918623ybf.123.1631900219046; Fri, 17 Sep 2021 10:36:59 -0700 (PDT)
Date:   Fri, 17 Sep 2021 17:36:54 +0000
Message-Id: <20210917173657.44011-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 0/3] KVM: selftests: Small fixes for dirty_log_perf_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes 2 bugs in dirty_log_perf_test:
 - Incorrect interleaving of help messages for -s and -x (patch 2)
 - Buffer overflow when using multiple slots (patch 3)

Both bugs were introduced by commit 609e6202ea5f ("KVM: selftests:
Support multiple slots in dirty_log_perf_test").

Patch 1 is a small tangentially related cleanup to use a consistent
flag for the backing source across all selftests.

v2:
 - Add Ben and Andrew's SOB to patches 1 and 2
 - Delete stray newline in patch 2 [Andrew]
 - Make print_available_backing_src_types static [Andrew]
 - Create a separate dirty bitmap per slot [Andrew, Ben]

v1: https://lore.kernel.org/kvm/20210915213034.1613552-1-dmatlack@google.com/

David Matlack (3):
  KVM: selftests: Change backing_src flag to -s in demand_paging_test
  KVM: selftests: Refactor help message for -s backing_src
  KVM: selftests: Create a separate dirty bitmap per slot

 .../selftests/kvm/access_tracking_perf_test.c |  6 +-
 .../selftests/kvm/demand_paging_test.c        | 13 ++--
 .../selftests/kvm/dirty_log_perf_test.c       | 63 +++++++++++++------
 .../testing/selftests/kvm/include/test_util.h |  4 +-
 .../selftests/kvm/kvm_page_table_test.c       |  7 +--
 tools/testing/selftests/kvm/lib/test_util.c   | 17 +++--
 6 files changed, 69 insertions(+), 41 deletions(-)

-- 
2.33.0.464.g1972c5931b-goog

