Return-Path: <kvm+bounces-547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A24647E0C72
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E74DB21546
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8182515A3;
	Sat,  4 Nov 2023 00:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U7k0fgSL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92881622
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:02:43 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2902D49
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:02:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5b59662ff67so13174817b3.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056161; x=1699660961; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1vwaM2DB2ZPo75zwBjfZLUSbsGuidXuSs+KvMaedrA=;
        b=U7k0fgSL0ChCzVSk+LY/nMNq+Fh1lR24W5eb04iaTSHxlCejo+5Re4lcDFMuCSU7iy
         YsfLB1b3okhIqrpnTwfpF5qSqU8J5krWJVWkBfCpRZgY8lXUJ0kSXOktzY8IYO9wQzFG
         ztEYUosZR7xCmzwUkLo4T6eCTXjfIhDQ1XB18mhmor4umc17CV4PcghDvADukSrKDm/g
         PhTKj4Ah+0LfLMBoVOCFgVYX5hD6HCnINRBowQclx54OfqKPX1+bpvm4Ki8NGI9BsbGV
         m+B4bHia+SVV2NY5Y/30nQnGXWmHpAqF8wQMurImoKYlm+H7vxprY+MMnsRmNVL9nFk7
         /QUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056161; x=1699660961;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n1vwaM2DB2ZPo75zwBjfZLUSbsGuidXuSs+KvMaedrA=;
        b=JORp/vIti88vOAUl91D/9ySLgCDpaGm1PGC+/XWr1Hs/Q2YE2yj6Ddvrvyed1y0qbk
         avLj/XZv0QOuZafqFjMfeVTkmz23eqbGIptN0EPqT/WG0G4+2JCUgMBfa6EEp2I/77HT
         EmH88uVqv2d0dWzexlqf4I9kqb+RWQ4vY4zD4gbMV8ouXOgG38gm6cm6yoVpenYo5GAW
         5of7uC8tHA1/hPfXYWBpMo7+PsZLafpUbe4Mf++uGEkRQn/q4V3S18K+a00wU2Ciukxf
         xY0zbQqxytT7f0b6AQeC6nu/ckcknAtkTameXIY7zPEHH9/NHfEP6uLcpvnhtzC7t+yo
         filg==
X-Gm-Message-State: AOJu0YyejwKYB5cMElMhKpdAwdIOyZhomMinUBWix1bukCq+moqsqBBT
	xwtkM/n8Itwvd3XfgZbsHiMEPPdpNHg=
X-Google-Smtp-Source: AGHT+IF5AxnhFRgiHUG2/4Rf88i9qr0QIptng+hsRGK9Hr4ht4+X+ShlIZ9uXoZYLxuZnBPC3J9BMD+v46U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3209:b0:5b8:d09e:704d with SMTP id
 ff9-20020a05690c320900b005b8d09e704dmr6284ywb.1.1699056161023; Fri, 03 Nov
 2023 17:02:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-1-seanjc@google.com>
Subject: [PATCH v6 00/20] KVM: x86/pmu: selftests: Fixes and new tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The series that just keeps on growing.  This started out as a smallish
series from Jinrong to add PMU counters test, but has now ballooned to be
fixes and tests (that to some extent do actually validate the fixes).

Except for the first patch, the fixes aren't tagged for stable as I don't
*think* there's anything particularly nasty, and it's not like KVM's vPMU
is bulletproof even with the fixes.

v6:
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

Sean Christopherson (13):
  KVM: x86/pmu: Don't allow exposing unsupported architectural events
  KVM: x86/pmu: Don't enumerate support for fixed counters KVM can't
    virtualize
  KVM: x86/pmu: Don't enumerate arch events KVM doesn't support
  KVM: x86/pmu: Always treat Fixed counters as available when supported
  KVM: x86/pmu: Allow programming events that match unsupported arch
    events
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
 arch/x86/kvm/pmu.h                            |   5 +-
 arch/x86/kvm/svm/pmu.c                        |   6 -
 arch/x86/kvm/vmx/pmu_intel.c                  |  67 ++-
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/kvm_util_base.h     |   4 +
 tools/testing/selftests/kvm/include/pmu.h     |  84 +++
 .../selftests/kvm/include/x86_64/processor.h  |  80 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  62 +-
 tools/testing/selftests/kvm/lib/pmu.c         |  28 +
 .../selftests/kvm/lib/x86_64/processor.c      |  12 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 567 ++++++++++++++++++
 .../kvm/x86_64/pmu_event_filter_test.c        |  34 +-
 .../smaller_maxphyaddr_emulation_test.c       |   2 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  29 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   2 +-
 17 files changed, 877 insertions(+), 109 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.42.0.869.gea05f2083d-goog


