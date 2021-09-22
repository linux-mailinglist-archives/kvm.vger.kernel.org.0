Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B1741400C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 05:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhIVDbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 23:31:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:30539 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVDbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 23:31:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="287178384"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="287178384"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 20:30:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="585239417"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga004.jf.intel.com with ESMTP; 21 Sep 2021 20:30:14 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:30:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 20:30:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 20:30:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ls/6+5d0kLpmx6Sjta+5F2dQCFVabCZrLq7I5ll7giu1yH4QbwCYTRlJ34hRCASFWYRSRW+eW+hy4b7Tj9xGog3izbGqi9TnXDbY26m4Dor4zJLkHAzjDT9NGqHnr2OA/ru8L98LwObtPwxeVuEgRbHgE7/mMY1Q2kg5o08RBdkKKKbEeaa4iw7lnKxFJ9BbCs0JXNl5fwUw8RuP8DNnwvg5idWAVSLSSy0BfJIg3HpFPrUbkdL4EMzXUsV6ldHvoW8ZzdSGaHwjswtKnY1g5DLAZbrhX+Je254kkhQhz/gXLDevejplxZEx4P0etNHePyvFE+EU/bw7LATatwzsZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8XHc90ckB55SqKoPP3vawbZNLtG6kQ9EztSTR2uAcBw=;
 b=SZ7/Q6bdTC9VLbNpUcZhwqm/lknyxHFLSRxuNxI9LIHxnNP4J9bdBq2KEchpV3B7lUDTSdASInuNbRmNLZi3/qFt8ybqzC1tMDKfeutivOWlxufcZGVSIL0c32wp4rcbSMvRz/d6PgtCyyEKrSHg/Qy15zaNte/s/2rPmzX0eS4wkVwGaVcsCVNljtmoNDIzWH6LB7qPHZuzK07HMFTkbJfyzKQV2teiO1jPtPYxENMSto8ch374g/QoSx30edHQsOj7do+rAki+ipp0vAkLr3R8KvwL+nKwRRtNE0HAgIhQZZZ4FS19aVIXocCu9RBnlvgaOKvay0q6jjzSRPIoMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XHc90ckB55SqKoPP3vawbZNLtG6kQ9EztSTR2uAcBw=;
 b=vBr5FT7udRFBOKyGbLIByq6De4pdnTrNpSxhPxcCmKLNENyi9hBT7xA6vpHQpvXckkqWsP6XKNEe7w+D35Gtv1UcJKTxqwpp1NndpuTGUEuLO0aXCEvzVuAyIpQoNoSc3wqJTLxaJJCqjxsN2V05E1Zfgbq+tJCHgdBNpZGlgd0=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5757.namprd11.prod.outlook.com (2603:10b6:408:165::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 03:30:09 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 03:30:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauuxV6AgACjuTA=
Date:   Wed, 22 Sep 2021 03:30:09 +0000
Message-ID: <BN9PR11MB5433D26EFA94F59756AF91838CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210921174049.GV327412@nvidia.com>
In-Reply-To: <20210921174049.GV327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be18adb7-855f-461b-eff8-08d97d7947c2
x-ms-traffictypediagnostic: BN0PR11MB5757:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB57578FE83524E57CAC50DA008CA29@BN0PR11MB5757.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kOuWP+El2AKJaUPftL7C3Gsh+DSD9ZvMjB/AYTv5/giOPVlxCx5hw6z1J3i4UqHMTKw6wE6SB0jP1N5ykDiQM5lbeTgSKumOTgJRmEIVJnfUZuCWoMglo2Qd9fXJ5j5NULCSeQJNkTvDaQgWMNCqW5sJfISbyLpp9Hm1LIpvi88z8NNZHcEr1dJJS7yNXzjUkJqrAV866KULfQOs4rwsw9lAmn+xAp39JmUjhka4a/vbDkIAxZsigK9QxAb5CoHSDD0gtybWzJl61unTq55T9CMI4G2Xai44UkFsCe7KYFg3AE5SnmxKU8lIOdWACTQoSVXAQ771QuMaukAZ+cMahcSO+rCa1HP/wE5MQ9BP7nA0YTa5IXdjhLrzve0bGYE1oHZehz79zynd+Q0ZjaIGFWiW9oNTDdqAU5fDyH+tClm0lEzZEaYk+MPVUDII5Fs4GZplcnn0gFOTEbB2nom/TSvJx1CG4aD4+cRr6hY/IIAAFFb8aMY7hzmSWfbbcnTeh1I3K/zmFEGZ3RhiUIOkfAc5fdTY2oMmIoC9JKfbjQ0cdvKRryTJypO9bIRXiUJmoyuG/tqTPcmmcF+416kAovDFohENn91OdEW53i84mpJ2xcu9NTZfhF7616Hxh1UC+TSZaHzW46azi3Brz1QmlUyl4XyhbJP+zZb6PsyGe0OqkKWhPzbqYS96wNOAfqeAWFaa0gMyhsJWJPtj7UYEOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6636002)(122000001)(110136005)(8676002)(4326008)(26005)(8936002)(33656002)(71200400001)(54906003)(66476007)(38070700005)(186003)(6506007)(66556008)(316002)(5660300002)(55016002)(52536014)(7696005)(38100700002)(7416002)(64756008)(86362001)(66446008)(76116006)(9686003)(2906002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bIWx2Fj+vJq4uHtU+XMkYzJcZwipjwqqd3+gkYeZCk+Ct6X8I7LYvaayJ8IL?=
 =?us-ascii?Q?6naTFp0CYFnSHWDZnBUNa7wC1/+EWaWtjnooSIO8GOp5tA7McBeJAHaLloA9?=
 =?us-ascii?Q?IMlJqa/qkQYFdwOqHR0C15PDkJBLPhOklklG7YtlpOuPCP9KlgGBtfaatimC?=
 =?us-ascii?Q?FKK2MYTKrG02rEO18EoNGcpfQlRBC7Hnu6+SclHV51KL8Sed02r6yqKB2YV0?=
 =?us-ascii?Q?mqW3Yfg8xfaht/XHtYDzRJF+87mgnFEor0+U7wpt3DgpgoCiGUeWOoPq2r6C?=
 =?us-ascii?Q?qh3xGnl4QNvrQwvvhwwB+hFb55ds/5Ea6IGIsQwzElOAc9lLoCsswD5dHNQF?=
 =?us-ascii?Q?7JA2GOm/6sBFaN9zrloMJ6wVsOiE8okX/sqLYqL+asVafa2T3IpmpbfN3Irm?=
 =?us-ascii?Q?4KiaZQrgfTJ9W6oyjKk0thUw7JN1zDP2GaEY81VmJjSkRpMev3TgguVNDMjb?=
 =?us-ascii?Q?6Up+CaEY+ZV+NATt8pw330M47NrgTAmgI+bRD8uBUn8hecelSNaUnXv6mm1+?=
 =?us-ascii?Q?RuLfr5bz6YlEXMjJmN2uG9SqWka5RVMNSygggF1QMtr2uVXiGLpvTP7iV7xA?=
 =?us-ascii?Q?HvkZQtNIxSL65KG9YfAXx3wT9VXJywyq/8XsLzlp03IAhVi7Z3LOPWptjuNf?=
 =?us-ascii?Q?lTRuOTW2A/bWIH25hj8uK9qY4vzWTehg6QT0TTnQX0ugxVDTP4cRjbfqhcXy?=
 =?us-ascii?Q?CpQVZpsJUAAiywm56M6xSNymGsYcNfdHNQg37Ysr3pOVFRohecd2ABp/5oG1?=
 =?us-ascii?Q?qw4+9Jzvl3622Te+EN02AMuZVQbiBhhYety2Zg08h7eqBKswygsZgFA9x1I0?=
 =?us-ascii?Q?dYfJHYozZfcP6d8orqvyln4sMIZZk+Cqa2yogsOxW/RDX/h90VEkzzOP3j/V?=
 =?us-ascii?Q?D/Zpz+wUaS/fulbtrvIlKSPz7In0VRhWFR5guKTyY+95LwPVJnT9Dyck4sS3?=
 =?us-ascii?Q?v94qU6SvktVGVO1mLnxr8b28G0GGKUiKOQn9ZT+NYP+S+xbVvuZRsuvfc+a+?=
 =?us-ascii?Q?C5m2S5iNUjGGNzAloUc62oA6LyQYyFXfZuWJJjq3vfDdu07vMsXzGiYoO/FO?=
 =?us-ascii?Q?ntBzKpAtzT/AVsEi2DcJr+XvMgRgVy3AXNRUx5+4FiDK+3s4nfB19E3K/ZG2?=
 =?us-ascii?Q?Kvf5Zg5uqXeKjiXNkrv7aqwPF3UcMMZThQ83a1WbuTNMeaJqNQnoWyxsRxHy?=
 =?us-ascii?Q?g9JqXBAkCQOdsPrtyb3BG7Ay9jQuWs0MIWPqUDMynK2l5w9VTv3cyd24zoIR?=
 =?us-ascii?Q?6DEePVF4iw3+or14BsHNh/e4PHsZbiRbNpKU5A/tyw3phG4nLl6Xu4cAQQxw?=
 =?us-ascii?Q?GLgmG+WHQnju6Syfe6O8Tzfe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be18adb7-855f-461b-eff8-08d97d7947c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 03:30:09.6605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y1tvT+ISiHwyeSlZSMnDCvF2SVuBCQGvErenYZFsjCWIXDbZGrBwauvqDb6nje7bPqxtw/GndhvKvtG2aHgPwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5757
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 1:41 AM
>=20
> On Sun, Sep 19, 2021 at 02:38:38PM +0800, Liu Yi L wrote:
> > After a device is bound to the iommufd, userspace can use this interfac=
e
> > to query the underlying iommu capability and format info for this devic=
e.
> > Based on this information the user then creates I/O address space in a
> > compatible format with the to-be-attached devices.
> >
> > Device cookie which is registered at binding time is used to mark the
> > device which is being queried here.
> >
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> >  drivers/iommu/iommufd/iommufd.c | 68
> +++++++++++++++++++++++++++++++++
> >  include/uapi/linux/iommu.h      | 49 ++++++++++++++++++++++++
> >  2 files changed, 117 insertions(+)
> >
> > diff --git a/drivers/iommu/iommufd/iommufd.c
> b/drivers/iommu/iommufd/iommufd.c
> > index e16ca21e4534..641f199f2d41 100644
> > +++ b/drivers/iommu/iommufd/iommufd.c
> > @@ -117,6 +117,71 @@ static int iommufd_fops_release(struct inode
> *inode, struct file *filep)
> >  	return 0;
> >  }
> >
> > +static struct device *
> > +iommu_find_device_from_cookie(struct iommufd_ctx *ictx, u64
> dev_cookie)
> > +{
>=20
> We have an xarray ID for the device, why are we allowing userspace to
> use the dev_cookie as input?
>=20
> Userspace should always pass in the ID. The only place dev_cookie
> should appear is if the kernel generates an event back to
> userspace. Then the kernel should return both the ID and the
> dev_cookie in the event to allow userspace to correlate it.
>=20

A little background.

In earlier design proposal we discussed two options. One is to return
an kernel-allocated ID (label) to userspace. The other is to have user
register a cookie and use it in iommufd uAPI. At that time the two
options were discussed exclusively and the cookie one is preferred.

Now you instead recommended a mixed option. We can follow it for
sure if nobody objects.

Thanks
Kevin
