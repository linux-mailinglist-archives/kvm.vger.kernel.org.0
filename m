Return-Path: <kvm+bounces-72738-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOu5B9CCqGmYvAAAu9opvQ
	(envelope-from <kvm+bounces-72738-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:06:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20737206E3F
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DBF50301F696
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 19:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07383DA5D8;
	Wed,  4 Mar 2026 19:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="J5cGG0Qn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="s6nzvTtp"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A46F3CCA0A;
	Wed,  4 Mar 2026 19:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651174; cv=none; b=UXI9C7xG3f3eZ6fxPGpbVjee1UxsUv/cfTyGKNjaOZwo21hpPyjysIbea5JyMTpGltSD/5HwbP8gc8Cn90P8YCLEMA9na/RTcmlPkwYA6MP7bBrM9SvV3FOPbbYl8Cjw89/uXighX2WoW4PKk3o/gVHq+1qOA3cd8NRVIR/aoAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651174; c=relaxed/simple;
	bh=RFBv8YwuEATNPVoLbeOgyN1xp695KYra6Xxis5eFQaA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N4PTC1U/UotLFg2GJjOVfnL5CId9kWypBNnRRkvz6ckoMpTknUf0eHQCRZx57iG6veLNIR4TzRKajdrycu3VYPe0IJmcTHxv8UHMG6ltusfpGjaX2u0SzfDWEMRR+lb/frC5iDWjw4tIEOpWkVNB1MKsEyYhO8X0YOEb+mqsom0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=J5cGG0Qn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=s6nzvTtp; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1711B7A01F3;
	Wed,  4 Mar 2026 14:06:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 04 Mar 2026 14:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772651171;
	 x=1772737571; bh=qCX0fETb7LppqJFm0Ooo/gF9iA4aj4iETpmuW38yLUo=; b=
	J5cGG0QnjYNIJbFY9/QFzTx/LoiA7Hekl8JrlfBF/u91a4htaCeH7cWMh4oGYeYL
	uegAvOocPdLI9Wavp8nEQpCCwaLiHnZn9ToTnfC7HlGOGRkPgyLX1SJqIBdExOnB
	hPR5548qbFe2zuX+Y+SbhNqM/cCM7tXz98a5xCTZ80QX7XTXueu7CG4XXiAmPmS9
	wKRwWoLsL4lPDlzPWjC/vqUoPbZJIP/lujah/1RMOzYWuJ6mAYM6MAf9Gtn6psSp
	FNhEDsZOGA3L2rcWb5FR9sZDLdQ4pePh24iq6NoaXWIct3eiapHAiOAeCpXgtQPB
	hMsBZADJa8IHRzXi3si/fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772651171; x=
	1772737571; bh=qCX0fETb7LppqJFm0Ooo/gF9iA4aj4iETpmuW38yLUo=; b=s
	6nzvTtpBqH82ivNYLovM4VSInHyVAhTS9x9CZI4bUO4nrSO0pfkvMET/J+zq0dEH
	IP9kWOiGGPMXQQRV3+3W0HAjfsPtuAC5uD5niGiwZzw6e8nM1dTrrz+2BP0HY5I7
	BMBe3hGrhf/kQOU5Yh0gaOQPMzR1JWRoGLhNKLHLrPlBl80J6LOPVUTs4JQTtwg3
	Ub7uiSGwdh4PsjvFdYgEFPsT8m/OnDPw9RLfWvmvOQjAG2qeI6VwNq0akS0qfyHA
	kMZjUvQyMQsrVBXGLVdLFSfU2iK/ILyk2dUfZzqlKjEsAUBuGdnW5QtwtWc+odSr
	LMlsAMLIWrYrhhJJ9wm6Q==
X-ME-Sender: <xms:o4KoaYbEUOGLmhALC8icVHpDOT1S438ENW5QCqOHIP-GywzmlY1t3w>
    <xme:o4KoaR6Z5v45JPMXnOiogT0-TzVDBNF68J-FnfWlvxNI4h0JAV6ZDlv2aAwR9coGt
    XkmBqbUwr_Aomu0YuQxiBYXXZJHW8ZaU8G7zw7EKYvKbZWVVdtSHQ>
X-ME-Received: <xmr:o4Koaedkhn-zMBZauvy8vcu3MDHXq1_iYsiinS4d_b6RBP94GHmCExjZqhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnkhhi
    thgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepmhho
    tghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpd
    hrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphht
    thhopegtjhhirgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepiihhihifsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehkjhgrjhhusehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:o4KoacwTUEQBTAzmZAtxLyBFqDj0s7Pu1krJnjphElBvv5aW1DbUTQ>
    <xmx:o4Koaco10nD57Gf9clP1e0nfdjb9UZqmHEjguojZoCmVA8W7mGvYrg>
    <xmx:o4KoaSz0x-rBCR0dfcPGxI2cyO6RyE58lo48j7_q3vEz9HUo9d6C0A>
    <xmx:o4KoaYqTR2TJRH4x2AHD1lNz29ZusarFu5YiU-SaRsmV_U9XuzgvGw>
    <xmx:o4KoaTNWn0ZE7R5gzToIJquRi5f4d3_R3M7lckYtnbIdzLUq-a9l8Lxf>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 14:06:10 -0500 (EST)
Date: Wed, 4 Mar 2026 12:06:08 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 07/15] vfio/nvgrace-egm: Register auxiliary
 driver ops
