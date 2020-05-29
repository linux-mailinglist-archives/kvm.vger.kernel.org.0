Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFAA1E89AE
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 23:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgE2VL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 17:11:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37432 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbgE2VLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 17:11:55 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200529211152euoutp02ae3b517eb5fe4ae0e036cdedab0df92f~TnBZEd7Ue2875928759euoutp02v;
        Fri, 29 May 2020 21:11:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200529211152euoutp02ae3b517eb5fe4ae0e036cdedab0df92f~TnBZEd7Ue2875928759euoutp02v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590786712;
        bh=dvY+FiUsAiJnTxLNORQDyXbiOs6V4mCD33FUXV5Ad88=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Ozzupd1ctUphYt3GU2BT13dlis6OagTDMd4G49JEHhF3W3TRB1/uwLOPQxCwwOQzt
         3tyvdbBpNWH2VHEYRrlMa5Z9Atzv6PRWiKMQJ7tOO7QTfV4gghTsiQoVGqHenbz6+x
         GHn7sbuI6nh0x46MVxuWsGrNSwfb4yzK3v1qW0b0=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200529211152eucas1p24a7256775766c6fb0b55d9d24858f1d2~TnBYp0imp1322213222eucas1p2Q;
        Fri, 29 May 2020 21:11:52 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 60.64.61286.89A71DE5; Fri, 29
        May 2020 22:11:52 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200529211151eucas1p1de3ce652a119f37c714b741aa5e3525f~TnBYAWsMn1592015920eucas1p14;
        Fri, 29 May 2020 21:11:51 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200529211151eusmtrp28aaacc47cb6378c7d91e19ecfae46848~TnBX-O7F50926509265eusmtrp2Q;
        Fri, 29 May 2020 21:11:51 +0000 (GMT)
X-AuditID: cbfec7f2-f0bff7000001ef66-3b-5ed17a981e36
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 9A.AA.07950.79A71DE5; Fri, 29
        May 2020 22:11:51 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200529211149eusmtip2b6bf63acde89c62ed24f4ddf485421f9~TnBWRY2ve2357023570eusmtip2o;
        Fri, 29 May 2020 21:11:49 +0000 (GMT)
