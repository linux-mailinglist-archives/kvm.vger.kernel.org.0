Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D110695532
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 01:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjBNAJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 19:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBNAJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 19:09:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5A6D3;
        Mon, 13 Feb 2023 16:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676333350; x=1707869350;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gLH3Wpbhz8P6F76aHKFXBfMY8wVN+3kBC+Gu/5iTIEk=;
  b=P2rFqllWMVxsm9C3TCCUjvcMnpQ3KSQtD2MYekCWTOYVtJkbiIukerSA
   Bzo9BLKKpEZ0owlVKp1phdgZpr5cvfyhvSOFP4587zBXKnF8g1a11p2Hq
   uNBlWKJmfUL5l+wCOcXCHUwmoSuwe3fvZLaQ64BvY+ketfuMwTiM5Xg+B
   Z04Aw6y+0TIxzAFrg7PIWaEpkynb1qpEP7qNHxgEMyv23KiOUJY+aDsKU
   72Ju3fMczpTitFFSHE+U1siRlmkFxzNinXWXK68QPJt6jT/w/IykSIqs/
   vQnIN9yRpqDWMgDQyVFO18/9A+5Aqd2QvEOJB/CjEXYwPvBgw28Y47KHm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="329662895"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="329662895"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 16:09:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="668973423"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="668973423"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 13 Feb 2023 16:09:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 16:09:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 16:09:09 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 16:09:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHQuwXSDdR+8txs4RE4BjDdkpfbLm9w7si/2aycZIQRmnrRJMuTfk6SnzA7yqyvsguWZw3PByM3+vSJQ5/gxHehhXQg2QWmjiCdGiu0jNesLlHPXPgM48jW8o3rZJ0SSd1GE9Zy68/cRLuAWPm2FLWlVua35xIXYYz2gm+GJcoR4zLzeRJbHWWnptYgn9AUByAISjUIctKtkE03tUoBL5Ne+nn9pJlnAv9Ho12p1JyPsXdi0ZA9ZsHMYodx9jwoox4VZq1U6VVkWg1/BhOGVWmdvXWjB6tjNYXgGO24mkYEAzH4NqImmUZHw1iuwmurKh+7EjXQzGrLqg+5pq7gESw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLH3Wpbhz8P6F76aHKFXBfMY8wVN+3kBC+Gu/5iTIEk=;
 b=FgNTZk8XON5Yn+9Lhw49D7adLPVj7tKiqcKiMRK3sXIM4RBA+J3wXaRgH3GTNcle9SOsqB1iXTDp5cdIMI481Nlet2I49iiqjKKGSlZK4521huMvTXw6gkg9w5SSGBfVu5NghGO4BoqQ+efMAhZ70jFNX4ngQnpIlGM6eogQcukPGkuDTSpdjAg3x20iQPMcMHxwEVenYnZn1HItg++3I7AtkF04zdXrpleOUpR7ESd+3RgRCCozYFO09k5XZvf/yeNuQqD26zYsBjRPBU26g3VbpzT98FAvP8ak3vBctxbbKpBOr1LAzeIUfqQQOIWiIIVHo3s8YzvNYeUocCIsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7177.namprd11.prod.outlook.com (2603:10b6:610:153::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 00:09:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 00:09:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NLNsAgAAwVbCAABingIAAFPCAgAACYoCAAAS0gA==
Date:   Tue, 14 Feb 2023 00:09:05 +0000
Message-ID: <e04d07c83b2bae4d89ba6c70d857cdf14cef8387.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
         <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
         <BL1PR11MB5978F562548EA22BFFD13970F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
         <2d7141b1-1d76-4e67-60d2-471a524c372e@intel.com>
         <8e9238bbcccedfa00e2dbec87e1d77d370911846.camel@intel.com>
         <5803a3f2-72c8-fb1e-9ba3-e52747c990d3@intel.com>
In-Reply-To: <5803a3f2-72c8-fb1e-9ba3-e52747c990d3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7177:EE_
x-ms-office365-filtering-correlation-id: 8e023e7b-647b-44cc-1fa4-08db0e1faf59
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1yG25F17hKPMk/1OgHcOjkvbFjsU7QwW3AK9LBEx7Jx6VnFnhHJgy18DBMwvm7De8idui6WPxqPnOVVBq1EjIl5ugu0VmK/QFOcM6ij9titsMy0PMnWVXplq6TE+FgwWBQbt5n8sRJDxV0NI6qIeoOXDIb6gLxK00q1DwH7Ws+9Q1+eKfKcnwd+pv9A6BGZ1NZWFTNVdd7zJy1K+axxJcUGxdijMpLWcTk/kCuveonmVzKjiHOHuXGUoZyEE1W6QyKayQ31ytP/4BgMVEZxewUJ03DVLDgpCFyRKQ8ovV8mRCGxl975WOy/GIptNJiGKI4mexDJUiwi6Fcc7zx0th6GLuUqT0Pro+ujKTTrTldotD6l4T0k/Dv1EAjLx2F1Sm9U4nxmkil8UQEekL2PmIzx0BM4zgkX4OcZLnl6n8wK/TScih9TNnyGhdt2z5weTIBa1qrXqslGZAJRZzPyyWj4TK+aU763EHP9Jvz1q5RDdnZiZq2IRKZjgkIgyVuDrfkcLELP5OAV0+cBKAZ58P+dxR5q3TuBMXOO9/xmYXa292AWvz9vFG9AtDjXuN/E1wr27fdLP1wzIu4xlloFXz7azxBDyfcJ9MwM3SyF9knDffx8iF4jkilkHvG18yPgTsZ1bjb0VhhzxsW4pAqegOpgkQMQB3809c/aPtnhRRv/fZ8tPkGbRjefYxKKL9dPH14DcqJn5tV10oHN9ctthqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199018)(36756003)(86362001)(122000001)(54906003)(110136005)(316002)(91956017)(4326008)(66946007)(76116006)(8676002)(71200400001)(6486002)(478600001)(2906002)(4744005)(66556008)(41300700001)(7416002)(8936002)(66446008)(5660300002)(64756008)(82960400001)(66476007)(38100700002)(38070700005)(2616005)(26005)(186003)(53546011)(6506007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUZNOCtOQUxtdE42ZDBGU3dNME1XZWtLZVdvR0VEQlErYVpLZGYxNXh6NklU?=
 =?utf-8?B?Zm1NMDRqQk8vVkx3Wi9DalNtMXp1RDRXaDZZQnV3Smw3ZWVWa0hjSU9RM1Yw?=
 =?utf-8?B?N0ZDMCtBMEVQNFAvRGtYWk9YeTU1RVd5Z1FiWTFKbFJQUzdyaVoyRjM5WFNX?=
 =?utf-8?B?YWpxY2Y1NmpoQktlelZzSGtVWVpUNitidVZ3cWlyRisxMUlybHIxK2NSWVRm?=
 =?utf-8?B?MnRUUElidHlBVzdUSDFtU0hUSHhlM1BxdVAvNkVHWGg5RzBkTDNUVmRuUXZy?=
 =?utf-8?B?ZEk4ZytYOCs4bWxFY3hyaHFxV25FdjV0NVdaWWZUaWsxNlZmUFBWMEM4VFRs?=
 =?utf-8?B?NXNLb1RGYVhkSHNILzJ2VTJVTWZrTU5lZXNqeWdXbWN2Z2VrVTU2NUZMOHJm?=
 =?utf-8?B?czJ5c2ozSVFvOVJOak1vMVdnYVVtUy9rUGYxVHlIZDA3V012TGJIbWV0d3ZB?=
 =?utf-8?B?clYzYUNUa1FCb3hhT1VFem9EQm9Xc3MzdFVQYU5aYTh1K3FGeHpZcUZjdHRo?=
 =?utf-8?B?R2cyQUZXUFpkRFpNT3ZlZGprQVgzZWN6WGZNdW9ZendSTE1IMWhUV2k5YjNM?=
 =?utf-8?B?NzhuaG82YkNtK0dZTzQ5Uk11cU55YnpPU2NuSThnOWxES3dodmVuREt5MnN2?=
 =?utf-8?B?TmhuUTJ1bDZVK1IyUlBOMjg3RVUxbHZVYVBSMjMwajNCZDRncUtRQ01OSERC?=
 =?utf-8?B?V0sxWW9uQ1NhRlR2VXB6b1hwaWw1RnFyYzlKYlA0UmFIa1QzcmY1SGFlVTF3?=
 =?utf-8?B?RlhmWkFSclBKUkFSZTBUdEtzczFtS05WQTg5bFZEbjRxZmpBNnNKaGVHNSs1?=
 =?utf-8?B?M090SUFLdFBCc25oeWVOekJOVVdJbHR0NU9OVmNhWUVHdXZBTHBpakVTdStB?=
 =?utf-8?B?MGxkTkV0Ni9OQnJFdyt5YzBUeEx3ZHVXSDNFSjlGdkM3aWNnaGsxbFIxUjk3?=
 =?utf-8?B?d2NzVmZsdTJsckFZM0szekliUFVjcUR5SXMyRTFvQjluUXNqUXBOOFJVVUdJ?=
 =?utf-8?B?ZDRFc09rY3pHRTlFR2ZWZ1RmU05yUFdGdVlBdUFZZEtZd1Y3ZENCckZOcHNZ?=
 =?utf-8?B?TTV6a0VNdVJXbG5OSVZhN3laUFBOZGQ3MjBGOVM2V0k3dmFKUXlGaGw3SWRw?=
 =?utf-8?B?YVI2ZDRXaXMza29UaUVFdyt5NGRqdFYrTkZzY2RkN2lmV0JRN21iNDJVY3Vy?=
 =?utf-8?B?aU5IeXRWbS94eGt0MGdoazIzU1NjcHVRcVZNYmsrVTF5NEx1MWo0NSttZXdy?=
 =?utf-8?B?TThkZ3Fub3lONndwUkdoQXZUK3dtZFppSTVnMmozdjhsSUNFTHNTNkRTVzRX?=
 =?utf-8?B?a2kzTlBvU3ZpQnZHcnlHMHhuV2FGRmljNXM4VnA1WjhwUzBPajFrQXFqZ2JO?=
 =?utf-8?B?cVQ3UGswTWtEb0NZMG5NZkFZM05mV1JNNTFtRVFseTdTQnlXZWVDVnVUWm4v?=
 =?utf-8?B?ellZa3dKd1lsTng5S2FjYjUvbTQzVEYwVVhVWDk2OFZ6RUdyZTF1RTRndHhq?=
 =?utf-8?B?d1NyTVROejluZXEwOWQwRDRqNTNQVlFTSThaVkxRaVp0bmtSRTBtU1Z2bVhv?=
 =?utf-8?B?cmZwYjVDaXRxWW95YnRybFJ3eXM4OWtoRE1SSHZEWDkrMWJ2NlRHZE52bU16?=
 =?utf-8?B?WDIyVHByRm9vY1lLVWVkaitlWDBZaUN2amM1eEUxVkRGNVhBemk1U3ExSmFz?=
 =?utf-8?B?R3FIMnNlY2RTU0plcWIvK1MwSGtBaHU3dDBKMCt4VWlPTGVzUk9TV3lraE5J?=
 =?utf-8?B?dVY4N3o4TFVsU3dWekJIa2lxaG9ZM0I3bVA2N0FLUzc5WWprUGlRZTZiRVJQ?=
 =?utf-8?B?a1VxdC81T2ZnL2k2NUYvNmhBVUJ4bThubnZ3bmhVa2JFQVJTYm8xcURpVEQr?=
 =?utf-8?B?SmM2UlF5ZTlSUXBkMm5ZaXJSK042UHlmWW9sK0JnRGNXQk8vaFlIeFc0Mjdl?=
 =?utf-8?B?MUtWUDAwMWpmUzdYcXJwYW1FRWlWcW40N0xkdXpaYUtvcjNUcUNwd3ZvMUoy?=
 =?utf-8?B?ZG43SmIvSDQ3eWRjTHVxU0E1Y0pTZUd5Z0trYXZ0NGhWbkVEbjV6bzhObDBF?=
 =?utf-8?B?Q2xjKzZZZ1M4akZGMEd6QWVvWG9idmJwMjV6OWtJNUdCcnMwRXlqVTJtTmVl?=
 =?utf-8?B?L3dOQWQ1d2FweG54eFd5a3RBS09ZV0p6SG83bndRdlMzZEZmaGJNb3l0RnNa?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <742A5819C8CFB947B662ED8859194CBA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e023e7b-647b-44cc-1fa4-08db0e1faf59
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 00:09:05.1529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wyCP5kGYuqiKmZbPJsrUBKk+uLh/WV8mHbvBSOcVOeRhXIsUcOB1MrzkVuKRgvYrKVtpDF8fiVEuTTpFEp7aoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7177
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAyLTEzIGF0IDE1OjUyIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMi8xMy8yMyAxNTo0MywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiAoIE15IG1haW4gY29uY2Vy
biBpcyAiUnVuIGFmdGVyIHRoZSBLVk0gaGFuZGxlciIgc2VlbXMgYSBsaXR0bGUgYml0IGhhY2t5
IHRvIG1lLg0KPiA+IExvZ2ljYWxseSwgaXQncyBtb3JlIHJlYXNvbmFibGUgdG8gaGF2ZSB0aGUg
VERYIGNhbGxiYWNrIF9iZWZvcmVfIEtWTSdzIGJ1dCBub3QNCj4gPiBfYWZ0ZXJfLiAgSWYgYW55
IHVzZXIgKEtWTSkgaGFzIGRvbmUgdGR4X2VuYWJsZSgpIHN1Y2Nlc3NmdWxseSwgdGhlIFREWCBj
b2RlDQo+ID4gc2hvdWxkIGdpdmUgdGhlIHVzZXIgYSAiVERYLXJ1bm5hYmxlIiBjcHUgYmVmb3Jl
IHVzZXIgKEtWTSkncyBvd24gY2FsbGJhY2sgaXMNCj4gPiBpbnZvbHZlZC4gQW55d2F5IGFzIG1l
bnRpb25lZCBhYm92ZSwgSSdsbCBkbyBhYm92ZSBhcyB5b3Ugc3VnZ2VzdGVkLikNCj4gDQo+IEkg
d2FzIGFzc3VtaW5nIHRoYXQgdGhlIEtWTSBjYWxsYmFjayBpcyB3aGF0IGRvZXMgVk1YT04gZm9y
IGEgZ2l2ZW4NCj4gbG9naWNhbCBDUFUuICBJZiB0aGF0IHdlcmUgdGhlIGNhc2UsIHlvdSdkIG5l
ZWQgdG8gZG8gdGhlIFREWCBzdHVmZg0KPiAqQUZURVIqIFZNWE9OLg0KPiANCj4gQW0gSSB3cm9u
Zz8NCj4gDQo+IA0KDQpZb3UgYXJlIHJpZ2h0Lg0KDQpXaGF0IEkgbWVhbnQgd2FzOiBiZWNhdXNl
IHdlIGNob29zZSB0byBub3Qgc3VwcG9ydCBWTVhPTiBpbiB0aGUgKG5vbi1LVk0pDQprZXJuZWws
IHdlIG5lZWQvaGF2ZSB0byBwdXQgVERYJ3MgY2FsbGJhY2sgYWZ0ZXIgS1ZNJ3MuICBPdGhlcndp
c2UsIHBlcmhhcHMgYQ0KYmV0dGVyIHdheSBpcyB0byBwdXQgVERYJ3MgY2FsbGJhY2sgYmVmb3Jl
IEtWTSdzLiAgQnV0IG1heWJlIGl0J3MgYW4gYXJndWFibGUNCiJwZXJoYXBzIiwgc28gbGV0J3Mg
anVzdCBkbyBURFgncyBjYWxsYmFjayBhZnRlciBLVk0ncyBhcyB5b3Ugc3VnZ2VzdGVkLg0K
