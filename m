Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8285563CD5
	for <lists+kvm@lfdr.de>; Sat,  2 Jul 2022 01:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiGAXkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 19:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiGAXki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 19:40:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AE4443E6;
        Fri,  1 Jul 2022 16:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656718835; x=1688254835;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bFKhKUNn6zTjTvGNB6I8XUGtCiL4kGNUZa+C84igMqk=;
  b=D4XpgKjrBUMQKNoXitGsndVW5c8YvcVpp731tbrpIESBRVKZK53pz3AU
   WIxCZpqMpHAkbuA066ctoLNQhNmMq6tQW/J1OwZ8RKfX5WqAeWGtM6r61
   arQgOpL/n7h+CdK6loJX3OHfVXpc35VLU6gXh7mcWR9BLzzGvjXkPCKEC
   G0F1G9bvMgcAruHL+8jYhC0CAW6iqjXa+jpA3KzcIPdHrwroLGhuny8Yo
   Xjp7Augf8xcHtUS8S+21h6mUk1zNJ+1k9nVdSxh5JaOyZwDKV0PIUCChJ
   MsRDXhtjfs6hG2dQZELlGW83aSwpZ4rXCW3gfpvw3pcBenm6ZVr+QXkOz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10395"; a="280325525"
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="280325525"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 16:40:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="596438520"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jul 2022 16:40:34 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 16:40:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Jul 2022 16:40:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Jul 2022 16:40:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sw2PpI0zOBm+6UNnu+lAeo/frkjz2d+CV1JuQwghZwjfQKn6zoq2E+mJp9bPLjEBnj9Jprj1R49rmLOZKt1ZVbkSclfzieeoe94P6nu2TzBrcIKwTMxOI5JHOUMSd3EUMJtl+VeE4kIedXdetOJ3FLtuANX+kHwQRlLuyB3hlD7aZxgLdLOFNrOaA7LgL6Uz+g86CE7WayadZRmQcsKvV5NEQJlqon1JJsjEMsd25BpNX7RVLCgbaNfOENDTlkg02oLrRmcDT8szZekjqhO9wZbM/ZIYeER7XeWqNxJB4fPm0bQwYB5VtnImXioVm7mubbxSoyxB1R9HcRC7umfU6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFKhKUNn6zTjTvGNB6I8XUGtCiL4kGNUZa+C84igMqk=;
 b=UC7Q50C4EnHuTcnc6+Of1de5e48gaMFX+CA4sIYcLkchD7wYoQmeMhgkvOCfmM6fmUOmiMtVSq5xyhm+MUydifFs6/SZ7XPPQxT/KLSY8Pu6IJWg8GFFXkjaT/i3xJDnX+9+R+YaV5DzgmnOC2c1U6CXOArVZcIyRAmCf84F7RFjOqSvDzVNEyXzDFSTK27KqQUaX1mTtZTv4Z0375OURUjvDjN/ck8GkCQQhR8uK7jO4YDo3G+bfVBToQs2eAf+82yPkJ+MbjKM+K9pUmYks0fLLJ9W7PBySMlR/YlqiFqd7U3qmVBI1ixbgSBUaym/umXBazr4qGQNsU7KKywZmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1236.namprd11.prod.outlook.com (2603:10b6:404:48::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 23:40:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5395.017; Fri, 1 Jul 2022
 23:40:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
Subject: RE: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Thread-Topic: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Thread-Index: AQHYjRJW3CSa5JgkkEy1u1YUe1sfEa1pUhkAgADYNXA=
Date:   Fri, 1 Jul 2022 23:40:26 +0000
Message-ID: <BN9PR11MB5276F1DF0264115CA8FCB3EA8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220701061751.1955857-1-aik@ozlabs.ru>
 <31d6e625-b89d-c183-0b38-0ab8ec202e47@arm.com>
In-Reply-To: <31d6e625-b89d-c183-0b38-0ab8ec202e47@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd6f93aa-65fa-4710-dbab-08da5bbb12fa
x-ms-traffictypediagnostic: BN6PR11MB1236:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C9OB3vnKytync+pHX8RAkuVYC0mkPn9BJFMCYFCAYpDafgxDmqIijfNGL4zlXI70BUBZv65mjM/cffLneqsFMy0HbVqa4dTgW9QXLOTczKEPwYSqdDZPzi9qLb15i8tzQTzXzmlBkElgP7n11usz/Q+Wqzdla2PouUyDo/d6bVUKJG6xAn1sP2mKkD/XZTZuMFKWLdEghUsPZDowKHlSETzEoZ2JyOnIQSUt7QdGFGMXxOWYJMPSS7xtHWpYGbvHppHBpsNhovoib3GXTkiZlfyXpMNlpMU+xevvZfI+M/NSGUk89qhH3Eyod7jPx58yQQKFcfIZDNccmkbfCTRwhkKT+8KkZ3FBuZDSb8NJ8mlcxc3/NNBirJIXs8rzekRTufUvWm+cd10XDmwwFD9b/7wn16DEwC4Gzpjk141rlo4QhNTcbgC30xtmrmMsE3E1khJCIM7d8pzgsnsZ8aGk9L9Y9piu5O6OOufvHjIyd/ja9VU+aaQX5zgW/NLP5heNBNKdtc1ui7QJwmebf0rwsS5VcHBj3ArBbYnPUP+hBs/LKUVVtRABoeaDsoZ3bEiW9IC2LaWwFhJUHR6Nbf9oSR0S7aQ31OSKDuE+7aSHyzJZawj6LKnOL0ghnL9T5evsjTmPwcsrm3uWe46CdxWFtRigDukaO8lQWr5uLosrbjCbSf7WU2Yjj2wmjn+awd/W2DZAuvLZ5EFqLib8rAzDWAZfKVyvZaKaitIg48G1meoMGFK+Q9I/zhnf6PNyqALZNTWjFpDWuOBkYPjTT6vA9S/oYi7poYfJkqxCxxR0K5oELMz4P5XIVpquXPcnIsK5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(376002)(39860400002)(346002)(366004)(52536014)(2906002)(8676002)(5660300002)(66476007)(76116006)(33656002)(66446008)(66556008)(64756008)(110136005)(4326008)(66946007)(478600001)(71200400001)(8936002)(54906003)(41300700001)(316002)(26005)(38070700005)(55016003)(6506007)(86362001)(9686003)(186003)(83380400001)(122000001)(53546011)(7696005)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TSt2bEFwdE9NSEpzalRob1RNY2hScXNpdE1lTjRhWFkrSXBTaDVqQ0dLSWFX?=
 =?utf-8?B?K3AyYTJpMnNDUmZ6VGdSYnAzNHg2TElqY1VudmVxTHFnVjlQOU5zNUl0YVBs?=
 =?utf-8?B?OG9DUVJFZnhIeUordXEyeXlWU2JvVlAyYVZpSGVGcndSRytSR1VhS3Z4Qzhy?=
 =?utf-8?B?ZjgxNXluNnc0c1dSQTZ1ZVp2akluMk1Oc1hFNFN4Qkt5bCs4Z2J5WUxFUDh0?=
 =?utf-8?B?cDJKRHRmU2gzK2ZzZC9OcGlDcnZCNGFjd1VLZVk2ODNwY1d2T3ZsN0Rhelgv?=
 =?utf-8?B?R1haMXVQZHBBV3Fzb3RHUHIxS0l6WlhTNmJsODlLak5iOUJ3Z0tvcWJpWDJ3?=
 =?utf-8?B?Q3FuVFZzdWExbkZ3dXhXNDd2d0IwMVVDRnRpYmNzNHJhKzhSbEljTmVBZ1U2?=
 =?utf-8?B?eS81c3YzUU1wbGw0SlVoNTN6dDNYSEwyTVJnc1FSNnEzcHhHRWFOY3ZPYjBK?=
 =?utf-8?B?STJhTEJMMm12YndYZklFaFc0enlNdWMyUEdYQzU3ajZ2SXk3Rzk5dnVscTF6?=
 =?utf-8?B?cTJjZUFrV05tZXdjaDVVenJUS1pqdDdjdVliTTVJRmZ1ZkVNMXp0VC9Xa0xI?=
 =?utf-8?B?aVZLaUlmVXM1QWxGK2EvSVhoVWFmSVlsMVMyNmRFY3FUdzl6UGxWbWs1elNs?=
 =?utf-8?B?eFQvRG92aUFaSnUzdVYraVBzV1c5VUphdklnSloySU9PdHRsSmJnRG1xamE3?=
 =?utf-8?B?WHJCVWQwK1N6TGl1Z0JGdWpKbDA0VThHK2ZDV3dBZ0RheThUYUd3RDdab0VM?=
 =?utf-8?B?VVl0QzNXV1NoZmw5RmdmaEUxS2p2QVMzZXpwY0V4L0U3dDNQVXk2K2tNZ2RT?=
 =?utf-8?B?ejBoTTRTZ0pEQ1lDNVNwRmdFTGdQLzgxQ25SSmV5VDc2RjlLZHRwakRUdThm?=
 =?utf-8?B?TFJnNzZaNEpRdE1Qc0NiREFua0ZQRC9CeDY1WmN6dlJkcDI4OGYycnFEZm9k?=
 =?utf-8?B?VHlpZUUrVTRvWEdJUk9YSTg1UWQybmh2QnZCTi9vQUdhZHZPeFF6SXM3L0t6?=
 =?utf-8?B?YW1yUzBBY2pUNkY0cVZ3eDBDTjluT3JSRXk0dnZHbmkvQ0tNUUl4OWkyMCtj?=
 =?utf-8?B?K2R2a0p6M1RCeDlpK2R4YmJPMHdhMGpPOUpWbytlK2huY1RQcGRxTUd3S3Fz?=
 =?utf-8?B?UzNHdFd0NzNHVVluYWtUODdmRks5MEkwZGxRdkVjTUJ0WFVLcUZCN0k3emw0?=
 =?utf-8?B?ZlZaU3dTeXBhWFNqNVBGR29ac1E0aVByTU1JT0g4cWhtL1JBSGNvcmZya2hw?=
 =?utf-8?B?a3plMnBhWHUzK203c29LYjlUTTk4SEtudi9WQ3RveW5YUmZ0MWc3ajNNZHJH?=
 =?utf-8?B?UVhLNlA4T1lXOWpyV0trdnlmejJoTW1qQjUreTh1bkFhWmVScjJnTGRYczBC?=
 =?utf-8?B?Q2t3OGFVbS9WcnpKZXl4REV4aXJ2YnZaOHUvTWxEWmQ2UVlhaDcxd055NHVU?=
 =?utf-8?B?Zi81NzMrTTcvd3lsczVJQXhkNmJVOUFvK3hkVjNqbzJHM1BBMHpac1c4U2E2?=
 =?utf-8?B?c052Z01XbU1XbllDQmFYVFB6SXJ2WmlKOHd1ekVtVUlRNzNuYU5mdGEwSjI4?=
 =?utf-8?B?eEhFYVQ3d1JlQkdIczZVOHZOWTg5QkZuTXZtQUJrSmJuK2lMUDQwMVh0YXJE?=
 =?utf-8?B?cHNSdDRYYnZVaGVWMXFMVHVXNFN4OHkyVmF4K2ZHcGp3RUdsUm9tZ291N0tL?=
 =?utf-8?B?am8yVHh6dWpwMHg1Uk15NXFRMXBCRGZxKzVBNHl3QzgxU3NhN3RLUUk2bWJW?=
 =?utf-8?B?d01qRjY5UkVpeWhpbFFnSnpreG1UazJ5a2pZaU5Pd1liZWhwaStMWmVaQWNR?=
 =?utf-8?B?Qm5RZmJ4cnpzNENDWVowODIzd09rVXdKTGtCVzRVUEJvUDc3VHhDNkMrMnpk?=
 =?utf-8?B?endDY2tVN1VTYkQ5bVJuZjFWb3ljaFpURlpvb21pLzNOVTI5UlZSNUxZUmRF?=
 =?utf-8?B?UTQ2U2pDVy9JMnpZTGY1RldYWm5QN0NxcFZtRVh4L2lVcmpsQlJUcHdjTFpU?=
 =?utf-8?B?eWV2VFNSMWYyWVBuSFJLQlZSNUhCSWNaTXF4QnRXZ3AxeWZvWER4OTVwdEdL?=
 =?utf-8?B?YmU3T0c4NVM5eEI4THB0VWhOQjVCc2pnM1prSVFlMWJTUWVhNmZzeVp4ZHRP?=
 =?utf-8?Q?owDHyrnYw2i0nkt+umtlmnnVH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6f93aa-65fa-4710-dbab-08da5bbb12fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 23:40:26.1476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QvRxnOWZkyPrtxfQKCI4aW4/GIUtMOgN39ZvrrhW6gwt+zT5XhEFtv0UNZWz4dl/Uz0VtGHf5qqHNZ6GG7gQ6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1236
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBSb2JpbiBNdXJwaHkgPHJvYmluLm11cnBoeUBhcm0uY29tPg0KPiBTZW50OiBGcmlk
YXksIEp1bHkgMSwgMjAyMiA2OjM0IFBNDQo+IA0KPiBPbiAyMDIyLTA3LTAxIDA3OjE3LCBBbGV4
ZXkgS2FyZGFzaGV2c2tpeSB3cm90ZToNCj4gPiBWRklPIG9uIFBPV0VSIGRvZXMgbm90IGltcGxl
bWVudCBpb21tdV9vcHMgYW5kIHRoZXJlZm9yZQ0KPiBpb21tdV9jYXBhYmxlKCkNCj4gPiBhbHdh
eXMgcmV0dXJucyBmYWxzZSBhbmQgX19pb21tdV9ncm91cF9hbGxvY19ibG9ja2luZ19kb21haW4o
KSBhbHdheXMNCj4gPiBmYWlscy4NCj4gPg0KPiA+IGlvbW11X2dyb3VwX2NsYWltX2RtYV9vd25l
cigpIGluIHNldHRpbmcgY29udGFpbmVyIGZhaWxzIGZvciB0aGUgc2FtZQ0KPiA+IHJlYXNvbiAt
IGl0IGNhbm5vdCBhbGxvY2F0ZSBhIGRvbWFpbi4NCj4gPg0KPiA+IFRoaXMgc2tpcHMgdGhlIGNo
ZWNrIGZvciBwbGF0Zm9ybXMgc3VwcG9ydGluZyBWRklPIHdpdGhvdXQgaW1wbGVtZW50aW5nDQo+
ID4gaW9tbXVfb3BzIHdoaWNoIHRvIG15IGJlc3Qga25vd2xlZGdlIGlzIFBPV0VSIG9ubHkuDQo+
ID4NCj4gPiBUaGlzIGFsc28gYWxsb3dzIHNldHRpbmcgY29udGFpbmVyIGluIGFic2VuY2Ugb2Yg
aW9tbXVfb3BzLg0KPiA+DQo+ID4gRml4ZXM6IDcwNjkzZjQ3MDg0OCAoInZmaW86IFNldCBETUEg
b3duZXJzaGlwIGZvciBWRklPIGRldmljZXMiKQ0KPiA+IEZpeGVzOiBlOGFlMGUxNDBjMDUgKCJ2
ZmlvOiBSZXF1aXJlIHRoYXQgZGV2aWNlcyBzdXBwb3J0IERNQSBjYWNoZQ0KPiBjb2hlcmVuY2Ui
KQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXhleSBLYXJkYXNoZXZza2l5IDxhaWtAb3psYWJzLnJ1
Pg0KPiA+IC0tLQ0KPiA+DQo+ID4gTm90IHF1aXRlIHN1cmUgd2hhdCB0aGUgcHJvcGVyIHNtYWxs
IGZpeCBpcyBhbmQgaW1wbGVtZW50aW5nIGlvbW11X29wcw0KPiA+IG9uIFBPV0VSIGlzIG5vdCBn
b2luZyB0byBoYXBwZW4gYW55IHRpbWUgc29vbiBvciBldmVyIDotLw0KPiANCj4gRldJVyBJIGRp
ZCB3b25kZXIgYWJvdXQgdGhpcyB3aGVuIHdyaXRpbmcgWzFdLiBJcyBpdCBhcHByb3ByaWF0ZSB0
byBoYXZlDQo+IGFueSBJT01NVSBBUEkgc3BlY2lmaWNzIG91dHNpZGUgdGhlIHR5cGUxIGNvZGUs
IG9yIHNob3VsZCB0aGVzZSBiaXRzIGJlDQo+IGFic3RyYWN0ZWQgYmVoaW5kIHZmaW9faW9tbXVf
ZHJpdmVyX29wcyBtZXRob2RzPw0KPiANCg0KVGhhdCBpcyBhIGdvb2QgcG9pbnQuIEJ1dCBhbiBh
YnN0cmFjdGlvbiBhcHByb2FjaCBtYXkgbm90IHdvcmsgYXMgaW4NCnNldF9jb250YWluZXIoKSB0
aGVyZSBtYXkgYmUgbm8gaW9tbXUgZHJpdmVyIGF0dGFjaGVkIHRvIHRoZSBjb250YWluZXINCnll
dC4gUHJvYmFibHkgYSBiZXR0ZXIgd2F5IGlzIGp1c3QgdG8gZG8gY2FjaGUgY29oZXJlbmN5IGNo
ZWNrIGFuZA0KZG1hIG93bmVyc2hpcCBjbGFpbSBib3RoIGluIHR5cGUxIGF0dGFjaF9ncm91cCB3
L28gYWRkaW5nIG5ldyBvcC4NCg0KQnV0IGEgYmlnZ2VyIHByb2JsZW0gdG8gbWUgaXMgaG93IGRt
YSBvd25lcnNoaXAgaXMgbWFuYWdlZCBub3cgb24NClBPV0VSLiBQcmV2aW91c2x5IGl0IHdhcyBn
dWFyZGVkIGJ5IEJVR19PTiBhbmQgdmZpb19ncm91cF92aWFibGUoKS4NCk5vdyB3aXRoIHRoYXQg
cmVtb3ZlZCB3aGlsZSBQT1dFUiBkb2Vzbid0IHN1cHBvcnQgZG1hIGNsYWltLCBkb2VzDQppdCBp
bXBseSBhIHJlZ3Jlc3Npb24gb24gUE9XRVIgcGxhdGZvcm0gbm93Pw0KDQplLmcuIHdoYXQgc2hv
dWxkIGJlIHJldHVybmVkIGZvciBQT1dFUiBpbiBWRklPX0dST1VQX0dFVF9TVEFUVVM6DQoNCglp
ZiAoZ3JvdXAtPmNvbnRhaW5lcikNCgkJc3RhdHVzLmZsYWdzIHw9IFZGSU9fR1JPVVBfRkxBR1Nf
Q09OVEFJTkVSX1NFVCB8DQoJCSAgICAgICAgICAgVkZJT19HUk9VUF9GTEFHU19WSUFCTEU7DQoJ
ZWxzZSBpZiAoIWlvbW11X2dyb3VwX2RtYV9vd25lcl9jbGFpbWVkKGdyb3VwLT5pb21tdV9ncm91
cCkpDQoJCXN0YXR1cy5mbGFncyB8PSBWRklPX0dST1VQX0ZMQUdTX1ZJQUJMRTsNCg0KVGhhbmtz
DQpLZXZpbg0K
