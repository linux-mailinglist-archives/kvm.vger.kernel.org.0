Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBB0733D77
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjFQBt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjFQBtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:49:55 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFFD3A8B
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:49:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b3d44e3d1cso11480495ad.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966594; x=1689558594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bBnVoG0dGS8HTBN+3H6jiV3bbfD0jHuG3w6ZkOnSA/c=;
        b=m6wN6nNjJrKG1RjDZ0IS5eBwL1sYAM497YtCBU8l5cuoQ6gmIcX/HJAifPvY3FKSui
         xvJIhG/22EJmaTta+LJdxYzJGA+d6gOqwYP61Yas87mTPS6K+cKUQxV5qaPTAQ2t8+cy
         UX/m8kWykMhscVYPYJOOLrgyNtsf7Sqdth6xPXdOXf42IHaayoa8hjpcpKGAKIVx9yX1
         NkOX3C/EAdYAUXx/rhWh+r3C+EmCsXUxZFrUfD1CmaDxQVECALchMBYYIHiSsWLoTWAK
         1If6GyNvKLYBu+PESn1VtQNCNhY69yFjpUk199q0YwT8mKaWVe9l+yDRpGjwSoopqtus
         pg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966594; x=1689558594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bBnVoG0dGS8HTBN+3H6jiV3bbfD0jHuG3w6ZkOnSA/c=;
        b=Y45O+gb37iQ2ynpFULq/ySFQSY67xJ49/V1qKyB8sOc0zS7L30rPk7QdyR2wJcgN+A
         fAYD6upucosrnE1yQsb1xNpJAz6ai4uJqKoByGpQNjhkCF4Yq7uoCqOCQ8tY0VJQrTTg
         bhTDBhuspoeqJYdhIHFCbGvLg7VN+PZDJqJxISsZF9cO4goO2klwkfB888I7XYVFYk1G
         j8/+1YvrEz/yy24BbMcMJ6Qq68yYRLrRl93lLaHQQZsduVmzWS8iuj7OVLOaIhrBZbF4
         qlQF9Ss6iQfbnuVno0H1OraGdzFkwn7e5Di5U928ZRKUykcdVvVCbzVFpZoTgNAfl7sX
         Unyw==
X-Gm-Message-State: AC+VfDwDJQFeDSd/KLss6GY5k0zVp4Q/ZRyl0nH1Pl7jV2rtlVCerfTr
        CLldB6qPua8SgYsypDbZghrsVnErBLI=
X-Google-Smtp-Source: ACHHUZ4cpPfFsO9W/eGdzgAztY0CAcJJ7yKSdodSvhnGM+FkRCdbajIl++ZLnxd673THR+rxqjLazg==
X-Received: by 2002:a17:903:2341:b0:1ad:f138:b2f6 with SMTP id c1-20020a170903234100b001adf138b2f6mr4392591plh.16.1686966594076;
        Fri, 16 Jun 2023 18:49:54 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:49:53 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 0/6] arm64: improve debuggability
Date:   Sat, 17 Jun 2023 01:49:24 +0000
Message-Id: <20230617014930.2070-1-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

My recent experience in debugging ARM64 tests on EFI was not as fun as I
expected it to be.

There were several reasons for that besides the questionable definition
of "fun":

1. ARM64 is not compiled with frame pointers and there is no stack
   unwinder when the stack is dumped.

2. Building an EFI drops the debug information.

3. The addresses that are printed on dump_stack() and the use of GDB
   are hard because taking code relocation into account is non trivial.

The patches help both ARM64 and EFI for this matter. The image address
is printed when EFI is used to allow the use of GDB. Symbols are emitted
into a separate debug file. The frame pointer is included and special
entry is added upon an exception to allow backtracing across
exceptions.

Nadav Amit (6):
  arm: keep efi debug information in a separate file
  lib/stack: print base addresses on efi
  arm64: enable frame pointer and support stack unwinding
  arm64: stack: update trace stack on exception
  efi: Print address of image
  arm64: dump stack on bad exception

 arm/Makefile.arm        |  3 ---
 arm/Makefile.arm64      |  1 +
 arm/Makefile.common     |  8 ++++++-
 arm/cstart64.S          | 13 ++++++++++
 lib/arm64/asm-offsets.c |  3 ++-
 lib/arm64/asm/stack.h   |  3 +++
 lib/arm64/processor.c   |  1 +
 lib/arm64/stack.c       | 53 +++++++++++++++++++++++++++++++++++++++++
 lib/efi.c               |  3 +++
 lib/stack.c             | 31 ++++++++++++++++++++++--
 10 files changed, 112 insertions(+), 7 deletions(-)
 create mode 100644 lib/arm64/stack.c

-- 
2.34.1

