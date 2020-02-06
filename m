Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C27154648
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgBFOfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:35:15 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726765AbgBFOfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:35:15 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D4F307895B7640D4A8E2;
        Thu,  6 Feb 2020 22:35:08 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Feb 2020
 22:35:02 +0800
Subject: Re: [kvm-unit-tests PATCH v3 04/14] arm/arm64: gicv3: Add some
 re-distributor defines
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>
CC:     <drjones@redhat.com>, <andre.przywara@arm.com>,
        <peter.maydell@linaro.org>, <alexandru.elisei@arm.com>,
        <thuth@redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-5-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <22a3b0f5-febd-f9e0-4404-7b01643e57b1@huawei.com>
Date:   Thu, 6 Feb 2020 22:35:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200128103459.19413-5-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/1/28 18:34, Eric Auger wrote:
> PROPBASER, PENDBASE and GICR_CTRL will be used for LPI management.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>   lib/arm/asm/gic-v3.h | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 6beeab6..ffb2e26 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -18,6 +18,7 @@
>    * We expect to be run in Non-secure mode, thus we define the
>    * group1 enable bits with respect to that view.
>    */
> +#define GICD_CTLR			0x0000
>   #define GICD_CTLR_RWP			(1U << 31)
>   #define GICD_CTLR_ARE_NS		(1U << 4)
>   #define GICD_CTLR_ENABLE_G1A		(1U << 1)
> @@ -36,6 +37,11 @@
>   #define GICR_ICENABLER0			GICD_ICENABLER
>   #define GICR_IPRIORITYR0		GICD_IPRIORITYR
>   
> +#define GICR_PROPBASER                  0x0070
> +#define GICR_PENDBASER                  0x0078

nit: we'd better use tab instead of space.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

> +#define GICR_CTLR			GICD_CTLR
> +#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
> +
>   #define ICC_SGI1R_AFFINITY_1_SHIFT	16
>   #define ICC_SGI1R_AFFINITY_2_SHIFT	32
>   #define ICC_SGI1R_AFFINITY_3_SHIFT	48
> 

