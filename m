Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB526B8053
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 19:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCMSVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 14:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjCMSVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 14:21:31 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504547B13F
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 11:20:58 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id t24-20020a1709028c9800b0019eaa064a51so7573102plo.10
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 11:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678731646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PM1IiLzVG/B4LJKhOIh/ybnm8AKBtKs/8CdHZzs7DFU=;
        b=d/+teK+i7sS+d/usRhN+9F8Qr9EAR7PhlfIz/9vpEC4zt1uYTptLwKRiv1xzN/x3lN
         u2jsV4wAIzZrot0B3jOgcAvXuX9g8yVAIJDfMXNotToHsK5F2F8zm9QTDEWD0Wo/kv3x
         a5Kzc13vXRazuPTgrMqulzB7AVAeqeXojiBB/QiWjOQM9NmOXyZh8hdyGSMttoU4/cqa
         BewXEX3IZy6wxhZmNPZCmcH8eiVpBcfl16rAZiYitY4pm2P7S4IcVlwB+4ZQk3/7xgWy
         +OY804v081fe6O/NB5ssSYUNHu98BUlKGgNBrmFxP1OpldLSBGlNPhs7FzMyZnQUg1d3
         S4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678731646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PM1IiLzVG/B4LJKhOIh/ybnm8AKBtKs/8CdHZzs7DFU=;
        b=6S8oQAHw65o1A3JZATmkOQo5HrPTW9YJTkxAIAIqm7NcfXxhPmh8D1ELByRiIgFVM3
         tMF39fvjPjpHqg2Y2LbVZS7seOWK8NN5A2gGc1C3eJX9+2dPCbO8xZOgEyAjU5MukkAc
         1JfxQ3AvkPAW3JsOrosKYvxm5l6a4kl07O3Zl1I5OvKT0jLCSx6/vi6gurjtq7vhF/Jk
         cSPvSBtJ0mqcXFpu8bMD2T+CQfSyEFHZDWKxwMFdrmvDnPsZNnGGLWZNK5rgFW8y85Zw
         W74CTRl7FaydjItoT0CJ/qlduZHo1d7CrX/x0uluyDgbSOFOn0onO2cx0YA6WRharOAq
         TMvw==
X-Gm-Message-State: AO0yUKV1S1XqyrEGy4RakDgpF4pEZE1iyyb6IGpn/0naz7PZs9vpusdS
        KTeu55N5ybl/r5IhpVSteFZ8HObSjhg=
X-Google-Smtp-Source: AK7set/qMjcNp7uU3kUB/Z9T5GwUkXhBd0BbVLbVayOtobwc51czDDEXl0I7nwE5t5UL3rZ9Rcx8zaNApc0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1d04:0:b0:623:8a88:1bba with SMTP id
 d4-20020a621d04000000b006238a881bbamr2020291pfd.2.1678731646573; Mon, 13 Mar
 2023 11:20:46 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:20:45 -0700
In-Reply-To: <ZA9eHzE5vhnXh+TA@linux.dev>
Mime-Version: 1.0
References: <20230309010336.519123-1-seanjc@google.com> <20230309010336.519123-3-seanjc@google.com>
 <ZAlGeYAmvhPmVmGe@debian.me> <ZAmWefGcsBwcODxW@linux.dev> <ZAoWogdeET5N0mug@google.com>
 <ZA9eHzE5vhnXh+TA@linux.dev>
Message-ID: <ZA9pfbhypRNPhdN8@google.com>
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

On Mon, Mar 13, 2023, Oliver Upton wrote:
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
> 
> If folks are aiming to make a multi-arch contribution then the architecture
> they regularly contribute to has absolutely zero relevance on the series
> itself.

There's disconnect between what my brain is thinking and what I wrote.

The intent of the "use kvm-x86/next" guideline is aimed to address series that
are almost entirely x86 specific, and only superficially touch common KVM and/or
other architectures.  In my experience, the vast, vast majority of "multi-arch"
contributions from x86 fall into this category, i.e. aren't truly multi-arch in
nature.

If I replace the above paragraph with this, does that address (or at least mitigate
to an acceptable level) your concerns?  Inevitably there will still be series that
are wrongly based on kvm-x86, but I am more than happy to do the policing.  I
obviously can't guarantee that I will be the first to run afoul of a "bad" series,
but I do think I can be quick enough to avoid shifting the burden to other
maintainers.  And if I'm wrong on either front, you get to say "told you so" and
make me submit a patch of shame ;-)

  The only exception to using ``kvm-x86/next`` as the base is if a patch/series
  is a multi-arch series, i.e. has non-trivial modifications to common KVM code
  and/or has more than superficial changes to other architectures's code.  Multi-
  arch patch/series should instead be based on a common, stable point in KVM's
  history, e.g. the release candidate upon which ``kvm-x86 next`` is based.  If
  you're unsure whether a patch/series is truly multi-arch, err on the side of
  caution and treat it as multi-arch, i.e. use a common base.

> > > > That means patches that primarily kvm ARM changes should be based on
> > > > kvm-x86/next, right?
> > > 
> > > No, don't do that.
> > 
> > +<infinity symbol>
> > 
> > This doc is specifically for KVM x86.
> 
> You've also made some suggestions about cross-arch development that do not fit
> the development model of other architectures. I have no desire to nitpick
> about the x86 process but want the multiarch language to actually set folks up
> for success working outside of the KVM/x86 tree.

Ah, I see where y'all are coming from.  Yeah, I didn't intend for that type of
blanket rule, e.g. my comment about this being specifically for KVM x86 was
intended to clarify that this doc should NOT be used to determine how to handle
non-x86 code.
