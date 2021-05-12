Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BC137B711
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 09:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhELHrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 03:47:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:46201 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhELHro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 03:47:44 -0400
IronPort-SDR: Svgy6PaEQIHDuFq1Kg1WSXtWYG5XRLpr0iQ8KelueiRsk8m2N1Qd63Op13qsyXuupAjvAiTVlJ
 z9AWYCNyd3nA==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="285147605"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="285147605"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 00:46:22 -0700
IronPort-SDR: EUSc8OFbHcR7H9eqzZG4seteHK/SB2/lTP+jbwfnNgg9d5Otvvq4Yyltk1za7TpruXaa/5lHyP
 TyUeTXA9X1Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="609808062"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 12 May 2021 00:46:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 12 May 2021 00:46:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 12 May 2021 00:46:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 12 May 2021 00:46:15 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 12 May 2021 00:46:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SO3qUVvNTcEfdC1gFKJWFLOb5vM4O9c5P41r6gYVIGW9JtmSWiJ6qMxmYHpEEj/HDJumgTgEcxRYTwFc4Teulk0pQjCoiQgM7ojBRzXF0BgOo7zHwfvDzu6/6OAX+5RGVIZZGDcML46swALXEnRdSRzVhSBZK8OtuPYz2D7vOiuvPiISUlBa5o4jzpFOqgATZir6z5DrwILisRc0bpn4rBt081NkSU6O5vDja9RizYPUgAhs/JdbcuhNkcdQeDHs9Wj2OzppHRHZwNt5o7hTJw46CHIGcGaKQtghCjOsI8M0yY48rwhScd+q2J5hAMgjdPgiuKZCCbHd334Gvg96sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65glzLarSfir5JzpRI+US+4zyPYTot968aAGKPjOyS4=;
 b=JqT82FHfpLPtl8wHlfZvu7fFUorWiwkbW+jciz/R75sT/JCm5X96XrQHMOkrMLqy83OHDXpMd23hwD8TxM2vytQynavr8m+9Y4ujU3hxiOsd2a76YqVFfY+9UBYqT/9eCE/xIvsFq2LD8WDVwGTAwbp/vcL9XAhoEM2BM6QnYKOXPu7sT7LNbwRt0SrY9W2nYkVG680MPmAruy0DCvExFMN5+LsEFjJYsVeIRUUUdcQ1qkdt7jH0EuTOHlZxQitTR8Bhcwx2xzfRUOinO4n907kgYU9v66+jrmcfbciUWxxMEILS44PhkuSTpBJi79ENxNVFDozcv3oCPyZbw0OsUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65glzLarSfir5JzpRI+US+4zyPYTot968aAGKPjOyS4=;
 b=cevVk9pgElfnwJQlTHuhz8rl6t3LfzN1JaffmWdKt4hjSWbVIhaS3xZTfZ2opwYUYhU/PWHla753m/5D+x+8qgdPP0mA5ykEXA2Vd46mU8P/xXaE9IG5R+RwPCzmx8jouNFnL+IISRu1kwYY+dQvPTaA7/jF0pofGP0hFoMPAbA=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1823.namprd11.prod.outlook.com (2603:10b6:300:10e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 12 May
 2021 07:46:05 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.4108.032; Wed, 12 May 2021
 07:46:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
CC:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: RE: [PATCH v8 7/9] vfio/mdev: Add iommu related member in mdev_device
Thread-Topic: [PATCH v8 7/9] vfio/mdev: Add iommu related member in
 mdev_device
Thread-Index: AQHXKx+RnarxvSHJQ0qqACGXvCESaareDy2AgACzFYCAANYSMA==
Date:   Wed, 12 May 2021 07:46:05 +0000
Message-ID: <MWHPR11MB18866988310787FE573763878C529@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20190325013036.18400-1-baolu.lu@linux.intel.com>
 <20190325013036.18400-8-baolu.lu@linux.intel.com>
 <20210406200030.GA425310@nvidia.com>
 <2d6d3c70-0c6f-2430-3982-2705bfe9f5a6@linux.intel.com>
 <20210511173703.GO1002214@nvidia.com>
In-Reply-To: <20210511173703.GO1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd6f46dd-067a-4e8c-eb20-08d91519ffb8
x-ms-traffictypediagnostic: MWHPR11MB1823:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB18238C7FAFE4369257BF24AA8C529@MWHPR11MB1823.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XGBYdKYyd+znCqf2fGCuS+Wkyn5IbQg+z/WoxsBdNp61ZqlNWczcCcf4qViM3b/1lxLAJVB4O1w3wJQP/4z9Qarjf1kAB/YHcqVym32/ZzXfqXUT6rLv68Ac79XRfol5hQYqiATq1ASPv2BpleLvSDpyWtQt/RoJGYPVivejtaj11Qqm9MambpV0EVVQ6Q1AVfMROSz3gtCjAudCbB4xhdDNWHnYsjFYJiG9trYeIsYMrQYz138YcmNlNconyvtnM2A+b5nmK05YXA6DMlAOvhrpwsXsdVTiZLxGUYB6HJkso5FxRyUajHFujL4Ol46tqKAQKEXdmzLaAitEFdcnHnkeCGbaOc/QT4qf0UqiClqL2sTm/6ps7r0AT6ISAztqCZ6QJHOqTSVUmewh5UpFhlEVgjbv1cHf6oDE/C+drWHkAsispDOziLNsjD3ynH/vMp5pph5oXo3sRlWHav4OemgO2D9HVzxtKgJQrIvIH5X5xDprCiWVxIoO+0zXIoEhiQ3BbUcHYdle9AZqNrf4/a4KQAQOo9oHiVydsk1iXhQVWCf6UECtvsLbW9yKqJSQ+Vq/G+ortgZHoBPTp6zqaaRq+bYl1d+WY0BNL4ZVY8k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(6506007)(316002)(83380400001)(110136005)(52536014)(54906003)(71200400001)(7416002)(66446008)(86362001)(33656002)(64756008)(26005)(4326008)(9686003)(478600001)(2906002)(186003)(5660300002)(8676002)(7696005)(8936002)(38100700002)(122000001)(76116006)(66476007)(66556008)(66946007)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WamgWwbom3w8HbybIv2KqoqyO6NUA9DLsM12AI+oZsdgxFU6g6q60giP5N5a?=
 =?us-ascii?Q?vyv4CyzcS7nWzHgYvryWRvhcg4Kasu5O+V0KBP85uXJuZO4w6nrPF6HFg98P?=
 =?us-ascii?Q?feCMUit4USvxzv7Dynq45n2xtqIQ3le7wtGxJHpYCcYli0VMlhPmKon0Rhq3?=
 =?us-ascii?Q?+flgehHGQACk0KeQOhGZ3BgGNWSjHMpXgIuHRmJLVRTXOJSD9OLq8h88LnyA?=
 =?us-ascii?Q?5I6Ik+pzoF8D08CVMZSrXJIjHjD3ah9P1U4CjkmT662h4pb8UEE1X4DFAsKF?=
 =?us-ascii?Q?ly8dlGuvsL0lXF+YPFBk+YLlr2Z41/3Sj1qP6gb1fbp2yaJ90pJa2oagHOl3?=
 =?us-ascii?Q?3k3dFdKxTtxjlZ/r5PnnwHJYt1cKi/t2xQxJ7AG6v3SZftHPdTRAQSt/QxE/?=
 =?us-ascii?Q?S9hf43Gz79gzqJZTohohZStU2KmwkycqfZHRj3ZnpeDzbZ/XFHt9ekH/8KHy?=
 =?us-ascii?Q?/d+33WBeh7BzWoMk/z3p/mU0XnbnEK+QJ2ujwEilfwYIFuyoTpdznLYBt2g5?=
 =?us-ascii?Q?dkYjJMWd7LkBRU/4OeXci++RdNiLeqVBSXxGWKJehoAGcL5y7OMTJI4mwUGS?=
 =?us-ascii?Q?S4ZuXcUuKYoGsGmQRQ0wN84N6AbzMY3hzItRLFS0lcEWhhnT9S+UtDHHX91Q?=
 =?us-ascii?Q?13q7WSugVF9dvts3kg8kl/SW88qVpnacoTvfxOF0PM53CREyL7reIdlVoPai?=
 =?us-ascii?Q?Da0NTh3WHb9ziSw6jBVNeMBs7XYEmbuFaQojZQJd1EsGIF08N3MdXOqJYzNO?=
 =?us-ascii?Q?hVFQYstPmWueoE9zxMXAAOR5oC62OyGKMeHSLUWvS9501NJa8eLxXoLg51dt?=
 =?us-ascii?Q?1lWmMW4iIYNv9O38dytgES0ww6svXjIDIDWZGOWmx3jMOYRReB4TwHXMPtkF?=
 =?us-ascii?Q?bh4jN3AQrCLPKOls6O/y7c8q5tPLP8/ydF6YcteMAuDzfmXCxTr9nyEHZnFQ?=
 =?us-ascii?Q?/DYqC2NOnr7dkIpj1fpJ7W5hiWldL/NOavmiWGloS+XAct5ra+ntxipJIHJm?=
 =?us-ascii?Q?PkpDPZsz1AxYbGY+DuK06cuJ0QBwmFGHcpApN9X/uaHxqdjmVZvyGxib+j1C?=
 =?us-ascii?Q?4Pv/1L9MkeR3Q5aJNAKxyHz6ezWBf5AjxL2ZFqY5f2RQlrM5UcdABeOS0V2H?=
 =?us-ascii?Q?qGGZpftfjklQGN7PvT+0+tD+X7U2KMlxo7EoeoWtVxURVh1ef0ETnllgc5k7?=
 =?us-ascii?Q?nyCFztdY1cLVO4hcGwe1svubvfQrNNVlM/y5G45lymk4iRwvO99c+V/NB7+R?=
 =?us-ascii?Q?rCCycPwacuCMR8p6/pDrZPoqMDjdiSeGzByLljoz0pOR99DMoUTGue5xs5t1?=
 =?us-ascii?Q?DFgT36p+ofJ/W0/StbkprO7P?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6f46dd-067a-4e8c-eb20-08d91519ffb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 07:46:05.3652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OnbAgVzO5TlpBcoGtIf6rQ7mwbEzC/UTR+cQJpetyuC9WuVUi/4z0GmE9Put+mrBt3fHtevkXhSACxzdqa8Q9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1823
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, May 12, 2021 1:37 AM
>=20
> On Tue, May 11, 2021 at 02:56:05PM +0800, Lu Baolu wrote:
>=20
> > >     After my next series the mdev drivers will have direct access to
> > >     the vfio_device. So an alternative to using the struct device, or
> > >     adding 'if mdev' is to add an API to the vfio_device world to
> > >     inject what iommu configuration is needed from that direction
> > >     instead of trying to discover it from a struct device.
> >
> > Just want to make sure that I understand you correctly.
> >
> > We should use the existing IOMMU in-kernel APIs to connect mdev with th=
e
> > iommu subsystem, so that the upper lays don't need to use something
> > like (if dev_is_mdev) to handle mdev differently. Do I get you
> > correctly?
>=20
> After going through all the /dev/ioasid stuff I'm pretty convinced
> that none of the PASID use cases for mdev should need any iommu
> connection from the mdev_device - this is an artifact of trying to
> cram the vfio container and group model into the mdev world and is not
> good design.
>=20
> The PASID interfaces for /dev/ioasid should use the 'struct
> pci_device' for everything and never pass in a mdev_device to the
> iommu layer.

'struct pci_device' -> 'struct device' since /dev/ioasid also needs to supp=
ort
non-pci devices?

>=20
> /dev/ioasid should be designed to support this operation and is why I
> strongly want to see the actual vfio_device implementation handle the
> connection to the iommu layer and not keep trying to hack through
> building what is actually a vfio_device specific connection through
> the type1 container code.
>=20

I assume the so-called connection here implies using iommu_attach_device=20
to attach a device to an iommu domain. Did you suggest this connection=20
must be done by the mdev driver which implements vfio_device and then
passing iommu domain to /dev/ioasid when attaching the device to an
IOASID? sort of like:
	ioctl(device_fd, VFIO_ATTACH_IOASID, ioasid, domain);

If yes, this conflicts with one design in /dev/ioasid proposal that we're
working on. In earlier discussion we agreed that each ioasid is associated
to a singleton iommu domain and all devices that are attached to this=20
ioasid with compatible iommu capabilities just share this domain. It
implies that iommu domain is allocated at ATTACH_IOASID phase (e.g.
when the 1st device is attached to an ioasid). Pre-allocating domain by
vfio_device driver means that every device (SR-IOV or mdev) has its own
domain thus cannot share ioasid then.

Did I misunderstand your intention?

Baolu and I discussed below draft proposal to avoid passing mdev_device
to the iommu layer. Please check whether it makes sense:

// for every device attached to an ioasid
// mdev is represented by pasid (allocated by mdev driver)
// pf/vf has INVALID_IOASID in pasid
struct dev_info {
	struct list_head		next;
	struct device		*device;
	u32			pasid;
}

// for every allocated ioasid
struct ioasid_info {
	// the handle to convey iommu operations
	struct iommu_domain	*domain;
	// metadata for map/unmap
	struct rb_node		dma_list;
	// the list of attached device
	struct dev_info		*dev_list;
	...
}

// called by VFIO/VDPA
int ioasid_attach_device(struct *device, u32 ioasid, u32 pasid)
{
	// allocate a new dev_info, filled with device/pasid
	// allocate iommu domain if it's the 1st attached device
	// check iommu compatibility if an domain already exists

	// attach the device to the iommu domain
	if (pasid =3D=3D INVALID_IOASID)
		iommu_attach_device(domain, device);
	else
		iommu_aux_attach_device(domain, device, pasid);

	// add dev_info to the dev_list of ioasid_info
}

// when attaching PF/VF to an ioasid
ioctl(device_fd, VFIO_ATTACH_IOASID, ioasid);
-> get vfio_device of device_fd
-> ioasid_attach_device(vfio_device->dev, ioasid, INVALID_IOASID);

// when attaching a mdev to an ioasid
ioctl(device_fd, VFIO_ATTACH_IOASID, ioasid);
-> get vfio_device of device_fd
-> find mdev_parent of vfio_device
-> find pasid allocated to this mdev
-> ioasid_attach_device(parent->dev, ioasid, pasid);

starting from this point the vfio device has been connected to the iommu la=
yer.
/dev/ioasid can accept pgtable cmd on this ioasid and associated domain.

Thanks
Kevin