Message-ID: <20260304120608.141f6c90@shazbot.org>
In-Reply-To: <20260223155514.152435-8-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-8-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 20737206E3F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72738-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,nvidia.com:email,messagingengine.com:dkim,shazbot.org:dkim,shazbot.org:mid]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:06 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Setup dummy auxiliary device ops to be able to get probed by
> the nvgrace-egm auxiliary driver.
> 
> Both nvgrace-gpu and the out-of-tree nvidia-vgpu-vfio will make
> use of the EGM for device assignment and the SRIOV vGPU virtualization
> solutions respectively. Hence allow auxiliary device probing for both.

But only one is added?

Can you point to any other in-tree drivers that include out-of-tree
device entries in their ID table?

Isn't this ID table what should make the module soft-dep unnecessary?

> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 38 +++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index 6bab4d94cb99..6fd6302a004a 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -11,6 +11,29 @@
>  static dev_t dev;
>  static struct class *class;
>  
> +static int egm_driver_probe(struct auxiliary_device *aux_dev,
> +			    const struct auxiliary_device_id *id)
> +{
> +	return 0;
> +}
> +
> +static void egm_driver_remove(struct auxiliary_device *aux_dev)
> +{
> +}
> +
> +static const struct auxiliary_device_id egm_id_table[] = {
> +	{ .name = "nvgrace_gpu_vfio_pci.egm" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(auxiliary, egm_id_table);
> +
> +static struct auxiliary_driver egm_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = egm_id_table,
> +	.probe = egm_driver_probe,
> +	.remove = egm_driver_remove,
> +};
> +
>  static char *egm_devnode(const struct device *device, umode_t *mode)
>  {
>  	if (mode)
> @@ -35,17 +58,26 @@ static int __init nvgrace_egm_init(void)
>  
>  	class = class_create(NVGRACE_EGM_DEV_NAME);
>  	if (IS_ERR(class)) {
> -		unregister_chrdev_region(dev, MAX_EGM_NODES);
> -		return PTR_ERR(class);
> +		ret = PTR_ERR(class);
> +		goto unregister_chrdev;
>  	}
>  
>  	class->devnode = egm_devnode;
>  
> -	return 0;
> +	ret = auxiliary_driver_register(&egm_driver);
> +	if (!ret)
> +		goto fn_exit;

This is not a good success oriented flow.  The error condition should
goto the unwind, the success condition can just fall through to return.
Thanks,

Alex

> +
> +	class_destroy(class);
> +unregister_chrdev:
> +	unregister_chrdev_region(dev, MAX_EGM_NODES);
> +fn_exit:
> +	return ret;
>  }
>  
>  static void __exit nvgrace_egm_cleanup(void)
>  {
> +	auxiliary_driver_unregister(&egm_driver);
>  	class_destroy(class);
>  	unregister_chrdev_region(dev, MAX_EGM_NODES);
>  }


