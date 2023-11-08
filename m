Return-Path: <kvm+bounces-1098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E497E4E04
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:31:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC6D6B2104D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878FF801;
	Wed,  8 Nov 2023 00:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZPMxqx3o"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7874D655
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:31:40 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9F310F9
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:31:39 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5af9ad9341fso86536937b3.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403499; x=1700008299; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7P2uvgy4SF2Vsxo1O1jFhHP8I0VSiu9GCBS0pSiN+9I=;
        b=ZPMxqx3oMAmJWaPs4jE+4bLs3R0RgHzNJ3eWX5BpULU7LP3zbxMz2scF4oN7UIdgLq
         6fOR5fqMua7hVjTghUO84EX1aH3t0oMPG5p3E7Pfn4RKWxcWrB6UOMNSLQ8z1EnC+31Y
         OBL2iTKk0/PcmOQyGlEmGFq8b/j+23tVzr22i4d2o+0sRZ/f3czFZ2Wt1e+w0Con3nfh
         Zoi3WOVtHodraoHbonVt9u/D6ap6a6ncXZ/0DRmauNpkk1ZF9Tf9qBUWtlHiOjCgALN3
         ArkMMpNZmblOLUsbJ0Cn36Oy3qutNByAoWiVbjLnG8tyBhPTLosA7HFTQT2rN7MpF2rL
         gOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403499; x=1700008299;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7P2uvgy4SF2Vsxo1O1jFhHP8I0VSiu9GCBS0pSiN+9I=;
        b=nAk4wp7enU/r5t5+rfG0A8ouDUDEcMSHQTRDMrsrdJVfD7vrapmzmC+cy1Hb9nfrhQ
         KvJ28LBkvn9LNQWl/MYr+0xjoiRsulnABZChMLo7+MmiqqkMJY5ITrKA/OL22usxXH7a
         erkkwbVvS32fHF0ZOEs/qE2X104FA1NNzQUsH5FXorJ5WYVC80Aorolz83lb1euD5yXL
         4dJHcPnXbInb4nMLiYl4I1BOlzTb4+w8rTlw3m0Pj1KjQFj/bcfjusxPyZO46V4smao6
         m2HgdPE7OdKLbOUFkZMLnAXL1lOf7I8LflsjYceHfESw8Mkn2rlXEltHZw1jbaTnmEQD
         7PgA==
X-Gm-Message-State: AOJu0YznUxJH4llmORELobcLht4AplJL2Af1o2bJmMNrEg3Ws28gNHFc
	hJQ4AYxpfJJ0M8r1urFweQV3+tkzAOk=
X-Google-Smtp-Source: AGHT+IHTuDc4+EPinrV5gtZxep5Vfbio+Vf4i0R/KvsNCABGXqAndJJEAJjRxmvT+aQR8GvBdhIr9yUHLMA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:eb4a:0:b0:5a7:be3f:159f with SMTP id
 u71-20020a0deb4a000000b005a7be3f159fmr4903ywe.5.1699403498941; Tue, 07 Nov
 2023 16:31:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:16 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-1-seanjc@google.com>
Subject: [PATCH v7 00/19] KVM: x86/pmu: selftests: Fixes and new tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Round 7!  Fix bugs where KVM incorrectly refuses to virtualize fixed
counters and events whose encodings match unsupported arch events, and add
a PMU counters selftest to verify

As an aside, my hope is that in the long term, we can build out the PMU
selftests and deprecate the PMU tests in KUT so that we have everything
in-kernel and in one spot.

v7:
 - Drop patches that unnecessarily sanitized supported CPUID. [Jim]
 - Purge the array of architectural event encodings. [Jim, Dapeng]
 - Clean up pmu.h to remove useless macros, and make it easier to use the
   new macros. [Jim]
 - Port more of pmu_event_filter_test.c to pmu.h macros. [Jim, Jinrong]
 - Clean up test comments and error messages. [Jim]
 - Sanity check the value provided to vcpu_set_cpuid_property(). [Jim]

v6:
 - https://lore.kernel.org/all/20231104000239.367005-1-seanjc@google.com
 - Test LLC references/misses with CFLUSH{OPT}. [Jim]
 - Make the tests play nice without PERF_CAPABILITIES. [Mingwei]
 - Don't squash eventsels that happen to match an unsupported arch event. [Kan]
 - Test PMC counters with forced emulation (don't ask how long it took me to
   figure out how to read integer module params).

v5: https://lore.kernel.org/all/20231024002633.2540714-1-seanjc@google.com
v4: https://lore.kernel.org/all/20230911114347.85882-1-cloudliang@tencent.com
v3: https://lore.kernel.org/kvm/20230814115108.45741-1-cloudliang@tencent.com

 
Jinrong Liang (7):
  KVM: selftests: Add vcpu_set_cpuid_property() to set properties
  KVM: selftests: Add pmu.h and lib/pmu.c for common PMU assets
  KVM: selftests: Test Intel PMU architectural events on gp counters
  KVM: selftests: Test Intel PMU architectural events on fixed counters
  KVM: selftests: Test consistency of CPUID with num of gp counters
  KVM: selftests: Test consistency of CPUID with num of fixed counters
  KVM: selftests: Add functional test for Intel's fixed PMU counters

Sean Christopherson (12):
  KVM: x86/pmu: Always treat Fixed counters as available when supported
  KVM: x86/pmu: Allow programming events that match unsupported arch
    events
  KVM: x86/pmu: Remove KVM's enumeration of Intel's architectural
    encodings
  KVM: x86/pmu: Setup fixed counters' eventsel during PMU initialization
  KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
  KVM: selftests: Extend {kvm,this}_pmu_has() to support fixed counters
  KVM: selftests: Expand PMU counters test to verify LLC events
  KVM: selftests: Add a helper to query if the PMU module param is
    enabled
  KVM: selftests: Add helpers to read integer module params
  KVM: selftests: Query module param to detect FEP in MSR filtering test
  KVM: selftests: Move KVM_FEP macro into common library header
  KVM: selftests: Test PMC virtualization with forced emulation

 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   1 -
 arch/x86/kvm/pmu.c                            |   1 -
 arch/x86/kvm/pmu.h                            |   1 -
 arch/x86/kvm/svm/pmu.c                        |   6 -
 arch/x86/kvm/vmx/pmu_intel.c                  | 107 +---
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/kvm_util_base.h     |   4 +
 tools/testing/selftests/kvm/include/pmu.h     |  95 +++
 .../selftests/kvm/include/x86_64/processor.h  |  82 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  62 +-
 tools/testing/selftests/kvm/lib/pmu.c         |  31 +
 .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 568 ++++++++++++++++++
 .../kvm/x86_64/pmu_event_filter_test.c        | 143 ++---
 .../smaller_maxphyaddr_emulation_test.c       |   2 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  29 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   2 +-
 17 files changed, 912 insertions(+), 239 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.42.0.869.gea05f2083d-goog


