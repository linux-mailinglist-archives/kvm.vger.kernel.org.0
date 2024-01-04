Return-Path: <kvm+bounces-5674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 740DE824915
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:34:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 023DA1F24F03
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BDF2D043;
	Thu,  4 Jan 2024 19:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w0X9znN1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFCA2C86B
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 19:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5eb8b6e777cso13565017b3.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 11:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704396791; x=1705001591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3odqetFnRKlvfMvvNirVfj4DpPxXj+e78Znnz7hwaYU=;
        b=w0X9znN15sI0iO8YLUDmTkaIb4dvzRjcTtLXirzHH0/RSDUdxvu5ihV89OaOh8/x4U
         cKL8CSUH+N8QrlkKjaqmXh0lXNwXeCWTMyxVq8RJmTFSBG58VVhAy1YXVEjJHmLxUvc6
         a9yZ5xD2NqVOCD4BeBoahblopHz8PFRIXd4UDPvwGKakBgwvnWErzdwODsDJTsOGizfz
         94YFFJEdGlQaWlJ5IFCVMx4BWJ14Ti10DcURZwVEBT3RjdCKp2H0/QD7fchKDlciTKUs
         nCz2c77cSW3ahyFb82ahBVPU0ltMl9BcrayIgwytZGscQM9fv808Jf2cduKFpjnkf4Bn
         widA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704396791; x=1705001591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3odqetFnRKlvfMvvNirVfj4DpPxXj+e78Znnz7hwaYU=;
        b=etIHWN9IAHKLd8du9LJ5jMbvB2gXFquJqjF1O30AVDOukG8PFZnUP7MDELg67Q6pju
         xHMcafcZsmjyFzd1BqQJFGbsfjJSvJQT8LTCD2wrFYYC4hr8DZuNn1EzYAjV2Wd1W1sN
         zWXZTPh9NrVPNnkUHJ5lICHFuIeNt24U7GsM11/ZqP7aKb7XGMZLOFjG/ck9l67XGGVV
         USI58bac+vuIt3j1GfYyCbt3cRlg2KUU8KCm+ulNCJJhpHE+2sGxHrN9m1G/HlUvRKFf
         aV5L9GCQpEt0FzaRrU35aMPZlqn9EWfaUmfuyoqwbLOEFiTo9eJFN1ls9lUFIpLJK2tC
         V6ug==
X-Gm-Message-State: AOJu0YxtHLM7ICp0ZHJSNMFPWGGrqIZMF5F4JxXxqpn7cnQJccxj4nAr
	lzVmhg8acyN/81jOKc8m42HScK5fXV7WzkZHPw==
X-Google-Smtp-Source: AGHT+IGDKsZxrf3sCThk0b/UtHyYvTZK8mYHa+XvumwDktj9b94hMRhRwc90R7W5UCtmSgmILMzmK4LoyV8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2e0e:0:b0:dbd:547e:4aac with SMTP id
 u14-20020a252e0e000000b00dbd547e4aacmr36887ybu.5.1704396791687; Thu, 04 Jan
 2024 11:33:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Jan 2024 11:32:58 -0800
In-Reply-To: <20240104193303.3175844-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240104193303.3175844-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: LAM support for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

LAM virtualization support.  FWIW, I intended to send this in early-ish
December as you've asked in the past, but December was basically a lost cause
for me in terms of doing upstream work.  :-/

The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b2f:

  selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:58:25 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-lam-6.8

for you to fetch changes up to 183bdd161c2b773a62f01d1c030f5a3a5b7c33b5:

  KVM: x86: Use KVM-governed feature framework to track "LAM enabled" (2023-11-28 17:54:09 -0800)

----------------------------------------------------------------
KVM x86 support for virtualizing Linear Address Masking (LAM)

Add KVM support for Linear Address Masking (LAM).  LAM tweaks the canonicality
checks for most virtual address usage in 64-bit mode, such that only the most
significant bit of the untranslated address bits must match the polarity of the
last translated address bit.  This allows software to use ignored, untranslated
address bits for metadata, e.g. to efficiently tag pointers for address
sanitization.

