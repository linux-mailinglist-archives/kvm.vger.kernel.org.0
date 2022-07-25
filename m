Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB42E5802C9
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbiGYQfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 12:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbiGYQfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 12:35:43 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB7F1147D
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:35:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31f3959ba41so6993667b3.2
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ksBrfdewc8P33kwHHKDSCCyl/DzIxhpSYohpoXierk4=;
        b=ZC1bR9phtbNXEPryoyk1EkQ3bf9BMsQO/E+fcO1TftMoR8B9g+cZFlznv24JmUu/C0
         2y0no+lbmVHb1kL1iY+mLTD+6eDi5s8t2Qro/wEBaVO9dvTy35UPq8ZQfoXE7y1OiyMz
         ElkbIl+D9Gdi9ReweT1OfnYE2BM68YmsukmjxX5sBLktmJI1UEtjWUsPXD2NA5eZKO/J
         sJyPWT3/77dViRM3fm3av+ixpyBw1UHxEhJYozpl8wLF2tb3WiQ6gC3v4KqjE0BvONEz
         exf9/ZBw2xwpYuywDwYAArj24YLkpcbBBz3D0wbxJ8MfWTx2aVHib8oYf1GnWRiScMO4
         BSTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ksBrfdewc8P33kwHHKDSCCyl/DzIxhpSYohpoXierk4=;
        b=nIDcTm/ERZhNF91PEwxSFmGQKZuVkOAolVKpk1yXkX5m+JiD3xosNTBVcAPDvDcU3y
         1B/YtfuDdMEpbDWrVDSbK8yPVm7LurdVOCgIZr1VyYYMm2e7w4dmxLVpgWEVuNONc6fS
         v9PglIr0XWGOd8tTcsi3i6vI8IysezKfA+/iH8qs7zsOmGqHd7F8ihEVg9saAzEKN+cx
         AgEDhSk/0MeztSQWDbg3mrgvAyW2Jy80as8dYkwUBKvzomfVle3XB12pV0nplkGYGeQZ
         eVPrl8e+g8rqePq8z6HfgDEhIDIC9po29kXnFQnS2TaOW9vpfS9X4D2SOiqgqAqBruya
         DMRA==
X-Gm-Message-State: AJIora/owkLRyfGltJjJFE/BIkbpPoVHqNfxdGDz4uDWk6tDUBx7M2JO
        sw4ZZ8UicmNRJboLfQsrTXAYQrK40pIJPg==
X-Google-Smtp-Source: AGRyM1sL1gyUN1UQbPSWdnzvDxlCAaonA7uF+FZyLewz7h5gcYIDjw5CZ+u9/w6tNgEX+bi1MQDnhbUysd55Vw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:6e56:0:b0:31e:8e41:7357 with SMTP id
 j83-20020a816e56000000b0031e8e417357mr10634393ywc.434.1658766942228; Mon, 25
 Jul 2022 09:35:42 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:35:37 +0000
Message-Id: <20220725163539.3145690-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH 0/2] KVM: selftests: Rename perf_test_util to memstress
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series renames the perf_test_util to memstress. patch 1 renames the files
perf_test_util.[ch] to memstress.[ch], and patch 2 replaces the perf_test_
prefix on symbols with memstress_.

The reason for this rename, as with any rename, is to improve readability.
perf_test_util is too generic and does not describe at all what the library
does, other than being used for perf tests.

I considered a lot of different names (naming is hard) and eventually settled
on memstress for a few reasons:

 - "memstress" better describes the functionality proveded by this library,
   which is to run a VM that reads/writes to memory from all vCPUs in parallel
   (i.e. stressing VM memory).

 - "memstress" contains the same number of characters as "perf_test", making
   it a drop in replacement in symbols wihout changing line lengths.

 - The lack of underscore between "mem" and "stress" makes it clear "memstress"
   is a noun, avoiding confusion in function names.

Looking to the future, I think "memstress" will remain a good name. Specifically
there are some in-flight improvements that will make this library even more of
a "memory stress tester":

 - A proposed series by yours truly [1] extends memstress/perf_test_util to
   support execute from memory, in addition to reading/writing.

 - Colton Lewis within Google is looking into adding support for more complex
   memory access patterns.

[1] https://lore.kernel.org/kvm/20220401233737.3021889-2-dmatlack@google.com/

David Matlack (2):
  KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
  KVM: selftests: Rename perf_test symbols to memstress

 tools/testing/selftests/kvm/Makefile          |  4 +-
 .../selftests/kvm/access_tracking_perf_test.c | 20 +++----
 .../selftests/kvm/demand_paging_test.c        | 20 +++----
 .../selftests/kvm/dirty_log_perf_test.c       | 22 ++++----
 .../include/{perf_test_util.h => memstress.h} | 34 ++++++------
 .../kvm/lib/{perf_test_util.c => memstress.c} | 54 +++++++++----------
 .../x86_64/{perf_test_util.c => memstress.c}  | 36 ++++++-------
 .../kvm/memslot_modification_stress_test.c    | 16 +++---
 8 files changed, 103 insertions(+), 103 deletions(-)
 rename tools/testing/selftests/kvm/include/{perf_test_util.h => memstress.h} (50%)
 rename tools/testing/selftests/kvm/lib/{perf_test_util.c => memstress.c} (83%)
 rename tools/testing/selftests/kvm/lib/x86_64/{perf_test_util.c => memstress.c} (68%)


base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
prerequisite-patch-id: 8c230105c8a2f1245dedb5b386327d98865d0bb2
prerequisite-patch-id: 9b4329037e2e880db19f3221e47d956b78acadc8
-- 
2.37.1.359.gd136c6c3e2-goog

