Return-Path: <kvm+bounces-62134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EBAEC3833E
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 23:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6BD51A23568
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 22:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31F22F12C3;
	Wed,  5 Nov 2025 22:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="eb4y8GUg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wgnrdSsO"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1BE256C70;
	Wed,  5 Nov 2025 22:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762381960; cv=none; b=lhW+e2o5n34tyA3dCmW59icyebD2/6IMzudK6WHD8B/aT1dWIABi+QGhpxQhHtu+DLvYaZDU9RrH6Lya123l0toUstiRwOpV/M1fGdyQpNH9K+reeMFaeo7BI6TR0e6j9YTyjSlXXCpsxs7JCJeDUyhYVidmuoiVo1SHXQ/rc7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762381960; c=relaxed/simple;
	bh=Y89HE2wRiWrwHFIIH5yf9M+Pax0OddbuTh7zu565CuA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NHLV01vNrYgCHfjjrR33Ndn5LBv9zrlef+3g0r8CAKlPVBI3ImE8uQ+QSI0c/nM0z29fcuAqiEGPiHYkfmUvnvfcYKChq/8yTR92J9Rc4Bv6mS2wi28cyzmSQc7lBEr6Npkm/8e2JAHxMY1FW3RUBDY++WD9zOZ3wTkFsKqtWiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=eb4y8GUg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wgnrdSsO; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 89CD8EC01DD;
	Wed,  5 Nov 2025 17:32:36 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 05 Nov 2025 17:32:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762381956;
	 x=1762468356; bh=C/N7mmjzp5gariu8cXvOhV8km+uTuUuFPtmIFDADyQA=; b=
	eb4y8GUg6136NbMIwDQUYOQd6ySWnrutZzG0S5POEcX+UWRKBQKdl7toZsV1p3wr
	62vfJE+8VhxaraQipFHiuYKqfa6gpK1Itm9emtj0JlH34sQcK0JgjOYN6T82HI6K
	amWWxtEk3EBvA0VP/zB4hQIeb73F40BOTIN0dA/USFCmL6rIZK3dGkX1Ua0g9Oo/
	2Gd0bSz1jzidLGoxML06ovIO6ZfJeEA3k3dL/7fSKfKO1hirXuCr/R6VDzYg6pRU
	ZSpYqO7CLICatQMQgNhl+9chCgY8eiGbVxCbwGv3c80hAREUx6zGYG4ZUK61u+Bw
	unfPbSNEUCMmlQSAFN/CSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762381956; x=
	1762468356; bh=C/N7mmjzp5gariu8cXvOhV8km+uTuUuFPtmIFDADyQA=; b=w
	gnrdSsOpXEnZFjW/Y1z4SLWGIUCfJ5Xm9wrkzwbKS/syWRifZ6kxzZheD+u7pKAm
	LnoK29GKC5NLk3bHfJ9GF+8UoaAAZU4Rz5ekM1Oq+tTY98XB2bAPLJ4LvaJ0wEzl
	XUFPqtcf0uDnu6dL1kd4OqFT06LItrTTKKhPGvITRVa/P166DEpwWMjUhhwtUESN
	dqUzeRChBu4AnAmJrQtpKFq7Te7mkZws0h75V559NC4+uzBN0iVgxaeu1FJV8BF7
	DFC7lBCVtB3FZ0196WZ/tpNQjinYlCBAQEmfLEyFt0Is7EaJJhziI67eQuWhkyFd
	OP0lhzm5r5wFjjRBchhmQ==
X-ME-Sender: <xms:g9ALad3NwZyt3WdM0zy18D6h-DF3H0YrWlSv8hAXzG4zHIcLIYcCaw>
    <xme:g9ALaXI2qnuk-EBtpZQbcrm3bRRiDIDm88lwXQpC_uRHHG9iS0eo-d_uYVd2Meb-S
    DeWZjsxHahQOwsAUYOi3DIy0r1OdRbli7vD1_G6sZAahKYJDDV4wQ>
