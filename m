Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C064CAE14
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244821AbiCBTDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244816AbiCBTDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:03:24 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B375DEE5;
        Wed,  2 Mar 2022 11:02:40 -0800 (PST)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K83QY1FMLz67LfL;
        Thu,  3 Mar 2022 03:02:29 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 20:02:37 +0100
Received: from [10.47.84.129] (10.47.84.129) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 2 Mar
 2022 19:02:36 +0000
Message-ID: <499b0d93-9352-b52f-0ee8-7dc7fd0bac5c@huawei.com>
Date:   Wed, 2 Mar 2022 19:02:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v7 04/10] hisi_acc_vfio_pci: add new vfio_pci driver for
 HiSilicon ACC devices
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-5-shameerali.kolothum.thodi@huawei.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220302172903.1995-5-shameerali.kolothum.thodi@huawei.com>
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
> +config HISI_ACC_VFIO_PCI
> +	tristate "VFIO PCI support for HiSilicon ACC devices"
> +	depends on (ARM64 && VFIO_PCI_CORE) || (COMPILE_TEST && 64BIT)

This means that we will have HISI_ACC_VFIO_PCI=y for COMPILE_TEST=y and 
64BIT=y and VFIO_PCI_CORE=n, but ...

> +	help
> +	  This provides generic PCI support for HiSilicon ACC devices
> +	  using the VFIO framework.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/hisilicon/Makefile b/drivers/vfio/pci/hisilicon/Makefile
> new file mode 100644
> index 000000000000..c66b3783f2f9
> --- /dev/null
> +++ b/drivers/vfio/pci/hisilicon/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisi-acc-vfio-pci.o
> +hisi-acc-vfio-pci-y := hisi_acc_vfio_pci.o
> +
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> new file mode 100644
> index 000000000000..8129c3457b3b
> --- /dev/null
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, HiSilicon Ltd.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/file.h>
> +#include <linux/hisi_acc_qm.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);

... there does not seem to be a stub for vfio_pci_core_finish_enable(), 
so I don't think that we compile under the conditions described. I think 
that HISI_ACC_VFIO_PCI should always depends on HISI_ACC_VFIO_PCI

> +
> +	return 0;
> +}

