Return-Path: <kvm+bounces-5673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E5D824914
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 596E31C22892
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B4C2CCCF;
	Thu,  4 Jan 2024 19:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mkBLyMqU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99082C84C
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 19:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbdb5c2b1beso947832276.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 11:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704396790; x=1705001590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ChQGziAearg2FbSuN54zv4ABNiqOzj/pbflw3R8trL8=;
        b=mkBLyMqU8/csF9u5xqCso1+yDXh1uzhKsCInUSX7Ah4JtNSvRTgYDoRmZO591EX/hi
         Ill+iarch4WKRGrlRkRgSvXeM5Ge0eEmEMHEGWBvu/GDQHvJAVee5vS6/ahzmO2nTekf
         QzgcA3jm0TZ53Lcctmf5ebkOREtf9ISHsZKay431stWvcAn8fpd34jld1+6HkXPWHQgj
         fo3nrYvKt9E5YIlKwMpLqURZBznr6YpVc6lJFpKG0dy8fNFA+gh9xVunpgKzT5M1KP0l
         A3LN2iogxnBql5i40v4FqLjAZvk+nKK0yF09qpETcGQh8/3lo/JdS2AQE1NLjnV2YE4A
         jzJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704396790; x=1705001590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ChQGziAearg2FbSuN54zv4ABNiqOzj/pbflw3R8trL8=;
        b=KR9wO8LyGZob5iV6mokdouo6Dc8dEaX3mZAqjz8CTBw2hZss+cYeVO39xlJHdlpsY3
         LjfoMNPiGzXWjpGa9DoP1ZYvRtuCK7e/A1yclX3NhTSs4hs/GaYXO5yQ/4SQaNZOd+0W
         tNWYHlILxWoOFcDW5xTFd1yaiiNxnHMxGEWScNAZMfJvEsHza7XXbk2abMBr57GEVO8O
         wUEgStpFw5Hxk+qCFJINDLkkByIn4Y+sp/Wry1maiBhxvPFeTHdC3cKe0cGMjGfjDG+R
         nxiUYYPn+xVt7bb3Lk98v84Mm/9ynLnZip8JDmk/l7sbpWpOPycsN6/BpP742JVT3vpn
         c+XQ==
X-Gm-Message-State: AOJu0Yx9q43X9qsb68amd0l8oWuKnZYuwVnUjonl+IhIzRLFyq6RlmaG
	pWdsab2Uq/BMCwwKD5Uz9a9uoQ7ZJvru4+z5zw==
X-Google-Smtp-Source: AGHT+IEhCnWrNEOxTcaSDRqvM7+abLds6lyALzUwtD8aEMLqhU8dcaVXZAl4O/901BueMTi4Wt/ETVG5nAU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c1:b0:dbd:b613:46a9 with SMTP id
 w1-20020a05690210c100b00dbdb61346a9mr371042ybu.5.1704396789984; Thu, 04 Jan
 2024 11:33:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Jan 2024 11:32:57 -0800
In-Reply-To: <20240104193303.3175844-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240104193303.3175844-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Hyper-V changes for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

This is essentially Vitaly's series to add CONFIG_KVM_HYPERV, along with a
one-off patch to clean up the range-based TLB flush APIs.  While it's not super
obvious that adding CONFIG_KVM_HYPERV is worth the churn, e.g. very few setups
can actually disable CONFIG_KVM_HYPERV in practice, the end result is nice and
at the very least makes it easier for non-HyperV gurus to follow along.

The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b2f:

  selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:58:25 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-hyperv-6.8

for you to fetch changes up to 017a99a966f1183e611f0b0fa6bec40160c81813:

  KVM: nSVM: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV (2023-12-07 09:35:26 -0800)

