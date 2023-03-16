Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316F06BC5BA
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 06:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjCPFis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 01:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCPFir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 01:38:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CF156523;
        Wed, 15 Mar 2023 22:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678945125; x=1710481125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Da/aCn/IyMHJWWMY6WmFqUQxi7cELhbqjF6eoi4loxI=;
  b=jiTl5hQQYV1UKv5vXdgUBj3vpSMiWtbYKLQHUonbfUyZTacFS+h9z3Qk
   eO0oeyRgUvH+h+IVlZqnYVSGrPCZXJJuLsddsxTk+zxgJDBHGgiPU7ufe
   jm6F4xGhJb5M+hMWDM13qyCxVIwtn4eIU8xtVL+BVu16KzTvVdTKryFNR
   3XikEL+j315+Vn7FkJxHObDVYkibC5bShrxIbvscGrZeTgpk+0Zx0XKms
   XAV4bGa6H+Eh7cm/HD+AuvoHGXyXweotrGao6xPscFhoqPqp72qSlprrP
   qsaH7H7ApUF3iqBISnFBXHcwsLH7FEosMLvg/MEqW7tensACQ8jSSB/1O
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="318294172"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="318294172"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 22:38:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="803580897"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="803580897"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 15 Mar 2023 22:38:44 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 22:38:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 22:38:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 22:38:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNhK2xNhZOLlZaNqpfjJh3mVKadMEggudVdhd5HiOV92+svdEmRX/kOxwLCkz5xWwX/VrZU0xGlzXkqmuEKlQYtNqoj7Hr+wKTyYk/Ajq1KTCH8sqsqsWOD2Uat7Y185Qb73Zi4+IDKpSSqPh2i0NiAn5KqBcz2me531AhvrLm6EMTKtYEZ1rOcVgXUqssdJmKhQlJYSZwllxRTP+Rva1eLFvgFfEavoWH9B7yYLysJs6ArgupiWjBs4PWupp9VLBOem/9G47DXt8bbHmRQN/n3T/5Tgho/3HXqU6Pe1+CIQhWkgvBCMwEfBh5+jJ+W+gyBSJV6yMQQ5Z7ALwd+Rvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiXrWUvkEV+mgwF3eEfm9Q6SM0951uJVJp2YAxvWDZI=;
 b=oGLt6b8PxF4twfOra7rQL4xDSWdwahKWvbqpoSXnTioxSZBWLV9RBHa/YsUlfw8MO2buHEBX03/Ay4LT8hbak9e1m9wufLTiadTD5v6QSqBbjV7beNdArvyLok3exNE8QSiuXyWNUnaTuws07sxBpijQGeUT2ksMaS73ZtR3V73naVoRVPk3JssThlIgrx9BqSJb+bBIOuS73W90f3SZZdtAolw7UQSPpMlHgALSAXbmbFkF9rfSRQykdxeLWHVEECiltP39CRtd5wGeL+Tymq2kYjiZQhZXUlc1KZ/068AuPh+8eKH1CxynFNxJny7A1+ceFoUib39RTEopsZN5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6806.namprd11.prod.outlook.com (2603:10b6:806:24d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 05:38:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 05:38:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq70SikAgAWuFwCAAReSgIAAVgYwgAAGiICAAAEI4IAAKQWAgAEmOLCAADF8gIAAAJiQ
Date:   Thu, 16 Mar 2023 05:38:41 +0000
Message-ID: <BN9PR11MB5276EDB7E88E9AE5F059C8948CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com> <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia> <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
 <BL1PR11MB52710B5DCB08214EF4542D098CBC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <ZBKp9BXwX3+txIEC@Asurada-Nvidia>
In-Reply-To: <ZBKp9BXwX3+txIEC@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6806:EE_
x-ms-office365-filtering-correlation-id: 05c14367-0bfb-4de8-1a0d-08db25e0b332
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /YOol2/SOlpN6JsVBC5yoIVJveFYhX4QUIGxgJZ5ykw0gE+h7wXyqur+25fRkJc1AvHAPLXwKu6LCVquzwxa1sa72G9lP5csUr18Xmh5x4xLo2HTm491snH7330Ky3O1kvVMrjsYUQ7vTSiy8EOm3HCT0K5AadFAqV9gObPD5pfOuy1WvY7qbVgEl7Dod7Z7zlHkjtN5RSfULBqrduE7cfdMMUAfChBD1RW2+lBL5sJV442WTvlIg3B+XwauILQ+skSgWfpe6cZ+SJnS136Chb9Yiu4xZWMFmsVxKKgdjOIvGegokAGepXev2dTF2Ra55S0kx/KP4n5ru/YGAKr++1ZklH/AdddzauP0o6NW69KXGa4Lx+AnECn3FrsmAlcYUAk/56Hmqx1VePAa02HFB05VIUsoHqV3ZOF2oogAestQwT/Mv8DZpbwvH93Sa773w8CuQj9zVoi8Hx523JeYdH3nxPnoeOA50bPMpOC3qd/O3AhWvM8qETxSbs/EF+vrXTzKW7BvWBvSf/3EXtryJSAT583GlgItVtSILapoSekvT7Kc8orG0FfuL0mYisQpp6UAQuJwHze1OOHLRl5/mvqFhpIZ2yADwOu5Fr+gINGkQYoCnFi7lLWG1mBxb6iawQpC57x9fKj8mttnc5IqB8cXkPryKQsWdyo8OfO36Ff8J82OT540OORXtEpJbFYo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199018)(38070700005)(86362001)(33656002)(38100700002)(82960400001)(122000001)(2906002)(52536014)(41300700001)(4744005)(5660300002)(7416002)(8936002)(55016003)(6506007)(26005)(9686003)(186003)(83380400001)(316002)(54906003)(4326008)(8676002)(6916009)(66946007)(64756008)(66446008)(66476007)(966005)(76116006)(478600001)(7696005)(71200400001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?laIrJi7ke936OfRB39KpU3jce2Je+w2O8Oos2poLS0wTM/De8rDCRRpLnGBY?=
 =?us-ascii?Q?Tl5yRLYUXZmIRZu+YCdE4pVB6yxINMsMMM3+NbcBMQpn7H+zsw2O/OEIY7kt?=
 =?us-ascii?Q?a5GrTIcSG6Us/FGpt0cPnyaNspfdzKdnFniyW8Bl8lGjond/rcFttC7/IBYq?=
 =?us-ascii?Q?XFOZuPM72iU4lQDQguEACEHN5mL4nW7gmnGs2gEj/fyXkxv1yGvwxFVe4I6Q?=
 =?us-ascii?Q?W1sw80X6WucoKbArNueviDFRrI4w3AelWEp8tJOPjgXM/AZQ3n6csJabD/JI?=
 =?us-ascii?Q?Gk+wJDZpfv9LEgNdfZlsdEvRUBd85FrACzKJjk1q1S7BTsIZun7WEIYnACUz?=
 =?us-ascii?Q?ojpDy1jmBlXC9qkIknkyFLQ6dkMWmh9s9+Kisto/HZZKCI1NnYDb86tz1ij8?=
 =?us-ascii?Q?l15LynwT5BLjE/dkk8nDitqRbyf/HMejm14JBzG/UGTe+iyE28Z8luW//5fU?=
 =?us-ascii?Q?O0UVbkth7zhI7cGGGN7oAhVQ6rwFpaMSkzTwlylS0i5AmtVJOED0was5eKhj?=
 =?us-ascii?Q?8+WwyuX+HDnZ5nwK7z+Z3Yj6y33j9n4XeN25eDuHGn/GjQmOJ7B69qZ7o858?=
 =?us-ascii?Q?d/yeDe8UmWeWyiMzKk0Lkv0taCTQ1FffmcLUZYOKo5eSoOI9l2W8Zo0fWBzl?=
 =?us-ascii?Q?YSUmM9IUHNfBMkA4Nd5rMHdlBT1W+YGOpZvSeMswRTpSgF1ccvTwzk7t/3nE?=
 =?us-ascii?Q?gNdZjEi4FueVGtUzRc4s5hFVk5pJ2tvyR22zD9Z3fx9Q4AUiw1dAy34fQgrJ?=
 =?us-ascii?Q?cOHnQ62RD1bBZ7PghZfhfay9YC9VuYkAs0YBTbmamjwgCrkUL/r9APDyHE5T?=
 =?us-ascii?Q?ABL/ZRb5/dishURH6SEBYT64PNW8YBr2ilW859oxagBHWPVpgZTRf4nL+FCR?=
 =?us-ascii?Q?/anYvR8Fo/9gfzFEWp0yTiaU9z6/WuQ8RJ382qrAGclne/Dxtg3VQiZm9tUb?=
 =?us-ascii?Q?SNnhBOUJA4H+akMt7ZfltY4NP6KzgezrnX2S9hv/p49+N7K7EJsWHsIaOtEr?=
 =?us-ascii?Q?O3bg9S7LUy4YgZ2QZiZ39kxmd3ly8WRXEzX3hH1MBUAS1iHoEUnTe+Gq2qNj?=
 =?us-ascii?Q?vG5SJiswb9fO5CALsYGnmI7XPKanhTKptrJ1LYAdoVvwNeyBAwJ9K2yI7W16?=
 =?us-ascii?Q?2JoTiBp9bw1jpOXXBsvpegBLLwyZ2NiX4Whcfbvf99nfr5o53PX7yYCLGN4J?=
 =?us-ascii?Q?BiE9s2Ol2AC9bwydabIfjPr/kV02tYc8r/rjfw2KFhFK3PeeIyb/Ub9Rc2C5?=
 =?us-ascii?Q?GFnk6tW6tBOphfXOjOeNvNO1kk9zbvMIAQbMWa6k6gdN1bO0Vd8KSn5d20Re?=
 =?us-ascii?Q?OGXysLTh29AygSi8ISmbjZbB8RPXEeZwZArOwDGuybariFr2KVxxVPltEQ1F?=
 =?us-ascii?Q?7kRqbtaKE3nqEB0WWRzd4LrJ6JN0zOe4+K8MW/j/adtMTZr90gYswftojHP0?=
 =?us-ascii?Q?v79lzKZYe1eaq5u3QQZrnuhbFEZhxtRl3o10QJEJWHzvvDT9CzgnGSaK0sBD?=
 =?us-ascii?Q?QfesiBYbJ7YcwqrNos6W8b0YISwqVWsMZA4mhZkO9F+1SuC+L0doJkvABkWl?=
 =?us-ascii?Q?HqFsxU+hZxsgsmVKgrgz5MfOXCxTkC3Vreve5Ilr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c14367-0bfb-4de8-1a0d-08db25e0b332
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 05:38:41.1896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hj+3rQJUO/ORhGWSw64ueJC4NSm6Z66cnb6uKvSzCc+II2bvBSf06LpxlbXs//hoZQOfefv/RxyFCQXKtI6LvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6806
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Thursday, March 16, 2023 1:33 PM
>=20
> Hi Kevin,
>=20
> I've fixed the other two commits. Here is the one that I am
> not sure about:
>=20
> On Thu, Mar 16, 2023 at 02:53:50AM +0000, Tian, Kevin wrote:
>=20
> > > [2] This adds iommufd_access_detach() in the cdev series:
> > >     "iommufd/device: Add iommufd_access_detach() API"
> > >
> > >
> https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a
> > > 097e2c9d9e26af4
> >
> > also add a check if old_ioas exists it must equal to the new_ioas in at=
tach.
>=20
> This is the commit adding detach(). And there's a check in it:
> 	if (WARN_ON(!access->ioas))
>=20
> Do you mean having an "if (access->ioas) return -EBUSY;" line
> in the commit adding attach()?

if (access->ioas && access->ioas !=3D new_ioas)
	return -EBUSY;

yes this is for attach.=20

>=20
> And, how should we check in the detach() if it equals to the
> new_ioas in attach? Isn't the WARN_ON(!access->ioas) enough?
>=20

this is not required.
