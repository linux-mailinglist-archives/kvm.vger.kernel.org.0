Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CDC68744A
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 05:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjBBEKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 23:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjBBEKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 23:10:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B863E761EF;
        Wed,  1 Feb 2023 20:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675311034; x=1706847034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DFKLW5WjdfFqcJjj1XywKwdHMBewYiwpE2dalwnnAIs=;
  b=UI9uAy90cVtN2wlve8A4bTDIhjjtJZh5JqLQIskKC6vBROCUo67V41bW
   6+Y3Y2b9NfXghPSs57fJJ66pN4hn4rnxJoJXRA9Ua4nrkxJDg2WLIMcNI
   z+C9PdAtjxif7qKGCm8drjnvPL1GeHAyXxj4Rs1V1sqbMm+KWW3emhdFy
   d3IMqLm5eAsMm13GgyYxkBVvPwE+JqXl184mrM+wgs66KF6sjcnW6M1EI
   iHhxDOart8NoJ0iEZFcj2q8HRsQams4cxjn/ApFWDMN+b+i4hwJkhhZum
   7b0t+0HPlYRTD9IxDhAeQwqb3tHyJy1ZieZiC0fpIlMLqAqhUIZpUFYeH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="308686254"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="308686254"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 20:10:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="697546344"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="697546344"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 01 Feb 2023 20:10:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 20:10:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 20:10:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 20:10:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfHeVMoDpb0atP0aCmwW6KlODeqxos8wjSxE88gQ91Ah8qFGZycS9RkNX++OrZxk/xSb88KZzY+FvSu75IAHzTkrB64ev/iWz3csuxSrPKmr6xRF01H4MPWHN4mSKeLuvld40kGOACIg/g0aXdUMUNvWkzlsB0ZYcjxkp1qwiuMRNyBWRuJ+gFzRmh4YbSounyr+7vC6ah/L8TZZIEiEtbRe7lFWWbL9LKhmCnrXZ0PHQcA23rafuutX6pGMyhSiVbd+JoB/im0X5UBu22fi24OK94b9ve36Ml9IivOo6Cskk+cmPI5j0JTXDlJsAI2qOBnR2N3HlfW6CeNslcqS9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFKLW5WjdfFqcJjj1XywKwdHMBewYiwpE2dalwnnAIs=;
 b=EBR9OtlSzOsJX2XZnaBo7p6KLHGqH46TZk+og9PBqa2hrv9bAxfJ9aKTSmNBtErCCXUyLD9DZwarbxDklXpEMnr93JKHWnK+1NARv2OmKXiS871fZ8Y8mNzqdyJTUBlc3fkMrFJM3iUhYAvWlPVBt6a89hqHuXCy6jiVvYcbIi9J6hmkktsSaMnAsf1f0573dplqoTx01+s5WIVcyVSUOmZh9qfxH445qusqM0bNaifQSxOw+psofAkKtjPvaKRNxYP7W72CUT4BgoN5JlFd8zkVCdTgGShaf/pjxryKR0jXol/fITKuiZmZPrJYog4x/OXZfF9RwfqPAER3z4c5cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6057.namprd11.prod.outlook.com (2603:10b6:208:375::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 04:10:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 04:10:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNnJFiVrNVn+VRUK8FiGvi+QS2a66vJwAgABONbA=
Date:   Thu, 2 Feb 2023 04:10:20 +0000
Message-ID: <BN9PR11MB5276B8F3F6735FF2616128868CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230201192010.42748-1-mjrosato@linux.ibm.com>
 <20230201162730.685b5332.alex.williamson@redhat.com>
In-Reply-To: <20230201162730.685b5332.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6057:EE_
x-ms-office365-filtering-correlation-id: fb8be05e-0d82-4efe-8d27-08db04d36645
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jzOFtzIPfRaU2u7tdXNT5Pw9Ol5xQ+DK54vkGJsRRizo2jMmmSj0A4BVLvYjoRdYWtL2JWkDLNsOcjjRe2pcPvLsyadqHJvHl8oXjadAGEYZ5tovXv2of2WyTXocKItxECzPLUuwfOXfOl5iI9uJAZDIi43+rOosPHSKhCRrs8SEl92dRGYERAuii/3XPPZSqCXFdRqUqxp8Bw0LgfJ/GOxmZ7fdC2oLf8V+jBOMBrm8dE/cbhtcWCCvm71BXoz7fM1UlBz8+9tYt9OU7Sif0bXSnOUTBSxjaWn2UhUD2oKUMwph2o4ObiR0ekB3X3qjnuE6Eqwev3O4LmTlx3FHg0fziO23MB4C/whe2t1S5rWf1d9FHPzoAevDEFv3KfkT5CFyCUyDIib0heAYVnv1hY6Zj9CIgs+x8BvuFL6BW7GIg0mekYTBIhHiIfDC3C81pBweNAtMeCS42jm1tSRJq2peo/1qlbqi0muxwmyZUDsZWid/YkrT8QDVql+vZKLQ/M913JIxa+hkUL1FdMtm1JF6D6a8g1k4pjbuVYerIOBNMLnKUC2cWOtbHvti3eueS+g2WG3/QA0lfOMUCsZnadTDJh+o5ke62kVHOEbMd4rY1vUZQWkOy7SEK0zRMJKH20do7UcCWv9235QvdUEEt15qIkqfG/4BotInUziQux4Soyx+R1hV/+LLykL/LQbWLKgJQ+0YUUX6VtfGjtDxFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199018)(33656002)(86362001)(38100700002)(122000001)(38070700005)(8676002)(4326008)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(7696005)(316002)(54906003)(110136005)(52536014)(41300700001)(8936002)(5660300002)(2906002)(7416002)(4744005)(478600001)(55016003)(82960400001)(6506007)(186003)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OLasmqlQd1oqabp4gRocjCQOyjeJfLoWuam5QYmSYZt9Rwp0N+Ig/AH3aKaH?=
 =?us-ascii?Q?SfdSamK4uwGW72D+lB7K/jbIHHC6LQviZJl7hKTmjs78mD9GvaeMRK1fqf9R?=
 =?us-ascii?Q?0JjLy2h1eU2+hx0cNet1aMhLSVx5We2IOclbxK2+nKR4EWaloxQ5JWh37E/q?=
 =?us-ascii?Q?AD134DIayUB9G4fzOrJUAcXzOicd9zl/MF90/u/gEVyruRi6ZF/wruAozGGd?=
 =?us-ascii?Q?qyTtjfZ+aWJg0CY73f1MndWsHZ4ONypSyChsZpw/z+2lPc9WHF7qQXbnzEr8?=
 =?us-ascii?Q?8NAn68AgquFlyLr2eDOKabLvV1soH9H/8z1xsdK29LBJhl/iXPz1/UHv3tTk?=
 =?us-ascii?Q?1F20rtZHZ7PSDaT0XGf2G20L9Hrout4qWgZyEZeBSvwU7yt7bH4qIVf5ZxF6?=
 =?us-ascii?Q?yRGNMyJPjXXIXtyhbgJvgaizcintSEXjTCdyE5LjdZp4QPBrhUDSO7ZuueP1?=
 =?us-ascii?Q?9egaRpV3lO+jwgW6OjrNj1nn94ZsepGfMLf/rRin9pV1yy8iMRT+Wpt8uUkW?=
 =?us-ascii?Q?+sV2scNZnRbDDAGPS+gMLYdAlU6VnS6Ho9w8Lzv+/vnq3/QprPdVbjO7DwVO?=
 =?us-ascii?Q?DuBxdpI8+Tss7XzSi940jF/0vxnSbYpaI0rUz7g3IYeTjLWNR9Ujuw7iX5X0?=
 =?us-ascii?Q?RG7uGw+X2rg2agImzXMbbka/NKKqTOIheE3pRvnRx38dhTF0n1RSKO+7I6gd?=
 =?us-ascii?Q?dU5uLZgZgjZ2pKRkDHDsK3dhWr8WGVX+pyCH9nR7OMgW3zlsYTc8rmcdbjmI?=
 =?us-ascii?Q?lf2kLSNiLlG8dHAWo6I25IQJ4sY/6Wdz+oYjfZo/wjk7K+u18m/gXmQMerhI?=
 =?us-ascii?Q?KC1ZjfbellATQxRgUw/0ldmkmoOGGJgAxj3dgrIJisZ8rm+crFWKjWI+ptg1?=
 =?us-ascii?Q?A1kFP78OqNY+941hzxcLHk7OjndzSKcwDGSmV9Fv746YnpaWGTBQJfp017iU?=
 =?us-ascii?Q?TzAZadjO1qLIPGtghxI7MVtm8nzOlxHpfYlZj5pVGaYR87BvVW7DVwHb5cLW?=
 =?us-ascii?Q?OHDvTeqtnbb6BpbJKGWvKF7f/hSYFtedBImU7tlkoeB3dn65Ex2mA+FCx16u?=
 =?us-ascii?Q?mYnk1cZ6BxsgJ3AgvrFWNm/qKL76ahldA1qCMMtCDHjM5ctpQRDn1zeK4GiE?=
 =?us-ascii?Q?TiiG2gi2o3hWN+K0pJ155cleDrfK68CZ46FfnxI0+j6GuQoNPNnhLM5YBwZ2?=
 =?us-ascii?Q?TN6/DM8kcvrBmDugkztv1bY3Wb8fWZAqrfGSM+XU6Me7hMqEtWoWOI7H99Z2?=
 =?us-ascii?Q?b2wHUav9n0oY6eqU1M9KBy9t4iRzIXo/84Fsvh+BA0TQuDf+FDXWCJMKe0+y?=
 =?us-ascii?Q?1HJFEcbm8D2VKijvSrT8ofQ4BY8bs4VexcNTpy/4Eh5pLlxLcOpkECfLxwaX?=
 =?us-ascii?Q?cCSnMrM3/AjL1yz4BuxVOAxGy97snDdVWMLQXjDcE3Gnzep+bluhWTVvuu61?=
 =?us-ascii?Q?NqTg7Or9vPwLnsG3eqXUMt0jcXz6Fw4EH768UmQMZiwH9IG6zZ31cp2qhXUc?=
 =?us-ascii?Q?u3P5l/8QvdleX4ZHn5cD5jsL8M9lFYJ1cMoAxW+me6GO93CUbVEMrE7uYL+R?=
 =?us-ascii?Q?0g3zAlEA0am6ppVFZthGSqwWA7M5U5oxhJi3ksJa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb8be05e-0d82-4efe-8d27-08db04d36645
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 04:10:20.3345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oHr9htsw1nw9ctxCjSLTcPbR5Etaqu2bVv7x+K0yNmTRdwknH1PIKw7bffdJ9D8OEra79r2KAeHDUScRjxD7bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6057
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, February 2, 2023 7:28 AM
> >
> > +#ifdef CONFIG_HAVE_KVM
> > +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct k=
vm
> *kvm)
>=20
> I'm tempted to name these vfio_device_get_kvm_safe() and only pass the
> vfio_device, where of course we can get the kvm pointer from the group
> internally.
>=20

I have a different thought. In the end the cdev series also need the simila=
r
safe get/put logic then it's better to keep it in vfio_main.c called by
the group/cdev path individually.
