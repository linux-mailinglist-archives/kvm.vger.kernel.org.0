Return-Path: <kvm+bounces-2663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2767FC427
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 20:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3F161C20EAD
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 19:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B9546BB1;
	Tue, 28 Nov 2023 19:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RY+zlK73"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA599D66;
	Tue, 28 Nov 2023 11:19:16 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8352C40E0195;
	Tue, 28 Nov 2023 19:19:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kZwaEBiXw0lG; Tue, 28 Nov 2023 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701199152; bh=g5Mn3al0jfBF2Tc5wdFDpfH6j9nnJam8vvaA6CzuQO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RY+zlK738bCdkjafOW/V4nnZkY05ywQPnrWVB+d3C58AHMANGruc+O4gqMj87sCo8
	 MHFuVexopL8HzEHdGlTSWn6aYW4utbPnl1oZNDLUySXdxmccA9uYoyZwm9tJaO9Zct
	 bHTOI0Lz40C9i6AboHFAKMJCFgAJXRon8/+UyTJ4R6lY8h3lXOq9s+N+C/DK5+5ITv
	 MRvAWiI/e8bs2qKj6sLM0LKJhKWgGS9x1up2i3Muagi9zDDYjxLo+Na+rLPqEGcJnr
	 TMDsYWzdbzbpYUjnBsCraFphskDd+LXJN3mnyc12EpYKyXDNKA8B73FRpAPDsW340o
	 aVQLz32kGRCtitobbENoKLorI70wVbAENFxQMWHMmyMmxggWAa5WiTkDiiPypxxKQe
	 D3xEe9CCNd0QTPz85sS7S0HED4LrWmPvPySTmA//rAy2VoXeO8LcGM7H4vIF3uhx8w
	 83JaBy4uRgI0daywYmI55bpcOvThNMvh7vV4TblLP/xZg8I8NQUYLQ1PqLsNq+T2ZN
	 RHi1c0M6hb48t4V1io8+ATkvHlkps0GClejTQvhNQ2/TCiCkRCAxEITdjHT5cFKFHm
	 BBnMRZAVISopwt4jD/3fm1Dek3PFT9OzznmkCjuEeRXGq00E+IigRL08qs6TtyO9hw
	 foVI56DUkjq2/5lxqyuHUIsI=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6D25E40E0031;
	Tue, 28 Nov 2023 19:18:50 +0000 (UTC)
Date: Tue, 28 Nov 2023 20:18:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Li, Xin3" <xin3.li@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
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
Subject: Re: [PATCH v12 24/37] x86/idtentry: Incorporate
 definitions/declarations of the FRED entries
Message-ID: <20231128191849.GEZWY9GbzySrVI1vpv@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-25-xin3.li@intel.com>
 <20231128100910.GSZWW8RnyhX0YQjwDm@fat_crate.local>
 <SA1PR11MB6734A1E439870989C7006166A8BCA@SA1PR11MB6734.namprd11.prod.outlook.com>
 <EE769C0F-FA81-49AD-A90B-F0E5D2A1DA7B@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <EE769C0F-FA81-49AD-A90B-F0E5D2A1DA7B@zytor.com>
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2023 at 10:58:50AM -0800, H. Peter Anvin wrote:
> >You have a very good sense =F0=9F=98=8A

I've been reading code of a couple of people for a couple of years. :-)

> Remember that Signed-off-by: relates to the *patch flow*.

Yes, you should take the time to read Documentation/process/ and
especially submitting-patches.rst.

We have it all written down and I point new(-er) people at that
directory at least once a week. :-\

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

