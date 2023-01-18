Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A2F671786
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjARJYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjARJXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:23:17 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5045B5D13A
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 00:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674031663; x=1705567663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u9b0VHn/Z4S+g8VYKeW45KrkpyNBxV87DZRYRaHvoM0=;
  b=Yc3Jo48EaZyUugNVCdquXD1U6zWu1vQRm5fCPB4Xf4hmN2YQXB/wEmFk
   PZTm1C43/X8vrMN+BidkDF3HGJD5+egm1b6JSaUB4bRNBunKmXCDlotBZ
   2yjqv9/kOis9gFkxxEPxX9c7ncAm8G6mSgsdBXNz3tX/MotpugW7QSX6f
   2Yy0wCbYBkTOOmCKkSJxx0o3POA5mWbv3ugl63hyYJ+4yq+ocpCQyWDJs
   UpN/NYLNpKNmBbfNPTjqCE1R+vRAKD+z8kfJUa21Zc0PitgfIl038DbmH
   DH+m36moutq5AYB17BgwHUW5fH2If5nr2zQnoRFUJXa1kaOBOGAvjjLb4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="327008929"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="327008929"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 00:47:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="609566406"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="609566406"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 18 Jan 2023 00:47:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 00:47:38 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 00:47:38 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 00:47:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gA7K1Ssorv4QynhEJxtJT4sjGd7y5Gaej0G7iRQquEljROidujP3oxjNCEJE8mmyeVEWWVmU6uQc/TUgviDOvomI6G1TyB7eQ7BYPEYZWm02hAG86/GWd0Wl++2JLOsXn/PtJmYm/Dh4Qxgz/V6tlbgiCVoC/DB4easWCdbbzotGWFXLWZZScL4yNOa5eMYHXCJR1KZipPDkUZ15smvFpaYGmXxQG0PDqpwf/kI3Z9ssMhV4Snmlevl0+VjgfmQVYh9DnuBjf3wFQ36HB2gs836HvLWkr5hamtRMXmegMBCYYo0HbDs0WXsUz45OQecUFxdHK8NPoycbSzdzqweCuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9b0VHn/Z4S+g8VYKeW45KrkpyNBxV87DZRYRaHvoM0=;
 b=g6/R17lN4Fp0AlIkyI/6cYzlC5ahiPgsa8e17auIJZ0ASAW0/0R+xF5LMK0Op7aCVGO71PcLkBXE4jgfS+uqpbxjaGqtPBuGEN7nwul4jFYeLq6c24QMJrWZojcOZpi/wa5EwvEbzBN8hPA31iDHmOA+0l4ttvybRY3ONf618Hr266rm3C+Jn+fArtcXVybDa2/vv+HSQbtfN1kBQL1iyfCdPtu4TyxqZq3y3Ax8mhM5JKZBd1yucrjK7ATnWvP65BQCwwJV6CK2rAqm6EZkHckdsZPNFcm7HnHPFRmV82mKz/2O14XyitUw/VpbuszZ0B4yypk4kuLwe7YvuT9jgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5582.namprd11.prod.outlook.com (2603:10b6:a03:3aa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 08:47:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 08:47:36 +0000
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
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 04/13] kvm/vfio: Rename kvm_vfio_group to prepare for
 accepting vfio device fd
Thread-Topic: [PATCH 04/13] kvm/vfio: Rename kvm_vfio_group to prepare for
 accepting vfio device fd
