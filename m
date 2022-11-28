Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12E763A331
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiK1IgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiK1IgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:36:14 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899BF62D1
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669624573; x=1701160573;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=THO7AFTmjZrGMnfhVWaeTwN1wK5mm7VUl4tHlh8qBnQ=;
  b=mXCK8MUuQ5pd1kNSyP2CCGUJdpU/6qyEUbCWGRp9kv2gaNwaIQ4/e+4T
   B+tIitfo4Pt7vDp0FpyYlZwWbrUQ9NmQJC5bD8CTkcGfjPxJwc9B20KJ3
   R9rsIeNT4jjzD13y/bDpxQ3EQmqO6/nm4iOOUurNv7tsD8xqKt7UdP7h/
   UotFe5jlyWbskkB0XGMRbwYWP2ZCizJSgA3LqTjyCYLoL+80HQKeDHhaD
   5KykrZMiS98pAtVOZBSmm4jsLRszKXDm7X+JG3x6i11f13E8xJik9CGIW
   efD+vNrXdXKCFct5SKnUQLOixgQCmjrIvJNwGcHtpXQAEF7j5cVTapAqC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="295163726"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="295163726"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:36:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="749286905"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="749286905"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 28 Nov 2022 00:36:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:36:12 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:36:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:36:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebFbES8S5J+IqClhTmHrlViN29+SPW++SQ4pUAY5HpS5iuZWWbJULI7bemF7/x4JX56ZpkRXSPP1vwjqpMn6SLQzGcM0yWh7Ch85JlO3vmni9Uy+cHvZy/GfA6Uo8DwlBT5z5t5It9Xas/j9ff2KzyUioNEQx7Sk62kyF9Z2P6rzilsvCSqn2HjtAlgJIe4zChx3jLxhFDIHu8aGyZjIAzD3uBv2YFAmMK/tXCT0vwOOzwk+jpaJWA5JITlxqjo/CXx1WtuHg+wMUp1jVPuM65pYsLJmHGD0Z+5QiL2mobI6njcET2j/MtCmWL75mOGDneKnpIZmDhSI6MI66Mu4ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THO7AFTmjZrGMnfhVWaeTwN1wK5mm7VUl4tHlh8qBnQ=;
 b=kAC6B1MX6XW4d2VVdlenzP6cNN94r+HUS9OwUMs6RG6PIhURABYZQYlFDRqwSLWSO5U+L09hKCW+/3Q402dMnl27ymQBHLHHBAx+ZOARaGnVIq4Gi7/kktbgHrBuZX98C9x6iXrftE91/fH1ck/y2rBS70VV8pR/mmdqE1ATzjS6FoFkMH37HzrC8KMxgs9XOZ+B9Y4lu66TWNgegSUHHEvXHedaefpIQ5Z7xWKOtgKg5E3L+6824U7AfXj61tdXNdUFpJfyLtXB6bCQhTe6RzY4MxuFU6yw8HmrcRTpmVg0HKxPsmv+owxkn7EyoD4L8c1yswZzmHfoE6nk1EPDqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4947.namprd11.prod.outlook.com (2603:10b6:303:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 08:36:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:36:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 09/11] vfio: Wrap vfio group module init/clean code into
 helpers
Thread-Topic: [RFC v2 09/11] vfio: Wrap vfio group module init/clean code into
 helpers
