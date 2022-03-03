Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDB4CC9D7
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiCCXMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiCCXMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:12:06 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD02A0BE9
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:11:20 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id f37so11092943lfv.8
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=daNUpbDbnTMsiMXGki4KiFcXAVXeh7bPU4q+rhUx32Q=;
        b=jVHnLzKkaZXhVype7FH5l41ut1Ll4aca/aPpHMck77rD4NAFTFYaFuuTrdFiFtxbaQ
         9K70LvEsg9ODL9KYv4iRxKow3AESKfkjA05jdjJ9Kmvpv+K8gKeENA854AIL6TEWNpjx
         MKGuItyh/1etVFbcckn32ll9H8ISUeBvX4VqHIaAXYbjzntC6BxyI5A5zOq8lmMWEtGp
         wvh0Fizsf0dI0bXlL+PkVy1KZHhWpEoM17wR+wB0s3jFyl5FY17G6EutRHfo0ksD3P92
         6UKEOwe67AOO8os8vG/ITPr0l4JSzGTOh2AnJF4nxo63ndxp/cZBRfMefEnQe1/vl/0H
         pdYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=daNUpbDbnTMsiMXGki4KiFcXAVXeh7bPU4q+rhUx32Q=;
        b=CpaOKh7T5mhl9y0K+fDXfhpg34FRncfoyi9zKBKAquuXdU0/HLxz2uF3j5/M7tlM19
         kg0u/jUhE8prxbK4sZYVlk1NdOH1YaoT2d6sWUEsJNJVA5iLSLvdhdeXDi6ThN4hKhEx
         rUv/arp+0+FDCtgnfGkA2LTFu2USiFJbVO+1CNaLl/u4yuo7ua7TRGsL6gMs0wbm8ehy
         RvkOfOzASVzOOHccxCu/EeXkame51RQhg/gIvOZLvZTu85d1ncKhusP0p5z0ZA8jRJiU
         Xb30kgwebmg6MQQujNbWvbSO/4HUNAajB9NSc6/hZBh8WRGkZb2JiTqVgJdyuOVI0ACx
         miRA==
X-Gm-Message-State: AOAM5325hd8ezRuwcXSn+JsV/fGrbNoQO8qRlxfombgVeaGgVdqnrliz
        FTWJXJpr1xW0J7o9dDdrQCI/VckZQc4=
X-Google-Smtp-Source: ABdhPJy7lJvPcH+V0ir9Sk+kZdQFP6ZXqHxrLGuP/+eCQfUkovocFZk16C8xA8XpUW2Yu3uQZBwTKg==
X-Received: by 2002:a05:6512:260b:b0:444:18:fce5 with SMTP id bt11-20020a056512260b00b004440018fce5mr22362028lfb.119.1646349078168;
        Thu, 03 Mar 2022 15:11:18 -0800 (PST)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id g13-20020a2ea4ad000000b0023382d8819esm725264ljm.69.2022.03.03.15.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:11:17 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Cc:     Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH v2 kvmtool 0/5] Fix few small issues in virtio code
Date:   Fri,  4 Mar 2022 01:10:45 +0200
Message-Id: <20220303231050.2146621-1-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Hello everyone,

Thanks for the reviews in the first patch set.

This is the second version of the original patch set which addresses
few found overflows in the common virtio code. Since the first version,
the following changes were made:
- the virtio_net warning patch was removed.
- a WARN_ONCE macro is added to help signal that an issue was observed,
  but without polluting the log.
- a couple of improvements in sanitization and style.
- TODO comment for missing handling of multi-byte PCI accesses.

The Makefile change is kept in its original form because I didn't understand
if there is an issue with it on aarch64.

Martin Radev (5):
  kvmtool: Add WARN_ONCE macro
  virtio: Sanitize config accesses
  virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
  Makefile: Mark stack as not executable
  mmio: Sanitize addr and len

 Makefile                |  7 +++--
 include/kvm/util.h      | 10 +++++++
 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  3 ++-
 mmio.c                  |  4 +++
 virtio/9p.c             | 27 ++++++++++++++-----
 virtio/balloon.c        | 10 ++++++-
 virtio/blk.c            | 10 ++++++-
 virtio/console.c        | 10 ++++++-
 virtio/mmio.c           | 44 +++++++++++++++++++++++++-----
 virtio/net.c            | 12 +++++++--
 virtio/pci.c            | 59 ++++++++++++++++++++++++++++++++++++++---
 virtio/rng.c            |  8 +++++-
 virtio/scsi.c           | 10 ++++++-
 virtio/vsock.c          | 10 ++++++-
 15 files changed, 199 insertions(+), 26 deletions(-)

-- 
2.25.1

