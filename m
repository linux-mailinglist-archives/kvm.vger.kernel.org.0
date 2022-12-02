Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F464027A
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 09:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbiLBIs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 03:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiLBIs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 03:48:57 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCE7AFCDA
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 00:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669970936; x=1701506936;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JbVNhXg1uwVN3CIfp280hYn/+BnIWPaQtmMeBeCjtXk=;
  b=W85YtTz5a1Xz9Scea3YxGUMWtQXOYjNZtWySSPYYQSC9zTofQ2vK0fTh
   pJGNZ2zTX3COj2rV67ZS7OJCv6SMfpG1nZSk4KjdV9AVII7m270RXKM23
   v+FADHoOmlViulILJUhnZZP1Cb9lLftZ5fXkZdLBDrGt2MJUadLhwxMu/
   fnjlNsw/zLgCt9lwm2e7LaQRO/X4/I/W8MOq0vVAf9hrP8ZnFr8Ft5q1i
   AtInHnfqSdli7xRwM9UCd5okgccJl9mbfls5Q+wQtHJJOsJ9WZRrFlyAK
   TrAR/i+M+bg3kviZ/Oay/QGkUtt2PslLqz22Bza8h+/0FMpQfAXAP0ryS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="303511201"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="303511201"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 00:48:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="787219584"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="787219584"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 02 Dec 2022 00:48:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 00:48:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 00:48:53 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 00:48:53 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 00:48:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqf3zMP7ly6vlXw8Sv2miIIyAmD8xy5CXYr0pyl1KbrRTTsS9Df3orvg75RTrs/WxoZ9d6xa3vdx60gfrCcPxTznA7IvKgcci85tsWTL0VpqNRUuyD+oSCHPil/LXLWw4Uk1R9o4lxRn+ZW2+GqF4Y6xSiDhbflyPlhPwPUD8rLrQBp+33Ecsl6QVtWmvj50iZwqYkwzaY3Jh6+28nLGNfGRkJ2slZwWSH63nenayOje3vA3JwiJ/rj2/9/iSmvmZSGMocUq8EDqmGfirDORxsOUd6V4lj0y2tcecry4htcrPkSFfHZ1S10j5KQWe3/V30TGq/ar+kMf4JHxfTBhLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ywx1Qb8MAaPRf/hwyUVx5gU71sCo9c/negCACU1m5yk=;
 b=DQmxY4KT9iSUnf4rNrWWlBBxcxTvGhvry3iaddDaYBQ98oBwqtb+v1DvzxNjNvdEG02Ns+gGMOyf4SN8riJ1hnnRFOuEBUUiJBa3P/9qy+WqXRM2QRe8C4tAfP2FVdwQDZhTY3y73b2cJeZYll0QE4QuS7lrDOeDGn+Aidq86iIG1zCXwsCKjvhY5oHk0LFIKKCRriEPjsCcXRM6X2rOV87ISWeBw1cBKYqZQO4QtZX/ARoz44PWPm/xcSExD1SY9eWjB4fBjejTFCA56Qij5qjMhBo1+KcG5HNjsZKtkNvUiBdfg8e1r9JVhE/B3WsS9tq8PlB4uj1BmkQDc/Duaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5230.namprd11.prod.outlook.com (2603:10b6:5:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 08:48:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 08:48:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "shayd@nvidia.com" <shayd@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "avihaih@nvidia.com" <avihaih@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Thread-Topic: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Thread-Index: AQHZBZng2HTEvVuQfEGVJ+Qa/2GadK5aRSpQ
Date:   Fri, 2 Dec 2022 08:48:50 +0000
Message-ID: <BN9PR11MB5276F73EE06AB80BB5039D998C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
 <20221201152931.47913-3-yishaih@nvidia.com>
In-Reply-To: <20221201152931.47913-3-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5230:EE_
x-ms-office365-filtering-correlation-id: 99acb3b8-2e99-4122-5a87-08dad4420904
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mlKQpVq3MtbQT3J1HJ/4yHEG5B0qlEDUV6mFAL69G2HqWukgA1UiQIakN/E/EfQNki8O8y/lzDUs/n3RQqI6nkr0yuX5P9rb2eGUfAQen4W99ZTqbtj03gFRRhpka0zltNHJcVdz+h6+NKkbC5I5fiKabGyyFdkKxlsLt/cKQpqD/igf1gY0CLpkx1xjRzn+uoNIJ/1m9lUOh2MqmO6RsCwjxqoWCUv0/W+2T3qnHSmvIUsh8o43+4Ni7grxfAAGz6Q2KQp+PX/qSma7Y5A4jAeHTZGcudVqbKOQoMF7iIdiEGOnMCB+57E768Y+tDt+Paa/3vYBd0RVmjXfF/KmYkRt88j84Jz6SHlysUxUeRmhLdjmCZbZ6xNtiKM++5+vVxZy9VZPMrFDAeCyAF8O+V2PbKMYX5gVQPsPkFyxmjHHIlhOXxpQEpT23NqCwWqpca60rASlQ327tLYj3YYBl9e7EQ1l6b/eNKyw6LnEMAPnV6+pvUxJYotVn0dvFeyuPQ9cxmXseFClpX4ZaeQn5bb7C5/VbD0vJ+sd3nonmJfK56p6RWj7Lr+v217cRl3UfCH4RYRjTgURLpWte23mrdITWzhBSEuNRt30hwAAIuI6z1Uk27ziId61l+s6liicEAfPQLyXADvXBkQRjyXMnijw/z1clHMYX6DIrMjc7wBvvaHM9a9CxCyYw54KyoW67a6rW4OeQ63HTISgBAX3TA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(33656002)(86362001)(9686003)(110136005)(6506007)(7696005)(71200400001)(38070700005)(55016003)(38100700002)(82960400001)(186003)(122000001)(54906003)(7416002)(41300700001)(5660300002)(52536014)(26005)(478600001)(66476007)(66446008)(64756008)(8676002)(66946007)(8936002)(76116006)(66556008)(4326008)(316002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XrsV8EWxfLaxCeeeGGj260hEr66+EgJ0uYGV5yqgYHDGic8cAjETUfmCh+lC?=
 =?us-ascii?Q?2BhHilJ1bEWGW6zKaGvq2520PBTxmDkEGdOgxumAMwnsIf9Yr66pkzoYeLSo?=
 =?us-ascii?Q?6liO3naikQOli+cbM5ushlT8iEZgbAzQnzvXXDbN/vsGubwHIwo3ZwRCuQn3?=
 =?us-ascii?Q?Vn9rmGPmZchzzXp3LArVHvu8K6de/24izgHkczQv9dKuAVlfunwuDjebOmiF?=
 =?us-ascii?Q?TJgGJxlY0JsosAvJr6HswxWmXTYP6KWXw5mM7KjICLUf1YKj9pPIzUMA3Sp1?=
 =?us-ascii?Q?jF3CYSeJcQBAkIwHuzusbpcLAm1h+Ee3Y8CT3D5PK5ddKC/2/3kr/JcVt+Tx?=
 =?us-ascii?Q?qwqzqBVzxUY33+T+cjezL5KAoYugsJW42QVQPlkgM5N+kSyA41eA8rK4+CMm?=
 =?us-ascii?Q?9KOba3CVmMceiSYT7zrmJgG94sd8TBMYID5KL86skfb7/BKeYknT5xe8gT00?=
 =?us-ascii?Q?KeByn4rTM2M5cGcmLIVuSAr9jBFt0qF1jS4FNPMkhzUCWoc88kpIWhG3yACH?=
 =?us-ascii?Q?bf97DxhdaQeig9wv+esUMx522I6Y6QEO1Y+zJoSHWgLIUp7bHNlOsXwXcsbn?=
 =?us-ascii?Q?C1SytjtRV7DXgLNKeEDRi2Y9ivL6XSSqq4bAoPFVFRVNrTEf+F9rTYUyoxOV?=
 =?us-ascii?Q?PUxAb28dguILN4AjH8zIF/ICONDgaE6flM8D/jW/AHsFwQTSB2eAzMq0ZML5?=
 =?us-ascii?Q?5Dj6Yb6VGFiIFfksHvFXhAug7Hh53C5ryIiPZRs3xTnOJKZlFXUb4nvzEADT?=
 =?us-ascii?Q?4wDFdblZHP7W6AfxGlMTQLBcGXg9+XWwS1WOQQw5J48uGE2LCC4OIf2uZaUo?=
 =?us-ascii?Q?naWseq6qbWH29jgIbq26YOXmKd6tImHpig1ihCMgWFdmLYRyajPq3AvHPwgQ?=
 =?us-ascii?Q?SyO5+wbERKP++z3wYkSJb1r0vB76e5IJZBd8qO9u9nJV3VQEgCVmOD+l6O4+?=
 =?us-ascii?Q?ZuQEsjR7Mkyua5tPAlnEsiEIx6iPB5k2oSEDvmJgehwALVxtyZS5B1LA0j5P?=
 =?us-ascii?Q?TMMErSNGd3uhry6osYnxh+Q4fEfkIlpWuf+bVMKNg7RSWPtWhDexNwHm5Qj+?=
 =?us-ascii?Q?fYy8ocqcAxBoA9pQzVYYYIiWicAlU+MnXZHRrtbKziRCWcU5i9G3jIxiyx0q?=
 =?us-ascii?Q?d6EBwPKAwQgM/2ICNK7oBpwr2bLG06/AqUpPH+E5x944T6b81yzaV/dZLy9/?=
 =?us-ascii?Q?WP7BVEFF1k+mMvue+HGis+TJfktAfPi6pUSq28tSZSgdOCbmzRd8KruHZqNm?=
 =?us-ascii?Q?DRhd5UXdRpPhAfYITWtrXgZRkTR7GbHibwlcHbrfipCA5/XB1hoFVHhAe9he?=
 =?us-ascii?Q?wHkig8yAGv49w9bKTaDucv9ebtFppw0HEw/LnIG3GEQy2VIwELw/KcXNiVI8?=
 =?us-ascii?Q?eLqRSO1c5IoaWfEYtST8L3hdYYtDXD8XUHfN+ToyVr6oHZf2Ne034MeyokIr?=
 =?us-ascii?Q?C52HAAAncWGFhuW7fwNykZj6A+7cm+ZGTsKgE+IahmRbTJzIKAqGynQvrzy5?=
 =?us-ascii?Q?W1MzW28zdf33loYV9q9qG6kL4ny/LN+KYbbztDGnxpF+H0/YoxoSYebzZ2B+?=
 =?us-ascii?Q?uSrs/osXwA/XGcn/Ta4PxurgMt9fu8dfJKKhXu6N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99acb3b8-2e99-4122-5a87-08dad4420904
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 08:48:50.9931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kU/UQ5YEEgHI68yOCEximS8tGeCMHPzOPpTHOxTALib1vNRT6wfIWFgMrgg1OV1vfbUz3d8UdkP5/6Pd0gjicQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5230
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Thursday, December 1, 2022 11:29 PM
>=20
> +/**
> + * VFIO_MIG_GET_PRECOPY_INFO - _IO(VFIO_TYPE, VFIO_BASE + 21)
> + *
> + * This ioctl is used on the migration data FD in the precopy phase of t=
he
> + * migration data transfer. It returns an estimate of the current data s=
izes
> + * remaining to be transferred. It allows the user to judge when it is
> + * appropriate to leave PRE_COPY for STOP_COPY.
> + *
> + * This ioctl is valid only in PRE_COPY states and kernel driver should
> + * return -EINVAL from any other migration state.
> + *
> + * The vfio_precopy_info data structure returned by this ioctl provides
> + * estimates of data available from the device during the PRE_COPY state=
s.
> + * This estimate is split into two categories, initial_bytes and
> + * dirty_bytes.
> + *
> + * The initial_bytes field indicates the amount of initial precopy
> + * data available from the device. This field should have a non-zero ini=
tial
> + * value and decrease as migration data is read from the device.
> + * It is recommended to leave PRE_COPY for STOP_COPY only after this fie=
ld
> + * reaches zero. Leaving PRE_COPY earlier might make things slower.

'slower' because partially transferred initial state is wasted and a full
state transfer is still required in STOP_COPY?

> + *
> + * The dirty_bytes field tracks device state changes relative to data
> + * previously retrieved.  This field starts at zero and may increase as
> + * the internal device state is modified or decrease as that modified
> + * state is read from the device.
> + *
> + * Userspace may use the combination of these fields to estimate the
> + * potential data size available during the PRE_COPY phases, as well as
> + * trends relative to the rate the device is dirtying its internal
> + * state, but these fields are not required to have any bearing relative
> + * to the data size available during the STOP_COPY phase.

I didn't get what the last sentence is trying to say. By definition those
fields have nothing to do with the transferred data in STOP_COPY.

is there an example what a silly driver might do w/o this caveat?

Except above this looks good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
