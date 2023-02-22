Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDDB69EF87
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBVHl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjBVHl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:41:56 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9366034C02;
        Tue, 21 Feb 2023 23:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677051715; x=1708587715;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0DlnQTxFRqIxb+9DFSKIanM9MRjPQkfcww2fr+kFqtA=;
  b=AFX6oyPgCwpsGlZ5D8SlmEMHnyq7xDdGiQ6KEjZudCcOhgGKxyG1jx2N
   fO7ulG/uU4oDvjstmiFb2yFJ6veZIMrniYkbjVmyP+tcByUImvoquDRiu
   yPfF+mfxo+O3IUJfxifkGKIixjkP2iuwjEV4vg46DSOxhPTQzL638gzhC
   BCIsWm5+WugesWA7jxb7sLvdmIiLV/DspeRMlJKE55oKtbZUPbFlqROOA
   iaerapfkFx9H20S5ZpgCwq9QK9FuNFVDqiyeX2yvPAlCW+Nn1iQXOe4j4
   KbpF5g5W0pgpf07N9mjox/tLWR3lDIMBxUX/HWjSPD+nSKmXB7Mr9xsAw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="395341260"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="395341260"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:41:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="814826888"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="814826888"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 21 Feb 2023 23:41:54 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:41:53 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:41:53 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:41:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4FwSibx4K4XGx9wCMIHsJtYTevUUNJh8SzPDcJ5wFkto49iqYGbH/BiC9mmcSSF+2KiaSSYzMPqYGFukqHMPibYQs5XN4ziO0mlvR3AoDLplVb4sRwpsZy2p7BKKQIghkDkRGD74199gBem7aF2+PiGQN5oOORDsh3Q7moePHk11L6zXSM9Mb3Vft1LpPVXJ2LegpwbPpC3Iw03g4SGafIEQfIEpoIvOI2xkWmpSpkd0ATrEbHXVbYaYy9v2ldkIopB8kBtRsHLQIPgCfxBPVBGOB2f46lKiCkUAF/sSwwZByJFcGSWhayiJ3M+Ok1R3Z1UdmrnDNugR9Y+Yu9teA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C93Vy0dibmnxeLc9PppHlwh7rDHEollf3VKDJfVWUkU=;
 b=i/1KNxBZJy97vetjPX4NUoUS05GNtQdxnlv2HiMVa9aEb0vs84SSL6ptCKhaIR9GZLMAL03gRecDv5RtfHRyk4RUGIYSOalx+bPqoAnOA6Wo9Y6CxTAcEonRI+eWBUoU9AEmj/S1jsmNr91RNBMF8Waaaf6e2RBp9f977Setq1GFeHUjPTLa0KnknNMPMxwEYL5TD4HjAcCrQuoHXMkeiT3BH7cY9RLPvpI7GkBIXGAsiA0plenTvnkLojzFjU+NGGyKRYTfyzQKEyGK/nWve5cFkKpV271VvCOuhHe33GaFjjrpNGn81rD08WsbhjmOZayc5xGQOWqn8I9yNYbCOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SN7PR11MB6749.namprd11.prod.outlook.com (2603:10b6:806:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 07:41:51 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:41:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v4 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Index: AQHZRadew/Zp4TWggkawcdsv4znQUa7altrQ
Date:   Wed, 22 Feb 2023 07:41:51 +0000
Message-ID: <BL1PR11MB52712FEB1CE79A0A09EED3378CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-18-yi.l.liu@intel.com>
In-Reply-To: <20230221034812.138051-18-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|SN7PR11MB6749:EE_
x-ms-office365-filtering-correlation-id: da58c7c5-f7a4-4cd9-e17e-08db14a842e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RJoj3TGmhrRC8vU++3dW6Xfd9aKgkWQ2nFGZLlxdzZFAEOoN9P960hhyUqf+II6L03BZv9H+1DC6LQGKNuMqaM1yART9zVpUcujY5pKN33ozbJnn8by8Nqks5TcI9FElhfvECs233+lROobhe01tFcOUl/1oxRe1Yo24R8ubVtMcMxBoPLlQRGz0wPb2EwIBXpdncPUAFH/STBNLspKVFFGcVFr5/uV7znMEw48y3cIOyyclN5U7xCAkNCxpW4f/3PdJsL5jIobsddq9kUSapDtiyc76y3OMn6yDuOz9EQuG5RKkp/Q+K4mW/IQtQfvCrEmD7Fz/rjzq10/MmLJjjSnp7kQjbG28g54Iow3UHHpxG6JBV4RR5usvMrPRwVoEsP/nM/ZfPY2JHxakiq16LGmLPyhBHkb9r8uCCRsBJwgZkpHrYseBUJQA+36EbpCyiZbKR2zbarvIqw/Nzldh0TZVvRy++U6FR6ZEzI4G4bR1pTGJH78I3jDSl59uwEUpGnpRfw+v+QwGt1vuquSWTOVt4vxkX37Fa3qjQBFHwz7J+hdmV1wuGIH0yGbRiGcW5eVi1+tgoFRi9v7A+w7rmG5ijUmyyFo3S/NbCgjR7oHPvnxhBpkYGOV495XqZ+IOJjBeZO1P1YVmSA6bqJGUznAvZd6Ynd9noX+hma9LXei2HbFahvSlz1wAkxryra7YWCGsMnAnftf+ZUTDrttSCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199018)(52536014)(2906002)(41300700001)(8936002)(5660300002)(4744005)(7416002)(8676002)(66556008)(66476007)(66446008)(66946007)(64756008)(76116006)(38100700002)(82960400001)(478600001)(122000001)(316002)(55016003)(54906003)(110136005)(71200400001)(38070700005)(7696005)(4326008)(33656002)(83380400001)(86362001)(9686003)(186003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x2WdOmXTJ/BLe2EVDF9qItWGEWhZNcSJBBd5USH0kdaZAJmnSLxxvbUYbHMf?=
 =?us-ascii?Q?bYcljthbiDONrYtV4O25rK5h7lN+RmZXGi162WqKqG2n10Ar02+voakn0orY?=
 =?us-ascii?Q?MlOUnq8agcXP6aTEqVZ0cC5LqJ/YkR9oNvQ4QF84yHce5LAIj1cMDzSC1pIz?=
 =?us-ascii?Q?4tBlsxisxFZVdoOIUDfv5aITunXsZSdotXc1ZO6uCZUUGKD+lbF2foUbWZI2?=
 =?us-ascii?Q?sxvT1KttSKgXcxJBsEFWZ6gU7Hk6CERqNGjVB5nyDzu447znUgF0HDUuW57z?=
 =?us-ascii?Q?cUYZULKqLg/oQwxrMEeDI+Z07L+Hpjj/66eDfvoe9k1SRs+4bcNIwOW6MwTa?=
 =?us-ascii?Q?BSwyFkfrutBl9wTlxPiNLR+AwTNzjk2ZfdyFqqhD2YoVCguYw9Pnz9uWJyYR?=
 =?us-ascii?Q?BOoX2ZtGAXMZj/LffQobr/Ili1Cso+ab+nbxBqb0LX6+gEjGwRGKVCH/68bi?=
 =?us-ascii?Q?Na8Bn21os3tnJggamWd/CGNxQwfkTZMLiO8xCDEdvp3UdLQ40T+Pzmm0VJ1R?=
 =?us-ascii?Q?l2sGSYB8Z06Kz52dUbc3y/hS2N28f5kn4ZyZLzrkLYGQkM2jx/dcYto3Xvuy?=
 =?us-ascii?Q?A+MiSWo8B+AvjNy4uFJQ3YVfpKrBeuQBaiivKONkL/QrQAL4LXVGF3eyWMSx?=
 =?us-ascii?Q?4zQy6cB7I9hE0ntH7pZX6T1zF6xBkNlNES+74aSC3q/zI90RdKxnk4CfOeyD?=
 =?us-ascii?Q?4TGNFwvXqXJR5A4LAuM28hlcrM+uMEKN1GzjGo5SZzwiTg849a0M1AvxcYO8?=
 =?us-ascii?Q?UkyS38CokjGG9VJvQObv/44yzfP9lLbfqtR8a/+mh42/189PtgDLLMvIc+wF?=
 =?us-ascii?Q?cX5VkBSSbuqqcIdnaqX98LKZMy6j2DJwtxqy5rEmmb8WtcEh3PjyKjbsLMHI?=
 =?us-ascii?Q?HhTTpzmb4gmv16eRKyJrsE5qT0xl4+oow6B3w6H+olsnz3AzXxVHI8oUJDk9?=
 =?us-ascii?Q?615ehff3R4afY/M5uAT8X9vPlvfTBC+OMoJrsT873G8cnd+UdjXtoWTR3jkN?=
 =?us-ascii?Q?CrcR8AKBQe8Er9WtnkHms8OAqLZNARNH8TfHqWmU9byg9s6hMFGqaFXhgX+B?=
 =?us-ascii?Q?RWxx/betYkq9VRyYUYaOVomP3sdRO0KZW7OYJhItsAbU6kNAld7aMYUXP7ny?=
 =?us-ascii?Q?pi/NdmlLGtGWHKNSPcy1TfRJJNtq4/bRVFpJuQtMmV5/5SrnqT3I3xycRQC/?=
 =?us-ascii?Q?5Q7yQyuvQSGPNY8T96ziVd4jYzhAFk7PVz5emCT0rzk682TjdBjST8SxA0kn?=
 =?us-ascii?Q?l0c42EIU71AP7tltgayNm7+6WOGT3T2Tlg+Dut6PdXXYr7A6Ch8Cm72eUE4a?=
 =?us-ascii?Q?TUEFoYDAXDjaRnskO6U2Pfo+nJP70DVOVyuqAG5845emKJneldWP+I9gETOv?=
 =?us-ascii?Q?FGXA93VB/TBDYN63kjlOXrqUAOI4NfHGKmskdXm8vkC3DeReEsJhu6tlM+lJ?=
 =?us-ascii?Q?KjwjrRmc+mj9VZEWcTUtpLNqSatQRSvWvEN3fJrRfvDxzy3Ay2ay/PK/pU9N?=
 =?us-ascii?Q?aIBuO74FoaA/uDRq0SsiZAll/zVvDyN42rDXkifhWET7wBZ121PfNfXa0FRQ?=
 =?us-ascii?Q?E4vAYUExamtCmYcqcWzC4xd4/B+Df+1r4rXqEVym?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da58c7c5-f7a4-4cd9-e17e-08db14a842e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:41:51.2011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sR1BFsjFsfBIpCOL8HnCJhFkdms03dRi38HA4/Pg4ko3KFe+3KbYxHt7ESNYziDHXlBzfWhdru7gAYWbDwIXlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6749
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
> Sent: Tuesday, February 21, 2023 11:48 AM
>=20
> This adds ioctl for userspace to attach device cdev fd to and detach
> from IOAS/hw_pagetable managed by iommufd.
>=20
>     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS,
> hw_pagetable
> 				   managed by iommufd. Attach can be
> 				   undo by
> VFIO_DEVICE_DETACH_IOMMUFD_PT
> 				   or device fd close.
>     VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the current
> attached
> 				   IOAS or hw_pagetable managed by
> iommufd.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
