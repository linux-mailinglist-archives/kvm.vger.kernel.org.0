Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5222ABE6
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 11:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgGWJos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 05:44:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:22001 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgGWJor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 05:44:47 -0400
IronPort-SDR: c0WZIaXR6j9m5HrBspB1Pbc3GldwPzYMcsgsQxSpsLrdwQfD1E21Bt0kOhOZQG92J3iBTWJltY
 twyvV/vEub5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="151799445"
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="151799445"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 02:44:47 -0700
IronPort-SDR: xV1jEcse1OR8GLk5F0n+7Xc2x5puXF96QR99cJ+FSsyrwoTM6DPEP/HwOrQ0XDlCGAn6CZDPN2
 GDGpSXasJ0Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="362993483"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga001.jf.intel.com with ESMTP; 23 Jul 2020 02:44:47 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 02:44:46 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX116.amr.corp.intel.com (10.22.240.14) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 02:44:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 02:44:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ez4qJ/HRObExl8rSyK2+fTeqpvrvRWZJJkWNJsC5qJUmS6w0EHj1DQpo7KzdebjUsVY+oZGsuL6LsgMsqecT4hYrt4mWipJM+avrzrSjX7wzcfPUVPE5jS4TxoxIjzs+moISSPrlMYTGzcYwyyA9vtS6Gkc98uhJsARgUcTw5/iOLw1egusjwBm6w6+pgAdadD6aW3R1Vj6EN85hAHTpFmFk31c4t4mrnzoCDYW7zbe2mJaJgUXqNk996OLtCiq7u8FqW5iKfEQAS1a1+nl9xx+KkytipwVI0aTZZKHxgK/7vmn3b7h2mGdgFbFYFKeGwFqGVfFiJcYLu+T8aXjnJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdrmg1KbihSqrsxQ5R3/CRwEznP/dKdohlS7gDwPs34=;
 b=oR4pVYaYBVz8fErFn0DpG+YOWLez+5/WgH9/O7/bfDFZxJz9gfrfUy0U/Oo2lB1aIaHE3KXxrdkuRGVOFzu0xOaDicj77c7IPcUFnea+lV5k/Yi/0XWsJOHq+ZwyrhGpVAObJ2oI69TQplQP/wFV3GJgWOtWf0sxdZ1q+EVnW809aFYplErDOLOqiAa+WFdWpE5E+XtYZTND+4bfmUtHgexTm/b4gHtbhmIkmxHyCDa1i4I4e5soxEO7oNOtp0zTn0sjIFE46OVFLGQThD3VfrRgSbTHq+tdsI+qz9D7+3NbKJNAsTU23XvptN8RJ9wvHIx5cDM4jnJEclAV9Sh75g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdrmg1KbihSqrsxQ5R3/CRwEznP/dKdohlS7gDwPs34=;
 b=gDFJwr1bAzpDvRW4HDnD5RzxJwaCqEDBIRnufXlXNKh++KdatRKUQm5HflPsWZpnsWYJ69Z9W2v2Wn41AKMiFq5rk+rrtIMPqwLU5IRLd1Ey3+0ytW/06o+OxCl78R06xhmBQ6aijrdCoQMrRVPiAgztwKGD0ilIBHi0B/sj8IU=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1578.namprd11.prod.outlook.com (2603:10b6:4:e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.23; Thu, 23 Jul 2020 09:44:44 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3216.020; Thu, 23 Jul
 2020 09:44:44 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Auger Eric <eric.auger@redhat.com>
CC:     Will Deacon <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Thread-Topic: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Thread-Index: AQHWWD2lVc+q/avNRU2WMQZyTvsTFakFfrYAgAFdguCAA4IGgIAAU1iAgADRvwCACXbYwA==
Date:   Thu, 23 Jul 2020 09:44:44 +0000
Message-ID: <DM5PR11MB143539FB262524EE1A292063C3760@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
 <20200713131454.GA2739@willie-the-truck>
 <CY4PR11MB1432226D0A52D099249E95A0C3610@CY4PR11MB1432.namprd11.prod.outlook.com>
 <20200716153959.GA447208@myrica>
 <f3779a69-0295-d668-5f2f-746b6ff2bdce@redhat.com>
 <20200717090900.GC4850@myrica>
In-Reply-To: <20200717090900.GC4850@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b715095-c2d2-4946-52bb-08d82eed07bc
x-ms-traffictypediagnostic: DM5PR11MB1578:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB15784B9B2EA1802E97A90054C3760@DM5PR11MB1578.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LcE357Zq7dwnW5Ik8x0a9o1N1pj7wVcI1/7z2ajlamxn3ifw7+kcPRS+VewWpVb8i3qNjLqCkiyTdEf2h0X/LZykNFwHXxWp4OihfBvNdWhr1oTG3WgeHYYziYDStl8oLKcEIDdVhlxOuT3q/nfGUztTq6D7JAmHMLy6A/nDEfieScCqnlqRlj5k2kqi07AZicx2H6128RTyhh4hYw1C69N/nK+8My67ydi+cdjuHeY0LXEh/iTXbP1lYxyL7Nq6BCvbVFcOY9p6dWt7wiaT+/ul3IOAphEjYaPop2seDA6xzQKnu8Al7NalGiGt/w3Xr0AQL6Z3FoV8j8EKdIKUh74bY1sKLh5bZmzDuFAAlQw3XyKCA9QHZU5cpm4NFwf05Lfix3QITU1vmJ2WXBhmiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(7696005)(26005)(53546011)(478600001)(6506007)(110136005)(186003)(71200400001)(83380400001)(66476007)(66446008)(64756008)(66556008)(966005)(5660300002)(33656002)(76116006)(55016002)(8936002)(8676002)(4326008)(316002)(54906003)(86362001)(7416002)(9686003)(66946007)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: w0HLFAhGRHMCaEwBR6fdJ6+wlHnN82XgZRknEvCVaa9zl/dq7djvMWA2SIz0mteIErUSYY2p7B3oU3ttSkz7qjL0jJHBG4AUrnxvwoXQnr3RfEJhEnNOowJ0HL8NVbjCtixg4ZB18yRNDPXjCSJ0KBXpzYkDKnA7k2BYbUKvRhjXXlU3yx7Ou93o+9QQVnQrwAn7Pn+sH5wtxI+KGQcBUxX/0bpbfL6VGPGp5iXk0UGBlRfd0+2EtUR5kGPHLW/FngrjDsdtPjlGXPiJBgrFcLLySo9kocw5xQjRmNWeqOY1Do/KQLs84pp1EZTPj1Z/iiGUQ4dWe5J1H7ZBCqp/HnhYye9yNozGhR8RcSMy+yK/iTx0cAsF978aZoMpQ+H23qRGebcBRVoSQhC9OHsNKxF10IqYNa4bmPOVoPzBHYhzgxfZx7OfDD9QTemyEk753oRsfeZb6i7dExTpinxvpGv+UaSHmsMmNR8H7tsk1/wjvQhYqcN+j6fzoRjHGa8B
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b715095-c2d2-4946-52bb-08d82eed07bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 09:44:44.3125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m5ii6FyuP53NhJSS30Uxbr6qyDXUboCLw/W63h2QLHtz9viSo3aMirdQW+R5LVwgVdfszo5Wa5Lc52epbNBreA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1578
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Friday, July 17, 2020 5:09 PM
>=20
> On Thu, Jul 16, 2020 at 10:38:17PM +0200, Auger Eric wrote:
> > Hi Jean,
> >
> > On 7/16/20 5:39 PM, Jean-Philippe Brucker wrote:
> > > On Tue, Jul 14, 2020 at 10:12:49AM +0000, Liu, Yi L wrote:
> > >>> Have you verified that this doesn't break the existing usage of
> > >>> DOMAIN_ATTR_NESTING in drivers/vfio/vfio_iommu_type1.c?
> > >>
> > >> I didn't have ARM machine on my hand. But I contacted with Jean
> > >> Philippe, he confirmed no compiling issue. I didn't see any code
> > >> getting DOMAIN_ATTR_NESTING attr in current
> drivers/vfio/vfio_iommu_type1.c.
> > >> What I'm adding is to call iommu_domai_get_attr(, DOMAIN_ATTR_NESTIN=
)
> > >> and won't fail if the iommu_domai_get_attr() returns 0. This patch
> > >> returns an empty nesting info for DOMAIN_ATTR_NESTIN and return
> > >> value is 0 if no error. So I guess it won't fail nesting for ARM.
> > >
> > > I confirm that this series doesn't break the current support for
> > > VFIO_IOMMU_TYPE1_NESTING with an SMMUv3. That said...
> > >
> > > If the SMMU does not support stage-2 then there is a change in behavi=
or
> > > (untested): after the domain is silently switched to stage-1 by the S=
MMU
> > > driver, VFIO will now query nesting info and obtain -ENODEV. Instead =
of
> > > succeding as before, the VFIO ioctl will now fail. I believe that's a=
 fix
