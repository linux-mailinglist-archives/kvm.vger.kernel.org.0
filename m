Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A12B6AA7FE
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 05:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCDEZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 23:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCDEZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 23:25:10 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362C61ACE4;
        Fri,  3 Mar 2023 20:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677903909; x=1709439909;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1zjbeV1K+VOAkg6UmUiCIO/OqJaLqxoHPao8h20sTLQ=;
  b=LkoBDzne37zcndHqHjx/9Eg+cOFvHseB0IY1qVNMeWeo12tmF7acE08L
   P8UjlAFoY1ki3bzRWqfNPE7UR+8cvAx8EHx82znl6twvSYJqKmecW0Xb3
   FUoJDgeGSxpJG6zorR7AiBuErHwnNxySaEBYzDi93aHPP7nNfiL8hVxhH
   RZAjFQk0hpl82ejFVxfeIKClOB+qgKBYvEBFTErMCFCldjRyq2FHCDj8u
   6XAgo81rFM/FxWDqcLRN5aKKijGD6bermy+2yZyI3YxNhDBOS9yoQNKRI
   iM6wcM4iG44cb/TngLxp6LhrBWL9J63s6MJZnrbNoEizoQgDFyD7DKrJ1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="362819527"
X-IronPort-AV: E=Sophos;i="5.98,232,1673942400"; 
   d="scan'208";a="362819527"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 20:25:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="744461075"
