Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C243D069E
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 04:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhGUBaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 21:30:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:60026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhGUBao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 21:30:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="208240753"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="208240753"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 19:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="657932185"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jul 2021 19:11:20 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 20 Jul 2021 19:11:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 20 Jul 2021 19:11:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 20 Jul 2021 19:11:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuNCZiN7ah3oM5fuilf9RBN3Ev0khVCcMxdbShRXJhvGFeS/RfTojFyLlUABpeVyLK9rrNX7aDZC7MDpDcegctxFiQBy5ouZm1z2AaGkfblGOOWdFUT8dveyw4lTMeOt4i4z9hRf4TdyHnYgSDHoSYOtPbHxBqD1nTpvwF02xJauKy4e98tqdwOHYsXuFP0VzXPi/9RDKE6S5ZEvKg+dKdVd9+MgwXjFrOkUlgdZqP6c/9aB24l97Br70eedJsDsdrEfQb0ProhxfPDFOLK1loZeN30dEJFBHMAE7cYwxXxVP2RvblK5wcdkHWJfrDBVHZOeRv6iyUiW93ILcdQk+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ht6WRalK3sLbTqpKI/DYw8H4ws/7M85oBM/FraDwwHs=;
 b=dXPTksYYrAt83eYCBc+R1V35H/qBRLOaeqpa5T1aRvbewSIUFP+67QJBy7NX0XlmKK9xUUdFfA7FcAWnzyq2tsRoiKMzMUeWziUf8z/mH/Yziv9LxYWwTYtKuwPBDWHmDiiGZGPEqunaE1E8srd9xecOGwcrnSrxIkkNFhoHdUCZtSjmFd1XmGqdtNEv/IP6S2YQI1s7WJqc77OcX3VeC0VMfSsxQZPI2J7MrJfYOZQT/CJzqRSt/jPcvstn6evEYUqWLT2IBk+6Z6CHWQ/xHHTv2WI4C3yW9PjKmB/evIOjT514Pqt7xBz2IPUJWVyTYpkT/jZVQHF0hWHlO7Emzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ht6WRalK3sLbTqpKI/DYw8H4ws/7M85oBM/FraDwwHs=;
 b=hUHPL30IZgbKfHLJstgyjqnC5RjXZ9kXuWKYBJ0a973DoZkCma5gplRR/kCQE1ltEvUboX9qdC60b3Y1bdGrKlq6KVsHmdab5N631doJU6Jv+ckDU1+jj0J8GsZQx4b4SxtI5F5E96uXs79VSX/5EU18tgKL3nzEDvHFP+omL20=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5758.namprd11.prod.outlook.com (2603:10b6:408:166::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 02:11:12 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%9]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 02:11:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Shenming Lu <lushenming@huawei.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQEkayMAAADgu8AABbP/AAAAaVlQAAzVHYAAAm93gAAC/CGAAAII8oAAAftjAAABDbYAAAAstAAAAGyhgAAARNiAAAwRJHAAJs+EAADX6NpQ
Date:   Wed, 21 Jul 2021 02:11:12 +0000
Message-ID: <BN9PR11MB5433D6313D75EA10919ABE818CE39@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210715124813.GC543781@nvidia.com>
 <20210715135757.GC590891@otc-nc-03> <20210715152325.GF543781@nvidia.com>
 <20210715162141.GA593686@otc-nc-03> <20210715171826.GG543781@nvidia.com>
 <20210715174836.GB593686@otc-nc-03> <20210715175336.GH543781@nvidia.com>
 <20210715180545.GD593686@otc-nc-03> <20210715181327.GI543781@nvidia.com>
 <BN9PR11MB543337BAEA86708470AC1E0C8C119@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210716183014.GN543781@nvidia.com>
