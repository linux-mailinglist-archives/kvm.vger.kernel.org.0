Return-Path: <kvm+bounces-1635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 554077EA9EB
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 06:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85C481C20943
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 05:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBA5BE5B;
	Tue, 14 Nov 2023 05:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="YyPAvs8E"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AD3BE52;
	Tue, 14 Nov 2023 05:02:37 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F74123;
	Mon, 13 Nov 2023 21:02:36 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8EEE540E0191;
	Tue, 14 Nov 2023 05:02:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OLoj8MhEtgvD; Tue, 14 Nov 2023 05:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699938151; bh=dUNHth64wAi+DfNN2LL+fvN9ITMNu8XyaBkF7nxLEPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YyPAvs8EM1vwD3w0yM6uPenFZuJ20wSRyZ9hjuiQyOL8O2giIr8S5BXx9anHdygDG
	 CFaXI6vczp2qx7Oiicr6bHk4Bhk0EKoec4EBYGgRx8/PgK0HOdeGlgHCrS/LyKfLOn
	 +Rek8cAJbX7v56BxizHvEb6+v0Rr4aoK2eIz0ZQuQ+BYQNjHN9Irbhg/4P6ylIrTIK
	 L96EjujMwTv03F5ZwqQWljZuNIR8jz8EsCCUq4yQ98y/6ReCeOJAMA3AGIhfcYY8Va
	 TxptPFnV9Jn/V88TPz4opLGkUqaBEfGXX0ntniZgugahJgApJ+lhbu07+xYq5fEE9q
	 aZIeHwwJSbzpWBStJMEhFon4R35ReXDbGOktsEphMNxdUmTuIHoseUct3QYUNjqBns
	 ke/rvL+1u7nChtWL+hpQRCLVY6hYb3wJJ6DIgaU4s6EW5CaHdwvhjpVSMkVy5lY2Lr
	 UIm8VoXWV/zEDUtPgERX9tQUEiU3sj7Qwu4s2iECuHd+S2HxfX6t295O+Bpdsqbrna
	 WZ18C6yTZZH9FVRZ58Dv2OKmEMb51UQ3XVnwCCrHe7XtSEwRvuraOUR4QywbPCMBrL
	 HY7DOKuH0Oy4OYsYDpkkfOVc5aA95lX/saZyWxsbWxzGa8Twt59w6yupWMfewKfsLL
	 BQ5N9OijKGco3KNW5DAtAtqc=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 15CEE40E0032;
	Tue, 14 Nov 2023 05:02:09 +0000 (UTC)
Date: Tue, 14 Nov 2023 06:02:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Li, Xin3" <xin3.li@intel.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"Lutomirski, Andy" <luto@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Christopherson,, Sean" <seanjc@google.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"Gross, Jurgen" <jgross@suse.com>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v12 01/37] x86/cpufeatures: Add the cpu feature bit for
 WRMSRNS
Message-ID: <20231114050201.GAZVL/Sd/yLIdON9la@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-2-xin3.li@intel.com>
 <20231108123647.GBZUuA31zntox0W0gu@fat_crate.local>
 <SA1PR11MB673495967E44583FC36B5E39A8B2A@SA1PR11MB6734.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SA1PR11MB673495967E44583FC36B5E39A8B2A@SA1PR11MB6734.namprd11.prod.outlook.com>

On Tue, Nov 14, 2023 at 12:43:38AM +0000, Li, Xin3 wrote:
> No.  tglx asked for it:
> https://lkml.kernel.org/kvm/87y1h81ht4.ffs@tglx/

Aha

"According to the CPU folks FRED systems are guaranteed to have WRMSRNS -
I asked for that :). It's just not yet documented."

so I'm going to expect that to appear in the next FRED spec revision...

> Because we are doing 
> 		wrmsrns(MSR_IA32_FRED_RSP0, ...)
> here, and X86_FEATURE_WRMSRNS doesn't guarantee MSR_IA32_FRED_RSP0 exists.
> 
> Or I missed something?

Well, according to what I'm hearing and reading so far:

FRED means WRMSRNS
FRED means MSR_IA32_FRED_RSP0

and if you had to be precise, the code should do:

	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
		if (cpu_feature_enabled(X86_FEATURE_WRMSRNS))
			wrmsrns(MSR_IA32_FRED_RSP0, (unsigned long)task_stack_page(task) + THREAD_SIZE);
		else
			wrmsr(MSR_IA32_FRED_RSP0, (unsigned long)task_stack_page(task) + THREAD_SIZE);
	}

but apparently FRED implies WRMSRNS - not documented anywhere currently
- so you can save yourself one check.

But your version checks FRED if it can do WRMSRNS while there's
a separate WRMSRNS flag and that made me wonder...

> Another patch set should replace WRMSR with WRMSRNS, with SERIALIZE added
> when needed.

I sense someone wants to optimize MSR writes ... :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

