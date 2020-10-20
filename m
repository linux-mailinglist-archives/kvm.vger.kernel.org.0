Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA0A293911
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 12:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388023AbgJTKVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 06:21:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:23371 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387515AbgJTKVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 06:21:45 -0400
IronPort-SDR: H7Lh766a8TU5U0CR+mUSLDEAUF0kmaiRooQR1iLIZZWo0wWIwCiKzfPgw/2cbWFkKzWu7OcpQJ
 GZxQjFCOquhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="251880984"
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="251880984"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 03:21:45 -0700
IronPort-SDR: r40myvL2itJdxS9+tZJFQz/Jv6lN7SAb5UC2m8xhgL2kaphLu+r0zew0nqRXQX2rqQOclz9KsP
 SjrvqxxLdqaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="scan'208";a="358477134"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Oct 2020 03:21:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 03:21:44 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 03:21:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Oct 2020 03:21:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 20 Oct 2020 03:21:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0MXRPgM+c/fIRyjevI4WKP8z5wUA4JVMHNoMr0DJwPL5vDRbk2KkTP6ni/eHxaA72QCCkEwajmxxCEs6BvYhkCSmvSyukf8g0hvchWtbtF/QyH2fYvAPgJc9rO0mPOGR+Kt9FiHMcoARyCds3NNqDm6ueCQHMlnJcae8TdalNTtRuohiFpeYCuVsjkAZDOB64Pl5K18hOvlgdiGLfoDF+8H4TemsxcGKF6zXz4p7UvGT3QNAKUdjdEuTyoTdpwX3M4Vcbb2+7gZvo4UR5qsS7YCnfCBCUSpnKRKlPs7b8u/JS+6RSDwWnfrX3PdVuGZhiBrPe9WOjp8oR7dhhCTIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbOETCATVdzhroDhfFt1SgltQIElXfTqbRk5gQtb8sA=;
 b=V7bm8/xZd15IDASU5VGBRqDAzBZds8fWw8Ahzdgo62sdHIf48o5r4XIkr1ZbGNYc/E6tMDl0KL6GDPO0p8kVBlZW3HjvJvcgnQ+L/aMLb+wpq7o9eWGSB1VkHBFXPpyO5dfkpuafxRtv7fSYfjA4CgqFShbVqbPYm1ryDax6TYGmCG7+xl2FDJGDGVCY6v9kzNT/pVfha0Y838UdFHuCijBVkOjBko6WN2hPy0J6DXyAK0787Ue+Z5x2nNr/WKC+rHLmkqHY3mBwDqE+Ge8xSIQ6jCjYxUK2aZxNo8RzoWNb+gXFIG0WfeGym1g8F6W5Zo576+hRP8ANjnOshfPdUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbOETCATVdzhroDhfFt1SgltQIElXfTqbRk5gQtb8sA=;
 b=KgvS3N3E3EF4UoIbE+iDCpzff/WEtLMamx4cIL1rG/KLwtgf1DylmQKqvyFoGbm0GRjVmMWMNDG/9wpIzoAzl1O2Owo6W9khS+i6cZWFTSCks9MXONKBaBVzOsJCyKlq7gQic9Vp84aMQRAnhNllPz9ex2mD1CcP3snlTIwh6KY=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4595.namprd11.prod.outlook.com (2603:10b6:5:2ac::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.25; Tue, 20 Oct 2020 10:21:41 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f%11]) with mapi id 15.20.3477.028; Tue, 20 Oct
 2020 10:21:41 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Subject: RE: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Topic: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Index: AdagceQQLvqwjRCrQOaq1hZ7MgDUUABZWmqgAH60bgAAh22vsAAM9nEAACSNTfA=
Date:   Tue, 20 Oct 2020 10:21:41 +0000
Message-ID: <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <MWHPR11MB1645AE971BD8DAF72CE3E1198C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201016153632.GM6219@nvidia.com>
 <DM5PR11MB1435A3AEC0637C4531F2FE92C31E0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201019142526.GJ6219@nvidia.com>
