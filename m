Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9846E261F09
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 21:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732547AbgIHT57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 15:57:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:44128 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbgIHPfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:46 -0400
IronPort-SDR: Vk1a8Xp01oHqi3a6rxgficaRMRGr8uTq6Dp/08L+148x0hEhYgnTroXXPB0ja9+tz03LOoCo35
 xddhQ16YHyvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="159124946"
X-IronPort-AV: E=Sophos;i="5.76,406,1592895600"; 
   d="scan'208";a="159124946"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 08:28:50 -0700
IronPort-SDR: OqiPE0Cn/mbaoFglvyhAf2rWnLm6JquwW+AKzi6KXAQYqzMCNSFdbI9D+UGi2vd+sJzRv/8Kvj
 Oe6qN0U8cxmQ==
X-IronPort-AV: E=Sophos;i="5.76,406,1592895600"; 
   d="scan'208";a="480068519"
Received: from sderix-mobl1.ger.corp.intel.com (HELO [10.214.213.131]) ([10.214.213.131])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 08:28:38 -0700
Subject: Re: [Intel-gfx] [PATCH 0/8] Convert the intel iommu driver to the
 dma-iommu api
To:     Logan Gunthorpe <logang@deltatee.com>, Tom Murphy <murphyt7@tcd.ie>
Cc:     kvm@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-tegra@vger.kernel.org, Julien Grall <julien.grall@arm.com>,
        Will Deacon <will@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-rockchip@lists.infradead.org, Andy Gross <agross@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Kukjin Kim <kgene@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
References: <20191221150402.13868-1-murphyt7@tcd.ie>
 <465815ae-9292-f37a-59b9-03949cb68460@deltatee.com>
 <20200529124523.GA11817@infradead.org>
 <CGME20200529190523eucas1p2c086133e707257c0cdc002f502d4f51d@eucas1p2.samsung.com>
 <33137cfb-603c-86e8-1091-f36117ecfaf3@deltatee.com>
 <ef2150d5-7b6a-df25-c10d-e43316fe7812@samsung.com>
 <b9140772-0370-a858-578c-af503a06d8e9@deltatee.com>
 <CALQxJuutRaeX89k2o4ffTKYRMizmMu0XbRnzpFuSSrkQR02jKg@mail.gmail.com>
 <766525c3-4da9-6db7-cd90-fb4b82cd8083@deltatee.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <60a82319-cbee-4cd1-0d5e-3c407cc51330@linux.intel.com>
Date:   Tue, 8 Sep 2020 16:28:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <766525c3-4da9-6db7-cd90-fb4b82cd8083@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi,

On 27/08/2020 22:36, Logan Gunthorpe wrote:
> On 2020-08-23 6:04 p.m., Tom Murphy wrote:
>> I have added a check for the sg_dma_len == 0 :
>> """
>>   } __sgt_iter(struct scatterlist *sgl, bool dma) {
>>          struct sgt_iter s = { .sgp = sgl };
>>
>> +       if (sgl && sg_dma_len(sgl) == 0)
>> +           s.sgp = NULL;
>>
>>          if (s.sgp) {
>>              .....
>> """
>> at location [1].
>> but it doens't fix the problem.
> 
> Based on my read of the code, it looks like we also need to change usage
> of sgl->length... Something like the rough patch below, maybe?

This thread was brought to my attention and I initially missed this 
reply. Essentially I came to the same conclusion about the need to use 
sg_dma_len. One small correction below:

> Also, Tom, do you have an updated version of the patchset to convert the
> Intel IOMMU to dma-iommu available? The last one I've found doesn't
> apply cleanly (I'm assuming parts of it have been merged in slightly
> modified forms).
> 
> Thanks,
> 
> Logan
> 
> --
> 
> diff --git a/drivers/gpu/drm/i915/i915_scatterlist.h
> b/drivers/gpu/drm/i915/i915
> index b7b59328cb76..9367ac801f0c 100644
> --- a/drivers/gpu/drm/i915/i915_scatterlist.h
> +++ b/drivers/gpu/drm/i915/i915_scatterlist.h
> @@ -27,13 +27,19 @@ static __always_inline struct sgt_iter {
>   } __sgt_iter(struct scatterlist *sgl, bool dma) {
>          struct sgt_iter s = { .sgp = sgl };
> 
> +       if (sgl && !sg_dma_len(s.sgp))

I'd extend the condition to be, just to be safe:

	if (dma && sgl && !sg_dma_len(s.sgp))

> +               s.sgp = NULL;
> +
>          if (s.sgp) {
>                  s.max = s.curr = s.sgp->offset;
> -               s.max += s.sgp->length;
> -               if (dma)
> +
> +               if (dma) {
> +                       s.max += sg_dma_len(s.sgp);
>                          s.dma = sg_dma_address(s.sgp);
> -               else
> +               } else {
> +                       s.max += s.sgp->length;
>                          s.pfn = page_to_pfn(sg_page(s.sgp));
> +               }

Otherwise has this been tested or alternatively how to test it? (How to 
repro the issue.)

Regards,

Tvrtko
