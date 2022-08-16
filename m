Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AD059577F
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiHPKGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 06:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiHPKGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 06:06:22 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB7A69F4F
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r69so8629469pgr.2
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=W6YOd56QG+w4EJ2+UVoO24f/heXOAOyLyBToQXedv28=;
        b=kCX80BuG6wgZQ7yL3Ae+H20C18a/ZmdckROkjWRH4W65SXUgEZMDCFbtY9igVIDFel
         lHhfDFCMMi3jzLK99tcwxDO+RJUyjYUopHiqpScJUkf6TVxjN5M+NnO9DVuvX21whoVC
         ExHSC7FroD4QhRU/MJ9sPGXhdn8Yzvtb6NQa14pGvarfRivrGlQ/iE6SLduWhjrMaZ2j
         SjZzn13InmsrP5DIlB902tDv035ZFlImL3uveblBcXc3JLNnC3uUjHtZChQEty+zcnNA
         2IdwVvPo4LDFa/zMeNIdG8RIqaqMziZUVIpVanTQ0GscRkCRqHneq+/SXLUKZSqLxnF+
         pESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=W6YOd56QG+w4EJ2+UVoO24f/heXOAOyLyBToQXedv28=;
        b=o7VaDDV7CRmZVh9dKjurN+id7GdXooYkwURXu0aCfsOHq7i+Bttirr7RagaifKZBvh
         U1YOOIM6STI36yhbU9LZU4duRJNXHL5Ukpm/cqfORaEiXzq2xUacaD7kvUvnv/CHDw0f
         E5Smin/B/MZI2y14PwI0boYqGM17BMhtltaqs94Q253rLGWfZUpqb+lehz7P94VFbhsC
         a+j7O9gR9PDZ27RZ0VLTneY9KwNTss2Gp83C9g9+cbO4VyxVtqjJ+wcNR3ux4RhR8kuv
         +hL68xEIKzzaF6tzWCSoQyJYIkrbUS4zpZdFobj4ufVFi/Gj35rOHofba+q27xT6WhoH
         wbGQ==
X-Gm-Message-State: ACgBeo34+RKBvEHyPyOQoy1MKy7/zt/1y+bLO6/ivrMkklMnPqxJYuDj
        Zw4zHaftp9cdD17kSCdj2ZY=
X-Google-Smtp-Source: AA6agR7lbdQ0lR6a29UUzCk84wSIEfGZw+HjZk0yVND4gida650mk9Z2QY4BqSOh29yp1bJCYr0xlw==
X-Received: by 2002:a05:6a00:1a44:b0:528:6af7:ff4a with SMTP id h4-20020a056a001a4400b005286af7ff4amr20269524pfv.78.1660637411626;
        Tue, 16 Aug 2022 01:10:11 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902db0c00b0016d7b2352desm8400920plx.244.2022.08.16.01.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 01:10:11 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/5] x86/pmu: Test case optimization, fix and addition
Date:   Tue, 16 Aug 2022 16:09:04 +0800
Message-Id: <20220816080909.90622-1-likexu@tencent.com>
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

v1 -> v2 Changelog:
- Introduce __start_event() and multiple_many() for readability; (Sean)
  (https://lore.kernel.org/kvm/20220801131814.24364-1-likexu@tencent.com/)
- Move PEBS testcases to this patch set for easier tracking;
  (https://lore.kernel.org/kvm/20220728112119.58173-1-likexu@tencent.com/)
- Create vPMU testcase group as more related tests are coming;

Like Xu (5):
  x86/pmu: Introduce __start_event() to drop all of the manual zeroing
  x86/pmu: Introduce multiple_{one, many}() to improve readability
  x86/pmu: Reset the expected count of the fixed counter 0 when i386
  x86/pmu: Add tests for Intel Processor Event Based Sampling (PEBS)
  x86: create pmu group for quick pmu-scope testing

 lib/x86/msr.h       |   1 +
 x86/Makefile.x86_64 |   1 +
 x86/pmu.c           |  49 +++--
 x86/pmu_pebs.c      | 486 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 +
 5 files changed, 527 insertions(+), 20 deletions(-)
 create mode 100644 x86/pmu_pebs.c

-- 
2.37.2

