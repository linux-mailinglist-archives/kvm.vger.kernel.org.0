Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701EE4CBEAE
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 14:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiCCNR5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 3 Mar 2022 08:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiCCNRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 08:17:55 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D521704CD;
        Thu,  3 Mar 2022 05:17:08 -0800 (PST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K8Wh76J62z67r9d;
        Thu,  3 Mar 2022 21:15:51 +0800 (CST)
Received: from lhreml714-chm.china.huawei.com (10.201.108.65) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 3 Mar 2022 14:17:05 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Mar 2022 13:17:05 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Thu, 3 Mar 2022 13:17:05 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYLltL2nbHr5hFZkexUhHVpQU6TqyszJkAgADNzBCAAAc9gIAAApOw
Date:   Thu, 3 Mar 2022 13:17:05 +0000
Message-ID: <f2172fa9f84447699cb0973bec3ca0da@huawei.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-10-shameerali.kolothum.thodi@huawei.com>
 <20220303002142.GE1026713@nvidia.com>
 <19e294814f284755b207be3ba7054ec2@huawei.com>
 <20220303130411.GY219866@nvidia.com>
In-Reply-To: <20220303130411.GY219866@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.82.4]
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
> Sent: 03 March 2022 13:04
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org;
> alex.williamson@redhat.com; cohuck@redhat.com; mgurtovoy@nvidia.com;
> yishaih@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Thu, Mar 03, 2022 at 12:57:29PM +0000, Shameerali Kolothum Thodi
> wrote:
> >
> >
> > > From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> > > Sent: 03 March 2022 00:22
> > > To: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org;
> > > alex.williamson@redhat.com; cohuck@redhat.com;
> mgurtovoy@nvidia.com;
> > > yishaih@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> > > <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> > > Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> > > <wangzhou1@hisilicon.com>
> > > Subject: Re: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
> > > migration
> > >
> > > On Wed, Mar 02, 2022 at 05:29:02PM +0000, Shameer Kolothum wrote:
> > > > +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> > > > +				       unsigned int cmd, unsigned long arg)
> > > > +{
> > > > +	struct hisi_acc_vf_migration_file *migf = filp->private_data;
> > > > +	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(migf,
> > > > +			struct hisi_acc_vf_core_device, saving_migf);
> > > > +	loff_t *pos = &filp->f_pos;
> > > > +	struct vfio_precopy_info info;
> > > > +	unsigned long minsz;
> > > > +	int ret;
> > > > +
> > > > +	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
> > > > +		return -ENOTTY;
> > > > +
> > > > +	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
> > > > +
> > > > +	if (copy_from_user(&info, (void __user *)arg, minsz))
> > > > +		return -EFAULT;
> > > > +	if (info.argsz < minsz)
> > > > +		return -EINVAL;
> > > > +
> > > > +	mutex_lock(&hisi_acc_vdev->state_mutex);
> > > > +	if (hisi_acc_vdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY) {
> > > > +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> > > > +		return -EINVAL;
> > > > +	}
> > >
> > > IMHO it is easier just to check the total_length and not grab this
> > > other lock
> >
> > The problem with checking the total_length here is that it is possible that
> > in STOP_COPY the dev is not ready and there are no more data to be
> transferred
> > and the total_length remains at QM_MATCH_SIZE.
> 
> Tthere is a scenario that transfers only QM_MATCH_SIZE in stop_copy?
> This doesn't seem like a good idea, I think you should transfer a
> positive indication 'this device is not ready' instead of truncating
> the stream. A truncated stream should not be a valid stream.
> 
> ie always transfer the whole struct.

We could add a 'qm_state' and return the whole struct. But the rest
of the struct is basically invalid if qm_state = QM_NOT_REDAY.

> 
> > Looks like setting the total_length = 0 in STOP_COPY is a better
> > solution(If there are no other issues with that) as it will avoid
> > grabbing the state_mutex as you mentioned above.
> 
> That seems really weird, I wouldn't recommend doing that..

Does that mean we don't support a zero data transfer in STOP_COPY?
The concern is if we always transfer the whole struct, we end up reading
and writing the whole thing even if most of the data is invalid.

Thanks,
Shameer
