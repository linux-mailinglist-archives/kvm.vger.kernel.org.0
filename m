Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB17B4191B9
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 11:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhI0Jok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 05:44:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:30718 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233587AbhI0Joj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 05:44:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10119"; a="221242947"
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="221242947"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 02:43:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="519989437"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga001.jf.intel.com with ESMTP; 27 Sep 2021 02:43:01 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 02:43:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 27 Sep 2021 02:43:00 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 27 Sep 2021 02:43:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lf+jtF1UtSTGZ9zKdIOTP39pdjoJlY2s90REtFICudkw2ib7QWeElpvN0zG/m+E07w6OnFIAytm+roi7WcHEy5w1Wlczv5AqICjNnpmicape83/mi0gAywsOlg4AiJ4Dx8APBQRsnqtSVaOycDUxiv8A/FkJ/WXefRYmvo+WFj3n4ZfyO+iJGrqqIWcVqXfXPT6a1I1K7Tzie4DZlov3y3PWTxu0JZJhK+mzPYSWs6BAij7trFTgNsjYmvR5joUZ8tQdOusaLoblIuHuqz7BhVygVRO52B7gzfeQieUYoT9uM1kD01djQbwPQmpPWygy57kT77o8vRstZyMTnsY1Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UNX6zGy85kL2txgjK3VV4F2yys2Dt32HSkSudgw+OF8=;
 b=SdCNdG81e1Pf2NT0NrRYFzz4C4O/vYklkEFzXTgni8vxHS8bLvW80NHLRAcSl4eo/yBwpqtZct4OcmBHaqMTAyHN52NqAygFNQlmqvZgSoPxuL4dNb5BEHzgg9XJOkWb5vpV/nScHcnqhkiWJ5eQgSWQGHEOACti6zf+J9Cn01y6xrnbXngi2LfASd5Dzw0sdhDlSbY+OkdmfjZx/VvK79CWOYTTvpodFUy2tjzMvAmKOW4O4FeQQWT4gDE2oN2EKpPN5lx1jTHkJKP8n8QrvQbGFtxdgkFBzPRwOzWfd7rffZ4TTaIL6lx0H50Al+tQCdbpK0Avy7LSn5ei3o747g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNX6zGy85kL2txgjK3VV4F2yys2Dt32HSkSudgw+OF8=;
 b=uFmsaGWBHhzqH6AjIRgHcnlUMeVVTdwXI1R2nnlGMytyF80FP4CgVzulzPOgKPTrtebEVLWzbuU+Omb6dAnVLSoC6WcUA0L3cKIdYitykOagip0ynvA37NEDUO03Mff15vo5krw4rqEY48Z5FIZ6b0bXcZ6Awo1wlwqL2gD5o6w=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2339.namprd11.prod.outlook.com (2603:10b6:404:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 09:42:58 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 09:42:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYA
Date:   Mon, 27 Sep 2021 09:42:58 +0000
Message-ID: <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
In-Reply-To: <20210922123931.GI327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18e613b0-24a8-4bf3-88d8-08d9819b30d4
x-ms-traffictypediagnostic: BN6PR1101MB2339:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2339AFB30DF93F1FC17D66D18CA79@BN6PR1101MB2339.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sd7F3woEPpgJcZGi9VjSmpSW8xFZS7D4aSiyMOmxgvU1/Ui0F9AsxNcsBBWWis88aPReupmAnh29MC3dnA35Z06beeKD25+69yCy1v7r227Ea3qCe9ORApqTyPsooJTQ86SO8im2rsC2OMmc3hVWCWXDVHjim3d9UlaIlf0uy2TkjIX7VIVcebm6xaiZc4xIYgbirmnQEN6GC7I8zz8R0/NxvIMklSblvT0HYLqltaUVmD1MyIA85RNFq1q1v0P8++J1QAQvR3vclQYcIhA18cRn8Y79BrTpIp36MYMwgUODC/viKDVtMrP1WQ9EseUwbCN24ot53g50IR7vBVViRPWQsjGloyhJZCgedleB1LKGU9JZnuC7Vt8yl0DcjLQ2NqXGzRqbqcjbZJXUOGF62haJXuP53KPZf8Yx5A9mUp0PTcZJExSl4n6f/maenMGLCaqVIZVquUvae3quVO+ECrrcNh0/RWq+IWxFUkcPGjmCvaSX62YLVt2i6P0uC3zzIrnpXpCAHcCWFmBvVZZwOS0ie3yDH2Y6ceVqav86fPu1r8I3108e2esAGBkEMJLveoiel3+J4Ub9toBPyHqqg3Z8+WJk350G3inz/DAKb6DoUzvRCjX8rSC1OcUFZ3Wy+Dk6kDaSxXKyJfnzXUbJNhe16G5eLHchX1wRnl2pgpMEowQx6s/JYv5XUJaynS8rLoqee0TAM3l/QcJeUkJ9ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(5660300002)(508600001)(66476007)(26005)(52536014)(33656002)(9686003)(55016002)(8936002)(186003)(66446008)(66556008)(64756008)(2906002)(66946007)(76116006)(38100700002)(54906003)(122000001)(7416002)(6916009)(4326008)(38070700005)(83380400001)(7696005)(86362001)(316002)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1VKw0j04ndRv0SdSkiscvBShBGuFDkFNOQJeRTzqSs+JpG9M5wq3R2Si1PKy?=
 =?us-ascii?Q?GI016FUoKRZhcdOWbPoF5uaai3nXfo68lQnS5eggc6nlUzy2hIfkO//FV6n4?=
 =?us-ascii?Q?m1/RUR8JhqgAClQJmDm3XkftFawoxxjVm6Ou/q5tp1VoREfFS2xo5RlgiFNB?=
 =?us-ascii?Q?6MAMimaJhsVt7RHJEIHWF8niML5XPfq8waRyVCZFUXvP2pbxARo5Q1LBcLbr?=
 =?us-ascii?Q?yw46ECKD4lHZ2rqtAad8uGJ1eWx0yji0Vz0pHVLOuTI1rRIOLbgS9m5W7UC9?=
 =?us-ascii?Q?eYcVujN4YZo4WqrhU+KGWuv+pxaZTzyFP0GVqLSTJSC4FguVjXQkN6p5nRCo?=
 =?us-ascii?Q?MibUhXrz1Vrk7MLcPG+QhYDYBG+oaNProsgpU/Rm1b3VPuDVqxIWg7LAsleS?=
 =?us-ascii?Q?C+EoxisQxNXNuvyyE9PojCgzEh3/53H45ICrXl+kK48SlYSPWj20zgebxG8x?=
 =?us-ascii?Q?ovLBiYvrR0j2nY2tGZqptz5epzf9pSiDPv/lN/Vf7j05Ft5WFKelkHq37G4O?=
 =?us-ascii?Q?hAzsrCX+YmSVxgjk/jkrJqWKhklHrpBOo0y4zKkztNSeWnD+jppEuo8L9B2v?=
 =?us-ascii?Q?ypuRt+AyfurJKiX2wunrM2CVj7maBfeDkAvNRExPK4AtvC5qBQ1ozqFBVk3C?=
 =?us-ascii?Q?f0SOfM5K5GRTVxbiFKwBffaH7FkH5AqioEL8jVsrzViYIyzcpqB7Y0U+XS3E?=
 =?us-ascii?Q?z3A2i2mjM20FKSm3R4MoZ+/xqqXy3bXQEZIUXXEtzq2Hi1vvKnt/KzC7QAYL?=
 =?us-ascii?Q?l2i3WRyEg+xQrmg6OkjPCTM6hPzMGU+CXsuoM3xp0NjB5y5v4kMxLXAy7e52?=
 =?us-ascii?Q?ZRbuAZYT9t5FXTO993MIsIS3cfs06uZaPpm5skP7fOOBFodwZkW+v6Nq/3rD?=
 =?us-ascii?Q?cl11uPztBV5f+zlXbsg87eK+uXUQ3ALVlEbSIFZlCYnpz4k+LhIMKJw1372o?=
 =?us-ascii?Q?tn27O9KWfZUcv/F5qYdtg/Hh3f+fAjGBzUdySsiMho7LWVY8Ev5k2JuGV3io?=
 =?us-ascii?Q?He8pAORHVCT/P9A04GmzyQDSTFmP4cdyLH6DAGJh3ERnk9/lPl/M4ygk4UgG?=
 =?us-ascii?Q?yNUDjVNV7Rk8xsbru+8IvgWIzuBSHhtvntYAafY6xKZ9SHXtoF2PTmdfQDck?=
 =?us-ascii?Q?pkuNoYRx6fQsC97XZ14fNAoR7mCk173EZ1DmxEqFqB0XzCjqB8Ahmayj7EPL?=
 =?us-ascii?Q?iC0VcBSI1shxKW2LzQ8sDzsdUIYUrMH/38MYnd/25mW6SMFyROkvlvSNXKxt?=
 =?us-ascii?Q?5w/0DNqzJg6hMmy3SEi9hHQo8XbJPxqlCA7O5Mf1TMaAcwOuJ43MLVd/Zway?=
 =?us-ascii?Q?sdbMd70LzT+JTVKQjQ5uq2S5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e613b0-24a8-4bf3-88d8-08d9819b30d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 09:42:58.6066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VaFP6z37CmpBXXn6VQ9v+RFx3HSjfifMgRnI/pUFjmYUw0QHpceNQ8VqORJ1sIn76BJUWmDEh1q3jkyUnMekSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2339
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:40 PM
>=20
> > > Ie the basic flow would see the driver core doing some:
> >
> > Just double confirm. Is there concern on having the driver core to
> > call iommu functions?
>=20
> It is always an interesting question, but I'd say iommu is
> foundantional to Linux and if it needs driver core help it shouldn't
> be any different from PM, pinctl, or other subsystems that have
> inserted themselves into the driver core.
>=20
> Something kind of like the below.
>=20
> If I recall, once it is done like this then the entire iommu notifier
> infrastructure can be ripped out which is a lot of code.

Currently vfio is the only user of this notifier mechanism. Now=20
three events are handled in vfio_iommu_group_notifier():

NOTIFY_ADD_DEVICE: this is basically for some sanity check. suppose
not required once we handle it cleanly in the iommu/driver core.

NOTIFY_BOUND_DRIVER: the BUG_ON() logic to be fixed by this change.

NOTIFY_UNBOUND_DRIVER: still needs some thoughts. Based on
the comments the group->unbound_list is used to avoid breaking
group viability check between vfio_unregister_group_dev() and=20
final dev/drv teardown. within that small window the device is
not tracked by vfio group but is still bound to a driver (e.g. vfio-pci
itself), while an external group user may hold a reference to the
group. Possibly it's not required now with the new mechanism as=20
we rely on init/exit_user_dma() as the single switch to claim/
withdraw the group ownership. As long as exit_user_dma() is not=20
called until vfio_group_release(), above small window is covered
thus no need to maintain a unbound_list.

But anyway since this corner case is tricky, will think more in case
of any oversight.

>=20
>=20
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 68ea1f949daa90..e39612c99c6123 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -566,6 +566,10 @@ static int really_probe(struct device *dev, struct
> device_driver *drv)
>                 goto done;
>         }
>=20
> +       ret =3D iommu_set_kernel_ownership(dev);
> +       if (ret)
> +               return ret;
> +
>  re_probe:
>         dev->driver =3D drv;
>=20
> @@ -673,6 +677,7 @@ static int really_probe(struct device *dev, struct
> device_driver *drv)
>                 dev->pm_domain->dismiss(dev);
>         pm_runtime_reinit(dev);
>         dev_pm_set_driver_flags(dev, 0);
> +       iommu_release_kernel_ownership(dev);
>  done:
>         return ret;
>  }
> @@ -1214,6 +1219,7 @@ static void __device_release_driver(struct device
> *dev, struct device *parent)
>                         dev->pm_domain->dismiss(dev);
>                 pm_runtime_reinit(dev);
>                 dev_pm_set_driver_flags(dev, 0);
> +               iommu_release_kernel_ownership(dev);
>=20
>                 klist_remove(&dev->p->knode_driver);
>                 device_pm_check_callbacks(dev);

