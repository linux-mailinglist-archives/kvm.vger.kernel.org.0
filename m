Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4878C7C5DEA
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 21:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbjJKT6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 15:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbjJKT6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 15:58:05 -0400
Received: from out-197.mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDED94
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 12:58:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697054278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NBdFJkgYJSOzXayzM8jpEgticEipqKrh87vuZZUVqWI=;
        b=XSVr3Iasililq6Jjf897ZcVr2TR3WCtF3BasDbHQAplqCTJ1uripBA2LHchI2JFxJT+oMa
        OSAkltHILlIHKi5+ll7X6VeJXzcQCgn6N1v+j61rkzdduSBRK6AooSaccrblDz25LKq/uU
        Zby2ksf7qO6a7XAzQgLmdkwVmyUnQpE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/5] KVM: selftests: Add ID reg test, update headers
Date:   Wed, 11 Oct 2023 19:57:35 +0000
Message-ID: <20231011195740.3349631-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2: https://lore.kernel.org/kvmarm/20231010011023.2497088-1-oliver.upton@linux.dev/

v2 -> v3:
 - Use the kernel's script/data for generating the header instad of a
   copy (broonie)

Jing Zhang (2):
  tools headers arm64: Update sysreg.h with kernel sources
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (3):
  tools: arm64: Add a Makefile for generating sysreg-defs.h
  perf build: Generate arm64's sysreg-defs.h and add to include path
  KVM: selftests: Generate sysreg-defs.h and add to include path

 tools/arch/arm64/include/.gitignore           |   1 +
 tools/arch/arm64/include/asm/gpr-num.h        |  26 +
 tools/arch/arm64/include/asm/sysreg.h         | 839 ++++--------------
 tools/arch/arm64/tools/Makefile               |  38 +
 tools/perf/Makefile.perf                      |  15 +-
 tools/perf/util/Build                         |   2 +-
 tools/testing/selftests/kvm/Makefile          |  24 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |   4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |  12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |   6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       | 479 ++++++++++
 .../selftests/kvm/lib/aarch64/processor.c     |   6 +-
 12 files changed, 785 insertions(+), 667 deletions(-)
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100644 tools/arch/arm64/tools/Makefile
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: dafa493dd01d5992f1cb70b08d1741c3ab99e04a
-- 
2.42.0.609.gbb76f46606-goog

