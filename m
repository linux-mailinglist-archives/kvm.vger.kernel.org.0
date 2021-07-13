Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AFA3C7A06
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 01:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhGMXXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 19:23:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:43643 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236702AbhGMXXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 19:23:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="210073891"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="210073891"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 16:20:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="650053766"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jul 2021 16:20:15 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 16:20:15 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 16:20:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 16:20:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 16:20:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAVnf+eqf7OuEgeRSNrCQFeVMOcWknz5Sw6pzqmc4mUoojEfUEqZP6GGjyrR7Swu0o5SGAETcCChZ6B1KfVDEQNzUyg0fotpxC1c6zzCq0Zrj+8rVRQajuMIuqmD/IH8aHGCyO9VbvT9RZdHjMt/7DmgJs/WpgcdT0z2eCfVjh+SiGPyL7Oza65nn6lPS7H4tCZdjVkhqenbI5X17J9AVmJEUpqTuiJzgcIrgeaMtgMyfkanSYgVBu8HICwBJc4JZDo9pgTyKn7x42v5HJHVW/rq4mxFXTk1WBN239mWXjvL3Wrswk8ctxc6wcmB2pN3GttREn6rTjTeTIiNI++mMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIyihp4mfYOkvhbZJhpbhECRMS8Zzr83s4sutUr4pD4=;
 b=UgwO1fIOWytLLU4a3wDQB9V9tWgVjcYYXat5aTDCuznri0iiPI/JDMG8mPjzaImG/682tTDaduZEsMI6L+02LnjcT7ldeGrk16wWD6wnfl1nCOsWlLSDtTF0QO9QteF/BPqUJQcK8/JJAuUSmrM0JgY1DMycyC84IwIlTTtVFrIUfDWr1SqGVlBPX3tD9Gel48LgNwWcLDA9w5olrrlIkGY23tmZ9MvIq961bqy9+FvrWsIMlK7seYx7/hSFErx0zX39ZqqwnYQYtvfch3g1R1JjNagCVdqi6lhRQXHBFq9dibfnm33jfG/3rr0qi38QZzpT+I+Luw4+GjGuZFyTKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIyihp4mfYOkvhbZJhpbhECRMS8Zzr83s4sutUr4pD4=;
 b=INOxTw4AotZ050gvnTYcAeWEskrOIoq8zQlVE9Jp/uYA+WtftdMut7zKj9ZYR8+4bWenaydv4HtGOJYuIPGANfbITYLAi51NvBtBaQ7TNIqqtIRqTU3T83tfMlGL8NvXlevWs9RBW6Vs9mkSAZxanJjrtJz6vzJby06lLLp+Wvc=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2596.namprd11.prod.outlook.com (2603:10b6:406:b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 23:20:12 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 23:20:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQAdcmAAAGvGIGAAJH+YAAAKpxYQABuHCIAAB18VgAAAO+iAAA0EGnAAAJwcAAAAZsfA
Date:   Tue, 13 Jul 2021 23:20:12 +0000
Message-ID: <BN9PR11MB54331F80DA135AF3EAD025998C149@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210709155052.2881f561.alex.williamson@redhat.com>
 <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210712124150.2bf421d1.alex.williamson@redhat.com>
 <BL1PR11MB54299D9554D71F53D74E1E378C159@BL1PR11MB5429.namprd11.prod.outlook.com>
 <20210713125503.GC136586@nvidia.com>
 <20210713102607.3a886fee.alex.williamson@redhat.com>
 <20210713163249.GE136586@nvidia.com>
 <BN9PR11MB5433438C17AE123B9C7F83A68C149@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210713230258.GH136586@nvidia.com>
In-Reply-To: <20210713230258.GH136586@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37fd1f9d-4bcc-4865-2afb-08d94654c3bf
x-ms-traffictypediagnostic: BN7PR11MB2596:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB25967CE831BA261D458EB6CF8C149@BN7PR11MB2596.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xeUO+QILAysqKOSLrzKuYyfZA3HBeAQn+kqAp4UTGrAsd3bf7gSOKTpsAVIxoNRbFcPdr1MAG+nvKdgkKX0/XqnzTtkq4Mk+sifn86enaKp0CwhS2Lh/SgNHwTvr5OVlaZeLzYXbbtqb4krTMzVf4Vq57/AJnOST62gjya3/VFoWmaOlibnTy2jSTRnAaC1naJB4Y8AG4g3DjYBDzUkjO+wgtPmXYswD59xcVM04PyTfir3P0QP68ezQdDmTs+7NA+x0EPPLL9PtyuNDyA6YhZqSVRTsU3anTJTjmJ5zwdiJLhzG+5L4JJZiONWXPZADyTz18UCYcjj914jKR6Loc1MhfSbp55FhW87vol6cKgzxKd647VX5jACU3CZP4Br83reHs6MeWj01JN2wUPD5wLHMZYOeIz+dE4VMIm7lgLOdfXS/7HEZQgoOHi6jSywL/h5BzK8yHNBpjp6v6h4S2DmZDywoAQgDlPYCN7zWiIBW+f+jDPiREKttgjJNUORZymgw/W9EnTYCLVe52OgvYjjv3PBnxYwavEpqA0d5UYqsMgCnHvLkwUh7cTz0uZQJYgQ1PpsiDl7vyAKw3kcIMf9cP1kZI8vK2YwxGS3p5OsYT4XJTmnHIlkcXS/3coohRLQZ41XrSTyfZrIuRA6dI0QVVnckTz8b6p/cJAW8QBJxPCO+/n52x5Aivjvj1tf6DIErP3vc9iK6SNaRiMBZgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(7416002)(8936002)(54906003)(33656002)(55016002)(52536014)(6916009)(26005)(9686003)(86362001)(478600001)(8676002)(4744005)(4326008)(2906002)(38100700002)(66946007)(83380400001)(316002)(5660300002)(66556008)(6506007)(71200400001)(122000001)(66446008)(66476007)(186003)(76116006)(64756008)(7696005)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i5tUywMCQp27z9s+dA0q8uTW1S98dVU9YWxzupYV26UcAwN+Oezad7572Nxz?=
 =?us-ascii?Q?6XcymVgw4OSrxrKwiRUjMZbGHL9G50Ck1RPdAwHcM7wDA/o0pORV1LcX5w/V?=
 =?us-ascii?Q?cm19PShQhe4lLQFi8BgyccKHzu8DvSpAMhjoGk9sPRsy98K+e7xS0jPvznko?=
 =?us-ascii?Q?ePc820HcsErOPOEZZ08SVG3b0yu1lk0G/Md1e/rPLr/60R52h3gjAHp2593U?=
 =?us-ascii?Q?FDUe+mPacabbM2i5ar5GsuyzEzG+YNkU2+l0XS3QEPiX2fngnlmyVPaYTR7V?=
 =?us-ascii?Q?k4q0Mvu+dpdYSBJ+SpSWKCM27GiecVugmMuLujrF9f2/gxK2Zx/5bCFrunri?=
 =?us-ascii?Q?EOmqAH9FJN8LZ1cjD2/iORpnOKcHmT5lcjsZe2T9MMlGpgImVsyBZz0AelGc?=
 =?us-ascii?Q?pg6HlyaB98PyQ15MrSEsTvM7D7fQaQ3FYgkYPdvQAnXLQ2wp8xvzFjyEyTpS?=
 =?us-ascii?Q?+YRjCnBaM+r3pQ6i1sFJGiNA3BkUJHq+qb8u3iPKbTDQUMNJtLytcIDkdnid?=
 =?us-ascii?Q?kod6vMLB6oggk97m/uaMrWafYE/l9lY95iHNwLYHkYkUaOgqtdyIOZYrgowC?=
 =?us-ascii?Q?DYBVHOlvnORNN5TfAnOdLRMrNlhKzMqIak15dgso44x09MBJRrAIgo6fJmY9?=
 =?us-ascii?Q?6GqyenE/l/hZISFxQtNVGCU5GOSt/Goq6HpoW468BgL7rqR5GQGShHoRKG7U?=
 =?us-ascii?Q?CaxCEaanmNncwofj7I5Sps7C0i2R338ZzDRt/PEQworGH7AtBEDqTf4eIx7X?=
 =?us-ascii?Q?PgvA2m65ZKlFIdT0jS/8PEitp5/paBtgFAxPrDxgKB4QBL0ThoQbTd+ryp0J?=
 =?us-ascii?Q?lWralnj5vrcuo/rLOpWU3XhZOqFsji5Spn5r2pSiV3B1aMfc9SflJx/V11ye?=
 =?us-ascii?Q?T5ArqQucRO548wraf9h91RSqgcjHi8+gGPnzukFsGhU3ucm/V/eH9y6XHl7E?=
 =?us-ascii?Q?OKAaLBaX//FPQ79uimJzOg7/cF1cVOvBrFLzhF9pYvdhCXb7RBWxZ3bKeNCo?=
 =?us-ascii?Q?zY1CVxKGIxEKaDTkYPBkgQfguk8Qqw5Rrz90HSsskrP574QC/setLjEcn0Sp?=
 =?us-ascii?Q?T8GSUWEEUIP6PURC9LcIkZ0ADLOWSBwbsrhBeD0qIw2RC/ARYvv6JgtiUGng?=
 =?us-ascii?Q?ztWKrsgiEKQ/4wRxHGpLAF61no5qL1PWRYgD9oP80jOAE+9mhqd8BRNr5gjl?=
 =?us-ascii?Q?mnvmBvIce8YV7gjnylNL1yDZ05gNoDiZxNO4/d7egggqIj5dOOu+zUJ+g9h6?=
 =?us-ascii?Q?ZSbCFkTpcppL8DpMqy3BhcajFEjQYFGyjYrjKw5sJbCEFySRt+4IJ1J5bWLe?=
 =?us-ascii?Q?QEtu2WcJKa14Z5wlzmDQ8GOE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37fd1f9d-4bcc-4865-2afb-08d94654c3bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2021 23:20:12.3863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ss6tqpmeN6wICRpXmxyKikQzdwRHzyIasX9OfPHIhdsPw72au/TuYGj051+urUZCu+GA6Y7uzzKA5amG9mGA4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2596
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, July 14, 2021 7:03 AM
>=20
> On Tue, Jul 13, 2021 at 10:48:38PM +0000, Tian, Kevin wrote:
>=20
> > We can still bind to the parent with cookie, but with
> > iommu_register_ sw_device() IOMMU fd knows that this binding doesn't
> > need to establish any security context via IOMMU API.
>=20
> AFAIK there is no reason to involve the parent PCI or other device in
> SW mode. The iommufd doesn't need to be aware of anything there.
>=20

Yes. but does it makes sense to have an unified model in IOMMU fd
which always have a [struct device, cookie] with flags to indicate whether=
=20
the binding/attaching should be specially handled for sw mdev? Or
are you suggesting that lacking of struct device is actually the indicator
for such trick?

Thanks
Kevin
