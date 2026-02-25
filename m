Return-Path: <kvm+bounces-71890-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SIsZCchqn2lEbwQAu9opvQ
	(envelope-from <kvm+bounces-71890-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:34:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A5D19DDFB
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:33:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2BD83036045
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78B33164A1;
	Wed, 25 Feb 2026 21:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Fe/KFBw9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="t4JQiMyb"
X-Original-To: kvm@vger.kernel.org
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D622BF3F4;
	Wed, 25 Feb 2026 21:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772055218; cv=none; b=Ip/a31IWkI3YpHRzm2MW/hhttSoh1P7bjlW3GSa3mJLvfLbbMu5k0D7PnVP+T8p1H4H6jWdwZefdAEGuCAW2TEzk66x/THVi8suMNMwzvEKJd+seCbPkH0BPxMHM/YzxC2mLTirESMD7Ls6ImiFPHefzzGwLuUQwERCcwLiVkWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772055218; c=relaxed/simple;
	bh=qVLxIfPa28DabIzJ3J/4UZE3fpMldIr2+vdAvFygbUw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A5eaiKprEGEhwRVR0lGNAOLxAj6o34lOo0rdjiBh4UglxLjIMKgx+2D3nf1kANpRBuLyh67YZxmR1R5M3tbQUTT2LGlXqTamzVp7B/RaM5DQD/iV2ahsMuI0Ok2Z09oLXGXSE4tz1pgnfw5Ic8uE2gRX7nVWADsbfXXXxB+E5GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Fe/KFBw9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=t4JQiMyb; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id B25A31380AF9;
	Wed, 25 Feb 2026 16:33:34 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Feb 2026 16:33:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772055214;
	 x=1772062414; bh=uOyGcfhW1LI1T0+ImDiYL1uiY49EgY0HI4HEklJbETo=; b=
	Fe/KFBw9AhdA4JIPEFA6oKZMPb3jkSYj07O1VtDSsj+hw5ueMPGI4TP6AlPnPNgU
	uZlkZcKu8F1V6CdaKQ5F8rawNot0JXhub7A7i8kZ2a6Irzgqdj7ZQAljrKUPo+WN
	ckUH2mfIMPrAO9ug3Y04JmgN0axE2/mLsE8on37v3AnY9UigCsYwl8fMzaZ92Kqq
	ZrMc2qH8gqaY/MnjtK/Xg04fIJ932Mkf7qP0Jlo8hmNEEll1xyQnNz1fVs3kNUB0
	Znrc1HsroIGXMMsicDgklPEh6/3RiMSEQcqGJ7mtvo8Q5V7ly3+egJRP/D/91qrN
	yhTgY2R+oZbaVMmtg7slSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772055214; x=
	1772062414; bh=uOyGcfhW1LI1T0+ImDiYL1uiY49EgY0HI4HEklJbETo=; b=t
	4JQiMybd8my/Q8yahj2kZiHYVHPzFYw0ah1C6Tkdx+JRzb9lwDbPteJ70dqqsSH6
	kadwUwL5Gk5PBfLYFgya2G4juOjsnxGCVT0+aoOKuK73XIt/Iq0+WpPFp5XsMxK+
	DZBp/DPLYUIoB6yitemqtAqz1guul+U7JWiurf6Vb0EjbLYJEalun1XNPphPOTLV
	VMvgLUWk+8R7ppxGFGoKLuKkEUXEo06Hji/3KL0bb92rRQw43cXEpsVQQctrKVIg
	dhMZgQyNNbsV9wf1seVJLxybZb5ljarp4SDjvTDq6G1ich04JP9tkvPNdadt8H8t
	D6yk0yc7cuZz9C+OPZyZg==
X-ME-Sender: <xms:rWqfabg6hBv-eIfPU45VVg_kTi1XiEwGHCOLtJKZTjFoS1vqERTeZw>
    <xme:rWqfaYPVV_7brDFcjHNXpI-JiFYTDmsC4vAhdZGQdFLO-xAQYewBtL7EIwbF0UqsN
    AC8flZI8dVseXF2purGoWJL7MkKi1NyUgatg72tdlNAJGpBX0RhIw>
X-ME-Received: <xmr:rWqfaUkEndAraLfwnPYcRWzYlSIKrjBMwBcae6DD4LZUkyH1CzTVOelnKSc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeegvddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfh
    gsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghs
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:rWqfaXUe2FtA3DswIFB60ExhxZFyF4WTpDXQ_5K0uJb6A_pjD1-zHw>
    <xmx:rWqfaZbwjR4qhyLCBUtS6HbozOQLTb8Da7JXbzPAfHRRsnRclDkjxQ>
    <xmx:rWqfae0woTolOhs7n0PnNGy8Qymd6xqUPJqv3NBoAD2YEx6TloCDlQ>
    <xmx:rWqfaetNyIWQCnkMaOKDOZ3yWit9rXv9QiQwVJWAzIF4HXj2RH6MkQ>
    <xmx:rmqfaUCfyiFWNX-EYiIXFm3n4u8-Ftbqh0sezsK1WkYGRbGtK7SN5TSD>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Feb 2026 16:33:30 -0500 (EST)
Date: Wed, 25 Feb 2026 14:33:28 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
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
 " =?UTF-8?B?TWljaGHFgg==?= Winiarski" <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 "Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?=" <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <20260225143328.35be89f6@shazbot.org>
In-Reply-To: <20260129212510.967611-5-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-5-dmatlack@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71890-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 77A5D19DDFB
X-Rspamd-Action: no action

On Thu, 29 Jan 2026 21:24:51 +0000
David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 0c771064c0b8..19e88322af2c 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
>  	int ret;
>  	bool is_disable_vga = true;
>  
> +	ret = vfio_pci_liveupdate_init();
> +	if (ret)
> +		return ret;
> +
>  #ifdef CONFIG_VFIO_PCI_VGA
>  	is_disable_vga = disable_vga;
>  #endif
> @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
>  
>  	/* Register and scan for devices */
>  	ret = pci_register_driver(&vfio_pci_driver);
> -	if (ret)
> +	if (ret) {
> +		vfio_pci_liveupdate_cleanup();
>  		return ret;
> +	}
>  
>  	vfio_pci_fill_ids();
>  
> @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
>  static void __exit vfio_pci_cleanup(void)
>  {
>  	pci_unregister_driver(&vfio_pci_driver);
> +	vfio_pci_liveupdate_cleanup();
>  }
>  module_exit(vfio_pci_cleanup);
>  
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> new file mode 100644
> index 000000000000..b84e63c0357b
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -0,0 +1,69 @@
...
> +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> +	.can_preserve = vfio_pci_liveupdate_can_preserve,
> +	.preserve = vfio_pci_liveupdate_preserve,
> +	.unpreserve = vfio_pci_liveupdate_unpreserve,
> +	.retrieve = vfio_pci_liveupdate_retrieve,
> +	.finish = vfio_pci_liveupdate_finish,
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
> +	.ops = &vfio_pci_liveupdate_file_ops,
> +	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
> +};
> +
> +int __init vfio_pci_liveupdate_init(void)
> +{
> +	if (!liveupdate_enabled())
> +		return 0;
> +
> +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +}

liveupdate_register_file_handler() "pins" vfio-pci with a
try_module_get().  Since this is done in our module_init function and
unregister occurs in our module_exit function, rather than relative
to any actual device binding or usage, this means vfio-pci CANNOT be
unloaded.  That seems bad.  Thanks,

Alex

> +
> +void vfio_pci_liveupdate_cleanup(void)
> +{
> +	if (!liveupdate_enabled())
> +		return;
> +
> +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +}

