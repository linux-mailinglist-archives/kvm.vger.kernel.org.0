Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4160661E8B
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 07:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjAIGDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 01:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjAIGDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 01:03:31 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30654FD4
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 22:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673244211; x=1704780211;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/wCKO4wFdboUSZS2LP4Cerzvhg9/spg0G/qA6zVfNk0=;
  b=K0XjIszETwNc5y7c7KsHh2nfCGw3WDEdhK7STZaRlrSCK0HvIqVUUKFs
   eciVREoSHYKHQCq4n9lcCU6zxokZ8p3IPxP7+PLl9binhouCaAj5wmM6V
   dZtS8hDbCh4ZzEw3kNY7h+4xVoXQDtUXwPt7mcbk2W1YJyM3g+p9qASn4
   XWw9zopAJA8et1Uqz7s207tqK6wdMs+DIqQrUB8jPr50ySiCp3nnFY/op
   +W4ySn9XtKbVPksIjla6GUN8E4HLRW6fz0a0TD9q4jgdO7/0XN9HVc0GX
   Snqb2MgQXLFa437VMIXBrWSTbc/mHASdfQiVMtXZELdUwVVx6d+hMFwCs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="302498545"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="302498545"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 22:03:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="901892879"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="901892879"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jan 2023 22:03:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 22:03:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 22:03:19 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 22:03:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8B6D5JyP1Lh/wkxhVZZVcp5lMH/c/IAE8jqLaxE6WkIuFJrwr80akTiRdhafOzsMYcXrKQQmXheB3Enj8t+/nyQwORp9B5UGAJyqZ5iVC66UwyAh1H9AjBJQKgs4dtEz3lksapYxkS0Vv81ZX5kVsYSVpwr1L2l/9WfsNdR8zD858FNlzoWXIOTExjCL1AJiC1rKYxuBfz0/CAZQO5NOVyVWeHlyQJcQBEOGq4fcQ5lieNjOLaFzzoU0HcpITpwnUnBofDDcVzsyp8CrCbLHvLanUcua9lETUPIOhGqjqJFun4KtANl43OG3BAaLZOI2WtmCaM0fMFjMNrp+zFwBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wCKO4wFdboUSZS2LP4Cerzvhg9/spg0G/qA6zVfNk0=;
 b=Jqeu7oGCMHl/fG6MM1xVPzz1vDudouU/ugU8AFAbpdGPFRqzIfcfXSdXlJI4MUFLQsx2yIK2vQGcjG92D4KTN6m+6OpTxpcxo4uLr5RdeHbKaLCbVxq5RljdBKFfDHi2NInn7Q32DsuS4upXqv+bqOVIs0PkelHyPV06FqnflnqAY3J7+kR0LqVulmEolbeAM+HiMRLqm4hGpmjQrWiaWOk83ILHETIZw0lzr6G7ZYSddP+kEidFri3eaiDpQjlFK1yKsA44oyCmpo/h9hsf4ixbxuaaR69d/5CeC5CY45bCYUkRfQS9BRqYTm+2ybSQiDlPE9RiaWbYscKxKjKFHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6774.namprd11.prod.outlook.com (2603:10b6:806:265::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 06:03:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 06:03:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 09/12] vfio: Make vfio_device_open() exclusive between group
 path and device cdev path
