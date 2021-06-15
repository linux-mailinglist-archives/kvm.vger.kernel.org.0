Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C253A8C3E
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 01:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFOXLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 19:11:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:5632 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhFOXLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 19:11:45 -0400
IronPort-SDR: krv5VOT2S1t/QuELlC07dBwGd26/WLxlyo2QxQWE6yo6DNxr+hOEARJjHmFJpLmpc/CxW7TGkM
 ALTJvGqcvEwg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="193392741"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="193392741"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:09:40 -0700
IronPort-SDR: SybIKhLo68vX3sB/Dv0c2eIQg1JFRFdTnesqEqt5fIKZNYO9N4/zh6Pm5SBAVyAzaqZu5IBjqg
 mgAzZ3MU31jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="404109386"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 15 Jun 2021 16:09:40 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 16:09:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 15 Jun 2021 16:09:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 15 Jun 2021 16:09:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0ogWVxhWlxAyohfWo1MEI+jEanqb+DyfIoO+zDyF9vyD16wI7PQJYVjikrl4Jxdr+fgbKFf7ObQ7zrsRiyRbaLZgq5hnhPFvGflqTwaZDXQcmnHdZowzp+BtUk7b154Sg8PG2+4GMiId/SVhIhcCqH7QmqijOgQLLHXQGDHn9BV3QbSbanKW7CAejJHibwePz6rMTgVw2jLOoGgpJW7NZO7oSoNtuvA57JM8tahQDchPOToBCVUa0gxU/VCCvN1Ym8Opfnd9ufEG2kI83GffmpQiP3r5iV+/uuMeu8IX/qH2RyJ9fyYYNPoywQ+hu09FIcImYwr/QA/6wjnfkoTRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/W7HtWYArBp+6MnlnGZlJrRdhoDndOHd75yEbPNLNI=;
 b=d5zfeQT4u0mh/qaoFZlJhJIk5qMJCOqHz/yPV0MUIoVHIhwvlyk/33cku+jVa0QwdbELHdds5iHyp/t5P7eI8dNvTM/4MZDZUnueJCc9vHHWzDj+b9oafSANn1tUHywEzMk7BAI3fp/Nxvf8CN6R31HCH4Azrt2R/N+mfxrwUNHR09YXHMD9rZGEnsH4KN2Qm19ICsv82vwI46osgmgfSWWRsQb3f346z9EK1FRjP/bUOCn5pv7fr3cH5V3FclnIi1wHZEKHGUxdWasI/dUyP/ZrzE0swF5U2wB6krnaW249BMUcW9C+X75MDVKxCJIKturRMDvGBD5odZiSnrAilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/W7HtWYArBp+6MnlnGZlJrRdhoDndOHd75yEbPNLNI=;
 b=LhRZ3tETZGVJ4NOtCP+b9a3kdy9ZXAXIKj9FY/z4yd8eG79QNZgb+bn+pER3xJAjclTO3EwPc86lir3GPTHkYxFveON+/QC5eHUx8ucw9ApLqKe5KiXcHLJxESA/ODzq/qFTuZTfESFWo6jd7pmCQu0AZQX7HM/phLy7mze1E2s=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 23:09:37 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.025; Tue, 15 Jun
 2021 23:09:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Gibson" <david@gibson.dropbear.id.au>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ97BhCb3gd8AUyldaDZ6yOMNABTUTCAAQiuDaAADwOFgAJSmyVgAA0fjwAAEFKEEAAASwWAAAAgcXA=
Date:   Tue, 15 Jun 2021 23:09:37 +0000
Message-ID: <MWHPR11MB1886A0CAB3AFF424A4A090038C309@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603130519.GY1002214@nvidia.com>
 <MWHPR11MB1886BA2258AFD92D5249AC488C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615150630.GS1002214@nvidia.com>
 <MWHPR11MB1886E9553A5054DF7D51F27D8C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615230215.GA1002214@nvidia.com>
