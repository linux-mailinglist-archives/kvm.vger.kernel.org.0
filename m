Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB82DD0D2
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 23:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439778AbfJRVEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 17:04:35 -0400
Received: from terminus.zytor.com ([198.137.202.136]:45297 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730793AbfJRVEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 17:04:35 -0400
Received: from [IPv6:2601:646:8600:3281:c81c:8219:2587:2aad] ([IPv6:2601:646:8600:3281:c81c:8219:2587:2aad])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id x9IL3s1Y3114321
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 18 Oct 2019 14:03:56 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com x9IL3s1Y3114321
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019091901; t=1571432637;
        bh=pgCUxipVhDY6K42fnCtrfVrYsH6X5lPe2Y45M3wSGS4=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=KgjNnBBRIT74Ipf0giXvMGL9Y96DNXVMLpQKziFzuXhxs45qVKwWrJw6pGnMV+PnS
         jEGggD5AJaHmWRT89brTeVv53dgvti1GnmBVGgf0b+JoFBMWXNtRuP8zRl3RytDn3t
         ms1J8Sn7NQjLKFWNfquZZY319BU13EIoUKhg9QIaDe0mo8Hh2PieksffqiA7rCr72k
         Mb4vSPpzQxFES6X/f782xffizh/B+6hjm8DwCV6WiR3J3SXjG3H/7FTUuAJwUKVeTj
         msfQf5y7B52u+bKDaCL6C0a6KmgzLZc+zZ2ZySSlO39cjzES7V5GeJGhKZYX9t0fOv
         /Tu2WWwGYsryw==
Date:   Fri, 18 Oct 2019 14:03:45 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <3c42bd1c3cb9469f8f762c97f52d8655@AcuMS.aculab.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com> <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de> <20190925180931.GG31852@linux.intel.com> <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com> <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de> <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com> <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com> <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com> <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com> <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de> <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com> <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de> <3908561D78D1C84285E8C5FCA982C28F7F4A5F08@ORSMSX115.amr.corp.intel.com> <3c42bd1c3cb9469f8f762c97f52d8655@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: RE: [RFD] x86/split_lock: Request to Intel
To:     David Laight <David.Laight@ACULAB.COM>,
        "'Luck, Tony'" <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   hpa@zytor.com
Message-ID: <CB773347-E305-422B-ADAC-219D0F01E27E@zytor.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On October 18, 2019 3:45:14 AM PDT, David Laight <David=2ELaight@ACULAB=2EC=
OM> wrote:
>From: Luck, Tony
>> Sent: 18 October 2019 00:28
>=2E=2E=2E
>> 2) Fix set_bit() et=2E al=2E to not issue atomic operations that cross
>boundaries=2E
>>=20
>> Fenghua had been pursuing option #1 in previous iterations=2E He found
>a few
>> more places with the help of the "grep" patterns suggested by David
>Laight=2E
>> So that path is up to ~8 patches now that do one of:
>> 	+ Change from u32 to u64
>> 	+ Force alignment with a union with a u64
>> 	+ Change to non-atomic (places that didn't need atomic)
>>=20
>> Downside of strategy #1 is that people will add new misaligned cases
>in the
>> future=2E So this process has no defined end point=2E
>>=20
>> Strategy #2 begun when I looked at the split-lock issue I saw that
>with a
>> constant bit argument set_bit() just does a "ORB" on the affected
>byte (i=2Ee=2E
>> no split lock)=2E Similar for clear_bit() and change_bit()=2E Changing
>code to also
>> do that for the variable bit case is easy=2E
>>=20
>> test_and_clr_bit() needs more care, but luckily, we had Peter Anvin
>nearby
>> to give us a neat solution=2E
>
>Changing the x86-64 bitops to use 32bit memory cycles is trivial
>(provided you are willing to accept a limit of 2G bits)=2E
>
>OTOH this only works because x86 is LE=2E
>On any BE systems passing an 'int []' to any of the bit-functions is so
>terribly
>wrong it is unbelievable=2E
>
>So changing the x86-64 bitops is largely papering over a crack=2E
>
>In essence any code that casts the argument to any of the bitops
>functions
>is almost certainly badly broken on BE systems=2E
>
>The x86 cpu features code is always LE=2E
>It probably ought to have a typedef for a union of long [] and int []=2E
>
>	David
>
>-
>Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
>MK1 1PT, UK
>Registration No: 1397386 (Wales)

One thing I suggested is that we should actually expose the violations at =
committee time either by wrapping them in macros using __alignof__ and/or m=
ake the kernel compile with -Wcast-align=2E

On x86 the btsl/btcl/btrl instructions can be used without limiting to 2Gb=
it of the address is computed, the way one does for plain and, or, etc=2E H=
owever, if the real toes for the arguments are exposed then or is possible =
to do better=2E

Finally, as far as bigendian is concerned: the problem Linux has on bigend=
ian machines is that it tries to use littleendian bitmaps on bigendian mach=
ines: on bigendian machines, bit 0 is naturally the MSB=2E If your reaction=
 is "but that is absurd", then you have just grokked why bigendian is funda=
mentally broken=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
