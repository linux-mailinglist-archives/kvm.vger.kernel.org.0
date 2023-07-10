Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DAE74DCE5
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 19:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjGJR6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 13:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjGJR6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 13:58:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6703AD
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 10:58:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-666edb1f24aso8398722b3a.2
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 10:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689011896; x=1691603896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y3Kh6x6stmaNirlbTTjGLpQMo7AQpwDDe4+8wKlDwRI=;
        b=gny4Y0B5iRsAfscYzrlANXGnpPraf2ilAIKd3sBAIh7ljOzLacn90WAyUN5AvepX85
         bIE3BREZHLXXu1fbO1DnDO7/Txd4D4Phqr5bv2xfc57JMqgiJJ60C7BoY78DdMgvLs3a
         KYwEX5FcX7Xft89IBFx/v6pb9jfduOWZpbakgiHxCgiXA4OHE1oxPucHk89myUYss1iY
         PgY91LPFn2VqguNAxgLSPqVNpqLRpC5llIc3264JmY+vcQUUKxR21R4GvzyLcnyDOhJZ
         XZjdho6cyjinpS04GxwPizzBgqrPEmndPWvsjxiTDPz86ua7yPbNWQ46I3Rh93i/g7/9
         UyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689011896; x=1691603896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3Kh6x6stmaNirlbTTjGLpQMo7AQpwDDe4+8wKlDwRI=;
        b=ULii4MAj009yHDahBkCB95yNdD3050biGgZPVPuaeF9Fq+PHbleXHnDB9Y3QlbkLR2
         AKS1xVtBVAwJ5wh0WEekPhcBYT4f5Xk+W5PlioARDNpr4i8NSO9XXRoRB60xPf0PwBFY
         XivZqU7W56pD2Mlvoj5IqW6MzVMWgSTdOAtnIpeodk2q0xiEMAHI7mZdXv0MUzg+uiJ+
         7qq2IAW2xijlQKi5XOXjAea2Khgqjh2n55oXMT/J4VKA5MBk8Aoad/eAPaSMDlrbCDOX
         vDDzoVjyVQidq4akfxV+QqHr57IvDI4peEnFv2dWqn7mQhzbsv8vN7BbvbP4Ts1xDtdz
         3EVg==
X-Gm-Message-State: ABy/qLYv8uhzqILrF1AcGTNd2O7QuDcVW9Dsf1zHbfSM4RnVR+LYShQ8
        pag7vXsovcWdEbLtJ+0fT9xS5os9h+4=
X-Google-Smtp-Source: APBJJlFmQK5y/3ZF/NjQlJqwclOEqbzaB1jgwJKq1XVmV19HcVuZ2WkNRE92ggPf7JX2d7+bEIjB7YBzXzM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3998:b0:668:7143:50ea with SMTP id
 fi24-20020a056a00399800b00668714350eamr18119150pfb.4.1689011896073; Mon, 10
 Jul 2023 10:58:16 -0700 (PDT)
Date:   Mon, 10 Jul 2023 10:58:14 -0700
In-Reply-To: <0c32f845-aad0-3059-2efa-9f6e3bb3affb@intel.com>
Mime-Version: 1.0
References: <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net> <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com> <20230704165836.GB462772@hirez.programming.kicks-ass.net>
 <1a8099e2-da28-6b2a-7b5a-1d6346b7f95d@intel.com> <20230705145750.GD4253@hirez.programming.kicks-ass.net>
 <0c32f845-aad0-3059-2efa-9f6e3bb3affb@intel.com>
Message-ID: <ZKxGtl7ErXCG5joz@google.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on demand
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Len Brown <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Ying Huang <ying.huang@intel.com>,
        Dan J Williams <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023, Dave Hansen wrote:
> On 7/5/23 07:57, Peter Zijlstra wrote:
> > On Wed, Jul 05, 2023 at 07:34:06AM -0700, Dave Hansen wrote:
> >> On 7/4/23 09:58, Peter Zijlstra wrote:
> >>> If we have concerns about allocating the PAMT array, can't we use CMA
> >>> for this? Allocate the whole thing at boot as CMA such that when not
> >>> used for TDX it can be used for regular things like userspace and
> >>> filecache pages?
> >> I never thought of CMA as being super reliable.  Maybe it's improved
> >> over the years.
> >>
> >> KVM also has a rather nasty habit of pinning pages, like for device
> >> passthrough.  I suspect that means that we'll have one of two scenarios:
> >>
> >>  1. CMA works great, but the TDX/CMA area is unusable for KVM because
> >>     it's pinning all its pages and they just get moved out of the CMA
> >>     area immediately.  The CMA area is effectively wasted.
> >>  2. CMA sucks, and users get sporadic TDX failures when they wait a long
> >>     time to run a TDX guest after boot.  Users just work around the CMA
> >>     support by starting up TDX guests at boot or demanding a module
> >>     parameter be set.  Hacking in CMA support was a waste.
> >>
> >> Am I just too much of a pessimist?
> > Well, if CMA still sucks, then that needs fixing. If CMA works, but we
> > have a circular fail in that KVM needs to long-term pin the PAMT pages
> > but long-term pin is evicted from CMA (the whole point of long-term pin,
> > after all), then surely we can break that cycle somehow, since in this
> > case the purpose of the CMA is being able to grab that memory chunk when
> > we needs it.
> > 
> > That is, either way around is just a matter of a little code, no?
> 
> It's not a circular dependency, it's conflicting requirements.
> 
> CMA makes memory more available, but only in the face of unpinned pages.
> 
> KVM can pin lots of pages, even outside of TDX-based VMs.
> 
> So we either need to change how CMA works fundamentally or stop KVM from
> pinning pages.

Nit, I think you're conflating KVM with VFIO and/or IOMMU code.  Device passhthrough
does pin large chunks of memory, but KVM itself isn't involved or even aware of
the pins.

HugeTLB is another case where CMA will be effectively used to serve guest memory,
but again KVM isn't the thing doing the pinning.
