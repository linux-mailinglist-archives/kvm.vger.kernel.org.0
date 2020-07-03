Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7FB2133DF
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 08:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgGCGIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 02:08:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:41474 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgGCGIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 02:08:25 -0400
IronPort-SDR: n0a0pJo7Wv2OxBUQHOhVGxA6E52W3N4yq0cmbFEvqGBxUgjTt6RtT32Nk836bhlu5dvjIrX5rm
 ahinGRsjiqSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="126711695"
X-IronPort-AV: E=Sophos;i="5.75,307,1589266800"; 
   d="scan'208";a="126711695"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 23:08:24 -0700
IronPort-SDR: OW/CqDDMASl2uw27Mw4Iw2JpeldjfqX/G/QlPPSsEgkfWLmzSV2yHQnpGi4k8bH5Y6aU1UNN8o
 aXAiJiFCgWjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,307,1589266800"; 
   d="scan'208";a="482263822"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jul 2020 23:08:23 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jul 2020 23:08:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jul 2020 23:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4Za5t0rwFG1GXc/8nEIZR+9LqvXKqw7//m0sYYE+3wawxMahMU4K3OTb41h+TwjJxgJsV089maVOqDN5GhtTyVCIOKHMVi9cn1GZlQnvjkO4OMUCX3wy+BGDt+UOqCA1/U14H3SiXI1IWmPAz11mztgKq1YQh9QG7RgvEEj2hgPDtTPSl2Bg1cSTVgsA8NgV4nB4TAETe0Lh6N+e4eA1CVTER9rxTxxgZUATavLLXv3knd8KpEBZ96lht8yUFrxwdv1CoQVJavsnz+fK91/GEl1Zd1xbnAKmBDlcnQ4JTN/enVV93ihm2adrQZPWa23z3aqMg73iGZ6HIDHTCX1fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Io9C94QWiIgriNh7dlktteqyDXWO1jL9LP4JFl/erh0=;
 b=bQrgIJmjZHkWxT2BUmJ+zr640oJ0EM3dygI7p0Vn/kOneiViofR2QpRB5V6ucyDjKr2BGuy9pWsrYCPF+gjXKngOhqBzLvVTsHxKm1ShSWm9UtXzSVwXU2IDSRrRryehlmQI6Fpk7OuqCpY7kEKGh9hmvUlxTDkofR7xaSX3+lfOvfCkuK5/l0t71xcYLExbldr+UYbcC4ttTOFS6c8gKcszyPw2uX513hM7GF2TSEvxhxquMAX3pz7tgnEuGCkF1pWFMkCSLkh3Hu0Cz4xt8kVu0INyZVB232siAOn8M/XrL0Uomsyo5oj5T2FB3ojWuVfEl2+R8IBMBOwIPehkCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Io9C94QWiIgriNh7dlktteqyDXWO1jL9LP4JFl/erh0=;
 b=PRxWXl5ajrdjFb+HsEAx9ry1VS1g2rYMhwHEUMeCX2EygvNiVzsb4UjrMmgzdutRAr4fsCEaxhhu56MBkbATPGDm8EOlSMeN8YIBI9o8we17+KnvA3zzVDeIZErGTeevo6cFmoXgXARmdr/pOxS23lkicOTGGFkdD3xaO9+PN88=
Received: from CY4PR11MB1432.namprd11.prod.outlook.com (2603:10b6:910:5::22)
 by CY4PR11MB1784.namprd11.prod.outlook.com (2603:10b6:903:126::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Fri, 3 Jul
 2020 06:08:22 +0000
Received: from CY4PR11MB1432.namprd11.prod.outlook.com
 ([fe80::b46e:9dcb:b46b:884a]) by CY4PR11MB1432.namprd11.prod.outlook.com
 ([fe80::b46e:9dcb:b46b:884a%4]) with mapi id 15.20.3153.027; Fri, 3 Jul 2020
 06:08:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 04/14] vfio: Add PASID allocation/free support
Thread-Topic: [PATCH v3 04/14] vfio: Add PASID allocation/free support
Thread-Index: AQHWSgRR5bz4tOM/oUaIsA0C5MG6Daj02DkAgACTvOA=
Date:   Fri, 3 Jul 2020 06:08:21 +0000
Message-ID: <CY4PR11MB14328B2485B4A6FA5412D0D0C36A0@CY4PR11MB1432.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-5-git-send-email-yi.l.liu@intel.com>
 <20200702151702.1baa65cb@x1.home>
