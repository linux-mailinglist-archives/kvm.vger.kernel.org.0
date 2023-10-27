Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A897DA1F8
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346595AbjJ0Utz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 16:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346544AbjJ0Utt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 16:49:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A4FD57
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9bc6447193so2066410276.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698439784; x=1699044584; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0CV1M/k92Q3xvDsogLi4g0xsgOAA/CC5ii4d683MKg=;
        b=CtvkMEikP2CIqXDhyruQ08qAT0RVSGGx25ICdO8QSDKBv2JOk+PKxIbL1FTVI/8gdo
         9dZUehrz3Ary66ADg2Ex4PRIYexOybRjAepWK3l2gAB094BOUvqQ1Ot3HQEkKz8SylbF
         3dmFmTevGZmk/j9k93r/A3atGjTY/81nWnYhLlUHuymiqcQ2yBe16SJBK97nuqhQFNfP
         JDwe+TW3xmHs+3c2hIBZoLP0oFr49561MErFATbCQdSherQ6zKDrwcuBq1PckJspJVDA
         sJ/xcF1IXv9NbADE5OUZG1LY/L+Umn3gS2tB3Zon+C1yFMeJ8eSNBIzgOjRRAL0wlhtZ
         bdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698439784; x=1699044584;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o0CV1M/k92Q3xvDsogLi4g0xsgOAA/CC5ii4d683MKg=;
        b=CauQDkNwGKT6mifLj6vobXpG/yU42rAXkGvxTljN0t5F684mGtvcVT20GQvD4gL594
         0pNLFOvYyuJ/uLi+BEwsN3JBhuH7wfvqNwcJE7v4QORjJiaInNoaJLmchGocMcMzjnAe
         zBHPpk/5MipypJK2atFA+WXuWxdiDI7GN9pbiVCjYgvinnYZ3H6gjjrpmnOROtJQdsx3
         FXz938xB92sx+OM0Jpgc+WVDRiRHBPJ7KWfINHURhg/sviWmt40wjUyFZzwjEV3+XCso
         lT8uX/KQyUjCrvDe4C7x8LkuhZNMgvmNGpYto0wemABf+rP1SSdWoDwEoldKppER8P41
         X54A==
X-Gm-Message-State: AOJu0YxKGnd3pteG12dLGNK6OYkVx8Yq4h7t7cOch3ekumyrFqr50ql9
        ePy06BE696Cmt2oAIYtQ/yd+G4U3EQQ=
X-Google-Smtp-Source: AGHT+IFyVIvU0lnC5H1qmCg8/VbkBp0uTDO3hfBWxoXiAA0R8/1nUT6MauG+rnbY1EzI1UkiRFE3Nq2R5qQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:add5:0:b0:d9a:4f4c:961b with SMTP id
 d21-20020a25add5000000b00d9a4f4c961bmr70045ybe.1.1698439784672; Fri, 27 Oct
 2023 13:49:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 13:49:28 -0700
In-Reply-To: <20231027204933.3651381-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027204933.3651381-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.7
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is mostly the first half of a series by Yan to optimize KVM's handling=
 of
guest MTRR changes for VMs with non-coherent DMA.  Yan had to put more comp=
lex
changes that actually realize the optimizations on hold, but the patches he=
re
are all nice cleanups on their own.

The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6d3=
:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux i=
nto HEAD (2023-09-23 05:35:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.7

for you to fetch changes up to 1de9992f9de0a92b6e11133aba0e2be833c11084:

  KVM: x86/mmu: Remove unnecessary =E2=80=98NULL=E2=80=99 values from sptep=
 (2023-10-18 14:34:28 -0700)

----------------------------------------------------------------
KVM x86 MMU changes for 6.7:

 - Clean up code that deals with honoring guest MTRRs when the VM has
   non-coherent DMA and host MTRRs are ignored, i.e. EPT is enabled.

 - Zap EPT entries when non-coherent DMA assignment stops/start to prevent
   using stale entries with the wrong memtype.

 - Don't ignore guest PAT for CR0.CD=3D1 && KVM_X86_QUIRK_CD_NW_CLEARED=3Dy=
, as
   there's zero reason to ignore guest PAT if the effective MTRR memtype is=
 WB.
   This will also allow for future optimizations of handling guest MTRR upd=
ates
   for VMs with non-coherent DMA and the quirk enabled.

 - Harden the fast page fault path to guard against encountering an invalid
   root when walking SPTEs.

----------------------------------------------------------------
Li zeming (1):
      KVM: x86/mmu: Remove unnecessary =E2=80=98NULL=E2=80=99 values from s=
ptep

Yan Zhao (5):
      KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
      KVM: x86/mmu: Zap SPTEs when CR0.CD is toggled iff guest MTRRs are ho=
nored
      KVM: x86/mmu: Zap SPTEs on MTRR update iff guest MTRRs are honored
      KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/stop=
s
      KVM: VMX: drop IPAT in memtype when CD=3D1 for KVM_X86_QUIRK_CD_NW_CL=
EARED

 arch/x86/kvm/mmu.h     |  7 +++++++
 arch/x86/kvm/mmu/mmu.c | 37 ++++++++++++++++++++++++++-----------
 arch/x86/kvm/mtrr.c    |  2 +-
 arch/x86/kvm/vmx/vmx.c |  9 +++------
 arch/x86/kvm/x86.c     | 21 ++++++++++++++++++---
 5 files changed, 55 insertions(+), 21 deletions(-)
