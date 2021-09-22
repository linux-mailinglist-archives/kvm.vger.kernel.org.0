Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92801413EC8
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhIVA6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:58:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:25082 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230243AbhIVA6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:58:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203648158"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="203648158"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 17:56:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="703468728"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 21 Sep 2021 17:56:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 17:56:19 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 17:56:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 17:56:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 17:56:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVPWfOA1Jf0TsinCSGIKtnn/o7vSgvdUbGDMrh2YDqAJyUMR9HkJt8xSDPuK6Ap6J45Ugj8wiZvp4vxNy9RPy1y6KEhnJt+eUKEGAi8yIOZLDRxCFNeQrUn0M611I48xbck8X2GRgLMmFJf5eUDWYOo3n5fhTWhqbT5gC+psQxMiePkfoAH2BZ9mP+HlDIZDzyWCJVNuPYb+LPJT4WBV1OL0E2+SXtdGyKJacXdQPKYwm1ExWUO6yMOofIbhdtrBnlYl0yOo/on1QfFvRiJ3ZeZFMcrnXhpt8zCgxftEhdOUO3VwDSAvh9f9z5nhDJryKOcc91I6PaJpmxX9OgCqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FB57o3QxzQteRqUqotAnHeGKLntEWTJYOg6FxEy4Jm8=;
 b=YhPmEDHsliYkn7uW97XFaUhxz6cKqHtp5WKIbgHmVo7Ym6cJDsoNidprMVT5u7tc94ZoP5bJyHz+RysDwgqQ412C6bKINaCUouwYw75uSlD/M7dlMflQrJaADfqJ8oAjmtxMXXuLtlH0TrxkNh3x8wKu27YoXCxd6XfbCfdYahVAqXw/XDvFEtIPSBB8QbJ3PfRdBz46eguiQqrRHdhHIHZsCNvktFRh2Ch2Zl3qFNrnaB/D3rT8x6URCjz0t3d6+gGyOGsAdU11ai3Z4WDkmwYAW3WXzq8x0xveEZouPKu+qfTBYIZh5I7h50kc9tn1shkH6roJayntwtd9DuF5JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FB57o3QxzQteRqUqotAnHeGKLntEWTJYOg6FxEy4Jm8=;
 b=fxwqgKDtx65VFb246c7p0Shie8j7hPk0tYv53cg/DsBADyO9fnq/FM8mfQPXMl8tPd66yNcxJti7fUA57Ej95t3L9YE2AiMTczbG6jLWnEMJahvXWcNhIK5/TZcJtEPCVxe6tihli64xWmYP48Q9ID9WaUvAE/23FrxUB9DriTk=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1330.namprd11.prod.outlook.com (2603:10b6:404:4a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 00:56:17 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 00:56:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>, "hch@lst.de" <hch@lst.de>,
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
Subject: RE: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Topic: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Index: AQHXrSFvz6zvm2xHBUaW/Kl+BWVvQauu6ySAgABTS3A=
Date:   Wed, 22 Sep 2021 00:56:17 +0000
Message-ID: <BN9PR11MB5433C4C1539B3965134391358CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-3-yi.l.liu@intel.com>
 <20210921135601.3393f51b.alex.williamson@redhat.com>
In-Reply-To: <20210921135601.3393f51b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57853485-82b7-4b1e-645a-08d97d63c8cf
x-ms-traffictypediagnostic: BN6PR11MB1330:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB13308B3A51A2189BE674C8F78CA29@BN6PR11MB1330.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xqMeuu0z6GpWU2fkqyHdvyJoDD7JGzZvZiHn2U3qcxqyjulQRSRypo1W0lOlQ8b6ansU12HthUCI7czXLZuqUJQbEZkcld5W0/6eK95qGEqD/9fxGU0eYtnNBKM9KNPCk4xAM9gDHhZ3xo/7kPeE5KoOdihdc5mJlCcIj9EUvcivPnkT4uB54AHw/UvGSA3tBswaJxoA/9uHLs4VcTxx+vseywK95lZeaBFNyQ/HPexl5HoXIv33Ygsu8dKJbCxIwO0PIRqz3TJo7G0Q+G1E6JSP6ze7z9uG6SPAP+fSIfNCzOJl3tYW1uniBrOLOGF0+Lb2QdXFcu0lT6S8WYEYp5LAwtbsTwZIbdZYhtIhffhWArq0+FkVSUV8XInaWZp612P5ZKzIOqTY3tdO9uPCVLd0W6fxu0mp8mC6WGY0g7cPUkukXNNW+Evlg0ECqvEbAgZOdqn9KmVG0SN03kjfdujoSzjeOsrNBHZzQkfTD3FM60dH6Dno8pl1qzkHIC77m6LSODhnB/ln8rxonoQ62aOmJ7W1eQWKFCap0SMDB2qPoRk7uvVaXzwOis7Z7Kff6Ld0ykhZt6ONXZgFEPywq7B8e1fkK32OkCXXykWqHeBzgWSIHBakZdEWoZzRwwi8HdnK1HXqkwjfBBYu4OPlJAds6R6ekb0qAZC9h+WgDs+obDov+GF+OE9Q/owF9/ZknsAgOE6Qzci8jze1vl+c7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52536014)(66556008)(66476007)(76116006)(66946007)(5660300002)(54906003)(508600001)(66446008)(64756008)(8676002)(33656002)(83380400001)(316002)(8936002)(4326008)(2906002)(122000001)(38070700005)(26005)(86362001)(9686003)(6506007)(55016002)(7696005)(7416002)(38100700002)(110136005)(6636002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0iXhGTTXRnD+qphUE240+yUILUkoTn6wOO1JPZuVOnwTX1NfCGhU4B4teoJ/?=
 =?us-ascii?Q?HvDKIzcr7jCN87pBUVkOZD0XDrrFci0RrHKbGq+rxD1xYgK4tA+65t+Gqj13?=
 =?us-ascii?Q?Ns68ZDAyf/LLp+XquFRkjyyxULN2P1dffvsvVkt9HQwBBj5UTK1VH5vfGxpI?=
 =?us-ascii?Q?t/0JWZi1oWF6wD+w02cLyFrQEX9TpHS+0JTzm9Yn0es5LT6daD9reufc4dl0?=
 =?us-ascii?Q?ZLj6WnkqCzkXlWHxfMpGEq/P8TmGmRGTmbI1CApoX9f8rs1h4tmKRim4gchw?=
 =?us-ascii?Q?iGMR3Q6ANLuFczZXFYFSrzl2CWcO0dfGk7cNnG/A9APtq52/LcZzRsQy4zFX?=
 =?us-ascii?Q?K5uQ9svZkye5VbwPHOUaScjabSSKsnvSyd8CJ4soh4dU8VdGR/JylQq5Km8d?=
 =?us-ascii?Q?fa7OfB75wEZbV1unRGjRCsdEluYzyOBBeW8B4fN/hzvrYV/JbCU0xZwRfrG/?=
 =?us-ascii?Q?2tflJ571Fx8lKHziy6rJ8ON6J9xwpd8Hv4TXpL+uN5qB99JKyfaHlPhoZ9co?=
 =?us-ascii?Q?D3iqfBPFwzWAiDIpyi3Vh81jBEohz8tlOkdO0Z2hqAybtPffQoBdgc+1BxbX?=
 =?us-ascii?Q?3XwUxkknWX6VQUhR76hjTBUgyauCB7+38b3Mhiix0eXED6Fs20/5Q9PhFLrr?=
 =?us-ascii?Q?COJrb2SuyB5jB9CIWJ8M9i+YKYt1yHEUwedVIMKuYAUdDL9reQ8u8yCSujyc?=
 =?us-ascii?Q?mKCr2PEhcZYaZCjtkpVFjBW1W7pQFa8iR4uUdtrXgGdQh5KWgng1AgDKT8hn?=
 =?us-ascii?Q?migC06smKe2l3B6b52dhiQrcnINJfdsjtjhgqTxqb5ecCiQb9S940MGH6ucb?=
 =?us-ascii?Q?XZ6PmQ/tikuaKytOyp9iZxmZfeTIjQpHfkWtgeY25RX6CrjcrzmztYiEUnPQ?=
 =?us-ascii?Q?LwBmAAj9JEaVsGHuSX7acFPxAv0UiQYGnWWoD73YEL9n5VL10fB0dgEB195F?=
 =?us-ascii?Q?eBSYj+hntveDHE7oLY5N+m4coAZEErxNsME/Sp20FuhxMVux8YEaC9L6HpEw?=
 =?us-ascii?Q?UlYTf2EuRe62Dtive5g6J7+NOvwvgkIPTgjNspN05EwGuz0rpFfKhaAkxeEt?=
 =?us-ascii?Q?33DVOe47ULg8mirQUa1FrFV1xM0PXIJ7q0/wsZx10DuEqz5txwlULcuNC4qe?=
 =?us-ascii?Q?R47JF4UWTxbL8ynKAxXnZryqyUoa0nqhEsNF0GhpzcTtwvm17tlKhaUGjNh/?=
 =?us-ascii?Q?eELNGZLjM5/zMvx/nalnRUtShcXdTWkRHSQ9KDONFHGn2L63nirpsgGmCOYl?=
 =?us-ascii?Q?lLWl6wjkXcJr6isFZP+2CWjV7Kspwzh/qLqMuB81B6HNbodxZdzQ9PNzyuje?=
 =?us-ascii?Q?K4s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57853485-82b7-4b1e-645a-08d97d63c8cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 00:56:17.1858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D1CJDNAD8wpq62ID39tS1fmQkFtV3egyduwS5zcMdfeWFoQnjn7XzF82+W/bKEPSSLrq0/cST6+7VZIJ5kJogQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1330
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, September 22, 2021 3:56 AM
>=20
> On Sun, 19 Sep 2021 14:38:30 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > This patch introduces a new interface (/dev/vfio/devices/$DEVICE) for
> > userspace to directly open a vfio device w/o relying on container/group
> > (/dev/vfio/$GROUP). Anything related to group is now hidden behind
> > iommufd (more specifically in iommu core by this RFC) in a device-centr=
ic
> > manner.
> >
> > In case a device is exposed in both legacy and new interfaces (see next
> > patch for how to decide it), this patch also ensures that when the devi=
ce
> > is already opened via one interface then the other one must be blocked.
> >
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio.c  | 228 +++++++++++++++++++++++++++++++++++++++----
> >  include/linux/vfio.h |   2 +
> >  2 files changed, 213 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 02cc51ce6891..84436d7abedd 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> ...
> > @@ -2295,6 +2436,52 @@ static struct miscdevice vfio_dev =3D {
> >  	.mode =3D S_IRUGO | S_IWUGO,
> >  };
> >
> > +static char *vfio_device_devnode(struct device *dev, umode_t *mode)
> > +{
> > +	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> > +}
>=20
> dev_name() doesn't provide us with any uniqueness guarantees, so this
> could potentially generate naming conflicts.  The similar scheme for
> devices within an iommu group appends an instance number if a conflict
> occurs, but that solution doesn't work here where the name isn't just a
> link to the actual device.  Devices within an iommu group are also
> likely associated within a bus_type, so the potential for conflict is
> pretty negligible, that's not the case as vfio is adopted for new
> device types.  Thanks,
>=20

This is also our concern. Thanks for confirming it. Appreciate if you
can help think out some better alternative to deal with it.

Thanks
Kevin
