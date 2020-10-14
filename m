Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5C228D857
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 04:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgJNCLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 22:11:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:51256 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727630AbgJNCLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 22:11:10 -0400
IronPort-SDR: 3qvzKhiUmyasxM2oinirH7qcdk9KcIggV5h3QweSCUvnAL2n8OIgaQXy8fyuaJtT7WQbEWQ2F5
 t+7zVmBffGGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="227659878"
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="227659878"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 19:11:08 -0700
IronPort-SDR: BwTqVYxdRzpUcuGwez1N3srNTngAUctKhq+YuPGqrBkQHsboplIOQwrSsJltBSXjXnfpmAZC81
 kQ+63ErJ7YCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="521248642"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 13 Oct 2020 19:11:07 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Oct 2020 19:11:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 13 Oct 2020 19:11:06 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.56) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 13 Oct 2020 19:11:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1e7RKTT3LwhLmQkG5bGmKJp136l3PmXpyjnGDUGJvl5Hyfu8YeYsQ8z6whG+C6uL3ZIsuPHLZyRc3XtLnXbRvKDP7I01zcpvIGeC+vAOAqY6tssaFN9rP51/ZfZCk/a5FV0SbKnwTL1ie9m73Tp2T8M/uPjSHJ12JR4Qqpa9hGPE2LaWw5jVoYqv6ty//B8xZn2TymFuOpTc0IwzatIXDPKKMNogNrEQK2xoCVQ9MaD0YscOyY/OhTNvJ90YxMZuv5kz8WgiW9QNwHnGjKZHXEJrGf2IaqZaTetBcJXD3luhEkNZH26+eKjkvbR5XxVdM8LdRCBEsxE3ck0yBJUvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPl/y2MOrjPcqqjMoJGJ7R4h7fjz5IEEWyFylQjIrq4=;
 b=M3Q+t4YEw2L3G8t621EU/0Deo3qSycat2PW0si88t0ZIminDrdld+SpwOVnhBObPjH3+BYu2SIth0ZW91k7q2KGYMoCjrC4rgRZ1GxdMB5A67AOWNIIgh7/L5LFmBuHbvNDxZR70+MFlndr1RRhs2VCZ03UWo7SRMHkANikExLyagaxZ0SPHCJYsUcwBiXL72w76rZwM0Mjy5EWRBKon+daYMxZFZsQ3zox3FuVFrxF0QOh+e7dRdz5FhSmhGiQhpMrcezrrnE3y7MnemjQxP0AjBV+i/AUQ+0NO5JumEjh7NZW544FtYJsCBgqHe9/KIamcc1zyTe8QmFa45Y4obA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPl/y2MOrjPcqqjMoJGJ7R4h7fjz5IEEWyFylQjIrq4=;
 b=jB8ilZnePMsfrFOLOVQ/eEFDVLw1+amIavdHmJT44CZfCI5PP97RpQfEHI0MoQc7kVqXZTW++i0UB59YbwM69deAjA9zpABvPMt29KgwRkRcy+P2dW4WA7wIbsy068rUCDx1FpoFVjlReNa+ZVUUgeMs6UoqWH1esxSy3NYQJAg=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1503.namprd11.prod.outlook.com (2603:10b6:301:f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Wed, 14 Oct
 2020 02:11:02 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b%8]) with mapi id 15.20.3455.032; Wed, 14 Oct 2020
 02:11:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Topic: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Index: AdagceQQLvqwjRCrQOaq1hZ7MgDUUAA2aDwAACB2JSA=
