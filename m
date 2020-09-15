Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BD2269CD6
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 06:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgIOEEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 00:04:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:56416 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgIOEEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 00:04:04 -0400
IronPort-SDR: qHhM38n3iOgj4xkd1FoRXs+4IHimTL3sLx//XKOmUu7MmVYN3kaHh3xUZTa1S1OxeSGNSM26gg
 UzGF40gggwDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160130403"
X-IronPort-AV: E=Sophos;i="5.76,428,1592895600"; 
   d="scan'208";a="160130403"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 21:03:57 -0700
IronPort-SDR: N68WyKpP1S+6SMmpI3/7kE+7329CPm1Fn2wWpGVFJZaPj2sMoA1DcAfqWoVM3/36053+A0aMQY
 XEmiSsztIr/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,428,1592895600"; 
   d="scan'208";a="301984634"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 14 Sep 2020 21:03:57 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Sep 2020 21:03:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 14 Sep 2020 21:03:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 14 Sep 2020 21:03:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXYfCtEIC0MkXGRthz+Wz7DSIkIHLHHfvEr8IdQT3oH01EpqRRuWPjkPdf2UMx4zNnqxiCC6sC2BNCIOWxMroZoLOSxEM4xXnuMC54hMqmBLihhG9NkbOBqSMCcZy8S/kNhZX27rOO7Kgdh0px2dNPfjJNjge+WejM2JuA0/OJdxyjNdOe/qmHAUtmq/QzQOyACYhshsF0LfwUWwf0PqZECa+ZqaV7CISt4ChfwzU5vMx6PMUtldGVAT0pNHxhjX4u559UNamSjmffsSe7WV7QWf1onPm4sszsYeA9iNzCOs2c1+KfNmbsDonz0fEBt7iLJlMXIQBDPcIhQq65oq/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONsjymOuCtCjWqEdW5soiOcSDuCt2ci3T8KM7kPtHVk=;
 b=iN0WzL/Y35n5Fpw3gyGCKIkSOAPmw/QvccQq3lau6ap8uay5WIsaWGXrenB6O7jNZbhiMPlLSE746T9yXLYove/M8hayquU7qUd4k1UNg5Rttx7csKpky99XoJY2+Nnfh6v9/q7kyt/KCSoKs+wxNydHnIbyBdQ0HsOVCfPytzOIAfyPS7Xw31Z6U9p4Xi327ZH86qXRFbPEEadZ4QEMfkXRhLCfsvVMiromMKPQOUeVJMgGZNnVHV5BhGag8Zgcx25yDRtyd+RZI/lgkIw2k1rAzzDc2nRF0oCL4RJrWQUrDLUjjyafVe6IxDAWMSmfMkg3xuRpJekG1F7i1gOrLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONsjymOuCtCjWqEdW5soiOcSDuCt2ci3T8KM7kPtHVk=;
 b=E5Go+IcHxAxSzovVhUWWhL7qmQFPSpGs5nserUZgUrnDMl5r/owD3Ja73xgzD5OP1ylp19oOBCLWFliksbBZ/Ohk6ongzH03NPa/TKAqE4s4lmxKCzItWyToRBhE4RnhXI+OKuhfhhtMxoCFMjeL/f4ha3cQqYO7t4iKMn61Ftk=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4724.namprd11.prod.outlook.com (2603:10b6:5:2ad::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Tue, 15 Sep 2020 04:03:42 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::7053:1185:558b:bc54]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::7053:1185:558b:bc54%9]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 04:03:42 +0000
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
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v7 04/16] vfio: Add PASID allocation/free support
Thread-Topic: [PATCH v7 04/16] vfio: Add PASID allocation/free support
Thread-Index: AQHWh19AsDEpgfBP2kiay/8zOXeWXKlj7NEAgACdb2A=
Date:   Tue, 15 Sep 2020 04:03:42 +0000
Message-ID: <DM5PR11MB1435BBD7E2CBAA80F768B7D5C3200@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <1599734733-6431-5-git-send-email-yi.l.liu@intel.com>
 <20200911145446.2f9f5eb8@w520.home>
