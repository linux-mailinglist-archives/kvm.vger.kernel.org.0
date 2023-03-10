Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B366B3BAB
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 11:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCJKGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 05:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCJKGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 05:06:46 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6467710C11B;
        Fri, 10 Mar 2023 02:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678442802; x=1709978802;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wSh2XJ27X/OpA5CuISnbaHNqRIYTFucpuJN/HeDamM8=;
  b=jGVL/CMyPE5mFQJe2R8vpEoEJ1gkQSwkgNjHm9SegacmvW8Cwaig1jvj
   kJmWwrTpSgRR+FO0NR4XvIdnCVKm1jcXuUog3NAf+LWUuM/S6Kri0PFV/
   tw59IopaYL2T98Cri9jP1+hg9chdoje4sumYoGchxdAHY36er+v+fXUkX
   MQrbY8oF6uxJ+FMtGdq2wn9sicP5W1VUmZT5Idr6Z+ofKdVkhcGSJTCk/
   0eh/r5dvgg04AgU15Ykr3FTUA2qgfXuhOsHluMs7Wn+WgzgAB1vNq2B4a
   5kBx2TvAnIZkdjgqXIUdL/2h3PjtGViu9+L0Wk9eLAxBxhZHuwax/vkqw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="334171926"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="334171926"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 02:06:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="1007070456"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="1007070456"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2023 02:06:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 02:06:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 02:06:27 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 02:06:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fu9Q9hCoCsM7zuS/loyoyGWtfMWnnmMfrj6LsoWcNLfhRr0ll5XakY/mVFacdqHBUUf21wNWmw5Eccrkk6EgH2CnNawRCjLM5sVmEPUsNEPuf8l2YyeMQ3WNG/9ACweDiLxnchD64d681eCJkyqVx/WLrp+HCPmThhPM+yOQfO0gkpe04L8Y785wwu1vniWeNALqcr4H8r7O7r4X4NjiQCOciCk4kUfB8l4N3nvw/TJV6YJcO+itveGrrf2KCow+YaKUkD56l/b8g+acMJNlbwvVTxCr+p7KmAVgj8nMinxbzrbZ/eUBgxMOyWnzAU1t6Bx+VDpgiMh5fp6OykE+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUxAmIV+8tt1bicLpPzr+usP2UJg8McTSTZFtvfchz4=;
 b=QDcN95zw8d0oZ6adMvwjWO/TBLSUdueyHSs6pzXdCq4fLcDVdkMhvlpOde2rDoEbUbu4KrYw/u7oW++/G+3on1NEaF5qrrtieFEOFQBOGRwmTKmneg2JZkE67+fP0eCDnUEkBlS+pdMCE/6D9WPq6f8vUjuuDji63stG2IjsrCdgPk76oHWSXx82eH66nCkRrM6ofZiru/GSK1Hw6uyOt98B4SPFOCB/LW/jP2AS2OHt3+1I0tAL3zp4oze86K08EoWT+8F0hs4fWlOQuRcmeS2E4ksGXvXf6N6vdxZvdZ75cOaaurdj1GhnA09FM1mYvSjHc2rAocmWblIYvqQahw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4821.namprd11.prod.outlook.com (2603:10b6:510:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 10:06:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 10:06:25 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: RE: [patch] docs: vfio: fix header path
Thread-Topic: [patch] docs: vfio: fix header path
Thread-Index: AQHZUzcImq9sZOQ9fEan6qsyYF5zpa7zyUGw
Date:   Fri, 10 Mar 2023 10:06:24 +0000
Message-ID: <DS0PR11MB752974A10D8188F267413BCFC3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230310095857.985814-1-jiri@resnulli.us>
In-Reply-To: <20230310095857.985814-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB4821:EE_
x-ms-office365-filtering-correlation-id: b2b3e0d7-f3fe-4db1-eafc-08db214f1b69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W3USdj+OLzz2p5IK74H4zDQurhBOUAKHl22B7gUIyO8Q2d9epfaqsYddCcMYIPUHxm6pq1gQM4eblDlxGLtgYnKhjOTSQ992dbRYC5XNqfP9rpEtmZljB+2J+59Uj+YYUvsY5VhtL4dOWD8BSYQCMFZvSr6lvwnSwG14Uysu2qBwYs9Q8dYep3oPy8bTMNq1YC73UK5XL5n5RorI36d3JHhMQj7pLWNTtATx4PgKg7Vj2Blz0fLYbTd/RbpVWKvVsuuVB9rjH0Bir68Aj0GFTHllJaKabSVXoIVCtyNtzBEfuQfBGBTouL5kD4OMrLrfhAV0vvLeOgGkFWnTYal7NppV9bFxS44zRiZjDyQrpDO/wtozYpGPE5J5mKoEnXBiI3IBze9D2VuEIKtWCknkK9C6JnyHrBCGmKz4ITXtAV7BaTdgXWUSru/TROUS69WZ3kr+IRWMiEI/JpW16YZGvE4r7L7VHeu6sZK/uDHTuvfUiDFc9E86k+jiXHPfrzOKjms5D7Hv1sK56xQso1jtsRyAPpI1OXa7EN72rQ5VbxiIO+LRqSxLGq4IvgY+QskGxpD/YwAkADeo+JckoJPkdxMo12qeLlxYFRHYzAJhBx+9k7Cblkx3FpShftsgulS/p+ot0uXx0BNdIT7nl++J5oi9gRr7LuluWoTl7OXNSI4hg63NzpZ66CEiMVK/2ntslk6fl4xiKB6Ki4AKwicL+9+/MYPLUQyxEcJxFMzxHtU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199018)(33656002)(54906003)(316002)(110136005)(478600001)(8936002)(7696005)(5660300002)(71200400001)(52536014)(2906002)(4744005)(66556008)(76116006)(64756008)(66946007)(4326008)(66446008)(8676002)(66476007)(41300700001)(122000001)(82960400001)(26005)(9686003)(38070700005)(55016003)(86362001)(38100700002)(186003)(6506007)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LKR20pJ66a0bSGsXOi+bdxMQ3qNQDLaY1ST0DJsJekDszFtYznjztAN6rWGO?=
 =?us-ascii?Q?+gmDn8YS00ZWBPALcItSN9Oo1Zk4VxKjqsH2/Yj9EaM5EhV8iUpN2ayvfe/I?=
 =?us-ascii?Q?/tSH4Rt2OaPhQHvlPt8VxEB/0BgwbRF4qDR3ob0DNSu5fPK9PHdjiBL5Ysxf?=
 =?us-ascii?Q?ej/i5pJUvhgw4jgdHtgkOYXD3zuDa7IL6KNXd1BJ/x9nmJYtGXWWPIlQgZLo?=
 =?us-ascii?Q?fauTD2CLjEA9S+3wsoVXHD4W3L7212BXhu/AJ88MvJY8CPOPFyBn2FLjbvQ1?=
 =?us-ascii?Q?hza3DyXpZfLJGfRF3Y1Akm9Hn6gXBtG3vhX1F/9KF+/FS/uDKCR/O8mM940U?=
 =?us-ascii?Q?zhZ19UCFECzKzNiDfJLNnK3nv0JKqGN5vBaj/vLOffd+dme/OOByQ/0WNUPa?=
 =?us-ascii?Q?NoNEraaWZz1qpTugn0eZ0mOs3knb6yc2SkGJIcssif+YD7cPtEGbuUaTpLfo?=
 =?us-ascii?Q?gqr78ZwZUDMT4jYTkM8RqtvwNZG8Dd4pxSrgpG7weEOLEXWCMXrBB9sSXmLQ?=
 =?us-ascii?Q?g/CH2imiNO86qjPAnOcj87jZ+aU3SB37eK6QA2ZlwBgH1Jhz6ghZJ2EfKQRg?=
 =?us-ascii?Q?Q0DVNpOj2YNrNtUrXCAb8F44OSfLNRcpKHGV3/gQSXpLEDvugYQg4PBwlgzu?=
 =?us-ascii?Q?iNcRiP0ZciRG7NkKFZJ90fDRZuaQPiU908CcgKf/zEg4zr+b597hSG2/eEu1?=
 =?us-ascii?Q?y3rmd/wA0NazF/MvByo82Nr3qPS2xE/Z4wcLSndJlPXVydc/b0IRfnZ8Ixx1?=
 =?us-ascii?Q?lULg7eU2WKAx34cBuLr29g4XGPIkb4UXSvlQllzNVBoB3EkM8WMFVH74AxP6?=
 =?us-ascii?Q?ZSAXsZKdE7wmNhRJAl6ZIpEP1xASdHkt4qufxAMunwPRozcdu3JTVQL6QuYb?=
 =?us-ascii?Q?q1rgR5u8dfTASZBekChz52y14e395XqZyLMNX+h/d05FHTpp8tYpNXMtDl47?=
 =?us-ascii?Q?FBagsIITmQ2uzXdZlrjmCqLFPxlDpkNXqco8l9DwBSlbLwHtXdCX4P58Es9F?=
 =?us-ascii?Q?/QJNalK38Lxkyv6opD1iu7yxsa/Vgo2LEL7uM7bHjSQ7PsYw2A7ZUQ/nbICC?=
 =?us-ascii?Q?BML859HOMiD2GZhQAL1eKUq9cnz/w/CvH+pJVSKoCZ3Vfrtchxg0fAPHfPnE?=
 =?us-ascii?Q?YmoVo3nvwHhSnEalRw6lcJjnblkfCZe26HDlwLtnLSKpeUnAeq+dB2vjVJZM?=
 =?us-ascii?Q?Mm2VjmRedhnScyiKf3o/C6YbKu5kSzyBdRbRQHeJ4K76l6MV05sDdfJFWKi2?=
 =?us-ascii?Q?n/TahrBq01Rjp+tnE9wOCVHg50UXXKRvZ1JXKMsBbnqmpzxoNJ2uBcbkYol4?=
 =?us-ascii?Q?5VFUOko3XVxC6mkfXqcjEP1Az9wEJ7toAIPH+K5BO78I0OM3rKtkOfmYt4eu?=
 =?us-ascii?Q?IdDwb9qIDZGQxO6BcfDPp5P5f4JpMA2vKqd6a6aIZSDay8Asa2NOSQb26lYp?=
 =?us-ascii?Q?WTE1YxDbSRl7XJ/y7IdKkjao9BC1IyH/2IB5tmjhlZxVWSQwR1PokE1Xqsnz?=
 =?us-ascii?Q?O5Y5wkEaqJ5D1B3h5mnHmF4B4/GxNGwpdJpWY7WYILzgqHY99hDRVQ0pLJaW?=
 =?us-ascii?Q?sb2NOH3sXbkGsyzgdM61kax354Gb5SWO72IjvjDL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b3e0d7-f3fe-4db1-eafc-08db214f1b69
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 10:06:24.8959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SZ2CALUOS+sdw95gvv3gz632NJYFp8HvAZVsG3/T1KWF61DESpk9jn7nxB2aa2XYIgZJK7VKT8hFDsRbhzVzgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4821
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, March 10, 2023 5:59 PM
>=20
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> The text points to a different header file, fix by changing
> the path to "uapi".
>=20
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> ---
>  Documentation/driver-api/vfio.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-
> api/vfio.rst
> index 50b690f7f663..68abc089d6dd 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -242,7 +242,7 @@ group and can access them as follows::
>  VFIO User API
>  ------------------------------------------------------------------------=
-------
>=20
> -Please see include/linux/vfio.h for complete API documentation.
> +Please see include/uapi/linux/vfio.h for complete API documentation.
>=20
>  VFIO bus driver API
>  ------------------------------------------------------------------------=
-------
> --
> 2.39.0