X-ME-Received: <xmr:g9ALaYhymf0TKPqYwYSZLH1KLkEdjsHnKICRZ675h2MHrzd9plJhbgZb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeehudduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeelpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopehlihhulhhonhhgfhgrnhhgsehhuhgrfigvihdrtghomh
    dprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdp
    rhgtphhtthhopehjghhgsehnvhhiughirgdrtghomhdprhgtphhtthhopehhvghrsggvrh
    htsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepshhhrghmvggv
    rhhkohhlohhthhhumhesghhmrghilhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnh
    drtggrmhgvrhhonheshhhurgifvghirdgtohhmpdhrtghpthhtoheplhhinhhugidqtghr
    hihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhg
    vghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:g9ALaXBrnjXp1uxZhdUrQeFjoEf_HcUzZY6xFgV3WFVJ-9ZRBV49gQ>
    <xmx:g9ALaa7H-uchEmi3frv73-YrPWRUW06xHpGufEbTwM9_1XukFbcBZw>
    <xmx:g9ALacFpB9CQaICNumc93uCeg-vDK-KZmBztDFKxUFPdjg4vREhxHQ>
    <xmx:g9ALaVAvkqHt7j8cUU2JuA-eZ3oezH-zn1atN3yMtEGCwdcKBDAo8w>
    <xmx:hNALaZPnduhhM-bLgujjoSIUAFZmeo-Wh3qWzBDP-r8l4121mdw32fNw>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Nov 2025 17:32:34 -0500 (EST)
Date: Wed, 5 Nov 2025 15:32:33 -0700
From: Alex Williamson <alex@shazbot.org>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
 <herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
 <jonathan.cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 2/2] hisi_acc_vfio_pci: adapt to new migration
 configuration
Message-ID: <20251105153233.59a504ae.alex@shazbot.org>
In-Reply-To: <20251030015744.131771-3-liulongfang@huawei.com>
References: <20251030015744.131771-1-liulongfang@huawei.com>
	<20251030015744.131771-3-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Oct 2025 09:57:44 +0800
Longfang Liu <liulongfang@huawei.com> wrote:
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 91002ceeebc1..419a378c3d1d 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -50,8 +50,10 @@
>  #define QM_QUE_ISO_CFG_V	0x0030
>  #define QM_PAGE_SIZE		0x0034
>  
> -#define QM_EQC_DW0		0X8000
> -#define QM_AEQC_DW0		0X8020
> +#define QM_EQC_VF_DW0		0X8000
> +#define QM_AEQC_VF_DW0		0X8020
> +#define QM_EQC_PF_DW0		0x1c00
> +#define QM_AEQC_PF_DW0		0x1c20
>  
>  #define ACC_DRV_MAJOR_VER 1
>  #define ACC_DRV_MINOR_VER 0
> @@ -59,6 +61,22 @@
>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
>  
> +#define QM_MIG_REGION_OFFSET		0x180000
> +#define QM_MIG_REGION_SIZE		0x2000
> +
> +/**
> + * On HW_ACC_MIG_VF_CTRL mode, the configuration domain supporting live
> + * migration functionality is located in the latter 32KB of the VF's BAR2.
> + * The Guest is only provided with the first 32KB of the VF's BAR2.
> + * On HW_ACC_MIG_PF_CTRL mode, the configuration domain supporting live
> + * migration functionality is located in the PF's BAR2, and the entire 64KB
> + * of the VF's BAR2 is allocated to the Guest.
> + */
> +enum hw_drv_mode {
> +	HW_ACC_MIG_VF_CTRL = 0,
> +	HW_ACC_MIG_PF_CTRL,
> +};
> +
>  struct acc_vf_data {
>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>  	/* QM match information */
> @@ -125,6 +143,7 @@ struct hisi_acc_vf_core_device {
>  	struct pci_dev *vf_dev;
>  	struct hisi_qm *pf_qm;
>  	struct hisi_qm vf_qm;
> +	int drv_mode;

I can fix this on commit rather than send a new version, but is there
any reason we wouldn't make use of the enum here:

	enum hw_drv_mode drv_mode;

?  Thanks,

Alex

>  	/*
>  	 * vf_qm_state represents the QM_VF_STATE register value.
>  	 * It is set by Guest driver for the ACC VF dev indicating


