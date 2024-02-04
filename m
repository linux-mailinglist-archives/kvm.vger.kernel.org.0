Return-Path: <kvm+bounces-7952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B7F848D18
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 12:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACEE31F21EC6
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 11:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD112209F;
	Sun,  4 Feb 2024 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+YYUSPc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CCC219F6;
	Sun,  4 Feb 2024 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707045649; cv=none; b=ZewVojqVhnq6zDokFZrBAchaOsYMcucMpXYNyvRC8Q2bUc631Vj6pFEcn9NXzANga1fIfw0KN8/qcc1G964YgsJFza+dhS03A2e6LfT24tm4/UqqVBZ9PqxuU5qGAqzLE88cBCQqdHG8tbQCqrh2dioZ++Y2is2XtuQJYb/im0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707045649; c=relaxed/simple;
	bh=gyDst7/eGUNtEbvcd5veYryHJOS12fm91uoZLHb14BY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YI79rEolNZAOy61J3LSXv7xXuxBkbAYmMeb8G6PZWdrTWcouTTrVy7mowfhNj+1RGh5RW7CHnv1WCrEaVDLpvMzot5ZDTkSOdUvysxVemckobF+evw21iwYdKeF0tyfgZXJPpnuYecPiqiHmkcaDdVPeDj27bOsvc1QnrV+5e+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+YYUSPc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE51C433C7;
	Sun,  4 Feb 2024 11:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707045649;
	bh=gyDst7/eGUNtEbvcd5veYryHJOS12fm91uoZLHb14BY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R+YYUSPcUyCeeEuzTDppzp9xZG+icLMMEHXtSxhqpkft2PiUdh6qYQ8whR9lTiSR0
	 xHd9H7MwMkCMQ+EL9PoGwVO/JnyNa0EPBNX53KzLDzT1pNJvxOVIBZX9XkCT+sE8Fo
	 Zmlwjrew/UHuoA3lfBzKb0QJiTxlWnuqZLZc46v26gNvYNRUZYIiEriEkJZM/mc4kJ
	 4mmjp+8GPE77M62rfoXXKzxZAojqHYr+ti8z0Qh+93RLe/w9Td2Eaz0h6SOd490ROU
	 SIZksWQZ9rB6stHZf+L87+F4o+8Kuf6R/ICWa3SIrgUXdXvsQj4GFpn2a+plNns+e9
	 qOAErYX3CzUUA==
Date: Sun, 4 Feb 2024 13:20:44 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Emily Deng <Emily.Deng@amd.com>
Cc: amd-gfx@lists.freedesktop.org, bhelgaas@google.com,
	alex.williamson@redhat.com, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] PCI: Add vf reset notification for pf
Message-ID: <20240204112044.GC5400@unreal>
References: <20240204061257.1408243-1-Emily.Deng@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240204061257.1408243-1-Emily.Deng@amd.com>

On Sun, Feb 04, 2024 at 02:12:57PM +0800, Emily Deng wrote:
> When a vf has been reset, the pf wants to get notification to remove the vf
> out of schedule.

It is very questionable if this is right thing to do. The idea of SR-IOV
is that VFs represent a physical device and they should be treated
separately from the PF.

In addition to that Keith said, this patch needs better justification.

Thanks

> 
> Solution:
> Add the callback function in pci_driver sriov_vf_reset_notification. When
> vf reset happens, then call this callback function.
> 
> Signed-off-by: Emily Deng <Emily.Deng@amd.com>
> ---
>  drivers/pci/pci.c   | 8 ++++++++
>  include/linux/pci.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 60230da957e0..aca937b05531 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4780,6 +4780,14 @@ EXPORT_SYMBOL_GPL(pcie_flr);
>   */
>  int pcie_reset_flr(struct pci_dev *dev, bool probe)
>  {
> +	struct pci_dev *pf_dev;
> +
> +	if (dev->is_virtfn) {
> +		pf_dev = dev->physfn;
> +		if (pf_dev->driver->sriov_vf_reset_notification)
> +			pf_dev->driver->sriov_vf_reset_notification(pf_dev, dev);
> +	}
> +
>  	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
>  		return -ENOTTY;
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index c69a2cc1f412..4fa31d9b0aa7 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -926,6 +926,7 @@ struct pci_driver {
>  	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
>  	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
>  	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
> +	void  (*sriov_vf_reset_notification)(struct pci_dev *pf, struct pci_dev *vf);
>  	const struct pci_error_handlers *err_handler;
>  	const struct attribute_group **groups;
>  	const struct attribute_group **dev_groups;
> -- 
> 2.36.1
> 
> 

