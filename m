Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E300356C79
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352360AbhDGMqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:46:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16017 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbhDGMqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 08:46:05 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FFkZh1WMHzPmKK;
        Wed,  7 Apr 2021 20:43:08 +0800 (CST)
Received: from [10.174.178.48] (10.174.178.48) by smtp.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Wed, 7 Apr 2021
 20:45:45 +0800
Subject: Re: [PATCH -next] s390/protvirt: fix error return code in
 uv_info_init()
To:     zhongbaisong <zhongbaisong@huawei.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
CC:     <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <2f7d62a4-3e75-b2b4-951b-75ef8ef59d16@huawei.com>
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
Message-ID: <a6732d77-6c15-8851-f271-bc6fec8984bb@huawei.com>
Date:   Wed, 7 Apr 2021 20:45:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2f7d62a4-3e75-b2b4-951b-75ef8ef59d16@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.48]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

格式不对，不要用outlook发

在 2021/4/7 20:38, zhongbaisong 写道:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
> ---
>  arch/s390/kernel/uv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index cbfbeab57c3b..370f664580af 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -460,8 +460,10 @@ static int __init uv_info_init(void)
>          goto out_kobj;
>
>      uv_query_kset = kset_create_and_add("query", NULL, uv_kobj);
> -    if (!uv_query_kset)
> +    if (!uv_query_kset) {
> +        rc = -ENOMEM;
>          goto out_ind_files;
> +    }
>
>      rc = sysfs_create_group(&uv_query_kset->kobj, &uv_query_attr_group);
>      if (!rc)
>
