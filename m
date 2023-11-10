Return-Path: <kvm+bounces-1437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED6A7E7772
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:29:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E59F3281366
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BA315B9;
	Fri, 10 Nov 2023 02:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yLElYXcX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE85B10F2
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:02 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86484220
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:01 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6c4bef214a8so1167398b3a.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583341; x=1700188141; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HfG2AV9l4DNvIYr5mNq9NGMW03Ak8D0zVqYjMUY2jko=;
        b=yLElYXcXExdc69hUJM5yb8E36aVN+Zq9NW8sUDCh34M51DPkPlZNAxVuTEXEi/rzkT
         R2e5+uK+0maZM8lUXX4GOQIlOsdgDkbfL+ajDWr31FbRepDe1v5+PeXB3sQxo0f2K21f
         /mIvlJlwme7faxR2DQj0vprHjBF0TsXuaoMiKPRVjZss97zxbtrCmCE63wXbPP/OA4C4
         AS8LNyFMO0bs2yG+X+ALc7fOYTQpoCAXKCpmRatIsmULoWJnVXBeEbEd3AglinvFd3U2
         Rz4tyU2ZkNulBG8Z07BgVyVnjmSkM6wo4/xda8yVJuC3/nQBqEwtU8wK+/rpMo3oI4AS
         DvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583341; x=1700188141;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HfG2AV9l4DNvIYr5mNq9NGMW03Ak8D0zVqYjMUY2jko=;
        b=bzI27VEeaE8PMlB+GXEFflY9cQgJcF5sDes+4rSc7yFlMOGA3SNmf2JgKdEMOzqU9j
         KsZq9Ssf4K7zZZPInTD8zRPqQYjfo+AKQvDIseBpwNgxLJJctSJDTrHK4wDW1M0HOLp0
         CPV7I0N1E530RemjW8WLS9VaMHf4wGneUTX1lok7mbEdO3hj8OWGbTB9ge1Yed8ofl0P
         5nXBBXdFwDoPFJIO+t7VwbZG73lVeORU3pb86eUCLXgNKtlbEz0zA46V2/RqR54XqkPM
         6trx9fDpsRDS6jhjKjGaEfQ7+txTZsmHvHglHwivpeZSVCyDtz3in+cs8TSBY6n9kbFu
         6wFw==
X-Gm-Message-State: AOJu0Ywi+eVesR1UcSzw4Mf3qzcnAqvcy6x0OLhST2R0+qlkNdQE90G9
	3RIO/vp+PQJv1gCtgnF7vVFUwnd63mw=
X-Google-Smtp-Source: AGHT+IF6fW5n79lfgTyeHn9haHWzarKUqzgO0Kwx601m+whHs0VwKQBZrtuBHphaohv7o7nBFvSpLjqN47Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:bcf:b0:6c3:38e5:e59 with SMTP id
 x15-20020a056a000bcf00b006c338e50e59mr899954pfu.6.1699583341257; Thu, 09 Nov
 2023 18:29:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-1-seanjc@google.com>
Subject: [PATCH 00/10] KVM: x86/pmu: Optimize triggering of emulated events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Optimize code used by, or which impacts, kvm_pmu_trigger_event() to try
and make a dent in the overhead of emulating PMU events in software, which
is quite noticeable due to it kicking in anytime the guest has a vPMU and
KVM is skipping an instruction.

Note, Jim has a proposal/idea[*] (that I supported) to make
kvm_pmu_trigger_event() even more performant.  I opted not to do that as
it's a bit more invasive, and I started chewing on this not so much because
I care _that_ much about performance, but because it irritates me that the
PMU code makes things way harder than they need to be.

Note #2, this applies on top of my other two PMU series:

  https://lore.kernel.org/all/20231103230541.352265-1-seanjc@google.com
  https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com

Those series fix actual functional issues, i.e. I'll definitely apply them
first (there's definitely no rush on this one).

[*] https://lore.kernel.org/all/CALMp9eQGqqo66fQGwFJMc3y+9XdUrL7ageE8kvoAOV6NJGfJpw@mail.gmail.com

Sean Christopherson (10):
  KVM: x86/pmu: Zero out PMU metadata on AMD if PMU is disabled
  KVM: x86/pmu: Add common define to capture fixed counters offset
  KVM: x86/pmu: Move pmc_idx => pmc translation helper to common code
  KVM: x86/pmu: Snapshot and clear reprogramming bitmap before
    reprogramming
  KVM: x86/pmu: Add macros to iterate over all PMCs given a bitmap
  KVM: x86/pmu: Process only enabled PMCs when emulating events in
    software
  KVM: x86/pmu: Snapshot event selectors that KVM emulates in software
  KVM: x86/pmu: Expand the comment about what bits are check emulating
    events
  KVM: x86/pmu: Check eventsel first when emulating (branch) insns
    retired
  KVM: x86/pmu: Avoid CPL lookup if PMC enabline for USER and KERNEL is
    the same

 arch/x86/include/asm/kvm-x86-pmu-ops.h |   1 -
 arch/x86/include/asm/kvm_host.h        |   1 +
 arch/x86/kvm/pmu.c                     | 143 +++++++++++++++----------
 arch/x86/kvm/pmu.h                     |  52 ++++++++-
 arch/x86/kvm/svm/pmu.c                 |   7 +-
 arch/x86/kvm/vmx/nested.c              |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c           |  44 ++------
 arch/x86/kvm/x86.c                     |   6 +-
 8 files changed, 154 insertions(+), 102 deletions(-)


base-commit: ef1883475d4a24d8eaebb84175ed46206a688103
-- 
2.42.0.869.gea05f2083d-goog


