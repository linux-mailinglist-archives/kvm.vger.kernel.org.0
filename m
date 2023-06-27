Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C720573EFB9
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 02:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjF0AdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 20:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjF0AdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 20:33:13 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9183A1704
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-262e2cb725eso1319754a91.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687825992; x=1690417992;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOT1eVBq29ctpBpqcjsB6AdN1DKsCO5wOwoZ/06Ucb4=;
        b=fIS3s20yfONixBcqZVTh52d5brNXVLlQ3PhMNc6xcTt5atvGn5avnXxuax/3peScCc
         xf/1ChXM4EcGg7AFu7DNOvFOBma94ZaP2x7ChScneXZnM6e6/9f4RKstXJM3M3QP7uND
         Q6Vq6ZiSflSz3ePcou2Y4WcGdHqh9DHm4pdSpUJP0R0qsMlSEQO0n6KQ/xglvDRbNmDy
         +73hJTQW0SAoD29u7xGWIYVuXgmHzr/T7Ej0LJ2j11JDLXw0fjLGpB+fbDV0qozJkRhH
         xa2z+GqUKC+Pc0WW29CFBDBPa3psw+a2Y7yBE1UsLP2tVSVx3I2jPoGh72xOEuJodGht
         Y70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687825992; x=1690417992;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOT1eVBq29ctpBpqcjsB6AdN1DKsCO5wOwoZ/06Ucb4=;
        b=mDRfgBvWe1Yp8eyB7nA1Q2zMaT2I9193BltvJ1QyX+Iu/LgYE8QHisNv7665b4Rl0i
         vHUc6GRmld56NRCxByRnpdcPGHKILBNqVASdoMdkp/qoYoqoWqFiWfnaz2ORAPvNAcHW
         HB4hLmcy2SqZkAU+9qQ+726wfW98Nmal7kMckflrrDyXt8J5PNVALmNQEop/VM+iOn0w
         R4k7GLz1zGiczqC2a3XX8Nd5kBHLlI0wY81yfShcL2EOk5zWEmCwlYERQE8WaoKKQpT2
         JPOrRYlePVtZDsvcGnuWz0nqdvScKJPC5oPVlcq2RZO9f9drtZzOwKKNR6bA5U0KiKY+
         gdgA==
X-Gm-Message-State: AC+VfDy9isaWMY6ge5XrorDxa0jzt6kVROSWWQb4dGYpRTcufNNTLMPU
        BrdSa2MRrwZGFSBqdFiUqrpPs+T6Chw=
X-Google-Smtp-Source: ACHHUZ7iBe755UP9B/VetDVklT0CO8M6y0p9HvUWtujFzbQmLLSamcoNlEG9wN4nmL7c/U6Tgk9HhNcQMD0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:be13:b0:262:dcc1:5e9b with SMTP id
 a19-20020a17090abe1300b00262dcc15e9bmr1010664pjs.0.1687825991992; Mon, 26 Jun
 2023 17:33:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 26 Jun 2023 17:32:59 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627003306.2841058-1-seanjc@google.com>
Subject: [GIT PULL] KVM: Non-x86 changes for 6.5
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

Non-x86, a.k.a. generic, KVM changes for 6.5.  As will hopefully always be
the case for common changes from me, nothing particularly interesting.

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.5

for you to fetch changes up to cc77b95acf3c7d9a24204b0555fed2014f300fd5:

  kvm/eventfd: use list_for_each_entry when deassign ioeventfd (2023-06-13 14:25:39 -0700)

----------------------------------------------------------------
Common KVM changes for 6.5:

 - Fix unprotected vcpu->pid dereference via debugfs

 - Fix KVM_BUG() and KVM_BUG_ON() macros with 64-bit conditionals

 - Refactor failure path in kvm_io_bus_unregister_dev() to simplify the code

 - Misc cleanups

----------------------------------------------------------------
Binbin Wu (1):
      KVM: Fix comment for KVM_ENABLE_CAP

Michal Luczaj (2):
      KVM: Don't kfree(NULL) on kzalloc() failure in kvm_assign_ioeventfd_idx()
      KVM: Clean up kvm_vm_ioctl_create_vcpu()

Sean Christopherson (1):
      KVM: Protect vcpu->pid dereference via debugfs with RCU

Wei Wang (3):
      KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
      KVM: destruct kvm_io_device while unregistering it from kvm_io_bus
      kvm/eventfd: use list_for_each_entry when deassign ioeventfd

 include/kvm/iodev.h       |  6 ------
 include/linux/kvm_host.h  |  4 ++--
 include/uapi/linux/kvm.h  |  2 +-
 virt/kvm/coalesced_mmio.c |  9 ++-------
 virt/kvm/eventfd.c        |  8 +++-----
 virt/kvm/kvm_main.c       | 30 ++++++++++++++++++++----------
 6 files changed, 28 insertions(+), 31 deletions(-)
