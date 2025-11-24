Return-Path: <kvm+bounces-64400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 518B1C815CB
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83E2F3A85E5
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5255A3148A1;
	Mon, 24 Nov 2025 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="SbobbR1h";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DBmy7H6J"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E8631352B;
	Mon, 24 Nov 2025 15:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998376; cv=none; b=X73gmK2EQjbu3gmmOHC3O9FeCX4TuwfLinhNTf1UGONsem54PaG98MYdTQB8e3G9ZdnewbWEm56P0i5SaKY3oAiDJXAXPAga0OyO7DDiqLNvYUgxYLUYW1eHe1QLVEG3ITrBlaQlCb15TrBORsgTOmUtW0XqJNhjgDWPl966/BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998376; c=relaxed/simple;
	bh=BSglOdI7ioZXdTTguFqJZ9AXXCnJx9130r2bz+Cfw3E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOs/KyJ0LMcp6sXIY/3IvQ9ucxrY9HjMUctGuBItdoY5NiVfHOTW0vGu6Ua6ozmN2rkytiWK5Wal2MY+im/dPyCUl4MUW7Q8RLu6h/Ie3/CyWzBzl2bUTjE1S0l+2HLKwsplVmrSK5/szTsg+xYfiKWXdaZLtP+BeCqSCDiK/Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=SbobbR1h; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DBmy7H6J; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 29CF5EC01C1;
	Mon, 24 Nov 2025 10:32:53 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Mon, 24 Nov 2025 10:32:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1763998373;
	 x=1764084773; bh=C4HQ3+7K4aq3+WLTK1rbndO5aMEdJcd+K3gbZvEczuk=; b=
	SbobbR1heygrd85YMmqGHK0ofQZtMsALxwK0avayXHL2Ypvbz5owc9wpcP5v53S8
	+E0dK1DXeaq++NhuWg1p5WwIq4/O3gPgy7eK4K7DBU90aqf50iVfSBYTzwV6V0Z8
	b8C+dLuuSPVvi9UX8TU9O7qpPnM6a6ljsL36vEECIJdZ8XIRUM1zftU06fWqwSvD
	HMInFfIFk9iEGy1/NAGxQw8cXxTi26g61aalPoATtubcg2S5CmDS5eRVL+tQ9k/t
	6oIRstFyngCwGnzQUN/7YK/7ssMcO0r6mn7kc4fsqlqbvCQEJOv3dhVl+Xjy0maJ
	lADc5NyGfRyvZZ1BNOR+jA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763998373; x=
	1764084773; bh=C4HQ3+7K4aq3+WLTK1rbndO5aMEdJcd+K3gbZvEczuk=; b=D
	Bmy7H6JRkeO6nacTPYsiQJxtVNBm0mE1UrUd9+3QwdrzqL9Y06zL8TcegHDlFjZV
	RiAMeH0RsTI+WgA0153kNEyh6lOrMRJ72JnXSGyaC9qqpcIf+VAQuhEuj3SaBYgu
	QzKdXSRVC7SG3dVg/knEgjKlQ44ZcGopgdJ45aioOFVNXkqqnozSc6J7muxF5tS9
	OkBu5m7anRo/qnGR0qJHJnnqdQzuAqTmpvHgylPgfFBMO9SopL+aTts6/MGwl2YD
	eT+oFAmvYS8xYyNQCBwQmaonHTRHI16BCM3s22bWdU41HjYrVfTLPY8H2ajKJNXB
	vq4Jw2h/aBxfUJsfjiNdA==
X-ME-Sender: <xms:pHokaWzp0MKPGpBV_7s0k26lp1Oz7jQ0prCIXdX9fytWKGnf5dS8QQ>
    <xme:pHokaae9Akv68YDRmM6Qs7qmHyzq4fb0OiXjiFM_L-mINeZYtQYiX_YVlkr7j2YTe
    XGgBeCoEJGR2Wui9THcQ_FrZ7NlIs9RK7ODQ023lRE25rShbpgy>
X-ME-Received: <xmr:pHokafrbyw1AHi1WdQ2uV671p0pm8YdmBGzPhuxzKK5khVylWZ66-rt3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeekleejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:pHokaaNr2O2JX6EWLaGx-kiZgDwUZBRm6GqqUi0aJ3apTcbJQBDAcA>
    <xmx:pHokaVF1wKKB0IezZtyTvV15aA-ZlTE4ni6YPDObIClReg0jdngnbg>
    <xmx:pHokadEFT8KnqIGLd7i1UeX85u3zDgJs6CBC-retmXGS0Z_HEMU3Dg>
    <xmx:pHokaUDb5-g8iS8onjjt0Q6O5BV0BJt5hloBqxiHl1YWE5QQ8zEeOA>
    <xmx:pXokaXnuZZVSdHb4PusKzXzrXTVc4z3uPUiJcRc4yf0dMqaYIZAP2JCB>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Nov 2025 10:32:51 -0500 (EST)
Date: Mon, 24 Nov 2025 08:32:49 -0700
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
Subject: Re: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Message-ID: <20251124083249.3316c6e9.alex@shazbot.org>
In-Reply-To: <20251124115926.119027-6-ankita@nvidia.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
	<20251124115926.119027-6-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Nov 2025 11:59:24 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Split the function that check for the GPU device being ready on
> the probe.
> 
> Move the code to wait for the GPU to be ready through BAR0 register
> reads to a separate function. This would help reuse the code.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 33 ++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index c84c01954c9e..3e45b8bd1a89 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,6 +130,24 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> +static int nvgrace_gpu_wait_device_ready(void __iomem *io)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
> +	int ret = -ETIME;
> +
> +	do {
> +		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
> +		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
> +			ret = 0;
> +			goto ready_check_exit;
> +		}
> +		msleep(POLL_QUANTUM_MS);
> +	} while (!time_after(jiffies, timeout));
> +
> +ready_check_exit:
> +	return ret;
> +}
> +
>  static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
>  						  unsigned int order)
>  {
> @@ -930,9 +948,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
>   * Ensure that the BAR0 region is enabled before accessing the
>   * registers.
>   */
> -static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
> +static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
>  {
> -	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
>  	void __iomem *io;
>  	int ret = -ETIME;
>  
> @@ -950,16 +967,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
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

I think you're inadvertently fixing a bug here too.  The ret
initialization to -ETIME is immediately clobbered by
pci_enable_device(), so exceeding the timeout would never generate an
error.  Now it will:

Fixes: d85f69d520e6 ("vfio/nvgrace-gpu: Check the HBM training and C2C link status")

Also we should remove the ret initialization.  Otherwise the series
LGTM.  Thanks,

Alex

>  
> -reg_check_exit:
>  	pci_iounmap(pdev, io);
>  iomap_exit:
>  	pci_release_selected_regions(pdev, 1 << 0);
> @@ -976,7 +985,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  	u64 memphys, memlength;
>  	int ret;
>  
> -	ret = nvgrace_gpu_wait_device_ready(pdev);
> +	ret = nvgrace_gpu_probe_check_device_ready(pdev);
>  	if (ret)
>  		return ret;
>  


