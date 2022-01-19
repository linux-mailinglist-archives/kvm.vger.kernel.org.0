Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72EA493E87
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 17:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356214AbiASQps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 11:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiASQps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 11:45:48 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1683C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:45:47 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id v3-20020a622f03000000b004c412d02ca3so1846941pfv.20
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UmMdJWWjuLml1trjVGK9qfeOvmg0pn/CwUINVBV/L1w=;
        b=aGdQFc4PR+4tPafaj1M/fi4ZrFZVki0pgxvyTb8SoD25lt6GhIF0FNEMDA9StlZqIR
         VfLCdfl6NNneYf4cfCcACQqoFMicXpbVgPhN+9TLdRb32cTiMsw5skpn4S37LjuwtcLa
         5c4RLFmZ72s7x9rHLSkTVYoAvCgHrYLNJDnQWoKrrkO1BoZ9vevYOYYMkJYdWVhHIzR0
         aK/X6E7w38q/KPhgCx3pRKrNF+tY20X+YZfuffLCkVVt+PfoNVq0nJuzDZQ2VeSVeqvP
         yD1IbO/FZZg9gTh57MsKJBmOFzdyUAMmpg9+jIqwlRWA6ZEYi288tQF/D6rTpETSxY6y
         J90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UmMdJWWjuLml1trjVGK9qfeOvmg0pn/CwUINVBV/L1w=;
        b=ADKT35lxRlaoxSmrdoNhB/7jLeeZTXlpZ6vc4Z5zz3gqL/lwRebA1IbuNQuqhOWyyi
         fY0rFGvEKZ1wSd0vbInd59Z5Qvyp/ReGIogrIQk70qig9kw8Tw8HaRr76ZNJ6DZ87xhk
         AHm1cDPJ0CAE3A4yqIUr3xWKB/oi6E8Gg1c0lO4CflffMYq0Zt4PDV4mzVnsCaaTqvD+
         sDIOOhfuQpXMhPelgQSD6egTEKvOKdQCEsJZE1zyatnm5L/eHNHAdZFG0CSAhwODvQuL
         BOEt8AuMV4jw/aGTO3e9ZLyVVsOwtAKn0Vgg2WqzHIYMc8XbIW+xIYNuQTFpAw9sbQs7
         5AzQ==
X-Gm-Message-State: AOAM531KrLnVK8FiHFWFavzzFiec5R6/SYmMu6X79tYVxMkHWwWYAt1n
        HQue8Wk/wS7efU5F+qoxDb+ZKZUkidz/BKVU8rUdoWtJ/mgKtN0dHixLsxdLLS50owgY14Lf7Zp
        /WNEDNZAKMAijFB5VbJT0tAC36VcjIm49HDCu8Ki3z1ycq059dZIPRy38K9hs4zdEsN1b
X-Google-Smtp-Source: ABdhPJyylD/0ItEw/7oDP+PjaP4nsmS6VAkSORBZlQH+44sEEy+SG59CTCuE6JMY52B4wPwE22jRODd6Tmj6S40H
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:b503:0:b0:4bc:1f47:3b26 with SMTP
 id y3-20020a62b503000000b004bc1f473b26mr31356355pfe.9.1642610747044; Wed, 19
 Jan 2022 08:45:47 -0800 (PST)
Date:   Wed, 19 Jan 2022 16:45:38 +0000
Message-Id: <20220119164541.3905055-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH v3 0/3] Add additional testing for routing L2 exceptions
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

Aaron Lewis (3):
  x86: Make exception_mnemonic() visible to the tests
  x86: Add support for running a nested guest multiple times in one test
  x86: Add test coverage for nested_vmx_reflect_vmexit() testing

 lib/x86/desc.c    |   2 +-
 lib/x86/desc.h    |   1 +
 x86/unittests.cfg |   7 +++
 x86/vmx.c         |  24 ++++++++-
 x86/vmx.h         |   2 +
 x86/vmx_tests.c   | 129 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 162 insertions(+), 3 deletions(-)

-- 
2.34.1.703.g22d0c6ccf7-goog

