Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DF81AB6C4
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 06:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404026AbgDPEZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 00:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403916AbgDPEZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 00:25:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29927C061A0F
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 21:25:48 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y12so908796pll.2
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 21:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rKdwxJq97I01y7ryQhSihbE5DvwLxtqugoVKkJX3ixQ=;
        b=wydQ1wV/OhVMd3QRFRKKNzkbsnXsrk7VwwEFQLbqM5ghK2myZ3rUwtN43+86ag5Yt2
         TOVAOmy3v83wlL5xBTadZIUPf+hW0tBsAuWepalWfrbGXhvYreeXUsNypMLEaIpgpwvr
         PdXGZjbSqpgXelubvmrELN3048hxl5mUCg3NnN2b4krIxxmP0EodZKg13/EFYF9wHYZu
         th6OcVEd1GYkAlpaK0/CDS+PavGH/YJhb9gM6FMd2Hn30UAhBpPttl/yVOnQckXFs1+9
         ByjKBlDgOAaMd4fSyIWUuB3lXPe1GalgZBYhX0Jk2ev8iAwwfXtj7rBzBsG2jmmx/old
         tBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rKdwxJq97I01y7ryQhSihbE5DvwLxtqugoVKkJX3ixQ=;
        b=AA8jFgVfEbglRBslyAqZVkEsnnosYlUrLsNeSFInSFtZXUAEzqAhRZZ12CqFQ2wuAb
         BuDW+fOGQvE+J/hs8a5YldANzcRd+pPwXulAwwPjPr0OkT2Ij4LXLf8QnjVm4vtNeOuu
         jvGJ52frpLjQfAXheqVya2q6GZRrgGwbMCh8NtZzOO4m7dcdgI12qi4XESHGqBkSUTC0
         0p2MNzIaRQFFI2nFgxfJ/h/oKKB1EGZXbKqPLmrYvaAYGHUt0KxBpMgRnkRZg4y4S2gc
         nJEIYu0gD7Y8xLIt9K5YhRCUm46Wj/XDyu2HEDCg/mlS3p+cLFC4KJkPCxD9N4kb7Hki
         8NSQ==
X-Gm-Message-State: AGi0PuaPkx72C3oJnwDqm7HhLGxC4PhM2tCYN+57cpnxlXZJOq9FLCOB
        a9+/5NZrHZO1FyvcuiBNb0Pt2A==
X-Google-Smtp-Source: APiQypIcBT/ktZ74DASZLCa7QPuT/QUI+4S8qRnrlE/V9pcUl97OuPwTBQpFJ7Cl/s+5dnZ05jLWvw==
X-Received: by 2002:a17:90b:3547:: with SMTP id lt7mr2650982pjb.96.1587011147553;
        Wed, 15 Apr 2020 21:25:47 -0700 (PDT)
Received: from [10.129.0.126] ([45.135.186.84])
        by smtp.gmail.com with ESMTPSA id e29sm10568241pgn.57.2020.04.15.21.25.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 21:25:47 -0700 (PDT)
Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     jean-philippe@linaro.org, shameerali.kolothum.thodi@huawei.com,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, peter.maydell@linaro.org, tn@semihalf.com,
        bbhushan2@marvell.com
References: <20200414150607.28488-1-eric.auger@redhat.com>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
Date:   Thu, 16 Apr 2020 12:25:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/14 下午11:05, Eric Auger wrote:
> This version fixes an issue observed by Shameer on an SMMU 3.2,
> when moving from dual stage config to stage 1 only config.
> The 2 high 64b of the STE now get reset. Otherwise, leaving the
> S2TTB set may cause a C_BAD_STE error.
>
> This series can be found at:
> https://github.com/eauger/linux/tree/v5.6-2stage-v11_10.1
> (including the VFIO part)
> The QEMU fellow series still can be found at:
> https://github.com/eauger/qemu/tree/v4.2.0-2stage-rfcv6
>
> Users have expressed interest in that work and tested v9/v10:
> - https://patchwork.kernel.org/cover/11039995/#23012381
> - https://patchwork.kernel.org/cover/11039995/#23197235
>
> Background:
>
> This series brings the IOMMU part of HW nested paging support
> in the SMMUv3. The VFIO part is submitted separately.
>
> The IOMMU API is extended to support 2 new API functionalities:
> 1) pass the guest stage 1 configuration
> 2) pass stage 1 MSI bindings
>
> Then those capabilities gets implemented in the SMMUv3 driver.
>
> The virtualizer passes information through the VFIO user API
> which cascades them to the iommu subsystem. This allows the guest
> to own stage 1 tables and context descriptors (so-called PASID
> table) while the host owns stage 2 tables and main configuration
> structures (STE).
>
>

Thanks Eric

Tested v11 on Hisilicon kunpeng920 board via hardware zip accelerator.
1. no-sva works, where guest app directly use physical address via ioctl.
2. vSVA still not work, same as v10,
3.  the v10 issue reported by Shameer has been solved,  first start qemu 
with  iommu=smmuv3, then start qemu without  iommu=smmuv3
4. no-sva also works without  iommu=smmuv3

Test details in https://docs.qq.com/doc/DRU5oR1NtUERseFNL

Thanks
