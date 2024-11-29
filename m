Return-Path: <kvm+bounces-32776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D9959DE8A8
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 15:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64DF61641F2
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 14:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FA313B5B3;
	Fri, 29 Nov 2024 14:38:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E083CD2;
	Fri, 29 Nov 2024 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732891105; cv=none; b=KI9IJF0SAoQG8vNFZkZeQ0nRxGoyPDEssbETJDC1GdkV0LoB8bb+2Dt7g1Hqxvv//A920ejfRvqsCuAvMvl0buUsq82G0lRPhjLMXoQTdBSLUqGOH6mXYkFfSf/afMN/a1ZavRa0RYgD6RsQ1LmHsWWOJdz1xAg8ROpv4691wrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732891105; c=relaxed/simple;
	bh=snODN72p4HzgsG+wUkWfkP65kEyLAgKcZEAr8US8HZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ki7rVqRfuoxkuLUjhuqraGQIQDKOSPsrGTCq8CprwlCNZpbjfhgVfMj0ZwnrpPVMTwD3G2z7bKLGxSWyaGpIT+JbbKQdtjWo4H01kSfP9tkaYW0/d/TMGiRgYy4Xy7vLwL2hUGnbItrWGTicX0jeoOxZJolFGXhlAFIalkbQy5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Y0G1R46fmz1V3n4;
	Fri, 29 Nov 2024 22:35:23 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id C1079180357;
	Fri, 29 Nov 2024 22:38:13 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 29 Nov 2024 22:38:12 +0800
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 29 Nov 2024 15:38:11 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Len
 Brown" <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Donald Dutile
	<ddutile@redhat.com>, Eric Auger <eric.auger@redhat.com>, "Guohanjun (Hanjun
 Guo)" <guohanjun@huawei.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, Jerry Snitselaar <jsnitsel@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: RE: [PATCH v4 08/12] iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
Thread-Topic: [PATCH v4 08/12] iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
Thread-Index: AQHbKyrKsqNlrqnGcUyZXy2u3OjB57LOfxbQ
Date: Fri, 29 Nov 2024 14:38:10 +0000
Message-ID: <8128e648ad014485a7db9771a94194de@huawei.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <8-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <8-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
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

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 31, 2024 12:21 AM
> To: acpica-devel@lists.linux.dev; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>;
> kvm@vger.kernel.org; Len Brown <lenb@kernel.org>; linux-
> acpi@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Lorenzo
> Pieralisi <lpieralisi@kernel.org>; Rafael J. Wysocki <rafael@kernel.org>;
> Robert Moore <robert.moore@intel.com>; Robin Murphy
> <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>; Will
> Deacon <will@kernel.org>
> Cc: Alex Williamson <alex.williamson@redhat.com>; Donald Dutile
> <ddutile@redhat.com>; Eric Auger <eric.auger@redhat.com>; Guohanjun
> (Hanjun Guo) <guohanjun@huawei.com>; Jean-Philippe Brucker <jean-
> philippe@linaro.org>; Jerry Snitselaar <jsnitsel@redhat.com>; Moritz
> Fischer <mdf@kernel.org>; Michael Shavit <mshavit@google.com>; Nicolin
> Chen <nicolinc@nvidia.com>; patches@lists.linux.dev; Rafael J. Wysocki
> <rafael.j.wysocki@intel.com>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Mostafa Saleh
> <smostafa@google.com>
> Subject: [PATCH v4 08/12] iommu/arm-smmu-v3: Support
> IOMMU_VIOMMU_ALLOC

[...]

> +struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
> +				       struct iommu_domain *parent,
> +				       struct iommufd_ctx *ictx,
> +				       unsigned int viommu_type)
> +{
> +	struct arm_smmu_device *smmu =3D
> +		iommu_get_iommu_dev(dev, struct arm_smmu_device,
> iommu);
> +	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> +	struct arm_smmu_domain *s2_parent =3D to_smmu_domain(parent);
> +	struct arm_vsmmu *vsmmu;
> +
> +	if (viommu_type !=3D IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	if (s2_parent->smmu !=3D master->smmu)
> +		return ERR_PTR(-EINVAL);
> +
> +	/*
> +	 * Must support some way to prevent the VM from bypassing the
> cache
> +	 * because VFIO currently does not do any cache maintenance.
> canwbs
> +	 * indicates the device is fully coherent and no cache maintenance
> is
> +	 * ever required, even for PCI No-Snoop."
> +	 */
> +	if (!arm_smmu_master_canwbs(master))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	vsmmu =3D iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
> +				     &arm_vsmmu_ops);
> +	if (IS_ERR(vsmmu))
> +		return ERR_CAST(vsmmu);
> +
> +	vsmmu->smmu =3D smmu;
> +	vsmmu->s2_parent =3D s2_parent;
> +	/* FIXME Move VMID allocation from the S2 domain allocation to
> here */

I am planning to respin the " iommu/arm-smmu-v3: Use pinned KVM VMID for
stage 2" [0] based on the latest IOMMUF code. One of the comment on that
RFC was, we should associate the KVM pointer to the sub objects like  viomm=
u
instead of iommufd itself[1]. But at present the s2 domain is already final=
ized
with a VMID before a viommu object is allocated.

So does the above comment indicates that we plan to do another
S2 VMID allocation here and replace the old one?

Please let me know your thoughts on this.

Thanks,
Shameer
[0] https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.k=
olothum.thodi@huawei.com/
[1] https://lore.kernel.org/linux-iommu/BN9PR11MB527662A2AB0A9BABD5E20E6D8C=
D52@BN9PR11MB5276.namprd11.prod.outlook.com/


