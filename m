Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEB120EB34
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 04:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgF3CAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 22:00:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:27064 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgF3CAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 22:00:53 -0400
IronPort-SDR: jcus4yDqKu4tJLw9kEEfolubmaV3qolzkmvD9uTjXw3CbFwzDKftXPSFg9lFK9fsTBy3XGUMpF
 Y8CRtAJOmExw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="143602967"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="143602967"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 19:00:52 -0700
IronPort-SDR: 3wVrju1Zt2XU4t+gH4O96wN7wVrjSDK9v17dC/wu/Za0xyv96GbHW5wXTx+pNXBUxtBsyRz0Fv
 YeeDS881i/Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="281061450"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga006.jf.intel.com with ESMTP; 29 Jun 2020 19:00:52 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 19:00:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 19:00:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mizIwgAyWjW/Jd/jCB7PXP8tkBBsqL6xUW7LcsznY+aPZN9nxLyXMfA7unW6oMoqzv4y2uNUNBIfAkQpdrhIHK80bMd4L4cKYxGQF/eQBUohDT+Ss9Q7fnmh1gxDM7dqeSGO2iD5BAGISFNsX5PnMyF/Ai81v6ICtEEl+07yfVOaNJR4xg0fhqwyiaSRzAb6ftifIdsF2NPB+l6GI/hy+VbV0LF97oqz69R2jnpCW9QuDQ7re5D6d29BwhgILsMz+KlDvAYsJF98MCEyt5AMXbYWbDR27bQtcIoQFFLSlbqBzwCC9SknERC3C57yvTnILQ5bjFkFmNPK5WxJNhxp1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr9VI6/LgTjOXypC5id/RwphEVY5eJ0P8f4wZjPYhRg=;
 b=IWbL2fF6q0LoXg1RG2Jhyvq/AjRfkUf0fb/BA1rV2XcoddDqacV/+Ewppo8letd+8gaYZUdoBRfql47Q3AY/f2kdvY7MgBxIOwvRAIMbsrrzZg9pudxTNM3r/FuOtUKGtq0Gvlz9JGwYy7vObjBYRVv+c2xxHspP99ATM+xW234DPLezSANPXykoOJ4PgV9hwTetvSQiWCLtwcEi8PsASmdEA5zDS+xzTPoGUkhuJT3dcxmolJzv0PS14hJbUDrTbbgWYLpD8IHyIwmt2N0A5gL3IKLpNQGLYnDBGfcZzSRvQvZ3tF5rGyh5vkVETbz2IrI1x6N6tq41e40ribIANw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr9VI6/LgTjOXypC5id/RwphEVY5eJ0P8f4wZjPYhRg=;
 b=IGRJt5OHYB48z7aOHRRCgZjMJDjz4rZIshKdi7oIiaMzeIs4wnsoSWNsiwxGLzYS+PhSdeAQXguLT6/PPQmwcD02cDrkCRYtANGn3JOpc8c4koheq5fTJAzE3B5SPsTU78p97o51RbBFlAzNKNAwofKuc07NI/7xeIqB0OPO7w4=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1600.namprd11.prod.outlook.com (2603:10b6:301:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 02:00:49 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 02:00:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v3 02/14] iommu: Report domain nesting info
Thread-Topic: [PATCH v3 02/14] iommu: Report domain nesting info
Thread-Index: AQHWSgRQYPLf19tsF0i4Fom/j2zC7qjvWjsAgAAx1ACAANlZcA==
Date:   Tue, 30 Jun 2020 02:00:49 +0000
Message-ID: <MWHPR11MB1645B09EBDC76514ADC897A68C6F0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
 <20200629092448.GB31392@stefanha-x1.localdomain>
 <DM5PR11MB1435FC14F2E8AC075DE41205C36E0@DM5PR11MB1435.namprd11.prod.outlook.com>
