Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37206414BA5
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbhIVOTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:19:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:5472 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236234AbhIVOTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:19:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203097380"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="203097380"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 07:18:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="518600360"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 22 Sep 2021 07:18:06 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 07:18:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 07:18:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 07:18:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K37k3dkzt0SF1YG9gqrubllJIh0EFfRc2QN/tA/+soX31pYx83+SLSpJt0X3AufOxW/9d0lIv/x9FlofLWg9IB2eRhbqpw52NMCNr6ygr4cRJ4/wsq6J5VIAL6bd8CNP9Amdfpx/5Ow3LpFGAfWV+VmmXA7Vs0ARNhgGICXEu68GwTtHl4LAfyn3pEbp1rIToRWgRfh6+Q6S3fOgog5Z2WYFBMwD4jrieev5ORkGSClL1/K5bbFrEuRHe8+H147/3VWLV5piRZt6cFjGqh/fZvgl8oFUzBKdgiAIL5oE1PvB6AFCrdh6MGUkpDBZa72Sgdr9hNMhcMh6D2RGJeh47g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ngLfJKnI2mPCXl57TxzZWFaAw7lf1vDeABL0mKA7e7E=;
 b=QWHK60JPLos3wuYEHNT7zH72N1EabLJ3nAgxLQfGTk/E7UpHjdosftm2OxWgz6Ge4WTcS6D0SGmIcaRY7cqSVIwBWUwMQlXcNnGu1ALHLsHFin03aqjK7gqyUMz3xVoFUZO0qciWo543ZTs4SDCkTegfVE3rFPjanSTTs542YFIUaJAHQgFP4qda3DuCIQa37L7WoWlpi50EAa5Iln+VPqlEeHozA/IxQ5lSeaegYLUyg1Zdca9etGwUl8SPreXVcQGBV3fhrQIE9Rg9WP7E0FUf8vCaeApVP5K18EPxnQFsvFt7OVgzP3cNNl4p+SbzL/JF9OA96LlUlsehFLN2LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngLfJKnI2mPCXl57TxzZWFaAw7lf1vDeABL0mKA7e7E=;
 b=nxSUn+Y1fiu+CkTv77/2CuoDRHxxXwEHtP2CgEI6efLkwCkgfen+7tcbU63gcWr9Ub17HHBf9qvHxaTEgDen75PbJ+L8HmgYl23B5IAc3EaoZSnPM82UG4FlToOtyYL96UzFkc8RTuqDzy1OnhOxFSiKblGqE8jQSakp/1PUXKI=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2145.namprd11.prod.outlook.com (2603:10b6:405:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 14:17:56 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 14:17:56 +0000
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
Subject: RE: [RFC 15/20] vfio/pci: Add VFIO_DEVICE_[DE]ATTACH_IOASID
Thread-Topic: [RFC 15/20] vfio/pci: Add VFIO_DEVICE_[DE]ATTACH_IOASID
Thread-Index: AQHXrSGrvqwDmY670Eehf+r4QAc6S6uuy+yAgACk0sCAAJgXgIAAFfCA
Date:   Wed, 22 Sep 2021 14:17:56 +0000
Message-ID: <BN9PR11MB5433D992DE87A7F8E09E24CF8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-16-yi.l.liu@intel.com>
 <20210921180417.GZ327412@nvidia.com>
 <BN9PR11MB543319F29F0260EBE2A9F3478CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922125833.GO327412@nvidia.com>
In-Reply-To: <20210922125833.GO327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb483d66-456b-4b17-58ee-08d97dd3c611
x-ms-traffictypediagnostic: BN6PR1101MB2145:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2145951B5BDAF378637FC57A8CA29@BN6PR1101MB2145.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: itJJi3QEtto3ooKfxCdTIC+wTsafflT22TQcADEytZo5llmrbDb1cqXphFHwxD2vAk6w+a5Nu1TPJ+dgodOCXgXzmqJIcT7b/sjM+0oNUhwppvF8H0wHBZ6N+Oikc2foNAG50/uiAHechklR0Guf+I13YyiKIsN5QQxcaQp6xxc0HBxqQKa5+UhrhafZY4DEAOMYdFP1xsvt8h5iIEzOOAwj3dh6cJA/Kbo2YwrOZnPZSwWBox7K3bE0EO43erVSRR0dpncHshcI1qID1mFlwuAk3dSOzKwlcXPoGFlCGjkziaabmmt9/miL0SIp/5b3ttglHS3XOBi3Gienta8i6GyaEsafmGve33IxmvReGP6BZM+VlporRX/KM2YGGelHDpHb9GSXHGshGNmDCEDIQLbn5cjxVsKtHcz9BEW07EBlCzpSwB/kLmJ5BY4Oyxh5+D4Q35bJqtQtp8PBEEiAtYGBv/hXSjMOUJZkYNRXH4rznKPOZ5glMFJpHvDJ3gj6kXC4Zdzjz/eoYfDTjlZTUlylUH/9C9UFarwvTiys66YWYQG6e8Gmb2pSCGw9d5vUEupS+ZQq4UUowiVRMcExS9JhL6axnrEHQyUdPV00wvG6IO2kXXdXbvkLyNIhZ7FX+xhK4Medm4Ma+H67lngC8vMRT2nUaNbeSay3S2B0xsQ3Oc0SLB9iauaIwrrVrbzkqozimry3gkY9Y1XRpYg6uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(8676002)(38070700005)(33656002)(26005)(66946007)(5660300002)(6916009)(6506007)(7416002)(186003)(7696005)(54906003)(122000001)(2906002)(9686003)(86362001)(83380400001)(4326008)(66476007)(71200400001)(76116006)(66556008)(66446008)(508600001)(8936002)(55016002)(64756008)(52536014)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HsQ66fNu0xlLRCXqHxqqKddkwsAVhkmff6z51UMIdmXQ5F8NjF55BLo2abHI?=
 =?us-ascii?Q?NY3hyCFXUGZ2bn2Fj7tGVmfN/XW1cSnR/gd049s51kMpBEMWOLTx7S352ZAJ?=
 =?us-ascii?Q?aAdg5KlW7qDES1FLT2Lwrzn6rLi1EIHO3K9PUUcqcUV1wqyigXhiOU6vVR4j?=
 =?us-ascii?Q?XPIWNlw1bKUmc/PI8UzM/Y+iH2MtlfpxiDFsSJreCwu52vdthXDyQyAAWrTZ?=
 =?us-ascii?Q?45QAclNIu10+RdPWDMyMdgSfzGvhTM8R+Av1+X5yjdee6JdCzpU64+QFF1FH?=
 =?us-ascii?Q?eatXFsw5Xi+1l3rI6DtGK+Ps9WHcWslIEdusIoUwuS3G7YrntS07QdTZak7J?=
 =?us-ascii?Q?aKR88sYKwzDZNwl86WWs7Mo+Y2DO3xK7D82hxBz0bUw/NjLlU9gxI4XEoCf+?=
 =?us-ascii?Q?50YJ6XP0HOWYXBD2NBkhIvBFAQccdjwmJpMmSE62my1jsDw/9V0tQcOWHV2T?=
 =?us-ascii?Q?T+dEurKZtF22+HkJcr7IDmT//jZ+UDL6zr9jWEI0MMuxOGUYgmHpk/ZdqIQC?=
 =?us-ascii?Q?ZI+V2uDABcQJqx/hp/yPmqHBHHlMkbKCc6pQ2aiiCWEyaghrZDQLqHkLaUju?=
 =?us-ascii?Q?fKUwvijHhgmi0Ij5N1M2K8rxNCTMNGCY/mnpFb06pJVIFyLg5lHa7nblBAnS?=
 =?us-ascii?Q?72QGEKbo7j40pcCiSe7sBo4nbCxfAer9x/nKVCMKmTWme31E7hXc313CRHQo?=
 =?us-ascii?Q?izVWbAHQjLGq2+DFuJvvslMIEOM8mmP83SKFceL8HMMGUBXLYqk+3+R00hT/?=
 =?us-ascii?Q?JCvDpQ/omxY4Jitmpl8UTMi4gVeDIKIgnv44Gn7pseHay28LsjTTYW4ii2tX?=
 =?us-ascii?Q?fVXij7/ysOZGpbWEYjX5YLuncKWYu6fP/d/nkdBQ0/9tsHuPdULlvFN0Mwvz?=
 =?us-ascii?Q?kh41BiN3Y8fsw6IzBaePZPltYbEeBrUOpyXHU0PsqPyTng3pA2BAopHZk+LL?=
 =?us-ascii?Q?ZEJi92J9yJN1LH2Eeju8h3gH+cK8qIce7kh4GaFg/EzpW9EItbtL4NSKKSK3?=
 =?us-ascii?Q?B6GwSLLqjgavt07aqJeH60GWS7nrWPQCvtfS3e4dMz1Wf/WlcroIjv9JmkHA?=
 =?us-ascii?Q?iekD3GuRw0oEJI6/g1juCKGvgY3glGc5A7jhOS/kkLUhyBqCK/xDGmAOd4cW?=
 =?us-ascii?Q?XObz8XZ5EZ0BnH20MrqYk9g2YK7s94+o+lzvoeFbR28rWB1KFr2WedjUZzRb?=
 =?us-ascii?Q?pEp01h9Mg8b1KY4AoE5BuOGzXPtDBYm8OBB6a0n8zOxWdMykw8cr3BonrUXH?=
 =?us-ascii?Q?GbmdAdomdQW9l9oFZrMvhTGXDDtxFnhNe5LIRr7upzHzxjXGlPXVUM+EsMAZ?=
 =?us-ascii?Q?0SLscLeJUvxBYMQ2trTRrr/R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb483d66-456b-4b17-58ee-08d97dd3c611
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 14:17:56.2241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /jhs0TYsyM5NkC7KMYgtL6/DW1a+AeCXReyhMIA+w2R+5cFXm7HY7tr90Z8xTU32k/46y1ppsD1JtJDKRX01Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2145
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:59 PM
>=20
> On Wed, Sep 22, 2021 at 03:56:18AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 2:04 AM
> > >
> > > On Sun, Sep 19, 2021 at 02:38:43PM +0800, Liu Yi L wrote:
> > > > This patch adds interface for userspace to attach device to specifi=
ed
> > > > IOASID.
> > > >
> > > > Note:
> > > > One device can only be attached to one IOASID in this version. This=
 is
> > > > on par with what vfio provides today. In the future this restrictio=
n can
> > > > be relaxed when multiple I/O address spaces are supported per devic=
e
> > >
> > > ?? In VFIO the container is the IOS and the container can be shared
> > > with multiple devices. This needs to start at about the same
> > > functionality.
> >
> > a device can be only attached to one container. One container can be
> > shared by multiple devices.
> >
> > a device can be only attached to one IOASID. One IOASID can be shared
> > by multiple devices.
> >
> > it does start at the same functionality.
> >
> > >
> > > > +	} else if (cmd =3D=3D VFIO_DEVICE_ATTACH_IOASID) {
> > >
> > > This should be in the core code, right? There is nothing PCI specific
> > > here.
> > >
> >
> > but if you insist on a pci-wrapper attach function, we still need somet=
hing
> > here (e.g. with .attach_ioasid() callback)?
>=20
> I would like to stop adding ioctls to this switch, the core code
> should decode the ioctl and call an per-ioctl op like every other
> subsystem does..
>=20
> If you do that then you could have an op
>=20
>  .attach_ioasid =3D vfio_full_device_attach,
>=20
> And that is it for driver changes.
>=20
> Every driver that use type1 today should be updated to have the above
> line and will work with iommufd. mdevs will not be updated and won't
> work.
>=20

will do.=20
