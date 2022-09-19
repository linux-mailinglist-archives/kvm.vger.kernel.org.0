Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7425BD831
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 01:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiISXXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 19:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiISXXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 19:23:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8DA6155
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:23:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-345753b152fso5952357b3.7
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=FLmyDD4oLn23IeBML1EOBWu56Vaucw8tPJ4AegUauVw=;
        b=Fdt6pMo+dlM6y1S0KigqICv34zf3i0AP/sA57hkXSLa/NW8kXjGYEa+Yk5Gx1nzaTK
         FRwlucQgoooCEiNHkMUxs58TGEav9CFe7OUXLmCOhFAOpHrnR66WKnQymTOH53dLQSmm
         U+aQCr5Of/p2zEoYD9EQzc01Q4XDNRi+3es5tm/Oeuexl8AMIi+rtiBkWWtB2ssH0Urc
         xxYfCRc8+o9WWgqRUxtPJq8VLo4uMl/reabp3QoBXmkngf4yIHydqJkiSaOANSe3DuEb
         qTU98VDeqgOjDdf4rbzqH3lZ8m2Ey/u3Klmihpu34tMJqskHHL2ynGLTsytWrREp4v8J
         MlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=FLmyDD4oLn23IeBML1EOBWu56Vaucw8tPJ4AegUauVw=;
        b=yXSgTZbDIyS0jplgWhPpBoxOub26mT62eUnD5ce+H6ZPmAn9XDOgKL4ZhsWLP1s8CA
         5OAFII+6XRQH6L/YrXeN9R9V32/1WyUl41++tJllKr+os9gjOOuDt+R/5MKRsnM3ipP8
         mPnfadPMmzyhf2a8ugdqS5XcXU5dxtZWI4IjN6zhfWAiN5ORz+LP+kOugo6Z8IhuS5c0
         LPkxiz+wycFGwBFkL0O2ZassGG8vAtmxbHhyWwZxy8nnw0W2ztwIywVVdK0+dLUE1YX+
         ZDEjOQH4IPqoHAH3YMMjHF2ztdH/oOhR8vn8LsjfdE64I/vJ8/Y4HQ3boB8v2gD61M2w
         zREw==
X-Gm-Message-State: ACrzQf3VzpPXGXwaKbCNFO+sEnMrrOFB7VYV/7bQwk4O/esaGo4BHuPz
        CfHNa1lx6t0/R9GK7T9IFYCC763a9W3Nlw==
X-Google-Smtp-Source: AMsMyM6fFAtYkW3QcKJpNysYJtX59WGpn/oRJWDvUhMkpVdNFle1tmcbagzVqY6I/cz3/MxZh7M6tO+jfxGjOw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:8d0c:0:b0:6af:d486:dd61 with SMTP id
 n12-20020a258d0c000000b006afd486dd61mr16829249ybl.402.1663629784387; Mon, 19
 Sep 2022 16:23:04 -0700 (PDT)
Date:   Mon, 19 Sep 2022 16:22:58 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220919232300.1562683-1-dmatlack@google.com>
Subject: [PATCH 0/2] KVM: selftests: Rename perf_test_util to memstress
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>
Cc: Ricardo Koller <ricarkol@google.com>
Acked-by: Andrew Jones <andrew.jones@linux.dev>

v1:
 - Rebased on top of kvm/queue
 - Drop RFC tag.
 - Add Andrew's Acked-by.

RFC: https://lore.kernel.org/kvm/20220725163539.3145690-1-dmatlack@google.com/

David Matlack (2):
  KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
  KVM: selftests: Rename perf_test_util symbols to memstress

 tools/testing/selftests/kvm/Makefile          |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c |  20 ++--
 .../selftests/kvm/demand_paging_test.c        |  20 ++--
 .../selftests/kvm/dirty_log_perf_test.c       |  22 ++--
 .../include/{perf_test_util.h => memstress.h} |  34 +++---
 .../kvm/lib/{perf_test_util.c => memstress.c} | 102 +++++++++---------
 .../x86_64/{perf_test_util.c => memstress.c}  |  36 +++----
 .../kvm/memslot_modification_stress_test.c    |  16 +--
 8 files changed, 127 insertions(+), 127 deletions(-)
 rename tools/testing/selftests/kvm/include/{perf_test_util.h => memstress.h} (50%)
 rename tools/testing/selftests/kvm/lib/{perf_test_util.c => memstress.c} (70%)
 rename tools/testing/selftests/kvm/lib/x86_64/{perf_test_util.c => memstress.c} (68%)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
-- 
2.37.3.968.ga6b4b080e4-goog