I expanded above into below conceptual draft. Please help check whether
it matches your thought:

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 68ea1f9..826a651 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -566,6 +566,10 @@ static int really_probe(struct device *dev, struct dev=
ice_driver *drv)
 		goto done;
 	}
=20
+	ret =3D iommu_device_set_dma_hint(dev, drv->dma_hint);
+	if (ret)
+		return ret;
+
 re_probe:
 	dev->driver =3D drv;
=20
@@ -673,6 +677,7 @@ static int really_probe(struct device *dev, struct devi=
ce_driver *drv)
 		dev->pm_domain->dismiss(dev);
 	pm_runtime_reinit(dev);
 	dev_pm_set_driver_flags(dev, 0);
+	iommu_device_clear_dma_hint(dev);
 done:
 	return ret;
 }
@@ -1214,6 +1219,7 @@ static void __device_release_driver(struct device *de=
v, struct device *parent)
 			dev->pm_domain->dismiss(dev);
 		pm_runtime_reinit(dev);
 		dev_pm_set_driver_flags(dev, 0);
+		iommu_device_clear_dma_hint(dev);
=20
 		klist_remove(&dev->p->knode_driver);
 		device_pm_check_callbacks(dev);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3303d70..b12f335 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1064,6 +1064,104 @@ void iommu_group_put(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_put);
