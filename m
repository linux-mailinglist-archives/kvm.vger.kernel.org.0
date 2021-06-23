Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C403B23F6
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFWXj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:39:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:30535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhFWXj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:39:26 -0400
IronPort-SDR: V0mOCDFtLxEs38O64qwjZVbekz35tKTlXyKUS3HsgG4jMdQ3Ke735epucuITED1+9y++R5FnYK
 POSLdFwRKy6w==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="207404008"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="207404008"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 16:37:08 -0700
IronPort-SDR: 4OebLzyy/qxQiFP8wFKUkTFgyV4VvPfjEXeQ+r3Ik6LDBDELkPvNFoNaJN6UIgpIVgHz8adgCC
 KlNpIntx9GTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="406466179"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 23 Jun 2021 16:37:07 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 16:37:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 16:37:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 16:37:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOGEnPa1kSuu2U9Z2wSW+cJJmOm8fWKENJ1BgTYMFj9+UhhDfIw7a6FCEUliGVJHycWXb+edALGp2uIzpwma7Sy6joHJCETxJbqctckOSo3ASkhJjLU2xbDzawsR78W8a9Vyb/UjDps0kruqya815TONvMsS0sQbvuDALYt3isS/h9GPf7NTZZjbX00VWm8YHwvhFiPxazuVicLFIO0T5vJlABV7WGk6p863V1O9LxgGQzxp5XZ159WAarwiHVUuJmMnm81gCpUwg76GD84bO0NOccOMBnnorKy1d+uUWbQQPhwFoimhyVW08ei2hTplLkcpgGN1XJvLEICbqZvbJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikzHZEuhTlqOWebinQqP/K7ohbbQ1CORBGdCy5esD5Y=;
 b=ADJcoBKcFCYcOvdu3Q4dHLeupAgvY9O9/jQ2WEK5sXM6lNbUVWc63XBx1b0a3pq2o12SGqtIALyBGnkkq/8xJcEoYO5ckAWifmgcTkWoTRZPyyHFX8tCRkqHNrpqL6dloLv6H/2t4suSdBq1bk728KqcgRu0oWjjzA79NxVanCanPvdbWsrx+yhI1A3r0hRP66oY6IyOqiaaDT5nb5R6hHuxjyPeNr4MA4tE/MaPaQfkyMTEH8uEStSWz595vtWkQjfE8bbqpprUN3l1diMu44+3C39MdUg33Y8e4vAeAVYpVgDc3VLt5bw8Ch6birxiB29HYIrEUr4qD3KAF5YLDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikzHZEuhTlqOWebinQqP/K7ohbbQ1CORBGdCy5esD5Y=;
 b=v5GoGmaBEa6qwVSAUmlxqe5YJPyMPieMykaYQugenGyKzuF2Xv96pKWuhh+5iPqXLEvqd9Gl31ylaX1//KbBv+evlz+Gllh7etcuiNpwnaJbwa68awarPbjoyWpHnUI0HOF8VPWhIwYqdhLitLg3eg7S+WN8LqJzBUawq7kxbUU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4715.namprd11.prod.outlook.com (2603:10b6:303:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 23:37:03 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Wed, 23 Jun
 2021 23:37:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "Bjorn Helgaas" <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
Thread-Topic: Virtualizing MSI-X on IMS via VFIO
Thread-Index: AddnMs7+4GfLhTceT8q8tdV8716lmQAZ7UiAAAoHBgAACsXtAAAX4LwAAA2wIPA=
Date:   Wed, 23 Jun 2021 23:37:03 +0000
Message-ID: <MWHPR11MB1886BB017C6C53A8061DDEE28C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
 <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
 <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
 <87bl7wczkp.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87bl7wczkp.ffs@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77b388e5-8dbe-4f89-3935-08d9369fce52
