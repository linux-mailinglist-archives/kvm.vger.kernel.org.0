Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5104F727954
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjFHH6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjFHH6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:58:37 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9012EA
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:58:36 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-33d37cc9d12so734385ab.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211115; x=1688803115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4yRFqg508jlhIJTvId1HikWkLMg7l9WIXZYisxaAOGc=;
        b=jCFSxpWfAp3s7AdTzF8n8zs96QU5CfRqn96Aat1Y4ZAZnThzayo1wjSy+osBoLJ1ef
         9YIGJFXCkIq7AOVA5fnBe074xj3j5HXljYwx/rz1b6a4VAUupmMmmxgtcCRp1v6sKbec
         b0ba3bsxR+67w5lZ++6VTOpDSOKsKz4nmB3REtxWDtIL1W7v70K63edzksNmVl5q3xFE
         Blj71m/NhVwcS5b/xEmolDKd7u4GdULnvoFUzyvcshJCaSqJ27prGSegxiIOxsBZt9dO
         02SZy07UIfDwqq+Q8Js6HdhWB1ql+l6P54UtsI6Km465zJXwVpywTJ1ptnWQpJ1M0IaH
         JGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211115; x=1688803115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4yRFqg508jlhIJTvId1HikWkLMg7l9WIXZYisxaAOGc=;
        b=U/qx0qliN+W3UGA3vXgz17kLog3iCCbEoWRGNKTUySPCIxFJhCEkh+7ArgViYas9Wa
         r39cZCPUiY9L2qQykreKn52nx6WNiF/uZTjGbdCuZ07sNX916rfojzRxtfQMbkK5PAh4
         w/cbPmGeY00WwhAopoQapl7xAilCOdT+JT2rptlyXWZ3OOZTfB81MVzU7Wfk1KG7EPLC
         a6kSOwRI8MmG3ZZmydgO23a8tV66bYxg4eVdDWaNFUw3LHK20mZL+7RoUylq7lMFwaF6
         qwULmnFty435WwePnV43bpuWU9T2Ag/2hbeWeJi42xrbSvvXt38QTf0uRrHnxkgMoRKv
         kA4g==
X-Gm-Message-State: AC+VfDxOpgc3L5OYhSYe+8yuMFqwdO9YnSnyh6frzaKOo3bk1wohBIpf
        oNb3GL3h7KZ4Tz8E/VSl8bVTjnXqAtA=
X-Google-Smtp-Source: ACHHUZ67ce7fphGLD+/kuZ1n4tpmZO5QdEngrfS9H0fO+f9uMO+b3L//Lx5tS+bSNU+ydGFnbljKOA==
X-Received: by 2002:a92:2802:0:b0:33a:a93f:a87e with SMTP id l2-20020a922802000000b0033aa93fa87emr7621000ilf.14.1686211115408;
        Thu, 08 Jun 2023 00:58:35 -0700 (PDT)
Received: from wheely.local0.net ([1.146.34.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm673182pga.88.2023.06.08.00.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 00:58:34 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v4 00/12] powerpc: updates, P10, PNV support
Date:   Thu,  8 Jun 2023 17:58:14 +1000
Message-Id: <20230608075826.86217-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Posting again, a couple of patches were merged and accounted for review
comments from last time.

Thanks,
Nick

Nicholas Piggin (12):
  powerpc: Report instruction address and MSR in unhandled exception
    error
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

 lib/powerpc/asm/handlers.h  |   2 +-
 lib/powerpc/asm/hcall.h     |   1 +
 lib/powerpc/asm/ppc_asm.h   |   9 +
 lib/powerpc/asm/processor.h |  55 ++-
 lib/powerpc/handlers.c      |  10 +-
 lib/powerpc/hcall.c         |   4 +-
 lib/powerpc/io.c            |  27 +-
 lib/powerpc/io.h            |   6 +
 lib/powerpc/processor.c     |  79 ++++-
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
 powerpc/unittests.cfg       |   3 +
 22 files changed, 1133 insertions(+), 258 deletions(-)
 create mode 100644 lib/ppc64/asm/opal.h
 create mode 100644 lib/ppc64/asm/vpa.h
 create mode 100644 lib/ppc64/opal-calls.S
 create mode 100644 lib/ppc64/opal.c
 create mode 100644 powerpc/spapr_vpa.c

-- 
2.40.1

