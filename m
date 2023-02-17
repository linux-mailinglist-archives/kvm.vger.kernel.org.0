Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6B269B5B8
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBQWzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBQWzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:55:46 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ABE497CE
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:55:45 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id n1-20020a170902f60100b0019a68e484e1so1397623plg.14
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7mkmapQ0vpzt9xv9DlarEuVnl2MD/unk2tf8qAki/3I=;
        b=sqvkhVW/pJB0gLXBZHzFDiw5qGK8xfy/MB8PwaIHDGW/DEsWFeEaPv9clNYGHliia+
         laClR02a/Bm3c7qNMCQICLwV/kWvPbwON3t+XiXxXZyjCOlizfHVOqQzUkkc7KI8O3Ko
         sknW0S6AvIHTY6PirIT4C+ilK6M6OzWxAU43rMaxE03q5XccjjQrXmyiqEKp3u4AIQBs
         98OK7cLaefVLSsAhfpvouKDI98IXJa2hhkD0MRxTXJYgTvi/S8ZV6TaACac926YO4NEV
         aX54KbzoJD1KtwGXqK8M7BXyVU/QY65DZKtg7e1mHmbpSh2LSeJMlPeUtbUTcyK6YW+g
         tCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7mkmapQ0vpzt9xv9DlarEuVnl2MD/unk2tf8qAki/3I=;
        b=aAyBtM+IbecaB0tYZ2kzs6HdN+KCD+C6DcfxevYc/Kf7E8azggCGMQmcdqOk0PTB1D
         dNJhvYO9iB92TKziPN7mQRPpB1lhqfhcklQcpEncMKnylSbiS/GhNsVn++HkLfRq1vBQ
         sEzvZEb2gwS6I1daZbsvso7NHtpiVhUmRO+PS1KM5Vn7vi91pIEuDukSHChiEb0B/zFu
         jHP/n/eRiuqQJTRHnhF16FoPUkvgOODZWygfJjabuMltuCc4zToUHDgyny2HvgzMlz5U
         s7eDhVjNFK9RZLl0rnVpvtNZT0b7pjQMOWPYphJsTtoW/Ulelr/dB83uXqkUwi61WK3Y
         2GPQ==
X-Gm-Message-State: AO0yUKXRMkQvxXMnZMeh/VRWrhnX/8K7ISBSaDoEfWtl8JZo7QIPJbsO
        4n8cd6cOl6XxQU4bjcESCHVtKRaV5VA=
X-Google-Smtp-Source: AK7set9jAgOuHOMAVbm+qokY7KHkEL+an+ozoMjNJHE+5dzTbvZmbHlIYrrQb0ES6LDHVU4aEL9bYvevBsI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8005:0:b0:5a8:c2e8:e08e with SMTP id
 j5-20020aa78005000000b005a8c2e8e08emr333287pfi.5.1676674544993; Fri, 17 Feb
 2023 14:55:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 17 Feb 2023 14:54:48 -0800
In-Reply-To: <20230217225449.811957-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230217225449.811957-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217225449.811957-2-seanjc@google.com>
Subject: [PATCH 1/2] Documentation/process: Add a label for the tip tree
 handbook's coding style
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a label for the tip tree's "Coding style notes" so that a forthcoming
KVM x86 handbook can reference/piggyback the tip tree's preferred coding
style.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/process/maintainer-tip.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/process/maintainer-tip.rst b/Documentation/process/maintainer-tip.rst
index 572a3289c9cb..ad0540d6882b 100644
--- a/Documentation/process/maintainer-tip.rst
+++ b/Documentation/process/maintainer-tip.rst
@@ -452,6 +452,8 @@ and can be added to an existing kernel config by running:
 Some of these options are x86-specific and can be left out when testing
 on other architectures.
 
+.. _maintainer-tip-coding-style:
+
 Coding style notes
 ------------------
 
-- 
2.39.2.637.g21b0678d19-goog

