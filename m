Return-Path: <kvm+bounces-1506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2357E86B4
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63E162810C7
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822603D988;
	Fri, 10 Nov 2023 23:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="28XEm44p"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95553A28D
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:55:37 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A3A3C3D
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:34 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5b053454aeeso35692027b3.0
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699660533; x=1700265333; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PY8LgwN808IydVRIyG0fx7z1NJlKrZCLfSJxMdvZJ8k=;
        b=28XEm44pIR6dQ2xTd3KRVxDuOXSQAPzkTN+G6oIvUcTpZvus8PXlXlFjBtbjtSYixA
         Xuf3lOLI+huPYrWYnBrX8MbVNHyguUykQDS/sW78EAzscQjlsbmHeacyOAwZ9Axls8Wh
         yZ/bSbAS6Wpa7mxJYG2yitNv7p4JI5GO5G1a3bbdihfvUMOQxAc5IWpxVro+LxSZTRlS
         FNIO6l5b3v0UEi/22deV6wj7LgEZK3pVq6iKlgHZFKCTW9elTiclt/GcYIy+0rP6cRjC
         b1WUTCF6AOSK2FRe/fiPE4jspkmCuKo2I0csWOLiLa65/7ce4tAzChTeKNYYq5c6auu4
         mMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660533; x=1700265333;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PY8LgwN808IydVRIyG0fx7z1NJlKrZCLfSJxMdvZJ8k=;
        b=b700+TFu+gFk9B/QNEbCYA6EHV5oJtI/iTp5T7YbVHrHVfl9PFAlXW/iDcOuSr7hEK
         URAVvrrivrpQ//Xlh97DkRXapDrTn+DjUYsgkY8Lhit8B7ADeYaJi49HqeN4yXxAIEZK
         Nb9MbCSCAFANDj7q8HLIYqqYwjo1xFEv/p5eNYPRqipti9GqxDZLqFHekJXXIKc0PuNi
         LSvIHAirFeNJXw6REZMVvs9sL+k87spffW5/hH9Zv23e4w9LbQwLBNfqbp7y5HhZIqku
         Oas5ybxNLT4v1oGsqruzsRE21UmuPbXiKH4wdVGN9VRxg0AyplljXUh7gFTTJ8GmlVet
         E1iA==
X-Gm-Message-State: AOJu0YwWmO+TA4J3s2MFOvLjknnIIGQ2fqRjPGk0TKYdyPytnj4kVK5L
	Kd4v9RL0j3whslQWeLBubk+g7HohXpI=
X-Google-Smtp-Source: AGHT+IFUT80IUQyz+DyvIJ1S3oZm0hrIuvXccKSjJSddXVOa73GAlW/yQGZGK6et3Ys0SEobeZ5TBSWMUnI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d78d:0:b0:5be:a164:5669 with SMTP id
 z135-20020a0dd78d000000b005bea1645669mr18569ywd.7.1699660533389; Fri, 10 Nov
 2023 15:55:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Nov 2023 15:55:19 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110235528.1561679-1-seanjc@google.com>
Subject: [PATCH 0/9] KVM: x86: Replace governed features with guest cpu_caps
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Replace the poorly named, confusing, and high-maintenance "governed
features" framework with a comprehensive guest cpu_caps implementation.

In short, snapshot all X86_FEATURE_* flags that KVM cares about so that
all queries against guest capabilities are "fast", e.g. don't require
manual enabling or judgment calls as to where a feature needs to be fast.

The guest_cpu_cap_* nomenclature follows the existing kvm_cpu_cap_*
except for a few (maybe just one?) cases where guest cpu_caps need APIs
that kvm_cpu_caps don't.  In theory, the similar names will make this
approach more intuitive.

Sean Christopherson (9):
  KVM: x86: Rename "governed features" helpers to use "guest_cpu_cap"
  KVM: x86: Replace guts of "goverened" features with comprehensive
    cpu_caps
  KVM: x86: Initialize guest cpu_caps based on guest CPUID
  KVM: x86: Avoid double CPUID lookup when updating MWAIT at runtime
  KVM: x86: Drop unnecessary check that cpuid_entry2_find() returns
    right leaf
  KVM: x86: Update guest cpu_caps at runtime for dynamic CPUID-based
    features
  KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
  KVM: x86: Replace all guest CPUID feature queries with cpu_caps check
  KVM: x86: Restrict XSAVE in cpu_caps based on KVM capabilities

 arch/x86/include/asm/kvm_host.h  |  40 ++++++----
 arch/x86/kvm/cpuid.c             | 102 +++++++++++++++++++-------
 arch/x86/kvm/cpuid.h             | 121 +++++++++++--------------------
 arch/x86/kvm/governed_features.h |  21 ------
 arch/x86/kvm/lapic.c             |   2 +-
 arch/x86/kvm/mmu/mmu.c           |   4 +-
 arch/x86/kvm/mtrr.c              |   2 +-
 arch/x86/kvm/reverse_cpuid.h     |  15 ----
 arch/x86/kvm/smm.c               |  10 +--
 arch/x86/kvm/svm/nested.c        |  22 +++---
 arch/x86/kvm/svm/pmu.c           |   8 +-
 arch/x86/kvm/svm/sev.c           |   4 +-
 arch/x86/kvm/svm/svm.c           |  50 ++++++-------
 arch/x86/kvm/svm/svm.h           |   4 +-
 arch/x86/kvm/vmx/nested.c        |  18 ++---
 arch/x86/kvm/vmx/pmu_intel.c     |   4 +-
 arch/x86/kvm/vmx/sgx.c           |  14 ++--
 arch/x86/kvm/vmx/vmx.c           |  63 ++++++++--------
 arch/x86/kvm/vmx/vmx.h           |   2 +-
 arch/x86/kvm/x86.c               |  72 +++++++++---------
 20 files changed, 282 insertions(+), 296 deletions(-)
 delete mode 100644 arch/x86/kvm/governed_features.h


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.42.0.869.gea05f2083d-goog


