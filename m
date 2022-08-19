Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2AE599A79
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348686AbiHSLKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348499AbiHSLKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:00 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD131F6196
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:09:59 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so7213570pjj.4
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Os7/EdVWsAX4eImwfRIaKfh+yulOnUlignrixkRWKyA=;
        b=ZGy/2yJQ2nAg/NR9O26SV2M65K38i7Zkv0lNp/4syKCmcrTWWsS9NAahaykCl09E4J
         xbfzMXVVZeNOfCDE/KA408xCKdF2lcQqdOBI9o6iQOYeaJeGfclDuiapHJzzifULVF+Y
         MNIJWaHRco1WO6F9JPGnO92OIpZrgUSxRG0ZDtelJfvNSEi1afSdsa9P/k4jlum/8loL
         ROsYMqBBxWaWElByV2chF98qn0sA7xE066sIpONKJvCtkVzQepy+HapoSj+WYjPYeHLo
         fx5icjGQWhfKg9WDwC3ZufzMX5HCV2pa0xJKN4i17jEPKUbx+x00b/HI15vQQ2uKKqFh
         dclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Os7/EdVWsAX4eImwfRIaKfh+yulOnUlignrixkRWKyA=;
        b=cl8vWyT7XTstyyO+qvbeFRF095UkpfgLXoXi/RoYQkxHe/kj05gY4HdrCGxZYtbJq8
         uiKtrVJFnT/mE+6uJunNs2P5wfXm3prxwtagZ1jIqNxaolqPAHbnImaxSmV3DdhU2q8J
         ctJ87So9N9sHGAY0o41lXx2vS8//agr0JQuBX5AzIH46kUIy36jNcDbdEzOBTxjBITnT
         HJHgttoH0ZVjpBVBrdVP12fcliM78Y124K/regchNNUQDfoQX/7lNNPEWMDD6J6PfN5A
         qVIgHn0DNf4B2Az2Z8OF3Cyuxt3X4C4BCkX41d0lJW22g1ydvyK8sqGrgadPtueHEviV
         f+MQ==
X-Gm-Message-State: ACgBeo2xoT6JcKaRx7u0s856coTGgsXs6ojw6NQzbi9c1GjAKlT/fHXZ
        6Rwn3KFW75CquU7vhCR5rqRUMmOEz357XA==
X-Google-Smtp-Source: AA6agR6uXBVCoYiWwzaAFUwiJtvLLl1aVJ6fdKOZvXnGOJakRZ0e80yzI5NL8E2i+QLaPNbOy7wfsw==
X-Received: by 2002:a17:90b:4c07:b0:1f5:40a:8047 with SMTP id na7-20020a17090b4c0700b001f5040a8047mr8026544pjb.44.1660907399154;
        Fri, 19 Aug 2022 04:09:59 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:09:58 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 00/13] x86/pmu: Test case optimization, fixes and additions
Date:   Fri, 19 Aug 2022 19:09:26 +0800
Message-Id: <20220819110939.78013-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3 Changelog:
- Add new testcases to cover Intel Arch PMU Version 1;
- Add new testcases to cover AMD PMU (Before Zen4);
- Fix multiple_many() in the patch 2/5;
- Move check_emulated_instr() into check_counters();
- Fix some report_prefix issues;
- Add PDCM check before accessing PERF_CAP register;
- Fix testing Intel LBR on AMD;

v2: https://lore.kernel.org/kvm/20220816080909.90622-1-likexu@tencent.com/
v1 -> v2 Changelog:
- Introduce __start_event() and multiple_many() for readability; (Sean)
- Move PEBS testcases to this patch set for easier tracking;
- Create vPMU testcase group as more related tests are coming;

Like Xu (13):
  x86/pmu: Introduce __start_event() to drop all of the manual zeroing
  x86/pmu: Introduce multiple_{one, many}() to improve readability
  x86/pmu: Reset the expected count of the fixed counter 0 when i386
  x86/pmu: Add tests for Intel Processor Event Based Sampling (PEBS)
  x86: create pmu group for quick pmu-scope testing
  x86/pmu: Test emulation instructions on full-width counters
  x86/pmu: Pop up FW prefix to avoid out-of-context propagation
  x86/pmu: Add PDCM check before accessing PERF_CAP register.
  x86/pmu: Report SKIP when testing Intel LBR on AMD platforms
  x86/pmu: Update testcases to cover Intel Arch PMU Version 1
  x86/pmu: Report SKIP when testing PMU on AMD platforms
  x86/pmu: Add assignment framework for Intel-specific HW resources
  x86/pmu: Update testcases to cover AMD PMU

 lib/x86/msr.h       |  18 ++
 lib/x86/processor.h |  32 ++-
 x86/Makefile.x86_64 |   1 +
 x86/pmu.c           | 304 ++++++++++++++++++---------
 x86/pmu_lbr.c       |   2 +-
 x86/pmu_pebs.c      | 486 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 +
 7 files changed, 758 insertions(+), 95 deletions(-)
 create mode 100644 x86/pmu_pebs.c

-- 
2.37.2

