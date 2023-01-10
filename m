Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA15663751
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbjAJC0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237924AbjAJC0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:26:11 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9316C558A;
        Mon,  9 Jan 2023 18:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673317565; x=1704853565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w4CH/+FsDdl0vCWEAD47qSyLmgYMxYNXW1w+NxT/w4Q=;
  b=ZwvqjYNTyAQFLfLog1OH/kD7N0BNidbRboVdcIIPNGnCfSlyCcSuUzHj
   PbiQ947q77YLWmhcf4w7FQwoVTjNJ9KzWNp88cec0qgmM2nvT2vCt63zR
   vo8tOtd1firxDcO2rBjG2BcFC+N827cT/1rVAoRMH9alMN8KvoDkh+b08
   wpqkYLjwpv56posjo8lGntNqq/IzeAJC7IaUfs5UPd5+iNPjG3nqdfXnS
   STwgZwR3quV0sJZUGZJlAmjP1eROwGV21Q86TM9z4KAyfIutw6GhuXH9u
   9BchxLFRu/pMhsQdmRo3RL9rZ94Ydaw5fOILNdL5qC4U7QO73dnRbNqsb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="320738950"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="320738950"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 18:23:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="780905887"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="780905887"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 09 Jan 2023 18:23:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 18:23:38 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 18:23:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 18:23:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T88abOE+8dDbQQQ+pR3z48Js/iLyZrnFZZG0N9N6a2b9hQ7+X9FA/X/oZJTiTBDZ4YfOTywe06yfWjArof+VVKIiuxEVsuWoZkVpUIUkWUY6q84man7eFxW1zK/9UaDaa3ujC7LBNTKvAlTekMyN5uVKFcVo3EKmOxAGl8xc8eztwsT7aYU3rNNsC+UriSjooG3lbKEBs0QsavLBoEA5EBapxs5yH+wv55rtI21KlSrgYrwx/VmaTOv4y0Tgj+Ub6f6Kp8xH4p7o6q0pcIFgiEKinrvUZmSReZOkvIr3HfKu/6lH23EG1kQtSuQSwR3ICUqRW6X6UiK93ylcjJJHPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4CH/+FsDdl0vCWEAD47qSyLmgYMxYNXW1w+NxT/w4Q=;
 b=kvJtcI2gOR19sCOeeCVU/niYPT9Yyi6hLr3v1ZQJ+Ngls6lDA9h3xEUUmmFwDBh+oGKh6+y23x3vlzxzCrIQwHUs4rHDUfQp7Ck0SmXG4GqPytZ/NrJV23nZKnXBe6ZXNPw+cZQ2O8CqHtr9qAFkpwB97cwWbUC+fm93M9J7NGeVT6F6ajrwsbn7xKWlEN0Bil+xqP2G3evcKdhMxAot1rIAMq3rUCGE29K/e0MFk8Yk4JZAnYmx4rnaHiZB/B1VMRaGs8OIdRuBQrPzvqf+FK2MUUpOPGZ7uEQcBZDmH55V/fRIdaQQE500POlvclOgB+eK2goUOD2bSdlXy49Qjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5314.namprd11.prod.outlook.com (2603:10b6:610:bd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 02:23:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 02:23:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHZC5gPYUqEVXDsYU2zS2Qoxtth0K6R8eiAgAUPNACAAAIIAIAAGroA
Date:   Tue, 10 Jan 2023 02:23:34 +0000
Message-ID: <cba4c7295b157dc5d0d88b73f335899f0aa5a21c.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <ef6fe9247007ee8e15272de01ded1e0a9152be02.1670566861.git.kai.huang@intel.com>
         <c70c30fb-073f-4355-c6a6-052d013a99da@intel.com>
         <81b814f096513e69e3099ab2b54034deadf8d7fd.camel@intel.com>
         <92aba287-c839-8841-a9f7-28a2c0b3097a@intel.com>
In-Reply-To: <92aba287-c839-8841-a9f7-28a2c0b3097a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5314:EE_
x-ms-office365-filtering-correlation-id: 3a463706-4ca4-4d0c-7a23-08daf2b1ac92
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d250vvKQqHUsFEUIrvAlMkhUGaQz7smbnNYIeUw5OnOUO4MH2Z6M7y+Ev4xmUMqSIezaIH+JVnEVp0Qea4ajFDoXxoXJrRP17ZFlfiP1DUpKZeMW8meGU6CNBMC9o2a3orxeVZNS81GLJ0Cm1OwEKFAkrVT83sK0M+W5GIpfyACDqJVqoAZmFCu7ZgsVBfBVDxGO5AR3HL0D1ZRNjbpHf4lfV2Vp1UdkCigR3YjuYeRIYPOT/iLJCI2PBEh+e05+zBACzbWbf4UZlIaRt4WDhk7WWKu/lr9enddIFs4gxNdOACXz0XEBCXYjQ3B2rwPpHw67Mx/7CGmtgWBtJZywWgigKTkpgT3sXzqKfw5bZxlHCUIYm7XB8dmXa0lykL3GZUQwtBjFjb53TIsM4sRcmkkoSBefVKgtmDvscbQ4+Dlgu55cfxxXSB2k/dfRqjB71dMX8YSWiWgY2Lnk4PFYp+8zgmLoLB8OOHg19gljD/jemiXreVL7ixngHmWiYRd38No/gK4NqaG4FUBGfYxOpCu5ob4dnpbVbpvK1rNDR2OfPliWRpAkLKVKIHguwaQf6IkUPUkDYN0XvvILZORxiKpK7zN2Sgn6Qf9ZhdTPfxPHzkI7X/ESfPHN7VTWWWEYat3aNZisb0TQGLza2NQ1fuT3NurSop5J85DDf/9h8B5ffWrNv2kdVXqYzGWajffHiAqJAaJDKq3vLddeg6qKGCes0EfnALxghUifUBH3IcA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199015)(2906002)(54906003)(2616005)(66476007)(64756008)(66446008)(66556008)(7416002)(5660300002)(66946007)(53546011)(122000001)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(82960400001)(76116006)(38100700002)(110136005)(8676002)(41300700001)(6486002)(38070700005)(86362001)(966005)(4326008)(316002)(91956017)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzZNb2hYc3Z2T043akl2N1ZSOUsxSVlva2xDODRuUUNnL3hFcXk0NlRXdlp1?=
 =?utf-8?B?TEtrN3RLK25uTGpua2ZSNlA1bVFwdzBIQ2hWVXVGU2hLd1JlK0pFSitIeDZ4?=
 =?utf-8?B?VUF2aFZKRGVTOFBQaGF0R0xWczJ6ZnBVQzkvUW5XMmYrUzBZOVF6azZTNlBz?=
 =?utf-8?B?WkpqUXBoblZFOTlmcmxvNncxYWZQZzZ6YTlQZi9hWDlPcytINE1pL2tPejJS?=
 =?utf-8?B?ajBHRVh0dGVDR1pSQWVCb0RUTnhhUzZXTXpZVTY0UEFJeDhYTzhlWmJRLzZI?=
 =?utf-8?B?akV4cGljbmdBN0VSQ05OakU4QWkweVdPd2NHdmtWd0hiRHZSMm9lOXMyZkY4?=
 =?utf-8?B?R08ycDNSamtUYTVUcDNxa2xFa2dxMEVsUUZUcXJGTUFSOUl1VUlUdEpFQ2Zw?=
 =?utf-8?B?bkF6QWw5ejlMNHd1QkNvdE0zd1IyQjRPdmpFKzQveitYaXRHWXhsVUpBekcv?=
 =?utf-8?B?SXZmVXFyQWIrRTVRZnpmUWRqeGxPd3JwZ1NUeVJyZFZRdWFFZU5BSU1aNzJB?=
 =?utf-8?B?NUM5RUFZVzhzRHdIcnFSMUhnWlJOR2thaWJzdU4xOEd3dThiaFhqdE1Nb1hk?=
 =?utf-8?B?RWgzLy9QeGt2aDJNRUtQUHBld2lYM0lDZnZGcDh2SjlNWTFjdmFUK1RvOXd6?=
 =?utf-8?B?TmV3dTQvNFVNRFA5c3YzcmVmWFVaZW1WNkdHQWpFZ1JqMi80SE5tQjFUbC9X?=
 =?utf-8?B?aTVhWlFHamY5Ry9OY1RLcGFsY3R2YjZjS1hNY2dJcU9MRUlPY3dXcnZzTHBN?=
 =?utf-8?B?Y2xMWjRlcVdUU2QreHExcDc2OFVHL0VIdWxnRG9yT2xFc1lPRHFMemhVKzg4?=
 =?utf-8?B?WDFzQjBTMjZsTGZ1ZExqV3ZpNGNNcEZ4RzhrbExzOUpNRzZEdmw5R0xUOGRp?=
 =?utf-8?B?aTRtUllETHdpR2pZMzltdGllUkJGWHFhTm42aTFrTEo4VHNVaG8wSkdEWkZL?=
 =?utf-8?B?aE5DNDVvWHpYQ0FMOGtkQmx2Q2N5SS9xQ1lXdUIwVWNVQ0JJSTdyejZoMFlF?=
 =?utf-8?B?UVlpQTZxZ1dhU3psQVgwWG1iU3FYZ2lHWHJHQ0I4RFo5NTJHSHhuL0l5QjJr?=
 =?utf-8?B?a3JjV1RDMXFQY0dnSnlNYlBEL3daaEM3SkRqbnhBK0JKbVFMb2ZqNjdNSjBT?=
 =?utf-8?B?bkY1cGhHUmxYelV6YVRGYS9jbVFzY0YvVEdvaVZ2Q2xteXpWejB4TlYvamRY?=
 =?utf-8?B?UW9pdlZJdmUwdGFNYldtaWRiMU9HTHFZUjRKOHVHYXd0bzhNMmJPaFkrb25y?=
 =?utf-8?B?c21PejlTNEtSUGtOZE82eDhJcnJSTm1ESEhnckRoajYvY2ZTNUYzcWpKaWo1?=
 =?utf-8?B?bzk5NGt5M1diTGhuSXhSRzZnMm9QR29LWTRqLzV6OE5SVmNKa1dGVS9EQ25M?=
 =?utf-8?B?OEpNRE16bklxbnArUE9RT1BLdFlJbHl3dkxESXJRSGp4MVpGUzNqLy9zdWZp?=
 =?utf-8?B?dXk0VEt0MVFjRXdkVUdFR3RxOVJVVlM2eTNoRVdOc1lQek9OTTl2TDExckNG?=
 =?utf-8?B?Y3ZGQURyTURyaVZJQkJpemhTK21DZ0RvdHM1UmtTZnhpcms0VEVDcHQwbnls?=
 =?utf-8?B?Ykt2aFc5Z2VhVjJkVkpnUGdWdzlNei9OZCtFRFJicFlYY2lxNmxSaHpaOEpz?=
 =?utf-8?B?aVFGRGZkeWl0THN1K1ZSMENER2p6R1hZUElkK3loQ2RsNC9OUlpzdW5GV25z?=
 =?utf-8?B?ZUhOQndnclhDZ1FSOXQ0UmxmVTR2ckNvR09mdDBVVWNhVHpaaWVhR0tRaFVU?=
 =?utf-8?B?bHdneFhsR01LZFRuWExaZXNaUXBPd0IrVWRDM0ZnQ2MzZytMaU4wQmtDT1dR?=
 =?utf-8?B?RnJRQUJmQTh4dTFjMWlkNGFMYVJocEt5anZTb0Jyek9oMnR6TG9vZTJUWGdG?=
 =?utf-8?B?VGxkVTZBdVBHQ3RhZGMzcHBjczhJVDZBOTZkaU1XVDFMRlFjTjFUVEEyZ2xT?=
 =?utf-8?B?Wi9tUFFVbllmVDFKdytKVU50NXNYU0xpdG9MRGx6WFFtQWhQQ242QUtlb3Rx?=
 =?utf-8?B?TE9pbm1LZWhuTFhZMHgxRkxycEdOTGVVcUlEeUhxdkxIMVZvMGdYQXhUS25l?=
 =?utf-8?B?N2tDTnJnSnFnS2J5a3hjWDNqUGRnbFppWTVPU0t3RXExQXhvZ0xFWHRTV0x6?=
 =?utf-8?B?b0VlSENoN0dpc2t2Vlo2TUszckUvbUtEVTVlcDVKNHZVWWxvZTcrQldqeTNB?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1019EB539FB4C24EADDB12AA781E6DBD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a463706-4ca4-4d0c-7a23-08daf2b1ac92
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 02:23:34.4604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ix0xz8mfyOBeaOReBPjtMZS/CnDRlS48lWN/I7yd9WDoQWB2L1b9LIbpXcAAhafsE6RarukVXK5F0vtbdHCb6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5314
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAxLTA5IGF0IDE2OjQ3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS85LzIzIDE2OjQwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAyMy0wMS0w
NiBhdCAxMToyNCAtMDgwMCwgRGF2ZSBIYW5zZW4gd3JvdGU6DQo+IC4uLg0KPiA+ID4gQWxzbywg
dGRtcl9zeiBhbmQgbWF4X3RkbXJzIGNhbiBib3RoIGJlIGRlcml2ZWQgZnJvbSAnc3lzaW5mbycu
ICBEbyB0aGV5DQo+ID4gPiByZWFsbHkgbmVlZCB0byBiZSBzdG9yZWQgaGVyZT8NCj4gPiANCj4g
PiBJdCdzIG5vdCBtYW5kYXRvcnkgdG8ga2VlcCB0aGVtIGhlcmUuICBJIGRpZCBpdCBtYWlubHkg
YmVjYXVzZSBJIHdhbnQgdG8gYXZvaWQNCj4gPiBwYXNzaW5nICdzeXNpbmZvJyBhcyBhcmd1bWVu
dCBmb3IgYWxtb3N0IGFsbCBmdW5jdGlvbnMgcmVsYXRlZCB0byBjb25zdHJ1Y3RpbmcNCj4gPiBU
RE1Scy4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgaXQgaHVydHMgcmVhZGFiaWxpdHkgdGhhdCBtdWNo
LiAgT24gdGhlIGNvbnRyYXJ5LCBpdCBtYWtlcw0KPiBpdCBtb3JlIGNsZWFyIHdoYXQgZGF0YSBp
cyBuZWVkZWQgZm9yIGluaXRpYWxpemF0aW9uLg0KDQpTb3JyeSBvbmUgdGhpbmcgSSBmb3Jnb3Qg
dG8gbWVudGlvbiBpcyBpZiB3ZSBrZWVwICd0ZG1yX3N6JyBpbiAnc3RydWN0DQp0ZG1yX2luZm9f
bGlzdCcsIGl0IG9ubHkgbmVlZHMgdG8gYmUgY2FsY3VsYXRlZCBhdCBvbmNlIHdoZW4gYWxsb2Nh
dGluZyB0aGUNCmJ1ZmZlci4gIE90aGVyd2lzZSwgd2UgbmVlZCB0byBjYWxjdWxhdGUgaXQgYmFz
ZWQgb24gc3lzaW5mby0NCj5tYXhfcmVzZXJ2ZWRfcGVyX3RkbXIgZWFjaCB0aW1lIHdlIHdhbnQg
dG8gZ2V0IGEgVERNUiBhdCBhIGdpdmVuIGluZGV4Lg0KDQpUbyBtZSBwdXR0aW5nIHJlbGV2YW50
IGZpZWxkcyAodGRtcnMsIHRkbXJfc3osIG1heF90ZG1ycywgbnJfY29uc3VtZWRfdGRtcnMpDQp0
b2dldGhlciBtYWtlcyBob3cgdGhlIFRETVIgbGlzdCBpcyBvcmdhbml6ZWQgbW9yZSBjbGVhci4g
IEJ1dCBwbGVhc2UgbGV0IG1lDQprbm93IGlmIHlvdSBwcmVmZXIgcmVtb3ZpbmcgJ3RkbXJfc3on
IGFuZCAnbWF4X3RkbXJzJy4NCg0KQnR3LCBpZiB3ZSByZW1vdmUgJ3RkbXJfc3onIGFuZCAnbWF4
X3RkbXJzJywgZXZlbiBucl9jb25zdW1lZF90ZG1ycyBpcyBub3QNCmFic29sdXRlbHkgbmVjZXNz
YXJ5IGhlcmUuICBJdCBjYW4gYmUgYSBsb2NhbCB2YXJpYWJsZSBvZiBpbml0X3RkeF9tb2R1bGUo
KSAoYXMNCnNob3duIGluIHY3KSwgYW5kIHRoZSAnc3RydWN0IHRkbXJfaW5mb19saXN0JyB3aWxs
IG9ubHkgaGF2ZSB0aGUgJ3RkbXJzJyBtZW1iZXINCihhcyB5b3UgY29tbWVudGVkIGluIHY3KToN
Cg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vY2MxOTVlYjY0OTljZjAyMWI0Y2Uy
ZTkzNzIwMDU3MTkxNWJmZTY2Zi5jYW1lbEBpbnRlbC5jb20vVC8jbWI5ODI2ZTJiY2Y4YmY2Mzk5
YzEzY2M1Zjk1YTk0OGZlNGIzYTQ2ZDkNCg0KUGxlYXNlIGxldCBtZSBrbm93IHdoYXQncyB5b3Vy
IHByZWZlcmVuY2U/DQoNCj4gDQo+ID4gPiBJZiBzbywgSSB0aGluayBJJ2QgcHJvYmFibHkgZG8g
c29tZXRoaW5nDQo+ID4gPiBsaWtlIHRoaXMgd2l0aCB0aGUgc3RydWN0dXJlOg0KPiA+ID4gDQo+
ID4gPiBzdHJ1Y3QgdGRtcl9pbmZvX2xpc3Qgew0KPiA+ID4gICAgICAgc3RydWN0IHRkbXJfaW5m
byAqdGRtcnM7DQo+ID4gPiAgICAgICBpbnQgbnJfY29uc3VtZWRfdGRtcnM7IC8vIEhvdyBtYW55
IEB0ZG1ycyBhcmUgaW4gdXNlDQo+ID4gPiANCj4gPiA+ICAgICAgIC8qIE1ldGFkYXRhIGZvciBm
cmVlaW5nIHRoaXMgc3RydWN0dXJlOiAqLw0KPiA+ID4gICAgICAgaW50IHRkbXJfc3o7ICAgLy8g
U2l6ZSBvZiBvbmUgJ3RkbXJfaW5mbycgKGhhcyBhIGZsZXggYXJyYXkpDQo+ID4gPiAgICAgICBp
bnQgbWF4X3RkbXJzOyAvLyBIb3cgbWFueSBAdGRtcnMgYXJlIGFsbG9jYXRlZA0KPiA+ID4gfTsN
Cj4gPiA+IA0KPiA+ID4gTW9kdWxvIHdoYXRhdmVyIGZvbGtzIGFyZSBkb2luZyBmb3IgY29tbWVu
dHMgdGhlc2UgZGF5cy4NCj4gPiANCj4gPiBMb29rcyBuaWNlIHRvIG1lLiAgV2lsbCB1c2UuICBB
IHNsaWdodCB0aGluZyBpcyAndGRtcl9zeicgaXMgYWxzbyB1c2VkIHRvIGdldA0KPiA+IHRoZSBU
RE1SIGF0IGEgZ2l2ZW4gaW5kZXgsIGJ1dCBub3QganVzdCBmcmVlaW5nIHRoZSBzdHJ1Y3R1cmUu
DQo+ID4gDQo+ID4gQnR3LCBpcyBDKysgc3R5bGUgY29tbWVudCAiLy8iIE9LIGluIGtlcm5lbCBj
b2RlPw0KPiANCj4gSXQncyBPSyB3aXRoIG1lLCBidXQgSSBkb24ndCB0aGluayB0aGVyZSdzIG11
Y2ggY29uc2Vuc3VzIG9uIGl0Lg0KPiBQcm9iYWJseSBiZXN0IHRvIHN0aWNrIHdpdGggbm9ybWFs
IGFyY2gveDg2IHN0eWxlIGZvciBub3cuDQo+IA0KPiANCg0KV2lsbCB1c2Ugbm9ybWFsIGFyY2gv
eDg2IHN0eWxlIGZvciBub3cuICBUaGFua3MgZm9yIHRoZSBpbmZvLg0KDQo=