In-Reply-To: <20201019142526.GJ6219@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [221.220.190.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 698d30c5-99d1-42e2-b84d-08d874e1f01f
x-ms-traffictypediagnostic: DM6PR11MB4595:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB459592AEABB98B22A35E7531C31F0@DM6PR11MB4595.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8qWj1Thd8MeM2esjikI9QYocYnKiKEz8JtS2MG8PM1SlvahJV22DPi0aZ/vXlPdvU20QPSIvF+gY+845rKX7j5S8TWAWrW2TCHd3ISY0NhReB6+pI8BaqWW9VQwLqRgoQDqorZpTzSG9fGAqxyT8XofG9zEylsw3AJAgVdU9i92hyNp9Ey/0Jlbs1rStL8eQjPFPJe6WI/IzWg76KSZcYP+8iyhNEUOcvW4ARRm4i7w+LC1db+/6JVyAc0Q3cjvq2LrjPOFhX+j5I6MJZRZVnZDVjt+GqwuZMhtC3sDR1ShGqV3FXFt6E9AD40kbVgVbWVw9ct0Ny8oQMn6X+eD163BN6mzAtVlF8mZvXK0/gtxluWDpKcITvbsr6A44w8tSD4R98GvTJN9Xirsg7QokYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(26005)(86362001)(8936002)(4326008)(6506007)(966005)(66556008)(54906003)(64756008)(316002)(186003)(66946007)(66476007)(76116006)(33656002)(66446008)(45080400002)(8676002)(478600001)(5660300002)(71200400001)(9686003)(83380400001)(55016002)(52536014)(7416002)(2906002)(6916009)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7HnQvj+GhogPpmpJCOAVJsxmTSLwzasyAPQskDA7mVGbuzVkzOGAWufxXeElzORUg1RLZRge6754Ovo3vyIz3O5ks5GtpRdgOI/2UiE2edeUGVsE6gvyhLSuSONhqIUPdYobsmL+sU/Wpu0OtiPTaP6iEUoNNnqDOX1H7XXBxByIPunRCHjicFi1e7RhrvtZ7I3Gcs5m7EgQuy1Mk3YZ/YqEm1TnUuh8p5mK4QWc1cj+AZ5Tiq6p54oUoIdskoEegFHn5lVItt6VDu5Tqz2jpFf3lbIIei9sYAUAj1SFOItg2gmh4vB4RMB4vjFOvfhvw/d+8H7LAYWgpR1hOadZXU1zU8UGKfIC6L0p1OmTgASn2cOW3AFWjNVMJ5XDAj9kHdkP8X1YnrStltCudcw+v8PWNKnBjevREImIynL9WY658zENLjKHTCuKbI3UJ8g/HCyJ7Z2war2UGHx/W01I8awxR77IJlA1Uu9rLbgP1tqwG5WFHS55tQ4j3BA1QaEoxGR4b2yVf5HF1riM+zxm/lKYoCPIJe5jMMxBoVoKgymwf6MnJMZFPZqKi0Iqm7t/sXJR1fYflO0gDf3+w0IDlto4O8Lcny4IG4wC1zFJsxYCOxUHHBWvP6v+KjIdZDHyNOv8Js206s0poCiYrsQ1sQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 698d30c5-99d1-42e2-b84d-08d874e1f01f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 10:21:41.6020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uObo6kRoIaVrNjnziC/1ko8/Bfp1iuLf5cWBmwiJslpu7DFaIlJ4IW8UtaAxHTYJhdicLrz2lAqrajkER46PUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4595
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, October 19, 2020 10:25 PM
>=20
> On Mon, Oct 19, 2020 at 08:39:03AM +0000, Liu, Yi L wrote:
> > Hi Jason,
> >
> > Good to see your response.
>=20
> Ah, I was away

got it. :-)

> > > > > Second, IOMMU nested translation is a per IOMMU domain
> > > > > capability. Since IOMMU domains are managed by VFIO/VDPA
> > > > > (alloc/free domain, attach/detach device, set/get domain
> > > > > attribute, etc.), reporting/enabling the nesting capability is
> > > > > an natural extension to the domain uAPI of existing passthrough
> frameworks.
> > > > > Actually, VFIO already includes a nesting enable interface even
> > > > > before this series. So it doesn't make sense to generalize this
> > > > > uAPI out.
> > >
> > > The subsystem that obtains an IOMMU domain for a device would have
> > > to register it with an open FD of the '/dev/sva'. That is the
> > > connection between the two subsystems. It would be some simple
> > > kernel internal
> > > stuff:
> > >
> > >   sva =3D get_sva_from_file(fd);
> >
> > Is this fd provided by userspace? I suppose the /dev/sva has a set of
> > uAPIs which will finally program page table to host iommu driver. As
> > far as I know, it's weird for VFIO user. Why should VFIO user connect
> > to a /dev/sva fd after it sets a proper iommu type to the opened
> > container. VFIO container already stands for an iommu context with
> > which userspace could program page mapping to host iommu.
>=20
> Again the point is to dis-aggregate the vIOMMU related stuff from VFIO so=
 it
