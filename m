Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF34449BD30
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 21:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiAYUbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 15:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiAYUbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 15:31:49 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9D4C06173B
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:31:49 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u24-20020a656718000000b0035e911d79edso4103199pgf.1
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=A3e+W8EwZEP+fCyncNgPTplraXQJT2GNNVmEIK/oKXQ=;
        b=EHVj4Wllcc94XaSDsZHroeg93MZOLojIWwCL0iTTpuRv/dMQZiSqJ/wTmSOLaCKnm1
         H0zW3rHnU25XNM03aOJpTiUzCezssOmGXOIvaflkBzrq/7wslj/mITkGQ3R5gufFCKZZ
         isL1m7v9uO7NihKtbjNlo1HPO/s+K3Fhad68+lHjtLP8QXiIDN65Iq4nWusIik7xGy5t
         R29o+pAP8tzzD+jw7DsMik9nuCraBvwzlwvtc2WC/wtCdUOW5sdBO6NoLrJW3g8xo4fz
         VoY8ZOGq8VXJDqyrNY3e3tIxZT62zbiXvgX8/ymhSOZwyQHDY3r/9XK/YfcE2cHNizUv
         0i0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=A3e+W8EwZEP+fCyncNgPTplraXQJT2GNNVmEIK/oKXQ=;
        b=NnpUrrC1Uji5EXTNUnVFz6fPirywmnMJ/Oy67dw2ZqMVTB4qPZD+e66rhs0AfRp4Y3
         UeMHdSk8LSDMDbigtSr2eMTF4fHIz0kOX7Nq3n7x5PlWmej3LfSYpSp9/FyRkZjA/1hq
         zUY1RhNqBZfOTdYD4VguOeAwbTDKJVfrGrrpUPIjPqaPq6cZxK59j6Mtcdu3FvWdABBI
         iFDQWRYpuqGW4FVwW/9M8QM5dcyFrPE0Oq7yHeDsk2g6prvCsH/au439kXsjHNr+YCBP
         mE4cvJcagcPJ5aVZkb3zYcLa9LH5kZohZCafElFOQFMiqplGdpSE0AVFKtq6AjexJL7j
         SBUw==
X-Gm-Message-State: AOAM530rVwTvzGVwp/k48Ed4rmWbwVaHqR4kYxp5nFIisqh7LSt0eamb
        lNekUck+InhooKYfJft7Jtyvtw8dqqqpy39U+WreSlmMV/pjimiFmzZl7jGiykSkUEoadkhTFxG
        iFIEcCK2t9nsMBzYVwSTJOImhN+wILoSSAD2mcmZNCWcL7jEx5of/ucU2b5r99MM9BLFi
X-Google-Smtp-Source: ABdhPJwcPAVSqNGRjBqKQ1px7VDDAwvXS4oV17XmK9ul8PNkppXMKRXfsBTixgOEOX8mDNcLxp6HuP4ufG4/4ELc
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1151:b0:4c4:b2c6:6060 with
 SMTP id b17-20020a056a00115100b004c4b2c66060mr20129242pfm.11.1643142698020;
 Tue, 25 Jan 2022 12:31:38 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:31:23 +0000
Message-Id: <20220125203127.1161838-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v5 0/4] Add additional testing for routing L2 exceptions
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a previous series testing was added to verify that when a #PF occured
in L2 the exception was routed to the correct place.  In this series
other exceptions are tested (ie: #GP, #UD, #DE, #DB, #BP, #AC).

v4 -> v5:
 - Removed vmx_exception_test from being able to be run on its own.
   It can only be run as a part of vmx now.
 - Removed vmx_exception_test from vmx in unittests.cfg.  Having
   it in that list filters the test from running.  With it removed
   it now runs as a part of vmx.
 - Split the commit for test_override_guest()
   and test_set_guest_finished() into two commits.
 - Fixed up vmx_l2_ac_test() and usermode_callback() based on feedback.

v3 -> v4:
 - Add vmx_exception_test to vmx.

v2 -> v3:
 - Commits 1 and 2 from v2 were accepted upstream (bug fixes).
 - Moved exception_mnemonic() into a separate commit.
 - Moved support for running a nested guest multiple times in
   one test into a separate commit.
 - Moved the test framework into the same commit as the test itself.
 - Simplified the test framework and test code based on Sean's
   recommendations.

v1 -> v2:
 - Add guest_stack_top and guest_syscall_stack_top for aligning L2's
   stacks.
 - Refactor test to make it more extensible (ie: Added
   vmx_exception_tests array and framework around it).
 - Split test into 2 commits:
   1. Test infrustructure.
   2. Test cases.

Aaron Lewis (4):
  x86: Make exception_mnemonic() visible to the tests
  x86: Add support for running a nested guest multiple times in one test
  x86: Add a helper to allow tests to signal completion without a
    vmcall()
  x86: Add test coverage for nested_vmx_reflect_vmexit() testing

 lib/x86/desc.c  |   2 +-
 lib/x86/desc.h  |   1 +
 x86/vmx.c       |  24 ++++++++-
 x86/vmx.h       |   2 +
 x86/vmx_tests.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 156 insertions(+), 3 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

