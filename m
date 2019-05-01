Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D8C10709
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 12:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfEAKiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 06:38:18 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:57718 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfEAKiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 06:38:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBCEB80D;
        Wed,  1 May 2019 03:38:17 -0700 (PDT)
Received: from [10.1.37.14] (unknown [10.1.37.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF9383F719;
        Wed,  1 May 2019 03:38:14 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v7 05/23] iommu: Introduce cache_invalidate API
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc:     peter.maydell@linaro.org, kevin.tian@intel.com,
        vincent.stehle@arm.com, ashok.raj@intel.com, marc.zyngier@arm.com,
        christoffer.dall@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-6-eric.auger@redhat.com>
Message-ID: <a9745aef-8686-c761-e3d0-dd0e98a1f5b2@arm.com>
Date:   Wed, 1 May 2019 11:38:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408121911.24103-6-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/2019 13:18, Eric Auger wrote:
> +int iommu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
> +			   struct iommu_cache_invalidate_info *inv_info)
> +{
> +	int ret = 0;
> +
> +	if (unlikely(!domain->ops->cache_invalidate))
> +		return -ENODEV;
> +
> +	ret = domain->ops->cache_invalidate(domain, dev, inv_info);
> +
> +	return ret;

Nit: you don't really need ret

The UAPI looks good to me, so

Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
