Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F36F6B186B
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 02:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCIBD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 20:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjCIBDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 20:03:50 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345949BE39
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 17:03:39 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id y1-20020a631801000000b00503696ca95dso66785pgl.1
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 17:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678323819;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m4Kgj90WAIRpMSk15gHVq1rdI6z2bGt/9q+3/N1bx1M=;
        b=cUy/iFCRkRNH+7tPQLWb+98G4wIahK2hGkuUeg6xfDpvcgUCGF8UTqGTpWuVvzgHcB
         WY8jDNLE1IDwFQ8EYUk/Wk+mmpum2gsubEnDtiv/35GkqBX0XA3cfEKXtNrNo5wlshdN
         XmCOyAbfl7BxnKqWbCx+4PlXYmAkjH+frEdXAOwVqk8qMgox5p4vQPh/tAAyylGA/qZ5
         73TrIG8Xeuw2Gu2s/60UxvJcwWGawwUhhAhEdeb8Citqpzt5BdpD3iFKZvQEMhDYXWEh
         RY+3t+K8HVxuLkP90h90L2BIFD5e7xWjbUSl8D7+sJMS08jMJPBjn24Ojq94AR8nuJmz
         APBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678323819;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m4Kgj90WAIRpMSk15gHVq1rdI6z2bGt/9q+3/N1bx1M=;
        b=aPRmKr+fGdupzxioCU3/dgrknoNkPyKE0f7TE9BRHfGS/I7C14LOPoZTyiXJkWdz72
         wY/y2SbGiSixHUZTTzwj2AS3uxn05ALwCyLD7hYZKsaHJSjocVR66skkTB/tV2W2aIZh
         i/X1auBuZ3JixOoiGq5UO4d6AqOtMZ9jUU09x3W2pxjP1LWunV26DfUFEwZoxEJFaVI/
         GfCstrJgPEefZHI8JSTasV/XFrInZ+RzPrOBDADi/luAntICwNKwDwutAjBouYnbjhBE
         2+id/NCvF7GN9K9cM1jVloyK8HxhrC9zCQrZ5UHMzUjYsIqa6zhiQ4f0U70m8AzVpb59
         NZ5g==
X-Gm-Message-State: AO0yUKX3+F81cBws+Axd79QNn5W8jzMYMwfXoY2/Zumu3JqaDsgAcTFo
        eTEXCXPQsSwBNw3tXNmjCC1KXIm9aCU=
X-Google-Smtp-Source: AK7set9P0T5ki9oZRXwb/iIWoWX/zO8NZrmywgby8NUI9KSxtnR70fM7ain7q1jp9/XvIvMglKUGVokEFgg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:ce87:0:b0:5da:cbe6:c0fb with SMTP id
 y129-20020a62ce87000000b005dacbe6c0fbmr8596647pfg.4.1678323819285; Wed, 08
 Mar 2023 17:03:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Mar 2023 17:03:34 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230309010336.519123-1-seanjc@google.com>
Subject: [PATCH v2 0/2] Documentation/process: Add a maintainer handbook for
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
        Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dcumentation for contributing to KVM x86, round 2!

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
 Documentation/process/maintainer-kvm-x86.rst  | 391 ++++++++++++++++++
 Documentation/process/maintainer-tip.rst      |   2 +
 MAINTAINERS                                   |   1 +
 4 files changed, 395 insertions(+)
 create mode 100644 Documentation/process/maintainer-kvm-x86.rst


base-commit: 3ac88fa4605ec98e545fb3ad0154f575fda2de5f
-- 
2.40.0.rc1.284.g88254d51c5-goog

