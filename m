Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053A072F48A
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 08:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243097AbjFNGOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 02:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243066AbjFNGO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 02:14:29 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB1F1BC9;
        Tue, 13 Jun 2023 23:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686723268; x=1718259268;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mblfH4ZfQQ4Tcwu386HnuWQ3g4egh1/CkG+55zUKgTE=;
  b=XkneHwlG1CmDzwbZir/S6URieWxs3T+ANXr8RL14KdMFstIe7RdrUojd
   TXYMvzN30+/+j+mnRKUJHl6LLJfW1X7cb5GTRh4k/eNwaxgUTGZDDU6WE
   iu7ZHgsJXe4Y6Su816DW6KGPqN6r2RsVS4dRgQirKCft5mzeRn/WYJN1X
   d+HiTIcIW+Gn0PRKZneyHbWgvS5ptpolBmTanlxM72GFsOHwnM5mQ4mT0
   xkkv7C50Uzi+lA3bw2lF8oNYWWcw2VkWKbUzeqiBaT/QlgNa6e5oJE0HY
   3dgUP02jPtzIiXfyIOgCsN7pXUTD2twv6+DNb6eSsms8INCV5i2gohJv2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361012586"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="361012586"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 23:14:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="836154926"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="836154926"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2023 23:14:26 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 23:14:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 23:14:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 23:14:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj0Agk72xFzdXRkJ/5adoQOEkxXOAC6V65eaOn1AjprXMCd0tRkU03ke+END8ktEscFWPSemiAk8j6Azkg1+bqxD+hFQjXm05tK644kk+3cegam7PFRDQvS0crBdEFHFPk/KR0WSvvDRGwjcW3ytvTIQLImltHFPnTDgxoMskzPvoC/K1DUNvr0llvE6cCAGD1ord9V5pbKcXWwXOT47b+R6dhuv629KDA5n7Nxk2kJVQMqYfPocPVLIbG6QXDk1JrMHwe4glvrG9WbCwXinLY+Jj8y3dKnEmPct49gdwFZsxZq23vbYmcgI+Q5KwtNfvuqLDtpxcNkA7RvgyXFs7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEewdqlIQTZszIUOisGV+1n0YzNzdeV1tpV90o2KlM8=;
 b=HaRz/mLdTt7aUx5k+vXIngou0YcOInAcJKUkpGwEc42+MtSAiDCtI/zP3iIVnCgZfGvsrYVVYBo4KP7RH07mSHxRLcQwXqwAi1ucLNS94pLc5Or+5j+t465936nhVBJCXSr65Ho/kCBLWlhO1jOjV3JwA+tcQvFr65WkHZVPPALLHOq8OWP6LvVQZN7nqJFFowSaA7SeGxCPR246MUDgoG1XKCUhIurH1+M7XrhMPbi//nHvlGuEXD2fk+OOpAn0qJBTXgE5eWqKxWyCesjVt5/BrTVPwuXL2SrAr+pCQp6IdBm460+miXEuxkPTx6rDVVb5s5uqligJ28tD4mDAXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7525.namprd11.prod.outlook.com (2603:10b6:806:31a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 06:14:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 06:14:18 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZlUw5Bdx6t/Ptjk+i/O1PZ4IdNK+H07wAgAB3NRCAAI6EgIAAArTAgAAFeACAAABSUIAABoqAgAAiIoCAAAWUgIAAK4AAgABxqjCAAC4LgIAABP9A
Date:   Wed, 14 Jun 2023 06:14:18 +0000
Message-ID: <DS0PR11MB7529E50A3F122449AAE5733FC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
        <20230612164228.65b500e0.alex.williamson@redhat.com>
        <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081913.279dea9e.alex.williamson@redhat.com>
        <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613084828.7af51055.alex.williamson@redhat.com>
        <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613091301.56986440.alex.williamson@redhat.com>
        <20230613111511.425bdeae.alex.williamson@redhat.com>
        <ZIiozfqet185iLIs@nvidia.com>
 <20230613141050.29e7a22b.alex.williamson@redhat.com>
 <DS0PR11MB7529F2D5EF95E9E1D63C9264C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52761B4E9C401A46FA5B4F2E8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52761B4E9C401A46FA5B4F2E8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB7525:EE_
