Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFB65A70EF
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 00:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiH3Wmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 18:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiH3Wml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 18:42:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666A5659E5;
        Tue, 30 Aug 2022 15:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661899357; x=1693435357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CPG9RPOeqiCh5xC0yZCUHK/36bvQIiQrZVZZ3lBVKNU=;
  b=TCQ3OALdKo/EdqNOqu691A0U3nfrW+U8wG8v51w5Tvl7grQRdEx8n/Cw
   kB/yRgQ6+W+gf7r3xSdF400Mqgbnb0bmux7EJRR93K4w3LqPqfOxE6HNt
   cdVYl5kzwLB3XPqNmVSa9rvrWCQy1FalskwDKYHjpNGmRzbq0keYcSXAx
   T7mri4qaRK3DyHIHDJ9jKbVUMWihJQDWNWsLg8RQvuuDAd6aj7UGsua+f
   WA7jOxLJ9Qa7oGeR021hNWgUiZU1SFdJ0ABLC5fypRQmnid09XDxhi92d
   ZADaXol+soZUAWWZHMW/2+42+TW0QH/SsktJpRR7U+zeo0ZAFIuew0vJO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="296107242"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="296107242"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 15:42:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="673088496"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 30 Aug 2022 15:42:36 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 15:42:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 15:42:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 15:42:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPh798pQ/oDdzKsbQIvSVDInDqEPgNXrzB5kV9sa4zNC8oDX/44x4rWJ7P72zkTpWn+HOFCCq7OfH7yc91ADbsR9Tu541wH7YHHjPdHuVTi8FiTEBJBgUj5DuEPuaUMg1fbBc3IyG7uFsLw15cWhU+qMU1NTBD6cvS2+izb7kO08WwWvEMFhJNSJVJviMTM5xSWLki11zFkgO2Uk2alCeX98Qv/Qgu4RVd8T2OwMNr7Y8sswkP6QYbLFcLHxSlaPADPAe9ERzwy7KN/Ae734tr5gzIQrRXiVpzzASZCg9SFBac4oC1mDuP3F134b752r75lTAcIAjEb0KD+ErQGGjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPG9RPOeqiCh5xC0yZCUHK/36bvQIiQrZVZZ3lBVKNU=;
 b=XLmfV5fYxurcZa6tZMxuDkaUvdk7hpesJSC+3HPtqdcx6KCwUUmojJaKO+NTu66x+yJ9TJAtj4CepIoPLHOqQ0W5jkmqB8OO4MUcBmk0nUPJbUac/X1KERpJqZuh3IWRhayPB4LELWwlKx4VDM+7J8nSdcmcDC7eL6JA+YsTl5PzdbJi37bSj3iWhfmckX+BbMTAs4BCKhj84TT9D0m7XPN+gM1zg+5RGWRT2HE3zikNPEcVGkD3+JbE3BWyw5L7UWCyuegsB2OD8rY3j69zpNKX826ghfWOKZxhhkw5d7MzEAkgvwhfZRRUkjSpZ+Je6c78FCCx5zgoAnRPp3+eUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by BYAPR11MB3671.namprd11.prod.outlook.com (2603:10b6:a03:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Tue, 30 Aug
 2022 22:42:33 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::fcf2:866:2eb0:b146]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::fcf2:866:2eb0:b146%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 22:42:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: x86: mmu: fix memoryleak in
 kvm_mmu_vendor_module_init()
Thread-Topic: [PATCH] kvm: x86: mmu: fix memoryleak in
 kvm_mmu_vendor_module_init()
Thread-Index: AQHYtrpTE8hRcJCftkOclVuF10QdUq3IBKiAgAAReAA=
Date:   Tue, 30 Aug 2022 22:42:33 +0000
Message-ID: <e1199046d184ad7210ebb100fc2f4b77d1ef4fba.camel@intel.com>
References: <20220823063237.47299-1-linmiaohe@huawei.com>
         <Yw6DsUwSInpz97IV@google.com>