x-ms-traffictypediagnostic: MW3PR11MB4715:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47158D7C243CB311A2D13AA78C089@MW3PR11MB4715.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /+/DR/Y+xChXnXu+NirIlKDywIS+/Y7I2M7bJpdLPG9HuSyoxyheNQHHXjsTTjRQ9aiwCK5j7kMc7Y9DEmPM4Ghvo67oeeNOpMvtyDgGO5ZSs3RRX0kmPDQ/chBfgFcIc/77OYeCfMWZjLOKczweeOy28aq6CzvSrb87PciC/o/QK2+U4NgoyeBqD7FVUbqp8FpYYHA6MSHhL83ZSetsDa3dkaFLNwA9SBODQm/DBNHT2kLJuRH65T7uCux/7cHibDeMJl61WTgDapiqsAIzvFV9dz9s4OuVKwztGONTkxbA7FNw5DR0Gc2Vx+neyqL3o17aTnzjl17SAW6PPVkgFVLUYTkbLz0se31bggv8y/O9Jy7V6ntwezSmJNcLjEN3oyTHDgSwJDxdcMLIzrx8UJjouc3ux2nNiaI9xXVlYtSL/2jOzvTw4pNgd1vv392Fhgpb7kKcO2Y3ip9FrywjjVAI33UU/CDFESIc1D4jwb48V9y9taxtzVRUyVzBg94Tw2QBZQ4RTv8gpdruI3PrDLkSuPEe/5rsdvNrKEUNZ8SmDLVljwReJdYxZPGzg/ABDYIWZVqgucTdk894pmIgs5B/Lo+dX+EwAe134TV5zJU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(39860400002)(366004)(6506007)(83380400001)(26005)(7696005)(7416002)(55016002)(33656002)(478600001)(122000001)(4326008)(38100700002)(9686003)(186003)(8676002)(2906002)(76116006)(71200400001)(5660300002)(66556008)(64756008)(66946007)(66446008)(66476007)(52536014)(8936002)(110136005)(54906003)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?74Vlam4pPM4wyo9ldcH40+KhQX9z9KZ/W0hgslW7w2UBwMgIcYi91jlYuxr1?=
 =?us-ascii?Q?7PDptfwztg89CJFYMKZCP4/oQoSf2XBaMieR7O/oyv7jI6GpQ3d0ZYF1ZvGi?=
 =?us-ascii?Q?JrwqGLQ2V8QcSbwLg0Rbxs95Tj7lVX0v0gnxUCWrP2MBD89FpAeM/2fCV5Oh?=
 =?us-ascii?Q?BpdosmqwJUYwvuT3dHu5/algc8TwFaO3a3m8z+sC1GI0o0GU2vb/cVWm3y74?=
 =?us-ascii?Q?QOp6jtOl230ZoY5SM+0X7Z1q14Yjt7DH+gIOsIFqXs6dBNBGDddql2Z4hWa+?=
 =?us-ascii?Q?U0FCNii8H32hjAZVzvtDG4/gp0+HliK5PrY3hXdLQgkOLUl8qCEx60fdUyCT?=
 =?us-ascii?Q?o8c5sD8p8J+IQvEh3qiPV8CvIv2GCv0dcga/ce1FKc6akSIXEq9KTKphGxIe?=
 =?us-ascii?Q?g6AeCI7bSc23GARBuvm2zCOg0MmenjIc8HN8GBwudTfaKf/KXbOJZ+btzEJS?=
 =?us-ascii?Q?YWSOcKDNZ3YSKcoA2ugpC0IVipjjlCiLRGYxrV/7lBsMDLBdcJG0WdUYtcK5?=
 =?us-ascii?Q?/N6Anp/mztP9SqrhXOPhiZAaH8T4IE8aNgpYnTAiNDjwGScvS87/Fo7CYmZ2?=
 =?us-ascii?Q?dQkVBaXKY3zUE0hdaqSRSfzFoLgvxlJJYm54qD2sTIM5ir+2x/5Nwiw3PUUA?=
 =?us-ascii?Q?enHMErxT16XASoviJPoogH14fdYgBcgiNRAJ0mvbNu7lg0GYluhAZ+zOTDTp?=
 =?us-ascii?Q?+MGq1hXXrjvpFqe29EsEi8tA4z8fW7gd9NmMRjZCHGq7CASg9kkk6ZRVZO8u?=
 =?us-ascii?Q?FP4pVjI9TsUip8E9UIoB1B5O/vZXQnsNHkTzdXaKkDNQ/yCBGpjROYTywCFF?=
 =?us-ascii?Q?5R2JRPCRq/nYP4n7U3j7d1ALxPamtzef0vJvA3c6h4pdFcie9me+1Db8gwz3?=
 =?us-ascii?Q?YNyc5UTBnKoLkjKgS9fUNRNBZUosQGZ2du/HaVVNTp+Ab4Pwkw0KH9j4Vchd?=
 =?us-ascii?Q?xBKHmWdysvU+PwavCUN/Tn0Duu4rO6IxPyX+Y4Em3Za7La5r/cEEEmlBwlfq?=
 =?us-ascii?Q?m60Bn27wjrd1WPLjNxvObDIjOQh4Z9adf8hkhWKMPDJi77FG3A90nX7NwUIh?=
 =?us-ascii?Q?yNVqb6wAtMP01V+74d5+Ie+fmFo7CXlvUvDeEFi26v4/eDiY3XbbkYXeT1Y8?=
 =?us-ascii?Q?XV4MEWyes/85ItwVjUWh6XJCuHZutl+8Kv3tgBxgZilSX3DwWJGRk0JaNab5?=
 =?us-ascii?Q?8knoL2P5z8RRUI3lylJATKiE+LFhXf4BQBvTnFN40hJY3+pUSFQvGUud1Hmw?=
 =?us-ascii?Q?MS01TmBTb387YXNO3RImOP9qoY4kpNDnNJ2jJUTuh9twDA8Mce7exTAaW1Kp?=
 =?us-ascii?Q?jxtBkNNrLqecmDf7QRZJ5KfZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b388e5-8dbe-4f89-3935-08d9369fce52
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 23:37:03.6881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zm8VN3MjhxZDfX+VsZqLSByqaQ8akmmtv1XEUsuSGHLyvKbhnwBKXQGDVG/lp0f3Z4r/YXZgAqp8TFYBWfvdFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4715
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Thursday, June 24, 2021 12:32 AM
>=20
> On Wed, Jun 23 2021 at 06:12, Kevin Tian wrote:
> >> From: Thomas Gleixner <tglx@linutronix.de>
> >> So the only downside today of allocating more MSI-X vectors than
> >> necessary is memory consumption for the irq descriptors.
> >
> > Curious about irte entry when IRQ remapping is enabled. Is it also
> > allocated at request_irq()?
>=20
> Good question. No, it has to be allocated right away. We stick the
> shutdown vector into the IRTE and then request_irq() will update it with
> the real one.

