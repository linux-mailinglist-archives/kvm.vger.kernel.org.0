Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D7D4C778C
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 19:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbiB1SXj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 28 Feb 2022 13:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240559AbiB1SX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 13:23:26 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1C699EF6;
        Mon, 28 Feb 2022 10:01:59 -0800 (PST)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K6p8314Lpz67yk2;
        Tue,  1 Mar 2022 02:00:35 +0800 (CST)
Received: from lhreml715-chm.china.huawei.com (10.201.108.66) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 19:01:45 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 18:01:45 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Mon, 28 Feb 2022 18:01:44 +0000
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
Subject: RE: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYLIIBaGfq6jzuvUWvoNXYZoVi1qypDgGAgAAyBYA=
Date:   Mon, 28 Feb 2022 18:01:44 +0000
Message-ID: <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
 <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
 <20220228145731.GH219866@nvidia.com>
In-Reply-To: <20220228145731.GH219866@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.94.1]
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
> Sent: 28 February 2022 14:58
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Mon, Feb 28, 2022 at 09:01:20AM +0000, Shameer Kolothum wrote:
> 
> > +static int hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device
> *hisi_acc_vdev,
> > +				 struct hisi_acc_vf_migration_file *migf)
> > +{
> > +	struct acc_vf_data *vf_data = &migf->vf_data;
> 
> This now needs to hold the migf->lock
> 
> > +
> > +	if ((cur == VFIO_DEVICE_STATE_STOP || cur ==
> VFIO_DEVICE_STATE_PRE_COPY) &&
> > +	    new == VFIO_DEVICE_STATE_RUNNING) {
> > +		hisi_acc_vf_start_device(hisi_acc_vdev);
> 
> This should be two stanzas STOP->RUNNING should do start_device
> 
> And PRE_COPY->RUNNING should do disable_fds, and presumably nothing
> else - the device was never stopped.
> 

Ok. I will take care of all the above.

> > +	} else if (cmd == VFIO_DEVICE_MIG_PRECOPY) {
> > +		struct vfio_device_mig_precopy precopy;
> > +		enum vfio_device_mig_state curr_state;
> > +		unsigned long minsz;
> > +		int ret;
> > +
> > +		minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
> > +
> > +		if (copy_from_user(&precopy, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +		if (precopy.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		ret = hisi_acc_vfio_pci_get_device_state(core_vdev, &curr_state);
> > +		if (!ret && curr_state == VFIO_DEVICE_STATE_PRE_COPY) {
> > +			precopy.initial_bytes = QM_MATCH_SIZE;
> > +			precopy.dirty_bytes = QM_MATCH_SIZE;
> 
> dirty_bytes should be 0
> 
> initial_bytes should be calculated based on the current file
> descriptor offset.
> 
> The use of curr_state should be eliminated
> 
> This ioctl should be on the saving file_operations, not here
> 
> + * This ioctl is used on the migration data FD in the precopy phase of the
> + * migration data transfer. It returns an estimate of the current data sizes
> 
> I see there is a bug in the qemu version:
> 
> @@ -215,12 +218,13 @@ static void vfio_save_precopy_pending(QEMUFile
> *f, void *>
>                                        uint64_t *res_postcopy_only)
>  {
>      VFIODevice *vbasedev = opaque;
> +    VFIOMigration *migration = vbasedev->migration;
>      struct vfio_device_mig_precopy precopy = {
>          .argsz = sizeof(precopy),
>      };
>      int ret;
> 
> -    ret = ioctl(vbasedev->fd, VFIO_DEVICE_MIG_PRECOPY, &precopy);
> +    ret = ioctl(migration->data_fd, VFIO_DEVICE_MIG_PRECOPY, &precopy);
>      if (ret) {
>          return;
>      }
> 
> I'll update my github.

Ok. Thanks for that.

And for the VFIO_DEVICE_MIG_PRECOPY ioctl, this is what I have now,

+static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
+                                      unsigned int cmd, unsigned long arg)
+{
+       struct hisi_acc_vf_migration_file *migf = filp->private_data;
+       loff_t *pos = &filp->f_pos;
+       struct vfio_device_mig_precopy precopy;
+       unsigned long minsz;
+
+       if (cmd != VFIO_DEVICE_MIG_PRECOPY)
+               return -EINVAL;
+
+       minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
+
+       if (copy_from_user(&precopy, (void __user *)arg, minsz))
+               return -EFAULT;
+       if (precopy.argsz < minsz)
+               return -EINVAL;
+
+       mutex_lock(&migf->lock);
+       if (*pos > migf->total_length) {
+               mutex_unlock(&migf->lock);
+               return -EINVAL;
+       }
+
+       precopy.dirty_bytes = 0;
+       precopy.initial_bytes = migf->total_length - *pos;
+       mutex_unlock(&migf->lock);
+       return copy_to_user((void __user *)arg, &precopy, minsz) ? -EFAULT : 0;
+}
+

I had a quick run with the above Qemu changes, and looks ok. Please let me know.

Thanks,
Shameer
