Return-Path: <kvm+bounces-61395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C875CC1AC95
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E6A6F586666
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 13:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CFC2C11F2;
	Wed, 29 Oct 2025 13:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="OUKdiLF4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="0EnkgFIo"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7BF29ACFC;
	Wed, 29 Oct 2025 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744386; cv=none; b=DvzKwwCZV8MrGnEk2422Z0RgaM0/RSmhtAq/3io2+05TQBqSvhu+Ga/kGGwYTJ/1ynH2S3x6P1kSZiIJfkrzCMeL/T572VnbMS8G+LkBwf8DrKDQByNNI9cNECKoLkJGfGaTkEfLxOXMuKRIQsnTNT/ibLJbeJXG3BXgaIzOVfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744386; c=relaxed/simple;
	bh=0vrPMGYikaT3kNZW5OzBGxPhCKlM8IZUrVp90xlGQA4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tX1vjAQIiSTn7Cn0UmM4XJA0nVAxY2wyQWnabDAusKaA00ELipXxCST3dXTR/0rh1MEmm0LWgG7iWG+LWQdyFvAgAhu9oGm65vkLIMuy72hjS6Bj5S5ITRiEthaKhIeNA8QRzKeO9/QbpltS4vS8V+c0PK3rsYnJxejOFaUyIpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=OUKdiLF4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=0EnkgFIo; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5F7E01400219;
	Wed, 29 Oct 2025 09:26:21 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 29 Oct 2025 09:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761744381;
	 x=1761830781; bh=sAaBhwjmQu3GhH1t8gq0LCcd1CEeOuI93h7oDi4PQwM=; b=
	OUKdiLF4t1KKj/BEzW26bzj7zHZ4/xInKJKncRC1PtVCHwxIM6/Gv1slnQt+1fvB
	oReuGYbjKxAX+48m0btRvSUFtdb5F7tMVeFSA0SqzIrZqPxFOtXyNvY+d9eM8wRW
	dm1487DNioKqzIw2uGF/UHC29SGh6gtdURQoZwaxF36iwhHxCxg5xvsksdMVNk0A
	JPuU1jmEnSAOrXl/N4r5C4NQd3ytK5yRbqwRWk/9/YNWcxLzYmoVAag+Lm7eL2Wa
	fTPO29kcDElqC4GCoIYTpJG7KCKESyU03lIVB6/iIGK1yqTXzbmSamIqrDAyOfdk
	BuCJzh/NA57zSpzMomkNUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1761744381; x=
	1761830781; bh=sAaBhwjmQu3GhH1t8gq0LCcd1CEeOuI93h7oDi4PQwM=; b=0
	EnkgFIoARTCSr7k7bWoEYRYQ+LS4han3Yia4zKuC7nwCDi/W1dAjk9dLpS+0vjbd
	wMnzvUjmeBxJXjUAkByO3Ajg+1XNE5E/l/sboKGYAi8ide8kt6R2hWMT5o7w45ZP
	uINLaXSDsnm5ly0cYI9J7m4fcQIXKVcv6KiRKkUiTU2vLLWI/av9dryJ5o5stVJF
	e5/sexJadjp+C4aFQ7HgzTUhdciFALFKXii4VSb40jKq2ndUo6IdjfycjF8qODk7
	AiGakzEE0XcRAxdJuKJ9W4mbtOOfOo62CUor2KnVCdh6w8YzMdLmAxRgZiv25Tth
	nfqkUOhY2Irbjf4YZJx5g==
X-ME-Sender: <xms:-xUCaZyG66KtfqZI2X_WppwOwA6N84EfmKZcOnmPWIHOxy838Gfa-g>
    <xme:-xUCaXj-gLvigiXCMTq8xqiOu2FWqHXU6tSIdyGCQdNmovo5BqSz5Xj4zNqI94Hvr
    AGz3iBpo44_hgStSIxY6KmNBF3pUxl12dDi7doY9rXz0tbjw-TYpA>
