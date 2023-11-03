Return-Path: <kvm+bounces-535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 538597E0BDA
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 837A31C2110A
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6469A250EF;
	Fri,  3 Nov 2023 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RKqc6eDX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDC424A15
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 23:05:46 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE074D73
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 16:05:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5b3715f3b41so34841567b3.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 16:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699052744; x=1699657544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DEfjFh44NmfiqSsnTU+vPV5C1Ip8OtIT4vR69i+9ITE=;
        b=RKqc6eDX2SdkS4IAXyxsVP5uyHSFrqCn504HqK2Q9x74/0/bq4uYAgZ1VTGPS+xCt5
         okpVbhKtNCLyeaDsIiVQoQugYdYqEhZxTFN8sAS17f3KendUwVBx0uajTIGlqlMvsT9g
         xRvKdamt7Vu5uU2HjMEczbxWya8LWewblmvNdmmzcQ0VQMENf2BbfcB2fOmif/Bc5zix
         4XL/Y82V1aydNOlG9lVATHcmxsln1Cgk/evPJKvzeOWe+ea7aXJJkvSuotgecVPRIYhB
         tZ/NtXB9AXVD1h9oylQrAvx3CFStuDMPty6piDVULoGvxShxYjkGO5Kx9OpzUY+BPvUu
         H5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699052744; x=1699657544;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DEfjFh44NmfiqSsnTU+vPV5C1Ip8OtIT4vR69i+9ITE=;
        b=NcB/65uXEA/2axVOj7UwRohRhsX6d6FS81UrIR7ZuxzqdDtfDjbwsg6vT/mXLr7m2W
         T+Img3QuKN/Xoi2nTqT14injMwznEluyZvsCx3BDtemH8NIK2+3VlrQiaJrxJ38wibTh
         5WZK21NiYIi0b3ocPmiCFE5JWDkiInaUTanipgppwTBPpctw5ZSgM71XGti2v6Qf0Auf
         gqt5lqcdSsUr6u1ugBaPr0VaXxEpsBtvyUgSwenOhXaUB5TFEFmsUcvs4IIQKiRclT4X
         dYgbpWWblKK00b4lhVnBjrzID0U6zNHMZka926uFTeEM0eNgDYUNBTHdvUL6VVZwqA40
         UzqQ==
X-Gm-Message-State: AOJu0Yw4T2+cpxK506tGZS9c/0wkxRAK1UBL3noFeMa+hGuse2Dbfons
	UIDa4bMhfEqEvY+aLSjGCcNPFON0s44=
X-Google-Smtp-Source: AGHT+IHq92zkFtQr6pUqAXNv5xuFcW/QuhURF5kl3POGKy2n8bFZrmBZRBlxSK9AesUH9GJsJZrHtBHQM6Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d785:0:b0:592:7a39:e4b4 with SMTP id
 z127-20020a0dd785000000b005927a39e4b4mr82946ywd.6.1699052743920; Fri, 03 Nov
 2023 16:05:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 16:05:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103230541.352265-1-seanjc@google.com>
Subject: [PATCH v2 0/6] KVM: x86/pmu: Clean up emulated PMC event handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

The ultimate goal of this series is to track emulated counter events using
a dedicated variable instead of trying to track the previous counter value.
Tracking the previous counter value is flawed as it takes a snapshot at
every emulated event, but only checks for overflow prior to VM-Enter, i.e.
KVM could miss an overflow if KVM ever supports emulating event types that
can occur multiple times in a single VM-Exit.

And as Mingwei root caused, emulating overflow while the perf event is
running can result in duplicate overflow events, e.g. if the perf event
overflows between taking and checking the snapshot.  This bug is largely
masked now that KVM correctly sets LVT_MASK when delivering PMIs, but it's
still a bug, e.g. could cause problems if there are other side effects.

Patches 1-5 are (some loosely, some tightly) related fixes and cleanups to
simplify the emulated counter approach implementation.  The fixes are
tagged for stable as usersepace could cause some weirdness around perf
events, but I doubt any real world VMM is actually affected.

Dapeng, I intentionally omitted your Reviewed-by from the last patch as
the change from v1 isn't trivial.

v2:
 - Collect reviews. [Dapeng]
 - Emulate overflow *after* pausing perf event. [Mingwei]

v1: https://lore.kernel.org/all/20231023234000.2499267-1-seanjc@google.com

Sean Christopherson (6):
  KVM: x86/pmu: Move PMU reset logic to common x86 code
  KVM: x86/pmu: Reset the PMU, i.e. stop counters, before refreshing
  KVM: x86/pmu: Stop calling kvm_pmu_reset() at RESET (it's redundant)
  KVM: x86/pmu: Remove manual clearing of fields in kvm_pmu_init()
  KVM: x86/pmu: Update sample period in pmc_write_counter()
  KVM: x86/pmu: Track emulated counter events instead of previous
    counter

 arch/x86/include/asm/kvm-x86-pmu-ops.h |   2 +-
 arch/x86/include/asm/kvm_host.h        |  17 ++-
 arch/x86/kvm/pmu.c                     | 140 +++++++++++++++++++++----
 arch/x86/kvm/pmu.h                     |  47 +--------
 arch/x86/kvm/svm/pmu.c                 |  17 ---
 arch/x86/kvm/vmx/pmu_intel.c           |  22 ----
 arch/x86/kvm/x86.c                     |   1 -
 7 files changed, 137 insertions(+), 109 deletions(-)


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.42.0.869.gea05f2083d-goog


