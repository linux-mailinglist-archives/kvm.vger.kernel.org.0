Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06CD4ADD64
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381906AbiBHPsY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 8 Feb 2022 10:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381888AbiBHPsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:48:23 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B11C0613C9;
        Tue,  8 Feb 2022 07:48:19 -0800 (PST)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtS3v6bbrz67XhV;
        Tue,  8 Feb 2022 23:44:11 +0800 (CST)
Received: from lhreml712-chm.china.huawei.com (10.201.108.63) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 16:48:17 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml712-chm.china.huawei.com (10.201.108.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 15:48:16 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Tue, 8 Feb 2022 15:48:16 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYHPDyAsbl+xVOv0mWAZg3hAhxZqyJxXkAgAABtKA=
Date:   Tue, 8 Feb 2022 15:48:16 +0000
Message-ID: <bd69bdb6e0664667be868ff799e8629e@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
 <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
 <20220208152226.GF4160@nvidia.com>
In-Reply-To: <20220208152226.GF4160@nvidia.com>
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
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 08 February 2022 15:22
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Tue, Feb 08, 2022 at 01:34:24PM +0000, Shameer Kolothum wrote:
> 
> Overall this looks like a fine implementation, as far as I can tell it
> meets the uAPI design perfectly.
> 
> Why did you decide not to do the P2P support?

I need to check that with our hardware folks. May be it is in pipeline. 

> > +static struct file *
> > +hisi_acc_vf_set_device_state(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> > +			     u32 new)
> > +{
> > +	u32 cur = hisi_acc_vdev->mig_state;
> > +	int ret;
> > +
> > +	if (cur == VFIO_DEVICE_STATE_RUNNING && new ==
> VFIO_DEVICE_STATE_STOP) {
> > +		ret = hisi_acc_vf_stop_device(hisi_acc_vdev);
> > +		if (ret)
> > +			return ERR_PTR(ret);
> 
> Be mindful that qemu doesn't handle a failure here very well, I'm not
> sure we will be able to fix this in the short term.

Ok. I will check that and see how big of a problem it is.

> > +static int hisi_acc_vfio_pci_init(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> > +{
> > +	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> > +	struct pci_dev *vf_dev = vdev->pdev;
> > +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> > +
> > +	/*
> > +	 * ACC VF dev BAR2 region consists of both functional register space
> > +	 * and migration control register space. For migration to work, we
> > +	 * need access to both. Hence, we map the entire BAR2 region here.
> > +	 * But from a security point of view, we restrict access to the
> > +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> > +	 * override functions).
> > +	 *
> > +	 * Also the HiSilicon ACC VF devices supported by this driver on
> > +	 * HiSilicon hardware platforms are integrated end point devices
> > +	 * and has no capability to perform PCIe P2P.
> > +	 */
> > +	vf_qm->io_base =
> > +		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> > +			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> > +	if (!vf_qm->io_base)
> > +		return -EIO;
> > +
> > +	vf_qm->fun_type = QM_HW_VF;
> > +	vf_qm->pdev = vf_dev;
> > +	mutex_init(&vf_qm->mailbox_lock);
> 
> mailbox_lock seems unused

I think we need that as that will be used in the QM driver APIs. I will add a
comment here.

> > +	hisi_acc_vdev->vf_id = PCI_FUNC(vf_dev->devfn);
> 
> Does this need to use the pci_iov_vf_id() function? funcs don't need
> to be tightly packed, necessarily.
> 
> This should be set when the structure is allocated, not at open time.

Ok. I will change and move it.
 
> > +	hisi_acc_vdev->vf_dev = vf_dev;
> > +	vf_qm->dev_name = hisi_acc_vdev->pf_qm->dev_name;
> 
> Also unused

I will see if we can get rid of it if it is not used by QM driver APIs used here.

> 
> > +	hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> > +
> > +	return 0;
> > +}
> >
> >  static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
> >  					size_t count, loff_t *ppos,
> > @@ -129,63 +1067,96 @@ static long hisi_acc_vfio_pci_ioctl(struct
> vfio_device *core_vdev, unsigned int
> >
> >  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
> >  {
> > -	struct vfio_pci_core_device *vdev =
> > -		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
> > +			struct hisi_acc_vf_core_device, core_device.vdev);
> > +	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> >  	int ret;
> >
> >  	ret = vfio_pci_core_enable(vdev);
> >  	if (ret)
> >  		return ret;
> >
> > -	vfio_pci_core_finish_enable(vdev);
> > +	if (!hisi_acc_vdev->migration_support) {
> 
> This should just test the core flag and get rid of migration_support:

Ok.

> 
> 		hisi_acc_vdev->core_device.vdev.migration_flags =
> 			VFIO_MIGRATION_STOP_COPY;
> 
> > +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.h
> > @@ -0,0 +1,119 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* Copyright (c) 2021 HiSilicon Ltd. */
> > +
> > +#ifndef HISI_ACC_VFIO_PCI_H
> > +#define HISI_ACC_VFIO_PCI_H
> > +
> > +#include <linux/hisi_acc_qm.h>
> > +
> > +#define VDM_OFFSET(x) offsetof(struct vfio_device_migration_info, x)
> > +
> > +#define HISI_ACC_MIG_REGION_DATA_OFFSET                \
> > +	(sizeof(struct vfio_device_migration_info))
> > +
> > +#define HISI_ACC_MIG_REGION_DATA_SIZE (sizeof(struct acc_vf_data))
> 
> These three are not used any more

True.

> 
> > +struct acc_vf_data {
> > +#define QM_MATCH_SIZE 32L
> > +	/* QM match information */
> > +	u32 qp_num;
> > +	u32 dev_id;
> > +	u32 que_iso_cfg;
> > +	u32 qp_base;
> > +	/* QM reserved 4 match information */
> > +	u32 qm_rsv_state[4];
> > +
> > +	/* QM RW regs */
> > +	u32 aeq_int_mask;
> > +	u32 eq_int_mask;
> > +	u32 ifc_int_source;
> > +	u32 ifc_int_mask;
> > +	u32 ifc_int_set;
> > +	u32 page_size;
> > +
> > +	/* QM_EQC_DW has 7 regs */
> > +	u32 qm_eqc_dw[7];
> > +
> > +	/* QM_AEQC_DW has 7 regs */
> > +	u32 qm_aeqc_dw[7];
> > +
> > +	/* QM reserved 5 regs */
> > +	u32 qm_rsv_regs[5];
> > +
> > +	/* qm memory init information */
> > +	dma_addr_t eqe_dma;
> > +	dma_addr_t aeqe_dma;
> > +	dma_addr_t sqc_dma;
> > +	dma_addr_t cqc_dma;
> 
> You can't put dma_addr_t in a structure that needs to go
> on-the-wire. This should be u64

Ok.

Thanks,
Shameer
 
> > +};
> > +
> > +struct hisi_acc_vf_migration_file {
> > +	struct file *filp;
> > +	struct mutex lock;
> > +	bool disabled;
> > +
> > +	struct acc_vf_data vf_data;
> > +	size_t total_length;
> > +};
> > +
> > +struct hisi_acc_vf_core_device {
> > +	struct vfio_pci_core_device core_device;
> > +	u8 migration_support:1;
> > +	/* for migration state */
> > +	struct mutex state_mutex;
> > +	enum vfio_device_mig_state mig_state;
> > +	struct pci_dev *pf_dev;
> > +	struct pci_dev *vf_dev;
> > +	struct hisi_qm *pf_qm;
> > +	struct hisi_qm vf_qm;
> > +	int vf_id;
> > +
> > +	struct hisi_acc_vf_migration_file *resuming_migf;
> > +	struct hisi_acc_vf_migration_file *saving_migf;
> > +};
> > +#endif /* HISI_ACC_VFIO_PCI_H */
