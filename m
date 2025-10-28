Return-Path: <kvm+bounces-61349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B8AC1713C
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 143304FFBAB
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7BB2DE6E9;
	Tue, 28 Oct 2025 21:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="d3y3Gpup";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="n1SgGhx4"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2232C3274;
	Tue, 28 Oct 2025 21:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761687547; cv=none; b=joDuNREazRZBiPPzsbn8+3nj58RzZKsoojY/ER7tjB1LRL11c4Vwqv0VkQgwGZcyRixb2vwwfV55QOOLebpt7yxIdyM/b/3laVql8AhgN9oOusAEAblA4uXCmB5D+BZv5mLbRIcI1YC6Dlsln7TOxBNQE8azoMYVSp3fb5UUEig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761687547; c=relaxed/simple;
	bh=xOASOABBvkPUNsQAaeefvM/VW8nqDwn8XkM2jh36XcY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DrmqlbvwFg7RjCbNGA32pIiP1QlIFGAp/gWZXy42Hm2xvJCRT7Yb6UbqFxZuvwJX5yGCqPCMq4j+rGc89+BsFd19ODObqIk+KmHao56VZTIKmWsSg8a5gtPAktTYDXuxUDdU4UNzsPvFsghvUYjx8ewX+XG78g0vANdooKrTdA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=d3y3Gpup; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=n1SgGhx4; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 0D04EEC0496;
	Tue, 28 Oct 2025 17:39:02 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 28 Oct 2025 17:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761687542;
	 x=1761773942; bh=DPOFQal6bpRTx55H2kMHu3VWh654e7b6m98lZBX4dv8=; b=
	d3y3Gpup1nT5JucMZm7h/cni5GWAv+riD6/qBRuts8V/XroOJLSJL/vcXDk0zq9T
	ASM7LKJX+86sedzSy2FRFZK8yVpjsYLvGruCYQTxC8/RgEg9iSZBUsqbZfFUlY52
	DYAmkT2jbyaceXGDzPJwoebFIM8lXYB2qjPLdOi6g0qgXV7BdJvoAuf+oJsjjhHo
	W3raTfgW1JoHSuVKfUXu0jaaXXMB9HZa+warCfYmSloGCnsmWeiupQuCyXPCAPVS
	kWcPqWxdQuKAnZQaBtMkCnJiRYiD4XL3rgCEbPoebnHe9zNfHG5SBDF59IBVzZ48
	63upKJoNPzqs/0fJsVgLCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1761687542; x=
	1761773942; bh=DPOFQal6bpRTx55H2kMHu3VWh654e7b6m98lZBX4dv8=; b=n
	1SgGhx4zuHYCB2GtU5mhuv6MSH0OSP67vEJ1d5ssW46QZT5zBWvbNlVEG38p07vi
	yQs+h6g9eTQky9hw/O/cxcjj7z3ULT69JmHCUI9O1AqGOPNfTPLga/pJ0aB8rHA3
	pfEfBPmxv+GB8N4qy2qMJAQBkrDOmtipW5Rz66Id+xe8NURKDCXN+zOxDLxEfNuJ
	WmQUuS6b1IKUlyVef0Q3bZi/MdFN40T62vzXTxZ37oXhjvr2jO4w+kCTFF5raamg
	dMU1L2cZD7sJHsWbLp152oqNedhFqPbAqtNk7PSejGpn3A97zGA+dcm5C+sqPZcD
	zMnsQSftikuzktAH+JIfA==
X-ME-Sender: <xms:9DcBadGmTZ5PGkXcyoAwft4Enym4aR8UY1TK94Ws9-GLPCq08rHmDw>
    <xme:9DcBaQlTFJRN_T0GQSFrP0y7Mp2GEStj3dM5mhSrk9e9_iqbojx7QxtOOvypBmnKJ
    gb1oGSyeFwfhMGtjzogn1BLeXQVkKQeMRAKxvjOhAaLY07WEvIXWQ>