X-ME-Received: <xmr:-xUCacpselgt01E5wBDJUaZg8GL3knMBo3Gry14LgwVdCu7Y_-lsnWEUnlo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieefkeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhephedvtdeuveejudffjeefudfhueefjedvtefgffdtieeiudfhjeejhffhfeeu
    vedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepuddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlih
    hulhhonhhgfhgrnhhgsehhuhgrfigvihdrtghomhdprhgtphhtthhopegrlhgvgidrfihi
    lhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehjghhgsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdr
    ohhrghdrrghupdhrtghpthhtohepshhhrghmvggvrhhkohhlohhthhhumhesghhmrghilh
    drtghomhdprhgtphhtthhopehjohhnrghthhgrnhdrtggrmhgvrhhonheshhhurgifvghi
    rdgtohhmpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:-xUCaeig-haT8IdcAxis2uXabSt36L-DN_Wze_TstpHzml2GoyPhjQ>
    <xmx:-xUCaeMN8krYecwwurPdGxUwG0HriWMBCeHIWNxVHV4lzVJrxIKl0Q>
    <xmx:-xUCaYxG_8UknDuuf4QHnq9FVd0ag5CnQmj43ULhxoJb6h4QaRi-TA>
    <xmx:-xUCaQoLdOD-8SA7MrxttM-S1gFc8hepvINqdu9bK1U-NINAz9BJzQ>
    <xmx:_RUCaY9fHh_b0MUdBDkvgi6pB5Mw_znmt3X8AiZL45Alwm-WAsX5OnSB>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Oct 2025 09:26:18 -0400 (EDT)
Date: Wed, 29 Oct 2025 07:26:17 -0600
From: Alex Williamson <alex@shazbot.org>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
 <herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
 <jonathan.cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linuxarm@openeuler.org>
Subject: Re: [PATCH v11 1/2] crypto: hisilicon - qm updates BAR
 configuration
Message-ID: <20251029072617.38e23c7c@shazbot.org>
In-Reply-To: <20251029122441.3063127-2-liulongfang@huawei.com>
References: <20251029122441.3063127-1-liulongfang@huawei.com>
	<20251029122441.3063127-2-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Oct 2025 20:24:40 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> On new platforms greater than QM_HW_V3, the configuration region for the
> live migration function of the accelerator device is no longer
> placed in the VF, but is instead placed in the PF.
> 
> Therefore, the configuration region of the live migration function
> needs to be opened when the QM driver is loaded. When the QM driver
> is uninstalled, the driver needs to clear this configuration.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/hisilicon/qm.c | 27 +++++++++++++++++++++++++++
>  include/linux/hisi_acc_qm.h   |  3 +++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index a5b96adf2d1e..f0fd0c3698eb 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -3019,11 +3019,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
>  	pci_release_mem_regions(pdev);
>  }
>  
> +static void hisi_mig_region_clear(struct hisi_qm *qm)
> +{
> +	u32 val;
> +
> +	/* Clear migration region set of PF */
> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
> +		val = readl(qm->io_base + QM_MIG_REGION_SEL);
> +		val &= ~BIT(0);
> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
> +	}
> +}
> +
> +static void hisi_mig_region_enable(struct hisi_qm *qm)
> +{
> +	u32 val;
> +
> +	/* Select migration region of PF */
> +	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
> +		val = readl(qm->io_base + QM_MIG_REGION_SEL);
> +		val |= QM_MIG_REGION_EN;
> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
> +	}
> +}

Same as commented last time:

https://lore.kernel.org/all/20251027222011.05bac6bd@shazbot.org/

> +
>  static void hisi_qm_pci_uninit(struct hisi_qm *qm)
>  {
>  	struct pci_dev *pdev = qm->pdev;
>  
>  	pci_free_irq_vectors(pdev);
> +	hisi_mig_region_clear(qm);
>  	qm_put_pci_res(qm);
>  	pci_disable_device(pdev);
>  }
> @@ -5725,6 +5750,7 @@ int hisi_qm_init(struct hisi_qm *qm)
>  		goto err_free_qm_memory;
>  
>  	qm_cmd_init(qm);
> +	hisi_mig_region_enable(qm);
>  
>  	return 0;
>  
> @@ -5863,6 +5889,7 @@ static int qm_rebuild_for_resume(struct hisi_qm *qm)
>  	}
>  
>  	qm_cmd_init(qm);
> +	hisi_mig_region_enable(qm);
>  	hisi_qm_dev_err_init(qm);
>  	/* Set the doorbell timeout to QM_DB_TIMEOUT_CFG ns. */
>  	writel(QM_DB_TIMEOUT_SET, qm->io_base + QM_DB_TIMEOUT_CFG);
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index c4690e365ade..aa0129d20c51 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -99,6 +99,9 @@
>  
>  #define QM_DEV_ALG_MAX_LEN		256
>  
> +#define QM_MIG_REGION_SEL		0x100198
> +#define QM_MIG_REGION_EN		0x1
> +
>  /* uacce mode of the driver */
>  #define UACCE_MODE_NOUACCE		0 /* don't use uacce */
>  #define UACCE_MODE_SVA			1 /* use uacce sva mode */


