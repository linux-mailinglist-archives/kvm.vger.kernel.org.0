Return-Path: <kvm+bounces-64674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6806BC8A9DE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62D0F3AE507
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 15:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A380332911;
	Wed, 26 Nov 2025 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="RpsHXPAg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="neptXDVX"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F659331A41;
	Wed, 26 Nov 2025 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170655; cv=none; b=rZ0ixFHhfxgfYvHzQ/k9KAMbmTCwZxiWCXJiYYuXOuA+mQ+rceigSLG/QzpP2388SxlDymJpPOHOZYzJ77AxnAx1yFQKmOVCIy7kKhyfrDeGDMJKUD3jY4CqDJvXVhYOFJH7MP2h3cRczudpO13jBnLpjoekwdsLAZT4Lu3XFNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170655; c=relaxed/simple;
	bh=PC2Baaa0HTihiivIFGDkF1SV5nsQ2DJWHLWnmQhhnGE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I4WX4ZcLhsfGEQTJVnoMcl9xHKfvNkBr1g1ABD0n8DWovVVeY/3IIAgpf6R9DcyYHGMcHqMYXJ1DDH4qt2gThCwDr8o/yhkVqI+HuU5hbnEGiUmbe4bay36i8X7PepCApgsbi+zuklrEXTnYj3+l6s8COLmqG0zS7vWhRELQPWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=RpsHXPAg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=neptXDVX; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 7868DEC000A;
	Wed, 26 Nov 2025 10:24:12 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 26 Nov 2025 10:24:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764170652;
	 x=1764257052; bh=4Hxx5Ns+2Syi3mQOWFbGcezq1+3byMGKKrsFtU+p4m0=; b=
	RpsHXPAgQnAv/79/LxFZuHz/kVuVy+ez5rOalpoGt8TapyUbRHp71HtlNcINM8WZ
	tqgKDujOcIj096JCSD5ZAAQU9jsk0o3+r5KcTbI4vwwn5I/rYtUbjEmUCVoyxcUA
	bqsQUZZbi35mbADqEwCv2MvX+VcuqPnJkBdxtJSJSGlmMctyWVCYzNAuCAfRcok/
	tbAAVsAcWXbU0Cp+FdWKKibMTY+xIO2+T+u4607pG09tsuna6siWTa2ojy+pTvud
	KRjc8wm4+K8zBY95sqwyaieU34piGWqeIzUyjjlbL3kmEjeJyFm/wrmOPsHyBwCo
	A4//kWZa9a9N/9yliR5yBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764170652; x=
	1764257052; bh=4Hxx5Ns+2Syi3mQOWFbGcezq1+3byMGKKrsFtU+p4m0=; b=n
	eptXDVXKnuwNc/1nTzFmHOV0ofAx9Zu1aJ1D58O0/UGw4MHD9nsGKFDUDjWf5pWi
	PiReMTRxmOr8cdhFuYVHI2MN0QEClniCkIyQl6KQbWBkvVsZ2VnBR8hqPXEuSqED
	7wmj1syFRdcvPMbIl2iHaPbcVlVMJXw83aHWJ4rOItAkX3pSrCScvtFc3L4wcanL
	4ckAIir9Kf0YuUQ9ixsntygAx4ebJCJ8Af/Ie5XtrJYYxdiVRdpcy7C+gSowRUdJ
	WDvRt69BVAhaR3gsAe9cbj3hLXQYp6br931Zj4hte4TQqQtyJtp/urf1qn0gJltu
	w1d3IT+cPKNpSXlBQq7TA==
X-ME-Sender: <xms:nBsnaYY-ItdFjVApVu9duOhaaikSaP9nsHITUpSt38hc4yzYZnoDmA>
    <xme:nBsnaeYTJafBpNMHOsKP1Y4w4v1Ex1oibVt0Qz3T5sGEoantg4oTmlmFfYUD0H6qE
    -idv3zKcnFzXAP2dc7uK_bCPYUHbPOdbW46T01P5pdZWR2T8C7f>
