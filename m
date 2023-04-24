Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520686ED39B
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjDXRgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjDXRgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:36:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C9C83DB
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:47 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-517bfcfe83fso2922941a12.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682357747; x=1684949747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7Y620C6tuXXPtb1+MLs9fmkWun+dPz1etWdoE7yAuNs=;
        b=m8VbZJwiMz4RiDhDBkNntFnMDCbS3QwMJCK6wE1x1J02gEv0g7KdshwEobVBWwGGJy
         9GRCg6afTSF7pwpS9UIyFpfPBjb+BDk3y8H80Y2X0Zjs/oTOG+oGpX3XGkxpadRTFvvc
         yb/9/TQ7ctZaH3/D0YLMsDtru52LsN3o3nDp8Y7CDA8gI36icJvz5ganKIFKFmeehHos
         mi9VuSUDhGoHuElm2Nl6GK87ZomloWG5ZUyOmnfhdwo/qRc43rxkJKJHjYFZYJvmPgS7
         gMzi2fU38T28YXgTGCsuQG+UY1vxj0i5kZH/W7B2HmHWUWLTDEn1xIVLUh8KZ2yfrVgl
         QynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682357747; x=1684949747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Y620C6tuXXPtb1+MLs9fmkWun+dPz1etWdoE7yAuNs=;
        b=bTXePTZeHmwSBVhoWdEMnA2FtP1HQLd53fIRjOiW0AQrJ2hFwY4OHzw/b8CbtpHUOz
         GV+fYwhMCDbxUax776kksSH8weXd3+pvgF0eL4CFJGhRxxNKiZJBo5e5EsJEDDmh5L6A
         JWDXGJhrF8f+ohsa4Z2fehmApTFRtsbk2XLocNwTJ4R51BThIJRngJ+QC7z9miLdm4pM
         TKS2X1Mr/4bV1FwW52SRHUbJnhGYxSh0FU+5aCGu1AkHomEvAX79HjhG/SU4ZlxRC0Kp
         SIBhXcmxKLP5MoUwh9M+5XYlhJm7loHm2Y5BIiCkI73gh8YVYO5M2V5yCIbrnPP66nQx
         SWQw==
X-Gm-Message-State: AAQBX9dnHvbauDSz2dZulBgCYL6kEnmDoiy+ooYhoGYXJv/f79O5FJ4Z
        auDTMDG4b/XDKnAJur8wptZfBoiOhUk=
X-Google-Smtp-Source: AKy350auYRjlO8SrWDR2U973UPHvzTlkeSmTtrDuSCl2vWxMnbVaT41iUJpQxlV/dKxxESZK3wK5XbjmwOI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:684f:b0:247:8d04:81ba with SMTP id
 e15-20020a17090a684f00b002478d0481bamr3408810pjm.8.1682357746764; Mon, 24 Apr
 2023 10:35:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Apr 2023 10:35:29 -0700
In-Reply-To: <20230424173529.2648601-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424173529.2648601-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.4
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

KVM VMX changes for 6.4.  A few cleanups and a few fixes, nothing super
interesting or urgent.  IMO, the most notable part of this pull request is
that ENCLS is actually allowed in compatibility mode. :-)

The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7:

  KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:18:07 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.4

for you to fetch changes up to 4984563823f0034d3533854c1b50e729f5191089:

  KVM: nVMX: Emulate NOPs in L2, and PAUSE if it's not intercepted (2023-04-11 09:35:49 -0700)

----------------------------------------------------------------
KVM VMX changes for 6.4:

 - Fix a bug in emulation of ENCLS in compatibility mode

 - Allow emulation of NOP and PAUSE for L2

 - Misc cleanups

----------------------------------------------------------------
Binbin Wu (1):
      KVM: VMX: Use is_64_bit_mode() to check 64-bit mode in SGX handler

Sean Christopherson (1):
      KVM: nVMX: Emulate NOPs in L2, and PAUSE if it's not intercepted

Yu Zhang (2):
      KVM: nVMX: Remove outdated comments in nested_vmx_setup_ctls_msrs()
      KVM: nVMX: Add helpers to setup VMX control msr configs

 arch/x86/kvm/vmx/nested.c | 112 ++++++++++++++++++++++++++++++----------------
 arch/x86/kvm/vmx/sgx.c    |   4 +-
 arch/x86/kvm/vmx/vmx.c    |  15 +++++++
 3 files changed, 91 insertions(+), 40 deletions(-)