LAM can be enabled separately for user pointers and supervisor pointers, and
for userspace LAM can be select between 48-bit and 57-bit masking

 - 48-bit LAM: metadata bits 62:48, i.e. LAM width of 15.
 - 57-bit LAM: metadata bits 62:57, i.e. LAM width of 6.

For user pointers, LAM enabling utilizes two previously-reserved high bits from
CR3 (similar to how PCID_NOFLUSH uses bit 63): LAM_U48 and LAM_U57, bits 62 and
61 respectively.  Note, if LAM_57 is set, LAM_U48 is ignored, i.e.:

 - CR3.LAM_U48=0 && CR3.LAM_U57=0 == LAM disabled for user pointers
 - CR3.LAM_U48=1 && CR3.LAM_U57=0 == LAM-48 enabled for user pointers
 - CR3.LAM_U48=x && CR3.LAM_U57=1 == LAM-57 enabled for user pointers

For supervisor pointers, LAM is controlled by a single bit, CR4.LAM_SUP, with
the 48-bit versus 57-bit LAM behavior following the current paging mode, i.e.:

 - CR4.LAM_SUP=0 && CR4.LA57=x == LAM disabled for supervisor pointers
 - CR4.LAM_SUP=1 && CR4.LA57=0 == LAM-48 enabled for supervisor pointers
 - CR4.LAM_SUP=1 && CR4.LA57=1 == LAM-57 enabled for supervisor pointers

The modified LAM canonicality checks:
 - LAM_S48                : [ 1 ][ metadata ][ 1 ]
                              63               47
 - LAM_U48                : [ 0 ][ metadata ][ 0 ]
                              63               47
 - LAM_S57                : [ 1 ][ metadata ][ 1 ]
                              63               56
 - LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
                              63               56
 - LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
                              63               56..47

The bulk of KVM support for LAM is to emulate LAM's modified canonicality
checks.  The approach taken by KVM is to "fill" the metadata bits using the
highest bit of the translated address, e.g. for LAM-48, bit 47 is sign-extended
to bits 62:48.  The most significant bit, 63, is *not* modified, i.e. its value
from the raw, untagged virtual address is kept for the canonicality check. This
untagging allows

Aside from emulating LAM's canonical checks behavior, LAM has the usual KVM
touchpoints for selectable features: enumeration (CPUID.7.1:EAX.LAM[bit 26],
enabling via CR3 and CR4 bits, etc.

----------------------------------------------------------------
Binbin Wu (9):
      KVM: x86: Consolidate flags for __linearize()
      KVM: x86: Add an emulation flag for implicit system access
      KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
      KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
      KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
      KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
      KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in emulator
      KVM: x86: Untag addresses for LAM emulation where applicable
      KVM: x86: Use KVM-governed feature framework to track "LAM enabled"

Robert Hoo (3):
      KVM: x86: Virtualize LAM for supervisor pointer
      KVM: x86: Virtualize LAM for user pointer
      KVM: x86: Advertise and enable LAM (user and supervisor)

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  5 +++-
 arch/x86/kvm/cpuid.c               |  2 +-
 arch/x86/kvm/cpuid.h               | 13 +++++----
 arch/x86/kvm/emulate.c             | 27 ++++++++++---------
 arch/x86/kvm/governed_features.h   |  1 +
 arch/x86/kvm/kvm_emulate.h         |  9 +++++++
 arch/x86/kvm/mmu.h                 |  8 ++++++
 arch/x86/kvm/mmu/mmu.c             |  2 +-
 arch/x86/kvm/mmu/mmu_internal.h    |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h     |  2 +-
 arch/x86/kvm/svm/nested.c          |  4 +--
 arch/x86/kvm/vmx/nested.c          | 11 +++++---
 arch/x86/kvm/vmx/sgx.c             |  1 +
 arch/x86/kvm/vmx/vmx.c             | 55 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  2 ++
 arch/x86/kvm/x86.c                 | 18 +++++++++++--
 arch/x86/kvm/x86.h                 |  2 ++
 18 files changed, 134 insertions(+), 30 deletions(-)

