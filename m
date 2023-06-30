Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C1E744239
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjF3Saw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 14:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjF3Sat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 14:30:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D6211F;
        Fri, 30 Jun 2023 11:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CbMDicFOeY5VdckkPN/BPu5OIcTYRlOakMO4pzeR/1s=; b=h03AT+EgdHGL4gmfUn6nIQf9kH
        tELcfcbxNx0EqJWT5XOxA9ZzAKMuqZW6XgnUq950oj8vWss02KuLnaDjVw94Ajimy1any1YceyFR1
        U1yb8klAe0V3ySXfH3TneSOe2xHvZDO/MApSEtk0qHKoA9TjdcIfay9yn2KtAPkRJAIm7prGPyPfz
        52C0MdaendV3o4ok05d0OwwXQ6cDBvfh1OT3pM2yxtyZlSEde4fF3LlR1J8lHXLMVWWXSOxietDx/
        fwFzj/EWWyW4GJPVLKcip3eE27+oqwqlRGnHY6FISc/OFtMPzNAvPT9TPckRpBCQ1fhQopG1hfYPm
        +RlqUpoQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qFIsx-005uVm-5a; Fri, 30 Jun 2023 18:30:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0500B3002E1;
        Fri, 30 Jun 2023 20:30:21 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DD53824824672; Fri, 30 Jun 2023 20:30:20 +0200 (CEST)
Date:   Fri, 30 Jun 2023 20:30:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
Message-ID: <20230630183020.GA4253@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 09:55:32AM +0000, Huang, Kai wrote:
> On Fri, 2023-06-30 at 11:26 +0200, Peter Zijlstra wrote:
> > On Thu, Jun 29, 2023 at 12:10:00AM +0000, Huang, Kai wrote:
> > > On Wed, 2023-06-28 at 15:17 +0200, Peter Zijlstra wrote:
> > > > On Tue, Jun 27, 2023 at 02:12:37AM +1200, Kai Huang wrote:
> > > > > +EXPORT_SYMBOL_GPL(tdx_cpu_enable);
> > > > 
> > > > I can't find a single caller of this.. why is this exported?
> > > 
> > > It's for KVM TDX patch to use, which isn't in this series.
> > > 
> > > I'll remove the export.  KVM TDX series can export it.
> > 
> > Fair enough; where will the KVM TDX series call this? Earlier there was
> > talk about doing it at kvm module load time -- but I objected (and still
> > do object) to that.
> > 
> > What's the current plan?
> > 
> 
> The direction is still doing it during module load (not my series anyway).  But
> this can be a separate discussion with KVM maintainers involved.

They all on Cc afaict.

> I understand you have concern that you don't want to have the memory & cpu time
> wasted on enabling TDX by default.  For that we can have a kernel command line
> to disable TDX once for all (we can even make it default).

That's insane, I don't want to totally disable it. I want it done at
guard creation. Do the whole TDX setup the moment you actually create a
TDX guast.

Totally killing TDX is stupid, just about as stupid as doing it on
module load (which equates to always doing it).

> Also, KVM will have a module parameter 'enable_tdx'.  I am hoping this could
> reduce your concern too.

I don't get this obsession with doing at module load time :/
