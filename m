Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49BB7CE1E7
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 17:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344790AbjJRP5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 11:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjJRP5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 11:57:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BADF11D;
        Wed, 18 Oct 2023 08:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697644659; x=1729180659;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vv1QB9oOqwc2IP005IiYNWOUivyeuTXcYERmhgIn7CY=;
  b=YEaNL9rJBbhD998co8zhXkKiqRHTBNmycRtyVbx+dqt0EoT4D0kT0+6D
   1VZnRV8/Oyhjqv0BHUP2Cvh3m/AMO5ra/mQo8XRMoILuUGKCdQfZZgV4i
   SL/BMb5CZV4NKGTk5AmEdK1lctSYTmgvQ3Potyu9MEn4zsEKR5R/7SSm/
   d+M0gXltFX8jpjTczrRZ713q+wI4Z46jufJRThZCBMIOh+RgKvrdeBhmr
   m0ngjytPAaC7PQ0YPqoS2sK7Jgx1pTQAo27gLczJrLb1WZYO0rnOAZvbb
   mVYoWHkUvfEtYI/6TTiQJoTAdiV7dvqUPQClhzMKAB64nRNFoJbtb75ES
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="371104710"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="371104710"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 08:57:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="4415385"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2023 08:56:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 08:57:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 18 Oct 2023 08:57:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 18 Oct 2023 08:57:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHCU1MOPxSDfo+3ADA2d5tIJbPcl0NOnvK1MVS1IM4VHaI4BObfyUxKcS6nZfOw/w55SN24x5T7uDkMU6PlbukNl03idIUS7I6sXLNUigTK8ym1O8vSWIMVj4xpAYfWWX98yhwxj3QWnD1dcFMazujwjhKKs1/jRYIQG9om3zKO+cdkyDCAuvyBsCyCvOuRRoMxudp6D+vciqL/tEdL2OeAeoR36TimOiukO1CpM0k9Yeq5g/WpMqd1TZfqcaONRUonmK67Ks8U3iGjjlUwPuEbp4G2I6lSDNEM4oln5lsdwIo5/ndGkR59ES6+be/Fnw416KZ5VcldwddqhoivQqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vv1QB9oOqwc2IP005IiYNWOUivyeuTXcYERmhgIn7CY=;
 b=dG+0uJWrgh7vQFIPT0tx67ziDFrSNWyzxlaIX6nRaCYRoERxIbzq4e8HtPipq6ol6zFeEfF0C1gO6tPfHJS3yuJLuSD9MPNbPAGUTcdjTUy1Jprv37+cXq1ymyT9pt9WwTjT34kjellGSlcVDsDpP8IEcw17PesujR9Zu7LKJ6G5dYNCtqzqsJL4nWLLAIHXQmI8TKhziCLfcLeh5kWCuS7jy5CsDXqtd/cPWL+EAVtDlPvoGE8w09adqZ00UNm46kRO6ZygVaeFbwtG7hl67Ngf2tOADcCZK+ccOzN7H32k9BmzgHLD0G7I9OqvC17SXIxc0flFZmHZnEWROFBd8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6405.namprd11.prod.outlook.com (2603:10b6:8:b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 15:57:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::809:68a0:d52b:3e4]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::809:68a0:d52b:3e4%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 15:57:32 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "Lutomirski, Andy" <luto@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Cui, Dexuan" <decui@microsoft.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "mikelley@microsoft.com" <mikelley@microsoft.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [PATCH 03/10] kvmclock: Use free_decrypted_pages()
Thread-Topic: [PATCH 03/10] kvmclock: Use free_decrypted_pages()
Thread-Index: AQHaATgZD0SuDFxZpEeGVbvuDaxBvrBPAyiAgACyAYA=
Date:   Wed, 18 Oct 2023 15:57:32 +0000
Message-ID: <11b91e72cb4dff760e387133a970956280ca9e00.camel@intel.com>
References: <20231017202505.340906-1-rick.p.edgecombe@intel.com>
         <20231017202505.340906-4-rick.p.edgecombe@intel.com>
         <3133a1a5-58c0-4b31-89fe-e86ffa12a342@linux.intel.com>
