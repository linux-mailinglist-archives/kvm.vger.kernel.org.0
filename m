Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2587F76A56A
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 02:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjHAAVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 20:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjHAAVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 20:21:31 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E97199F
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:30 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5646868b9e7so264600a12.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690849290; x=1691454090;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+wox7n0HGm6/MIYHbn+fgxMoQ9mtfs5CTs8dCYiGjc=;
        b=YKTsvhZ2yK8ijk1hvQnnvPjyJrUl4x9YYQigtkgJOdxwi8e5EDHLvzyUyj2vk/YVzV
         ekiC0pO2TtKJD66SiHJZnIibf42rePRdof640KqRxj8VIzBlJzSPwl8Nv3Cf7/N3ldth
         dGMqUsC83Gp+4oqcau6yKS4sZjKLLuPF6Ar5VeXi38GKp2ChE+gXsXyVmyb3mAYFif3I
         LTM5a4ZPX5OMHhjtleUviJslPw3SL0x8d4c4d6bDV64KvtlRtwrsXi/jRI1b44l8L2S7
         +6WP4Z/eh60ZvzMSyoYaPBCZME3nj2v23uiDCoQKCCLsFq0viP/MBQqDXzccOwOjHXbc
         JtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849290; x=1691454090;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+wox7n0HGm6/MIYHbn+fgxMoQ9mtfs5CTs8dCYiGjc=;
        b=KoI4IHPi7RIvIdzU4LSj0PyvV82KdHNYN88BYhGUTBXvubZP5yw1g5RdyQqLVLrtL8
         jvDzaF+ZQpJoO7omvNdSqZAswn2Hvug7qdAb88rX1jiI2LexPDyrBsrqe1LEBQRwIw60
         RCDWGrz93HWXSLcsOrCWev1Z6UfAv7WvPo1ALENG6teIAVj9msf6B09hFgNhzcEFqp2i
         0+P3UHr6KK7qCLpceJs+YEfU+Ju2i3BQEFvnFDJ3Krw2QWOJFkb223BYJlBSzESvZ7va
         45+Kk8QCX7NsmJ//FyTwd+/sMFvjstudfnuh4UP0yGqyMAU3pFldt8cRwjo7S72oO0WF
         1+CA==
X-Gm-Message-State: ABy/qLb/eDW0RnxPFkHPJHZERCb0kLEeglkoQzCtwpTk8LXJJpt/1kG5
        oOsaUgp2NSttck5RT3RgTkrmTtqFXhb/
X-Google-Smtp-Source: APBJJlE0OuN5kF9ibnyFOkVhExXmb05tVThZCevDMYgY3YUyE3ZrbAfNXVORndtQ7keq6D5QKaDiMrGmSoTP
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a63:3e41:0:b0:563:9037:b725 with SMTP id
 l62-20020a633e41000000b005639037b725mr50244pga.3.1690849289749; Mon, 31 Jul
 2023 17:21:29 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  1 Aug 2023 00:21:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801002127.534020-1-mizhang@google.com>
Subject: [PATCH v3 0/6] Update document description for kvm_mmu_page and kvm_mmu_page_role
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the 3rd version and I made some changes according to feedback:

v2 -> v3:
 - update the description of shadowed_translation [sean,randy].
 - update the description of ptep for tdp mmu [sean].
 - update tdp_mmu_root_count into root_count and update the description
   [sean].
 - update mmu_valid_gen with more details suggested by [sean]
 - add extra description for tdp_mmu_page [sean]

Mingwei Zhang (6):
  KVM: Documentation: Add the missing description for guest_mode in
    kvm_mmu_page_role
  KVM: Documentation: Update the field name gfns and its description in
    kvm_mmu_page
  KVM: Documentation: Add the missing description for ptep in
    kvm_mmu_page
  KVM: Documentation: Add the missing description for tdp_mmu_root_count
    into kvm_mmu_page
  KVM: Documentation: Add the missing description for mmu_valid_gen into
    kvm_mmu_page
  KVM: Documentation: Add the missing description for tdp_mmu_page into
    kvm_mmu_page

 Documentation/virt/kvm/x86/mmu.rst | 44 ++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 9 deletions(-)


base-commit: 0b210faf337314e4bc88e796218bc70c72a51209
-- 
2.41.0.585.gd2178a4bd4-goog

