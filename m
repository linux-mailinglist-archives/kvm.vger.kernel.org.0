Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705BE697341
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbjBOBLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjBOBLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:11:10 -0500
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791B232500
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:10:48 -0800 (PST)
Received: by mail-pf1-f201.google.com with SMTP id g14-20020a056a001a0e00b005a8b6d0006eso4095280pfv.11
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zY1itVqr4NRwx33CIj1LGsSMpb+ZWU5I258av7X58K8=;
        b=KnbZJ9ztnMmXoLDmypMyjTEMmQw9Ei6RF2e56bJDB/G1D8QBlNeRlvzstamN+PggDh
         7Nl4QHQRMFqvJG2ynCc0MFaF13KKSgRpQ40wU6AFy4V4tIM6V+MeFcb18I+eZY6XpGzS
         9/IUhLjfETtXTtdoag/o9mhbJp8CobiDcPD3or0m/yxsTqeFsVsU03EqB9Dt6cbW+kS7
         GEcfri4G6DWc/lzD9VfSuvFD97fdIdMmjIMhSRSyByl8vSIDNrUBslH0ti4SyCSgbBNu
         TPWtr7wBpGUtq0RYCtd+d/FnfwDFF7BkJdqsdWtt1Isg8vUR+Q/zcxlxQlA6zeT7HGpZ
         CfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zY1itVqr4NRwx33CIj1LGsSMpb+ZWU5I258av7X58K8=;
        b=vIz6RyXwAeQD3hRVdRi/hP00PB7CrKDEMKP9dXaTQtrAIBnuZl0arf5ywFJGwzewVT
         +EcsrTEqYx6y1fn8OiR2QwjCEmIDw0iBoO9EW7HxCxj07V7nw2BqLfFpjMv5PAcaDI6N
         eQKd1Uy+g/ZlQc2Y5+Um2HYYpgFFm53cIRfF5OCTQONwIv2tkpZeDThrJUXeuIPHdaD4
         arTR4f9tJsKQ9mOGZE99uMro1unYJTy/14yC+t07NHiZC6V/6uJVrZSsXf38Seyx5yIj
         WmutLYgFctWpm5TIcbJTHaUVacpzIm7Oc51qrtxzK8pnoMKKO2a1esUxG5epzmHMNmOQ
         hYLw==
X-Gm-Message-State: AO0yUKWu4pYp2XoyXP+se7hc4IqitegBUm4bca2J0jvdVvEny/xHB/Pm
        GEO8hWXEgo8kFuO5H/IAOlNzTBCPtzI=
X-Google-Smtp-Source: AK7set88NGZtU2CwU2xi9toR/cENFmMCcO2/QwOw7MQNHg+3xa4kYNVXNscF6J3au2Ru2AMxIU25a+08uXM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:955c:0:b0:4fb:d59c:3227 with SMTP id
 t28-20020a63955c000000b004fbd59c3227mr61156pgn.9.1676423318894; Tue, 14 Feb
 2023 17:08:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Feb 2023 17:07:17 -0800
In-Reply-To: <20230215010718.415413-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230215010718.415413-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010718.415413-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM SVM changes for 6.3.  There's a fix for x2AVIC that ideally would go into
6.3, but I didn't grab as I want a Reviewed-by and/or Tested-by from someone
with x2AVIC hardware (I massaged Suravee's original patch a fair bit).

  https://lore.kernel.org/all/20230207002156.521736-1-seanjc@google.com

The following changes since commit 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f:

  KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init() (2023-01-24 13:00:32 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.3

for you to fetch changes up to f94f053aa3a5d6ff17951870483d9eb9e13de2e2:

  KVM: SVM: Fix potential overflow in SEV's send|receive_update_data() (2023-02-07 14:36:45 -0800)

----------------------------------------------------------------
KVM SVM changes for 6.3:

 - Fix a mostly benign overflow bug in SEV's send|receive_update_data()

 - Move the SVM-specific "host flags" into vcpu_svm (extracted from the
   vNMI enabling series)

 - A handful for fixes and cleanups

----------------------------------------------------------------
Anish Ghulati (1):
      KVM: SVM: Account scratch allocations used to decrypt SEV guest memory

Like Xu (1):
      KVM: svm/avic: Drop "struct kvm_x86_ops" for avic_hardware_setup()

Maxim Levitsky (4):
      KVM: nSVM: Don't sync tlb_ctl back to vmcb12 on nested VM-Exit
      KVM: x86: Move HF_GIF_MASK into "struct vcpu_svm" as "guest_gif"
      KVM: x86: Move HF_NMI_MASK and HF_IRET_MASK into "struct vcpu_svm"
      KVM: x86: Use emulator callbacks instead of duplicating "host flags"

Peter Gonda (1):
      KVM: SVM: Fix potential overflow in SEV's send|receive_update_data()

zhang songyi (1):
      KVM: SVM: remove redundant ret variable

 arch/x86/include/asm/kvm_host.h |  9 +++------
 arch/x86/kvm/emulate.c          | 11 +++++------
 arch/x86/kvm/kvm_emulate.h      |  7 ++-----
 arch/x86/kvm/smm.c              |  2 --
 arch/x86/kvm/svm/avic.c         |  2 +-
 arch/x86/kvm/svm/nested.c       |  1 -
 arch/x86/kvm/svm/sev.c          |  6 +++---
 arch/x86/kvm/svm/svm.c          | 29 +++++++++++++++--------------
 arch/x86/kvm/svm/svm.h          | 29 +++++++++++++++++++++++++----
 arch/x86/kvm/x86.c              | 14 +++++++++-----
 10 files changed, 63 insertions(+), 47 deletions(-)
