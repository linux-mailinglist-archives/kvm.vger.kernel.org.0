Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E5C4D124C
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 09:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344945AbiCHIeR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 8 Mar 2022 03:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241170AbiCHIeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 03:34:16 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C06424F06;
        Tue,  8 Mar 2022 00:33:20 -0800 (PST)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KCT870WDgz67NB8;
        Tue,  8 Mar 2022 16:31:51 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:33:17 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 08:33:17 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Tue, 8 Mar 2022 08:33:17 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v8 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Topic: [PATCH v8 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Index: AQHYL1LES66RK6Gs/kmsjFJ+eUfqqKy1C2eAgAAh4CA=
Date:   Tue, 8 Mar 2022 08:33:16 +0000
Message-ID: <21c1ddd171df45bdb62220cf997e58e6@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-6-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB527681F9F6B0906596A77A178C099@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527681F9F6B0906596A77A178C099@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.27.151]
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

Hi Kevin,

> -----Original Message-----
> From: Tian, Kevin [mailto:kevin.tian@intel.com]
> Sent: 08 March 2022 06:23
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org
> Cc: linux-pci@vger.kernel.org; alex.williamson@redhat.com; jgg@nvidia.com;
> cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: RE: [PATCH v8 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
> migration region
> 
> Hi, Shameer,
> 
> > From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Sent: Friday, March 4, 2022 7:01 AM
> >
> > HiSilicon ACC VF device BAR2 region consists of both functional
> > register space and migration control register space. From a
> > security point of view, it's not advisable to export the migration
> > control region to Guest.
> >
> > Hence, introduce a separate struct vfio_device_ops for migration
> > support which will override the ioctl/read/write/mmap methods to
> > hide the migration region and limit the access only to the
> > functional register space.
> >
> > This will be used in subsequent patches when we add migration
> > support to the driver.
> 
> As a security concern the migration control region should be always
> disabled regardless of whether migration support is added to the
> driver for such device... It sounds like we should first fix this security
> hole for acc device assignment and then add the migration support
> atop (at least organize the series in this way).

By exposing the migration BAR region, there is a possibility that a malicious
Guest can prevent migration from happening by manipulating the migration
BAR region. I don't think there are any other security concerns now especially
since we only support the STOP_COPY state.  And the approach has been that
we only restrict this if migration support is enabled. I think I can change the
above "security concern" description to "malicious Guest can prevent migration"
to make it more clear.

Hope this is fine.

Thanks,
Shameer
