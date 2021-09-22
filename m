Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1F5413ECB
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhIVBBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:01:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:30011 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhIVBBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:01:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="220296889"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="220296889"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 17:59:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="613209195"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 21 Sep 2021 17:59:36 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 17:59:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 17:59:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 17:59:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwmAf1usQrcX9jtb9arf7gciq/OujiVHZholUckabx+PPTJ7Mp5sHwSCMCPIm2+yZyzbs+GotA6u3UH3kHUo0yO33eL2SvAGT/asswNjAPqeuQHQbL9MUd3YBk4Y1TMRLRMM8UIY/Uis3dF40V4DbTYsc76hsip8QTxdjTYLqDr2VtcTrRnC/V9utV+MXyKOvZZf9QG/g+RaV7ConL8nHQhaJO3cbIZ+2p7il2AKjKV0+KIfWTMpw8254wY5Mq1v3PgkPsERb2WKiaf14WZXor+nQdHwDbzL2+Q5LOh5nMJqiv55Qtq6kduZdxE9zV1NA7ThcxNsi3Nokg4JQbUIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JcwJil7iuuQZAzJVeIjg52jyjCQPMJI2gJME1XeV3nU=;
 b=ARliLdEaq4VjlZzYD8CIOb6khWvfdkS22VKsEQdnGMNFcAaKUpg57PC6DlFco3eLKYxrwriNa1bAF1XdEGDVsBumOnzvP9oEtwDlLbxhB7jg1gTlwihuZzfgsczLeVn+iM/HhREiA5We4nzvlpqNUARdLmnz7G6WXzuJr7kYO95wQAzrlFurpqCNaODNvJJTVAj2Jka8hEDtKMGT/JQ0SIBIFC9dr6W3/eJBhuxTlUlC9LQLNUTQskAtH7fX89PqWwB7+hI2Z7xOBRgE1rQYNI72If0hf8uPPoQa8F50ugjK3vCDV4vqvRaDEEwpzaHzq0hGz9Z91qwkyfiJfJb/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcwJil7iuuQZAzJVeIjg52jyjCQPMJI2gJME1XeV3nU=;
 b=PFnuECxpBi8raTbBICWpjPgonANW5sVdpnamV/cmi0hhuaFHL5Is/XX7c6Op7n6ncAseLb8Y1xVYLA9sHZYgzMRILQmgYqCFW1fh5tbNs2UBLtsO+wPNTpK28l2BkpYikh1iD9rE+1p8iFgS8r6HimBPYFPLgEBNOWO0Ceb29qw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB0049.namprd11.prod.outlook.com (2603:10b6:405:67::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 00:59:27 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 00:59:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
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
Subject: RE: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Topic: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKuuqYQAgAB3MFCAAB2WgIAAAOgA
Date:   Wed, 22 Sep 2021 00:59:27 +0000
Message-ID: <BN9PR11MB54330FF701EAB6BAB55C53078CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005337.GC327412@nvidia.com>
In-Reply-To: <20210922005337.GC327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c513d2b7-3be1-47a5-4521-08d97d643a27
x-ms-traffictypediagnostic: BN6PR11MB0049:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB0049031DE4B20B940512B9D58CA29@BN6PR11MB0049.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XxemcW3yrhyVqToZvD4qg5bnoHLeIZLdS8Oxen3kPjROXFWM9xywc9pJcVIOJ9RZxnzqXB7zETo6xZz4SWokWleB57vTHHrUADAV1vPLQQrEAME0cHfpqA+X+qFRpkszHBDe46YVpdrhihx2RzjQr67fmXgolnaKBTmJ+R9rufzQaaHnr9ODQpPmQWpHMK8hIGsnt5Fqq1bnQhomNnXZBM/yGvqJr/YeYL8++KCwzK/RGAVxqB/0nECPqBWaDJLs34qHltcwSAvtmU7VCx6Mh8U72BEsYm3oo+/UkMVT+ZJ9qtYpbS7zsGGEYNSshygyZvOpqcQ61ibImoirlMkMOvDcaf6+29Zp8sYIRP03bZZdCzyT+L5sJ+xfjjMnyQ5vsoFHCjh4D0oKkWko58X5EN37R0TfyXBltaSYno1ieDRaym2S9zu+KHTzIt8lolXgCO9u9VsWBXg/6nYiTDAwavxRS9UZUCAD108FDAqo3/zzk7XrNb0P7MrimZDNta/VlWibJtOvlRjSiJbSKoLP78eprYOWGau39c/PTetQqrbntQ4U2mAcE9ratkBGiyNlS3laQvGLSDfUBNwhlqhdLLTtS8K6rIXY5riINymoI17YrsCMFWTebMPzQCRoVAgtyhMPfUestLXhamS9IFVLvbPAR9aXFLgQzPGrkEywSN5MR4szL2kVBf0Y7QteWMwckSxoPITvT0vJ25k+wd3GlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(4326008)(8936002)(26005)(8676002)(6916009)(2906002)(5660300002)(33656002)(54906003)(66446008)(6506007)(122000001)(316002)(38100700002)(9686003)(186003)(71200400001)(86362001)(7696005)(66476007)(508600001)(66556008)(7416002)(66946007)(55016002)(76116006)(38070700005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pXvlUjsEsFvPIB6Y24/7MraEpkKWk7Y9lbcd8/8ftl0TXJ6CwURapOB8GjM1?=
 =?us-ascii?Q?xSfb0D/+f9LqC0PEEic1ZOiTTbIkLhF7TY/7SbgiI3I4Q3jVULFN9dD1YuLE?=
 =?us-ascii?Q?7m8tTgP2dezOy8ELo/G6dBuRTH8+yx9PjJ3a2p51syVVfUUyeEMkTPeHO5Cw?=
 =?us-ascii?Q?2VLF/6CqlBYjVHVol91Xx27DKNfiZfGWRs5gcFFYCIXzSb6Nlo/NLiWpSAQh?=
 =?us-ascii?Q?KO4q9o4AesPdaGppK9uZcQlpKU79ymdV1oCAf6jDfeFVIJukblig1STLAU3k?=
 =?us-ascii?Q?dU+Hstr/DH3aYTxyZGBFKLNGWqFUJISTrwC0EgqvHaceMWZWvn/VtCU/nyIr?=
 =?us-ascii?Q?2ksgnHOexzAJ/RIoV0AYiOAwwy2fydbhLRD5MLhZtLFwL/mcTbP1E7FOdJNI?=
 =?us-ascii?Q?bdoPAF/eFiVAiok4V8bx6MVB9SLCwWeu5Gp65FBUlahpUeZCNUCqFWrfZkJM?=
 =?us-ascii?Q?aX5rubYZSqb68VFCjDScu5zl8SnfkyL6YIW2YImdLTnAya4EY4seVq96/8oh?=
 =?us-ascii?Q?thLG5aqP+PUD1JZuXSlvRMDc/U5cgtLJPjMUsGXyYBiRRyV8lv0zp4lg5fnV?=
 =?us-ascii?Q?xG+zX9V9ME4z15+cfi5G6wmSE+MEIFWIV2OzQZzsqUx0NK3kBbjuZriOsrN5?=
 =?us-ascii?Q?HZpILgBjsdNHgLw2TYKGo51vp56AnlZXyBsTIDSdXE2e4FGsDA/b9a3ZgJkQ?=
 =?us-ascii?Q?T9+YVeUSUJRVK1/yuJ/5eaUoyaCkeCC7qnf9J551jp0EXszGrzx9hmgRBxRY?=
 =?us-ascii?Q?jKyph+VaqUfunPQ4yLhTed3/Opm4/S7zZ+0H9sYn5unKXLGq4e/ji+gE9oK6?=
 =?us-ascii?Q?0H0poZoQoNAI7NM7Lc11MsdQE1aDwa1V7/4lvGhrbl8E4jXz0L1gsjoJcz/R?=
 =?us-ascii?Q?G2L1Te9iFUuR/jbm+EdCQKuOrpcPaFp+gYtvTr4fT/iX4HbFLRrjsec/epJX?=
 =?us-ascii?Q?Ijs6h+NXXgtFcgxYgtDbLW1EivVsudfawDoPA9TMyvTnQnimhY5xxW6VotD6?=
 =?us-ascii?Q?KijPg9BCJw9f8/t6G+zaO4RVFq1z/wWBtxMZ0zS6kB7IdQ+Ni7jQ/hM8AUaO?=
 =?us-ascii?Q?WksVa7UUAjPNACoNCK+anqtH+ohBzQpSa70gvrF6kwhLlHC9yMgufjOmcC2Q?=
 =?us-ascii?Q?7X6g5Jt1uePZ0fMuDbufjZqxQ26DONNPrtyhOQRj2MhCH+ZIWpbPbYsViHhb?=
 =?us-ascii?Q?wNEc7xtEKTA3ttZ+aOXRkitsjjHeUl5z5f5iVOJdRKhGiePg7OruQ0BAR3HL?=
 =?us-ascii?Q?9XomiMvYtsDqm9/X/cuxZOZ/PFj66tIWlCFDIPWJYDdmZ35/+GDslNXx2iRM?=
 =?us-ascii?Q?e3c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c513d2b7-3be1-47a5-4521-08d97d643a27
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 00:59:27.3946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7bBVvfA1TvFoR4ocahxs0WmhXuUHFa3CKhCwus3aejvorpmzt5nfFlL7YxWFUmUt5itRAxQNxToLtL+qXn9hXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0049
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:54 AM
>=20
> On Tue, Sep 21, 2021 at 11:10:15PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 12:01 AM
> > >
> > > On Sun, Sep 19, 2021 at 02:38:31PM +0800, Liu Yi L wrote:
> > > > With /dev/vfio/devices introduced, now a vfio device driver has thr=
ee
> > > > options to expose its device to userspace:
> > > >
> > > > a)  only legacy group interface, for devices which haven't been mov=
ed
> to
> > > >     iommufd (e.g. platform devices, sw mdev, etc.);
> > > >
> > > > b)  both legacy group interface and new device-centric interface, f=
or
> > > >     devices which supports iommufd but also wants to keep backward
> > > >     compatibility (e.g. pci devices in this RFC);
> > > >
> > > > c)  only new device-centric interface, for new devices which don't =
carry
> > > >     backward compatibility burden (e.g. hw mdev/subdev with pasid);
> > >
> > > We shouldn't have 'b'? Where does it come from?
> >
> > a vfio-pci device can be opened via the existing group interface. if no=
 b) it
> > means legacy vfio userspace can never use vfio-pci device any more
> > once the latter is moved to iommufd.
>=20
> Sorry, I think I ment a, which I guess you will say is SW mdev devices

We listed a) here in case we don't want to move all vfio device types to
use iommufd in one breath. It's supposed to be a type valid only in this
transition phase. In the end only b) and c) are valid.

>=20
> But even so, I think the way forward here is to still always expose
> the device /dev/vfio/devices/X and some devices may not allow iommufd
> usage initially.
>=20
> Providing an ioctl to bind to a normal VFIO container or group might
> allow a reasonable fallback in userspace..
>=20

but doesn't a new ioctl still imply breaking existing vfio userspace?

Thanks
Kevin
