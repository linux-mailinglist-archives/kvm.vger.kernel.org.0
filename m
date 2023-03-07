Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7476AECE9
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 18:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjCGR71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 12:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCGR67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 12:58:59 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2676990798
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 09:53:14 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id bh9-20020a170902a98900b0019e506b80d0so8112984plb.13
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 09:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678211594;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FH5HroVi/C3VxZfsb2/P+6HagVCxSp9FIUS8qc4SYho=;
        b=r38YVV5DocwCciXQg3DFck+9jJ0axjzxdDx/79RPsGOKD/mbFJu0/nmzh151/5ihzQ
         V4ni2EHRcrNyxgcAlYbZnL5vuNmtlt1TI/LHuA31KqDXUtb/J7GlzJjObxZgK9UJVThC
         dSTJN4VlnmLpMcsMXY55KYnYG14wMfrnekgU2kvaWLnG9KqjZXcDl2yfvm4bUyv0YexM
         8AvnyN15Gf6SsEOUbUMGIsBuVInEn3/eUax06b2PKUbzzSchbibnuS+1rACY0lITQpAt
         fMJ+RQzkvi20PXbxSflfzrz1K1hikW+vZdNKPIO3dXbIYSxtWfZgMEY292DOB3n/ZzuR
         ESyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211594;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FH5HroVi/C3VxZfsb2/P+6HagVCxSp9FIUS8qc4SYho=;
        b=bJWyPdfdpA8FiMSktfCFTLtAHvv8jfZcasaQrHCKGzQw1v+p3IUY0IQadM/+zXp28b
         A5zRh30jlEBDC/A9ukX4YmQj3HeM2PeSSQL1lSvt9vnnKyC/ndxW6IMHAq6ludw9+MWP
         0Oa6dg9X2GSAGS1HicTAPYzH6u3X9F+NInU6fVOBUVwqAbnD5yZD5IW3kE2esbXpPM1X
         b6AJrPK2jm642fvW7UJOF70wA8LLyMq7CRFNPBExovLL7bxn9IhTWAPc7zCWI6PAibEp
         UNM94/MTVrQuAKdI0a1MsrHF8Ary+cZGdghLhRIWtP/tgsxHepjWfIJk5pRQqoy75zYo
         enyQ==
X-Gm-Message-State: AO0yUKV7nDFmVAoqzSEFojqtOZS7KBo2n/+9zXr5ySSKmZEIzw405JCE
        uWx7RyeTztZhafRyB5K29pLN0BWTd2Y=
X-Google-Smtp-Source: AK7set8i6YBNwec80PM3pvXSqrgujM0vdkzrzCgf37/cB3hOh0c+pDYUrnfCowrQfggC00zJAIpWBop6tgg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ef8d:b0:19a:fa2f:559e with SMTP id
 iz13-20020a170902ef8d00b0019afa2f559emr6221804plb.3.1678211594391; Tue, 07
 Mar 2023 09:53:14 -0800 (PST)
Date:   Tue, 7 Mar 2023 09:53:12 -0800
In-Reply-To: <425d56ca2a2c9eb3a0bd4019706aee6db5dd8fc6.camel@linux.intel.com>
Mime-Version: 1.0
References: <20230217225449.811957-1-seanjc@google.com> <20230217225449.811957-3-seanjc@google.com>
 <425d56ca2a2c9eb3a0bd4019706aee6db5dd8fc6.camel@linux.intel.com>
Message-ID: <ZAd6CMlwf7cZkQo9@google.com>
Subject: Re: [PATCH 2/2] Documentation/process: Add a maintainer handbook for
 KVM x86
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023, Robert Hoo wrote:
> On Fri, 2023-02-17 at 14:54 -0800, Sean Christopherson wrote:
> > +Branches
> > +~~~~~~~~
> > +The KVM x86 tree is organized into multiple topic branches.  The
> > purpose of
> > +using finer-grained topic branches is to make it easier to keep tabs
> > on an area
> > +of development, and to limit the collateral damage of human errors
> > and/or buggy
> > +commits, e.g. dropping the HEAD commit of a topic branch has no
> > impact on other
> > +in-flight commits' SHA1 hashes, and having to reject a pull request
> > due to bugs
> > +delays only that topic branch.
> > +
> > +All topic branches, except for ``next`` and ``fixes``
> 
> What's this "fixes" branch for?
> If fixes for current cycle, will apply to main KVM tree; if fixes for
> next cycle, why not directly to its topic branch or next branch (kvm-
> x86 tree)?

kvm-x86/fixes is a placeholder for carrying fixes for the current cycle.  I
deliberately hedged in the previous section by saying "Generally speaking".  I.e.
the vast majority of fixes will be applied to the main tree, but there may be
situations where I gather fixes in kvm-x86 and send a pull request to Paolo, e.g.
that may be easier if Paolo is on holiday for an extended period.

 : Generally speaking, fixes for the current cycle are applied directly to the
 : main KVM tree, while all development for the next cycle is routed through the
 : KVM x86 tree.

I'll add a blurb to the above paragraph to clarify that fixes _may_ be carried in
kvm-x86/fixes.

> I see in main KVM tree, its "fixes" branch is very inactive.

AFAIK, Paolo doesn't use it at all.

> Too many functional branches will add your maintenance burden.

There's definitely a point where more branches would be a bad thing, but I don't
think having a "fixes" branch moves the needle on that front.

> > , are rolled into ``next``
> > +via a cthulu merge on an as-needed basis, i.e. when a topic branch
> > is updated.
> > +As a result, force pushes to ``next`` are common.
> > +
> > +Lifecycle
> > +~~~~~~~~~
> > +Pull requests for the next release cycle are sent to the main KVM
> > tree, one
> > +for each KVM x86 topic branch. 
> 
> Will each KVM x86 topic branch has a mapping topic branch in main KVM
> tree? I mean where is their pull target(s), next branch in main KVM
> tree? or their counterpart branches in main KVM tree?

Barring some esoteric edge case, the target will be kvm/next or kvm/queue.  Merging
to a topic branch and then merging again would add no value.  I'd prefer not to add
anything to clarify the target because (a) it's technically outside the scope of KVM
x86 and (b) it simply doesn't matter as far as KVM x86 is concerned.  E.g. if Paolo
wants/needs to merge a topic branch somewhere else for whatever reason, that doesn't
impact the KVM x86 lifecycle in any way.

> >  If all goes well, the topic branches are rolled
> > +into the main KVM pull request sent during Linus' merge
> > window.  Pull requests
> > +for KVM x86 branches are typically made the week before Linus'
> > opening of the
> > +merge window, e.g. the week following rc7 for "normal" releases.
> > +
> > +The KVM x86 tree doesn't have its own official merge window, but
> > there's a soft
> > +close around rc5 for new features, and a soft close around rc6 for
> > fixes.
> > +
> > 
> > +Comments
> > +~~~~~~~~
> > +Write comments using imperative mood and avoid pronouns.  Use
> > comments to
> > +provide a high level overview of the code, and/or to explain why the
> > code does
> > +what it does.  Do not reiterate what the code literally does; let
> > the code
> > +speak for itself.  If the code itself is inscrutable, comments will
> > not help.
> 
> Welcome comments that state preconditions for calling this function?
> e.g. some lock held.

Hard "no".  Any non-obvious preconditions should be conveyed through lockdep
assertions, WARNs, etc...
