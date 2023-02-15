Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314EF69733B
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbjBOBKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbjBOBKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:10:14 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECA032E54
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:09:46 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id p4-20020a654904000000b004fb64e929f2so4525465pgs.7
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=STtDYSq7UiUXzOCBqRab4Q4AQWbi7x0jTuvKHVDqDkg=;
        b=ptq2vIQ3RFq+k9L0Aa17O2TOm73bfXj6Ykgq2yAaSBam4tGNoat1Afv5/uSvq8Keo/
         eYRUcoh3E8maVMINqxVTPgtGfif+ICZf7mItSnSRaPmF4cNvkMpyWZ49ZqZb0pu4ltuI
         StmT+RjECmP1WuP4sgSCkkuSvqawtEwluvbqhNVwTc/D4OPAFvctXWQFGR602oDXJS3K
         LGAb2WHq7xBV0NBLAO4mFmzo7JbIaTI7fmZo+rJC58jzsdLqcF7bqU4KCUxybBmIO7GB
         9q9pLv3wzROXlTiFiee5mtv0498ASuj6TNsj8tGux8OnqPK+ifimBRJJyoDzTjOEYgDf
         TXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=STtDYSq7UiUXzOCBqRab4Q4AQWbi7x0jTuvKHVDqDkg=;
        b=UuVnq5Gh6dczANuQtM93WZg6CbhpwDFRy6SlFphTyAlgGRqwhLPXFN6I1gsOBp6/7P
         ADvAeJ0rSVT4EmbbWNRlvZE5e1LRKUPKStppgS52mMKR6/k+fzayGrC952iwyVOmPkD3
         bPCDKSPG8yzxwV9ovtjfHNrJ27hqTXib2sjfBZVQ1nwyEct/fEbc96wVz8XYhIzIWHVP
         dZg+arZ8O6xI/YqdoTv/sqTZWZqnMkXwrqquahuY9Ry3uGt6dGPMoVjCYYuXaIH7jpc5
         deqDHPayNzTHJV9gxqLDh+uYyjxqtYLkKA0ucIHOOKeuQGkXB7xckxqoMUqv5jNZyRh8
         Z3GA==
X-Gm-Message-State: AO0yUKUHeAaDvppK26hUdGqLAidqtn046tTRbiak8ZbR1Fru2RUrszcn
        UwADAh1ZHeLdIxId/i+JFTOrpfbhFdY=
X-Google-Smtp-Source: AK7set/UkgdFWYRfCBD/VB0GG/xTdo3TFBieRpqYnbC0clmT7xVccNpQhOteLn7FzjdgaPwFyyhCspqsFP8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9842:0:b0:5a8:91d2:7bb with SMTP id
 n2-20020aa79842000000b005a891d207bbmr13528pfq.53.1676423310207; Tue, 14 Feb
 2023 17:08:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Feb 2023 17:07:12 -0800
In-Reply-To: <20230215010718.415413-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230215010718.415413-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010718.415413-2-seanjc@google.com>
Subject: [GIT PULL] KVM: Non-x86 changes for 6.3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Non-x86, a.k.a. generic, KVM changes for 6.3.  Mostly trivial patches, the most
interesting is the coalesced MMIO fix.  Wei's cleanup[1] for the device buses
proved to be less trivial than originally thought, so I opted to get the basic
fix landed before doing the cleanup.

Note!  There are two KVM-wide patches[2][3] that I didn't grab, but that can
probably go into 6.3, especially the one from Paul.

[1] https://lore.kernel.org/all/20230207123713.3905-1-wei.w.wang@intel.com
[2] https://lore.kernel.org/all/20230118035629.GT2948950@paulmck-ThinkPad-P17-Gen-1
[3] https://lore.kernel.org/all/20221229123338.4142-1-wei.w.wang@intel.com

The following changes since commit 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f:

  KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init() (2023-01-24 13:00:32 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.3

for you to fetch changes up to 5bad5d55d884d57acba92a3309cde4cbb26dfefc:

  KVM: update code comment in struct kvm_vcpu (2023-02-07 17:58:19 -0800)

----------------------------------------------------------------
Common KVM changes for 6.3:

 - Account allocations in generic kvm_arch_alloc_vm()

 - Fix a typo and a stale comment

 - Fix a memory leak if coalesced MMIO unregistration fails

----------------------------------------------------------------
Alexey Dobriyan (1):
      KVM: account allocation in generic version of kvm_arch_alloc_vm()

Sean Christopherson (1):
      KVM: Destroy target device if coalesced MMIO unregistration fails

Wang Liang (1):
      kvm_host.h: fix spelling typo in function declaration

Wang Yong (1):
      KVM: update code comment in struct kvm_vcpu

 include/linux/kvm_host.h  | 6 +++---
 virt/kvm/coalesced_mmio.c | 8 +++++---
 2 files changed, 8 insertions(+), 6 deletions(-)
