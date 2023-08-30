Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A1C78D0EC
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 02:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241359AbjH3AHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 20:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241384AbjH3AGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 20:06:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562271BB
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7b9a334ccfso646999276.0
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693354009; x=1693958809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ8YNeHXsREV0hpzprjYM+6/iFlEsiLChUUSk+Lc2m0=;
        b=RZmeOhxYbmusEKMvyBXVQQJHSXRvUiyj8hGQa072NlTF1KbL28cCKs7qRCyR9JspL5
         Tl8GZZ9r27Ih+ZVakF5Lx9fl4PqZxuesHa6wm7HLYma0TFF+a2J3YCJeoZLucNOWkTfz
         Hc6gZBzIGCqD5ojfKXDzZdjt/KsZW6iwv8B268CJ/lp7hBycpsEytmzZyIS4lqP+sh4d
         waCKfJzwKX8gasmmpsfC4VLIo3+pf6KKOKcPsexrNGJdXP93l1O1coCgZ45kf/zrskA6
         rTE7A/VCom3rW+qyqeE6wkxikTqjWQkPrjEVZT3RFU5EA4KB07QmGBMlBxfCPRgUNFkC
         bEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693354009; x=1693958809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZ8YNeHXsREV0hpzprjYM+6/iFlEsiLChUUSk+Lc2m0=;
        b=JOpXHIiKHV/6PcIdwnTfyrwV2Gy/hhZc2AxwrmDBk8exHi2nQZJ7exq9dWQ4yV6ReU
         70QIiUeHB1bqOxXFHvCaKQ1aXPD1FCcJAimVV+zq6TjRnhuElNuON3Fq41AdoxAVHo2m
         X/2kDHMas2RaB96ZQmjm7SJJ4O6Is2ARJZavMUb2rTQt8oLArDyEjnzO+fFKxeHAHUiH
         DIS2JOd2zkIbujRhn6YTeyXHBw8mEHYPjT2eTlaLRIbwK3GQtk2mCTojoXbiMmrjahVs
         UgXSWDWLaRxoa2AU6gNjUhdAYZUj5xzZpMdY5Jhgx+vAG/kaJckp0TsR+WGzL1xpbryf
         pzMQ==
X-Gm-Message-State: AOJu0YyI+r7XgiQKQDa2OkxrN7ipZGyGfHAhxjpelMVkSI2/i5HzCI0x
        CjLLAofrGYl04spvr1djRbQfx885hTk=
X-Google-Smtp-Source: AGHT+IHEZae9ppdLOiBltQkqUst0SJWut/uVWEOjcRNPgCB87ODLlmwwLPLclatbGNpv7w0njJ0BjpoOWrg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d086:0:b0:d72:a54d:4ab with SMTP id
 h128-20020a25d086000000b00d72a54d04abmr33630ybg.3.1693354009662; Tue, 29 Aug
 2023 17:06:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Aug 2023 17:06:32 -0700
In-Reply-To: <20230830000633.3158416-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230830000633.3158416-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.6
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

Please pull SVM changes for 6.6.  The highlight is the addition of support for
enabling DebugSwap for SEV-ES (and later) guests, i.e. to allow SEV-ES guests
to utilize hardware breakpoints.

The SEV and SEV-ES fixes from me are a bit late to the party, but they've gotten
as much testing from -next as their going to get.

As mentioned in the "misc" pull request, there's a rather annoying conflict
between the LBR virtualization cleanups and the guest_can_use() framework.

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.6

for you to fetch changes up to 80d0f521d59e08eeaa0bc5d624da139448fb99b8:

  KVM: SVM: Require nrips support for SEV guests (and beyond) (2023-08-25 09:00:40 -0700)

----------------------------------------------------------------
KVM: x86: SVM changes for 6.6:

 - Add support for SEV-ES DebugSwap, i.e. allow SEV-ES guests to use debug
   registers and generate/handle #DBs

 - Clean up LBR virtualization code

 - Fix a bug where KVM fails to set the target pCPU during an IRTE update

 - Fix fatal bugs in SEV-ES intrahost migration

 - Fix a bug where the recent (architecturally correct) change to reinject
   #BP and skip INT3 broke SEV guests (can't decode INT3 to skip it)

----------------------------------------------------------------
Alexey Kardashevskiy (6):
      KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
      KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
      KVM: SEV-ES: explicitly disable debug
      KVM: SVM/SEV/SEV-ES: Rework intercepts
      KVM: SEV: Enable data breakpoints in SEV-ES
      KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled

Manali Shukla (1):
      KVM: SVM: correct the size of spec_ctrl field in VMCB save area

Sean Christopherson (12):
      KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment about swap types
      KVM: SVM: Don't defer NMI unblocking until next exit for SEV-ES guests
      KVM: SVM: Don't try to pointlessly single-step SEV-ES guests for NMI window
      KVM: SVM: Fix dead KVM_BUG() code in LBR MSR virtualization
      KVM: SVM: Clean up handling of LBR virtualization enabled
      KVM: SVM: Use svm_get_lbr_vmcb() helper to handle writes to DEBUGCTL
      KVM: SVM: Take and hold ir_list_lock when updating vCPU's Physical ID entry
      KVM: SVM: Set target pCPU during IRTE update if target vCPU is running
      KVM: SVM: Get source vCPUs from source VM for SEV-ES intrahost migration
      KVM: SVM: Skip VMSA init in sev_es_init_vmcb() if pointer is NULL
      KVM: SVM: Don't inject #UD if KVM attempts to skip SEV guest insn
      KVM: SVM: Require nrips support for SEV guests (and beyond)

 arch/x86/include/asm/cpufeatures.h       |   1 +
 arch/x86/include/asm/svm.h               |   5 +-
 arch/x86/kvm/svm/avic.c                  |  59 ++++++++--
 arch/x86/kvm/svm/sev.c                   | 100 ++++++++++++++---
 arch/x86/kvm/svm/svm.c                   | 179 +++++++++++++++++++------------
 arch/x86/kvm/svm/svm.h                   |  43 +-------
 tools/arch/x86/include/asm/cpufeatures.h |   1 +
 7 files changed, 252 insertions(+), 136 deletions(-)
