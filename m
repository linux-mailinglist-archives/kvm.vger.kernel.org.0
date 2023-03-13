Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AFE6B7F8D
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 18:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjCMRc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 13:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjCMRcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 13:32:55 -0400
Received: from out-38.mta1.migadu.com (out-38.mta1.migadu.com [IPv6:2001:41d0:203:375::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0E924CAE
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 10:32:32 -0700 (PDT)
Date:   Mon, 13 Mar 2023 17:32:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678728748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oSimWHYH2lVyX1VD90V/L4j8kwRRJGcNk5nCqgP2JAU=;
        b=PJWEINEgTzy0YHyxA+TAT/5Uf4XwnQ31PLXHuQjMDuRf52uTgSs7QXYtDY0Q3fnUWHUNEA
        VZmt2gRJbZxNQB0jx9pEuCeKv+LKcqFtjbIaLm/DZryoWMcWMhQw8ly7Ex+LLbxAoRPJGF
        YLAsnidmNXvS9vnD5iF/pMSLhPywr74=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
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
Subject: Re: [PATCH v2 2/2] Documentation/process: Add a maintainer handbook
 for KVM x86
Message-ID: <ZA9eHzE5vhnXh+TA@linux.dev>
References: <20230309010336.519123-1-seanjc@google.com>
 <20230309010336.519123-3-seanjc@google.com>
 <ZAlGeYAmvhPmVmGe@debian.me>
 <ZAmWefGcsBwcODxW@linux.dev>
 <ZAoWogdeET5N0mug@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAoWogdeET5N0mug@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 09, 2023 at 09:25:54AM -0800, Sean Christopherson wrote:
> On Thu, Mar 09, 2023, Oliver Upton wrote:
> > On Thu, Mar 09, 2023 at 09:37:45AM +0700, Bagas Sanjaya wrote:
> > > On Wed, Mar 08, 2023 at 05:03:36PM -0800, Sean Christopherson wrote:
> > > > +As a general guideline, use ``kvm-x86/next`` even if a patch/series touches
> > > > +multiple architectures, i.e. isn't strictly scoped to x86.  Using any of the
> > > > +branches from the main KVM tree is usually a less good option as they likely
> > > > +won't have many, if any, changes for the next release, i.e. using the main KVM
> > > > +tree as a base is more likely to yield conflicts.  And if there are non-trivial
> > > > +conflicts with multiple architectures, coordination between maintainers will be
> > > > +required no matter what base is used.  Note, this is far from a hard rule, i.e.
> > > > +use a different base for multi-arch series if that makes the most sense.
> > 
> > I don't think this is the best way to coordinate with other architectures.
> > Regardless of whether you intended this to be prescriptive, I'm worried most
> > folks will follow along and just base patches on kvm-x86/next anyway.
> 
> Probably, but for the target audience (KVM x86 contributors), that's likely the
> least awful base 99% of the time.

Sorry, I follow this reasoning at all.

If folks are aiming to make a multi-arch contribution then the architecture
they regularly contribute to has absolutely zero relevance on the series
itself.

> > It'd be easier to just have multi-arch series use a stable base (i.e. a
> > release candidate) by default. That'd avoid the undesirable case where merging
> > a shared branch brings with it some random point in another arch's /next
> > history.
> 
> You're conflating the base of the patch series with the branch it is applied to.

We cannot pretend the two are in no way related. The dependencies of a series
are not obvious when based on the /next branch of any one architecture.

> I'm most definitely not proposing that multi-arch series from x86 contributors
> always be routed through kvm-x86.  It's ultimately the responsibility of the
> maintainers, not the contributors, to avoid funky merges and histories.

Right, but contributors looking to make changes across architectures share
some of the burden of cross-arch coordination as well. Basing patches off of
a random commit not in Linus' tree does not match at least the arm64
workflow.

> If a
> series warrants a dedicated topic branch, then we need to create said topic branch
> off a stable, common base, irrespective of what the contributor based their patches
> on.

The lowest friction way to coordinate such things is to start off with a
common base and go from there. If there is a compelling argument for doing
things differently in the context of one series then let's talk about it on
the list.

> If a series from an x86 contributor applies cleanly on kvm-x86/next but not on
> -rc2 (or whatever), then the reverse would also likely be true (if the contributor
> used -rc2 as the base).

This can be addressed in a merge resolution, thereby offloading the
responsibility to the maintainer.

> In other words, for series with non-trivial modifications
> to other architectures and/or common KVM code, IMO the base used for the _initial_
> posting doesn't matter all that much for us maintainers since such series will
> likely require additional attention no matter what base is used.

In all likelihood, sure the series will be respun. But, you're offloading the
responsibility to ask for a sane base on other arch maintainers which I'm not
cool with.

> On the flip side, the vast majority of "multi-arch" series in KVM tend to be focused
> on a single architecture, with only incidental contact to other architectures and/or
> common KVM code.  Those types of series will likely be routed through their "target"
> arch tree, and so for x86, using kvm-x86/next as the base is preferrable.

With long term aspirations to share more code between architectures (e.g.
common MMU) I believe we'll see more changes that have meaningful interaction
with all architecutures.

> My goal with suggesting/prescribing kvm-x86/next to contributors is to make the
> easy things easy.  On my end, that means having _predictable_ submissions and
> minimizing the number of avoidable conflicts.  For contributors, that means having
> a very simple rule/guideline.  "Use kvm-x86/next unless you know better" satisfies
> all those conditions.

I believe "Use a release candidate unless you know better" for multi-arch
changes is just as simple. Better yet, it clues in contributors as to how
changes are coordinated across architectures and might help them know better
next time around.

> > If a different approach makes sense for a particular series then we can
> > discuss it on the list and arrive at something agreeable for all parties
> > involved.
> > 
> > > That means patches that primarily kvm ARM changes should be based on
> > > kvm-x86/next, right?
> > 
> > No, don't do that.
> 
> +<infinity symbol>
> 
> This doc is specifically for KVM x86.

You've also made some suggestions about cross-arch development that do not fit
the development model of other architectures. I have no desire to nitpick
about the x86 process but want the multiarch language to actually set folks up
for success working outside of the KVM/x86 tree.

-- 
Thanks,
Oliver
