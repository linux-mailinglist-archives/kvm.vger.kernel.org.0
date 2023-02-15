Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E8069733E
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbjBOBKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbjBOBKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:10:23 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FD983F3
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:09:53 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id g12-20020a170902868c00b00199148d00f2so9961840plo.17
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/D3tWjq5EbXGfsR6lDylgRsLrovR+yglXMNG93mrjXQ=;
        b=GfjOADNQleJBV6SLlcbfQMeHdXt/RX9hIFiY3rYg69NIxEhdF2js3Tng8z6G7Xp/nT
         9eyspcQYid7406j1CMK96UheLbXpkRX/m6onKKOtGG95jKtmz7hM2n2MaqNTzaAspn9r
         V5iWLcfAS1oIiXazMw+pmmpzl9P8Oo7eo+w9FrbilEhQEwKLZ3uO72QLHYuEYgxA8YxE
         3NsqVjXqVctGAUX95wnh/xDHicr94iF/5pccDnkx4WREbeVO5xMFCHIJrxtRTlersOm+
         1gdm2RTUzbaA67UnEegDfwt3UlSYDQQSHUdXUQTBbhlLnniZRGezqPyTGsuZtJcpiwbO
         TyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/D3tWjq5EbXGfsR6lDylgRsLrovR+yglXMNG93mrjXQ=;
        b=hOnjYRk4KkkTyu/D+UCQji+4uRq5ddqyxHutoz0IlJOgiPMe3/OO7IQKKOvKV+uLAF
         tQqPC4Zb+qXmJ7DCoe6dPUJTB75fyaRK7Wh+rC1Z7qSuIE+03vTB8gUi22seRjQF22Y6
         8TW+cSGPMlUe94S6WolLcla+uZqV6vOLafPQvLwG5Tys6FRrNhW57VpgRk/ANfDVkKT1
         eL6TJGyDcfYUIHc6L4zsoarptuPQOlcX/AxpAgb2RXT6LaWYbq89e0p3/+nrPvGeJPgK
         jIlWVRyzxfz98YoSpkTurs3HpyKs8H1sDiYSjaxhEIgfAsiA/uJjg5ZLcmru35+XmzOd
         Vjeg==
X-Gm-Message-State: AO0yUKX2lD8guLzisLgrXwVDSh8BM26BOQjx7Jao2QlVvnwyIA//M+N7
        ElrtHdHhMw0u2IPF+Oo4bG77okjEcSY=
X-Google-Smtp-Source: AK7set/Svo1zA8o8HHs/0xjBmiTppRburnATrTqlyJn0pc8ICSysKVsZXnH+Lv4OQlYwKRHnbQHLOtgzeyg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5d03:0:b0:4da:a1d0:3f3f with SMTP id
 r3-20020a635d03000000b004daa1d03f3fmr60827pgb.5.1676423315470; Tue, 14 Feb
 2023 17:08:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Feb 2023 17:07:15 -0800
In-Reply-To: <20230215010718.415413-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230215010718.415413-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010718.415413-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: PMU changes for 6.3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM x86/pmu changes for 6.3.  The most noteworthy patches are two fixes that
_aren't_ in this pull request.  The arch LBRs fix came late in the cycle and
doesn't seem super urgent, not sure if it needs to go into 6.3.  Disabling vPMU
support on hybrid CPUs is much more urgent, but I want your input before
proceeding.

  https://lore.kernel.org/all/20230128001427.2548858-1-seanjc@google.com
  https://lore.kernel.org/all/20230208204230.1360502-1-seanjc@google.com

The following changes since commit 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f:

  KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init() (2023-01-24 13:00:32 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.3

for you to fetch changes up to 13738a3647368f7f600b30d241779bcd2a3ebbfd:

  perf/x86/intel: Expose EPT-friendly PEBS for SPR and future models (2023-02-01 16:42:36 -0800)

----------------------------------------------------------------
KVM x86 PMU changes for 6.3:

 - Add support for created masked events for the PMU filter to allow
   userspace to heavily restrict what events the guest can use without
   needing to create an absurd number of events

 - Clean up KVM's handling of "PMU MSRs to save", especially when vPMU
   support is disabled

 - Add PEBS support for Intel SPR

----------------------------------------------------------------
Aaron Lewis (7):
      KVM: x86/pmu: Correct the mask used in a pmu event filter lookup
      KVM: x86/pmu: Remove impossible events from the pmu event filter
      KVM: x86/pmu: prepare the pmu event filter for masked events
      KVM: x86/pmu: Introduce masked events to the pmu event filter
      KVM: selftests: Add flags when creating a pmu event filter
      KVM: selftests: Add testing for KVM_SET_PMU_EVENT_FILTER
      KVM: selftests: Test masked events in PMU filter

Like Xu (4):
      KVM: x86/pmu: Drop event_type and rename "struct kvm_event_hw_type_mapping"
      KVM: x86/pmu: Don't tell userspace to save MSRs for non-existent fixed PMCs
      KVM: x86/pmu: Add PRIR++ and PDist support for SPR and later models
      perf/x86/intel: Expose EPT-friendly PEBS for SPR and future models

Sean Christopherson (5):
      KVM: x86/pmu: Cap kvm_pmu_cap.num_counters_gp at KVM's internal max
      KVM: x86/pmu: Gate all "unimplemented MSR" prints on report_ignored_msrs
      KVM: x86/pmu: Use separate array for defining "PMU MSRs to save"
      KVM: x86/pmu: Don't tell userspace to save PMU MSRs if PMU is disabled
      KVM: x86/pmu: Provide "error" semantics for unsupported-but-known PMU MSRs

 Documentation/virt/kvm/api.rst                     |  80 ++++-
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/events/intel/ds.c                         |   4 +-
 arch/x86/include/asm/kvm_host.h                    |  15 +-
 arch/x86/include/uapi/asm/kvm.h                    |  29 ++
 arch/x86/kvm/hyperv.c                              |  10 +-
 arch/x86/kvm/pmu.c                                 | 286 +++++++++++++---
 arch/x86/kvm/pmu.h                                 |  13 +-
 arch/x86/kvm/svm/pmu.c                             |   2 +
 arch/x86/kvm/svm/svm.c                             |   5 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  23 +-
 arch/x86/kvm/vmx/vmx.c                             |   4 +-
 arch/x86/kvm/x86.c                                 | 230 +++++++------
 arch/x86/kvm/x86.h                                 |  12 +
 include/uapi/linux/kvm.h                           |   1 +
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 381 ++++++++++++++++++++-
 16 files changed, 897 insertions(+), 199 deletions(-)
