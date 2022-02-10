Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952F04B114B
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243329AbiBJPHn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Feb 2022 10:07:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiBJPHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 10:07:43 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637181A2;
        Thu, 10 Feb 2022 07:07:43 -0800 (PST)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jvg80084yz67MkT;
        Thu, 10 Feb 2022 23:06:56 +0800 (CST)
Received: from lhreml714-chm.china.huawei.com (10.201.108.65) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 10 Feb 2022 16:07:40 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 15:07:40 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Thu, 10 Feb 2022 15:07:40 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYHPDyAsbl+xVOv0mWAZg3hAhxZqyL5CAAgAEAYUA=
Date:   Thu, 10 Feb 2022 15:07:40 +0000
Message-ID: <e739f0cef853428e9d72ebc6e3c52187@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
        <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
 <20220209164440.0d77284c.alex.williamson@redhat.com>
In-Reply-To: <20220209164440.0d77284c.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.92.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: 09 February 2022 23:45
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; jgg@nvidia.com; cohuck@redhat.com;
> mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Tue, 8 Feb 2022 13:34:24 +0000
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> > +
> > +static struct hisi_acc_vf_migration_file *
> > +hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> > +{
> > +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> > +	struct device *dev = &hisi_acc_vdev->vf_dev->dev;
> > +	struct hisi_acc_vf_migration_file *migf;
> > +	int ret;
> > +
> > +	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
> > +		dev_info(dev, "QM device not ready, no data to transfer\n");
> > +		return 0;
> > +	}
> 
> This return value looks suspicious and I think would cause a segfault
> in the calling code:

Ah..Right!. I think I can move the above to the vf_qm_state_save()
and use migf->total_length to handle this.

Thanks,
Shameer
 

