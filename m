Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7E6C2D65
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 10:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCUJCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 05:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjCUJCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 05:02:20 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52938392BA;
        Tue, 21 Mar 2023 02:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KH5F80yINO5u+Qvwf3LF3BCo0e24JRTEVrTz/LTZRGo=; b=QGqDX+L1MgXmk/OGgeESIDl2wU
        t7zOTahpKY55fj8oVrKsY4pNI/kFOe0lk5kaufyqp7zPbG9axv0R+KOlpIrnwy6t9l1htAw1SLlKP
        uzX1t0OuCxeweOCUGiBAo628MzMnKf8mWw5cQDsxGSDI/Cqy/VQUVaYhMVlzT6m3ALVyQ3dpFEN16
        eNmuImAg0+r0gsNi1nXOmF4lzBJXzm25dG1hudq85LBM3eJ275LDtJUtWoWFXHVWSZa6Fn41BXYWI
        mHqUY4VIT6fx42I3Wy2InWgGAYqoVqFOcPfTGnGsJ2KrOgWwFHgwhmpGezGdSMPmDEpLn7yYSueV/
        fjx75nTQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peXqW-004DSz-0U;
        Tue, 21 Mar 2023 08:59:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 641803002C0;
        Tue, 21 Mar 2023 09:59:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3B63E205414ED; Tue, 21 Mar 2023 09:59:53 +0100 (CET)
Date:   Tue, 21 Mar 2023 09:59:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [PATCH v5 20/34] x86/fred: add a machine check entry stub for
 FRED
Message-ID: <20230321085953.GA2234901@hirez.programming.kicks-ass.net>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-21-xin3.li@intel.com>
 <20230320160021.GP2194297@hirez.programming.kicks-ass.net>
 <SA1PR11MB67349805EA11F4BAD07D62F9A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR11MB67349805EA11F4BAD07D62F9A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 12:04:47AM +0000, Li, Xin3 wrote:
> > > Unlike IDT, no need to save/restore dr7 in FRED machine check handler.
> > 
> > Given how fragile MCE is, the question should be, do we ever want hw
> > breakpoints to happen while it is running?
> 
> HW breakpoints still work if they are properly configured.
> 
> > If the hw-breakpoint handler trips on the same memory fail that got us into the
> > mce the first time, we're dead.
> 
> Right.
> 
> Unless the MCIP bit is turned off any subsequent #MC goes to shutdown
> ("machine is screwed").
> 
> It's the kernel debugger's responsibility to decide how to proceed in such
> cases. But if the kernel debugger itself is in a screwed memory region, we
> are soooooo dead.

Yeah, so I would much prefer, for robustness sake, to start out with not
allowing #DB in MCE -- much like today.