X-ME-Received: <xmr:nBsnaZlvehX7lvIxwqwOkHz1QLrZh2-IRxzu1F7dkSl6Vzvy3Jvfwlo2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegieelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohepvdehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhkihht
    rgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtg
    hpthhtohephihishhhrghihhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhl
    ohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehkvghvihhnrdhtih
    grnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrnhhikhgvthgrsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohephihunhigihgrnhhgrdhl
    ihesrghmugdrtghomh
X-ME-Proxy: <xmx:nBsnaQQMurNxuG1veeG8zKSLUr5cCyyM-nwTxN-WSiEccXC3f7Fz6g>
    <xmx:nBsnaeXbo4h-oeZwsBeuVTIZVrDVnTWG6yIJMDoomayR0FDXpc_RxQ>
    <xmx:nBsnaWuNEgsKkmJb8rhYFA60K-m1MHytMmZ8md4C1zsfreC6y4Ie4g>
    <xmx:nBsnaeOk4rIci-69sBtJGR46Z-875MFYI9xEEH-bXhDpKAFbzunmxA>
    <xmx:nBsnaQs658lMFUwP_5-jGn-H7g0OQakWcEwylZ-DvJn9jhUAgkv9DteP>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 10:24:10 -0500 (EST)
Date: Wed, 26 Nov 2025 08:23:00 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <skolothumtho@nvidia.com>,
 <kevin.tian@intel.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
 <mochs@nvidia.com>, <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
 <zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
 <bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
 <apopple@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiw@nvidia.com>, <danw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: Re: [PATCH v7 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after
 reset
Message-ID: <20251126082300.09e3503a.alex@shazbot.org>
In-Reply-To: <20251126052627.43335-6-ankita@nvidia.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
	<20251126052627.43335-6-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Nov 2025 05:26:26 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Introduce a new flag reset_done to notify that the GPU has just
> been reset and the mapping to the GPU memory is zapped.
> 
> Implement the reset_done handler to set this new variable. It
> will be used later in the patches to wait for the GPU memory
> to be ready before doing any mapping or access.
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index f691deb8e43c..b46984e76be7 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -58,6 +58,8 @@ struct nvgrace_gpu_pci_core_device {
>  	/* Lock to control device memory kernel mapping */
>  	struct mutex remap_lock;
>  	bool has_mig_hw_bug;
> +	/* GPU has just been reset */
> +	bool reset_done;
>  };
>  
>  static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> @@ -1048,12 +1050,34 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
>  
> +/*
> + * The GPU reset is required to be serialized against the *first* mapping
> + * faults and read/writes accesses to prevent potential RAS events logging.
> + *
> + * The reset_done implementation is triggered on every reset and is used
> + * set the reset_done variable that assists in achieving the serialization.

I can't parse this last sentence, "used _to_ set"?.  Maybe something as
simple as:

/*
 * First fault or access after a reset needs to poll device readiness,
 * flag that a reset has occurred.
 */

Thanks,
Alex

> + */
> +static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +	struct nvgrace_gpu_pci_core_device *nvdev =
> +		container_of(core_device, struct nvgrace_gpu_pci_core_device,
> +			     core_device);
> +
> +	nvdev->reset_done = true;
> +}
> +
> +static const struct pci_error_handlers nvgrace_gpu_vfio_pci_err_handlers = {
> +	.reset_done = nvgrace_gpu_vfio_pci_reset_done,
> +	.error_detected = vfio_pci_core_aer_err_detected,
> +};
> +
>  static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
>  	.name = KBUILD_MODNAME,
>  	.id_table = nvgrace_gpu_vfio_pci_table,
>  	.probe = nvgrace_gpu_probe,
>  	.remove = nvgrace_gpu_remove,
> -	.err_handler = &vfio_pci_core_err_handlers,
> +	.err_handler = &nvgrace_gpu_vfio_pci_err_handlers,
>  	.driver_managed_dma = true,
>  };
>  


