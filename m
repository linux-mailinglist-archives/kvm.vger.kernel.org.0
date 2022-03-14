Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9724D79B4
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 04:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiCNDmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 23:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiCNDmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 23:42:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C037B272A;
        Sun, 13 Mar 2022 20:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647229254; x=1678765254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=22QAwi9z/VKpeTDRK3rvp8bSAbZd6E4CmquYmPwntq8=;
  b=TpGkKd/77lcpeF3Xt6lLiH41w+Kqor0rQRPeRKKx00vn8iqiX01XYhfK
   5AkkVDRmITtPo2PfE9eejV7s3Bvea+2+N1Kbm9jfVCsh0AvYFFki8vEsx
   nLcK2J7LFBuHNM+le1pFvgRBH1T5GBd6jDnJu+YOFwjK9LrMWk8XooCCr
   LGydcgfnAb35FIvhDt0U0qOa26GfbWlH2w1JL5tOXXeCutZAmMT84UltC
   0794PIBEQ/srWqHh0Lk5+BZYnzr/1k9pRqrMxtepOUQ9RY8Ibegnp/fro
   J31xignAVnyF/Ishm0yaKhUSLIqDyLtZa0gzvW8iFvDS0gxVJwKc4tTA9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="243374613"
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="243374613"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 20:40:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="549058690"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 Mar 2022 20:40:53 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sun, 13 Mar 2022 20:40:52 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sun, 13 Mar 2022 20:40:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Sun, 13 Mar 2022 20:40:52 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Sun, 13 Mar 2022 20:40:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5yis88O2YthDwkEA+1i1NcARgPksJFhFijQHerzNk8BGEXp5ie9mdT2l+jK7O5Ql/VL9zzxZGxCDm4s6/E0Ff3vbx5UxgKHBL59LsUD2SQfaaFni0dH94YsiMhCKFSBxK8EOBpc5eWTLBYOEk6gBmPUDMYHcjwaUG78GlFP0Yw1AGgip1M6wWAS/kgNoxRNBRighH6iR6ANbLvbUfoK673TD6syytkKFKaI03Y+caG3UJbA1qXGARHNkDCrOAyBkLHIVeEUNzCjSzRqW5Mty3num5CuS6pKQgD9XxTWICCCYw4TXNCQlsr8b2FLgh9scQ8xDdZt+fn7INccrytADA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=22QAwi9z/VKpeTDRK3rvp8bSAbZd6E4CmquYmPwntq8=;
 b=ZWqWA8sdTa4GQMyFQr1h3ogVjaEwZ5Qr3/yYXmH+cVNKAUEz4oU7fRTINaQ7HVxtKNYHXwm6baSmLrP9WuVOdTJKhQ+qQQzrFbKIXLgY8+8TZ4IeCM0jdUR/7M6v12c5Bt20b9ju+lR5wcQ3K6zjLSdFL9LSECBb4aTfrUaJrg77k4LwHQWzDLMNpO09PdArhGxn9HbEBpqfEWyEb19vf/8MHfPqnZUNcKm18oF8uBeRBfXpbdNnT2cKxIQyZqIbqxBJONMlL66OPYThQ5gyOJ9JAqQtXoFRtTbxKym7ZDBHph6CArhqSQMwttMhz9cSSXuKQ2+tcdJKyjSIwwXYOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN6PR11MB3312.namprd11.prod.outlook.com (2603:10b6:805:c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Mon, 14 Mar
 2022 03:40:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 03:40:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: RE: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYL1L4gR02rU84FUWBTBG9yRMgBqyvtjoAgASXrICAAAasAIAABpSAgADGSDCAAMaeAIAA1MMggAJlVQCABSgAwA==
Date:   Mon, 14 Mar 2022 03:40:49 +0000
Message-ID: <BN9PR11MB5276ADFF72558C8782911F758C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
        <20220304205720.GE219866@nvidia.com>
        <20220307120513.74743f17.alex.williamson@redhat.com>
        <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
        <20220307125239.7261c97d.alex.williamson@redhat.com>
        <BN9PR11MB5276EBE887402EBE22630BAB8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220308123312.1f4ba768.alex.williamson@redhat.com>
        <BN9PR11MB527634CCF86829E0680E5E678C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220310134954.0df4bb12.alex.williamson@redhat.com>
In-Reply-To: <20220310134954.0df4bb12.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c22ac714-da8e-488c-9214-08da056c6ea9
x-ms-traffictypediagnostic: SN6PR11MB3312:EE_
x-microsoft-antispam-prvs: <SN6PR11MB33122BF6E40E1F5FA8086A108C0F9@SN6PR11MB3312.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z/CNZRUs93kEmLOxJbfVqvpYWpNiT/I/+vJUp3hQwknH+wOHK2j048h2ySMB3fqkN6dwnWbTTXz27xFip5hVIvB4shrwute/dPCgjquhZjI7odFJY76k3Dl4n52Z068D+y5YiNiG+B8L+RbK6pDQRLD13SWfo0z4k43fKcfcV2o3p3m8pygyergyxH7gme9O8eYy0xEBe7sNi21lprLpIODT18wcW+L2zjC7PAUSc3l0+BluI6fhZ/HckOAcv+gmED6BgWFGnV942THSIApsl+QOFdo3lqtHGYmS3dLbqIwHP78V2R7a6T+hNBhLf6qSclT6NL3nRR55JgniJYepWge9WTM6vGV2ttQPU1INS1NdkSTwfyeswB2eNZMZPrECvoTH0mX4wRFw2hARf9yuBnW7M/xBg6Myt9r1ll282gOw9I4wAtPCFGAx/M/ngWgTebWxYSQHO40ZMFGnE+vBKKobSkWbpFU4I+pQtPvdnbwsMT9rGBDpKOXAPKrS/SLrRqOa/O1cQjj3+C1Rf99ggJyBUPlangNYO242/Z5wb/3d1DUmJTwd9oI50WrelNmxsLzFXhdG3lB9hlVqzXz82MUROM7ZUmZOPK4mQLU+vlOJnHC8VzEjLuRKUKIAN0bHPy3mRgaWEkzIbhSwLHFwNYPBYZzE04XcOr5Kr4Qk4UeGGRth/dj0TLdi/2ao6u+Cw5Js5/cWVMHJi8t0YvHcebs/vQQyHLg214DkOy/psog=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(122000001)(71200400001)(38070700005)(86362001)(6506007)(7696005)(2906002)(9686003)(82960400001)(38100700002)(508600001)(4326008)(8676002)(66556008)(76116006)(66946007)(66476007)(66446008)(64756008)(5660300002)(7416002)(52536014)(8936002)(55016003)(33656002)(83380400001)(54906003)(6916009)(316002)(60764002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWVuNENMUElwU0ZjZHh5Z2FQeW9sdXM0M2xnd0dXMks1S1ZBcnFMZExSYWl4?=
 =?utf-8?B?OGhqZ1FOcXJ0aCs4STJoUi9leHJEWGtTL1VtYVZuTFhya1orOXNQdU56NUZu?=
 =?utf-8?B?S2pXNm9QOFl2dmpuTExLeGVBM28xTEhJNzN6eTkvazFIbmlSNjVkTXI1bWl6?=
 =?utf-8?B?Sit4UmNsa2N6aE5aMGZXWEUwR0hhWEpITUk2OE9DOVArUy9hTWVUVXErWjE3?=
 =?utf-8?B?ZXRHRjB3L1N0RDlIZk1BOXE3eG1WazVibnNIYmtORXNhZTlFb2hPdWV5cEhq?=
 =?utf-8?B?dkRQRldHT09reXY5ZVBrVkkveWs1UlQ3R045bTFtNllJWjJuY0VmZTZGQ3hC?=
 =?utf-8?B?Y2tGbXo1emQxTWIzbEFYd0VxYWEzYzlMdmQ2cDlHYXlxZ04yY2pycXdvRVRr?=
 =?utf-8?B?ZHV0TVQ2UXFkeFl3ckkyUkFxQkRXWS9NbkxST1BScUcxeTFHME84ODNlZ3FO?=
 =?utf-8?B?ZU50VHp3bFpsb3Z1RGJwbWZndGpEUDZBdHRPeUY0ejhxanhPMWo4RDY3Wlhm?=
 =?utf-8?B?ejJjZUx0R3gvMGVyVVR0T0tkWUkrYVMvYkdPS0VPYzNEb1Z1RE1wMERLdmNq?=
 =?utf-8?B?ZWVxNGREbitVUkFxa24zR3V1NXJzeU9EUFA3djdHLyt3YXplMm1PdnUzVTdX?=
 =?utf-8?B?cUZIaEJFMjAreDJlaHlwTFhuTDRod2QyTS9zVERnNmZqL0o5bGx4WjNQMDZN?=
 =?utf-8?B?QjFLLzRPOHYwN09GL3g1dmRaWTMrc1QxOVZFc0ZRNlJxbUsrbUxBWDZWckFw?=
 =?utf-8?B?alVPRVZnV2lJQy9yZTJVMlpaT1o2RUVkOE8ya0xnREk4YjV3UnRzNHVxUWhT?=
 =?utf-8?B?c2IvNzc4WUp6ZnVHemJwK2EvdHhFNENzeW41M0xOSHdPcFYvbElSQnd1VDNB?=
 =?utf-8?B?VFRBaXdJVVV4RHBLRUptV1U5M2pGSnRENkVXNHBNUldyRmU2b0hHanBEVzBi?=
 =?utf-8?B?WlJCRVgrUWo0eExnR29hMmRPSC9jMFZDdXEzaG5ya0M0MHpmaU15NzN6aGY2?=
 =?utf-8?B?YXFPcnVBTy8vYXZsZnZyVmtRcUNsVFlaOWJHSkx1V0IzRG1LeGhHVGtEbitl?=
 =?utf-8?B?TVlReUVwdTV2em41Qy9OaFFSczVsaUd1ZnNqWllKYUtDSS9Tb1RlR0F2REtn?=
 =?utf-8?B?OWxIbG5veHkwVWw2a2M5S1BzWGtHVWdpZkw1V1NvcTB0clNJbFRjSWJTK1hm?=
 =?utf-8?B?VTV3TG5UTThZQkRDd2J0a1BaOGxKUE9WSVBXUnBGUmU1cXp5cERhU0Qxc1dK?=
 =?utf-8?B?d1d3TTZHTFllWnQwM3NXbzZmYnVKTG5HOWR4TDZOQmdYcm0wZm5PTUF6KzNS?=
 =?utf-8?B?dmpqM3E1NFpPeEVHMkJRRWQ3SFYvWUlTQ2s5aE84cEZwZHIzRm04WTM5UGZl?=
 =?utf-8?B?RnMvYWJKRGduTDI2SjFnbWVmWDhiQlRSM245SHlsNGF5emkwR1hpNXZaUFNq?=
 =?utf-8?B?eHJJR0dWUmg1YTR2L0VGZFNoV3drbEhIbjYzZVl4My9vODdaT2hTcmtwZXB5?=
 =?utf-8?B?cURsemZ6cWtiRWZPTUl3NkpnZndRVng4V3VhR3JLQ2tJY0hmcE5rcTQ3TVUv?=
 =?utf-8?B?SlQ5U2thc3JCSVhWTUhNQ05oWHI3OVcxcE0vRnJYRU1hNjYzaUJTV05xVmdP?=
 =?utf-8?B?ZWVzTFFMOThJRVpCbEVTVGlrU1VxcEx1WTllKzFYSWNrN0d1WWZYaDBpb1hp?=
 =?utf-8?B?em5WdXdDays3aXJ6VUNCWHcreGovd3VzdXBNSmhLNFlFNGFXd21NNDBneWcy?=
 =?utf-8?B?U0hscTZrYUtLdmlGcjB6RGlDdUg0S3NDOGhZOEdKUDRkaFBaY2RkMkpaR1Vn?=
 =?utf-8?B?VDBaQk5ISmg5UEE4MHhyeExkUkpLSjdkR0RucjkxZ01RUEtHYWk4VWdLNGEw?=
 =?utf-8?B?bmk2VW5jQyt5akxoKzh0SEJMNmd2bXVKRm5jcml3bUwvQUpQL1AvYmRqSU1G?=
 =?utf-8?Q?F/sk7N/R7nI/jISxVc6YVgh24Lfpgw9+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22ac714-da8e-488c-9214-08da056c6ea9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 03:40:49.6622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hANOzvY7Bfjww1EeaopW91xzLOAEqpDsdMb9SnHyCz8laDNIK/rEK6SdT7A/OaYr4EsBCr2B0Sifs2JuIi4usQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3312
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBGcmlkYXksIE1hcmNoIDExLCAyMDIyIDQ6NTAgQU0NCj4gDQo+IE9uIFdlZCwgOSBNYXIg
MjAyMiAxMDoxMTowNiArMDAwMA0KPiAiVGlhbiwgS2V2aW4iIDxrZXZpbi50aWFuQGludGVsLmNv
bT4gd3JvdGU6DQo+IA0KPiA+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1z
b25AcmVkaGF0LmNvbT4NCj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggOSwgMjAyMiAzOjMz
IEFNDQo+ID4gPg0KPiA+ID4gT24gVHVlLCA4IE1hciAyMDIyIDA4OjExOjExICswMDAwDQo+ID4g
PiAiVGlhbiwgS2V2aW4iIDxrZXZpbi50aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+
ID4gPiA+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+
DQo+ID4gPiA+ID4gU2VudDogVHVlc2RheSwgTWFyY2ggOCwgMjAyMiAzOjUzIEFNDQo+ID4gPiA+
ID4gPg0KPiA+ID4gPiA+ID4gPiBJIHRoaW5rIHdlIHN0aWxsIHJlcXVpcmUgYWNrcyBmcm9tIEJq
b3JuIGFuZCBaYWlibyBmb3Igc2VsZWN0IHBhdGNoZXMNCj4gPiA+ID4gPiA+ID4gaW4gdGhpcyBz
ZXJpZXMuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gSSBjaGVja2VkIHdpdGggWmlhYm8uIEhl
IG1vdmVkIHByb2plY3RzIGFuZCBpcyBubyBsb25nZXIgbG9va2luZw0KPiBpbnRvDQo+ID4gPiA+
ID4gY3J5cHRvIHN0dWZmLg0KPiA+ID4gPiA+ID4gV2FuZ3pob3UgYW5kIExpdUxvbmdmYW5nIG5v
dyB0YWtlIGNhcmUgb2YgdGhpcy4gUmVjZWl2ZWQgYWNrcw0KPiBmcm9tDQo+ID4gPiA+ID4gV2Fu
Z3pob3UNCj4gPiA+ID4gPiA+IGFscmVhZHkgYW5kIEkgd2lsbCByZXF1ZXN0IExvbmdmYW5nIHRv
IHByb3ZpZGUgaGlzLiBIb3BlIHRoYXQncyBvay4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE1heWJl
IGEgZ29vZCB0aW1lIHRvIGhhdmUgdGhlbSB1cGRhdGUgTUFJTlRBSU5FUlMgYXMgd2VsbC4NCj4g
VGhhbmtzLA0KPiA+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+IEkgaGF2ZSBvbmUgcXVlc3Rpb24g
aGVyZSAoc2ltaWxhciB0byB3aGF0IHdlIGRpc2N1c3NlZCBmb3IgbWRldg0KPiBiZWZvcmUpLg0K
PiA+ID4gPg0KPiA+ID4gPiBOb3cgd2UgYXJlIGFkZGluZyB2ZW5kb3Igc3BlY2lmaWMgZHJpdmVy
cyB1bmRlciAvZHJpdmVycy92ZmlvLiBUd28NCj4gZHJpdmVycw0KPiA+ID4gPiBvbiByYWRhciBh
bmQgbW9yZSB3aWxsIGNvbWUuIFRoZW4gd2hhdCB3b3VsZCBiZSB0aGUgY3JpdGVyaWEgZm9yDQo+
ID4gPiA+IGFjY2VwdGluZyBzdWNoIGEgZHJpdmVyPyBEbyB3ZSBwcmVmZXIgdG8gYSBtb2RlbCBp
biB3aGljaCB0aGUgYXV0aG9yDQo+ID4gPiBzaG91bGQNCj4gPiA+ID4gcHJvdmlkZSBlbm91Z2gg
YmFja2dyb3VuZCBmb3IgdmZpbyBjb21tdW5pdHkgdG8gdW5kZXJzdGFuZCBob3cgaXQNCj4gPiA+
IHdvcmtzDQo+ID4gPiA+IG9yIGFzIGRvbmUgaGVyZSBqdXN0IHJlbHkgb24gdGhlIFBGIGRyaXZl
ciBvd25lciB0byBjb3ZlciBkZXZpY2Ugc3BlY2lmaWMNCj4gPiA+ID4gY29kZT8NCj4gPiA+ID4N
Cj4gPiA+ID4gSWYgdGhlIGZvcm1lciB3ZSBtYXkgbmVlZCBkb2N1bWVudCBzb21lIHByb2Nlc3Mg
Zm9yIHdoYXQNCj4gaW5mb3JtYXRpb24NCj4gPiA+ID4gaXMgbmVjZXNzYXJ5IGFuZCBhbHNvIG5l
ZWQgc2VjdXJlIGluY3JlYXNlZCByZXZpZXcgYmFuZHdpZHRoIGZyb20ga2V5DQo+ID4gPiA+IHJl
dmlld2VycyBpbiB2ZmlvIGNvbW11bml0eS4NCj4gPiA+ID4NCj4gPiA+ID4gSWYgdGhlIGxhdHRl
ciB0aGVuIGhvdyBjYW4gd2UgZ3VhcmFudGVlIG5vIGNvcm5lciBjYXNlIG92ZXJsb29rZWQgYnkN
Cj4gYm90aA0KPiA+ID4gPiBzaWRlcyAoaS5lLiBob3cgdG8ga25vdyB0aGUgY292ZXJhZ2Ugb2Yg
dG90YWwgcmV2aWV3cyk/IEFub3RoZXIgb3BlbiBpcw0KPiA+ID4gd2hvDQo+ID4gPiA+IGZyb20g
dGhlIFBGIGRyaXZlciBzdWItc3lzdGVtIHNob3VsZCBiZSBjb25zaWRlcmVkIGFzIHRoZSBvbmUg
dG8gZ2l2ZQ0KPiB0aGUNCj4gPiA+ID4gZ3JlZW4gc2lnbmFsLiBJZiB0aGUgc3ViLXN5c3RlbSBt
YWludGFpbmVyIHRydXN0cyB0aGUgUEYgZHJpdmVyIG93bmVyDQo+IGFuZA0KPiA+ID4gPiBqdXN0
IHB1bGxzIGNvbW1pdHMgZnJvbSBoaW0gdGhlbiBoYXZpbmcgdGhlIHItYiBmcm9tIHRoZSBQRiBk
cml2ZXINCj4gb3duZXIgaXMNCj4gPiA+ID4gc3VmZmljaWVudC4gQnV0IGlmIHRoZSBzdWItc3lz
dGVtIG1haW50YWluZXIgd2FudHMgdG8gcmV2aWV3IGRldGFpbA0KPiBjaGFuZ2UNCj4gPiA+ID4g
aW4gZXZlcnkgdW5kZXJseWluZyBkcml2ZXIgdGhlbiB3ZSBwcm9iYWJseSBhbHNvIHdhbnQgdG8g
Z2V0IHRoZSBhY2sNCj4gZnJvbQ0KPiA+ID4gPiB0aGUgbWFpbnRhaW5lci4NCj4gPiA+ID4NCj4g
PiA+ID4gT3ZlcmFsbCBJIGRpZG4ndCBtZWFuIHRvIHNsb3cgZG93biB0aGUgcHJvZ3Jlc3Mgb2Yg
dGhpcyBzZXJpZXMuIEJ1dA0KPiBhYm92ZQ0KPiA+ID4gPiBkb2VzIGJlIHNvbWUgcHV6emxlIG9j
Y3VycmVkIGluIG15IHJldmlldy4g8J+Yig0KPiA+ID4NCj4gPiA+IEhpIEtldmluLA0KPiA+ID4N
Cj4gPiA+IEdvb2QgcXVlc3Rpb25zLCBJJ2QgbGlrZSBhIGJldHRlciB1bmRlcnN0YW5kaW5nIG9m
IGV4cGVjdGF0aW9ucyBhcw0KPiA+ID4gd2VsbC4gIEkgdGhpbmsgdGhlIGludGVudGlvbnMgYXJl
IHRoZSBzYW1lIGFzIGFueSBvdGhlciBzdWItc3lzdGVtLCB0aGUNCj4gPiA+IGRyaXZlcnMgbWFr
ZSB1c2Ugb2Ygc2hhcmVkIGludGVyZmFjZXMgYW5kIGV4dGVuc2lvbnMgYW5kIHRoZSByb2xlIG9m
DQo+ID4gPiB0aGUgc3ViLXN5c3RlbSBzaG91bGQgYmUgdG8gbWFrZSBzdXJlIHRob3NlIGludGVy
ZmFjZXMgYXJlIHVzZWQNCj4gPiA+IGNvcnJlY3RseSBhbmQgZXh0ZW5zaW9ucyBmaXQgd2VsbCB3
aXRoaW4gdGhlIG92ZXJhbGwgZGVzaWduLiAgSG93ZXZlciwNCj4gPiA+IGp1c3QgYXMgdGhlIG5l
dHdvcmsgbWFpbnRhaW5lciBpc24ndCBleHBlY3RlZCB0byBmdWxseSB1bmRlcnN0YW5kIGV2ZXJ5
DQo+ID4gPiBOSUMgZHJpdmVyLCBJIHRoaW5rL2hvcGUgd2UgaGF2ZSB0aGUgc2FtZSBleHBlY3Rh
dGlvbnMgaGVyZS4gIEl0J3MNCj4gPiA+IGNlcnRhaW5seSBhIGJlbmVmaXQgdG8gdGhlIGNvbW11
bml0eSBhbmQgcGVyY2VpdmVkIHRydXN0d29ydGhpbmVzcyBpZg0KPiA+ID4gZWFjaCBkcml2ZXIg
b3V0bGluZXMgaXRzIG9wZXJhdGluZyBtb2RlbCBhbmQgc2VjdXJpdHkgbnVhbmNlcywgYnV0DQo+
ID4gPiB0aG9zZSBhcmUgb25seSBldmVyIGdvaW5nIHRvIGJlIHRoZSBudWFuY2VzIGlkZW50aWZp
ZWQgYnkgdGhlIHBlb3BsZQ0KPiA+ID4gd2hvIGhhdmUgdGhlIGFjY2VzcyBhbmQgZW5lcmd5IHRv
IGV2YWx1YXRlIHRoZSBkZXZpY2UuDQo+ID4gPg0KPiA+ID4gSXQncyBnb2luZyB0byBiZSB1cCB0
byB0aGUgY29tbXVuaXR5IHRvIHRyeSB0byBkZXRlcm1pbmUgdGhhdCBhbnkgbmV3DQo+ID4gPiBk
cml2ZXJzIGFyZSBzZXJpb3VzbHkgY29uc2lkZXJpbmcgc2VjdXJpdHkgYW5kIG5vdCBvcGVuaW5n
IGFueSBuZXcgZ2Fwcw0KPiA+ID4gcmVsYXRpdmUgdG8gYmVoYXZpb3IgdXNpbmcgdGhlIGJhc2Ug
dmZpby1wY2kgZHJpdmVyLiAgRm9yIHRoZSBkcml2ZXINCj4gPiA+IGV4YW1wbGVzIHdlIGhhdmUs
IHRoaXMgc2VlbXMgYSBiaXQgZWFzaWVyIHRoYW4gZXZhbHVhdGluZyBhbiBlbnRpcmUNCj4gPiA+
IG1kZXYgZGV2aWNlIGJlY2F1c2UgdGhleSdyZSBsYXJnZWx5IHByb3ZpZGluZyBkaXJlY3QgYWNj
ZXNzIHRvIHRoZQ0KPiA+ID4gZGV2aWNlIHJhdGhlciB0aGFuIHRyeWluZyB0byBtdWx0aXBsZXgg
YSBzaGFyZWQgcGh5c2ljYWwgZGV2aWNlLiAgV2UNCj4gPiA+IGNhbiB0aGVyZWZvcmUgZm9jdXMg
b24gaW5jcmVtZW50YWwgZnVuY3Rpb25hbGl0eSwgYXMgYm90aCBkcml2ZXJzIGhhdmUNCj4gPiA+
IGRvbmUsIGltcGxlbWVudGluZyBhIGJvaWxlcnBsYXRlIHZlbmRvciBkcml2ZXIsIHRoZW4gYWRk
aW5nIG1pZ3JhdGlvbg0KPiA+ID4gc3VwcG9ydC4gIEkgaW1hZ2luZSB0aGlzIHdvbid0IGFsd2F5
cyBiZSB0aGUgY2FzZSB0aG91Z2ggYW5kIHNvbWUNCj4gPiA+IGRyaXZlcnMgd2lsbCByZS1pbXBs
ZW1lbnQgbXVjaCBvZiB0aGUgY29yZSB0byBzdXBwb3J0IGZ1cnRoZXIgZW11bGF0aW9uDQo+ID4g
PiBhbmQgc2hhcmVkIHJlc291cmNlcy4NCj4gPiA+DQo+ID4gPiBTbyBob3cgZG8gd2UgYXMgYSBj
b21tdW5pdHkgd2FudCB0byBoYW5kbGUgdGhpcz8gIEkgd291bGRuJ3QgbWluZCwgSSdkDQo+ID4g
PiBhY3R1YWxseSB3ZWxjb21lLCBzb21lIHNvcnQgb2YgcmV2aWV3IHJlcXVpcmVtZW50IGZvciBu
ZXcgdmZpbyB2ZW5kb3INCj4gPiA+IGRyaXZlciB2YXJpYW50cy4gIElzIHRoYXQgcmVhc29uYWJs
ZT8gIFdoYXQgd291bGQgYmUgdGhlIGNyaXRlcmlhPw0KPiA+ID4gQXBwcm92YWwgZnJvbSB0aGUg
UEYgZHJpdmVyIG93bmVyLCBpZiBkaWZmZXJlbnQvbmVjZXNzYXJ5LCBhbmQgYXQgbGVhc3QNCj4g
PiA+IG9uZSB1bmFmZmlsaWF0ZWQgcmV2aWV3ZXIgKHByZWZlcmFibHkgYW4gYWN0aXZlIHZmaW8g
cmV2aWV3ZXIgb3INCj4gPiA+IGV4aXN0aW5nIHZmaW8gdmFyaWFudCBkcml2ZXIgb3duZXIvY29u
dHJpYnV0b3IpPyAgSWRlYXMgd2VsY29tZS4NCj4gPiA+IFRoYW5rcywNCj4gPiA+DQo+ID4NCj4g
PiBZZXMsIGFuZCB0aGUgY3JpdGVyaWEgaXMgdGhlIGhhcmQgcGFydC4gSW4gdGhlIGVuZCBpdCBs
YXJnZWx5IGRlcGVuZCBvbg0KPiA+IHRoZSBleHBlY3RhdGlvbnMgb2YgdGhlIHJldmlld2Vycy4N
Cj4gPg0KPiA+IElmIHRoZSB1bmFmZmlsaWF0ZWQgcmV2aWV3ZXIgb25seSBjYXJlcyBhYm91dCB0
aGUgdXNhZ2Ugb2Ygc2hhcmVkDQo+ID4gaW50ZXJmYWNlcyBvciBleHRlbnNpb25zIGFzIHlvdSBz
YWlkIHRoZW4gd2hhdCB0aGlzIHNlcmllcyBkb2VzIGlzDQo+ID4ganVzdCBmaW5lLiBTdWNoIHR5
cGUgb2YgcmV2aWV3IGNhbiBiZSBlYXNpbHkgZG9uZSB2aWEgcmVhZGluZyBjb2RlDQo+ID4gYW5k
IGRvZXNuJ3QgcmVxdWlyZSBkZXRhaWwgZGV2aWNlIGtub3dsZWRnZS4NCj4gPg0KPiA+IE9uIHRo
ZSBvdGhlciBoYW5kIGlmIHRoZSByZXZpZXdlciB3YW50cyB0byBkbyBhIGZ1bGwgZnVuY3Rpb25h
bA0KPiA+IHJldmlldyBvZiBob3cgbWlncmF0aW9uIGlzIGFjdHVhbGx5IHN1cHBvcnRlZCBmb3Ig
c3VjaCBkZXZpY2UsDQo+ID4gd2hhdGV2ZXIgaW5mb3JtYXRpb24gKHBhdGNoIGRlc2NyaXB0aW9u
LCBjb2RlIGNvbW1lbnQsIGtkb2MsDQo+ID4gZXRjLikgbmVjZXNzYXJ5IHRvIGJ1aWxkIGEgc3Rh
bmRhbG9uZSBtaWdyYXRpb24gc3Rvcnkgd291bGQgYmUNCj4gPiBhcHByZWNpYXRlZCwgZS5nLjoN
Cj4gPg0KPiA+ICAgLSBXaGF0IGNvbXBvc2VzIHRoZSBkZXZpY2Ugc3RhdGU/DQo+ID4gICAtIFdo
aWNoIHBvcnRpb24gb2YgdGhlIGRldmljZSBzdGF0ZSBpcyBleHBvc2VkIHRvIGFuZCBtYW5hZ2Vk
DQo+ID4gICAgIGJ5IHRoZSB1c2VyIGFuZCB3aGljaCBpcyBoaWRkZW4gZnJvbSB0aGUgdXNlciAo
aS5lLiBjb250cm9sbGVkDQo+ID4gICAgIGJ5IHRoZSBQRiBkcml2ZXIpPw0KPiA+ICAgLSBJbnRl
cmZhY2UgYmV0d2VlbiB0aGUgdmZpbyBkcml2ZXIgYW5kIHRoZSBkZXZpY2UgKGFuZC9vciBQRg0K
PiA+ICAgICBkcml2ZXIpIHRvIG1hbmFnZSB0aGUgZGV2aWNlIHN0YXRlOw0KPiA+ICAgLSBSaWNo
IGZ1bmN0aW9uYWwtbGV2ZWwgY29tbWVudHMgZm9yIHRoZSByZXZpZXdlciB0byBkaXZlIGludG8N
Cj4gPiAgICAgdGhlIG1pZ3JhdGlvbiBmbG93Ow0KPiA+ICAgLSAuLi4NCj4gPg0KPiA+IEkgZ3Vl
c3Mgd2UgZG9uJ3Qgd2FudCB0byBmb3JjZSBvbmUgbW9kZWwgb3ZlciB0aGUgb3RoZXIuIEp1c3QN
Cj4gPiBmcm9tIG15IGltcHJlc3Npb24gdGhlIG1vcmUgaW5mb3JtYXRpb24gdGhlIGRyaXZlciBj
YW4NCj4gPiBwcm92aWRlIHRoZSBtb3JlIHRpbWUgSSdkIGxpa2UgdG8gc3BlbmQgb24gdGhlIHJl
dmlldy4gT3RoZXJ3aXNlDQo+ID4gaXQgaGFzIHRvIHRyZW5kIHRvIHRoZSBtaW5pbWFsIGZvcm0g
aS5lLiB0aGUgZmlyc3QgbW9kZWwuDQo+ID4NCj4gPiBhbmQgY3VycmVudGx5IEkgZG9uJ3QgaGF2
ZSBhIGNvbmNyZXRlIGlkZWEgaG93IHRoZSAybmQgbW9kZWwgd2lsbA0KPiA+IHdvcmsuIG1heWJl
IGl0IHdpbGwgZ2V0IGNsZWFyIG9ubHkgd2hlbiBhIGZ1dHVyZSBkcml2ZXIgYXR0cmFjdHMNCj4g
PiBwZW9wbGUgdG8gZG8gdGhvcm91Z2ggcmV2aWV3Li4uDQo+IA0KPiBEbyB5b3UgdGhpbmsgd2Ug
c2hvdWxkIGdvIHNvIGZhciBhcyB0byBmb3JtYWxpemUgdGhpcyB2aWEgYSBNQUlOVEFJTkVSUw0K
PiBlbnRyeSwgZm9yIGV4YW1wbGU6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92
ZmlvL3ZmaW8tcGNpLXZlbmRvci1kcml2ZXItYWNjZXB0YW5jZS5yc3QNCj4gYi9Eb2N1bWVudGF0
aW9uL3ZmaW8vdmZpby1wY2ktdmVuZG9yLWRyaXZlci1hY2NlcHRhbmNlLnJzdA0KPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjU0ZWJhZmNkZDczNQ0KPiAtLS0g
L2Rldi9udWxsDQo+ICsrKyBiL0RvY3VtZW50YXRpb24vdmZpby92ZmlvLXBjaS12ZW5kb3ItZHJp
dmVyLWFjY2VwdGFuY2UucnN0DQo+IEBAIC0wLDAgKzEsMzUgQEANCj4gKy4uIFNQRFgtTGljZW5z
ZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ICsNCj4gK0FjY2VwdGFuY2UgY3JpdGVyaWEgZm9yIHZm
aW8tcGNpIGRldmljZSBzcGVjaWZpYyBkcml2ZXIgdmFyaWFudHMNCj4gKz09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA9DQo+
ICsNCj4gK092ZXJ2aWV3DQo+ICstLS0tLS0tLQ0KPiArVGhlIHZmaW8tcGNpIGRyaXZlciBleGlz
dHMgYXMgYSBkZXZpY2UgYWdub3N0aWMgZHJpdmVyIHVzaW5nIHRoZQ0KPiArc3lzdGVtIElPTU1V
IGFuZCByZWx5aW5nIG9uIHRoZSByb2J1c3RuZXNzIG9mIHBsYXRmb3JtIGZhdWx0DQo+ICtoYW5k
bGluZyB0byBwcm92aWRlIGlzb2xhdGVkIGRldmljZSBhY2Nlc3MgdG8gdXNlcnNwYWNlLiAgV2hp
bGUgdGhlDQo+ICt2ZmlvLXBjaSBkcml2ZXIgZG9lcyBpbmNsdWRlIHNvbWUgZGV2aWNlIHNwZWNp
ZmljIHN1cHBvcnQsIGZ1cnRoZXINCj4gK2V4dGVuc2lvbnMgZm9yIHlldCBtb3JlIGFkdmFuY2Vk
IGRldmljZSBzcGVjaWZpYyBmZWF0dXJlcyBhcmUgbm90DQo+ICtzdXN0YWluYWJsZS4gIFRoZSB2
ZmlvLXBjaSBkcml2ZXIgaGFzIHRoZXJlZm9yZSBzcGxpdCBvdXQNCj4gK3ZmaW8tcGNpLWNvcmUg
YXMgYSBsaWJyYXJ5IHRoYXQgbWF5IGJlIHJldXNlZCB0byBpbXBsZW1lbnQgZmVhdHVyZXMNCj4g
K3JlcXVpcmluZyBkZXZpY2Ugc3BlY2lmaWMga25vd2xlZGdlLCBleC4gc2F2aW5nIGFuZCBsb2Fk
aW5nIGRldmljZQ0KPiArc3RhdGUgZm9yIHRoZSBwdXJwb3NlcyBvZiBzdXBwb3J0aW5nIG1pZ3Jh
dGlvbi4NCj4gKw0KPiArSW4gc3VwcG9ydCBvZiBzdWNoIGZlYXR1cmVzLCBpdCdzIGV4cGVjdGVk
IHRoYXQgc29tZSBkZXZpY2Ugc3BlY2lmaWMNCj4gK3ZhcmlhbnRzIG1heSBpbnRlcmFjdCB3aXRo
IHBhcmVudCBkZXZpY2VzIChleC4gU1ItSU9WIFBGIGluIHN1cHBvcnQgb2YNCj4gK2EgdXNlciBh
c3NpZ25lZCBWRikgb3Igb3RoZXIgZXh0ZW5zaW9ucyB0aGF0IG1heSBub3QgYmUgb3RoZXJ3aXNl
DQo+ICthY2Nlc3NpYmxlIHZpYSB0aGUgdmZpby1wY2kgYmFzZSBkcml2ZXIuICBBdXRob3JzIG9m
IHN1Y2ggZHJpdmVycw0KPiArc2hvdWxkIGJlIGRpbGlnZW50IG5vdCB0byBjcmVhdGUgZXhwbG9p
dGFibGUgaW50ZXJmYWNlcyB2aWEgc3VjaA0KPiAraW50ZXJhY3Rpb25zIG9yIGFsbG93IHVuY2hl
Y2tlZCB1c2Vyc3BhY2UgZGF0YSB0byBoYXZlIGFuIGVmZmVjdA0KPiArYmV5b25kIHRoZSBzY29w
ZSBvZiB0aGUgYXNzaWduZWQgZGV2aWNlLg0KPiArDQo+ICtOZXcgZHJpdmVyIHN1Ym1pc3Npb25z
IGFyZSB0aGVyZWZvcmUgcmVxdWVzdGVkIHRvIGhhdmUgYXBwcm92YWwgdmlhDQo+ICtTaWduLW9m
ZiBmb3IgYW55IGludGVyYWN0aW9ucyB3aXRoIHBhcmVudCBkcml2ZXJzLiAgQWRkaXRpb25hbGx5
LA0KPiArZHJpdmVycyBzaG91bGQgbWFrZSBhbiBhdHRlbXB0IHRvIHByb3ZpZGUgc3VmZmljaWVu
dCBkb2N1bWVudGF0aW9uDQo+ICtmb3IgcmV2aWV3ZXJzIHRvIHVuZGVyc3RhbmQgdGhlIGRldmlj
ZSBzcGVjaWZpYyBleHRlbnNpb25zLCBmb3INCj4gK2V4YW1wbGUgaW4gdGhlIGNhc2Ugb2YgbWln
cmF0aW9uIGRhdGEsIGhvdyBpcyB0aGUgZGV2aWNlIHN0YXRlDQo+ICtjb21wb3NlZCBhbmQgY29u
c3VtZWQsIHdoaWNoIHBvcnRpb25zIGFyZSBub3Qgb3RoZXJ3aXNlIGF2YWlsYWJsZSB0bw0KPiAr
dGhlIHVzZXIgdmlhIHZmaW8tcGNpLCB3aGF0IHNhZmVndWFyZHMgZXhpc3QgdG8gdmFsaWRhdGUg
dGhlIGRhdGEsDQo+ICtldGMuICBUbyB0aGF0IGV4dGVudCwgYXV0aG9ycyBzaG91bGQgYWRkaXRp
b25hbGx5IGV4cGVjdCB0byByZXF1aXJlDQo+ICtyZXZpZXdzIGZyb20gYXQgbGVhc3Qgb25lIG9m
IHRoZSBsaXN0ZWQgcmV2aWV3ZXJzLCBpbiBhZGRpdGlvbiB0byB0aGUNCj4gK292ZXJhbGwgdmZp
byBtYWludGFpbmVyLg0KPiBkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUw0K
PiBpbmRleCA0MzIyYjUzMjE4OTEuLjRmN2QyNmY5YWFjNiAxMDA2NDQNCj4gLS0tIGEvTUFJTlRB
SU5FUlMNCj4gKysrIGIvTUFJTlRBSU5FUlMNCj4gQEAgLTIwMzE0LDYgKzIwMzE0LDEzIEBAIEY6
CWRyaXZlcnMvdmZpby9tZGV2Lw0KPiAgRjoJaW5jbHVkZS9saW51eC9tZGV2LmgNCj4gIEY6CXNh
bXBsZXMvdmZpby1tZGV2Lw0KPiANCj4gK1ZGSU8gUENJIFZFTkRPUiBEUklWRVJTDQo+ICtSOglZ
b3VyIE5hbWUgPHlvdXIubmFtZUBoZXJlLmNvbT4NCj4gK0w6CWt2bUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gK1M6CU1haW50YWluZWQNCj4gK1A6CURvY3VtZW50YXRpb24vdmZpby92ZmlvLXBjaS12ZW5k
b3ItZHJpdmVyLWFjY2VwdGFuY2UucnN0DQo+ICtGOglkcml2ZXJzL3ZmaW8vcGNpLyovDQo+ICsN
Cj4gIFZGSU8gUExBVEZPUk0gRFJJVkVSDQo+ICBNOglFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJl
ZGhhdC5jb20+DQo+ICBMOglrdm1Admdlci5rZXJuZWwub3JnDQo+IA0KPiBJZGVhbGx5IHdlJ2Qg
aGF2ZSBhdCBsZWFzdCBZaXNoYWksIFNoYW1lZXIsIEphc29uLCBhbmQgeW91cnNlbGYgbGlzdGVk
DQo+IGFzIHJldmlld2VycyAoQ29ubmllIGFuZCBJIGFyZSBpbmNsdWRlZCB2aWEgdGhlIGhpZ2hl
ciBsZXZlbCBlbnRyeSkuDQo+IFRob3VnaHRzIGZyb20gYW55b25lPyAgVm9sdW50ZWVycyBmb3Ig
cmV2aWV3ZXJzIGlmIHdlIHdhbnQgdG8gcHJlc3MNCj4gZm9yd2FyZCB3aXRoIHRoaXMgYXMgZm9y
bWFsIGFjY2VwdGFuY2UgY3JpdGVyaWE/ICBUaGFua3MsDQo+IA0KDQpZZXMsIHRoaXMgd29ya3Mg
Zm9yIG1lLiBNb3ZpbmcgZm9yd2FyZCB0aGUga2RvYyBtYXkgYmUgZXhwYW5kZWQNCnRvIGluY2x1
ZGUgY2VydGFpbiB0ZW1wbGF0ZS9leGFtcGxlIHRvIGRlbW9uc3RyYXRlIG5lY2Vzc2FyeSANCmlu
Zm9ybWF0aW9uIHRvIGJlIHByb3ZpZGVkIGJ5IHZlbmRvciBkcml2ZXJzIGlmIGNvbW1vbiByZXZp
ZXcNCmdhcHMgYXJlIHJlcGVhdGVkbHkgaWRlbnRpZmllZCBmcm9tIHByYWN0aWNlLg0KDQpUaGFu
a3MNCktldmluDQo=
