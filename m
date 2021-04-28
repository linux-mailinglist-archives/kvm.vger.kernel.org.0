Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0D836D5A7
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbhD1KTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239233AbhD1KTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 06:19:38 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E610EC061574
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id m9so49686266wrx.3
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h0nQnWfRsJ4H9fZ4V8oB0e3t3FwopAIx7BelND6opc4=;
        b=bXzFmQP1exjyRE4ikU7o5JEDc/TxB2cHiu9Lh59XBAJr+A3q4lARBvXmVMzRNrMj5L
         vjQJBVkXOC65HWb6w/qD1dmG8PVFdbanqJ2laZYgQq13ex4X9vXw+PPX/Zb7R3PrC+Ad
         R5Awbdh6Ev+31y58S3A+X3ushs8Rd1m6WW8Sgw4QMJc0hPQ5X+ky1FvjHRFvWutikyqN
         FmckXdM8YadSOzFWOHXv/ch+cwdB0Ghq5vu7RrFMAYpRW3zkAHvZLuRPyOVSZWtnTYrU
         J1mHfdZGgz+Sq1mGKTs8nq3/sqUOHcrxOS9ChhVQKsS+WoN9knT9GVVSSRh6Rianlb7V
         ipTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h0nQnWfRsJ4H9fZ4V8oB0e3t3FwopAIx7BelND6opc4=;
        b=DXf+kpwEbTETBj7Bft2Dn0+qYEJZXtNnMxeCtJa+xlJMdOPaJ/IS3e5/2VT1/Qqakd
         rMqYeoqY5q4PWNBLda2Iy7CVNWKGVWfs+KNgSyel+Nh3GnxynJ+m1leqg27xJ8pZqfVn
         HQoU6t9+SBpIKRFLyzNqdAO3mNWGzIHAQB0APwwWpauoTpPFyN9yxn0aveC7h0HQpK4k
         nt169xua3AER2/9GevOmJAW1G8GqPDf8q4jlDjbfIUpYNcbYiJDeRVQ31/rXB7msGt6N
         ZweqzWAGubVNpaPmNzcKZ7jOZJmQnHwPOu6wKK9iB/A+qJecNOyI/31Oyg62WUtyMvpE
         e93A==
X-Gm-Message-State: AOAM531e5zJxYPnEo/We4TecH2jn+afzYoRPP3Y7BK3tNthn6nXasPH7
        p58F4oBiokD3EG2I2YcDT//7uA==
X-Google-Smtp-Source: ABdhPJyF87c/fp1iN0zpxYpXE/1Gh0VymotpoSflP0pBM80ElDhXfzZRhRVKwFGRvGOg2YP67jblyQ==
X-Received: by 2002:a05:6000:1564:: with SMTP id 4mr35151201wrz.197.1619605128646;
        Wed, 28 Apr 2021 03:18:48 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id g5sm7632844wrq.30.2021.04.28.03.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 410151FF8F;
        Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v1 3/4] arm64: enable its-migration tests for TCG
Date:   Wed, 28 Apr 2021 11:18:43 +0100
Message-Id: <20210428101844.22656-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428101844.22656-1-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the support for TCG emulated GIC we can also test these now. You
need to call run_tests.sh with -a to trigger the
its-migrate-unmapped-collection test which obviously doesn't need the
KVM errata to run in TCG system emulation mode.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arm/unittests.cfg | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index c72dc34..d4dbc8b 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -203,7 +203,6 @@ arch = arm64
 [its-migration]
 file = gic.flat
 smp = $MAX_SMP
-accel = kvm
 extra_params = -machine gic-version=3 -append 'its-migration'
 groups = its migration
 arch = arm64
@@ -211,7 +210,6 @@ arch = arm64
 [its-pending-migration]
 file = gic.flat
 smp = $MAX_SMP
-accel = kvm
 extra_params = -machine gic-version=3 -append 'its-pending-migration'
 groups = its migration
 arch = arm64
@@ -219,7 +217,6 @@ arch = arm64
 [its-migrate-unmapped-collection]
 file = gic.flat
 smp = $MAX_SMP
-accel = kvm
 extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
 groups = its migration
 arch = arm64
-- 
2.20.1