In-Reply-To: <3133a1a5-58c0-4b31-89fe-e86ffa12a342@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6405:EE_
x-ms-office365-filtering-correlation-id: a6019014-8a57-4b45-ff29-08dbcff2f04d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uv6ipUgtJZO9FwP45KAjn9V1aZHKtNiDtIuJDi4rYWtGEoLT9KXjJgFcqjiLX7rq9/g3uSheA2s7t9ndCjvDi3HWoeYJN9FvvaH2LZo0osP5wE55ufHvhdAWCGmEgb++55P2ceH2kszripqZU45KSIBQslJfjtBwfAVwwiyyJ1W/cLk1GfFoDK9qTLFDODtdKFR2YWxRlXurkjmxOsCZP4UYGwE8x/b86dY2BmL0RZereeBiGVvkQ/7vwKTRjGPn7RlpzBaxDg6JfA2qYhzDjqQHpwdNFhdBk0fqpJeYStly7OJtuSOXCHzfT5PBBDa9YG4LlsqqF/ISjFxqsOUrlwOvpbe0Kwel/BO1WUmnyFTJoRyO7pcQPdW8/YQQINfthqdro41AlDzPMU7gKIOQV13RH8T0AaDB5+OuYiEidug1rbfTCyOTqo5TbNMeaYp99cQxyN3bhWjcf5Fb0ougq0zp5MTB0T70jMkOdE3FczXzRy5ZpPkNwDWUuaTGG+8omt8r1Y/xEUycfoE3wv24lodD8PnqoLKM7czGpLAdHnQFkXOTMtvblmNUhi6N+s3OqBa/d5JDY1LROinNuQQRAFwjsHzdGjMbrFZatcZOARRHthhVAzAe4h0saojulyjeZo0tCliqX+8LF179Ha4+HA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(376002)(346002)(396003)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(53546011)(6506007)(478600001)(6486002)(71200400001)(6512007)(83380400001)(2616005)(26005)(4001150100001)(76116006)(66556008)(54906003)(316002)(8936002)(66446008)(110136005)(91956017)(8676002)(5660300002)(66476007)(7416002)(66946007)(41300700001)(64756008)(4326008)(2906002)(38100700002)(122000001)(36756003)(921005)(82960400001)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnFBZE9BNWJvWVU5QzcyYitURG9SMHlzZlZyaldIRlk4WlYxZTAwSGppNldN?=
 =?utf-8?B?TUNJMEVQMDIzYytoc2E1azA1amtsanl5d1BpaXdTWjZOTWNTc2MraDFNem9p?=
 =?utf-8?B?VFFDdks5MUtZUmsvWHdKT20vTUZMSGRhY3poK1Bua0YveHc0VkF0OGdrS0Na?=
 =?utf-8?B?NVY1WVpRRW1DYmprNXB1by9QY09NMkVvMm5veVlUMDVwais4cVl5WURlY1BS?=
 =?utf-8?B?emkybksxZFh0dU96cjhGWjlTaHI1VGFnY1FSRXpQcVBzVW5YMlN5cmRhTmd5?=
 =?utf-8?B?ZlMvYmlsdTlVdjIwQmwwTFFTYnZoTUswdVlWT3FHbFBDUUp4aFdGNTNNUUVK?=
 =?utf-8?B?bXdRV0w0T1N1SHp5MEx1OTc0QVh1UWtycG5jeUFrZkJHSzdZTWVVWHoxSTc3?=
 =?utf-8?B?b3NGbk5UL0t5bnArSFU4cHRuOHI1TFBlQWRFdk1vcHo1V3J3QUxqVHppeDZZ?=
 =?utf-8?B?RjJXUFNMNk45Y25QSVQ5Y1VpWnZ1Q2ZzcDhTbjBoeVlIS0VzWjlacnQ0c1Nx?=
 =?utf-8?B?NkdGVlRiRkVxVkcvUDFQV0I4MVhxRitMN3VRdHB6dnN1bytUQVBBd2QvTGFH?=
 =?utf-8?B?Y25hTThWNkZpR3RsTER3YkFidmdMWWd3L0NtR0RrenFUK1Bsa0RRSDNFc1ov?=
 =?utf-8?B?aWVRVGJDMDFXaDVmVkNrREtjUDBJK0tQamc5YUZ5SVp1OFdKajNTazd6VlZy?=
 =?utf-8?B?cFY3bEJIU0RxTWhkaHlTQTVWR3dBRmJxSEIySk5sUncvbmZiSFI4QkloK3lw?=
 =?utf-8?B?NHlaOFJQQVRqRDl4YU1oVGFKOFR1OVlObmczTDFjSnFlN2tqMnNyU2REWmhX?=
 =?utf-8?B?SDgwUGwxSm9IMy9qUDJxeVpScWt1cXlSSXR6a3RncXljeURDMDhHQlgycStL?=
 =?utf-8?B?V01NSzRzRmxvRGl1Mkdkb0tDYmoxNEdhdVhETEF4dk40My9Fd2FPc1N2VEcz?=
 =?utf-8?B?M0ExalNQM2FITVA4N3pRREhHR2RpS3VCMTMrbVBDSlRvZzBPZEs0Q0hrbDQw?=
 =?utf-8?B?OUg0S0x0aFNjNUhJdzA3SFBJQzJWVUJBa1dxb3lJb2J4UzNCOHQrV0gzV0Qy?=
 =?utf-8?B?MG9STkFhdjU3ZXFJSXYrYVN6bDZrdlVqb0l3RmlrU255TWNHVksvOEVnNWdC?=
 =?utf-8?B?eENpUmxYVERmRlI2RnZYRk1LdkpIK212M3B4Z0FwSU1LWXlHcENsWnF4MVVJ?=
 =?utf-8?B?Z3hsYU1MejNUUHp5MklBbjRnTVNENzc4TFRvL20wRkdORHMvbWh5d0x3bVRJ?=
 =?utf-8?B?T29GKy8rT1JDTW5hNFhCakx5QXFJVGRyd2VMVjU1WFhwR1lNYXBCNXB4NTNm?=
 =?utf-8?B?NHMvdE1yVzBBenlQMGVhRlRkL1BuMGFmQ0h1SnhpUTYxV1FRSVZxQVhvcXZS?=
 =?utf-8?B?TjJlanQzenNUQmxSNzN5NnV3NldLa3VCM1kwZmZWWFpwTWx4Zit6a0dEOGt2?=
 =?utf-8?B?d2lFb0ZuWmlRZytBbHNoM1kvdDl2QTlIalYxamRmOHI2VVdmY2pFWXIrRXVt?=
 =?utf-8?B?KzVYT2pWWW1EVkZJcVl2QW0rcmQvcGFUaEQ5c3Z4NEJWZW9BV3d4TWE5MXoy?=
 =?utf-8?B?WGpUcFNoc1luRnhjYTNVdGJtSGlyU3JwN1BtQ2Vsbm9rZzZYZUxTcmwvZnlr?=
 =?utf-8?B?ZXBaRmNsYy96ZU14b3g2M2FzQjBjYzdVeGVlZ2lUb2Y3NVdWdlpqZDA3NS8v?=
 =?utf-8?B?OEFvZDJyT2l6UWRDcGFKc0NHSFBmczFCaGZrUUp3ZHZpNGpuUkwxVHY5NnI4?=
 =?utf-8?B?cDFFS211QkMvMXIzV29FVFFmRGZ1dSt2MVNqZDFtaWtDSGlWcUpNdW1teUV1?=
 =?utf-8?B?MnJMYjdPallYaURCd0JjQTRoWlFlVFM3Q2d1UjRQUTdES0s1c29FbXpQNDJF?=
 =?utf-8?B?bXFSZWYwUkJodHNnT1ZTVmlDRjhSby9WMzRidyt2ZFRHM2MwS1VLYkNxUzRi?=
 =?utf-8?B?dWtpRUs1Zjg3MnQ3RzNhVG40bUs0QkRDUHhTYzRrV21OSTR6bGszQUtMVmNr?=
 =?utf-8?B?RmdJZVJkWHJZWVRURzROcUdqODZUVVJGNTVkcmpRQlZYU2pzbkN2dXlJZE1U?=
 =?utf-8?B?U254cERsMjB4S1FFQU1vY0ZlSlkrRFZ5UUVlSTVIbWhFWVhYbDN3N2Rub21v?=
 =?utf-8?B?RWcrT0dEb0lVWkJWaGJFKzhmYzN2bUlzV2hZWjRIbllxSndoOVVsMHFBeWF4?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73C7352639028648915C08B26ECBD304@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6019014-8a57-4b45-ff29-08dbcff2f04d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 15:57:32.3299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P+0c8Qw0kUL1xAqAUMJMibsHf5e7/J6PFSnT58qsZxXYTLtvo5lJeZK7FY9GfXEC1USDrFQe38jHskY+umtUH2gay5g5ARvKOckqaK+34U8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6405
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTEwLTE3IGF0IDIyOjIwIC0wNzAwLCBLdXBwdXN3YW15IFNhdGh5YW5hcmF5
YW5hbiB3cm90ZToNCj4gDQo+IA0KPiBPbiAxMC8xNy8yMDIzIDE6MjQgUE0sIFJpY2sgRWRnZWNv
bWJlIHdyb3RlOg0KPiA+IE9uIFREWCBpdCBpcyBwb3NzaWJsZSBmb3IgdGhlIHVudHJ1c3RlZCBo
b3N0IHRvIGNhdXNlDQo+ID4gc2V0X21lbW9yeV9lbmNyeXB0ZWQoKSBvciBzZXRfbWVtb3J5X2Rl
Y3J5cHRlZCgpIHRvIGZhaWwgc3VjaCB0aGF0DQo+ID4gYW4NCj4gPiBlcnJvciBpcyByZXR1cm5l
ZCBhbmQgdGhlIHJlc3VsdGluZyBtZW1vcnkgaXMgc2hhcmVkLiBDYWxsZXJzIG5lZWQNCj4gPiB0
byB0YWtlDQo+ID4gY2FyZSB0byBoYW5kbGUgdGhlc2UgZXJyb3JzIHRvIGF2b2lkIHJldHVybmlu
ZyBkZWNyeXB0ZWQgKHNoYXJlZCkNCj4gPiBtZW1vcnkgdG8NCj4gPiB0aGUgcGFnZSBhbGxvY2F0
b3IsIHdoaWNoIGNvdWxkIGxlYWQgdG8gZnVuY3Rpb25hbCBvciBzZWN1cml0eQ0KPiA+IGlzc3Vl
cy4NCj4gPiANCj4gPiBLdm1jbG9jayBjb3VsZCBmcmVlIGRlY3J5cHRlZC9zaGFyZWQgcGFnZXMg
aWYNCj4gPiBzZXRfbWVtb3J5X2RlY3J5cHRlZCgpIGZhaWxzLg0KPiA+IFVzZSB0aGUgcmVjZW50
bHkgYWRkZWQgZnJlZV9kZWNyeXB0ZWRfcGFnZXMoKSB0byBhdm9pZCB0aGlzLg0KPiA+IA0KPiA+
IENjOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiA+IENjOiBXYW5wZW5n
IExpIDx3YW5wZW5nbGlAdGVuY2VudC5jb20+DQo+ID4gQ2M6IFZpdGFseSBLdXpuZXRzb3YgPHZr
dXpuZXRzQHJlZGhhdC5jb20+DQo+ID4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+
ID4gLS0tDQo+IA0KPiBTaW5jZSBpdCBhIGZpeCwgZG8geW91IHdhbnQgdG8gYWRkIEZpeGVzIHRh
Zz8NCj4gDQo+IE90aGVyd2lzZSwgaXQgbG9va3MgZ29vZCB0byBtZS4NCj4gDQo+IFJldmlld2Vk
LWJ5OiBLdXBwdXN3YW15IFNhdGh5YW5hcmF5YW5hbg0KPiA8c2F0aHlhbmFyYXlhbmFuLmt1cHB1
c3dhbXlAbGludXguaW50ZWwuY29tPg0KDQpUaGFua3MuIFllcywgdGhlIHRoaW5raW5nIHdhcyB0
byBtYXJrIGFsbCB0aGVzZSBmb3Igc3RhYmxlLCBidXQgc29tZQ0KcGF0Y2hlcyBhcmUgc3RpbGwg
UkZDIGZvciB0aGlzIHZlcnNpb24uIEknbGwgYWRkIGl0IGZvciBhbGwgbm9uLVJGQw0Kb25lcyBp
biB0aGUgbmV4dCB2ZXJzaW9uLg0K
