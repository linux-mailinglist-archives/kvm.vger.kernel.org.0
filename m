Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA646F1B34
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 17:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346259AbjD1PLZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 28 Apr 2023 11:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346252AbjD1PLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 11:11:23 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F001993;
        Fri, 28 Apr 2023 08:11:21 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Q7GFH24VQz6J6v0;
        Fri, 28 Apr 2023 23:08:03 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 16:11:17 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Fri, 28 Apr 2023 16:11:17 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v10 00/22] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v10 00/22] Add vfio_device cdev for iommufd support
Thread-Index: AQHZeFBNpioWjL263kGpOppFOucUXK9AZoUAgABvCNA=
Date:   Fri, 28 Apr 2023 15:11:17 +0000
Message-ID: <be7a00e1bc5e4ed18382ad78cdebb085@huawei.com>
References: <20230426150321.454465-1-yi.l.liu@intel.com>
 <MW4PR11MB67633DB179D9DD03E0C3F680E86B9@MW4PR11MB6763.namprd11.prod.outlook.com>
In-Reply-To: <MW4PR11MB67633DB179D9DD03E0C3F680E86B9@MW4PR11MB6763.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.171.238]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jiang, Yanting [mailto:yanting.jiang@intel.com]
> Sent: 28 April 2023 10:30
> To: Liu, Yi L <yi.l.liu@intel.com>; alex.williamson@redhat.com;
> jgg@nvidia.com; Tian, Kevin <kevin.tian@intel.com>
> Cc: joro@8bytes.org; robin.murphy@arm.com; cohuck@redhat.com;
> eric.auger@redhat.com; nicolinc@nvidia.com; kvm@vger.kernel.org;
> mjrosato@linux.ibm.com; chao.p.peng@linux.intel.com;
> yi.y.sun@linux.intel.com; peterx@redhat.com; jasowang@redhat.com;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> lulu@redhat.com; suravee.suthikulpanit@amd.com;
> intel-gvt-dev@lists.freedesktop.org; intel-gfx@lists.freedesktop.org;
> linux-s390@vger.kernel.org; Hao, Xudong <xudong.hao@intel.com>; Zhao,
> Yan Y <yan.y.zhao@intel.com>; Xu, Terrence <terrence.xu@intel.com>; Duan,
> Zhenzhong <zhenzhong.duan@intel.com>
> Subject: RE: [PATCH v10 00/22] Add vfio_device cdev for iommufd support
> 
> > Subject: [PATCH v10 00/22] Add vfio_device cdev for iommufd support
> >
> > Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens
> > the /dev/vfio/$group_id first before getting device fd and hence getting
> access
> > to device. This is not the desired model for iommufd. Per the conclusion of
> > community discussion[1], iommufd provides device-centric kAPIs and
> requires its
> > consumer (like VFIO) to be device-centric user APIs. Such user APIs are
> used to
> > associate device with iommufd and also the I/O address spaces managed
> by the
> > iommufd.
> >
> > This series first introduces a per device file structure to be prepared for
> further
> > enhancement and refactors the kvm-vfio code to be prepared for accepting
> > device file from userspace. After this, adds a mechanism for blocking
> device
> > access before iommufd bind. Then refactors the vfio to be able to handle
> cdev
> > path (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> > This refactor includes making the device_open exclusive between the
> group and
> > the cdev path, only allow single device open in cdev path; vfio-iommufd
> code is
> > also refactored to support cdev. e.g. split the vfio_iommufd_bind() into two
> > steps. Eventually, adds the cdev support for vfio device and the new ioctls,
> then
> > makes group infrastructure optional as it is not needed when vfio device
> cdev is
> > compiled.
> >
> > This series is based on some preparation works done to vfio emulated
> devices[2]
> > and vfio pci hot reset enhancements[3].
> >
> > This series is a prerequisite for iommu nesting for vfio device[4] [5].
> >
> > The complete code can be found in below branch, simple tests done to the
> > legacy group path and the cdev path. Draft QEMU branch can be found
> at[6]
> > However, the noiommu mode test is only done with some hacks in kernel
> and
> > qemu to check if qemu can boot with noiommu devices.
> >
> > https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v10
> > (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)
> >
> > base-commit: c3822365940319ad86487cc1daf6f1a4c271191e
> > (based on Alex's next branch and merged the vfio_mdev_ops branch from
> > Jason's repo)
> >
> 
> Tested NIC passthrough on Intel platform.
> Result looks good hence,
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>

Likewise, tested on HiSilicon D06(ARM64) platform with a NIC pass-through device
and looks fine.

FWIW,

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer


 

