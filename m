Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3116D6EA981
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 13:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjDULoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 07:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjDULn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 07:43:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37ADC3
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 04:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682077436; x=1713613436;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+F3hyH8RngW38vMUGPZ/CcnmKxq311UyWNH7+rdaMpo=;
  b=NQVQ4MSJ7xx24pn03RohDF/BTQx5RrAtFgGaTQDW25rhBFG94sEAhlsi
   61sJlKf54fubhXwhcW7HYe8xpS/XSHTLFfQYO5xJiF2Z7lCY61gupVdCe
   njzJaTwTgknarwoTiedLdIerbdxNlzTlCgVrznlxhQHkNelPg4TrLM4ft
   FmmutjzrMeWx3rusoEmVgprPkRnSRwXgZHNo5UMIELfSkWn9hT1Q/owMx
   2YeiAyU4hCsv40gFmfg0hp8cX9OWq8OSiIGhCjp3jNPSD4K1fqoXbwTZW
   FMEBFuqwJc24mBcJKMEKMoUBhZUKz0E/BXUoxJ4DauQl3fnbKckOBCEvz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="432251331"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="432251331"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 04:43:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="803719611"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="803719611"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2023 04:43:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 04:43:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 04:43:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 04:43:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6cjyQsHAdsdGPsr/S/ezd++jJZiCBCV2TPSKd9pJ+GcTWqFhcyviEfMbPePOLguocqaeaJJHjqYQqmkpNkDPlk+lqq+cgU45kAOsM4f/iBuWJgGsIjRXdYxuGHG7zzU5AMNhFyHK9km1VFbNQQA3W6WQqTdE3CK28JsNHmLn72bG33lwArXaweoUsKFCpGOVYd2DmqJiOFx3ygRHVv5/K6XGZrmh9kZo8kbvn5xmAQrBsaqgp/Aj49iIHCxd8PLVvuCOOz173Oj83EHuvQBV3Dq5hk6u+pZRPHMQmSUWUwxbZcsGLt2t1Qcs/iguz7C9BDxJ1EGPcdBrFjDcOFnLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+F3hyH8RngW38vMUGPZ/CcnmKxq311UyWNH7+rdaMpo=;
 b=BnlZWZBvLqqXPhkk0ud61qKFRNAz8wBYwwlhfKLlFP431f3/RBd3FIQ+0lE9dS9jGiGmaofleU/ynTHdTLXXEfvEKjo8Ww1zcvnEFExMrlFgxDRq6gGwFoEWFmTfPXX44SdWft2Bb7YfGmJ6LLstYg4yxh9/F+Hg499bonNha/RiPyfTKzHJZiera6vaOw6SWfAlTmGjPNprJO28OWYzncPcVAuHiN+PM5r1IhrJ3ZW/qXG+9cYBPncQVzNG5k8VM3e1AXzOBdNrJ2oTwbxg5ybVMVRZ0PmMiqQQl5Efw6g0NWeQM2eYu00SBnFz/hAXK800G6dEG+W6rp+3yzROVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5114.namprd11.prod.outlook.com (2603:10b6:806:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 11:43:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6298.030; Fri, 21 Apr 2023
 11:43:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgIAAJr0AgABKcWCADGbRAIAAVjKA
Date:   Fri, 21 Apr 2023 11:43:52 +0000
Message-ID: <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
         <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
         <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
         <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
         <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
         <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
         <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
In-Reply-To: <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5114:EE_
x-ms-office365-filtering-correlation-id: 2cec9d7e-1a63-427e-773d-08db425dae43
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1lXnev1hupA4UM5q4/LAXd6thlyysDtcZGN9qOvbG+x4EAJidtn1hF21ACJJuhgOlaXWHo6RRwJivzUFkTP389G5CXqiuI5K5ZYAyKquclk+owcFEnuZC+6PtCOl/fH4P1uENwQxPk7n/LajRW1ruCCgLbjjstYeZviPrgzUBArK1GJxuRuh+k2pAB4LAG4k0iMepU9giwJOiQ3MA1fP202sKLI/jS1yW2Gnv4akJAfW8A84T64I1AGK7M4fdoWx9HjpFjoBn8g9fwG3vdCS/VLm3g4J5Bq45IN18/TSInUF3oxIXtBB2Wdo0DA431eDmV6MgI+sf0XSt1mJPrayHherbZni306cMgg7YZM61yGgJP1q1TEs4Y4kKhF8nBkEFvGJtNKfVbX9ce8a9lWg3I8di10c+SUU3p1QyaXJuuynJXTnlqoSfDohst6L8NbSqi4fGpAHlxoGAgkLrRCLfS+VV4xCP5tBh56qetbgJaGyUDvm+eIQbJeh006Tv3f1rQn6vQSiZYZWklF1kJ8K36Mk6oMWI2oOLAVEhmoyFxMl2J6Ju/mwifG21YhZAjv4hovCaCJMsEyeHfzoIQNcgOiaXFWu7prRKQ6Stfu4hu/8GHckwsKv8v03xgGgXFfV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199021)(8936002)(38070700005)(53546011)(6512007)(8676002)(26005)(6506007)(186003)(2616005)(41300700001)(2906002)(316002)(71200400001)(5660300002)(54906003)(36756003)(82960400001)(478600001)(38100700002)(66946007)(86362001)(4326008)(91956017)(6486002)(66556008)(64756008)(76116006)(122000001)(66476007)(66446008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0RMNk40Yjl2UjAwZGhPRVU3WmRpMWFleWM5eFdtQmsydVgwNURGbDZFQXVn?=
 =?utf-8?B?Z0NkdzBBYUwyOFdLZ2p2QTJRWndsWGV1WDQvUUpKb2RteWF5aHpQWGtTMnk0?=
 =?utf-8?B?TzBSbldYWFBCd2ttdStuQVFYTkZxZWFOcTh6K1pOd1VnU0lqWDJEcmEvMXor?=
 =?utf-8?B?NHR5ZmRQRm15VG9Xb2hVTkZVYnM5bjQ0aWd2YUNsOUFDWW5oTVpKVUErNm4x?=
 =?utf-8?B?bGFhTlFINytFdVZRSFRFdmEvUEI0WmIwNkwxT2Y4SHB3QmQyZ2VEZDViQ1Z2?=
 =?utf-8?B?K0tmREhrekZPaFc5T1FVVWxpZDdGRjNTT2RrZ0Y1Wkh3SVR2VU03OUVCNkFR?=
 =?utf-8?B?R1J3NTdLdTNsOWxzYXRJazZxSWRITDRHS1ljL0VLeFJTeUxLdXlSRTdrRzEw?=
 =?utf-8?B?Vk5uZ3Y1aks2RFlodFgxMmxCSnJmemF5dHYwYUZ0ZXBXazhYU3JFWnBJT2Qr?=
 =?utf-8?B?YU44VmRrK0VseDJGK2RFeXNac3lqd0hpWmk4MG55bkxsOUg0cEhUeU1mOFRh?=
 =?utf-8?B?SWQvbzcvQWNqZTBORGkyZzR3ZWtJcUx1RjB6MEk0SFVBNDk5WlZScXlDczlN?=
 =?utf-8?B?c2o3WE9wbjI1M1NackNRSUlENzJXOHNwTkZrWlYxdXU3VktMVXkvY0x2ZWpS?=
 =?utf-8?B?VURUTDJRV3FRVHROOUlwdWovVlV3WVRobXAvWGlUeWpYcm5RYjZBNVY0OFNz?=
 =?utf-8?B?ZGN4eG00WGY2MDNkSHRRcHpwMTN6NGFqOWRXaGJ4ZWVKa3FjQ1NuUW1kK09I?=
 =?utf-8?B?ZEhPcllwQmZJS0s1RmVFTnhkbHhqTm9NSktkZW1uSElZRkxXUnI0dDVzZEJI?=
 =?utf-8?B?SkwyN3o0NDBHRGxYdGpIVml4YXJxMklLOWV4YnMzZjZDU095TWowZHhROGZh?=
 =?utf-8?B?dnZTRmdUajB5cE9qR3hRVE8zeVdudG1kN2JWeCtHcVNtMVpLRmg2dnQzblBF?=
 =?utf-8?B?QXF0c1pnT0hZb1FBamxaOHRINXg5eUg4R1BxWTZoZ2RHMkExaGtNaUhnQ2pj?=
 =?utf-8?B?OGRrRXdCd1BibnhJM0dtR0lPNjJHYTd1RDVGVmJTUUVrYndEWnkrQmFseTE1?=
 =?utf-8?B?bDNRUHZNVlB6OGFUbDgyWll1YWhTVUZMcWQrRUlVaEp6bHRpdlVpWHJqVHFR?=
 =?utf-8?B?RHFiRllJeHhaRWFjRWpLVEREQ0REbFN6b3VQSCt0KzNMeFNwZGVPaFB4TXJS?=
 =?utf-8?B?NHl3TXpYTUR4d3c3L05hcjJUU1UrK0xFWHVhdnREc0RzTG5NYjVYeXg4bHdT?=
 =?utf-8?B?SUIvbCs1aXk2WXNlb3I3SEhxMjVqKy9OUUN6aHpmRHZtL29vVDhQMkxGSmRX?=
 =?utf-8?B?cDQ4TFZab1JTTHpDc3AxL3o5UXZSNFRIOWVDK01jMDBicWQySVA0SVN6VmRr?=
 =?utf-8?B?MU9tNDA2OS9MMmRFdE96MVdweXdXSkx6UmlvQ0tLcUJpaVhNNzZadXRPWmQ1?=
 =?utf-8?B?c0JRbWNsL0d5M0ZFUjhKdGJNaFBVZHlYM2ZpWGVpZWFXN01kL2MwZXFVdy9a?=
 =?utf-8?B?RkVkQlJIODZoR3V5RTVKYlJZZFFFWHk1YUZ5NHc3ZVNkblRZM3h2T0o4dko4?=
 =?utf-8?B?dnB5NVJYKzVnckEvSzNHaWRKekZlNE1yWHZzYkwwNktpekl6d3hNMVNWMFdh?=
 =?utf-8?B?ZmoyT0g2dWpnWHQxRHJDMnpPUThJWkdyL2JoNkY4cEZiQk4vYXVrQklyU1U2?=
 =?utf-8?B?bW9UMWR3cU4vaEFRb2tJMXB1Z2VldEh3T25uOC9YS0tJMVNyMnAzTXByWWpV?=
 =?utf-8?B?TU1zQVVaM2ViMk42dDQyREJyRGVnTXdBbjFPS3FoMTZ1d0pwT3pSeHdCSGRh?=
 =?utf-8?B?WW9Td1dLMGhmbkpZTlVGc3UybGVuOStkYzBTdzR2Z3B0T3dHa05CK1g4SDVP?=
 =?utf-8?B?T0ZMNUZZdkFXMitCbnJCeURQVlJ0TlRUS2ZraFhZa1dUZ0taRktXRnc5cTJF?=
 =?utf-8?B?T1ZoTU5kWTNDOE15M2tidENFeXhYQkQzb1I0RFpmYUc0TkNHRTY3MFl4Q3Qr?=
 =?utf-8?B?Nm9IR2RUcTFXTVJneG5SZHVJU0pzbExmUFpoVG5FWVNDODd1aHFGdlJSSjBE?=
 =?utf-8?B?NDU1RTFiNUpSU2xLUDkrbkxEeUo0aVpsNDRjc2dQay9kdXVtYzlmQWc2Tysx?=
 =?utf-8?Q?Eg1XDeTmH4GWjbyunP31NpAAJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC704FA295E176498A178887E31EDBA7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cec9d7e-1a63-427e-773d-08db425dae43
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 11:43:52.6070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jarmxiUOtKbZmhBB7dSMmsRLhyoG+kt2iL9XDF2oniAkPMyguWAdmCi91f6xsRf0DlpQ+kBLp34+P0OR57sQNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5114
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA0LTIxIGF0IDE0OjM1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE9u
IDQvMTMvMjAyMyA1OjEzIFBNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gT24gNC8xMy8yMDIz
IDEwOjI3IEFNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiBPbiBUaHUsIDIwMjMtMDQtMTMg
YXQgMDk6MzYgKzA4MDAsIEJpbmJpbiBXdSB3cm90ZToNCj4gPiA+ID4gPiBPbiA0LzEyLzIwMjMg
Nzo1OCBQTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gPiANCj4gPiA+IC4uLg0KPiA+ID4g
PiA+ID4gPiArCXJvb3RfZ2ZuID0gKHJvb3RfcGdkICYgX19QVF9CQVNFX0FERFJfTUFTSykgPj4g
UEFHRV9TSElGVDsNCj4gPiA+ID4gPiA+IE9yLCBzaG91bGQgd2UgZXhwbGljaXRseSBtYXNrIHZj
cHUtPmFyY2guY3IzX2N0cmxfYml0cz8gIEluIHRoaXMNCj4gPiA+ID4gPiA+IHdheSwgYmVsb3cN
Cj4gPiA+ID4gPiA+IG1tdV9jaGVja19yb290KCkgbWF5IHBvdGVudGlhbGx5IGNhdGNoIG90aGVy
IGludmFsaWQgYml0cywgYnV0IGluDQo+ID4gPiA+ID4gPiBwcmFjdGljZSB0aGVyZSBzaG91bGQg
YmUgbm8gZGlmZmVyZW5jZSBJIGd1ZXNzLg0KPiA+ID4gPiA+IEluIHByZXZpb3VzIHZlcnNpb24s
IHZjcHUtPmFyY2guY3IzX2N0cmxfYml0cyB3YXMgdXNlZCBhcyB0aGUgbWFzay4NCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBIb3dldmVyLCBTZWFuIHBvaW50ZWQgb3V0IHRoYXQgdGhlIHJldHVybiB2
YWx1ZSBvZg0KPiA+ID4gPiA+IG1tdS0+Z2V0X2d1ZXN0X3BnZCh2Y3B1KSBjb3VsZCBiZQ0KPiA+
ID4gPiA+IEVQVFAgZm9yIG5lc3RlZCBjYXNlLCBzbyBpdCBpcyBub3QgcmF0aW9uYWwgdG8gbWFz
ayB0byBDUjMgYml0KHMpIGZyb20gRVBUUC4NCj4gPiA+ID4gWWVzLCBhbHRob3VnaCBFUFRQJ3Mg
aGlnaCBiaXRzIGRvbid0IGNvbnRhaW4gYW55IGNvbnRyb2wgYml0cy4NCj4gPiA+ID4gDQo+ID4g
PiA+IEJ1dCBwZXJoYXBzIHdlIHdhbnQgdG8gbWFrZSBpdCBmdXR1cmUtcHJvb2YgaW4gY2FzZSBz
b21lIG1vcmUgY29udHJvbA0KPiA+ID4gPiBiaXRzIGFyZSBhZGRlZCB0byBFUFRQIHRvby4NCj4g
PiA+ID4gDQo+ID4gPiA+ID4gU2luY2UgdGhlIGd1ZXN0IHBnZCBoYXMgYmVlbiBjaGVjayBmb3Ig
dmFsYWRpdHksIGZvciBib3RoIENSMyBhbmQNCj4gPiA+ID4gPiBFUFRQLCBpdCBpcyBzYWZlIHRv
IG1hc2sgb2ZmIG5vbi1hZGRyZXNzIGJpdHMgdG8gZ2V0IEdGTi4NCj4gPiA+ID4gPiANCj4gPiA+
ID4gPiBNYXliZSBJIHNob3VsZCBhZGQgdGhpcyBDUjMgVlMuIEVQVFAgcGFydCB0byB0aGUgY2hh
bmdlbG9nIHRvIG1ha2UgaXQNCj4gPiA+ID4gPiBtb3JlIHVuZGVydGFuZGFibGUuDQo+ID4gPiA+
IFRoaXMgaXNuJ3QgbmVjZXNzYXJ5LCBhbmQgY2FuL3Nob3VsZCBiZSBkb25lIGluIGNvbW1lbnRz
IGlmIG5lZWRlZC4NCj4gPiA+ID4gDQo+ID4gPiA+IEJ1dCBJTUhPIHlvdSBtYXkgd2FudCB0byBh
ZGQgbW9yZSBtYXRlcmlhbCB0byBleHBsYWluIGhvdyBuZXN0ZWQgY2FzZXMNCj4gPiA+ID4gYXJl
IGhhbmRsZWQuDQo+ID4gPiBEbyB5b3UgbWVhbiBhYm91dCBDUjMgb3Igb3RoZXJzPw0KPiA+ID4g
DQo+ID4gVGhpcyBwYXRjaCBpcyBhYm91dCBDUjMsIHNvIENSMy4NCj4gDQo+IEZvciBuZXN0ZWQg
Y2FzZSwgSSBwbGFuIHRvIGFkZCB0aGUgZm9sbG93aW5nIGluIHRoZSBjaGFuZ2Vsb2c6DQo+IA0K
PiAgwqDCoMKgIEZvciBuZXN0ZWQgZ3Vlc3Q6DQo+ICDCoMKgwqAgLSBJZiBDUjMgaXMgaW50ZXJj
ZXB0ZWQsIGFmdGVyIENSMyBoYW5kbGVkIGluIEwxLCBDUjMgd2lsbCBiZSANCj4gY2hlY2tlZCBp
bg0KPiAgwqDCoMKgwqDCoCBuZXN0ZWRfdm14X2xvYWRfY3IzKCkgYmVmb3JlIHJldHVybmluZyBi
YWNrIHRvIEwyLg0KPiAgwqDCoMKgIC0gRm9yIHRoZSBzaGFkb3cgcGFnaW5nIGNhc2UgKFNQVDAy
KSwgTEFNIGJpdHMgYXJlIGFsc28gYmUgaGFuZGxlZCANCj4gdG8gZm9ybQ0KPiAgwqDCoMKgwqDC
oCBhIG5ldyBzaGFkb3cgQ1IzIGluIHZteF9sb2FkX21tdV9wZ2QoKS4NCj4gDQo+IA0KDQpJIGRv
bid0IGtub3cgYSBsb3Qgb2YgY29kZSBkZXRhaWwgb2YgS1ZNIG5lc3RlZCBjb2RlLCBidXQgaW4g
Z2VuZXJhbCwgc2luY2UgeW91cg0KY29kZSBvbmx5IGNoYW5nZXMgbmVzdGVkX3ZteF9sb2FkX2Ny
MygpIGFuZCBuZXN0ZWRfdm14X2NoZWNrX2hvc3Rfc3RhdGUoKSwgdGhlDQpjaGFuZ2Vsb2cgc2hv
dWxkIGZvY3VzIG9uIGV4cGxhaW5pbmcgd2h5IG1vZGlmeWluZyB0aGVzZSB0d28gZnVuY3Rpb25z
IGFyZSBnb29kDQplbm91Z2guDQoNCkFuZCB0byBleHBsYWluIHRoaXMsIEkgdGhpbmsgd2Ugc2hv
dWxkIGV4cGxhaW4gZnJvbSBoYXJkd2FyZSdzIHBlcnNwZWN0aXZlDQpyYXRoZXIgdGhhbiBmcm9t
IHNoYWRvdyBwYWdpbmcncyBwZXJzcGVjdGl2ZS4NCg0KRnJvbSBMMCdzIHBlcnNwZWN0aXZlLCB3
ZSBjYXJlIGFib3V0Og0KDQoJMSkgTDEncyBDUjMgcmVnaXN0ZXIgKFZNQ1MwMSdzIEdVRVNUX0NS
MykNCgkyKSBMMSdzIFZNQ1MgdG8gcnVuIEwyIGd1ZXN0DQoJCTIuMSkgVk1DUzEyJ3MgSE9TVF9D
UjMgDQoJCTIuMikgVk1DUzEyJ3MgR1VFU1RfQ1IzDQoNCkZvciAxKSB0aGUgY3VycmVudCBjaGFu
Z2Vsb2cgaGFzIGV4cGxhaW5lZCAodGhhdCB3ZSBuZWVkIHRvIGNhdGNoIF9hY3RpdmVfDQpjb250
cm9sIGJpdHMgaW4gZ3Vlc3QncyBDUjMgZXRjKS4gIEZvciBuZXN0ZWQgKGNhc2UgMikpLCBMMSBj
YW4gY2hvb3NlIHRvDQppbnRlcmNlcHQgQ1IzIG9yIG5vdC4gIEJ1dCB0aGlzIGlzbid0IHRoZSBw
b2ludCBiZWNhdXNlIGZyb20gaGFyZHdhcmUncyBwb2ludCBvZg0KdmlldyB3ZSBhY3R1YWxseSBj
YXJlIGFib3V0IGJlbG93IHR3byBjYXNlcyBpbnN0ZWFkOg0KDQoJMSkgTDAgdG8gZW11bGF0ZSBh
IFZNRXhpdCBmcm9tIEwyIHRvIEwxIGJ5IFZNRU5URVIgdXNpbmcgVk1DUzAxwqANCgkgICB0byBy
ZWZsZWN0IFZNQ1MxMg0KCTIpIEwwIHRvIFZNRU5URVIgdG8gTDIgdXNpbmcgVk1DUzAyIGRpcmVj
dGx5DQoNClRoZSBjYXNlIDIpIGNhbiBmYWlsIGR1ZSB0byBmYWlsIHRvIFZNRU5URVIgdG8gTDIg
b2YgY291cnNlIGJ1dCB0aGlzIHNob3VsZA0KcmVzdWx0IGluIEwwIHRvIFZNRU5URVIgdG8gTDEg
d2l0aCBhIGVtdWxhdGVkIFZNRVhJVCBmcm9tIEwyIHRvIEwxIHdoaWNoIGlzIHRoZQ0KY2FzZSAx
KS4NCg0KRm9yIGNhc2UgMSkgd2UgbmVlZCBuZXcgY29kZSB0byBjaGVjayBWTUNTMTIncyBIT1NU
X0NSMyBhZ2FpbnN0IGd1ZXN0J3MgX2FjdGl2ZV8NCkNSMyBmZWF0dXJlIGNvbnRyb2wgYml0cy4g
IFRoZSBrZXkgY29kZSBwYXRoIGlzOg0KDQoJdm14X2hhbmRsZV9leGl0KCkNCgkJLT4gcHJlcGFy
ZV92bWNzMTIoKQ0KCQktPiBsb2FkX3ZtY3MxMl9ob3N0X3N0YXRlKCkuIMKgDQoNCkZvciBjYXNl
IDIpIEkgX3RoaW5rXyB3ZSBuZWVkIG5ldyBjb2RlIHRvIGNoZWNrIGJvdGggVk1DUzEyJ3MgSE9T
VF9DUjMgYW5kDQpHVUVTVF9DUjMgYWdhaW5zdCBhY3RpdmUgY29udHJvbCBiaXRzLiAgVGhlIGtl
eSBjb2RlIHBhdGggaXPCoA0KDQoJbmVzdGVkX3ZteF9ydW4oKSAtPsKgDQoJCS0+IG5lc3RlZF92
bXhfY2hlY2tfaG9zdF9zdGF0ZSgpDQoJCS0+IG5lc3RlZF92bXhfZW50ZXJfbm9uX3Jvb3RfbW9k
ZSgpDQoJCQktPiBwcmVwYXJlX3ZtY3MwMl9lYXJseSgpDQoJCQktPiBwcmVwYXJlX3ZtY3MwMigp
DQoNClNpbmNlIG5lc3RlZF92bXhfbG9hZF9jcjMoKSBpcyB1c2VkIGluIGJvdGggVk1FTlRFUiB1
c2luZyBWTUNTMTIncyBIT1NUX0NSMw0KKFZNRVhJVCB0byBMMSkgYW5kIEdVRVNUX0NSMyAoVk1F
TlRFUiB0byBMMiksIGFuZCBpdCBjdXJyZW50bHkgYWxyZWFkeSBjaGVja3MNCmt2bV92Y3B1X2lz
X2lsbGVnYWxfZ3BhKHZjcHUsIGNyMyksIGNoYW5naW5nIGl0IHRvIGFkZGl0aW9uYWxseSBjaGVj
ayBndWVzdCBDUjMNCmFjdGl2ZSBjb250cm9sIGJpdHMgc2VlbXMganVzdCBlbm91Z2guDQoNCkFs
c28sIG5lc3RlZF92bXhfY2hlY2tfaG9zdF9zdGF0ZSgpIChpLmUuIGl0IGlzIGNhbGxlZCBpbiBu
ZXN0ZWRfdm14X3J1bigpIHRvDQpyZXR1cm4gZWFybHkgaWYgYW55IEhPU1Qgc3RhdGUgaXMgd3Jv
bmcpIGN1cnJlbnRseSBjaGVja3MNCmt2bV92Y3B1X2lzX2lsbGVnYWxfZ3BhKHZjcHUsIGNyMykg
dG9vIHNvIHdlIHNob3VsZCBhbHNvIGNoYW5nZSBpdC4NCg0KVGhhdCBiZWluZyBzYWlkLCBJIGRv
IGZpbmQgaXQncyBub3QgZWFzeSB0byBjb21lIHVwIHdpdGggYSAiY29uY2lzZSIgY2hhbmdlbG9n
DQp0byBjb3ZlciBib3RoIG5vbi1uZXN0ZWQgYW5kIChlc3BlY2lhbGx5KSBuZXN0ZWQgY2FzZXMs
IGJ1dCBpdCBzZWVtcyB3ZSBjYW4NCmFic3RyYWN0IHNvbWUgZnJvbSBteSBhYm92ZSB0eXBpbmc/
IMKgDQoNCk15IHN1Z2dlc3Rpb24gaXMgdG8gZm9jdXMgb24gdGhlIGhhcmR3YXJlIGJlaGF2aW91
cidzIHBlcnNwZWN0aXZlIGFzIHR5cGVkDQphYm92ZS4gIEJ1dCBJIGJlbGlldmUgU2VhbiBjYW4g
ZWFzaWx5IG1ha2UgYSAiY29uY2lzZSIgY2hhbmdlbG9nIGlmIGhlIHdhbnRzIHRvDQpjb21tZW50
IGhlcmUgOikNCg==
