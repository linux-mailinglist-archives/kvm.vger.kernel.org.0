Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3D16ED39A
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbjDXRf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjDXRfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:35:55 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D067ECF
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:45 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63b66a3275eso3243187b3a.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682357745; x=1684949745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=76M1veUu2ZcIvuewJM5+N+OX38tjJzW1eVYteDYm0tg=;
        b=SC0HejOb0FN0TL0qbH++zenxR1wt0qhcwWqh+FqeVG7e2PMKDuu/aVMiqerbJfPHaA
         cmGco+1sZ96skukcFb/u4UjOsX8QF3hCPlDZYCcJiuQm2Hwf7OXXkwWkjUw9r5UvT7rH
         4MTRZl31eatqQ3ggac/tcDyW4cDhIJADelM4elRBi4G+v2e4ptuus6hZ+7b5eKq8gMzu
         p8xyyvaklQ6VAckLCUMe2N8z7P+i7ztqpzSV8ks/FUJMsCm9pMXBUaeunCFK5E57xNxq
         iezIlyyQ9LDhTTN6aJYrOroTp3vbfgVaTW8P10XIevoc5n1I3o+QjkGmMmDMUkOQe3ud
         zoYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682357745; x=1684949745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76M1veUu2ZcIvuewJM5+N+OX38tjJzW1eVYteDYm0tg=;
        b=CRqi6mm9jOXnPVJ1rojj/aNG7FH/3g8aic7CwGwnRSzNBmio6CNDZb5NgHi7TVfZSd
         Fz/O9lg4cryoggAOZUIGjGDSxyskWubcdTo8lxRHF4aGe4uS1uHugez4N4WV5dJCuZi6
         ITg1xMWS3EZEPsFB6lACVQ4pepB2K4REwSDZa6AsOm2kJJVQAfH2tUw9RTMtUu6EOVaM
         KhPdf3NG8XgxTI9gDxdnyE12+rMuAJONXOoCe1uFtNIT6EKO1mgXiVqG+zlmNvl56h2F
         p5tc+Fu5GE/gSM3ddqcabKASKyQa6n+tdvcnLXxKCxXSTX3L3owxHJEItUrsP7xZgQex
         0Fzg==
X-Gm-Message-State: AAQBX9fXwSTZLMhTam1JedsbgJMVDyUY8Z7q72FDcE2KHKghVcj8ZWWp
        BEDQ1PC0RKvOm1ady509awzDqwYa4Rw=
X-Google-Smtp-Source: AKy350bYA2Ton8Iy0s00YutnymPh/V+vMsPInJUom0q6FMnxsLzaQiaMaZDSveyJo/tP2vsojx5MjzcyvSo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d02:b0:63b:234e:d641 with SMTP id
 fa2-20020a056a002d0200b0063b234ed641mr5817511pfb.4.1682357744922; Mon, 24 Apr
 2023 10:35:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Apr 2023 10:35:28 -0700
In-Reply-To: <20230424173529.2648601-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424173529.2648601-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.4
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

KVM SVM changes for 6.4.  The highlight, by a country mile, is support for
virtual NMIs.

The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7:

  KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:18:07 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.4

for you to fetch changes up to c0d0ce9b5a851895f34fd401c9dddc70616711a4:

  KVM: SVM: Remove a duplicate definition of VMCB_AVIC_APIC_BAR_MASK (2023-04-04 11:08:12 -0700)

----------------------------------------------------------------
KVM SVM changes for 6.4:

 - Add support for virtual NMIs

 - Fixes for edge cases related to virtual interrupts

----------------------------------------------------------------
Maxim Levitsky (2):
      KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
      KVM: SVM: add wrappers to enable/disable IRET interception

Santosh Shukla (5):
      KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting VINTR
      KVM: nSVM: Disable intercept of VINTR if saved L1 host RFLAGS.IF is 0
      KVM: SVM: Add definitions for new bits in VMCB::int_ctrl related to vNMI
      KVM: x86: Add support for SVM's Virtual NMI
      KVM: nSVM: Implement support for nested VNMI

Sean Christopherson (5):
      KVM: x86: Raise an event request when processing NMIs if an NMI is pending
      KVM: x86: Tweak the code and comment related to handling concurrent NMIs
      KVM: x86: Save/restore all NMIs when multiple NMIs are pending
      x86/cpufeatures: Redefine synthetic virtual NMI bit as AMD's "real" vNMI
      KVM: x86: Route pending NMIs from userspace through process_nmi()

Xinghui Li (1):
      KVM: SVM: Remove a duplicate definition of VMCB_AVIC_APIC_BAR_MASK

 arch/x86/include/asm/cpufeatures.h |   8 +-
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |  11 ++-
 arch/x86/include/asm/svm.h         |  10 ++-
 arch/x86/kvm/svm/nested.c          |  91 ++++++++++++++++++----
 arch/x86/kvm/svm/svm.c             | 153 ++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h             |  29 +++++++
 arch/x86/kvm/x86.c                 |  46 +++++++++--
 8 files changed, 292 insertions(+), 58 deletions(-)
