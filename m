Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD7A4B1123
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 16:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243319AbiBJPBz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Feb 2022 10:01:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243267AbiBJPBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 10:01:52 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812A4C15;
        Thu, 10 Feb 2022 07:01:53 -0800 (PST)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jvg210ZX8z67lNg;
        Thu, 10 Feb 2022 23:01:45 +0800 (CST)
Received: from lhreml714-chm.china.huawei.com (10.201.108.65) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 16:01:51 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 15:01:50 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Thu, 10 Feb 2022 15:01:50 +0000
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
Subject: RE: [RFC v4 5/8] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Topic: [RFC v4 5/8] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Index: AQHYHPDoOQ+DzroH5UW9kocWNKHJr6yLwb+AgAEM7WA=
Date:   Thu, 10 Feb 2022 15:01:50 +0000
Message-ID: <5269a28bf55f4a44b23e6f59d0d5b86b@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
        <20220208133425.1096-6-shameerali.kolothum.thodi@huawei.com>
 <20220209144137.3770d914.alex.williamson@redhat.com>
In-Reply-To: <20220209144137.3770d914.alex.williamson@redhat.com>
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
> Sent: 09 February 2022 21:42
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; jgg@nvidia.com; cohuck@redhat.com;
> mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v4 5/8] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
> migration region
> 
> On Tue, 8 Feb 2022 13:34:22 +0000
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > HiSilicon ACC VF device BAR2 region consists of both functional
> > register space and migration control register space. From a
> > security point of view, it's not advisable to export the migration
> > control region to Guest.
> >
> > Hence, override the ioctl/read/write/mmap methods to hide the
> > migration region and limit the access only to the functional register
> > space.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  drivers/vfio/pci/hisi_acc_vfio_pci.c | 122 ++++++++++++++++++++++++++-
> >  1 file changed, 118 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> > index 8b59e628110e..563ed2cc861f 100644
> > --- a/drivers/vfio/pci/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> > @@ -13,6 +13,120 @@
> >  #include <linux/vfio.h>
> >  #include <linux/vfio_pci_core.h>
> >
> > +static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
> > +					size_t count, loff_t *ppos,
> > +					size_t *new_count)
> > +{
> > +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> > +	struct vfio_pci_core_device *vdev =
> > +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +
> > +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> > +		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> > +		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
> 
> Be careful here, there are nested assignment use cases.  This can only
> survive one level of assignment before we've restricted more than we
> intended.  If migration support is dependent on PF access, can we use
> that to determine when to when to expose only half the BAR and when to
> expose the full BAR?

Ok. I will add a check here.

> We should also follow the mlx5 lead to use a vendor sub-directory below
> drivers/vfio/pci/

Sure.

Thanks,
Shameer

> 
> Alex
> 
> > +
> > +		/* Check if access is for migration control region */
> > +		if (pos >= end)
> > +			return -EINVAL;
> > +
> > +		*new_count = min(count, (size_t)(end - pos));
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
> > +				  struct vm_area_struct *vma)
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +	unsigned int index;
> > +
> > +	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> > +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> > +		u64 req_len, pgoff, req_start;
> > +		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
> > +
> > +		req_len = vma->vm_end - vma->vm_start;
> > +		pgoff = vma->vm_pgoff &
> > +			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> > +		req_start = pgoff << PAGE_SHIFT;
> > +
> > +		if (req_start + req_len > end)
> > +			return -EINVAL;
> > +	}
> > +
> > +	return vfio_pci_core_mmap(core_vdev, vma);
> > +}
> > +
> > +static ssize_t hisi_acc_vfio_pci_write(struct vfio_device *core_vdev,
> > +				       const char __user *buf, size_t count,
> > +				       loff_t *ppos)
> > +{
> > +	size_t new_count = count;
> > +	int ret;
> > +
> > +	ret = hisi_acc_pci_rw_access_check(core_vdev, count, ppos,
> &new_count);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return vfio_pci_core_write(core_vdev, buf, new_count, ppos);
> > +}
> > +
> > +static ssize_t hisi_acc_vfio_pci_read(struct vfio_device *core_vdev,
> > +				      char __user *buf, size_t count,
> > +				      loff_t *ppos)
> > +{
> > +	size_t new_count = count;
> > +	int ret;
> > +
> > +	ret = hisi_acc_pci_rw_access_check(core_vdev, count, ppos,
> &new_count);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return vfio_pci_core_read(core_vdev, buf, new_count, ppos);
> > +}
> > +
> > +static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned
> int cmd,
> > +				    unsigned long arg)
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +
> > +	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> > +		struct pci_dev *pdev = vdev->pdev;
> > +		struct vfio_region_info info;
> > +		unsigned long minsz;
> > +
> > +		minsz = offsetofend(struct vfio_region_info, offset);
> > +
> > +		if (copy_from_user(&info, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (info.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> > +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> > +
> > +			/*
> > +			 * ACC VF dev BAR2 region consists of both functional
> > +			 * register space and migration control register space.
> > +			 * Report only the functional region to Guest.
> > +			 */
> > +			info.size = pci_resource_len(pdev, info.index) / 2;
> > +
> > +			info.flags = VFIO_REGION_INFO_FLAG_READ |
> > +					VFIO_REGION_INFO_FLAG_WRITE |
> > +					VFIO_REGION_INFO_FLAG_MMAP;
> > +
> > +			return copy_to_user((void __user *)arg, &info, minsz) ?
> > +					    -EFAULT : 0;
> > +		}
> > +	}
> > +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> > +}
> > +
> >  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
> >  {
> >  	struct vfio_pci_core_device *vdev =
> > @@ -32,10 +146,10 @@ static const struct vfio_device_ops
> hisi_acc_vfio_pci_ops = {
> >  	.name = "hisi-acc-vfio-pci",
> >  	.open_device = hisi_acc_vfio_pci_open_device,
> >  	.close_device = vfio_pci_core_close_device,
> > -	.ioctl = vfio_pci_core_ioctl,
> > -	.read = vfio_pci_core_read,
> > -	.write = vfio_pci_core_write,
> > -	.mmap = vfio_pci_core_mmap,
> > +	.ioctl = hisi_acc_vfio_pci_ioctl,
> > +	.read = hisi_acc_vfio_pci_read,
> > +	.write = hisi_acc_vfio_pci_write,
> > +	.mmap = hisi_acc_vfio_pci_mmap,
> >  	.request = vfio_pci_core_request,
> >  	.match = vfio_pci_core_match,
> >  };

