Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF1F741084
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 13:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbjF1Lzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 07:55:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:55149 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231504AbjF1Lzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 07:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687953332; x=1719489332;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WenmENrCtD5NWaxfSXRbwYTJrz8lTYnfUODoBwJSvko=;
  b=R8RwFHxL/5YtLhUhbbNvU5eQBlWQ5u570JNucuG5VRckVqgOv+h+tJt0
   5HTxM+Ugr8PukDmwsf3fY96jbUzYSG4CHVcg+o8b8tqqTjD/j2oeetV37
   YeKEXgDr3lzEZbLeXp23MOCARTIlCum66+r7YYikFnqlabXaWkgeS8VZ6
   fCWoxAnq+MInX7vL8mOA8FFqFJu4lgRxHe6N/XOM+PQ7/FR+wzNHXilE3
   OX1iPk6CxBdFTLw1xzjhlqIV5gYDLGOVAW/dxTO36HV/l9El1LGKL4reD
   5CUF3tkCK9brtq0MXgOFkf2VRV/4e5MJAtzsCjG+eU3kDYk+8aIX0Kuyj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="361865554"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="361865554"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 04:55:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="711019721"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="711019721"
Received: from rajritu-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.47.187])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 04:55:24 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 57DD21095C8; Wed, 28 Jun 2023 14:55:21 +0300 (+03)
Date:   Wed, 28 Jun 2023 14:55:21 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230628115521.bo7x6lhonsmyvr7v@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
 <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
 <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
 <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
 <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 12:28:12AM +0000, Huang, Kai wrote:
> On Tue, 2023-06-27 at 22:37 +0000, Huang, Kai wrote:
> > > > 
> > > > +/*
> > > > + * Do the module global initialization if not done yet.
> > > > + * It's always called with interrupts and preemption disabled.
> > > > + */
> > > 
> > > If interrupts are always disabled why do you need _irqsave()?
> > > 
> > 
> > I'll remove the _irqsave().
> > 
> > AFAICT Isaku preferred this for additional security, but this is not
> > necessary.
> > 
> > 
> 
> Damn.  I think we can change the comment to say this function is called with
> preemption being disabled, but _can_ be called with interrupt disabled.  And we
> keep using the _irqsave() version.
> 
> 	/*
> 	 * Do the module global initialization if not done yet.  It's always
> 	 * called with preemption disabled and can be called with interrupts
> 	 * disabled.
> 	 */
> 
> This allows a use case that the caller simply wants to call some SEAMCALL on
> local cpu, e.g., IOMMU code may just use below to get some TDX-IO information:
> 
> 	preempt_disable();
> 	vmxon();
> 	tdx_cpu_enable();
> 	SEAMCALL;
> 	vmxoff();
> 	preempt_enable();
> 
> Are you OK with this?

Is it hypothetical use-case? If so, I would rather keep it simple for now
and adjust in the future if needed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
