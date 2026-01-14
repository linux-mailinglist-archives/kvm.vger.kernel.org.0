Return-Path: <kvm+bounces-68006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C20D1D24E
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:36:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A1ED9300F04A
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 08:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA4737F734;
	Wed, 14 Jan 2026 08:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LEY+MWOz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C9937F10B;
	Wed, 14 Jan 2026 08:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768379781; cv=none; b=i7c2/etMeO68UbUPkObhzL63ObLq8ZocVYYQNLW/n49qBxt45ix5dnBYm+S0D6W1H7f6OtviH/Re1idqmWirj7SrNFTRVfWygx30MCW5mBe/O2T6Bsk9vDmFN0DFPtAqKk6WGnjUHAwpiv1AsSb2ldkTjOc/C9rK6BlyEZskbk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768379781; c=relaxed/simple;
	bh=99KsgWKra+6xhdJaIgKBB2Rg2UOcJnsFP4Dw4GOw6vs=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NiDnyjMz/598QMwVNtGelcbKy2XSo3dwWa4uthsCMfiD4CmfJFWT6iZgifEm1/EhN+ad/n1Ax37RQyesP3rgNIQSxyL5OzHS9hVeJ+8wh+cgwvcyqGsqh4HAWMI9ioFbMwgpUsCqnBmzEYH2e9+RbgQp5gqoiaT9egiGisFcGyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LEY+MWOz; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768379777; x=1799915777;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=99KsgWKra+6xhdJaIgKBB2Rg2UOcJnsFP4Dw4GOw6vs=;
  b=LEY+MWOziSdw2Pebhyj/R+HhMQ3pIGIeH+6757oLz5ygfaQtZQIgZpUw
   62UVy2rBsxrrLBUL24lAESHGMMwDCLZ7lW3jB614sGr78irlEyqin1kiL
   iUf71NRp0+qqQv+zSRY+bOGWNDYZ8Yqz5/p9RpMS7AI/2nlIcHsV+WXUO
   sPxEWnxAbJQgSRPKbn9xbvl8QbgaNoRjUAcGC9e+yNbca3l4frPUyq6aD
   SwIuP78wFpgPPtifh9Y9T5f8/YWwwtGhUa4HCVPozQXNxmalY1NWVx+Mg
   o2tEmB5WMDtd40sR1Q5OEIzrRshQfp6mqtUo8V0RKMvqC++fjok2pTOO2
   Q==;
X-CSE-ConnectionGUID: sDrzYy0fSkScV0zzFnryYA==
X-CSE-MsgGUID: z5E1mL0nTJyuXtOOUHWYhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="81038249"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="81038249"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 00:36:14 -0800
X-CSE-ConnectionGUID: uyrcVPWNRMqWc2uPJfetfw==
X-CSE-MsgGUID: O0yIUfY9RHWj8RSiCHLEhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="204678707"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.107])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 00:36:11 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 14 Jan 2026 10:36:08 +0200 (EET)
To: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
    "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, 
    Alex Williamson <alex@shazbot.org>, Nathan Chen <nathanc@nvidia.com>, 
    Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/pci: Lock upstream bridge for
 vfio_pci_core_disable()
In-Reply-To: <BN0PR08MB695173DD697AB6E404803FEA838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
Message-ID: <1ccd984a-a852-2e98-12c5-3547581a3eb7@linux.intel.com>
References: <BN0PR08MB695173DD697AB6E404803FEA838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 13 Jan 2026, Anthony Pighin (Nokia) wrote:

> Fix the following on VFIO detach:

Fix the following warning that occurs during VFIO detach:

> [  242.271584] pcieport 0000:00:00.0: unlocked secondary bus reset via:
>                pci_reset_bus_function+0x188/0x1b8
> 
> Commit 920f6468924f ("Warn on missing cfg_access_lock during secondary
> bus reset") added a warning if the PCI configuration space was not
> locked during a secondary bus reset request. That was in response to
> commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")
> such that remaining paths would be made more visible.
> 
> Address the vfio_pci_core_disable() path.

Similar comments as to the other patch.

Why these are not submitted in a series (they seem to fix very similar 
cases, just for different call chains)?

> Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3a11e6f450f7..aa2c21020ea8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
>  
>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  {
> +	struct pci_dev *bridge;
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_dummy_resource *dummy_res, *tmp;
>  	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
> @@ -694,12 +695,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	 * We can not use the "try" reset interface here, which will
>  	 * overwrite the previously restored configuration information.
>  	 */
> -	if (vdev->reset_works && pci_dev_trylock(pdev)) {
> -		if (!__pci_reset_function_locked(pdev))
> -			vdev->needs_reset = false;
> -		pci_dev_unlock(pdev);
> +	if (vdev->reset_works) {
> +		bridge = pci_upstream_bridge(pdev);
> +		if (bridge && !pci_dev_trylock(bridge))
> +				goto out_restore_state;

Misaligned.

> +		if (pci_dev_trylock(pdev)) {
> +			if (!__pci_reset_function_locked(pdev))
> +				vdev->needs_reset = false;
> +			pci_dev_unlock(pdev);
> +		}
> +		if (bridge)
> +			pci_dev_unlock(bridge);
>  	}
>  
> +out_restore_state:
>  	pci_restore_state(pdev);
>  out:
>  	pci_disable_device(pdev);
> -- 
> 2.43.0
> 

-- 
 i.


