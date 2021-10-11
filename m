Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82054428842
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 10:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhJKIEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 04:04:50 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25507 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbhJKIEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 04:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633939360; x=1665475360;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SWSt4Zajf5vVkLLhpFaCVvuuv4r8MHC+p8V5X539Sbo=;
  b=qdc8V+Ge6OX1Nb95zvayzF9twHoJadI+rcCxyJB+hCaYfCe1AdLnkA+N
   I4VUJwg8ulXH+lrQqD9k1/lQTnNvoNlNnqKiopenxL/7+EyljO2IbCFh4
   42fR3rj0jhNUvbelZ98lAuYpF6/SNMd1oxurUEnvzrHNnTJKRjsETjq8s
   kSRlLYJrvhT0FnXY2GaDHG9Y68bUwi+p0Da4KFbWYhnn217sGJrF6PxPB
   m5dsvHQi9HFzpx/erYTESrlk+RZh/kU9w9I9ZAhZgTS+sPZY45+gx3hhu
   ROlLjJmwnWVSgYojlSqzbybvbYKhQjGEY0TOcoxbQmly7gljztumm178a
   A==;
X-IronPort-AV: E=Sophos;i="5.85,364,1624291200"; 
   d="scan'208";a="294189953"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 11 Oct 2021 16:02:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICXGWxpim7L06DuO2fbV44HJaaYI35Igwes3ru7H4r2nhzrnbM7aHPpUlN/pmZ8Riapy9XQlg9GdCSvGagAP77X4mJZncW6xUGTy80JISTzIJ2pGEO+zSLDsB8f30HIKiJRFtsUB8OYl0mbirD26zRCkc8YLO0fNT7A0iA0PWA2MRj1VvehSIlf9c4HKd0gHYby2N8Sq5fEWNgrgk4sdW6teXOCPCgHwcOzjBctzO9XdmQXQ6SL7pgtfamF2hyhXkIPAbn4+1Hi6/jLKW9RAZKSUhHugpFUx7w31YWWS1S1A0ucms5q+JTNybpvvSykHOpngAY7CMpGCUpG88fD92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWSt4Zajf5vVkLLhpFaCVvuuv4r8MHC+p8V5X539Sbo=;
 b=SBzGHUdo7bSIYgO+i313c0zeNPsd5TYaWh3J8MIK+q/lXsb4HNiRx7+d+UG3pZM+a5Zus2dR/YYFVvKywd0E5NHIarGEvnTonSWxUc5L+vq8/k28xZeSoeynQ16ntlro0K5m3hnZ2Ydd3ST9cux2rMLsX8jHyN87A+IsNeTPl8qGcL/TVcpktJmRd5Vatfd+IoD2Q53VDg5ptNM1BANwne3aKui9zQOsZ7awE6mEI+iZ3sM5s5UfXyxaoE2SJS79e6oo9eiFwxqU5DyLZz+muwJzDGoMQmC3efzVALeSmJqMm+V3rD+ZKmxT02xhE+Rwmxw6rZarqcb+ty/hM7tZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWSt4Zajf5vVkLLhpFaCVvuuv4r8MHC+p8V5X539Sbo=;
 b=Xmb7EOJLdVagcoHDk7DSAoitxKZql3kbRrfkvocdoS+dN9J361wFk6+G0rQJng3XP9bIDskQym4Xw+bcXp5w/PaWtTOTx8exCzra3mFR6JozsBUAGQI+HvvvhaMRm1djiQdWqDBeL3JF6vyDLkPqgG8kGo5S6SPSXVeeQGciTjc=
