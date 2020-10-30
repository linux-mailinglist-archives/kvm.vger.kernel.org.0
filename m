Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108FD29FDB5
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 07:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgJ3GNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 02:13:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:24952 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3GNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 02:13:45 -0400
IronPort-SDR: pvdlKMfIRYsx+1IYnLKuSUlkc3PYGfCscj1Kf2nEb6vGZyYhko4PUMXeA86cP9SoEKfNtchYu2
 7Y+MtcJWI7Gw==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="232745026"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="232745026"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 23:13:43 -0700
IronPort-SDR: Tnz2/dAXV9I+zAvE6W7yuuGtwX8n53y1FYX7no0QapXf0BETIwikR7WFGZWMrpb09bXFcJ9523
 k4in9BQNkyjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="304844532"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 29 Oct 2020 23:13:43 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Oct 2020 23:13:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Oct 2020 23:13:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Oct 2020 23:13:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 29 Oct 2020 23:13:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXJKFk4i+Zk/o5G4Kn/pHhBtNI2ed9a2ixA5wznonZf5oMcKIIja16+1g6C4lENMsLKaBELgJJI5UWTuY7upKjy0tmdyTUZJHJ6/7XDAAJQ8ODqEfBpLoGAUX66EvS8ZmTVPJOVvE5W9aCoWhq2irfSbT0vF463pSt73VWqpJYPHuTSRr/JopmaepXXOx93nNW2bMcDBKjVF+ebC47GStELtSiN7+JZLeaFi0q7/kthDSOP+9I4N9U7gtidy1utxUHLVXxh1BnL9LmQfqcDLNGjmxM3zp98G5/pFIitkH+cc/G0YX2oBBtZcIEFMsELD3Xc+TfkTQaDHRJgHsHbczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJH/VynuKMfvxifEQ+iVB23EtK0r5/gv7z50oE7Q2Xk=;
 b=e/XZVP2rc3acuF6qt8zi4v1OwLfUA/ByItEL1nDk0PKjwGodJS5iby9DWhx39CJjH34sG1aNjadGIZl9SaeSjx+QDWn6F5Kf+m1tG2Qyd+NNXsYv3wB9NIvMKH8aovzrkgwNr9x3peXsMI+OMcOK++6dk7NH1sQdzMsQCPOJp8OX67OgdshOxowe8BRjn1qAKbXVPDO4pnpWT9YucXBlc1zBwL8JnslJYrfobfpOmLgc/TNCRE61c+g+kzlMQIArUItPGm2BXUwvHJWQwC71mBx9KGUZgAz8IEumjX4C1EByowX41citaSxuWZKslRE1d665HuHm9mqSoEchzvijyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJH/VynuKMfvxifEQ+iVB23EtK0r5/gv7z50oE7Q2Xk=;
 b=zJ2lZhXIqc6qFGjn+sCy8KZuUYg8o8z6+ON/7DLonECnp7+A5ICjee66zD+DnTceVMvMWbESWuSNcwZLyoSfBfEA+eE3K8Mp+fcLbNIQaAg6bsTMC9dQV46EVn106EKZCQs+T4AX0uV86sFJckd84HrjqTEBrUfvuMSNFyFLqcY=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4730.namprd11.prod.outlook.com (2603:10b6:303:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Fri, 30 Oct
 2020 06:13:06 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b%8]) with mapi id 15.20.3477.034; Fri, 30 Oct 2020
 06:13:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: RE: [PATCH v6 4/5] iommu/vt-d: Add iommu_ops support for subdevice
 bus
Thread-Topic: [PATCH v6 4/5] iommu/vt-d: Add iommu_ops support for subdevice
 bus
Thread-Index: AQHWrnpPGYPR7Ur3ekaXVTIsMMRUx6mvpdRA
Date:   Fri, 30 Oct 2020 06:13:06 +0000
Message-ID: <MWHPR11MB1645F4F4D22E8FA12BDCFAE88C150@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
 <20201030045809.957927-5-baolu.lu@linux.intel.com>
