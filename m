Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015B16954D8
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 00:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjBMXjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 18:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjBMXjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 18:39:18 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A10C649
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 15:39:17 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-16cc1e43244so12838676fac.12
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 15:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ktaBt39wS4f2yCu02LIXZMFtDIQascfY8Gt2E5XTzjg=;
        b=X0tOw9s28CYugHz6ZHC9SJauJDYvMA4hKuFlOfrD5E0WFz1QQC2umxD9SSn20R/YZa
         nI4/TX/PUZel0L4U89dwKXDRmpLK0rrSB5G2rAg6gdr5o4FV9F/r6b0w0ESdxyd0lC/B
         xEODVPYz/H4EEtSD8H7IqpRtT2STmyzzIZGGxcqEF/25kGTs1ulQHCLKx+EPCigBf8Hp
         mID5u4fZ6Tv4eoa3Y3XhOk1Rcn49d2TT09s6Gms7crhHjQ/phjtgxd0BbXxU4hvp8aFQ
         IqNSWZ/uvqK/73waagT7uWflBvIn7Fc6tfhjsCPMtfYAzT3kzyYuTXqdrz0M7fSY+X7X
         W5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ktaBt39wS4f2yCu02LIXZMFtDIQascfY8Gt2E5XTzjg=;
        b=kCjCa2QYw5q68zZXAHfOYotyiqV4ZJg68co2GMB8mAoGjwql58UZy1DsAgGO4wWPRY
         VSo4Jq1crDLXusY0AseeGwpx0G7ngQ0Kkqc1GlMr2xkbmEUP8cQv2VQgoRTLlol1XT8H
         fDm0mfzmnhFBlJDPiiTTGbJ5uCvYeT7vNVCBpRGXrkn+ESHcFLLH87yZYmKCIWgoUvXJ
         hA9g82s7rHE2aYdrnm52256fuU6/4JbruUz4HE24cEdYjX600OW6Thf0drPXauu38paM
         rM2MelKbSEKS1Y0uGDXTdPIBNya/ZqzNXgCpVSODspfv+y2zRZ4QDCz9EFCqUmwys9gG
         R6NA==
X-Gm-Message-State: AO0yUKUbcxPG2lqK1Le7fGtQbGMfHDI4iWmI4wdl2/z3xcZfdrnWAqH7
        VDU+MHqytSeTmhJsHolZglHx+eZVelk2Kt9z1fua+w==
X-Google-Smtp-Source: AK7set9CsYCQgd2WdRuRBl7l0PTQ1UaPtTpAsr9EVzTsDTVe8XSr1K5UxB+YK03KvheKFGMDO+PFXKMELqjmns6Vyww=
X-Received: by 2002:a05:6871:d81:b0:16d:e8ac:8424 with SMTP id
 vi1-20020a0568710d8100b0016de8ac8424mr1202074oab.179.1676331556807; Mon, 13
 Feb 2023 15:39:16 -0800 (PST)
MIME-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 13 Feb 2023 15:39:04 -0800
Message-ID: <CAJHc60wHFHYCotv87n0rCuDLaF4k8idNpMf-J9ERRebLH=uBLQ@mail.gmail.com>
Subject: Re: [PATCH 00/13] Extend the vPMU selftest
To:     Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 10:02 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Hello,
>
> This vPMU KVM selftest series is an extension to the selftests
> introduced by Reiji Watanabe in his series aims to limit the number
> of PMCs on vCPU from userspace [1].
>
> The idea behind this series is to expand the test coverage to include
> the tests that validates actions from userspace, such as allowing or
> denying certain events via KVM_ARM_VCPU_PMU_V3_FILTER attribute, KVM's
> guarding of the PMU attributes to count EL2/EL3 events, and formal KVM
> behavior that enables PMU emulation. The last part validates the guest
> expectations of the vPMU by setting up a stress test that force-migrates
> multiple vCPUs frequently across random pCPUs in the system, thus
> ensuring KVM's management of vCPU PMU contexts correctly.
>
> Patch-1 renames the test file to be more generic.
>
> Patch-2 refactors the existing tests for plugging-in the upcoming tests
> easily.
>
> Patch-3 and 4 add helper macros and functions respectively to interact
> with the cycle counter.
>
> Patch-5 extends create_vpmu_vm() to accept an array of event filters
> as an argument that are to be applied to the VM.
>
> Patch-6 tests the KVM_ARM_VCPU_PMU_V3_FILTER attribute by scripting
> various combinations of events that are to be allowed or denied to
> the guest and verifying guest's behavior.
>
> Patch-7 adds test to validate KVM's handling of guest requests to count
> events in EL2/EL3.
>
> Patch-8 introduces the vCPU migration stress testing by validating cycle
> counter and general purpose counter's behavior across vCPU migrations.
>
> Patch-9, 10, and 11 expands the tests in patch-8 to validate
> overflow/IRQ functionality, chained events, and occupancy of all the PMU
> counters, respectively.
>
> Patch-12 extends create_vpmu_vm() to create multiple vCPUs for the VM.
>
> Patch-13 expands the stress tests for multiple vCPUs.
>
> The series has been tested on hardwares with PMUv8p1 and PMUvp5.
>
Sorry for the typo (thanks Reiji for pointing it out!). It should be
"PMUv3p1 and
PMUv3p5". And the testing was done on v6.2-rc6 + [1].

Thank you.
Raghavendra
> Thank you.
> Raghavendra
>
> [1]: https://lore.kernel.org/all/20230203040242.1792453-1-reijiw@google.com/
>
>
> Raghavendra Rao Ananta (13):
>   selftests: KVM: aarch64: Rename vpmu_counter_access.c to vpmu_test.c
>   selftests: KVM: aarch64: Refactor the vPMU counter access tests
>   tools: arm64: perf_event: Define Cycle counter enable/overflow bits
>   selftests: KVM: aarch64: Add PMU cycle counter helpers
>   selftests: KVM: aarch64: Consider PMU event filters for VM creation
>   selftests: KVM: aarch64: Add KVM PMU event filter test
>   selftests: KVM: aarch64: Add KVM EVTYPE filter PMU test
>   selftests: KVM: aarch64: Add vCPU migration test for PMU
>   selftests: KVM: aarch64: Test PMU overflow/IRQ functionality
>   selftests: KVM: aarch64: Test chained events for PMU
>   selftests: KVM: aarch64: Add PMU test to chain all the counters
>   selftests: KVM: aarch64: Add multi-vCPU support for vPMU VM creation
>   selftests: KVM: aarch64: Extend the vCPU migration test to multi-vCPUs
>
>  tools/arch/arm64/include/asm/perf_event.h     |    7 +
>  tools/testing/selftests/kvm/Makefile          |    2 +-
>  .../kvm/aarch64/vpmu_counter_access.c         |  642 -------
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 1710 +++++++++++++++++
>  4 files changed, 1718 insertions(+), 643 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
>  create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_test.c
>
> --
> 2.39.1.581.gbfd45094c4-goog
>
