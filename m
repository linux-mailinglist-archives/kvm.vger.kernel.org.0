Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD4F6D7FF1
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 16:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbjDEOrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 10:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237141AbjDEOrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 10:47:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E44FB;
        Wed,  5 Apr 2023 07:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680706024; x=1712242024;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S/CR1o6T9wCIyQH3UmxO+Q9H2mC56bNxadi826abGG8=;
  b=b7abHl272AMez1WjY4c2pSELa9XemLPC4hTQGgoag+uCZy+ByFANjmoo
   CTmCw24vQYiXyTmktmEBLUreTuN3BRiehs75C408Mpy5DLwSSRSlwutQh
   KF9wHNxmnPg9YK/yplpxzbEpJu6c4J9D5EXrMU42e5Yk4nVlSBHdZLvKm
   FViOOok8+4tF8VYCEfUr8F9QQISN4Lo8ETvMT4+xEM5pbingzxrO8AtcP
   sRcy1XPR8lfmf2z62AhKEn2icJGKH403Rzh1mP5F+Cxz/fMn4W3Z2NdhQ
   xr3eld2Li0TVZPBJbl70w6ijeXNg45xcJHcYVsykczjTPVFxRlMjmBOAc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="322128881"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="322128881"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 07:47:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="686774919"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="686774919"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 05 Apr 2023 07:47:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 07:47:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 07:47:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 07:46:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghP0/N7vR16hBgytPs3vIMg2YFCAqRkh96GlUmvZ8abc2RYeTIrPz6WekVCvkr7l6qf4aiHiBps4M8a3vtn1Fg3xJyJxaK1ZoLyNYL0Wen4Ed4VPXTQNGHXQaOGdrL3rtfdrqkKFTGEyyHBbgEBgD+TaxegRnan465Egz6zTOLeZ1vENRfXYOWrILbBIiwrAJclyGF9jamvlwb3iTCqt0BHQRnSQbVrWUWLTV64xTLIA8B+aclS5icokdJy03nXWlRG5xRQ+u2fG970ToWDQTVb/yj0gkVgxdDI0IvkIyy/EshFZ/doi5RaCoA7ra8dZeNhSDNiLLHQ3oC9SnYsZ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rxHEVjzvNsUvTzbWXKoNYpVujtqyVFJaHCyv747Yik=;
 b=bhw+UwRCF8dgbuk/GtjJ0hEoh/tYkLiXxCquKHWLriNSB4/Ymst/xgZAeqPFo2PHkQ9JGqp3xx7cCqa98vh2qvzH3E+Ud20xCpTpWa3TAg3F4ipUnKyEtP6Z4pHrgmJVPpIWFfwkpxoH5XYPSBQinck+QUp3Y7aIGUJ8dzN6yzVXs8flfqPUIx6vbGYIzLJtNXgG+stroeqa4c4QYGVA3IkM0zwuF6B4DL9epGCxYE81kUHDsQ8cTKZQD0pBRX1RV+KToz6JT48/uZ9RNMdL7gTF+bgLpz4+7yAVUWf2sz7CT+IIa0gGnrSMCPg/YD+V2vJfVuauv0r9pfVcUaysew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4575.namprd11.prod.outlook.com (2603:10b6:806:9b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Wed, 5 Apr
 2023 14:46:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 14:46:52 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v9 16/25] iommufd/device: Add iommufd_access_detach() API
Thread-Topic: [PATCH v9 16/25] iommufd/device: Add iommufd_access_detach() API
Thread-Index: AQHZZK1DZFmNremnwkKG+VLVqq49ia8bxOAAgADdFACAACQI0IAABoMAgAAEz0A=
Date:   Wed, 5 Apr 2023 14:46:52 +0000
Message-ID: <DS0PR11MB75292A8BD357131A5BE76283C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-17-yi.l.liu@intel.com>
 <20230404164512.37bca62e.alex.williamson@redhat.com>
 <ZC1h7PyuhEg3ZMcj@nvidia.com>
 <DS0PR11MB7529B223F9091E509DBF351DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZC2FnFmBldTnKeaB@nvidia.com>
