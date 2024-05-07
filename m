Return-Path: <kvm+bounces-16801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2AD58BDCEA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 10:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 018811C2311C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A53413C909;
	Tue,  7 May 2024 08:06:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918E113B7AF;
	Tue,  7 May 2024 08:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715069209; cv=none; b=ufwyqXcSXx2HmWSQgQ4/iuuEcZ8liwhfwuuJAonni6vmbx/a2uWnxzXebMxDUn2y95xQYnFlvwfD+jROFDZMssSn1979q6DkxexxDxNkM09SeD/Gr5SZ8bG936dfBAhE4TKL3XlsLt7D4+RaookgoRiKf7er8GqpM5jONFeqKXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715069209; c=relaxed/simple;
	bh=bfN0Lt/MHmbuk1zI5i8I74mbv+rVl0Hq7fCQ6JLhMFU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J6SEhLRnUm1SNP0INPqQQzyLUKaLnHicgmZ0yoK8s+uT5Abkr0gK9mLEqtrxphDY5+HBhRvSWbaallZErQzk5WQvaWt/OuPhWF1sm2gFSaeDjceMC5tIIEDkJk/eAxNMGCdI+q7cmV+h0Z7LPemYXqMLQ3GD+ZwjrnrbyfDWRX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VYW6v651Fz6DB9c;
	Tue,  7 May 2024 16:05:43 +0800 (CST)
Received: from lhrpeml100002.china.huawei.com (unknown [7.191.160.241])
	by mail.maildlp.com (Postfix) with ESMTPS id 4CCE4140C9C;
	Tue,  7 May 2024 16:06:11 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100002.china.huawei.com (7.191.160.241) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 7 May 2024 09:06:04 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Tue, 7 May 2024 09:06:04 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>, liulongfang
	<liulongfang@huawei.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v6 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v6 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Index: AQHalxS9rabDiUo2yUOKARoyroN9ObGFvbMAgAW+J+A=
Date: Tue, 7 May 2024 08:06:04 +0000
Message-ID: <7b0645b43889431b9830bc17835c15e4@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
	<20240425132322.12041-5-liulongfang@huawei.com>
 <20240503112120.3740da24.alex.williamson@redhat.com>