X-IronPort-AV: E=Sophos;i="5.98,232,1673942400"; 
   d="scan'208";a="744461075"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 03 Mar 2023 20:25:08 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 20:25:08 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 20:25:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 20:25:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OusDr1a3JxhhTHQs5YQf8AZNwuGOR34J2qgaYFXu+1ETQ5hrnpfoeckTQ2iTBUfBG7GwSRK3/KAvTkykmmLYtIyJfY66TUwfJTkDNYwTJagJLhuY9WR90IUO9oFBk7R2dGSSO/IBnrmylN9F33wQkrLjMNQA6VcmNDjD3e9PfXw+YScjb5Zx8XBYgElRoSetLrJdr0LpwzSyr1ThD8OOBVG54kXrT+STRGvZMnpLPbnb/Zzs22MYgI6cN9NPxjQWYn2lZWR3ZPUrpgvT9SQ3AjX5FE7RKkb6f4SVGFNH7dI/vsDD7xANSX9dmwwKQkCeScsRj+cBeZPLrIiAnNZKXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zjbeV1K+VOAkg6UmUiCIO/OqJaLqxoHPao8h20sTLQ=;
 b=HdqXzzkXQDnumP2R+aI65EVHx8RRULNhz/KESdIQiooxhEj7JMFPHMRA7Wl5Ooosv24O6siUX5Ok2F9NguOQ0pUiWMzOnfGTFF+FtHGIt6j9ycS7tBZ68jMCTRjTkq1TtImWsKFEIxagMXfX26GiZ0HcNVXMVbgHiygyx3kSt8gQ384i5JzOOmjFKnB4pjQDMhu1MtuYBniqT0Y8Xgatuqoggwt9scJw/wPa1uuhTKXer+5ORYSO+WKwaz+MIS5eb6HC+qOZlwkOboPvw+eN0lPPNr+N/53U26Yj9oFevauAIGAiV21XkT8TFjovt2vko70+DUSeZ7Fh/zMyTjg2Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SJ0PR11MB4800.namprd11.prod.outlook.com (2603:10b6:a03:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Sat, 4 Mar
 2023 04:25:01 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6156.018; Sat, 4 Mar 2023
 04:25:01 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Topic: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Index: AQHZTEMoO+JAZhQRUE2mrtrpaO2QJ67mVMSAgABZTgCAAD+sAIAAV8fggACG/4CAAHmhIIAASlCAgADEVYCAAIGXEA==
Date:   Sat, 4 Mar 2023 04:25:00 +0000
Message-ID: <DS0PR11MB6373C317B71C7B1BABB9BED2DCB09@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230301133841.18007-1-wei.w.wang@intel.com>
 <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
 <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZAAsIBUuIIO1prZT@google.com>
 <DS0PR11MB6373DAA05CEF9AB8A83A6499DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CAL715WLo90-JkJe6=GfX755t1jvaW-kqD_w++hv3Ed53fhLC3w@mail.gmail.com>
 <DS0PR11MB63735E9AC8F4636AF27DAA4ADCB39@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CAL715WJsV3tPkMDK0exgHeuKOP9kJtc62Ra0jnRhT1Gd6AiEWg@mail.gmail.com>
 <ZAIwEZdYcrs5EcHE@google.com>
In-Reply-To: <ZAIwEZdYcrs5EcHE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SJ0PR11MB4800:EE_
x-ms-office365-filtering-correlation-id: 474361bc-e2a3-49cb-8d7f-08db1c686b5a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ha07ab7uvTUaQsw7pBavdjmwzNrkn30NO1jejFIbb7DeKBZGKO4sMZjCQrH0VSzS1KQsDJvWPZ6dzFhvrWLpmHye56IOWPYLO+0NqF6LWYmvbhhXx66v/efTvClUt/NqxipvYwNEUA3Foh3L671tMfEZ/8JzDYce/giOVqv3jnEBRlWJSAX1KEs2OOixFBt2fQeuTiut5TbcFO5DPHwwRnxPjdNy14H7rumIQzhPHwVXiWB0otasJTXScXcOSDlrkRkmbQBCk08Wm3LbCFugWog59W4LK5sgrSKkdiBeBcKjMHm0WvgdjIQyT8oNGKnouRh1nVJaLy9x9dqwbbeqvoLeNyOwcC6LeDuAcsz3A7HSzivunxlA5Leui7/Nk+OLiLxeFHXBhbpzbEPREoBoNe1FqboLNwFpeqx6lkL07HvJogemyoGaTeMGggbtPJ3juiEwojs/C9aabl5gz3tVllm6/K5z7nva3YTTpWkAXd6ozglupEkB0T2LPsF9C6o4Ox6w0zRQaY4NjeNOsxiHMlfSz4zD3ZGhUIvhPj7DAcv0OXmRVVDxp4BQeBU5Jiyv7Q287M4u5i0jzP5XfeTTypnp3q8YNgZQDtOukYSXXvN6uO2Az3prjPWmxPjicDIz+TV408lZaMHVzkYM/DSHu+nLKjotdpEef7D08NhzIn3ooWxpkcV9/CmnMaoVAePpBH7jPwMU7EH8C2dXgl/Jhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199018)(52536014)(5660300002)(8936002)(4326008)(55016003)(8676002)(64756008)(66446008)(66556008)(66946007)(86362001)(66476007)(76116006)(54906003)(110136005)(478600001)(71200400001)(7696005)(316002)(33656002)(41300700001)(2906002)(26005)(82960400001)(186003)(9686003)(122000001)(53546011)(38100700002)(38070700005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tmc4RlFVVVZmWUU5RENtVCsrRzMwcndyUm41NVdnMStVWVNsQWt2ZnczVEJz?=
 =?utf-8?B?NG92UHdXZnZpNXU4TWRUOFQ2cnlKRVVSalk1T0FzZ0JJZVFDLzhGY1BlbG5F?=
 =?utf-8?B?cmJtb2RrTGtqamFXQUd4MHh5VW56QldJd2JjMTdkakc4dE4zL3dxOGN4NTY0?=
 =?utf-8?B?T0RGZnlMRzI2WTFhby93YTRXcDBMSWM2dmZiT0hmZWdmRTJkNkNZNEoyR1J3?=
 =?utf-8?B?aTdIcXpodGIzUkY0MWtsZ1RIRVllUVg4UFh5YmtPbWd4WTB6TkN4SHpDTXpu?=
 =?utf-8?B?N2VPd01xbUFlZHJiZFprb0s2Zm9IZEVqNzBieW0wUlV6SVhRbDA3QjdHOUxk?=
 =?utf-8?B?M2JNMkhJNzJFakZtdEROSmVYWDlhWjRQU2ZXT0xmR2N6dVdnV0pGVXlGWDlv?=
 =?utf-8?B?MEM0YmZObDU2eHhtZy9zMFRNSFZPVXVhUkNiRVg2d1pOL3EvRVhkWGlwRXRM?=
 =?utf-8?B?bDQ2MHNJN3UyMzE1TUh5cUt0T1h5UUxwNEx4QjFtR1hsdG9sMjJpSytmQitp?=
 =?utf-8?B?Rm9STjQrL01vS3FkUTliZkdmeUJSU1pPdDJJcUNVUlFLWnM0NzViU1pCU0Jv?=
 =?utf-8?B?VXVHbG10T0dhanJCRjF6Rkpxd1d2UEt2dGhrRlUxK3ErRHlNYllkSE04RzZs?=
 =?utf-8?B?TVhFRndSbUVqQUgwUlAzbk12TTBQKzErTjFRd3VEbG5uLzg0SDVhcEF2MU9O?=
 =?utf-8?B?VElmU1ByYU9vTllBVGlncm1jZmNpa0hkTnBVSjZOWEZNL2RKOWV4eUkyKzZZ?=
 =?utf-8?B?c0RURUNiUTVwTVFjY2x4dm1YdkhEQ09RMGthZS9CV1I2M0RycDhPVTVoR2s0?=
 =?utf-8?B?Q0MyTWVxOTdKNnJmVHNpWTlzdU1lQktwVFkxSE5yek51WFRtU0JQZldFV2FT?=
 =?utf-8?B?dGdzUUFYSkF0UUxVRE93V3gyRGorNGYzMzc1RGY2TzhaV0lNbFhWQW5PRXUx?=
 =?utf-8?B?eUx5d0JYWStJMU5qT0pCRmhRZ2hOY01oMHM5YzFGeTZGY0NFbTdidFFXWEpl?=
 =?utf-8?B?UDkyZldTT00wbUdmSjRvU0FWaWRtSmNUWnlmejBHbzR5a0dGRVFoWk05V0pj?=
 =?utf-8?B?MCtmOXljdm1VMjBtcXBpT25ieTF0MzFkNiszN0tFUzd6UTd1U0Q1OE9qNE1N?=
 =?utf-8?B?WnUwcmdCMFlZNmFudDdlTFdqYzBNOEh6b2pNK3U0amRmYnBlelpHNG9yb20y?=
 =?utf-8?B?ZTAremtYRHJhN1E5bDdWOUhRWldKZWxZWXZoSUlRTnk3N2FMbVBhSDh2bjZG?=
 =?utf-8?B?TzlUU2ZHVE5WaWRNWDhHR2M0RDJrYm9qMGJGRTVzOVlTR09Hc0RyYk85RkhJ?=
 =?utf-8?B?SVcyUDdyWFloclVPYzFHU0VtRHVhK09JTVo2aVV4WkRLelRoY3NxaE5ZYXE2?=
 =?utf-8?B?T3RJZm1YQWtYNHhDL2NYV1hZWXRpTG5YV2FpMXcwNDM1YTRrY0QybjNmUllW?=
 =?utf-8?B?T0cxYlVYWnA2Um1uNE9renRhR2prU2Y4MlZkYzJzc09qLy9Xd2cvMGp6b1B2?=
 =?utf-8?B?OHlscGlRdTJxazBsZFAwdDR1QTJHUWZFd2tCSlRMaUY5Zm5SWmR3ZzZ4RkVq?=
 =?utf-8?B?aEplckx2Q3lobUMrVFpFTGhBQS9ndlloYXZEaklYQTFLYjJEdVp1b1BjVEt6?=
 =?utf-8?B?WDdNQmNXYlIwdkxnYWNSeTZMaDNqRzNQNnp0VHIwbi83R3JYeDBCNzZkTmxT?=
 =?utf-8?B?WWtkMWgyYndGbFhyQ1ZyNXhOM1pPaE9GOVJXRDJtbGllT3lRcS9jakQxWWtE?=
 =?utf-8?B?ZlVzUGJiYkkwcCs3WVpubitWUk96VUZVMExleEh6QzdMSWFCSkZScGlUUnA2?=
 =?utf-8?B?bisraUNqM0RpK3NnZWVmZlBxK01nRGMyRzBVaHRiL0g5c3pKemRqSC9rZFJw?=
 =?utf-8?B?OFBTU2FxVWhqTnR5K1NpKzJ3ZlpEQ1hpU3FDN2UycEk2UFlWaXg4QVdwQ3FH?=
 =?utf-8?B?L0l6RVY3T1pucFg0NFYvY0xjcSsvU3BINnpGTExjRmptdnpmZWRxRXJUeVpz?=
 =?utf-8?B?c2JkL0lZc21sR1A2SXREeVNRMW1uTUhVSXBXczlJYnN0cXRva1p5V0w2SUt0?=
 =?utf-8?B?Ujc5bHJLUEc0R3E1TzFPVm1qNmpGU09SL00vZnlQOHFHOVNRaEZ5VHMyT0RL?=
 =?utf-8?Q?EUTxny7Amomc9TBZtzR39DlA1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 474361bc-e2a3-49cb-8d7f-08db1c686b5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2023 04:25:00.6017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FlYe0DjRGIyL3Fv86emTr4xUgHvNMh8maXjGHmBLKkQUBW6ptxtUUjE1UiU0Ya6qTHWyEBRD7vqbYWJE84Ygzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4800
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0dXJkYXksIE1hcmNoIDQsIDIwMjMgMTozNiBBTSwgRGF2aWQgTWF0bGFjayB3cm90ZToN
Cj4gPiA+IE9uIEZyaWRheSwgTWFyY2ggMywgMjAyMyAyOjEyIEFNLCBNaW5nd2VpIFpoYW5nIHdy
b3RlOg0KPiA+ID4gPiA+IE9uIFRodXJzZGF5LCBNYXJjaCAyLCAyMDIzIDEyOjU1IFBNLCBNaW5n
d2VpIFpoYW5nIHdyb3RlOg0KPiA+ID4gPiA+ID4gSSBkb24ndCBnZXQgaXQuIFdoeSBib3RoZXJp
bmcgdGhlIHR5cGUgaWYgd2UganVzdCBkbyB0aGlzPw0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgNCj4gPiA+ID4gPiA+IGIvaW5j
bHVkZS9saW51eC9rdm1faG9zdC5oIGluZGV4IDRmMjZiMjQ0ZjZkMC4uMTA0NTUyNTNjNmVhDQo+
ID4gPiA+ID4gPiAxMDA2NDQNCj4gPiA+ID4gPiA+IC0tLSBhL2luY2x1ZGUvbGludXgva3ZtX2hv
c3QuaA0KPiA+ID4gPiA+ID4gKysrIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oDQo+ID4gPiA+
ID4gPiBAQCAtODQ4LDcgKzg0OCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBrdm1fdm1fYnVnZ2Vk
KHN0cnVjdA0KPiA+ID4gPiA+ID4ga3ZtDQo+ID4gPiA+ID4gPiAqa3ZtKQ0KPiA+ID4gPiA+ID4N
Cj4gPiA+ID4gPiA+ICAjZGVmaW5lIEtWTV9CVUcoY29uZCwga3ZtLCBmbXQuLi4pICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXA0KPiA+ID4gPiA+ID4gICh7ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gPiA+ID4gPiAtICAg
ICBpbnQgX19yZXQgPSAoY29uZCk7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4gPiA+ID4gPiA+ICsgICAgIGludCBfX3JldCA9ICEhKGNvbmQpOyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhpcyBpcyBlc3Nl
bnRpYWxseSAiYm9vbCBfX3JldCIuIE5vIGJpZ2dpZSB0byBjaGFuZ2UgaXQgdGhpcyB3YXkuDQo+
ID4gPiA+DQo+ID4gPiA+ICEhIHdpbGwgcmV0dXJuIGFuIGludCwgbm90IGEgYm9vbGVhbiwgYnV0
IGl0IGlzIHVzZWQgYXMgYSBib29sZWFuLg0KPiA+ID4NCj4gPiA+IFdoYXQncyB0aGUgcG9pbnQg
b2YgZGVmaW5pbmcgaXQgYXMgYW4gaW50IHdoZW4gYWN0dWFsbHkgYmVpbmcgdXNlZCBhcyBhDQo+
IEJvb2xlYW4/DQo+ID4gPiBPcmlnaW5hbCByZXR1cm5pbmcgb2YgYW4gJ2ludCcgaXMgYSBidWcg
aW4gdGhpcyBzZW5zZS4gRWl0aGVyDQo+ID4gPiByZXR1cm5pbmcgYSBCb29sZWFuIG9yIHRoZSBz
YW1lIHR5cGUgKGxlbmd0aCkgYXMgY29uZCBpcyBnb29kIHdheSB0byBtZS4NCj4gPg0KPiA+IFdo
YXQncyB0aGUgcG9pbnQgb2YgdXNpbmcgYW4gaW50ZWdlcj8gSSB0aGluayB3ZSBuZWVkIHRvIGFz
ayB0aGUNCj4gPiBvcmlnaW5hbCBhdXRob3IuIEJ1dCBJIHRoaW5rIG9uZSBvZiB0aGUgcmVhc29u
cyBtaWdodCBiZSBjb252ZW5pZW5jZQ0KPiA+IGFzIHRoZSByZXR1cm4gdmFsdWUuIEkgYW0gbm90
IHN1cmUgaWYgd2UgY2FuIHJldHVybiBhIGJvb2xlYW4gaW4gdGhlDQo+ID4gZnVuY3Rpb24uIEJ1
dCBpdCBzaG91bGQgYmUgZmluZSBoZXJlIHNpbmNlIGl0IGlzIGEgbWFjcm8uDQo+ID4NCj4gPiBB
bnl3YXksIHJldHVybmluZyBhbiAnaW50JyBpcyBub3QgYSBidWcuIFRoZSBidWcgaXMgdGhlIGNh
c3RpbmcgZnJvbQ0KPiA+ICdjb25kJyB0byB0aGUgaW50ZWdlciB0aGF0IG1heSBsb3NlIGluZm9y
bWF0aW9uIGFuZCB0aGlzIGlzIHdoYXQgeW91DQo+ID4gaGF2ZSBjYXB0dXJlZC4NCj4gDQo+IHR5
cGVvZigpIHdvbid0IHdvcmsgaWYgY29uZCBpcyBhIGJpdGZpZWxkLiBTZWUgY29tbWl0IDhkNGZi
Y2ZiZTBhNCAoIkZpeA0KPiBXQVJOX09OKCkgb24gYml0ZmllbGQgb3BzIikgZnJvbSBMaW51cyBm
cm9tIGJhY2sgaW4gMjAwNzoNCg0KWWVzLCB0aGlzIHNlZW1zIHRvIGJlIGEgZ29vZCByZWFzb24g
Zm9yIG5vdCBnb2luZyBmb3IgdHlwZW9mLiBUaGFua3MgZm9yIHNoYXJpbmcuDQoNCj4gDQo+IEFz
IGZvciBpbnQgdmVyc3VzIGJvb2wsIEkgZG9uJ3Qgc2VlIGEgc3Ryb25nIGFyZ3VtZW50IGZvciBl
aXRoZXIuIFNvIGxldCdzIHN0aWNrDQo+IHdpdGggaW50IHNpbmNlIHRoYXQncyB3aGF0IHRoZSBj
dXJyZW50IGNvZGUgaXMgdXNpbmcgYW5kIHRoYXQgYWxpZ25zIHdpdGggdGhlDQo+IGdlbmVyaWMg
a2VybmVsIFdBUk5fT04oKS4NCj4gDQo+IElmIHNvbWVvbmUgd2FudHMgdG8gcHJvcG9zZSB1c2lu
ZyBhIGJvb2wgaW5zdGVhZCBvZiBhbiBpbnQgdGhhdCBzaG91bGQgYmUgYQ0KPiBzZXBhcmF0ZSBj
b21taXQgYW55d2F5IGFuZCBuZWVkcyBhbiBhY3R1YWwganVzdGlmaWNhdGlvbi4NCg0KV2FpdCBh
IGJpdC4gTGV0IG1lIHNlZWsgZm9yIGEgdmFsaWQgcmVhc29uIGZyb20gdGhlIFdBUk4gc2lkZSBm
aXJzdC4NCg0KQ29kaW5nU3R5bGUgYWxyZWFkeSBzYXlzOg0KYm9vbCBmdW5jdGlvbiByZXR1cm4g
dHlwZXMgYW5kIHN0YWNrIHZhcmlhYmxlcyBhcmUgYWx3YXlzIGZpbmUgdG8gdXNlIHdoZW5ldmVy
DQphcHByb3ByaWF0ZS4gVXNlIG9mIGJvb2wgaXMgZW5jb3VyYWdlZCB0byBpbXByb3ZlIHJlYWRh
YmlsaXR5IGFuZCBpcyBvZnRlbiBhDQpiZXR0ZXIgb3B0aW9uIHRoYW4gJ2ludCcgZm9yIHN0b3Jp
bmcgYm9vbGVhbiB2YWx1ZXMuDQoNCg0KDQoNCg0KDQoNCg==
