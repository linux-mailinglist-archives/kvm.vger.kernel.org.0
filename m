Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA89550211F
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 05:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349324AbiDOD7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 23:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349316AbiDOD7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 23:59:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AFFA66DC
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 20:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649995037; x=1681531037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xoMP5rWiY3GaPFJrKeGCOdqoet5CrtSzFasfWq0XYrc=;
  b=B9JAQg1//yQTYGDOREFlcBGY/R1yNU0xTV5JVh9dekmzAHZuxLwTEixU
   g238AydjG8vFeOp5Rb7kPmmCEhPlsZdGsrbquDC9IJ8SE3zC37ilmoV/w
   b6XXS/akdFgwx/QlQTELy6JmSG8hFzNyDduW47jK6fcigOGqNMTZiAx4O
   zO15mAdJOOwdwfRO5L4Al4C18Y6McUvOzXRE0uu2coYL0G3b2WItGopg3
   vOf/RZrlbZYK8PiPZ7cvqznx6YQV2dSKisSS6J6vVOGZiVPqKp4GfF9Wq
   0uEZlbX8yt7mwu9Mk4tL/XsDkSYCUt19H0pbf5ccG//ggrvDoZxs0cstn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="261932675"
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="261932675"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 20:57:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="612591409"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 14 Apr 2022 20:57:17 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 20:57:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 20:57:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 20:57:16 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 20:57:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ju4LzGKlrgYRjhB+8ysWNromQauokatbyrtZ5V2IDGEBuIOfjbbAImmWDkztOPvKrc2Xut0knPISH4Pt0nUT3qFGiW70BmN4GOs1R7GWnHRZpE2Avjj7TbrnFsLsEY8sM6OcMl+Bri2YtIehizkK5lFU2MZWrnKEJX5R7QUtBcJtiT0Md19l1y6xdQY6J/I3C5Rlzteac+kAZ1/+ZO/M/dYrrMWQVzDHckctZIa5lQsY3us4tboJU1Gh/XtVDZOHNah+ZffpmqPpHAVBI39ZNrnSMMslAzpzhbznWFyRnzAv59uSDBorxurOIscPDdijiDMxjeVyF12XpAIntfVsoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xoMP5rWiY3GaPFJrKeGCOdqoet5CrtSzFasfWq0XYrc=;
 b=b4k73nwgQR0JShcO7+FwjbHQIdEGt0bkS1vwbHs+mlOyPhQN4s//2DCTAc+m1F0fHbFNYSmrYqK5KeGWFrMlyUhxikGZZt2ajH/MoHkNP6tSRMrwqNT6C5bR7KX0jGTFIBSk+eHs2vLA6jdVD52fPDuDMOvv+vaAGSiS38aI7hS5I1DVhm+t5Mtd/tZjvPkD/8BX5Q/0h19YsEPCfOdSuL0zJ3xt1AKDx+3WzgH2g8JHGrFdypgT1UX4ztD5C6qnRzJOKhqAbrxQycs+dhfJmDHwVKC3XmEPTROhhI9AHhiLl04/hci4G136dGUuFfNIaCnRGffBNsl/6rDfDi6k+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR11MB0042.namprd11.prod.outlook.com (2603:10b6:4:6b::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 03:57:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Fri, 15 Apr 2022
 03:57:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Thread-Topic: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Thread-Index: AQHYUDAMID4ey+ocu0eeixgszfXfG6zwV6bg
