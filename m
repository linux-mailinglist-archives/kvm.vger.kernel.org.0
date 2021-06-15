Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD813A79AF
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 10:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhFOJBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 05:01:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:5176 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhFOJBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 05:01:33 -0400
IronPort-SDR: O7mU1WPHV18KIvd3ExD43188IJsn6GotZyR5eVnvXgvG8Q0SJ/B4E5e80IA45TKPJeDMTWgpz6
 kB0+R31Q5awQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="205983912"
X-IronPort-AV: E=Sophos;i="5.83,275,1616482800"; 
   d="scan'208";a="205983912"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 01:59:29 -0700
IronPort-SDR: WW0w83WPN19IN26T9VrSiMNvi7VF22fgH2DRQcxLamAycMyhGsGbmZHinw6q2LJ7WXqFp8HtiS
 /OaP/EuQMl5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,275,1616482800"; 
   d="scan'208";a="554381397"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jun 2021 01:59:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 01:59:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 15 Jun 2021 01:59:27 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 15 Jun 2021 01:59:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGNhtbKn0re52vQK7ckFhiy8A+Hp7uN0goO4nKksShqm2Q5dAMFmL1Don4jJJfeZPMdQ4NU5DoPoOkP/SXKFagyjCFeI8Js6Oe1pudDapPbJVphIiVLiGtVIym25xbAgiKpFBHfMhrmC//eGGmAqWalldceZoWwj1KgR0IkjEtoDHWvHRNIR/xhtKbTvwcQHuf0ZXJo0yK3aAPK/Dx+VhTW+IfKPKojzPf+HRZ7RkRSDZqPhkHnP6sR6zBinerf3anGaP65/8ZeB6NVl27xu8ax4LaTs4E9T89J888TZ+Z7IHRt78pWIQvD0r78DNG3pJnm64h5uMmO/cRuraymQvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rrlnzwFMwlkV0cgYHoJ89Uztgop6F1HP4kwpMBq9Os=;
 b=iF/k2oOQkIGBoyfnvqyzZgpw9crAgEkyo1+i/gNGpzeeEEHL/QON0CEnYTqaWfkW85i2Al3phj7GoDtDZyzTUZehyXLbJsNpFUCllLMAaGCecF1EwjROEtT0iebVzvvOUrBffo5L8qcDpeK2GMiE0y7Byw1fEVPIQAf9X4vux59mUfo86MLoFQ08Cnd6R3eh2mC7BV7FYDb+BiehcvACh2/DdGpLMVcbz66UVzzwIZ6noEHLZQJwbMcjV9w4G7qmYdmNooMaCeEo8u1JjChNSL6qIeABh1YQlRtuLtAPLW6M7PRe/lyOakM3PcH1YivVlRB5yRt/1k9nJ0rLzoUvSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rrlnzwFMwlkV0cgYHoJ89Uztgop6F1HP4kwpMBq9Os=;
 b=lnhESdIDGdLEpLVRjRhCy6e9ZpYuJItEbl909taKaH/QcV96OzJ5gXoGO+L2zLpT1iAucEnzG5H1u8DfKhX9oLGM5zZ/lWSlnRPkOZdQW9MFL0KjLv/pnDZigBTaur7P2ELeonebccQAUNjLJU6imZK5Fzo/xcRtY0+7l/3P3dk=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5153.namprd11.prod.outlook.com (2603:10b6:303:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Tue, 15 Jun
 2021 08:59:25 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.025; Tue, 15 Jun
 2021 08:59:25 +0000
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
Thread-Index: AddSzQ97BhCb3gd8AUyldaDZ6yOMNABTUTCAAQiuDaAADwOFgAJSmyVg
Date:   Tue, 15 Jun 2021 08:59:25 +0000
Message-ID: <MWHPR11MB1886BA2258AFD92D5249AC488C309@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603130519.GY1002214@nvidia.com>
In-Reply-To: <20210603130519.GY1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b2f7679-526f-4b1f-9698-08d92fdbe06b
x-ms-traffictypediagnostic: CO1PR11MB5153:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5153E61603ABB9989568EB4F8C309@CO1PR11MB5153.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ae/5R6Bz+pJO7UmFeQ3KdFwWFhJuN3VWjYjFIQ7i8yJZRiZZpIbeI56DZisLJVkEqpDkDKHERAYlu62QZHDAAmFuXe6CEP1VnpulYQtFvi6A9wxlKewwJX68ME8+/UPu/qZe4QfKe1KaAKPMVg9i2DMks25CQbENOeb/Wf0HDVJ5BAFMamqQHhrLge+08p6qeoSZBcQairknLdXk+kJdZZUucIQ/YkEy63SKI5hqYxG6PknLZ7UD01pOH/lXtXLnAGaZJumtSmBE0E6ddXc8SeBHrJHh2LNfT2EJPY77QPAF0Jy9JQEAVmFUWdFKYKANqEr4vk9ZTQzuJeSmHcdfPN39Kk6HqjDQv2zJQOJ9XUK3EmCRQnOOXBFbXfj+c0VlZgq2UQJvZ9v9fl17NHvmrgEIvbPe0mKOQKYmI9VSp+/lu9Ab9piMBxtHEn0hDSrFk70wgnkHAADe2rAXScdjtemHJbIu3tv+nbKeumQ9UikM6QUz1mRrbSSCwGCtP/76UEJAtJZ2NTYwZFXnd8dF8nv6rcv/iDSoPDpR611+1Qr73Cxp/auq5xRuhCz3nBXIYs6E2pYK4nAOXyrwyAaPjsmsLIhrVehVnA1Ug9arUJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(2906002)(71200400001)(76116006)(9686003)(7696005)(86362001)(55016002)(5660300002)(122000001)(4326008)(186003)(54906003)(6506007)(66946007)(8676002)(26005)(478600001)(316002)(6916009)(38100700002)(7416002)(8936002)(66476007)(33656002)(52536014)(66556008)(64756008)(66446008)(84040400003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mtsxsaIroVwwMjeqfTkEvrmsbiYu362WbAaYdQeHoCgmYkYFQ+HyRUQPo7cV?=
 =?us-ascii?Q?lyCZTEfmEjVHj5UhnT/btMtkhfW/6SOMqI9sgTkWWITj/J578uJrGHiyStUD?=
 =?us-ascii?Q?aiAss1HEqyZ/EmtQhwv+CWEDlst7zAb4/Mppa/mwMv9Kh99JnTiyFZChLx3v?=
 =?us-ascii?Q?63CSOWvQDVUX2y3wM/fgZvoP4RPcPlWxkicDWidA+BtD9tCyy52xQ7xuM0ly?=
 =?us-ascii?Q?stDxBw8m+2rCR4p1QqB6kqkk/LCp2o5vrI2djHeh0f5R/GJdn6S9R4aiXSdh?=
 =?us-ascii?Q?NRnfl9aNZ+HrLESOctS1YG/3+LgviTdbN9tPkXoQxz7ZZUd6qLpmk/iWBRLd?=
 =?us-ascii?Q?uzkQJMLeeaXT3AIiDNP/IveXxh8qUHb8Z7ILtgyuSJXfMLfd6grgauSasWwd?=
 =?us-ascii?Q?/R8T+HIHh5c56yhyU4CkMl7Rmx/U5nBkGA6u2ERjGcTr8PEshfnHwywSLX5z?=
 =?us-ascii?Q?7HYAD09fdK6zTnKnQo4sbMwpuyy8EybXJ3LXqmMISigSSwMuFK/MR19sEvyy?=
 =?us-ascii?Q?JMnyzEWo7DFtLhh8clvxQEQOGzqfAWdG+/hdMkoFW7nxcncB/DOZHGjfsxmb?=
 =?us-ascii?Q?ppkLXCNBap7KisyYNtMAn14sp85wbIs93moymgnMGqWNZQ1lWsGKb2JtDnkE?=
 =?us-ascii?Q?sinGeNqeHUHysFmUoHUhKh8IXsHsvRt9kY3I8evv4PGnhaYWBDdgBobsnk51?=
 =?us-ascii?Q?py1J6fBMx+IqLa6jbQlKrgLCmlPSBwNdMnqBobe/gTVuZtRGkLQTBJj5C4Zw?=
 =?us-ascii?Q?qXREZdP1tluYkZBvyonOw1cnRSeBIJu7YiDcaWQGWZi7o/0iJH9Uz5xhRjHg?=
 =?us-ascii?Q?dMJKOhH9Q5z9k7kEqJsd80rRnG/koWluxjae0bSZ+rwI+gwUgpQykNlBmFnE?=
 =?us-ascii?Q?wKqdzqvmRv99WUyXqaFval1t6meZteW3Rx2QAKdsrBmw+fj0PMob8xKXJIus?=
 =?us-ascii?Q?F41GBUrfNK1bseYN27gb5LVfJalx1gBjxwSX8a2h/vzdvJyQC+Y0weHQ/J3B?=
 =?us-ascii?Q?ANbukoAhs/CfePYZbdALjcbPg45v4d39/VRx6uMDtDcZh25vOKdiWF1SfyCC?=
 =?us-ascii?Q?O4elHq7yFtVE25c+rY0DJrQahaUm87QjVi7Nz3WWBwl5EYDT/AFL6y892j41?=
 =?us-ascii?Q?eetEamkLuy+5pgCpqSmXm0Z6QXqs6qA/uaf1hWCTm/iUcsan2iLdCo16Rbr5?=
 =?us-ascii?Q?GAXNZkTeeAoFCKjC76S1+SDRw0fNp5ZLFvsFm1GICyH63GEluPanbFa/nCS5?=
 =?us-ascii?Q?UaNQFCzvK4igFV9wK861rJetFDmDobVAALkeNDJgXgo84lngpAp65gDQmROG?=
 =?us-ascii?Q?U4gx8OjFgJ6eWzorpbj24vtT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b2f7679-526f-4b1f-9698-08d92fdbe06b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 08:59:25.8216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fEZQmNLEefx1A+piSgBiVRK8u9tfclOinJ328f7pP75hla0DSWlcfPjYEL14y0H1UnKQuofo24LGuJLpQr5Iqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5153
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jason,

> From: Jason Gunthorpe
> Sent: Thursday, June 3, 2021 9:05 PM
>=20
> On Thu, Jun 03, 2021 at 06:39:30AM +0000, Tian, Kevin wrote:
> > > > Two helper functions are provided to support VFIO_ATTACH_IOASID:
> > > >
> > > > 	struct attach_info {
> > > > 		u32	ioasid;
> > > > 		// If valid, the PASID to be used physically
> > > > 		u32	pasid;
> > > > 	};
> > > > 	int ioasid_device_attach(struct ioasid_dev *dev,
> > > > 		struct attach_info info);
> > > > 	int ioasid_device_detach(struct ioasid_dev *dev, u32 ioasid);
> > >
> > > Honestly, I still prefer this to be highly explicit as this is where
> > > all device driver authors get invovled:
> > >
> > > ioasid_pci_device_attach(struct pci_device *pdev, struct ioasid_dev *=
dev,
> > > u32 ioasid);
> > > ioasid_pci_device_pasid_attach(struct pci_device *pdev, u32
> *physical_pasid,
> > > struct ioasid_dev *dev, u32 ioasid);
> >
> > Then better naming it as pci_device_attach_ioasid since the 1st paramet=
er
> > is struct pci_device?
>=20
> No, the leading tag indicates the API's primary subystem, in this case
> it is iommu (and if you prefer list the iommu related arguments first)
>=20

I have a question on this suggestion when working on v2.

Within IOMMU fd it uses only the generic struct device pointer, which
is already saved in struct ioasid_dev at device bind time:

	struct ioasid_dev *ioasid_register_device(struct ioasid_ctx *ctx,
		struct device *device, u64 device_label);

What does this additional struct pci_device bring when it's specified in
the attach call? If we save it in attach_data, at which point will it be
used or checked?=20

Can you help elaborate?

Thanks
Kevin