Date:   Wed, 14 Oct 2020 02:11:02 +0000
Message-ID: <MWHPR11MB164594ACBB0941BCA4258E658C050@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201013102758.GB694407@myrica>
In-Reply-To: <20201013102758.GB694407@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f2a0b34-14e5-40f5-6a81-08d86fe66686
x-ms-traffictypediagnostic: MWHPR11MB1503:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1503031717D923FE44FD63608C050@MWHPR11MB1503.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AeH9OiEubp2LzjZevzrSSG1bXtBNg56WbftT2L8E3tmEbHwV97LlPg74M6cHQcxD/RKC47CwAARLOiwQ9Mgo91TP95cXtmD+CjNYhzeEy/ZhmWW89H1brPYICo226TJnHTKkXpkmPGckvMG+2/I7Dj0Z4MSMmQCBgSkpeDl/fEs05MvlAv6z3B7+DLFKaBPJW198O0mHe0gTEtcSkNvddWAFQroSdqokeXkkKmsYOTiTiheaNqUMV3SyzlTJ15DwjgeeaJ+COPyS60Rauf+V1c5pZ8Z1Yfh0AQjC14zKiNBPNALDlAvOk026jt4Dk1tjxDtxy8SW8ye2juycQn24bQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(9686003)(478600001)(316002)(54906003)(33656002)(4326008)(83380400001)(71200400001)(66946007)(66446008)(86362001)(8936002)(6506007)(8676002)(7416002)(66476007)(66556008)(64756008)(76116006)(26005)(52536014)(7696005)(5660300002)(186003)(55016002)(2906002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eDmENuyIJblTxpbMKrSjNEAdYIkIvSm+7Twz8K/97Dd4MGEWrdn6KnklzEk1KHhfpVCWFITcEBKRNMmTk92J53PixFjk0iDPBVrD97GcB7WX9k6HuyrGPGGd5282IEEsNio7aNj+4kUuSjCjo9CTiN8P+2w94YbS6su9QIJoM6pd9HptWBXQR0Meiy0Z/GAbWKNBAX869NcGBJnoZzxciXesMYAw8kHEpmhRfGL0v0YRy86ueb037GqsOGPodvaaYfp/78+c11p8NqW8vVlVfbaYNnSLp02BIlX66RlN6ortldgiR2Deo3gcQBggjqqElrL3bkVa36+uVJQGokF+pjaFbzNlFsAt0G/yh0ZfIXRhMJf8Qxuq3wW72XBrLi7eGK4UK0HjoAnQF6ABC7olwRyfoa8QfSA4k1WfM49bD+eBMXngzSYMNqyRAaQ8/Q6Yyco+8SoirqZ6d5s+u33EF3pme89ziFKWBVbPRkVquVk7rIQUTTVBWrwmkTkUfAWT9WfWLDJD8TXYhREx492xqfVyM2/izoAGgY0dIo2NlZyY0lNRPGawr+vzbPwAEWz5j9aSxPQBuVLETxcFXZXu4eW/oKmGMfw4/kZ8Li9tfuNy9urWpAU7iKCcxmc7zEfnz5g+8ktz4WLlxQF/XSlAPQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2a0b34-14e5-40f5-6a81-08d86fe66686
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 02:11:02.4392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RztRNeEOxPAjir1XLnYtk3e2DyuahJ1adeEH+XgA0MZyzdjiWtRJQpMm2iK2atemO36LG0+bPJS19IEAtTK5Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1503
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Tuesday, October 13, 2020 6:28 PM
>=20
> On Mon, Oct 12, 2020 at 08:38:54AM +0000, Tian, Kevin wrote:
> > > From: Jason Wang <jasowang@redhat.com>
> > > Sent: Monday, September 14, 2020 12:20 PM
> > >
> > [...]
> >  > If it's possible, I would suggest a generic uAPI instead of a VFIO
> > > specific one.
> > >
> > > Jason suggest something like /dev/sva. There will be a lot of other
> > > subsystems that could benefit from this (e.g vDPA).
> > >
> > > Have you ever considered this approach?
> > >
> >
> > Hi, Jason,
> >
> > We did some study on this approach and below is the output. It's a
> > long writing but I didn't find a way to further abstract w/o losing
> > necessary context. Sorry about that.
> >
> > Overall the real purpose of this series is to enable IOMMU nested
> > translation capability with vSVA as one major usage, through
> > below new uAPIs:
> > 	1) Report/enable IOMMU nested translation capability;
> > 	2) Allocate/free PASID;
> > 	3) Bind/unbind guest page table;
> > 	4) Invalidate IOMMU cache;
> > 	5) Handle IOMMU page request/response (not in this series);
> > 1/3/4) is the minimal set for using IOMMU nested translation, with
> > the other two optional. For example, the guest may enable vSVA on
> > a device without using PASID. Or, it may bind its gIOVA page table
> > which doesn't require page fault support. Finally, all operations can
> > be applied to either physical device or subdevice.
> >
> > Then we evaluated each uAPI whether generalizing it is a good thing
> > both in concept and regarding to complexity.
> >
> > First, unlike other uAPIs which are all backed by iommu_ops, PASID
> > allocation/free is through the IOASID sub-system. From this angle
> > we feel generalizing PASID management does make some sense.
> > First, PASID is just a number and not related to any device before
> > it's bound to a page table and IOMMU domain. Second, PASID is a
> > global resource (at least on Intel VT-d), while having separate VFIO/
> > VDPA allocation interfaces may easily cause confusion in userspace,
> > e.g. which interface to be used if both VFIO/VDPA devices exist.
> > Moreover, an unified interface allows centralized control over how
> > many PASIDs are allowed per process.
> >
> > One unclear part with this generalization is about the permission.
> > Do we open this interface to any process or only to those which
> > have assigned devices? If the latter, what would be the mechanism
> > to coordinate between this new interface and specific passthrough
> > frameworks? A more tricky case, vSVA support on ARM (Eric/Jean
> > please correct me) plans to do per-device PASID namespace which
> > is built on a bind_pasid_table iommu callback to allow guest fully
> > manage its PASIDs on a given passthrough device.
>=20
> Yes we need a bind_pasid_table. The guest needs to allocate the PASID
> tables because they are accessed via guest-physical addresses by the HW
> SMMU.
>=20
> With bind_pasid_table, the invalidation message also requires a scope to
> invalidate a whole PASID context, in addition to invalidating a mappings
> ranges.
>=20
> > I'm not sure
> > how such requirement can be unified w/o involving passthrough
> > frameworks, or whether ARM could also switch to global PASID
> > style...
>=20
> Not planned at the moment, sorry. It requires a PV IOMMU to do PASID
> allocation, which is possible with virtio-iommu but not with a vSMMU
> emulation. The VM will manage its own PASID space. The upside is that we
> don't need userspace access to IOASID, so I won't pester you with comment=
s
> on that part of the API :)

