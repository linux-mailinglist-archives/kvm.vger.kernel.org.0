Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F740CEDA
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhIOVcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhIOVb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:31:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B3AC061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:30:39 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s9-20020a17090aa10900b001797c5272b4so5075480pjp.7
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=J4eYxZIeQjwgVfStz22W3PI/nvaYP2gIF4yhA0KrQ54=;
        b=ftWB43/19w6hUBaLXiS9O6PtsYSX0IQsCsVtXbhF+5LRxsBizL2YdGw1HcAIZ/QWk+
         3IsYPrJgSPzDFpfLDIp2PdwG2naPODnYn9HPWYUL50O7vx8HlmQYpt1NQB28xSxv8eQ9
         P6IUQk2pP7xLVnuxyEMPdAPjpnK0/xGLTwYxisvdLdmlt+ipOtjF3u/gqkvh7Lugs/gY
         dOU9WS+SjJ93/HFfRpy8+4R3xVY77T1Mrny0GMcyQ8etMFfBekTNY6l0n0xKpRZ0BAfu
         UjH6TVakd/2q1tOK+XMtZ/96wOAft/B7YU+vzu6oG1DwY9iwqhdVJDYER9L2ONdYxyn7
         9uRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=J4eYxZIeQjwgVfStz22W3PI/nvaYP2gIF4yhA0KrQ54=;
        b=UqPM3jjMn2cAGaqfrxX+ZAmxc5rR/ZS7/x7qu4szdM/a4EAd/hymkt83MEVzLScBwR
         UO5snEMpkcnhEdMG7o8bDWhVdSC7LCOnLAOofvkxMjtJY3+wQ4t4p1xaRSSf6rnDssBt
         3YpTCANITkbNxdATpu6CYQWs7A15yRs3L3a+KP+UA1Ob/OeqRcvMUCQWA4pYpVwxTEtQ
         OCZ5x+1TQvX7UZgTAteMEnY4yrm6iQZK9t8fN2O5oBOKJ/04V0DbNfHizrlZ75gy3j2x
         CKZG4HzTBt8emH/g8BOLOp8EPZjXa9avBAngIMTc81nYRyi5s5IYSJnjbqVoDmzTvBuu
         p8Ig==
X-Gm-Message-State: AOAM533OINqdCA7l1JhfUXP51W1tlGCB3toCqHwd+MLC/ADjfoUI80yz
        9o0kn5hdqXFEB5sN5koh0d/htl6WDNDncg==
X-Google-Smtp-Source: ABdhPJxXjgWJjF6uZZXk458HROOMHT1OYABM5hMIOsG8Gg1WMApfVou2NjMsrnYwk5anYSrc85wWTXlUdbd8yQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:bb94:b0:13c:9113:5652 with SMTP
 id m20-20020a170902bb9400b0013c91135652mr1624934pls.70.1631741438850; Wed, 15
 Sep 2021 14:30:38 -0700 (PDT)
Date:   Wed, 15 Sep 2021 21:30:31 +0000
Message-Id: <20210915213034.1613552-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 0/3] KVM: selftests: Small fixes for dirty_log_perf_test
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

David Matlack (3):
  KVM: selftests: Change backing_src flag to -s in demand_paging_test
  KVM: selftests: Refactor help message for -s backing_src
  KVM: selftests: Fix dirty bitmap offset calculation

 .../selftests/kvm/access_tracking_perf_test.c |  6 ++---
 .../selftests/kvm/demand_paging_test.c        | 13 +++++------
 .../selftests/kvm/dirty_log_perf_test.c       | 23 +++++++++++++------
 .../testing/selftests/kvm/include/test_util.h |  5 +++-
 .../selftests/kvm/kvm_page_table_test.c       |  7 ++----
 tools/testing/selftests/kvm/lib/test_util.c   | 17 ++++++++++----
 6 files changed, 43 insertions(+), 28 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

