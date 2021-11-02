Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F61442B16
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhKBJ4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:56:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:46127 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhKBJ4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:56:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10155"; a="231480651"
X-IronPort-AV: E=Sophos;i="5.87,202,1631602800"; 
   d="scan'208";a="231480651"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 02:53:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,202,1631602800"; 
   d="scan'208";a="576947297"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Nov 2021 02:53:36 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 02:53:36 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 02:53:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 2 Nov 2021 02:53:35 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 2 Nov 2021 02:53:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZ8kDAq7BB2CUJlOxrv4HZqHDc59PeFa/WF9+qv+E/11W9MOuQCAcwh3I0LkpUF92zrRhOfDdtzwzDTyviRNZ0poTmJIDoTGcpxs27FpyrTXHKI0nwcrcEEHauU5b+gzSScWVc5E1MgCU6oZpSRfl+BTEB0XXNBfjd4Va6PXrXf/bPOiO9LIIoLl2Z2BX6a9O73GSyCEQRIn7c/154fp+UhGVqey8gubH5zz268t/ZYpzzxM40xUFZMbt+I0pVnoRbMZ68+Zgh1GO895tm9tEwLIS53WGxasWTJVgBMX0siUUEMLjXls2+C+YnQ073lp0VrZPZn+2unxCpsjlBG+ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZMWee0hrD1m/JCHniVwW7y7Ey4za4/ch92fqpEzEhE=;
 b=QBbhUoTLifeklSiout6nZG1MJyh+VXkl5H0+j2kTbO3A+nhAj7ldRNlm7CyuI8wfBbp41t2eUsydQ+7N6oPXgquybNXB+dpXD+mCYXHH++DQFElwcznfdCtd/lDv+9ncnEPhLHq0jtYQrOeejcS4n2p4hKclWkIQqmx0c5iuTnjHa8edmy93BGGuvl63TgJpvQfKvA5o7JxcLWmxdB+YYA//SqyW25D8i9F2e06TfSMXLhjXdeE4OcOlN6NYlZHbFdcvgzCw9wcWzEpdSNdOv2BTOz3+V8vw8KjZw4yBo3uLj6dFFOBTOxJUary0Ti41YVISDYcYdSqAigOCw7oq3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZMWee0hrD1m/JCHniVwW7y7Ey4za4/ch92fqpEzEhE=;
 b=EnjG+/DOzaPMEe7Rh0eYSQi0nYkhz2f1zsAk/LV+cAW1wkzOBCDu4ERc/mYCjo3QNMjCNVlimKQyJhRHoOwNfSiAUzYsGj/ISy5VSFsWDvUrDhDr1UR2iHbIsrBH3nER3bXm4BIlD6u6iSBAgRZ7UZZoS0NPIoYVhzg91dqXkh4=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5660.namprd11.prod.outlook.com (2603:10b6:510:d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Tue, 2 Nov
 2021 09:53:30 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::e849:e503:195c:b69c]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::e849:e503:195c:b69c%6]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 09:53:30 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Topic: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Index: AQHXyZ9N9hHTiUakTUi0phVNj8QgQ6vpuU9ggATxeICAAVDBMA==
Date:   Tue, 2 Nov 2021 09:53:29 +0000
Message-ID: <PH0PR11MB565808A9C9974A0D0D72B738C38B9@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <PH0PR11MB56583D477B3977D92C2C1ADDC3839@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211025125309.GT2744544@nvidia.com>
 <PH0PR11MB56586D2EC89F282C915AF18DC3879@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211101125013.GL2744544@nvidia.com>
