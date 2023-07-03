Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E8D745EA6
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 16:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjGCOlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 10:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjGCOlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 10:41:00 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB191B5;
        Mon,  3 Jul 2023 07:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688395259; x=1719931259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oiAYYlrvhxpb7dxgLlbZm7axICahdWtDSJkHwBkZwWs=;
  b=hs8JMq157Qmat2x0sPPHkBWyqlAPYj8DPDNVOV7UWIhnwXwGyulcJo+V
   ElGrqZgsDHQIT3WvcfAz2VTK1esIojbX/r1kWkTy9RFgYLk9OM1AgO2Ea
   XTN9ckEhppp0a23T8eYnqcdolX7TradAdWV7eERvjYdAKZYWSkGWB758h
   XcknFTe/zVNIGlVS2P6VdawxHZ4Ng9I9+TASnuIgFnzdB88lumNks96pO
   3pGPELetLigrhzbrlskpYtDhCHpq/sW+2pXkPCZaQiwWsHKqxLOgmj+Z8
   8xSgLwTeTmYLNzm/xzDDnjZT5GUIG8clSba9UdeK+lYDhlJVeTu7hr3XW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="352724303"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="352724303"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 07:40:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="1049112742"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="1049112742"
Received: from lbates-mobl.amr.corp.intel.com (HELO [10.212.242.115]) ([10.212.242.115])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 07:40:56 -0700
Message-ID: <eb83e722-0379-1451-9c9c-9b9de33cb4cb@intel.com>
Date:   Mon, 3 Jul 2023 07:40:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
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
 <20230703104942.GG4253@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230703104942.GG4253@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/3/23 03:49, Peter Zijlstra wrote:
>> There are also latency and noisy neighbor concerns, e.g. we *really* don't want
>> to end up in a situation where creating a TDX guest for a customer can observe
>> arbitrary latency *and* potentially be disruptive to VMs already running on the
>> host.
> Well, that's a quality of implementation issue with the whole TDX
> crapola. Sounds like we want to impose latency constraints on the
> various TDX calls. Allowing it to consume arbitrary amounts of CPU time
> is unacceptable in any case.

For what it's worth, everybody knew that calling into the TDX module was
going to be a black hole and that consuming large amounts of CPU at
random times would drive people bat guano crazy.

The TDX Module ABI spec does have "Leaf Function Latency" warnings for
some of the module calls.  But, it's basically a binary thing.  A call
is either normal or "longer than most".

The majority of the "longer than most" cases are for initialization.
The _most_ obscene runtime ones are chunked up and can return partial
progress to limit latency spikes.  But I don't think folks tried as hard
on the initialization calls since they're only called once which
actually seems pretty reasonable to me.

Maybe we need three classes of "Leaf Function Latency":
1. Sane
2. "Longer than most"
3. Better turn the NMI watchdog off before calling this. :)

Would that help?
