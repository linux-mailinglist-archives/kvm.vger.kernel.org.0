Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9301E8733
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 21:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgE2TFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 15:05:36 -0400
Received: from ts18-13.vcr.istar.ca ([204.191.154.188]:56172 "EHLO
        ale.deltatee.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgE2TFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 15:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Sender:
        Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
        :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nhAOftfyfj+FPkKvFiLyWhZt65EpTKYajbE3eXvsvFs=; b=Au5x22kdoavuCP15EixJShyeVc
        xSf1ZvVd/sQsd21cm+wlMkMVPvmWUNCuTwOXOspqpww0a042+UM9sc8AJpFSpVUsYFEh4rsbl+FZO
        mMdOQJ13c/r35Pu4XwHP/vpqKEt1ZJMUTg9psw1MVR5EgpPeLY9sRw+TQrOl/N7TMJ4xk94Jk+rsJ
        Mvp7tDsg05uFy8LEnvhacd6Quyv6NmV6RcOMnRcr4Hqh//UfP6DTM/gi45aQ297i+RyOU4NJbKQDQ
        6TF9Pp10KoRcCt2b1u3v2J2JlzgFkHY8usyjXKelkV30hDNKVxV6NcEJ6BWnhbYJBUP/1z43voVXr
        CQIfKJBg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtp (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1jekJh-0002Ks-TI; Fri, 29 May 2020 13:05:18 -0600
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Tom Murphy <murphyt7@tcd.ie>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Julien Grall <julien.grall@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-rockchip@lists.infradead.org, Andy Gross <agross@kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
References: <20191221150402.13868-1-murphyt7@tcd.ie>
 <465815ae-9292-f37a-59b9-03949cb68460@deltatee.com>
 <20200529124523.GA11817@infradead.org>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <33137cfb-603c-86e8-1091-f36117ecfaf3@deltatee.com>
Date:   Fri, 29 May 2020 13:05:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529124523.GA11817@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: joonas.lahtinen@linux.intel.com, jani.nikula@linux.intel.com, m.szyprowski@samsung.com, dwmw2@infradead.org, kgene@kernel.org, linux-kernel@vger.kernel.org, cohuck@redhat.com, robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org, virtualization@lists.linux-foundation.org, tglx@linutronix.de, linux-tegra@vger.kernel.org, rodrigo.vivi@intel.com, linux-mediatek@lists.infradead.org, alex.williamson@redhat.com, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org, gerald.schaefer@de.ibm.com, agross@kernel.org, linux-rockchip@lists.infradead.org, jonathanh@nvidia.com, krzk@kernel.org, maz@kernel.org, linux-samsung-soc@vger.kernel.org, jean-philippe@linaro.org, will@kernel.org, thierry.reding@gmail.com, julien.grall@arm.com, matthias.bgg@gmail.com, bjorn.andersson@linaro.org, dri-devel@lists.freedesktop.org, airlied@linux.ie, kvm@vger.kernel.org, iommu@lists.linux-foundation.org, murphyt7@tcd.ie, hch@infradead.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH 0/8] Convert the intel iommu driver to the dma-iommu api
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-29 6:45 a.m., Christoph Hellwig wrote:
> On Thu, May 28, 2020 at 06:00:44PM -0600, Logan Gunthorpe wrote:
>>> This issue is most likely in the i915 driver and is most likely caused by the driver not respecting the return value of the dma_map_ops::map_sg function. You can see the driver ignoring the return value here:
>>> https://github.com/torvalds/linux/blob/7e0165b2f1a912a06e381e91f0f4e495f4ac3736/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c#L51
>>>
>>> Previously this didn’t cause issues because the intel map_sg always returned the same number of elements as the input scatter gather list but with the change to this dma-iommu api this is no longer the case. I wasn’t able to track the bug down to a specific line of code unfortunately.  
> 
> Mark did a big audit into the map_sg API abuse and initially had
> some i915 patches, but then gave up on them with this comment:
> 
> "The biggest TODO is DRM/i915 driver and I don't feel brave enough to fix
>  it fully. The driver creatively uses sg_table->orig_nents to store the
>  size of the allocate scatterlist and ignores the number of the entries
>  returned by dma_map_sg function. In this patchset I only fixed the
>  sg_table objects exported by dmabuf related functions. I hope that I
>  didn't break anything there."
> 
> it would be really nice if the i915 maintainers could help with sorting
> that API abuse out.
> 

I agree completely that the API abuse should be sorted out, but I think
that's much larger than just the i915 driver. Pretty much every dma-buf
map_dma_buf implementation I looked at ignores the returned nents of
sg_attrs. This sucks, but I don't think it's the bug Tom ran into. See:

amdgpu_dma_buf_map
armada_gem_prime_map_dma_buf
drm_gem_map_dma_buf
i915_gem_map_dma_buf
tegra_gem_prime_map_dma_buf

So this should probably be addressed by the whole GPU community.

However, as Robin pointed out, there are other ugly tricks like stopping
iterating through the SGL when sg_dma_len() is zero. For example, the
AMD driver appears to use drm_prime_sg_to_page_addr_arrays() which does
this trick and thus likely isn't buggy (otherwise, I'd expect someone to
have complained by now seeing AMD has already switched to IOMMU-DMA.

As I tried to point out in my previous email, i915 does not do this
trick. In fact, it completely ignores sg_dma_len() and is thus
completely broken. See i915_scatterlist.h and the __sgt_iter() function.
So it doesn't sound to me like Mark's fix would address the issue at
all. Per my previous email, I'd guess that it can be fixed simply by
adjusting the __sgt_iter() function to do something more sensible.
(Better yet, if possible, ditch __sgt_iter() and use the common DRM
function that AMD uses).

This would at least allow us to make progress with Tom's IOMMU-DMA patch
set and once that gets in, it will be harder for other drivers to make
the same mistake.

Logan