There are max 64K irte entries per Intel VT-d. Do we consider it as
a limited resource in this new model, though it's much more than
CPU vectors?

>=20
> > So the correct flow is like below:
> >
> >     guest::enable_msix()
> >       trapped_by_host()
> >         pci_alloc_irq_vectors(); // for all possible vMSI-X entries
> >           pci_enable_msix();
> >
> >     guest::unmask()
> >       trapped_by_host()
> >         request_irqs();
> >
> > the first trap calls a new VFIO ioctl e.g. VFIO_DEVICE_ALLOC_IRQS.
> >
> > the 2nd trap can reuse existing VFIO_DEVICE_SET_IRQS which just
> > does request_irq() if specified irqs have been allocated.
> >
> > Then map ims to this flow:
> >
> >     guest::enable_msix()
> >       trapped_by_host()
> >         msi_domain_alloc_irqs(); // for all possible vMSI-X entries
> >         for_all_allocated_irqs(i)
> >           pci_update_msi_desc_id(i, default_pasid); // a new helper fun=
c
> >
> >     guest::unmask(entry#0)
> >       trapped_by_host()
> >         request_irqs();
> >           ims_array_irq_startup(); // write msi_desc.id (default_pasid)=
 to ims
> entry
> >
> >     guest::set_msix_perm(entry#1, guest_sva_pasid)
> >       trapped_by_host()
> >         pci_update_msi_desc_id(1, host_sva_pasid);
> >
> >     guest::unmask(entry#1)
> >       trapped_by_host()
> >         request_irqs();
> >           ims_array_irq_startup(); // write msi_desc.id (host_sva_pasid=
) to ims
> entry
>=20
> That's one way to do that, but that still has the same problem that the
> request_irq() in the guest succeeds even if the host side fails.

yes

>=20
> As this is really new stuff there is no real good reason to force that
> into the existing VFIO/MSIX stuff with all it's known downsides and
> limitations.
>=20
> The point is, that IMS can just add another interrupt to a device on the
> fly without doing any of the PCI/MSIX nasties. So why not take advantage
> of that?
>=20
> I can see the point of using PCI to expose the device to the guest
> because it's trivial to enumerate, but contrary to VF devices there is

also about compatibility since PCI is supported by almost all OSes.

> no legacy and the mechanism how to setup the device interrupts can be
> completely different from PCI/MSIX.
>=20
> Exposing some trappable "IMS" storage in a separate PCI bar won't cut it
> because this still has the same problem that the allocation or
> request_irq() on the host can fail w/o feedback.

yes to fully fix the said nasty some feedback mechanism is required.

>=20
> So IMO creating a proper paravirt interface is the right approach.  It
> avoids _all_ of the trouble and will be necessary anyway once you want
> to support devices which store the message/pasid in system memory and
> not in on-device memory.
>=20

While I agree a paravirt interface is definitely cleaner, I wonder whether
this should be done in orthogonal or tied to all new ims-capable devices.
Back to earlier discussion about guest ims support, you explained a layered
model where the paravirt interface sits between msi domain and vector
domain to get addr/data pair from the host. In this way it could provide
a feedback mechanism for both msi and ims devices, thus not specific
to ims only. Then considering the transition window where not all guest
OSes may support paravirt interface at the same time (or there are
multiple paravirt interfaces which takes time for host to support all),=20
would below staging approach still makes sense?

1)  Fix the lost interrupt issue in existing MSI virtualization flow;
2)  Virtualize MSI-X on IMS, bearing the same request_irq() problem;
3)  Develop a paravirt interface to solve request_irq() problem for
      both msi and ims devices;

Thanks
Kevin