In-Reply-To: <Yw6DsUwSInpz97IV@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abddfed6-ec6a-46a7-8820-08da8ad8edb1
x-ms-traffictypediagnostic: BYAPR11MB3671:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ta1hOMm+1qBOFrPg5icbATdDgc8fGeE6RSEpIyswu32cX/OsjgU61jDVeDC4+wPrsUESIC9eMe1VhJcdKB4Va8j/HpRQbgY3kzbFT3z67CS+wN6Dbv6kqA9ZwxwIq+tBDeDKITjaR8S3yfPLDQeRJUnC0rVEPlEyshV98Q+wlAi1Qaj46gY6aatd2j0Hzj+ddosLajv8UEr2z2TS1EvUG42l1u6vLji+VrSiSXufECgxM1rShC0j3PrTVKmbkBPo4WjfdOoEG/MciAopbmJZYqiRWo08HGaHre+3QDRy85Pr9e0TqNlXK0kIOkAH3efzhbBtsKZmMktTt+hdclbHY1jODNx1Z78vwKAplbsPegxXeM5GlGLBtC2tZ2wIzQnRTxi6SqpZcL5wXG9vMZ0S7cOlToWxPKlEA4tk6St1LRRCxiNcMK6tYnkf9iysp/cgavw2IMS2n3hvuJopy03vCpr+n2FlSbcL8wuybFeuMI8hvcVWgvBhyE5JAURN/Kgl95Y09eY1numvMGq/SCc9nwUXDX0T0cVYqi7hrRdTj2qaxNl3DkXKKxQoj9WX/VEgwM2AfkG6GW3ERypn1+zqxm6byXI4/NiXfNcgB8QqG92dGejTEM0MBv+fw+d2wsLvc6Xl1xz+i8b4TE6OLxSx+r0fG0gSG+D7kUCroBgFExA8vxiAVrPkKEcyyhw8SjFo9enKswmVm9RpEzI2DBrh7C4QeP2p5IX7s4NzEUFL6fh+4ruKLwFILHgESJOCV52M2RN3is1nzEmjHql1aqECpB2tgI20vJPVpNTsOmweIEc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(136003)(346002)(376002)(316002)(38100700002)(6512007)(64756008)(66946007)(66476007)(36756003)(76116006)(26005)(6506007)(66446008)(86362001)(38070700005)(66556008)(82960400001)(122000001)(186003)(83380400001)(4744005)(8936002)(966005)(7416002)(5660300002)(2616005)(8676002)(4326008)(54906003)(41300700001)(110136005)(2906002)(6486002)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGJuL2VVbW9uSklVRWV0dHZlQ3NrNzFxU0EyWGU2azdQMnVlU0ZZZkk5cGkv?=
 =?utf-8?B?WG9mSjIrVW5mSUxlUnpETk1WWXNRNGttQTY3dUxBZDZFWDFvWnp5cFRWZWgx?=
 =?utf-8?B?bWdmdXE2VXdBMHdPY2JsOUxlZy9tVzdCWmhYUmt5R2gzS002MEZQV3JmNjdX?=
 =?utf-8?B?NEJ6TjM2bXZyYmg3K0Y3MWUvbjhJZkJTS2JnWEVjT0Nid0RKYzZLaWVwVkd1?=
 =?utf-8?B?WlBOWml6a0h6N21CcnlqU1IrRlJiUHFucmxVc1BEWFI1bExjSnRRQXI3dmtl?=
 =?utf-8?B?MFlKNHh0bC9qMTJia2J5aE13NEpYd05TVFJPRWpieEZUbTFCUDh3eFhlVnZY?=
 =?utf-8?B?REhlTkE1RlJPNGc1VGxiTFJrRmhaOUlVS3JOY21QZFhRb01kYm9qQ0c0amw2?=
 =?utf-8?B?Snhyd3FESXdWTVh0SE41a1lWa3JGNjRuWUZndWFGY1hVR3hrRmUzMytJQS9p?=
 =?utf-8?B?a1luTSsrdzZCRlVSZS8zUjA4TFJYbk5oL2JNdkpVNFh2aW8yaXhXdU83NmxJ?=
 =?utf-8?B?bWJXMDhqM000M3RFSFBpRTBPWkc1c1BLQ3VrQ2RjV2NyL0M5cEx1Ujg0SUti?=
 =?utf-8?B?MVRTTDAwcGxoNzY1MUowdWUyME5vOHk3TFREWjYydlZjakhzcFFmT2REa3ov?=
 =?utf-8?B?blV4dTIwZ1VvQzVlYVFQZXl0VDUxdTZyczZ2Nksva1RnVmt3ZHNOVFRkSU5n?=
 =?utf-8?B?NXlRU0xCOGFTRnJaYWVlTklCeVBhRTA5dDNLazgrMzBGcU9BOTVkUk01ZGVS?=
 =?utf-8?B?N05nMjNVQWFrZVM2eHQrQ0E2c3oyayt6N1hwK0JibWdnZ05vS0JLWm1UKzhL?=
 =?utf-8?B?RVBXWGx4dWQ0cDZwVllRelAzbFYyREFjdWRxVG02TFFhbmFIUjA2OHFHYUpR?=
 =?utf-8?B?bFNwWlNSenlxejZlaEZaZUoxQ2kyZjIyamxpdGg2MVBkeGg4a0tPQnp1Qyt4?=
 =?utf-8?B?Ym1sS3Exc0h5K1lFRlJUOVJuZ2NxN0tpSldJeTE2OVo0WHExMWFNVjl2WnY5?=
 =?utf-8?B?ZGlWY0JyS0dxZUFwY0pWWHNuT0ttQy9EMnJFNlJ4VTFrTjZLZEJyMkVIczVS?=
 =?utf-8?B?d2NzTlUrb2t0VnBVWVl2TGV3VVM4TU1kOUE4QmFqaFlNdTFWUnZPTzhBNlVO?=
 =?utf-8?B?dlpzeGlGYWFoTG9QbVhQcmZXaENHVGJKS1NVTG5mMEJJa21GKzJwMHlmeVBD?=
 =?utf-8?B?V0lHTFBOR0NuRTZ4bisvWVpBZ0ZQZTY2OHhDaENkWnIzY2JReG55ejdGTnN6?=
 =?utf-8?B?aTZFZG9mN1pqMFdMcmRocnVXZVh1cldhOWdoM3Q2NkFjc1BZTEN0Q2ZRMm4r?=
 =?utf-8?B?WUhjbDV6MVVlOVFVeGhhWDZsOE1tTkVXV29mSzJlN0o1VXd1M1h0VE92Q2Fk?=
 =?utf-8?B?YTNCNXFKTUxQUTBRYkZ4dElROFgyOWl2a2t1c1JFNytmS1VsL3lEck1YemVT?=
 =?utf-8?B?emR3Z3FZSmh6YzI2YTdQeVZTemIxNFhkTEc0eUhOT0dGMDFEQUthTFpFenlx?=
 =?utf-8?B?UVo5VjJJOXBrQ3RXQ0padmc4aDIzWHdXYVo3b0l1SzRRRjZCNkFPMFdhNjNC?=
 =?utf-8?B?bDdrdlpweGxHVGNjZm5uZGl2K3JTcEdpdEV3bGpScjBJaS83bjl6d21xOTZv?=
 =?utf-8?B?cVUxa3doa1RTa2hhdGx1TzlDMy9rYVJpdUdWQkZtTk1PYmV3clZXMGdwZTFo?=
 =?utf-8?B?bXBKSENCT3FoNUJUcitzYjRRNUhpdlQzdVZUanFlTFgxYUFrZGQyYlhnRXVr?=
 =?utf-8?B?VmpzVjJlUWhkTUZqdmZsdWxXdU1rZGM5T25QSnBUU3VHdTBNeDdld25mRzRi?=
 =?utf-8?B?M0pFQnV3eG5NYU9rcnVWaEpNMFByN2dETmRaRmtFeGcrS2lsU0tkSHZVNGJ4?=
 =?utf-8?B?cEFFbUF5RDlCUGIwYUlTai9RUUxKdEhnRldmV3lFa1d6RGIzc0NuSDBxbWFm?=
 =?utf-8?B?Slh4Yk80YXZYRFJydUxvakZIZ1pHTFdSTUlxVEdxR0tDcGZ0N2pWOGdqU1hQ?=
 =?utf-8?B?NzFTbkFwdS92a2xteHNMMm5HVFNRcUdHMnpyUTFjZVBua1FtTk54U0RaN3gv?=
 =?utf-8?B?MU1RMlJuQ2E4bGR0WW96MHhhMFNvVFR4ZUtIc0lucDZNZUpEYldzb0J5NHk5?=
 =?utf-8?B?U09GZk9kRnpWVTZvVUJDQ1laaXAvUmc5MlJVMFVHdXYxeTBoK1NzeWw2alVm?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A19E55C61F9E8149A2FB6FD3AF51DA9D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abddfed6-ec6a-46a7-8820-08da8ad8edb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 22:42:33.1282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: co/7KVx8r7+JvyfiipevqH/52kuubiPA4TkNf2K3DD1e92BWOaTMUO3Zy6/q6oeh4ohuEJaYFIYNld5QV1XOfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3671
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTMwIGF0IDIxOjQwICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEF1ZyAyMywgMjAyMiwgTWlhb2hlIExpbiB3cm90ZToNCj4gPiBXaGVu
IHJlZ2lzdGVyX3Nocmlua2VyKCkgZmFpbHMsIHdlIGZvcmdvdCB0byByZWxlYXNlIHRoZSBwZXJj
cHUgY291bnRlcg0KDQo+ID4ga3ZtX3RvdGFsX3VzZWRfbW11X3BhZ2VzIGxlYWRpbmcgdG8gbWVt
b3J5bGVhay4gRml4IHRoaXMgaXNzdWUgYnkgY2FsbGluZw0KPiA+IHBlcmNwdV9jb3VudGVyX2Rl
c3Ryb3koKSB3aGVuIHJlZ2lzdGVyX3Nocmlua2VyKCkgZmFpbHMuDQo+ID4gDQo+ID4gRml4ZXM6
IGFiMjcxYmQ0ZGZkNSAoIng4Njoga3ZtOiBwcm9wYWdhdGUgcmVnaXN0ZXJfc2hyaW5rZXIgcmV0
dXJuIGNvZGUiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IE1pYW9oZSBMaW4gPGxpbm1pYW9oZUBodWF3
ZWkuY29tPg0KPiA+IC0tLQ0KPiANCj4gUHVzaGVkIHRvIGJyYW5jaCBgZm9yX3Bhb2xvLzYuMWAg
YXQ6DQo+IA0KPiAgICAgaHR0cHM6Ly9naXRodWIuY29tL3NlYW4tamMvbGludXguZ2l0DQo+IA0K
PiBVbmxlc3MgeW91IGhlYXIgb3RoZXJ3aXNlLCBpdCB3aWxsIG1ha2UgaXRzIHdheSB0byBrdm0v
cXVldWUgInNvb24iLg0KPiANCj4gTm90ZSwgdGhlIGNvbW1pdCBJRHMgYXJlIG5vdCBndWFyYW50
ZWVkIHRvIGJlIHN0YWJsZS4NCg0KU29ycnkgZm9yIGxhdGUgcmVwbHkuDQoNClRoZSBjb21taXQg
bWVzc2FnZSBoYXMgIndlIi4gIFNob3VsZCB3ZSBnZXQgcmlkIG9mIGl0Pw0KDQotLSANClRoYW5r
cywNCi1LYWkNCg0KDQo=
