Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811EB7D07C3
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 07:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346301AbjJTFqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 01:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbjJTFqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 01:46:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA2B1A6
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 22:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697780811; x=1729316811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4gQePHol3zMuDzQCAvZUQsHOm9kUOF6t6Zzm1J6kLKc=;
  b=CMmaR8npMYK2ezM+6dqfy/t3ZIPJwgoWGh/FKaq7QgpFWb83K2iWmJmt
   Sn6i1BS9Uzrv91bJkTjXQW7Wjsgtc+EgU7akcqkawclvIsu/CbqD/6MSd
   QZS8U6Jj4yxoY6GW7z+JlPITko4uEQ1MP0f1CNqq7uHp2Fx3z0RcppJiN
   KC0s+CzGCdPJJOJK+V4GtJKTQCZibg75ckOTGqFCfH/i4VzyJvZXBr6OO
   diwzwoac2JmhR4A6fGxzX9J1I0m8Yzi2nWx6XSS/xXJLzgG5DI+vXMM/s
   JVkqyMcZJV9obW0ugxdBKFzwqFVj7VIWqXqps+243gePPjzQcfDGsxlDq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="450659418"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="450659418"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 22:46:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="901040897"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="901040897"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 22:44:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 22:46:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 22:46:49 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 22:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmVLZmjfxFq/quqO5wUUJ6y1I22YrWD8nG8Otgphl5ay9arYqvoXxGqMledjt8iotVvRcna9/+eTknNJUoOc1fE8FhOGCiQ9h5h6iX+0VGDoUgrwB0PLnEeBpbb9KY+LQUcYzdbTtkM2TXlGm5BbXOKYFKQcCRYXIbl5dSNJiJoLUGLy3Vc047jNKe8niCvj5A72mySHvkOkRdX7b2MhzRE463d/HpaWU7Lz9iIG+uyi5TtxKZz8TszoAr7ZBY+awWhySIRqx0fzPOBmne1Z2PVIrabPSrha0zOd2wh2NlbvANPMxftoT5aV5Yemse774O2u1SGO+eOZQuUhaACgoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmPlwAc3VQxGOfol5+X403oMmwTwDMcYg4H4+HtdCH0=;
 b=bmgW3MoaHJeFRbjQlWVCgNU+lRlLABSLp0AGMmbjUUvX9Q+y68SUvgeoLiU6eRdQmtYJJUANnZTdxv3B2hhNlLf3DUbETGM7+NR3Rf750cVe3RZyD1hRhMLXmWNx0xkKljqeS9XiUUXg8/ctGcuaacnz2gpZw/GaR9BPIF4vfuUXzXWyGLMRHNVcOTprmEHRb/7X9u2Wasu0uh1O8bW6oUVAvdljlbYw8LfK3pXmS70iiSgUVs30PC1CLR48K7bBgaEtAuzo32kVZXZ8BTaNKyeNcZByThW7wLsTSKIvu5mprexYGuczIVXD8cdZww+ed0n81hRvYmsPa9SFz4GFGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7902.namprd11.prod.outlook.com (2603:10b6:8:f6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.26; Fri, 20 Oct 2023 05:46:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 05:46:42 +0000
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
        "Martins, Joao" <joao.m.martins@oracle.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "Yishai Hadas" <yishaih@nvidia.com>
Subject: RE: [PATCH v4 02/18] vfio: Move iova_bitmap into iommufd
Thread-Topic: [PATCH v4 02/18] vfio: Move iova_bitmap into iommufd
Thread-Index: AQHaAgGZTM8pwmwHHEucUozJY6xiaLBSLX0A
Date:   Fri, 20 Oct 2023 05:46:42 +0000
Message-ID: <BN9PR11MB5276AA3C4115EBAE13F100F28CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-3-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-3-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7902:EE_
x-ms-office365-filtering-correlation-id: 3eb4d7c0-c51c-4a75-365d-08dbd12ff05e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6y45UF9qOTsgSaqTAranHChH8+a8sCp2cW3m1ce6e3bMvsyAmhf0BFfEFeauad1adK/9YTCLd+b6dLuXcIs/85koe7v1LBbcqVFA2GxxblniwqVlgVaCB8Yt13n3538IhdplT103dLzYmkoEYahA7+hEOpa2eWbQ93PncHgxBbNbrzDw0BSRTmP0icTLNa7yqVP5mMw2GaoDxVSKDXPenaJG2XilrE/X3tjl7LZQIIl465A11Ju38dwsrhKGF3Y3bXQyCSeGvp5mVG+iXHD46mVow36oXXVWhgRpKRKBKrDqCIqZnh6o5+D5m3Dg9IWNc9GKAEeqChKQZuCtvd5yaONzIYIFOul9uymlCjdTIDj9YML1AfmevdVuhJ/pMLQ9fnfEte2BjnDSnI764EwdxT1+4xHUC63gUMVdH0CfzT+5seDn9dD5M4aZ17YD+rTRdTjMWZA2EV3NUMXXdXX8DzL4m+yMqvkKetLEcsQZ+wbcFA9/OCPQZSRB2gHTxoi8Y+rkm7Hk3sEch3pZljP+gNJ/wVhMOD0IbdD+dIgsRIt0/mpTYy37e1OEQ8PGdJJio2eZOFJSxqTzXU0FvaynZqqPu8oF1wMOc/fNmFKRUQ9/975Nci+MJz3BZ1GdSqHj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(39860400002)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(55016003)(110136005)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(316002)(122000001)(478600001)(82960400001)(86362001)(33656002)(5660300002)(52536014)(8676002)(8936002)(7416002)(4744005)(4326008)(41300700001)(83380400001)(38100700002)(9686003)(7696005)(6506007)(71200400001)(2906002)(26005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ly4pBiAIOwPa7bVOvr9hdGRNe0Xp75PFR1rD1YuhVEBchFKpDVZWLpTe+ic+?=
 =?us-ascii?Q?KYDd/F3tUELAvV9ukOySitYqGP4wXU32n0fH4iTA7r0lXTPLGDpAERq2IH01?=
 =?us-ascii?Q?5FCiGCHz6tLzCBZeZBC7I7tVIq+XcmVfSXUmSmutOSAzPFhYZRjpjNRpEIC0?=
 =?us-ascii?Q?8gz4D0lNEl2WQGEhH1xyZnYXJjKOh5lF2iqhmfeF40LTq+qlU08yb4ODklNe?=
 =?us-ascii?Q?QvF6sFq0Jj9IgNROgIuEmjFp4exFIvHCsOZ5mBonscm8y6O8XJ2KMsc4GbFq?=
 =?us-ascii?Q?ewrwajsi7eSGYhA/14BQC1mlmhCBzXbQCgpBBy2wxBoaTmxhB7oxbfaTzipn?=
 =?us-ascii?Q?dABbMrjvo/rVlVLLzbWCBa8k+ZY/AKvk0/C8taEiT9K1JSnNRjl1L5ALezBh?=
 =?us-ascii?Q?23ok5hIFcHhiL8DHeYQFMVzNpnW3kc+nTEzP7KBk/qj9OZOiTuxlsDM3x3kv?=
 =?us-ascii?Q?1RPgGvL5UbEMG7oXqxJsYaaNc5f4IhQRCliDG/JHOJ+eW1WPMDMp8yFU9hG8?=
 =?us-ascii?Q?PeGmUJSJ/fG3C8qWAtMwnb0qM2HL7DOA981NMTpcmr4TRRL4FES5XQVdFZgC?=
 =?us-ascii?Q?tT0+JTKwknno0o89ys60If4mI3JS81OjsY2N2ifZ7pDeV/wJSE1jR7/AOVS/?=
 =?us-ascii?Q?wAVfjSjHLr6CsDIFh2iYuOR6kwWyodipXU0zP4eUxxMK4eNouX1KzczdLTv1?=
 =?us-ascii?Q?MozWBxUBt+rDUuGot/Q1lX/kKlYoh1mLUC2YxFPFt3lwizscWilK0+pRg8IY?=
 =?us-ascii?Q?FUE3R4r85+hQ+I3baYTcYktJcwesycn4SW3/U2G/M7T7LI8B1qNmHYtZPQX8?=
 =?us-ascii?Q?UjagqyFk4hrJ8gj9mgJ3QFR/8szbUa4MMqSH40lVOjE8ncdGs2lfwrDBYNWu?=
 =?us-ascii?Q?QRHvRcM5XCpp2S5IuDZCwLY+CXEd2u/GHnV39KU+f8dsQwZz4PPK5F9a+e0I?=
 =?us-ascii?Q?gOwaH0J0R2GFIEwLBibViOp5j6UhKT9cR2jPhZZwCrgENWuZxkEamLDd4fuu?=
 =?us-ascii?Q?JLR+/Xh+1XFaxhaff8AnTevvW/30Bv8XKGv+bMhC1iZUzadyrQ1cf1382N3O?=
 =?us-ascii?Q?fWyY4h56klZrNAW8XrDqg6PFBigZ507a66ey3wXK3FHgcDViUNH9nJLUh7yL?=
 =?us-ascii?Q?GdH1tAoM3DJblWV0uJroktmT9TKEtUgpO+LfUWRfoc4iN/jtDyXoh3Y/g65J?=
 =?us-ascii?Q?Nf5kBALrhERUf9H2Qlpg0AtKtd9/es5l/LuLtr8L/qRKGxI5SPNfwWW5Ocdb?=
 =?us-ascii?Q?wuCHOAjN1lQ7VokTAJES8yflQmK94kwFwTzrsRiCMq0CUySN0DB4BPoodeWa?=
 =?us-ascii?Q?DWdRbpNFhkYdrBOrmRvZf0vGuiZWYoYxKZXQQCp65bmQZIFqNMjAmMAhz5i2?=
 =?us-ascii?Q?/hrI98+VO8/ALiBU04cIKstzuYOV8brEPeEkHjJwQkU7qrKmZMbyOtacfnmg?=
 =?us-ascii?Q?PxM/Aph8xCOkn3/ThxxoCDt1nMUdppWm1gqEBdf1WAZlj7HQI3bCxlJiO23W?=
 =?us-ascii?Q?1y8xJif5ZHw74lJkGKS6KF5RvKdTJpsbF50IQi4kaxZGIC5h8qdKDYM9FMal?=
 =?us-ascii?Q?/dv9k5rt2opn4GpC/odXYgUXUMPUBLeMNr6E5vLc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb4d7c0-c51c-4a75-365d-08dbd12ff05e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 05:46:42.8986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UujxdXXSaX5g2UjbRo+DtthhjtkfMJ63YEw3ZdOUNDTZZDvTy5hqVLZxL4ahW196TZGCeJ2vy+9KfOtyXFRKFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7902
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and
> walking
> the user bitmaps, so move to the common dependency into IOMMUFD.  In
> doing
> so, create the symbol IOMMUFD_DRIVER which designates the builtin code
> that
> will be used by drivers when selected. Today this means MLX5_VFIO_PCI and
> PDS_VFIO_PCI. IOMMU drivers will do the same (in future patches) when
> supporting dirty tracking and select IOMMUFD_DRIVER accordingly.
>=20
> Given that the symbol maybe be disabled, add header definitions in
> iova_bitmap.h for when IOMMUFD_DRIVER=3Dn
>=20
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