x-ms-office365-filtering-correlation-id: 726e054f-8b62-4a0d-fdc2-08db6c9e965c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cl6l2i6gNG2pEn+xl9418wVczBEUAeVOqvDk1yRD5vDjjOcouA8A+eqWaIwpGWSG9T/dOuXzIbOh7FYB23dlVKUhVSLR61Fyx0qdHoMTceDgyPe5BQdzTvoU8QQ5BRQ+IypQ40EIQcxOlrF91bRGU1FXc27OrfcOcl5xz5oTPf4fROsFTohWzp/m6xt/X2nc3XV7Gl6BXzKlcVW9s8nKwBSwpmEbVEtvd4KLwTTLWjM3ZucPAKClRC28nnpmfFEt5NDHqxJDUSF9PFIoWYYRsgruEtrmOloLJi2k2seLnUwjKznEXKMVtxYFK2HTw3PxP7raHFBinw4TPdUYLRevXB3UlcAyj2ckSrkmD5mkDm85d2rksqKWI+6IyThKnPZpDVrjK5DLhHB2+vE+QTCp6A29jevJ1+JAEqRxNado3cZ7oEXaA1dIRYo4myW4lXfZ4jIuahjTWUeccR0Pj1j2Ufkru+6HFGna8au+ORC0mBtxHlYpACh6zlHK9wCHSbfvtfFrE2vzBt0rITDWATQP889gbVk+8JMmfXCWlg+4tC9W99KDzP2gyOF9+5P39JhEyzEXxF2OXTNe4nFiil9o9ZtymrSGvSvVkKCxZcm7uuVWdH653P8Oxf0dYupjSXDQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(7416002)(64756008)(66476007)(4326008)(316002)(66446008)(76116006)(41300700001)(66556008)(110136005)(2906002)(54906003)(8936002)(66946007)(8676002)(66899021)(52536014)(5660300002)(71200400001)(478600001)(186003)(7696005)(26005)(6506007)(33656002)(122000001)(55016003)(83380400001)(9686003)(82960400001)(38070700005)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FJFmXTIdpwttoG4ZKAw8XDMKzu9KlLgqwXWC6R3ypMpJnYVcs6cIR1qm1C0k?=
 =?us-ascii?Q?G/puxmAZh/fEnNz2/EdAocsTnnDapw5APeynVEe4LeIujLtjxLYcFCNGHrPl?=
 =?us-ascii?Q?fqWbeiIjqndDf6iishzlTsadaZTb3w3n7nXVXskz7TCxtcdXLiT6F4Un2mTZ?=
 =?us-ascii?Q?f9bMx0KcPtl6ifzwtV/GTj9hsRPIGVPzedvCfURNqa+Oz3QpQ3qumF1x8pl8?=
 =?us-ascii?Q?pncx4euDUSPOPLTUDTRrLmPPPFFvTysd6CBH7+9r+tQk10plQXcIaNxUZEvz?=
 =?us-ascii?Q?tqIKE4XeICdSCPda3vSMmbY0MGlpUQF6gzI3mOme6qskGhy3iZ7r5fCtSqeh?=
 =?us-ascii?Q?ys6tqYoRhFv1/it+Pv36bIlMCedpw3zuS6QVQEAAt+JJR7/B9k3WuMnhuOIw?=
 =?us-ascii?Q?oJ7GMELwGcLllhr52N0SJPlFgYHoYTx+qfJ9iRf0CaFUmn+tSMW8o9Ilx0ec?=
 =?us-ascii?Q?WEIw40MoQjrMe4Klfgs642ZNT4ZcTQ+uXTzKczzMNQ+ADQD3rPK7m8qRjw0E?=
 =?us-ascii?Q?Cy07teCoatUTiOaiSbtEQuN/KpI9AOiUSdtW5JotvV3tzGy31q3R+gKyLnw1?=
 =?us-ascii?Q?l3y4EmBD+Fc+je+UWW6AVhJvWqgIJvQspJ2zXOLHtkQKHGqCQC5WLrn0MZn7?=
 =?us-ascii?Q?sYiTSMTFqJQUhtXdda/nFRtndxGIXwGLAvallViqtN6D/+BKKqgALlk+4kar?=
 =?us-ascii?Q?BiJGEwEbYMfh4XUvcYIwhL3CqQQBcnCnTBUF/FAWIWQh+gMzq6fLtFcLKRSn?=
 =?us-ascii?Q?2dbRC14agP1j/yYFNa3nXl7uwhrmrx8Ior8iKqMKluHPE0rO15AKr+mfBHaH?=
 =?us-ascii?Q?kPwd6nGHEDLvrIWKo5MHSUQLiaPHpOHUmCce1v6g7rSjkbFbfUYReT8EHLfK?=
 =?us-ascii?Q?x6cv70hkX+Y4v6P0h/EKahqb6mBQtXCr3QEjI8GSrvQUmG0w4VnyJjrbzizW?=
 =?us-ascii?Q?68Oz28PXvPcH4810XG0dN1+E80+TtZSwb14GzA/pwaA/E989IkUFRjQ+NYf6?=
 =?us-ascii?Q?G4V+Yahmf4c3jAxVgE2zip9/ayByukC82O5QUc52TKKdFJTXr02sIUrQskLP?=
 =?us-ascii?Q?ha3r/9TN3wZZCmAaJgxEVSaY3F6Q/rPDR7YrLss+HedZiJF3CoZ07iaXptG6?=
 =?us-ascii?Q?dbUXnKOyrg/Dl478n2rUsFMDmZsXNJsBL/HfZ8TYngH4eGk7PfdQNBjYICPC?=
 =?us-ascii?Q?xWkr4XWSQbgez5T4DpYG5geRIZDNV9fUnzgSp4bR1w5lIX5XQ05gjEqWgBRT?=
 =?us-ascii?Q?NJX6B6VS0a8u2IR951vDoe+v6C2EqigBkhqPlDSK3J3VBZYtFndNG/1pRGLr?=
 =?us-ascii?Q?+melttYnbggiK7+5JtgUl0uu4verkqgLBgQZL+ElFkRRop08gidqylEuTtqx?=
 =?us-ascii?Q?jxG8+0GtHUH0NZdInMdoTiD8IJx7rV7AP3z1MTi9yUQ3yj8j+r7yr8nWHf4r?=
 =?us-ascii?Q?PZtc9AC2VA8UdKJneCtjzmNMUp4SvPNQctrRrIylxeKWQ0rV18+reijYsV4u?=
 =?us-ascii?Q?lErIjLtL6d1KpDf/FAFNDON96s+INcpI/qA1htirg8PtpU4P9F+TroGhwhI5?=
 =?us-ascii?Q?wHat89z1joaB5phakvIg2idn1zJJf1sTll0VMpo9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726e054f-8b62-4a0d-fdc2-08db6c9e965c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 06:14:18.6122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NPMq2Z0Ozz3EgYKViED90OOE2sk7q2b15fnIjRuAnnqj8olCNjsTKc8VEQ4Ebk5t//hsDGhqKI+PVbvIehkPDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7525
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, June 14, 2023 1:42 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, June 14, 2023 11:24 AM
> >
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, June 14, 2023 4:11 AM
> > >
> > > On Tue, 13 Jun 2023 14:35:09 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Tue, Jun 13, 2023 at 11:15:11AM -0600, Alex Williamson wrote:
> > > > > [Sorry for breaking threading, replying to my own message id with=
 reply
> > > > >  content from Yi since the Cc list got broken]
> > > >
> > > > Yikes it is really busted, I think I fixed it?
> > > >
> > > > > If we renamed your function above to vfio_device_has_iommu_group(=
),
> > > > > couldn't we just wrap device_add like below instead to not have c=
dev
> > > > > setup for a noiommu device, generate an error for a physical devi=
ce
> > w/o
> > > > > IOMMU backing, and otherwise setup the cdev device?
> > > > >
> > > > > static inline int vfio_device_add(struct vfio_device *device, enu=
m
> > vfio_group_type
> > > type)
> > > > > {
> > > > > #if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > > > 	if (device->group->type =3D=3D VFIO_NO_IOMMU)
> > > > > 		return device_add(&device->device);
> > > >
> > > > vfio_device_is_noiommu() embeds the IS_ENABLED
> > >
> > > But patch 23/ makes the definition of struct vfio_group conditional o=
n
> > > CONFIG_VFIO_GROUP, so while CONFIG_VFIO_NOIOMMU depends on
> > > CONFIG_VFIO_GROUP and the result could be determined, I think the
> > > compiler is still unhappy about the undefined reference.  We'd need a
> > > !CONFIG_VFIO_GROUP stub for the function.
> > >
> > > > > #else
> > > > > 	if (type =3D=3D VFIO_IOMMU && !vfio_device_has_iommu_group(devic=
e))
> > > > > 		return -EINVAL;
> > > > > #endif
> > > >
> > > > The require test is this from the group code:
> > > >
> > > >  	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
> > {
> > > >
> > > > We could lift it out of the group code and call it from vfio_main.c=
 like:
> > > >
> > > > if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(vdev)
> > > && !device_iommu_capable(dev,
> > > >      IOMMU_CAP_CACHE_COHERENCY))
> > > >    FAIL
> > >
> > > Ack.  Thanks,
> >
> > So, what I got is:
> >
> > 1) Add bellow check in __vfio_register_dev() to fail the physical devic=
es that
> >     don't have IOMMU protection.
> >
> > 	/*
> > 	  * noiommu device is a special type supported by the group interface.
> > 	  * Such type represents the physical devices  that are not iommu
> > backed.
> > 	  */
> > 	if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(device)) &&
> > 	    !vfio_device_has_iommu_group(device))
> > 		return -EINVAL; //or maybe -EOPNOTSUPP?
> >
> > Nit: require a vfio_device_is_noiommu() stub which returns false for
> > the VFIO_GROUP unset case.
>=20
> device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY) is valid
> only for cases with iommu groups. So that check already  covers the
> group verification indirectly.