Date:   Fri, 15 Apr 2022 03:57:14 +0000
Message-ID: <BN9PR11MB52764D80F73203162C8E82268CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9621f95-3d99-4647-470f-08da1e9406c3
x-ms-traffictypediagnostic: DM5PR11MB0042:EE_
x-microsoft-antispam-prvs: <DM5PR11MB0042448A62D973ABFCE89F478CEE9@DM5PR11MB0042.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IVSzvJwQQqX04vHZN9xxNoMFahYgZ823ZQ8WN3U2enNRqYLBLUlcNnYT7MArie30h7ayYLIoh2qG4xwzNVzgkfFkFtCmA2PHgGiVDbP7+5fr7F0HVdXPT2P1P9MVeUNenPbAqEiyNxlJnl05phBMTrMUfH8iPmn7yZGITbX7o0Bxnb6jbNbCYO33Rj3yh7REy8DY1cfzTuFiXjsKNtZl8iy8Q08Ury+4/ztJoSI6qNsYdLGYJOOlktH0KPEkRrtLYzm5LcP8l80U9NNU8NkxL6jFIswYunrwkCc9L85opqWRFA6tJWIGecR3+k75VlouPERirHweGwqhoxuiunYokExwTkWQkSqjXs+haTlRTG4OV8EaCW6VTZRpsW8nPfClF84YTVzZqdmbHDfhMFVgbXcHDaxploC5rr8deMIbCjK0dEpxHIryn0wPAFLVxrYcVrOHtphH0hREKhkuadWxolacme6Df4d/ErcRFKBHvrIXrCQ6cJk3A0gbV7esepl+rj0HSooiW3Yxs/1wbQ2xmQmOX9gbdGrWV/0K2CC1Iu+mlGn7BkrWeuG5qtu6zCQ+L4+ArqMqbnfjkDaIrrfhPGflalwam+ZPkyq0qSScQr+ekfjLwnbxQlQcibhaoAgRrq4U+/mWEodfPtHEQXs95XN24h2Nm3uEj70S6SZMXBW6ltON2fzDIM3bEoAoPSz4V87MLA/8iEK4BMvVLYWM9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(26005)(186003)(52536014)(33656002)(86362001)(64756008)(8676002)(76116006)(66446008)(71200400001)(66556008)(316002)(83380400001)(66476007)(4326008)(66946007)(110136005)(38070700005)(54906003)(9686003)(8936002)(107886003)(508600001)(38100700002)(55016003)(82960400001)(122000001)(6506007)(2906002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?skJUeDJtSdUh6jaj6HS26AzltPIUpqP6ODvdi3X2kPOJx+wYyE7hDuCnu6yu?=
 =?us-ascii?Q?CXv3Q6p38dGNbh0eqvDwJJTi10lO95aZT9eh/F6GtV5raM5jxlu2ZVNjitjc?=
 =?us-ascii?Q?A+Sy1FtemB7KXy5iV7gR2lES/l4mZeOMKApGQxHizdwvCShV7XOpmKI4cILp?=
 =?us-ascii?Q?SWtGY07y/kpzwOSv/DKWgQOCdFm4PxOOjqLDIOQYb4jv1oCLsrpVwg8VSR0K?=
 =?us-ascii?Q?WQnmujcb37QDuA75oKCT5QDfpnHNQmjM+/00E3heMJtbf9iinRW2D6H8KY73?=
 =?us-ascii?Q?aPE6cT+SIgyaRHwXNNRlJihxF/ioeFLaHdc4RQ0659uqKRBwvs+nEgoQkgL9?=
 =?us-ascii?Q?K1ja8AiSdSgJuih2NEpN/eVKA7RA97qJHMF/87Ryn/4fu+rCzGXVrizo3HV5?=
 =?us-ascii?Q?PeYyffuz1k3Th9kje1MlhC8zXblbTAlX6PObpwtSoXCK6GQGKcE6tJxmy9Ki?=
 =?us-ascii?Q?2wl2cr9n6MDjVAkF85mfqrA/JXFNBKiIlLfBeGn1Bt38ejyC09dJTJYP+K4f?=
 =?us-ascii?Q?ssmoafuMgh4sZZYFrwL3WdOy9lpB+NuGv/agm6/VmLXFFQ8JHqcHVTYZDsdY?=
 =?us-ascii?Q?dHYx+0+npLt6dBgOddoIvTDGMf/TpLt2pJl7Jd58vs6xJF7JS9dZFwidp8D0?=
 =?us-ascii?Q?ZhCnor8+mOZsxy544CWOL0NTVbgT/8AIZ27lH/7aZDLHl89GCRoPGINdhp6g?=
 =?us-ascii?Q?O6hUOmu5ah1HMkcKQc6Zd2DIYXrAAOjQSH7z+EBweZaf+mr/aw9iovzLTdu7?=
 =?us-ascii?Q?MKFxB1BpKgvInJEe1fqnCfn46v+y73bPYdYia7WyrOq8lLKMW1hx9qGkB2RW?=
 =?us-ascii?Q?E5OsDrMNTfVjppy22Pa/nsI+UC7JOQGIM5RrghmwkppNZqyBIq8KYzJP+PHM?=
 =?us-ascii?Q?IZbxw+6rfbRvjxwQDPJxrOFXSYsBEJveeYmFTYNa9lwcYAcFC5YbQhet4NFR?=
 =?us-ascii?Q?htArwYvyOcQG3mhQuwkL3jnrvNCXNeg/USQEqEIZ7I4anziMCiTZQfalhzjg?=
 =?us-ascii?Q?gfS7RXpEv+XVzNWQEQG2H3y7kDGgrJMqrBfTa0N0Y8Bq9wldnuXKwjvtsbf7?=
 =?us-ascii?Q?Bz5Qwl3eGCHY5ztfK5zHeWWY6DiJXSCRZuvl7NuVWSHmspaoJlEWpWsqp7p+?=
 =?us-ascii?Q?TIZRzuDFu/9oPJaBUlmTSrRsfsLpoNOrPt4UAGU4wEoLkxalKJLZ8F9Tqp8f?=
 =?us-ascii?Q?Hra7MM2xxS0js6D4shqpCAHrOY/s+JDZVDq5yp5qNIamUEPg3MUDHk/nPQgn?=
 =?us-ascii?Q?Phu2IY1tyjTFqUlCa1i9xp05TS/OysBJtwTd+T5AQyEby7lmuS9cwEytB0zF?=
 =?us-ascii?Q?cRmX5qKy+pjSKTnWHCWdQciOCjMeYLb7dYmDDbKXSYgp64Cqa2xmT9H3JRdI?=
 =?us-ascii?Q?mk6zMcbQ2bVjXkvbJWVTLG8Me0UMIMlpK+nHv1hlRsx8nmk3+W+GrsB3VKz6?=
 =?us-ascii?Q?JOdiQBeB1bDDp+pkYgSMpCRAbo1weLWmYEZwtsSYjQV+kUskXOEsCoBu5Ouy?=
 =?us-ascii?Q?i+IQp6MJwI+Xd4Gk7aL0odq8P956qT8riv7Z6PsrmUuxMgCj0MYme/2SHSVD?=
 =?us-ascii?Q?Yrgoc8zeduBWyHaip6xZAxXjjA/zGRFspDvnyorukDcalazF3w6lOz7rVrFE?=
 =?us-ascii?Q?S0+64fNmUqgP28VtfRbvebNrySbVCeEUaPY2P9l7xVUCPZo0CSFOXx3iiqml?=
 =?us-ascii?Q?/UhBLoJPXxcKX9DgEp51+S0qNLB65SZja7VRshltwVZc3BEI3RkkXbQvOqpp?=
 =?us-ascii?Q?XYSkUt9GSw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9621f95-3d99-4647-470f-08da1e9406c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:57:14.2862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+RPdM3nMeNV714r9AV/SSHgTXi+DPqEyUykPgsT+Lyi3LiJ0ED9Bm1jIF7H+U85UP21oujIZRLmaU9KnqgCcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0042
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 15, 2022 2:46 AM
>=20
> kvm and VFIO need to be coupled together however neither is willing to
> tolerate a direct module dependency. Instead when kvm is given a VFIO FD
> it uses many symbol_get()'s to access VFIO.
>=20
> Provide a single VFIO function vfio_file_get_ops() which validates the
> given struct file * is a VFIO file and then returns a struct of ops.

VFIO has multiple files (container, group, and device). Here and other
places seems to assume a VFIO file is just a group file. While it is correc=
t
in this external facing context, probably calling it 'VFIO group file' is
clearer in various code comments and patch descriptions.

>=20
> Following patches will redo each of the symbol_get() calls into an
> indirection through this ops struct.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Out of curiosity, how do you envision when iommufd is introduced?
Will we need a generic ops abstraction so both vfio and iommufd
register their own ops to keep kvm side generic or a new protocol
will be introduced between iommufd and kvm?=20
