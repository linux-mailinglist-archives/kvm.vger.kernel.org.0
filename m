Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806557D081F
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346958AbjJTGJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345092AbjJTGJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:09:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C95DD45
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697782170; x=1729318170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZvQadqGLr10WybmpcnnvsbRz0LYV50Z918GN9E1vI4k=;
  b=LlpRHlRN6CuM20d+2F+Gnd4X7LhsfW5Pvbmxo3C4fq28MtPkbfGrusdH
   eMs7jOg/kWLDydeVpDULTvI35YhelhtpVSm7xSGDcKpiLHlvwlPZfVDiN
   AFacao52ZM1t+4wf7bdx19bAJBNcEY1vUyVhAJ0mrJiHcRj2OfwkWUA/7
   Y4z783chayHpo6SvErwejeNuC/ybpQRNOyz97b7I6qF7iQjt34vveYXg0
   kt6s4OZMv/pGkq/fPBIBEax7cO3LqutD1d3Itz+OM9BfJjNLr0aDuwo24
   N/AkFr74ouE5hCnlD3NvslJrtleOzWhk7GhocfcYlxzIEv8ngXBIdXztz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="366669226"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="366669226"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 23:09:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="733857817"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="733857817"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 23:09:29 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:09:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 23:09:28 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 23:09:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtmygNWuQ6KC1u/ENO/5c2CFQT8TPptcF962y3QFwTxjqu1O8NGnAbFK45ueAho4MgQhn5QXiGYkz8oiZSiZdURlTb5OFbGe9AxUP4htyW8zbv59NOP26FTpbP5VdyafikpwJlsoGNDgmUEiFRs2x0dPA7VVjrmsYqsQfqjzJ/AWutrKtdNyQx/HdGLMEUxqtlLaiKuY/OSLPOv69hwyII3nJFzjUIX1rFlKkU4E/jy8vI+O/ZxFYMxvZ+MlrMhHJ1ZNOItgEl9wk7GfZ/gqUlAhUQ7QnQ9VEmT/JcUUxHDgxD73KuT/zClKHxNV9EfiY5yQOQpe4Cl61hOgQRgS5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLnq8dfrFbxlUvXMa7bSAebWiu06P6Z6++Icv9JXxK8=;
 b=Jz2bnfGaI/xvWetg4J+5oUNeNlKGLRV1z7DqV9S4PbBd4DS/cpNQR93faOhoDwigJVmBrqNySvivUzI8klNpYRdjgDfgJseZK5ryryOkqySmPiquBOqs91h0moyWTjc6yrU7EkRfA1b3r/DEdVkVwpjVT5r8z6ucth+YRkZEHw3mliozn5F6t6G5K847i3bxW5ydFIyIBw0wNoF+G4Tkn23DCd09CIhwTp7SuKWrkT5dWKOu5Wr4FZMl2eSARROcPW/uQlDJPil2JMxDxWUQKLuVVFrmtjeXsZsa5F2I99cjiZmp7pRTCTkDqWhpJb81alKgQ2656pPSuVluVGrI+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7760.namprd11.prod.outlook.com (2603:10b6:8:100::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Fri, 20 Oct
 2023 06:09:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 06:09:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v4 06/18] iommufd: Add IOMMU_HWPT_SET_DIRTY
