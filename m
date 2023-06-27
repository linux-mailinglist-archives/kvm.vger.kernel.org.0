Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2680773EFBF
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 02:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjF0AdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 20:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjF0AdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 20:33:23 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749D4173A
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b561edde47so30086495ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687826001; x=1690418001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/XyuVQXzD8M/qARM8CRFFM69l6guVTcvJ3+RsznqEQs=;
        b=NQfmlfMl0pakrOTFF8c/zOirQ0mP6KeB0PAHKzwYnxrdUBdk/IHCsvmMqZWn2xppvA
         aFcccIGnUcT1ubDa/C9E6kOhkacLTmZurTbvVjgDYpTqo4w4Bjbo3q46uDB9cYc6sfWn
         QoiCB4A2ecSgmk4KHci2Hj1bq+/aFsWJVdmw0qDG7PqoU011vgpR+kbZyZHfHAkZt2Lz
         rBvXEZoEcMh6YH8D4rfvce7ZooSQqDufUYPnsP8cWiZDzJJoHIk7Ot71l7D/umMYhvPD
         e8ahyk8RPBT6gCoZngiSdLhs8KcyvGdMPnle0CJ7b4xN6P9c3iW54bopCkUpr4lA1nMK
         54eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687826001; x=1690418001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/XyuVQXzD8M/qARM8CRFFM69l6guVTcvJ3+RsznqEQs=;
        b=jQJNR2XtcrX0nTvbmjRrphbH4mXVMfT+0bLQjiEqVSGo8Np+6wH0YNNWw4w533PiT+
         QI5vqhuuvTLRhMMcEx7dQuhFclzHEThFaAfJ2laWn6uFOyir3bNLtTl4aLkprM9JEDZZ
         h1AeOjUH0bH1DGwDVg3tHaodnJhi1vdqB53UC00hw7OZU84GTy9H9LH7NmybVcIt61OI
         flkKsOu5eCzbTNOvKpB8oJjmtyP9l8foNlzd1UZl9VzNwdNDRBxBsa/j33hiDismt9YC
         O43rsoMQhSu6FBCrv8CNR7ZlpwVT9wxlf12mnSABH0nXmbIvJ8BR2vPIcki/3IKUqs7y
         NlIA==
X-Gm-Message-State: AC+VfDwwCCRp9Rg94RDvS2vvoePb4DBaDdOpCSHsbx2Dbg4JNFe/UbqO
        efV+JLC6fjpABE+IUE1O0g6bSMdaVHA=
X-Google-Smtp-Source: ACHHUZ6/wZU8cwxAZPHPPLlezNtM7pQpIrJ/Y0rQXLCsUbzL6IquyJcAJXwmKiFWLrYGwXBGGXkJwB3Ut9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b496:b0:1ae:531f:366a with SMTP id
 y22-20020a170902b49600b001ae531f366amr1218856plr.5.1687826000967; Mon, 26 Jun
 2023 17:33:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 26 Jun 2023 17:33:04 -0700
In-Reply-To: <20230627003306.2841058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627003306.2841058-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.5
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

KVM SVM changes for 6.5.  Misc fixes and cleanups, nothing super notable.

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.5

for you to fetch changes up to 106ed2cad9f7bd803bd31a18fe7a9219b077bf95:

  KVM: SVM: WARN, but continue, if misc_cg_set_capacity() fails (2023-06-13 09:20:26 -0700)

----------------------------------------------------------------
KVM SVM changes for 6.5:

 - Drop manual TR/TSS load after VM-Exit now that KVM uses VMLOAD for host state

 - Fix a not-yet-problematic missing call to trace_kvm_exit() for VM-Exits that
   are handled in the fastpath

 - Print more descriptive information about the status of SEV and SEV-ES during
   module load

 - Assert that misc_cg_set_capacity() doesn't fail to avoid should-be-impossible
   memory leaks

----------------------------------------------------------------
Alexander Mikhalitsyn (1):
      KVM: SVM: enhance info printk's in SEV init

Mingwei Zhang (1):
      KVM: SVM: Remove TSS reloading code after VMEXIT

Sean Christopherson (2):
      KVM: SVM: Invoke trace_kvm_exit() for fastpath VM-Exits
      KVM: SVM: WARN, but continue, if misc_cg_set_capacity() fails

 arch/x86/kvm/svm/sev.c | 19 +++++++++++--------
 arch/x86/kvm/svm/svm.c | 28 ++--------------------------
 arch/x86/kvm/svm/svm.h |  1 -
 3 files changed, 13 insertions(+), 35 deletions(-)
