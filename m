Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AAA7DA204
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346523AbjJ0UuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 16:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbjJ0UuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 16:50:00 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2096410CF
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a839b31a0dso32177207b3.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698439788; x=1699044588; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ojvpxtx2aV2Xt8Hg6l62FzxVHJA7YGTaVrWAGxNmS6o=;
        b=D+P5yXyPg3ZrbqNVnHi5iLvsS6UKb+Kvz+LiNqItDFI9NyY5uRPT6XkQ1PLnmN8qKo
         0P1W5JC2YnpCxaZjP6JGctx5uPPUs2Hm9Jcq0/1KwoMsYaAR38qhgfuD7pQzLyKTmt/c
         LJ0Ngrxk4nw/DhetWd42rji1b9uVPaYupLc8UXbzLD24toQtpMztvQBzHJzyGgCHQAnw
         WhKIA08RS6BYWJqb+eZVE7CrvrjKknw49Tqfj+IQlm90ZUWH64oX6HRkNqYWAJZxo1+F
         TzavwaKwYT8ftLxAoI8h78e5+MDxjE3tV9sGPipzYQHZAbiJDqmzFvWbl8aKU/SzuCit
         Ae2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698439788; x=1699044588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ojvpxtx2aV2Xt8Hg6l62FzxVHJA7YGTaVrWAGxNmS6o=;
        b=EQwTvtyXoibMv0/Lldn+7gajoFHebcumOSKN4X7EvuRhbU5RBo04ouVbASSCx+Veme
         tccqZ+oEW2n9WEvBFeGDstvquw1trJQQxIeByF0DTYh1Ivo7AB2CKadetITLIGMB3hDq
         fnTdF2igJPeVJPo3uAuymt/Mpf3oNmVo/1cWjgjt5IcMOcgkKePoLUWSzEtKMWw01gnL
         PgWEGWUBePalflceb+yTSuIyqPfKNQpi1HNLS2aApEWPniheDWdSS3wn7O3eO3oN6+CG
         J4kAF5cWkTX0OZMUpwPJebsUOx5Uf1d6qXgXI4YjFiLkhDXbeZpKw8dUAvpI/M4SvH9Z
         dihA==
X-Gm-Message-State: AOJu0Yw2roeGGS0vfQ2VYP+zQDOkMxoYCGj8KDgo5aQTdztLC5dCCF26
        /wNjacw3qeR3wD1Of5vu49VfKrAbtNg=
X-Google-Smtp-Source: AGHT+IF1vLRlyaNxV61h2dtpxOd0pPI/GiI6ZWJtmq7UmqZkhjAXHn70a29yPEb6Xyw6LFpyTFC85TQGEAg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a046:0:b0:58c:b45f:3e94 with SMTP id
 x67-20020a81a046000000b0058cb45f3e94mr72219ywg.8.1698439788736; Fri, 27 Oct
 2023 13:49:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 13:49:30 -0700
In-Reply-To: <20231027204933.3651381-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027204933.3651381-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.7
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An enhancement to help userspace deal with SEV-ES guest crashes, and cleanups
related to not being able to do "skip" emulation for SEV guests.

The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6d3:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD (2023-09-23 05:35:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.7

for you to fetch changes up to 00682995409696866fe43984c74c8688bdf8f0a5:

  KVM: SVM: Treat all "skip" emulation for SEV guests as outright failures (2023-10-04 15:08:53 -0700)

----------------------------------------------------------------
KVM SVM changes for 6.7:

 - Report KVM_EXIT_SHUTDOWN instead of EINVAL if KVM intercepts SHUTDOWN while
   running an SEV-ES guest.

 - Clean up handling "failures" when KVM detects it can't emulate the "skip"
   action for an instruction that has already been partially emulated.  Drop a
   hack in the SVM code that was fudging around the emulator code not giving
   SVM enough information to do the right thing.

----------------------------------------------------------------
Peter Gonda (1):
      KVM: SVM: Update SEV-ES shutdown intercepts with more metadata

Sean Christopherson (2):
      KVM: x86: Refactor can_emulate_instruction() return to be more expressive
      KVM: SVM: Treat all "skip" emulation for SEV guests as outright failures

 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  4 +--
 arch/x86/kvm/svm/svm.c             | 50 ++++++++++++++++----------------------
 arch/x86/kvm/vmx/vmx.c             | 12 ++++-----
 arch/x86/kvm/x86.c                 | 22 +++++++++++------
 5 files changed, 45 insertions(+), 45 deletions(-)
