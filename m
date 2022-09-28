Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828ED5EEA59
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiI1X4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiI1X4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:56:31 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8E110C7AB
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:56:31 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b5so13607357pgb.6
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=voWIOlvE6xY6pJCYliBMURGrAJOoVflZKd2yIzLEPnA=;
        b=JCkmzE9taWz2PO23dHyQ1cN/jZXIjeBFxF5nl4dSI7GO8isbyDtQm8D+JXh7uB3axx
         ue053OVGVgL4x7xIoU9mCQrF9ule+zudwLtemwLKCMpvzb/lp99+lJPpjxXrxPMVc/HY
         DvOTyigoAlRjpkgm4gABxmS0yEcULZBZS2/zzgUyZ8QlGPlJBptSVUm1kRsRCrgFBB8D
         K7aQu1DlpROc3ciAHlpR+KiRV04iE8FRBqWEVEuMBwX98+hJ/kgzB7gLK8rn0tuxqckV
         4Gcx5Uh3JxhYId64vwN/ES2H3ZbvkDjCopcUUrig6Lqgu4QkN8eky2sVky1v+ws2rLqp
         nq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=voWIOlvE6xY6pJCYliBMURGrAJOoVflZKd2yIzLEPnA=;
        b=DB46iHykiV02SA7aGvrI8YhahUpaCvjesT9scyR2UYaXCt6HJmPiTXT2MUEcx+hsHd
         y/O3hYaf/5cGEsJ1myfEFu9yPqD+ihqxjwck3PjcfacqGzDyLuDLICWxHaEsTAGQN33p
         gVsZIdAkj26HhkyrohFC8xszNLCoqg0jkBLkEC32BKOCSgEID+LaJVefmlamOlEASRRR
         7wmQLTy4Jg4gKt3bo5xQZj3uF5BMbJKu/E6NWPof3f7O68kCA9wzrSZ8KqVUBLD4gtaG
         Ajjw722Utmxa2gDrc2mKlYGaP/FqXEgBHy0FQI8lHQYXslwqz2AW0PllD8k9/bPF8nsK
         25rw==
X-Gm-Message-State: ACrzQf0+Yt9QWiRUleeb1WEMb4gf5jGpANupPF1ceW0wSD4tTTfi3ChI
        hMefTzjNWRNmng0pypIag2Fykx850tK/Ag==
X-Google-Smtp-Source: AMsMyM7NH/4yulepb5kSeUkKoLldZTDv0gTKOsOBsoSSZAVF6eXnUuRbnEvF5JZ76GI7QirHhlzMag==
X-Received: by 2002:a63:8748:0:b0:43b:bacd:4461 with SMTP id i69-20020a638748000000b0043bbacd4461mr282115pge.507.1664409390529;
        Wed, 28 Sep 2022 16:56:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a15-20020aa78e8f000000b00540f3ac5fb8sm4671990pfr.69.2022.09.28.16.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 16:56:30 -0700 (PDT)
Date:   Wed, 28 Sep 2022 23:56:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: KVM: x86: Second batch of updates for 6.1, i.e. kvm/queue
Message-ID: <YzTfKh3Sv7RB1abm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Second and likely final batch of x86 updates for 6.1, i.e. for kvm/queue.  All
larger series (NX precision, Hyper-V TLB flush, AVIC fixes, etc...) are
destined for 6.2.

There are a variety of selftest fixes and improvements that I think we should
get into 6.1, but they're not x86 specific, i.e. I need to sync with you to
figure out how to handle those.

Note, Like's PEBS KVM-unit-tests[1] will fail unless the PMU fix that's going
through the tip tree is also applied[2].  That's my fault, I requested Like to
post it separately without thinking through the KUT ramifications.

Thanks!

[1] https://lore.kernel.org/all/20220819110939.78013-1-likexu@tencent.com
[2] https://lore.kernel.org/all/20220831033524.58561-1-likexu@tencent.com


The following changes since commit c59fb127583869350256656b7ed848c398bef879:

  KVM: remove KVM_REQ_UNHALT (2022-09-26 12:37:21 -0400)

are available in the Git repository at:

  https://github.com/sean-jc/linux.git tags/kvm-x86-6.1-2

for you to fetch changes up to ea5cbc9ff839091a86558d4e2c082225b13e0055:

  KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters scalability (2022-09-28 12:47:23 -0700)

----------------------------------------------------------------
KVM x86 updates for 6.1, batch #2:

 - Misc PMU fixes and cleanups.

 - Fixes for Hyper-V hypercall selftest

----------------------------------------------------------------
Like Xu (6):
      KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
      KVM: x86/pmu: Don't generate PEBS records for emulated instructions
      KVM: x86/pmu: Refactor PERF_GLOBAL_CTRL update helper for reuse by PEBS
      KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
      KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement amd_*_to_pmc()
      KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters scalability

Vipin Sharma (2):
      KVM: selftests: Check result in hyperv_features for successful hypercalls
      KVM: selftests: Load RAX with -EFAULT before Hyper-V hypercall

Vitaly Kuznetsov (1):
      KVM: selftests: Don't set reserved bits for invalid Hyper-V hypercall number

 arch/x86/kvm/pmu.c                                   |  20 ++++++++++++++-----
 arch/x86/kvm/svm/pmu.c                               | 117 +++++++++++++++++++---------------------------------------------------------------------------------------------
 arch/x86/kvm/vmx/pmu_intel.c                         |  29 +++++++++++++++-------------
 tools/testing/selftests/kvm/x86_64/hyperv_features.c |  13 +++++++------
 4 files changed, 57 insertions(+), 122 deletions(-)
