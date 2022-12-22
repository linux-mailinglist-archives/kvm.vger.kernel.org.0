Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCF265417C
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 14:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiLVNEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 08:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiLVNEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 08:04:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3018527CF9;
        Thu, 22 Dec 2022 05:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mvzYaFpmiBrAALCIOGS8LyjgZjYQvTkctg7B9W1gCbA=; b=eHub322LS1fojURr/mFQ8s9YEW
        pgIvOlB+BReIjBD7xZUrHEExwUWlZVYYvQ+RFWdr1Np8pzM4xPv6OYWQnOLV2/LvC64mc6pKzbbrD
        GEUnM9q8UGW1wxzlnHB+Er0zXmBzT4dhe16TRpk99QvLdNtf6N3lbFg41lxpXjtZ3D+KT05Xz/5D7
        CaBd19Q0BTSq95A7ok10jWhCSpDHpXkzhTKjehIqetjTjgHVtZMSn7hgHwSWUyXff0G7voVN8WHxC
        t6o7XAFGbUvL2i1HEko9l7MctqJDHUL9NlpmyQXnaDKbla2sV/BEE8Xk4ZofN+Hgw8jMcyzSR23H7
        kwaPGhpQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p8LF3-003fgr-Og; Thu, 22 Dec 2022 13:04:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 283FA3000DD;
        Thu, 22 Dec 2022 14:03:58 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 040EF20D2DE36; Thu, 22 Dec 2022 14:03:57 +0100 (CET)
Date:   Thu, 22 Dec 2022 14:03:57 +0100
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
Subject: Re: [RFC PATCH 14/32] x86/fred: header file with FRED definitions
Message-ID: <Y6RVvRg20Xc6IR4k@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-15-xin3.li@intel.com>
 <Y6F4s0K2b2G8aMve@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21615569318BD964A2855F44A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB21615569318BD964A2855F44A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 02:58:06AM +0000, Li, Xin3 wrote:

> > > +/* Flags above the CS selector (regs->csl) */
> > > +#define FRED_CSL_ENABLE_NMI		_BITUL(28)
> > > +#define FRED_CSL_ALLOW_SINGLE_STEP	_BITUL(25)
> > > +#define FRED_CSL_INTERRUPT_SHADOW	_BITUL(24)
> > 
> > What's the state of IBT WAIT-FOR-ENDBR vs this? That really should also get a
> > high CS bit.
> 
> FRED does provide more possibilities :)

That's not an answer. IBT has a clear defect and FRED *should* fix it.
