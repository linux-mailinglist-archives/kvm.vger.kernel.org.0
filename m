Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2005E413EC1
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhIVAzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:55:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:29683 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhIVAzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:55:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="220296427"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="220296427"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 17:54:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="557164829"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 21 Sep 2021 17:54:08 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 17:54:07 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 17:54:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 17:54:07 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 17:54:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1BNwHVXLSq0aH/R6epw0Gw1+yTUjVbek7ewml9yyOJeHdmitgMjfeDqBmU90/SQTbo72C7O2tj8J9o5bSGoWCEEDT/5SsgViY9/lB9i1Aw05xThmz/uUZSUVV6qJ8eMhP9fHfyGQ5hzhq4o3EIdy13knhfGcPig0DlmxmFKQ2Rgq+JJorZJP5+tzqMVaHN/CZPzSy3IjlV/lrB5RZ3w8hmcF2QD5XDapNv6AxoqnH46y1q2p0PCXdFSJjL1K78V8JmK8lhTsUa6r8MByHHJuGQ/bLixMLiIYeKgS1a2XyXGTreRtWQxzR5QTFoUUbyhMrXxGpSJZ/bOtwTgJmiCuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SsdZPIsJ5kC6MfCsouaIWLHYciH7gQlPQJ6UgNtVAEk=;
 b=BeHsgiBhLOTMTv4SLM1WkHDJaXGkMrPzhOhSLlVpY6G5QoHxM/bkn137sMaVvCnPZ+puaTmZH4pGGJojeA3f9iQVGs6Sng+6I/uiDEcyIRF1xeGXEXs1V3wVsbgrKg3JG93iF6ebQ9qrXcWyvpW1ajErsmoX6Hit1AxP5OZgUpn/2W6+1F5kcrB5iiIlvwhEoKH6tMuZ2f9RFLMzzhnQCyw6mKHyUiyKO1D0Rfm+bPP+gOR21BHSUpSjXcg5CMzDQ51lH0So4J4PbjlY7YCejMS9hBlyPgeWaPp7UerR/NHcMfAI28wt1P7l/dh1AI3+Z7XlUVsT7GTrBejoUZZkhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsdZPIsJ5kC6MfCsouaIWLHYciH7gQlPQJ6UgNtVAEk=;
 b=IWqysa7pknDdXtcTIXg8osE/txe78JiLdnvICDpLal7MBSf/PDEutfhKxccXHqhIKr+6kzAv6GIbQzWupgKUR6pXM9QbfSo2/6klY0Nq5tBbKHqENp6Vn7hD+1xJJIc0fQzHwJpm+xWqchU8CDmpuCv+6hmb/lql9wC9Jd5fXFE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5757.namprd11.prod.outlook.com (2603:10b6:408:165::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 00:54:02 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 00:54:02 +0000
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
Subject: RE: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Topic: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKuuqYQAgACO5rA=
Date:   Wed, 22 Sep 2021 00:54:02 +0000
Message-ID: <BN9PR11MB54330421CA825F5CAA44BAC98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
In-Reply-To: <20210921160108.GO327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c77587a7-0301-43b7-a73c-08d97d63788c
x-ms-traffictypediagnostic: BN0PR11MB5757:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB5757128CFC0612059849F3738CA29@BN0PR11MB5757.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ywtQnQzu8jDHCYjdOn3gURKP+uqgCn5SiDz2aiwIjilguY6wgAFm3WkYLWdnPlMCfWcz2ZbCV1p5bdyX92bVaT3xswV6aLe0ub2KEyOY+xW/bPlkYvcWwjEAIhnEK0jdTUaxhZ3UOawoZ5+mUyHwdr7VmdHq1PzreBIEfd+CLEv449xgIInpka1G71scahLA9ELAlD+BdzhRD+fZqj0bwJOBW/pERGutksVC7eUiLJXGQxhD154AMgvu4WoFwu+vq64lUKuXIIDVdc4DRWuegzH4dL/MMvUUyxAKVFx5ugBOmh3duRhOBos/l7CDEKjMipwSKCDAw27Fc539yYX+si2z0CWnUo54SUtoKkVKZ/Dc2xOQe1DWF72jKosW0vTjzDA89rBttRUO3Ml54ohuhxwP1OIT6HhlVl/R+MvUOpsRY/XCpJOxoaI2t3KPyi/pRQHyBU1RStcqfyG00Sp2BeDpf7kvlZHj5S+NhTIkDPqKSUF682Bk++5Sa7hUQACxIdwES4PxJLazPmJEqskGjE0IMsiU9iCjNUt74oX/gdVkAepzO28s/7UrkgzOv9Z0fNnOgzmxpaH3nY+6HKQ91v7LX85krO13Rn9KyY0EjJE8LWBODKIEUYisG6N1uZ4vBnW2BAk5shg936+R2THHINlWAfHOucD5yvmLjiZp4d1kAJWyPJw/QNjQ+w5Q+HgsWbzBFLvqss1Z9Eqkb6NRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(84040400005)(64756008)(7416002)(38100700002)(55016002)(9686003)(66446008)(86362001)(7696005)(52536014)(76116006)(66946007)(2906002)(26005)(110136005)(4326008)(8676002)(8936002)(6636002)(122000001)(508600001)(83380400001)(6506007)(316002)(5660300002)(66556008)(54906003)(71200400001)(33656002)(186003)(4744005)(66476007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U8EYrz6RO18KhfyV/t5WcgoszsSjeFY1zLmBPDQZYZQAzBj4RqoYh+89Kfdw?=
 =?us-ascii?Q?lH1Uv065QPyywkJkSMTXXoXrl2WHclmTI5UN7Wv/D4Tz4Dm6qr7HaUgmXsUK?=
 =?us-ascii?Q?pEdyjxkmOFd69xSYoMY6IGTYaUeu0CZtgYDhK0mp+IbjasYaY9GvitvE9HeS?=
 =?us-ascii?Q?KPAtY7+kuc4tMty9biWP1URjWlwtczLg60uCr5NSAz7e2AHrh2SvvniCe245?=
 =?us-ascii?Q?uEhev8yeVshIuTZoAQ5zeiPZW/jHUGBcyhmjP1LODFws5Lq4PtA32U1do11y?=
 =?us-ascii?Q?NErlPtgcBqMCouohBE2Tpaz5xOUtqoEotLxaEQezHODasusJyFIbRcL/bvCF?=
 =?us-ascii?Q?p0VDRSFzAkwLROFG3zc7kr5hfXbdoDsIVLGzwryvz3qH942TZvnszCxLbWzB?=
 =?us-ascii?Q?3o2DjxPgM7xYk5qVjRx8UEnzox7hJKR5me5pET5SeBLLrkXava+3KfrflNSR?=
 =?us-ascii?Q?7MxAtT/+pKuQlm/DfA548I+QKXzM8/y70xkSIxsxT9u4/OkPa3nhVKNfL58T?=
 =?us-ascii?Q?Fcg27XqDCoIwF+JcGMC4F0ADfJqxYAiHJBu+elGRSH5wCATjbrLetEkSQxBQ?=
 =?us-ascii?Q?sjRZARF7grB6B4v/uVnJzGk3DEm2J6R6BUfF8vAKibt2Os560kjvvvFpmNmx?=
 =?us-ascii?Q?XCgk7mDEBGabEkOvOkZL5w9aOusYCc9Nb3ZJx0HAwMgfWbQNL88lsuMMNsAr?=
 =?us-ascii?Q?ya9dtirgojuoVU/zwE8Z8JUyL2iPo25zuF8ofSDLBB51ldfT76Upy100YMwm?=
 =?us-ascii?Q?UrmbXquJHG7DgM7kZeiHmzKhtlti94yA3jtyyIjOQVtGZLVO8vbASjUYOues?=
 =?us-ascii?Q?vTOqGEB9dCCFgrGWS+MfIC2/wy2oTjYdC8GqEBUZ4UGHMSGqTDZQGmeOO50u?=
 =?us-ascii?Q?qLtRjQKMDxt/UWYtbXxPxtIBJuKbckV6J1cZ7iIUTFxvS1d8U8335y4Gitj3?=
 =?us-ascii?Q?nxaKDcTLLRoF1uz2CBeg6dy3If/ituk9YwrfmLVzNjPejRGaoVEWH4P79rkW?=
 =?us-ascii?Q?1FkNf55Qxeh7N1dk/ypx/y76vAosTVlBVoIjAks2wfRyhctK1p7vt5N9UAGR?=
 =?us-ascii?Q?8CYoA0ubx5voCboH01sE5CDC1ODsQnDI3r/sJwJCs9Lzcc751Xhm7UkvCcOc?=
 =?us-ascii?Q?Y6yngKKMEs1vIOizG3EhDDu/D/SfVVEwt+mSs5AhcaonUjfdd9ni+Kk00Xf6?=
 =?us-ascii?Q?OeshlU9L2wHrfZ08VMoyiG4hOf0DOsBRMEg8up1VZSO2oIgFU+NLDh253GGS?=
 =?us-ascii?Q?GNE5YwK/vdndIEXLDOcj6BEAwn/gHPtASPx4wjXsN1lVrd91IFhotyQVTMsY?=
 =?us-ascii?Q?t7s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77587a7-0301-43b7-a73c-08d97d63788c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 00:54:02.5681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFRwmihzxNtQ8+5eMn62ZiTUSzB1iOVB9FUspuYwR0R7DYmuWwG6aP2Q8+aPlVqltXLcf2kfmepxYdmWxS6xDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5757
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 12:01 AM
>=20
> >  One open about how to organize the device nodes under
> /dev/vfio/devices/.
> > This RFC adopts a simple policy by keeping a flat layout with mixed
> devname
> > from all kinds of devices. The prerequisite of this model is that devna=
mes
> > from different bus types are unique formats:
>=20
> This isn't reliable, the devname should just be vfio0, vfio1, etc
>=20
> The userspace can learn the correct major/minor by inspecting the
> sysfs.
>=20
> This whole concept should disappear into the prior patch that adds the
> struct device in the first place, and I think most of the code here
> can be deleted once the struct device is used properly.
>=20

Can you help elaborate above flow? This is one area where we need
more guidance.

When Qemu accepts an option "-device vfio-pci,host=3DDDDD:BB:DD.F",
how does Qemu identify which vifo0/1/... is associated with the specified=20
DDDD:BB:DD.F?=20

Thanks
Kevin
