Return-Path: <kvm+bounces-69010-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJV7BByxc2nOxwAAu9opvQ
	(envelope-from <kvm+bounces-69010-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:34:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8867D79112
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8BCD0300C305
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 17:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1341F3EBF00;
	Fri, 23 Jan 2026 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="GVkGZ1oL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="zMT1n4IT"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2200D1A9FB0;
	Fri, 23 Jan 2026 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769189656; cv=none; b=LXcuYj1OVjiknm6wwTHDq/R0jixLkGPhe2Dt4ya2V4ethoEodQNi/EJ2/G2Ur/g0eHWLtpP3LflvkAYCaggStf3agSjO7xQW0AArLlIz5HrNszhlizJrIEZ0+luyaEfZ/WQ9iY7bLtF1pSf84RcxWIMgfPu3tT2ANzKMw+HDMyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769189656; c=relaxed/simple;
	bh=Sj5YyPVggP+BRXC4qtAmJhRAhmu5JfPXX/NCTNVczNY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=px8+7URae8roqVYpS8AD6+LVfLa2dCKU44HBJw+D3+czfn7h13QXZi+9u/R2nZ+5neZR6NlBRXq7h4dZD5DZB0O468N3+ly+GatvZ/nnoIU8qaHa/u0bka/er13DAKnyMY7GbEjmQDz4vZbMY3ZFJO/sc7n2KDwE/xuh4Tgmlj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=GVkGZ1oL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=zMT1n4IT; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id C27D0EC00E0;
	Fri, 23 Jan 2026 12:34:11 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 23 Jan 2026 12:34:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1769189651;
	 x=1769276051; bh=Lno9HQ+X9KKXxs30iybAzXA159cmJxys/KIcIVS3m0Q=; b=
	GVkGZ1oLLbmaVh0HNx5vutlmQlsOoaf8iweRqETDNkTLbZTg240Z9uJCB/1e0Foc
	s2GOIV19jsh9IcGug/41yWYrLkDm3/1XhsJ9HRU00DT14sNDcALtYwVP8FZ+2gDS
	w0nHVXiEg7GRV9VomwJ0WuwaDVlLgNDVGTUchxBZ9s7+QWP68ozyPUIGr/iVUDgH
	An4r+GRjrC89+BNaN7we6HdjxS67O5Swb/e8AbssqrEM4MLbLooaEuhDSmJaHIGi
	G63rNg2o1Wip7rXchJT4F538yiZyi5wLBrRN8FUojnOXoJiV9kWWMvt75IrZ8QyH
	9gDsby+U88wPV8hPngGOPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1769189651; x=
	1769276051; bh=Lno9HQ+X9KKXxs30iybAzXA159cmJxys/KIcIVS3m0Q=; b=z
	MT1n4ITk4+GJRKQFritjRMolVykHjftR+Nfg38itg3Uj5cBJhY2Rb7M6KyKinnf4
	Uv9fMjArr+rUGwftefKFu3orEXwpI2Gmjsgrx6dMOh3NvlYqMkz/IMNsLYFlaU8D
	tin6abI5Q2G9kc8oTilW56+kkSecCi6lX7QL2S5NGhQwxe0FGjinZb8wUL91/KdP
	Lo9TlPPi6ugUGfnKm+Dha7GWTkN3EXEodbRWII9NhDr/rXkEr+fEzEP1K7IB0pY6
	yGpkP2z7d+UOQjkgvsplYFT358CiGv5qmWgJOfOhsyRKgSiggMhbck0E4oa4Y7RA
	dWNJgVnZ646S1P8rs+LqQ==
X-ME-Sender: <xms:E7FzaSyuI3gLuyngQBeo4RGLgZPo1UcapZSrwg31sr_RD_AOFzUqmg>
    <xme:E7Fzae8e7HxpfLVyFcw9b8e6t6KOnVNja5CC0WHDT3GvcK2zfgw94UIfmNswKr16D
    uWBlgooTsdCZ2tRsKUs49L2lx59QBsD46VMGAwGWigQX_mDtpX77A>
X-ME-Received: <xmr:E7FzaSi6XGLxZReYHTyQBKc8b27uIc-QUjyGz8xK-xx7wJIdq2WdfwqMSfc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeelieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekheejieetffefueeiteejtdejffdvleelvdeuvdffvdefteeghfevkeeu
    vdefvdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhg
    pdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlvg
    honheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehkvghvih
    hnrdhtihgrnhesihhnthgvlhdrtghomhdprhgtphhtthhopehvihhvvghkrdhkrghsihhr
    vgguugihsehinhhtvghlrdgtohhmpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghr
    nhgvlhdrohhrgh
X-ME-Proxy: <xmx:E7FzadGS6M_0zeHgGXWAiD5Q26TkZafHubhqUYm7-37ATy5j9MI5PQ>
    <xmx:E7FzaZ-kdIQZlMVAjYHc5BleeRLBwxCAkt3t8uoQYKmOj9UGHyuHVQ>
    <xmx:E7FzaczsjWQRXFT7jq3_ivKli_EHrB03nJJVQa6g7IpNg9bnHQkzDA>
    <xmx:E7FzadPYyRrwT1gDhkXoSx2IHUl3ofIl5u13_vJoxpLXtdz8hb3ylQ>
    <xmx:E7FzacAHCJgTx52jl0km7cEUN-Ieigg0Q6IrDOxynUgVF1u8qKV3LxLH>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 23 Jan 2026 12:34:10 -0500 (EST)
Date: Fri, 23 Jan 2026 10:34:07 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin
 Tian <kevin.tian@intel.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfio-rc] vfio: Prevent from pinned DMABUF importers to
 attach to VFIO DMABUF
Message-ID: <20260123103407.1778a2ac@shazbot.org>
In-Reply-To: <20260121-vfio-add-pin-v1-1-4e04916b17f1@nvidia.com>
References: <20260121-vfio-add-pin-v1-1-4e04916b17f1@nvidia.com>
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
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm1,messagingengine.com:s=fm2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69010-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 8867D79112
X-Rspamd-Action: no action

On Wed, 21 Jan 2026 17:45:02 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Some pinned importers, such as non-ODP RDMA ones, cannot invalidate their
> mappings and therefore must be prevented from attaching to this exporter.
> 
> Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> This is an outcome of this discussion about revoke functionality.
> https://lore.kernel.org/all/20260121134712.GZ961572@ziepe.ca
> 
> Thanks
> ---
>  drivers/vfio/pci/vfio_pci_dmabuf.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Applied to vfio for-linus branch for v6.19.  Thanks,

Alex


> 
> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> index d4d0f7d08c53..4be4a85005cb 100644
> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> @@ -20,6 +20,16 @@ struct vfio_pci_dma_buf {
>  	u8 revoked : 1;
>  };
>  
> +static int vfio_pci_dma_buf_pin(struct dma_buf_attachment *attachment)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void vfio_pci_dma_buf_unpin(struct dma_buf_attachment *attachment)
> +{
> +	/* Do nothing */
> +}
> +
>  static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
>  				   struct dma_buf_attachment *attachment)
>  {
> @@ -76,6 +86,8 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
>  }
>  
>  static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
> +	.pin = vfio_pci_dma_buf_pin,
> +	.unpin = vfio_pci_dma_buf_unpin,
>  	.attach = vfio_pci_dma_buf_attach,
>  	.map_dma_buf = vfio_pci_dma_buf_map,
>  	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
> 
> ---
> base-commit: acf44a2361b8d6356b71a970ab016065b5123b0e
> change-id: 20260121-vfio-add-pin-2229148da56e
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>
> 
> 


