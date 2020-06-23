Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2348F205219
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 14:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbgFWMMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 08:12:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:45112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732396AbgFWMMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 08:12:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 856F7AD5D;
        Tue, 23 Jun 2020 12:12:39 +0000 (UTC)
Date:   Tue, 23 Jun 2020 14:12:37 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20200623121237.GC14101@suse.de>
References: <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
 <20200623111443.GC4817@hirez.programming.kicks-ass.net>
 <20200623114324.GA14101@suse.de>
 <20200623115014.GE4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623115014.GE4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 01:50:14PM +0200, Peter Zijlstra wrote:
> If SNP is the sole reason #VC needs to be IST, then I'd strongly urge
> you to only make it IST if/when you try and make SNP happen, not before.

It is not the only reason, when ES guests gain debug register support
then #VC also needs to be IST, because #DB can be promoted into #VC
then, and as #DB is IST for a reason, #VC needs to be too.

Besides that, I am not a fan of delegating problems I already see coming
to future-Joerg and future-Peter, but if at all possible deal with them
now and be safe later.

Regards,

	Joerg