In-Reply-To: <20200911145446.2f9f5eb8@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [114.244.141.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a5eb633-5e6d-4f8c-c98d-08d8592c55fb
x-ms-traffictypediagnostic: DM6PR11MB4724:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB47240CAF922FCA9D635A5A49C3200@DM6PR11MB4724.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2wXatWux+zwnE2WZkc+3vl8uM8WuWkU0ApndKXOMgKmKpXq2oHzOCXtU2tnxQnbSLPYpbunxvqdqVB7OYKROe74J1umFiB8LTF6+HzRn1GphkE/M+qz8wzfUsrnZ5TIIO2B/lGwysQtUl9/H1FU+KDzRp1592knXp2gtPrY/+eNU9xgudUvWG/AOErBR4cQb6V8FLQpEcJppXaiX0jogcxcmBOHW1cO9XTUQTppFBL/IaH6eH+mLQS2dXDaE1leseDbBRfS2KIxACdaTPVkLfmOm9EKD9Fn2U/F3k5fTcNys/6J6AqGyovT7ywDm+1MbeQ6mi0Z1vD/1QfbKo+1suupJRQim2UK3H3zwOmfFszuEvrqVzShXiqRK6+XCIxYFYIp0Mo2i0ExXWSXHIAiZLqvuvex09QtJecZSqiyWmr+WBaQBVlm2eof1swXJ7Lkh4FRYStBy1zut4STe/2n95w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(4326008)(7416002)(186003)(52536014)(54906003)(26005)(8676002)(30864003)(5660300002)(966005)(316002)(6506007)(66446008)(2906002)(83380400001)(71200400001)(9686003)(7696005)(64756008)(66556008)(66946007)(8936002)(55016002)(33656002)(66476007)(86362001)(6916009)(478600001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ovil/2JugQnmttG6vTS+/7RhJ27e0zNogrnMOga3jOjeoXdVDCTmmLs6Q7vqXMOXskKnLehjjXuT/RgMza/jJFW7fWrKt5a8GwBEuhg32JryssisJbTL4HcUjxdX6vYgDgcdPTpFUU7nksWplvYwmZKDYJIo3qrwPPArjQIsxBWEepA56l1+/ifuTddljHzJm4J/mWaNXzoiUl505ej7TwqG2RDXIr+rrtHWaI4nhuZbDbsrtWwUXvtkEw4IbgWIvUt+FePYRzHXOuigAYvpPBR3Qd22PMIK69Wp1HbLDJ5BYyiFvwHhlkTs4hATQMPtyZrEmNkHdbZQ1UdMK4FRKIPxdre114TWsyu27saXS+NdrRDVtBW+j/Aa2/DipYqHDDkqiH6sbT02fYTeTzuMMc9/lDwflXyYCqBJex4IUHbuntAul4i+lxDtfmhq25fpyqARpLqJrFaUtoPLVsomf5MMLY9K5wUKANOS5yjmV2nUafhMcv6k869KKXbyKBn4tA8C6RvS4AiHlRETtASkOE9uegaYydnWDffTNrIDqRIZzX5vzQ5NP+961HldKnIfij9ePTJoNzGFgg9BDWeezSdWh7prepg9NPyM0oAwl52XETPgYyS8ap0VXhW1MRcarnFfow3kvfBncAymjMDV/A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5eb633-5e6d-4f8c-c98d-08d8592c55fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2020 04:03:42.7033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BTuE2z/bMjb4x4svT2vANkDb0KBoZQcgVkuvxgSm96+HzwrHD0veve8AHOZsQA+3tffaFOMlM9PAHsCONuUITw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4724
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, September 12, 2020 4:55 AM
>=20
> On Thu, 10 Sep 2020 03:45:21 -0700
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
> > VT-d) requires system-wide managed PASIDs across all devices,
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
pported too.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > ---
> > v6 -> v7:
> > *) remove "#include <linux/eventfd.h>" and add r-b from Eric Auger.
> >
> > v5 -> v6:
> > *) address comments from Eric. Add vfio_unlink_pasid() to be consistent
> >    with vfio_unlink_dma(). Add a comment in vfio_pasid_exit().
> >
> > v4 -> v5:
> > *) address comments from Eric Auger.
> > *) address the comments from Alex on the pasid free range support. Adde=
d
> >    per vfio_mm pasid r-b tree.
> >    https://lore.kernel.org/kvm/20200709082751.320742ab@x1.home/
> >
> > v3 -> v4:
> > *) fix lock leam in vfio_mm_get_from_task()
> > *) drop pasid_quota field in struct vfio_mm
> > *) vfio_mm_get_from_task() returns ERR_PTR(-ENOTTY) when
> > !CONFIG_VFIO_PASID
> >
> > v1 -> v2:
> > *) added in v2, split from the pasid alloc/free support of v1
> > ---
> >  drivers/vfio/Kconfig      |   5 +
> >  drivers/vfio/Makefile     |   1 +
> >  drivers/vfio/vfio_pasid.c | 247
> ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h      |  28 ++++++
> >  4 files changed, 281 insertions(+)
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
> > 100644 index 0000000..44ecdd5
> > --- /dev/null
> > +++ b/drivers/vfio/vfio_pasid.c
> > @@ -0,0 +1,247 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2020 Intel Corporation.
> > + *     Author: Liu Yi L <yi.l.liu@intel.com>
> > + *
> > + */
> > +
> > +#include <linux/vfio.h>
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
>=20
> I'm not sure we really need a macro to define this since it's only used o=
nce, but a
> comment discussing the basis for this default value would be useful.

