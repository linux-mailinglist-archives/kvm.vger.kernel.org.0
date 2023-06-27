Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A379F73EFBA
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 02:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjF0AdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 20:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjF0AdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 20:33:15 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208A01709
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2631fc29e8aso4620a91.3
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687825993; x=1690417993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9uEty93gwJKN8VDP8aD+w1291hK9v1sb+FWDuU2s5ew=;
        b=r4fmz/U+sHFusCcXA5awnQmSDchZFEDU1kXtTRCZPHxRQfotxplZIz34Tb6QNh7UKR
         xI0FC6TW7jC0BfmJR0THaiFVcaOIC9YrqzLZGcYBVWy+skaUZO7yoE9/j+4J1dzwkwgP
         R0X5a7ShKqoWlD1DZgtqGnJ/yDX70C5lueJnVDBIGl6mI/k57NOI432TgX7oMHguCwPa
         63QRUENAiOgh7i2VEISi4csCN0nfeAK/HFKmrI9xC80/oTSGV6qa9AM9xpNeLxnIiU2f
         Eb41fKDt+nHAohDB0P+nSuA1vdrZiHvf2h4WRPO1j0uTXgluowvuC9yFiBufOL/f8f+G
         R9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687825993; x=1690417993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9uEty93gwJKN8VDP8aD+w1291hK9v1sb+FWDuU2s5ew=;
        b=dh1Zj99QARLT7nRpNslj+tVsfhjf1AMntrn7c7RsM9c+EpVJZ9pns6TrdyDqlGyPyT
         slvUObxLRQTt8DzS0nsqNtzEd7Mtau64Wk13glIAPiSjGPLHTmAAPVOanQlGx2uVQjUc
         HmfviHPiu9+BwmvFyxJQcRAtW0OOMdg9Hm8Nx7REcc2jNCssLjt7Ro7SunXi2MuwpVB2
         rGxLBY53VVUByl9d2VVJuAxui4GLCIA5XGcAvnW3D3EyQSQyhf3xevUkSkMiU2tizGyd
         lPKDNgvus2Tx3xkTE94c96J55STJWj5Y8dDqVUBuqLrkwhQSSGuSZHEYnKhDKEx5rgiq
         bnFQ==
X-Gm-Message-State: AC+VfDx81v/bffw0hT5SBAJGNyqOAJXmt5OyYJBlyHq6SABpCe9pg8XN
        OFF+wHxSkhJS1qLOmRdSpiFE8mOh28E=
X-Google-Smtp-Source: ACHHUZ5AA6vbDTIbmWXgMuBgN56l4KikU5VqHEoQBeuhuBj6eWFM6rKRfB+gBpPd2QRLAFJdXJZV1zBq8AY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d808:b0:263:151e:2259 with SMTP id
 a8-20020a17090ad80800b00263151e2259mr132995pjv.1.1687825993700; Mon, 26 Jun
 2023 17:33:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 26 Jun 2023 17:33:00 -0700
In-Reply-To: <20230627003306.2841058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627003306.2841058-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.5
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM x86 "misc" changes for 6.5.  The most notable change is the addition of a
maintainer handbook, both because of its content, and because there's a trivial
conflict in maintainer-handbooks.rst with an in-flight patch from the arm-soc
tree: https://lore.kernel.org/all/20230623122037.16eb8bec@canb.auug.org.au

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.5

for you to fetch changes up to 63e2f55cabedf8a7ede928f7cf3ab028af44b9e9:

  Documentation/process: Add a maintainer handbook for KVM x86 (2023-06-22 14:25:38 -0700)

----------------------------------------------------------------
KVM x86 changes for 6.5:

 - Move handling of PAT out of MTRR code and dedup SVM+VMX code

 - Fix output of PIC poll command emulation when there's an interrupt

 - Fix a longstanding bug in the reporting of the number of entries returned by
   KVM_GET_CPUID2

 - Add a maintainer's handbook to document KVM x86 processes, preferred coding
   style, testing expectations, etc.

 - Misc cleanups

----------------------------------------------------------------
Andy Shevchenko (1):
      KVM: x86: Remove PRIx* definitions as they are solely for user space

Binbin Wu (1):
      KVM: x86: Fix a typo in Documentation/virt/kvm/x86/mmu.rst

Chao Gao (1):
      KVM: x86: Correct the name for skipping VMENTER l1d flush

Jinliang Zheng (1):
      KVM: x86: Fix poll command

Ke Guo (1):
      KVM: SVM: Use kvm_pat_valid() directly instead of kvm_mtrr_valid()

Michal Luczaj (1):
      KVM: x86: Clean up: remove redundant bool conversions

Sean Christopherson (12):
      KVM: x86: Add helper to query if variable MTRR MSR is base (versus mask)
      KVM: x86: Add helper to get variable MTRR range from MSR index
      KVM: x86: Use MTRR macros to define possible MTRR MSR ranges
      KVM: x86: Move PAT MSR handling out of mtrr.c
      KVM: x86: Make kvm_mtrr_valid() static now that there are no external users
      KVM: x86: Move common handling of PAT MSR writes to kvm_set_msr_common()
      KVM: x86: Update number of entries for KVM_GET_CPUID2 on success, not failure
      KVM: selftests: Extend cpuid_test to verify KVM_GET_CPUID2 "nent" updates
      KVM: x86: Use cpu_feature_enabled() for PKU instead of #ifdef
      KVM: x86: Update comments about MSR lists exposed to userspace
      Documentation/process: Add a label for the tip tree handbook's coding style
      Documentation/process: Add a maintainer handbook for KVM x86

Wenyao Hai (1):
      KVM: VMX: Open code writing vCPU's PAT in VMX's MSR handler

 Documentation/process/maintainer-handbooks.rst  |   1 +
 Documentation/process/maintainer-kvm-x86.rst    | 390 ++++++++++++++++++++++++
 Documentation/process/maintainer-tip.rst        |   2 +
 Documentation/virt/kvm/x86/mmu.rst              |   2 +-
 MAINTAINERS                                     |   1 +
 arch/x86/kvm/cpuid.c                            |  13 +-
 arch/x86/kvm/i8259.c                            |   3 +
 arch/x86/kvm/lapic.c                            |   5 -
 arch/x86/kvm/mtrr.c                             |  64 ++--
 arch/x86/kvm/svm/svm.c                          |   9 +-
 arch/x86/kvm/vmx/vmx.c                          |  11 +-
 arch/x86/kvm/x86.c                              |  56 ++--
 arch/x86/kvm/x86.h                              |   1 -
 tools/testing/selftests/kvm/x86_64/cpuid_test.c |  21 ++
 14 files changed, 493 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/process/maintainer-kvm-x86.rst
