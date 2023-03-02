Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439FE6A7E2E
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 10:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCBJnI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 2 Mar 2023 04:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCBJnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 04:43:06 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF319EE6;
        Thu,  2 Mar 2023 01:43:03 -0800 (PST)
Received: from lhrpeml100002.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PS5kJ48fpz689Rs;
        Thu,  2 Mar 2023 17:42:48 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100002.china.huawei.com (7.191.160.241) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 09:43:00 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.021;
 Thu, 2 Mar 2023 09:43:00 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Index: AQHZSpxHUh/YYv3qukeFp+lKFtoCf67jLB2AgACBDoCAAOlEAIAAn5IAgAIKi/A=
Date:   Thu, 2 Mar 2023 09:43:00 +0000
Message-ID: <b7c1f9d5b4b647f0b0686c3b99f3d006@huawei.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
 <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <SA1PR11MB5873479F73CFBAA170717624F0AC9@SA1PR11MB5873.namprd11.prod.outlook.com>
 <Y/64ejbhMiV77uUA@Asurada-Nvidia>
In-Reply-To: <Y/64ejbhMiV77uUA@Asurada-Nvidia>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: Nicolin Chen [mailto:nicolinc@nvidia.com]
> Sent: 01 March 2023 02:29
> To: Xu, Terrence <terrence.xu@intel.com>
> Cc: Liu, Yi L <yi.l.liu@intel.com>; Jason Gunthorpe <jgg@nvidia.com>;
> alex.williamson@redhat.com; Tian, Kevin <kevin.tian@intel.com>;
> joro@8bytes.org; robin.murphy@arm.com; cohuck@redhat.com;
> eric.auger@redhat.com; kvm@vger.kernel.org; mjrosato@linux.ibm.com;
> chao.p.peng@linux.intel.com; yi.y.sun@linux.intel.com; peterx@redhat.com;
> jasowang@redhat.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; lulu@redhat.com;
> suravee.suthikulpanit@amd.com; intel-gvt-dev@lists.freedesktop.org;
> intel-gfx@lists.freedesktop.org; linux-s390@vger.kernel.org; Hao, Xudong
> <xudong.hao@intel.com>; Zhao, Yan Y <yan.y.zhao@intel.com>
> Subject: Re: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
> 
> On Tue, Feb 28, 2023 at 04:58:06PM +0000, Xu, Terrence wrote:
> 
> > Verified this series by "Intel GVT-g GPU device mediated passthrough" and
> "Intel GVT-d GPU device direct passthrough" technologies.
> > Both passed VFIO legacy mode / compat mode / cdev mode, including
> negative tests.
> >
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> 
> Sanity-tested this series on ARM64 with my wip branch:
> https://github.com/nicolinc/iommufd/commits/wip/iommufd-v6.2-nesting
> (Covering new iommufd and vfio-compat)

Hi Nicolin,

Thanks for the latest ARM64 branch. Do you have a working Qemu branch corresponding to the
above one?

I tried the https://github.com/nicolinc/qemu/tree/wip/iommufd_rfcv3%2Bnesting%2Bsmmuv3
but for some reason not able to launch the Guest.

Please let me know.

Thanks,
Shameer
