Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51023DBA26
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 01:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438711AbfJQX2O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 17 Oct 2019 19:28:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:16176 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438647AbfJQX2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 19:28:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 16:28:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,309,1566889200"; 
   d="scan'208";a="190191437"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga008.jf.intel.com with ESMTP; 17 Oct 2019 16:28:13 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.146]) by
 ORSMSX103.amr.corp.intel.com ([169.254.5.9]) with mapi id 14.03.0439.000;
 Thu, 17 Oct 2019 16:28:13 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFD] x86/split_lock: Request to Intel
Thread-Topic: [RFD] x86/split_lock: Request to Intel
Thread-Index: AQHVhOahH6iHJ8BHzEm2TNVz98K/g6dfc1fA
Date:   Thu, 17 Oct 2019 23:28:12 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F4A5F08@ORSMSX115.amr.corp.intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
 <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
 <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
 <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
 <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODljMjMyZjAtZTYxOS00NzY5LTgyMDctODdhNWE0NmQwZjUxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiK1VhZ2syblhnNzhLZHpxcmNpaEd6OWdiOU90ZEwwRXI1V0g3cnhGemhROXMzejY3K3FaTzQrYTJmSnhXXC96UmYifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> If that's not going to happen, then we just bury the whole thing and put it
> on hold until a sane implementation of that functionality surfaces in
> silicon some day in the not so foreseeable future.

We will drop the patches to flip the MSR bits to enable checking.

But we can fix the split lock issues that have already been found in the kernel.

Two strategies:

1) Adjust alignments of arrays passed to set_bit() et. al.

2) Fix set_bit() et. al. to not issue atomic operations that cross boundaries.

Fenghua had been pursuing option #1 in previous iterations. He found a few
more places with the help of the "grep" patterns suggested by David Laight.
So that path is up to ~8 patches now that do one of:
	+ Change from u32 to u64
	+ Force alignment with a union with a u64
	+ Change to non-atomic (places that didn't need atomic)

Downside of strategy #1 is that people will add new misaligned cases in the
future. So this process has no defined end point.

Strategy #2 begun when I looked at the split-lock issue I saw that with a
constant bit argument set_bit() just does a "ORB" on the affected byte (i.e.
no split lock). Similar for clear_bit() and change_bit(). Changing code to also
do that for the variable bit case is easy.

test_and_clr_bit() needs more care, but luckily, we had Peter Anvin nearby
to give us a neat solution.

So strategy #2 is being tried now (and Fenghua will post some patches
soon).

Strategy #2 does increase code size when the bit number argument isn't
a constant. But that isn't the common case (Fenghua is counting and will
give numbers when patches are ready).

So take a look at the option #2 patches when they are posted. If the code
size increase is unacceptable, we can go back to fixing each of the callers
to get alignment right.

-Tony


