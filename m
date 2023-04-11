Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF206DE243
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 19:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjDKRRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 13:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjDKRQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 13:16:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D70B5598
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 10:16:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54ee12aa4b5so90906857b3.4
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 10:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681233415;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rxRq7IEOowHT+3lZvfsRXImSkulOEzG82uwdGkSU48I=;
        b=IEIUnJfKT1h1+cZkb1XP2ptSpAyBOIu5i+dE3DGuWDt4Wv8yGnnU6YsR4hw1P1Rww2
         5ARveRIB2sgXqKBkILJTbhnpymk/kafUHOkEROBI+uXPey9mGCmlPwSEQZZzzdflUKXL
         qWLOa0nUgBP0+VhNkEFnyRph0Q/k/o1Jo5tBdLpE9SpAqwSXRep/VgfkVPFZDM+e2NYh
         KNS5IKch27NzqpwghvRINaeYID+O5LeOSWkhheVEnxGM4Kzh+ETf7VNKR98bm9QhH+TT
         FYcTVYOeMEg/MkmV6tuhOsoWa2WwpXHEBpYTF8Wl0pMzo3Tzvea7i3GdD15BUEIgHVaF
         VMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681233415;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxRq7IEOowHT+3lZvfsRXImSkulOEzG82uwdGkSU48I=;
        b=4+l6uIElb+gokWqjF+8IRFoh7piGDAhmFDSr/mzQ0/J0GlmLTvnAYla0N+uVnczrv2
         prYNUrGzCcztWC8wji/Bmw9cMNqG7sBBbpQZB8b2eFLW7ZDWyhmQI9Ni7Wtt9Kfalilc
         fMR0WYxIlcy9YhCLqvs9Wh4L/C4W3nrcA4H14J14LW3rq8FTEdrzkqIp4BcSy2UHzEbk
         9qy+AnI7MPv6mkYj91f4JMd/p25AWeleYvJP71tbFuKnN1NensJ8NSi+5K33lHOuk1ci
         JdK5ve98tB87XZGDROBz1/M2FV1GRnVjCPONJHHwGQJ6WtN3cQoPqTFgHvPhfY5RJctd
         +ysw==
X-Gm-Message-State: AAQBX9cCZa4OavQmdiyougLYKKghuKRmFej+wAyTIe8O0/eK+dRqzwPp
        ICMgr74aI880rEObDN9XONBF8cJC8hg=
X-Google-Smtp-Source: AKy350aOFuqLb4Xj6nP4d09SKpKOHeyL6TU4ugtbhHOugVmN4JDIGyDDtdUShlrt2xoUXZNRXoQWTEoTZwA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d4d1:0:b0:b80:2bf9:2f78 with SMTP id
 m200-20020a25d4d1000000b00b802bf92f78mr10090547ybf.11.1681233415496; Tue, 11
 Apr 2023 10:16:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Apr 2023 10:16:49 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230411171651.1067966-1-seanjc@google.com>
Subject: [PATCH v3 0/2] Documentation/process: Add a maintainer handbook for
 KVM x86
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Shier <pshier@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dcumentation for contributing to KVM x86, round 3!

v3:
 - Add language to clarify that "reverse fir tree" is also known as
   "reverse Christmas tree or reverse XMAS tree". [Robert, Mingwei]
 - Change guidance for patches/series that touch code outside of x86/kvm
   to recommend/prescribe using a common base, e.g. release candidate,
   not kvm-x86/next. [Bagas, Oliver]

v2:
 - Fix a KVM_GET_SUPPORTED_CPUID typo. [Yuan]
 - Give Cthulhu the respect it deserves. [Like]
 - Explicitly state that selftests vs. KVM patches need to maintain
   bisection (when possible). [Like]
 - Change the recommended base from topic branches to "next" (and plan on
   providing stable, persistent git objects via tags). [David W]
 - Add a blurb to provide guidance for series that touch non-x86 arch
   code. [Yu]
 - Clarify when (not) to reference/quote specs (APM and SDM). [Maciej]
 - Add preferences for shortlog length. [Maciej]
 - Exempt things like comment fixes from testing requirements. [Maciej]
 - Add a foreword to try and make the doc less scary to newcomers. [Maciej]
 - Add a rule for testing Documentation/ changes.
 - Clarify that fixes for the current cycle may be carried in the KVM x86
   tree, but are usually taken directly by Paolo. [Robert]
 - Tweak the "Changelog" section to call out that using imperative mood
   and avoiding pronouns is the most important rule.

v1: https://lore.kernel.org/all/20230217225449.811957-1-seanjc@google.com

Sean Christopherson (2):
  Documentation/process: Add a label for the tip tree handbook's coding
    style
  Documentation/process: Add a maintainer handbook for KVM x86

 .../process/maintainer-handbooks.rst          |   1 +
 Documentation/process/maintainer-kvm-x86.rst  | 390 ++++++++++++++++++
 Documentation/process/maintainer-tip.rst      |   2 +
 MAINTAINERS                                   |   1 +
 4 files changed, 394 insertions(+)
 create mode 100644 Documentation/process/maintainer-kvm-x86.rst


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.40.0.577.gac1e443424-goog

