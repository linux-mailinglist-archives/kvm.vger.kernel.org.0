Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7370E6F9079
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 10:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjEFIPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 04:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjEFIPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 04:15:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED40B9EF9;
        Sat,  6 May 2023 01:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683360907; x=1714896907;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JzBev04gqMxnbs1RGR8DEJuVBB4pGDshkd9nd6fSNHM=;
  b=DrA50U/ofe1NeZmtspighainTLZyQOgDA8pfOl6rC2XdHUofstfEy18V
   pNDslKQvw1g5zC0vojZQIryqZe/5H4qBohx6KoC92+CFqznQ+08Vo+1yf
   0CtGoq658i7xqcELFP55lsBcCQMPYNQ4o59o6XINrWSzmkmq0TunZBnAq
   4z2yygw8k7eWsJxtfT8ZMIlSvAe8H7FcSKiN8xCXZ+SHNYBooXBEUrn+7
   7oswP2SBjObCxAAeT1MLjd5g1bCW6lf1HeDVs3r1qqHpo/u2moipu6Kfg
   oJXeQXafkRi/n8NvNVma/YYX3LH97eWwHiAq/uPuwjqnuWcij4Ub4LRnG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="351513206"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="351513206"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 01:15:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="762754862"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="762754862"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 06 May 2023 01:15:03 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 01:15:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 6 May 2023 01:15:02 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 6 May 2023 01:15:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOpcSnckIT+8/H3+RAFuqu8UhKf/bNQMbiQX2Zf8rBImjIvFZ/WPoeLqKPxJWr7bwPMcBM/3R/wyB0KNPkOiox8OtqKhUI6VUfVPypFWHuCFoiwsQN9/3IS49Aqmyzmdon7asmqaR4ElyXswl9SpwrreDOO28O50x9L9q8mpwnOlROf/KtRL8xej2UlW8y313ejP5BaPwGd1kA3cjx5Ja/xXbf3FQRvoybW6n3pQZavg2vQa6YA/VRB9XU5vA8iFwGt/9LvFDB4IKClxHgI/QYOFSVmzRdhZ7Z2AxoVVUPvMLUcwZhe/hUf6CBJ88IewCunUli46bVUrtH1fGM6GiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tGHiWU43BcGVPfTi66EF+EkS/liZiF7N8Oh9Rip35w=;
 b=hhXFP7ScwXHCP0r5vhQk9voqS/MmcKThTr7ewSVSEGfVtripv93TG/hBB4Chw25x9ZPtt2m67OKOBAHTHuyAmfmlZdQkpFGN779W5ML62ao4Lvu5ppSn2WOXewcn4zCMgDAe/8oVfnf7NwpsW92uyFdAIayvDxQOLCJEVTs0aP08JoAgQnfAcLKZoycFTZkMTn0/39HUDL40RArB/biiryiyJ7+QHuhe5Vp7/p+ypPXLX3emvwQ515LXmlopTjq62Xb9IlODgrsUS+VPqHcjNX9BDqjZYjbWfh41mZRu90I1zbU47+QF5kfewLxPsd5XSu/MZq6KF3rAOHADRm29Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5562.namprd11.prod.outlook.com (2603:10b6:610:d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 08:15:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 08:15:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Thread-Topic: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Thread-Index: AQHZeS7NjeBSeWLT50GaZQKxGXZCA69ARxSQgADG4ICACkQGoIAAiAsAgAEZCCA=
Date:   Sat, 6 May 2023 08:15:00 +0000
Message-ID: <BN9PR11MB52761AAC6808D9B8AC9C186D8C739@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
        <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
        <BN9PR11MB5276B67702AACB0B5BF1EC0A8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <296ec21f-fc7d-eaf2-484c-27ae8815c5a8@intel.com>
        <BN9PR11MB5276ED7B47909222093E92438C729@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230505092808.5c36e1f6.alex.williamson@redhat.com>
In-Reply-To: <20230505092808.5c36e1f6.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5562:EE_
x-ms-office365-filtering-correlation-id: 407090c7-8278-4efb-b352-08db4e09fca9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R0aPNd0yFKj2jn9wN/HDMXgMhUH2xEVe850LwbOKA/XrcINsZ9ZPWhjjWe+ubY9X3JwrTya+Fva1Q1onkVG3C41Zxr7LF/0Xx+qSIdXe0j+bpLVqqunG6gvzrkAfbuJ/pH19p29Vm38NXMZHks6Ttx2xokj/6H/pRl5RSD8HROFLT5FwlhECmX99lyPiDt5cOebosRr/yUQ1AAAHT9c+wIRz5dro7iwlNF8UHxGEibhbBjkAECjRmzAwXCo702VFTlAK2ZOqedrT78Ysp8O0Vq077DKbluqf/aSRzEsoBA/Ew4gEc1rMIi3uqqjouci/lYDXXgu+HGXxkrhQIU+/g2OWqIuhlSvaXb7g3yW7VEURi7wpp55YHx3acscjD4cpjEDoB5RE+ymR8v+bhU54I3IZNAk2CsMVB7rwJnxd3pTJ1x1nohTH211jwi4W3TbjQ+e6vnXV9bcQj7gFwU5NEkhtFYsIC/jnvWYcqNK4aczQ3WlZhq14Sw4+KKVC3sNPlOujpqxQtxGGvCM93+0fJVcu3SmXOF9WNZlTiq3mhvXiaQJXqd0ZuI2ypOuxCsIhK3AV829Lt7tyQ1k1ed4IO/9sTwjld84IPhkyufizDeSv9QArzQgQSLMjPWekMUqx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(71200400001)(7696005)(83380400001)(55016003)(186003)(122000001)(38100700002)(86362001)(38070700005)(33656002)(82960400001)(6506007)(9686003)(53546011)(64756008)(66446008)(66476007)(66556008)(66946007)(6916009)(4326008)(2906002)(76116006)(54906003)(41300700001)(52536014)(5660300002)(316002)(8676002)(8936002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m8zy5NdL8IO+UNIHcqSH4CPFRasIP9ekZUT8OYsGxNULc0Zl4HO1OfYrNgud?=
 =?us-ascii?Q?Uq2JaDi9ToVNys8TnaUTs7fvNMW7M0ot7tIDblp37whfDb5lgTuBZm/KJFDT?=
 =?us-ascii?Q?owIh8Z74948iwpBF3S2dOZtQbAzvCGmIcsf80VbeiNU/xsIR/5bcKH7pbI+o?=
 =?us-ascii?Q?zPP7nPPUFYWvLbg6aUeI6EyOARz491M9+X/sGzL25P9u4dT8oGbYL8+Dtw0f?=
 =?us-ascii?Q?+4z7SnfaejJQ4sdneEq7rsDuM7JM+81sxDRJ16BsEl8HmlMyNaEzZVxhgG3R?=
 =?us-ascii?Q?X4MBgDCYnhdP0wMELlpaT3dlUc17Dia6AXwVDmPxHSyRkh+kOBLSBeYoEnQ6?=
 =?us-ascii?Q?t3ph4IzuJjXe5H0cqNrprJdYVEqp9JONa0KMgcbO577YJ9MQCt94m4N6MEMS?=
 =?us-ascii?Q?26galwqFG0B7z1fFTtzNlmMBqEbf9K5KiaOqB3ACoTNxfspgSksrwFiBrhxi?=
 =?us-ascii?Q?EfYrpSfE5PMwU4bR9RM+HHoI2I8HuRae6G8YXlSHBUpqUzfqZ84/BUDeMqZE?=
 =?us-ascii?Q?4DcxasPKLLHi0eS9Is49ulDFjAbn08dDpnzfVilNtuWiKx3CLRbDbYYH/acC?=
 =?us-ascii?Q?noMq1dS6rn/KPj1xLMEbCfNk+0KXNOYtMtejNJfdV8gpUGvo7Q54XSipJOqP?=
 =?us-ascii?Q?N0h5PpWEHT7UIShX2++3d+YcfC0hiua1NspUhVlvL1a5TnZsoP2sdoa2oQ5J?=
 =?us-ascii?Q?bGSOKes7bMqgacHeBkklaW2fyeWIEpmeb7B2Zo1z2u/eliq2K+j92OHxBvik?=
 =?us-ascii?Q?69efQTbFyyaXBKUnDgzV/OrHVRlifKDZqttwAnarneJR5v2cxv225QM3hr3k?=
 =?us-ascii?Q?tmosMwmFXUE/a75q/nawwKfrOy1E9siGXrCcUKv0RbIJ0TG84ZSkM5NqF/lk?=
 =?us-ascii?Q?MUtFJEtNvXPQdY4DaxGLrukrXSUE8v+pj0Xrl3/UnbmXOZwcEoJ6xIDQ7mGh?=
 =?us-ascii?Q?qr3GapVj4x1FQ61A5nmNyViwTD50cjvBV/he/xSByHu2cFimt2jzMOxzhhf3?=
 =?us-ascii?Q?HoKi+7Fli/ahGIYtgz6CCb5ckVjiFZbqJIjpga5ggtM8HC9bhGRltHPbBnsc?=
 =?us-ascii?Q?ZxpzfvvTIdvGrkOIg4jePGOIzjNsWzjtvznI8aW098iTK9oB6ZWvOIJoXx5P?=
 =?us-ascii?Q?3Ga8aPl/CXeh83JEURMxfh36eBUF0Xnyto493wtKd2hAvTVJniVc26qWKN8T?=
 =?us-ascii?Q?dSpuPum7/G++CxAjhp3dIKI8Q5znjIYHMr1MGLEAyyVQu2XlIPqFAR17L46Y?=
 =?us-ascii?Q?bb7MmZtp3KclrP4iTOvQA8zKdJxO9MipcG0Oy+AoUNTFdQs1NbAhcX1Nm/86?=
 =?us-ascii?Q?1Peu2xORA53+BSihWJ73zkqOxQx/YuFvbhlcWtWMmNtLHI3Pz2jwrXfC4T8O?=
 =?us-ascii?Q?37/Elkd2sYibCBUwUR67hWVJCgJ9xnTfam1hSCz8piY4VJGt90tNB6ZlQIzb?=
 =?us-ascii?Q?Lyds9gLmmX8kzOvefTwFM4I09zrARiYXmYrJ4Imo4SsMbLbjO1hRKqDAydCN?=
 =?us-ascii?Q?xN8MIsfWCOeHnG2LRhRaIn/Mx9lHLIaC/uj7WoLHVPczqMes5jJcwEaQjPJ3?=
 =?us-ascii?Q?6T03bfLsmbPCZiy86hA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407090c7-8278-4efb-b352-08db4e09fca9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2023 08:15:00.3509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4zEHMb5bgdEH42AFF7+dR0vC68+QaaekrENB1dFQZ3YQinfDHZDo0emn+hqhyA8LkfRU5HaGaT6TOFvKvaSxlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5562
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, May 5, 2023 11:28 PM
>=20
> On Fri, 5 May 2023 08:10:33 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Chatre, Reinette <reinette.chatre@intel.com>
> > > Sent: Saturday, April 29, 2023 2:35 AM
> > >
> > > Hi Kevin,
> > >
> > > On 4/27/2023 11:50 PM, Tian, Kevin wrote:
> > >
> > > > Should this behavior be something configurable?
> > >
> > > This is not clear to me and I look to you for guidance here. From pra=
ctical
> > > side it looks like configuration via module parameters is supported b=
ut
> > > whether it should be done is not clear to me.
> > >
> > > When considering this we need to think about what the user may expect
> > > when
> > > turning on/off the configuration. For example, MSI-X continues to
> allocate a
> > > range of interrupts during enabling. These have always been treated a=
s a
> > > "cache" (interrupts remain allocated, whether they have an associated
> > > trigger
> > > or not). If there is new configurable behavior, do you expect that th=
e
> > > driver needs to distinguish between the original "cache" that the use=
r is
> > > used to and the new dynamic allocations? That is, should a dynamic MS=
I-
> X
> > > capable device always free interrupts when user space removes an
> eventfd
> > > or should only interrupts that were allocated dynamically be freed
> > > dynamically?
> >
> > That looks tricky. Probably that is why Alex suggested doing this simpl=
e
> > scheme and it is on par with the old logic anyway. So I'll withdraw thi=
s
> > comment.
>=20
> Don't forget we're also releasing the irq reservations when the guest
> changes interrupt mode, ex. reboot, so the "caching" is really only
> within a session of the guest/userspace driver where it would be
> unusual to have an unused reservation for an extended period.  Thanks,
>=20

Yeah, that makes sense.