Thread-Index: AQHZKnqUMhDElVLG10KBd0Ga2ul0Ma6j3fjw
Date:   Wed, 18 Jan 2023 08:47:36 +0000
Message-ID: <BN9PR11MB5276E625ABA260CEA646CD6C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-5-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5582:EE_
x-ms-office365-filtering-correlation-id: 56b3bd99-3a00-42f4-126d-08daf930a622
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E976F/hpaf4RJrpWuJzDiSlvd1utczzhSYtSRKp26g4+ctUH6Mf7DrjagdVAoxjKO4Nkd0kpSAb+Jb7CLgPlXfNpmVkgiN63RHxwo7A/HcufWFVteOO1TrmiLVCBp4/1HmNQmRS5XFQnBahGUNfzbMXf5zAw/XEWbsN3cYUFxlH6bRqrFOjzFLgTpPePaRaQskKMCbtpOj+ji9sKcCvxzKrhBLapYUub3stlbHR03dnSDin4BbcA/LexAOk+UuMsArMfjWXvfvjNILkKixnKpXGAXiVNbmt+V0f0Cc523X6mGzgpypCWPN0t0gGPznK7ZaprhZZgs7HKvH8PyG7br3Xd/VPfTi3EkB22Gu1cRfc38bM6uwqN988pALyIAYHCCfuLtcnFnolan7K3bmsAXhEigyUUGmuTyFTHHUPTR0/sVGaAqkXEan8tSIQkC4BwvX54/BycGUS7UGrlKlGNipHJyuYEUJc1/MSNXjt1Q4CNS7VPoNyg0NebWxSAFIT9Io46hQROmoFk6Sh2nkwuzbK3qdnJ1i5vtbh9hjzwNfZRA+VvGIIgZNKpcD8mZhNnk6pPbJVd3Y/R2tUEYBAQJ9ntZxmDWdLi5/nykLBcmu/y37rg8+rWSqMpL9c+tdkKNx9uZMCe1rRAI7GXezKL+Y/Jwz6Eqo9kT6Wf+w3j/YMpjvphA8mvaFtxEQZkq6ho
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199015)(86362001)(9686003)(66946007)(41300700001)(186003)(64756008)(8676002)(4326008)(66476007)(66446008)(66556008)(26005)(33656002)(76116006)(55016003)(71200400001)(316002)(7696005)(2906002)(110136005)(54906003)(478600001)(122000001)(6506007)(38100700002)(38070700005)(7416002)(558084003)(82960400001)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c+kcDrDY3QJNcDg5tAhlgV0srJfJhYDHhZbGtS6KY2BwmwMR8f2UhwDraxBV?=
 =?us-ascii?Q?oGOOKzyvovNREIo3DfRwYboZ5two7VYDpQwcDn8VpjVvgVBvCgynvifHuxZk?=
 =?us-ascii?Q?8xWfyt+47ZAqTtWlv+5O9CrFN6ICmApLAvWwnjYdo6bk8X4ZwbMoKuWH9piN?=
 =?us-ascii?Q?o7I6c9Jr5LzniQkqY49VqeVPz4dgVgiWgT6HtzKuFNPw8/r+3CDOB7jc6e3g?=
 =?us-ascii?Q?JVcFzkfdp6QNdJiBaliIe/NltfWt1SPgLvn6toNCw8Bkr5B5cLNh8pEwAbYZ?=
 =?us-ascii?Q?z+yD/QW2NkRyJ9gGtJfco7Z4LspNHKnIciLaQ+G4i5sg7LmS/iljmoouW3PP?=
 =?us-ascii?Q?Zar975I++xNqvBwpnPs8l0UkHm+McPbNM9ekpBCoh3XeRoYnfpeLsV5RQnZm?=
 =?us-ascii?Q?Kwhn8AHtt+hDsBG+Z1fsLBiwTeDO+lXbkYco/PQsPsqSy9wYLl2yv0yhQxBr?=
 =?us-ascii?Q?EtHVTipE8G5k9eSHDJ4bjz9jD1djQbSN9huS6xafnITgEVIqO176VYO/LLIj?=
 =?us-ascii?Q?N+qzUJ7HOYjL2eCAY/j81k7kt10tbr0jYIX3kwg44vDhATFtt57+Q/K71YD8?=
 =?us-ascii?Q?jQ74PNVzgBDazjawo+myyh4cStpvRQ65F/nQbfZcGmksyebeTqEt0Dt/KX/e?=
 =?us-ascii?Q?zSbQ1qJlCdkQCeto0tgGUxSAxAVO9unsSd/zDL7RozozYKZ99dlSQDCERdim?=
 =?us-ascii?Q?ZM/8efSBcz2PCSvNfjpgSfYqSrEthbetuvbkkJqittnijoGOXW/Lnuf8dJaf?=
 =?us-ascii?Q?f9AHpMTVfxpK2c85yDVuyxjzSh7dkj1rUxXabBaCbe57ENAkd6U9gA5QpiBS?=
 =?us-ascii?Q?TK7zFDP+sWErgM0jf7+MrC4vlvhPmOPh1EqAZP9zrmCVFa+lBM4MQDeVf4og?=
 =?us-ascii?Q?ZfovCLgFmfe1phR6qAwXFqTz6vj/jzhlvP9/M/2VwajgxRzKpUesydVMnzEh?=
 =?us-ascii?Q?mOKl4y2V/U74rx02Ij6Y884fmppTm5llYzOBuDKMWnECR3vd0AWC1mdwvZGP?=
 =?us-ascii?Q?be8na1MmL51mykTn3KPmiK/YLDMVZ2u9xpi7bmIjZS8RUFI5jX5GBZ7zVNYe?=
 =?us-ascii?Q?WyRRsQP47VXsXQzaSz3WKfYAX01IwimuoWcs/zCtkx2GPJo7fRsViwjLlB0s?=
 =?us-ascii?Q?2EdrzkdGbR4wkNLpevl79JHE3Eh5WTnEdgTMy7J9ZQSr4jR/R09BrH133MlF?=
 =?us-ascii?Q?ZFjUpAjON//fJA6G1mLVKkpocHnncZfImwSDQVbYRW9WvQjSkutRDlqm4UBN?=
 =?us-ascii?Q?ZhTvE+ctplDBaBYAHt24bVUBb75KrF/jKiFzhs6dL+lrmMPTn4nMou0y/Lgw?=
 =?us-ascii?Q?5E+Ulz64urvk3WecMGVF61ZmqW0b0ILAH7Xkx0ARQkVDZ0cJQhvbWsXXLnsO?=
 =?us-ascii?Q?pVIOPBMVKZe+TXKMCXQDhG8kbnN1qDPHYnejWkqe8HdWHyY04lOOcXZFS9KQ?=
 =?us-ascii?Q?l35GrpmCoc11l9vmf1ElTIAIdEKQE+CronL7umyvHqeZkq3JR2mhk+eo30As?=
 =?us-ascii?Q?zj/wnU8u9v7FqFcqtRQzOjlA1xBJ0qgK32xwrclRwR/AcwA+rYRnLlQvPzYz?=
 =?us-ascii?Q?UZHMq3bTsKWRM0CfVg/CZqLr+73vLwEbUuihauvj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b3bd99-3a00-42f4-126d-08daf930a622
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 08:47:36.6719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PrkOAOKstisr0RSmQc/dSaB7/ABVsaGrItGm7it8Rs+HUtEVeoOb37ZRjTW9X4mKCcVytZocd1k9AGzeu5VxlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5582
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
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> Meanwhile, rename related helpers. No functional change is intended.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
