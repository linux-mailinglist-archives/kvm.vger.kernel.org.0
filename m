Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BA87DA1F6
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346518AbjJ0Utm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 16:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346498AbjJ0Utk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 16:49:40 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAB31AA
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:38 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27ff9e2ffdfso1923357a91.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698439778; x=1699044578; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=F0GgFwBHDaTkhQsg7B4id3Q1Dy4NRZ9lf/HDP2O5wKQ=;
        b=4UU0kYxJU/gcwcZtgIEeV4omjd28k7PIOCuOzCahFGPL7LFmNPf2v6+VeFoEpICQZZ
         SrugI0r2PvFe5ZkukvzebzWezH4u1X1plKCgnbjTunQi0KWqAqqTYJ1EH7a8V4vb+4oU
         w3SqS0J0++Vx0bZZIerqluwl+I145Ae/behAj8hDnDv2uIk7NKCFxEReZg3JZvf5JXlj
         4peW3aaAwqlRHCAm5XBMwxhST0P4ingyCJia9blXWI7HtTVtH4cOUgHiV4ryrPr4kXPT
         voGLGSjNFpCYmidj1xWyCQL+wv3w4tX4btyVPtetuOweyQNdGuY5vPwo227X2H1mJM+k
         apOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698439778; x=1699044578;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F0GgFwBHDaTkhQsg7B4id3Q1Dy4NRZ9lf/HDP2O5wKQ=;
        b=vQc8FUoSiuLmm0wr3zZbG2bNkRmZFwn++mRqArVKymJO+VmgNsxcvJK6qw1T2kDAEu
         mJk7B5yxgOwva12GT4umcW5FWoX+Ys2mFO061z3UHagJTc5vUgXFcn3fmTsrtUSN6R7u
         onzLeaqGGY9XYv3AVNNMyYiKxK0EXlTOz3H0LNy8xEYEMPm/LZrFfY1iM4hguwhVH2qB
         WLYhvUUOykzKarn4NRjT8mC8l1wOcDmkePI8FLHkMjDu4UJbQyTg28g2F1fq7PBXad3S
         X4Ta1NvxNsFp75Iz+HC8hswIG3LcAWij+CRujomiOXzf/FUT3Xf7Wm9n0utpAqgumeyE
         LcCg==
X-Gm-Message-State: AOJu0YyCKMsWzSTjpVFshqhJofMQ3lr8E3fNfoEiWiGMnF6/QIH1amjz
        Ehr4JSKyXB9Cl/uuPq2kvt/uHDHT6n8=
X-Google-Smtp-Source: AGHT+IHvGAQmtaofLW4fDTeQIJezLNbav66mMWrYOSqZpO65GYDrU2z5z+HQvsLGFfVloL3gqz7a5wuX1RI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fb81:b0:27d:a0b:bff with SMTP id
 cp1-20020a17090afb8100b0027d0a0b0bffmr74124pjb.2.1698439778215; Fri, 27 Oct
 2023 13:49:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 13:49:25 -0700
In-Reply-To: <20231027204933.3651381-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027204933.3651381-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: APIC changes for 6.7
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two small APIC changes for 6.7, both specific to Intel's APICv.

The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6d3:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD (2023-09-23 05:35:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-apic-6.7

for you to fetch changes up to 629d3698f6958ee6f8131ea324af794f973b12ac:

  KVM: x86: Clear bit12 of ICR after APIC-write VM-exit (2023-09-28 10:42:16 -0700)

----------------------------------------------------------------
KVM x86 APIC changes for 6.7:

 - Purge VMX's posted interrupt descriptor *before* loading APIC state when
   handling KVM_SET_LAPIC.  Purging the PID after loading APIC state results in
   lost APIC timer IRQs as the APIC timer can be armed as part of loading APIC
   state, i.e. can immediately pend an IRQ if the expiry is in the past.

 - Clear the ICR.BUSY bit when handling trap-like x2APIC writes to suppress a
   WARN due to KVM expecting the BUSY bit to be cleared when sending IPIs.

----------------------------------------------------------------
Haitao Shan (1):
      KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.

Tao Su (1):
      KVM: x86: Clear bit12 of ICR after APIC-write VM-exit

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/lapic.c               | 30 +++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.c             |  4 ++--
 4 files changed, 21 insertions(+), 15 deletions(-)