----------------------------------------------------------------
KVM x86 Hyper-V changes for 6.8:

 - Guard KVM-on-HyperV's range-based TLB flush hooks with an #ifdef on
   CONFIG_HYPERV as a minor optimization, and to self-document the code.

 - Add CONFIG_KVM_HYPERV to allow disabling KVM support for HyperV "emulation"
   at build time.

----------------------------------------------------------------
Sean Christopherson (1):
      KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks iff HYPERV!=n

Vitaly Kuznetsov (16):
      KVM: x86/xen: Remove unneeded xen context from kvm_arch when !CONFIG_KVM_XEN
      KVM: x86: Move Hyper-V partition assist page out of Hyper-V emulation context
      KVM: VMX: Split off vmx_onhyperv.{ch} from hyperv.{ch}
      KVM: x86: Introduce helper to check if auto-EOI is set in Hyper-V SynIC
      KVM: x86: Introduce helper to check if vector is set in Hyper-V SynIC
      KVM: VMX: Split off hyperv_evmcs.{ch}
      KVM: x86: Introduce helper to handle Hyper-V paravirt TLB flush requests
      KVM: nVMX: Split off helper for emulating VMCLEAR on Hyper-V eVMCS
      KVM: selftests: Make Hyper-V tests explicitly require KVM Hyper-V support
      KVM: selftests: Fix vmxon_pa == vmcs12_pa == -1ull nVMX testcase for !eVMCS
      KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h
      KVM: x86: Make Hyper-V emulation optional
      KVM: nVMX: Introduce helpers to check if Hyper-V evmptr12 is valid/set
      KVM: nVMX: Introduce accessor to get Hyper-V eVMCS pointer
      KVM: nVMX: Hide more stuff under CONFIG_KVM_HYPERV
      KVM: nSVM: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV

 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +
 arch/x86/include/asm/kvm_host.h                    |  25 +-
 arch/x86/kvm/Kconfig                               |  14 +
 arch/x86/kvm/Makefile                              |  16 +-
 arch/x86/kvm/cpuid.c                               |   6 +
 arch/x86/kvm/hyperv.h                              |  85 +++-
 arch/x86/kvm/irq.c                                 |   2 +
 arch/x86/kvm/irq_comm.c                            |   9 +-
 arch/x86/kvm/kvm_onhyperv.h                        |  20 +
 arch/x86/kvm/lapic.c                               |   5 +-
 arch/x86/kvm/mmu/mmu.c                             |  12 +-
 arch/x86/kvm/svm/hyperv.h                          |   9 +
 arch/x86/kvm/svm/nested.c                          |  30 +-
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/kvm/svm/svm_onhyperv.c                    |  10 +-
 arch/x86/kvm/vmx/hyperv.c                          | 447 ---------------------
 arch/x86/kvm/vmx/hyperv.h                          | 238 +++--------
 arch/x86/kvm/vmx/hyperv_evmcs.c                    | 315 +++++++++++++++
 arch/x86/kvm/vmx/hyperv_evmcs.h                    | 166 ++++++++
 arch/x86/kvm/vmx/nested.c                          | 149 ++++---
 arch/x86/kvm/vmx/nested.h                          |   3 +-
 arch/x86/kvm/vmx/vmx.c                             |  20 +-
 arch/x86/kvm/vmx/vmx.h                             |  12 +-
 arch/x86/kvm/vmx/vmx_onhyperv.c                    |  36 ++
 arch/x86/kvm/vmx/vmx_onhyperv.h                    | 125 ++++++
 arch/x86/kvm/vmx/vmx_ops.h                         |   2 +-
 arch/x86/kvm/x86.c                                 |  66 ++-
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |   2 +
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c  |   5 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c        |   2 +
 .../testing/selftests/kvm/x86_64/hyperv_features.c |   2 +
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c    |   2 +
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |   1 +
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c        |   2 +
 .../kvm/x86_64/vmx_set_nested_state_test.c         |  16 +-
 35 files changed, 1091 insertions(+), 767 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.c
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.h
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.c
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.h

