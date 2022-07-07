Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A7B5697DE
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 04:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiGGCTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 22:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiGGCTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 22:19:32 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139762F380;
        Wed,  6 Jul 2022 19:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657160372; x=1688696372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7qUobuu/wV6r8bkYlSoaPu3m2U6xKupP8brZeZYQYQg=;
  b=gRCcyAYWpySMZv6j5EoIadNGznaqnpl76l4DXj5+EeBJm5GlO/gZa5mR
   bzqjpd81kOsf4XEmTuY+KglOUp5DTZ9zr2JLDez1WI6393rs0Q+b2k+I9
   PDX16f6EwDO3FxVi77XpZHXvLY6oEEDdJt86J0BQoGbx7qmV0Qw46MFOD
   1zJlzhjnrgOSpZm6Gtzx230Lba6w5mPl/JQHNt5zoXegIhu4TIDx0uw+C
   4GwMUeeWFHS8IqX+cV40U4GxAvWRvluFgmcviaJXeSSAbgWVPoyxwkSlk
   shr07n2q836ZGU3EdeIvOxXsD/PpnUnZ0w94L60r3yXp4UHtw9dlcT/sZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="263697671"
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="263697671"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 19:19:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="735795421"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jul 2022 19:19:31 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Jul 2022 19:19:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 6 Jul 2022 19:19:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 6 Jul 2022 19:19:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQxDFOsPZbkf4ZcWkFH1eLJP2MQbLpoA6fImYBvaJeYLrg62/Xxw+aWfsLDlUw4H2gyXIzpgVKyISHcseYMDKw+DMMKBxtuOGCB4c+Q/nRrRqX64Qnt0WPiSIAstmnb5oJ7ih/Bxmm5axPSL0LCDfD2Ma4oz2P1AJKAYxht5QlHg2bxGn8EdUqXwXAQbbNxkH9YcvCOj6oNVj5sDtzeMz3PdVu7coNd0+bmptlemzzNuXBO5Qksc1tS6a3C4NsL0mx5TipP9ypH5eLms+ne2OJGCubFZrRkpiaRxc7qmXtuaech7kbpfRChTrjWdif+ciYkol09ZTEnM/oTKZtL1dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qUobuu/wV6r8bkYlSoaPu3m2U6xKupP8brZeZYQYQg=;
 b=LgP5X6NSuG9+7JUsjMd7gW/jPQbL8tO1S9hyPBLaNRCFtsLkqbI96qVAe1cJFDe6zqkjPNOGuOlUqT9z/3ngOmeJnP9ZN4HOyA+RDwPDxG3SMzyGdUzG9ZZm3K1MmwG9T/XkQbh4/qvRYiFPCZW/jCX6ZrVJltUdKBDyrbgThOep0pzzENf63DvrU3tTwmvUb+853xODFklDqp6Tj/1KDLv1WtTwumCjYZQUAqZ9HwhfUEhSe8qKik3SVspzkKDSSoc8Yzp3lz6UokmewMmj5RewovGeeuMDwMe8g4j99ApbXr1gGDVJcrk8/06+Ot9rAbMTbmswWrnbwUbH8kEYTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5325.namprd11.prod.outlook.com (2603:10b6:5:390::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 7 Jul
 2022 02:19:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 02:19:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 15/15] vfio/mdev: remove an extra parent kobject reference
Thread-Topic: [PATCH 15/15] vfio/mdev: remove an extra parent kobject
 reference
Thread-Index: AQHYkQwS7GWAcGAMC0aVPYgleuWe/a1yLbAA
Date:   Thu, 7 Jul 2022 02:19:29 +0000
Message-ID: <BN9PR11MB5276298D32DED20C8B19DA4D8C839@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220706074219.3614-1-hch@lst.de>
 <20220706074219.3614-16-hch@lst.de>
