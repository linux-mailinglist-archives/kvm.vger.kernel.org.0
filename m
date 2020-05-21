Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63AF1DCED3
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 16:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgEUOBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 10:01:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4835 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729460AbgEUOBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 10:01:04 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B5FDEB054420817EE0C8;
        Thu, 21 May 2020 22:01:02 +0800 (CST)
Received: from [10.173.222.27] (10.173.222.27) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 21 May 2020 22:00:54 +0800
Subject: Re: [kvm-unit-tests PATCH 1/6] arm64: microbench: get correct ipi
 recieved num
To:     Jingyi Wang <wangjingyi11@huawei.com>, <drjones@redhat.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <eric.auger@redhat.com>
References: <20200517100900.30792-1-wangjingyi11@huawei.com>
 <20200517100900.30792-2-wangjingyi11@huawei.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8e011659-4e4d-7312-4466-5ed3ea54cc9b@huawei.com>
Date:   Thu, 21 May 2020 22:00:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200517100900.30792-2-wangjingyi11@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/17 18:08, Jingyi Wang wrote:
> If ipi_exec() fails because of timeout, we shouldn't increase
> the number of ipi received.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>   arm/micro-bench.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 4612f41..ca022d9 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -103,7 +103,9 @@ static void ipi_exec(void)
>   	while (!ipi_received && tries--)
>   		cpu_relax();
>   
> -	++received;
> +	if (ipi_recieved)

I think you may want *ipi_received* ;-) Otherwise it can not even
compile!

> +		++received;
> +
>   	assert_msg(ipi_received, "failed to receive IPI in time, but received %d successfully\n", received);
>   }

With this fixed, this looks good to me,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks.