Okay. This IOMMU_CAP_CACHE_COHERENCY check is missed in the cdev
path.

> With that I think Jason's suggestion is to lift that test into main.c:
>=20
> int vfio_register_group_dev(struct vfio_device *device)
> {
> 	/*
> 	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> 	 * restore cache coherency. It has to be checked here because it is only
> 	 * valid for cases where we are using iommu groups.
> 	 */
> 	if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(device) &&
> 	    !device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
> 		return ERR_PTR(-EINVAL);

vfio_device_is_noiommu() needs to be called after vfio_device_set_group().
Otherwise, it's always false. So still needs to call it in the __vfio_regis=
ter_dev().

> 	return __vfio_register_dev(device, VFIO_IOMMU);
> }
>=20
> >
> > 2) Have below functions to add device
> >
> > #if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
> > static inline int vfio_device_add(struct vfio_device *device)
> > {
> > 	if (vfio_device_is_noiommu(device))
> > 		return device_add(&device->device);
> > 	vfio_init_device_cdev(device);
> > 	return cdev_device_add(&device->cdev, &device->device);
> > }
> >
> > static inline void vfio_device_del(struct vfio_device *device)
> > {
> > 	if (vfio_device_is_noiommu(device))
> > 		return device_del(&device->device);
> > 	cdev_device_del(&device->cdev, &device->device);
> > }
>=20
> Correct

Regards,
Yi Liu
