Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2AB4CADE3
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbiCBStO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237825AbiCBStN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:49:13 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF2A2C1;
        Wed,  2 Mar 2022 10:48:28 -0800 (PST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K83695jbNz67Ywb;
        Thu,  3 Mar 2022 02:48:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 2 Mar 2022 19:48:25 +0100
Received: from [10.47.84.129] (10.47.84.129) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 2 Mar
 2022 18:48:25 +0000
Message-ID: <6e3bcece-1046-0c2f-78d8-21d5030a8d71@huawei.com>
Date:   Wed, 2 Mar 2022 18:48:24 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v7 01/10] crypto: hisilicon/qm: Move the QM header to
 include/linux
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-2-shameerali.kolothum.thodi@huawei.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220302172903.1995-2-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.84.129]
X-ClientProxiedBy: lhreml739-chm.china.huawei.com (10.201.108.189) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/2022 17:28, Shameer Kolothum wrote:
> Since we are going to introduce VFIO PCI HiSilicon ACC
> driver for live migration in subsequent patches, move
> the ACC QM header file to a common include dir.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>   drivers/crypto/hisilicon/hpre/hpre.h                         | 2 +-
>   drivers/crypto/hisilicon/qm.c                                | 2 +-
>   drivers/crypto/hisilicon/sec2/sec.h                          | 2 +-
>   drivers/crypto/hisilicon/sgl.c                               | 2 +-
>   drivers/crypto/hisilicon/zip/zip.h                           | 2 +-
>   drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h | 0

include/linux/crypto seems a better location. I'm not sure if someone 
suggested a location already, though.

>   6 files changed, 5 insertions(+), 5 deletions(-)
>   rename drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h (100%)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
> index e0b4a1982ee9..9a0558ed82f9 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre.h
> +++ b/drivers/crypto/hisilicon/hpre/hpre.h
> @@ -4,7 +4,7 @@
>   #define __HISI_HPRE_H
>   
>   #include <linux/list.h>
> -#include "../qm.h"
> +#include <linux/hisi_acc_qm.h>
>   
>   #define HPRE_SQE_SIZE			sizeof(struct hpre_sqe)
>   #define HPRE_PF_DEF_Q_NUM		64
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index c5b84a5ea350..ed23e1d3fa27 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -15,7 +15,7 @@
>   #include <linux/uacce.h>
>   #include <linux/uaccess.h>
>   #include <uapi/misc/uacce/hisi_qm.h>
> -#include "qm.h"
> +#include <linux/hisi_acc_qm.h>
>   
>   /* eq/aeq irq enable */
>   #define QM_VF_AEQ_INT_SOURCE		0x0
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> index d97cf02b1df7..c2e9b01187a7 100644
> --- a/drivers/crypto/hisilicon/sec2/sec.h
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -4,7 +4,7 @@
>   #ifndef __HISI_SEC_V2_H
>   #define __HISI_SEC_V2_H
>   
> -#include "../qm.h"
> +#include <linux/hisi_acc_qm.h>
>   #include "sec_crypto.h"
>   
>   /* Algorithm resource per hardware SEC queue */
> diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
> index 057273769f26..534687401135 100644
> --- a/drivers/crypto/hisilicon/sgl.c
> +++ b/drivers/crypto/hisilicon/sgl.c
> @@ -3,7 +3,7 @@
>   #include <linux/dma-mapping.h>
>   #include <linux/module.h>
>   #include <linux/slab.h>
> -#include "qm.h"
> +#include <linux/hisi_acc_qm.h>

alphabetic ordering (ignoring previous point)?

>   
>   #define HISI_ACC_SGL_SGE_NR_MIN		1
>   #define HISI_ACC_SGL_NR_MAX		256
> diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
> index 517fdbdff3ea..3dfd3bac5a33 100644
> --- a/drivers/crypto/hisilicon/zip/zip.h
> +++ b/drivers/crypto/hisilicon/zip/zip.h
> @@ -7,7 +7,7 @@
>   #define pr_fmt(fmt)	"hisi_zip: " fmt
>   
>   #include <linux/list.h>
> -#include "../qm.h"
> +#include <linux/hisi_acc_qm.h>
>   
>   enum hisi_zip_error_type {
>   	/* negative compression */
> diff --git a/drivers/crypto/hisilicon/qm.h b/include/linux/hisi_acc_qm.h
> similarity index 100%
> rename from drivers/crypto/hisilicon/qm.h
> rename to include/linux/hisi_acc_qm.h

