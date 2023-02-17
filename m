Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8E269B5B4
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBQWzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBQWzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:55:44 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC11497CE
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:55:43 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j15-20020a170902da8f00b00198f5741d23so967095plx.18
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qX01yCG8Tyfo4OLzTgqDTzCtCYMj9HQcITl6rWSXSe8=;
        b=KBb86AS6Bi2LtTKgGnz+8tOM0X+pAfsuaBUQ+iFcVSfi5Q5AQyb1AmPUDnw4AF4gxh
         ILwju8KN1MrzKii0D3UKWafgBswM4wVwIez1qnpau5bJpKtEDbrorC91Aww0VLFfFi0J
         Qrq87XIUMfz4EkYE8GoI3zWFMBA8F03vGXjTT8SygbfjKuwF92wHF5HshOdFknqHdYTZ
         HUp73oX11zD18NsvAnQ2hELjhHDQ3hewfdnx8rCsh+2g0n8XLYPt0vqV32jOT38j7J0A
         kNmnfUHFW96AGn3gboicXNua5odI23/BGQp+ksMx+BW4CNtXbCPHXh5rKCMJ92E5L4Ix
         QpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qX01yCG8Tyfo4OLzTgqDTzCtCYMj9HQcITl6rWSXSe8=;
        b=chTz44t79De/J1eSLNbTtmw4xSWFr4EOXAoi0zqg753BJcE/X/egesR0pg98sOlBKW
         4EV2mtnP+Cl7YILcPTuVxKEyVw7L6llpO1lxHS7njLqBGf557S5nQmo8Zvt6yaiUGFFj
         Lo0MmH9glQS9afRW7NmsXPeApQfFUGbY4v4WQ2VdEggvT/FMf32sVZioCdm73RrXFEOo
         lGAXQDjfOkNkmvNg7G9FA3282PBIcdbfnQlAel9yXIF5y87qGw1A+x/12T9ZHnbXlouv
         nI3fKsqCGKS6YksM3x9iYBLHafvqtDnWLLmUhdvrV3Z57bQH8JglGs2mSkFIrhJTTs+W
         HVng==
X-Gm-Message-State: AO0yUKVIh2sETnShISX6N5WJTe5JDDYVl4kJY26V9gn8IPPwVZaT6ukK
        lnyS3awtfvKfYxuPdJ60saYjH5Q/rWo=
X-Google-Smtp-Source: AK7set/mf3kTZZHYyyxIdumXwfoCp+a614uL8v4tEP2+5jOUSq8xyzK6n8AWr3/rs0uqUdxzNytzvZFXBtI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6b94:0:b0:4fb:398f:ef2a with SMTP id
 d20-20020a656b94000000b004fb398fef2amr983477pgw.0.1676674543018; Fri, 17 Feb
 2023 14:55:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 17 Feb 2023 14:54:47 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217225449.811957-1-seanjc@google.com>
Subject: [PATCH 0/2] Documentation/process: Add a maintainer handbook for KVM x86
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

Hi all!

Here be the long-promised/threatened documentation for contributing to KVM
x86.  The Cc list is quite large for two reason: partly to spread awareness,
but mostly to get input from the target audience.  If you have something
to say, a question to ask, or a request to make, now's the time!

Sean Christopherson (2):
  Documentation/process: Add a label for the tip tree handbook's coding
    style
  Documentation/process: Add a maintainer handbook for KVM x86

 .../process/maintainer-handbooks.rst          |   1 +
 Documentation/process/maintainer-kvm-x86.rst  | 347 ++++++++++++++++++
 Documentation/process/maintainer-tip.rst      |   2 +
 MAINTAINERS                                   |   1 +
 4 files changed, 351 insertions(+)
 create mode 100644 Documentation/process/maintainer-kvm-x86.rst


base-commit: 3ac88fa4605ec98e545fb3ad0154f575fda2de5f
-- 
2.39.2.637.g21b0678d19-goog

