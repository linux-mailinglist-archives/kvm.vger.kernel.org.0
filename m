Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DA53D081F
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 07:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhGUEcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 00:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbhGUEcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 00:32:39 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B3EC061574
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 22:13:15 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id e7-20020ac84e470000b029025ca4fbcc12so893135qtw.18
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 22:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=dPPqwC9VgrNwWEvLtt1usx0UZWr/+TNKPVKEDUalWg8=;
        b=EhS8oT4rzPymoogP0OnMeN6fyNgPO9u7q9nBDl2JA9w5V0XNfHI9R3XvGYxV7U4h90
         WZL00WkrnAfkzBWn27CEynX0AvwjG1a+xpmV2dQDZoePS/2rvPRde/hNdPSPTnkW5G3h
         ZcplIkcMPWcQLKLJ3v59KmnnH4k6YIZXC8IWTBIpXnfudh1+Nsf8xPYhFcXmV160rxSf
         RPBSc/tXPd9oRKWJcl5xtSwcH9cXi1Jup0dw/LoJtY2+hkUxmu1/cx5Vm4+J5lZ1XDfz
         EgmeYTr4czgg85tA4blI7Eo+9LviJTQhaKBaYmSnH1Fyioptsxlks2+yhVT6GwCKW3gL
         8zvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=dPPqwC9VgrNwWEvLtt1usx0UZWr/+TNKPVKEDUalWg8=;
        b=RFMHXg3TH9CXdrxNza6d5dyJcyuqTC6joIG2saj3nwJx+8NDF8YgllLbfYismY4vdS
         u04hYatASBID+DkKltiTAoilvpT5MNGOu+me7JzGCB2cvp7aWW/BRks5wwQvWrr7V8tc
         q9r8uOAvauRQ8U4wfv7aaF+5uGdxBsVGKg5FC4XQTvZlOkx03bQ8PpsuSz/6+9H5JjDw
         ZiTjuPZWSSogNHZWLSJ/7ThoplFUGZrlHJb+4MiyJe2afzCKxHgsxIm4FKtaXTT9o4oc
         wzs6+Br0w0oxYXG2qjoCGHIHLvdAKE7nOW/KOUbCsiWzBNU3CZJEGy8Hot1hjUnRtElp
         jQBw==
X-Gm-Message-State: AOAM530g5p83TBcLXV0YtV4nfsg44rG4bOi6A9rPhOOrNzxpayLICA70
        MGp455XQb9Gy6hHo5V/KrRh23VqPdRjy
X-Google-Smtp-Source: ABdhPJwQIqM/AQsXKND5pCeLrQ6op99HQjuCZqaj55ZQhJ7MB5VMXzi1/rJr37TVqlAhnnkSVwsMvvWcbBWO
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:4b06:fd20:8c22:9df1])
 (user=mizhang job=sendgmr) by 2002:a05:6214:401e:: with SMTP id
 kd30mr34598769qvb.43.1626844394132; Tue, 20 Jul 2021 22:13:14 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 20 Jul 2021 22:12:45 -0700
Message-Id: <20210721051247.355435-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 0/2] Add detailed page size stats in KVM stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit basically adds detailed (large and regular) page size info to
KVM stats while preserves the existing metric: lpages.

To support legacy MMU and TDP mmu, we use atomic type for all page stats.

pre-v1 (internal reviewers):
 - use atomic in all page stats and use 'level' as index. [sean]
 - use an extra argument in kvm_update_page_stats for atomic/non-atomic.
   [bgardon]
 - should be careful on the difference between legacy mmu and tdp mmu.
   [jingzhangos]

Mingwei Zhang (2):
  kvm: mmu/x86: Remove redundant spte present check in mmu_set_spte
  kvm: mmu/x86: Add detailed page size stats

 arch/x86/include/asm/kvm_host.h |  9 ++++++
 arch/x86/kvm/mmu.h              |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 53 +++++++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.c      | 10 +++----
 arch/x86/kvm/x86.c              |  6 +++-
 5 files changed, 54 insertions(+), 26 deletions(-)

--
2.32.0.402.g57bb445576-goog

