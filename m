Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17241725273
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 05:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240534AbjFGDkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 23:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbjFGDkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 23:40:49 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C00E54;
        Tue,  6 Jun 2023 20:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686109247; x=1717645247;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NXP0EbY/8o70HTOcZdbiRuSqyy4dRfjjMTfnnBWagTc=;
  b=CmH69+il2AKpjgJ+6CJ4aBxT6gQ1YgJcEiEjjxejix48iDv/RlPT1nEP
   R4KFXBY2MPaCi7R8cl1EDqq2ZmVtGNM+q+G/Dd4MIzhHenbGABgBkCrFy
   ohEb+FHtcbKbeljoUk/OkODaQiGgxxvjy6aN3DyFdaU6DqLSSRmVJOySu
   2X/FOBFOA9zPHqbsz7hCC2BnnIgb094JJGJJBnfrhVK0j24pGWqcdThQ3
   qJWCwt+dV2GbeChkcZl7vgL72CMlQI0UQeeDELAmnPEZHaEM6vv+cJNEf
   dTXhB01ShUAGCCLmn4nlwvhoxN2XBMwutux2TqGFhoQn8PcAhzYQ9bzja
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="346476488"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="346476488"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 20:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="853663578"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="853663578"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2023 20:40:45 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 20:40:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 20:40:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 20:40:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqPivUByOd2azm/ePYw8iFomSRxqp9gzLLhFIbHMKxzvUTkxL9x1xSoWzIyrBgl+XdLkGUN7/1uV89qxOrrhUk/O0Uxkeqvn6zYHoZkZRI7zjfI/x2mOOb0Z/LmbM/FBnLVWS6HLt1Puq4rLcYg4veewfSgEaO5esDPPvSAhJkoeqpKw3tjgWhXD2PCOzgL0Z2ydli2PZw6pp1CRn2lwxdBLGop5gB4uR5LKYHCNhOnXJ5geyxL3IxRrmt2zdl7XB6BYNBZLa603aEBGMu9OILo1skv4Q53GGKECDaHH0IltgqkyN5zfsJfCqwvz64JGtj21c5ze5Ub4EmQlerlPKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXP0EbY/8o70HTOcZdbiRuSqyy4dRfjjMTfnnBWagTc=;
 b=IzhQ9JmiB79pLeRbi7X/+6AiR/vxypHl7COtf0n56tB5F/xGxeYBvIBH/zhUvVEax7q6ZW1u+RdZARZ/tZWYLIfZQO1VElRUQ2OxOlF42ZvuRaQ6TcO7r9X61PnuwmdREWu9ahkIIa6jLw6rS80jnHe8Y6ERWplLJmLGuOaPK+QmBKw9/ebp5tj7IVVvtLAdTesyvqvqgMtILwTNql5jZODmCPsEo3qaBI7sXL4OTuuBIwjft8PTa9qOHMoAeqp6uF6LlxDiQlkCbspAbMdgTNEVmSotns7qEuugFa9Fsq57zsEeiXyTk94feNrpgk7XVFOKNi2wZvzGsdTJsoyDtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6090.namprd11.prod.outlook.com (2603:10b6:930:2e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Wed, 7 Jun
 2023 03:40:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 03:40:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v9 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Thread-Topic: [PATCH v9 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Thread-Index: AQHZmFfuANh3ioR480+bw2zBFwe+E69+svKA
Date:   Wed, 7 Jun 2023 03:40:37 +0000
Message-ID: <fbc522e315d261607869b1996adc05e3646e535e.camel@intel.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
         <20230606091842.13123-3-binbin.wu@linux.intel.com>
In-Reply-To: <20230606091842.13123-3-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6090:EE_
x-ms-office365-filtering-correlation-id: e29c3f3e-6dd3-4060-6527-08db6708f581
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LAhjJZArv2q3imB6RcPmxglTxnfArET6pwN2z8JUoqewjPJ9KdUwgXi363OvhbqEFfLFepEeirmevAZMA+kLkXzg4dSa5W8CLXgKsDHkADtYimViSPZ3ygHomMTBczPTl7mdpCKS0neApITw5WShkACPIkGJXN3Zh2YhOD8FSM8F63ZEJo8tUVhrM8VZQMe3HGAUImzjmt20Cvn3/OSPWUZSRUtm4c6hUtRN/K93iwlt/t9zz4Lxh1jxLDWwbQimB/iKdot68LQFv5gIuoNzfDRV7+aOamwJzAMpqNFWKHEcaxrbFwLBN6qgDiCeSwSPRG437fl3EpPvh0pse/HOfLoJKmuZdaZ7zDm0Y/QhHUQ2I6VIq7NX8qZazQBfJMYj8kIXNu/TIvb211/Dk0M9Is0g0gRLRIVgO5sRQ8KQ9vmgeb/58iWdOTnT2ugCx7XzwGrzsCxKat5WFrlUvPjYwKU32ozGw/Z0XIzU603NL6YR4zxA5JnIS1p8ZIIWp72m4Gkji64bm6A636eNgEofw1IuwJQSd+4wm2fQn3LkE8qH1aNJ7kINmENuGFE6b4lTX4ND+X16w7VB1vklPbxjSAVH9I9o1IADAkI3Wm/X88MP4+zwURaKCJWnIxyBtlU3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(86362001)(64756008)(66446008)(4744005)(5660300002)(2906002)(4326008)(41300700001)(38070700005)(316002)(66476007)(66556008)(91956017)(66946007)(76116006)(38100700002)(54906003)(110136005)(8936002)(8676002)(82960400001)(122000001)(478600001)(71200400001)(6486002)(6506007)(36756003)(186003)(6512007)(2616005)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEZJNGp5OXMrd3h6aXRJYk9SMkM1cXkrTkh0RDhodENYNGIvZjYySUphU2I1?=
 =?utf-8?B?V0JjVUpXdzVxRTFqY0xhV2dJVExjYlpRZHA0azdwcHRBMnNCSzZVVDF1bElh?=
 =?utf-8?B?bG1tckJ4Skp4aG02bkI4ZmtOUDlmRld6QUNFeTVvaXk2aGJvaERHWk1Oa1Az?=
 =?utf-8?B?alJtdkhuM2U2SjBNV3ZWUlhxUUZuM3YwV1p3MW42OWx5empjdCs1MlYxL2ts?=
 =?utf-8?B?eVNkaGFSZHZPZWttS1lyUlJ3bElzdmdnVFJ0b0VZS2pUa3kxd1Avbkd3eVJQ?=
 =?utf-8?B?Vkg5ZjdZTjBBY2hiYjIyYitUdDhYRC9kdEFBbkZXc01RTlAvOG04bVFiQXhJ?=
 =?utf-8?B?VzEvVVhyZ1A5aGJNaGt0OW9iM3AxanlLNjNDcGRSRndnOHR3SG42cTRiUjQ4?=
 =?utf-8?B?RHpGQVBtckxWQVJZVWxvcmh3UWJtL3RqZEVNTjBsQk1vNFdiYndkVHFIeThB?=
 =?utf-8?B?aThlWG1rT0ZZazJIQUlpaC9OajRwaUZxUXF0S2pldUZ2Sk9qTEJwdlZEbzBE?=
 =?utf-8?B?aEFGemtwZ1pDakV1SkxpYUpwRTQyd3U1WGIydkI2elA4SG9OL0pDazc3QUVK?=
 =?utf-8?B?TURnd01kTUpibUFDRWI3bEQ3akpnbE01YjNEQ0xBY1paaytNcFJJRTZaY0VC?=
 =?utf-8?B?bnZpakRwYUxCWVc4Y0ZhcjFlR2ZQak9vcTdjbytBdnltMzZvcTZtZGVSdXQ1?=
 =?utf-8?B?SysrVzlNT0xqd2pORUdOMjArR0pPMGhDNnRYdVc2NnNsNXZ1ZEYwdk1rZ1hx?=
 =?utf-8?B?ZTJwUFIvbUVuOTlXRVJxWWZmQzJvN0wyTXVtTmpkUU4xeFBnbGFuWW4ycUZQ?=
 =?utf-8?B?UFV0ZVgxQ0lXNndvUjIzYTQ4VkRwZ2lyT2xCZzFNV25PQ3Y1T1p2Q3RwZU5M?=
 =?utf-8?B?R0NidHRrUWZNZTNPNVAxOExBL1VOdTRQMHBxMy9IVXFVZWlXVGxrcWRXS1Jy?=
 =?utf-8?B?MS9PbERrMHYrT1I3TmFWRHVLS0Y1eG9lRjREWTFQZHFrdmg0WVNyRTlhajJN?=
 =?utf-8?B?SUkyVUpBeVJ5Tmd1eEh2K1RTVEpOdWNURTdNUHEvU1FPTEFOcnNMVy9mR0xz?=
 =?utf-8?B?N0dzbVU4YjZMSmp1c25uTDRGYkVwRHJFQVJEa1A0VUNuOFlpL2FiS3huWGpY?=
 =?utf-8?B?QkZRR3BpTkFUazN4dDAwVFZtamRvMTZ0TWZaM2ZoYnByZlMrdnZoaVU4U2lW?=
 =?utf-8?B?QWhyUkxPMHhObGFUK0xUdTVQcEVEK1E4bCtLekVVZ2drVTFRV1ZQNjJIbkkw?=
 =?utf-8?B?ck52VG9RYzJrcFI3NmFnUTFocFdORWsvN1E1V1FPaGtFeFF3NmJiQXY2K05z?=
 =?utf-8?B?WW40QUZQRmZVQ0ExVzNtOTBzRTdRSG5YekR0NWRia2trMGE5U2pwenlXdW5U?=
 =?utf-8?B?TnRUL3Mzb3R4ZGJRMHdEbFAyT3lKQmZ2MkdBdzQrZ1JhUnZ2emNCeEl5UmR3?=
 =?utf-8?B?TVpiY1JUQnFYOFUwbnk2cUxrV1FabkRReEJwSk1MUUU5WTNZeTBwTFd0aGIz?=
 =?utf-8?B?UWhVWjlwV3I5RHJoTi9FcFB6M2tTajBPeTFIbExCeStiWXJwSmlUdVpwck8v?=
 =?utf-8?B?aURwZVVybU1vSVl3K2s3dkphUlFqL0hSM3dqdGIrdjFnc1J6d1hLaHdDeWlM?=
 =?utf-8?B?NmpqVFNiQVQxeFdTRVdKdzdrRE1ubERMdUpIdFBERXBKWFROTzRYT2JkYmZu?=
 =?utf-8?B?ajArVXNiY0pRN2NVcHowU241cHdsZG5tRHNQTU4vejJaYTJ5ZHNsMzllNHo3?=
 =?utf-8?B?cEZ5THFycmhJMzIzZDlvSVVPYVhVaGc0VXM5REhJSGtyQzIvY2laZkE4UkhX?=
 =?utf-8?B?bzJUajk5MnB1Q0xMa0ZadmFsTFNoUy9USk5uMjVxRWREbVBrRTJlVk02KzdD?=
 =?utf-8?B?MUFuTFdueWNpUFY3cGhvVGFlTTdJMGd2WjVsamhDVEFnMEorbVdMVloybUZV?=
 =?utf-8?B?VmN2dUFXdVNRSFlwN1p1VUxMYUZ0bzhnOWZhblJFMjJ4SFI3a21rb284UmNY?=
 =?utf-8?B?VkIwYS8vT1NBbWZIdnZkUDVacXpnZWttdy9DRklGVUdWUDZKazlERzh4V0s5?=
 =?utf-8?B?ajRVS3Fra2pqMmNHem5Sd1BIc0dFcW1oL0hxUFJjcXJoeTBkK1BmcjFvK1VZ?=
 =?utf-8?B?MmpvUTFKblFFQkhNb282RnZLbThkREtmRStoQmc2ZmhrSm9CS1NGbzZjeTRq?=
 =?utf-8?B?SkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C72CC8D4A72EC24680D94D4A24C36300@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e29c3f3e-6dd3-4060-6527-08db6708f581
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 03:40:37.8968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zihv3/IEy4q45nvEzFxjYYuNlxPb7Qusy2kUR/9t1+VCd23uAVWkGFVoRDv7+4PL36JqexhdcU6A4kTlLYCrcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6090
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTA2IGF0IDE3OjE4ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE1v
dmUgQ1I0LkxBTV9TVVAgb3V0IG9mIENSNF9SRVNFUlZFRF9CSVRTIGFuZCBpdHMgcmVzZXJ2YXRp
b24gZGVwZW5kcyBvbiB2Y3B1DQo+IHN1cHBvcnRpbmcgTEFNIGZlYXR1cmUgb3Igbm90LiBMZWF2
ZSB0aGUgYml0IGludGVyY2VwdGVkIHRvIGF2b2lkIHZtcmVhZCBldmVyeQ0KPiB0aW1lIHdoZW4g
S1ZNIGZldGNoZXMgaXRzIHZhbHVlLCB3aXRoIHRoZSBleHBlY3RhdGlvbiB0aGF0IGd1ZXN0IHdv
bid0IHRvZ2dsZQ0KPiB0aGUgYml0IGZyZXF1ZW50bHkuDQoNCktWTSBvbmx5IG5lZWRzIHRvIGRv
IHZtcmVhZCBvbmNlIHRvIGNhY2hlIGd1ZXN0J3MgQ1I0LCBhbmQgcHJlc3VtYWJsZSB2bXJlYWQg
aXMNCmEgbG90IGNoZWFwZXIgdGhhbiBhIFZNRVhJVC4gIFNvIEkgZG9uJ3Qgc2VlIHRoZSB2YWx1
ZSBvZiBpbnRlcmNlcHRpbmcgaXQgaWYNCnRoZXJlJ3Mgbm8gbmVlZCB0byBkby4NCg0KQnV0IHBy
ZXN1bWFibHkgSSB0aGluayB3ZSBjYW5ub3QgYWxsb3cgZ3Vlc3QgdG8gb3duIHRoaXMgYml0IGJl
Y2F1c2UgS1ZNIHdhbnRzDQp0byByZXR1cm4gYSB2YWxpZCBDUjQgaWYgTEFNIGlzbid0IGV4cG9z
ZWQgdG8gZ3Vlc3Q/ICBPdGhlcndpc2UgZ3Vlc3QgY2FuIHN0aWxsDQpzZXQgdGhpcyBiaXQgZXZl
biBMQU0gaXNuJ3QgZXhwb3NlZCB0byBndWVzdC4NCg0KQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8N
Cg0KSWYgbm90LCB5b3VyIGp1c3RpZmljYXRpb24gb2YgaW50ZXJjZXB0aW5nIHRoaXMgYml0IGlz
bid0IGNvcnJlY3QgYW5kIG5lZWRzDQp1cGRhdGUuDQoNCg==