In-Reply-To: <20211101125013.GL2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14139b07-7b97-48f9-2b5b-08d99de6a007
x-ms-traffictypediagnostic: PH0PR11MB5660:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB5660F86770716E7704812B8BC38B9@PH0PR11MB5660.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c7p4hfVzeyMC3J2PzVeMCEknwdYtYbXUGTd8Bf5eAcDPU/EsJb1z+XoAXZgfS1rtCBMhtT6OHn9Dru3+w3iwIqE5g4iZUjsJ6tJxpIHilI+0PmrsCvEc2/Xk5b//dQAUIzdMwANa7a2/utpnwbREfgkXYr/I7AoSiMrHah230RL7Czqns3Wfo4IwVJZ4U+gWgiACKjrdaRJf212u1qi5zgF5djpeUGC2Vh/gsVn51q3ZS866Roz1zIZP31rcHV9Z/5PJy11bjUerZCNkcVYh8PQTTWz3odPeXxqUBdg+gVjsl3ctMIIrW1WWFfhEwhMf5U1qWaOvIkpRaRKTQ714PieVcNxvo4n9S2snwfTJu8jUQrVXFx0GYtUwe9EC3jwzS3de3gDTju1fBFhBqYQpEsJTf9ZbfSfkumt7OA4/RpvKRU09J+pSIRkrizG2yd77h2EG1i12Ag5EBdm4azC4U59AsOqu7U5mqc+RI90jm4vo/yUts1fr0951etuwnktFPEMS3+82WnQs3Z5zl2kcAbeuQAcjVmvkOTH7vH5PFKTIZcmfW10KJfmI2DBBU/d9MB2zFfItWs3yeeFQ7bILWmLQ1oPMAoQqS9ENMkKxYrnBkYBC/9WkEXmB4UHaz91pu15t8e+yOwTuTAks6fSxu/XZPoW6dOcoBNIgiBrYx2S7mdlG5vXyIT1dlorVbuxo4r9brq9RzsMtXf3TPVX4gQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(122000001)(5660300002)(186003)(33656002)(508600001)(38070700005)(64756008)(52536014)(66476007)(7696005)(71200400001)(66946007)(66446008)(66556008)(26005)(76116006)(4326008)(6506007)(82960400001)(8936002)(83380400001)(7416002)(316002)(2906002)(8676002)(54906003)(6916009)(55016002)(9686003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q6AFt0BZTEkZxOXA9ZCBzRfwk1FQiDe2MDWUj8YOrhDfHgj/6kPG0HjLE4se?=
 =?us-ascii?Q?yL8T0AhMQpSCOJlpjWXdyp448HJrv+28JPc7hSWExprlBa3yQZjjL8qmzBs5?=
 =?us-ascii?Q?5PQz5FUCaWxFOFhNWlpL9m24i1z1aeggxxVjUaGZNWm4OU3LhHWL2z3OO0RK?=
 =?us-ascii?Q?u2bBNUxEnOZDKGgnaUSfDdXUAIoAk4S2ep8ik8ykf4XUiaz3W4zwtqkx9i5a?=
 =?us-ascii?Q?CY4lNCXuLxumxEzHQjciAr3YWdAozEH4whF+JKI2jSIWPBzFpI22b2Eypcjj?=
 =?us-ascii?Q?1rh7xQ1U0MihSp1LpWwAhRHdgzXuKz36Rk0qh26N19chXniUKOidgyTHc5gj?=
 =?us-ascii?Q?BAcvu1d1LCBKw5vZPtxMjn2F0Ga3JLg3ryAWWPYR+wNJFTvim1TK1MYgvjTm?=
 =?us-ascii?Q?Xzb3WylrjqxJmdkm1Oj8O9yWccrDU9aH+cXJP+stjkda+vLOW0FLb2CT5UaQ?=
 =?us-ascii?Q?GR6PguZT6En4kH14IYc8A3lw2UsbmaWqQSQJ5OgeDilBIUMc2H0AmUNheZkU?=
 =?us-ascii?Q?in7mKb/JfAKMgoS8PP2TH9BUtJ0ek1KhzLpv2O0QFStkTlousfMi2ZJPkL+k?=
 =?us-ascii?Q?GPnIAQW9bHqYrxFyAnwpXe69G2AJkt02SsHe45sXSX5Z9hhxIZmAl8m47iPJ?=
 =?us-ascii?Q?giJ1VSLtQkRr7kFd2c8GEvQzBMtL7jzDEwF2azMqOJKZttckNAyfLaTpyD7S?=
 =?us-ascii?Q?9k+nRsUqubMgZAoY1cwhoRpkN1PqbyZzLb3IW3ir6+DT97xmkSng+4NODSY6?=
 =?us-ascii?Q?2AHiCmbDUzPB4NBt92QeLxuXlbTdK35lIwzhe8OX+1tGu4eUBRguNQ4gIeCp?=
 =?us-ascii?Q?WLwF9LP6WPj2A72IbMI735OEzRlyQJBdDylSHoRXEIbYAFaHpj00xFn/6jBM?=
 =?us-ascii?Q?K75SNcItPmYIXfKL4LkhA3sYjFn/y4WUd2ALtxKJUtIKNEzvsHepdCXFrx6L?=
 =?us-ascii?Q?OnG1VgXUU+0ThsDcR9scJbiRBj0PWy1pYC06PSTNY0edTJurQuY7uokch9xj?=
 =?us-ascii?Q?FvhRSH6N3NLMohHdr8Mq/R0+3S/tZdVgs6WD9CLwFFuYj2gAPDuGI0AtrMnJ?=
 =?us-ascii?Q?4XOuONhrcQ7kaVnuzbONO0ewjkpHjnHLhz0/VES7UCp6wxjq9oQfL60iwdIr?=
 =?us-ascii?Q?2/L+fnTxUkE1GGvSf0uYXl9vXAo/+8Mj+V9BgMI19y/RDj87fCeh3QvvmqiK?=
 =?us-ascii?Q?vDx1BkWL5pF/7LwK6CoZp47lJTQeuPMYyejSygoVWKB0FfeUca6BWcGTczNz?=
 =?us-ascii?Q?MmXvpgu9LL5CbwqS267OLCWdgdseSerDRpMFgSsC9Epml92ecKrA8QwuncM/?=
 =?us-ascii?Q?xH1PFX6wiDyK3U+Ue5biRSIw/2b+/tULiBu/uk6cw8yAXMN8ORCsfn0Fpl9X?=
 =?us-ascii?Q?i7YTvJa2eBuVOOC/sL9cSvr8B0d4OVaRu2Coddan3R9lgRRvFxLJS4Hk2eGy?=
 =?us-ascii?Q?a4covrjUKq8ntttOpob1OONfzNqA7PxN6uv89nfDU5brb6BJ7tOzOGArQdbc?=
 =?us-ascii?Q?e7WkTdSqVV5vOpMn3dHOVa2oT1vKFfGApHyLWeLHe4VEy0h8J0+Vyys1zJbt?=
 =?us-ascii?Q?BUrTPdLGHMMhrRu+9BcQ9oUM6mdB8M8uEcqryR66Ugf+sPtSYAmFRDUhXy46?=
 =?us-ascii?Q?vU9N6929ecycqhRqkERYzgY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14139b07-7b97-48f9-2b5b-08d99de6a007
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 09:53:30.1025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x8KZ3zYaPim3jmJPtK3sDpL3zW9OR2ZZvB+L0YujIahGRbEfwEMers1JJSIXcBTdgKo4PNSrDMqEGgphX7mChw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5660
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, November 1, 2021 8:50 PM
>=20
> On Fri, Oct 29, 2021 at 09:47:27AM +0000, Liu, Yi L wrote:
> > Hi Jason,
> >
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Monday, October 25, 2021 8:53 PM
> > >
> > > On Mon, Oct 25, 2021 at 06:28:09AM +0000, Liu, Yi L wrote:
> > > >    thanks for the guiding. will also refer to your vfio_group_cdev =
series.
> > > >
> > > >    Need to double confirm here. Not quite following on the kfree. I=
s
> > > >    this kfree to free the vfio_device structure? But now the
> > > >    vfio_device pointer is provided by callers (e.g. vfio-pci). Do
> > > >    you want to let vfio core allocate the vfio_device struct and
> > > >    return the pointer to callers?
> > >
> > > There are several common patterns for this problem, two that would be
> > > suitable:
> > >
> > > - Require each driver to provide a release op inside vfio_device_ops
> > >   that does the kfree. Have the core provide a struct device release
> > >   op that calls this one. Keep the kalloc/kfree in the drivers
> >
> > this way sees to suit the existing vfio registration manner listed
> > below. right?
>=20
> Not really, most drivers are just doing kfree. The need for release
> comes if the drivers are doing more stuff.
>=20
> > But device drivers needs to do the kfree in the
> > newly added release op instead of doing it on their own (e.g.
> > doing kfree in remove).
>=20
> Yes
>=20
> > > struct ib_device *_ib_alloc_device(size_t size);
> > > #define ib_alloc_device(drv_struct, member)                          =
          \