In-Reply-To: <20210716183014.GN543781@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 450aeac6-cd2b-48c5-67de-08d94becd03f
x-ms-traffictypediagnostic: BN0PR11MB5758:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB5758BDA8FB008D96850A01378CE39@BN0PR11MB5758.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N+PJGqlQL/QKHNpIvIbKZN6TMp360jN/nKDRfw7Mam6jfT0ys376KlDr1u/D/0C8O+dqP8JAVL6eki5mhtxsgKik+H73tiRwn74Bt/Cy4UsVxsI10qYt48///Uql8efdLsR4Txl0DtIzGwxskYUyqRif4Y8lAoybyjriPrmDhcmGbBITQ4VqNQ/9tlyITaOKfh3+8Z+LhMbuZo/Gq99+fKPkUlROeZ+GAodJ+yfQzgsapJzJbT3DBkL8PZiWkWS3cIAebx9txiza3kaGD1EuYojZVXe0J2yr76Y+kxjiiWaUfUq0gOs8sM+fsEHfWT3momPy0GGaE7qXVeF3R0ZXEm7trDNMZipZXYQTdgUlpk2YafaZjGjWbh8C57db84X3S2VizXUbyezpaTKIWP9Ym+zmQrGlfUKghKFV51Lf0Kqow7ClmSwccvt2Yoom/nCRuUEXwlnUTFG3FHkzOHGF6JX0WqfDv7oRPbvKnvz6TgpAmRhkWRUei4YiUDF7BrNipg7j9/hdbXXk0+6jgjSWD8UmMZH69smAAzWCiRSbOMwzYERm4ZT5yx566LubLzBjThRNzfWf5bZQZu1ZbCaCR1h9ZnDyyiholNE96yQrhDynWM8qntBLua+S5RRGj8tXOYPR3RfS/uxaw48/3hsEuInjBUmcgZZ69O5tqNDRkuJbriEpefFul1erPyr8Y4xkJsMfQRWUE+2o5QCmc4/pMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(86362001)(186003)(8936002)(76116006)(6506007)(7696005)(33656002)(26005)(7416002)(52536014)(122000001)(5660300002)(83380400001)(55016002)(66446008)(6916009)(316002)(38100700002)(8676002)(66476007)(9686003)(54906003)(66946007)(71200400001)(478600001)(64756008)(2906002)(66556008)(4326008)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y7UW06f1UD9uyQKRiKcBy+uW71TItoagjQON8wpsfOUR0RbKmXg+IMVfzgQ6?=
 =?us-ascii?Q?MskVmyYlb1R7Cq5EIiUKQy5RDx1NPi6J55NFNomEbauO534iaWNZP4jXdf4e?=
 =?us-ascii?Q?+cWwYTcMlOfd9GbKj+MPVqFeSCxQvR6YU52hzdLQZlgi4FrlCJN6iP2PRtF7?=
 =?us-ascii?Q?CsWbkkHyJYQy0ZLOdezBO1AhCq2GJOM0qWwB8Vv2O/2d27cbtDa09eNj95rH?=
 =?us-ascii?Q?wdYEWTF4vLW4fP+x51J5OSuBhRHfwhBbuvio7Am6S3p29XKY8mHb5JpE72zH?=
 =?us-ascii?Q?XWGsMlVDyUzprvq+DlHJBLgSZ/qJxoJ27xjDU+Pzlo/y3ARrg+EccqsfeXsq?=
 =?us-ascii?Q?3kNztBAgd7nreZydR2sx/CX4248LwpjLTGWztQyFDMPAMzcgSvcgFZlGRwK7?=
 =?us-ascii?Q?vfFhiTcD8IVm2IQYoC8arCe8cicPFYFnqKqlY0KJuDRMXYbClu2d7sUkPGrM?=
 =?us-ascii?Q?n9tCMH6rWb6xj5DizHg4/52jmQNHZ4CW+O1mkDG/lJpMlBPdRZW1ufAfcr8r?=
 =?us-ascii?Q?kdfh37/srSSXioK4bJJy5Xw+ES5mtrcI7BVbgTuALcW6je2KvMoxq1tjK/fJ?=
 =?us-ascii?Q?Fvvgputd8fHYLvuYm34tfIHLhqJeI243W7sU2ZCgNsvxZq+W+klo4iOInA6I?=
 =?us-ascii?Q?ae8as+MhHpezVRmzH3Fx6NJ1qI6IQsLaTidSW00/aBREPRQ5J0B83S5qlHW4?=
 =?us-ascii?Q?PTRNVBpbiXvpDJ4JJjl1ZjGYqDg16OKqdupieah9/QrFhwX69e0HrpfcnQaj?=
 =?us-ascii?Q?NM5cCxJprV2qfRWyxao4YtBdIb59eZOVEgXVIoLL37sjkLtfxNAcb29Gs1So?=
 =?us-ascii?Q?ZUuhiKPAByRP2IRYUH8z7qRYZ17PlBQuMSrFkD6id+Gza231CEnPyp41mWdr?=
 =?us-ascii?Q?VAj2BqTflV9I8r/CJKo5c5r6WzMwn5OcU3TQ2c4X0yd8DhKVypEisha8Sp1K?=
 =?us-ascii?Q?PdwZ3+qbhkwYWzLZYdjK+nQXPbBBt+BOqPiicYGJzgzDzWXqZ5JsvPpJu5fq?=
 =?us-ascii?Q?9qkOWf+SKGdYTCQpkpHaWTm3sPr5Giy5KqLAlU/KslMv6F11KRkiby6DUVI6?=
 =?us-ascii?Q?kmK2sWUBQ7RgZ05dsYP80rZbtoNJX4KL+m7DV1vhfhy8qO2a0x9VDWtPywFI?=
 =?us-ascii?Q?o+3JNlCvib5aQy+MrRVLYjR+oH4sNtbdD08rtEGbzm/t7PsCBy/6mhZWZmB9?=
 =?us-ascii?Q?QYsCpyGuRoBfpN2BDWhF8v6R5+7jydrzRJ0s2qNwghR0MHG80Dmgsg5cLcr+?=
 =?us-ascii?Q?yG7fxJEBFr+5qKkzE09ULX+trymlXedO5c1AW+KzwoOnftbO+LnJTRrAu4Bo?=
 =?us-ascii?Q?cSNPJKa2yFXm8Afoz5DOXR9c?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 450aeac6-cd2b-48c5-67de-08d94becd03f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2021 02:11:12.5537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wUIWWoWo3hhNmolLYuUk/W/l/Son5pNorEVtGmIyYh+8Ma0yWz3Gl8IKLu9nf30p8a9vZ3WUzMaRY2QXI58JoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5758
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, July 17, 2021 2:30 AM
>=20
> On Fri, Jul 16, 2021 at 01:20:15AM +0000, Tian, Kevin wrote:
>=20
> > One thought is to have vfio device driver deal with it. In this proposa=
l
> > it is the vfio device driver to define the PASID virtualization policy =
and
> > report it to userspace via VFIO_DEVICE_GET_INFO. The driver understands
> > the restriction thus could just hide the vPASID capability when the use=
r
> > calls GET_INFO on the 2nd mdev in above scenario. In this way the
> > user even doesn't need to know such restriction at all and both mdevs
> > can be assigned to a single VM w/o any problem.
>=20
> I think it makes more sense to expose some kind of "pasid group" to
> qemu that identifies that each PASID must be unique across the
> group. For vIOMMUs that are doing funky things with the RID This means
> a single PASID group must not be exposed as two RIDs to the guest.
>=20

It's an interesting idea. Some aspects are still unclear to me now=20
e.g. how to describe such restriction in a way that it's applied only
to a single user owning the group (not the case when assigned to
different users), whether it can be generalized cross subsystems
(vPASID being a vfio-managed resource), etc. Let's refine it when=20
working on the actual implementation.=20

> If the kernel blocks it then it can never be fixed by updating the
> vIOMMU design.
>=20

But the mdev driver can choose to do so. Should we prevent it?

btw just be curious whether you have got a chance to have a full=20
review on v2. I wonder when might be a good time to discuss=20
the execution plan following this proposal, if no major open remains...

Thanks
Kevin