Thread-Topic: [RFC 09/12] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZE4aVYgjarRHr4EWdz3J8XBccc66VtG9w
Date:   Mon, 9 Jan 2023 06:03:15 +0000
Message-ID: <BN9PR11MB5276A6CE0A1B2B538646A09A8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-10-yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6774:EE_
x-ms-office365-filtering-correlation-id: 95a249a6-2a1c-472d-7011-08daf20732d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wSQ2LPqaHPX8kaSn3jcSbE3PAPr/kIp3D6r/BrpH5UiOhJcHQW1k/9nlNZTNO5dhc7IMT1+QBe/YmdGvgJVRMjEmvCeNhcMxAP3PK+6P/IzQTm60GbFCMfNCuT4usOjxJ+V917BxSYbxjay12JQ6wOJEiDOM+B5DYT21M93EcUiA1IQpT7brsBDHrCPspsye+zkXdaUKa6jOd3lkEfhl9uYx1ZBm8ZF6N5KQ1X5EqBjOLAm0UdQQ+upjen3aoI+p8vvANOzljMjgv3XbnH7eaNtnLP0IlROM10lblpnO2sFUwHDMtjM+corXfjlGT2RSpRfoT8bHo/c7R8Lbr8/r9Zu6txi0qUS8Ab6PVASzJ5p6BYKoiaSM8bD6RjmqXy3EiW8JXLvIULKOfyWNhbhRwN/AqOczgqZMvBwhss3QoA5gge/SSHMm5jEMWZVibsIMXexJ4Lhh4lsuVwawTsLbHkID0VRca/6UsWxSizZKSfCqKE6T0lfot/8dT4NZhbV5lS+VPOF9NjQvIkWJkHeKc3Xzp8fpLkh0rAbt6Ubh0NtCLjsw678ZmtFARU7v/ajwb9SzQBQiSoy1sniBkwomSo0QsnE5OxNgo8sn+CqwBZRVOd2sLoU/TZVj0Y9mindQv9pQ5+H2qPhoySeeXanZXf2RMOAQJas9tQCCkK33TSatyNCSBfAZpv8G/Tem42Ujud37qsDZ2U9bRgRxqDmUUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199015)(54906003)(9686003)(316002)(7696005)(110136005)(26005)(71200400001)(8676002)(186003)(4326008)(66556008)(66946007)(76116006)(64756008)(66476007)(66446008)(6506007)(478600001)(38100700002)(41300700001)(83380400001)(7416002)(52536014)(33656002)(5660300002)(122000001)(2906002)(8936002)(86362001)(82960400001)(38070700005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wEfEXMMZV9YOzNg5Tum40v6SIkYZaNSdpME6Dvslh6oqcayeGcsHS2BMHv8W?=
 =?us-ascii?Q?ntbpbR5h0udnFumZguF4Q27E3RzN7nsJDZRUteSiQNhwdW+JPp87KFGUdcPn?=
 =?us-ascii?Q?KIT2QY13oR3I7RrBvi4MMeFKo5qIsuuzZu2ugoi7dFEb+daH6+JkLNoMvPd2?=
 =?us-ascii?Q?7l2a5d5l6IpFGNQVdnVE1Sx1D4O1tt/e8SGF+AFuHYF6KEAbMaApVEMyuEUx?=
 =?us-ascii?Q?tH2vlnYRywzEk1BX5clKj1+X8xhpc6hn6rymGWgxCMgBWgdNpNS/LcB65kf9?=
 =?us-ascii?Q?PLxJGgEVXtsTFy9qG/1j3kcWGj8J/9oqSR0vrA8w2QUPo0opARSmB2WQttGY?=
 =?us-ascii?Q?OA2sZ5n9Fv2lHIpppQaHpk5Nn5YBa0/mJkEH2uA1Av4SWx4CaXnXTmuRYtWr?=
 =?us-ascii?Q?vUX5/MZoVGgQWVtxazE6KmaxJHUwby/1d3wuRaGZxkC8pmqnlZTw5cgAa4f4?=
 =?us-ascii?Q?XomI4/6zjh/bLaWE1LH1K83W8UKxQBDbZoahwNaBLBzGz8XuSYRsQqdY7ols?=
 =?us-ascii?Q?imk4rxS1QbnXxxkdtsb6XKqgChPGPJfxvC+X4nQBPknd5pprezKXo7hQWnsZ?=
 =?us-ascii?Q?hbd567ncMRK2bNR9aDRVnpbWIEzsJNldMo5rTlUT119k2XJpSAD5u+WnttKm?=
 =?us-ascii?Q?YEiQTvDrlXWawN5GOk9R/vohwITXeP9ocshhAzWeZ3mcy9B054xNUIjyP4Ed?=
 =?us-ascii?Q?CsaSuA6/+F8vBqBlUXoFF6PIJhA1G4uqSHbf67G1zaLv7M0pADMIkUDtVSsQ?=
 =?us-ascii?Q?2lLuddcCRZgyKiG2BPeeyzvYongFg9jMleRifhbNy2QUnFyOeF8m6Fb6DfGQ?=
 =?us-ascii?Q?VMUPFCbdo0lm1V1GFB9hkVWnGdU/uAPl2VLl/UMydeo/V+2XRjd16AsQU855?=
 =?us-ascii?Q?OnzxO+P9mP/xR3MUCWlrDZN53P5Ez5Qzn8NBhCGH4KUFq6sA6Fuid2OTYEj7?=
 =?us-ascii?Q?P+GIqJ74dsdtwgcLlP9+6/prvQ9UvFUam64z6Yfke9JjTL9Ido5OUvfMlLfv?=
 =?us-ascii?Q?x/MUphpfl49INujMLoGCQk70SCNgFKe7wtN0eUsOwrstpaHklyqmuY9wglIw?=
 =?us-ascii?Q?DwwTQhIBeEdL8Zvcbyw0tBxD2LUBRCmTTNYnEguMzKMmK8i7nFNvC6jhSqSZ?=
 =?us-ascii?Q?r8w3Xe0JOb1DyiPu36H3gJ/WcWySYkBAC3opkH1iocy+5EiJF40kA1+/stMv?=
 =?us-ascii?Q?ERYZw0SnAHpZyWAom+B3WcCLd9ff7rgjm/XjWpbHfMyP3MOQ9DDxVYyBCo4u?=
 =?us-ascii?Q?U8Xm7uSXPZMtmie9XW+ujSsqGy616F1eDOmC4rgxC5TxlR0hnuiOGNCQr7CP?=
 =?us-ascii?Q?255dlehW5WAbJ9IRHBXoB8f6uShnEC60e+uwPheVu6qDyzCC0dJ3CCCmvaiR?=
 =?us-ascii?Q?BVuD03es4CkmAF3HEz0OnQ6lQ52jyMNH42JbzF3jOk8aALyLiErCziSY6H0K?=
 =?us-ascii?Q?f2a1R16231eW+y7feAWTF3pgzo4VoDWI0ynZtFGMNPAlYWvOOlxIPoWdtepY?=
 =?us-ascii?Q?MmKDdgi8n1/TRetHE+4ZlBNOHyM/1NIHSF5isfJRCzdQgs/Z5Om1GiM+M2RL?=
 =?us-ascii?Q?AmkYWz8u0pC3BpAGOdquvRI1XyD1Ke6oqBqjv41G?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a249a6-2a1c-472d-7011-08daf20732d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 06:03:15.7615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18l1hg0ysxNpjE6ReR7humOV4ZslOf2R5LHZkNiya6N9SxiU6AmXHtB3VgMq6Y8bEFS8YdwW5eC/P3Xu5wL1Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6774
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, December 19, 2022 4:47 PM
>=20
> VFIO group has historically allowed multi-open of the device FD. This
> was made secure because the "open" was executed via an ioctl to the
> group FD which is itself only single open.
>=20
> No know use of multiple device FDs is known. It is kind of a strange
> thing to do because new device FDs can naturally be created via dup().
>=20
> When we implement the new device uAPI there is no natural way to allow
> the device itself from being multi-opened in a secure manner. Without
> the group FD we cannot prove the security context of the opener.
>=20
> Thus, when moving to the new uAPI we block the ability to multi-open
> the device. This also makes the cdev path exclusive with group path.

also highlight that the new scheme needs to sustain both the
legacy behavior i.e. multi-open in the group path and the new
behavior i.e. single-open in the cdev path. This mixture leads to
the introduction of a new single_open flag stored both in
vfio_device_file and vfio_device.

