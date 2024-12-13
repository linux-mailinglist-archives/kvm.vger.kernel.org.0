Return-Path: <kvm+bounces-33757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 165579F13D9
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 18:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB718280CA2
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C9A1E5711;
	Fri, 13 Dec 2024 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FczdbIr3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674C71E411D;
	Fri, 13 Dec 2024 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734111423; cv=none; b=mS1GbyQkBBYBE1HsLVBUcKNLp4215oEXxcd+McXlXSMVxO6orNasCVusztc3Y4byaswC8N7eMNFzkSvuStmS5l5FMaiFm1InUdeYnEhiJDYNXKynyrFtgfzOgupaOuFInKUEW0XfzlKQvaU9Lf0SmfHaSIbmw+2bMKMN5NsnE+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734111423; c=relaxed/simple;
	bh=TPjNyO3hUQt1c7Qv2LFixn3eov+lAMQBbXMkeYju2CA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=u7kdhD/SeppqtSRasDYx+qCv6lSq/JAul4zsDWFSxVqv5dbqH2Hd3xUXIC9+4fysD1JBdhC0rZShzcHYVUxlObG021Ol/GKTk06h1d9tLwibtJjTmo9FyNqBchisdXuYGDYaNXY66BDyKzw0/xODmSj6+G6ygWc/FjYebt1IM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FczdbIr3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21232C4CED0;
	Fri, 13 Dec 2024 17:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734111423;
	bh=TPjNyO3hUQt1c7Qv2LFixn3eov+lAMQBbXMkeYju2CA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=FczdbIr3msWtbFOtXybKq+61kkP/SsP//pjuHuvnT+St79Nx0v6Ckn4JTGlBoQYwc
	 qGOcuMymOBbiD5mUbuIk94lUq0TwDqH4Q99QTPS/WSP8MZTLyUzvsB2E2k+nT3Xu5x
	 AmGh9/Nsy0Wew64KNqZbGeHjJ2dgziu0VRkAydQqSxk0ISh/S5c2+m1t8WiY7MyZ7V
	 9Wn0oc4R1nhR4O9k4hMmF9fWMb5gpHU9aJoirDe13nZvAuGZOWerGR6UV0RgYdlCls
	 rs6XbgLIuWlc8CNCnoQuyICn181YAGjyJH8AaX8JFhYIVM8RUAW8ACOTCh2EoW2wuw
	 tIiuJP7yq06wg==
Date: Fri, 13 Dec 2024 11:37:01 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: zhangdongdong@eswincomputing.com
Cc: alex.williamson@redhat.com, bhelgaas@google.com, yishaih@nvidia.com,
	avihaih@nvidia.com, yi.l.liu@intel.com, ankita@nvidia.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Remove redundant macro
Message-ID: <20241213173701.GA3419486@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213094617.1149-1-zhangdongdong@eswincomputing.com>

On Fri, Dec 13, 2024 at 05:46:17PM +0800, zhangdongdong@eswincomputing.com wrote:
> From: Dongdong Zhang <zhangdongdong@eswincomputing.com>
> 
> Removed the duplicate macro definition PCI_VSEC_HDR from
> pci_regs.h to avoid redundancy. Updated the VFIO PCI code
> to use the existing `PCI_VNDR_HEADER` macro for consistency,
> ensuring minimal changes to the codebase.
> 
> Signed-off-by: Dongdong Zhang <zhangdongdong@eswincomputing.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 3 ++-
>  include/uapi/linux/pci_regs.h      | 1 -
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index ea2745c1ac5e..c30748912ff1 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1389,7 +1389,8 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
>  
>  	switch (ecap) {
>  	case PCI_EXT_CAP_ID_VNDR:
> -		ret = pci_read_config_dword(pdev, epos + PCI_VSEC_HDR, &dword);
> +		ret = pci_read_config_dword(pdev, epos + PCI_VNDR_HEADER,
> +					    &dword);
>  		if (ret)
>  			return pcibios_err_to_errno(ret);
>  
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 1601c7ed5fab..7b6cad788de3 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -1001,7 +1001,6 @@
>  #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
>  #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
>  
> -#define PCI_VSEC_HDR		4	/* extended cap - vendor-specific */
>  #define  PCI_VSEC_HDR_LEN_SHIFT	20	/* shift for length field */

We should resolve the duplication of PCI_VSEC_HDR and PCI_VNDR_HEADER,
but I don't like the fact that we're left with this dangling
PCI_VSEC_HDR_LEN_SHIFT.

That leaves vfio using PCI_VNDR_HEADER and PCI_VSEC_HDR_LEN_SHIFT,
which don't match at all.

I think you should remove PCI_VSEC_HDR_LEN_SHIFT as well and change
vfio to use PCI_VNDR_HEADER_LEN() instead.

It's somewhat dicey removing things from pci_regs.h since it's in
include/uapi/, but this is such a niche thing we might be able to get
away with it.

Bjorn

