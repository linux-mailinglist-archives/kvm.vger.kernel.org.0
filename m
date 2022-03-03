Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDC94CBE45
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 13:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiCCM6V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 3 Mar 2022 07:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiCCM6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 07:58:19 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37AE1FA42;
        Thu,  3 Mar 2022 04:57:32 -0800 (PST)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K8WFW72w4z67GZK;
        Thu,  3 Mar 2022 20:56:15 +0800 (CST)
Received: from lhreml711-chm.china.huawei.com (10.201.108.62) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Mar 2022 13:57:30 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml711-chm.china.huawei.com (10.201.108.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Mar 2022 12:57:29 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Thu, 3 Mar 2022 12:57:29 +0000
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
Thread-Index: AQHYLltL2nbHr5hFZkexUhHVpQU6TqyszJkAgADNzBA=
Date:   Thu, 3 Mar 2022 12:57:29 +0000
Message-ID: <19e294814f284755b207be3ba7054ec2@huawei.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-10-shameerali.kolothum.thodi@huawei.com>
 <20220303002142.GE1026713@nvidia.com>
In-Reply-To: <20220303002142.GE1026713@nvidia.com>
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
> Sent: 03 March 2022 00:22
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
> On Wed, Mar 02, 2022 at 05:29:02PM +0000, Shameer Kolothum wrote:
> > +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> > +				       unsigned int cmd, unsigned long arg)
> > +{
> > +	struct hisi_acc_vf_migration_file *migf = filp->private_data;
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(migf,
> > +			struct hisi_acc_vf_core_device, saving_migf);
> > +	loff_t *pos = &filp->f_pos;
> > +	struct vfio_precopy_info info;
> > +	unsigned long minsz;
> > +	int ret;
> > +
> > +	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
> > +		return -ENOTTY;
> > +
> > +	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
> > +
> > +	if (copy_from_user(&info, (void __user *)arg, minsz))
> > +		return -EFAULT;
> > +	if (info.argsz < minsz)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&hisi_acc_vdev->state_mutex);
> > +	if (hisi_acc_vdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY) {
> > +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> > +		return -EINVAL;
> > +	}
> 
> IMHO it is easier just to check the total_length and not grab this
> other lock

The problem with checking the total_length here is that it is possible that
in STOP_COPY the dev is not ready and there are no more data to be transferred 
and the total_length remains at QM_MATCH_SIZE.

This just reminded me that the -ENOMSG setting logic in save_read() is
wrong now as it uses only the total_length to determine the PRE_COPY state. 

I think either we need to get the curr state info at both places or in STOP_COPY,
if there are no additional data, set the total_length = 0 and handle it in save_read().

Looks like setting the total_length = 0 in STOP_COPY is a better solution(If there are
no other issues with that) as it will avoid grabbing the state_mutex as you
mentioned above.

> > +struct acc_vf_data {
> > +#define QM_MATCH_SIZE 32L
> 
> This should be
> 
> #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)

Ok.

> > +	/* QM match information */
> 
> You should probably put an 8 byte random magic number here just to
> make the compatibility more unique.

Ok. Will add one.

> > +	u32 qp_num;
> > +	u32 dev_id;
> > +	u32 que_iso_cfg;
> > +	u32 qp_base;
> > +	/* QM reserved match information */
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
> > +	u64 eqe_dma;
> 
> Am I counting wrong or is there a padding before this? 7+7+5 is not a multiple
> of 2. Be explicit about padding in a structure like this.

That's right. It needs padding before 'eqe_dma'.

Thanks,
Shameer