Thread-Index: AQHZAAAdUDf5aeMaUkWYIXSmolHaj65UCNkQ
Date:   Mon, 28 Nov 2022 08:36:11 +0000
Message-ID: <BN9PR11MB527637F19900281D36403C848C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-10-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4947:EE_
x-ms-office365-filtering-correlation-id: fc3d5951-8fbc-4388-6440-08dad11b9a6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TJ0+DNeh/mCiclo7rSihySrNUP9cEAZmMzfEV4zsnaaVLY9Pp29AJHltLoPhxdo+6p3pOOZme/2ip29rtqLKr+A9uOwK1hCAq7Z++QwrAHtPKaRST/MXCRta2/y0MB8AWqgPm7FpDd5KV5o1xdaY8TMKsg3afflfyxQWIX/CykaXOvWu7cCsBTixJDqFNao5qtlMgomgKgTGNWZnpxQ0XfWpLRmVHKy7VKvYxU0In6uWla3ic5nFB5blo4CDNDTwGcr4fjEsSxFOYI1K6+TOrJODb8RLvk9F3Ux+juCEQDG/e1Dp58Ilb01HyksCrADTdC0Axm0mbpTEVXkOGDape8xdMnyXctxG1zAluL+GKEua68MZDCzf1dtQ3onwruM8qSzL5CXAul+Zs6SmIsDTqDqK0y5EQU9/nDFxMFR+7Ki1hrI7hUdb5BYzLExeAZmPZFCp55arMprEYq7BnvdUadViSGwMDYJq1v1jO/8HBY6Bleq6xw3gqab2W+GvR06zVsFandYf6hDcaPeYxdRRYBkUIE4ZVLgdRqBS5450/yQ9HozigrE2cP+4R6RUl1tfm2sK5HM8Flr4G/aNmlV9LdUH7+D4FGd/FlMSjpfjFHDCfOiswqYNoNTp2jmozNFLdk4nf7xbcSMgRAeC8yz4ay1Yvt23rYaM7dFYU/DWioPR5s+TgF+eCWnj8P1kHDj2xTKbCfLxqGRVLXdexfR2bA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199015)(316002)(54906003)(71200400001)(82960400001)(7696005)(122000001)(6506007)(38100700002)(41300700001)(4326008)(4744005)(8936002)(52536014)(66446008)(186003)(86362001)(5660300002)(66556008)(26005)(9686003)(8676002)(64756008)(66476007)(66946007)(33656002)(55016003)(76116006)(110136005)(2906002)(38070700005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e/OJEC0he2iHPCIxfrkN54vELdZwZ8wV8VDqSUQKXzrJF8MJ337i9Y4/cdMK?=
 =?us-ascii?Q?l7wqh6hqt6fpCRKJrcdwDSKf1r+0tRyOHlmC+HkorZCoRi3PcpTctc0zm+Jp?=
 =?us-ascii?Q?f/q5KtGg4DAzFUjY2sWnPD+VnQFZ1wKyEQ66dfkp4stQ3RFTRnCU5mTOQZNj?=
 =?us-ascii?Q?tdL3tFTdcbymvo0n54HkqOVcuquC/gVvdvAfnyxTUA4DsYVeaxvFkA9tE89r?=
 =?us-ascii?Q?0roGCpVZYC/JRh/Kc6VCOaKicxbg5PM+zpxUSbNVulvV0kf+qOVPNkIqKMCd?=
 =?us-ascii?Q?JwNppNVMk6XxCEUBauEv65UgYWHDDk89/tldMj/6GxtARKaIG2l/s+5dXAnS?=
 =?us-ascii?Q?egv4Y/PE8iLre8ciUFKSVOqaRZ26R06swwmBKg9uJdeizpDQ+55PRhzP5VdE?=
 =?us-ascii?Q?wvqKNAoBfDSC6y5qZ1VOAR+paVewwGyRKqHzwEP0QxqTZ/VHqWw7ARHE2R+4?=
 =?us-ascii?Q?whMenhmJ0mV6aVyk+sSVJDXvfslyz11+VVNqmITHXrAqnd7Ev8C1x/Ih0Oge?=
 =?us-ascii?Q?QSK4KwDQwhbX/YSSuA5MFPZY3pApibjBwYyxrOblwxq7N9sKterSACoE3Gx8?=
 =?us-ascii?Q?DM3UFaLt/5tN91xQMBTOZ4sil45gJ+hicSZ1StV3PYjdb2Chuc/6T7vobZsu?=
 =?us-ascii?Q?r0l3VsgdA1et2GOEWDIf2yGm6VbK0+wR2C9yERBM7VD8+xmshfoSwY9kHexL?=
 =?us-ascii?Q?wKYAotGfvbd9DriWefYQxj4qmH7X9p2NkTXwAmNLAIiPmqOYkN6kXHJxhuAL?=
 =?us-ascii?Q?F1EQXg+GC8YhFLLVGiSg4M7RuMpeKIpbFH9gXmoCr8Z3hST0wlMrrXLG3dXA?=
 =?us-ascii?Q?VWQbuNoKY6UfzrvWokE1oSYa9s2l1oTZFMXP8hw1zgv+U5LQ9ViwC72lieDi?=
 =?us-ascii?Q?JTVrwmRBeagKwiz1J4ULj6LBvMOBZhX+WwG2piP67NYopwnrrh4X5BbR+xTR?=
 =?us-ascii?Q?9OWOisOqcZ7kK4TYVgTxo1oKjgFROeHtsztoO1U0DrFGVthZ3DyB+MQ+E0GJ?=
 =?us-ascii?Q?mGKThNoTx1/bKAuVqggDnKueJ8pUkBSFrky98QT3ovj4d2IsnuAXey0Oog0q?=
 =?us-ascii?Q?csMTK9zdDNf7KAI3hIYPhJX/kfy6EjHYitqdQoPQr0whevLocXP3IIK29HUO?=
 =?us-ascii?Q?h4DzKy91qnEX7NCYhRWgw1K7Xydg6U4O8Htkoay7I1zitUd5/mnqkhJF8vWy?=
 =?us-ascii?Q?g5m2IPSn09/5LsdJ4QNpDrkFM3D6EsCca0MIPI5I3qXe1T/tW7UPsi6v/nFV?=
 =?us-ascii?Q?vQIM7FifHBhoIPEajqIAKAUjgGZkFyAH6I8oKEk3X1hF3grKv1viXwY/b5it?=
 =?us-ascii?Q?Vwilxke7i8LvMDhq5AwBNpYKmXL5QBTrP1DGAdCcAa+iG2aierzHIbWP+iEe?=
 =?us-ascii?Q?J6cmw2THcafY3fLaxv4O6sJeipKhi7n65PQ/BY6j9VZo2Uf6PnJ9Rxw32tOo?=
 =?us-ascii?Q?zFSx784DbIXQQ+qd8j20qNQOoKAKwTNgxufINxRM+ne1+vuL/0p2HfOsLlMr?=
 =?us-ascii?Q?snyKGM+WoZRAGitkLoSdgmqxXZIF4C3qpfEiVmdEKnDWi35id5bX6GojJS4a?=
 =?us-ascii?Q?gKe78KPYb7+PB5iSMsGNKta0jJPQJDpjgugU+ma1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3d5951-8fbc-4388-6440-08dad11b9a6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:36:11.1060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pdzpw2jq50cCs7NjbaPHy9WSO41dpipzo3n9uSAY8Q2kZ3YRIOOQUxDJtSpRCPZwC7Wn/QIcynWQ95nIoKgUow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4947
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
> Sent: Thursday, November 24, 2022 8:27 PM
>=20
> This wraps the init/clean code of vfio group global variable to be helper=
s,
> and prepares for further moving vfio group specific code into separate
> file.
>=20
> As container is used by group, so vfio_container_init/cleanup() is moved
> into vfio_group_init/cleanup().
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
