Return-Path: <kvm+bounces-1409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B217E7717
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B4A5B20D7D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3005137F;
	Fri, 10 Nov 2023 02:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vRLLea/r"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7E8ED1
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:14 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE59F449A
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da04776a869so1964010276.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582393; x=1700187193; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fieQRgDj3lOBldorrKk0xxM9dxIlyktL3ce/ZyP+uk=;
        b=vRLLea/rURSg1c12rK0HA8Ar6UTiPnaRBaDkOV4feiy6z1dPnAHMGEZCC185mKUwjw
         USf2Rp8JIiN03RAtbrJ7GRmZm5vTJAxLkK27hj/ovJHVBF584K6p1K9240YO48ZxmcRV
         uf/1RIVBl5ckrZ81XvaABWQ22AiSxc4fqtx/u7H+Eu3xTJ+mKMQg7V+fg40fIyFy61K+
         xqPBC4JaRo8f3hrJ3QzUeRE1X1Dsp7b/vW3VO0Ts3t8vkrMcsUxXO3lVw3CsTFjZrd/9
         oG6op2mrTgG0yhVR7Jh0C3SmeSUHO/B1fqI8eUAH3utrKzgru/d4KAiPWTuFkC/Rhsik
         tEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582393; x=1700187193;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+fieQRgDj3lOBldorrKk0xxM9dxIlyktL3ce/ZyP+uk=;
        b=Oyz7Wy+j/LZi+wGYqCGx2J/aCJPmVIRsCmrTDEhvMo730/gYVsDUTvi5eIh8Xkn3vo
         ZkWSnMkQdOkmtDZcwPfu6mfGPWD/b74BxcQBaQYTHvdxPC7hmVsZDvDf+sMn2/3evKdn
         XyP8WiDehZMPNjyskYtnQxsZU+I4Ot4iECSTn9hLV1/HwsCfrQOJJDpUECyqQA/xojYi
         7S9gIzKJ8PmIuCqfr2Vmp9BG2IFmugofv5y1URnx56v2HX5c8tROrrJKhegKh8zKtBC7
         zM1bUM6uBhvxPkA7hg7S3VvVNnZ+AxI3OYJpHSUjypwo/9qaXwwaeoir5MEpgclxTH1B
         XyTA==
X-Gm-Message-State: AOJu0YzYIcK+/ERUB6yMQWzQrFLcP3rp6/XXlIYpKBlDyfoG6pjbabq+
	gjyBzUVKd3/aw9SEHqfq48hktJyx2Lc=
X-Google-Smtp-Source: AGHT+IFV7CH/dCGUgods9ICtYXMvecn5bC5WpPOIUAgyUeAHi/Hs0TPU8YMvkGp7t90hneFQ08caiOqxT64=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:701:b0:d9a:6007:223a with SMTP id
 k1-20020a056902070100b00d9a6007223amr225799ybt.8.1699582392989; Thu, 09 Nov
 2023 18:13:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-1-seanjc@google.com>
Subject: [PATCH v8 00/26] KVM: x86/pmu: selftests: Fixes and new tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Another round, another new pile of fixes and tests.  My apologies for
sending so many versions of this thing, I thought v7 was going to be the
last one.  *sigh*

Fix bugs where KVM incorrectly refuses to virtualize fixed counters and
events whose encodings match unsupported arch events, and add a PMU
counters selftest to verify the behavior.

As an aside, my hope is that in the long term, we can build out the PMU
selftests and deprecate the PMU tests in KUT so that we have everything
in-kernel and in one spot.

v8: 
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

Sean Christopherson (19):
  KVM: x86/pmu: Always treat Fixed counters as available when supported
  KVM: x86/pmu: Allow programming events that match unsupported arch
    events
  KVM: x86/pmu: Remove KVM's enumeration of Intel's architectural
    encodings
  KVM: x86/pmu: Setup fixed counters' eventsel during PMU initialization
  KVM: x86/pmu: Get eventsel for fixed counters from perf
  KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC index on AMD
  KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
  KVM: x86/pmu: Disallow "fast" RDPMC for architectural Intel PMUs
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

 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   1 -
 arch/x86/kvm/pmu.c                            |   4 +-
 arch/x86/kvm/pmu.h                            |   1 -
 arch/x86/kvm/svm/pmu.c                        |  10 +-
 arch/x86/kvm/vmx/pmu_intel.c                  | 133 ++--
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/kvm_util_base.h     |   4 +
 tools/testing/selftests/kvm/include/pmu.h     |  97 +++
 .../selftests/kvm/include/x86_64/processor.h  | 148 ++++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  62 +-
 tools/testing/selftests/kvm/lib/pmu.c         |  31 +
 .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 607 ++++++++++++++++++
 .../kvm/x86_64/pmu_event_filter_test.c        | 143 ++---
 .../smaller_maxphyaddr_emulation_test.c       |   2 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  29 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   2 +-
 17 files changed, 1035 insertions(+), 256 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.42.0.869.gea05f2083d-goog


