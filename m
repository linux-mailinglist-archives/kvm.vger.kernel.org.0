Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4014F4D0D3F
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 02:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244352AbiCHBIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 20:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiCHBIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 20:08:15 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52E331202;
        Mon,  7 Mar 2022 17:07:18 -0800 (PST)
Received: from kwepemi100018.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KCHFb25nSzdfwr;
        Tue,  8 Mar 2022 09:05:55 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 kwepemi100018.china.huawei.com (7.221.188.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:07:16 +0800
Received: from [10.67.102.118] (10.67.102.118) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:07:16 +0800
Subject: Re: [PATCH v8 1/9] crypto: hisilicon/qm: Move the QM header to
 include/linux
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-2-shameerali.kolothum.thodi@huawei.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <42d94745-c664-bd7c-7bc5-d20359669765@huawei.com>
Date:   Tue, 8 Mar 2022 09:07:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20220303230131.2103-2-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/3/4 7:01, Shameer Kolothum Wrote:
> Since we are going to introduce VFIO PCI HiSilicon ACC driver for live
> migration in subsequent patches, move the ACC QM header file to a
> common include dir.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre.h                         | 2 +-
>  drivers/crypto/hisilicon/qm.c                                | 2 +-
>  drivers/crypto/hisilicon/sec2/sec.h                          | 2 +-
>  drivers/crypto/hisilicon/sgl.c                               | 2 +-
>  drivers/crypto/hisilicon/zip/zip.h                           | 2 +-
>  drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h | 0
>  6 files changed, 5 insertions(+), 5 deletions(-)
>  rename drivers/crypto/hisilicon/qm.h => include/linux/hisi_acc_qm.h (100%)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
> index e0b4a1982ee9..9a0558ed82f9 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre.h
> +++ b/drivers/crypto/hisilicon/hpre/hpre.h
> @@ -4,7 +4,7 @@
>  #define __HISI_HPRE_H
>  
>  #include <linux/list.h>
> -#include "../qm.h"
> +#include <linux/hisi_acc_qm.h>
>  
>  #define HPRE_SQE_SIZE			sizeof(struct hpre_sqe)
>  #define HPRE_PF_DEF_Q_NUM		64
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index c5b84a5ea350..ed23e1d3fa27 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -15,7 +15,7 @@
>  #include <linux/uacce.h>
>  #include <linux/uaccess.h>
>  #include <uapi/misc/uacce/hisi_qm.h>
> -#include "qm.h"
> +#include <linux/hisi_acc_qm.h>
>  
>  /* eq/aeq irq enable */
>  #define QM_VF_AEQ_INT_SOURCE		0x0
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> index d97cf02b1df7..c2e9b01187a7 100644
> --- a/drivers/crypto/hisilicon/sec2/sec.h
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -4,7 +4,7 @@
>  #ifndef __HISI_SEC_V2_H
>  #define __HISI_SEC_V2_H
>  
> -#include "../qm.h"
> +#include <linux/hisi_acc_qm.h>
>  #include "sec_crypto.h"
>  
>  /* Algorithm resource per hardware SEC queue */
> diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
> index 057273769f26..f7efc02b065f 100644
> --- a/drivers/crypto/hisilicon/sgl.c
> +++ b/drivers/crypto/hisilicon/sgl.c
> @@ -1,9 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2019 HiSilicon Limited. */
>  #include <linux/dma-mapping.h>
> +#include <linux/hisi_acc_qm.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> -#include "qm.h"
>  
>  #define HISI_ACC_SGL_SGE_NR_MIN		1
>  #define HISI_ACC_SGL_NR_MAX		256
> diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
> index 517fdbdff3ea..3dfd3bac5a33 100644
> --- a/drivers/crypto/hisilicon/zip/zip.h
> +++ b/drivers/crypto/hisilicon/zip/zip.h
> @@ -7,7 +7,7 @@
>  #define pr_fmt(fmt)	"hisi_zip: " fmt
>  
>  #include <linux/list.h>
> -#include "../qm.h"
> +#include <linux/hisi_acc_qm.h>
>  
>  enum hisi_zip_error_type {
>  	/* negative compression */
> diff --git a/drivers/crypto/hisilicon/qm.h b/include/linux/hisi_acc_qm.h
> similarity index 100%
> rename from drivers/crypto/hisilicon/qm.h
> rename to include/linux/hisi_acc_qm.h
> 
Acked-by: Longfang Liu <liulongfang@huawei.com>

Thanks,
Longfang