In-Reply-To: <20220706074219.3614-16-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfd4b8fa-ad27-4555-4685-08da5fbf1f65
x-ms-traffictypediagnostic: DM4PR11MB5325:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yPmOQw6C+TSU7MUK8OLMQZ0oNTEaUpiV2I5+1L0vC5bDMs9J5weVbaQyFYd6MdThkVd9CF0uu0C5qa6Geb9Ty0FcztjqiA2C8JFZoozf47Y+cJvg2nYBXfXA/epaPL0y0nYEHeYGH6ypkVFcxCxpNMwpZEOMDdurw40AdRDa35FGKXAro6Jl84n25owbZhA1th2N03tFOlytkOaX+Mg8o+4iG9X878EMm8e+MI0YPGYfJh3FXydKOheOQ4jEsPfeLCCFmgo0uLHob3oLqtLjftnEK2kHpWQ1lRK5iHYDV6Y8OU0iLlHjJAE2Zfm9lcX1ec1psvOdgX0UM35zSyt1wjAxlNfg6iGnhO9CZP3r/Fs/vffHdX9pZny1Ts2iWhGkrx8bDPSNCrYtb1bSyP08yW8jnkGuO878i6sqWs+KQRQeNVnYOyTz7UGwERQufbfiiMvVWN+3kxFv0mzFkWrLkz51Y7Px/PkIpM3MX02vpAIUnzsJObjsXBJSOBcJT3+yy8ypF7sH9Wa55pCyqXadEGLufaMQ+53WDGBu86K0Qg0wH9qHGTJrEPutrTeQEOS90Hu6SypMz5S99aJcyDGljTWpYXd5cS7iWtnSTrOC8pfkIBtPx6goyBVZx5T7vsb0RIwOXT4fKjWequY4onU03djG5Cou6KurwEhkQajopBAmbd3BmOWa7/YYtdGdeQBDPrfze/KWWlSqXZepUYMSlTqEvYuYAZ0Bqk2/n86UyrgcOGIGUD7G/7esWUtesU9C/7vjKm/tUIHTxBk8b8pJ8uXVKa0k3rk+E0peGRkHXJuC0qsEsd2WowxXZ3nbpyF1oHF5wExlXHhNUgn6I0zizQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(366004)(396003)(136003)(2906002)(55016003)(41300700001)(54906003)(8936002)(38100700002)(316002)(6506007)(7696005)(110136005)(71200400001)(66476007)(33656002)(66446008)(86362001)(478600001)(52536014)(64756008)(186003)(8676002)(26005)(4326008)(38070700005)(921005)(9686003)(122000001)(82960400001)(5660300002)(66556008)(7416002)(66946007)(76116006)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Op6ZJv6SZJUXbVmkqDg3vodAsRcZy/9MmmCqyP3+szbFLLjfISRXryBT+M8K?=
 =?us-ascii?Q?Ya/WPWl+V6YuTgX8dBFnbF8/1qJYpKim64srSI0nHadhzk4jCxN8Eba3ZpJu?=
 =?us-ascii?Q?ggeWc/cQL9fLqWlpPjwLcocmbUeFNm25GWsPi31PVhr4+ZEkn/KQgr6Imi83?=
 =?us-ascii?Q?EUJUHuWsJ94FZyribKeMCX5RhPiJI03xkd7zIiYEb3XdnGGLqiVzT0x8kiFR?=
 =?us-ascii?Q?VALRBoSs3hEK8RsTfWaHbNuNytpif+nohHPC4q0Ids9S4BUgYSjnIerJYU8D?=
 =?us-ascii?Q?O/JTENcm/kHrtDy0i2pwuBLiB6k2BqrNBZ1jQuNoFksxjZM8u4Im75U5Jh0j?=
 =?us-ascii?Q?6CNjsRY0BEsdMT7q11JJIoPyPBbACl7mzyuMr6RKysUObGZshGagqSNcaUxS?=
 =?us-ascii?Q?5itZ//zeoVbjzt2f1xcOqPbMfwnBNv/XCfyFKPQ3WoeqMce1L28ZjYSOZq/m?=
 =?us-ascii?Q?rnFEZ78GVYGwyOZRWK0hOrbBkodxYvnIG4RC/U+ZxV4mzDn57c7Z7htSeIMD?=
 =?us-ascii?Q?LBdPJwAC9QlpojlTF8PaK1uPZFaZUQRO+A7aSusTkOH8Ot4cPCNfTo9Ep3GO?=
 =?us-ascii?Q?yIxtVDoNheOqlpQf+97TLSvaSxB+fw1G3nHrZSirMkT25xVYvsUIekIR/+3/?=
 =?us-ascii?Q?yVMFcdn6+097YJ5u5+t92jhB4a8atwrMsyBdiW4Ta2vjmNCgnQ8E92/EMfS0?=
 =?us-ascii?Q?AKPPDd4ysmSI8mybiM6hgt5bEmjL+O2X/rPxxW87JR+5tGMghnst7dC4VMog?=
 =?us-ascii?Q?YXp23kzhYR/IsNlfBJYByJBbycJa0Ut9CDDT4SWFjLgxF+NVVvnmguRRNmEJ?=
 =?us-ascii?Q?mNwRJ2yR0jP2JLsd2im6dHKKfT2BqoumaHhnhyuyDpZvw4K1dwetVRPHqL9z?=
 =?us-ascii?Q?6UGl3BkWrMzJAsFndRkim44ewr7iQxY55Ai5vaH0VlI7GuAjWy4JDb6otAVO?=
 =?us-ascii?Q?tSDmyI6LSyX1GkPC6BpzfgtK63gQfR8nJ9iAf/s1G8k4ihTJN/tyPO50sVZd?=
 =?us-ascii?Q?TrMVkYpePhZLM/P4Epj6dIwZLSI/2kc0V+rA24zoCSq2TR6EFKZB3uthdt6O?=
 =?us-ascii?Q?tlshiCwnNeMtEPrFNx3pjb8D50OeOoe104A6lpTb5U8gVsHw5E577WuLjAPI?=
 =?us-ascii?Q?nH9QmRVo2tHHlmYipA5uEFhAkNDRtz8jxkzrwc/+i/uq45PLq+qitDId271J?=
 =?us-ascii?Q?PXeN94MCz+Cvhkrcjk1k6SeuFAKoB25MxJRnBnVWmuud1M0QX6XPNSiX+tMp?=
 =?us-ascii?Q?7lfvtH77QiumNRYRTvjn1A5NV1NHnmhIlnwRMWJOncO8AJ7rhbqkl/6RimmD?=
 =?us-ascii?Q?j6JQm6I+WHRlkmx3qqI43AbvDzwvOHEpsgswZo80DaZApYkSvPFNJrZp2baw?=
 =?us-ascii?Q?qs+1jjf03/p+Jg9g8upOpEHWvKlcej2sO9NsQt/8BsWlF2zLpupJy0fUGv+q?=
 =?us-ascii?Q?ZoJMh/vWyBkYRNU7iao0zZ3q6tQDkyugzCD0UduxrE/KLzvKbF+Nt74irnYg?=
 =?us-ascii?Q?ShfQI0Gec+OnlNYOL78A9gG5qw9LslAWz41mmFt0bdeUgQ/eWfMyr1IzgaYK?=
 =?us-ascii?Q?NkDA4RiZtv4cuP+S4RkdeuPxPc6AQOnClQaMhVUS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd4b8fa-ad27-4555-4685-08da5fbf1f65
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 02:19:29.5844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2pIfCY9XQRtao5g9HDRUzqY7CzqYCtS3gGcKIjnfKRHnP277fK73KhoKAUMSiceSgNLc8/7n4ZbOdvOvVvHyBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5325
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Wednesday, July 6, 2022 3:42 PM
>=20
> The mdev_type already holds a reference to the parent through
> mdev_types_kset, so drop the extra reference.
>=20
> Suggested-by: Kirti Wankhede <kwankhede@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
