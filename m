Return-Path: <kvm+bounces-5675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 471CC824919
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED4A11F2341E
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAD72D625;
	Thu,  4 Jan 2024 19:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sX3wrLLs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC96E2D600
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 19:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbe9ef2422cso1183681276.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 11:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704396795; x=1705001595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0gL82psZOay2fkE6NWKDmgNyb6GicZeTgyQYLdcvkDM=;
        b=sX3wrLLsuT6j7vDEVEP1PtFuBrOTbW7VqyXVMzlPy0Oeijrug3Wz7FT0sRENFm+yuh
         PUEst8CKAsBI0KOfvr/zHxOz9MMl9aGcUhYUBPyIEDGIpaTCwHU8cd9f8arpGa7eAEI7
         dqHk3+thCy5KVMRIRLw4wPpGf4tM3hfUaljbu5nlZc0DgNddM5VhEdb1d05bguY2qWtn
         0Ke4qbiTblN6GReoDR6JmbFvOZh1BItln5A0BuZ4eFDLi6ZuRKtZhDv2NWsbhCjchlMo
         ObS4hnUtvSvDUtiwZGT60fX5gxkJ958zVdECpcU74XkXc0gM+T6rHyHRKdakWRug90bc
         Lq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704396795; x=1705001595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0gL82psZOay2fkE6NWKDmgNyb6GicZeTgyQYLdcvkDM=;
        b=Wrk3jz1FYH98Owp+L9hJE8HPXsc9d3grekjQGBfcovYl005K2h1epD2lpUwuHOhOq/
         ULGfuvq3kz5EW8qafdjCGq6Mygf9IMmHkIfDy9vcv+dhR4f/kUepyfT0r1InDcMq+hJX
         044ptBDlmaCsgbawQfkMVLmP91Qbq9p3VzHyDkd2o0TUNPHMXjFPpiD0CXz4ZQz5v4z2
         Gvb6/BOsK2HgEgYCZDEfv1Dnd/BFEbTgyaGclwL5DoLGRkcLWitvqRYLpJK3w5hK2ecI
         GB5Jz6qDeW5Fhjse/zujHrJiuhmvRRYtHbqLjq9z6aBHPOfkhQc1Sn4vAqMSW79v5EhT
         5wkg==
X-Gm-Message-State: AOJu0YxP0RQ8aeAKySxHlf2u9B9mhzLtXAH5TK8eae7d3O3S/+RX031y
	zvXL2kNV5QKosdD6hcK+E+Vhuj+7I4H4MOhu/w==
X-Google-Smtp-Source: AGHT+IHiEIv32pEw7qtAgHWDlk+hCdfXeHNfURJg05mMSlvid89DZjvpCXEgbhuK5FzQrfqkdt5Gmt7Kskc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:81ce:0:b0:dbd:b1d3:85e4 with SMTP id
 n14-20020a2581ce000000b00dbdb1d385e4mr37002ybm.1.1704396794928; Thu, 04 Jan
 2024 11:33:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Jan 2024 11:32:59 -0800
In-Reply-To: <20240104193303.3175844-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240104193303.3175844-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A variety of one-off changes...

The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b2f:

  selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:58:25 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.8

for you to fetch changes up to 15223c4f973a6120665ece9ce1ad17aec0be0e6c:

  KVM: SVM,VMX: Use %rip-relative addressing to access kvm_rebooting (2023-11-30 12:51:54 -0800)

----------------------------------------------------------------
KVM x86 misc changes for 6.8:

 - Turn off KVM_WERROR by default for all configs so that it's not
   inadvertantly enabled by non-KVM developers, which can be problematic for
   subsystems that require no regressions for W=1 builds.

 - Advertise all of the host-supported CPUID bits that enumerate IA32_SPEC_CTRL
   "features".

 - Don't force a masterclock update when a vCPU synchronizes to the current TSC
   generation, as updating the masterclock can cause kvmclock's time to "jump"
   unexpectedly, e.g. when userspace hotplugs a pre-created vCPU.

 - Use RIP-relative address to read kvm_rebooting in the VM-Enter fault paths,
   partly as a super minor optimization, but mostly to make KVM play nice with
   position independent executable builds.

----------------------------------------------------------------
Jim Mattson (2):
      KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
      KVM: x86: Use a switch statement and macros in __feature_translate()

Sean Christopherson (2):
      KVM: x86: Turn off KVM_WERROR by default for all configs
      KVM: x86: Don't unnecessarily force masterclock update on vCPU hotplug

Uros Bizjak (1):
      KVM: SVM,VMX: Use %rip-relative addressing to access kvm_rebooting

 arch/x86/kvm/Kconfig         | 14 +++++++-------
 arch/x86/kvm/cpuid.c         | 21 ++++++++++++++++++---
 arch/x86/kvm/reverse_cpuid.h | 33 ++++++++++++++++++++++-----------
 arch/x86/kvm/svm/vmenter.S   | 10 +++++-----
 arch/x86/kvm/vmx/vmenter.S   |  2 +-
 arch/x86/kvm/x86.c           | 29 ++++++++++++++++-------------
 6 files changed, 69 insertions(+), 40 deletions(-)

