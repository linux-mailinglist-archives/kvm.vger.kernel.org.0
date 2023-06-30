Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85154743843
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbjF3JZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjF3JZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:25:26 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D7919C;
        Fri, 30 Jun 2023 02:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5kMR4RZMpRfqpCS+yssLHYk+vsmGpmykrhyTHw3S//Q=; b=WU9yNRdiaTprqK+nmhNcQr86y2
        7wrYieC7gE7WxRIyGhL54/cCim7FbFza5Ycv6dCs+7x832Jq8OVnUyy1r4LvbYij4InFAadiUUWRH
        YtgDtSw64N5rH4Qk9WCEpPWsZjroMrgw9mTxG41eCZ6sYzVAYIqdWHq2b6/Ez7FV47ORJ31MEd0Pk
        o6M37G9TOfsiaKXYgwrzHFjhg+m2CFKmCthDTC5f+Q/2zLSdtss26+rU3b/9kSEJ/LRiQ6jCvMR6l
        RKvtQCVvODSNvoS82FrHwP0LpaY7rw2MHUqWrNBjl+WEr7WaBWohscBgiQdE4675MGkPQYImgVSxG
        dIKo4nsA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qFANE-007wLX-0U;
        Fri, 30 Jun 2023 09:25:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BCCC4300118;
        Fri, 30 Jun 2023 11:25:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A4606245D3645; Fri, 30 Jun 2023 11:25:03 +0200 (CEST)
Date:   Fri, 30 Jun 2023 11:25:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230630092503.GC2533791@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628130419.GC2438817@hirez.programming.kicks-ass.net>
 <20322f0432e418eaacfe397aa9363f94ada0b902.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20322f0432e418eaacfe397aa9363f94ada0b902.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 12:00:44AM +0000, Huang, Kai wrote:

> The spec says it doesn't have a latency requirement, so theoretically it could
> be long.  SEAMCALL is a VMEXIT so it would at least cost thousands of cycles.

:-(

> If raw_spinlock isn't desired, I think I can introduce another function to do
> this and let the caller to call it before calling tdx_cpu_enable().  E.g., we
> can have below functions:
> 
> 1) tdx_global_init()	-> TDH_SYS_INIT
> 2) tdx_cpu_init()	-> TDH_SYS_LP_INIT
> 3) tdx_enable()		-> actual module initialization
> 
> How does this sound?

Ah, wait, I hadn't had enough wake-up juice, it's tdx_global_init() that
did the raw_spinlock_t, but that isn't the IPI thing.

Then perhaps just use a mutex to serialize things?