X-ME-Received: <xmr:9DcBaYe026DLdE2JGOznhDxEVYJtCXrIwFpXLcSgyIUZe7DUfcit51vthUo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieduleehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohepuddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhulhho
    nhhgfhgrnhhgsehhuhgrfigvihdrtghomhdprhgtphhtthhopegrlhgvgidrfihilhhlih
    grmhhsohhnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehjghhgsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrgh
    drrghupdhrtghpthhtohepshhhrghmvggvrhhkohhlohhthhhumhesghhmrghilhdrtgho
    mhdprhgtphhtthhopehjohhnrghthhgrnhdrtggrmhgvrhhonheshhhurgifvghirdgtoh
    hmpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:9DcBaWH6FVe8X8tQqzPoxjF_75Dkem5wDjmPIUjl2MmaHQL1rH1eWg>
    <xmx:9DcBaWjchZJnJ1sSg7oMPa8Gk9NdbgMS-DXunoiVv-hyAAoyHrnVAg>
    <xmx:9DcBaS2zFcSMYO16nLVwuPEAUx-QnYO5arryp5At3_e42-xe2N6Iyw>
    <xmx:9DcBaZfxBPjty1ED4qvfjabbOpgBoZxBuwKZEgSQ-Z2BLwYWeeOCQw>
    <xmx:9jcBaQTxezhmY4dXFeMYMA9TWZzOkyyQRKOv0PEaS5xAQicg1w5WK1T->
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Oct 2025 17:38:59 -0400 (EDT)
Date: Tue, 28 Oct 2025 15:38:57 -0600
From: Alex Williamson <alex@shazbot.org>
To: liulongfang <liulongfang@huawei.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
 <herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
 <jonathan.cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linuxarm@openeuler.org>
Subject: Re: [PATCH v10 2/2] hisi_acc_vfio_pci: adapt to new migration
 configuration
Message-ID: <20251028153857.67329c09@shazbot.org>
In-Reply-To: <734cd156-26c1-50f7-f0fa-db76beaab745@huawei.com>
References: <20251017091057.3770403-1-liulongfang@huawei.com>
	<20251017091057.3770403-3-liulongfang@huawei.com>
	<20251027222007.5e176e42@shazbot.org>
	<734cd156-26c1-50f7-f0fa-db76beaab745@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Oct 2025 15:04:37 +0800
liulongfang <liulongfang@huawei.com> wrote:

> On 2025/10/28 12:20, Alex Williamson wrote:
> > On Fri, 17 Oct 2025 17:10:57 +0800
> > Longfang Liu <liulongfang@huawei.com> wrote:
> >   
> >> On new platforms greater than QM_HW_V3, the migration region has been
> >> relocated from the VF to the PF. The VF's own configuration space is
> >> restored to the complete 64KB, and there is no need to divide the
> >> size of the BAR configuration space equally. The driver should be
> >> modified accordingly to adapt to the new hardware device.
> >>
> >> On the older hardware platform QM_HW_V3, the live migration configuration
> >> region is placed in the latter 32K portion of the VF's BAR2 configuration
> >> space. On the new hardware platform QM_HW_V4, the live migration
> >> configuration region also exists in the same 32K area immediately following
> >> the VF's BAR2, just like on QM_HW_V3.
> >>
> >> However, access to this region is now controlled by hardware. Additionally,
> >> a copy of the live migration configuration region is present in the PF's
> >> BAR2 configuration space. On the new hardware platform QM_HW_V4, when an
> >> older version of the driver is loaded, it behaves like QM_HW_V3 and uses
> >> the configuration region in the VF, ensuring that the live migration
> >> function continues to work normally. When the new version of the driver is
> >> loaded, it directly uses the configuration region in the PF. Meanwhile,
> >> hardware configuration disables the live migration configuration region
> >> in the VF's BAR2: reads return all 0xF values, and writes are silently
> >> ignored.
> >>
> >> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> >> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
> >> ---
> >>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
> >>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  21 ++
> >>  2 files changed, 165 insertions(+), 61 deletions(-)
> >>
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> index fde33f54e99e..55233e62cb1d 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
> >>  	return 0;
> >>  }
> >>  
> >> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >> +			   struct acc_vf_data *vf_data)
> >> +{
> >> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
> >> +	struct device *dev = &qm->pdev->dev;
> >> +	u32 eqc_addr, aeqc_addr;
> >> +	int ret;
> >> +
> >> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
> >> +		eqc_addr = QM_EQC_DW0;
> >> +		aeqc_addr = QM_AEQC_DW0;
> >> +	} else {
> >> +		eqc_addr = QM_EQC_PF_DW0;
> >> +		aeqc_addr = QM_AEQC_PF_DW0;
> >> +	}
> >> +
> >> +	/* QM_EQC_DW has 7 regs */
> >> +	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> >> +	if (ret) {
> >> +		dev_err(dev, "failed to read QM_EQC_DW\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	/* QM_AEQC_DW has 7 regs */
> >> +	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> >> +	if (ret) {
> >> +		dev_err(dev, "failed to read QM_AEQC_DW\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >> +			   struct acc_vf_data *vf_data)
> >> +{
> >> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
> >> +	struct device *dev = &qm->pdev->dev;
> >> +	u32 eqc_addr, aeqc_addr;
> >> +	int ret;
> >> +
> >> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
> >> +		eqc_addr = QM_EQC_DW0;
> >> +		aeqc_addr = QM_AEQC_DW0;
> >> +	} else {
> >> +		eqc_addr = QM_EQC_PF_DW0;
> >> +		aeqc_addr = QM_AEQC_PF_DW0;
> >> +	}
> >> +
> >> +	/* QM_EQC_DW has 7 regs */
> >> +	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> >> +	if (ret) {
> >> +		dev_err(dev, "failed to write QM_EQC_DW\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	/* QM_AEQC_DW has 7 regs */
> >> +	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> >> +	if (ret) {
> >> +		dev_err(dev, "failed to write QM_AEQC_DW\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >>  {
> >>  	struct device *dev = &qm->pdev->dev;
> >> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >>  		return ret;
> >>  	}
> >>  
> >> -	/* QM_EQC_DW has 7 regs */
> >> -	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> >> -	if (ret) {
> >> -		dev_err(dev, "failed to read QM_EQC_DW\n");
> >> -		return ret;
> >> -	}
> >> -
> >> -	/* QM_AEQC_DW has 7 regs */
> >> -	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
> >> -	if (ret) {
> >> -		dev_err(dev, "failed to read QM_AEQC_DW\n");
> >> -		return ret;
> >> -	}
> >> -
> >>  	return 0;
> >>  }
> >>  
> >> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
> >>  		return ret;
> >>  	}
> >>  
> >> -	/* QM_EQC_DW has 7 regs */
> >> -	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> >> -	if (ret) {
> >> -		dev_err(dev, "failed to write QM_EQC_DW\n");
> >> -		return ret;
> >> -	}
> >> -
> >> -	/* QM_AEQC_DW has 7 regs */
> >> -	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
> >> -	if (ret) {
> >> -		dev_err(dev, "failed to write QM_AEQC_DW\n");
> >> -		return ret;
> >> -	}
> >> -
> >>  	return 0;
> >>  }
> >>  
> >> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>  		return ret;
> >>  	}
> >>  
> >> +	ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >>  	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
> >>  	if (ret) {
> >>  		dev_err(dev, "set sqc failed\n");
> >> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>  	vf_data->vf_qm_state = QM_READY;
> >>  	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
> >>  
> >> +	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
> >> +	if (ret)
> >> +		return ret;
> >> +  
> > 
> > I'd have thought it'd still make sense that qm_{get,set}_regs() would
> > handle this subset of registers even though it's split out into helper
> > functions, now we have the dev_data debugfs failing to fill these
> > registers.  It's not clear it was worthwhile to split out the xqc
> > helpers at all here.  
> 
> Moving the differentiated handling of eqc and aeqc, which results from different drv_mode values,
> into the helper functions can keep the main business logic code for live migration
> clean and concise.

You can keep the helpers if you want, it's already introduced a bug
here separating the xqc register get/set from all the others though.
The helpers are also not removing the redundancy of getting the
register offsets.  It might be better to keep the read/write in the
get/set function and just add a helper for the offsets:

static void qm_xqc_reg_offsets(struct hisi_acc_vf_core_device *hisi_acc_vdev,
			       u32 *eqc_addr, u32 *aeqc_addr)
{
	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
		*eqc_addr = QM_EQC_VF_DW0;
		*aeqc_addr = QM_AEQC_VF_DW0;
	} else {
		*eqc_addr = QM_EQC_PF_DW0;
		*aeqc_addr = QM_AEQC_PF_DW0;
	}
}

Thanks,
Alex

> >   
> >>  	ret = vf_qm_read_data(vf_qm, vf_data);
> >>  	if (ret)
> >>  		return ret;
> >> @@ -1186,34 +1232,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> >>  {
> >>  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> >>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> >> +	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
> >>  	struct pci_dev *vf_dev = vdev->pdev;
> >> +	u32 val;
> >>  
> >> -	/*
> >> -	 * ACC VF dev BAR2 region consists of both functional register space
> >> -	 * and migration control register space. For migration to work, we
> >> -	 * need access to both. Hence, we map the entire BAR2 region here.
> >> -	 * But unnecessarily exposing the migration BAR region to the Guest
> >> -	 * has the potential to prevent/corrupt the Guest migration. Hence,
> >> -	 * we restrict access to the migration control space from
> >> -	 * Guest(Please see mmap/ioctl/read/write override functions).
> >> -	 *
> >> -	 * Please note that it is OK to expose the entire VF BAR if migration
> >> -	 * is not supported or required as this cannot affect the ACC PF
> >> -	 * configurations.
> >> -	 *
> >> -	 * Also the HiSilicon ACC VF devices supported by this driver on
> >> -	 * HiSilicon hardware platforms are integrated end point devices
> >> -	 * and the platform lacks the capability to perform any PCIe P2P
> >> -	 * between these devices.
> >> -	 */
> >> +	val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
> >> +	if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
> >> +		hisi_acc_vdev->drv_mode = HW_ACC_MIG_PF_CTRL;
> >> +	else
> >> +		hisi_acc_vdev->drv_mode = HW_ACC_MIG_VF_CTRL;
> >>  
> >> -	vf_qm->io_base =
> >> -		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> >> -			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> >> -	if (!vf_qm->io_base)
> >> -		return -EIO;
> >> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_PF_CTRL) {
> >> +		/*
> >> +		 * On hardware platforms greater than QM_HW_V3, the migration function
> >> +		 * register is placed in the BAR2 configuration region of the PF,
> >> +		 * and each VF device occupies 8KB of configuration space.
> >> +		 */
> >> +		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
> >> +				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
> >> +	} else {
> >> +		/*
> >> +		 * ACC VF dev BAR2 region consists of both functional register space
> >> +		 * and migration control register space. For migration to work, we
> >> +		 * need access to both. Hence, we map the entire BAR2 region here.
> >> +		 * But unnecessarily exposing the migration BAR region to the Guest
> >> +		 * has the potential to prevent/corrupt the Guest migration. Hence,
> >> +		 * we restrict access to the migration control space from
> >> +		 * Guest(Please see mmap/ioctl/read/write override functions).
> >> +		 *
> >> +		 * Please note that it is OK to expose the entire VF BAR if migration
> >> +		 * is not supported or required as this cannot affect the ACC PF
> >> +		 * configurations.
> >> +		 *
> >> +		 * Also the HiSilicon ACC VF devices supported by this driver on
> >> +		 * HiSilicon hardware platforms are integrated end point devices
> >> +		 * and the platform lacks the capability to perform any PCIe P2P
> >> +		 * between these devices.
> >> +		 */
> >>  
> >> +		vf_qm->io_base =
> >> +			ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> >> +				pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> >> +		if (!vf_qm->io_base)
> >> +			return -EIO;
> >> +	}
> >>  	vf_qm->fun_type = QM_HW_VF;
> >> +	vf_qm->ver = pf_qm->ver;
> >>  	vf_qm->pdev = vf_dev;
> >>  	mutex_init(&vf_qm->mailbox_lock);
> >>  
> >> @@ -1250,6 +1314,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct pci_dev *pdev)
> >>  	return !IS_ERR(pf_qm) ? pf_qm : NULL;
> >>  }
> >>  
> >> +static size_t hisi_acc_get_resource_len(struct vfio_pci_core_device *vdev,
> >> +					unsigned int index)
> >> +{
> >> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> >> +			hisi_acc_drvdata(vdev->pdev);
> >> +
> >> +	/*
> >> +	 * On the old HW_ACC_MIG_VF_CTRL mode device, the ACC VF device
> >> +	 * BAR2 region encompasses both functional register space
> >> +	 * and migration control register space.
> >> +	 * only the functional region should be report to Guest.
> >> +	 */
> >> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL)
> >> +		return (pci_resource_len(vdev->pdev, index) >> 1);
> >> +	/*
> >> +	 * On the new HW device, the migration control register
> >> +	 * has been moved to the PF device BAR2 region.
> >> +	 * The VF device BAR2 is entirely functional register space.
> >> +	 */
> >> +	return pci_resource_len(vdev->pdev, index);
> >> +}
> >> +
> >>  static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
> >>  					size_t count, loff_t *ppos,
> >>  					size_t *new_count)
> >> @@ -1260,8 +1346,9 @@ static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
> >>  
> >>  	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> >>  		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> >> -		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
> >> +		resource_size_t end;
> >>  
> >> +		end = hisi_acc_get_resource_len(vdev, index);
> >>  		/* Check if access is for migration control region */
> >>  		if (pos >= end)
> >>  			return -EINVAL;
> >> @@ -1282,8 +1369,9 @@ static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
> >>  	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> >>  	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> >>  		u64 req_len, pgoff, req_start;
> >> -		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
> >> +		resource_size_t end;
> >>  
> >> +		end = hisi_acc_get_resource_len(vdev, index);
> >>  		req_len = vma->vm_end - vma->vm_start;
> >>  		pgoff = vma->vm_pgoff &
> >>  			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> >> @@ -1330,7 +1418,6 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
> >>  	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> >>  		struct vfio_pci_core_device *vdev =
> >>  			container_of(core_vdev, struct vfio_pci_core_device, vdev);
> >> -		struct pci_dev *pdev = vdev->pdev;
> >>  		struct vfio_region_info info;
> >>  		unsigned long minsz;
> >>  
> >> @@ -1345,12 +1432,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
> >>  		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> >>  			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> >>  
> >> -			/*
> >> -			 * ACC VF dev BAR2 region consists of both functional
> >> -			 * register space and migration control register space.
> >> -			 * Report only the functional region to Guest.
> >> -			 */
> >> -			info.size = pci_resource_len(pdev, info.index) / 2;
> >> +			info.size = hisi_acc_get_resource_len(vdev, info.index);
> >>  
> >>  			info.flags = VFIO_REGION_INFO_FLAG_READ |
> >>  					VFIO_REGION_INFO_FLAG_WRITE |
> >> @@ -1521,7 +1603,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
> >>  	hisi_acc_vf_disable_fds(hisi_acc_vdev);
> >>  	mutex_lock(&hisi_acc_vdev->open_mutex);
> >>  	hisi_acc_vdev->dev_opened = false;
> >> -	iounmap(vf_qm->io_base);
> >> +	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL)
> >> +		iounmap(vf_qm->io_base);
> >>  	mutex_unlock(&hisi_acc_vdev->open_mutex);
> >>  	vfio_pci_core_close_device(core_vdev);
> >>  }
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> index 91002ceeebc1..d287abe3dd31 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> @@ -59,6 +59,26 @@
> >>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
> >>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
> >>  
> >> +#define QM_MIG_REGION_OFFSET		0x180000
> >> +#define QM_MIG_REGION_SIZE		0x2000
> >> +
> >> +#define QM_SUB_VERSION_ID		0x100210  
> > 
> > Above SUB_VERSION_ID isn't used.  
> 
> Yes, this macro variable needs to be removed.
> 
> >   
> >> +#define QM_EQC_PF_DW0			0x1c00
> >> +#define QM_AEQC_PF_DW0			0x1c20  
> > 
> > Seems like it'd make sense to define these next to the VF offsets and
> > perhaps even add "VF" to the existing macros for consistency.  Thanks,
> >  
> 
> OK, it's better to distinguish between the old offset variable names with "VF"
> and the newly added PF offset addresses for clarity
> 
> Thanks,
> Longfang.
> 
> > Alex
> >   
> >> +
> >> +/**
> >> + * On HW_ACC_MIG_VF_CTRL mode, the configuration domain supporting live
> >> + * migration functionality is located in the latter 32KB of the VF's BAR2.
> >> + * The Guest is only provided with the first 32KB of the VF's BAR2.
> >> + * On HW_ACC_MIG_PF_CTRL mode, the configuration domain supporting live
> >> + * migration functionality is located in the PF's BAR2, and the entire 64KB
> >> + * of the VF's BAR2 is allocated to the Guest.
> >> + */
> >> +enum hw_drv_mode {
> >> +	HW_ACC_MIG_VF_CTRL = 0,
> >> +	HW_ACC_MIG_PF_CTRL,
> >> +};
> >> +
> >>  struct acc_vf_data {
> >>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
> >>  	/* QM match information */
> >> @@ -125,6 +145,7 @@ struct hisi_acc_vf_core_device {
> >>  	struct pci_dev *vf_dev;
> >>  	struct hisi_qm *pf_qm;
> >>  	struct hisi_qm vf_qm;
> >> +	int drv_mode;
> >>  	/*
> >>  	 * vf_qm_state represents the QM_VF_STATE register value.
> >>  	 * It is set by Guest driver for the ACC VF dev indicating  
> > 
> > .
> >   