In-Reply-To: <20240503112120.3740da24.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, May 3, 2024 6:21 PM
> To: liulongfang <liulongfang@huawei.com>
> Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; linuxarm@openeuler.org
> Subject: Re: [PATCH v6 4/5] hisi_acc_vfio_pci: register debugfs for hisil=
icon
> migration driver
>=20
> On Thu, 25 Apr 2024 21:23:21 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
>=20
> > On the debugfs framework of VFIO, if the CONFIG_VFIO_DEBUGFS macro is
> > enabled, the debug function is registered for the live migration driver
> > of the HiSilicon accelerator device.
> >
> > After registering the HiSilicon accelerator device on the debugfs
> > framework of live migration of vfio, a directory file "hisi_acc"
> > of debugfs is created, and then three debug function files are
> > created in this directory:
> >
> >    vfio
> >     |
> >     +---<dev_name1>
> >     |    +---migration
> >     |        +--state
> >     |        +--hisi_acc
> >     |            +--dev_data
> >     |            +--migf_data
> >     |            +--cmd_state
> >     |
> >     +---<dev_name2>
> >          +---migration
> >              +--state
> >              +--hisi_acc
> >                  +--dev_data
> >                  +--migf_data
> >                  +--cmd_state
> >
> > dev_data file: read device data that needs to be migrated from the
> > current device in real time
> > migf_data file: read the migration data of the last live migration
> > from the current driver.
> > cmd_state: used to get the cmd channel state for the device.
> >
> > +----------------+        +--------------+       +---------------+
> > | migration dev  |        |   src  dev   |       |   dst  dev    |
> > +-------+--------+        +------+-------+       +-------+-------+
> >         |                        |                       |
> >         |                 +------v-------+       +-------v-------+
> >         |                 |  saving_mif  |       | resuming_migf |
> >   read  |                 |     file     |       |     file      |
> >         |                 +------+-------+       +-------+-------+
> >         |                        |          copy         |
> >         |                        +------------+----------+
> >         |                                     |
> > +-------v---------+                   +-------v--------+
> > |   data buffer   |                   |   debug_migf   |
> > +-------+---------+                   +-------+--------+
> >         |                                     |
> >    cat  |                                 cat |
> > +-------v--------+                    +-------v--------+
> > |   dev_data     |                    |   migf_data    |
> > +----------------+                    +----------------+
> >
> > When accessing debugfs, user can obtain the real-time status data
> > of the device through the "dev_data" file. It will directly read
> > the device status data and will not affect the live migration
> > function. Its data is stored in the allocated memory buffer,
> > and the memory is released after data returning to user mode.
> >
> > To obtain the data of the last complete migration, user need to
> > obtain it through the "migf_data" file. Since the live migration
> > data only exists during the migration process, it is destroyed
> > after the migration is completed.
> > In order to save this data, a debug_migf file is created in the
> > driver. At the end of the live migration process, copy the data
> > to debug_migf.
> >
> > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > ---
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 225 ++++++++++++++++++
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
> >  2 files changed, 232 insertions(+)
> >
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > index bf358ba94b5d..656b3d975940 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > @@ -627,15 +627,33 @@ static void hisi_acc_vf_disable_fd(struct
> hisi_acc_vf_migration_file *migf)
> >  	mutex_unlock(&migf->lock);
> >  }
> >
> > +static void hisi_acc_debug_migf_copy(struct hisi_acc_vf_core_device
> *hisi_acc_vdev,
> > +	struct hisi_acc_vf_migration_file *src_migf)
> > +{
> > +	struct hisi_acc_vf_migration_file *dst_migf =3D hisi_acc_vdev-
> >debug_migf;
> > +
> > +	if (!dst_migf)
> > +		return;
> > +
> > +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> > +	dst_migf->disabled =3D src_migf->disabled;
> > +	dst_migf->total_length =3D src_migf->total_length;
> > +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> > +		sizeof(struct acc_vf_data));
> > +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> > +}
> > +
> >  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> >  {
> >  	if (hisi_acc_vdev->resuming_migf) {
> > +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev-
> >resuming_migf);
> >  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
> >  		fput(hisi_acc_vdev->resuming_migf->filp);
> >  		hisi_acc_vdev->resuming_migf =3D NULL;
> >  	}
> >
> >  	if (hisi_acc_vdev->saving_migf) {
> > +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev-
> >saving_migf);
> >  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
> >  		fput(hisi_acc_vdev->saving_migf->filp);
> >  		hisi_acc_vdev->saving_migf =3D NULL;
> > @@ -1144,6 +1162,7 @@ static int hisi_acc_vf_qm_init(struct
> hisi_acc_vf_core_device *hisi_acc_vdev)
> >  	if (!vf_qm->io_base)
> >  		return -EIO;
> >
> > +	mutex_init(&hisi_acc_vdev->enable_mutex);
> >  	vf_qm->fun_type =3D QM_HW_VF;
> >  	vf_qm->pdev =3D vf_dev;
> >  	mutex_init(&vf_qm->mailbox_lock);
> > @@ -1294,6 +1313,203 @@ static long hisi_acc_vfio_pci_ioctl(struct
> vfio_device *core_vdev, unsigned int
> >  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> >  }
> >
> > +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_d=
evice
> *vdev)
> > +{
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> > +	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
> > +	struct device *dev =3D vdev->dev;
> > +	int ret;
> > +
> > +	if (!vdev->mig_ops) {
> > +		dev_err(dev, "device does not support live migration!\n");
>=20
> Sorry, every error path should not spam dmesg with dev_err().  I'm
> going to wait until your co-maintainer approves this before looking at
> any further iterations of this series.  Thanks,

Sure. I will sync up with Longfang and also make sure we address all the ex=
isting
comments on this before posting the next revision.

Thanks,
Shameer

