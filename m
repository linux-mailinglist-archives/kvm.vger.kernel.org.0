Return-Path: <kvm+bounces-64670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 80939C8A9C9
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1FCD14E5423
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 15:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31513328EC;
	Wed, 26 Nov 2025 15:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="TJmkqhEJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Fo3vjtry"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9594B3321BA;
	Wed, 26 Nov 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170651; cv=none; b=Z3qVmN33uivVNtjrb4p+6ynaz4wNTkTzLvevy3YIQGMCXnuAgIh7vhxLPlesM49vYqb4P4LR/Z7EXMqbgH6SMZ3T6w5w+5ptfbUFaaisALOjpsRUCiof9NLSD1/keSbzYYChNFf55O8J3/ASsN6LoROEKm2BWADaFRsVZ+XuTTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170651; c=relaxed/simple;
	bh=w/WkVcZ7JeI2n4dkA4fvLLpjsmEO7tNErzXkXUl3uUY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewrLIa3BKb5xZ6ryMrUgY2hAloOTzL53GSmJ6i5vFA3XfuN7LiuE5guxZ2uYU7XGbjGmtafat1bBFnSDquxRaHuTrJFyHTT/C5oKJzG/HF8x3MqZhi+bh6bueL6/bpQySGCrJCxX3m7yrZjrh3M6/KRIf46TLXmYP0WchhyuWN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=TJmkqhEJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Fo3vjtry; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 4FCEAEC000A;
	Wed, 26 Nov 2025 10:24:05 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 26 Nov 2025 10:24:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764170645;
	 x=1764257045; bh=iS1FFUWVwkCVU/m/hCrPC1kfzwe7lCdTSspMufCVAfQ=; b=
	TJmkqhEJfWdsdw4NUcWUKIAblRv5PfW8EVSJDPHqh5ufiCf+/tc5TiNmJmh1nWoF
	RtyBoi6W097PQIM/466mrGsRsiIkSUD71WRjP0f7+WZhoaeFxFkXHm+m8HJ8P8TN
	gaqTBpiWKcLGLk7oue6rp6tdvRDzaYZpS92rbVf85bYxpOwrkky+8pLPnWqCn445
	F2ek8lLU9Z2aZwjfRdN4gnEujBtUQBEiuf2YL8fKMv7J++GKUuu0CneU9CTtlfA8
	uK07MCwZqG6XArw5AyLhGLNAuwrjccq8WvwPAsyjfM18PSNeavXOVM1w40bDSO1X
	43m477E//5YCvjZquTTy1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764170645; x=
	1764257045; bh=iS1FFUWVwkCVU/m/hCrPC1kfzwe7lCdTSspMufCVAfQ=; b=F
	o3vjtryfAYLesjgMOU9wJvdLA2UGPZ2OPKGuGe+cFnoMXSzYG4mGQzXp8ZeIYlLJ
	nPLibk4jXQ/AgWig1Wg4yRCGMnxAaidsdWOA3xBikilLQgy3ZjOLRY6ffd7vvzKA
	ruTHI/LWSH0IxnaDSof6uZljh/F10DlvgzN/xJXygDC8V2OiyRKzA/So6gaTqoSs
	zMWPEngHM42npy3iB+ys5SSU5B39Lqca4Sw4d2qjXow7naHIaPu739SEVT2a5dCs
	YDynz0q883/pScYT69w+9QFgGeG1eATeE7luKKb+7P38ZlBpn41kMEaiKVoN8o5Z
	vuk7AAL4wiEbZBN9Qw1Lg==
X-ME-Sender: <xms:lBsnaW37snuHyk8FBTrT4fEujedaLiKiBTGdNNHBSI2ReDzgy45JsA>
    <xme:lBsnaUEMcTl4Jn-p5_Uf23QEdn8OxcO4b9h20uJwI5-vCGmWQ_QsD9yRu8TZqn30C
    6LHjlPZC5bGPzlSuK0bpRcf0R_Ey3UlxfaeyA4aPpv_0abERbqp2A>
X-ME-Received: <xmr:lBsnaVjw2H6PpArMNdPCM5DKcfWMV-_IyFW-UAtkOrWyzyI3ST-i8S9X>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegjedtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:lBsnaVd3tsqA2hpKzRVPfIRFSSI663lxN33DUlSYEq_ptSCuhO1t8g>
    <xmx:lBsnaTwgDgUUK7u68KiGhN3zu76uJqDsFfdUlgDIOkHLfRn36HZT4g>
    <xmx:lBsnaXbQ6---vXlPrO5gn2ptGPDxYq_2NG2WimQ4PIRVwou0OrlDdQ>
    <xmx:lBsnaZISxK0hTG7MEfgD7wGsxABI1q9t0DgXlEM6mRpe5uQDu3yqqw>
    <xmx:lRsnaXwPPek7B4-_njDSyFMjufvAY60ZSBsHGLUia-tkV088wr7l9gII>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 10:24:03 -0500 (EST)
Date: Wed, 26 Nov 2025 08:22:54 -0700
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
Subject: Re: [PATCH v7 4/6] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Message-ID: <20251126082254.70d4a7b5.alex@shazbot.org>
In-Reply-To: <20251126052627.43335-5-ankita@nvidia.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
	<20251126052627.43335-5-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Nov 2025 05:26:25 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Split the function that check for the GPU device being ready on
> the probe.
> 
> Move the code to wait for the GPU to be ready through BAR0 register
> reads to a separate function. This would help reuse the code.
> 
> This also fixes a bug where the return status in case of timeout
> gets overridden by return from pci_enable_device. With the fix,
> a timeout generate an error as initially intended.
> 
> Fixes: d85f69d520e6 ("vfio/nvgrace-gpu: Check the HBM training and C2C link status")
> 
> Reviewed-by: Zhi Wang <zhiw@nvidia.com>
> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index ac9551b9e4b6..f691deb8e43c 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,6 +130,20 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> +static int nvgrace_gpu_wait_device_ready(void __iomem *io)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
> +
> +	do {
> +		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
> +		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY))
> +			return 0;
> +		msleep(POLL_QUANTUM_MS);
> +	} while (!time_after(jiffies, timeout));
> +
> +	return -ETIME;
> +}
> +
>  static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
>  				   unsigned long addr)
>  {
> @@ -934,9 +948,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
>   * Ensure that the BAR0 region is enabled before accessing the
>   * registers.
>   */
> -static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
> +static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
>  {
> -	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
>  	void __iomem *io;
>  	int ret = -ETIME;

ret initialization is not needed, it's immediately clobbered.  Thanks,

Alex


>  
> @@ -954,16 +967,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
>  		goto iomap_exit;
>  	}
>  
> -	do {
> -		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
> -		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
> -			ret = 0;
> -			goto reg_check_exit;
> -		}
> -		msleep(POLL_QUANTUM_MS);
> -	} while (!time_after(jiffies, timeout));
> +	ret = nvgrace_gpu_wait_device_ready(io);
>  
> -reg_check_exit:
>  	pci_iounmap(pdev, io);
>  iomap_exit:
>  	pci_release_selected_regions(pdev, 1 << 0);
> @@ -980,7 +985,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  	u64 memphys, memlength;
>  	int ret;
>  
> -	ret = nvgrace_gpu_wait_device_ready(pdev);
> +	ret = nvgrace_gpu_probe_check_device_ready(pdev);
>  	if (ret)
>  		return ret;
>  


