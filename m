Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD40671802
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjARJm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjARJj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:39:27 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030D018B12
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 00:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674032210; x=1705568210;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kaJvc1Zg5R/kJ+PIAZJCcfyuCF3rLNX8+FceXkbkbdU=;
  b=ZWQEgWlvvq6LT1mgq5Ab4PcHB8GxYkjGihVd2bWWyWatoSdEJR5f5DOX
   9Wz0Outs+3E4nl4wQauRQnayVdAmrKPCmDkh9breNJ7tdnIe31l6JJNzz
   f1o7/QnIO1XAVzHlHidA/4cYO9XRrG72L/HpCB1T4lIWekjVOVCMGHUaQ
   ggolbg3/+mRqb4zDteIj2uQaXJNQF432kyG7xWHDJisM2GB2B/8ekRIlZ
   iUm4qCuKBNiyO8zLy05ZoqRXBhbglclOYorY8kfZyoeXHMKvkILLO8aZL
   MarxuuYr0pYU2ONN/APNRrn3GlaZW+hP01xe4j9/o0Vvk0R5wAPPUVsYV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="305309663"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="305309663"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 00:56:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="723005432"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="723005432"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jan 2023 00:56:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 00:56:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 00:56:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 00:56:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 00:56:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QD4tiVclzQL7D1XzLtS1/sImW7jSq9ZsrNADRXxqZEO+fFQPBxRXU5wr+NaS285jRyowj3tfGkb8J3Hy0oPssKAYffbLY0UW6HLwqVo/ip+67xY71s8cUwWRK/iPjhAlqXcHcdfQv1qe8/luotFilmFly1OsUT8c0veVoV6H1lkr3O2MTx2Tg2xddk/KXXozK7nz3lrTKSbr5nLS9gJJAeyLI6bxIPQOGkPPpwxpWYCoAqY4cur+lksuPIB8m5/u0IIE5KV9iKK+/3lxx5OmAXry+022LQnhYaED3T51uEmDeLJI4ywgV/82vGAW8kgah34iK86rGQCQVdE7PvZnyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFHadz/qyNzcKz175MFKS5IEsEEHj+ImkUGl83bkP5E=;
 b=mlhmbz984O15uUctv78erd/77Sfqr4UP9+6Y3mMRINLkJeTs464xoyB2c7newe+vmAsmMTJRU2oeDSi/TNBN7Ey2KsgRNOQ0MCxMOHjZKnww4U1rKgo1C/pWCnjJnSVYaeuYPWt1rXwIezExaFWg1UG+ApDd5XDV0Rm/U/cYDJEVesgwJPVHNyYK+jJSY54DLyNnGScuY52HQSDlgVcwQQR96WwS1ePTTvxz2IDNjooe5xusY/gHkNarR9j3agyn9Ed4mV4Q4tJaeAbpHG/jxM/uEc1Oapr+JXt0C2rPuf3Pe5jAlAU9yipYNg6eFe2BtCQdj0y0RhBjjTqLD48IEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5362.namprd11.prod.outlook.com (2603:10b6:610:b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 08:56:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 08:56:45 +0000
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
Subject: RE: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Topic: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Index: AQHZKnqZYiHu50d0v0+W2V8FfMRkea6j4EPw
Date:   Wed, 18 Jan 2023 08:56:45 +0000
Message-ID: <BN9PR11MB5276A3644F8AB8429F8F90C58CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5362:EE_
x-ms-office365-filtering-correlation-id: a147745a-f4a9-4d3e-59d0-08daf931ed1b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 52ulmAb7k8Z1wNv2HQFlxV9gDyekCmOn5nnVCgUwthY67IPOeICiWqkGLI8jPuriVpnYMf3E1B/tiGSNtkGpPJBfUcceuXbZ7ERc09T7bDFh9w4v6OJlENDl0FUE3qxweThHbfI9sDVAA9UjczdXy1TTuYPThis75L4nQjC6bMe734yvNYXLfxmH5Ypyg2kDMncoaKFQ/bYWYIYzPqFp2DcodqerSxs01TYIPa0QSlHTwpKpMpd53n4R7/V+W4UZoD14nGTryXb3a9dUOQDVhXcpFoXEbEFXTR1gIerLliJo0eDUBq/UHWm3RfcFtiTd8G33m2xo+TYM7GubFHTIE9hcE3y3NM6BpcHMzMDovWpZQQt1k3Ix/KuEhRCXMT5PypiHzAW55Td4/m5i0baNPcm31VYhraKDrMfLAS6cI+INQzecFkbWyW4vlsvacq5IajTEkQ7XqoJjw4vRXN4cquHVuoyRaNpY+hM9/m5+naWuGmm3pDqGQFj0pwE780xOk7agpMUApvyeZiMbLLK2/6zV5i9UrGTH5xD/wm5Y1Ff4DRU1+vwqZbnHoftBENiRt+KkDmqcJKxyzrcoeoXdpHWzWaexd67/O7UBAIN6RUrFT/2ferbLOS6aT5xQ98ovI+gxXa/+W0DVyxxRlnNvV4yNp+gpQZmNu2YLfVMWpxt1dDGoAeX3pyZ2ggjzEurWlfwsPoehVfRvncD5c3z3gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(376002)(39860400002)(346002)(451199015)(82960400001)(316002)(38100700002)(122000001)(66476007)(86362001)(38070700005)(33656002)(5660300002)(8936002)(7416002)(52536014)(2906002)(66556008)(55016003)(76116006)(66946007)(4744005)(66446008)(64756008)(4326008)(8676002)(41300700001)(26005)(186003)(9686003)(7696005)(71200400001)(54906003)(110136005)(6506007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KTZb3jAPhnwocqbnubQvRb6ZRfFgS3Mya5sSfedv4KgsqWTQphOcsrS/2uYO?=
 =?us-ascii?Q?OnpHdKHY+6lFvJZ2NvbD9Rj+EzqPGFS+90DDmRy0E1KLpXx1Ib7hA8l/vcbU?=
 =?us-ascii?Q?zq8P6aEP2UTsJAeqX4A5Kyh1Na7olLAGBLYBZqhCMWLoO7Bl2cgyhemZbzCz?=
 =?us-ascii?Q?HwBA+k7TdIhOXlup3ndzp1k8j8mk/k3S9V3u5FvK4SiY7rXYNDKBoFGaqjs8?=
 =?us-ascii?Q?eCFxj2pQEencmST5aiWGj6x88w2Q8+wVKd6wkBMHFNhw74FUfKlHQ+ghbkdk?=
 =?us-ascii?Q?FqGggkzCGYVfr0h1EHlitfZzu5lxizYbbWEqbuwhWW3NWBkDVbqQcLjQItYl?=
 =?us-ascii?Q?UXFQa8WWVYtEHfBVm6tRuBAIgsitAoMJPpj+PHD6VW8GObILbNdKgRzmBkmN?=
 =?us-ascii?Q?LtcXTGPlmBdezJTFc0jPDrIC2j6Ep6tp7zDeXAmvitpNxEV1IwABBmRwnHep?=
 =?us-ascii?Q?/WbxWe85m8+LbAC9bM8Tdl8nILuD41ODTaSpMw2pP/KQ7t6Lbi4GC4OVFM1h?=
 =?us-ascii?Q?nmhdkzLfNCj29CDK5knEB6sXmwgrISdgayNCsd1zxbgN3/Dhi/ygmx1z9jJJ?=
 =?us-ascii?Q?rUi+NhwCW8XWk0XXxXR4AxpsGicc7q5P6Z61ZrITMpwFTv296PUSKVKEP7es?=
 =?us-ascii?Q?ycGaxok9HWyxkjQ/fnf+C7Asf/VBgPBr2WoBWAcY6CUExCr39rNojmos8KVw?=
 =?us-ascii?Q?HZYjzqjteX3iTrf/zkc2tLszIY7pEVRJXEIAAjfTr1siDKVAE9GjqCKMCpdl?=
 =?us-ascii?Q?xbGjKsVM4C5UNCnIPYGS+TOivO1CpH35xxl3OA1KjA9hHtrROFH0BijDXTlS?=
 =?us-ascii?Q?rhX+KpuxWuPBSJBsodYXYs6kovtzgTFMmJfu3zTbG8tF8XeycPNNXTvS2lPq?=
 =?us-ascii?Q?f3CCgArEb2NrTy97ynu4Zv8g8I5x3CocgEAZGjCSCUU3h8oW20Zy2JM8ByST?=
 =?us-ascii?Q?RhpRN5vzsfB2r+eRZL92YuqHxRJBq26VvwWzc1nUrZ/wJ54rw+56cGXCeNEr?=
 =?us-ascii?Q?rWWSM7K5A7ECvA6zYWQ7EjK46wECq1lLwHyk/YCcYYKBKi6NUi32DNm5jzWK?=
 =?us-ascii?Q?BKcLmHvpPeLEMDC9uobZSqN8MutF8kZ0zmSIdDaArO9kHp8jMjGOIQzPHRtt?=
 =?us-ascii?Q?ngutAH8ToskvmI3yAcZFNAjkERmgfCqg6g0IXzpV0LFApdCtsXxjvaLJDf4J?=
 =?us-ascii?Q?fqquy0z8MhUKMfbFQNfxQUtdzkXzz+zyY0bGIz37fhgFUntf+cGbrJGmlWZp?=
 =?us-ascii?Q?CI9eMJbL5BteWaqeFhXXrpLH7xMj9q1E8hQap437tmJMco24jWx+yFRsclpH?=
 =?us-ascii?Q?sQsvQN+ieRbVSPNEgxMdSQHIAxtkJWwyS3nPSUKA3VI8pEqntDuoUggLPBvy?=
 =?us-ascii?Q?vFwrBDWfSq0ORjGq/wPXgynnlpfJgZ4qoRo3UEQPGTFexshCfoTiwHO7gXEP?=
 =?us-ascii?Q?2OC44U9qTTYp26s785P+92Qe62fjbQUE7BrmSoQaGExN3NYcKOs/p/pxDaba?=
 =?us-ascii?Q?wkx2dIwltsvhraLu+GPQizqltUGtkMbxA8AqzaVyzW2iPwFZUJfRjg5ZjZ76?=
 =?us-ascii?Q?kc322HliP+1i3T+3hKu3s/s8BatnlaZZzz2hORpw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a147745a-f4a9-4d3e-59d0-08daf931ed1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 08:56:45.2428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y+mnViC6OAEAJcjTjnVsN1PV+BWg+C6HrFSSmu35DzHI2MHrTtbsB3269gizQRE1I3AuMa9RYU/iL1Uu5Qy6WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5362
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
> @@ -364,7 +364,7 @@ static int kvm_vfio_create(struct kvm_device *dev,
> u32 type);
>  static struct kvm_device_ops kvm_vfio_ops =3D {
>  	.name =3D "kvm-vfio",
>  	.create =3D kvm_vfio_create,
> -	.destroy =3D kvm_vfio_destroy,
> +	.release =3D kvm_vfio_destroy,

Also rename to kvm_vfio_release.
