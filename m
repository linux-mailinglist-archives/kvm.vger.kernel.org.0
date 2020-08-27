Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50E22550AA
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 23:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgH0Vgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 17:36:49 -0400
Received: from ale.deltatee.com ([204.191.154.188]:56066 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgH0Vgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 17:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Sender:
        Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
        :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zdm0S2PWnmi/4XqIOhf530rvRuJxiVED1nzE9jKGFv8=; b=ppSg/+iqJxad7jlIdh8Y9MCuj8
        eSljdwyCXvCK6jPPd1tDLxSyQS3OfNvWLb9rtPcYH0tWwPfWbqN/SiMzEXvytS1UAroOMpWq4CKsr
        xfvgurd/B+ph0RQQQ1EzYI+0ZpzdPV5/Uswr2aB44f4wnSsg3hKjVRT5VB+fo6TYDz8WScdTIrB1a
        lqtdPM5OflsEyE9zX8HxA1hW1slt1BtGeyEXEyB6sDZqrjj08vGYlUHqbHHMmg7U/d8+fLz2ulJyX
        sTKVbt8qvuIIoPlaapegTlcU5pwKMVdug8+j4AwArHv8UF09Cs7kGZZdcUEzA8cBdrj5P5NOXyHnm
        VcG2ZJyQ==;
Received: from s01060023bee90a7d.cg.shawcable.net ([24.64.145.4] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1kBPZG-0002Dd-OC; Thu, 27 Aug 2020 15:36:23 -0600
To:     Tom Murphy <murphyt7@tcd.ie>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@infradead.org>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
References: <20191221150402.13868-1-murphyt7@tcd.ie>
 <465815ae-9292-f37a-59b9-03949cb68460@deltatee.com>
 <20200529124523.GA11817@infradead.org>
 <CGME20200529190523eucas1p2c086133e707257c0cdc002f502d4f51d@eucas1p2.samsung.com>
 <33137cfb-603c-86e8-1091-f36117ecfaf3@deltatee.com>
 <ef2150d5-7b6a-df25-c10d-e43316fe7812@samsung.com>
 <b9140772-0370-a858-578c-af503a06d8e9@deltatee.com>
 <CALQxJuutRaeX89k2o4ffTKYRMizmMu0XbRnzpFuSSrkQR02jKg@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <766525c3-4da9-6db7-cd90-fb4b82cd8083@deltatee.com>
Date:   Thu, 27 Aug 2020 15:36:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALQxJuutRaeX89k2o4ffTKYRMizmMu0XbRnzpFuSSrkQR02jKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.145.4
X-SA-Exim-Rcpt-To: joonas.lahtinen@linux.intel.com, jani.nikula@linux.intel.com, dwmw2@infradead.org, kgene@kernel.org, linux-kernel@vger.kernel.org, cohuck@redhat.com, robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org, virtualization@lists.linux-foundation.org, tglx@linutronix.de, linux-tegra@vger.kernel.org, rodrigo.vivi@intel.com, linux-mediatek@lists.infradead.org, alex.williamson@redhat.com, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org, gerald.schaefer@de.ibm.com, agross@kernel.org, linux-rockchip@lists.infradead.org, jonathanh@nvidia.com, krzk@kernel.org, maz@kernel.org, linux-samsung-soc@vger.kernel.org, jean-philippe@linaro.org, will@kernel.org, thierry.reding@gmail.com, julien.grall@arm.com, matthias.bgg@gmail.com, bjorn.andersson@linaro.org, dri-devel@lists.freedesktop.org, airlied@linux.ie, kvm@vger.kernel.org, iommu@lists.linux-foundation.org, hch@infradead.org, m.szyprowski@samsung.com, murphyt7@tcd.ie
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH 0/8] Convert the intel iommu driver to the dma-iommu api
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-08-23 6:04 p.m., Tom Murphy wrote:
> I have added a check for the sg_dma_len == 0 :
> """
>  } __sgt_iter(struct scatterlist *sgl, bool dma) {
>         struct sgt_iter s = { .sgp = sgl };
> 
> +       if (sgl && sg_dma_len(sgl) == 0)
> +           s.sgp = NULL;
> 
>         if (s.sgp) {
>             .....
> """
> at location [1].
> but it doens't fix the problem.

Based on my read of the code, it looks like we also need to change usage
of sgl->length... Something like the rough patch below, maybe?

Also, Tom, do you have an updated version of the patchset to convert the
Intel IOMMU to dma-iommu available? The last one I've found doesn't
apply cleanly (I'm assuming parts of it have been merged in slightly
modified forms).

Thanks,

Logan

--

diff --git a/drivers/gpu/drm/i915/i915_scatterlist.h
b/drivers/gpu/drm/i915/i915
index b7b59328cb76..9367ac801f0c 100644
--- a/drivers/gpu/drm/i915/i915_scatterlist.h
+++ b/drivers/gpu/drm/i915/i915_scatterlist.h
@@ -27,13 +27,19 @@ static __always_inline struct sgt_iter {
 } __sgt_iter(struct scatterlist *sgl, bool dma) {
        struct sgt_iter s = { .sgp = sgl };

+       if (sgl && !sg_dma_len(s.sgp))
+               s.sgp = NULL;
+
        if (s.sgp) {
                s.max = s.curr = s.sgp->offset;
-               s.max += s.sgp->length;
-               if (dma)
+
+               if (dma) {
+                       s.max += sg_dma_len(s.sgp);
                        s.dma = sg_dma_address(s.sgp);
-               else
+               } else {
+                       s.max += s.sgp->length;
                        s.pfn = page_to_pfn(sg_page(s.sgp));
+               }
        }

        return s;
