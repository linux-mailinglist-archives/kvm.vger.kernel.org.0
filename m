Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C9674450A
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 01:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjF3XNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 19:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjF3XNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 19:13:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60353AB9;
        Fri, 30 Jun 2023 16:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688166822; x=1719702822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SrteLpfpxpFm4YLNpW3foRZtyRqgWwWsAEa8LqWi7Vg=;
  b=JDsL4OznBzaIG6376E7k3L7zetQF2foRZq2HeMRpyGYhlMJZz5n8MIkj
   Ig+yLYeFMGE9O4ChVngpdc2hQy4WbXqoK75v0sb27BtflXdV5jCcH1bYk
   s2FoXlAyJ3dwjZroK22macwDv0vo4Jm+nvM+yrPtqIt5u/ywa9XabuLoI
   f4WDWD2hzu82MY1cqwQ6HAMKNY4T/W+AFlHHpcmhHa1Ola70b54lCN6er
   Ez+IzkNmoEPP8ZAuGXazQB1YFMZTWYeVf7D+twneIvgzSTJf2GPZReEGd
   WvRnRdz3iDMCGH/hWgI/tGk9s72GCr/EqT1y6Lmj1WcSBCVcKUuPb1CVW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365092686"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="365092686"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 16:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="891911122"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="891911122"
Received: from amuruge1-mobl.amr.corp.intel.com (HELO [10.252.133.96]) ([10.252.133.96])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 16:13:40 -0700
Message-ID: <ade3ca18-659c-26d2-c158-372ba39531c8@intel.com>
Date:   Fri, 30 Jun 2023 16:13:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ZJ9IKALhz1Q6ogu1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/23 14:24, Sean Christopherson wrote:
> That said, if this is a sticking point, let's just make enable_tdx off by default,
> i.e. force userspace to opt-in.  Deployments that *know* they may want to schedule
> TDX VMs on the host can simply force the module param.  And for everyone else,
> since KVM is typically configured as a module by distros, KVM can be unloaded and
> reload if the user realizes they want TDX well after the system is up and running.

Let's just default it to off for now.

If we default it to on, we risk inflicting TDX on existing KVM users
that don't want it (by surprise).  If it turns out to _that_ big of an
inconvenience, we'd have to reverse course and change the default from
on=>off.  *That* would break existing TDX users when we do it.  Gnashing
of teeth all around would ensue.

On the other hand, if we force TDX users to turn it on from day one, we
don't surprise _anyone_ that wasn't asking for it.  The only teeth
gnashing is for the TDX folks.

We could change _that_ down the line if the TDX users get too rowdy.
But I'd much rather err on the side of inconveniencing the guys that
know they want the snazzy new hardware than those who just want to run
plain old VMs.

I honestly don't care all that much either way.  There's an escape hatch
at runtime (reload kvm_intel.ko) no matter what we do.
