Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D49B7D09BF
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbjJTHxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbjJTHxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:53:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5673FA
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697788384; x=1729324384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ah9Jzfs4t2QTpqn660pVw+3/lrcRuQ7oRJ522liycnw=;
  b=JAshKWr2OJEC6QB/DbzbhRjLReuCQqfV5t+yfagGL9E2WkBN9mrwOtY3
   x5CdZaR15JS7q2cv82l1xhD+7z6K766gfTFZxD+1kuQdtvwE0osGfQjWr
   BrERyA+c/vrahvArgexbB6nag552VgZoA4VeJ9rmMDHy49jO3mDEW9X5C
   7HOn86Jlyl/FYehwgXNMH6d2Pgn0Mzf3RG0+eRoJu/DKAs/0W91jw/C9r
   bBc2BhOBrn6RZA0EoMcGJvMOvFsJL1DRIhMtuYwC7E7L4Tq/FP9i/brBW
   lM6dTqr8iZjgDgtj4psDEps69ByeMS3+KdXVxgG5DxwjyRHfqe5OVpn8S
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="390332967"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="390332967"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 00:53:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="1088663676"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="1088663676"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 00:53:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 00:53:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 00:53:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 00:53:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmpLdRRDpXNmvzn6ah2VwPAIr3yufHEEEePBycpGTDlMCV4MiTuUEaDk66ZfZGS1wpdSbCVhu+xs1Z56Efva71rdwVS9sReBMyxQIMTfyV5kSrn8lXE7hkDBOlAv2c01bSsHBem+sa23Vcu71gIjyZM4wm3WLkGoFPHDBdFGd8rw9Jx6/ghBhLwFmyu49TtJPovckiD8mCzuGEzyq01iqFfF8hNDYTyOJggJiOKd6Ud00sCOK2oWxSgDvFq62uPJxYCYPTFXuKUkBldmpQ/b6IjCIjEsy9Ic62O2DeEBktXMlZV1YmE+dhqaK/lUM6cUt7yk+uEOLAeEvoEGc8nn+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwn0Pawn4OzUnjXU1fxfEQDEVzsK3vpgoehwVwlPH98=;
 b=mpJBrgmEKGrefx5DbadQ+1GMu0ugdMf0l9vP/zrgi9dLDsqvIcNacPFqbpODDcxJp2DEzJ80JElcx+cBSZLpU+n1hMr3ghq1CY+AjYbKTAdfVwr+A06OD2+Vww5Xn1hceBycpFD4MPOBa+AOlHx/SjlPIGPKtLOt2VJAhCtUIVwJQoxAh7LpIXbjYjYse2JnIPP+r9aU59hdYrhkW5rUqPWjpKqOEDjWoKmXPPmePq/maZ2vOaVfSe31Z2rqdjiCPGd1ao74DdGwTHjbX+mRVQb8TDscNUSqpK3eWZ7mMY+Rxd1Xo08q7xssFziCF9QdGv4QXrsgKOXwn9HIBVKgjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5285.namprd11.prod.outlook.com (2603:10b6:208:309::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 07:53:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 07:53:00 +0000
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
Subject: RE: [PATCH v4 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Thread-Topic: [PATCH v4 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Thread-Index: AQHaAgG7hOZ/iuMrl0GVgcuEDP8az7BST/gA
Date:   Fri, 20 Oct 2023 07:53:00 +0000
Message-ID: <BN9PR11MB527658ABE413A50034647D9A8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-13-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-13-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5285:EE_
x-ms-office365-filtering-correlation-id: d2e21fc9-bd9b-42a4-39b5-08dbd1419523
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w4klalrlRxWBlsIfVaif+azDsrgwJMJrmOm0C9KlqnjQTZpfctOhRt0anm99mozvShSWexrBJcQ7cXHpIlrjM62242D8b9tpMUkTHjpw+L4bDiBzV4SmPOyAzi7mkitAsQXEqB7bhL1luYSJnyJ8KuP/6bQY5ZSzoZlW1o5dxEVO196DQOr59BzSYbPuaaBN9NS6Uawb9U9zlNuCXRr/wBUsaUbroCh0A1S9vDDLYtggpY6wyGRehjYXcwSY+wQp3eG9gq9vqoN9JAZ4FwIpoB4Va3qPD9aGrhoyBHgSTjbjfP4d5WU8Ovpy8rf8K30a/O3B9B2tefJwpFeXK4S/lROXm8l9t+HDi0WF+JNt/7YEF5Z495WIY6K9/92gdebtZkjsOSFVqi/kFN6l/I7hEo/ksTjirQqPR3MfGvZIjdoFsMkl7OC2+Q1aqFjAxSYpuYgsb8hxgX0hp50PZxwJ7HqW/jOmYk5bXQbhZn+rwb8eJeSAmfGk1s+X3klKNyuD67VB6M2MkmP80G4ONt/xMqA5WAtdeMR3LPBnKlyPZW/sRgnyRv9cFTTRcQQd0X/FiQJiLcKb38BtY82eGqvOskY6H45rbPoLcptHy6ZI+58GbkDZ1SOY2Eg2zdwSvQmvg2ERK+k4t7X5AUvSl3nL/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(346002)(396003)(376002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(55016003)(26005)(71200400001)(7696005)(6506007)(9686003)(41300700001)(8936002)(4326008)(7416002)(8676002)(52536014)(5660300002)(4744005)(2906002)(478600001)(76116006)(54906003)(66446008)(66476007)(66946007)(64756008)(66556008)(110136005)(316002)(122000001)(82960400001)(86362001)(38100700002)(33656002)(38070700009)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FuA3S5CNdvXlkjnuXoixbuDmlygf1QZ2ArhuxRagEvC2CZvC7SacFwavO4MX?=
 =?us-ascii?Q?PdSqERkb5l7zlg3vYG0MnKCqCEYQZlmuHOBhkQrjaerQyslnXhtGxH//iSz8?=
 =?us-ascii?Q?P/A76MPAQ1YTnTz3pf5bsyEu8OOA6zjGJaykZkWQP3WmD8kD5dHk0+DSByGp?=
 =?us-ascii?Q?xv3pZm73Hd8oZJOK74GKDJki6ene1Wcj7+Uj49EnIOWweIr8DRlDpy9UI6Mn?=
 =?us-ascii?Q?9zKrBbLvPLqPgczUTcYe8MPX4yiM1omoncQqgWU19eonM0RPBTJz/v7zzij5?=
 =?us-ascii?Q?IeWUXpYdBlk5y0UgRptLmI4ZFbZHGIBNA/BQg7OwejNNmn7r8TPpsqLsmw0M?=
 =?us-ascii?Q?kE9EG1ZI6Z0WY26m9N3ltgYW5ba0I2FTlWXF/bWCOga3vO9bUUsDA3nkuBfE?=
 =?us-ascii?Q?yUc+FbhqEB/Y4YXAhoSyOFdhouBr+TsFl7Ym5ho8pUBwB+SvcoCaVziyvd/w?=
 =?us-ascii?Q?Dqi9K3m98ay6BkPGzbPyY4nIPbjsL4B3tG7LqcJqkB2Nbjl1zK/uGcWrPy3z?=
 =?us-ascii?Q?bR2Qy5199GMpuzE1K9VsSbEqtBmfYlzVpCFkbq/bcbn7ZHG+oxZzY9Dy0aSJ?=
 =?us-ascii?Q?XJiTt9+TqyBkyWePKWI4PFKxp6ESW49XX9McujsFMjUy/v7g2oDuEsyDf6SY?=
 =?us-ascii?Q?+oRqqY6my4oUNggdHajGoAn6ztzuymYycrZgrMlOoNtkr5JLw5iVxNITsT77?=
 =?us-ascii?Q?hgh5JXBSoQX9hwLcGr5qULnn3khlc1wHqpvEV22BksaVnf+o8FYdOaRYsm5k?=
 =?us-ascii?Q?r2O66bbRMY5qmZj1g2OzpFV2ug7ZlGxAZAjLhSxkHXOjzrzmQXBQvZRkpZBL?=
 =?us-ascii?Q?kBq1xHKZeAcj6dlpQV2sHvb9nT9BSGWCfQp7rIDDrtQTq/0yyuXZoiDmwF4R?=
 =?us-ascii?Q?O3nJvRYSFsc2Efd/vFTvLS8byotQWcAB5vKoYqOZvx7NX/47MOABhkuzr+IR?=
 =?us-ascii?Q?ujUi/rbEsYqsbRjGTGevQYgeY5v4Hd0ZP7CF88sl2mN/H6yOh/r09joOpEDw?=
 =?us-ascii?Q?jNiveR/TP1Nybuyu/x8uw2sLOCslSOpyHEd6/y0keCvzQtPoE/ybiEvXvHcv?=
 =?us-ascii?Q?vFeX4jLRVY1QIsJdFur4km5oQmhR/buT4PLKvwT5iCFSvzKYH40OIbp1Domg?=
 =?us-ascii?Q?uk/FHenV2Z4mbx+lOboP0Y23Z8/+6mi62M07va/s+xRha1KEd2SVZegB3157?=
 =?us-ascii?Q?qzeSaXfqFVTBLTEo0ktewYsUF/rrvB5wR+IRPr401rreRCUdeh8Z4sVx3m19?=
 =?us-ascii?Q?CpPkepgG0ykycSyL1iXx8QW6DFONXNa+ndkR4PLQXOxtcxK0zpbKrrtSqLt0?=
 =?us-ascii?Q?pvehxk8ieT22csmbvSS+MOIsJCmzcNTdENU5qP1F2sGBOuTS6sAHcJEQj5At?=
 =?us-ascii?Q?vZpoFF+OD1dSaVVC80BSZMfb9HdmHzLogfe/1DSvEG4VuDi1Bfz5rnmEjAc5?=
 =?us-ascii?Q?ZQmstKce2GgJd6RGU0SbNSBEwgDDoQTo3P5VWalPGruxoTLfJtWM3HOcchPf?=
 =?us-ascii?Q?+T2UVqkjpIwMM5Acs4PSAjV0NywueQS9PQahsyGbq6AOuPnYg3ecPaqCoCIj?=
 =?us-ascii?Q?Se5ErYMO3F6lsf02hNA6Yo/V+Jf1NQtaU+NxEuXz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e21fc9-bd9b-42a4-39b5-08dbd1419523
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 07:53:00.8208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JA+BxdyckgsK/Z22Es8q9XK6tKfwKhLZWAdq0wmadXFU566/mdkVgZbgJr+0Ow8kStFIgVn5bYMcMWDFlwD1Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
> +	if (!IS_ERR(domain) && enforce_dirty) {
> +		if (to_dmar_domain(domain)->use_first_level) {
> +			iommu_domain_free(domain);
> +			return ERR_PTR(-EOPNOTSUPP);
> +		}
> +		domain->dirty_ops =3D &intel_dirty_ops;
> +	}

I don't understand why we should check use_first_level here. It's
a dead condition as alloc_user() only uses 2nd level. Later when
nested is introduced then we explicitly disallow enforce_dirty
on a nested user domain.

otherwise with Baolu's comments addressed:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
