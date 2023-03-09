Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1566B2BFF
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 18:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjCIR0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 12:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCIRZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 12:25:58 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A1EF31E7
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 09:25:56 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p10-20020a170902e74a00b0019ec1acba17so1411363plf.0
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 09:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678382756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nAzHwxIzKgR5cpPFlKSmTV6wBjCG9GNYIIeb+EiWOEw=;
        b=pcfEThEU4Vasj7WYR/Waxpaik/NppP6KUs9ppDrOWtyN2K2o4KqOmGK0EDNvaR1PpN
         /UnLgb4a0okqN8xPoiVdvT3V4a3xQpbxcpQw+hqc3obdWDA1zbjdpsZMinO2+XGf0pnk
         tx9vE4rRQCJ5voH+cpItfZtOeBNDgs3HFupLFCjAMoI4yqWp5+vfnERiQVRovGhbDJlD
         OI+CCOqeKsFNSgk9agGxkWOLj6VAn6Cx55qyTcqfd2JJGxyGwRwezuRC/2e6nTnTf9sd
         6ToNYA8q0vemzt2KRH+BjeI+gz/XbfE+MvBJgD+F+nwK3UPkZ0AbCSmlQJnwfuNg6ozs
         ZadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678382756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nAzHwxIzKgR5cpPFlKSmTV6wBjCG9GNYIIeb+EiWOEw=;
        b=tUrb3esTdeUKt7Mp1I9d9g/s+ZyFocclh009kOGmixWyAiuKijv2z0/6Oy3bc/stCW
         A6WCk6r+L7K43PMn47dvvsPNi7kRTYjzB91biK9jj3kqX7d3SMnZ9dIM3wOZySip+sib
         T7NfhYjxEZCbRYJ8NPQ+MqjqGk9xSfHeXb40l6iea1sGXT1EYHDe56P7clepHxOXsYjT
         lPRjg+2xiD2BPA5GOpl1MNQY1wzn0N/DA2rmr3C7L33T++3fvFFOI71wHKxNxIJfrBQm
         6TmnNN2SDG6N7bt9AjAR1iSxBDxSWBTh6D5Dhmsh9t4aG80l7mPbbXPKZbQEHdsVYg9m
         l1sA==
X-Gm-Message-State: AO0yUKUsumi020HrNbPXoEle4qVUGSnXLb7A8JXteCoR6YFXxq48aIjG
        xljkHNQfpP5lGoy84dU/6XiPSjC08ng=
X-Google-Smtp-Source: AK7set/wzMVIYZAs4ttZZ0eOPrOq++LXdebZdExp7oCzxxYkXloK+akjBCXw06ZtDEXNHa6PBgMRsLH3hjo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:4293:b0:199:ab4:e140 with SMTP id
 ju19-20020a170903429300b001990ab4e140mr8601038plb.6.1678382756129; Thu, 09
 Mar 2023 09:25:56 -0800 (PST)
Date:   Thu, 9 Mar 2023 09:25:54 -0800
In-Reply-To: <ZAmWefGcsBwcODxW@linux.dev>
Mime-Version: 1.0
References: <20230309010336.519123-1-seanjc@google.com> <20230309010336.519123-3-seanjc@google.com>
 <ZAlGeYAmvhPmVmGe@debian.me> <ZAmWefGcsBwcODxW@linux.dev>
Message-ID: <ZAoWogdeET5N0mug@google.com>
Subject: Re: [PATCH v2 2/2] Documentation/process: Add a maintainer handbook
 for KVM x86
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Shier <pshier@google.com>,
        Anish Ghulati <aghulati@google.com>,
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

On Thu, Mar 09, 2023, Oliver Upton wrote:
> On Thu, Mar 09, 2023 at 09:37:45AM +0700, Bagas Sanjaya wrote:
> > On Wed, Mar 08, 2023 at 05:03:36PM -0800, Sean Christopherson wrote:
> > > +As a general guideline, use ``kvm-x86/next`` even if a patch/series touches
> > > +multiple architectures, i.e. isn't strictly scoped to x86.  Using any of the
> > > +branches from the main KVM tree is usually a less good option as they likely
> > > +won't have many, if any, changes for the next release, i.e. using the main KVM
> > > +tree as a base is more likely to yield conflicts.  And if there are non-trivial
> > > +conflicts with multiple architectures, coordination between maintainers will be
> > > +required no matter what base is used.  Note, this is far from a hard rule, i.e.
> > > +use a different base for multi-arch series if that makes the most sense.
> 
> I don't think this is the best way to coordinate with other architectures.
> Regardless of whether you intended this to be prescriptive, I'm worried most
> folks will follow along and just base patches on kvm-x86/next anyway.

Probably, but for the target audience (KVM x86 contributors), that's likely the
least awful base 99% of the time.

> It'd be easier to just have multi-arch series use a stable base (i.e. a
> release candidate) by default. That'd avoid the undesirable case where merging
> a shared branch brings with it some random point in another arch's /next
> history.

You're conflating the base of the patch series with the branch it is applied to.
I'm most definitely not proposing that multi-arch series from x86 contributors
always be routed through kvm-x86.  It's ultimately the responsibility of the
maintainers, not the contributors, to avoid funky merges and histories.  If a
series warrants a dedicated topic branch, then we need to create said topic branch
off a stable, common base, irrespective of what the contributor based their patches
on.

If a series from an x86 contributor applies cleanly on kvm-x86/next but not on
-rc2 (or whatever), then the reverse would also likely be true (if the contributor
used -rc2 as the base).  In other words, for series with non-trivial modifications
to other architectures and/or common KVM code, IMO the base used for the _initial_
posting doesn't matter all that much for us maintainers since such series will
likely require additional attention no matter what base is used.

On the flip side, the vast majority of "multi-arch" series in KVM tend to be focused
on a single architecture, with only incidental contact to other architectures and/or
common KVM code.  Those types of series will likely be routed through their "target"
arch tree, and so for x86, using kvm-x86/next as the base is preferrable.

My goal with suggesting/prescribing kvm-x86/next to contributors is to make the
easy things easy.  On my end, that means having _predictable_ submissions and
minimizing the number of avoidable conflicts.  For contributors, that means having
a very simple rule/guideline.  "Use kvm-x86/next unless you know better" satisfies
all those conditions.

> If a different approach makes sense for a particular series then we can
> discuss it on the list and arrive at something agreeable for all parties
> involved.
> 
> > That means patches that primarily kvm ARM changes should be based on
> > kvm-x86/next, right?
> 
> No, don't do that.

+<infinity symbol>

This doc is specifically for KVM x86.
