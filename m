Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245516B0E44
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 17:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjCHQLR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 8 Mar 2023 11:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjCHQKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 11:10:41 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCEE4AFDB;
        Wed,  8 Mar 2023 08:10:36 -0800 (PST)
Received: from lhrpeml100001.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PWxh60g27z689xQ;
        Wed,  8 Mar 2023 23:54:14 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100001.china.huawei.com (7.191.160.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 15:54:45 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.021;
 Wed, 8 Mar 2023 15:54:45 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "Xu, Terrence" <terrence.xu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
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
Thread-Index: AQHZSpxHUh/YYv3qukeFp+lKFtoCf67jLB2AgACBDoCAAOlEAIAAn5IAgAIKi/CAAO3wAIAA+kPAgAEQJQCABt1mAA==
Date:   Wed, 8 Mar 2023 15:54:45 +0000
Message-ID: <5152227cbe0e4bdcacf0763f1af16e8f@huawei.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
 <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <SA1PR11MB5873479F73CFBAA170717624F0AC9@SA1PR11MB5873.namprd11.prod.outlook.com>
 <Y/64ejbhMiV77uUA@Asurada-Nvidia>
 <b7c1f9d5b4b647f0b0686c3b99f3d006@huawei.com>
 <ZAE2J0I1LiBjWUnm@Asurada-Nvidia>
 <d59a0262d5bf423c9e49ad4ac6015296@huawei.com>
 <ZALspPvvLGFuK96F@Asurada-Nvidia>
In-Reply-To: <ZALspPvvLGFuK96F@Asurada-Nvidia>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Nicolin Chen [mailto:nicolinc@nvidia.com]
> Sent: 04 March 2023 07:01
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Xu, Terrence <terrence.xu@intel.com>; Liu, Yi L <yi.l.liu@intel.com>;
> Jason Gunthorpe <jgg@nvidia.com>; alex.williamson@redhat.com; Tian,
> Kevin <kevin.tian@intel.com>; joro@8bytes.org; robin.murphy@arm.com;
> cohuck@redhat.com; eric.auger@redhat.com; kvm@vger.kernel.org;
> mjrosato@linux.ibm.com; chao.p.peng@linux.intel.com;
> yi.y.sun@linux.intel.com; peterx@redhat.com; jasowang@redhat.com;
> lulu@redhat.com; suravee.suthikulpanit@amd.com;
> intel-gvt-dev@lists.freedesktop.org; intel-gfx@lists.freedesktop.org;
> linux-s390@vger.kernel.org; Hao, Xudong <xudong.hao@intel.com>; Zhao,
> Yan Y <yan.y.zhao@intel.com>
> Subject: Re: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
> 
> On Fri, Mar 03, 2023 at 03:01:03PM +0000, Shameerali Kolothum Thodi
> wrote:
> > External email: Use caution opening links or attachments
> >
> >
> > > -----Original Message-----
> > > From: Nicolin Chen [mailto:nicolinc@nvidia.com]
> > > Sent: 02 March 2023 23:51
> > > To: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> > > Cc: Xu, Terrence <terrence.xu@intel.com>; Liu, Yi L
> > > <yi.l.liu@intel.com>; Jason Gunthorpe <jgg@nvidia.com>;
> > > alex.williamson@redhat.com; Tian, Kevin <kevin.tian@intel.com>;
> > > joro@8bytes.org; robin.murphy@arm.com; cohuck@redhat.com;
> > > eric.auger@redhat.com; kvm@vger.kernel.org; mjrosato@linux.ibm.com;
> > > chao.p.peng@linux.intel.com; yi.y.sun@linux.intel.com;
> > > peterx@redhat.com; jasowang@redhat.com; lulu@redhat.com;
> > > suravee.suthikulpanit@amd.com; intel-gvt-dev@lists.freedesktop.org;
> > > intel-gfx@lists.freedesktop.org; linux-s390@vger.kernel.org; Hao,
> > > Xudong <xudong.hao@intel.com>; Zhao, Yan Y <yan.y.zhao@intel.com>
> > > Subject: Re: [PATCH v5 00/19] Add vfio_device cdev for iommufd
> > > support
> > >
> > > On Thu, Mar 02, 2023 at 09:43:00AM +0000, Shameerali Kolothum Thodi
> > > wrote:
> > >
> > > > Hi Nicolin,
> > > >
> > > > Thanks for the latest ARM64 branch. Do you have a working Qemu
> > > > branch
> > > corresponding to the
> > > > above one?
> > > >
> > > > I tried the
> > >
> https://github.com/nicolinc/qemu/tree/wip/iommufd_rfcv3%2Bnesting%2B
> > > smmuv3
> > > > but for some reason not able to launch the Guest.
> > > >
> > > > Please let me know.
> > >
> > > I do use that branch. It might not be that robust though as it went
> > > through a big rebase.
> >
> > Ok. The issue seems to be quite random in nature and only happens when
> > there are multiple vCPUs. Also doesn't look like related to VFIO
> > device assignment as I can reproduce Guest hang without it by only
> > having nested-smmuv3 and iommufd object.
> >
> > ./qemu-system-aarch64-iommuf -machine
> > virt,gic-version=3,iommu=nested-smmuv3,iommufd=iommufd0 \
> -enable-kvm
> > -cpu host -m 1G -smp cpus=8,maxcpus=8 \ -object iommufd,id=iommufd0
> \
> > -bios QEMU_EFI.fd \ -kernel Image-6.2-iommufd \ -initrd
> > rootfs-iperf.cpio \ -net none \ -nographic \ -append "rdinit=init
> > console=ttyAMA0 root=/dev/vda rw earlycon=pl011,0x9000000" \ -trace
> > events=events \ -D trace_iommufd
> >
> > When the issue happens, no output on terminal as if Qemu is in a locked
> state.
> >
> >  Can you try with the followings?
> > >
> > > --trace "iommufd*" --trace "smmu*" --trace "vfio_*" --trace "pci_*"
> > > --trace "msi_*" --trace "nvme_*"
> >
> > The only trace events with above are this,
> >
> > iommufd_backend_connect fd=22 owned=1 users=1 (0) smmu_add_mr
> > smmuv3-iommu-memory-region-0-0
> >
> > I haven't debugged this further. Please let me know if issue is
> > reproducible with multiple vCPUs at your end. For now will focus on VFIO
> dev specific tests.
> 
> Oh. My test environment has been a single-core vCPU. So that doesn't
> happen to me. Can you try a vanilla QEMU branch that our nesting branch is
> rebased on? I took a branch from Yi as the baseline, while he might take
> from Eric for the rfcv3.
> 
> I am guessing that it might be an issue in the common tree.

Yes, that looks like the case.
I tried with:
 commit 13356edb8750("Merge tag 'block-pull-request' of https://gitlab.com/stefanha/qemu into staging")

And issue is still there. So hopefully once we rebase everything it will go away.

Thanks,
Shameer
