Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D496942D5BF
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhJNJOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:14:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:27960 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhJNJOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 05:14:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="207751748"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="207751748"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 02:12:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="487261679"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 14 Oct 2021 02:12:04 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 02:12:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 02:12:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 02:12:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUYfw38Dju3bnBnshp3D/+rC0zAketCGplTMRcHixaKVKNWYSPm5/zwfSDza8+Cuqq3be1yh3X1JBRsEc4zE72kUmj1xHXZTB7dW4Nysy6RSi4HFbuwPpuNpGsXCCwUIhAlxlJthI9MVO7zkTKteHHlDISGqVCAZDTQQjoLGjs3/Ob+LcjhYU4el5m0pBwdHA9g7OlrVKNf5XXmEbq1S/9ddGiK8KK7kMM8I0hg+9O3oz9ns386g7jspZbrNZ4v9ycbJIuPQrVZU2z9KOzWu1xXE8tzwG3MD7xPHnm74fFmkK2nVhrVrri4HP0GsNWhJ2iBk9BYyTIGe+JLGck+I3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7D8hEONag4p/GSTF8IRi6eV8gUqtCJzFtMjmyi3AsWI=;
 b=i5SY7se6AHQMBYnKLLw+DP9aZ48Yxi1QE43hGESMFXv4Ke8qp/52Wuy1PoNGnwiQJ6vsd6t1XWY1taT29R/V5phF4lQUYYiqVee5W5NjPjxfgOVMpDbHJLkanmk+YVT4wgZ2dovoZJckk4yphnI1DT17P5yxo6Q0u47FkbvJYAnkePOWcXSX+aE7pzOVL0u2OQywIra3vpnamLNWbvMC18M4iUJT4wZ8Fkusu3IZKl1awqgMVMMMSTX+4ftn5s7WPw3bfA7W3apn37rY6BezWE68qoBUkd60YuF68PUoIo4etNlkTTYQ+B3AsUwvE/OEKwQOg/CR7ubhGtQbzoZ6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7D8hEONag4p/GSTF8IRi6eV8gUqtCJzFtMjmyi3AsWI=;
 b=tKekq5/nexHue9wPz/X+gBH0Zc/sqyJq70Cx0iAAm0niGwmdpf9E1Mer0SzfN/8qlGr01mXJ2aw9pqRSmm4OrIHbcts7o/sOVaN352lz9AqjbhtdX0CD+56AEajNy0eIziNG/PLoVA7+bWpTMIUpg58+aYB7RZf5SUap8WJtEOA=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB4098.namprd11.prod.outlook.com (2603:10b6:405:7f::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 14 Oct
 2021 09:11:58 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 09:11:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
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
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAEL4QgACKr4CACtdfoIAA3DaAgBUX8GA=
Date:   Thu, 14 Oct 2021 09:11:58 +0000
Message-ID: <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
In-Reply-To: <20210930222355.GH964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10e0c449-8fb3-45ec-fd18-08d98ef2ad11
x-ms-traffictypediagnostic: BN6PR11MB4098:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB4098D8A1C2CAF9C0E4C1BF658CB89@BN6PR11MB4098.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bMrdHY6K7HzfsHBSejP3mL7/P9ksubnGnahtdjB1516/L/8z+pi0iU8pZmPHeujSuWln25hSjvf900UnExsKE56K6i6PNQt/qFbFT41IVJMEoQzbFSxC44SgfqcQPGFkytnMPUJzyL8pGee9Ibc+ee05NBAY1gkqCvMYMzxrvhv/BinocUhAAcpXR/H/hPGFoVe/dHkkYsJNbpyzMT3FcEV6YBOHypkdHcNRl8D69RpqlE82O5FG98z/5BTB2crsIxRIuf3k9SjbhgtVoYc2jik994N0NpnMmNFM+pdmjSRXFhwXS9WIEer3rzBpWkD390S5RPhZQzDnOU8Wsxy/Aryxx2EMdabgujeoZghSuqiHYrRXCHmVEyTEHQDsW0qUK8e9DG6pXOnXYOUW5GpY/U8XZIMwRPWi8eO5edGdmGYQmFSPbmzT2DkEcpzJO8j8xJ0noTmMsonm16sO1mWPtDWAeE0xFZCUVoh/duHvk1X/y1J43JMvgrl7BemElpLqFGHZY/S7ItZ2eXDK4NSrAByu8cyHA7k93MklzfPKdLP56gmZ+/azznR+nhv4OTaWPJSKl1MqgRM4DQbNm/46LaIxYoXwxJvT1x5erHBiGKcGJUPE7sgNDOC9xRPk1c0GzTDCf4MbLaGrlATyl50kggfN7Y3iWYVxLt8T+roqp8eQvvfxvu7H62iHpVhegXsIM+k1/olRIMFwxmi+DhLiOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(26005)(5660300002)(7416002)(66946007)(76116006)(64756008)(66556008)(8676002)(122000001)(38100700002)(4326008)(66446008)(71200400001)(83380400001)(186003)(66476007)(54906003)(8936002)(33656002)(38070700005)(316002)(52536014)(6506007)(55016002)(508600001)(9686003)(6916009)(2906002)(7696005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZrxYpPMbk7jjYlRoQsa7jEg2oly+MH3YIXsg4H6i5o2knwCpKVuQc9NZ9a89?=
 =?us-ascii?Q?iU/Bk7LCXK3tEBIkk9059gqvbZtgI6unaaD/AFnaL5tTuZVnmf9JaqX/0oFI?=
 =?us-ascii?Q?Lkk6c4AnB1mfDd3Js50zTweSj+FVFFeFdWwhSGvFD7woiM9CegqLwWJoJYgy?=
 =?us-ascii?Q?WXvGDdwoI1/r67gErJDBzXP72ukrGkoR5D9iCIhABoY0iUWSa/rntVH6D2c0?=
 =?us-ascii?Q?WM8iI74dG9kPPfjBUP5m9TEqVUB5TLMHh8TM8Ul0LMttmWQLoUBdqopyNI5+?=
 =?us-ascii?Q?wX3kVVoIQjMIho74t4JPmjtClwinAGdHVoQxo8d+WSZZbr3PHjrU7c1NlGnj?=
 =?us-ascii?Q?X6Bw86qgXIlGkOOd0mRJqE4gaazQ6LJTGlJuTuL+AdWJyixpTk1XE9eSCVJG?=
 =?us-ascii?Q?tW32bNJ3TfsqoH0bJjl64Wp55Z8JaNEj3Nw18pz6LaYdcq9yQnX0D1KJG/5k?=
 =?us-ascii?Q?CoC1n+3FG36f+BwIF5jcBBVg/fQ4+o3SNMAhCw32MLR65yCqouvHzOLVR2qE?=
 =?us-ascii?Q?9jimbtk0kt6zulfZakcIYJBl1qRADeQxqI/4QidTa1WjQjUVqSC94PlPzi22?=
 =?us-ascii?Q?It9bU7oqj8QknBpNxIsSI7FbbRPTEZW518dsXb2y0pbiItgK/oFTGr8DEc3L?=
 =?us-ascii?Q?icYNbqiMSm/kWROWVKoriT29gxwsEMF9Q/AT+YFB0/Xfg0y5XqSeQaWgYKzA?=
 =?us-ascii?Q?N7YUlYToxs/cqW4q+RiIJm4QeZoRsc0kjcgRamZG9XCqQjGyDyN64Nl2CKQ7?=
 =?us-ascii?Q?/877ix2swqK65+8BvuKjiBYgJjxvEqb04AREbNZHrjowPSzwwwvgw8TMyDME?=
 =?us-ascii?Q?kTcTA1nTJ3Dcp+FwYORnN77qvuDB44e928R91w+6chFjlZ+4ZU/6DH5QzP21?=
 =?us-ascii?Q?gtOVJthq50eXIXd3zQnqL2U7LSogsFAmOCEqau0brDRDKg+KDLxWjh8NK5a1?=
 =?us-ascii?Q?DVKFWor0PkHnnB8drjNfbmYa6BUzzlQ8KG9LIxgJrKlLkL6caEKHLbChOS1B?=
 =?us-ascii?Q?1dPBWYiwimyAPYUP+YL2VYMzKquHeZu6y5aZk0knWkG3uNiWSAlK6JDZcvoR?=
 =?us-ascii?Q?1Y7DgtTPrccK+WGavUCCn8BGEHWztQ8HIj/X8aqhHiRAFAkRHrwCB9ztI7FN?=
 =?us-ascii?Q?sCBZkmygB0Y74q6kuXyDkkB+a6B3WEqTY2ypS7aAHmpyERTLZvrNrgamUUvl?=
 =?us-ascii?Q?l/cFV3zWY/Txp12pApqlBJR+SiIxLmlYSs4WCabITTCBUT9rymSD48BHTPnd?=
 =?us-ascii?Q?U6Bi/wDQqSAbo1/24RXISbp5YwbJHnYdFi2qgj7pbQPKLrod/sy6aAYwazPs?=
 =?us-ascii?Q?+UcWG+nf9mgGr5oo7AaSgfHN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e0c449-8fb3-45ec-fd18-08d98ef2ad11
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 09:11:58.5158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qSXYe5elpSpGoMtF5pUJBgg2WThqWiDwVYF+k0kzgrc1uuka34KhFhDodfh/ltu/UXcyxiBwukROvxztEN0pFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4098
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, October 1, 2021 6:24 AM
>=20
> On Thu, Sep 30, 2021 at 09:35:45AM +0000, Tian, Kevin wrote:
>=20
> > > The Intel functional issue is that Intel blocks the cache maintaince
> > > ops from the VM and the VM has no way to self-discover that the cache
> > > maintaince ops don't work.
> >
> > the VM doesn't need to know whether the maintenance ops
> > actually works.
>=20
> Which is the whole problem.
>=20
> Intel has a design where the device driver tells the device to issue
> non-cachable TLPs.
>=20
> The driver is supposed to know if it can issue the cache maintaince
> instructions - if it can then it should ask the device to issue
> no-snoop TLPs.
>=20
> For instance the same PCI driver on non-x86 should never ask the
> device to issue no-snoop TLPs because it has no idea how to restore
> cache coherence on eg ARM.
>=20
> Do you see the issue? This configuration where the hypervisor silently
> make wbsync a NOP breaks the x86 architecture because the guest has no
> idea it can no longer use no-snoop features.

Thanks for explanation. But I still have one puzzle about the 'break'
part.

If hypervisor makes wbinvd a NOP then it will also set enforce_snoop
bit in PTE to convert non-snoop packet to snoop. No function in the guest
is broken, just the performance may lag.

If performance matters then hypervisor configures IOMMU to allow
non-snoop packet and then emulate wbinvd properly.

The contract between vfio and kvm is to convey above requirement
on how wbinvd is handled.

But in both cases cache maintenance instructions are available from=20
guest p.o.v and no coherency semantics would be violated.

>=20
> Using the IOMMU to forcibly prevent the device from issuing no-snoop
> makes this whole issue of the broken wbsync moot.

it's not prevent issuing. Instead, IOMMU converts non-snoop request
to snoop.

>=20
> It is important to be really clear on what this is about - this is not
> some idealized nice iommu feature - it is working around alot of
> backwards compatability baggage that is probably completely unique to
> x86.
>=20
> > > Other arches don't seem to have this specific problem...
> >
> > I think the key is whether other archs allow driver to decide DMA
> > coherency and indirectly the underlying I/O page table format.
> > If yes, then I don't see a reason why such decision should not be
> > given to userspace for passthrough case.
>=20
> The choice all comes down to if the other arches have cache
> maintenance instructions in the VM that *don't work*
>=20

Looks vfio always sets IOMMU_CACHE on all platforms as long as
iommu supports it (true on all platforms except intel iommu which
is dedicated for GPU):

vfio_iommu_type1_attach_group()
{
	...
	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
		domain->prot |=3D IOMMU_CACHE;
	...
}

Should above be set according to whether a device is coherent?

Thanks
Kevin