=20
+static int iommu_dev_viable(struct device *dev, void *data)
+{
+	enum dma_hint hint =3D *data;
+	struct device_driver *drv =3D READ_ONCE(dev->driver);
+
+	/* no conflict if the new device doesn't do DMA */
+	if (hint =3D=3D DMA_FOR_NONE)
+		return 0;
+
+	/* no conflict if this device is driver-less, or doesn't do DMA */
+	if (!drv || (drv->dma_hint =3D=3D DMA_FOR_NONE))
+		return 0;
+
+	/* kernel dma and user dma are exclusive */
+	if (hint !=3D drv->dma_hint)
+		return -EINVAL;
+
+	/*
+	 * devices in the group could be bound to different user-dma
+	 * drivers (e.g. vfio-pci, vdpa, etc.), or even bound to the
+	 * same driver but eventually opened via different mechanisms
+	 * (e.g. vfio group vs. nongroup interfaces). We rely on=20
+	 * iommu_{group/device}_init_user_dma() to ensure exclusive
+	 * user-dma ownership (iommufd ctx, vfio container ctx, etc.)
+	 * in such scenario.
+	 */
+	return 0;
+}
+
+static int __iommu_group_viable(struct iommu_group *group, enum dma_hint h=
int)
+{
+	return (__iommu_group_for_each_dev(group, &hint,
+					   iommu_dev_viable) =3D=3D 0);
+}
+
+int iommu_device_set_dma_hint(struct device *dev, enum dma_hint hint)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group =3D iommu_group_get(dev);
+	/* not an iommu-probed device */
+	if (!group)
+		return 0;
+
+	mutex_lock(&group->mutex);
+	ret =3D __iommu_group_viable(group, hint);
+	mutex_unlock(&group->mutex);
+
+	iommu_group_put(group);
+	return ret;
+}
+
+/* any housekeeping? */
+void iommu_device_clear_dma_hint(struct device *dev) {}
+
+/* claim group ownership for user-dma */
+int __iommu_group_init_user_dma(struct iommu_group *group,
+				unsigned long owner)
+{
+	int ret;
+
+	ret =3D __iommu_group_viable(group, DMA_FOR_USER);
+	if (ret)
+		goto out;
+
+	/* other logic for exclusive user_dma ownership and refcounting */
+out:
+	return ret;
+}
+
+int iommu_group_init_user_dma(struct iommu_group *group,
+			      unsigned long owner)
+{
+	int ret;
+
+	mutex_lock(&group->mutex);
+	ret =3D __iommu_group_init_user_dma(group, owner);
+	mutex_unlock(&group->mutex);
+	return ret;
+}
+
+int iommu_device_init_user_dma(struct device *dev,
+			      unsigned long owner)
+{
+	struct iommu_group *group =3D iommu_group_get(dev);
+	int ret;
+
+	if (!group)
+		return -ENODEV;
+
+	mutex_lock(&group->mutex);
+	ret =3D __iommu_group_init_user_dma(group, owner);
+	mutex_unlock(&group->mutex);
+	iommu_grou_put(group);
+	return ret;
+}
+
 /**
  * iommu_group_register_notifier - Register a notifier for group changes
  * @group: the group to watch
diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
index e408099..4568811 100644
--- a/drivers/pci/pci-stub.c
+++ b/drivers/pci/pci-stub.c
@@ -36,6 +36,9 @@ static int pci_stub_probe(struct pci_dev *dev, const stru=
ct pci_device_id *id)
 	.name		=3D "pci-stub",
 	.id_table	=3D NULL,	/* only dynamic id's */
 	.probe		=3D pci_stub_probe,
