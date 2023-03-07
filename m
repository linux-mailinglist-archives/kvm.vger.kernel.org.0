Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6B06AE225
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 15:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjCGOXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 09:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjCGOWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 09:22:42 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D26C4AFD0
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 06:18:10 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t2-20020a632d02000000b005075b896422so894734pgt.19
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 06:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678198629;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8DFqT51TM/0XwMfstqHvMEBhJbT+EG3oH+uIjCT0G8s=;
        b=jBdmriAiwcJodoZbaeYFXiYfQ+ioNiQBnmnYn0nkvsx73vSJ3R2bVOdnbD3X0rGCeg
         yAIhXprAznNprXUgRLi3w1x0kf0H5IPdGClGhoz633f64WUvlSB1tKx/Dj+glqyv7Cne
         w/GFYW1QUHGaU2WU7asrj8ciwGwg7vgTPcnqH4E1UH7+NKWwq4GomftQh/DyRUcTlvf3
         KhSey7x4vTLh5C6/rynkfyLDPbcYnFt9L8A/PQDc8xG2EgDfP5OCNiUMt2+TMwruT61w
         LqO8YUbZ5LcKlzHOKGPpjqJnY25pTDNLlTn9G0aet+uJb51tkkJ3UGPKlVVIwIosb6pe
         gyZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678198629;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8DFqT51TM/0XwMfstqHvMEBhJbT+EG3oH+uIjCT0G8s=;
        b=jIDElujtRnA14EGdG4VE5SB9JaIj9qxsuwTa7ePcNYr6QZ63C1s2ox+jdBDPybYPLR
         dTmVzYwB73RRU/Azc7q9Yf+2i0n7IkawRZZ6zasE29Zj3CL7Okd8OyH6AjqM+YkAWy5M
         MxgIxBqWArKlGTYDiqCX6taR5Tb6yWpmR+E/7cD8owIqDAMfOcaGFkjWt5tEfAYVHdYq
         NDZIi9BjjjnJJGtPd+4S6kSAb1GDrvy78NHor2OrpXTLRYFDjjauu0aidwJfEGeOaixY
         tvLHwA4i49C3lbNrlDlg0gm75QpF0tKVvMUmIzleMK222jsQbCKCDAV2AS+o8gObI+MK
         jVDg==
X-Gm-Message-State: AO0yUKVPsArV7XSSNHBEt9bHjvnlUNy10LqSIRZs9OZt4bTjX8gY/gOO
        8rGqdZ2rAoMKTHHSAt76q16Kv3Z50ILQFgD22TcmhtRqJnSOOsU9YSV1S1hSFsUUqcrVCH1HuUL
        doOU/P5Lw5eFEIwzw2xEK8+5n4h/zT/YvxTWg1UvUv7ZNmzHa6X4l1vN/m9OyjsCrweuq
X-Google-Smtp-Source: AK7set+jD00VvAGWSF+h/1h40/9opSyB6+TPaawk116jxjJWeWDqxZdxtJMBeWfzNm0sX2zPCr9es/8/LJfStSPP
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:f812:b0:19c:140d:aad7 with SMTP
 id ix18-20020a170902f81200b0019c140daad7mr5661226plb.4.1678198629134; Tue, 07
 Mar 2023 06:17:09 -0800 (PST)
Date:   Tue,  7 Mar 2023 14:13:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307141400.1486314-1-aaronlewis@google.com>
Subject: [PATCH v3 0/5] Fix "Instructions Retired" from incorrectly counting
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

This series fixes an issue with the PMU event "Instructions Retired"
(0xc0), then tests the fix to verify it works.  Running the test
updates without the fix will result in a failed test.

v2 -> v3:
 - s/pmc_is_allowed/event_is_allowed/ [Like]

v1 -> v2:
 - Add pmc_is_allowed() as common helper [Sean]
 - Split test into multiple commits [Sean]
 - Add macros for counting and not counting [Sean]
 - Removed un-needed pr_info [Sean]


Aaron Lewis (5):
  KVM: x86/pmu: Prevent the PMU from counting disallowed events
  KVM: selftests: Add a common helper to the guest
  KVM: selftests: Add helpers for PMC asserts
  KVM: selftests: Fixup test asserts
  KVM: selftests: Test the PMU event "Instructions retired"

 arch/x86/kvm/pmu.c                            |  13 +-
 .../kvm/x86_64/pmu_event_filter_test.c        | 146 ++++++++++++------
 2 files changed, 108 insertions(+), 51 deletions(-)

-- 
2.40.0.rc0.216.gc4246ad0f0-goog

