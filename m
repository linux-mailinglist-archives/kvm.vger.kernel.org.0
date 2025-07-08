Return-Path: <kvm+bounces-51748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B6FAFC54A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:19:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32FF11781C2
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3212BD5BB;
	Tue,  8 Jul 2025 08:18:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB8E221DBA;
	Tue,  8 Jul 2025 08:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751962738; cv=none; b=YNf5HsBdhFxFVqfslAWjHcvZlKaBkQgi5HQgJ0RZcexmKbEaga6QYHKNJEMy3rzFzuKihERyoTTVgAxr6MjTf/u798LaN8QjlqN4bdw/OEGmjs+e1J8Uxt7o7nw5ioV0s6GV+PjqHRPVmk6Yq2RsQayQaNgCukuKd3nDvZeyUwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751962738; c=relaxed/simple;
	bh=sGK409pw0pZ0BKgmmvoYzQGhRPuIletgMvMw+haw9Vk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A3XX2H+T4ZZ7H0nc8VmJ0YYhxDY8BSX0LOsKWKAqyoxc6tHPHJUWeNl+5pNxyADdsOAyel/uGjUmTI+GAAf2SJwPw41qJ6HmW+ETSCnT7Slr0IlsqB7jqiGNuZ++pHZLHBvI5Jtmqztqz2VIezOPH77J0vTEBoDSQTTdbOnhbzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bbv7L4cTSz6GDDk;
	Tue,  8 Jul 2025 16:15:42 +0800 (CST)
Received: from frapeml500006.china.huawei.com (unknown [7.182.85.219])
	by mail.maildlp.com (Postfix) with ESMTPS id A91301402EA;
	Tue,  8 Jul 2025 16:18:51 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500006.china.huawei.com (7.182.85.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 8 Jul 2025 10:18:51 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 8 Jul 2025 10:18:51 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v5 2/3] migration: qm updates BAR configuration
Thread-Topic: [PATCH v5 2/3] migration: qm updates BAR configuration
Thread-Index: AQHb6Zy0W5sPOs5SDkGRskaRazIkbLQn7aZQ
Date: Tue, 8 Jul 2025 08:18:51 +0000
Message-ID: <a4ff64ceeab1405ab6ebb8ed89c35407@huawei.com>
References: <20250630085402.7491-1-liulongfang@huawei.com>
 <20250630085402.7491-3-liulongfang@huawei.com>
In-Reply-To: <20250630085402.7491-3-liulongfang@huawei.com>
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
> Sent: Monday, June 30, 2025 9:54 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v5 2/3] migration: qm updates BAR configuration
>=20
> On new platforms greater than QM_HW_V3, the configuration region for
> the
> live migration function of the accelerator device is no longer
> placed in the VF, but is instead placed in the PF.
>=20
> Therefore, the configuration region of the live migration function
> needs to be opened when the QM driver is loaded. When the QM driver
> is uninstalled, the driver needs to clear this configuration.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.=
c
> index d3f5d108b898..0a8888304e15 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -242,6 +242,9 @@
>  #define QM_QOS_MAX_CIR_U		6
>  #define QM_AUTOSUSPEND_DELAY		3000
>=20
> +#define QM_MIG_REGION_SEL		0x100198
> +#define QM_MIG_REGION_EN		0x1
> +
>   /* abnormal status value for stopping queue */
>  #define QM_STOP_QUEUE_FAIL		1
>  #define	QM_DUMP_SQC_FAIL		3
> @@ -3004,11 +3007,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
>  	pci_release_mem_regions(pdev);
>  }
>=20
> +static void hisi_mig_region_clear(struct hisi_qm *qm)
> +{
> +	u32 val;
> +
> +	/* Clear migration region set of PF */
> +	if (qm->fun_type =3D=3D QM_HW_PF && qm->ver > QM_HW_V3) {
> +		val =3D readl(qm->io_base + QM_MIG_REGION_SEL);
> +		val &=3D ~BIT(0);
> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
> +	}
> +}
> +
> +static void hisi_mig_region_enable(struct hisi_qm *qm)
> +{
> +	u32 val;
> +
> +	/* Select migration region of PF */
> +	if (qm->fun_type =3D=3D QM_HW_PF && qm->ver > QM_HW_V3) {
> +		val =3D readl(qm->io_base + QM_MIG_REGION_SEL);
> +		val |=3D QM_MIG_REGION_EN;
> +		writel(val, qm->io_base + QM_MIG_REGION_SEL);
> +	}
> +}

May adding a  comment for above functions  will be helpful.

> +
>  static void hisi_qm_pci_uninit(struct hisi_qm *qm)
>  {
>  	struct pci_dev *pdev =3D qm->pdev;
>=20
>  	pci_free_irq_vectors(pdev);
> +	hisi_mig_region_clear(qm);
>  	qm_put_pci_res(qm);
>  	pci_disable_device(pdev);
>  }
> @@ -5630,6 +5658,7 @@ int hisi_qm_init(struct hisi_qm *qm)
>  		goto err_free_qm_memory;
>=20
>  	qm_cmd_init(qm);
> +	hisi_mig_region_enable(qm);
>=20
>  	return 0;

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

You need to CC QM driver maintainers for this.

Thanks,
SHameer

