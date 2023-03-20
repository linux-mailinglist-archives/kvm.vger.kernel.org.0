Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2536C0B03
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjCTHDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjCTHDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:03:50 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83C27AA5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:03:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so15391874pjv.5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295829;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jy2VIL6bO5mZL/jdQbdNJj46CrpgZXPfvqfmWbmTMCI=;
        b=br0PJSuZlPOccgICcjx18go83jGLL24VtJuBAN9/0RH/Rm8SZFwOLu3af50MsNfvlt
         7SApp9Iim5yiOoF37GobP10xFVt+el3zBwyf0J33Ge4COuOZnMxQrnSlCiZX0g7AKieI
         FTuM1TEUNbEFqYxRh2PcmEkx3SNZtOjTza/sJNlxCihSvgVVtSXwCI1oIsZB+OPprg31
         ozKPFxOb9XG/c0XSbdypM/oR9Sg+/AI8MePoxYljPqbhq0aKKrE7ccN0+NPx9MrjWWGx
         Pjm9UN0pLQjl033u3Ekr3kH8HKasS6shKVWOnGLRsNjoFZwkEzb3GgB5LeQ3w4u6gRWL
         bxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295829;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jy2VIL6bO5mZL/jdQbdNJj46CrpgZXPfvqfmWbmTMCI=;
        b=GIJHtAkC0fITElaE/ysO8QgpTP6bvvh5KCXfFAGx+mfWcEUCoFQI3LgVaH7fs/L50s
         Crjo9v0X6z7Li0g8qY+58k1KrE/bujwHaYcofbSR0LzdNAAw9a1XTDfembaxR0lHd4Fk
         21LkYTM40IN3U/XfI9Us0PPEbYiW9/edvOs6i874wlKLiGTmpPwoYyhtYdcVQWetEMrK
         Zirxyp1CtxoTsd8EGiPkCeWgvgkVCaM1nVMXSnxAoqxfQwigeTYxXSrK3S2lQiGEIlmw
         CHWI9fC5rO4jJfjMEvUh1Hy/ZHhjfSHCgm7LfMvOWPNPqSiseEPKmBiQgu/PJjhsdaq+
         o0dg==
X-Gm-Message-State: AO0yUKW7m96+GiTifXRI7O+2+moL4SKIipjvDW3CCPJADXW4/HgS9s6s
        RbLis4XQaU4leeIZ9KRaWVXD4KCysgM=
X-Google-Smtp-Source: AK7set/+F9V5sauPXaabvZ8Ik7b8VKDFs76M/jrzI5sGy6du3TGnnwmv+jolDmE/yLpibkbH0giFUA==
X-Received: by 2002:a05:6a20:4c2:b0:cc:d7ec:b7c with SMTP id 2-20020a056a2004c200b000ccd7ec0b7cmr15059453pzd.4.1679295828954;
        Mon, 20 Mar 2023 00:03:48 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:03:48 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 00/10] powerpc: updates, P10, PNV support
Date:   Mon, 20 Mar 2023 17:03:29 +1000
Message-Id: <20230320070339.915172-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since v1 series, I fixed the sleep API and implementation in patch 2
as noted by Thomas. Added usleep and msleep variants to match [um]delay
we already have.

Also some minor tidy ups and fixes mainly with reporting format in the
sprs test rework.

And added PowerNV support to the harness with the 3 new patches at the
end because it didn't turn out to be too hard. We could parse the dt to
get a console UART directly for a really minimal firmware, but it is
better for us to have a test harness like this that can also be used for
skiboot testing.

Thanks,
Nick

Nicholas Piggin (10):
  MAINTAINERS: Update powerpc list
  powerpc: add local variant of SPR test
  powerpc: abstract H_CEDE calls into a sleep functions
  powerpc: Add ISA v3.1 (POWER10) support to SPR test
  powerpc: Indirect SPR accessor functions
  powerpc/sprs: Specify SPRs with data rather than code
  powerpc/spapr_vpa: Add basic VPA tests
  powerpc: Discover runtime load address dynamically
  powerpc: Support powernv machine with QEMU TCG
  powerpc/sprs: Test hypervisor registers on powernv machine

 MAINTAINERS                 |   2 +-
 lib/linux/compiler.h        |   2 +
 lib/powerpc/asm/handlers.h  |   2 +-
 lib/powerpc/asm/hcall.h     |   1 +
 lib/powerpc/asm/ppc_asm.h   |   6 +
 lib/powerpc/asm/processor.h |  21 ++
 lib/powerpc/handlers.c      |  10 +-
 lib/powerpc/hcall.c         |   4 +-
 lib/powerpc/io.c            |  33 +-
 lib/powerpc/io.h            |   6 +
 lib/powerpc/processor.c     |  52 +++
 lib/powerpc/setup.c         |  10 +-
 lib/ppc64/asm/opal.h        |  11 +
 lib/ppc64/asm/vpa.h         |  62 ++++
 lib/ppc64/opal-calls.S      |  46 +++
 lib/ppc64/opal.c            |  67 ++++
 powerpc/Makefile.ppc64      |   4 +-
 powerpc/cstart64.S          |  26 +-
 powerpc/run                 |  30 +-
 powerpc/spapr_vpa.c         |  90 +++++
 powerpc/sprs.c              | 641 ++++++++++++++++++++++++++----------
 powerpc/tm.c                |  20 +-
 powerpc/unittests.cfg       |   4 +
 23 files changed, 925 insertions(+), 225 deletions(-)
 create mode 100644 lib/ppc64/asm/opal.h
 create mode 100644 lib/ppc64/asm/vpa.h
 create mode 100644 lib/ppc64/opal-calls.S
 create mode 100644 lib/ppc64/opal.c
 create mode 100644 powerpc/spapr_vpa.c

-- 
2.37.2