Thread-Topic: [PATCH v4 06/18] iommufd: Add IOMMU_HWPT_SET_DIRTY
Thread-Index: AQHaAgGluSbZOZ2b7UuFBnzYedbfx7BSMuog
Date:   Fri, 20 Oct 2023 06:09:26 +0000
Message-ID: <BN9PR11MB52764CD9B4741197FD01DDB68CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-7-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-7-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7760:EE_
x-ms-office365-filtering-correlation-id: ac948435-61ef-496f-a663-08dbd1331cd9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qbNOLu97kY2Y3VEkAAJvETHSNsWLoR0Zccjt9OuH5epbTnE067QzU47l0ctynNhzqBoRUODbkgPdTYUORsZC9/o5e3zD8HE6db5SvcwLt7arYL8iQChBOiOb/yovMC/SO85E1lWGEvQEVNubHdzUArsvYHw+MrcGcXypFa6/IgkGGq3gzOO6Ck1mqEjKNiS71MsPzgiBAeOp60h9jhDO7G8HYTV6dqfUqNxv7ybiQeJtl5kWpr76aMIr6cP+qmyp7NHldcDDQ0D+ODNQ+aKrKEpSsA02WvpZFyd4ehS+DpNM4Kq1esB3RXYSlqaEUPv8LGAAvwiU43ewV+DE9X1Oin7Z6a2HJygWF9Ti4QXXR5azoyQZkY2bqirPPLML8cdeJa/a+R66zLDTGhGkXswJMLAjYbbizyN5Z7OFq5tgZbTpgTV7z/BCj3o8PuVmp07zDrXhcbP0xSdQ7vKUrlibLuiqFDN+yIb8boydcwCjxbEcsSP/FOvPlyj0cklHx43io8t5Waf6nuKsXgUdXyRjpFv3YohQcl00tZd+Xmi1tMLrr4DsEVYaUqz8k6RxlOoq0qRnLZy5WCtL5p8DDIsOvHGVt/pg2REZFjiQWH0B1z7wK9CtmYBny4du5E0YQVIp9imiH2y5kCtzwH6ctvczeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(396003)(376002)(136003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(38070700009)(55016003)(6506007)(7696005)(7416002)(71200400001)(83380400001)(64756008)(76116006)(82960400001)(66446008)(33656002)(66946007)(54906003)(66476007)(66556008)(2906002)(316002)(41300700001)(8676002)(110136005)(8936002)(4326008)(478600001)(9686003)(38100700002)(52536014)(86362001)(26005)(122000001)(5660300002)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1h3IHfjGJwvZMcSvUc0KerTaDamJjNLTHqKJmgwgA8F1KMnIooVRluD53K6M?=
 =?us-ascii?Q?C86ULPli/e/DcS3PrgiDuGVoLQecJyri3zF9h4KwWfDLHtSp8sm6cKSEi4cF?=
 =?us-ascii?Q?v0fo0CbHYuQEomf0gOzmbjdxjthd5U8YHrwXlWAJyyD6h9El5ewuXE/39T2g?=
 =?us-ascii?Q?jUONtBQvqYdLfwKNJgDh3oqZDTRTq/kVpXCYQz4Wg9m9lZ9upSIUKksD4z0a?=
 =?us-ascii?Q?k8zZihmL7G2hMBwTcRzpG6Oh10W1VDDDY1j61vHcVCSahKlrRy15zhFV/7jE?=
 =?us-ascii?Q?DcjwCnfmDM1uG0lwZCYkTvRWoT/mKIaUJHt4+GkQ8zU9CxeVtT8jpswOnTD8?=
 =?us-ascii?Q?wmIOo3F3EO+1gws8kfoyKEfY6I7VqyZh27lnrnmtA0CW/qTOOgshlkl3FUaM?=
 =?us-ascii?Q?ivhvpkoKiLEN9vQXM3J6rbfzTLrkTsc3K4eK88a6ZgA9jcKpc4QImDr+e2cQ?=
 =?us-ascii?Q?McdsUsDLyNMU51VSdwvV02LR3SYiTFB+GcD8S4vsC5IVQ3F5yu+PeZ8OU3iC?=
 =?us-ascii?Q?vmKn6Bqm/tF2ZhTCXreBckm27sYyr6EVFZMWmj9O7TBnPt/NszvSnbQc9wJx?=
 =?us-ascii?Q?QQwdm+aRGA5eLGnc4L5a1ZG3CIGFdMbhXLF9Oz9PBmVzxYXoXxyfxhrwB4qI?=
 =?us-ascii?Q?/4zzs/7xaGGOIpYPp+9YmqtwOV2c7h0zNZNJKAvJyLbQGaulssM2DbBXmjhU?=
 =?us-ascii?Q?n5lziU6hyLEzehMJGj9LcettzjnelWbS+MD4bMO1MhJGSZAVH2I89UC2owlm?=
 =?us-ascii?Q?HU55ODBE7/255ikZQR6uiOX5B5XjwJBHtkC/cPqnWcI1cLiqWatOnI1J3tC9?=
 =?us-ascii?Q?/p5rvYK1jwXfpRd0GDUJwCcViNxoEQt2EQY3oalY6XVXS+eaHtTyyjgRUiyr?=
 =?us-ascii?Q?Hj0MfKxNSJv7mWPUPIOeuzq6D7lH16bnrM8KqwMXn25p/i7Y+MZ1O/Fl15OP?=
 =?us-ascii?Q?8qhgMLPsPnGvhES5qGjEkPmKJ5bHYiyK9hQYiA3rpEbVOBsrPZkR9J8WVTkc?=
 =?us-ascii?Q?d3Y/Kco8RIG9WzG+2XUb0GjDJ4DtSuSLrPdPl4yaTpGshuFMAOJMmuBRod3d?=
 =?us-ascii?Q?iq9QJo3qBLW6NlqdpdPigw1W8ghdqOoffpWTO7wvpbqbODHnSP3VCOJMqKjj?=
 =?us-ascii?Q?YqTw7UeKtxkQL9l3eVVcMIf1/Yx4uPq4EKXfGt+RK37F+p6nF8DBsK2tsECS?=
 =?us-ascii?Q?vIQAXaoxYZ+WRBYclQ+3kif8boTZJVrpJilapqZirNIzCYkXg4n5otDlI/UO?=
 =?us-ascii?Q?zcIdW7P2rUxI8UxvSzdsNBhY9hvwcAYXsAFElcMaXf+Ol5/j09XV3JJ3v+VO?=
 =?us-ascii?Q?NI2m023VbCcbrGw/jmPTdC5TPlH6MH5lXDajnKXQvIMhvf5Df9R30zWFKxIk?=
 =?us-ascii?Q?FfG1WCIfE4nwRDg+uyaIBAHHshlltT4NK11v0rgbbrR14wuPzYpL3rf2Baed?=
 =?us-ascii?Q?uWZJAt7ql+Z05y35TLv8L8cZyPPKJdQUEZPBL3l0Q7wNrebwgCJuPAlUDXBs?=
 =?us-ascii?Q?hFBDiXA68igpEFryMZfglDlUDW86MyrZ9YAt2iDV8ZHH1njXLwyMS2sGtaq1?=
 =?us-ascii?Q?ZzhhmMdtIuPEdUa0Lpze7enwCWzf4zRAalv2F0WI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac948435-61ef-496f-a663-08dbd1331cd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 06:09:26.0611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c5t7xjQwe0MTh6eDccd/C26lGC7GhuzbI8eHqSq5RmTAm94Nxykn11EgzZ+3GwVdAab4Wr3jfAm/YNcn8vO7Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7760
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> +
> +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
> +			    struct iommu_domain *domain, bool enable)
> +{
> +	const struct iommu_dirty_ops *ops =3D domain->dirty_ops;
> +	int ret =3D 0;
> +
> +	if (!ops)
> +		return -EOPNOTSUPP;
> +
> +	down_read(&iopt->iova_rwsem);
> +
> +	/* Clear dirty bits from PTEs to ensure a clean snapshot */
> +	if (enable) {
> +		ret =3D iopt_clear_dirty_data(iopt, domain);
> +		if (ret)
> +			goto out_unlock;
> +	}

why not leaving this to the actual driver which wants to always
enable dirty instead of making it a general burden for all?

> +
> +/*
> + * enum iommufd_set_dirty_flags - Flags for steering dirty tracking
> + * @IOMMU_DIRTY_TRACKING_ENABLE: Enables dirty tracking

s/Enables/Enable/

> + */
> +enum iommufd_hwpt_set_dirty_flags {
> +	IOMMU_DIRTY_TRACKING_ENABLE =3D 1,

IOMMU_HWPT_DIRTY_TRACKING_ENABLE

> +
> +/**
> + * struct iommu_hwpt_set_dirty - ioctl(IOMMU_HWPT_SET_DIRTY)

IOMMU_HWPT_SET_DIRTY_TRACKING
