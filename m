Return-Path: <kvm+bounces-5919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E83EB829068
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63DA0B2567E
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E3F3E485;
	Tue,  9 Jan 2024 23:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WaCeRluF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C1B3E46A
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9a541b720aso4513482276.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841373; x=1705446173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/WTC5urPvjKbLxaXGg2R7t+1+DYebe0qdlFCKKJSgE=;
        b=WaCeRluFbpL/0ux/AR9r8PSuCGI0X59auNyPOJEtMmImz6mmZPhcKxMDSs3XploSIB
         6WhgAJjaqj95nv89urXhPp9x98MBo5jR5MO4QMVfAMS+JsH72ZFdeJqxtxOFxaXIdpP5
         m33j1heZbuWih6PQTHNMUgzG0Gy2V598Rd/HvagPklA88ojkAD7yvBFA6vNYN2lumL8d
         ZQk58uaj9E+IIxC1D7O4IquzlYh+HADpKEaC5OCyL0+XGyZo3BsTTtGARGMeC0pXukgN
         /5o9aGWZBFguOIkoE+8FuKRBSse2tsXYEKNkB0VzxS1c3IZUWONg05B0Lu1iEfoknPvn
         MMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841373; x=1705446173;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+/WTC5urPvjKbLxaXGg2R7t+1+DYebe0qdlFCKKJSgE=;
        b=nT2sGABga8NAb+VPW/Fy5lYToOBSXXu6WBDHlP2hBmM7EKSDXkrz4V3oM1E1as5Kjw
         nkhX8AgWgL9V59+M2+Irh7jTxtfUdYenY/Nwfl9bIFcpLAyMG4JouU12Jwkd9zUcd3V7
         e8S2JfGAitWMevKuzbm5vOX26fJNVTN9TXfBwk9dnRRybB1skowEIywY4jgBa26IrB6O
         zOfdIXYZlU1FdCXOvvsFay62dkvYaffPykDkwsV8zZiGwSkU4u0wm5uivIn29UG0PR51
         ZHiHRqTObg76n6HabrRmGS4w5a7udHXCbivD1fvjR9p/VaI8jGxNinYQFfBCRlpfJiLc
         01Dg==
X-Gm-Message-State: AOJu0YyKmAP57bI0q7rfJ97yPcvDjOYVfN0Bd8xO0GmA0r/AhN6vQAOa
	OPBqfiiRUZAhDjG3JqkTjAMB6AXRpCLIK8UAkw==
X-Google-Smtp-Source: AGHT+IGvVOM2zTQjgCg038sWSFcfI3KUXQfRUVzqTd8vzUPCBVk/n4JAiz6MJ8albjZh9cXk9ie4OMpoG0M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:565:b0:dbd:99af:daba with SMTP id
 a5-20020a056902056500b00dbd99afdabamr34474ybt.5.1704841372925; Tue, 09 Jan
 2024 15:02:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:20 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-1-seanjc@google.com>
Subject: [PATCH v10 00/29] KVM: x86/pmu: selftests: Fixes and new tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Knock wood, _this_ is the final of fixes and tests for PMU counters.  New
in v10 is a small refactor to treat FIXED as a value, not a flag, when
emulating RDPMC.  Everything else is the same as v9 (although rebased, but
there were no conflicts).

v10:
 - Collect review. [Dapeng]
 - Treat the FIXED type in RDPMC's ECX as a value, not a flag. [Jim]

v9:
 - https://lore.kernel.org/all/20231202000417.922113-1-seanjc@google.com
 - Collect reviews. [Dapeng, Kan]
 - Fix a 63:31 => 63:32 typo in a changelog. [Dapeng]
 - Actually check that forced emulation is enabled before trying to force
   emulation on RDPMC. [Jinrong]
 - Fix the aformentioned priority inversion issue.
 - Completely drop "support" for fast RDPMC, in quotes because KVM doesn't
   actually support RDPMC for non-architectural PMUs.  I had left the code
   in v8 because I didn't fully grok what the early emulator check was
   doing, i.e. wasn't 100% confident it was dead code.

v8:
 - https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com
 - Collect reviews. [Jim, Dapeng, Kan]
 - Tweak names for the RDPMC flags in the selftests #defines.
 - Get the event selectors used to virtualize fixed straight from perf
   instead of hardcoding the (wrong) selectors in KVM. [Kan]
 - Rename an "eventsel" field to "event" for a patch that gets blasted
   away in the end anyways. [Jim]
 - Add patches to fix RDPMC emulation and to test the behavior on Intel.
   I spot tested on AMD and spent ~30 minutes trying to squeeze in the
   bare minimum AMD support, but the PMU implementations between Intel
   and AMD are juuuust different enough to make adding AMD support non-
   trivial, and this series is already way too big.
 
v7:
 - https://lore.kernel.org/all/20231108003135.546002-1-seanjc@google.com
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

Sean Christopherson (22):
  KVM: x86/pmu: Always treat Fixed counters as available when supported
  KVM: x86/pmu: Allow programming events that match unsupported arch
    events
  KVM: x86/pmu: Remove KVM's enumeration of Intel's architectural
    encodings
  KVM: x86/pmu: Setup fixed counters' eventsel during PMU initialization
  KVM: x86/pmu: Get eventsel for fixed counters from perf
  KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC index on AMD
  KVM: x86/pmu: Prioritize VMX interception over #GP on RDPMC due to bad
    index
  KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
  KVM: x86/pmu: Disallow "fast" RDPMC for architectural Intel PMUs
  KVM: x86/pmu: Treat "fixed" PMU type in RDPMC as index as a value, not
    flag
  KVM: x86/pmu: Explicitly check for RDPMC of unsupported Intel PMC
    types
  KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
  KVM: selftests: Extend {kvm,this}_pmu_has() to support fixed counters
  KVM: selftests: Expand PMU counters test to verify LLC events
  KVM: selftests: Add a helper to query if the PMU module param is
    enabled
  KVM: selftests: Add helpers to read integer module params
  KVM: selftests: Query module param to detect FEP in MSR filtering test
  KVM: selftests: Move KVM_FEP macro into common library header
  KVM: selftests: Test PMC virtualization with forced emulation
  KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
  KVM: selftests: Add helpers for safe and safe+forced RDMSR, RDPMC, and
    XGETBV
  KVM: selftests: Extend PMU counters test to validate RDPMC after WRMSR

 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   3 +-
 arch/x86/kvm/emulate.c                        |   2 +-
 arch/x86/kvm/kvm_emulate.h                    |   2 +-
 arch/x86/kvm/pmu.c                            |  20 +-
 arch/x86/kvm/pmu.h                            |   5 +-
 arch/x86/kvm/svm/pmu.c                        |  17 +-
 arch/x86/kvm/vmx/pmu_intel.c                  | 178 +++--
 arch/x86/kvm/x86.c                            |   9 +-
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/kvm_util_base.h     |   4 +
 tools/testing/selftests/kvm/include/pmu.h     |  97 +++
 .../selftests/kvm/include/x86_64/processor.h  | 148 ++++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  62 +-
 tools/testing/selftests/kvm/lib/pmu.c         |  31 +
 .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 617 ++++++++++++++++++
 .../kvm/x86_64/pmu_event_filter_test.c        | 143 ++--
 .../smaller_maxphyaddr_emulation_test.c       |   2 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  29 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   2 +-
 20 files changed, 1097 insertions(+), 291 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c


base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.472.g3155946c3a-goog


