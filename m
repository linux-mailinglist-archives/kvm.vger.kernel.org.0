Return-Path: <kvm+bounces-66330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89165CCFB0D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 091123035807
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C8F2459ED;
	Fri, 19 Dec 2025 11:52:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D8221ABDC;
	Fri, 19 Dec 2025 11:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766145135; cv=none; b=Nl9UC/CQgNuhfklGgHuslAZmgkIHmngPmRMVGy9PM12k624hw0k4UE+S4e8Nd0gNke6dy53I/r3sgPJdzxCzgMID73GlfIMZWLEU77jdYBGvhLxCQb+mb3GkOyL+LpQidYbAWqxiJdCeGK3/rH1GskSV/kUxwmkzY//zYqONCuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766145135; c=relaxed/simple;
	bh=a+A3/IhorGkly3ylg8hXj7Ua6UftWWtnu2AVm/TxfS0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAgdI6EMs5+XPDCXENgDWjxRQWpfPEouwLCF8/nRMcsZxZdr52BKJS5Kqc/uwlFcqayX699Zr/nOWlZmfIYCcLH5oMIuoSfuDiTxC7xErOTwqeA2mGFJ7dQi09XELoOnSSf36hQC6g/9e7nQ2TEUMmCenJ3Y4Zmy9apykxCNdCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXm8n4XQ7zJ46cH;
	Fri, 19 Dec 2025 19:51:37 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3092640086;
	Fri, 19 Dec 2025 19:52:10 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 19 Dec
 2025 11:52:09 +0000
Date: Fri, 19 Dec 2025 11:52:07 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v1 12/26] iommu/vt-d: Reserve the MSB domain ID bit for
 the TDX module
Message-ID: <20251219115115.00000922@huawei.com>
In-Reply-To: <20251117022311.2443900-13-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
	<20251117022311.2443900-13-yilun.xu@linux.intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 17 Nov 2025 10:22:56 +0800
Xu Yilun <yilun.xu@linux.intel.com> wrote:

> From: Lu Baolu <baolu.lu@linux.intel.com>
>=20
> The Intel TDX Connect Architecture Specification defines some enhancements
> for the VT-d architecture to introduce IOMMU support for TEE-IO requests.
> Section 2.2, 'Trusted DMA' states that:
>=20
> "I/O TLB and DID Isolation =E2=80=93 When IOMMU is enabled to support TDX
> Connect, the IOMMU restricts the VMM=E2=80=99s DID setting, reserving the=
 MSB bit
> for the TDX module. The TDX module always sets this reserved bit on the
> trusted DMA table. IOMMU tags IOTLB, PASID cache, and context entries to
> indicate whether they were created from TEE-IO transactions, ensuring
> isolation between TEE and non-TEE requests in translation caches."
>=20
> Reserve the MSB in the domain ID for the TDX module's use if the
> enhancement is required, which is detected if the ECAP.TDXCS bit in the
> VT-d extended capability register is set and the TVM Usable field of the
> ACPI KEYP table is set.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Missing sign off of the person who 'handled' the patch by sending it to
the list in this series.  i.e. Xu Yilun.

One comment inline.

Thanks,

Jonathan

> diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
> index a54934c0536f..e9d65b26ad64 100644
> --- a/drivers/iommu/intel/dmar.c
> +++ b/drivers/iommu/intel/dmar.c
> @@ -1033,6 +1033,56 @@ static int map_iommu(struct intel_iommu *iommu, st=
ruct dmar_drhd_unit *drhd)
>  	return err;
>  }
> =20
> +static int keyp_config_unit_tvm_usable(union acpi_subtable_headers *head=
er,
> +				       void *arg, const unsigned long end)
> +{
> +	struct acpi_keyp_config_unit *acpi_cu =3D
> +		(struct acpi_keyp_config_unit *)&header->keyp;
> +	int *tvm_usable =3D arg;
> +
> +	if (acpi_cu->flags & ACPI_KEYP_F_TVM_USABLE)
> +		*tvm_usable =3D true;
As below. Be consistent on int vs bool as otherwise the subtle use of -1 is=
 very confusing.
> +
> +	return 0;
> +}
> +
> +static bool platform_is_tdxc_enhanced(void)
> +{
> +	static int tvm_usable =3D -1;
> +	int ret;
> +
> +	/* only need to parse once */
> +	if (tvm_usable !=3D -1)
> +		return tvm_usable;
> +
> +	tvm_usable =3D false;

This is flipping between an int and a bool which seems odd.
I'd stick to an integer then make it a bool only at return.

> +	ret =3D acpi_table_parse_keyp(ACPI_KEYP_TYPE_CONFIG_UNIT,
> +				    keyp_config_unit_tvm_usable, &tvm_usable);
> +	if (ret < 0)
> +		tvm_usable =3D false;
> +
> +	return tvm_usable;
> +}



