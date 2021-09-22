Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5021414B4A
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhIVOCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:02:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:20496 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhIVOCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:02:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223630143"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="223630143"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 06:59:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="533778669"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 22 Sep 2021 06:59:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 06:59:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 06:59:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 06:59:42 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 06:59:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kk0OpH2rmJhv8qp5DoBFP8F3KVIY7F/ppdlUldf2q6yoRpMMy/VDf2ZVU2fWGtm7xOoPtB7UaR2iwDZHu2whjDDO7xpCXj4YXSrhvmlQosC8lYS3o+MLqEyMf8gr7JagUQF6QAUotadAbCK3SRkYdDaTiJjDsLD1o6K22xa5RhKMN0G9zQyB85xIM18mCGY5kbvW3SxAFHzWbMV8TVhayKFtMtZZTadwM7yPTDWvTUkp4YsMe7+/ORQE+m4GCeg235wW9O0syC+1w06MXB5K+Sq3yiJG8DLHG3NetlOgpPzZH51qdCc5h7AUuZ7jAPMpC7YBIQfy/pYGWTvDkFGDag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GXF0u96J6LKoCmoEHedY02qV24xmDDwSSrBrMB4omZo=;
 b=Og2RfCYa+hBKtFZWKP0kHH3SnAWXMJc6Y91h8F006/3S25x1yAS+E0WO0ehUNeo6cqxBjecRzCNo6/isrsh+29nxKac9B1O5Yy/zwexwW67ffaon0eXMm1WOER0BYZLxiMHLe6CWh2+DW2I8vyOkEL7IxCX5Oj2JjYEqlBMeW8H7aK9OulO74EShC7rfbjPFQT/s3JcYp6vr8bq+pZ2+VwHFPzM06CxDthbdZKBOI0xoyx2HVGYtVpOKEjMySQjL22adLkev1TLh+5tS3Tn+y4ZWX+0ju5k43HwOoPWYdAK3RqP1sToApdTGhyXzcmRWAwo2+QNhZybR4FCgvtySkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXF0u96J6LKoCmoEHedY02qV24xmDDwSSrBrMB4omZo=;
 b=dW3LQzUQMmkA92ynB0l4AqQi65VD9+dq4eA+a0qY+DUvH78NeL3K95Xat+x6Aw67YL8pJf7sa9sFNIV1vKsHir3iQ67Q4U6XfOwBTO8z0UtXCbf2iTM0JvospweyaY6YP2Ee3pBTlnN4iTG4DX1scOeC4texJgeHuzmu0n+uRxQ=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2290.namprd11.prod.outlook.com (2603:10b6:405:4e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Wed, 22 Sep
 2021 13:59:39 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 13:59:39 +0000
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
Subject: RE: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Thread-Topic: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Thread-Index: AQHXrSFnPBIvaGfS70e23Uj7Zne3L6uupBEAgACprmCAALYQAIAAFc2Q
Date:   Wed, 22 Sep 2021 13:59:39 +0000
Message-ID: <BN9PR11MB543342C7757E85E9C41733B48CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
 <20210921154138.GM327412@nvidia.com>
 <BN9PR11MB543344B31D1AC7C8BC054E268CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922124034.GJ327412@nvidia.com>
In-Reply-To: <20210922124034.GJ327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f7847dd-98bf-44c3-22b0-08d97dd13874
x-ms-traffictypediagnostic: BN6PR1101MB2290:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2290D0BEF27925AE4C7EBFB48CA29@BN6PR1101MB2290.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sce8X3RaHIxWBDZKFlomgirol8wE4Ci+q1OyvIOPVyoD+fqlA31inIjNnO7Pd20Eml8G7BsEKfQ8aUcmkgBAHafhgcSCgVKNBi6magQYKDqVsSVShayp9ezbosMONAAzrIiPYHbHo11VIywI1NYw0rFQh7F5O6Fg7eMVtNfr2u8Fg+cjc+qlWAVNB+tj0rJXqiTMkRlaalCg1jkOsTM6hDC6awYr5tMxsXhAY/434ydzjvBxfVG4pmMTvbkuvdSMsAXJKhIWd+bhmRGpNoIvA6sDmr4vfGeti+GyjbqWyU2W+mq/9KIOPo6zjCA1IAwuqS8WN2JLVk3PTdmDXH3QgY2YwUZDCJo5GmYzHCv7r16sSJ8tGDTErjMzecx4e73zYVUoh/XHBPBqxu9QnC35LFWNqWjMC2tRlympoQaX/it2o6BK2y4mg0LN5AJdpLBjqqP163CST5SpCPrKGtfdG8FvsUJt5XP37j5qx0I98MCCa91hp8Gq+8coz0m3UtX0AUqq/PkYCU7THPvVR2wE9+kQV9bQdYWtLx65Pq/AlKROi02Bsyv3FNDapsaO+akqBFswNLYjKRNgF0AtdRamAjGyYIwWDmLDra5yyGuFT8wu/ae+bJZRS5IXRgNJ4loWrltcwxrVGyhXwNJAUx79p5uiYtuWiQZhnN3oNFy9fNfm86xzwwqIwyeEK5XxLQv0JLfWIxhHesAwVDwelGaqFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(9686003)(2906002)(7416002)(86362001)(54906003)(8676002)(55016002)(33656002)(4744005)(8936002)(316002)(508600001)(66556008)(76116006)(66946007)(66476007)(186003)(26005)(66446008)(122000001)(64756008)(7696005)(5660300002)(6916009)(52536014)(38100700002)(71200400001)(38070700005)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hBdFWirJPe3vVyDQOx8UkKdl2iXJIjfo4zuFyIecNImsfQ1lg8Rr/IVmV7C2?=
 =?us-ascii?Q?JOsMralJiZpL14Pg5gtI/ZIJB3Q86ioY6tHzk4DBA25SY0NPJj+YL3XNl/cQ?=
 =?us-ascii?Q?Ar8BycxmNJ4PPY/PnHcdm9g9vYxr+FyvM7G+1Uv1yRUeQ+7+2bZslaLmhL7b?=
 =?us-ascii?Q?9fjHVZeMPsPYkG/nCyj9DakWw82rR+0hABuvF6vTekafCAlSrEMWmsUVhsdK?=
 =?us-ascii?Q?Mm/ey3EfMMUVb/NM7RKumONezMlyE5vgRaWDY8e1CJljsjXInErsGPlh90zv?=
 =?us-ascii?Q?aCDVag8Aqpn5xoX8SDNq2YCs/8d0jvWyqQBO3t9TWWLH3Y5+Ewc932h+hAia?=
 =?us-ascii?Q?BwUQ9ArtzSDsWZrArWtx1POzF6gKahAK4fb9HVVRyKn6/k7+S2vf3K7MwjZ9?=
 =?us-ascii?Q?fOnNipmLCkif/+/Qi+oo0gQ0TQhwC/SY+S8PfiSUOj5R3478q2L5Mxb7Qfh8?=
 =?us-ascii?Q?hZPH/rAodGP+ZP81mibtqVvUniZ3YLmAnxJk75gnGXZV95hTvt4abx4mtdgs?=
 =?us-ascii?Q?N4kJEb0V+0S90LAVLOxqnej85E/0MlDtqfTR5o/2M3GS139GjEa2ZQ9yo8eM?=
 =?us-ascii?Q?7r2ioqUB4jSETwvOyvJ/ysPgiJJ9Du8dUQqxC/jdJ6Yta4N6pibaOG1sCx80?=
 =?us-ascii?Q?l0trjDTKI+FSWQUZ18Y6Pq0Tm+rRJSh6LO1js90d0sKsUTJRHIdG+yC6wNX0?=
 =?us-ascii?Q?Ou+sK98+Tk31ve0ggBR7xpnSPd6wkM6wOHC9RU9oqrv5mTapTRe4+D4md0MF?=
 =?us-ascii?Q?6G+RNO/+JDBf2SYepWlnBAV6VDG7QECK9ZEdrdZDBkFWip+MgaeMGQKrwtlO?=
 =?us-ascii?Q?Nn2WZ7JnlGx9VXROkgpwq+knYCoMaSgmYQ7rUYxwdj8vX43AWblKju59Yuiu?=
 =?us-ascii?Q?3Dn+UOP5iAG5e102U5R9Z6Me66xBn7XDqKiRMBAag+nLbjdj9TpZAureDP79?=
 =?us-ascii?Q?XqHArL+mtbJ60iJGEBSt2ETFzLXt1cqhmjWUpwBlGGJw4x2bAV9pfMAosFeu?=
 =?us-ascii?Q?Qv3s3/gYmyKFMSMXFdbZcmn8dG9X/5h7XpisKAZr/cOSImaCtrs7ntxFRp46?=
 =?us-ascii?Q?wc4xD7uu89GJFwPn3zTam/31GoGu0E8Mb73LFUlJpYXrYIpRWKtLC/OhjluG?=
 =?us-ascii?Q?xUhQEoxyBk6naQtTwclN0B/ajKmHxXv90PRrK6/2jkh/8HVc8doJ6JOY2EJK?=
 =?us-ascii?Q?W3zcJwvbqR3j4bQx6eNszPprXy5q+jJ5WvM5eAqCEspku0CO3f3yzoo349T+?=
 =?us-ascii?Q?oA0wMR1+oeqYXJZFdlDwe4j6ENdsbf8Ht8+MNhTvxQEM9F7hnBjiyFEgJg1l?=
 =?us-ascii?Q?FnhgSXo+auI8MyM0sdBCyLDy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7847dd-98bf-44c3-22b0-08d97dd13874
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 13:59:39.6068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H2EpKXnqbHOfIBboadwgsPTd3ruCpfRkqixn9xTaStlU4NyZJ5vQjHUjiAuboKAJ0hXKKzLOnfeT13ZonCfFRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2290
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:41 PM
>=20
> On Wed, Sep 22, 2021 at 01:51:03AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, September 21, 2021 11:42 PM
> > >
> > >  - Delete the iommufd_ctx->lock. Use RCU to protect load, erase/alloc
> does
> > >    not need locking (order it properly too, it is in the wrong order)=
, and
> > >    don't check for duplicate devices or dev_cookie duplication, that
> > >    is user error and is harmless to the kernel.
> > >
> >
> > I'm confused here. yes it's user error, but we check so many user error=
s
> > and then return -EINVAL, -EBUSY, etc. Why is this one special?
>=20
> Because it is expensive to calculate and forces a complicated locking
> scheme into the kernel. Without this check you don't need the locking
> that spans so much code, and simple RCU becomes acceptable.
>=20

In case of duplication the kernel just uses the first entry which matches
the device when sending an event to userspace?
