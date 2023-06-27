Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8939173EFBD
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 02:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjF0AdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 20:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjF0AdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 20:33:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BD51709
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bfe702f99b8so5183670276.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687825997; x=1690417997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q84fPEVE13UcUIHnTQ0lagxjr3ZhE8+laam/pQBkIy4=;
        b=FOJHbUphe8Zfe9cvCbV4Qw1NcWx3w+is64aFI7rUjwkYvPdqZwv0ezfkpxrVJXx6kY
         aY7McmSQFhIInahAbo87gqjjUg04lMLZHLr6iP91964SM/TGZKPn/SCOfCXzVRTLchCN
         EQ+TcpuldCX+ynWDgRhswHxxdCKpXJ2h3RlEIoa0CIag75yiXyjIFGEANS9hY1qGYQPP
         l0Hl8+mR/P99N88c4c2v7K1B5DFGMHqBcsn6axEKHopluICDmH+Hz/gdnlOyr+IYWQFL
         f/QA5/xdKGJggnVR0m+fhTeJJbHZk+32bZTHDUGYPFHRKRNrF+eB68oEIHEdPETbF+dv
         D3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687825997; x=1690417997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q84fPEVE13UcUIHnTQ0lagxjr3ZhE8+laam/pQBkIy4=;
        b=MAyPCgO6vl2sz0YQN1SyVsMBQf8rujpRraaF/HPoyB7JphluqbOfAGhZa+6KIyjAsC
         8+gFQDpbSElIvESuC8qwJJ7h6MD7J3Z4OTHQZJ3dQt+OYume2VQSWggiSkoJKvrTiy+/
         yv+BpCAOFmryOvlad24H0sNwmsJWWnUFkvn8scYzEmNh1CTu8x9wBpnSJ9Mc+X2LePug
         a+DmbUGxxIic4NLpDL+KwpFEYqSfwNPQ19X3Jy2Mv5F+xpgmJM01fdgU7h7VenpRqwlv
         RkcHMs82e6q+MSyFPz/3OvX10d6w8pARNuEo297HQ0FyBRYIWzDBhRfcKyLDTe/YE44m
         +6Fw==
X-Gm-Message-State: AC+VfDyABpgSFQNQCf6PlaXCHdwPKjOKGueI/TpKlB26axDJg8vYp/Wm
        P2/sNMTx51sIxwLo9JInHV1gl6pOWuw=
X-Google-Smtp-Source: ACHHUZ7QsYrcwxvMeo+Tk0qSctC90KXNnywP7AgRczWLAh2oKF4jIIa/ksFnI8YyOBrWISN4v48jutxUzVA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:addb:0:b0:be3:b9a6:a6b2 with SMTP id
 d27-20020a25addb000000b00be3b9a6a6b2mr6569640ybe.9.1687825997131; Mon, 26 Jun
 2023 17:33:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 26 Jun 2023 17:33:02 -0700
In-Reply-To: <20230627003306.2841058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627003306.2841058-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: PMU changes for 6.5
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

KVM x86/pmu changes for 6.5.  The highlight is also the only line item: support
for AMD PerfMonV2. 

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.5

for you to fetch changes up to 94cdeebd82111d7b7da5bd4da053eed9e0f65d72:

  KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022 (2023-06-06 17:31:44 -0700)

----------------------------------------------------------------
KVM x86/pmu changes for 6.5:

 - Add support for AMD PerfMonV2, with a variety of cleanups and minor fixes
   included along the way

----------------------------------------------------------------
Like Xu (11):
      KVM: x86/pmu: Move reprogram_counters() to pmu.h
      KVM: x86/pmu: Reject userspace attempts to set reserved GLOBAL_STATUS bits
      KVM: x86/pmu: Move handling PERF_GLOBAL_CTRL and friends to common x86
      KVM: x86/pmu: Provide Intel PMU's pmc_is_enabled() as generic x86 code
      KVM: x86: Explicitly zero cpuid "0xa" leaf when PMU is disabled
      KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
      KVM: x86/pmu: Advertise PERFCTR_CORE iff the min nr of counters is met
      KVM: x86/pmu: Constrain the num of guest counters with kvm_pmu_cap
      KVM: x86/cpuid: Add a KVM-only leaf to redirect AMD PerfMonV2 flag
      KVM: x86/svm/pmu: Add AMD PerfMonV2 support
      KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022

Sean Christopherson (1):
      KVM: x86/pmu: Rename global_ovf_ctrl_mask to global_status_mask

 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h        |  2 +-
 arch/x86/kvm/cpuid.c                   | 30 ++++++++++-
 arch/x86/kvm/pmu.c                     | 92 +++++++++++++++++++++++++++++++---
 arch/x86/kvm/pmu.h                     | 56 +++++++++++++++++++--
 arch/x86/kvm/reverse_cpuid.h           |  7 +++
 arch/x86/kvm/svm/pmu.c                 | 68 ++++++++++++++++++-------
 arch/x86/kvm/svm/svm.c                 | 19 +++++--
 arch/x86/kvm/vmx/nested.c              |  4 +-
 arch/x86/kvm/vmx/pmu_intel.c           | 77 +++++-----------------------
 arch/x86/kvm/vmx/vmx.h                 | 12 -----
 arch/x86/kvm/x86.c                     | 10 ++++
 12 files changed, 260 insertions(+), 118 deletions(-)
