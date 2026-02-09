Return-Path: <kvm+bounces-70595-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FfJFhW8iWmkBQUAu9opvQ
	(envelope-from <kvm+bounces-70595-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:51:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC29410E5E0
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76E5B301ABA8
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 10:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CE9369202;
	Mon,  9 Feb 2026 10:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1j/oo8Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4869434D3A1;
	Mon,  9 Feb 2026 10:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770633994; cv=none; b=jn6dOTB8aLAFY+kEnbeZakp7iNSSOLaEviOFXbgD50lLHxbpuy7jiWSMlAe7iNnGqJBZdPNpYCFUVFRTbgvUQ/OITeBQhLGpcJUolqDzd3oOt8c+5PZcZAywPSafcIue5evtGTp7PsYDHfQL+XnBCFUTaC+gA6HcHCEtIiVg9w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770633994; c=relaxed/simple;
	bh=oIt396BW0G8JKjB3ihTbTUGQExj5VHd026WpVIYdpus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmE6HWAmH1/YwH+ZHSC3p/93yME5gTW+38Pii7/DkkZx/OFMmKGyN56u6bb9SDAxw812f7RwS/ho8RE4tPUTIOaleFYFG43J/w5Of9rX2iqYHSqZhHvmNykr+XdJlawfOg/BKcm2dm1Tk/7faKIAKqt+r22occH53QR1LvtQQjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1j/oo8Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FB0C4AF09;
	Mon,  9 Feb 2026 10:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770633994;
	bh=oIt396BW0G8JKjB3ihTbTUGQExj5VHd026WpVIYdpus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k1j/oo8QK/ejNBc05bSTOhnoqe3Cz8Uic4ZB8DgLB6cvvEnyG1ytS3tB3kWwJ66YL
	 kdhdul1duJC4HmHdBNK5aR8XQkvV2/fscJX45JcUrDFRnkzimRLuFzPY85nOPZsLev
	 ee5m6rVjVuX2pqQ51jIvTvN12mpXJxIhbudJFV5H8YANKbdj771RVvECymK00DuW5g
	 899YyjxvPN6uFr5ODLrSkPEe1PAFAUdLDP4yZUQitMKhxzSyPHkEFWhZw7l9Jsn4PZ
	 rExYCaRqcxgNc6W3ZGEvrJ9amfDEEtsgyBObAVCodT37Qdzv29zkDP17YvvhlJuuXc
	 /U0q4cJGwryMg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 492D1F40069;
	Mon,  9 Feb 2026 05:46:32 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 09 Feb 2026 05:46:32 -0500
X-ME-Sender: <xms:CLuJaXXxQKKU56KpHtA4N-brlRRO3TdzHB1BQAMjTLLlbBAIguQlng>
    <xme:CLuJaYZchdMiYkeNYZ_Om82s8QFx_5KHYBNl3X_pvMGAhFymx5pxQmk971Ny3Q2JD
    oOPTYR-98Da44Bijk5Wv5MzPBlvXqIE2plVuKjPhlYnoMBAN4hbuAQ>
X-ME-Received: <xmr:CLuJaaWDRWKn_Ub_E6S2hVnJDFN35M3O19damgHYMxnjgoYr4Cmogv9TBMkxNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduleeiiedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtohepvhhish
    hhrghlrdhlrdhvvghrmhgrsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrdhh
    rghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehkvhhmsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghotghosehlihhs
    thhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheptghhrghordhgrghosehinhhtvghl
    rdgtohhmpdhrtghpthhtoheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrd
    gtohhmpdhrtghpthhtohepkhgrihdrhhhurghnghesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:CLuJab6AboiZ9JrcFOA7I44Omgg_Q9zC6j0XH56thRmXe_3cFkqaIQ>
    <xmx:CLuJaad8rS6BeJ8LPABmMD0TqLGLwZxxx7H6wG4vRefbrO363mwt6A>
    <xmx:CLuJad7_XFePpMqe_jPykn70JicMwJTlAdHchLMmK_yX4GGBfZJL3A>
    <xmx:CLuJaa2mgySh0A79OA0GfWgDEG38qzD2EtBqtTrsS-J2qLRoTubkTQ>
    <xmx:CLuJaQCESpHTIEyecjPO1R-qi7BK661LY8odbtzHiuJiU3gyLkG2O7eY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Feb 2026 05:46:31 -0500 (EST)
Date: Mon, 9 Feb 2026 10:46:30 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>, 
	dave.hansen@linux.intel.com, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, 
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Message-ID: <aYm6-SMojt9uqi0G@thinkstation>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <6d8d37740459963e6fd7f16a890a837b34ebdf17.camel@intel.com>
 <aYXSd8B00OtKZcAU@thinkstation>
 <2235a1cf-7ccf-4134-80b5-8056537c6d33@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2235a1cf-7ccf-4134-80b5-8056537c6d33@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70595-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kas@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: EC29410E5E0
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 07:10:58AM -0800, Dave Hansen wrote:
> On 2/6/26 03:39, Kiryl Shutsemau wrote:
> >> Hi Kiryl, just wanted to check on the plan for this, I didn't see it
> >> merged in tip.git x86/tdx (or any other tip branch). Were you planning
> >> to take it through x86/tdx? Can I help with anything to move it along?
> > I guess it has to wait after the merge window at this point.
> > 
> > Dave, could you queue this after -rc1 is tagged?
> 
> Sure.
> 
> Is there any other TDX stuff that needs to get picked up at the same
> time that's been languishing?

Nothing on my side.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

