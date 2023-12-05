Return-Path: <kvm+bounces-3632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0695C805F6F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 21:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B08F9B20F84
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288206929F;
	Tue,  5 Dec 2023 20:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bIthWYpT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EEC181;
	Tue,  5 Dec 2023 12:29:58 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 18AFD40E014B;
	Tue,  5 Dec 2023 20:29:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4YEoh4W8wn-3; Tue,  5 Dec 2023 20:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701808194; bh=yB72VxK/0IQl3pur+X+/eX4EI1aY2v5x0vLEBbpCd0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bIthWYpTbMK0CmeXE3hZeqs8Zowj8EzqAaqEzRtGvMWJEY9OicO1L4rgb5NGO/cFh
	 KbUzib78+xQk/ODh5jPhwPi6M+uPK4HyG9iAF6fK8XAkQvqPxUXX1vLmGAgBNaDc8P
	 QJ8R+AH4zVMD/OT9aZcKE+cNdWx8LdSCevu1iVheOIwg4ln9MqWaO+NP4zjFh2dDuB
	 3W5XSvi3I0K/M/ZUuoiE5oHvtiyhRcqP/jB40a5CFcTw68JQ1HN+SoCpAUPjgXILzC
	 0OrG+FfxawWJNaRBhhFGij21/IsthdN9DBzO6+0lWxAt1XQTbIDeGn5IptAVUKP8iR
	 ood6UQKjaYPsDFwTt6Im0LXGKY9dQtdzRFnJDOmm5o0XazvH/Aj8ZNEas6QvJREuEm
	 U7/lo8Y5QsKowYoGL8Xd9f+uKDOimkfD57IFugVuESJk2gr6QE7I9xQ2BzEvK0sagP
	 +eXDgyaGU6httlGOTnyiKRCJWxecWIzXy2Qj5wGkpF4NTfWtzarVAmfHOYwLDyTivX
	 Fuh9rGE74pkyFvt3hNZrrrWjD9CUg/6pXNnQ9eZPJ9/WlrzCkgGwJLbbR6zCWvtlFW
	 sJ0l2GZlX85PBitwagY0/XBNviHTudAzZIKfsdslgFpW0P3/e7HdPr0FJsWACGi4gB
	 MNTCED08c+B70gZyElT2OcOY=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DE2D240E0195;
	Tue,  5 Dec 2023 20:29:27 +0000 (UTC)
Date: Tue, 5 Dec 2023 21:29:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"ak@linux.intel.com" <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"imammedo@redhat.com" <imammedo@redhat.com>,
	"sagis@google.com" <sagis@google.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	"Brown, Len" <len.brown@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Message-ID: <20231205202927.GJZW+IJ0NelvVmEum/@fat_crate.local>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
 <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
 <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>
 <20231205195637.GHZW+Add3H/gSefAVM@fat_crate.local>
 <2394202d237b4a74440fba1a267652335b53b71d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2394202d237b4a74440fba1a267652335b53b71d.camel@intel.com>

On Tue, Dec 05, 2023 at 08:08:34PM +0000, Huang, Kai wrote:
> The difference is for TDX host the kernel needs to initialize the TDX module
> first before TDX can be used.  The module initialization is done at runtime, and
> the platform_tdx_enabled() here only returns whether the BIOS has enabled TDX.
> 
> IIUC the X86_FEATURE_ flag doesn't suit this purpose because based on my
> understanding the flag being present means the kernel has done some enabling
> work and the feature is ready to use.

Which flag do you mean? X86_FEATURE_TDX_GUEST?

I mean, you would set a separate X86_FEATURE_TDX or so flag to denote
that the BIOS has enabled it, at the end of that tdx_init() in the first
patch.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

