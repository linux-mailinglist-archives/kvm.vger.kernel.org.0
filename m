Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214726BDDEA
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCQBGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQBGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:06:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4808F3CE1D;
        Thu, 16 Mar 2023 18:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679015199; x=1710551199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zg5uq2cy1671eB+I08jaTHvRxnSMZoAaYzqp9nKPsz8=;
  b=SFD0k6dedHernClUBCiXenNR86NW3H3Wm5xcRddJeB/Z+LaHjj8ZFf3N
   5H3kI5nHQxD0fTVoVy7gUPLEtNOt33/uFOZ/PB/3SqkLQ4SU4fFE1aTB3
   mTLw7rsEch0n2xlfwJGiN1KI9xEw//wDTIksFBjrppVGHqJxYX5fL85sk
   ZfSoIWA6sRZS8kKjynHjhDp1zo2BHvWXfHBIbJtS3c938cpDtfK9NTyod
   qRb2qG+mpEOkJa9GwszEklMSsUs3tLFQnSDrLacw4bKRlspsiZ/yX6xUw
   kYcTAty66vBIp8FQgumq88oKnnFkoXJYy9QhrQYlyn3zvSWk6I7keWQq0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="338167258"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="338167258"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:05:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="790544109"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="790544109"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 18:05:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:05:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:05:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:05:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0bNbWtlNS9gjvJ/5n8pi74nkOMZqyUbjjUrudRWre3U3BNIU8K0ZyPKnFpjZT0JkW6+PC71fIEq9fay5G7y8T0LlO8krY4p9KKU9RhANeZaeV5V/VPm5gJhKUrKAiqOD07uAGRJBgQgChSSvIRc1ONyMjQhQVexi42auTQtJNp49CGsMI/7WArr5jbd3rvbZlqIgZv664+IzZ/g6dOTrUOZHs/o5DtJyOiYsLQCwr5CaFaBwGyNkWbk2xsNCAvu6/piEZnvJu2lGw+oCABvh3kp/1vk+rbuTFhxltrOtzjahVpDNovcX4t/0fNVYg2qjS3QU4eLCig+8ZLzEP4t3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zg5uq2cy1671eB+I08jaTHvRxnSMZoAaYzqp9nKPsz8=;
 b=gV4iQco3xFX4PSo003LiGBbu7H+aePT/MI3SQIksAzwgFtOtcqjw524CulV/puCFAb8DiN48CC72bdsDe/4HyE2bvA5VvLuKL4+FcBK2iYEaUzoDcUXaoC5awTnZfOAJ4RLYpCci+pscOJ6CV0ZdA34NHqFO41mIft/rRIni/W0k+lBJnbzljtR5QBvr14Ht12u8XqP2K7fvzn10Yo/gXf+tB0zCcgOSseW527HNfJFYDWAha3UpD6P1gNrxbJ05WtHpKQ0NGXIe6zZvBtTZ5t2Q+1D23AM3r95l97hEKzwwQUDGIXI7lX5txrNhaROHcv2dSt1JTVUubCQ10wEchw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB8377.namprd11.prod.outlook.com (2603:10b6:208:487::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 01:05:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:05:32 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v2 2/5] vfio-iommufd: No need to record iommufd_ctx in
 vfio_device
Thread-Topic: [PATCH v2 2/5] vfio-iommufd: No need to record iommufd_ctx in
 vfio_device
Thread-Index: AQHZWAEKzo1DlMb/4UW+H68yGKTSWa7+KQVg
Date:   Fri, 17 Mar 2023 01:05:32 +0000
Message-ID: <BN9PR11MB5276FE8C8091626C1A2DB7F28CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316121526.5644-1-yi.l.liu@intel.com>
 <20230316121526.5644-3-yi.l.liu@intel.com>
