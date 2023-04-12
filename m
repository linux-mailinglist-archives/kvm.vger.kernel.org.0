Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8263A6DF4D3
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 14:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjDLMP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 08:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjDLMPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 08:15:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C65E3581;
        Wed, 12 Apr 2023 05:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681301743; x=1712837743;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/GGPMYbOWxht6XDQoL0kDIrthmueIpDXLWvI9aTKf+o=;
  b=Eov9ywJqbhscrpUqJB9kDAflLagOVVFqMj0VadglxElP2L6wXnY2Ork0
   6kjBojronSAX3YH7LUargG5jTZTEer4GAtnDPjxQqcrEYo+wgVdQfAXYS
   uXboqluLI2rvG+WuKgSYHN6wHbVxyyM0OpTKOm30gfzFbK/p0VwsK2rnD
   5ulLHvq1Qw3tum5pUcFFIcrNQMlqHg/YoWsJ6ooo48JIjYPWKVzgMrgpV
   de5+lXDaxje8riq4eKPlBtAq5sYUunVpNeIpjfUgmmFAtgfqAMtYWWyJL
   yIqHv39XknUQSmQAtnY4VdD7d4Q3xZsDiYEKruC6cGjsAJ9xAI7yuKNhV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="430161370"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430161370"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 05:15:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="758213209"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="758213209"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 12 Apr 2023 05:15:42 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 05:15:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 05:15:42 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 05:15:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXbee2dljGxp791eaZeIc1ceMyAO2Us6TqUcmBFsPFPIGJk8Q1MNDu5JLkGu2RSCwJqhVWzH5rleikZyqaTePRquXftK8gg1C1gqVImYc8tH/bHi6SVaSGjJJjjYM0Idx56t8Z/6/0Dru103K5QuUtEkMXjk0Byr/R/922rONRmjwW+Bc+2CnzNGS1PgzOG7Q30thjAhjRO6ewR9eAfM2DPAoLNE/J8+YzgzgA19JlXP1JBiXS3rRIt5h5JPRakMDFseDoilQIv6KL769LvgYD58gYpAKOpN5WQ6K0oip6V9qWqFma2S/+1WxkT2BsoCnw3kQ9TY68hOfy3RihygKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GGPMYbOWxht6XDQoL0kDIrthmueIpDXLWvI9aTKf+o=;
 b=LZoNNeY+QuBeYJoNUQF7kOiAzwU7Hhmqgd8uOoPbuEHhS1KwRuZvB1sodFNqRf3kgl7WoXgXgGudLFCaFIAM3WED6bqpUJy/Sq7Wilen+vuw0BwMIhmv/8Qg2q258sb08jGF8Ykhf6Kr2NGog1kxWVTAKmpuzkwOTIWQiSFjohyyta5HsEdnDU5AjR8oTdBH1gi1bZXKfeubUTXoAhxmRNkjWHMNovaSGtYI+HPgCMM1vmlFtc1k0QUBnfgp5yzX+dxTvlkKOaZrnUL7hLTpWkEkT9whoLOV695HtjktL2WiyGLuw/eAXuXKVcrbOLnywEpJIBStBVHtzu2of9vZrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4929.namprd11.prod.outlook.com (2603:10b6:303:6d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Wed, 12 Apr
 2023 12:15:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 12:15:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Topic: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Index: AQHZZ1neAPY41R6lzkG8Mkf04T1Dpq8cd6WAgAETnwCAChcCgA==
Date:   Wed, 12 Apr 2023 12:15:40 +0000
Message-ID: <1c9bebd63b25f2789b4064748c30c4590bbc2c7d.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
         <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
         <ZC4qF90l77m3X1Ir@google.com>
In-Reply-To: <ZC4qF90l77m3X1Ir@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4929:EE_
x-ms-office365-filtering-correlation-id: d78caefd-15f4-4293-36b3-08db3b4fa19c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTo3ypMsJW2Se6al4S/P8FzYL3JlNT7zsWH9asclGGfgOwPupbRceDGQ4y3xga7ei/DOpcg27Jxehmr5G3nW05LOA0wx3D9/2LJDkssoPOmGNt4xeDtKQsff+JBCNAfHGzcxqi2ESoi+82c78CO2VwkVdZFmA7h4vSz7dwPIxiV7T8m4DXz18Q9WFQuzxt5541gBVT2qX6tq+w7wV7LXK8abiJ5cn6QLs9hYNGM5DaM0BdWYfwIgin68315V/rOnLJZbgSQuOyR6g9TBp6vXz9y32YkNhKolZWAKCZWy7JpkSRLbjAK8ZZNB+MVZB9KEH9Y7UjqxGmRbH+nLNCbzOcyZYDNTB1sDwUC0Rmi+hv0IJaEFNFyqUhwS8voO2DeGGv/TMkz7VuOGoxEuFqMevPAcpjitZnr+w0TnrJLaE0S1Fb28ZItDSMtEoF1+e2uFtuEqSTdPMd9AHeT/fwi/y7rUIlSywLB1zoAKpwuJJ18ljXFWojEh7KIQGOaRTr5slaXpPzmTMG2LbNJ1X1V9oa40P44981YY6LPfSOQ22XEQjl4s+otup1Kkk1dfS7NEZymtsPbsSB8cLjC98hZL3O4jSpBTWtoMPQjoyerFxA/1A9KbZdiFaPuQL0YROeic
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199021)(64756008)(82960400001)(6506007)(6512007)(122000001)(26005)(38070700005)(38100700002)(83380400001)(2616005)(186003)(8936002)(36756003)(316002)(41300700001)(6486002)(71200400001)(4326008)(6916009)(8676002)(86362001)(5660300002)(2906002)(478600001)(76116006)(66476007)(54906003)(66446008)(66556008)(91956017)(66946007)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVIwZlJKUm1tNzg0YjQxMW00Q29mcktJMDk3QnAyK085UjA3WVROTDZEcVpI?=
 =?utf-8?B?QXo4bDdmTEdaVlNaS1J1RU9rSVhqanhOVS9MWk1GSXZaeFlRVjNxczNRclZo?=
 =?utf-8?B?SUpvVUo4N1g5OFMyVW1lRHd2M2FaR3hHTkkzbUpxZ01LbXpBYkY0Q1pVb0l4?=
 =?utf-8?B?aWZaV3RRWE1nR0R1QW1ac3hVbGtzSXVHaGtVQ1I4bTU1ci81R1ZBUHdzNnlT?=
 =?utf-8?B?bWJjVDZxRnJIM2lqeXVSdGpEaUxpbHVKMzRScXVwMEY2UmYyZWZmNEZHSHk3?=
 =?utf-8?B?bWpoR2tKUjJNbVQwSHBrNmlwYU12dzExNU15L1JFbklJdXRXbUkvbE1GbWEy?=
 =?utf-8?B?U09DUm1hUDA2Q2Z5RnY0amtJU1JNMUJDRnpkbndDd0pjd3NKa3dwU282Q0VZ?=
 =?utf-8?B?UERuaFNBSDBRbDNsWnJlellyUG1rK1RHekl0NzRDcFRDU2JvMG0yMG5qZjRk?=
 =?utf-8?B?TE9Zd1dLL1JNWk41am0yOHFRZEZQVHk4cm9aclhRVWZ1ZGNxb1prN3Q2Z3Yy?=
 =?utf-8?B?VkZrTlNlWUN6cFNPcE5qTnhKNW1BTGg0YU1qZ1Z3bE0vOG0waHJ0dGxGeUtH?=
 =?utf-8?B?MGZPNFA4NVRraHU0RjBrenY0a1pnVzQxekZhQ0Y1OGJRT05TeFJOeWdFTjJQ?=
 =?utf-8?B?OHE3cFpnaDNhcGFweFQ0NDR3ZnNZYnAwdTNDVTQ2YlRqd01OYzM2eGlsTjA2?=
 =?utf-8?B?SkVucU40dmVpYzRoNStESzAwdlVycnJnTHFKWFFuUjd0R3gvU3ZicmsvVmY3?=
 =?utf-8?B?dHEvalREa0ZWdmx6K083MUpUa28wUVJxVEQzcWNMcXh6bllEdWZRanlUc3Ix?=
 =?utf-8?B?WGhnQjJyYWNhVXFobHh6a1kwVDk4M2FOdGdTaWJXMk0zaWZ3NlhKTlg5bDMx?=
 =?utf-8?B?dHY3R0wvd2lDeXVVdXZtc1AyMWZZMWhIckRnM3dvZGQyY3JDeVFmaUgxMzF2?=
 =?utf-8?B?Mm5BSmQ0TlN0TlJoVk4xWklnV1ZKbVY2eXRXU0sxWmZlZFFyQkN0QUlRcG5V?=
 =?utf-8?B?eVBwZXdOZmx4SEdsR3RlRXhza0VieXRXSnNHOExnNGtNWVZyakZKVGlVRlQx?=
 =?utf-8?B?SkRNcUZJY1dlNDNJYksrY09DbVV2cHRjdTdpczZPbnVBVEJQemc0cmF2a2xE?=
 =?utf-8?B?VFRheVpqbEx3Z3hUUG1ZWlh0MytlMmxoMzZldjA2ZzJjVUIzZXVGVFNwZVFT?=
 =?utf-8?B?b2c2QytHZUQ2bThqNEFiQkdRY04rZ1FmNWJDalZ1RUxSWG15NXE3Y01QTW9Y?=
 =?utf-8?B?bTdaeldaNk1qS1Q2RVpxdGJpcWJEdWE1NnlYNmpkVWczdHFrQTJVOS9LOUNK?=
 =?utf-8?B?SjR0VGpCWk0zaDY4TVRDKzBzcGJDK1F3WUlXUWM4cDhoTXZEWnlyaHhmdjZw?=
 =?utf-8?B?bS9SWUtkNEp2TzF3YStHNFk0Uit0enJuN0c0TERpSTQ4YTlnNmZONHRCclB0?=
 =?utf-8?B?NExaRlhHYWR0b3B0SllYUldjeEZ1SnllUFFNMnhWMUQ4dXRnOE9YOS9nd29D?=
 =?utf-8?B?Q3B3Q05Rb1dYbHBoQ0FCYmZCbFBVcTllOU45QUdpcjh1RC9OOXFYd0RZdTZS?=
 =?utf-8?B?NnF1ZlpHRVN3NkZIMkdPZXV2eUFtdnVUdVo1SlpYS09yQXBBRkVPU2FzQTIw?=
 =?utf-8?B?MzZwOHV4cy9oeEs3blZUaWdkbERyR1hXV1lJWUZVLzdkaE1Oa0lxVWR6Q1lp?=
 =?utf-8?B?aGkyMnFzRTdDZXpSRUtCdkMvVEo2K09YSlUxclFRQ3FlOTVLL1pJUVdFbm9J?=
 =?utf-8?B?RnhtY0hWeHR2TWxia0NTSE9GMzBsTkVkTTJDNVhoQ09zYUxUYnY4akFHY2x3?=
 =?utf-8?B?bGJXb3RiaTZBOFZaVWZVdGh5anhEOTNRUklyTVViZGI1alpOaENjOWRLLzVS?=
 =?utf-8?B?S2ZGVGJIN3lTdnJxRkQ2QnNSaDlIUlNLTXJYdWtyZlVGZktpYU1xZWtWMWhn?=
 =?utf-8?B?eXd1V3dKRVVKUEhSTTJ2anl1VGtUblcvZHRRM0VxWHNGTEM5aTdXRFZ6aEZ1?=
 =?utf-8?B?dkVWSzJINVlSMHhndW0rSTJGU2xGZVlkVSt5QkhRL3RVSXRGRCtpL0dTUEI1?=
 =?utf-8?B?TnQrZjRrejFTYXo3cUpSSUxpUlJSUFZNWXFlNXlUTnNoVXRvcHgrVmhSRU1K?=
 =?utf-8?Q?ePL82EtOzb/9nurJEtJC+SuBh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F776CEB89DF3D244AF54651F4199C484@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d78caefd-15f4-4293-36b3-08db3b4fa19c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 12:15:40.2696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ahMZ1PE62cXAS3HuEueXq50YicoyKNVK4ZFY1KTQUn0UxjGV5lwgqSkV0IsDqCvywbwx7aJLHM3/sUIiNK473A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4929
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