> > > rather than a regression, it should have been like this since the
> > > beginning. No known userspace has been using VFIO_IOMMU_TYPE1_NESTING
> so
> > > far, so I don't think it should be a concern.
> > But as Yi mentioned ealier, in the current vfio code there is no
> > DOMAIN_ATTR_NESTING query yet.
>=20
> That's why something that would have succeeded before will now fail:
> Before this series, if user asked for a VFIO_IOMMU_TYPE1_NESTING, it woul=
d
> have succeeded even if the SMMU didn't support stage-2, as the driver
> would have silently fallen back on stage-1 mappings (which work exactly
> the same as stage-2-only since there was no nesting supported). After the
> series, we do check for DOMAIN_ATTR_NESTING so if user asks for
> VFIO_IOMMU_TYPE1_NESTING and the SMMU doesn't support stage-2, the ioctl
> fails.

I think this depends on iommu driver. I noticed current SMMU driver
doesn't check physical IOMMU about nesting capability. So I guess
the SET_IOMMU would still work for SMMU. but it will fail as you
mentioned in prior email, userspace will check the nesting info and
would fail as it gets an empty struct from host.

https://lore.kernel.org/kvm/20200716153959.GA447208@myrica/

>=20
> I believe it's a good fix and completely harmless, but wanted to make sur=
e
> no one objects because it's an ABI change.

yes.

Regards,
Yi Liu

> Thanks,
> Jean
>=20
> > In my SMMUV3 nested stage series, I added
> > such a query in vfio-pci.c to detect if I need to expose a fault region
> > but I already test both the returned value and the output arg. So to me
> > there is no issue with that change.
> > >
> > > And if userspace queries the nesting properties using the new ABI
> > > introduced in this patchset, it will obtain an empty struct. I think
> > > that's acceptable, but it may be better to avoid adding the nesting c=
ap if
> > > @format is 0?
> > agreed
> >
> > Thanks
> >
> > Eric
> > >
> > > Thanks,
> > > Jean
> > >
> > >>
> > >> @Eric, how about your opinion? your dual-stage vSMMU support may
> > >> also share the vfio_iommu_type1.c code.
> > >>
> > >> Regards,
> > >> Yi Liu
> > >>
> > >>> Will
> > >
> >