Received: from BY5PR04MB6724.namprd04.prod.outlook.com (2603:10b6:a03:219::15)
 by BYAPR04MB5912.namprd04.prod.outlook.com (2603:10b6:a03:108::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Mon, 11 Oct
 2021 08:02:35 +0000
Received: from BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::30:9ac4:b644:a0e4]) by BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::30:9ac4:b644:a0e4%9]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 08:02:35 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "seanjc@google.com" <seanjc@google.com>
CC:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        "vincent.chen@sifive.com" <vincent.chen@sifive.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "wangkefeng.wang@huawei.com" <wangkefeng.wang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] RISC-V: Add SBI HSM extension in KVM
Thread-Topic: [PATCH v3 5/5] RISC-V: Add SBI HSM extension in KVM
Thread-Index: AQHXu/N6afAc5oSwwU24PAOY+ZlwW6vJMwEAgARBy4A=
Date:   Mon, 11 Oct 2021 08:02:35 +0000
Message-ID: <0383b5cacb25e9dc293d891284df9f4cbc06ee3a.camel@wdc.com>
References: <20211008032036.2201971-1-atish.patra@wdc.com>
         <20211008032036.2201971-6-atish.patra@wdc.com>
         <YWBdbCNQdikbhhBq@google.com>
In-Reply-To: <YWBdbCNQdikbhhBq@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.1 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8efd18bd-af07-432f-87a3-08d98c8d7c85
x-ms-traffictypediagnostic: BYAPR04MB5912:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB591299AA270DA3FBCC10B3F8FAB59@BYAPR04MB5912.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: htUiMpGQ+9NyYh1VZcCDUCUzP4yrVhuFN+7e/IR9axwwAI0NYqVTab7n6DfiUhNijB9KW6ezIa3E6EiGfiprnxAEkFAbDwy09T+mczyfzOJ2SMbzHZIGO8k5zrFZeUPMkmBHIvUvF0k8R4k9D9BYs4MHy+59H/XB5XcS+s0Y6HTxhnDFyYbFdFMBT1SSuxcj5s6IH0CxktKRajpt7Bs48yGDjGFwWvw2utvmapUg6Vb4wDL/cE7tucXH6ZBgDeDSn1bR4w6kNZmptX7g0JJLYTP+gcN+ljX8s0zM5ixjrdW0rC1wYSRCYArssccWuJqWnVhkb67Bf70HHci61UWDwGQiOJbo2WRdD7ViF1Yw20mwLdK6Th9po5hSKYss1eeXTtHscX9ogruafjgTbHliuLG5Kpl2IV1ZknaiNOuXEji+FcJSRljR0nsSYdhuLoS8u3b9l6HplXJO4J6b+YZSvQue25jkfXtXKYos64+Qokg8dI+jkHOVscXiPbF+3HCIICe0jZf1cnBFSqQCrkmiIU7ldiv1oYHMAUgNgP3unYPrP6Iu0ipG+lTijGr5jdH6V03QK0N8pzfCqJSY/LLHgjn0ykVRN7cxYyxZE6kBD3KFFdTCEvukSm+fBNIS4Egj0VE9re652ENcKCGoiXOxGdZHj8cUxeInE13stnVEL4EWdRvQkTfR4Dk50755QVs4lxXWhMS63G4e8GuB2kICPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6724.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(2616005)(38100700002)(316002)(6506007)(36756003)(186003)(64756008)(66556008)(66446008)(66476007)(66946007)(76116006)(8676002)(7416002)(54906003)(5660300002)(8936002)(38070700005)(26005)(6916009)(508600001)(4326008)(71200400001)(2906002)(6512007)(86362001)(83380400001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjRUSm1WSkp3Umg4V0hOSUxxbGZqN09nS1BQWkUxelBqQStaOU1QVm9BUnJk?=
 =?utf-8?B?Nm9iVXduNjR1RzhzYU5MNVZRTkpRSy9iNGxGYlNpSlp0N25sWE03NXZWQUN2?=
 =?utf-8?B?b05jSGxORlkyeDk0OWFxQ1NweGwzMEd5cDZpVEVaYVlsTFRnS0VlNTRMNUQ1?=
 =?utf-8?B?aitKemFPU1YyeFg5NURkbmNIa1RjelhsR0FYdUh3bEVSaTVabzRoYjBQTlRm?=
 =?utf-8?B?bkpPd2lJeXl3RHkrODZhRmEweEtYWERTaTJkK1o4N3p2M0N6RlJRV2QvSzk0?=
 =?utf-8?B?RHJMeGltVWpQUktrQ25jc0YwblBPbElSTW1vRWtYTWZUUTc4anV0YW5VaHF1?=
 =?utf-8?B?bzBnRjJoajhNaDl0VXhaS0dRUC9ZbGVvYm9TZFlOVmN4d1hsME1KWEVxa1hw?=
 =?utf-8?B?cXpVbW8zUzVtcEROTWp4SFoxSFJGYjZ5TjY5M1FPVjdlZVJGOGlxczRVWS8v?=
 =?utf-8?B?RHpZRkVLdy9nU3FjaytkZkRtTkUwOTZNT3E3L1VuU2ttZFVJenhzdE04bVJB?=
 =?utf-8?B?cm9nbTFiQjZudUdncGZsZllVa295RVBpbVI1cm5nMnZ4Yk1MTXNHSXJSWWpX?=
 =?utf-8?B?OHVSTzkzOUZIdkJhM0lnT0I1Q3pQZm9tdkJuRnFJTmNjWGZqNGZYZUNQcktq?=
 =?utf-8?B?WXk4dHQ1c2I5ZVVJZlBhMDZBempUaDdwUmFXTnpUeGxrNFVRaFJWamx2MnRl?=
 =?utf-8?B?MXc2QlpYaTdyUk9odXRnOVI1dHA1VHdIQVZzY013VnZxOHVSdWk5ajQ5ek56?=
 =?utf-8?B?bGx2OTJQZm8xdlBnK2pVOUFHaXBLY0pqdk11ZnR3bS80ajV6TkRFYkM0eWtX?=
 =?utf-8?B?NEVPY3hkRDRibkhSOGFWYStJOC85MS84dlYyQkRhNzFQbS9TZmRxMC9hMVVV?=
 =?utf-8?B?a01RNkJLRURSL0dhdUh2QTFobWVSZ0dVMzNuUkM3VUxGWU1ibjJ5dFVDZjRn?=
 =?utf-8?B?ZGJUQjZpVEw5VFNJclBhV1NGWjI0czROSGoyUGVhN3J1SmY3aXNmK3RiaGNw?=
 =?utf-8?B?NVhWZnJ0eldqK0tSZkZMNkdtZkRocUNjZDJBUDRiSldVT0Z3aEE5a21xOG1B?=
 =?utf-8?B?amo2SnQ0S3R4UkpJbVNoaFBpblh4eElFYW1kdWZsUVVEMFpZTXppZGRHN243?=
 =?utf-8?B?U05jUENubkdKaDBxNzM2RkxsUm5FbDRUU3Y3RVpXTmN6TXdXci80WGFPMjVt?=
 =?utf-8?B?OHFSQndOaXpsS1lmT3NJS3RCMnNmMW11TStlNEhrek9zZDlrOHRsQWlVd3Js?=
 =?utf-8?B?Z0dObFhvN0ZsTlR6VGpSSTlkR3JYVkNMcEkwY0FIQjhJNnRwZ0hIWlV6NWh6?=
 =?utf-8?B?bmdOZVBvd1NscVBYNFBWUzNVdW0vN1k2b1BDZVIyOGRTYlNNZW4xcXRSMzkw?=
 =?utf-8?B?SHJZMUdzWmNHTFNUWWx1OEZaUHBKcTQxR09JaXl4TFN2SnZQcDhGU3RDMlF3?=
 =?utf-8?B?cHJQanhSOGVwM1pFclJwS2ZhMFVGeCtwWWcrYlZtcGk4TmhlQW9qUVBIL1Bn?=
 =?utf-8?B?Q2Jia0pDN3A2b3B2S1QxV1RuZFJvQ0NWMnZvWkUvZUhRMVFxeTIvbHVnUG5o?=
 =?utf-8?B?SzhMK09ZZkNNMThqMkRiUTZkVzNXbW0zTVVYd3JRaXRHaElNUGdKTVpEYytM?=
 =?utf-8?B?bi9ENitMbjNzWEdwbUs3QzBLSFVERFE3a1p3cjl1MmJ3aFBUYzRTU1h2dE96?=
 =?utf-8?B?enBNd2dmK0lLbkZydWZBTS9nY01qb0hpZ3kydmhqaDE0U29DWFdSWUVEVFp2?=
 =?utf-8?Q?5R5givv5bdMCyNYkK9fj/hoO4edhmSkXQI8N6rI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <233E6EFC1E0AD14BBD7FAAF4D1B0F5B3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6724.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8efd18bd-af07-432f-87a3-08d98c8d7c85
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 08:02:35.5655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Cy4jTlTOKWUMMDeuAgS+DePvW2JVuYi65oYvcuKO3id+lPGwMYZodIQlHE6DXnxKKz1yAkEjvFQ4fbmSGYRXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5912
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIxLTEwLTA4IGF0IDE1OjAyICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE9jdCAwNywgMjAyMSwgQXRpc2ggUGF0cmEgd3JvdGU6DQo+ID4gU0JJ
IEhTTSBleHRlbnNpb24gYWxsb3dzIE9TIHRvIHN0YXJ0L3N0b3AgaGFydHMgYW55IHRpbWUuIEl0
IGFsc28NCj4gPiBhbGxvd3MNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9yaXNjdi9rdm0vdmNwdS5j
IGIvYXJjaC9yaXNjdi9rdm0vdmNwdS5jDQo+ID4gaW5kZXggYzQ0Y2FiY2U3ZGQ4Li4yNzhiNGQ2
NDNlMWIgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9yaXNjdi9rdm0vdmNwdS5jDQo+ID4gKysrIGIv
YXJjaC9yaXNjdi9rdm0vdmNwdS5jDQo+ID4gQEAgLTEzMyw2ICsxMzMsMTMgQEAgc3RhdGljIHZv
aWQga3ZtX3Jpc2N2X3Jlc2V0X3ZjcHUoc3RydWN0DQo+ID4ga3ZtX3ZjcHUgKnZjcHUpDQo+ID4g
wqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBrdm1fdmNwdV9jc3IgKnJlc2V0X2NzciA9ICZ2Y3B1LQ0K
PiA+ID5hcmNoLmd1ZXN0X3Jlc2V0X2NzcjsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGt2
bV9jcHVfY29udGV4dCAqY250eCA9ICZ2Y3B1LT5hcmNoLmd1ZXN0X2NvbnRleHQ7DQo+ID4gwqDC
oMKgwqDCoMKgwqDCoHN0cnVjdCBrdm1fY3B1X2NvbnRleHQgKnJlc2V0X2NudHggPSAmdmNwdS0N
Cj4gPiA+YXJjaC5ndWVzdF9yZXNldF9jb250ZXh0Ow0KPiA+ICvCoMKgwqDCoMKgwqDCoGJvb2wg
bG9hZGVkOw0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqAvKiBEaXNhYmxlIHByZWVtcHRpb24g
dG8gYXZvaWQgcmFjZSB3aXRoIHByZWVtcHQgbm90aWZpZXJzDQo+ID4gKi8NCj4gDQo+IFN0YXRp
bmcgd2hhdCB0aGUgY29kZSBsaXRlcmFsbHkgZG9lcyBpcyBub3QgYSBoZWxwZnVsIGNvbW1lbnQs
IGFzIGl0DQo+IGRvZXNuJ3QNCj4gaGVscCB0aGUgcmVhZGVyIHVuZGVyc3RhbmQgX3doeV8gcHJl
ZW1wdGlvbiBuZWVkcyB0byBiZSBkaXNhYmxlZC4NCg0KDQpUaGUgcHJlZW1wdGlvbiBpcyBkaXNh
YmxlZCBoZXJlIGJlY2F1c2UgaXQgcmFjZXMgd2l0aA0Ka3ZtX3NjaGVkX291dC9rdm1fc2NoZWRf
aW4oY2FsbGVkIGZyb20gcHJlZW1wdCBub3RpZmllcnMpIHdoaWNoIGFsc28NCmNhbGxzIHZjcHVf
bG9hZC9wdXQuDQoNCkkgd2lsbCBhZGQgc29tZSBtb3JlIGV4cGxhbmF0aW9uIGluIHRoZSBjb21t
ZW50IHRvIG1ha2UgaXQgbW9yZQ0KZXhwbGljaXQuDQoNCj4gDQo+ID4gK8KgwqDCoMKgwqDCoMKg
cHJlZW1wdF9kaXNhYmxlKCk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgbG9hZGVkID0gKHZjcHUtPmNw
dSAhPSAtMSk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKGxvYWRlZCkNCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKga3ZtX2FyY2hfdmNwdV9wdXQodmNwdSk7DQo+IA0KPiBPb2Yu
wqAgTG9va3MgbGlrZSB0aGlzIHBhdHRlcm4gd2FzIHRha2VuIGZyb20gYXJtNjQuwqANCg0KWWVz
LiBUaGlzIHBhcnQgaXMgc2ltaWxhciB0byBhcm02NCBiZWNhdXNlIHRoZSBzYW1lIHJhY2UgY29u
ZGl0aW9uIGNhbg0KaGFwcGVuIGluIHJpc2N2IGR1ZSB0byBzYXZlL3Jlc3RvcmUgb2YgQ1NScyBk
dXJpbmcgcmVzZXQuDQoNCg0KPiAgSXMgdGhlcmUgcmVhbGx5IG5vIGJldHRlcg0KPiBhcHByb2Fj
aCB0byBoYW5kbGluZyB0aGlzP8KgIEkgZG9uJ3Qgc2VlIGFueXRoaW5nIGluDQo+IGt2bV9yaXNj
dl9yZXNldF92Y3B1KCkgdGhhdA0KPiB3aWxsIG9idmlvdXNseSBicmVhayBpZiB0aGUgdkNQVSBp
cyBsb2FkZWQuwqAgSWYgdGhlIGdvYWwgaXMgcHVyZWx5IHRvDQo+IGVmZmVjdCBhDQo+IENTUiBy
ZXNldCB2aWEga3ZtX2FyY2hfdmNwdV9sb2FkKCksIHRoZW4gd2h5IG5vdCBqdXN0IGZhY3RvciBv
dXQgYQ0KPiBoZWxwZXIgdG8gZG8NCj4gZXhhY3RseSB0aGF0Pw0KPiANCj4gPiDCoA0KPiA+IMKg
wqDCoMKgwqDCoMKgwqBtZW1jcHkoY3NyLCByZXNldF9jc3IsIHNpemVvZigqY3NyKSk7DQo+ID4g
wqANCj4gPiBAQCAtMTQ0LDYgKzE1MSwxMSBAQCBzdGF0aWMgdm9pZCBrdm1fcmlzY3ZfcmVzZXRf
dmNwdShzdHJ1Y3QNCj4gPiBrdm1fdmNwdSAqdmNwdSkNCj4gPiDCoA0KPiA+IMKgwqDCoMKgwqDC
oMKgwqBXUklURV9PTkNFKHZjcHUtPmFyY2guaXJxc19wZW5kaW5nLCAwKTsNCj4gPiDCoMKgwqDC
oMKgwqDCoMKgV1JJVEVfT05DRSh2Y3B1LT5hcmNoLmlycXNfcGVuZGluZ19tYXNrLCAwKTsNCj4g
PiArDQo+ID4gK8KgwqDCoMKgwqDCoMKgLyogUmVzZXQgdGhlIGd1ZXN0IENTUnMgZm9yIGhvdHBs
dWcgdXNlY2FzZSAqLw0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChsb2FkZWQpDQo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2bV9hcmNoX3ZjcHVfbG9hZCh2Y3B1LCBzbXBfcHJv
Y2Vzc29yX2lkKCkpOw0KPiANCj4gSWYgdGhlIHByZWVtcHQgc2hlbmFuaWdhbnMgcmVhbGx5IGhh
dmUgdG8gc3RheSwgYXQgbGVhc3QgdXNlDQo+IGdldF9jcHUoKS9wdXRfY3B1KCkuDQo+IA0KDQpJ
cyB0aGVyZSBhbnkgc3BlY2lmaWMgYWR2YW50YWdlIHRvIHRoYXQgPyBnZXRfY3B1L3B1dF9jcHUg
YXJlIGp1c3QNCm1hY3JvcyB3aGljaCBjYWxscyBwcmVlbXB0X2Rpc2FibGUvcHJlZW1wdF9lbmFi
bGUuDQoNClRoZSBvbmx5IGFkdmFudGFnZSBvZiBnZXRfY3B1IGlzIHRoYXQgaXQgcmV0dXJucyB0
aGUgY3VycmVudCBjcHUuIA0KdmNwdV9sb2FkIGZ1bmN0aW9uIHVzZXMgZ2V0X2NwdSBiZWNhdXNl
IGl0IHJlcXVpcmVzIHRoZSBjdXJyZW50IGNwdSBpZC4NCg0KSG93ZXZlciwgd2UgZG9uJ3QgbmVl
ZCB0aGF0IGluIHRoaXMgY2FzZS4gSSBhbSBub3QgYWdhaW5zdCBjaGFuZ2luZyBpdA0KdG8gZ2V0
X2NwdS9wdXRfY3B1LiBKdXN0IHdhbnRlZCB0byB1bmRlcnN0YW5kIHRoZSByZWFzb25pbmcgYmVo
aW5kIHlvdXINCnN1Z2dlc3Rpb24uDQoNCg0KPiA+ICvCoMKgwqDCoMKgwqDCoHByZWVtcHRfZW5h
YmxlKCk7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiDCoGludCBrdm1fYXJjaF92Y3B1X3ByZWNyZWF0
ZShzdHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGludCBpZCkNCj4gPiBAQCAtMTgwLDYgKzE5Miwx
MyBAQCBpbnQga3ZtX2FyY2hfdmNwdV9jcmVhdGUoc3RydWN0IGt2bV92Y3B1DQo+ID4gKnZjcHUp
DQo+ID4gwqANCj4gPiDCoHZvaWQga3ZtX2FyY2hfdmNwdV9wb3N0Y3JlYXRlKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCj4gPiDCoHsNCj4gPiArwqDCoMKgwqDCoMKgwqAvKioNCj4gPiArwqDCoMKg
wqDCoMKgwqAgKiB2Y3B1IHdpdGggaWQgMCBpcyB0aGUgZGVzaWduYXRlZCBib290IGNwdS4NCj4g
PiArwqDCoMKgwqDCoMKgwqAgKiBLZWVwIGFsbCB2Y3B1cyB3aXRoIG5vbi16ZXJvIGNwdSBpZCBp
biBwb3dlci1vZmYgc3RhdGUNCj4gPiBzbyB0aGF0IHRoZXkNCj4gPiArwqDCoMKgwqDCoMKgwqAg
KiBjYW4gYnJvdWdodCB0byBvbmxpbmUgdXNpbmcgU0JJIEhTTSBleHRlbnNpb24uDQo+ID4gK8Kg
wqDCoMKgwqDCoMKgICovDQo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHZjcHUtPnZjcHVfaWR4ICE9
IDApDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2bV9yaXNjdl92Y3B1X3Bv
d2VyX29mZih2Y3B1KTsNCj4gDQo+IFdoeSBkbyB0aGlzIGluIHBvc3RjcmVhdGU/DQo+IA0KDQpC
ZWNhdXNlIHdlIG5lZWQgdG8gYWJzb2x1dGVseSBzdXJlIHRoYXQgdGhlIHZjcHUgaXMgY3JlYXRl
ZC4gSXQgaXMNCmNsZWFuZXIgaW4gdGhpcyB3YXkgcmF0aGVyIHRoYW4gZG9pbmcgdGhpcyBoZXJl
IGF0IHRoZSBlbmQgb2YNCmt2bV9hcmNoX3ZjcHVfY3JlYXRlLiBjcmVhdGVfdmNwdSBjYW4gYWxz
byBmYWlsIGFmdGVyDQprdm1fYXJjaF92Y3B1X2NyZWF0ZSByZXR1cm5zLg0KDQoNCj4gPiDCoH0N
Cj4gPiDCoA0KPiA+IMKgdm9pZCBrdm1fYXJjaF92Y3B1X2Rlc3Ryb3koc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQ0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2t2bS92Y3B1X3NiaS5jIGIvYXJj
aC9yaXNjdi9rdm0vdmNwdV9zYmkuYw0KPiA+IGluZGV4IGRhZGVlNWU2MWE0Ni4uZGI1NGVmMjEx
NjhiIDEwMDY0NA0KPiANCj4gLi4uDQo+IA0KPiA+ICtzdGF0aWMgaW50IGt2bV9zYmlfaHNtX3Zj
cHVfc3RhcnQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDC
oMKgc3RydWN0IGt2bV9jcHVfY29udGV4dCAqcmVzZXRfY250eDsNCj4gPiArwqDCoMKgwqDCoMKg
wqBzdHJ1Y3Qga3ZtX2NwdV9jb250ZXh0ICpjcCA9ICZ2Y3B1LT5hcmNoLmd1ZXN0X2NvbnRleHQ7
DQo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGt2bV92Y3B1ICp0YXJnZXRfdmNwdTsNCj4gPiAr
wqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nIHRhcmdldF92Y3B1aWQgPSBjcC0+YTA7DQo+ID4g
Kw0KPiA+ICvCoMKgwqDCoMKgwqDCoHRhcmdldF92Y3B1ID0ga3ZtX2dldF92Y3B1X2J5X2lkKHZj
cHUtPmt2bSwgdGFyZ2V0X3ZjcHVpZCk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKCF0YXJnZXRf
dmNwdSkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU5WQUw7
DQo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKCF0YXJnZXRfdmNwdS0+YXJjaC5wb3dlcl9vZmYpDQo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUFMUkVBRFk7DQo+ID4g
Kw0KPiA+ICvCoMKgwqDCoMKgwqDCoHJlc2V0X2NudHggPSAmdGFyZ2V0X3ZjcHUtPmFyY2guZ3Vl
c3RfcmVzZXRfY29udGV4dDsNCj4gPiArwqDCoMKgwqDCoMKgwqAvKiBzdGFydCBhZGRyZXNzICov
DQo+ID4gK8KgwqDCoMKgwqDCoMKgcmVzZXRfY250eC0+c2VwYyA9IGNwLT5hMTsNCj4gPiArwqDC
oMKgwqDCoMKgwqAvKiB0YXJnZXQgdmNwdSBpZCB0byBzdGFydCAqLw0KPiA+ICvCoMKgwqDCoMKg
wqDCoHJlc2V0X2NudHgtPmEwID0gdGFyZ2V0X3ZjcHVpZDsNCj4gPiArwqDCoMKgwqDCoMKgwqAv
KiBwcml2YXRlIGRhdGEgcGFzc2VkIGZyb20ga2VybmVsICovDQo+ID4gK8KgwqDCoMKgwqDCoMKg
cmVzZXRfY250eC0+YTEgPSBjcC0+YTI7DQo+ID4gK8KgwqDCoMKgwqDCoMKga3ZtX21ha2VfcmVx
dWVzdChLVk1fUkVRX1ZDUFVfUkVTRVQsIHRhcmdldF92Y3B1KTsNCj4gPiArDQo+ID4gK8KgwqDC
oMKgwqDCoMKgLyogTWFrZSBzdXJlIHRoYXQgdGhlIHJlc2V0IHJlcXVlc3QgaXMgZW5xdWV1ZWQg
YmVmb3JlDQo+ID4gcG93ZXIgb24gKi8NCj4gPiArwqDCoMKgwqDCoMKgwqBzbXBfd21iKCk7DQo+
IA0KPiBXaGF0IGRvZXMgdGhpcyBwYWlyIHdpdGg/wqAgSSBzdXNwZWN0IG5vdGhpbmcsIGJlY2F1
c2UgQUZBSUNUIHRoZSBjb2RlDQo+IHdhcyB0YWtlbg0KPiBmcm9tIGFybTY0Lg0KPiANCg0KVGhh
bmtzIGZvciBub3RpY2luZyB0aGlzLiBJdCB3YXMgYSBzbGlwIHVwLiBJIHdpbGwgZml4IGl0IGlu
IG5leHQNCnJldmlzaW9uLg0KDQoNCj4gYXJtNjQgaGFzIHRoZSBzbXBfd21iKCkgaW4ga3ZtX3Bz
Y2lfdmNwdV9vbigpIHRvIGVuc3VyZSB0aGF0IHRoZSB2Q1BVDQo+IHNlZXMgdGhlDQo+IHJlcXVl
c3QgaWYgdGhlIHZDUFUgc2VlcyB0aGUgY2hhbmdlIGluIHZjcHUtPmFyY2gucG93ZXJfb2ZmLCBh
bmQgc28NCj4gaGFzIGENCj4gc21wX3JtYigpIGluIGt2bV9yZXNldF92Y3B1KCkuDQo+IA0KPiBT
aWRlIHRvcGljLCBob3cgbXVjaCBvZiBhcm02NCBhbmQgUklTQy1WIGlzIHRoaXMgc2ltaWxhcj/C
oCBXb3VsZCBpdA0KPiBtYWtlIHNlbnNlDQo+IHRvIGZpbmQgc29tZSB3YXkgZm9yIHRoZW0gdG8g
c2hhcmUgY29kZT8NCg0KV2hpbGUgc29tZSBvZiB0aGUgb3BlcmF0aW9uYWwgbWV0aG9kb2xvZ2ll
cyBpbXBsZW1lbnRlZCBpbiB0aGlzIHBhdGNoDQphcmUgc2ltaWxhciB3aXRoIEFSTTY0IChpLmUu
IFNCSSBIU00gdnMgUFNDSSBmb3IgY3B1IGhvdHBsdWcvYm9vdGluZyksDQp0aGUgaW1wbGVtZW50
YXRpb24gaXMgZGlmZmVyZW50IGluIHRlcm1zIG9mIENTUiBzYXZlL3Jlc3RvcmUgJiBwZW5kaW5n
DQppcnEgaGFuZGxpbmcuIFdlIG1heSBlbmQgdXAgaW4gbW9yZSBjb2RlIHRvIGFzIG5ldyBhcmNo
IGhvb2t1cHMgbWF5DQpoYXZlIHRvIGJlIGFkZGVkLg0KDQpUaGlzIG9wdGlvbiBjZXJ0YWlubHkg
Y2FuIGJlIGV4cGxvcmVkIGluIGZ1dHVyZS4gQnV0IGl0IGlzIG5vdCBvdXIgVE9ETw0KbGlzdCBy
aWdodCBub3cuDQoNCg0KPiANCj4gPiArwqDCoMKgwqDCoMKgwqBrdm1fcmlzY3ZfdmNwdV9wb3dl
cl9vbih0YXJnZXRfdmNwdSk7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoHJldHVybiAwOw0K
PiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IGt2bV9zYmlfaHNtX3ZjcHVfc3RvcChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gK3sNCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoKCF2Y3B1
KSB8fCAodmNwdS0+YXJjaC5wb3dlcl9vZmYpKQ0KPiANCj4gVG9vIG1hbnkgcGFyZW50aGVzZXMs
IGFuZCB0aGUgTlVMTCB2Q1BVIGNoZWNrIGlzIHVubmVjZXNzYXJ5Lg0KDQpvay4gV2lsbCBmaXgg
aXQuDQoNCg0KPiANCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1F
SU5WQUw7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoGt2bV9yaXNjdl92Y3B1X3Bvd2VyX29m
Zih2Y3B1KTsNCj4gPiArDQo+ID4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIDA7DQo+ID4gK30NCj4g
PiArDQoNCi0tIA0KUmVnYXJkcywNCkF0aXNoDQo=
