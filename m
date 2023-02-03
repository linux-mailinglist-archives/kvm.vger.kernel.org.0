Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE67688E5C
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjBCECL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjBCECG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:02:06 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59958AC0E
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675396917; x=1706932917;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jk8ExCAwgRbAU8WYLmNRj0vbq5PCw112dE4AeR8kRF4=;
  b=bmz8qsilNjRPF+JL1DD/yAPrk7r7m6/KX9qez43iLNDrTa0KLhgDU3wg
   kCnTKz2i+MibCGsdzIHywkpHmlF0YJH8+jGFdCHjtG4dEwsE2xZ9O1sMi
   SopSzYT0ttTbo0P9VdESRIy0+IADaGVjBAMcgajJ2Yj9RxW+N4aXL4emR
   CmyrUiEK8jFvmZXsWX58KjZc/nv/dFqeknn/6gNNAuvqERyHXXN4ux5ke
   DCQOd2VjMao0zFs6P3/HMaJoSU+0hVY8v3DckC0IHvqPqTQa2M9GJa0Bq
   3D381ZBZKE4vl22Q334sGm1+6g/C7nRzW0h2OE/L+GljdI2leBbBQp4nk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="391047217"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="391047217"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 20:01:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="696022919"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="696022919"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 02 Feb 2023 20:01:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 20:01:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 20:01:55 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 20:01:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 20:01:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyTY+TEBDHKQ9dFF5XED7sSpdvvzrRYfTbdks3JeaZp9ri42a3fT0fjrtVZ968cFyy0DGWi+gICaJFYPW3jFYIXVO1NJTC65w7gd0zXaaZpBxtCtTxQYym7d0dRn4G2Y/NIHRKI3DpWTjw4Xqv8KeIqNxzQopns2JN87rND29C9DZorN+Hb3GaIWJOBrx4+WzQ4roM+Yr0CHXRXYp4lhO2EeccenUolAwXYCP0ldz7DLQnhwsvtIHbrvwVd+OI1le+BxVEOxrz13NLl/0TKJtZwj2wxOxQiRpDXe18Sq6DI9kyaTJDATOYGioKsYWIy2o6IQlkYB3yykMzGHczh8wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jk8ExCAwgRbAU8WYLmNRj0vbq5PCw112dE4AeR8kRF4=;
 b=nz69Cj8XgqaJHBrTSvkfVRWdxHtxZdtd8O2s2gCJmG6BfntoYZhVHKpdlSAaPj47GOkDwBwJ6jEYEv/A7VRnWei4WEpe4X2zOIDDjT3i1nVHCt/v5EHHoOv1aFlA1XkK74gN9j80n0qnKgXp4RoZzCtKeTxFoRje4UsTEFyFFktXjWwUIHNP1tB5gkmKsIfkMRlYaP1C3qXmjV49xCXeRLVy35uKQarq/YB99MX2ccX0M0W5eY9aWx0FRdKmY6s1XtWrC9MMTdmO/22f79jL+vJA/s8D5uhGEWOHYj3AyXo8nDrGlwfjZv0PN6VrPAEDlSkEh7wAuItBsC8RwYLG8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5041.namprd11.prod.outlook.com (2603:10b6:303:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 04:01:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 04:01:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/2] vfio: Update the kdoc for vfio_device_ops
Thread-Topic: [PATCH 1/2] vfio: Update the kdoc for vfio_device_ops
Thread-Index: AQHZNtyn4VVVC6uiwk2osauf9jDmJq68mq9w
Date:   Fri, 3 Feb 2023 04:01:52 +0000
Message-ID: <BN9PR11MB5276F7A5CB7331F17913252C8CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
 <20230202080201.338571-2-yi.l.liu@intel.com>
