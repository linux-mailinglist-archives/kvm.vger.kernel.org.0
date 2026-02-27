Return-Path: <kvm+bounces-72200-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iLr9KJnhoWmHwwQAu9opvQ
	(envelope-from <kvm+bounces-72200-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:25:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0FDC1BBF74
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A547C3046F7C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE5E37AA73;
	Fri, 27 Feb 2026 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="M5HcbGYu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Gqh9tuzf"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80310348445;
	Fri, 27 Feb 2026 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772216714; cv=none; b=o5/rOFKBETLNfEKtUA2y2tleeMIcY3tQBX98/F4C4tRsa7eZyvt/JY665JKA2RnuchjikW8e4psSeLA8G27JRAtTEROVKYa8Wgv5L3Sblzfrw0Cy1mi0u/olQKWdPkDhjYmmk2JsCAU1fRP++tWQ8V3oisPZOGdc+TbW5zcks6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772216714; c=relaxed/simple;
	bh=ij3/uuF1IJxXf2afJj9FRKZNyAbuS7zCH04NXX5F1y8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g1dSxeDlqSmgkJQmpJDltnQE1GIvlbGMgu0J8rSlKJ16C2OhGUrwzlHvDGgIVSx/KZPvEIaEXm5TvxqR6CmVzKcRgk/YQKmcIOXV5/eQoZheLB4C/2Sg1HY3mwXwYy9Ded5h+5pS1ZVcAfexHYWM7SvYo5ep7xVa7MWivN8W8VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=M5HcbGYu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Gqh9tuzf; arc=none smtp.client-ip=202.12.124.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id E683C13014A3;
	Fri, 27 Feb 2026 13:25:08 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 27 Feb 2026 13:25:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772216708;
	 x=1772223908; bh=h2MIetHNFq+qTvq+cXYYK0YgcuU2lcFpP3MOKL3SGt4=; b=
	M5HcbGYuV2I6ExGXjWjOd4SeeCigxt2cqKKirjhfZh06/QH5jWk5Z0JXXsThF4Fa
	7RNYoPp8Q5eAqiRc4MvFU9TfVLtKQF2soXn5Oi+wy5mVV02Y9V6al1nzNE0dM4Kf
	WM/D1Xyoo09YEP+zJELM7kvTK/Ul5KUP+3qr1TPLZTPStNtbStFcdz+hWfflEMCR
	eQDCZ0Ft8O0kf3j2MmhqyBxK+mhdOncmKEF4Dp4ercNY5ApAahSRV2An/RJEd4i7
	BdyHODrQLIwkBu6mJDWJbQjY2nSQJaubJmCsA0WpqDsoj1gNpOHZWdqR9igUU03x
	BT+8ghQY6qxqc1r0rOqLpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772216708; x=
	1772223908; bh=h2MIetHNFq+qTvq+cXYYK0YgcuU2lcFpP3MOKL3SGt4=; b=G
	qh9tuzfCH3lGFGrRjjXpdIFarDbZ9CPj/YT4lwdF5h6EzJZsS7JvnCF0Ks8Fnt0K
	LLfTOS7cdqhASypxTn6RzcsJBbGS38oM2wwz7RMuVfeRK5coZnlcRuACt2MXtpC7
	oHxISpVXtMqtiuv/OOXKhaJEtt7KniH7T4QEfK6G5L7z1cX/ZSU5pv5LbVF42vgh
	Zas7Cla0p33GtwfHxAEvLwtGrQiXgWNPpsRDMpMBUt041aDFgywssveH5+UbFKfk
	+EdQzATJOuDsuK2NDYiJdTUMuhVhgtTwQOO6Zr5EeJ3shSuZkI0NQLDWzZr01fnv
	3H57jQf4QaTibPhvtFDqQ==
X-ME-Sender: <xms:g-GhafZtSzmZsd9mg_1JeAf4a7CBH5YscM2LP9OxDN6vYBmrOT2RjQ>
    <xme:g-GhacBgZvn3vllUUZAduJus40XYnJCARLd5Qn2lpnCZ3hm5LcKmaH3_ifCdg8nRc
    bhfW2epKwLgco9PQY9RMjvB-8ySVXhjHa2szTFK4d0BoXgBo_sTQA>
X-ME-Received: <xmr:g-GhaXh3-jN2zQNLkCxS_aGmExZJC3QTxFCBwgyNzGHK4F5uOcX9ANZcPzI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeeljedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetuefgleefhfdvueegffdtffevhfffgfffiedutdetgffhheejtdekfeek
    ieehgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhg
    pdhnsggprhgtphhtthhopeegiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepug
    hmrghtlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthhopehhvghlghgrrghssehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegrjhgrhigrtghhrghnughrrgesnhhvihguih
    grrdgtohhmpdhrtghpthhtohepghhrrghfsegrmhgriihonhdrtghomhdprhgtphhtthho
    pegrmhgrshhtrhhosehfsgdrtghomhdprhgtphhtthhopegrphhophhplhgvsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhn
    rdhorhhgpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:g-GhaZTBdxISglkYbGFG0qQfvpfCG4WwcCrRmOzReyBOsLRaTibMXA>
    <xmx:g-GhaZuzpGX7ZWhZ_xeqPZZfg5xHy96idHFhKwVKbQXv6_voPSqgXg>
    <xmx:g-GhaT_XKP-XkGzZ4qGYqUFyPdICEwLE_1eo3ZKj2dbSLvmaUQ6GRw>
    <xmx:g-GhaVbO8hrlbCn4XT7ZfiNIekMI1_uwVcu6rbUJGDu-1KeSuemYKg>
    <xmx:hOGhaZd0C4q89F5ZU_31WMqce-tyc-ZrNJ3uFW7ijN5Nq5kVoD4bQVYy>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 13:25:03 -0500 (EST)
Date: Fri, 27 Feb 2026 11:25:01 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?B?TWlj?= =?UTF-8?B?aGHFgg==?= Winiarski
 <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260227112501.465e2a86@shazbot.org>
In-Reply-To: <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
References: <20260129212510.967611-3-dmatlack@google.com>
	<20260225224651.GA3711085@bhelgaas>
	<aZ-TrC8P0tLYhxXO@google.com>
	<20260227093233.45891424@shazbot.org>
	<CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	FREEMAIL_CC(0.00)[kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72200-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim,shazbot.org:email]
X-Rspamd-Queue-Id: C0FDC1BBF74
X-Rspamd-Action: no action

On Fri, 27 Feb 2026 09:19:28 -0800
David Matlack <dmatlack@google.com> wrote:

> On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazbot.org=
> wrote:
> >
> > On Thu, 26 Feb 2026 00:28:28 +0000
> > David Matlack <dmatlack@google.com> wrote: =20
> > > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > > > > +{
> > > > > + struct pci_dev *dev =3D NULL;
> > > > > + int max_nr_devices =3D 0;
> > > > > + struct pci_ser *ser;
> > > > > + unsigned long size;
> > > > > +
> > > > > + for_each_pci_dev(dev)
> > > > > +         max_nr_devices++; =20
> > > >
> > > > How is this protected against hotplug? =20
> > >
> > > Pranjal raised this as well. Here was my reply:
> > >
> > > .  Yes, it's possible to run out space to preserve devices if devices=
 are
> > > .  hot-plugged and then preserved. But I think it's better to defer
> > > .  handling such a use-case exists (unless you see an obvious simple
> > > .  solution). So far I am not seeing preserving hot-plugged devices
> > > .  across Live Update as a high priority use-case to support.
> > >
> > > I am going to add a comment here in the next revision to clarify that.
> > > I will also add a comment clarifying why this code doesn't bother to
> > > account for VFs created after this call (preserving VFs are explicitly
> > > disallowed to be preserved in this patch since they require additional
> > > support). =20
> >
> > TBH, without SR-IOV support and some examples of in-kernel PF
> > preservation in support of vfio-pci VFs, it seems like this only
> > supports a very niche use case. =20
>=20
> The intent is to start by supporting a simple use-case and expand to
> more complex scenarios over time, including preserving VFs. Full GPU
> passthrough is common at cloud providers so even non-VF preservation
> support is valuable.
>=20
> > I expect the majority of vfio-pci
> > devices are VFs and I don't think we want to present a solution where
> > the requirement is to move the PF driver to userspace. =20
>=20
> JasonG recommended the upstream support for VF preservation be limited
> to cases where the PF is also bound to VFIO:
>=20
>   https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/
>=20
> Within Google we have a way to support in-kernel PF drivers but we are
> trying to focus on simpler use-cases first upstream.
>=20
> > It's not clear,
> > for example, how we can have vfio-pci variant drivers relying on
> > in-kernel channels to PF drivers to support migration in this model. =20
>=20
> Agree this still needs to be fleshed out and designed. I think the
> roadmap will be something like:
>=20
>  1. Get non-VF preservation working end-to-end (device fully preserved
> and doing DMA continuously during Live Update).
>  2. Extend to support VF preservation where the PF is also bound to vfio-=
pci.
>  3. (Maybe) Extend to support in-kernel PF drivers.
>=20
> This series is the first step of #1. I have line of sight to how #2
> could work since it's all VFIO.

Without 3, does this become a mainstream feature?

There's obviously a knee jerk reaction that moving PF drivers into
userspace is a means to circumvent the GPL that was evident at LPC,
even if the real reason is "in-kernel is hard".

Related to that, there's also not much difference between a userspace
driver and an out-of-tree driver when it comes to adding in-kernel code
for their specific support requirements.  Therefore, unless migration is
entirely accomplished via a shared dmabuf between PF and VF,
orchestrated through userspace, I'm not sure how we get to migration,
making KHO vs migration a binary choice.  I have trouble seeing how
that's a viable intermediate step.  Thanks,

Alex