T24gV2VkLCAyMDIzLTA0LTA1IGF0IDE5OjEwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAwNSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
dWUsIDIwMjMtMDQtMDQgYXQgMTc6NTkgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiAqKiogV0FSTklORyAqKiogQUJJIGJyZWFrYWdlLg0KPiA+ID4gDQo+ID4gPiBTdG9w
IGFkanVzdGluZyB0aGUgZ3Vlc3QncyBDUFVJRCBpbmZvIGZvciB0aGUgYWxsb3dlZCBYRlJNIChh
LmsuYS4gWENSMCkNCj4gPiA+IGZvciBTR1ggZW5jbGF2ZXMuICBQYXN0IG1lIGRpZG4ndCB1bmRl
cnN0YW5kIHRoZSByb2xlcyBhbmQgcmVzcG9uc2liaWxpdGllcw0KPiA+ID4gYmV0d2VlbiB1c2Vy
c3BhY2UgYW5kIEtWTSB3aXRoIHJlc3BlY3QgdG8gQ1BVSUQgbGVhZnMsIGkuZS4gSSB0aG91Z2h0
IEkgd2FzDQo+ID4gPiBiZWluZyBoZWxwZnVsIGJ5IGhhdmluZyBLVk0gYWRqdXN0IHRoZSBlbnRy
aWVzLg0KPiA+IA0KPiA+IEFjdHVhbGx5IEkgYW0gbm90IGNsZWFyIGFib3V0IHRoaXMgdG9waWMu
DQo+ID4gDQo+ID4gU28gdGhlIHJ1bGUgaXMgS1ZNIHNob3VsZCBuZXZlciBhZGp1c3QgQ1BVSUQg
ZW50cmllcyBwYXNzZWQgZnJvbSB1c2Vyc3BhY2U/DQo+IA0KPiBZZXMsIGV4Y2VwdCBmb3IgdHJ1
ZSBydW50aW1lIGVudHJpZXMgd2hlcmUgYSBDUFVJRCBsZWFmIGlzIGR5bmFtaWMgYmFzZWQgb24g
b3RoZXINCj4gQ1BVIHN0YXRlLCBlLmcuIENSNCBiaXRzLCBNSVNDX0VOQUJMRVMgaW4gdGhlIE1P
TklUT1IvTVdBSVQgY2FzZSwgZXRjLg0KPiANCj4gPiBXaGF0IGlmIHRoZSB1c2Vyc3BhY2UgcGFz
c2VkIHRoZSBpbmNvcnJlY3QgQ1BVSUQgZW50cmllcz8gIFNob3VsZCBLVk0gc2FuaXRpemUNCj4g
PiB0aG9zZSBDUFVJRCBlbnRyaWVzIHRvIGVuc3VyZSB0aGVyZSdzIG5vIGluc2FuZSBjb25maWd1
cmF0aW9uPyAgTXkgY29uY2VybiBpcyBpZg0KPiA+IHdlIGFsbG93IGd1ZXN0IHRvIGJlIGNyZWF0
ZWQgd2l0aCBpbnNhbmUgQ1BVSUQgY29uZmlndXJhdGlvbnMsIHRoZSBndWVzdCBjYW4gYmUNCj4g
PiBjb25mdXNlZCBhbmQgYmVoYXZpb3VyIHVuZXhwZWN0ZWRseS4NCj4gDQo+IEl0IGlzIHVzZXJz
cGFjZSdzIHJlc3BvbnNpYmlsaXR5IHRvIHByb3ZpZGUgYSBzYW5lLCBjb3JyZWN0IHNldHVwLiAg
VGhlIG9uZQ0KPiBleGNlcHRpb24gaXMgdGhhdCBLVk0gcmVqZWN0cyBLVk1fU0VUX0NQVUlEezJ9
IGlmIHVzZXJzcGFjZSBhdHRlbXB0cyB0byBkZWZpbmUgYW4NCj4gdW5zdXBwb3J0ZWQgdmlydHVh
bCBhZGRyZXNzIHdpZHRoLCB0aGUgYXJndW1lbnQgYmVpbmcgdGhhdCBhIG1hbGljaW91cyB1c2Vy
c3BhY2UNCj4gY291bGQgYXR0YWNrIEtWTSBieSBjb2VyY2luZyBLVk0gaW50byBzdHVmZiBhIG5v
bi1jYW5vbmljYWwgYWRkcmVzcyBpbnRvIGUuZy4gYQ0KPiBWTUNTIGZpZWxkLg0KDQpTb3JyeSBj
b3VsZCB5b3UgZWxhYm9yYXRlIGFuIGV4YW1wbGUgb2Ygc3VjaCBhdHRhY2s/IDopDQoNCj4gDQo+
IFRoZSByZWFzb24gZm9yIEtWTSBwdW50aW5nIHRvIHVzZXJzcGFjZSBpcyB0aGF0IGl0J3MgYWxs
IGJ1dCBpbXBvc3NpYmxlIHRvIGRlZmluZQ0KPiB3aGF0IGlzL2lzbid0IHNhbmUuICBBIHJlYWxs
eSBnb29kIGV4YW1wbGUgd291bGQgYmUgYW4gYWx0ZXJuYXRpdmUgd2UgKEdvb2dsZSkNCj4gY29u
c2lkZXJlZCBmb3IgdGhlICJzbWFsbGVyIE1BWFBIWUFERFIiIGZpYXNjbywgdGhlIHVuZGVybHlp
bmcgcHJvYmxlbSBiZWluZyB0aGF0DQo+IG1pZ3JhdGluZyBhIHZDUFUgd2l0aCBNQVhQSFlBRERS
PTQ2IHRvIGEgc3lzdGVtIHdpdGggTUFYUEhZQUREUj01MiB3aWxsIGluY29ycmVjdGx5DQo+IG1p
c3MgcmVzZXJ2ZWQgYml0ICNQRnMuDQo+IA0KPiBSYXRoZXIgdGhhbiB0ZWFjaCBLVk0gdG8gdHJ5
IGFuZCBkZWFsIHdpdGggc21hbGxlciBNQVhQSFlBRERScywgYW4gaWRlYSB3ZSBjb25zaWRlcmVk
DQo+IHdhcyB0byBpbnN0ZWFkIGVudW1lcmF0ZSBndWVzdC5NQVhQSFlBRERSPTUyIG9uIHBsYXRm
b3JtcyB3aXRoIGhvc3QuTUFYUEhZQUREUj00NiBpbg0KPiBhbnRpY2lwYXRpb24gb2YgZXZlbnR1
YWwgbWlncmF0aW9uLiAgU28gbG9uZyBhcyB1c2Vyc3BhY2UgZG9lc24ndCBhY3R1YWxseSBlbnVt
ZXJhdGUNCj4gbWVtc2xvdHMgaW4gdGhlIGlsbGVnYWwgYWRkcmVzcyBzcGFjZSwgS1ZNIHdvdWxk
IGJlIGFibGUgdG8gdHJlYXQgc3VjaCBhY2Nlc3NlcyBhcw0KPiBlbXVsYXRlZCBNTUlPLCBhbmQg
d291bGQgb25seSBuZWVkIHRvIGludGVyY2VwdCAjUEYoUlNWRCkuDQo+IA0KPiBDaXJjbGluZyBi
YWNrIHRvICJ3aGF0J3Mgc2FuZSIsIGVudW1lcmF0aW5nIGd1ZXN0Lk1BWFBIWUFERFIgPiBob3N0
Lk1BWFBIWUFERFINCj4gZGVmaW5pdGVseSBxdWFsaWZpZXMgYXMgaW5zYW5lIHNpbmNlIGl0IHJl
YWxseSBjYW4ndCB3b3JrIGNvcnJlY3RseSwgYnV0IGluIG91cg0KPiBvcGluaW9uIGl0IHdhcyBm
YXIgc3VwZXJpb3IgdG8gcnVubmluZyB3aXRoIGFsbG93X3NtYWxsZXJfbWF4cGh5YWRkcj10cnVl
Lg0KDQpJIGd1ZXNzIGV2ZXJ5b25lIHdhbnRzIHBlcmZvcm1hbmNlLg0KDQo+IA0KPiBBbmQgc2Fu
ZSBpcyBub3QgdGhlIHNhbWUgdGhpbmcgYXMgYXJjaGl0ZWN0dXJhbGx5IGxlZ2FsLiAgQU1YIGlz
IGEgZ29vZCBleGFtcGxlDQo+IG9mIHRoaXMuICBJdCdzIF90ZWNobmljYWxseV8gbGVnYWwgdG8g
ZW51bWVyYXRlIHN1cHBvcnQgZm9yIFhGRUFUVVJFX1RJTEVfQ0ZHIGJ1dA0KPiBub3QgWEZFQVRV
UkVfVElMRV9EQVRBIGluIENQVUlELCBidXQgaWxsZWdhbCB0byBhY3R1YWxseSB0cnkgdG8gZW5h
YmxlIFRJTEVfQ0ZHDQo+IGluIFhDUjAgd2l0aG91dCBhbHNvIGVuYWJsaW5nIFRJTEVfREFUQS4g
IEtWTSBzaG91bGQgYXJndWFibHkgcmVqZWN0IENQVUlEIGNvbmZpZ3MNCj4gd2l0aCBUSUxFX0NG
RyBidXQgbm90IFRJTEVfREFUQSwgYW5kIHZpY2UgdmVyc2EsIGJ1dCB0aGVuIEtWTSBpcyByZWpl
Y3RpbmcgYSAxMDAlDQo+IGFyY2hpdGVjdHVyYWxseSB2YWxpZCwgaWYgaW5zYW5lLCBDUFVJRCBj
b25maWd1cmF0aW9uLiAgRGl0dG8gZm9yIG5lYXJseSBhbGwgb2YNCj4gdGhlIFZNWCBjb250cm9s
IGJpdHMgdmVyc3VzIHRoZWlyIENQVUlEIGNvdW50ZXJwYXJ0cy4NCj4gDQo+IEFuZCBzb21ldGlt
ZXMgdGhlcmUgYXJlIGdvb2QgcmVhc29ucyB0byBydW4gYSBWTSB3aXRoIGEgdHJ1bHkgaW5zYW5l
IGNvbmZpZ3VyYXRpb24sDQo+IGUuZy4gZm9yIHRlc3RpbmcgcHVycG9zZXMuDQo+IA0KPiBUTDtE
UjogdHJ5aW5nIHRvIGVuZm9yY2UgInNhbmUiIENQVUlEL2ZlYXR1cmUgY29uZmlndXJhdGlvbiBp
cyBhIGdpZ2FudGljIGNhbiBvZiB3b3Jtcy4NCg0KQWdyZWVkLiAgVGhhbmtzIGZvciB0aGUgY2xh
cmlmaWNhdGlvbi4NCg0K