yep, may remove the macro. 1000 is actually a value come from an offline
discussion with Jacob. And was first mentioned in below link. Since we
don't have much data to decide a default quota today, so we'd like to
make 1000 be default quota as a start. In future we would give administrato=
r
the ability to tune the quota.

https://lore.kernel.org/kvm/A2975661238FB949B60364EF0F2C25743A0F8CB4@SHSMSX=
104.ccr.corp.intel.com/

> Also, since
> Matthew Rosato is finding it necessary to expose the available DMA mappin=
g
> counter to userspace, is this also a limitation that userspace might be
> interested in knowing such that we should plumb it through an IOMMU info
> capability?

agreed. it would be helpful. I'll add it.

> > +static int pasid_quota =3D VFIO_DEFAULT_PASID_QUOTA;
> > +module_param_named(pasid_quota, pasid_quota, uint, 0444);
> > +MODULE_PARM_DESC(pasid_quota,
> > +		 "Set the quota for max number of PASIDs that an application is
> > +allowed to request (default 1000)");
> > +
> > +struct vfio_mm_token {
> > +	unsigned long long val;
> > +};
> > +
> > +struct vfio_mm {
> > +	struct kref		kref;
> > +	struct ioasid_set	*ioasid_set;
> > +	struct mutex		pasid_lock;
> > +	struct rb_root		pasid_list;
> > +	struct list_head	next;
> > +	struct vfio_mm_token	token;
> > +};
> > +
> > +static struct mutex		vfio_mm_lock;
> > +static struct list_head		vfio_mm_list;
> > +
> > +struct vfio_pasid {
> > +	struct rb_node		node;
> > +	ioasid_t		pasid;
> > +};
> > +
> > +static void vfio_remove_all_pasids(struct vfio_mm *vmm);
> > +
> > +/* called with vfio.vfio_mm_lock held */
>=20
>=20
> s/vfio.//

got it. thanks for spotting it.

>=20
>=20
> > +static void vfio_mm_release(struct kref *kref) {
> > +	struct vfio_mm *vmm =3D container_of(kref, struct vfio_mm, kref);
> > +
> > +	list_del(&vmm->next);
> > +	mutex_unlock(&vfio_mm_lock);
> > +	vfio_remove_all_pasids(vmm);
> > +	ioasid_set_put(vmm->ioasid_set);//FIXME: should vfio_pasid get ioasid=
_set
> after allocation?
>=20
>=20
> Is the question whether each pasid should hold a reference to the set?

no, I was considering whether vfio_pasid needs to hold a reference on
the ioasid_set. But after checking ioasid_alloc_set(), the answer is
"no" since a successful ioasid_alloc_set() calling will atomically
increase the refcnt of the returned set. So no need to take another
reference in vfio_pasid.

> That really seems like a question internal to the ioasid_alloc/free, but
> this FIXME needs to be resolved.

I should have removed it before sending it out. sorry for the confusion. :-=
(

>=20
>=20
> > +	kfree(vmm);
> > +}
> > +
> > +void vfio_mm_put(struct vfio_mm *vmm) {
> > +	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_mm_lock); }
> > +
> > +static void vfio_mm_get(struct vfio_mm *vmm) {
> > +	kref_get(&vmm->kref);
> > +}
> > +
> > +struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task) {
> > +	struct mm_struct *mm =3D get_task_mm(task);
> > +	struct vfio_mm *vmm;
> > +	unsigned long long val =3D (unsigned long long)mm;
> > +	int ret;
> > +
> > +	mutex_lock(&vfio_mm_lock);
> > +	/* Search existing vfio_mm with current mm pointer */
> > +	list_for_each_entry(vmm, &vfio_mm_list, next) {
> > +		if (vmm->token.val =3D=3D val) {
> > +			vfio_mm_get(vmm);
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	vmm =3D kzalloc(sizeof(*vmm), GFP_KERNEL);
> > +	if (!vmm) {
> > +		vmm =3D ERR_PTR(-ENOMEM);
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * IOASID core provides a 'IOASID set' concept to track all
> > +	 * PASIDs associated with a token. Here we use mm_struct as
> > +	 * the token and create a IOASID set per mm_struct. All the
> > +	 * containers of the process share the same IOASID set.
> > +	 */
> > +	vmm->ioasid_set =3D ioasid_alloc_set(mm, pasid_quota,
> IOASID_SET_TYPE_MM);
> > +	if (IS_ERR(vmm->ioasid_set)) {
> > +		ret =3D PTR_ERR(vmm->ioasid_set);
> > +		kfree(vmm);
> > +		vmm =3D ERR_PTR(ret);
> > +		goto out;
>=20
> This would be a little less convoluted if we had a separate variable to s=
tore
> ioasid_set so that we could free vmm without stashing the error in a temp=
orary
> variable.  Or at least make the stash more obvious by defining the stash =
variable as
> something like "tmp" within the scope of this branch.

I see. also the "ret" is not necessary as only used only once. so it would
be like below:

tmp =3D ioasid_alloc_set(mm, pasid_quota, IOASID_SET_TYPE_MM);
if (IS_ERR(tmp)) {
	kfree(vmm);
	vmm =3D ERR_PTR(ret);
	goto out;
}

> > +	}
> > +
> > +	kref_init(&vmm->kref);
> > +	vmm->token.val =3D val;
> > +	mutex_init(&vmm->pasid_lock);
> > +	vmm->pasid_list =3D RB_ROOT;
> > +
> > +	list_add(&vmm->next, &vfio_mm_list);
> > +out:
> > +	mutex_unlock(&vfio_mm_lock);
> > +	mmput(mm);
> > +	return vmm;
> > +}
> > +
> > +/*
> > + * Find PASID within @min and @max
> > + */
> > +static struct vfio_pasid *vfio_find_pasid(struct vfio_mm *vmm,
> > +					  ioasid_t min, ioasid_t max)
> > +{
> > +	struct rb_node *node =3D vmm->pasid_list.rb_node;
> > +
> > +	while (node) {
> > +		struct vfio_pasid *vid =3D rb_entry(node,
> > +						struct vfio_pasid, node);
> > +
> > +		if (max < vid->pasid)
> > +			node =3D node->rb_left;
> > +		else if (min > vid->pasid)
> > +			node =3D node->rb_right;
> > +		else
> > +			return vid;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static void vfio_link_pasid(struct vfio_mm *vmm, struct vfio_pasid
> > +*new) {
> > +	struct rb_node **link =3D &vmm->pasid_list.rb_node, *parent =3D NULL;
> > +	struct vfio_pasid *vid;
> > +
> > +	while (*link) {
> > +		parent =3D *link;
> > +		vid =3D rb_entry(parent, struct vfio_pasid, node);
> > +
> > +		if (new->pasid <=3D vid->pasid)
> > +			link =3D &(*link)->rb_left;
> > +		else
> > +			link =3D &(*link)->rb_right;
> > +	}
> > +
> > +	rb_link_node(&new->node, parent, link);
> > +	rb_insert_color(&new->node, &vmm->pasid_list); }
> > +
> > +static void vfio_unlink_pasid(struct vfio_mm *vmm, struct vfio_pasid
> > +*old) {
> > +	rb_erase(&old->node, &vmm->pasid_list); }
> > +
> > +static void vfio_remove_pasid(struct vfio_mm *vmm, struct vfio_pasid
> > +*vid) {
> > +	vfio_unlink_pasid(vmm, vid);
> > +	ioasid_free(vmm->ioasid_set, vid->pasid);
> > +	kfree(vid);
> > +}
> > +
> > +static void vfio_remove_all_pasids(struct vfio_mm *vmm) {
> > +	struct rb_node *node;
> > +
> > +	mutex_lock(&vmm->pasid_lock);
> > +	while ((node =3D rb_first(&vmm->pasid_list)))
> > +		vfio_remove_pasid(vmm, rb_entry(node, struct vfio_pasid, node));
> > +	mutex_unlock(&vmm->pasid_lock);
> > +}
> > +
> > +int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
>=20
> I might have asked before, but why doesn't this return an ioasid_t and re=
quire
> ioasid_t args?  Our free function below uses an ioasid_t range, seems rat=
her
> inconsistent.=20

yep, will fix it.

> We can use a BUILD_BUG_ON if we need to test that an ioasid_t fits
> within our uapi.

perhaps not. vfio_pasid_alloc() should return INVALID_IOASID for allocation
failure. vfio_iommu_type1 should check the return value of vfio_pasid_alloc=
()
and return a proper result to userspace.

>=20
> > +{
> > +	ioasid_t pasid;
> > +	struct vfio_pasid *vid;
> > +
> > +	pasid =3D ioasid_alloc(vmm->ioasid_set, min, max, NULL);
> > +	if (pasid =3D=3D INVALID_IOASID)
> > +		return -ENOSPC;
> > +
> > +	vid =3D kzalloc(sizeof(*vid), GFP_KERNEL);
> > +	if (!vid) {
> > +		ioasid_free(vmm->ioasid_set, pasid);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	vid->pasid =3D pasid;
> > +
> > +	mutex_lock(&vmm->pasid_lock);
> > +	vfio_link_pasid(vmm, vid);
> > +	mutex_unlock(&vmm->pasid_lock);
> > +
> > +	return pasid;
> > +}
> > +
> > +void vfio_pasid_free_range(struct vfio_mm *vmm,
> > +			   ioasid_t min, ioasid_t max)
> > +{
> > +	struct vfio_pasid *vid =3D NULL;
> > +
> > +	/*
> > +	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
> > +	 * teardown necessary structures depending on the to-be-freed
> > +	 * PASID.
> > +	 */
> > +	mutex_lock(&vmm->pasid_lock);
> > +	while ((vid =3D vfio_find_pasid(vmm, min, max)) !=3D NULL)
>=20
> !=3D NULL is not necessary and isn't consistent with the same time of tes=
t in the above
> rb_first() loop.

got it. thanks for the guiding.

>=20
> > +		vfio_remove_pasid(vmm, vid);
> > +	mutex_unlock(&vmm->pasid_lock);
> > +}
> > +
> > +static int __init vfio_pasid_init(void) {
> > +	mutex_init(&vfio_mm_lock);
> > +	INIT_LIST_HEAD(&vfio_mm_list);
> > +	return 0;
> > +}
> > +
> > +static void __exit vfio_pasid_exit(void) {
> > +	/*
> > +	 * VFIO_PASID is supposed to be referenced by VFIO_IOMMU_TYPE1
> > +	 * and may be other module. once vfio_pasid_exit() is triggered,
> > +	 * that means its user (e.g. VFIO_IOMMU_TYPE1) has been removed.
> > +	 * All the vfio_mm instances should have been released. If not,
> > +	 * means there is vfio_mm leak, should be a bug of user module.
> > +	 * So just warn here.
> > +	 */
> > +	WARN_ON(!list_empty(&vfio_mm_list));
>=20
> Do we need to be using try_module_get/module_put to enforce that we canno=
t be
> removed while in use or does that already work correctly via the function=
 references
> and this is just paranoia?  If we do exit, I'm not sure what good it does=
 to keep the
> remaining list entries.  Thanks,

I did a test before, and it's true the module dependency is enforced
via function references and cannot remove a module before removing
other modules which have referred its function. BTW., for the WARN_ON,
I referred the handling against vfio.group_list in vfio_cleanup(). :-)

Regards,
Yi Liu

> Alex
>=20
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
> > 38d3c6a..31472a9 100644
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
> > +				  ioasid_t min, ioasid_t max);
> > +#else
> > +static inline struct vfio_mm *vfio_mm_get_from_task(struct
> > +task_struct *task) {
> > +	return ERR_PTR(-ENOTTY);
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

