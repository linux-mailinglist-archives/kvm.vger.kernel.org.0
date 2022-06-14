Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245C754ADFE
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 12:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbiFNKLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 06:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiFNKLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 06:11:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED803F324;
        Tue, 14 Jun 2022 03:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655201511; x=1686737511;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NQ2wNKegv2WHK8BWOIRZx1Hij3ZXSEy8WnZj93rNXXY=;
  b=Fa7sR/Znz3FB0BXWDE9o9H/T+UvdrseN9fI1QSQfcuOm00p8NYvTCKX0
   YtRZE6smaZhpN35dFzi+T47wf0cwYYK0cGwMrhXTZsEDinxkIAT3QxHmM
   n+umLxDAn41ry2lmoUUom6NhTc0EW12RwPDBd/5odhhN/jcz3yxAMoyHw
   IoeHshg5DALlEZ2swY17VeYCtO9NASJTdunWHC8WR9WtS6wF8XVlT1p0I
   +H7Q+LYjvbOtPUC4ybp99C6RVwXlgsScbuk3vgautukv7Sn/zrkrMYLz5
   bwvRRkzlA5rSLelxDn7N49X+1o3IzOO/yENM8fvgySe+WAxA2I5ggN9ZW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="259025482"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="259025482"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 03:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="588370868"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 14 Jun 2022 03:11:48 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 03:11:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 14 Jun 2022 03:11:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 14 Jun 2022 03:11:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpnJ4LL/fgbCglupjTvIXuBG8NNg0ia3RLyL0HMc6SPXjFVVsBnw3F3uVI5Gxd7t88a41Xmr7u1RptoBTi47qx3Q9tyyJSY3MlxWrMyvwNL8jLet6KL1jnx+SyDCYUzHdUjIUsdV2juHm+iIoUlJL7zl0dA6qc4AGVzGTtt/9rLuHS7yQasjggWRWo1MkitXFIu2izJXJqYQ0bpI2ZHp8Xhg/VQM8y+tb/xVgaP2ME6SnSwSIh2wtznegoDWdZKbBfB/YZcPpFALIJ5w1aY3fsAu57785hi6wjvJpqmYbCBu4SZbRALYbWqCz1IvlBbXfEehkRB8/kIZsl3beqzsyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQ2wNKegv2WHK8BWOIRZx1Hij3ZXSEy8WnZj93rNXXY=;
 b=ZBWjZwB1qe930LvyGHutH809ROPrVF+hLRVoGYO3sEYSb7RFqmlyn4JlrwaU9VOrKnPvHghS1uNWNKR4Ma8FC3q5w3X1ezzUko/Af9puyhux3zmAAl7vicuYYqaA3LZi0I82NuUhG+iOr/wgZmhZuiwEMPosH2V34kvjO97cvk+JwjuoCHtaTzGEcduaS9PoqTWjAwzJu+wCt5GtTNh4DpoFYVFD0MhRkBkvj6rRzy2Wj+HP5yeJXoYytd/XzYb1FEjMYlo73FCLhWU0J8zzwa2gsm9HA5sZQINbQf5YH+EPCDOZN7l9HaNOqBoeQH3lJYma8t7wpt9Uz3NDWNZTjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4380.namprd11.prod.outlook.com (2603:10b6:5:14e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Tue, 14 Jun
 2022 10:11:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 10:11:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
Subject: RE: [PATCH 10/13] vfio/mdev: consolidate all the name sysfs into the
 core code
Thread-Topic: [PATCH 10/13] vfio/mdev: consolidate all the name sysfs into the
 core code
Thread-Index: AQHYf6r/BN+RGu2V3EC8Tww+nPQzwa1OruKg
Date:   Tue, 14 Jun 2022 10:11:45 +0000
Message-ID: <BN9PR11MB527675E56BA61F49427ACDB88CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-11-hch@lst.de>
In-Reply-To: <20220614045428.278494-11-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6eec785-ebcb-4e80-99f5-08da4dee494e
x-ms-traffictypediagnostic: DM6PR11MB4380:EE_
x-microsoft-antispam-prvs: <DM6PR11MB438017F488797F2A9952844F8CAA9@DM6PR11MB4380.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P/7jzoO4q4jJwpziSA30qIOZVYpppFSWn3k/bOwUShB0yWyJkRo5f/abe9xPxdjInbnFCVRiw0PpMD7uSg8Iw45zeEYk6Z90uNf7lMEobYPg2xejunN0cP9C/tZqFs4i8+B5hXLMYqeZfPP8ib7dvTVSl9QwZzhwNgSYL8XDT70CUXWB/D7REcohSge59Cg+t5gUUpsti+oT+Argrzc5ov2rOrE5UocLKxbiB66iV2R/8PGrkKMz2Wru17osv/3bIoH0l81cD/5P5WzzCCS5hC54irvuGAqv0OuJxePPC/bNFW3jYpsl19bv+Au1UtBHO/5b4c8m5RYv1LqETinaBJT+3QDeQ4ml3tVSZnIjxLkBruNT3Snp1mQJub0ggiQ0jqlsjUlTv5elXH3ISj8L7KW71JctBzj9HNlt6jT+Rfk0ZWBRWnDD1YGSUqe4rWFIouHC67B9KDg+dHwAoczAmGNctgDuDv9y6vrCmfrJEzpRz3OtowXkS41/N2GWsSBbKdXBI7WbE1y5ZB5U8ZVradCKgM6QE1Q4GauVXMjs62FXMFecqFZorpYFCxO4fCeBZiJdM9qGDC9x9eUODqO4oV0924Qh5gmQp1o1UDAHDgwqU474EbUhvv3m8o8KFnGzZ9j2MTvmw2Zcd0ttZhfrvjXn0sojgSxUQiPLZBFxAjqwDE4VoKDcV+FdpkBQzI/3Xd+qaKzd51e0w7DTmrX+hXlONKOiQ/wHDHp37TIQPOQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(38070700005)(921005)(122000001)(110136005)(82960400001)(64756008)(66476007)(38100700002)(54906003)(76116006)(66446008)(66946007)(66556008)(8676002)(55016003)(4326008)(316002)(71200400001)(7696005)(6506007)(52536014)(9686003)(26005)(86362001)(508600001)(2906002)(4744005)(7416002)(33656002)(186003)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pG9msJk4XyNIXY8cZYrnqkON2YxDzm7ySH1iNAcjaom9MI1gE47y7Ib7Bx80?=
 =?us-ascii?Q?GbYpmmUhIgstMjGJW1nao7IZ4ARYQWMzy37G/PRJF+8oCF2eUpX9wyyoZPiP?=
 =?us-ascii?Q?WEibLNHEyZt910/+52+XSUdE7sfc1eU20TVUvrcDWamnnrVaDYYDbC3eqMdY?=
 =?us-ascii?Q?0Jb2nnGF98a7krN47o23XqCdfaRRcG/Q00aIheOYI8YDofp0gxvC1u2VieGr?=
 =?us-ascii?Q?5fyKPD7k5IgSx8lDjlQ/sMf+vIH8Ujk550f5S+up87b/CWw9RdQkVftub4oW?=
 =?us-ascii?Q?gDZizwKPXDHIBtqEqFwNbCOV0ERxdNZcPG9vVeZrwmDKoqgQ6WHIzOzV2V63?=
 =?us-ascii?Q?6CnliNgm1z93+mygXajrODeMAh5fdm3Ud7Qh3HvQp2mals1NMyK444lD5BuP?=
 =?us-ascii?Q?rIYYZpOm1eDCKSrNvGu6DsU5fNDcXEsN0vUcrg8Mx04ZHFjI1fRfkuUG236E?=
 =?us-ascii?Q?UKSIY2ToRYecBI4z0xrMBu3dGhQ900eSdhxUztXiPrgH7gX5eaEHnqnXWxPt?=
 =?us-ascii?Q?wXGWoyDlJ6WtG1gH1HAlGpGr8TOMBEXPCHkXTafvO8ee83aAJIij93IqDXh7?=
 =?us-ascii?Q?wpmh7TRsczkfAYAPWpxY1wxpyrge3tmO3wv4KyDiFnfnLrrSw6C5UJXJDc6M?=
 =?us-ascii?Q?uQqbB/dwGz18A1bkx/2oWfYKBHvTvjUekxjX0GGiIVQROkfXdd+4aXC4Kfou?=
 =?us-ascii?Q?NzL+NzUypRRohSIW5ZRGbWAT7G06ZIMrJc9OpTG8UybG6B6ycJa20AFcaXcB?=
 =?us-ascii?Q?T4vcksFn62zMF8+0hDioLjO97feE8Eyl+HQP8CBuj/Gctvc1utVx8YNXM3Nt?=
 =?us-ascii?Q?X5LUnClLCEa7u+Au6NgkbpdnT/tDlC4jUswEhb/AhgZFbD9Bxrw+oDGInjnK?=
 =?us-ascii?Q?tYSaeUuaPF7wA2FYNFUMRX3F2bvQ5SOQBAgcJQkOhLm60pTxNMmhEGK7Z2JV?=
 =?us-ascii?Q?Us+m5QplqymI3JKKiabGr1xIsN2tb2hudcn4MW1On2/I6xi86ag9nENQFGkL?=
 =?us-ascii?Q?RsBAGC1BtkkbNegO4ESxn97SWV7CQdJ1hgYXQ31OpQbrknEPWgymrb7B8AIP?=
 =?us-ascii?Q?QMBr6nYRfnKrtOmI+DDZ+GS5yFe1e9/sEAm66N1IAT6TFk4HeYnxxAtFJoGM?=
 =?us-ascii?Q?hbdFzilWX4LQxGQyDLqJv5wcgvvdRZ7un0IL/iqTv7HL0GpXsdzxI/jlrs+C?=
 =?us-ascii?Q?0tPiSAq0W5dFhEYmpHmM00lXO3Gf0paZaWbqZvGTgpJmd3jfVXg45Dkfg3q8?=
 =?us-ascii?Q?L6AM+OZQs7cDjV65Po4nPMowrgrrv/NGfSdRx5fIwU6dZWqhNLJiZsJXgRrL?=
 =?us-ascii?Q?cDGGjxqwLd7Cg1rsCC8cyzggL9Szyl1FhOhb8/1OAJBQRKN2wtY7qhTcUXdT?=
 =?us-ascii?Q?89WlOHCWULvH46xfOlctqKKqP09Cf3/JKF5FL4/W0lUSsl2wZzMsSew7i/Vp?=
 =?us-ascii?Q?TxOPd/AN3F1mIs/ZaejNOTdJWMLm0SRA43FHEXal18rsmg42iTXw2PIHmtpx?=
 =?us-ascii?Q?GbnMxsffGZZSWJmxPm8ubglcK5tgSdQEDlOPB2uTBfDbiPo73RAMmu6oNGQy?=
 =?us-ascii?Q?8rtcAd+zvUCYS4t2AxX2AAsrdH6MsaOsCAzg14qIHYnwfdR4MW9RH9LeobOG?=
 =?us-ascii?Q?s3Gjm1Sc15nXmvWq/z5ANpWmSoZna6EOWszffOG5uZNLGBkkpajTJ6pd50sU?=
 =?us-ascii?Q?LN/fJg6Te2q0G7T18jMhqQQOruY94ssZGn04z34MJLsPnB7kUF4d01fQp6E4?=
 =?us-ascii?Q?gNgwL+G/nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6eec785-ebcb-4e80-99f5-08da4dee494e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 10:11:45.3633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bjb4oVu4A7DGU1S3IKdhyCZW83iYZc95JzPlnkZJaXvrzFo2Nz1TBstZI8HaGcywzzMd/nA/Rv9P5WKhmPkMrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4380
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Tuesday, June 14, 2022 12:54 PM
>=20
> Every driver just emits a static string, simply add a field to the
> mdev_type for the driver to fill out or fall back to the sysfs name and
> provide a standard sysfs show function.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
