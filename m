Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A203B5FC993
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJLQ5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLQ5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:57:35 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF968DED0F
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:57:33 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n9-20020a170902d2c900b001782ad97c7aso12080338plc.8
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EFnDYMnLq9oUrThu2ARtqDZqn0BB2GiFtCF7heUuwd0=;
        b=tT5bcW6oedqQQMaU7QwvcG73kCR+PUf/sfLR4DQQWGm0WMG/q8Z+YAYOJLD5+u8ZMf
         JCQYmVPOab1xIms3LzftF0R2T6RFQTFLerSjXEEDWyUDxCcLZaGy9WhzJZeOsaSmamuQ
         RxzMkyRRGfu4ccVPwFYnTCzTH5DEmaZjiJJ1Ymanu9neUbMegDWeqO59/42geB57Gd4u
         AEXzFqCg/JmkKH24dWF4raF766arAugjeqVCrprfdb0lbkbKhi9bnyPPJOYJmNFQq/La
         eBrMGYYWDtMER5TNJ0EnIGyhQdr51qs0zaxI5ZzIz6lQAXD7F86MYOKE3RjzP7x4ZYeJ
         a3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EFnDYMnLq9oUrThu2ARtqDZqn0BB2GiFtCF7heUuwd0=;
        b=3R6vWWh+Fyw2dpOFkknrX60B4246T+EFPa3GBf6QmCNUM3hQ3oz5XzojY+4dmIkC+4
         QCBECsBJTuXPi2Ctvu4RpoSokDUJCUoabUF8U3XAVEtyEUW6qh6NaG0pwmeHFP7vYN3M
         c5VC8vErXPskh9BAEkBTvLcZf5GjUnNUnDUt/MOZHvgQwA3c8H7MFuCDhiUvTlGWXgbT
         PI+bQwBVcyWlGf8yrq+zXmieOYOdpPpsIYszaYnzRSMQp9wCnrk9+AyRo5aVXwerrQrI
         LVSbTavWKgo0tQuyFQ67zinam6Bw4e3+VtgYjJX0qVgtx9ebFyYp/sStdqpFdKOaMYWB
         DNcQ==
X-Gm-Message-State: ACrzQf1BmCiWgadju6reaQkFGaj+pecFlisiD08cfzCL1XDKf7tqBjKH
        vUo37A6OZl2TsBnifIm05ZK4WJkLxQmi6g==
X-Google-Smtp-Source: AMsMyM5Qei0t2L7PqaaUiVb22Q7nLrJUTdvji8cSo4IABHAg8W52iYe+ELeIiEKwf9BfXhI1+QsEkAWSPBtklw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a63:8549:0:b0:461:3995:60d1 with SMTP id
 u70-20020a638549000000b00461399560d1mr17297373pgd.105.1665593853506; Wed, 12
 Oct 2022 09:57:33 -0700 (PDT)
Date:   Wed, 12 Oct 2022 09:57:26 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012165729.3505266-1-dmatlack@google.com>
Subject: [PATCH v2 0/3] KVM: selftests: Rename perf_test_util to memstress
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

v2:
 - Add precursor patch to rename pta to args [Sean]

v1: https://lore.kernel.org/kvm/20220919232300.1562683-1-dmatlack@google.com/
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


David Matlack (3):
  KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
  KVM: selftests: Rename pta (short for perf_test_args) to args
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
 rename tools/testing/selftests/kvm/lib/{perf_test_util.c => memstress.c} (69%)
 rename tools/testing/selftests/kvm/lib/x86_64/{perf_test_util.c => memstress.c} (68%)


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.38.0.rc1.362.ged0d419d3c-goog

