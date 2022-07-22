Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7195257E2ED
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 16:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiGVOS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 10:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiGVOS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 10:18:56 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59CEA6F8C
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:55 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v5so2897549wmj.0
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6AtW8tuHZLIvXRNPsvbUdvS0N3UxgY9EVnXj3rrySRg=;
        b=ObZKmgvNVd0sNaQGe0Vzhx29jmDHxzjmFh6dm/Q86Hhj41XLBiSTvSQH3bKSbrkOuo
         VjQ72xZzDGiUJRoKFEK6ZkgM536W8HDcvV00PRDLdBCK+UYgv+tkWOXzdY6E+u29kwbV
         wE6sdUSV6ptdYO3jS80LWH4IF73aAGrTGYPOmK5pr1tHS5rKMjQBcAiIo0LDcTp91QrB
         I7PsKmq5Q3P28XC3Tj0rL3RsnhHDAyUHlbjzAB7wLqqOqKaGmgiGndoRD5r9rkNXKzG3
         D6gOk6de0I+gBaqky/nFnnS86v13JBUIjF9AXxQr83oonhfBJ2rtYnVlGYh5WhT5K63A
         5Otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6AtW8tuHZLIvXRNPsvbUdvS0N3UxgY9EVnXj3rrySRg=;
        b=dAsCuYln0n+JGreuRFLracmHcZuUPMVXhXzopQaL1iT6VPW0WzbIkh6trnaDa9eFJa
         4joK6kMIhgxRsGE9I4FYyV9ByVJVcCrOQ8U3+vDAqgZ4TW2jrZH24ZyP3kxGqvGBALak
         RG5c9oiRvsZIWV26a5KrURl1+vX8jR7lXIVwzmXKTXfCRIfT69O5OUIPpUQ6J9uCiUxt
         A7o/PiFyw8xFz2ju8kneuh+d/ooxinbWrMtdvc1J+MermGNgv3DSe+jg3Qt9m4pkgX+H
         4DqOHYbFqwxVgCa7vpR5BNFdhw4pr+OhBJ+IHsW4qOiCSE9wYrPJZRy1wOlrChFv6dPr
         50/Q==
X-Gm-Message-State: AJIora9q07N1lXC2N32V3fniYX+lhPLyU9xME0noBCD9hth7SlDk39mj
        eUtHUWM383CpHbEn+2nn7SG3E6hdpDdJMA==
X-Google-Smtp-Source: AGRyM1smEk9cqu2jQYtTz+WB0anPv56fHEWswLHUzrlN6FVZ7fZVSCW59H5dtRsS1SxlxlDioDjtmA==
X-Received: by 2002:a05:600c:4f49:b0:3a3:1d16:18e8 with SMTP id m9-20020a05600c4f4900b003a31d1618e8mr29553wmq.109.1658499534195;
        Fri, 22 Jul 2022 07:18:54 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id az28-20020a05600c601c00b003a325bd8517sm6379415wmb.5.2022.07.22.07.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 07:18:53 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com, sami.mujawar@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 0/4] Makefile and virtio fixes
Date:   Fri, 22 Jul 2022 15:17:28 +0100
Message-Id: <20220722141731.64039-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few small fixes for kvmtool:

Patch 1 fixes an annoying issue when building kvmtool after updating
without a make clean.

Patch 2 enables passing ARCH=i386 and ARCH=x86_64.

Patch 3 fixes an issue with INTx on modern virtio-pci. That code was
written when INTx were edge-triggered, but they are now level-triggered.

Patch 4 fixes an uninitialized allocation error.

Jean-Philippe Brucker (4):
  Makefile: Add missing build dependencies
  Makefile: Fix ARCH override
  virtio/pci: Deassert IRQ line on ISR read
  virtio/rng: Zero-initialize the device

 Makefile            | 7 ++++---
 virtio/pci-modern.c | 5 +----
 virtio/rng.c        | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

-- 
2.37.1