It makes sense. Possibly in the future when you plan to support=20
SIOV-like capability then you may have to convert PASID table
to use host physical address then the same API could be reused. :)

Thanks
Kevin

>=20
> > Second, IOMMU nested translation is a per IOMMU domain
> > capability. Since IOMMU domains are managed by VFIO/VDPA
> >  (alloc/free domain, attach/detach device, set/get domain attribute,
> > etc.), reporting/enabling the nesting capability is an natural
> > extension to the domain uAPI of existing passthrough frameworks.
> > Actually, VFIO already includes a nesting enable interface even
> > before this series. So it doesn't make sense to generalize this uAPI
> > out.
>=20
> Agree for enabling, but for reporting we did consider adding a sysfs
> interface in /sys/class/iommu/ describing an IOMMU's properties. Then
> opted for VFIO capabilities to keep the API nice and contained, but if
> we're breaking up the API, sysfs might be more convenient to use and
> extend.
>=20
> > Then the tricky part comes with the remaining operations (3/4/5),
> > which are all backed by iommu_ops thus effective only within an
> > IOMMU domain. To generalize them, the first thing is to find a way
> > to associate the sva_FD (opened through generic /dev/sva) with an
> > IOMMU domain that is created by VFIO/VDPA. The second thing is
> > to replicate {domain<->device/subdevice} association in /dev/sva
> > path because some operations (e.g. page fault) is triggered/handled
> > per device/subdevice. Therefore, /dev/sva must provide both per-
> > domain and per-device uAPIs similar to what VFIO/VDPA already
> > does. Moreover, mapping page fault to subdevice requires pre-
> > registering subdevice fault data to IOMMU layer when binding
> > guest page table, while such fault data can be only retrieved from
> > parent driver through VFIO/VDPA.
> >
> > However, we failed to find a good way even at the 1st step about
> > domain association. The iommu domains are not exposed to the
> > userspace, and there is no 1:1 mapping between domain and device.
> > In VFIO, all devices within the same VFIO container share the address
> > space but they may be organized in multiple IOMMU domains based
> > on their bus type. How (should we let) the userspace know the
> > domain information and open an sva_FD for each domain is the main
> > problem here.
> >
> > In the end we just realized that doing such generalization doesn't
> > really lead to a clear design and instead requires tight coordination
> > between /dev/sva and VFIO/VDPA for almost every new uAPI
> > (especially about synchronization when the domain/device
> > association is changed or when the device/subdevice is being reset/
> > drained). Finally it may become a usability burden to the userspace
> > on proper use of the two interfaces on the assigned device.
> >
> > Based on above analysis we feel that just generalizing PASID mgmt.
> > might be a good thing to look at while the remaining operations are
> > better being VFIO/VDPA specific uAPIs. anyway in concept those are
> > just a subset of the page table management capabilities that an
> > IOMMU domain affords. Since all other aspects of the IOMMU domain
> > is managed by VFIO/VDPA already, continuing this path for new nesting
> > capability sounds natural. There is another option by generalizing the
> > entire IOMMU domain management (sort of the entire vfio_iommu_
> > type1), but it's unclear whether such intrusive change is worthwhile
> > (especially when VFIO/VDPA already goes different route even in legacy
> > mapping uAPI: map/unmap vs. IOTLB).
>=20
> I agree with your analysis. A new coarse /dev/sva interface would need to
> carry all the VFIO abstractions of container (minus map/unmap) and
> group+device, which are not necessarily needed by VDPA and others, while
> the original VFIO interface needs to stay for compatibility. To me it
> makes more sense to extend each API separately, but have them embed
> common
> structures (bind/inval) and share some resources through external
> interfaces (IOASID, nesting properties, IOPF queue).
>=20
> Thanks,
> Jean
