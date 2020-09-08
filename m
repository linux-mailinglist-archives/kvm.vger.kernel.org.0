Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4C8261E72
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 21:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730790AbgIHTvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 15:51:51 -0400
Received: from ale.deltatee.com ([204.191.154.188]:51884 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730192AbgIHPt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Sender:
        Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
        :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DvSiEr2JCy+2h9dy7CIecEenG2gQsa0A5OP2d9PI/p0=; b=dbg0PtMPK+HbvI6GMZzh/J5E8Z
        Q/TWc7UsDFhg1cOVJt/pysWKo3QQRWraF1mqHM6mdRGQ6y0rj+OXqZUSgbgyS5kW1MF22xpb3bm/M
        J9Rf7mpjgRlZVOcx1SZJ6EJp7lFy55R6nqk8PsS8AEsD0hf0g4vJC65mDtFEAYzf7cE0mQHAAVUlU
        S7bbDUQqTHtHsrq5f8RHYZU0yCa5rG3lpeqMLTKlNXStV+C6+vhM0UL/8Wjc5CgLnNZYF3jPybjc/
        ulyb1L7dumDVfTJQeMlSwf7IyaVvWKGWBe0b9ikUV9lDLMezAf5m+fY9DJk+AU+8aTTS01s/mCgwR
        I5zJe2Ew==;
Received: from s01060023bee90a7d.cg.shawcable.net ([24.64.145.4] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1kFfnI-0008Go-Gj; Tue, 08 Sep 2020 09:44:29 -0600
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Tom Murphy <murphyt7@tcd.ie>
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
 <60a82319-cbee-4cd1-0d5e-3c407cc51330@linux.intel.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <e598fb31-ef7a-c2ee-8a54-bf62d50c480c@deltatee.com>
Date:   Tue, 8 Sep 2020 09:44:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <60a82319-cbee-4cd1-0d5e-3c407cc51330@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 24.64.145.4
X-SA-Exim-Rcpt-To: robin.murphy@arm.com, kgene@kernel.org, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, cohuck@redhat.com, dwmw2@infradead.org, gerald.schaefer@de.ibm.com, virtualization@lists.linux-foundation.org, tglx@linutronix.de, matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org, agross@kernel.org, linux-rockchip@lists.infradead.org, hch@infradead.org, jonathanh@nvidia.com, krzk@kernel.org, maz@kernel.org, linux-samsung-soc@vger.kernel.org, jean-philippe@linaro.org, m.szyprowski@samsung.com, will@kernel.org, julien.grall@arm.com, linux-tegra@vger.kernel.org, bjorn.andersson@linaro.org, dri-devel@lists.freedesktop.org, airlied@linux.ie, kvm@vger.kernel.org, murphyt7@tcd.ie, tvrtko.ursulin@linux.intel.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [Intel-gfx] [PATCH 0/8] Convert the intel iommu driver to the
 dma-iommu api
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-09-08 9:28 a.m., Tvrtko Ursulin wrote:
>>
>> diff --git a/drivers/gpu/drm/i915/i915_scatterlist.h
>> b/drivers/gpu/drm/i915/i915
>> index b7b59328cb76..9367ac801f0c 100644
>> --- a/drivers/gpu/drm/i915/i915_scatterlist.h
>> +++ b/drivers/gpu/drm/i915/i915_scatterlist.h
>> @@ -27,13 +27,19 @@ static __always_inline struct sgt_iter {
>>   } __sgt_iter(struct scatterlist *sgl, bool dma) {
>>          struct sgt_iter s = { .sgp = sgl };
>>
>> +       if (sgl && !sg_dma_len(s.sgp))
> 
> I'd extend the condition to be, just to be safe:
>     if (dma && sgl && !sg_dma_len(s.sgp))
>

Right, good catch, that's definitely necessary.

>> +               s.sgp = NULL;
>> +
>>          if (s.sgp) {
>>                  s.max = s.curr = s.sgp->offset;
>> -               s.max += s.sgp->length;
>> -               if (dma)
>> +
>> +               if (dma) {
>> +                       s.max += sg_dma_len(s.sgp);
>>                          s.dma = sg_dma_address(s.sgp);
>> -               else
>> +               } else {
>> +                       s.max += s.sgp->length;
>>                          s.pfn = page_to_pfn(sg_page(s.sgp));
>> +               }
> 
> Otherwise has this been tested or alternatively how to test it? (How to
> repro the issue.)

It has not been tested. To test it, you need Tom's patch set without the
last "DO NOT MERGE" patch:

https://lkml.kernel.org/lkml/20200907070035.GA25114@infradead.org/T/

Thanks,

Logan
