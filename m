Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373196CA45C
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjC0Mpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC0Mpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:45:35 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C653583
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x15so7561685pjk.2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KCiKOWP9OD70+BMDOPG9uFA2Fku30UBKZIR1BIz1KaI=;
        b=IZtvd/anTvYfpHea3GmU2+btAEj77m3vW1Mt5eWpVnuyutaBiJVGvXjFs+TFLYNQbs
         P02X4vQY1iBy3GWkgdWvwXkBgHJryaZxCK5nw+AsLgOCg1ZRrS/kO39xexqg2Z4S9i0v
         fv5KoJRoNEyo6J33Zo1q5WN5YEaphnRgePvDdRe4tL8IznpiP63iqO+kOQcNLAp0VfcD
         3KEtBaHsXSmOGKsAOg3OwEwY0SN4m6HfRQqFB3UpsTJgmd8/2tOVCyYyEhV4j/V9866H
         2oraQgLAR1XMcgazB1Zv/seWO2/25b8S4xRErc2ZepPs8YJ6+OQBt9BZ7TFBn11Z+qfU
         xltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KCiKOWP9OD70+BMDOPG9uFA2Fku30UBKZIR1BIz1KaI=;
        b=zKddAnxwE1O+4IHBa+vCj+awqCUjbvtRKxheMrLf5p2I6c9psY1H2cv6YJDDX8p7os
         yf3FpV3U6diQ2PkNxRE3pwxb6mlBoI7JWzvdrbPP9t7TdCRz+UuxlZphYZwLbpE/kgRZ
         kAKxqURhE54S/VsyI6ihOfDyyxDtcTfc23QHJo0+Bzv+Qrb9ltwGpw7j1XBP7EWhroYw
         bM4tm+F5GZUKu1lLL8ZqGqu9oWg/niDVwH7HsTT3cpLHEr4RyuDr7FFxVEhHzSZiJ51r
         dexwVzRaB4NMN6GoHiOLOQ6W4MSkoqlNaDW93pdd/DK+MebtHNqdYxOMRKDSigDrbL3k
         mQSw==
X-Gm-Message-State: AAQBX9e4lHJcEIkBthiJdzi5iz7jqmfVoNKKPB5rKkfvd0IEhdfQPOb1
        rLCFdKagrSxF1BYxeF99OGBuOrZ/HCo=
X-Google-Smtp-Source: AKy350Yn3HKa4UqZvJBBsd+tBZKfXhhXlpPWcsb/4f2azx1FDruTqa/GfCcbWd7tMf57PyRRIc5UYA==
X-Received: by 2002:a17:902:d411:b0:1a1:c8b3:3fe1 with SMTP id b17-20020a170902d41100b001a1c8b33fe1mr8896800ple.31.1679921132917;
        Mon, 27 Mar 2023 05:45:32 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 00/13] powerpc: updates, P10, PNV support
Date:   Mon, 27 Mar 2023 22:45:07 +1000
Message-Id: <20230327124520.2707537-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is growing a bit I'm sorry. v2 series added extra interrupt
vectors support which was actually wrong because interrupt handling
code can only cope with 0x100-size vectors and new ones are 0x80 and
0x20. It managed to work because those alias to the 0x100 boundary, but
if more than one handler were installed in the same 0x100-aligned
block it would crash. So a couple of patches added to cope with that.

Thanks,
Nick

Nicholas Piggin (13):
  MAINTAINERS: Update powerpc list
  powerpc: Add local variant of SPR test
  powerpc: Add some checking to exception handler install
  powerpc: Abstract H_CEDE calls into a sleep functions
  powerpc: Add ISA v3.1 (POWER10) support to SPR test
  powerpc: Extract some common helpers and defines to headers
  powerpc/sprs: Specify SPRs with data rather than code
  powerpc/spapr_vpa: Add basic VPA tests
  powerpc: Expand exception handler vector granularity
  powerpc: Add support for more interrupts including HV interrupts
  powerpc: Discover runtime load address dynamically
  powerpc: Support powernv machine with QEMU TCG
  powerpc/sprs: Test hypervisor registers on powernv machine

 MAINTAINERS                 |   2 +-
 lib/powerpc/asm/handlers.h  |   2 +-
 lib/powerpc/asm/hcall.h     |   1 +
 lib/powerpc/asm/ppc_asm.h   |   6 +
 lib/powerpc/asm/processor.h |  55 ++-
 lib/powerpc/handlers.c      |  10 +-
 lib/powerpc/hcall.c         |   4 +-
 lib/powerpc/io.c            |  27 +-
 lib/powerpc/io.h            |   6 +
 lib/powerpc/processor.c     |  80 ++++-
 lib/powerpc/setup.c         |   8 +-
 lib/ppc64/asm/opal.h        |  15 +
 lib/ppc64/asm/vpa.h         |  62 ++++
 lib/ppc64/opal-calls.S      |  46 +++
 lib/ppc64/opal.c            |  74 +++++
 powerpc/Makefile.ppc64      |   4 +-
 powerpc/cstart64.S          | 105 ++++--
 powerpc/run                 |  35 +-
 powerpc/spapr_hcall.c       |   9 +-
 powerpc/spapr_vpa.c         | 172 ++++++++++
 powerpc/sprs.c              | 645 ++++++++++++++++++++++++++----------
 powerpc/tm.c                |  20 +-
 powerpc/unittests.cfg       |   6 +
 23 files changed, 1138 insertions(+), 256 deletions(-)
 create mode 100644 lib/ppc64/asm/opal.h
 create mode 100644 lib/ppc64/asm/vpa.h
 create mode 100644 lib/ppc64/opal-calls.S
 create mode 100644 lib/ppc64/opal.c
 create mode 100644 powerpc/spapr_vpa.c

-- 
2.37.2

