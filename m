Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF08C6B87E9
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 02:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjCNB6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 21:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCNB6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 21:58:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD033559FB;
        Mon, 13 Mar 2023 18:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678759086; x=1710295086;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KA2kgASpgm0Dv4j7Pcjt2+2AhbyPnv816A4G2mdihYY=;
  b=Oa+XDkgkTAORDZiQuy1cqwXptJvvjEQOXxXQb6XZA/nCncH7+o/h6krK
   4W+kkc7itiqHqXY3hN/v9K8q08a40ZP56A6lXcmxlyVlq2p9vhYhGUYYy
   wxj96Fv33c9//ATFjXbXholQlmd5HdOHOK07BXu7vTW0WomE8oubGGEnR
   GUOwrUvJaSAMyrYgw7xkYc35WlwHQ+yqAKnX9/0/go1bXm0b3OUE0WA/D
   DWXNW6BPh1xqsXZATxFKP6qGTg4yIisCUE26OQoGhqEONHdC+exs9O9sM
   VXKPRAvHyQu4eS5REt6ZOZS8B1gDtdehZXYZsJlOPoxvDo9Vm8LGVB9E4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="321159009"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="321159009"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 18:58:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747826008"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="747826008"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 13 Mar 2023 18:58:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 18:58:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 18:58:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 18:58:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbQm/xFp3Jy9Rt+CfFQul+6re2Cbufs4dyMlm+86AoR3W9QwDw1pe7DWaGWYxu3YOuBxKSose33V85Wcpo8jUxGtYJXlFWk2rrs9g0hThXWVbs726pD5eThYCwilbHrulfGdVwoducx/wuaudTCsaWgNy30DjTNZPa38UgDsghonY5GczD0D666q5wtRudvOBcab5wrXVZ+wrwLla3jWYgu2qK1XR7D8q+61s44vgLgw1VnLT4Y1tKpFd6BBIE3dFDhV8FY1EeZMbAwI1yvbI0gaDgt9+QNvqXLgVUEF5xKQ/h8Nm1JDZmh67Qs663H2C8cVrbZBg9NjuyKIqKdPNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KA2kgASpgm0Dv4j7Pcjt2+2AhbyPnv816A4G2mdihYY=;
 b=cUvud/tSTbp6s9xwThCghb2/FNVuA8igrrqaEVwEKbb1RODp5aT1dnrbgFrq26Z/hzBrtl2To8CwvCob0rc7r5cnV8eX7A1hZoOZ1TlF+wPS4FsJ9Gj4ZIk0eq1UuZClpkOt6nEBwpG4pDdpI9W92trCmo6MXONZjZSC18j6w/A1G9thxuucEqGfixVtcklmcqtQhp17zbnXV0JiiVpFULp164sV2PH9vcZ5thae0KPM6fyFSoBTwknhja7spoh8+yGcEUhFjo8N6JP3vGH81Bv2pMNIg2en0dQrTxZE9T0gKpdTg7k1QQ1ajBFDctwWo47ysd2Sb6FKJdbODEv0IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 BN9PR11MB5354.namprd11.prod.outlook.com (2603:10b6:408:11b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 01:57:57 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6178.023; Tue, 14 Mar 2023
 01:57:57 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: RE: [PATCH v13 002/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Thread-Topic: [PATCH v13 002/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Thread-Index: AQHZVQwyPtweEeflQU+AdyzJJ/rB6K74yaGggABC0gCAAHG2UA==
Date:   Tue, 14 Mar 2023 01:57:57 +0000
Message-ID: <DS0PR11MB63737EC24D2DC4EC871B8670DCBE9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <e4d32af22f0a540c62fffaa17fe478a723e109ea.1678643052.git.isaku.yamahata@intel.com>
 <DS0PR11MB63735A7EEC68894923925ECEDCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20230313184024.GA3922605@ls.amr.corp.intel.com>
In-Reply-To: <20230313184024.GA3922605@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|BN9PR11MB5354:EE_
x-ms-office365-filtering-correlation-id: 4d83850e-3a73-45ca-47ed-08db242f8886
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h3w1/J4ghKgkcINfzmwet8wRawqRwoVJ3lGhxkNBeFS4F5J+8aaeK4zw4vMpIrHDCjwuYZCLD2dW7HL/OWpGg81mbwThpM7XfDEjoZT+2QSLBwViY0JPxHxfzGRuI/gnFtTNHQYrlGlHdEhsuuCfZkzdtRVJoULtBY29sHkOsou/v6za9QD7RLHsnP7oTYfYeQqCujQ0XZdsC/RNnxM9AD2t9ieVsyExoyun0AyVR/Jako10bs7ajbDoOFLoEOIoB/5H/vYy516EF76skWB6+PBVQ4iSpVBhszVXcoPZidJfhoaNR4CvqB82Pi7OEXDAUVXqFkF/cYoERbkFKUUEnuVAoex+UdTaP9zhSU2Rs2iNyK/zEJgbJtcPwL0o6Xio3dkt6D0zIMdj9XrnBlJOEQJNY3fWTFxYfYgXdgTHSi4CjulTWsESTbjlrCRGo8bjmMX9VAoZ92CSZz2BAvsmR4xn9fEHCvb3mm21L++taUgtjtOAxE3EXopYtd1vC2yFQGmHYvQXhTsc2kGQMIDel4xyY6t87s11JVpB5+TYjBQHWWCcSx7L4DoNkHnhCyt/kIV4P2v1zW50jCet08QkfMf+BvPR/vjChXpjRZpJ0C49kRW+LsgNA3dEHJBfsShvi78UWsagevI+5q9jY/UI1QvCWWkeCGyYEg/X5xobFmqzQqUr6B9QRo/ksBSh3UdDW2yyPB7fW6egqhuHvNtJRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199018)(86362001)(38070700005)(33656002)(52536014)(8936002)(41300700001)(2906002)(5660300002)(4326008)(6916009)(54906003)(478600001)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(316002)(8676002)(83380400001)(38100700002)(122000001)(55016003)(82960400001)(53546011)(9686003)(6506007)(26005)(71200400001)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3ZSaGgrNk9pRnI5ZndCQ3FsYlpiK2ZHbVh5WndBY3VnOWJCWnY3TUhPa0ow?=
 =?utf-8?B?OTcwK3pUMFp1TjhTUFBrazRsajRLRnNJNzQ1Tk5UREVSb3VjMml5WFU2TWZT?=
 =?utf-8?B?L2gwSG16NUE0Wnl5bkwrL1ZqTHhSTkptcGFtSnQzeXZwYjZFNjJYMU9GYjdn?=
 =?utf-8?B?Q3hXajdNSFRYT1BSb01DTEN1K0xnNFI2OFQ2VzdkeTlyQStzTzVNeHJqVmx3?=
 =?utf-8?B?bGt5RTVvVU9EbjhvZ3U2SkVXaTBrYXBvTExWWFFPdC8vbkxUOFZiSUVORExo?=
 =?utf-8?B?dWJ4N2lUalVmb2pqeXd4NWhWeHhCd1c4STdQSkR3TVIvYnF0M3hTZUhkZnFX?=
 =?utf-8?B?bk9QQVp4QVhxY2lqMlpQd2ZOT2xnd3Z0azF2REloVnkvMlJvaWV4QlFMbmhT?=
 =?utf-8?B?dkVhTW9qK09GUGFrYlZpUXlUL2JTdkRXZ2Z1ZDJNaWJHVWIreTY2SmhLME4r?=
 =?utf-8?B?TW1EKzJwWDhURnRHT1RKME1oclkrKzJ6NStyM0xVTklzTWdPSXA4eGRIaGdI?=
 =?utf-8?B?Y2hnUVBiVG51aU95OFZQTmtXWXp0bTMwUFJ2VlNqRVlMQWkwSi9DUmxxWmxY?=
 =?utf-8?B?Q2syK1ZFMERwMmJuTjdOeWV2TERJcE81YTg4Yk9oOG1MWFIzcnAxYmtsQm1N?=
 =?utf-8?B?bHBzRHlxZHdib2s1VGdzeUd3UHViajdWMHlhMXdqMTVRbkdQVDFYNUlCUXJ4?=
 =?utf-8?B?SmhFT0JHamRSbkhycndBTWdlNkVFKysySW5keVpVWVByV0tUWDNWZXdibno0?=
 =?utf-8?B?Q1VPcXVjV3cySVpwS1JPNXViS3R1TzcrSmtqa3JZdk51aUVNc2VHcktiLzFN?=
 =?utf-8?B?TW0wMDZZYTZCRVo3cnhGQjhiRXhnMkFKRjM4SW82Zzg0bDFVdjJpbktMZmhD?=
 =?utf-8?B?dTZnbHhHcTJ3WFB1Wi9renE0SFVxNVlNanVwTXNDMkhhcmJtWExaanlPQTMw?=
 =?utf-8?B?ckN0dlk3OUxxeVhMWWhxSVkvN0xBYU1rMWFra2kybDVxcmZsSDBySG1yeWMz?=
 =?utf-8?B?VE9lbHJDNGpkTjB4TlllYkoxb0FXRFVSeWZrb0gzaWt4QXpVQW1Nd3k5NTBQ?=
 =?utf-8?B?QVZ5QzJzTXg4L1UrSWcyTlpoVTc2TDQ0NzNycDF0Nk12bmZ4Y3VncjFRMWtS?=
 =?utf-8?B?dW5GVEp0VHQzellhWjFaSWMvc3d6Sk1RR1luVVJNYTV6dFVWSHJlemE2a1Bl?=
 =?utf-8?B?Z3NZcERSNzhWT01hRFRrb2hiL1BHNlVWUkxVbUk4ajY1Ymg0Qk1pNklsMWpl?=
 =?utf-8?B?bmVPM2NQRjdGdldaNnlqM1lXS0htdEtTVnRjT0U5R3VBNWZmUmNReFdjMW1N?=
 =?utf-8?B?L2NoL1pSTUprZVNGUFMwQlA5TzBya09wMkUyQXFtVjd2T1pIOTZ3eDRJa0xh?=
 =?utf-8?B?UDlaZkRqM0ZJUWoxOVgyT05hM0NHKzFHdGlsamRrSk9oZjRkMHBIcUsraHdT?=
 =?utf-8?B?eEJPalNBcDBJZzBnUEQ4Y3hEazNqazNSOWpHRkM4dUdQd21MeHRvTXpTeGZt?=
 =?utf-8?B?L3RHcndHRm9xMjNjM3M4cW4rOFpEc3g1OUxkUnkyR2dKWk1oSnA1eEJEWUhH?=
 =?utf-8?B?dGtmbDc4bzRrTjZYQTVJSHMrWi9ReE5GV3VDQmJVR2ZlRjk4aG9EL05KQXQz?=
 =?utf-8?B?eTc3L0x2V3k2dWFHZW9CMVlQZkwwSEhSYXR2ajI1Snd0bm16eDVDVlpyMjFs?=
 =?utf-8?B?VmRLWlJIb3ltOG9RRFNqK1JMbmFtUnhMbFNubDd5N09QYlk1RjY5MVA4Ynhw?=
 =?utf-8?B?VFlDdXk5MHc2dDdiTzgvTnQ5djI4WnRVeEpxVVlKOWFsMkgyaGtDbGJmTnVE?=
 =?utf-8?B?UkhWYWZWbXc0VnkyNGlFYjBCWTFjRlFjU2JYL1JRbHFzZldQYlZFMEp1dlhP?=
 =?utf-8?B?Nm1ERWpURzV6dWJ6dlRYbDdiSDh3SHRIdVRlUElBU2FiVm0yb01DNXhsS0xY?=
 =?utf-8?B?NHdvN3poUit2b3JyVllrU1VuVHZZOVY4V2VudFRNSUlETDZnUlJORWpEeXRi?=
 =?utf-8?B?T2hTSmlBeFJwTmpsYWZwNEIvQXM2RU9xTjE2WHY4V2NkaDlBN2lVd0NiNFBR?=
 =?utf-8?B?MlRiNGlhUXh3YjBUWWRPeGJDYzVEY09ucXQ3MTNxWVJIYUxlTWRDb2xDeDRr?=
 =?utf-8?Q?PTwLPn1f/iNKQK0RkswrPv+zr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d83850e-3a73-45ca-47ed-08db242f8886
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 01:57:57.5465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B40pel+WBhTTRV11/vZukEDFd2967nZuS3jm9aQHFFtvXD1Ms9fcLeIV+m7G4c8NnwQhlC0iW7F6HCXNTKg4Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5354
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlc2RheSwgTWFyY2ggMTQsIDIwMjMgMjo0MCBBTSwgSXNha3UgWWFtYWhhdGEgd3JvdGU6
DQo+ID4gSSBoYWQgYSBwYXRjaCB0byBmaXggYSBidWcgaGVyZSwgbWF5YmUgeW91IGNhbiB0YWtl
IGl0Og0KPiA+DQo+ID4ga3ZtX3g4Nl92ZW5kb3JfaW5pdCBjb3BpZXMgdnRfeDg2X29wcyB0byBr
dm1feDg2X29wcy4NCj4gPiB2dF94ODZfb3BzLnZtX3NpemUgbmVlZHMgdG8gYmUgdXBkYXRlZCBi
ZWZvcmUgY2FsbGluZw0KPiA+IGt2bV94ODZfdmVuZG9yX2luaXQgc28gdGhhdCBrdm1feDg2X29w
cyBjYW4gZ2V0IHRoZSBjb3JyZWN0IHZtX3NpemUuDQo+IA0KPiBUaGFua3MgZm9yIGNhdGNoaW5n
IGl0LiAgV2l0aCB5b3VyIHBhdGNoLCB2bV9zaXplIGlzIGFsd2F5cyBtYXgoc2l6ZW9mIHN0cnVj
dA0KPiBrdm1fdm14LCBzaXplb2Ygc3RydXQga3ZtX3RkeCkgZXZlbiB3aGVuIHRoZSBhZG1pbiBz
ZXRzIGt2bV9pbnRlbC50ZHg9dHJ1ZQ0KPiBhbmQgdGR4IGlzIGRpc2FibGVkIGJ5IGVycm9yLg0K
DQpUaGlzIHNlZW1zIHRvIGJlIGFub3RoZXIgYnVnLCB3aGVyZSBlbmFibGVfdGR4IHNob3VsZCBi
ZSBzZXQgdG8gZmFsc2UgaWYgdGR4DQpmYWlscyB0byBiZSBlbmFibGVkOg0KDQpkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCmluZGV4
IGQ2YTlmNzA1YTJhMS4uZWYxZTc5NGVmYjk3IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3Zt
eC90ZHguYw0KKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KQEAgLTQ1NTIsNiArNDU1Miw3
IEBAIHN0YXRpYyBpbnQgdGR4X21vZHVsZV9zZXR1cCh2b2lkKQ0KDQogICAgICAgIHJldCA9IHRk
eF9lbmFibGUoKTsNCiAgICAgICAgaWYgKHJldCkgew0KKyAgICAgICAgICAgICAgIGVuYWJsZV90
ZHggPSBmYWxzZTsNCiAgICAgICAgICAgICAgICBwcl9pbmZvKCJGYWlsZWQgdG8gaW5pdGlhbGl6
ZSBURFggbW9kdWxlLlxuIik7DQogICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCiAgICAgICAg
fQ0KDQo+IA0KPiBvcHRpb24gMTogSWdub3JlIHN1Y2ggd2FzdGUuIFlvdXIgcGF0Y2guIFRoZSBk
aWZmZXJlbmNlIGlzIHNtYWxsIGFuZCBpdCdzIG9ubHkNCj4gICAgICAgICAgIHRoZSBlcnJvciBj
YXNlLiBMb2NhbGx5IEkgaGF2ZSB0aGUgZm9sbG93aW5nIHZhbHVlcy4NCj4gICAgICAgICAgIHNp
emVvZihzdHJ1Y3Qga3ZtX3ZteCkgPSA0NDU3Ng0KPiAgICAgICAgICAgc2l6ZW9mKHN0cnVjdCB2
Y3B1X3ZteCkgPSAxMDQzMg0KPiAgICAgICAgICAgc2l6ZW9mKHN0cnVjdCBrdm1fdGR4KT0gNDQ2
MzINCj4gICAgICAgICAgIHNpemVvZihzdHJ1Y3QgdmNwdV90ZHgpID0gODE5Mg0KPiAgICAgICAg
ICAgSSBzdXNwZWN0IHRoZSBhY3R1YWwgYWxsb2NhdGlvbiBzaXplIGZvciBzdHJ1Y3Qga3ZtIGlz
IHNhbWUuICBUaGF0J3MNCj4gICAgICAgICAgIHRoZSByZWFzb24gd2h5IEkgZGlkbid0IGhpdCBw
cm9ibGVtLg0KDQpObywgdGhlIGFjdHVhbCBhbGxvY2F0aW9uIHNpemUgaXNuJ3Qgc2FtZS4NCllv
dSBkaWRu4oCZdCBnZXQgZXJyb3Igbm90aWNlcyBiZWNhdXNlIHRoZSBrdm1fdGR4IGZpZWxkcyBh
cmUgc3RpbGwgbG9jYXRlZA0KaW4gdGhlIHNhbWUgcGFnZSBhcyB0aGF0IGFsbG9jYXRlZCBmb3Ig
a3ZtX3ZteCwgdGhvdWdoIHRoYXQgcGFydCBvZiBtZW1vcnkNCmlzbuKAmXQgZXhwbGljaXRseSBh
bGxvY2F0ZWQuIElmIGt2bV90ZHggc2l6ZSBncm93cyBhbmQgY3Jvc3NlcyB0aGUgcGFnZSBib3Vu
ZGFyeSwNCnlvdSB3aWxsIHNlZSB1bmV4cGVjdGVkIGZhdWx0cy4gT3IgaWYgdGhpcyBwYXJ0IG9m
IG1lbW9yeSAoaWxsZWdhbGx5IHVzZWQgYnkNCmt2bV90ZHgpIGxhdGVyIGhhcHBlbnMgdG8gYmUg
Z2l2ZW4gdG8gb3RoZXIga2VybmVsIGNvbXBvbmVudHMgdG8gdXNlLCB5b3UNCndvdWxkIHNlZSBy
YW5kb20gZXJyb3JzIHNvbWV3aGVyZS4NCg0KPiANCj4gb3B0aW9uIDI6IEV4cGxpY2l0bHkgdXBk
YXRlIHZtX3NpemUgYWZ0ZXIga3ZtX3g4Nl92ZW5kb3JfaW5pdCgpDQo+ICAgICAgICAgICBzdHJ1
Y3Qga3ZtX3g4Nl9vcHMgaXNuJ3QgZXhwb3J0ZWQuICBJdCB3b3VsZCBiZSB1Z2x5Lg0KPiANCj4g
b3B0aW9uIDM6IEFsbG93IHNldHVwX2hhcmR3YXJlKCkgdG8gdXBkYXRlIHZtX3NpemUuDQo+ICAg
ICAgICAgICBzZXR1cF9oYXJkd2FyZSh2b2lkKSA9PiBzZXR1cF9oYXJkd2FyZSh1bnNpZ25lZCBp
bnQgKnZtX3NpemUpDQo+ICAgICAgICAgICBJdCdzIGNvbmZ1c2luZyBiZWNhdXNlIGt2bV94ODZf
b3BzLnZtX3NpemUgaXMgYWxyZWFkeSBpbml0aWFsaXplZC4NCj4gDQo+IExldCdzIGdvIHdpdGgg
b3B0aW9uIDEoeW91ciBwYXRjaCkuDQoNClNvdW5kcyBnb29kLg0K
