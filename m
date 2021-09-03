Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122DC40081C
	for <lists+kvm@lfdr.de>; Sat,  4 Sep 2021 01:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350475AbhICXNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 19:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343523AbhICXNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 19:13:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F56C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 16:12:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j9-20020a2581490000b02905897d81c63fso862658ybm.8
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 16:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QkiTTQtXnyEZcRUySewtR+57JtdQhQ0KOdghgRxRcZE=;
        b=IooNTu6FZ9xkgjL3G/epbvjkhF5WJ6iWpr8+VQO6+GaTOokXSzKdEA+bTx1NfAnxY2
         aZlLN+0/c0EBv+91Nu4yVYvuE8Ew2QaKtBC/1lJS6EI007DAbO1McK+JknwcStWLcR+A
         gvG+F3GHevvAgWOzEy/3Y8y3zXPVnVD5qV+oo81ngQGWAmYpw0xRHqT/1uPUkTiNiYM2
         Q+om+Cc2TCagOxgA0MTtJTH5FvDiZY6KN75q5usywBKd8jf1ZlGf9NUn3I0KTkOO5+Wb
         2IXwAp39QdWj9+DhwH+j2KNDwz5DIX77nD+g5mqvkOB0S/nuwIPh5lOBEjWNCNYXfuZJ
         r8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QkiTTQtXnyEZcRUySewtR+57JtdQhQ0KOdghgRxRcZE=;
        b=n9DfMm7HgQQ1O6v+qKtRHMMmBrVHbXaQsl3Uj9z/aPV/xoDp7FHAx/Uixt0xDQaMet
         +MGkH83KqoyxdOM1xo1LbHzx+Sq9Q0r6i5dsW5NYlXbypW+PLhcIR/Pilq7rnEwLp0D4
         4JRAlOiqqotPBYkGouY6DqAhR4wxsZdk0IpvykRDcXLgG4z3ilmRZ1JXOiEHbbmcWfuR
         6/+XlIgF0us4wcYAPYILLOMUcdSiXUoWGSI4QDQMjKRGJJXZ8weRnrViXL93FF69BhkM
         iIcQUI6fVTLZ0gT9QiZIp/caVlMp+2LV9y098FovNNxVqfYFIuT83DshF+hCwljNL1fv
         MScg==
X-Gm-Message-State: AOAM530UycFX6xhb5wuG1oR4fmZxKsRBpp/AQmr7XxF0THjs+2cDRWsT
        xUSS+qd1KsH5FPn0zbkLvUkqi5aAFM0akvE+A23zGkjI32/4Y1KKJCCBHEfjblv3ZNhyAdQTAp7
        cwcFqfGKjGv4gZOt27A9cZquGv4n6DjEvOUb5cUFOlVREqYM7M5QPisk2XmtnXDE=
X-Google-Smtp-Source: ABdhPJyN0dnwoh0+vwNtcBqHpCB38Wsjeqw1QVO8CQwV3gZ9X4JKa4ur2iCwNOdlMkWLD5xvCRjNKIsgX8/JCA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:1bc5:: with SMTP id
 b188mr1813293ybb.267.1630710739159; Fri, 03 Sep 2021 16:12:19 -0700 (PDT)
Date:   Fri,  3 Sep 2021 16:11:54 -0700
In-Reply-To: <20210903231154.25091-1-ricarkol@google.com>
Message-Id: <20210903231154.25091-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210903231154.25091-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add memslot_perf_test and memslot_modification_stress_test to the list
of aarch64 selftests.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5832f510a16c..e6e88575c40b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -84,6 +84,8 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 
+TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
+TEST_GEN_PROGS_aarch64 += memslot_perf_test
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
-- 
2.33.0.153.gba50c8fa24-goog

