Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08666DE245
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 19:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjDKRRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 13:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKRRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 13:17:01 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5725B87
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 10:16:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-634b28df943so433430b3a.1
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 10:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681233417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAWY2GWJIOv3kSnnhE+XBMXk33N7ZjQj5xRT3xD84XE=;
        b=jWs4xyTSD7QZDesz889DQcUQvh3/z26bMvD2shwcwLOpjSGtg6oc61L54/3v6k0UMX
         IMu/wcjJRdH4wfwedj5slu2rUBsS3lsbM3N2LzLL8Y4XmbIdZIu86latIVc7rObIVzmc
         NvsYJNKoi50Be6pGbJwaPttFRl0udWv3+puuHQj6Wzp6LzpajMRdPxuuCaNgKeCICIQc
         RHPE1tjLk4Cu40Xl7VRDcFI9u33AFff4au3FnQSrNObD1pOysS3ra+LxXCLBYLRDq5vq
         XBEh2peOvJAtbuHH7AgWGqpzXPRpnBrCSTDfxhCYFCJ3vLXmG/NPDMthaiWh6nKkslgB
         VgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681233417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZAWY2GWJIOv3kSnnhE+XBMXk33N7ZjQj5xRT3xD84XE=;
        b=VMTr8W3aBA6SLrKQaxnnF6CRseUt5s9z93Z7U17+1ziuawzK1mdkMnQ0XaHgDhclSN
         muV9JDgvvRsdGXBmQQGzYBdhY+5RG8iDnjdUolfDI29CFo9Q/W+Z115anjdVgp6hvgjH
         HxxysEjQnZ3jGHglh4dbaGAiW+TKwv4CxCjzVYWL1zUPMKz0SCZ13qFQlMHAGeFSFiaj
         4hPtI+EXElvjpHhCnYAOHBDXUYU8jq4JmF5hAXo6F5FuI6w5tdm7FbTZkE0/749GFto3
         6id6eIFM9ghjOxapZ62jueOPvJGRU83DezhZQl0jiG+nfhZ9ge9VNIVlWTtnn/CnWEHR
         Nnag==
X-Gm-Message-State: AAQBX9dGwTGq5sb3VLdI1HvaDDwxQyd5Q8rDhYLxtCIpCbpB3AU7cqap
        RRDVS3arMCF76zagW1MmGHSNJetpFrs=
X-Google-Smtp-Source: AKy350antwYI7cZ/gdaNMLfTnDUjSOKojkZRRqxDmtLuewwmU75fwv5B9NZ2izG7ZonO98NMMojvoH/F2As=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d9c:b0:625:dac0:5263 with SMTP id
 fb28-20020a056a002d9c00b00625dac05263mr7037008pfb.0.1681233417257; Tue, 11
 Apr 2023 10:16:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Apr 2023 10:16:50 -0700
In-Reply-To: <20230411171651.1067966-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230411171651.1067966-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230411171651.1067966-2-seanjc@google.com>
Subject: [PATCH v3 1/2] Documentation/process: Add a label for the tip tree
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
2.40.0.577.gac1e443424-goog

