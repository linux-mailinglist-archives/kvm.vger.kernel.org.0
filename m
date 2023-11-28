Return-Path: <kvm+bounces-2662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA617FC3E3
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 19:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C02E1C20E95
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 18:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5CB58AD1;
	Tue, 28 Nov 2023 18:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="11Iza6/q"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89436D63;
	Tue, 28 Nov 2023 10:59:36 -0800 (PST)
Received: from [127.0.0.1] ([98.35.210.218])
	(authenticated bits=0)
	by mail.zytor.com (8.17.2/8.17.1) with ESMTPSA id 3ASIwqLV616002
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 28 Nov 2023 10:58:52 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 3ASIwqLV616002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2023111101; t=1701197933;
	bh=74Rbbp6WmPGdUYvYwxbnx3GlgDUb6hVq+tbhktrir44=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=11Iza6/qBiVUooTKd04zGe3+wGNKZVtkyP1VW7naU9P22AgKrZowrwJtcMKq3USBK
	 0lE8KKp0aSf0L7vG6wMYqj3GBFBG4Z+IyjuorpigOVR+bZGRipokdFZpAHxsKxJVsJ
	 eXJ+JD+99XTQDzX1is23XA0HmvT2kbL85O4HuT09syHKKptCBqObIMJ1kEJAvGPIrT
	 Te5AF0KD+nO8MMWUcEFZ5cOMcsuvCtml6Q1SjlKD/yPKStgz2z/rfZFPbT9QhXqSv3
	 0Q4y+BTl1dMGW1ncv4Yl5PW3gnAB2+y+WTENs06cntMqYcI+tLMnha0J9K8iGZB7yh
	 4oXasKaWj6nVA==
Date: Tue, 28 Nov 2023 10:58:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Li, Xin3" <xin3.li@intel.com>, Borislav Petkov <bp@alien8.de>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v12_24/37=5D_x86/idtentry=3A_Incorporat?= =?US-ASCII?Q?e_definitions/declarations_of_the_FRED_entries?=
User-Agent: K-9 Mail for Android
In-Reply-To: <SA1PR11MB6734A1E439870989C7006166A8BCA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231003062458.23552-1-xin3.li@intel.com> <20231003062458.23552-25-xin3.li@intel.com> <20231128100910.GSZWW8RnyhX0YQjwDm@fat_crate.local> <SA1PR11MB6734A1E439870989C7006166A8BCA@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <EE769C0F-FA81-49AD-A90B-F0E5D2A1DA7B@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 28, 2023 10:39:01 AM PST, "Li, Xin3" <xin3=2Eli@intel=2Ecom> wr=
ote:
>> > FRED and IDT can share most of the definitions and declarations so
>> > that in the majority of cases the actual handler implementation is th=
e
>> > same=2E
>> >
>> > The differences are the exceptions where FRED stores exception relate=
d
>> > information on the stack and the sysvec implementations as FRED can
>> > handle irqentry/exit() in the dispatcher instead of having it in each
>> > handler=2E
>> >
>> > Also add stub defines for vectors which are not used due to Kconfig
>> > decisions to spare the ifdeffery in the actual FRED dispatch code=2E
>> >
>> > Tested-by: Shan Kang <shan=2Ekang@intel=2Ecom>
>> > Signed-off-by: Thomas Gleixner <tglx@linutronix=2Ede>
>> > Signed-off-by: Xin Li <xin3=2Eli@intel=2Ecom>
>>=20
>> This makes me wonder too who the author is=2E The commit message text s=
ounds
>> like tglx=2E :)
>
>You have a very good sense =F0=9F=98=8A
>
>This is mostly from his review comments and suggestions on my original
>changes to IDTENTRY=2E  So probably I should put a "Suggested-by" instead
>of "Signed-off-by" as HPA pointed out!
>
>Thanks!
>    Xin
>

Remember that Signed-off-by: relates to the *patch flow*=2E