Subject: Re: [PATCH 0/8] Convert the intel iommu driver to the dma-iommu api
To:     Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@infradead.org>
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
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <ef2150d5-7b6a-df25-c10d-e43316fe7812@samsung.com>
Date:   Fri, 29 May 2020 23:11:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <33137cfb-603c-86e8-1091-f36117ecfaf3@deltatee.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA02TbUxTZxiG856vnnYrOT0wecUlc000kWwi0S3PdDG4ze2YLcu2xD8uolWP
        YATUVhg4khGKMDvQg87JDk35kAhzTLBVtARaYZlN09GWDwkjLKgwBBxFEE1ARwc9svHvvu/3
        evI894+XJfkpJo49lHFcNGYY0vSMhmq6PRt4s+xEZ/KGiulo8A89o6DE7yXgabiYAZ87RIEU
        HEfQ82SSgdKfzpHg/Ht04UGqJqBcchBQ6d4Ctd0NCPJ+DtJQIFdT0FpFQGHlp3Bm6CEJgUCj
        Cqznj4F9qJeGUneHCrqbrQx0mzsRTN8NkyBVmUkoC7gIODUjM1Bz0sNAfsFGcFq9NMxLszS0
        PRqmwS33qsBhP0/CbLONgtoOGwMFA28lrRHqbfVIaLvfzggjd0aQ4JT/VAmOunjhYssYIdgv
        n2KEgd4WRgj5/SrhxtO7tGDzfi4MfuchBEfNN8K5vloklJhDjDDpusN8xu/SvHtATDuUJRoT
        tu7VpF7tyzkqr8oeq3dSecixwoLULOY24UCZnbIgDctzdQj/cb0GKWYG4Wcj9wnFPEb4d99J
        1dLIw19LX1C1CBf2V9CKmUTYVe4mF6lo7hMsBRuYRR3DfYGLJuQIRHINGuxwlUYghkvElglL
        BNJyW7G1pYha1BS3BpfM9UTyV7jduHhwnFQYHfb+OBxh1FwSbix6FGFI7jVsvl5OKjoW9w9X
        RO7GnF+Nu25OEcrdH+ALt68yio7G455rL/q8isPOpQEzwvf8v6gUU4xwd34ZUqgteMA/tzDN
        LqxYhxuaE5R4G7aVS5EYc1G4b0KnHBGFzzZdIJVYi78t5BV6LZY9V/5b2xbsIiWkl5dVk5fV
        kZfVkf/fW4moyyhWzDSlp4imxAzxq/UmQ7opMyNl/f4j6Xa08BF8857pm+hJ1752xLFI/7I2
        O74zmacNWaac9HaEWVIfo32vw5fMaw8Yck6IxiN7jJlpoqkdrWIpfax2Y/XYbp5LMRwXD4vi
        UdG49Eqw6rg8BJ3XEvi5KevKr1t/u/WSbu9F/mz+rkujb+Tyde8HNJwh+FHo+6z9ufT2bRr5
        sKyL2fd49bGQvXXet32n9PaHJer+PfaqKw9Q4+jmhKhbuntyn7g6O3XHx68/z/lyMK6pZ+h5
        eAfJ/PDX5hbrTKL34Hz4NFiicu2h7KTUf95RuW5k6SlTqiExnjSaDP8CU3RiiAQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTdxjG8z+3FmK3s4L6HyNezsI+eKkeSu2LY4wsITkmc5ljydywaKNH
        MNLW9RQj8IFGEGYV10Zx85RVQAcTiGLrZTVMQh0jDeEWkBCjyAYhQ1dEFBS3yEq7JXx78jy/
        34c3eZWk+iiToDxgtolWszGfY2KprtedIxu/K+rP2Xyn/D3oGfubgsqeIAFzCycZ6GqbosDZ
        9wjB4OwTBlyXTpPg/+vP8OCsI8Dt9BFQ0/Y+NAxcQWBv6qOhTK6j4JdaAsprPoFvxx6T0Nvb
        ooDqqq/BOzZEg6utWwEDt6oZGCjtRzAzukCCs7aUhO97bxNw/LnMwMVjnQwcLdOCvzpIw2vn
        PA3t0+M0tMlDCvB5q0iYv+WhoKHbw0DZfV1GktDsaUZC+x8BRpi4O4EEv/xAIfh+WidcaJ0k
        BG/jcUa4P9TKCFM9PQrh5twoLXiCO4SHJzoJwXexRDg93ICEytIpRnhy+y7zqforTZrVUmAT
        1+RZJNsHXDYPyRo+FTTJKakaXqs3bE3WcZvS0/aJ+QcOi9ZN6Xs0eVeHCw/J7xyZbPZTduRb
        4UAxSsym4Md3XGgxq9kfEZ5zvR3tE3HwrJ2O5jj8z5CDcaDYMBNCeMQdigxx7MfY2XeFWczx
        7GfYfipELkIk64vFp37tUESNHwg8K1+mFimG5bEj5IgYKjYdV7dWRHqKTcKVrwYj/XLWgE9c
        eKmIMm/h4LnxCBPDZuCWiukIQ7JbsMf3OxnNq3Hpdfd/eSW+N36ecCK1vESXlyjyEkVeotQg
        qhHFiwWSKdckJWsko0kqMOdq9lpMXhT+vxu/zV/7GTmmsgKIVSJumapvQ3+OmjYelgpNAYSV
        JBev+qi7K0et2mcsLBKtlt3WgnxRCiBd+DgXmbB8ryX8zWbbbl7H6yGV12v12i3ArVR9w7bv
        UrO5Rpt4UBQPidb/PUIZk2BHJdPZj65x5cV09oqsxHtkZkW9gaoY3u4dHXzWqJ9Jyzwz00qn
        dn1Yp880xG131593F43tedM/8YU2v9G4jHtj9ez+L7PSqnSrSjJDa+MN765fe2xNYrFpmyOl
        /fPacxtqzAv8joaOI2cvF7Y0BewpGahjcv/GkRc7XXMvimkvm/SUo6Q8I7+OtErGfwHumZIe
        lQMAAA==
