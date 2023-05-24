Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B6070F0CA
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbjEXIcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239955AbjEXIcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:32:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F2C97;
        Wed, 24 May 2023 01:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684917121; x=1716453121;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WWiUbi2RSS/xN4DKaZ/zJ8ysJFSOT5OkO+zz12sIxkA=;
  b=ZNI98UvfcLSil7LiBctWoYTg/pGXY6n37Wz1D1Anr5H1RYwXwIQD+W/J
   waOj2ZAkBWFKWnf4YhlhNbTumYMUq7WGKn4NMs5XD3CKMFeZ8vZRvb0QV
   5TFbcq1NuZzdroN+kl/1eMtyOyXJSA2CCIH8ykPBlEeUAh/8JnmkaNMSw
   z62PpsqXShv+A1BkcaaNZuymf6mU0FVDa6MatslCN2doFnwDnoXWlh3EY
   YPZJ4vTfy4yaCGnlqVh8gELU+eyD43U/ABu+w4fBWn6YA0/cWu3Bt//Vs
   492NuerBshz1mnrwJbtzLSNUQ7gkaHAcp6H9NMHlbspjfDbBBI9iSB2+J
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="333120111"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="333120111"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:31:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="707422849"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="707422849"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2023 01:31:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:31:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 01:31:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 01:31:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VALiZPszyNYuqQY07pCoCN6lIPW3Uc8fODwk0M5kcm8jREtV/5ZVEcjGTAeXNCyBQz7jOxiAgBXuRUEhTy0/qjq3CL8Q68l3Fj2zLutSXURyEvVxlpVjn9N5t8OaiaAcwS6uus0C8bOLlbR0TcgruI5FSnVJVj8YSvIx+mAs4h6HJjyr7kQDs6KJyypc35w9ujo/MWH4U7jaD6nhQ1bOVM5N6BcUKrAuPoD9HZCdjodMNH9X9WsNAmzX0LuHNV6bcIlYhm8WKz3hYWZgQgj7C8hf0bMJIp3jwg4MXXy/SgtMLYeP7hFoDQYZVHgGvPsKGHdzAyifoQbR90+N5qqY9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWiUbi2RSS/xN4DKaZ/zJ8ysJFSOT5OkO+zz12sIxkA=;
 b=gVAS0sduL0lWVhjndG4TnkkBqsL1kal+4MplnreH8TF3lZnHLZHY6m3X49h71s+1s5Xl/EdvX000jxrU0OA+QiFdTU0Yhpk8ABSL384qD0PTLnLWv6gSu6UZ+XYs9eG4MD4G3uA6fhKCSae95U8wQoQragIe97jw7hZDAn/99duX4U+AoAzV/I23zkUgN3tQWtCo59SqhOkvyW9nqVD4eiIVZ0pifbuRrg0WO7JIzWwTLBuRh9aQBhGoxu7sSONczyCVSRsHDP03xddx/80ldKcJfT/hRi1unc+IHUIvKO7BnKT8U36BoAHDvtw1kp0F1wv3e9fwSpU50UrKP+IdPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6404.namprd11.prod.outlook.com (2603:10b6:510:1f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 08:31:48 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 08:31:48 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
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
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZhZ7k65TFikm5KUKI3FkaFFDbUK9m5qgAgAA8RCCAAO6sgIAArYHQgAAHgQCAAAA4gIAAXi/w
Date:   Wed, 24 May 2023 08:31:48 +0000
Message-ID: <DS0PR11MB75290F3CFE0DA02A8A5A8997C3419@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-20-yi.l.liu@intel.com>
        <20230522160124.768430b4.alex.williamson@redhat.com>
        <DS0PR11MB752935BF70AC95B564685DC0C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230523095121.1a7a255d.alex.williamson@redhat.com>
 <DS0PR11MB75292184D6938DF4193C318EC3419@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276415D558B1BBA5C19A2AA8C419@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529F262A9088E582700C3AAC3419@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529F262A9088E582700C3AAC3419@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB6404:EE_
x-ms-office365-filtering-correlation-id: cd97bd79-9437-4a4c-79f6-08db5c3150ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: khhde8LuS7GkTZ+oR2L7FZndqAiqIUm69TGyUjtNMVu7ahtzk4vYiEuWSv/A/kaiCy6bzn7Ba1Oq2NzenJzX8o+Ec3cf5l/k+6p8varFhEzb2KxKno1EZ3dJZsp2is08F12mXoy144hgagr3qR5GeFgRXI5TD7rTnudsEcq0BbVCPVIExeOI6AsXxRmvgTQZZT900ZpoZtPHJI9vQk2zV75SA6NGR54T3vYy92WnaJeCuSTy6WmloZuJfFqdJ0awVENbrGQ9GSxulnoUc+ieV5eWdJFmmfS2qeT1XAZmh63FMlX0At3BuYgq9rWctqzl7vcAhX72+x9T0pOm2zg5zqBCUKm59v8Qm7AsnXxMGePdVWiKA84iHLNzkEuPc0IPRMhy0xsmKHrRa4NQZ2CTGq459Yrmnb/FCNHqGZ6h0JCjqOD6Pu9LNjzPsnDzKYLZnBxf0TzD0IolSASX1BJIvi05roGKoRX3kcwz6uB0tvctYP6fSfHLuoahecJRzqdtY6eta0xVbXdPILtzJJ+cv04UrPLorwS8ZLscAAx/cYT5A7g0+taEY27vX6w84AZumoJy+W9XkY3aUuF7nLb0IZxnT474BilbNtKaz3SwdiPk+4sjDVkqPkQm4s/1l5CH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(7696005)(122000001)(38100700002)(8676002)(8936002)(38070700005)(7416002)(82960400001)(5660300002)(52536014)(9686003)(55016003)(6506007)(26005)(2940100002)(186003)(2906002)(83380400001)(33656002)(966005)(86362001)(316002)(110136005)(71200400001)(54906003)(66446008)(64756008)(4326008)(66946007)(76116006)(478600001)(45080400002)(66476007)(66556008)(41300700001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzR4TVkvaXFONlZDMExhNnJFM3RDaEdNY1IzMk0vRTVLamMwYm9zK1ZmbXNx?=
 =?utf-8?B?U2FUaWpHZExjNUxjaVY5bFNzc2UrOEVsc1Jmd28vQU1qelR2MFBtUmxYTlg5?=
 =?utf-8?B?blhGZ0hVZDVSWkQ0a1dkempHOEhVZW8vUzI3SDJRNTBqTERuY0RTQVFLVC9T?=
 =?utf-8?B?TzlOOHVlUDAvTFBUVXVUaHhCWVlMQ1ZkOWFHMmRWazNwVUhqUjdGYWRHZ2ww?=
 =?utf-8?B?UG9CUjBXMnRreWh6TVM3eTlXb3dQY0NLdFR3VkxkRmpGaWZwc1AwU2NWdjBy?=
 =?utf-8?B?cTZoRlFRN0xVRjNCMlZLM3ZqWktsdkRzejRJVEFqa3oyTVFvYTRvbEx5eXN1?=
 =?utf-8?B?QnhyNXZ5ekNUeHVzNXEyOERLV1labE9WdlZoZFdmTVVMa3RncG0vYzczYy9W?=
 =?utf-8?B?K0kwWXJETWJUYWtPZlpUcWUrNjZOeGpaaDJRY1AzakpzaURkRmsxTU5RVHVW?=
 =?utf-8?B?QzNwN0I3S3RUdXhzN1QrSDNpL09CMWRYWTkzSGNnMHhyWFVLL0JTd3lCZHc1?=
 =?utf-8?B?c1hLa2szZmovYWhoMFdNVW52RWhtVWFPVFQwOFh3cFdQTmR0TEJia1JsZ0Nh?=
 =?utf-8?B?RVhpNWJMeldWMWpITzRNV1kxRnIyRXdsaXp4QW5EZnZvNHF4YnljeHNhb3V4?=
 =?utf-8?B?UmkyMm9udWptSmdoZGlZd0hVNUwvZ0xYUUxwaWhMUUk2Mk1VcWtFN2VrUmdl?=
 =?utf-8?B?dENWRTdpeEJIQ2RCQnJDTnhXQXBaZ25tanBDayt6azE2SFFPVGxGRWtrU3d6?=
 =?utf-8?B?Y1A5UGpHNXN6ZHhKOEtha1M5UFpPSCtjTlVCdm1nQTJYdlkrRTJndXlpZE8v?=
 =?utf-8?B?bFRwYlk0MllNVC9LSy94N3dVMlBQNkhRZVNoTDZ5QmU0V0psNEgzVmhmMXRX?=
 =?utf-8?B?RndUMmx4RmpvTm9EN3NPNTUzQVVqcXJQc3c1cDBSdFp1RE1MM09CNmF5S0Yz?=
 =?utf-8?B?SjBMZ1NCZXVMaW5KdHJ6WTJ2a013Nko0RzRPT0lVSUhlTWV2amhZU3hnTisz?=
 =?utf-8?B?dW5YcWRLWFZPYmh1dVgrTEZkdDVIcHdOOFZ1YWxndXdBOFAyYkdDTDNqTWQw?=
 =?utf-8?B?dHpqUGxqNS9Hb3ZqVXRWWVpJRlhRZ1gzU0Vla1BCZ1BEU21qRC9YMW9OZ2Vj?=
 =?utf-8?B?Ungrdml2RTAzZ0phdXZ0QkVjc0xOZzJTOVNZMXY1M1V4NG1uSE5OdkdCWDZO?=
 =?utf-8?B?dlRYSUJSbENhVUdmNkVvWEQ0dXUrbTgydGxRM3BjTFlPTE83L2E2a0hzR29x?=
 =?utf-8?B?Z3NuWlRlbUhWc0FYZVVaYmhjWkRNS1l1OVN0WmRWWUVINFg3UnRqeDR0Uldq?=
 =?utf-8?B?RmdrUkVOc2Roc3ErVHB4dGxYWnBRWXlKMDN0blRzYnRGektkUnQrYUliOEl2?=
 =?utf-8?B?Z0VXVm1PNC9pVEl3S3dTcE1sWGJJOU94UXVtVGxRYTkyMWhjajhRY0FsS0Fq?=
 =?utf-8?B?c1grVHhTVjdmc2w2REJiZFJVcXNPc0Y3bERaaENrV25xcFVZMEdVSGlpaGNQ?=
 =?utf-8?B?ZFBadFQ5aURVV3g4WXVYRjVrRXZwQ0JSdmc0SnJZL2JmOGRXWWhCMVZ0ZVVt?=
 =?utf-8?B?VEVlU0hxeFBiY2VxMWMvTVBNSlk2VTc1TWxMV1Z2cWhmVlRuTkh4ZmtqcEZu?=
 =?utf-8?B?bFpRaFlEZldITHdrbUY4cW5MY3MrVlk2S3Q1cU40VmlFMnpEbG93TnFUTklP?=
 =?utf-8?B?L29WbE1KbW1DRzVDS3lJNElBQk5IcU15UFNqS25BcEd2RGNOZE9MVWJyaVg3?=
 =?utf-8?B?YVVWZmZiR2x2RjJnMmNnZnBMcEgxR2lCbTNqV1ZKQlNMMExDRUdQU3JDVWhH?=
 =?utf-8?B?OVJSWGJ5Q28yZzBnMXRIVkJZcjR1K21tTk5nNzhIQmVwbzhmaHdUZGxDN2NZ?=
 =?utf-8?B?bWtqRDRxbDh4Y3Z4ZkdhTXVKYXZHMktSeWdWMzRFMUp0TXYzTzBPREhHR0Zr?=
 =?utf-8?B?c2RhTm5BNnI4N2JaQjJFNENSWlJTZTJNSy9wSVZrMUlzK21DSzVZa2hKQWVh?=
 =?utf-8?B?cndUNjNJRW5hLzFXeUVydGZFalE3b2k0Ym0vR0g1NDJNc1d1cEFmOWFDSGR5?=
 =?utf-8?B?aHJwLzMzbUVleExyYmgwY0lISU9ZQkkxZE5BUzRONTVvalJXZERLUlRlZmhp?=
 =?utf-8?Q?rvcJ5a1zddD1SHBT6X8WFkQNI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd97bd79-9437-4a4c-79f6-08db5c3150ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 08:31:48.3488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tsWR4PeJUoJ7eToiFssb2htyoevNydLzYgNgrLk2I6L1JKxyNYClWQ24zveZVpIz5jow1rWgF87vE3cydk2mPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6404
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBNYXkgMjQsIDIwMjMgMTA6NDEgQU0NCj4gDQo+ID4gRnJvbTogVGlhbiwgS2V2aW4gPGtldmlu
LnRpYW5AaW50ZWwuY29tPg0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgTWF5IDI0LCAyMDIzIDEwOjM5
IEFNDQo+ID4NCj4gPiA+IEZyb206IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+
ID4gU2VudDogV2VkbmVzZGF5LCBNYXkgMjQsIDIwMjMgMTA6MjEgQU0NCj4gPiA+DQo+ID4gPiA+
ID4NCj4gPiA+ID4gPiB2ZmlvX2RldmljZV9vcGVuX2ZpbGUoKQ0KPiA+ID4gPiA+IHsNCj4gPiA+
ID4gPiAJZGV2X3dhcm4oZGV2aWNlLT5kZXYsICJ2ZmlvLW5vaW9tbXUgZGV2aWNlIG9wZW5lZCBi
eSB1c2VyICINCj4gPiA+ID4gPiAJCSAgICIoJXM6JWQpXG4iLCBjdXJyZW50LT5jb21tLCB0YXNr
X3BpZF9ucihjdXJyZW50KSk7DQo+ID4gPiA+ID4gfQ0KPiA+ID4gPg0KPiA+ID4gPiBUaGVyZSBu
ZWVkcyB0byBiZSBhIHRhaW50IHdoZW4gVkZJT19HUk9VUCBpcyBkaXNhYmxlZC4gIFRoYW5rcywN
Cj4gPiA+IEkgc2VlLiBJIG1pc3VuZGVyc3Rvb2QgeW91LiBZb3UgYXJlIGFza2luZyBmb3IgYSB0
YWludC4g8J+Yig0KPiA+ID4NCj4gPiA+IEFjdHVhbGx5LCBJJ3ZlIGNvbnNpZGVyZWQgaXQuIEJ1
dCBpdCBhcHBlYXJzIHRvIG1lIHRoZSB0YWludCBpbg0KPiA+ID4gdmZpb19ncm91cF9maW5kX29y
X2FsbG9jKCkgaXMgZHVlIHRvIHZmaW8gYWxsb2NhdGVzIGZha2UgaW9tbXVfZ3JvdXAuDQo+ID4g
PiBUaGlzIHNlZW1zIHRvIGJlIGEgdGFpbnQgdG8ga2VybmVsLiBCdXQgbm93LCB5b3UgYXJlIHN1
Z2dlc3RpbmcgdG8gYWRkDQo+ID4gPiBhIHRhaW50IGFzIGxvbmcgYXMgbm9pb21tdSBkZXZpY2Ug
aXMgcmVnaXN0ZXJlZCB0byB2ZmlvLiBJcyBpdD8gSWYgc28sDQo+ID4NCj4gPiB0YWludCBpcyBy
ZXF1aXJlZCBiZWNhdXNlIHRoZSBrZXJuZWwgaXMgZXhwb3NlZCB0byB1c2VyIERNQSBhdHRhY2sN
Cj4gPiBkdWUgdG8gbGFja2luZyBvZiBJT01NVSBwcm90ZWN0aW9uLg0KPiA+DQo+ID4gZmFrZSBp
b21tdV9ncm91cCBpcyBqdXN0IHRvIG1lZXQgdmZpb19ncm91cCByZXF1aXJlbWVudC4NCj4gDQo+
IEdvdCBpdC4gdGhhbmtzLg0KDQpQbGVhc2UgcmVmZXIgdG8gdGhlIHByb3Bvc2VkIGNoYW5nZSBp
biBbMV0uIFRoZSBub2lvbW11IHRhaW50IGlzDQptb3ZlZCB0byB0aGUgZW5kIG9mIF9fdmZpb19y
ZWdpc3Rlcl9kZXYoKSByZWx5IG9uIHRoZSBub2lvbW11DQpmbGFnIHNldCBieSB2ZmlvX2Rldmlj
ZV9zZXRfbm9pb21tdSgpLg0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL0RTMFBS
MTFNQjc1MjkwN0QyMTFFMzcwMzE0NTUwM0ExMkMzNDE5QERTMFBSMTFNQjc1MjkubmFtcHJkMTEu
cHJvZC5vdXRsb29rLmNvbS8NCg0KUmVnYXJkcywNCllpIExpdQ0K
