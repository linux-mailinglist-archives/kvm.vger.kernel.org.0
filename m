Return-Path: <kvm+bounces-34549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DF883A00ED9
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 21:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 525B17A1F4B
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D238C1BEF86;
	Fri,  3 Jan 2025 20:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8M488aL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D778C26281;
	Fri,  3 Jan 2025 20:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735936462; cv=none; b=d9E7fJJ6mc7oytEX3RMGy4ETZK6DvehjTVoKG+/a5bg1TTs7+3DgLX0BOxAXG+KfxZza3GFB6esflogzYqiR8jU/t2uBEGQP/jnvulbvZlskTteNUtZknUSzQ2rQqIVYOfDoTAW+XCprF2TWKIh/Izhp6c8VicHvvxyretIKRi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735936462; c=relaxed/simple;
	bh=1ZGLulGDlTSpJxCguhGrREQr5gRXYqPGBZZ/QU6S1do=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=BY8lvZnZ9n/H/qKBhdAgomtfB5bxCWVUVI2lPv8YCLfE1NYAxITn2c8GeRAaujhDhBdKtcI3Tx3wuvtfOUjB4OEeZ0dQRznKifbgAfDVX1BV3OFpzgFFGKzUnYUs3sFMr4TvGDDN5B0lOY9xGuqschtAdwrmeZb/atox222ihvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8M488aL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F0FC4CECE;
	Fri,  3 Jan 2025 20:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735936460;
	bh=1ZGLulGDlTSpJxCguhGrREQr5gRXYqPGBZZ/QU6S1do=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=S8M488aLHj8YsuX4skSyMkDhobtt51M+IfjDXAFlPoz/mKb1Kr5T+l0pqUSn0YLNc
	 fJSGx8HMuqTpXi11J5y32fYY8PURzV3VJKZXrDj6JTKWjSBSBrRnvwUnpxx33PKLZI
	 d+QVKKyEVbaS60j1LZPpVMizKCEdONQK4e0XbBsyiUf6y6HtuZc3Yz0OTOHb4ZEwDR
	 yQDKKktFGWJEjCuDABLY8ENZ//g4iS0A6tC4dxZskJuDy47U0KkUxUr9za3vwebKTM
	 q4AUmRIoPOGsZsm7WTe2vcMokVZP9/P8Kx9laEQuw+QE2t0inEguU4Jf0egjXjS7f4
	 SDl66nkiVVNmA==
Date: Fri, 3 Jan 2025 14:34:18 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: zhangdongdong@eswincomputing.com
Cc: alex.williamson@redhat.com, bhelgaas@google.com, yishaih@nvidia.com,
	avihaih@nvidia.com, yi.l.liu@intel.com, ankita@nvidia.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Remove redundant macro
Message-ID: <20250103203418.GA4193119@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241216013536.4487-1-zhangdongdong@eswincomputing.com>

On Mon, Dec 16, 2024 at 09:35:36AM +0800, zhangdongdong@eswincomputing.com wrote:
> From: Dongdong Zhang <zhangdongdong@eswincomputing.com>
> 
> Removed the duplicate macro `PCI_VSEC_HDR` and its related macro
> `PCI_VSEC_HDR_LEN_SHIFT` from `pci_regs.h` to avoid redundancy and
> inconsistencies. Updated VFIO PCI code to use `PCI_VNDR_HEADER` and
> `PCI_VNDR_HEADER_LEN()` for consistent naming and functionality.
> 
> These changes aim to streamline header handling while minimizing
> impact, given the niche usage of these macros in userspace.
> 
> Signed-off-by: Dongdong Zhang <zhangdongdong@eswincomputing.com>

Applied with Alex's ack to pci/misc for v6.14, thanks!

> ---
>  drivers/vfio/pci/vfio_pci_config.c | 5 +++--
>  include/uapi/linux/pci_regs.h      | 3 ---
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index ea2745c1ac5e..5572fd99b921 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1389,11 +1389,12 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
>  
>  	switch (ecap) {
>  	case PCI_EXT_CAP_ID_VNDR:
> -		ret = pci_read_config_dword(pdev, epos + PCI_VSEC_HDR, &dword);
> +		ret = pci_read_config_dword(pdev, epos + PCI_VNDR_HEADER,
> +					    &dword);
>  		if (ret)
>  			return pcibios_err_to_errno(ret);
>  
> -		return dword >> PCI_VSEC_HDR_LEN_SHIFT;
> +		return PCI_VNDR_HEADER_LEN(dword);
>  	case PCI_EXT_CAP_ID_VC:
>  	case PCI_EXT_CAP_ID_VC9:
>  	case PCI_EXT_CAP_ID_MFVC:
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 1601c7ed5fab..bcd44c7ca048 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -1001,9 +1001,6 @@
>  #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
>  #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
>  
> -#define PCI_VSEC_HDR		4	/* extended cap - vendor-specific */
> -#define  PCI_VSEC_HDR_LEN_SHIFT	20	/* shift for length field */
> -
>  /* SATA capability */
>  #define PCI_SATA_REGS		4	/* SATA REGs specifier */
>  #define  PCI_SATA_REGS_MASK	0xF	/* location - BAR#/inline */
> -- 
> 2.17.1
> 

