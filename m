Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0BE128BF3
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2019 00:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLUXqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 18:46:42 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:34193 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfLUXqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Dec 2019 18:46:42 -0500
Received: by mail-qv1-f65.google.com with SMTP id o18so5079840qvf.1;
        Sat, 21 Dec 2019 15:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DZy1sByRbPp81Fc4unsIfUDkM1speXohHbJEFLa+79Y=;
        b=K2F08+kbBOHpEb5GI2snEkwsgZNjaPXWMKDftdpnSDrNjdoFsaU7mJy1E8X+UN6pTF
         CqMGQGTCVzkASTJTbCKGzwmcE+xGW9X9DoBShnHYBHrUjwA2y0thgfSaIDeXsAsxh80K
         Lzsw/9ErY21ZUOic82HoE2snRWWJy1wLWDPwW7IWmh5yvrdgv4rUVX4xVE004OheL+PI
         /8AUmTvOKwGIU5Ku/sIm9m5U0rOim/SPjYy3gzVxef0QWGwTj1JJt9SDEH83TWoChVOq
         wLkEyhYrjgWcWjYym7iQAuL3qcxgGsX3JQNmgv7pU5p9IHVMooy6My1cg5SbonFnCmxX
         Fqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=DZy1sByRbPp81Fc4unsIfUDkM1speXohHbJEFLa+79Y=;
        b=cvV8272CjqKNjseP9IVVUXbbxKJ0slLx1WsbkDJHDoeN/3vHwuctTz95T3x5v8qef4
         wfQuL7StZwZjPkgUDbtB+lwe/oMAwB9Xbdy10mk/u+2jQR3GNEe7D0D74q70kMq9arlb
         PNhpmuqIUw/xbiPYSNl5/rUdu6ZFvqxccOvNBRozsvoS6a54JRTc/3sqU3aSAA/0JUGC
         Y3VAraup61c7CsK8ZBh2M96ClkM7ofpaMh+1a0fD0joJM0iWn/CYvcAr53OIWtdMFcZl
         FXh0enaSlbVfnKVaYH03LCc6yFScN4tbWLcZmnZySjUxro6ycPDJmnN/BrhaN27W9cjt
         IMDw==
X-Gm-Message-State: APjAAAXdYKo5LbSIyB+ksyGRkl7Fcg1OvKReFWcuR7hCwWAQBk3DWZYm
        wG6m4ecW0EFirlb5YPryXQA=
X-Google-Smtp-Source: APXvYqxZv5pvU+COa+Z57bqd7TVlj3AKMVnWrlNSwtaonBLRwl6oAVA7CbZzWjXYXul1zP2Wc7+ZAQ==
X-Received: by 2002:a05:6214:14b3:: with SMTP id bo19mr18216129qvb.93.1576972000657;
        Sat, 21 Dec 2019 15:46:40 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id b7sm4323472qkh.106.2019.12.21.15.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 15:46:40 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sat, 21 Dec 2019 18:46:37 -0500
To:     Tom Murphy <murphyt7@tcd.ie>
Cc:     iommu@lists.linux-foundation.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Julien Grall <julien.grall@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/8] iommu/vt-d: clean up 32bit si_domain assignment
Message-ID: <20191221234635.GA99623@rani.riverdale.lan>
References: <20191221150402.13868-1-murphyt7@tcd.ie>
 <20191221150402.13868-2-murphyt7@tcd.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191221150402.13868-2-murphyt7@tcd.ie>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 21, 2019 at 03:03:53PM +0000, Tom Murphy wrote:
> In the intel iommu driver devices which only support 32bit DMA can't be
> direct mapped. The implementation of this is weird. Currently we assign
> it a direct mapped domain and then remove the domain later and replace
> it with a domain of type IOMMU_DOMAIN_IDENTITY. We should just assign it
> a domain of type IOMMU_DOMAIN_IDENTITY from the begging rather than
> needlessly swapping domains.
> 
> Signed-off-by: Tom Murphy <murphyt7@tcd.ie>
> ---
>  drivers/iommu/intel-iommu.c | 88 +++++++++++++------------------------
>  1 file changed, 31 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 0c8d81f56a30..c1ea66467918 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -5640,7 +5609,12 @@ static int intel_iommu_add_device(struct device *dev)
>  	domain = iommu_get_domain_for_dev(dev);
>  	dmar_domain = to_dmar_domain(domain);
>  	if (domain->type == IOMMU_DOMAIN_DMA) {
> -		if (device_def_domain_type(dev) == IOMMU_DOMAIN_IDENTITY) {
> +		/*
> +		 * We check dma_mask >= dma_get_required_mask(dev) because
> +		 * 32 bit DMA falls back to non-identity mapping.
> +		 */
> +		if (device_def_domain_type(dev) == IOMMU_DOMAIN_IDENTITY &&
> +				dma_mask >= dma_get_required_mask(dev)) {
>  			ret = iommu_request_dm_for_dev(dev);
>  			if (ret) {
>  				dmar_remove_one_dev_info(dev);
> -- 
> 2.20.1
> 

Should this be dma_direct_get_required_mask? dma_get_required_mask may
return DMA_BIT_MASK(32) -- it callbacks into intel_get_required_mask,
but I'm not sure what iommu_no_mapping(dev) will do at this point?
