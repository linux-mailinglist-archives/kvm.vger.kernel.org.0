Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3FA50F596
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241910AbiDZIwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 04:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346446AbiDZIuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 04:50:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EA7136977
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 01:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650962292; x=1682498292;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EKIBgRpt++Nh+EG2FKjPUGcr0AzSAQTlymmkrIkVhrQ=;
  b=EE37Pi6hWRAfu5TqERvY9Sk6tIljk691cPZgOdDIJ1V/2kq0s5EbgPw2
   3dxnn8UPdiBWll3qM4zCNVKFr2vjRde2zygTgkts3n/PD152s4np8eaP4
   aqZeK3MUh4gwFY4cccX7OiL8SXO0D4fnnJ73Ii2UCFssS91WkBwBGqedV
   OvYm2G1yJxzTZL5bw0r9oroY/njasY0rZcLusHoqoSKU8ndDqwyrFTsGK
   7/fyjxRj8RoH+hkchzcSpIM86A65yr9KVFuu4bBR1MrQSUlLF37/1tPyA
   BxDURqsRDIwkTaS6zDA3PiwlE+dQ3v5cxnowbam6TG/t2amoPZN4TCRH2
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="265666135"
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="265666135"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 01:37:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="595654190"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 26 Apr 2022 01:37:43 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 26 Apr 2022 01:37:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 26 Apr 2022 01:37:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 26 Apr 2022 01:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4w8yUFN/CJiCsqv6j51Ty5btBrQrOsYd5HNAcuxxtsdkuboNlleTHnuTnL/JMOaDs9SvRv1anUYWZHewuAK0F+2lvJPiEL0DDOQAmDQo0e0hrFArUvWdLuvdVdN1UQNWeIhL7G9RsG749VPcdqcuACF8g5s3c95vSOSIPo/N/oE51UAmXK6RRlF0PviJj4GqqSAWKcs7ETyezELn9aL+kQrVdLYFKTjXVfLkERDW0McacOdjk7ad/pfGKtGoXBRIx3fWh4pPAwyeUCpL/ELo//ZlyfRAo0ns8WrIMh9WvSLPNiye0+DkRJUPQ8BsyenEYzaCh1m5t/d+XCY3FgyLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EKIBgRpt++Nh+EG2FKjPUGcr0AzSAQTlymmkrIkVhrQ=;
 b=M1Xb/LRrxzE2s3FG3yYBeCZxWAAOQX0xxMvPtWdXDE+dLSwoMJPdeXVvkTmXDSofuOkvZWDEg1MJUkKKYe0AQTsQUvpCL0zJXm2ucQ9K4JbzwAqGOiPOtPISMzlxnCEZ2BorjUu0SsuNvmhPwPjG15M/xX8S5YKnCBY0yLb2CgSR9tgSytwCF+La1Ax8bls/ZZCsJ7/m90AiRu6guvDDi6hrj05Vj4ibo2vrBd/PufoWUVPYT/3EdAbaisV9IlGHNo2i189dN+LDwH/7cv43/oZ7HmeE2PZtmamZ6YJ29pvM0egeMQV0JOqQ8lcdaB3mypO5mB7GKsZ7NcUbgspc5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO6PR11MB5652.namprd11.prod.outlook.com (2603:10b6:5:35e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 26 Apr
 2022 08:37:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 08:37:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Laine Stump <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: RE: [RFC 00/18] vfio: Adopt iommufd
Thread-Topic: [RFC 00/18] vfio: Adopt iommufd
Thread-Index: AQHYT+0D1ejJho1As0eoIzmf/Uaf8qz8i3yAgAPt+QCAAErCAIABIpyQ
Date:   Tue, 26 Apr 2022 08:37:41 +0000
Message-ID: <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220422160943.6ff4f330.alex.williamson@redhat.com>
        <YmZzhohO81z1PVKS@redhat.com>
 <20220425083748.3465c50f.alex.williamson@redhat.com>
In-Reply-To: <20220425083748.3465c50f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5033e178-99b8-4719-7587-08da27600704
x-ms-traffictypediagnostic: CO6PR11MB5652:EE_
x-microsoft-antispam-prvs: <CO6PR11MB5652CB56974516714426F6988CFB9@CO6PR11MB5652.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xLGQQmlSm00Ua7OpFL05eHzq1cx35IRpaOsESkjssf+35sGpRyXgkz2QBHv5+i9ri/dT3fOy4n9MVkuAK6+0xBG7EiCPJ5JSQHUI9qWlpQVJfQh7uAqNnPg0YhjxDnA8REJ6tL9fcf+6Y6UtEE+lCyTq3Vhe/w65X0bGqbFNwpkflL8n0504TMXk2eQ/DaL/8tyXccjB1P/H3I31XC5oCmgrM2ujzbjaUKhkiBwIeI3xZ7sEVW4+RCzuRae/8hMKIcnA/KHQtl1Sa2r0ApXO/DAt6mMDx/djLkK6smAiQxzHff89XuWtW4BFMpJ8ZjtyeIUOIunm/K6zaXGwPHl+bjsL3wK3srpzDj82yTrFINO8zITEnoDd1c80T6SWvsxTODbQiipC4Y1rQJcuNS0pIcOUpnzj9JMwEzDuXAit+T39mn/+HzJCRs0lrOu3vfqmvC4geUxvglF0o2E1lTps99uGQYO2g8m4x1BkciAYe+iNEaaNEUHe/vgRf61xxJSBHFYzQ9rVgZa7ZHNpZlpmvxw3VXe7ej3PuBDkf8Qe0zyYC0/609ovLcjAauY0HaOMO9OKgp/CiFSs0khbuijAvzHK3njCFT9wkYlmvF8i+ELVxCevYAkZvnF9oGiojcbQlaVUoyPo6XVfzF5wbt+QdinkIU8VnRKF4VBJdlYSSp3VaOFL2OgzBfiy5QwDurIpQdk8x0AQs8cHlPR1BmzQWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(38070700005)(55016003)(38100700002)(33656002)(7416002)(66446008)(4326008)(5660300002)(316002)(71200400001)(83380400001)(2906002)(6506007)(7696005)(26005)(86362001)(186003)(82960400001)(122000001)(508600001)(8936002)(110136005)(54906003)(66946007)(52536014)(8676002)(64756008)(66476007)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YlN0bTQ4YXRNR0ozbk1DNFlKcUg5MU51Mzc4UERIYUs0Zzl5VW5RYTF6VXNh?=
 =?utf-8?B?Sk5TY3d3blNGaVRKc2RZeXFXTEl0Wll3NlBtTVpzNEhOeGVrY1dyMG9DSFlU?=
 =?utf-8?B?QzhUc1REYWNFR1JIZjQvbGs0akdDSVF4ZFdlTlBHdUVMTWZUd2w2dDdrTlJ1?=
 =?utf-8?B?bm9oWUxCSW8rNzRnZkMzZWNwc1BVNkNHSjJRT2VDbFdOakc1WVZoL2dDKzBu?=
 =?utf-8?B?bFAvZnIvQ3B1NXptaTdLVXFFUnVuSlVNQU9Senp5a05JbG5OTXFzbkI0am1v?=
 =?utf-8?B?bktQT1RJbVEyaWdwNXhGQnNtNVA5NkJUWUVKczVqYk9RTDhhNVg1YlJhYWkz?=
 =?utf-8?B?VmVucmxUN3VCWnpEbU12enNKN0VvMFhPTnliTnRDL2VBRTVKTC95TC9VeVpB?=
 =?utf-8?B?NnFJbTFySVFES2xpUlFXbmFIZlV1aUcwVG9wdWoyK2RxdXR4U1d0WXlPaWRN?=
 =?utf-8?B?bmhjelNMQ244Nk85QW1TcGhpNGpOUmVTdWVhZExUMGtZNkpxWnkzYy9JYmxP?=
 =?utf-8?B?THo4SHpoZkU0c2djN0xlcXN1NGwrTWtuaUdkWlE5RmdGbG80cmprTTRLYXBr?=
 =?utf-8?B?emRIMitQR0Rub1VLV2lmWVFYai9IamMxcmRrOU1mOEZJQjdhdGhXV0YzYTlV?=
 =?utf-8?B?VG14SVhmbkZLckJPMWZPZjlIOEJ1bEovQjMweUtNSjUwSk5YeXhJYlVvWHVm?=
 =?utf-8?B?ZWZlQi9oNXFydmRXL0ZIM2ZEV2U3QVhObW93SHJUeW9xaXUvMXM2T0ZNRmE2?=
 =?utf-8?B?OVM3bjMzTnpBZUEwUXRGWU9WZVJSeGpaQThRRzNVYUxid0NsUG5wZFp2VW14?=
 =?utf-8?B?MUlpTDdBaUdMOWhyL2NNbVczZUpiOXJkY1FBWVhpNEZCZ2JVMXR3STV0Qlo4?=
 =?utf-8?B?Z0VPd0c2aGlGbm1JUUFmdy9oWGM3K3dydERxRGxEN2RpUjByTlJTTTUvVlBa?=
 =?utf-8?B?Q0JpYjkrZEpwOXBjbFFoanZBdWtKRWp5czh1Ym1hSkhOYzVGcVpCd1FzVkNp?=
 =?utf-8?B?TTcwTElRaGhPMWREbS9tMFMyM3FPMDFqUHpGNzBxNFVQNy9UUCtPSVppemRT?=
 =?utf-8?B?cnppSTc1aERMWlZqNmpjekU3NEtMcUxIYW1xODBVc1lEZk5OWWhtUjZHci9p?=
 =?utf-8?B?V2o3cDNUMG1US2JGdFNoN1RPWld3ZDQzdEN5dlViUkNabGswV1FmYUFpS0Nk?=
 =?utf-8?B?OTlMVDFYanhwMlFBWHN3R1E0QU9DZUN5NW11SEJ1bTJaS3AvL3Q3bVZ2Tk5Q?=
 =?utf-8?B?Q2Nta3ZhZWF1ZDVLcTVadnJpb3dILzFJS1E0VUoyTHZFcW4zRGxmWjUvUFNC?=
 =?utf-8?B?cTIwZldTTGRYczdKTHpTVExKd01Kb1ROWW9ZSTlFem90cGgrd3dqeEN4QW9z?=
 =?utf-8?B?UElEQkpGSFZIaDZsMlg3d0t4QTc0NVJTUkFvdmlSYjIvNzZyaDVKZUYzL21G?=
 =?utf-8?B?eVdsb1JIeGsrQXBWMnVDWDM5YXJDamJpVDEvM1FhQURsZmQ4YVgzajlTVmI3?=
 =?utf-8?B?UjBMUUpHajZ4RHoxTllTM2M1WFh5aHkrQWFGVGR1T3gyY2pkOHROaGRNWE1x?=
 =?utf-8?B?a1N4Qm14ZmZtVU9WYjRTc0hZN0IzeFlLWEZyNWl4QjdnSHZ6MFBoWjZVWDhk?=
 =?utf-8?B?TFAzMFJIc0s2L0ZIdkpUUDZrMVVBaGlkc21YR2UrcjdSRUhPNEtTeGE0K1gv?=
 =?utf-8?B?dE1nYUhBYmZ4djBrSE42QmhmemVGUjR1N0RHa2MvemdndG8wbXhUb09jSUNv?=
 =?utf-8?B?S1c3R1AzR1FiZWhZbzNWUWsva3MrV0trdWkxRVJKUDlPTzNKUjdMQTQvYXpC?=
 =?utf-8?B?b2tMbVBPN3g4ODdqc2FnTEZsRk82QW0wTDVNaFlDZElHMllEU3JXYit3Ykpt?=
 =?utf-8?B?Z011VTV1VWd1S2hRclhoUzhjVWJHWGpNakd3Qk9ybmJaMUtUQjEyaE5DWlBU?=
 =?utf-8?B?UkRtdVlzOFRNeVNZSC9wMTBGaHpkMDVZTVRlVmNWQUticWRRdE9iajZnSzNk?=
 =?utf-8?B?U01NaHRwMXRMVDc0ZmZmOExYQkN0Wm02ZU1LUCsydE9zWWc1Wk5LOHQ0NEIv?=
 =?utf-8?B?K0N3UlhpREJXL3k0NkZOZ04zT2JrczQwWVZzMzQ4aGsxd1lpcXNaaXhRK3Na?=
 =?utf-8?B?dW1rTzNiY21LZCsyalI0UEw2RGV3a2xoandZblZTSEVwRHdJVnlCNG5KUjZX?=
 =?utf-8?B?RWVMYXZFZ0ZiOWJ4bmdXZkUweEtvZENWK3RWRnJXS1RTd1FMbWNjZnpCK0N6?=
 =?utf-8?B?OVkvOG9OelNMcUdxaUV4dHoweC9STnN1SWgyMzUreDhDbEFPenF1ZXFGY0dH?=
 =?utf-8?B?ejNtUmp3bnMyTlhLRWxLd3FaNmQwNnJIdmxGTW95dGtuaFVRQlpGUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5033e178-99b8-4719-7587-08da27600704
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 08:37:41.4266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fFQE9znR5Q5awNPy03fz/c+gKnM/L/cQ064eM/tfjFOoemOVycCCu0ebvaxEWCcY++uw9iKTRCzdKDPL2V5C1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5652
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBNb25kYXksIEFwcmlsIDI1LCAyMDIyIDEwOjM4IFBNDQo+IA0KPiBPbiBNb24sIDI1IEFw
ciAyMDIyIDExOjEwOjE0ICswMTAwDQo+IERhbmllbCBQLiBCZXJyYW5nw6kgPGJlcnJhbmdlQHJl
ZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBGcmksIEFwciAyMiwgMjAyMiBhdCAwNDowOTo0
M1BNIC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gPiBbQ2MgK2xpYnZpcnQgZm9s
a3NdDQo+ID4gPg0KPiA+ID4gT24gVGh1LCAxNCBBcHIgMjAyMiAwMzo0Njo1MiAtMDcwMA0KPiA+
ID4gWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gV2l0
aCB0aGUgaW50cm9kdWN0aW9uIG9mIGlvbW11ZmRbMV0sIHRoZSBsaW51eCBrZXJuZWwgcHJvdmlk
ZXMgYQ0KPiBnZW5lcmljDQo+ID4gPiA+IGludGVyZmFjZSBmb3IgdXNlcnNwYWNlIGRyaXZlcnMg
dG8gcHJvcGFnYXRlIHRoZWlyIERNQSBtYXBwaW5ncyB0bw0KPiBrZXJuZWwNCj4gPiA+ID4gZm9y
IGFzc2lnbmVkIGRldmljZXMuIFRoaXMgc2VyaWVzIGRvZXMgdGhlIHBvcnRpbmcgb2YgdGhlIFZG
SU8gZGV2aWNlcw0KPiA+ID4gPiBvbnRvIHRoZSAvZGV2L2lvbW11IHVhcGkgYW5kIGxldCBpdCBj
b2V4aXN0IHdpdGggdGhlIGxlZ2FjeQ0KPiBpbXBsZW1lbnRhdGlvbi4NCj4gPiA+ID4gT3RoZXIg
ZGV2aWNlcyBsaWtlIHZwZGEsIHZmaW8gbWRldiBhbmQgZXRjLiBhcmUgbm90IGNvbnNpZGVyZWQg
eWV0Lg0KPiA+DQo+ID4gc25pcA0KPiA+DQo+ID4gPiA+IFRoZSBzZWxlY3Rpb24gb2YgdGhlIGJh
Y2tlbmQgaXMgbWFkZSBvbiBhIGRldmljZSBiYXNpcyB1c2luZyB0aGUgbmV3DQo+ID4gPiA+IGlv
bW11ZmQgb3B0aW9uIChvbi9vZmYvYXV0bykuIEJ5IGRlZmF1bHQgdGhlIGlvbW11ZmQgYmFja2Vu
ZCBpcw0KPiBzZWxlY3RlZA0KPiA+ID4gPiBpZiBzdXBwb3J0ZWQgYnkgdGhlIGhvc3QgYW5kIGJ5
IFFFTVUgKGlvbW11ZmQgS0NvbmZpZykuIFRoaXMgb3B0aW9uDQo+IGlzDQo+ID4gPiA+IGN1cnJl
bnRseSBhdmFpbGFibGUgb25seSBmb3IgdGhlIHZmaW8tcGNpIGRldmljZS4gRm9yIG90aGVyIHR5
cGVzIG9mDQo+ID4gPiA+IGRldmljZXMsIGl0IGRvZXMgbm90IHlldCBleGlzdCBhbmQgdGhlIGxl
Z2FjeSBCRSBpcyBjaG9zZW4gYnkgZGVmYXVsdC4NCj4gPiA+DQo+ID4gPiBJJ3ZlIGRpc2N1c3Nl
ZCB0aGlzIGEgYml0IHdpdGggRXJpYywgYnV0IGxldCBtZSBwcm9wb3NlIGEgZGlmZmVyZW50DQo+
ID4gPiBjb21tYW5kIGxpbmUgaW50ZXJmYWNlLiAgTGlidmlydCBnZW5lcmFsbHkgbGlrZXMgdG8g
cGFzcyBmaWxlDQo+ID4gPiBkZXNjcmlwdG9ycyB0byBRRU1VIHJhdGhlciB0aGFuIGdyYW50IGl0
IGFjY2VzcyB0byB0aG9zZSBmaWxlcw0KPiA+ID4gZGlyZWN0bHkuICBUaGlzIHdhcyBwcm9ibGVt
YXRpYyB3aXRoIHZmaW8tcGNpIGJlY2F1c2UgbGlidmlydCBjYW4ndA0KPiA+ID4gZWFzaWx5IGtu
b3cgd2hlbiBRRU1VIHdpbGwgd2FudCB0byBncmFiIGFub3RoZXIgL2Rldi92ZmlvL3ZmaW8NCj4g
PiA+IGNvbnRhaW5lci4gIFRoZXJlZm9yZSB3ZSBhYmFuZG9uZWQgdGhpcyBhcHByb2FjaCBhbmQg
aW5zdGVhZCBsaWJ2aXJ0DQo+ID4gPiBncmFudHMgZmlsZSBwZXJtaXNzaW9ucy4NCj4gPiA+DQo+
ID4gPiBIb3dldmVyLCB3aXRoIGlvbW11ZmQgdGhlcmUncyBubyByZWFzb24gdGhhdCBRRU1VIGV2
ZXIgbmVlZHMgbW9yZQ0KPiB0aGFuDQo+ID4gPiBhIHNpbmdsZSBpbnN0YW5jZSBvZiAvZGV2L2lv
bW11ZmQgYW5kIHdlJ3JlIHVzaW5nIHBlciBkZXZpY2UgdmZpbyBmaWxlDQo+ID4gPiBkZXNjcmlw
dG9ycywgc28gaXQgc2VlbXMgbGlrZSBhIGdvb2QgdGltZSB0byByZXZpc2l0IHRoaXMuDQo+ID4N
Cj4gPiBJIGFzc3VtZSBhY2Nlc3MgdG8gJy9kZXYvaW9tbXVmZCcgZ2l2ZXMgdGhlIHByb2Nlc3Mg
c29tZXdoYXQgZWxldmF0ZWQNCj4gPiBwcml2aWxlZ2VzLCBzdWNoIHRoYXQgeW91IGRvbid0IHdh
bnQgdG8gdW5jb25kaXRpb25hbGx5IGdpdmUgUUVNVQ0KPiA+IGFjY2VzcyB0byB0aGlzIGRldmlj
ZSA/DQo+IA0KPiBJdCdzIG5vdCB0aGF0IG11Y2ggZGlzc2ltaWxhciB0byAvZGV2L3ZmaW8vdmZp
bywgaXQncyBhbiB1bnByaXZpbGVnZWQNCj4gaW50ZXJmYWNlIHdoaWNoIHNob3VsZCBoYXZlIGxp
bWl0ZWQgc2NvcGUgZm9yIGFidXNlLCBidXQgbW9yZSBzbyBoZXJlDQo+IHRoZSBnb2FsIHdvdWxk
IGJlIHRvIGRlLXByaXZpbGVnZSBRRU1VIHRoYXQgb25lIHN0ZXAgZnVydGhlciB0aGF0IGl0DQo+
IGNhbm5vdCBvcGVuIHRoZSBkZXZpY2UgZmlsZSBpdHNlbGYuDQo+IA0KPiA+ID4gVGhlIGludGVy
ZmFjZSBJIHdhcyBjb25zaWRlcmluZyB3b3VsZCBiZSB0byBhZGQgYW4gaW9tbXVmZCBvYmplY3Qg
dG8NCj4gPiA+IFFFTVUsIHNvIHdlIG1pZ2h0IGhhdmUgYToNCj4gPiA+DQo+ID4gPiAtZGV2aWNl
IGlvbW11ZmRbLGZkPSNdWyxpZD1mb29dDQo+ID4gPg0KPiA+ID4gRm9yIG5vbi1saWJpdnJ0IHVz
YWdlIHRoaXMgd291bGQgaGF2ZSB0aGUgYWJpbGl0eSB0byBvcGVuIC9kZXYvaW9tbXVmZA0KPiA+
ID4gaXRzZWxmIGlmIGFuIGZkIGlzIG5vdCBwcm92aWRlZC4gIFRoaXMgb2JqZWN0IGNvdWxkIGJl
IHNoYXJlZCB3aXRoDQo+ID4gPiBvdGhlciBpb21tdWZkIHVzZXJzIGluIHRoZSBWTSBhbmQgbWF5
YmUgd2UnZCBhbGxvdyBtdWx0aXBsZSBpbnN0YW5jZXMNCj4gPiA+IGZvciBtb3JlIGVzb3Rlcmlj
IHVzZSBjYXNlcy4gIFtOQiwgbWF5YmUgdGhpcyBzaG91bGQgYmUgYSAtb2JqZWN0IHJhdGhlcg0K
PiB0aGFuDQo+ID4gPiAtZGV2aWNlIHNpbmNlIHRoZSBpb21tdWZkIGlzIG5vdCBhIGd1ZXN0IHZp
c2libGUgZGV2aWNlP10NCj4gPg0KPiA+IFllcywgIC1vYmplY3Qgd291bGQgYmUgdGhlIHJpZ2h0
IGFuc3dlciBmb3Igc29tZXRoaW5nIHRoYXQncyBwdXJlbHkNCj4gPiBhIGhvc3Qgc2lkZSBiYWNr
ZW5kIGltcGwgc2VsZWN0b3IuDQo+ID4NCj4gPiA+IFRoZSB2ZmlvLXBjaSBkZXZpY2UgbWlnaHQg
dGhlbiBiZWNvbWU6DQo+ID4gPg0KPiA+ID4gLWRldmljZSB2ZmlvLQ0KPiBwY2lbLGhvc3Q9RERE
RDpCQjpERC5mXVssc3lzZnNkZXY9L3N5cy9wYXRoL3RvL2RldmljZV1bLGZkPSNdWyxpb21tdWZk
PWYNCj4gb29dDQo+ID4gPg0KPiA+ID4gU28gZXNzZW50aWFsbHkgd2UgY2FuIHNwZWNpZnkgdGhl
IGRldmljZSB2aWEgaG9zdCwgc3lzZnNkZXYsIG9yIHBhc3NpbmcNCj4gPiA+IGFuIGZkIHRvIHRo
ZSB2ZmlvIGRldmljZSBmaWxlLiAgV2hlbiBhbiBpb21tdWZkIG9iamVjdCBpcyBzcGVjaWZpZWQs
DQo+ID4gPiAiZm9vIiBpbiB0aGUgZXhhbXBsZSBhYm92ZSwgZWFjaCBvZiB0aG9zZSBvcHRpb25z
IHdvdWxkIHVzZSB0aGUNCj4gPiA+IHZmaW8tZGV2aWNlIGFjY2VzcyBtZWNoYW5pc20sIGVzc2Vu
dGlhbGx5IHRoZSBzYW1lIGFzIGlvbW11ZmQ9b24gaW4NCj4gPiA+IHlvdXIgZXhhbXBsZS4gIFdp
dGggdGhlIGZkIHBhc3Npbmcgb3B0aW9uLCBhbiBpb21tdWZkIG9iamVjdCB3b3VsZCBiZQ0KPiA+
ID4gcmVxdWlyZWQgYW5kIG5lY2Vzc2FyaWx5IHVzZSBkZXZpY2UgbGV2ZWwgYWNjZXNzLg0KPiA+
ID4NCj4gPiA+IEluIHlvdXIgZXhhbXBsZSwgdGhlIGlvbW11ZmQ9YXV0byBzZWVtcyBlc3BlY2lh
bGx5IHRyb3VibGVzb21lIGZvcg0KPiA+ID4gbGlidmlydCBiZWNhdXNlIFFFTVUgaXMgZ29pbmcg
dG8gaGF2ZSBkaWZmZXJlbnQgbG9ja2VkIG1lbW9yeQ0KPiA+ID4gcmVxdWlyZW1lbnRzIGJhc2Vk
IG9uIHdoZXRoZXIgd2UncmUgdXNpbmcgdHlwZTEgb3IgaW9tbXVmZCwgd2hlcmUNCj4gdGhlDQo+
ID4gPiBsYXR0ZXIgcmVzb2x2ZXMgdGhlIGR1cGxpY2F0ZSBhY2NvdW50aW5nIGlzc3Vlcy4gIGxp
YnZpcnQgbmVlZHMgdG8ga25vdw0KDQpCYXNlZCBvbiBjdXJyZW50IHBsYW4gdGhlcmUgaXMgcHJv
YmFibHkgYSB0cmFuc2l0aW9uIHdpbmRvdyBiZXR3ZWVuIHRoZQ0KcG9pbnQgd2hlcmUgdGhlIGZp
cnN0IHZmaW8gZGV2aWNlIHR5cGUgKHZmaW8tcGNpKSBnYWluaW5nIGlvbW11ZmQgc3VwcG9ydA0K
YW5kIHRoZSBwb2ludCB3aGVyZSBhbGwgdmZpbyB0eXBlcyBzdXBwb3J0aW5nIGlvbW11ZmQuIExp
YnZpcnQgY2FuIGZpZ3VyZQ0Kb3V0IHdoaWNoIG9uZSB0byB1c2UgaW9tbXVmZCBieSBjaGVja2lu
ZyB0aGUgcHJlc2VuY2Ugb2YNCi9kZXYvdmZpby9kZXZpY2VzL3ZmaW9YLiBCdXQgd2hhdCB3b3Vs
ZCBiZSB0aGUgcmVzb3VyY2UgbGltaXQgcG9saWN5DQppbiBMaWJ2aXJ0IGluIHN1Y2ggdHJhbnNp
dGlvbiB3aW5kb3cgd2hlbiBib3RoIHR5cGUxIGFuZCBpb21tdWZkIG1pZ2h0DQpiZSB1c2VkPyBP
ciBkbyB3ZSBqdXN0IGV4cGVjdCBMaWJ2aXJ0IHRvIHN1cHBvcnQgaW9tbXVmZCBvbmx5IGFmdGVy
IHRoZQ0KdHJhbnNpdGlvbiB3aW5kb3cgZW5kcyB0byBhdm9pZCBoYW5kbGluZyBzdWNoIG1lc3M/
DQoNCj4gPiA+IGRldGVybWluaXN0aWNhbGx5IHdoaWNoIGJhY2tlZCBpcyBiZWluZyB1c2VkLCB3
aGljaCB0aGlzIHByb3Bvc2FsIHNlZW1zDQo+ID4gPiB0byBwcm92aWRlLCB3aGlsZSBhdCB0aGUg
c2FtZSB0aW1lIGJyaW5naW5nIHVzIG1vcmUgaW4gbGluZSB3aXRoIGZkDQo+ID4gPiBwYXNzaW5n
LiAgVGhvdWdodHM/ICBUaGFua3MsDQo+ID4NCj4gPiBZZXAsIEkgYWdyZWUgdGhhdCBsaWJ2aXJ0
IG5lZWRzIHRvIGhhdmUgbW9yZSBkaXJlY3QgY29udHJvbCBvdmVyIHRoaXMuDQo+ID4gVGhpcyBp
cyBhbHNvIGV2ZW4gbW9yZSBpbXBvcnRhbnQgaWYgdGhlcmUgYXJlIG5vdGFibGUgZmVhdHVyZSBk
aWZmZXJlbmNlcw0KPiA+IGluIHRoZSAyIGJhY2tlbmRzLg0KPiA+DQo+ID4gSSB3b25kZXIgaWYg
YW55b25lIGhhcyBjb25zaWRlcmVkIGFuIGV2ZW4gbW9yZSBkaXN0aW5jdCBpbXBsLCB3aGVyZWJ5
DQo+ID4gd2UgaGF2ZSBhIGNvbXBsZXRlbHkgZGlmZmVyZW50IGRldmljZSB0eXBlIG9uIHRoZSBi
YWNrZW5kLCBlZw0KPiA+DQo+ID4gICAtZGV2aWNlIHZmaW8taW9tbXUtDQo+IHBjaVssaG9zdD1E
REREOkJCOkRELmZdWyxzeXNmc2Rldj0vc3lzL3BhdGgvdG8vZGV2aWNlXVssZmQ9I11bLGlvbW11
ZmQ9Zg0KPiBvb10NCj4gPg0KPiA+IElmIGEgdmVuZG9yIHdhbnRzIHRvIGZ1bGx5IHJlbW92ZSB0
aGUgbGVnYWN5IGltcGwsIHRoZXkgY2FuIHRoZW4gdXNlIHRoZQ0KPiA+IEtjb25maWcgbWVjaGFu
aXNtIHRvIGRpc2FibGUgdGhlIGJ1aWxkIG9mIHRoZSBsZWdhY3kgaW1wbCBkZXZpY2UsIHdoaWxl
DQo+ID4ga2VlcGluZyB0aGUgaW9tbXUgaW1wbCAob3IgdmljYS12ZXJjYSBpZiB0aGUgbmV3IGlv
bW11IGltcGwgaXNuJ3QNCj4gY29uc2lkZXJlZA0KPiA+IHJlbGlhYmxlIGVub3VnaCBmb3IgdGhl
bSB0byBzdXBwb3J0IHlldCkuDQo+ID4NCj4gPiBMaWJ2aXJ0IHdvdWxkIHVzZQ0KPiA+DQo+ID4g
ICAgLW9iamVjdCBpb21tdSxpZD1pb21tdTAsZmQ9Tk5ODQo+ID4gICAgLWRldmljZSB2ZmlvLWlv
bW11LXBjaSxmZD1NTU0saW9tbXU9aW9tbXUwDQo+ID4NCj4gPiBOb24tbGlidmlydCB3b3VsZCB1
c2UgYSBzaW1wbGVyDQo+ID4NCj4gPiAgICAtZGV2aWNlIHZmaW8taW9tbXUtcGNpLGhvc3Q9MDAw
MDowMzoyMi4xDQo+ID4NCj4gPiB3aXRoIFFFTVUgYXV0by1jcmVhdGluZyBhICdpb21tdScgb2Jq
ZWN0IGluIHRoZSBiYWNrZ3JvdW5kLg0KPiA+DQo+ID4gVGhpcyB3b3VsZCBmaXQgaW50byBsaWJ2
aXJ0J3MgZXhpc3RpbmcgbW9kZWxsaW5nIGJldHRlci4gV2UgY3VycmVudGx5IGhhdmUNCj4gPiBh
IGNvbmNlcHQgb2YgYSBQQ0kgYXNzaWdubWVudCBiYWNrZW5kLCB3aGljaCBwcmV2aW91c2x5IHN1
cHBvcnRlZCB0aGUNCj4gPiBsZWdhY3kgUENJIGFzc2lnbm1lbnQsIHZzIHRoZSBWRklPIFBDSSBh
c3NpZ25tZW50LiBUaGlzIG5ldyBpb21tdSBpbXBsDQo+ID4gZmVlbHMgbGlrZSBhIDNyZCBQQ0kg
YXNzaWdubWVudCBhcHByb2FjaCwgYW5kIHNvIGZpdHMgd2l0aCBob3cgd2UgbW9kZWxsZWQNCj4g
PiBpdCBhcyBhIGRpZmZlcmVudCBkZXZpY2UgdHlwZSBpbiB0aGUgcGFzdC4NCj4gDQo+IEkgZG9u
J3QgdGhpbmsgd2Ugd2FudCB0byBjb25mbGF0ZSAiaW9tbXUiIGFuZCAiaW9tbXVmZCIsIHdlJ3Jl
IGNyZWF0aW5nDQo+IGFuIG9iamVjdCB0aGF0IGludGVyZmFjZXMgaW50byB0aGUgaW9tbXVmZCB1
QVBJLCBub3QgYW4gaW9tbXUgaXRzZWxmLg0KPiBMaWtld2lzZSAidmZpby1pb21tdS1wY2kiIGlz
IGp1c3QgY29uZnVzaW5nLCB0aGVyZSB3YXMgYW4gaW9tbXUNCj4gaW50ZXJmYWNlIHByZXZpb3Vz
bHksIGl0J3MganVzdCBhIGRpZmZlcmVudCBpbXBsZW1lbnRhdGlvbiBub3cgYW5kIGFzDQo+IGZh
ciBhcyB0aGUgVk0gaW50ZXJmYWNlIHRvIHRoZSBkZXZpY2UsIGl0J3MgaWRlbnRpY2FsLiAgTm90
ZSB0aGF0IGENCj4gInZmaW8taW9tbXVmZC1wY2kiIGRldmljZSBtdWx0aXBsaWVzIHRoZSBtYXRy
aXggb2YgZXZlcnkgdmZpbyBkZXZpY2UNCj4gZm9yIGEgcmF0aGVyIHN1YnRsZSBpbXBsZW1lbnRh
dGlvbiBkZXRhaWwuDQo+IA0KPiBNeSBleHBlY3RhdGlvbiB3b3VsZCBiZSB0aGF0IGxpYnZpcnQg
dXNlczoNCj4gDQo+ICAtb2JqZWN0IGlvbW11ZmQsaWQ9aW9tbXVmZDAsZmQ9Tk5ODQo+ICAtZGV2
aWNlIHZmaW8tcGNpLGZkPU1NTSxpb21tdWZkPWlvbW11ZmQwDQo+IA0KPiBXaGVyZWFzIHNpbXBs
ZSBRRU1VIGNvbW1hbmQgbGluZSB3b3VsZCBiZToNCj4gDQo+ICAtb2JqZWN0IGlvbW11ZmQsaWQ9
aW9tbXVmZDANCj4gIC1kZXZpY2UgdmZpby1wY2ksaW9tbXVmZD1pb21tdWZkMCxob3N0PTAwMDA6
MDI6MDAuMA0KPiANCj4gVGhlIGlvbW11ZmQgb2JqZWN0IHdvdWxkIG9wZW4gL2Rldi9pb21tdWZk
IGl0c2VsZi4gIENyZWF0aW5nIGFuDQo+IGltcGxpY2l0IGlvbW11ZmQgb2JqZWN0IGlzIHNvbWVv
bmUgcHJvYmxlbWF0aWMgYmVjYXVzZSBvbmUgb2YgdGhlDQo+IHRoaW5ncyBJIGZvcmdvdCB0byBo
aWdobGlnaHQgaW4gbXkgcHJldmlvdXMgZGVzY3JpcHRpb24gaXMgdGhhdCB0aGUNCj4gaW9tbXVm
ZCBvYmplY3QgaXMgbWVhbnQgdG8gYmUgc2hhcmVkIGFjcm9zcyBub3Qgb25seSB2YXJpb3VzIHZm
aW8NCj4gZGV2aWNlcyAocGxhdGZvcm0sIGNjdywgYXAsIG52bWUsIGV0YyksIGJ1dCBhbHNvIGFj
cm9zcyBzdWJzeXN0ZW1zLCBleC4NCj4gdmRwYS4NCg0KT3V0IG9mIGN1cmlvc2l0eSAtIGluIGNv
bmNlcHQgb25lIGlvbW11ZmQgaXMgc3VmZmljaWVudCB0byBzdXBwb3J0IGFsbA0KaW9hcyByZXF1
aXJlbWVudHMgYWNyb3NzIHN1YnN5c3RlbXMgd2hpbGUgaGF2aW5nIG11bHRpcGxlIGlvbW11ZmQn
cw0KaW5zdGVhZCBsb3NlIHRoZSBiZW5lZml0IG9mIGNlbnRyYWxpemVkIGFjY291bnRpbmcuIFRo
ZSBsYXR0ZXIgd2lsbCBhbHNvDQpjYXVzZSBzb21lIHRyb3VibGUgd2hlbiB3ZSBzdGFydCB2aXJ0
dWFsaXppbmcgRU5RQ01EIHdoaWNoIHJlcXVpcmVzDQpWTS13aWRlIFBBU0lEIHZpcnR1YWxpemF0
aW9uIHRodXMgZnVydGhlciBuZWVkcyB0byBzaGFyZSB0aGF0IA0KaW5mb3JtYXRpb24gYWNyb3Nz
IGlvbW11ZmQncy4gTm90IHVuc29sdmFibGUgYnV0IHJlYWxseSBubyBnYWluIGJ5DQphZGRpbmcg
c3VjaCBjb21wbGV4aXR5LiBTbyBJJ20gY3VyaW91cyB3aGV0aGVyIFFlbXUgcHJvdmlkZQ0KYSB3
YXkgdG8gcmVzdHJpY3QgdGhhdCBjZXJ0YWluIG9iamVjdCB0eXBlIGNhbiBvbmx5IGhhdmUgb25l
IGluc3RhbmNlDQp0byBkaXNjb3VyYWdlIHN1Y2ggbXVsdGktaW9tbXVmZCBhdHRlbXB0Pw0KDQo+
IA0KPiBJZiB0aGUgb2xkIHN0eWxlIHdlcmUgdXNlZDoNCj4gDQo+ICAtZGV2aWNlIHZmaW8tcGNp
LGhvc3Q9MDAwMDowMjowMC4wDQo+IA0KPiBUaGVuIFFFTVUgd291bGQgdXNlIHZmaW8gZm9yIHRo
ZSBJT01NVSBiYWNrZW5kLg0KPiANCj4gSWYgbGlidmlydC91c2Vyc3BhY2Ugd2FudHMgdG8gcXVl
cnkgd2hldGhlciAibGVnYWN5IiB2ZmlvIGlzIHN0aWxsDQo+IHN1cHBvcnRlZCBieSB0aGUgaG9z
dCBrZXJuZWwsIEkgdGhpbmsgaXQnZCBvbmx5IG5lZWQgdG8gbG9vayBmb3INCj4gd2hldGhlciB0
aGUgL2Rldi92ZmlvL3ZmaW8gY29udGFpbmVyIGludGVyZmFjZSBzdGlsbCBleGlzdHMuDQo+IA0K
PiBJZiB3ZSBuZWVkIHNvbWUgbWVhbnMgZm9yIFFFTVUgdG8gcmVtb3ZlIGxlZ2FjeSBzdXBwb3J0
LCBJJ2QgcmF0aGVyDQo+IGZpbmQgYSB3YXkgdG8gZG8gaXQgdmlhIHByb2JpbmcgZGV2aWNlIG9w
dGlvbnMuICBJdCdzIGVhc3kgZW5vdWdoIHRvDQo+IHNlZSBpZiBpb21tdWZkIHN1cHBvcnQgZXhp
c3RzIGJ5IGxvb2tpbmcgZm9yIHRoZSBwcmVzZW5jZSBvZiB0aGUNCj4gaW9tbXVmZCBvcHRpb24g
Zm9yIHRoZSB2ZmlvLXBjaSBkZXZpY2UgYW5kIEtjb25maWcgd2l0aGluIFFFTVUgY291bGQgYmUN
Cj4gdXNlZCByZWdhcmRsZXNzIG9mIHdoZXRoZXIgd2UgZGVmaW5lIGEgbmV3IGRldmljZSBuYW1l
LiAgVGhhbmtzLA0KPiANCj4gQWxleA0KDQo=
