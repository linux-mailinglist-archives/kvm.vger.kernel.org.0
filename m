Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47ED4944A1
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357711AbiATA32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344860AbiATA31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:29:27 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2E0C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:27 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id z3-20020a17090a468300b001b4df1f5a6eso2861302pjf.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=xGZFB5oitmoGiXBBflNxGwPgP1wyJ5Z4WqYt/VFwkiA=;
        b=NJvpYqFsz6ZeovbRKj7OmMHLCguJFKdO+CbKb/3g1hyUq1QBWmNPxKoEiNFMvKE2h4
         23dNp22ynkJzw0GeaSnDAvk5UUbNdPBvwQXqUBYQ/CBgYpTlZrUrpy0SY32ZIXuHecMF
         JyE5kd/H0UhWUzOgyK0b3WL3eOysXoSQfDqqd8aek71ToQXv1/K1GdDq7awEUqo9Gm2v
         4TpefpWZrkohuID94LHw8udTjEwocADW9JvSNJlLFz7Pb9XKhU3Nal5gNV+KaXVunLI4
         71FdQ9ZsB1Keifk9NMnzTvT2/7CUSsn2ViAP6hueKUU2jNr9qF/RmprGmwyCMVYjVnUd
         whzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=xGZFB5oitmoGiXBBflNxGwPgP1wyJ5Z4WqYt/VFwkiA=;
        b=3U0whuWMHUzNBoqlvebFv8NlT1RMAtnlFKUVxOkHvOcgugvUoTzfABdUq/RufjwFqE
         8ZCcZst99Qo3cNTaiHZGHFyz7Pb3DSj+C3jZHpq6U8NjgPHzac6Z1EuokS/9QDwmQAM9
         nbJWESF8alAwdNG+ueK7ceZsW4kJZE6aIy7dXMXXtWKxNjOAHC850IJkVSL1N93UBH6J
         barlOr/Ltl25W3t1ltP5mX0ohD+9Sq+eeiI3wGR0MZdyrK2sE2amChNa7zdCROEVGT2Y
         V8J/6pJiZLdZXtlhsgXjSazGzumUloU5YgMucb/iII76EFgOSXHwDVhUkAbgSKYu//jD
         mq6Q==
X-Gm-Message-State: AOAM531WjCYN9QrONnlaSuyNHn7kk8VLOFrQxDcoeDonbyNUnnvYgYUp
        FlCiTlF90jNJqUkUwZ9p83BtjQxq1Xg=
X-Google-Smtp-Source: ABdhPJztAmWUYS6iDZVpfxrvowC/HS88XndWtavsP2LLYhIb0NEM6yDcvuwOytOvS5eyfCLgzRmAAmIxgk0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:5f07:0:b0:4be:3e19:6c08 with SMTP id
 t7-20020a625f07000000b004be3e196c08mr33740482pfb.71.1642638566582; Wed, 19
 Jan 2022 16:29:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:29:16 +0000
Message-Id: <20220120002923.668708-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH 0/7] x86/debug: More single-step #DB tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add single-step #DB + STI/MOVSS blocking regression tests for a related
KVM bug[*].  Before adding the test (last patch), overhaul asm/debugreg.h
and clean up x86's "debug" test.

[*] https://lore.kernel.org/all/20220120000624.655815-1-seanjc@google.com

Sean Christopherson (7):
  bitops: Include stdbool.h and stddef.h as necessary
  x86/debug: Add framework for single-step #DB tests
  x86/debug: Test OUT instead of RDMSR for single-step #DB emulation
    test
  x86/debug: Run single-step #DB tests in usermode (and kernel mode)
  x86: Overhaul definitions for DR6 and DR7 bits
  x86/debug: Add single-step #DB + STI/MOVSS blocking tests
  x86/debug: Explicitly write DR6 in the H/W watchpoint + DR6.BS
    sub-test

 lib/bitops.h           |   3 +
 lib/x86/asm/debugreg.h | 125 ++++++--------
 x86/debug.c            | 384 ++++++++++++++++++++++++++++++++++-------
 x86/emulator.c         |  14 +-
 x86/vmx_tests.c        |  27 +--
 5 files changed, 405 insertions(+), 148 deletions(-)


base-commit: 92a6c9b95ab10eba66bff3ff44476ab0c015b276
-- 
2.34.1.703.g22d0c6ccf7-goog