In-Reply-To: <20201030045809.957927-5-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1eab4a8d-7bb5-4bf8-9463-08d87c9ade06
x-ms-traffictypediagnostic: MW3PR11MB4730:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47308170417764F7A1A1423A8C150@MW3PR11MB4730.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JUJQtkNYVSrmiKgQawI1c+5HXpV5YR4oBObthNWDStQtRimuVclqdtgnP7bC2Ses1bkBiv1gS9fh31FBXz/Xdf+mVqgKL5yFbk4PGKNVDDJpV9dFcAB1QlOwpxiIbhx67y0tw7/fVgAuJKtcXi4YKjU5svczYlLZkrexMW21NaNTrOfMX77Y+rwU65K/PCIOg2NS1zeFjE7CpMuXuj2PFq8n5V+3N6y4S3PuHmfRwshQOsXdRq2wWn81q4SMtFBvRLKQgYAWIR7BeSbAsPppsz0QyvaB7WmWnZyly3hqljeajSfoqQz2eHMgBhDwpe/sD23gsRlj1U4gNFvnO2FPww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(26005)(54906003)(316002)(478600001)(55016002)(186003)(71200400001)(86362001)(6506007)(83380400001)(2906002)(66476007)(66446008)(64756008)(8676002)(66556008)(110136005)(4326008)(33656002)(9686003)(7416002)(52536014)(8936002)(66946007)(76116006)(7696005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NcBR2yCOuWW4ToRbG3MdFfFTQj2rBpco4X7CiKcO8IzOmtKKl9UEO/h0qGiV6qVhRYx+sJuFjof8+ouh8JXuFJofyXgwFHrXBEmBFtpDnsucRg614/qOJFyTs/lERjUc1VpviFShKSC351QeIAH1merOgvpE/iQtMLO1zeocAwvCcKhVEmYUHruk5jceSANg9eLZ/eNKN/n2fMJUrrQkSVT6mV9VoZMaIWIq1wBhEjU39AKHCGR7FTKDd/ESwfO4clic78/xAvTm6BF11Xke9E9/ZrQ6CGW4PwqQBDWWiM13Vx7mSIlcGmF8lUAqOXHEGtqHpIG/5dQbIaCiFA72kHEllx3zND4QBQeZ87S1IcCvkrCPvk7ccqnt4Oq8vgQ9gRfCvF88wBpu1cWKKv7QCNo4FXC2r4w2q031COGtWOTVWTCkKDVXpJETk1ZPKPFLGak0LQkoPmYYIR9HOCrCdGFtRRntWl1ST/6MoAj/o4LLkxuG6lXGzq45M/mkdpNjnDXR2MmVVifSFLsgIWmfWryezApR75s++eU6nsd/y7nfRTxusaxtVngarpcxzT23K1UraKM3YifzQxaO9caUdtX5V6XHApfeIBpBxh7TIVwPyhhPa1j48qREfmmK2UdmLnYdoKU9NMv2IWcWERITNw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eab4a8d-7bb5-4bf8-9463-08d87c9ade06
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 06:13:06.3306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFEgeEKKKc01LZraS+tmcU73/9UqmmARIj7jR71WpPiXPzXOLE6buzP0AijZmqs0M7DAeq99dJwKHhRqpPmpmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4730
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, October 30, 2020 12:58 PM
>=20
> The iommu_ops will only take effect when INTEL_IOMMU_SCALABLE_IOV
> kernel
> option is selected. It applies to any device passthrough framework which
> implements an underlying bus for the subdevices.
>=20
> - Subdevice probe:
>   When a subdevice is created and added to the bus, iommu_probe_device()
>   will be called, where the device will be probed by the iommu core. An
>   iommu group will be allocated and the device will be added to it. The
>   default domain won't be allocated since there's no use case of using a
>   subdevice in the host kernel at this time being. However, it's pretty
>   easy to add this support later.
>=20
> - Domain alloc/free/map/unmap/iova_to_phys operations:
>   For such ops, we just reuse those for PCI/PCIe devices.

One question. Just be curious whether every IOMMU vendor supports
only one iommu_ops for all bus types. For Intel obviously the answer is
yes. But if a vendor supports bus-type specific iommu_ops for physical
devices, this may impose a restriction to VFIO or other passthrough=20
frameworks, because VFIO today maintains only one mdev bus while the=20
parent devices could come from different bus types. In the end the ops
for subdevice should be same as the one used for the parent. Then it may=20
require VFIO to organize subdevices based on parent bus types.=20

>=20
> - Domain attach/detach operations:
>   It depends on whether the parent device supports IOMMU_DEV_FEAT_AUX
>   feature. If so, the domain will be attached to the parent device as an
>   aux-domain; Otherwise, it will be attached to the parent as a primary
>   domain.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel/Kconfig  |  13 ++++
>  drivers/iommu/intel/Makefile |   1 +
>  drivers/iommu/intel/iommu.c  |   5 ++
>  drivers/iommu/intel/siov.c   | 119 +++++++++++++++++++++++++++++++++++
>  include/linux/intel-iommu.h  |   4 ++
>  5 files changed, 142 insertions(+)
>  create mode 100644 drivers/iommu/intel/siov.c
>=20
> diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
> index 28a3d1596c76..94edc332f558 100644
> --- a/drivers/iommu/intel/Kconfig
> +++ b/drivers/iommu/intel/Kconfig
> @@ -86,3 +86,16 @@ config INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON
>  	  is not selected, scalable mode support could also be enabled by
>  	  passing intel_iommu=3Dsm_on to the kernel. If not sure, please use
>  	  the default value.
> +
> +config INTEL_IOMMU_SCALABLE_IOV

INTEL_IOMMU_SUBDEVICE? if just talking from IOMMU p.o.v...

> +	bool "Support for Intel Scalable I/O Virtualization"
> +	depends on INTEL_IOMMU
> +	select VFIO
> +	select VFIO_MDEV
> +	select VFIO_MDEV_DEVICE
> +	help
> +	  Intel Scalable I/O virtualization (SIOV) is a hardware-assisted
> +	  PCIe subdevices virtualization. With each subdevice tagged with
> +	  an unique ID(PCI/PASID) the VT-d hardware could identify, hence
> +	  isolate DMA transactions from different subdevices on a same PCIe
> +	  device. Selecting this option will enable the support.
> diff --git a/drivers/iommu/intel/Makefile b/drivers/iommu/intel/Makefile
> index fb8e1e8c8029..f216385d5d59 100644
> --- a/drivers/iommu/intel/Makefile
> +++ b/drivers/iommu/intel/Makefile
> @@ -4,4 +4,5 @@ obj-$(CONFIG_INTEL_IOMMU) +=3D iommu.o pasid.o
>  obj-$(CONFIG_INTEL_IOMMU) +=3D trace.o
>  obj-$(CONFIG_INTEL_IOMMU_DEBUGFS) +=3D debugfs.o
>  obj-$(CONFIG_INTEL_IOMMU_SVM) +=3D svm.o
> +obj-$(CONFIG_INTEL_IOMMU_SCALABLE_IOV) +=3D siov.o
>  obj-$(CONFIG_IRQ_REMAP) +=3D irq_remapping.o
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 1454fe74f3ba..dafd8069c2af 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4298,6 +4298,11 @@ int __init intel_iommu_init(void)
>  	up_read(&dmar_global_lock);
>=20
>  	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
> +
> +#ifdef CONFIG_INTEL_IOMMU_SCALABLE_IOV
> +	intel_siov_init();
> +#endif /* CONFIG_INTEL_IOMMU_SCALABLE_IOV */
> +
>  	if (si_domain && !hw_pass_through)
>  		register_memory_notifier(&intel_iommu_memory_nb);
>  	cpuhp_setup_state(CPUHP_IOMMU_INTEL_DEAD,
> "iommu/intel:dead", NULL,
> diff --git a/drivers/iommu/intel/siov.c b/drivers/iommu/intel/siov.c
> new file mode 100644
> index 000000000000..b9470e7ab3d6
> --- /dev/null
> +++ b/drivers/iommu/intel/siov.c
> @@ -0,0 +1,119 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/**
> + * siov.c - Intel Scalable I/O virtualization support
> + *
> + * Copyright (C) 2020 Intel Corporation
> + *
> + * Author: Lu Baolu <baolu.lu@linux.intel.com>
> + */
> +
> +#define pr_fmt(fmt)	"DMAR: " fmt
> +
> +#include <linux/intel-iommu.h>
> +#include <linux/iommu.h>
> +#include <linux/mdev.h>
> +#include <linux/pci.h>
> +
> +static struct device *subdev_lookup_parent(struct device *dev)
> +{
> +	if (dev->bus =3D=3D &mdev_bus_type)
> +		return mdev_parent_dev(mdev_from_dev(dev));

What about finding the parent through device core? Then the logic
should work for all subdevice frameworks.

> +
> +	return NULL;
> +}
> +
> +static struct iommu_domain *siov_iommu_domain_alloc(unsigned int type)
> +{
> +	if (type !=3D IOMMU_DOMAIN_UNMANAGED)
> +		return NULL;
> +
> +	return intel_iommu_domain_alloc(type);
> +}
> +
> +static int siov_iommu_attach_device(struct iommu_domain *domain,
> +				    struct device *dev)
> +{
> +	struct device *parent;
> +
> +	parent =3D subdev_lookup_parent(dev);
> +	if (!parent || !dev_is_pci(parent))
> +		return -ENODEV;
> +
> +	if (iommu_dev_feature_enabled(parent, IOMMU_DEV_FEAT_AUX))
> +		return intel_iommu_aux_attach_device(domain, parent);
> +	else
> +		return intel_iommu_attach_device(domain, parent);

if subdevice then FEAT_AUX should be assumed true? otherwise why
do we use subdevice interface to attach domain to physical device?

Thanks
Kevin

> +}
> +
> +static void siov_iommu_detach_device(struct iommu_domain *domain,
> +				     struct device *dev)
> +{
> +	struct device *parent;
> +
> +	parent =3D subdev_lookup_parent(dev);
> +	if (WARN_ON_ONCE(!parent || !dev_is_pci(parent)))
> +		return;
> +
> +	if (iommu_dev_feature_enabled(parent, IOMMU_DEV_FEAT_AUX))
> +		intel_iommu_aux_detach_device(domain, parent);
> +	else
> +		intel_iommu_detach_device(domain, parent);
> +}
> +
> +static struct iommu_device *siov_iommu_probe_device(struct device *dev)
> +{
> +	struct intel_iommu *iommu;
> +	struct device *parent;
> +
> +	parent =3D subdev_lookup_parent(dev);
> +	if (!parent || !dev_is_pci(parent))
> +		return ERR_PTR(-EINVAL);
> +
> +	iommu =3D device_to_iommu(parent, NULL, NULL);
> +	if (!iommu)
> +		return ERR_PTR(-ENODEV);
> +
> +	return &iommu->iommu;
> +}
> +
> +static void siov_iommu_release_device(struct device *dev)
> +{
> +}
> +
> +static void
> +siov_iommu_get_resv_regions(struct device *dev, struct list_head *head)
> +{
> +	struct device *parent;
> +
> +	parent =3D subdev_lookup_parent(dev);
> +	if (!parent || !dev_is_pci(parent))
> +		return;
> +
> +	intel_iommu_get_resv_regions(parent, head);
> +}
> +
> +static const struct iommu_ops siov_iommu_ops =3D {
> +	.capable		=3D intel_iommu_capable,
> +	.domain_alloc		=3D siov_iommu_domain_alloc,
> +	.domain_free		=3D intel_iommu_domain_free,
> +	.attach_dev		=3D siov_iommu_attach_device,
> +	.detach_dev		=3D siov_iommu_detach_device,
> +	.map			=3D intel_iommu_map,
> +	.unmap			=3D intel_iommu_unmap,
> +	.iova_to_phys		=3D intel_iommu_iova_to_phys,
> +	.probe_device		=3D siov_iommu_probe_device,
> +	.release_device		=3D siov_iommu_release_device,
> +	.get_resv_regions	=3D siov_iommu_get_resv_regions,
> +	.put_resv_regions	=3D generic_iommu_put_resv_regions,
> +	.device_group		=3D generic_device_group,
> +	.pgsize_bitmap		=3D (~0xFFFUL),
> +};
> +
> +void intel_siov_init(void)
> +{
> +	if (!scalable_mode_support() || !iommu_pasid_support())
> +		return;
> +
> +	bus_set_iommu(&mdev_bus_type, &siov_iommu_ops);
> +	pr_info("Intel(R) Scalable I/O Virtualization supported\n");
> +}
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index d3928ba87986..b790efa5509f 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -787,6 +787,10 @@ size_t intel_iommu_unmap(struct iommu_domain
> *domain, unsigned long iova,
>  phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
> dma_addr_t iova);
>  void intel_iommu_get_resv_regions(struct device *device, struct list_hea=
d
> *head);
>=20
> +#ifdef CONFIG_INTEL_IOMMU_SCALABLE_IOV
> +void intel_siov_init(void);
> +#endif /* INTEL_IOMMU_SCALABLE_IOV */
> +
>  #ifdef CONFIG_INTEL_IOMMU_SVM
>  extern void intel_svm_check(struct intel_iommu *iommu);
>  extern int intel_svm_enable_prq(struct intel_iommu *iommu);
> --
> 2.25.1