In-Reply-To: <DM5PR11MB1435FC14F2E8AC075DE41205C36E0@DM5PR11MB1435.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47ced898-e848-426e-3a26-08d81c996962
x-ms-traffictypediagnostic: MWHPR11MB1600:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB16001908EBC8928FE8F337EC8C6F0@MWHPR11MB1600.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nBBTpSGtX/0EZ/DTDpJHY4QeG3xQt8ltSxm2Plqe3QPWqzpB5m4jNr19ulmxhLQ0CJ1Pxbg1pakJUWI97muVbp7OH+mhQ1YQnlHYbjcEbCEutmAZveYy0N4S05rDeygfy8LZ3yZ/jDhm4c7IYtjV0/YvJvElTcGVpI9V+mf9ny/hpnZFf/TJRqTCqbqhoQyreIJNi0YdVlRQBFB4pkCxK3ROPQqD5hKgvNQke586QHA5X3xHgRZ4wo3kpq444gdNcuCQnlH7ttU8dS8PYAbbpv1N4V2OoYXU6k7GHhoRMltDGvY1cUq23OnQw5HyFX3nZqAR/BixogAMjyYD8xGFfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(9686003)(186003)(76116006)(66946007)(66446008)(4326008)(54906003)(8936002)(66556008)(5660300002)(86362001)(110136005)(71200400001)(66476007)(52536014)(2906002)(33656002)(64756008)(8676002)(7416002)(26005)(55016002)(316002)(478600001)(7696005)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yEh5+Uml/8KMDl7oSzfVTUJccRLQQ5ByQHwwtYHgWBex5DT5GcYLU780BOqOU+zqC5Tz5yQ+uC5FSgggKjd/TE5Ezpb+oDAhzoYEB+FwGFpUl31cesRzz+Lf0VyCTHE1Iw3a42yth97hhY/tyf4hPoMPzpeqEfsiG9TF+EDK7ABW5rPPwbyssDPVWSR/1ir/2qEj44anDgy2sID1IWR19FwI5olfviaYfUiAGWcHda/dv/r1zXULjHrB+Fxit4rozyREada/AQNc+Ep7SDs0qhLfcZuLZ/EtKqHgwOHpzwjsqo8aQxu1yGf7hETnUBp5yAKxoWtiIwjpm10mxyiB+MVgwsEI+vdXjGDDvU4QkeSC5pxI2WwiyRgkNtzJi+vdvU5VmoombVyJnnvvTqblWOIaZxpILAqkYX+nxrUxFMFX0uXOAZ4hthtKoSC4rnyRA4vN8qNxITlth51uUJpXis8R089rNWHPqeXMVk9flU2E9zLJ9sHMsFQSRv3aJO3t
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ced898-e848-426e-3a26-08d81c996962
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 02:00:49.5654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OEQJ3iA0K8Lp19jhEECZDtRQsq1DiR+K75klEjOQqfQpOLhjwuNfXtDxlV9x/561H3Ht5Pw5RhwZaTveOJrn0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1600
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, June 29, 2020 8:23 PM
>=20
> Hi Stefan,
>=20
> > From: Stefan Hajnoczi <stefanha@gmail.com>
> > Sent: Monday, June 29, 2020 5:25 PM
> >
> > On Wed, Jun 24, 2020 at 01:55:15AM -0700, Liu Yi L wrote:
> > > +/*
> > > + * struct iommu_nesting_info - Information for nesting-capable IOMMU=
.
> > > + *				user space should check it before using
> > > + *				nesting capability.
> > > + *
> > > + * @size:	size of the whole structure
> > > + * @format:	PASID table entry format, the same definition with
> > > + *		@format of struct iommu_gpasid_bind_data.
> > > + * @features:	supported nesting features.
> > > + * @flags:	currently reserved for future extension.
> > > + * @data:	vendor specific cap info.
> > > + *
> > > + * +---------------+------------------------------------------------=
----+
> > > + * | feature       |  Notes                                         =
    |
> > > + *
> >
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D
> > =3D+
> > > + * | SYSWIDE_PASID |  Kernel manages PASID in system wide, PASIDs
> used  |
> > > + * |               |  in the system should be allocated by host kern=
el  |
> > > + * +---------------+------------------------------------------------=
----+
> > > + * | BIND_PGTBL    |  bind page tables to host PASID, the PASID coul=
d   |
> > > + * |               |  either be a host PASID passed in bind request =
or  |
> > > + * |               |  default PASIDs (e.g. default PASID of aux-doma=
in) |
> > > + * +---------------+------------------------------------------------=
----+
> > > + * | CACHE_INVLD   |  mandatory feature for nesting capable IOMMU
> |
> > > + * +---------------+------------------------------------------------=
----+
> >
> > This feature description is vague about what CACHE_INVLD does and how
> to
> > use it. If I understand correctly, the presence of this feature means
> > that VFIO_IOMMU_NESTING_OP_CACHE_INVLD must be used?
> >
> > The same kind of clarification could be done for SYSWIDE_PASID and
> > BIND_PGTBL too.
>=20
> For SYSWIDE_PASID and BIND_PGTBL, yes, presence of the feature bit
> means must use. So the two are requirements to user space if it wants
> to setup nesting. While for CACHE_INVLD, it's kind of availability
> here. How about removing CACHE_INVLD as presence of BIND_PGTBL should
> indicates support of CACHE_INVLD?
>=20

So far this assumption is correct but it may not be true when thinking forw=
ard.
For example, a vendor might find a way to allow the owner of 1st-level page
table to directly invalidate cache w/o going through host IOMMU driver. Fro=
m
this angle I feel explicitly reporting this capability is more robust.

Regarding to the description, what about below?

--
SYSWIDE_PASID: PASIDs are managed in system-wide, instead of per device.
When a device is assigned to userspace or VM, proper uAPI (provided by=20
userspace driver framework, e.g. VFIO) must be used to allocate/free PASIDs
for the assigned device.

BIND_PGTBL: The owner of the first-level/stage-1 page table must explicitly=
=20
bind the page table to associated PASID (either the one specified in bind=20
request or the default PASID of the iommu domain), through VFIO_IOMMU
_NESTING_OP

CACHE_INVLD: The owner of the first-level/stage-1 page table must
explicitly invalidate the IOMMU cache through VFIO_IOMMU_NESTING_OP,
according to vendor-specific requirement when changing the page table.
--

Thanks
Kevin