> > >         container_of(_ib_alloc_device(sizeof(struct drv_struct) +    =
          \
> > >                                       BUILD_BUG_ON_ZERO(offsetof(    =
          \
> > >                                               struct drv_struct, memb=
er))),    \
> > >                      struct drv_struct, member)
> > >
> >
> > thanks for the example. If this way, still requires driver to provide
> > a release op inside vfio_device_ops. right?
>=20
> No, it would optional. It would contain the stuff the driver is doing
> before kfree()
>=20
> For instance mdev looks like the only driver that cares:
>=20
> 	vfio_uninit_group_dev(&mdev_state->vdev);
> 	kfree(mdev_state->pages);
> 	kfree(mdev_state->vconfig);
> 	kfree(mdev_state);
>=20
> pages/vconfig would logically be in a release function

I see. So the criteria is: the pointer fields pointing to a memory buffer
allocated by the device driver should be logically be free in a release
function. right? I can see there are such fields in struct vfio_pci_core_de=
vice
and mdev_state (both mbochs and mdpy). So we may go with your option #2.
Is it? otherwise, needs to add release callback for all the related drivers=
.

struct vfio_pci_core_device {
	struct vifo_device vdev;
...
	u8 *pci_config_map;
	u8 *vconfig;
...
};

struct mdev_state {
	struct vifo_device vdev;
...
	u8 *vconfig;
	struct page **pages;
...
};

> On the other hand ccw needs to rcu free the vfio_device, so that would
> have to be global overhead with this api design.

not quite get. why ccw is special here? could you elaborate?

Thanks,
Yi Liu