+	.driver =3D {
+		.dma_hint	=3D DMA_FOR_NONE,
+	},
 };
=20
 static int __init pci_stub_init(void)
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_mai=
n.c
index dcd648e..a613b78 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -678,6 +678,9 @@ static void ifcvf_remove(struct pci_dev *pdev)
 	.id_table =3D ifcvf_pci_ids,
 	.probe    =3D ifcvf_probe,
 	.remove   =3D ifcvf_remove,
+	.driver =3D {
+		.dma_hint	=3D DMA_FOR_USER,
+	},
 };
=20
 module_pci_driver(ifcvf_driver);
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a5ce92b..61c422d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -193,6 +193,9 @@ static int vfio_pci_sriov_configure(struct pci_dev *pde=
v, int nr_virtfn)
 	.remove			=3D vfio_pci_remove,
 	.sriov_configure	=3D vfio_pci_sriov_configure,
 	.err_handler		=3D &vfio_pci_core_err_handlers,
+	.driver =3D {
+		.dma_hint	=3D DMA_FOR_USER,
+	},
 };
=20
 static void __init vfio_pci_fill_ids(void)
diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index a498ebc..6bddfd2 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -48,6 +48,17 @@ enum probe_type {
 };
=20
 /**
+ * enum dma_hint - device driver dma hint
+ *	Device drivers may provide hints for whether dma is
+ *	intended for kernel driver, user driver, not not required.
+ */
+enum dma_hint {
+	DMA_FOR_KERNEL,
+	DMA_FOR_USER,
+	DMA_FOR_NONE,
+};
+
+/**
  * struct device_driver - The basic device driver structure
  * @name:	Name of the device driver.
  * @bus:	The bus which the device of this driver belongs to.
@@ -101,6 +112,7 @@ struct device_driver {
=20
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
 	enum probe_type probe_type;
+	enum dma_type dma_type;
=20
 	const struct of_device_id	*of_match_table;
 	const struct acpi_device_id	*acpi_match_table;

Thanks
Kevin


