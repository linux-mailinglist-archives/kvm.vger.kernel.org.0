Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD96DC303
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 12:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404190AbfJRKpS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 18 Oct 2019 06:45:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47556 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389040AbfJRKpS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Oct 2019 06:45:18 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-16-e-9XGDehPgqlQMnchm9hag-1; Fri, 18 Oct 2019 11:45:15 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 18 Oct 2019 11:45:14 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 18 Oct 2019 11:45:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Luck, Tony'" <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
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
Thread-Index: AQHVhOahH6iHJ8BHzEm2TNVz98K/g6dfc1fAgADCoYA=
Date:   Fri, 18 Oct 2019 10:45:14 +0000
Message-ID: <3c42bd1c3cb9469f8f762c97f52d8655@AcuMS.aculab.com>
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
 <3908561D78D1C84285E8C5FCA982C28F7F4A5F08@ORSMSX115.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F4A5F08@ORSMSX115.amr.corp.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: e-9XGDehPgqlQMnchm9hag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luck, Tony
> Sent: 18 October 2019 00:28
...
> 2) Fix set_bit() et. al. to not issue atomic operations that cross boundaries.
> 
> Fenghua had been pursuing option #1 in previous iterations. He found a few
> more places with the help of the "grep" patterns suggested by David Laight.
> So that path is up to ~8 patches now that do one of:
> 	+ Change from u32 to u64
> 	+ Force alignment with a union with a u64
> 	+ Change to non-atomic (places that didn't need atomic)
> 
> Downside of strategy #1 is that people will add new misaligned cases in the
> future. So this process has no defined end point.
> 
> Strategy #2 begun when I looked at the split-lock issue I saw that with a
> constant bit argument set_bit() just does a "ORB" on the affected byte (i.e.
> no split lock). Similar for clear_bit() and change_bit(). Changing code to also
> do that for the variable bit case is easy.
> 
> test_and_clr_bit() needs more care, but luckily, we had Peter Anvin nearby
> to give us a neat solution.

Changing the x86-64 bitops to use 32bit memory cycles is trivial
(provided you are willing to accept a limit of 2G bits).

OTOH this only works because x86 is LE.
On any BE systems passing an 'int []' to any of the bit-functions is so terribly
wrong it is unbelievable.

So changing the x86-64 bitops is largely papering over a crack.

In essence any code that casts the argument to any of the bitops functions
is almost certainly badly broken on BE systems.

The x86 cpu features code is always LE.
It probably ought to have a typedef for a union of long [] and int [].

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