In-Reply-To: <20210615230215.GA1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.71.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb3e58d5-19f5-476f-ce02-08d93052a5e2
x-ms-traffictypediagnostic: CO1PR11MB4963:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4963BD3F50D70B161B20DD5C8C309@CO1PR11MB4963.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S+G5wwk1xWeRXldKL1KIsrdlLTi7RoUPHR4eMl9kymjb8X7Nb/ukUdASZIsU06Ge+Y0B/pLhE1J4ntldYPh/8/V+Z+/M81x00sgajJGSiCCrVr8H0VWIEDEQpRBB8CjoAmwiT2V9DdcWbjiOIBxMyWD0tPfAsq59D0ffBQPMyXUp1EEm9wDmhTANyV80bhCI4oY6UE7Xy8cSvyG0FlLTyvzILtUBcQcFsVwF+w5s5UZtnBABKn8OBreu3J4exuwL6aTy5Gpn0wbQJRPF3J+xnqL0NWotDoUJtQuNgOMgueCgjxImDG+tbEDYE9Bmotiq70Hml2oZRMER8VH9f35POEDndXixH1Gu170x/tANAYdEf1h7vJ9hJ5gdEGhOMjZ4jgl1EvrpSuLXA/Dv61CP+3AfNX1yatetmcwKbd8hNGyntp9Cga/YaS6hSu+ab4hYpHLzZuqcB0csDeonbU+F78UVIo5pgJFtFVYeN/cgMzPnylZ9WyMsY9CSu4Q1DCdvvknhSF5je6jZOKVBGgqTWNcOUiVJOXVQoXJv9oC180jDzSlxYfXKoLImyfmJ2J63WVvMjUlR4b0VUQcQh4ACtHwmvYHYt/29oHhnudKVJZQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(55016002)(64756008)(66476007)(2906002)(66556008)(8676002)(54906003)(66446008)(76116006)(5660300002)(71200400001)(26005)(9686003)(7416002)(52536014)(478600001)(6916009)(186003)(38100700002)(7696005)(122000001)(4326008)(8936002)(86362001)(33656002)(66946007)(83380400001)(6506007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eguk5xzLesmU+lXxrdWSe00mdCe9SbgV/Q3qtzNkvR9blpOfR+clolWkDg3B?=
 =?us-ascii?Q?bRni14K0EZfhgAgYBNsawqvfFqwGHSmnv4Ltyx5M2uZwlh5zyybRBrkBmJc8?=
 =?us-ascii?Q?UOfLDmYW1qqElxbXMdITXrPd5jc4/EG8hCQC+Zhhg3G4kQhD6LPO6hJv9zR5?=
 =?us-ascii?Q?8BIVpwG3FaQZvsP5pT/JgG1djYGJOcbahFjDhPCtauw7v0El7qrxQFmbmKIb?=
 =?us-ascii?Q?Rd0v5ePTwG5qgUB+i1mIsW1ZcMYHB/tmr2lRlZAFAtepzDa6jFhMrznXfWWF?=
 =?us-ascii?Q?vgYfXAh2FRa6tElAxJ7Q4763WaZMJbVf/yvJtWIscalnO3jCgDHLSmY/3y4x?=
 =?us-ascii?Q?W7OCu+uGKE8H17H7mSCh6uc9rc7pRwYarKJp8Dw9tr9FNYs0XGfZdJgBPAHF?=
 =?us-ascii?Q?rN8dKR9QDQkGghL9iliL1+ce1AgMdmP2zAJWRS6mcpJS6/2VBrVeIC08iIDl?=
 =?us-ascii?Q?JgDTpp4NUP9eXXkfSVjQBcq6unQfLMlYUpubzX10OwT8jf7X0+W627cUz8jQ?=
 =?us-ascii?Q?F1+VuO/oXMr2GLHCTFjSki9v8hlLjFE4y+UvCIGE5t3Xk0fV0bPQ3G/ZUBwO?=
 =?us-ascii?Q?0RdSfd++xUylVbF0z/n1EQbZEVudstNecW/x5+Lftcjv/yCsenzFlUwxbZba?=
 =?us-ascii?Q?S9x4w0NymQ1VVt/mjXPbdig5iTYl1Y9PZprJwBekzXNUUcP4fK9vizYI+OcT?=
 =?us-ascii?Q?VV8668zDqKSRv0bf0zWgzHWg253UflcCprDHKnFu3BFt6CS5PfiuigKwB5xt?=
 =?us-ascii?Q?+nAG519ftUgnpWul24U9F1M2xYjC0+15H2ObYsjaUYpNULwr5pii9DjR/TbG?=
 =?us-ascii?Q?w+VBJw4hhIn3ednIEL3BUmgDsxsHCHynyyeCO5DS+bjESCV/pltKtkR7y9Bt?=
 =?us-ascii?Q?yBcaZukW6gW9dabOtrSMHgeI/PK43iUtrHYfmuSa26lH57MTj+XWhD74CcSD?=
 =?us-ascii?Q?s679AduVGOl691OmO8nfGicJnK6HeU23Y6aY/nnrdSgMwTJbT6QZYbNIcLWb?=
 =?us-ascii?Q?v/+9qSTfGYTrV6Zl+ePUQTz+WGqt3vjfIiPM6RPmfm0+/evi+X57f1C14H9b?=
 =?us-ascii?Q?UdGXAkGHF8mHkRsYFskLyxw4CFtJDP0YhTy/EcQT5XdD/A0v3Cs2ff7OVdFN?=
 =?us-ascii?Q?BVWYsFZL9+tkSK1W3Fj1zY5dI9RJ+aJJwGb0DPk+iSOmW2mE2KdH/MpcIper?=
 =?us-ascii?Q?6Bt7pyKEF7mqbXIhu9+cUxEIj2k1MAqNNfrHtrOvnD9/1tK8qlTWprr9HJHD?=
 =?us-ascii?Q?2REQDoqLyIeSjDyfLl2pt2zuX2m8nNn3S4fUawOHJgVHjOPNmyqBsKh/DfVm?=
 =?us-ascii?Q?SFsVSRdt8a6+czQ31+a4ZZHu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb3e58d5-19f5-476f-ce02-08d93052a5e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 23:09:37.6622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rkA5dkH4JFf5QIZZQZgOk/y+nuyV6EnqMTZLo2rABgehoOJ0w2n4G9M7RQEvcZTZCN64W9TbMJHDv/H477hW4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 16, 2021 7:02 AM
>=20
> On Tue, Jun 15, 2021 at 10:59:06PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, June 15, 2021 11:07 PM
> > >
> > > On Tue, Jun 15, 2021 at 08:59:25AM +0000, Tian, Kevin wrote:
> > > > Hi, Jason,
> > > >
> > > > > From: Jason Gunthorpe
> > > > > Sent: Thursday, June 3, 2021 9:05 PM
> > > > >
> > > > > On Thu, Jun 03, 2021 at 06:39:30AM +0000, Tian, Kevin wrote:
> > > > > > > > Two helper functions are provided to support
> VFIO_ATTACH_IOASID:
> > > > > > > >
> > > > > > > > 	struct attach_info {
> > > > > > > > 		u32	ioasid;
> > > > > > > > 		// If valid, the PASID to be used physically
> > > > > > > > 		u32	pasid;
> > > > > > > > 	};
> > > > > > > > 	int ioasid_device_attach(struct ioasid_dev *dev,
> > > > > > > > 		struct attach_info info);
> > > > > > > > 	int ioasid_device_detach(struct ioasid_dev *dev, u32 ioasi=
d);
> > > > > > >
> > > > > > > Honestly, I still prefer this to be highly explicit as this i=
s where
> > > > > > > all device driver authors get invovled:
> > > > > > >
> > > > > > > ioasid_pci_device_attach(struct pci_device *pdev, struct
> ioasid_dev
> > > *dev,
> > > > > > > u32 ioasid);
> > > > > > > ioasid_pci_device_pasid_attach(struct pci_device *pdev, u32
> > > > > *physical_pasid,
> > > > > > > struct ioasid_dev *dev, u32 ioasid);
> > > > > >
> > > > > > Then better naming it as pci_device_attach_ioasid since the 1st
> > > parameter
> > > > > > is struct pci_device?
> > > > >
> > > > > No, the leading tag indicates the API's primary subystem, in this=
 case
> > > > > it is iommu (and if you prefer list the iommu related arguments f=
irst)
> > > > >
> > > >
> > > > I have a question on this suggestion when working on v2.
> > > >
> > > > Within IOMMU fd it uses only the generic struct device pointer, whi=
ch
> > > > is already saved in struct ioasid_dev at device bind time:
> > > >
> > > > 	struct ioasid_dev *ioasid_register_device(struct ioasid_ctx *ctx,
> > > > 		struct device *device, u64 device_label);
> > > >
> > > > What does this additional struct pci_device bring when it's specifi=
ed in
> > > > the attach call? If we save it in attach_data, at which point will =
it be
> > > > used or checked?
> > >
> > > The above was for attaching to an ioasid not the register path
> >
> > Yes, I know. and this is my question. When receiving a struct pci_devic=
e
> > at attach time, what should IOMMU fd do with it? Just verify whether
> > pci_device->device is same as ioasid_dev->device? if saving it to per-d=
evice
> > attach data under ioasid then when will it be further used?
> >
> > I feel once ioasid_dev is returned in the register path, following oper=
ations
> > (unregister, attach, detach) just uses ioasid_dev as the main object.
>=20
> The point of having the pci_device specific API was to convey bus
> specific information during the attachment to the IOASID.

which information can you elaborate? This is the area which I'm not
familiar with thus would appreciate if you can help explain how this
bus specific information is utilized within the attach function or=20
sometime later.

>=20
> The registration of the device to the iommu_fd doesn't need bus
> specific information, AFIAK? So just use a normal struct device
> pointer
>=20

yes.

Thanks
Kevin
