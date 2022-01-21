Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22394496277
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381716AbiAUP7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381728AbiAUP7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 10:59:02 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EB0C061401
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:59:02 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id y14-20020a17090ad70e00b001b4fc2943b3so6169922pju.8
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Q894Lgfl+HKUSkEGAnwZMeEW6TiX6rYOsogZldbM6+w=;
        b=PnJKXbBD700sQotbBLfDB9b6h62aqrU33wD5XQ1M66JD6ugTmBxsTp1nnSNVBhHrGA
         GzJT18i8Pwq5EfB2jI5xvfK49pOAbrXWB/ddIhumPTC0onKijP+xFIL60nlrZUTuhLt+
         61ri9cv0hJj2pQkl7vmSsPlcdkUuuyGBw1Eg1nKu/sb49utZFFpd454KWxP1uDIk3wAv
         tuDjs0x09ZUbuLF0e6JveGTBb37mS3GWlV3CYrcimjb2cC+JxzZsXuwAMoKDiIt1ollW
         YJWfeHpDQR2MK1cfs4QGsQHDcNi6TToTgo/yHDCyTvcuPVzI2hwX92tyHP7H0ZQJzZKD
         6bAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Q894Lgfl+HKUSkEGAnwZMeEW6TiX6rYOsogZldbM6+w=;
        b=pAnJhNC+mbicv68sIio0zMNg3zxDSM0v9x/y4cTxy+UULtLTLrPLK2xM3yamie/IyI
         aud/NndWW+NOcI7Kd2tg1mXGilai7O9O7rqv44SqqfepOSCsGHKzdh7G1AzSMfSMjkF5
         lqqw04dNB7ZzQnZnatpWQ7IVitoi6R1AGiKlabM3pFhRNOOzIICJ1ENX27k5zZN30v1J
         liqrU6c8v0MAg9uoBlur5+b5AWwjy4uvM2t2FPuklD8Jg92vieWrZhANBS83fm1YkVyC
         sw38tvQpCKleVDvHKExlnWgpWgYIK0/Ze3ua/2NalkNpWOzw65q/2lhXRDZnKeWz1qxT
         3VSg==
X-Gm-Message-State: AOAM532DsJgIqjq0MwaMqQVcVByMv4jqzcpKvH9hRaAPC+Lbyw1BPzXO
        SiDUwFetQfQ7EurhziD21gLbT8BF0BUMTAo2/Q65R7u8SHii9bwk80CZaprQqWtt57Jcel0duTj
        RbVHXFUBmjtraKoIgJgG07Ro2CZMElL8DhrLI5kHaeZOsKBSOJjHUz7TYHHwHqNLgUdFm
X-Google-Smtp-Source: ABdhPJySSAMVe9z1PAHx5KrVJCZq8MG0p0BFLAqrQXOQCA9/R5NspH2aa8KCqtvTvX2jPz/SuFpOph5xGh4EDJBO
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:2310:b0:4c3:d3e:3667 with SMTP
 id h16-20020a056a00231000b004c30d3e3667mr4450483pfh.69.1642780741454; Fri, 21
 Jan 2022 07:59:01 -0800 (PST)
Date:   Fri, 21 Jan 2022 15:58:52 +0000
Message-Id: <20220121155855.213852-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v4 0/3] Add additional testing for routing L2 exceptions
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

Aaron Lewis (3):
  x86: Make exception_mnemonic() visible to the tests
  x86: Add support for running a nested guest multiple times in one test
  x86: Add test coverage for nested_vmx_reflect_vmexit() testing

 lib/x86/desc.c    |   2 +-
 lib/x86/desc.h    |   1 +
 x86/unittests.cfg |   9 +++-
 x86/vmx.c         |  24 ++++++++-
 x86/vmx.h         |   2 +
 x86/vmx_tests.c   | 129 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 163 insertions(+), 4 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

