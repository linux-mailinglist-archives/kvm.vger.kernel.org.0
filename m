Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD23A3A1CBF
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhFISbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFISbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:31:52 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319E7C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 11:29:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e7so13051610plj.7
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWR8DM4rZhEv+b9OobAtNIa8e8KYb5VZU+CQqiIP8z8=;
        b=fglm8JtV2d8eBftD13zlGmrIsoWahp/ny3WYdraGjB25yEV3n9mxbjbFe6x1TlEUtZ
         pzfpgkmgPGJLjl5g9/URjjODx3CAJykW6xEgeaiHpOX9avokCzXxfinqtOGwaTFFcke6
         jzkKJcXo9KErlY8A6t1TxSu4w9IBUt2ryJIXoSwh7eiffF7myaZS6gZZd4K38PRU8WQ2
         Gy3n7oRXIYkK+qkPemY7Kkb/isW204H694MschMw6KQruDYhCe+NHDVtRYzs4yA/EsZJ
         ZWdcZZAjCojyhJjcoha62ewCREyVMsoaP2omvS8sCKZ2/Ay95ineGIy99fqzuSX9AF3z
         7yuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWR8DM4rZhEv+b9OobAtNIa8e8KYb5VZU+CQqiIP8z8=;
        b=ukyQPdC74wUo/yxGgX4WRvVyx5l6q4JB1g1NR9yDhmlNW3+5CmwGxgti1AReUmXMog
         7LuWNckQC+u6nn7Z6nmxJH7rFv3vImLtQ/UCf0nw+5P3Fq5YF6ToDY0H74jJHm6/VB2k
         0Fozt1VLYXuKD/UhONnLF4TBJsPjRxreWR8t2AXnwU7/y9Dg2TzuNAVpSfiRWAt8pvuy
         MdLyX5wtFX3RfJW5F2ctxUgNC+hu27WJr/Vn13+/9qLftMLAHUhfl0fBk+N9eQAZhc1N
         dk4ZjCwkl9+BmhIn4sMTeotnfAl97/U625Oj7UdrgBccCUwgA0Vsu2Tf8rRbpkjDm7P/
         ArWg==
X-Gm-Message-State: AOAM532i/HN28WUD0rhfHrhZNtA0Ov4MVFvUCTUw62482med4HSuwtB9
        IqPQxUTyx41SNprOniL2o0k=
X-Google-Smtp-Source: ABdhPJwzuhkiCrUel2AJjw8pYZgqGJJREtBsCMSVqy9zcn34GyPERAhHr9enLx0XiuHC5TZpim00Xw==
X-Received: by 2002:a17:90a:c905:: with SMTP id v5mr11950533pjt.136.1623263396538;
        Wed, 09 Jun 2021 11:29:56 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:29:56 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 0/8] x86: non-KVM improvements
Date:   Wed,  9 Jun 2021 18:29:37 +0000
Message-Id: <20210609182945.36849-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

This set includes various fixes and improvements, mostly for non-KVM
environments.

The purpose of the patches are: easier to parse test results, skipping
tests that are unsupported and few fixes to tests.

Nadav Amit (8):
  lib/x86: report result through serial console when no test device
  x86/tsx-ctrl: report skipping tests correctly
  x86/smptest: handle non-consecutive APIC IDs
  x86/hypercall: enable the test on non-KVM environment
  x86/hyperv: skip hyperv-clock test if unsupported by host
  x86/syscall: skip TF-test if running neither on KVM nor AMD
  x86/pmu: Skip the tests on PMU version 1
  x86/vmx: skip error-code delivery tests for #CP

 lib/x86/io.c        |  3 +++
 lib/x86/processor.h |  9 +++++++++
 x86/hypercall.c     | 31 +++++++++++++++++++++++--------
 x86/hyperv_clock.c  |  5 +++++
 x86/pmu.c           |  6 ++++++
 x86/realmode.c      |  5 +++++
 x86/smptest.c       |  3 ++-
 x86/syscall.c       |  7 ++++++-
 x86/tsx-ctrl.c      |  6 +++---
 x86/vmx_tests.c     |  3 +++
 10 files changed, 65 insertions(+), 13 deletions(-)

-- 
2.25.1

