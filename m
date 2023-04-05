Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A4F6D761A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbjDEICE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbjDEIB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:01:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BD630ED;
        Wed,  5 Apr 2023 01:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680681716; x=1712217716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rnyM7crNrSmkTbhPIwNxMlM41q5el3RalvqxOqbqwNI=;
  b=HCPme6ICoFhFkjQ2y/wqcLiF2WPd9TFO2JhUuTqTmOsxCt/o0CUTn6fO
   iTCxKgYyi8qs0f1qSVwFvVBwizivzxuuWsOJh2Toa9gwU6hMcy66/D3K3
   NBKqK2qDTTuHAn6OdXYhFw2mh+cxNhgmLpWcdGn2eU42nii6On3mKKymG
   RNI/XFIvjjw+auCtK6dup7q65z0sIbSEJ8yBY7J7jZjAQRx8SSc1zcxmw
   Y0PS5bN3+8C1R5r84njVWssdjfTJFOkvRP3f0Ur/mPT49VPk4nzqL47Xv
   ldDgLyKRrl2yqt1BaRMSUlX41j6aqkJn/f9NPoMjlIqmLtLrdDezMkcgx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="428680149"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="428680149"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:01:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="830276004"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="830276004"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 05 Apr 2023 01:01:52 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 01:01:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 01:01:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 01:01:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6jjubJfvgOdEiof64+s9MCRhIbQO1VLRuFm3D05TgoAwCoCCUqNcCtB3hVJfc+6aQwOPhbL4eSK9eI0GfLAxOk1Y6YshqlBk1oxNEtEMu6HT/kdc6jF+/XpIezkXFHYlhVQz+Sl3LCaY3ntwKPzCgEQyDasleuR5XgQD2zrkg3KnD8TbGlXU4TZzof19n47kB+tFAPLOTgBmCaMdc6d93UgLPLD8/eN3IYCF8aAbWFP8wON5NBbzWA2Kt5HfzS+Qd7Yt1MUIoPdqWt5rbwTUQy9x3sAjGXaMBrGSmUtf1F7q7N753jELkMgm++/IX2tlhuDxZMwYqtUhGY0b4nvcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpFCiBFOAhZkJlFdxsY0XeEUsyEHGu7t4b9e6ttAh8k=;
 b=NwEWIP7DbQvFP5bHxeRVpgoZaLDeKjm4APjIjPkryJWat9JmzhxcUV9/2wOyTAYeb7mk9KnBj08uo/6X6E4xBcj7YrgrUGK3eKOOSU7+gXi8KEL4zhDzm27ZDw9cfwX1rRmUnn/LxowUWvJ93FHigXP8X/Sjf9xvEkEUtbY16pXp8EFIMCk4ryKdURjsSL6HkrQxwes1fUWCzs2ULRLwv209aKnc8FTSVPmIV5DTqHYJ9CqDS6YaPWusslbXnDaoEAijJuU0XduPLap6P9gywIwVSC63jkcPnsK9TwZpKhH62ixEpy1MZYqMJD8+hdjjsuWY/qpWM3IvmDqgIpbfzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8343.namprd11.prod.outlook.com (2603:10b6:610:180::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 08:01:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 08:01:49 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZZKh/F8Y4f47WR0u72nj77BeY3q8bm/YAgAC8rsCAAAYvYA==
Date:   Wed, 5 Apr 2023 08:01:49 +0000
Message-ID: <DS0PR11MB7529730CD29F2BD13F1DD9AEC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-6-yi.l.liu@intel.com>
 <20230404141838.6a4efdd4.alex.williamson@redhat.com>
 <DS0PR11MB752919BC81CCCAB1A13998CAC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB752919BC81CCCAB1A13998CAC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB8343:EE_
x-ms-office365-filtering-correlation-id: 4fa701e5-8120-4e22-1413-08db35ac0284
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8lMMhVNDbLppQCvUS6X0CCVFt6MNvlaweIxxIfaYVqleB38VIrYTMFYTHR14g41Yge3x2w18aNOIFRzEna+BNJR9BCkq7woO1/IvLw2tk28xxHg1Dpqa6cxNpLPh4+yaOwCTvPxjGI6nar43zk09ILjrgQraweJc2QxwEVEt3c1Ay5r/97zXjEpzqmynUSA2XntylHNdR8iGfOFKNljdxzOQQwR547MZiD0n2GdI9cIoJ0LL2Nu4qZafVDihk3ZYkDeRALoXlxJyk6ga0vmo4XraAqZmCgfC0pitDEoN6HVlfFf4YoyWscgYKLIbaFGnsbJ6FoEDTcjFXTL93fuZU5R+XnJ0pfgnrL7HtD+i8jlBXsJjP7oS2M+YxgtbohqsXlywsl7CguCWYhGOIJARx2gY8LPhdmUCSU629rZ1Mk5Fl62SRgCPPbCw0ruay9Mp2iARaHzI+3sNFsyWUMqDGuo9q7Kq5bxC1LhsnvR4G0rqcxBb6ej0AI8t7wuh3v2B/ee4OQF7btlS4mylAgvN+trT+C6laRK93sdLMCIX2w8b1jJ2s1a0uRp6oAh9Oi7Kn4GEKY5XLGieuegeY1MGIQdUFQEvWQS6zCizOZBkoyxztbgl9lMlf3WsK+I8scJbe/avr50KNmFiH4M2hfJGqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199021)(33656002)(122000001)(38100700002)(8676002)(52536014)(7416002)(5660300002)(55016003)(38070700005)(82960400001)(64756008)(66476007)(66556008)(76116006)(8936002)(66946007)(86362001)(41300700001)(6916009)(4326008)(66446008)(83380400001)(54906003)(6506007)(9686003)(2906002)(71200400001)(7696005)(26005)(2940100002)(478600001)(316002)(186003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2XcQYVJyo+epMkUgTHO1CoFDKvBVNa+27MmHcFD0nS2ALCO1KPl0WxnWBK+u?=
 =?us-ascii?Q?1G+eA3rzdGRoLXnTIv3jyoegPIqycr7w93G90Cx3DP5Q+y01QYL//PfezeLr?=
 =?us-ascii?Q?1GwTTebdZ+9NMsBuiyU9LiCrJWIw2i7eVMwYkLNn9Cow2wQAhp7Rtj0WFkO4?=
 =?us-ascii?Q?RZJVfGlKBYPY+pGyZOug5uQ1EJOnJsZtska55Z1mYZD6ahHQ7GvgGS3vOJd9?=
 =?us-ascii?Q?xMl2ekN6rdVFvr8f/gysiMkHjmHwoaptgmqa1NFDu8Fm7I8lIGv6cQyUSgQL?=
 =?us-ascii?Q?uO4PWVSzhdWluDw67wzceEp3a3CXZR59AQcvMntAhPhCe/kTV2p8KtGSwJF/?=
 =?us-ascii?Q?Nxj1XgLKG/HIX+2f+FLOcTBASK14PKmQgFmkt6UEqNtPzzJpUb8HiwsMmIrM?=
 =?us-ascii?Q?xUq0eCNlseSBPGKE5WuzZ4w8A3oe5/RJeF9KUXQYWis7cw4VUwAHzpFJcI0r?=
 =?us-ascii?Q?Icaj3qTU9BZ9Bjrm8w60wrRdYVXMcFlsVQl44O/jyER0RvF+vEGH+fjIbntU?=
 =?us-ascii?Q?OoQyA5j4tlJ2Ij/sJ8tyBXI2MbVrlGN8HVt8AvBltkeEehbkUEag8z/ytsSE?=
 =?us-ascii?Q?wkls5Yfss+x0lt+JwTWSGkOc4sKbf18xJ1waS8iAehh+ZpxG/pIRyAYcRCOd?=
 =?us-ascii?Q?HraA6wqhr8hX0g7y95Al3DzKYrqIcN9ZiK8HHwSv6y9uWdU9jbTJIip8cgTh?=
 =?us-ascii?Q?wC36wWG11XbbyRI2NkmfzSkXtpK/0OpKg2FVtcutqhR2emMcmBUSG8ZrG6bi?=
 =?us-ascii?Q?mE6Yc7krYNZLschCc41eI1iAqw/tPoK7jT5bf8N4wV4dX6NF0yNziQ18AtM8?=
 =?us-ascii?Q?KQbBZCOcSofjZAimKy2OvIWX4eDFotBIvu8Aa52oRvPRVCHH9hGo5x4zfhdY?=
 =?us-ascii?Q?MYLiUkL86geqoqJeHyTn0WJ/24FS2EqLOsJ7U84Wj/GvuRgkKRMatJ0XPyX9?=
 =?us-ascii?Q?Ut62v05S8sMExUOtSNVUQPLLGdJgszxzMTPUFkrpMgdU1yQ1OQc3ZdWkBKfS?=
 =?us-ascii?Q?8zKkYROfdbuLWlTujknvIAcUiCQWiZrG5lqu1+e/NLa2tdX0VTNicOjwf9Su?=
 =?us-ascii?Q?hkVrlp2HPFYDQgRR//NSf9e75rQX8UQIMcbL+ExgJSWdGWAn5RXWI1sGgY7C?=
 =?us-ascii?Q?2/DmTgUw/vokC3bHSS1sl4zNR+MoHL31CqhjhkwnBobRP9Yuy11eIALvNEEu?=
 =?us-ascii?Q?PZ1aahEUCP4vHUJlqEB3rwMFImf8kq9UNpOIYqJlMW9tXgm1utctazSPJrLB?=
 =?us-ascii?Q?QOa4rKpcTKFMw44WsDWQj99YLeVK6P1pwY7bKAv4D7wGgko81B5OC+P0venh?=
 =?us-ascii?Q?pPMeatYRvx+CkZLelnFRzqyK3upDpT33qbuNnQM8yb7M2W0r10Gj01jRisQJ?=
 =?us-ascii?Q?HlsnHieT15YjDE1erxlVMVYhSQ3vhuUnLy34T31JnazyiiDlmubnMK9AE9iz?=
 =?us-ascii?Q?nmxHCjDphwNzyE1T1FINumN6b8heDdim/B7EDu94JuxXrhxnxpYZCSt+2rIF?=
 =?us-ascii?Q?EwVjvtSkZe1C39lZvAl2r/BYgOSBu3HS/UHVdMuN94CTZdpwAXdh7oqymup7?=
 =?us-ascii?Q?TTEzbYqIq3x107w1g08=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa701e5-8120-4e22-1413-08db35ac0284
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 08:01:49.5806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GcpvoEdkdCQn+j5qc0tBUOwTPE39qpQpXwKWooxFPKO8t8oTjbAyea3mSW9FDOvhPgY0bIMA94m9TI6EcFrVQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8343
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, April 5, 2023 3:55 PM
=20
> >
> > Therefore, I think as written, the singleton dev_set hot-reset is
> > enabled for iommufd and (unintentionally?) for the group path, while
> > also negating a requirement for a group fd or that a provided group fd
> > actually matches the device in this latter case.  The null-array
> > approach is not however extended to groups for more general use.
> > Additionally, limiting no-iommu hot-reset to singleton dev_sets
> > provides only a marginal functional difference vs VFIO_DEVICE_RESET.
>=20
> I think the singletion dev_set hot-reset is for iommufd (or more accurate=
ly
> for the noiommu case in cdev path).

but actually, singleton dev_set hot-reset can work for group path as well.
Based on this, I'm also wondering do we really want to have singleton dev_s=
et
hot-reset only for cdev noiommu case? or we allow it generally or just
don't support it as it is equivalent with VFIO_DEVICE_RESET?

If we don't support singletion dev_set hot-reset, noiommu devices in cdev
path shall fail the hot-reset if empty-fd array is provided. But we may jus=
t
document that empty-fd array does not work for noiommu. User should
use the device fd array.

Regards,
Yi Liu

