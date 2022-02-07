Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEA34ABEFE
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 14:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383117AbiBGMcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 07:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442754AbiBGMVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 07:21:38 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9144DC03FEFC
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 04:12:16 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v186so39347032ybg.1
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 04:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=nmVRRu0GExGcm7DNW9DR6nksryuC5Xcn3ZEbPIvWg6w=;
        b=Q/E0xhxeCtgIqbaBf14CVxtiMmyWWdw12H/WkdrtRjiKwi2GWn0UcY/0G43rffcrcY
         Lrx2JspH1ON+SAC3wZra9JtMWqqQU06/SUmi7Lpt4f8vDWnfEAlGRD2lrGVFLj/H2iRo
         cCPXWQD8WT5oR5r1gptSS5/bPjoNlTJFOEQK2Ig74xKVMsA2EbgID8xHv27g9PvAAxBe
         cJgYO1nHXbpWNA/jz5qlZ7fgVdn2AtVJAIjUNvE/s+p9zIqiYtZQSTNssGueNjbsH5k1
         p4jPdoxiAeOZCwUNzhuvlth6c9exQ94OTkoXvchXCgIHpCplh3mC1dRUK6g9pE34Z+Va
         WcKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nmVRRu0GExGcm7DNW9DR6nksryuC5Xcn3ZEbPIvWg6w=;
        b=Z4AjufOB1CpmVJTT/a/TVahPY0X5I6GwkyqdXDyTZD9PD+VsIzZ4INa2u6a5/QHIQ5
         +VrJ0kglsZ6ST4wltet8pVgSV8BZXssOHjKT2bldLM7s525S4avQ2lMtrSAK1LswlH2A
         cGD/Ag/YdxE/JwPxG/4AwRyczGupi6A/uKMvcyVX9nnYUdR6Y6yhgoqZkWiMe26VQUCc
         xyvm62m8K+ahioThUUOMdkoJJIaXs16kPw2BCkhX8DKrzLZwA0Z0A4OC23ladLGP4eIl
         lWTjoGIO6ndqrkWfZQDSY3VEpJPxSgfMH1TXx+ivgWumEa7/mXnIXT+z96jf2IEV/2fe
         tWtA==
X-Gm-Message-State: AOAM533UBb/j00pDDpm7n7rQNFLSYZT6csPs+V1lma7z5aNsSVROQV/y
        TOhrzloKnmqm/qld6/J6LzRB19NXc8pEyctOwl3K+Q==
X-Google-Smtp-Source: ABdhPJxSdt1NcSb1S3ok3YdEwcV9/Jd32HM5LS8VwfQcInwVMV7qzFYMrduopZpaHLrNvp6KWrjkvSrsWwkrkUAmKzE=
X-Received: by 2002:a81:3542:: with SMTP id c63mr10841884ywa.87.1644235935664;
 Mon, 07 Feb 2022 04:12:15 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 7 Feb 2022 17:42:04 +0530
Message-ID: <CA+G9fYuYuDBWAvTzjyDOoSQfxVKLKo2a9nAnBX65DiTpGHjB8w@mail.gmail.com>
Subject: kvm-unit-tests: timed out on arm64 devices
To:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-unit-test cases running on today's linux next-20220207 fails due
to timed out error.
Reported these failures on nxp-ls2088 and bcm2711-rpi-4-b.

Output log:
TESTNAME=selftest-setup TIMEOUT=90s ACCEL= ./arm/run arm/selftest.flat
-smp 2 -m 256 -append 'setup smp=2 mem=256'
selftest-setup (timeout; duration=90s)
TESTNAME=selftest-vectors-kernel TIMEOUT=90s ACCEL= ./arm/run
arm/selftest.flat -smp 1 -append 'vectors-kernel'
selftest-vectors-kernel (timeout; duration=90s)
TESTNAME=selftest-vectors-user TIMEOUT=90s ACCEL= ./arm/run
arm/selftest.flat -smp 1 -append 'vectors-user'
selftest-vectors-user (timeout; duration=90s)
TESTNAME=selftest-smp TIMEOUT=90s ACCEL= ./arm/run arm/selftest.flat
-smp $MAX_SMP -append 'smp'
selftest-smp (timeout; duration=90s)
TESTNAME=pci-test TIMEOUT=90s ACCEL= ./arm/run arm/pci-test.flat -smp 1
pci-test (timeout; duration=90s)
TESTNAME=pmu TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1
pmu (timeout; duration=90s)
TESTNAME=gicv2-ipi TIMEOUT=90s ACCEL= ./arm/run arm/gic.flat -smp
$((($MAX_SMP < 8)?$MAX_SMP:8)) -machine gic-version=2 -append 'ipi'
gicv2-ipi (timeout; duration=90s)
TESTNAME=gicv2-mmio TIMEOUT=90s ACCEL= ./arm/run arm/gic.flat -smp
$((($MAX_SMP < 8)?$MAX_SMP:8)) -machine gic-version=2 -append 'mmio'
gicv2-mmio (timeout; duration=90s)
TESTNAME=gicv2-mmio-up TIMEOUT=90s ACCEL= ./arm/run arm/gic.flat -smp
1 -machine gic-version=2 -append 'mmio'
gicv2-mmio-up (timeout; duration=90s)
TESTNAME=gicv2-mmio-3p TIMEOUT=90s ACCEL= ./arm/run arm/gic.flat -smp
$((($MAX_SMP < 3)?$MAX_SMP:3)) -machine gic-version=2 -append 'mmio'
gicv2-mmio-3p (timeout; duration=90s)
TESTNAME=gicv3-ipi TIMEOUT=90s ACCEL= ./arm/run arm/gic.flat -smp
$MAX_SMP -machine gic-version=3 -append 'ipi'
gicv3-ipi (timeout; duration=90s)
TESTNAME=gicv2-active TIMEOUT=90s ACCEL= ./arm/run arm/gic.flat -smp
$((($MAX_SMP < 8)?$MAX_SMP:8)) -machine gic-version=2 -append 'active'
gicv2-active (timeout; duration=90s)
TESTNAME=gicv3-active TIMEOUT=90s ACCEL= ./arm/run arm/gic.flat -smp
$MAX_SMP -machine gic-version=3 -append 'active'
gicv3-active (timeout; duration=90s)
TESTNAME=psci TIMEOUT=90s ACCEL= ./arm/run arm/psci.flat -smp $MAX_SMP
psci (timeout; duration=90s)
TESTNAME=timer TIMEOUT=2s ACCEL= ./arm/run arm/timer.flat -smp 1
timer (timeout; duration=2s)
TESTNAME=micro-bench TIMEOUT=90s ACCEL=kvm ./arm/run arm/micro-bench.flat -smp 2
micro-bench (timeout; duration=90s)
TESTNAME=cache TIMEOUT=90s ACCEL= ./arm/run arm/cache.flat -smp 1
cache (timeout; duration=90s)


ref:
https://lavalab.nxp.com/scheduler/job/832149#L1429
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20220207/testrun/7807533/suite/kvm-unit-tests/test/cache/log

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