In-Reply-To: <ZC2FnFmBldTnKeaB@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA0PR11MB4575:EE_
x-ms-office365-filtering-correlation-id: be80e1c5-1698-4fc5-1788-08db35e497f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 41Z9jO445vfjo86sBqxkcVpqvVMKfLW/w0d1hVowpll/MjOYmXjKeso3aZO9bgrYkUREBfEXqZB11K8BN/rEu4VvlBjVFHeEru1CwzNb6J2ypI0W8cT46tMrjGPOc2BvkZYZHTV6kB5iItcijXSV9MH4mdsLExlbUk9VyfS36R/ljj4YezfliRQBH2qqqX3jKBli3I2DyvaQ8fvcZ5SB/MKAjFhbyLf0ES3zw85vvamMSn8IF0uF1WnFDzx0z6Vi9kGC8rxc5XmiMmwkafMkM0hGQILuDznbT450uDR4yB76yUW0KaPo5xP1rus6vqCTvEGu7g+uuTnfhJ8V+l48IsFoC7YyEiz744udQ0QuHwPEleuKtPW3WBZByjGLa0f+20P1tiDKK8vuIy1j6JZOXXRaESD041b7oO3lm80wVjfwoKL3njFHhkKRAUcTiCVehAEkS+24CIRLDBJgfIF1O4kMJ2SUyYiB8nEGMDiQLUmqFBArTsdBz+nfoXEEwh8caQxs7s6b3QjBjA+DzGkQ+30rJE2sJNUhb8hUc0n6c6yi3CapDguTsHvI4Dc9lxG0RhKBHpNtNI8PZ5WiOcRvlwp0gUvuPXsJ83rw3bEJ+sp+xpD2UXbog+yvUbxz/wo8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199021)(33656002)(122000001)(52536014)(38100700002)(4744005)(5660300002)(7416002)(2906002)(8936002)(66556008)(55016003)(8676002)(38070700005)(82960400001)(64756008)(66476007)(66446008)(86362001)(41300700001)(6916009)(76116006)(66946007)(4326008)(966005)(54906003)(9686003)(6506007)(71200400001)(7696005)(26005)(316002)(478600001)(186003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qt8WlX0QEXuNQsEURHOgoCvn/QZmiIZlkgkO752F5pCqVD21DGoEi38Tilua?=
 =?us-ascii?Q?ly5jVjMjJnL7cLJaIBETpTU8RbYXEfoYai8FbSQlGhYoUKA/o8WCnXJ5kQgD?=
 =?us-ascii?Q?Njbii/BJp+bgrQk+QoGmv7xoJ318cgJhxXthixOl/taxmdyhFfO22eUDxcbH?=
 =?us-ascii?Q?dEEZD0bK4JXW2jFAaXo1diqWcVf2Wt2xeOxuc4h7k0AxWqHu+M3NQO2Iu8ss?=
 =?us-ascii?Q?/5Kkd5oGlU4ouiSNRvjmvUFGgNwFl4gNuX4kaPB7cyvFuc2ztzHeFo1AEx3K?=
 =?us-ascii?Q?KzeCgyi7Pdfi4m26DdqUNxX+J0HutqYRvHHJz0NljJl0EsWopYWPZtiLdFnJ?=
 =?us-ascii?Q?8ekuRIsYZM2i41T8Bv7rbQbN8GBwj1kcz2j3tcF+Dfhw69CAU2HNgwa3MXI0?=
 =?us-ascii?Q?6GFgQ6ZyrokDIaI9xvLxFiDojoVXfJZS2m6iOF7Mw+izPPCOUKuj/I1g4zhs?=
 =?us-ascii?Q?SAZXHMd7G6j14gYIguQwA6pR9iS+YEDZLzeHwGrSZuZeExRQkd9xxPv0B6g8?=
 =?us-ascii?Q?oBkbfVd8smEU8JM074hL358C0cer8Db6cKEZbUKfeBn8Ir9/mewJnowtGsIo?=
 =?us-ascii?Q?TW0GYNvA097UanPfN7LPuUSsXkvlKuyEcr6kY1Y7wDvmlLw/c5Y5y5Icaa00?=
 =?us-ascii?Q?chByH9DD8cQow3cAzqKqJMxOplNEpFNtyn9IWH3/42/O29Q2IsDt/HRqd/DE?=
 =?us-ascii?Q?DrCZ4PvlnKULn9Q3SChk5AIDo6mmJoo+YQcwnSEet8FTKxdixANLeitLcy01?=
 =?us-ascii?Q?TKFVYEnBFTiKKEKmmI8d02VNnHbSuhGNpwCNRVMxvKkSuaWts2fP2B173Ten?=
 =?us-ascii?Q?P/HroBGpLH9RqYNAdFZjKX4MU14m5TH9A99fA829Dx5KhH0uCz5hjetkgqYQ?=
 =?us-ascii?Q?HjGk43G2SGb8Ycpr5cH6gKs9TxzQVNT59fYboJN6qJpSId3AyKB1vgg8bMrS?=
 =?us-ascii?Q?lhZ6GnU4ouGV6d2Bow/YTsdmRbJf3ZupvhuLQ7wxI4zmytu1rENqr8dInt//?=
 =?us-ascii?Q?R6WlkrGNv0UKzKycUomsDcjL2fH9igXD21k5+I/7xPeKzKswNag0NKv0TxsM?=
 =?us-ascii?Q?hYDJre/5lTWCFIhyDpZGudmneck/Tl5iy1ktQIlbNWd/jkucPYwccMu8eGLH?=
 =?us-ascii?Q?ssVWHN2C2cdLdao9CH9urZ3KN5yK4kVPUn8hj7FgFd6vTOBUSXULsravUD/9?=
 =?us-ascii?Q?Nsp8Ifc1d1OT5UiAzntO29D0xV4xt9mT51p41ONIvAsVPtyCPhtNECaL0a1u?=
 =?us-ascii?Q?dRbUkCwkMBC3th48fqqPdgCExrPlcYLfj3UOJ1Ab/iTvhqw6yl+DsgZ3oS8S?=
 =?us-ascii?Q?g19Nslge9FMPznu9OriB98TzvQ4JSSuDNvhgnmwrc0WAaeHw5qZw4nyxlArc?=
 =?us-ascii?Q?nwSN+y94dx+Tlk92Uz1J3H1z6oaonFcQ8igQcqWjVJFQcz4Vnl0eJ1HkYZH0?=
 =?us-ascii?Q?0Nd2QHzefH7IRxywi6nYwgscmofA8VuU7L1JpOD9TMCRt3xY+LNxxkZJ5UNR?=
 =?us-ascii?Q?N2uwNk1lu1YGObFD78VHwOIqk1+3RsI7PG2Ww3gfDMbjFQToArtxqezQkjDZ?=
 =?us-ascii?Q?MBTyFsreTBWFUPN5Zxe4i6WLbVIMM71bC65oRVum?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be80e1c5-1698-4fc5-1788-08db35e497f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 14:46:52.0513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GmV5cBMCJXX1NjEnuexs+7Q1fkY2THV0yDvzxCgXZuiMwlnyNAlgJQjx0cDImeRjuJCXKeNvODIga/Ss1qtqzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4575
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 5, 2023 10:29 PM
> > > >
> > > > Does this need to go in via iommufd first?  There seems to be quite=
 a
> > > > bit of churn in iommufd/device.c vs the vfio_mdev_ops branch (ie. i=
t
> > > > doesn't apply). Thanks,
> > >
> > > I think it is best to stay with this series, Yi has to rebase it
> >
> > The rebased version is here. Shall I resend a version which is rebased =
on
> > top of vfio_mdev_ops?
> >
> >
> https://github.com/yiliu1765/iommufd/commit/d3d8f65c82fe2ca2a7b1a635f4b40=
b2a
> 0971daa9
>=20
> When you post the v10 it should be based on top of the vfio_mdev_ops
> and the hot reset series.

yes. At least, I see the hot reset series needs to be refreshed w.r.t. the
comments from Alex and Eric.

Regards,
Yi Liu
