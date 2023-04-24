Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5CE6ED83A
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 00:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjDXW7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 18:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjDXW7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 18:59:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227137694
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:58:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b92309d84c1so23967864276.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682377138; x=1684969138;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0/d1X4UeFzhGQT5EhUATI1QVCWoXdG4f8Wft1N876wI=;
        b=2uwUoWszfmF14u1ztX1wX+MkIXwfFAOMLlmfBN3JiQPammP1nwlC1uvlaPzDHoSkee
         Ph7XRzxU0XXfJNb7OU8RaRNz6+5Ch4PPvhD7JxkNEtQh/FgJkj0HaeoG8cMG2AKGh3KO
         /Qu8jyeoL9rmHMqWq9fR3UWd7dm/ofYvXyNQqs94OSz5wpFVL4CRQs/O0w6ZOlL9f7dy
         Z02vEWSd4LpyEHxWWXTDr1T9qX0ya/UACnhotBeqg4wx/VwjkwXCSKJC1BGh9O/OyE43
         SUryMUaEy/VY8yImtmu4OfFCJ7wxLzEhkBdeQFnth/uU+M3+/+uKT/3caTQN7zFdZEuC
         6YVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377138; x=1684969138;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0/d1X4UeFzhGQT5EhUATI1QVCWoXdG4f8Wft1N876wI=;
        b=O8Rw63mv9eFbWk394ZxCjejUXuQqb+piUqJMsctkEpvYoyDDmKzrcG8m1ZfuRbv1j7
         uPCveOX0KgCcCUIVEjCwCuKfliO6wxSUBhFEMFOFFQPFaH8U6t3k9ejF32WWxZaLrh+r
         vBnWq5MJ0AiArKuF5IUS3iUpBUCPQTG6UEakCG71TNmIoCgM8pzV6HPvympUhts1XciD
         3JZV/YKYTKt4dMI2t+awrYH2Z7G7zLnw5qUuEfuvFGxBwcKzUXy6PO2jt/5uX4DgvuDD
         XqvgQABHyXX2Qoh1JNoR1vHhD0HBUGnFjPZ0JLMop4BfJDWJ1wcGnt4wkXyfI8y7O2fj
         CE8A==
X-Gm-Message-State: AAQBX9eWPTiWFbQ6rUQeZvNu5Y2xchIPFPPHtNpuIG3SxH4MrloKH72f
        60B7P+DACSxZecnHcxL5P2iSzUAjwnO4hMPiq+7kLt9gK3+3EQjtsr5+SzFtgLkTipWVxmSemWD
        kbyN3NjCRTs5BuVFlF4Ei69Rf5FV3pM1skQEg3Q623oJbuUIYDORjX4zNgFxv5L4R7JP4
X-Google-Smtp-Source: AKy350Y5RugmHTTgEyEWZ029Zj0orjdBI+0TZtqh/IX4meknUnTYe+v0UcxX6S5I4TJlFP9oKrQbt5xeRrexcsJ0
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a25:408d:0:b0:b8f:5474:2f33 with SMTP
 id n135-20020a25408d000000b00b8f54742f33mr7774603yba.5.1682377138351; Mon, 24
 Apr 2023 15:58:58 -0700 (PDT)
Date:   Mon, 24 Apr 2023 22:58:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424225854.4023978-1-aaronlewis@google.com>
Subject: [PATCH v2 0/6] Add printf and formatted asserts in the guest
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the ucall framework to offer GUEST_PRINTF() and GUEST_ASSERT_FMT()
in selftests.  This will allow for better and easier guest debugging.

v1 -> v2:
 - Added a proper selftest [Sean]
 - Added support for snprintf [Shaoqin]
 - Added ucall_nr_pages_required() [Sean]
 - Added ucall_fmt2() for GUEST_ASSERT_FMT()
 - Dropped the original version of printf.c [Sean]
 - Dropped patches 1-2 and 8 [Sean]

Aaron Lewis (6):
  KVM: selftests: Add strnlen() to the string overrides
  KVM: selftests: Add kvm_snprintf() to KVM selftests
  KVM: selftests: Add additional pages to the guest to accommodate ucall
  KVM: selftests: Add string formatting options to ucall
  KVM: selftests: Add ucall_fmt2()
  KVM: selftests: Add a selftest for guest prints and formatted asserts

 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/guest_print_test.c  | 207 ++++++++++++
 .../testing/selftests/kvm/include/test_util.h |   3 +
 .../selftests/kvm/include/ucall_common.h      |  20 ++
 tools/testing/selftests/kvm/lib/kvm_sprintf.c | 313 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   4 +
 .../selftests/kvm/lib/string_override.c       |   9 +
 .../testing/selftests/kvm/lib/ucall_common.c  |  47 +++
 8 files changed, 606 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
 create mode 100644 tools/testing/selftests/kvm/lib/kvm_sprintf.c

-- 
2.40.0.634.g4ca3ef3211-goog

