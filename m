Return-Path: <kvm+bounces-24121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D3BD9517DB
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 11:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A3A628466D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 09:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F591684B9;
	Wed, 14 Aug 2024 09:39:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7800B13E8A5;
	Wed, 14 Aug 2024 09:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723628390; cv=none; b=UIt1MRLg4UaJJlBHOdJU1Ey8UEEtfM1nn1k4w6H2xX1ftnCCstTX2xmKh3MCGB4302x/AjZdpz4NQmDa84NxK1ZsZV5CIyn5+QUVCpnoUzAW7sQ6LhixAYC2IRIOwHCAnmWqPeXmIMs2ljVCgGefOOGzWgyq9vWoed0NlEScJTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723628390; c=relaxed/simple;
	bh=vJVA25NlVApgT7H0WWSrbrXVJdmhTh1HAQt9tiDC4NI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xxo8cXtskfB9AFgQY9KmiiPIZh7dSsDOkCky8ueDbPpzjOrI8+W1+CgQ7Ux08LhL9AF/o5ceP10SfhQM7uvAHDlRrvKmyJnfHkb6AeL2g9NMYQOe4bLxLI3u4C8T++CnqqCbbn+UO9v6K2qnAb4j33rdgzxRifigoRDYvUxUOH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WkNRx5HDsz6K6Cf;
	Wed, 14 Aug 2024 17:36:29 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (unknown [7.191.163.213])
	by mail.maildlp.com (Postfix) with ESMTPS id 5E8C4140B2A;
	Wed, 14 Aug 2024 17:39:45 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500001.china.huawei.com (7.191.163.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 10:39:45 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Wed, 14 Aug 2024 10:39:45 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v8 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v8 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Index: AQHa5/1cLifCKuSClUed/yMoPQ/pPbImir+Q
Date: Wed, 14 Aug 2024 09:39:44 +0000
Message-ID: <42784fb0fd1c44cf9470c9662e154b88@huawei.com>
References: <20240806122928.46187-1-liulongfang@huawei.com>
 <20240806122928.46187-4-liulongfang@huawei.com>
In-Reply-To: <20240806122928.46187-4-liulongfang@huawei.com>
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
> From: liulongfang <liulongfang@huawei.com>
> Sent: Tuesday, August 6, 2024 1:29 PM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v8 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
> migration driver
...=20
> +static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	size_t vf_data_sz =3D offsetofend(struct acc_vf_data, padding);
> +	struct acc_vf_data *vf_data =3D NULL;
> +	int ret;
> +
> +	vf_data =3D kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
> +	if (!vf_data)
> +		return -ENOMEM;
> +
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	ret =3D hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> +		goto migf_err;
> +	}
> +
> +	vf_data->vf_qm_state =3D hisi_acc_vdev->vf_qm_state;
> +	ret =3D vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> +		goto migf_err;
> +	}
> +
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
> +
> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +			(unsigned char *)vf_data,
> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "device  ready: %u\n"
> +		 "device  opened: %d\n"
> +		 "data     size: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
> +		 hisi_acc_vdev->dev_opened,

I think the dev_opened will be always true if it reaches here and can be
removed from here and from hisi_acc_vf_migf_read() as well.

Please don't respin just for this. Let us wait for others to review this.

Thanks,
Shameer

