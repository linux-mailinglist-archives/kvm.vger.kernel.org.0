Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59712205302
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 15:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732650AbgFWNDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 09:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732542AbgFWNDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 09:03:52 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D49C061573;
        Tue, 23 Jun 2020 06:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YaPfqTCjeDJ9yQ4e7Ug2AGa7kbHGPm3KcaODCyhYn5k=; b=kGSfp6xHac4GqUF2vY+RwsZvtv
        UtLfm9rQDTo+JtvY9BvI3ZBed/ULh8lhJvTMgFO03+l0rXmutXve4emLYgluNUaAjGzxt7P3/Dq7z
        jEQ2dZHsRc0N9TSA3Onut7BDTJdXmUQ1ktnDfGVTNvD09O61TCjE8ggrVHK7U8vOoGMvG2Qx6IDfM
        OrAT6fCMMx5AHvdh8ofYbc3OcE1CAByxLfGEty3z8FkvgQVSjRtA2G5zp+VMADbkm8Y5TYaPkDTSW
        OC7F6qJi6s4/AF1qlXVPlcrECrBgRFz4ONJWn6G71e1KFlk7Usfpdjv91uJ6wGPH2ixslVKd91zDi
        61hKOVmQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jniaC-0007Vk-Lm; Tue, 23 Jun 2020 13:03:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E0300300F28;
        Tue, 23 Jun 2020 15:03:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CCDBB23CBF713; Tue, 23 Jun 2020 15:03:22 +0200 (CEST)
Date:   Tue, 23 Jun 2020 15:03:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623130322.GH4817@hirez.programming.kicks-ass.net>
References: <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
 <20200623111443.GC4817@hirez.programming.kicks-ass.net>
 <20200623114324.GA14101@suse.de>
 <20200623115014.GE4817@hirez.programming.kicks-ass.net>
 <20200623121237.GC14101@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623121237.GC14101@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 02:12:37PM +0200, Joerg Roedel wrote:
> On Tue, Jun 23, 2020 at 01:50:14PM +0200, Peter Zijlstra wrote:
> > If SNP is the sole reason #VC needs to be IST, then I'd strongly urge
> > you to only make it IST if/when you try and make SNP happen, not before.
> 
> It is not the only reason, when ES guests gain debug register support
> then #VC also needs to be IST, because #DB can be promoted into #VC
> then, and as #DB is IST for a reason, #VC needs to be too.

Didn't I read somewhere that that is only so for Rome/Naples but not for
the later chips (Milan) which have #DB pass-through?

> Besides that, I am not a fan of delegating problems I already see coming
> to future-Joerg and future-Peter, but if at all possible deal with them
> now and be safe later.

Well, we could just say no :-) At some point in the very near future
this house of cards is going to implode.

We're talking about the 3rd case where the only reason things 'work' is
because we'll have to panic():

 - #MC
 - #DB with BUS LOCK DEBUG EXCEPTION
 - #VC SNP

(and it ain't a happy accident they're all IST)

Did someone forget to pass the 'ISTs are *EVIL*' memo to the hardware
folks? How come we're getting more and more of them? (/me puts fingers
in ears and goes la-la-la-la in anticipation of Andrew mentioning CET)


