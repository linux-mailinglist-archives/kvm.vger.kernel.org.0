Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF85D6CF8BE
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjC3Bdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjC3Bdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:33:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C894EEB;
        Wed, 29 Mar 2023 18:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680140022; x=1711676022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CVU9/aw4lfwAY8d38iZPj2Ke7nDk8S62fsP+b4eW2SE=;
  b=fWVDZ6Gl8s1GgbHCLvW/cyfq0w9dhaQfAgP3spwDxoLDfAWXcqyU7d8G
   8Ntt1pL2JQYxx5R93ZcjOs3emv5zzHR8Dc0IlqPVIMtGpEnx4ZjLWYsOq
   dNNzfzrfL15UWPe4rk2PRkeMIz016HQj0uxmCu8l1Fry2NhHmXoW5DqyP
   ENkSNPv+8b3A+adejxmf/pkndJ39oatlHdFRELJ26pyK0ZAOwPXaazgzT
   n6F4wPe+oWyWOD/dDb5IU7M5HOzPIEbCZe7WqVj8dpxO3v+GilB2tacwT
   Jk5JzSt/0vmnDL+UsqQQrpziiFR7uQYjcmb2H+w2l+VJYrwes0GwyHF/8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="341062014"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="341062014"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 18:33:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="687044507"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="687044507"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 29 Mar 2023 18:33:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 18:33:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 18:33:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 18:33:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C++XNeT0Wev/dWex1Fnbvaqzx47BdAUZVujjLT+NjddI3lQ3dxJT9JojLNVBGKxqEQL21/1FiYzOdszToJkP3llNsFTQRO1d54XOuGSv24hLE1W/L88sApNamobpwFl8/5yaA4Nb4cjxOGJ3iCnwPhzrsmKBKbz1wIu/gqGpASBxw14M7kFq4n5Iw5Ikcwn4AgJJklI9srudf6VLRAKbD/hjCmv1KcP7jOtvXnh3HJh57emekJc3ia/WXOwKdrQyANZY0R136Beca2FrRJjLKYRPXQ3LI4TArPHcEmITKLdcpWtEc0pBnBeZMlusSii3Cgc3RaJv7sMf8IMNbJcHJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVU9/aw4lfwAY8d38iZPj2Ke7nDk8S62fsP+b4eW2SE=;
 b=LnVhRq5P5hJEH7k7WL+NoSEusXvaqQa4z2y7I5bTK3vYuqvUlTs46OMQjtWuKRvnCokVi/Fy7OhscKA/F4xmZFjMbkOHPSuS6eETBTik37Gl0eJ0CTzIc9DD8cB+Avj4DMyPXqHb9WxYEG2Gx0Ou2el1D+RnOaaCCtEgWItYCVUlmk1ocD/2XdsbKhcpR3DJgeIit4g5HjTbXkwa+iAxLX4pLqAcN8Im78AdYSzJwItO0tvwQQFrE7nzkdXQUoFTnm3xB/w/DdV8FpsQA1B+fz2SDlu09XOpZ234tpZuBGf4vWsUC39KdxJzPoy8UScVcyZrZICCr6iK7Gfdo093ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5062.namprd11.prod.outlook.com (2603:10b6:510:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 01:33:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 01:33:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92YoejP8gsuUepwiqB47+8d68PAuSAgACHvgCAAC35QIAAiJkAgAADhQCAAAJBAIAABAgAgAAE14CAAAe3AIAABCSAgAC8HoCAAGkTAIAAak2AgACbrXCAAAWucA==
Date:   Thu, 30 Mar 2023 01:33:38 +0000
Message-ID: <BN9PR11MB5276DBDCB366B26DEDE5C6838C8E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20230328082536.5400da67.alex.williamson@redhat.com>
 <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
 <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
 <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
 <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZCReOXsLsuS/J8TC@nvidia.com>
 <BN9PR11MB527652CC7ABD6AE2908A9A1F8C8E9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527652CC7ABD6AE2908A9A1F8C8E9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5062:EE_
x-ms-office365-filtering-correlation-id: 843b350c-262d-40b3-21e9-08db30bec96d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zshg30uf/ZDjSdD2uMxmyRc/1V+MubFgA1eh8ikK4Mzc74W4kVh4RegwvmfNNvf38vcJ1j1Bh315UzDMXWwyQ+GU4Ep0yvf2ttg+WIIV5o32j0Ms2UchRmZbM6Jbz6wU9kxrULdyPssKrCJdgCGlKQ2Zcfep3HDllhXRbaPsGinJ+PqFRI4x0k/JeOTSnuTzq21/64vGLryS2Uk4LYQawLjTKuSYa8iTWIVf7spTPtLTYW6y2Vf9lUwMx9LSlQvVZ7pY3JnMgHqRZoheji0AhuK5EcUD6mT6mQwnwg+LUWwWRJ10TNsY/QWnFwJBoDdVVy/Zo6tqJJCT9gjt80I2UGqa6gpu833JbHqGxJ8bFUQwPKjKVav5orl2pMPfVNad86nBjq5KHf6qMU8R2K4AB1MVAefWEH4gN9cGWcZZ17R5e3gTGlt967xDzT+6uX3EGMIjAILjVNGTwe4smXi0mQfCtZ0zaHnH6Hq2qXngd7bKnkdU1Vnf0jD0lOtBQNQTyiMK5HFlmX3N5rpKOmNajKi6vU3Qny6XQ4DUfrqTcFsoT48xAaS3BZGk+4dXtYT8DnbNdOkiJ38hNM7yWJYiDjstaL0fQ2MI/lYxaIiA0xvSz0urRF3dXHHK560f8k1a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(26005)(54906003)(9686003)(6506007)(55016003)(478600001)(316002)(186003)(110136005)(71200400001)(7696005)(52536014)(66556008)(66946007)(64756008)(66446008)(4326008)(66476007)(8676002)(41300700001)(2940100002)(122000001)(8936002)(82960400001)(33656002)(76116006)(2906002)(86362001)(38070700005)(38100700002)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OeNhoY9+N7XHDT4j19U9EpqypBZ7z+eAhp9tYbL4vDpGoLJzc9OcoSz4wuDw?=
 =?us-ascii?Q?WNjGXwpVhl+aBb4i5IDD8Opd+wdMFBwgYJEHMsOMy6SJ3bSMcElg4NJ5hyyc?=
 =?us-ascii?Q?EUfwDX/c4CZmLpiWZtWNbhNiSaxmd3pD/8jFVIMWWwu8s075qoPu0PRVq/Ub?=
 =?us-ascii?Q?TUrngsQ7Dm5sX3H4bXFaUh8Rt2XXNHZsySmxlUi/naEzvMATKDjPfYrHM0Na?=
 =?us-ascii?Q?2wA86E0RgmgkhlxpBNUGutwsjzFlJtoDep/sjkPjj7nqWyV0O5rybF/pNQIP?=
 =?us-ascii?Q?Mkgn7uW8GfgdCtNX5JMjYje69hPa66yFXVJVww7pLhVWKC7AlubE2xo5wNAb?=
 =?us-ascii?Q?z9z4bbVSRic/X01Kjc0IJlTYKPJfCcWbbW3szGAkO0X1+PDkBD54L80wxZex?=
 =?us-ascii?Q?E8DYggwtwp2P7ZBAmtd+4aewtOaFQdmzo5wZjXxGfGY/P5waBcj4/LiB8WgZ?=
 =?us-ascii?Q?T3EpfcgrqNpa98uZw8s34hziNIN1hDfj077Xz1uUQYAoIIk4NYIaP8/WNeMn?=
 =?us-ascii?Q?Hy+pczworxWF1ZM0qkEAHTycXZ3LWK2xyTxkL+pm7RrvllpU7JauLzY7OBMM?=
 =?us-ascii?Q?FJW62XvYPmtESfKxKyzgdUsxzCRsrawJahYLJhBPYRkOFkV74m+zugBIYk16?=
 =?us-ascii?Q?un1Km1N+tBJ+l2fNFnR0HKWU60LsnM4UIRiplxUfwgY6LVgEpCpdLi6bgRfg?=
 =?us-ascii?Q?RZUSdh2xKQE3HoaNjR7+myYp7nzJSQ0is0kWTFFGvkkFhjuW5wO1K6AzgTDn?=
 =?us-ascii?Q?rDuNEtW7k2/UeszfSfQ2sz17zhjwaFZD5cQ8XRB8z/7Lb6NP02nJ6SIgEwBM?=
 =?us-ascii?Q?L/c7sNa7F9qsXp4r+eRaxiFwxcT1OKYKIlyYwQVkyHFg26+DEefR+6yvDHUx?=
 =?us-ascii?Q?OffLp1lCp89mlxcNh8sRUTycZ0kuj7I4XTT8M8AFqSdrG6Gve/y5TRa5Fs4s?=
 =?us-ascii?Q?OpBOYq6+MMfI1/MzFIcB5DUQxs8A8UhrkSBqA+2bGKryNXQqfW4liNUx5E8t?=
 =?us-ascii?Q?6xQOy0epGd/H+QFcSRlqDIAudsJ70IqxKzhulmve19j2GGlu+iOmqyGcw6iN?=
 =?us-ascii?Q?2Mqbk2mAdRnZCUMGc35jAh8XMuffkqgUsLQr3Sh6jGdLkQylMAYTexzeFyvh?=
 =?us-ascii?Q?ZxQeMTdjcVgrZZ34HTXXsgnUT3ZxQRT48mCgJvrpsIwlOOHQ8N4kIk2gVm+y?=
 =?us-ascii?Q?C1KTxaTsUaq7hC5gtAGqPsvExPBr3tt1Tbi0Z3PQ4fpM6csCHwp3wePtue4B?=
 =?us-ascii?Q?+rIhO9gvK4MPACiNdjcoVd3fiVB3N94vtkaKW4qUqdNSoTTTu3O58ZGpuoTq?=
 =?us-ascii?Q?EhWwLWO/5NNjcWU7KXW7CVr3JqGCGjRWVEDUaaSYDvOuc6eJyLFuevRFpXLR?=
 =?us-ascii?Q?x2xXTDP+iDDmRIHETnfq3CiPhlDGArJE9V4Cs55ZYuTAYtGB8M8zDr1HtCeH?=
 =?us-ascii?Q?MmpedXUJov2TZFDZlBLsCp0zFuu8tHqhGPR7/S/SpO1zdA20CPYZw8ptNnqX?=
 =?us-ascii?Q?fmnRuNZb+jE4d6m3gK0gkCMUWQAFCtjY0GNEaLPXvTkIQKlabuDMvx4V7kdW?=
 =?us-ascii?Q?gSSznLkSpPvwWRSZkG/fc8Qon1WZAfX0m6qYqBfm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843b350c-262d-40b3-21e9-08db30bec96d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 01:33:38.4022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MqhfuGJZe9T1Nn/Qqj02f2k/hqgml03oZhw02JKbhnNX+Ff7gPXR5URnyLXaA6gWgx/9/uRyqSfUQ0cJx2km1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5062
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, March 30, 2023 9:10 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, March 29, 2023 11:50 PM
> >
> > On Wed, Mar 29, 2023 at 09:41:26AM +0000, Tian, Kevin wrote:
> >
> > > We could extend bind_iommufd to return the group id or introduce a
> > > new ioctl to query it per dev_id.
> >
> > > Once that is in place looks we don't need a new _INFO ioctl?
> >
> > The iommu_group and the reset group are different things
> >
> > The issue is processing the BDF strings, not the group ID.
> >
> > Probably we should have some way for iommufd to report the group_id
> > from the dev_id?
> >
>=20
> Yes, that is my thought. Though iommu_group and reset group are
> different things we could still leverage existing _INFO ioctl once there
> is a way to associated dev_id to group_id.

Please ignore this comment. Yes they are different things so even if
a dev_id is in a group_id reported on a reset BDF string it doesn't mean
this dev_id is in the reset group.

Qemu can know that all affected devices are either owned by itself or
not used by other processes if dev_id's opened by itself can be
associated to all group_id's reported in the BDF strings. But it still lack=
s
of information to tell the reset dependency within those opened devices
within Qemu.

So we do need a new _INFO ioctl for cdev. :/
