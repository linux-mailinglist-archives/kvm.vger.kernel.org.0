Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5D518C7F5
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 08:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgCTHGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 03:06:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:51858 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgCTHGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 03:06:38 -0400
IronPort-SDR: /5RtDVa0fYimAIkILgAmXLIfuYv+MFFR4M6jlQ+8+VBUrSF1TeQEqKe72sp7jkBrTpzO0mTS9D
 MbZWMivTYT3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 00:06:37 -0700
IronPort-SDR: qQTFLsdf6C7DljdvIuIQN6Y1afZcxjIFlDqm5oREhf3SQKLv3Q8zMsPRwvvsQ2xfMB1iJdT5ye
 7yUiw7Egm94Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="356328149"
Received: from sxu27-mobl2.ccr.corp.intel.com (HELO [10.254.214.109]) ([10.254.214.109])
  by fmsmga001.fm.intel.com with ESMTP; 20 Mar 2020 00:06:26 -0700
Cc:     baolu.lu@linux.intel.com,
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
        Marc Zyngier <maz@kernel.org>,
        Julien Grall <julien.grall@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/8] iommu/vt-d: Remove IOVA handling code from
 non-dma_ops path
To:     Tom Murphy <murphyt7@tcd.ie>, iommu@lists.linux-foundation.org
References: <20191221150402.13868-1-murphyt7@tcd.ie>
 <20191221150402.13868-4-murphyt7@tcd.ie>
 <CALQxJuuue2MCF+xAAAcWCW=301HHZ9yWBmYV-K-ubCxO4s5eqQ@mail.gmail.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <46bf21e2-bb3e-1c1e-8dae-2c5bd8c5274f@linux.intel.com>
Date:   Fri, 20 Mar 2020 15:06:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALQxJuuue2MCF+xAAAcWCW=301HHZ9yWBmYV-K-ubCxO4s5eqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/20 14:30, Tom Murphy wrote:
> Could we merge patch 1-3 from this series? it just cleans up weird
> code and merging these patches will cover some of the work needed to
> move the intel iommu driver to the dma-iommu api in the future.

Can you please take a look at this patch series?

https://lkml.org/lkml/2020/3/13/1162

It probably makes this series easier.

Best regards,
baolu

> 
> On Sat, 21 Dec 2019 at 07:04, Tom Murphy<murphyt7@tcd.ie>  wrote:
>> Remove all IOVA handling code from the non-dma_ops path in the intel
>> iommu driver.
>>
>> There's no need for the non-dma_ops path to keep track of IOVAs. The
>> whole point of the non-dma_ops path is that it allows the IOVAs to be
>> handled separately. The IOVA handling code removed in this patch is
>> pointless.
>>
>> Signed-off-by: Tom Murphy<murphyt7@tcd.ie>