In-Reply-To: <20230202080201.338571-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5041:EE_
x-ms-office365-filtering-correlation-id: 76561ee3-536f-423b-d760-08db059b6216
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 13ImxmReHuyS3nqLiiBpEbY8VxM0PNDOilPFLDqVBpXd6uoScvsZI5slvjnpTmIaOC1zhy04Ua2mg4mYv7DGlxw0MeMN7Cw/ydIEW80dQzbQwwNf7LMgAE6EblaRPkYVSXzdL7npm/UF6y7DjBr4/gjp1zitqC2o9WRcw1mmmDVLmY65sIYoJuxdy7cC8HHHsTFJ1M1kx6aoCW1diB3/Zc7eM36xTi5kzCLC7S4oLxBAU/9VK0Y2QqvNiuSW5E0qSXVa2BYllsli8tDdshVn6tDRn3O0V0y6znenb8is487FhV7YTndvVVz29M6O/CxkIdBjOhJPxPEF1+ErcirS9P3uAlkjLuxCg4tnAv+2+4zxuSBRXl9UDMH8ZLSftYwHt/7eB0v3WWGk70cNnw45oz79JBXm/XPZ8wZkRfTlCIZYkXHWYWrU3YYXEc06Ex0X29vSxrocuqMGGgGbO0QzNGdV9ogR5zxc215KCm6fJeECMwmbHx6A7q5JAb+P0w0rRLturfIt8poH1NZZmwFQiUSVGvszXbYCUBufn1StFQGHa5MNzHQ+bQbAKTJPplowohsgHooJuvDLssUV1JCb6rC7Lngr//x0JT7nJ0+FApcqsMbRvP4r4/DYr71ui4A3JxOWZbBZWRhfMCaoEps//Lrhmv+wiss8mF8cRIqeFvbTROuEfo43baCzcMw6SkYwT668HDXy9W27lz1njvmlqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199018)(122000001)(316002)(478600001)(9686003)(38070700005)(41300700001)(26005)(186003)(86362001)(55016003)(71200400001)(7696005)(52536014)(8936002)(82960400001)(38100700002)(33656002)(6506007)(558084003)(5660300002)(66946007)(4326008)(66556008)(66476007)(66446008)(64756008)(8676002)(76116006)(2906002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qd88OQdhTgj3DqSFTd2GsK52c54anzBcx2NcVgBWtbvHCvXpV8U51YewFvaK?=
 =?us-ascii?Q?++cwIcLi14a85OIT7lUYpIjsXeA2AVAJ/ZWwnMK/B3/DZNKTSTkUiwHUna35?=
 =?us-ascii?Q?D+Wlw5imtiDe3v5VGNEy+Pwdss2X0xsvigzPf74czs6qgVspnCO8y00PFMAg?=
 =?us-ascii?Q?jxTNnYK+7jMVjxWX8CuVRg3wgPja1H70E2Po1m3TOODBWodb3kFjfXeVQ82C?=
 =?us-ascii?Q?IdC7A811xm6xgSzUcNXQb3Hh4BjBM8jg07RrU2/trvqNzOw89lE4VLeZLKbm?=
 =?us-ascii?Q?Gh6OFsa2bwALwRUT0kkmllgT9GhSJpab+ifGvsPvOxTknxCGFTaWNdaiPPqd?=
 =?us-ascii?Q?KhN+tvFP6fn2/f+li6spzDqb3tkF3ds6SrnsBLSuzQaD3dzNDzHlOgL7mlJF?=
 =?us-ascii?Q?tE7A9XHJU/No2rHHkrSXd5kywq1CFYv8RPrUUdCJ40Vqc6lHELToTz6ScmlW?=
 =?us-ascii?Q?F8npCYqSKr3i1FFKaJsIvqgejxPwPiLhdgDwYe2Em6E4UnL+xgUcqlSh+Xj6?=
 =?us-ascii?Q?c3+9uQrNJPbzqpU3JBNAk28cl4vVHukH3ZBedriexQK35OnBON9qV6jgHhOS?=
 =?us-ascii?Q?5IzaI1P3FK4ukYneuseSmQgBjsbqNNUCpdFXvatAbBAxbEox4EvtfaGj/WFJ?=
 =?us-ascii?Q?bxE6eEwIZphog/JQbk510g0Ih4FB8imjeOH6ZxInLErFxuQ1GaUUv6jsK72m?=
 =?us-ascii?Q?indWDJ8fk1aEBtTVYIQcufIExY2EKnzCQlaCKSGpa9yL+/KFGdKOmRtC9QBT?=
 =?us-ascii?Q?yVWx+OxENHO/8JHSfoubtmYnny1yBo98bh6YyKGCY3hQe8UDJMR1TiS8tbNv?=
 =?us-ascii?Q?juJxE60ApdNdslOXKWyS8pS7rv8za55K9ILTrokWMQN8K2Eh1f2gZdl2ShHL?=
 =?us-ascii?Q?5KbVJF8afyBzXbF3kcCsz5gaDYhNTXjU5sNaS+iYAjeIUZFk1BODvgocAJa3?=
 =?us-ascii?Q?ldD153PGtMNCoCkd4T+YSfIEIMsdEcNoDOIs8uDTJ3/F6XQO2bbt4FvwR6Sj?=
 =?us-ascii?Q?osYy7yBtSgHDzviTCnyHE1mjP0TtNl4G7eG6Afe8Zn+1eIcQrftWpotx0IsR?=
 =?us-ascii?Q?8PuyJmo1sZ75FTeI7iMBAAGGJBaQJZAzaxyutIuC3QI1scwHHSOKcsx0MirD?=
 =?us-ascii?Q?Sjgwxfy+iJf4FUHyZjL5bdKzX1IRVl4jk20lOrwWu/5J1lK57klDXHXJgBDa?=
 =?us-ascii?Q?fdp8A/QYvPJhA8GkvXe7jzSpaiVUfywpLUI6/PgBetl1x3g+w7hvw9JTJqL9?=
 =?us-ascii?Q?OfZMM/kVZcSPRaoJnNJRFLuvEZqrw6fk+YQEqPPbRvoO98U+J8du6Q/Q45N+?=
 =?us-ascii?Q?ehm1/pEiL4JmtbhJfIcR3B3KuIAQQvnKiLFnAUgaVs2fStQpjuj5iRoRY4Ll?=
 =?us-ascii?Q?ciG37rKseZJ3Du/IVjqbVVdCCjRoVGoEsxy/0pAKN2cujK/5XXEK5VDbduwn?=
 =?us-ascii?Q?NDuIVDut9kxfT2g7GUxEOYuly/m4lB/b6FU3t8KKyDqsEB43RQm8yQ1ZjLtd?=
 =?us-ascii?Q?lRqSBHNgnDw5ejnyhvCTHZBAJ0aG70/wy8vFMpXlxATTROLcYP1NRjMrnNOS?=
 =?us-ascii?Q?TL1DoTKz4UVALdIzJ827xo+AtHxJUhyOmZCIcnkv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76561ee3-536f-423b-d760-08db059b6216
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 04:01:52.6322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ii9xeqU156le8Mj7GeLSFMzHPBiRwmgdhSzbau1uhHuQtMnSCwNeK7qV4neE3PVwRER1LFdbTA0/QawhkZfAoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5041
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, February 2, 2023 4:02 PM
>=20
> this is missed when adding bind_iommufd/unbind_iommufd and attach_ioas.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