In-Reply-To: <20200702151702.1baa65cb@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c921a38e-d5c2-4954-8f00-08d81f177d4f
x-ms-traffictypediagnostic: CY4PR11MB1784:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB17845486D4D2E4308BB4B44EC36A0@CY4PR11MB1784.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ndxJGTU71xmKnF1I/nQhJoDmpyAHIz4j5LXr1fgAHdmHXhBVQO00OH4QNhdEftTD8Q2ab3L3xOQkCaZWmU4A6utlCiBKrhAQMmslKy00944Tjr2aImkZKPcE6L+ctQTTQIvz0/TavMAVHVJ1H0yAcB7v3EX8UqEimG5aGpADknT2/0CbOk7h7qfp/aOK7/vsLld1/VF0A5dQ1B4Z+8FUHCH8252Wxquq092LS1c6phlNjD8OzOF11Qj0rDa5HGNzV5Isat8eHvFqrfCdWoGsB5nqp3Y4RnHjc8I27+Rq7IgLbZ1wWD1uIq37UBZlp9DKbPgUBCIO0915xn4/gjbVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1432.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(55016002)(4326008)(33656002)(9686003)(186003)(316002)(66476007)(66556008)(64756008)(66446008)(54906003)(76116006)(66946007)(26005)(8676002)(83380400001)(6916009)(8936002)(7416002)(86362001)(5660300002)(6506007)(71200400001)(7696005)(478600001)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yLakeEzcL6EqdRlwNNqbaxtDUlk9LBIFYctH0pKSH8Br7g7oiCeMeFw1SF9TkCKuYF+qutXPNT4tjOPIqE2Y3vVWyAY48kNhR+enn0mfTab+DuYBxWbczqB0ME33/nCqmOVUVv7PATG/Lhzavxg489xRderN3eqp8BQI2bY5kyXlukr1TfRTMJiyAz3gjQpCxtLJG4kB8lo+yTK8oyMYlADnYZ8pb/fHhtRri5s2PEWixGRvii4xZGOc83pp5zVkgbZfde5jdH+vDgyYPsgsgu5kkIMiHzSLgpYbshFPE5fN0loDvPLf+BoQJ/9DEIS1WNozKbi2qELmuJJuByc/1rPyRrWRU7GPPFYDUlCp62n0F6d0LAW4kJstg/Fis3jyNhPUeikFGGO02OTBmYp1d0R3vvlvmasa9ewRybQyoc7CTADE2pCtu62vNU91wVnfxlFh0rLAwan6zJOP7yDdGiISTtYiHC0TNZHIPDwXlx1eudDXD0w4RLEFEDUjjSA9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1432.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c921a38e-d5c2-4954-8f00-08d81f177d4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 06:08:21.8040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lg4ROJlbblHXYopkqpbL8chNyxiJ7NERmw9NnLCTDZysFKb2fSVIH1Zxi+OqmneqyTODRRsq423BYcDH9BJHcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1784
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, July 3, 2020 5:17 AM
>=20
> On Wed, 24 Jun 2020 01:55:17 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > Shared Virtual Addressing (a.k.a Shared Virtual Memory) allows sharing
> > multiple process virtual address spaces with the device for simplified
> > programming model. PASID is used to tag an virtual address space in
> > DMA requests and to identify the related translation structure in
> > IOMMU. When a PASID-capable device is assigned to a VM, we want the
> > same capability of using PASID to tag guest process virtual address
> > spaces to achieve virtual SVA (vSVA).
> >
> > PASID management for guest is vendor specific. Some vendors (e.g.
> > Intel
> > VT-d) requires system-wide managed PASIDs cross all devices,
> > regardless of whether a device is used by host or assigned to guest.
> > Other vendors (e.g. ARM SMMU) may allow PASIDs managed per-device thus
> > could be fully delegated to the guest for assigned devices.
> >
> > For system-wide managed PASIDs, this patch introduces a vfio module to
> > handle explicit PASID alloc/free requests from guest. Allocated PASIDs
> > are associated to a process (or, mm_struct) in IOASID core. A vfio_mm
> > object is introduced to track mm_struct. Multiple VFIO containers
> > within a process share the same vfio_mm object.
> >
> > A quota mechanism is provided to prevent malicious user from
> > exhausting available PASIDs. Currently the quota is a global parameter
> > applied to all VFIO devices. In the future per-device quota might be su=
pported
> too.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> > v1 -> v2:
> > *) added in v2, split from the pasid alloc/free support of v1
> > ---
> >  drivers/vfio/Kconfig      |   5 ++
> >  drivers/vfio/Makefile     |   1 +
> >  drivers/vfio/vfio_pasid.c | 151
> ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h      |  28 +++++++++
> >  4 files changed, 185 insertions(+)
> >  create mode 100644 drivers/vfio/vfio_pasid.c
> >
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig index
> > fd17db9..3d8a108 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -19,6 +19,11 @@ config VFIO_VIRQFD
> >  	depends on VFIO && EVENTFD
> >  	default n
> >
> > +config VFIO_PASID
> > +	tristate
> > +	depends on IOASID && VFIO
> > +	default n
> > +
> >  menuconfig VFIO
> >  	tristate "VFIO Non-Privileged userspace driver framework"
> >  	depends on IOMMU_API
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile index
> > de67c47..bb836a3 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -3,6 +3,7 @@ vfio_virqfd-y :=3D virqfd.o
> >
> >  obj-$(CONFIG_VFIO) +=3D vfio.o
> >  obj-$(CONFIG_VFIO_VIRQFD) +=3D vfio_virqfd.o
> > +obj-$(CONFIG_VFIO_PASID) +=3D vfio_pasid.o
> >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) +=3D vfio_iommu_type1.o
> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) +=3D vfio_iommu_spapr_tce.o
> >  obj-$(CONFIG_VFIO_SPAPR_EEH) +=3D vfio_spapr_eeh.o diff --git
> > a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c new file mode
> > 100644 index 0000000..dd5b6d1
> > --- /dev/null
> > +++ b/drivers/vfio/vfio_pasid.c
> > @@ -0,0 +1,151 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2020 Intel Corporation.
> > + *     Author: Liu Yi L <yi.l.liu@intel.com>
> > + *
> > + */
> > +
> > +#include <linux/vfio.h>
> > +#include <linux/eventfd.h>
> > +#include <linux/file.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/sched/mm.h>
> > +
> > +#define DRIVER_VERSION  "0.1"
> > +#define DRIVER_AUTHOR   "Liu Yi L <yi.l.liu@intel.com>"
> > +#define DRIVER_DESC     "PASID management for VFIO bus drivers"
> > +
> > +#define VFIO_DEFAULT_PASID_QUOTA	1000
> > +static int pasid_quota =3D VFIO_DEFAULT_PASID_QUOTA;
> > +module_param_named(pasid_quota, pasid_quota, uint, 0444);
> > +MODULE_PARM_DESC(pasid_quota,
> > +		 " Set the quota for max number of PASIDs that an application is
> > +allowed to request (default 1000)");
> > +
> > +struct vfio_mm_token {
> > +	unsigned long long val;
> > +};
> > +
> > +struct vfio_mm {
> > +	struct kref		kref;
> > +	struct vfio_mm_token	token;
> > +	int			ioasid_sid;
> > +	int			pasid_quota;
> > +	struct list_head	next;
> > +};
> > +
> > +static struct vfio_pasid {
> > +	struct mutex		vfio_mm_lock;
> > +	struct list_head	vfio_mm_list;
> > +} vfio_pasid;
> > +
> > +/* called with vfio.vfio_mm_lock held */ static void
> > +vfio_mm_release(struct kref *kref) {
> > +	struct vfio_mm *vmm =3D container_of(kref, struct vfio_mm, kref);
> > +
> > +	list_del(&vmm->next);
> > +	mutex_unlock(&vfio_pasid.vfio_mm_lock);
> > +	ioasid_free_set(vmm->ioasid_sid, true);
> > +	kfree(vmm);
> > +}
> > +
> > +void vfio_mm_put(struct vfio_mm *vmm) {
> > +	kref_put_mutex(&vmm->kref, vfio_mm_release,
> > +&vfio_pasid.vfio_mm_lock); }
> > +
> > +static void vfio_mm_get(struct vfio_mm *vmm) {
> > +	kref_get(&vmm->kref);
> > +}
> > +
> > +struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task) {
> > +	struct mm_struct *mm =3D get_task_mm(task);
> > +	struct vfio_mm *vmm;
> > +	unsigned long long val =3D (unsigned long long) mm;
> > +	int ret;
> > +
> > +	mutex_lock(&vfio_pasid.vfio_mm_lock);
> > +	/* Search existing vfio_mm with current mm pointer */
> > +	list_for_each_entry(vmm, &vfio_pasid.vfio_mm_list, next) {
> > +		if (vmm->token.val =3D=3D val) {
> > +			vfio_mm_get(vmm);
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	vmm =3D kzalloc(sizeof(*vmm), GFP_KERNEL);
> > +	if (!vmm)
> > +		return ERR_PTR(-ENOMEM);
>=20
> lock leaked, mm leaked.

oh, yes. silly mistake.

> > +
> > +	/*
> > +	 * IOASID core provides a 'IOASID set' concept to track all
> > +	 * PASIDs associated with a token. Here we use mm_struct as
> > +	 * the token and create a IOASID set per mm_struct. All the
> > +	 * containers of the process share the same IOASID set.
> > +	 */
> > +	ret =3D ioasid_alloc_set((struct ioasid_set *) mm, pasid_quota,
> > +			       &vmm->ioasid_sid);
> > +	if (ret) {
> > +		kfree(vmm);
> > +		return ERR_PTR(ret);
>=20
> lock leaked, mm leaked.

got it.

> > +	}
> > +
> > +	kref_init(&vmm->kref);
> > +	vmm->token.val =3D (unsigned long long) mm;
>=20
> We already have it in @val.

yep, let me use val directly.

> > +	vmm->pasid_quota =3D pasid_quota;
>=20
> This field on the structure and this assignment seems to serve no purpose=
.

yeah, it's used in prior version. let me drop it. if we still want it, may =
add
later.

> Thanks,
>=20
> Alex
>=20
> > +
> > +	list_add(&vmm->next, &vfio_pasid.vfio_mm_list);
> > +out:
> > +	mutex_unlock(&vfio_pasid.vfio_mm_lock);
> > +	mmput(mm);
> > +	return vmm;
> > +}
> > +
> > +int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max) {
> > +	ioasid_t pasid;
> > +
> > +	pasid =3D ioasid_alloc(vmm->ioasid_sid, min, max, NULL);
> > +
> > +	return (pasid =3D=3D INVALID_IOASID) ? -ENOSPC : pasid; }
> > +
> > +void vfio_pasid_free_range(struct vfio_mm *vmm,
> > +			    ioasid_t min, ioasid_t max)
> > +{
> > +	ioasid_t pasid =3D min;
> > +
> > +	if (min > max)
> > +		return;
> > +
> > +	/*
> > +	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
> > +	 * teardown necessary structures depending on the to-be-freed
> > +	 * PASID.
> > +	 */
> > +	for (; pasid <=3D max; pasid++)
> > +		ioasid_free(pasid);
> > +}
> > +
> > +static int __init vfio_pasid_init(void) {
> > +	mutex_init(&vfio_pasid.vfio_mm_lock);
> > +	INIT_LIST_HEAD(&vfio_pasid.vfio_mm_list);
> > +	return 0;
> > +}
> > +
> > +static void __exit vfio_pasid_exit(void) {
> > +	WARN_ON(!list_empty(&vfio_pasid.vfio_mm_list));
> > +}
> > +
> > +module_init(vfio_pasid_init);
> > +module_exit(vfio_pasid_exit);
> > +
> > +MODULE_VERSION(DRIVER_VERSION);
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR(DRIVER_AUTHOR);
> > +MODULE_DESCRIPTION(DRIVER_DESC);
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h index
> > 38d3c6a..74e077d 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -97,6 +97,34 @@ extern int vfio_register_iommu_driver(const struct
> > vfio_iommu_driver_ops *ops);  extern void vfio_unregister_iommu_driver(
> >  				const struct vfio_iommu_driver_ops *ops);
> >
> > +struct vfio_mm;
> > +#if IS_ENABLED(CONFIG_VFIO_PASID)
> > +extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct
> > +*task); extern void vfio_mm_put(struct vfio_mm *vmm); extern int
> > +vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max); extern void
> > +vfio_pasid_free_range(struct vfio_mm *vmm,
> > +					ioasid_t min, ioasid_t max);
> > +#else
> > +static inline struct vfio_mm *vfio_mm_get_from_task(struct
> > +task_struct *task) {
> > +	return NULL;
> > +}
> > +
> > +static inline void vfio_mm_put(struct vfio_mm *vmm) { }
> > +
> > +static inline int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int
> > +max) {
> > +	return -ENOTTY;
> > +}
> > +
> > +static inline void vfio_pasid_free_range(struct vfio_mm *vmm,
> > +					  ioasid_t min, ioasid_t max)
> > +{
> > +}
> > +#endif /* CONFIG_VFIO_PASID */
> > +
> >  /*
> >   * External user API
> >   */