In-Reply-To: <20230316121526.5644-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB8377:EE_
x-ms-office365-filtering-correlation-id: ee8edcda-135d-4a5d-ff75-08db2683b54a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +ZUkvNrcSnjleOm4NocwrEpfBrNRTwvkuGb6bqj1w2YQ119zbUoCVkxIsDOEBHpRkhueaJdkK2yAEx06OdUJfog1pRZfQtnYloeqkoRt5S5HYa7dIBjCGua1pMsdT154h1GFQdZc26EPxH62xYkeTVaOJQJ56WwjwjJUS4L80fgh6XovuPWBDZnRq3/6w02k/YqWfXO1ngWousT1r+i0AYh7WMDoStDU7B/e2q/NzUEbsPjrfXz1hGHRR0hra61wrBe4tj3KCXLBAooQmRUCv8tbrxS2V4+Dm0tuRE7xklx2Wv/71Rf7/94+mxvgFPLs9jD0inT0TqegMXHgqPgkXX9KF9xxzA8dT+GZUB1DonrHwYIPQ3aPqnhwGcC+ZLIlgSWIG6jBkDyE6lz9Gb8YLrvV1Hp/HDs9ivpvHrrUsw9uMMCk4cRyYMMsTCQ6Nf8PohCD3PQAPmslJtxq0pipcdLf9HBaFFOceSVBhQfbhUqTbcZNFn5jUU0qZ47gywWHaTe+xviNsTCdZybErPMpeWL3Qu3Qm1O8O5fKYRGMCUeKhfaadM0y0fuCoRU9GYY9tbH5wGYoxZ0mPXXHSvY+yMWnQY9T6wbbnRuUmbkNs8hGNWkIseOSUZz3REgedwMZTX8nXJO1mL/TeZP272y3LT1wMCfbmymO/CT2VlRuJXTkK84CWkJnrihhAC9P38D/h3ZltGJTwi+eSDuppiJN1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199018)(26005)(6506007)(478600001)(71200400001)(7696005)(8676002)(83380400001)(76116006)(66556008)(66476007)(66446008)(66946007)(64756008)(54906003)(110136005)(186003)(9686003)(316002)(41300700001)(52536014)(8936002)(5660300002)(7416002)(4744005)(4326008)(2906002)(122000001)(38100700002)(82960400001)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3k1wUbBorSB/4IPSS5wfNlOPKdyNBnTg2UDbQpQJm9kyAby782Q7ykgFyWAL?=
 =?us-ascii?Q?Y400iDDV6PJuQxetp8loqrH6+S0QPsZVghLUhmrzT6lJS1A3RYiWCR9rX0zE?=
 =?us-ascii?Q?nAdll3wShDhLpH3IB3rJn8LoAL51Xvjfhr+ee12QuZG5uy31ZgEkLeTpwbrt?=
 =?us-ascii?Q?InlSmfpmUlWO7BqTxo1ZDcKD9g/j9MT+mS1+B4ZKEq1P6D1rOp5PL40fO56o?=
 =?us-ascii?Q?U6y4bovXN4D6IUyhnWG4BwJb5DTDLfLtTG7MDxfmZVWYDDEttJ+A3VZ+FkyW?=
 =?us-ascii?Q?1Q2QIZq2iGzlZTddIFjzUsFy3Ref3/1N+iWYi5tRwbgFp5GuyjFjlP9tizbW?=
 =?us-ascii?Q?1vGMTUAJ8MsODUCFjodOULKm/Yh3HASvaJcJTYparLk4dQrP2pe4VPEzOWlB?=
 =?us-ascii?Q?c9g1sV1XVxdRzMXvlcaTDjdGYCi0LkvTPoWXumjhJfKkpvcDDkXlYLnjviyr?=
 =?us-ascii?Q?IyAW1rvGw/AR9c6oyKXfx0Of/XE0yfR4ZgWVwYZBVBdrgDFmX43ctwYWjZI7?=
 =?us-ascii?Q?4d08W17vGGdq7RLMP8PABd8jiTe0HJg998wEmCATYvTZpyT/nOimuPnKrFaR?=
 =?us-ascii?Q?inD1aqKBqa5xbenuWs9Wjy1wr7Vcp4UjgHzYGavjv5itAuoOQH3E3X6jKBlg?=
 =?us-ascii?Q?0Gpxg9jSeAjwiKwpGVvxrfkuiy8IK0bvMEkP0GAB7X930W2WAQ75F1qHHMNE?=
 =?us-ascii?Q?vQwbv7v5AnfUywsgvA2nhCvB7NtsInuSWrxTzKqqCAD8udblFbaLZxyXcWmq?=
 =?us-ascii?Q?2mtqRgBucMsTCGFq7ddFimEQCsfGy+8Jobw1d5j5P/LmAxeVlxpnMYrjJL8u?=
 =?us-ascii?Q?0kGoCM+7BpmuW1VEPyvK7mlNfKqhzWiuOipunQP1rJM7RKPOCeiOP+4Vtp5i?=
 =?us-ascii?Q?VCtQauPj7KYmmgfcIsCYnOvFctxo/135hfro1qmqrVbK/PlNL1pRQdXVYDzs?=
 =?us-ascii?Q?0hKURELVbeMt3mOrMKIUzoHFgNNMD7W5xfRVx/8zh6FOQsjTC5V/XXHGnqce?=
 =?us-ascii?Q?/foAgFsoJPYqgNu9yMKBATJNO7IjGkoCSpuR37mroIRg5EgaEh+BIvmbe7Px?=
 =?us-ascii?Q?YGoD+m0ss4PoGIf+kwxFTrSFj0oG9eFYHSXvbru8Y/Gq0JzXv1pyIRc/zXzy?=
 =?us-ascii?Q?3GfPwlvF9fH2Xein+r7cgWZbLEEfm8t3R+nqNSX32kv4rtD3EDI7fFmZGiwW?=
 =?us-ascii?Q?Sq0+ZCuiIH8SMPLH7QZ/HnRsCaJvHsiDsYZliy6TCAY1x9rUIqu+dKIAxvb9?=
 =?us-ascii?Q?/Fhk186QoD1abJplZFlTU3gyfvaN2ehtliv3gBS3AJYErD7zsZu5VqsM1Z+6?=
 =?us-ascii?Q?utj6/73JQFLmgOP6GvbHKn7BsEBTPn2BwvnKERJ4VqVv5GncbpTZrhNLx7+8?=
 =?us-ascii?Q?J/91X7w8TUeUy/gCrq2Valedmxy0gwdKmlXJW4YXhkSz2m7sU0GQDwUsRR0j?=
 =?us-ascii?Q?UOGhHe3pjvtxTxgNPPVNfUFveQoiXJQTNZ87G1Hlm9w6F0ievmEm6njEjwuY?=
 =?us-ascii?Q?SPeReV1vORB1UAM5DI+ymkIvMxFqYKJvAF0YoP9kJ4/A/1Iw4SnocqtatuyP?=
 =?us-ascii?Q?YewAQamsvaMmLEpycfDQWakq6rJyLqNinyu2yQa/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8edcda-135d-4a5d-ff75-08db2683b54a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:05:32.7049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XJDfeB5HhBAo7SeJieJQp9//drpS3ItKmyJC0wH8Z1xoGM88litscGe0v9uiiWtWhPgvTXr7Z9wDJLpBWb2blg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8377
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

> From: Yi Liu
> Sent: Thursday, March 16, 2023 8:15 PM
>=20
> iommufd_ctx is stored in vfio_device for emulated devices per
> bind_iommufd.
> However, as iommufd_access is created in bind, no more need to stored it
> since iommufd_access implicitly stores it.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