> can
> be shared between more subsystems that need it.

I understand you here. :-)

> I'm sure there will be some
> weird overlaps because we can't delete any of the existing VFIO APIs, but
> that
> should not be a blocker.

but the weird thing is what we should consider. And it perhaps not just
overlap, it may be a re-definition of VFIO container. As I mentioned, VFIO
container is IOMMU context from the day it was defined. It could be the
blocker. :-(

> Having VFIO run in a mode where '/dev/sva' provides all the IOMMU handlin=
g is
> a possible path.

This looks to be similar with the proposal from Jason Wang and Kevin Tian.
It is an idea to add "/dev/iommu" and delegate the IOMMU domain alloc,
device attach/detach which is no in passthru framework to an independent
kernel driver. Just as Jason Wang said replace vfio iommu type1 driver.

Jason Wang:
 "And all the proposal in this series is to reuse the container fd. It=20
 should be possible to replace e.g type1 IOMMU with a unified module."
link: https://lore.kernel.org/kvm/20201019142526.GJ6219@nvidia.com/T/#md49f=
e9ac9d9eff6ddf5b8c2ee2f27eb2766f66f3

Kevin Tian:
 "Based on above, I feel a more reasonable way is to first make a=20
 /dev/iommu uAPI supporting DMA map/unmap usages and then=20
 introduce vSVA to it. Doing this order is because DMA map/unmap=20
 is widely used thus can better help verify the core logic with=20
 many existing devices."
link: https://lore.kernel.org/kvm/MWHPR11MB1645C702D148A2852B41FCA08C230@MW=
HPR11MB1645.namprd11.prod.outlook.com/

>=20
> If your plan is to just opencode everything into VFIO then I don't
> see how VDPA will work well, and if proper in-kernel abstractions are bui=
lt I
> fail to see how
> routing some of it through userspace is a fundamental problem.

I'm not expert on vDPA for now, but I saw you three open source
veterans have a similar idea for a place to cover IOMMU handling,
I think it may be a valuable thing to do. I said "may be" as I'm not
sure about Alex's opinion on such idea. But the sure thing is this
idea may introduce weird overlap even re-definition of existing
thing as I replied above. We need to evaluate the impact and mature
the idea step by step. That means it would take time, so perhaps we
may do it in a staging way. First having a "/dev/iommu" be ready to
handle page MAP/UNMAP which can be used by both VFIO and vDPA, mean-
while let VFIO grow up (adding features) by itself and consider to
adopt the new /dev/iommu later once /dev/iommu is competent. Of
course this needs Alex's approval. And then adding new features
to /dev/iommu, like SVA.

>=20
> > >   sva_register_device_to_pasid(sva, pasid, pci_device,
> > > iommu_domain);
> >
> > So this is supposed to be called by VFIO/VDPA to register the info to
> > /dev/sva.
> > right? And in dev/sva, it will also maintain the device/iommu_domain
> > and pasid info? will it be duplicated with VFIO/VDPA?
>=20
> Each part needs to have the information it needs?

yeah, but it's the duplication which I'm not very much in. Perhaps the idea
from Jason Wang and Kevin would avoid such duplication.

> > > > > Moreover, mapping page fault to subdevice requires pre-
> > > > > registering subdevice fault data to IOMMU layer when binding
> > > > > guest page table, while such fault data can be only retrieved
> > > > > from parent driver through VFIO/VDPA.
> > >
> > > Not sure what this means, page fault should be tied to the PASID,
> > > any hookup needed for that should be done in-kernel when the device
> > > is connected to the PASID.
> >
> > you may refer to chapter 7.4.1.1 of VT-d spec. Page request is
> > reported to software together with the requestor id of the device. For
> > the page request injects to guest, it should have the device info.
>=20
> Whoever provides the vIOMMU emulation and relays the page fault to the gu=
est
> has to translate the RID -

that's the point. But the device info (especially the sub-device info) is
within the passthru framework (e.g. VFIO). So page fault reporting needs
to go through passthru framework.

> what does that have to do with VFIO?
>=20
> How will VPDA provide the vIOMMU emulation?

a pardon here. I believe vIOMMU emulation should be based on IOMMU vendor
specification, right? you may correct me if I'm missing anything.

> Jason

Regards,
Yi Liu
