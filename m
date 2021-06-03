Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFCC399B5D
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 09:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhFCHTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 03:19:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:47511 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhFCHTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 03:19:13 -0400
IronPort-SDR: K1rP78kPK9M01UMINHwhwW98MciqkqgrtqOTe5brzXmaISRhVszF5Oxc3XLyF72lW60SNPA2mZ
 iICVL/s/MLqg==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="184356547"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="184356547"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 00:17:28 -0700
IronPort-SDR: NlW2f3mmaNVSiYWVKR/1MiUqImS2L2tlzxd32FJKIMkjgdMNLxamY1u+nmH7SbY1y0juo/Z90i
 CqNFb31Xpm/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="474967213"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Jun 2021 00:17:28 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 00:17:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 00:17:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 00:17:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJIdbFnEUqXTVgkA098hwmXIiMOm+pJQxss5XMJHEeS49Kv/Irgs1nvpCbMzEwgnP/Xh1d4JUe4K1/iukbmJxce2MKPzuW15kBm9mOKdiQYR0x8jCm87hh699k+HC1m7cRRMrvdH2mD9/kSt5p33B66tI7WGOa7oFBIzx6SQW+ZNUFexkFq9pDYyYKjFjPgHHmhWZ65NJ/Kd+zZquZOyNXXhn58R2vQsRdhTRAE5G4l2ZSD3r2X/nU+a+08ALsh073Zvascsog/NuI54Xk0kkRK5ng6qTpcnZZYreFHK1k/M/+WJ2tuLdwzhoKZBfJCGXqzXs4+eoEvgG+Mj2CEXww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzMRrRLsubm/trqIzq7AbjnYJaawEVmjm6m7Vc6COag=;
 b=ZLJfOLzuiTMIfPlip/2oSPURyQ74gJ1br5z5++a8tEEGO0Z+DE68Prh2WYhjxZK06Ex9Nv878ZWNMSKbdPS6eVlfkredjrbKJ0+1jQwuCFf/LvlmbEJi9CnHafwe8PX885+yaxVXgc3W9L70L1yMeFwMMzVIVjTLb4/hQei739vPauB8fmoN5V+gHWC98/iXeco3I7PFVP4oHRP8ZS33o7nP4ni7cGyLoGZIHerxDch9K9Qlvu3kU3GnTU7YrbcLtMpcGTP/DI+mFStXUvJvZ9p7iwLxFS8pbUWF08/RhA5wzw7+enezGMuT90rUNub+KfAHtyKvqbFYEDAVznItNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzMRrRLsubm/trqIzq7AbjnYJaawEVmjm6m7Vc6COag=;
 b=j2vZs1PNiK/8sXW4Cezb/YLWHLJENWdMDD5kzOdSml7ZqF/L7uefXaBsrtOwdC2CBZ6TTF1eoBwxM0hP4MIam8fUuuPqsCvaXoDle3JxbTXvDpKc3XVIgYOMSXIZFU9M+3A3w3boRZ2RXE+awb5E5MjCXVGQDjZUH1q8bdw5MGQ=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1360.namprd11.prod.outlook.com (2603:10b6:300:26::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 07:17:24 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 07:17:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwEqZK+AADPpzDA=
Date:   Thu, 3 Jun 2021 07:17:23 +0000
Message-ID: <MWHPR11MB1886081DE676B0130D3D19258C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
In-Reply-To: <YLch6zbbYqV4PyVf@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64a913e4-a90c-44f1-406d-08d9265fa2b4
x-ms-traffictypediagnostic: MWHPR11MB1360:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1360DB0E83899FC0B79CB7AF8C3C9@MWHPR11MB1360.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vvO2XHjSXfC0fgmwQtVVCHocmNXTuppQXYkTayNRkLQ3b0MBqx1XvHv5H2DaNMO/mtWt8LzmBoZjuIkF68luQHlZ1E+4r74hSM/IaWPBLkiartCGFo/lkX5JWMiDltQ1I6KL4nJN3je994nZvKhFMm3/xl9iaAVi0/fL45EOH5T4eY9qYLJxEFwHmDwUa+KdEcmQfMVpmdlqnBtW7O4A23HQk2rvBhBJ4RhDsFapd0y3xy6leYLTx/Qfcpts7URMB0DyiwTVchrYeG4BQPSzyxHGS9JMRYepiMjDfdnZmZMOJEEW9gHRX7gok980DpsVMreyaxe/WayQG3arqVd4UcHWoCLSOiUnxWmmE61okDVxCwDXLhyeyAb7tMJqKpKKFX95UA7h2Gzam/8v1KDRTj6lCDcq/gYqC2YlOQ4okEML9KKaCcfKhS7AfcS+08Gvv0XAhZXmXkyeuX5pz7TJUMYYJ50xzq7GpudV+EPAXV8t2di+VZ9/BElqfHzGb6MEmJhthngHbD8cA8qjW/9rRd8VoEdpS0B4wC3cVlVAeo+gCiNwkgoSH8xT+8pEzLO+ZTeYYjn+NoT/0Tf4M9NHqNfKdCWpq/9puoIBVKtThUE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(396003)(346002)(8676002)(54906003)(4326008)(8936002)(5660300002)(71200400001)(33656002)(478600001)(316002)(83380400001)(6506007)(26005)(66946007)(76116006)(7696005)(64756008)(66476007)(66446008)(66556008)(2906002)(52536014)(6916009)(122000001)(38100700002)(7416002)(186003)(55016002)(9686003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VQqsfrTtzq53pcZsZcRcLKnaNGoGAhz42cT/XjBHOmVIy90YYf6YAYaSgjkS?=
 =?us-ascii?Q?8JYruOhF6f1DtRSYdCQfy2N9bBHe852a4J9UCrzWiGxfw6u+HHw9Uhtb9eCr?=
 =?us-ascii?Q?y7alXrZgrSMlyN04/usvJBnJsZ5nplAM1stWL/p3425jK1cmMwfxQrUqdcEI?=
 =?us-ascii?Q?RZGCX3RWDsnqphV5jpczuqI8+1xswQ6QKJbV5JPcSmA8WNm4vJVKjPVNwAov?=
 =?us-ascii?Q?/3jaKbBKTxbJoN8I0brW7MyRoEhN4o5atpRzMus2MdNE1QiIII5At9bwBRKk?=
 =?us-ascii?Q?R+5bpDb/x996uJYVWaHu0p2lfMM9hTXNcI8sYWlPKRMuc/U3lbPD+fNlie/m?=
 =?us-ascii?Q?tmJVc26T3bEyRlA0SyunLpj7iQEX7wKHwJmw0C1pLfTb58WRKvw/+4zFGVki?=
 =?us-ascii?Q?Y3Pjsg84k5IC4BBFSOl7cSwOcAdE6H4VLboh2Sp28hZb8ZcZEJILF5ey1FXe?=
 =?us-ascii?Q?De609ptnCSB5MDpSSu9BAsESiHbt1VaxssoG147OygtTHJnXLxrXJRfu+Tsr?=
 =?us-ascii?Q?+k5O2ROg+ybR6jvsttfxnenSwEPcT2bz+y5Wg0tznYFoH0/3pccsGviLYerf?=
 =?us-ascii?Q?24zxKMXztEbA4U0Zlrl/DaCTWH4efb3/LsJGM/4Vcxa1pu2WMu1ZblUk4ef3?=
 =?us-ascii?Q?hkILUX7vHyC7Hf9Ezg8/ZMpU7NJsOwyCIPBVtc9MKy0Mb/2jFtXWTthzhf/m?=
 =?us-ascii?Q?YWV3DQHQQ9NqhhFs0P5l59CxFR21YyBF2ntyBgPfHr5n+BNBtLQ6qgKtCHuD?=
 =?us-ascii?Q?4MhLic6CdTiy4TBM8qpvh0/xnE+JF3P0Sm+Cuee/L4n3P0hheX7EOPlP1ktY?=
 =?us-ascii?Q?sZPkbZeyWyDY2WJ/ZaPIQ/IsmUatvPGv6Iji2FHBZeD3//mrRC9AS5pPxsOB?=
 =?us-ascii?Q?edlVtIhWqzLQGt3hu4Bc3aW+axPqzvR3ROvlmjCb+LYHtqKQyDdO49Ppo1rz?=
 =?us-ascii?Q?gV4JhdR50mPeY1CGTzRBPhksQC5zH6FFgvlMi6Ouna6pvIRoFyRweh+bEASe?=
 =?us-ascii?Q?qzqzR+I0kTSuEgBMzpUJx3KgyaFXCL+ztsD5PWGwKB5aJW0UW4C0muqpz4lM?=
 =?us-ascii?Q?zSyS49AVrriJSaf5q9ubsAAhlfQZD32g9hDCReHYWligYTe778uz1nb6nhn8?=
 =?us-ascii?Q?1EfqmJbl4YdBn4ZQWSU130kIub9bYBLLyyjtvvZWkT59hAMp9cBFhl1xrAVF?=
 =?us-ascii?Q?TqkYA1KRrNArpTNMxp0LrJkPD9aDdlsJmkEuH4BnA+n1rg/jl6PYdC5RQ/Fo?=
 =?us-ascii?Q?G8y9rXy+Q7rDnC1oHXXMwTdhan9Isgn3bfG534FnPhKPxToF9Xc8dA9s2R1F?=
 =?us-ascii?Q?ZiWYE2Q+iT5jCm/eSAK6J844?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64a913e4-a90c-44f1-406d-08d9265fa2b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 07:17:24.0237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EiSHQtk1hCQqz8vLwKKACBrhRP7SvJ7XDj0XKh4jxsC9R01mnJerPYTvD5kPpD+35Adls8XnUIGJN0j94Mjrzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1360
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson <david@gibson.dropbear.id.au>
> Sent: Wednesday, June 2, 2021 2:15 PM
>=20
[...]=20
> > An I/O address space takes effect in the IOMMU only after it is attache=
d
> > to a device. The device in the /dev/ioasid context always refers to a
> > physical one or 'pdev' (PF or VF).
>=20
> What you mean by "physical" device here isn't really clear - VFs
> aren't really physical devices, and the PF/VF terminology also doesn't
> extent to non-PCI devices (which I think we want to consider for the
> API, even if we're not implemenenting it any time soon).

Yes, it's not very clear, and more in PCI context to simplify the=20
description. A "physical" one here means an PCI endpoint function
which has a unique RID. It's more to differentiate with later mdev/
subdevice which uses both RID+PASID. Naming is always a hard
exercise to me... Possibly I'll just use device vs. subdevice in future
versions.

>=20
> Now, it's clear that we can't program things into the IOMMU before
> attaching a device - we might not even know which IOMMU to use.

yes

> However, I'm not sure if its wise to automatically make the AS "real"
> as soon as we attach a device:
>=20
>  * If we're going to attach a whole bunch of devices, could we (for at
>    least some IOMMU models) end up doing a lot of work which then has
>    to be re-done for each extra device we attach?

which extra work did you specifically refer to? each attach just implies
writing the base address of the I/O page table to the IOMMU structure
corresponding to this device (either being a per-device entry, or per
device+PASID entry).

and generally device attach should not be in a hot path.

>=20
>  * With kernel managed IO page tables could attaching a second device
>    (at least on some IOMMU models) require some operation which would
>    require discarding those tables?  e.g. if the second device somehow
>    forces a different IO page size

Then the attach should fail and the user should create another IOASID
for the second device.

>=20
> For that reason I wonder if we want some sort of explicit enable or
> activate call.  Device attaches would only be valid before, map or
> attach pagetable calls would only be valid after.

I'm interested in learning a real example requiring explicit enable...

>=20
> > One I/O address space could be attached to multiple devices. In this ca=
se,
> > /dev/ioasid uAPI applies to all attached devices under the specified IO=
ASID.
> >
> > Based on the underlying IOMMU capability one device might be allowed
> > to attach to multiple I/O address spaces, with DMAs accessing them by
> > carrying different routing information. One of them is the default I/O
> > address space routed by PCI Requestor ID (RID) or ARM Stream ID. The
> > remaining are routed by RID + Process Address Space ID (PASID) or
> > Stream+Substream ID. For simplicity the following context uses RID and
> > PASID when talking about the routing information for I/O address spaces=
.
>=20
> I'm not really clear on how this interacts with nested ioasids.  Would
> you generally expect the RID+PASID IOASes to be children of the base
> RID IOAS, or not?

No. With Intel SIOV both parent/children could be RID+PASID, e.g.
when one enables vSVA on a mdev.

>=20
> If the PASID ASes are children of the RID AS, can we consider this not
> as the device explicitly attaching to multiple IOASIDs, but instead
> attaching to the parent IOASID with awareness of the child ones?
>=20
> > Device attachment is initiated through passthrough framework uAPI (use
> > VFIO for simplicity in following context). VFIO is responsible for iden=
tifying
> > the routing information and registering it to the ioasid driver when ca=
lling
> > ioasid attach helper function. It could be RID if the assigned device i=
s
> > pdev (PF/VF) or RID+PASID if the device is mediated (mdev). In addition=
,
> > user might also provide its view of virtual routing information (vPASID=
) in
> > the attach call, e.g. when multiple user-managed I/O address spaces are
> > attached to the vfio_device. In this case VFIO must figure out whether
> > vPASID should be directly used (for pdev) or converted to a kernel-
> > allocated one (pPASID, for mdev) for physical routing (see section 4).
> >
> > Device must be bound to an IOASID FD before attach operation can be
> > conducted. This is also through VFIO uAPI. In this proposal one device
> > should not be bound to multiple FD's. Not sure about the gain of
> > allowing it except adding unnecessary complexity. But if others have
> > different view we can further discuss.
> >
> > VFIO must ensure its device composes DMAs with the routing information
> > attached to the IOASID. For pdev it naturally happens since vPASID is
> > directly programmed to the device by guest software. For mdev this
> > implies any guest operation carrying a vPASID on this device must be
> > trapped into VFIO and then converted to pPASID before sent to the
> > device. A detail explanation about PASID virtualization policies can be
> > found in section 4.
> >
> > Modern devices may support a scalable workload submission interface
> > based on PCI DMWr capability, allowing a single work queue to access
> > multiple I/O address spaces. One example is Intel ENQCMD, having
> > PASID saved in the CPU MSR and carried in the instruction payload
> > when sent out to the device. Then a single work queue shared by
> > multiple processes can compose DMAs carrying different PASIDs.
>=20
> Is the assumption here that the processes share the IOASID FD
> instance, but not memory?

I didn't get this question

>=20
> > When executing ENQCMD in the guest, the CPU MSR includes a vPASID
> > which, if targeting a mdev, must be converted to pPASID before sent
> > to the wire. Intel CPU provides a hardware PASID translation capability
> > for auto-conversion in the fast path. The user is expected to setup the
> > PASID mapping through KVM uAPI, with information about {vpasid,
> > ioasid_fd, ioasid}. The ioasid driver provides helper function for KVM
> > to figure out the actual pPASID given an IOASID.
> >
> > With above design /dev/ioasid uAPI is all about I/O address spaces.
> > It doesn't include any device routing information, which is only
> > indirectly registered to the ioasid driver through VFIO uAPI. For
> > example, I/O page fault is always reported to userspace per IOASID,
> > although it's physically reported per device (RID+PASID). If there is a
> > need of further relaying this fault into the guest, the user is respons=
ible
> > of identifying the device attached to this IOASID (randomly pick one if
> > multiple attached devices) and then generates a per-device virtual I/O
> > page fault into guest. Similarly the iotlb invalidation uAPI describes =
the
> > granularity in the I/O address space (all, or a range), different from =
the
> > underlying IOMMU semantics (domain-wide, PASID-wide, range-based).
> >
> > I/O page tables routed through PASID are installed in a per-RID PASID
> > table structure. Some platforms implement the PASID table in the guest
> > physical space (GPA), expecting it managed by the guest. The guest
> > PASID table is bound to the IOMMU also by attaching to an IOASID,
> > representing the per-RID vPASID space.
>=20
> Do we need to consider two management modes here, much as we have for
> the pagetables themsleves: either kernel managed, in which we have
> explicit calls to bind a vPASID to a parent PASID, or user managed in
> which case we register a table in some format.

yes, this is related to PASID virtualization in section 4. And based on=20
suggestion from Jason, the vPASID requirement will be reported to
user space via the per-device reporting interface.

Thanks
Kevin
