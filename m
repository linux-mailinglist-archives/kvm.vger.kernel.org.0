Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EC56DFA89
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjDLPrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 11:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDLPre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 11:47:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8B059F0
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 08:47:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1a667067280so2228035ad.1
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 08:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681314452; x=1683906452;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yjrE3vkWoYaBe3XK1gCb5Sp1UmCvYlcNR4o4s9Hxl/0=;
        b=x0lvcwo264vjHzlYWnCEK1c/d9SF4qJXDBKMDHCWZYlGR+S0SDr1jR3tI0yXPpi4Nq
         EITD3Nqm4TOtwRLIFu+tskH8GAStRwoHEpYJClreiibgLOtabKQV/cRWlioJAlr9qPaf
         wOqWSQIyC7jQKNnTsVxaixE2fu7wUXVbRbYSEepNC/ywEjsoddcFKD/p6HnxJkGQhtok
         POF2elMpKOEK3b5gqIxih1gOfdp/ac07+OJ10EAykTiIWwDcCbChCnyskJDszVMlC6J4
         k80kAsC1uIlED0JyrXNAFhQIPEoiA2pkdN7hFRMJAD5Y//HTxcONm6cuCHJMDaRavB5X
         KjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681314452; x=1683906452;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yjrE3vkWoYaBe3XK1gCb5Sp1UmCvYlcNR4o4s9Hxl/0=;
        b=HwkzOFsz1xM5Xx/3HmYM2/pDHT3guKhyKkuHY8hAvj+io+VLPuUa6BuLQSAryWJ1UC
         dnByTTfsDnzG0u1MYR6oMQbKvoE14uVNY1IlqRRpkURs2Ju6UnpZ6KRQ28mFS0Tg65wV
         ++g0t4wfBfa0znVm2UHeqzO+j+7oCm27W41UTEQX1mEJYOtzSxQtSDb4uCu96L10oFmU
         KhmMoSnFATXuzXGt3XAJOnAwoeF2H0r+JGowzaYggY63uKF9w4ZrVg7cmyP1Q27zcKRQ
         HO4ojX6bJvh5/689Gs1BrGyScl46YkmdekQJE3d47e/Y5hWfody3s4lRPmXTCIkU//YR
         lLXg==
X-Gm-Message-State: AAQBX9dmPI+2TSFCoiqsjjCBM4hz1WtUt1Ao1j1Y/dYQ8KKDmKJ1+pCI
        stXeF78lfZ1bK8qLxNdaNu1VyuFYjDY=
X-Google-Smtp-Source: AKy350aJDClf8K5+aIBJwRzeHF4JMKPh5FDv4GVFVqkv9oGFBr6wnSjqIYxtGQWHmi4AI9OsjRJkuI7bQV0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1414:b0:637:ec79:5afc with SMTP id
 l20-20020a056a00141400b00637ec795afcmr5084428pfu.3.1681314452103; Wed, 12 Apr
 2023 08:47:32 -0700 (PDT)
Date:   Wed, 12 Apr 2023 08:47:30 -0700
In-Reply-To: <4e3706bd9dccc6cd00eab9c59e06b3912b0c8dfe.camel@intel.com>
Mime-Version: 1.0
References: <20230411171651.1067966-1-seanjc@google.com> <20230411171651.1067966-3-seanjc@google.com>
 <4e3706bd9dccc6cd00eab9c59e06b3912b0c8dfe.camel@intel.com>
Message-ID: <ZDbSkqCm8AYVMqPI@google.com>
Subject: Re: [PATCH v3 2/2] Documentation/process: Add a maintainer handbook
 for KVM x86
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        "eesposit@redhat.com" <eesposit@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pshier@google.com" <pshier@google.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "jthoughton@google.com" <jthoughton@google.com>,
        Guang Zeng <guang.zeng@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "leobras@redhat.com" <leobras@redhat.com>,
        "bgardon@google.com" <bgardon@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        Jing2 Liu <jing2.liu@intel.com>,
        "amoorthy@google.com" <amoorthy@google.com>,
        "nikunj@amd.com" <nikunj@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "mhal@rbox.co" <mhal@rbox.co>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "mizhang@google.com" <mizhang@google.com>,
        Sagi Shahar <sagis@google.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "aghulati@google.com" <aghulati@google.com>,
        "ricarkol@google.com" <ricarkol@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "flyingpenghao@gmail.com" <flyingpenghao@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axelrasmussen@google.com" <axelrasmussen@google.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "aaronlewis@google.com" <aaronlewis@google.com>,
        Maciej Szmigiero <maciej.szmigiero@oracle.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "pdurrant@amazon.com" <pdurrant@amazon.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>,
        "junaids@google.com" <junaids@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jiaxi.chen@linux.intel.com" <jiaxi.chen@linux.intel.com>,
        Rongqing Li <lirongqing@baidu.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "babu.moger@amd.com" <babu.moger@amd.com>,
        Wei W Wang <wei.w.wang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "houwenlong.hwl@antgroup.com" <houwenlong.hwl@antgroup.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023, Kai Huang wrote:
> On Tue, 2023-04-11 at 10:16 -0700, Sean Christopherson wrote:
> > +Timeline
> > +~~~~~~~~
> > +Submissions are typically reviewed and applied in FIFO order, with som=
e wiggle
> > +room for the size of a series, patches that are "cache hot", etc.=EF=
=BF=BD Fixes,
> > +especially for the current release and or stable trees, get to jump th=
e queue.
> > +Patches that will be taken through a non-KVM tree (most often through =
the tip
> > +tree) and/or have other acks/reviews also jump the queue to some exten=
t.
> > +
> > +Note, the vast majority of review is done between rc1 and rc6, give or=
 take.
> > +The period between rc6 and the next rc1 is used to catch up on other t=
asks,
> > +i.e. radio silence during this period isn't unusual.
> > +
> > +Pings to get a status update are welcome, but keep in mind the timing =
of the
> > +current release cycle and have realistic expectations.=EF=BF=BD If you=
 are pinging for
> > +acceptance, i.e. not just for feedback or an update, please do everyth=
ing you
> > +can, within reason, to ensure that your patches are ready to be merged=
!=EF=BF=BD Pings
> > +on series that break the build or fail tests lead to unhappy maintaine=
rs!
> > +
>=20
> It seems you don't like resending patch as a ping:
>=20
> https://lore.kernel.org/lkml/20230410031021.4145297-1-alexjlzheng@tencent=
.com/t/#md30aa77e5c2592b5b1fb0401d14e6fdbf52c2e06
>=20
> Do you want to include this to the documentation too?

Honestly, I would rather get Documentation/process/submitting-patches.rst u=
pdated
to rework its recommended use of RESEND.  I doubt I am the only person that=
 thinks
a RESEND after 1-2 weeks to ping for reviews is inefficient and confusing f=
or
everyone involved.  And on the flip side, AFAICT there's no mention anywher=
e of
the much more common (and IMO justified) use cases, e.g. to fix/tweak the T=
o/Cc
lists or because there was an issue with mail delivery.
