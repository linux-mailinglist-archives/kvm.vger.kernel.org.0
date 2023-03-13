Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBC66B7F9F
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 18:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCMRiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 13:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCMRit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 13:38:49 -0400
Received: from out-42.mta1.migadu.com (out-42.mta1.migadu.com [IPv6:2001:41d0:203:375::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8A7457F7
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 10:38:45 -0700 (PDT)
Date:   Mon, 13 Mar 2023 17:38:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678729123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ybjm14aOpi7A3aopxAqo4v6WPM99l74ygtnwOLCEz88=;
        b=qKL8BE7By0J03+sOQJyOVoPjg1EGaqkkILFMuvPubmJwJo5R2I4Ioa3AvwEaBz6xeymaZv
        fSiwHIOu2V9lLMl5hGzbssWXHnbWFVtrn7RUibLPjv8SLEBZ3oZbk6sfw51BVun6oviMRP
        /MmVzX2rgkW/XRE5u55rvZjO02g9bOE=
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
Message-ID: <ZA9flqMBSlW95S/i@linux.dev>
References: <20230309010336.519123-1-seanjc@google.com>
 <20230309010336.519123-3-seanjc@google.com>
 <ZAlGeYAmvhPmVmGe@debian.me>
 <ZAmWefGcsBwcODxW@linux.dev>
 <ZAoWogdeET5N0mug@google.com>
 <ZA9eHzE5vhnXh+TA@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA9eHzE5vhnXh+TA@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023 at 05:32:29PM +0000, Oliver Upton wrote:
> On Thu, Mar 09, 2023 at 09:25:54AM -0800, Sean Christopherson wrote:
> > On Thu, Mar 09, 2023, Oliver Upton wrote:
> > > On Thu, Mar 09, 2023 at 09:37:45AM +0700, Bagas Sanjaya wrote:
> > > > On Wed, Mar 08, 2023 at 05:03:36PM -0800, Sean Christopherson wrote:
> > > > > +As a general guideline, use ``kvm-x86/next`` even if a patch/series touches
> > > > > +multiple architectures, i.e. isn't strictly scoped to x86.  Using any of the
> > > > > +branches from the main KVM tree is usually a less good option as they likely
> > > > > +won't have many, if any, changes for the next release, i.e. using the main KVM
> > > > > +tree as a base is more likely to yield conflicts.  And if there are non-trivial
> > > > > +conflicts with multiple architectures, coordination between maintainers will be
> > > > > +required no matter what base is used.  Note, this is far from a hard rule, i.e.
> > > > > +use a different base for multi-arch series if that makes the most sense.
> > > 
> > > I don't think this is the best way to coordinate with other architectures.
> > > Regardless of whether you intended this to be prescriptive, I'm worried most
> > > folks will follow along and just base patches on kvm-x86/next anyway.
> > 
> > Probably, but for the target audience (KVM x86 contributors), that's likely the
> > least awful base 99% of the time.
> 
> Sorry, I follow this reasoning at all.

I *don't* follow ...

-- 
Thanks,
Oliver
