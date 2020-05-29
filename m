Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961361E7145
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 02:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438046AbgE2AY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 20:24:29 -0400
Received: from ts18-13.vcr.istar.ca ([204.191.154.188]:45220 "EHLO
        ale.deltatee.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S2437659AbgE2AY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 20:24:27 -0400
X-Greylist: delayed 1339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2020 20:24:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Sender:
        Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
        :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SHO6IGYEd6YDcItDhjnlUPf5s8OIRwKvgFq6kM1/DP0=; b=r/axjxYlIiDMYaBSzOJcmN4D8z
        5nhVyK5+jkTuLY9r/DkIPGDqA4zBXW2lnj24/75M8PApunP8NH63l8JZKK4zOM+RkgNUjkh8Zu7L0
        uAWAMjn96WqKiZuaMyo8cBfMY0aRwfiPej4ElwlF0HqAS+905dMVMngwIHFwJNhllq+TXuBP3naK4
        /r6v4D4I21bAG2X4/zOYuy5cJVYuMqe8ZbDWBeVK1iPsKmEydsM4SFCoqrouhRTbQELtOXUOa1f+x
        r0Injuuidql/AmLXAXcQzgEff4xFuOZ6W7hJhBwZm1rFF3QVErdj3XcX2phEoDBlDrcVSy7R3MomJ
        Ro1gd+aA==;
Received: from s0106602ad0811846.cg.shawcable.net ([68.147.191.165] helo=[192.168.0.12])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1jeSSD-0001kd-5g; Thu, 28 May 2020 18:00:54 -0600
To:     Tom Murphy <murphyt7@tcd.ie>, iommu@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-tegra@vger.kernel.org, Julien Grall <julien.grall@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-rockchip@lists.infradead.org, Andy Gross <agross@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
References: <20191221150402.13868-1-murphyt7@tcd.ie>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <465815ae-9292-f37a-59b9-03949cb68460@deltatee.com>
Date:   Thu, 28 May 2020 18:00:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20191221150402.13868-1-murphyt7@tcd.ie>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 68.147.191.165
X-SA-Exim-Rcpt-To: baolu.lu@linux.intel.com, robin.murphy@arm.com, kgene@kernel.org, linux-kernel@vger.kernel.org, cohuck@redhat.com, dwmw2@infradead.org, gerald.schaefer@de.ibm.com, virtualization@lists.linux-foundation.org, tglx@linutronix.de, matthias.bgg@gmail.com, rodrigo.vivi@intel.com, linux-mediatek@lists.infradead.org, alex.williamson@redhat.com, eric.auger@redhat.com, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org, agross@kernel.org, linux-rockchip@lists.infradead.org, jonathanh@nvidia.com, krzk@kernel.org, maz@kernel.org, linux-samsung-soc@vger.kernel.org, jean-philippe@linaro.org, m.szyprowski@samsung.com, will@kernel.org, thierry.reding@gmail.com, julien.grall@arm.com, linux-tegra@vger.kernel.org, bjorn.andersson@linaro.org, dri-devel@lists.freedesktop.org, airlied@linux.ie, kvm@vger.kernel.org, iommu@lists.linux-foundation.org, murphyt7@tcd.ie
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH 0/8] Convert the intel iommu driver to the dma-iommu api
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tom,

On 2019-12-21 8:03 a.m., Tom Murphy wrote:
> This patchset converts the intel iommu driver to the dma-iommu api.

Just wanted to note that I've rebased your series on recent kernels and
have done some testing on my old Sandybridge machine (without the DO NOT
MERGE patch) and have found no issues. I hope this can make progress
soon and get merged soon. If you like you can add:

Tested-By: Logan Gunthorpe <logang@deltatee.com>

> While converting the driver I exposed a bug in the intel i915 driver which causes a huge amount of artifacts on the screen of my laptop. You can see a picture of it here:
> https://github.com/pippy360/kernelPatches/blob/master/IMG_20191219_225922.jpg
> 
> This issue is most likely in the i915 driver and is most likely caused by the driver not respecting the return value of the dma_map_ops::map_sg function. You can see the driver ignoring the return value here:
> https://github.com/torvalds/linux/blob/7e0165b2f1a912a06e381e91f0f4e495f4ac3736/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c#L51
> 
> Previously this didn’t cause issues because the intel map_sg always returned the same number of elements as the input scatter gather list but with the change to this dma-iommu api this is no longer the case. I wasn’t able to track the bug down to a specific line of code unfortunately.  

I did some digging into this myself and while I don't have full patch, I
think I traced it closer to the problem.

Sadly, ignoring the number of nents returned by map_sg() is endemic to
dma-buf users, but AMD's GPU driver seems to do the same thing,
presumably without issues.

Digging a bit further, I found that the i915 has an "innovative" way of
iterating through SGLs, see [1]. I suspect if __sgt_iter is changed to
increment with sg_dma_len() and return NULL when there is no length
left, it may fix the issue.

But, sorry, I don't really have the means or time to fix and test this
myself.

Thanks,

Logan

[1]
https://elixir.bootlin.com/linux/v5.7-rc7/source/drivers/gpu/drm/i915/i915_scatterlist.h#L76