X-CMS-MailID: 20200529211151eucas1p1de3ce652a119f37c714b741aa5e3525f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200529190523eucas1p2c086133e707257c0cdc002f502d4f51d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200529190523eucas1p2c086133e707257c0cdc002f502d4f51d
References: <20191221150402.13868-1-murphyt7@tcd.ie>
        <465815ae-9292-f37a-59b9-03949cb68460@deltatee.com>
        <20200529124523.GA11817@infradead.org>
        <CGME20200529190523eucas1p2c086133e707257c0cdc002f502d4f51d@eucas1p2.samsung.com>
        <33137cfb-603c-86e8-1091-f36117ecfaf3@deltatee.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Logan,

On 29.05.2020 21:05, Logan Gunthorpe wrote:
> On 2020-05-29 6:45 a.m., Christoph Hellwig wrote:
>> On Thu, May 28, 2020 at 06:00:44PM -0600, Logan Gunthorpe wrote:
>>>> This issue is most likely in the i915 driver and is most likely caused by the driver not respecting the return value of the dma_map_ops::map_sg function. You can see the driver ignoring the return value here:
>>>> https://protect2.fireeye.com/url?k=ca25a34b-97f7b813-ca242804-0cc47a31c8b4-0ecdffc9f56851e1&q=1&u=https%3A%2F%2Fgithub.com%2Ftorvalds%2Flinux%2Fblob%2F7e0165b2f1a912a06e381e91f0f4e495f4ac3736%2Fdrivers%2Fgpu%2Fdrm%2Fi915%2Fgem%2Fi915_gem_dmabuf.c%23L51
>>>>
>>>> Previously this didn’t cause issues because the intel map_sg always returned the same number of elements as the input scatter gather list but with the change to this dma-iommu api this is no longer the case. I wasn’t able to track the bug down to a specific line of code unfortunately.
>> Mark did a big audit into the map_sg API abuse and initially had
>> some i915 patches, but then gave up on them with this comment:
>>
>> "The biggest TODO is DRM/i915 driver and I don't feel brave enough to fix
>>   it fully. The driver creatively uses sg_table->orig_nents to store the
>>   size of the allocate scatterlist and ignores the number of the entries
>>   returned by dma_map_sg function. In this patchset I only fixed the
>>   sg_table objects exported by dmabuf related functions. I hope that I
>>   didn't break anything there."
>>
>> it would be really nice if the i915 maintainers could help with sorting
>> that API abuse out.
>>
> I agree completely that the API abuse should be sorted out, but I think
> that's much larger than just the i915 driver. Pretty much every dma-buf
> map_dma_buf implementation I looked at ignores the returned nents of
> sg_attrs. This sucks, but I don't think it's the bug Tom ran into. See:
>
> amdgpu_dma_buf_map
> armada_gem_prime_map_dma_buf
> drm_gem_map_dma_buf
> i915_gem_map_dma_buf
> tegra_gem_prime_map_dma_buf
>
> So this should probably be addressed by the whole GPU community.

Patches are pending:
https://lore.kernel.org/linux-iommu/20200513132114.6046-1-m.szyprowski@samsung.com/T/

> However, as Robin pointed out, there are other ugly tricks like stopping
> iterating through the SGL when sg_dma_len() is zero. For example, the
> AMD driver appears to use drm_prime_sg_to_page_addr_arrays() which does
> this trick and thus likely isn't buggy (otherwise, I'd expect someone to
> have complained by now seeing AMD has already switched to IOMMU-DMA.

I'm not sure that this is a trick. Stopping at zero sg_dma_len() was 
somewhere documented.

> As I tried to point out in my previous email, i915 does not do this
> trick. In fact, it completely ignores sg_dma_len() and is thus
> completely broken. See i915_scatterlist.h and the __sgt_iter() function.
> So it doesn't sound to me like Mark's fix would address the issue at
> all. Per my previous email, I'd guess that it can be fixed simply by
> adjusting the __sgt_iter() function to do something more sensible.
> (Better yet, if possible, ditch __sgt_iter() and use the common DRM
> function that AMD uses).
>
> This would at least allow us to make progress with Tom's IOMMU-DMA patch
> set and once that gets in, it will be harder for other drivers to make
> the same mistake.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

