Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A3F75FFDB
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 21:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjGXTho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 15:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjGXThm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 15:37:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77191B5
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 12:37:39 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583c49018c6so31805197b3.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 12:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690227459; x=1690832259;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4VWgPiua4ZmSDkThmKhRK2lyYjlOypYwlqtCHhU3qo=;
        b=F/34vdGPJzVdninBmHaaYps8MkTJYqcn8LiDiws1Gv9uty0wqqclSdi5PAck/jLSQ8
         EcvJd0MXjWq+ozQp31NWYaFd+VTGDlut71Qqrqv/Qg4H1ujvRnubTaajPpFNnoBweu0M
         oD4S1+sp8BqCqEuaH6IQAGP81DI3GAPBZhuBKv0CoLbXzC/z+R+Wd2Ag72X9NzgeOl5Q
         lMXjB8hE6JbU6/PZRlXHvU7xkq9MdpO9Csy+OLjbBwzxy5pLFWwNIK9tfQ46O3+mDDnZ
         ABbVfHKJBmLVtKzHA1Fe/rCU4NvdrZ6ogNs+M3yzlpLaPX+2qfVUk9U1m5xDOTr3BasY
         3dsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690227459; x=1690832259;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4VWgPiua4ZmSDkThmKhRK2lyYjlOypYwlqtCHhU3qo=;
        b=Yypso6pGI9XAtsKx4lOq29dEcxCwpkWLEJdVHQ8tkq2T1YHwW903oZhBEF/YhHS5+T
         Mr5rpVugoEENitEFbA7tcXt/3WnAfgrWpkG7kWeKNSeDEM5F3GII8ew0JXXBS7rtdohW
         I+//LtgFu1ajzJpj7jjNRdZYn/sea5SnI2u7SqqsE9x70qXL3zZckG+ZOe8eJVIrl0ON
         mUOMWZkKswozFzKCwQTUWaEV4b2MCXEVSvzbNyi2uINq57pHF9b1MIZACsRqSiJupbq1
         giHjBOByK4hlRnhp/uZLN8m06qwSs0agbItOB2hFMvF0P04CweGI2Se1nqWHCdHVkIvz
         Vtqg==
X-Gm-Message-State: ABy/qLZqcX1SEcn7p8bcRepvBPWVw/m1hI9cz+TfXp4f/mEhjXZlPx4p
        Zq8mT9N24xaAqPiLANvQ6s1iUv/MFWc=
X-Google-Smtp-Source: APBJJlG4XX11fRNdTWxSIJ1x78nNmOIsCxonkuectk9GCCLaduDufbvEPsVji3+TYABpm1rQkYjd/u9/tRY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae54:0:b0:576:6e4e:b87f with SMTP id
 g20-20020a81ae54000000b005766e4eb87fmr73392ywk.10.1690227458870; Mon, 24 Jul
 2023 12:37:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Jul 2023 12:37:00 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724193700.54825-1-seanjc@google.com>
Subject: [ANNOUNCE / CFP] KVM Microconference at LPC 2023
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are excited to announce the first KVM MC at Plumbers 2023!

The KVM microconference will focus on KVM itself, as well as KVM's touchpoints
with other kernel subsystems.  The purpose of the KVM MC is to supplement KVM
Forum by providing developers with a dedicated vehicle for discussing kernel
internals.  Topics that are primarily aimed at something other than KVM are
firmly out of scope and will be rejected.  Please consider the Confidential
Computing MC, the VFIO/IOMMU/PCI MC, or KVM Forum 2024 for virtualization topics
that aren't directly related to KVM internals.

The KVM MC will be comprised of ~3 "big" topics, and ~6 (+/-2) "small" topics.
Big topics will be allotted 30-40 minutes, and small topics 10-20 minutes.
Please add a note in your submission if you would like your topic to be
considered for a big slot (consider it a hint to help us rough in the scedule).

Below is a list of *ideas* for topics.  Topics that are not on the list are more
than welcome!  If we were omniscient, we wouldn't need this CFP!

Note, priority will be given to open problems, i.e. things that have already
been posted/discussed on LKML, but posting before LPC is NOT a hard requirement.

Potential Topics:
  - Serving inaccessible/unmappable memory for KVM guests (a.k.a. guest_memfd)
  - Optimizing mmu_notifiers, e.g. reducing TLB flushes and spurious zapping
  - Supporting multiple KVM modules (for non-disruptive upgrades)
  - Improving and hardening KVM+perf interactions
  - Implementing arch-agnostic abstractions in KVM (e.g. MMU)
  - Defining KVM requirements for hardware vendors
  - Utilizing "fault" injection to increase test coverage of edge cases
  - KVM vs VFIO (e.g. memory types, a rather hot topic on the ARM side)

Abstracts can be submitted via https://lpc.events/event/17/abstracts.  Don't
forget to select "KVM MC" as the track!

Thanks!
