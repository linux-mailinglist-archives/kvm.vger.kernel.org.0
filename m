Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D3736026
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 01:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjFSXgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 19:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFSXgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 19:36:04 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BC1AF;
        Mon, 19 Jun 2023 16:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687217763; x=1718753763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ICjngSvyFvrHiB+wZemLXqZudMOwH26rY8mCWZXaD20=;
  b=aSBCLFLjahZlj38VJlemjeIf5gfk2OXpi96GHFZ6JfA/1XoV46h4y10W
   yZ98GK3Vl7x5i7MbOUVL4EFyC4ljF0dveOg432XEam4HmkFzMrPd4GTYo
   /GLbxl2X+NMA2w6WAoAluSxZ+e6oHmM06C65JYwVdOYWY776srBYFw04L
   kb907pGjSwBCHKqxTY4+viw+7VkLYKMsg5ltLBCqjrYQL+PwMoSbOtdCN
   jL31qzoor4MX4ZZCJBq3Ay/FWQBJiJdptsUWSWNYDVIR78KYwKedeT28k
   lICOupRxsnXk5Hoc5OQjmOnReVJPux81NJ1WLSjDBbGw26OJggpNA7B+I
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="340070522"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="340070522"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 16:36:02 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="747787461"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="747787461"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 19 Jun 2023 16:36:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 16:36:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 16:36:01 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 16:36:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmSm45Ms1TQa9VQe1mjwXCQCjr1Dd2uFPWaY9WVI7wJDNY5sbMfCFbB5b3U9At3glI1N2rdP7Lp6daaik7zCQ97JFQ2gkkSuDfnMVKckhWJ5tTerkNQWqyrIYG4JMZWYc7M9EJIESLjPQ2ITbApQ//3/YmrO77hAgrgz9ca9nuUDu5kidkmthnsSJ53e887f0H7FvIeCC6ZsTF4lVikulSUMdZ1suK93H//NAu854sC6J5414VpG+nxuKfCyVG11xRuUmCaBs6z5kQIrrjfQhxsE9EuB7BVrYtmSM9Tfb2bt6BUM9TCg31MD+cPD/qpHKS0o8V5M3fbpXIy66+h6Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICjngSvyFvrHiB+wZemLXqZudMOwH26rY8mCWZXaD20=;
 b=AMpw+WM+GZGYHE23MTr+eTZUdEAnFU/mCqRCvB0zUw1K3VrS+y/l07zJkukQnYsDQXxsmepuMPREXmB/Et2pIXFpNurgTdEGofm8RR2uhfuf1Bt/onVxwLR9G0qeSL+3BLDtOVTvjdsSCoIiOF6YbpWaFN68d0bO+xtS6QSxs7JlhOClH0/kYwUqOY7hgMR9NVBWCNGMy4fZCQfMsKKfuIwpvedcTQz90k5Yd+k+NCR60TSgBMPAG82V/URRwDnavdyq8fHEA62BXK+5yI3bUwwyK608JZ0PrpMHsLqKW/mwCIHXj1ndX74x2t3dWTFElSef66SmD6nWrrU2apt7Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5874.namprd11.prod.outlook.com (2603:10b6:806:229::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 23:35:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 23:35:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCACt3UgIAALtiAgAAEVYCAAJPKgA==
Date:   Mon, 19 Jun 2023 23:35:52 +0000
Message-ID: <3a3199b09e86cb4699a13f392842736b482831e3.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
         <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
         <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
         <20230619144651.kvmscndienyfr3my@box.shutemov.name>
In-Reply-To: <20230619144651.kvmscndienyfr3my@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB5874:EE_
x-ms-office365-filtering-correlation-id: 987c7bcb-bb18-4fce-f71d-08db711debd5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ybJnBvZe03lIe5uEbq4RGRH5iEDWw5YZUZgfWyr+rFhlYb5nMH6yQZGPg2tXUBIX+v41ZaRmWwlcAyB4HN4zOjqhTEoC9zZuCDyrJu7LQzDEZOuRQtZCt7iN4GERbHBLviG2Gz3q2SV6d8kWmecky4wpsknCLEcJfnNzF5DzgitlqvoaetFBwqAx/jTDYTNhsiFl1BXWBIENLpuDGuN947M/9JgU5KR74ZmbDCg+JBURKAy+uZUdCn8bBek/HC7IzTPOviddKZsJ+mfgK8VPu+t/x+1eflQkEqLkF5bLlfS+i75f6scwrwISaHuIPIT9EKSWyqsWU0B1xrMOYxOjNoIx8172mftAn9pl6IDDqNeI8ybBmn0dnEDt3C8f0D0lqZpM33USMBd6B62SkQ/jAor5lApYpE8ES6kiTlXtvYYPE8aMKtRtHtL4eqpP6cowsUDcbjZMCc5eOHi0YKY+lwbRk9o93pXSXBhhIm/nE0Q3fIakHKKXSM1zVwcnGMWQjhmLPd86KDtVYQd8+9Mz05ne2rEUx9G7ygDjZaJoP08n/UtpMojKjmqEkviUxqOgM1LSColhVO7Ayv10scnfvEcSN5Zask57q/ZZixwosbOWfO0NVU5iwsdDCGosturt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199021)(122000001)(7416002)(82960400001)(83380400001)(38100700002)(86362001)(41300700001)(8936002)(38070700005)(8676002)(5660300002)(64756008)(66556008)(66476007)(66446008)(66946007)(316002)(2616005)(6506007)(53546011)(6512007)(26005)(186003)(6486002)(76116006)(6636002)(478600001)(110136005)(91956017)(4326008)(54906003)(71200400001)(2906002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXlVTURPZGtsUFF5Y1YwUEVUTS9DUndyT1hZdjNrNHMwWUNoWlU3M1dzK0pG?=
 =?utf-8?B?SjdVQ0ZuQjJianZUaXpmNEk0OFl3djlqcXJkdHVETHV6cm94OTJ6WThlZ1RM?=
 =?utf-8?B?ZXllK2EvZzdXZk9udjRnWTYyVXpyazRkWWNJQjRlNzlqdHFsdWpmSS8xaXl3?=
 =?utf-8?B?NmZhcUlPTEdHN3V0R09MU2xGaFg0b1lPTjdvSXIvV3pRZE1rTjNoWjZ0eCsv?=
 =?utf-8?B?eGc0ZWlsMzRrK3RRMTM5ZVJqaWdDTXJGVXRnU0xRQ25McHp1c2RNZnBhSTJ2?=
 =?utf-8?B?ZnhHVXVMM1ZSeU8vK0tUSDFFbm9UWHNmOW5HQlYzd3VCZ0tYVVcxakdLbVk0?=
 =?utf-8?B?VkZSby8zK1EzRUl4ZEgrR1FQdmxjNDZyT0x4WHJvZG4xejU2dFBKYXVqdEsx?=
 =?utf-8?B?NndOODJmZExCelY1Umd1MUNjbllFK1M0R0xpd0dLdXkzL1lBRDdkMklab0VI?=
 =?utf-8?B?cC9SWTlZMGJCY1NjVEpWUFBtUlBrdkJQTHZTWk83QldWNVUvdml0WGpiY2Iv?=
 =?utf-8?B?enN4WUlpMTZYUWhyaldqWlhXamJ4MWpsQXZiVm1EZ2Jva2VSN2RXdGNRSHlJ?=
 =?utf-8?B?bUxIZUZQSVkyL0VLQ1ZaeG1kTlNPVlJjSnJSdEExUC9HS01JelYyd294ZU5z?=
 =?utf-8?B?aWswTzJsQisxMmFDMWN2OTZLRWR3RVRnS2hYbFRmR2JmekhLanlwbGdGOU1S?=
 =?utf-8?B?ZnIwSXAwdGU2Qy83ZlNac21zYm50VmZtdHBkaDkrN0JlRXN1ZkltY3dxbks0?=
 =?utf-8?B?aVkzcit1TnZjM3JZRjFSWjE2MG40N1IyMUUySXpJVTM2T0RFZVNvQzlGclNV?=
 =?utf-8?B?Qy9HZ0dWaUs4L0hERFliMVVaWjNicU5tbTVXMU00dE1ZWk1ROTVlZFFpRDlx?=
 =?utf-8?B?UVRDTzU4MnROcVR4ZzYwRUYzUjlSd291bHFKVW5BWll0VUJiam1kSXRheGQ0?=
 =?utf-8?B?TjFXaTRuT0drYW9UZTdsYkhObEh2YVRQdjhrMnJ4N1QydEU4SWNFdFlBRWY3?=
 =?utf-8?B?eGQvRTAwMlQrb3BEQloyaU5Fc1BRWjdUTkMwLzYzblg2aHlNQmZSZ0wwVkFh?=
 =?utf-8?B?RkZUQTRLT2E5Q0x5L3A2TTRuMHhPMU5sZnNhOUZmK0w1TTdsTmJ3K3hDSEFZ?=
 =?utf-8?B?Rjc3Z25qMkVuK0FFMUZ6dUc5R1JEeXpId29EU2xmN0o3OVpIR1kwWnNyQW5L?=
 =?utf-8?B?MkZHSG1SSXNGVGNTRFNRS3YxYjJpa21tNnRuc3M3Mkt5Q1QvYkVlR01rdFIx?=
 =?utf-8?B?QmpSb1hWVTQwSDlHOFM5ekJaQytIY01Qd3hhZUhnYzhGVTVrc0RsZkN2WUNF?=
 =?utf-8?B?YUxFUDlmaFFUS0NIcDc5MmFJNmN3WUVFUUdBeXJiOEJiRlROdkZjRk9ZM2hM?=
 =?utf-8?B?b1FXTGpGTmROS2N0TklaMjg3WndQa040bUgyZHRJRGkvbkRyOCtEa1ZzVURD?=
 =?utf-8?B?S3QzSlR0emlZMXJkemJDT0hHOG9QZksyVUFRaGYwQmJGQUUyNnFiaHBzVEZr?=
 =?utf-8?B?SE9nYXRqbk0rRWZLOXdLWWUrM1l3OVhhVC9lb3ZIN3Mwejh4MnRyKzRYeHhE?=
 =?utf-8?B?OXovc1hvUExrQXZUcXZlaWU3bHJ1WjRVWHF1bWpscmVYbFRPL05pS0VWcm5z?=
 =?utf-8?B?QUhoOFBTTE5hZ3BEOGo1dEd2cEF4Rm1vWFBUcUVZZXFiaVFBTjRTQTdmNmxY?=
 =?utf-8?B?MGZUemMvdWdIUEQvbzJtUlgzMkQ2ckg0S2d1QVVBMkJTSU9tTHFTM2dCVVBk?=
 =?utf-8?B?cVl4TFVvMkRpU1dZVk5DTjNZakYwQUY2TDFKclNtRUlsUDE5eXRVV3FOM3RJ?=
 =?utf-8?B?WU5YRXVXZmRGWHRsczB6OHc2WVNIMlAwMlA5R0krdlJuN1E4czROdnFwb2NC?=
 =?utf-8?B?UWU1cTRmQzVLdWNzWExmZm5OT04xMTRNQzV1Sk41alRWMEQ5RCtZYzNER2lh?=
 =?utf-8?B?ZWRtNzNPalRYVXN4M2xkR0JycXdWQnlKU2luc2RzWlNoSkpibGdBZXpHTk9U?=
 =?utf-8?B?c21HVWdCM2VEQ0ZHa09YV3NpcEsrRVdBSlZVdWxFc2xOUlNvektSaFFpTXlX?=
 =?utf-8?B?U2t6NXo0YXMrK2hpa201MWxxWDNHV1p1d1doSmNNamh5NXE1ZzhtY3NRWHNo?=
 =?utf-8?Q?SElGMCXC5z+rauVEHe1Gp5/Q6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62ECE8216776DC42A4845513D34B56AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987c7bcb-bb18-4fce-f71d-08db711debd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 23:35:52.7220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OcUtFDRNYAg74HXRib34DGgat9xxdXUV3bFgRPFarlk4cJYy3MnYTLcByceEYcq0lBtMq0xjMw7NsXunMN89Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5874
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDE3OjQ2ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAxOSwgMjAyMyBhdCAwNzozMToyMUFNIC0w
NzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiBPbiA2LzE5LzIzIDA0OjQzLCBIdWFuZywgS2Fp
IHdyb3RlOg0KPiA+ID4gT24gTW9uLCAyMDIzLTA2LTEyIGF0IDA2OjQ3IC0wNzAwLCBEYXZlIEhh
bnNlbiB3cm90ZToNCj4gPiA+ID4gT24gNi8xMi8yMyAwMzoyNywgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiA+ID4gPiBTbyBJIHRoaW5rIGEgX19tYigpIGFmdGVyIHNldHRpbmcgdGRtci0+cGFtdF80
a19iYXNlIHNob3VsZCBiZSBnb29kIGVub3VnaCwgYXMNCj4gPiA+ID4gPiBpdCBndWFyYW50ZWVz
IHdoZW4gc2V0dGluZyB0byBhbnkgcGFtdF8qX3NpemUgaGFwcGVucywgdGhlIHZhbGlkIHBhbXRf
NGtfYmFzZQ0KPiA+ID4gPiA+IHdpbGwgYmUgc2VlbiBieSBvdGhlciBjcHVzLg0KPiA+ID4gPiA+
IA0KPiA+ID4gPiA+IERvZXMgaXQgbWFrZSBzZW5zZT8NCj4gPiA+ID4gSnVzdCB1c2UgYSBub3Jt
YWwgb2xkIGF0b21pY190IG9yIHNldF9iaXQoKS90ZXN0X2JpdCgpLiAgVGhleSBoYXZlDQo+ID4g
PiA+IGJ1aWx0LWluIG1lbW9yeSBiYXJyaWVycyBhcmUgYXJlIGxlc3MgbGlrZWx5IHRvIGdldCBi
b3RjaGVkLg0KPiA+ID4gSGkgRGF2ZSwNCj4gPiA+IA0KPiA+ID4gVXNpbmcgYXRvbWljX3NldCgp
IHJlcXVpcmVzIGNoYW5naW5nIHRkbXItPnBhbXRfNGtfYmFzZSB0byBhdG9taWNfdCwgd2hpY2gg
aXMgYQ0KPiA+ID4gbGl0dGxlIGJpdCBzaWxseSBvciBvdmVya2lsbCBJTUhPLiAgTG9va2luZyBh
dCB0aGUgY29kZSwgaXQgc2VlbXMNCj4gPiA+IGFyY2hfYXRvbWljX3NldCgpIHNpbXBseSB1c2Vz
IF9fV1JJVEVfT05DRSgpOg0KPiA+IA0KPiA+IEhvdyBhYm91dCBfYWRkaW5nXyBhIHZhcmlhYmxl
IHRoYXQgcHJvdGVjdHMgdGRtci0+cGFtdF80a19iYXNlPw0KPiA+IFdvdWxkbid0IHRoYXQgYmUg
bW9yZSBzdHJhaWdodGZvcndhcmQgdGhhbiBtdWNraW5nIGFyb3VuZCB3aXRoIGV4aXN0aW5nDQo+
ID4gdHlwZXM/DQo+IA0KPiBXaGF0J3Mgd3Jvbmcgd2l0aCBzaW1wbGUgZ2xvYmFsIHNwaW5sb2Nr
IHRoYXQgcHJvdGVjdHMgYWxsIHRkbXItPnBhbXRfKj8NCj4gSXQgaXMgbXVjaCBlYXNpZXIgdG8g
Zm9sbG93IHRoYW4gYSBjdXN0b20gc2VyaWFsaXphdGlvbiBzY2hlbWUuDQo+IA0KDQpGb3IgdGhp
cyBwYXRjaCBJIHRoaW5rIGl0J3Mgb3ZlcmtpbGwgdG8gdXNlIHNwaW5sb2NrIGJlY2F1c2Ugd2hl
biB0aGUgcmVib290aW5nDQpjcHUgaXMgcmVhZGluZyB0aGlzIGFsbCBvdGhlciBjcHVzIGhhdmUg
YmVlbiBzdG9wcGVkIGFscmVhZHksIHNvIHRoZXJlJ3Mgbm8NCmNvbmN1cnJlbnQgdGhpbmcgaGVy
ZS4NCg0KSG93ZXZlciBJIGp1c3QgcmVjYWxsIHRoYXQgdGhlIG5leHQgI01DIGhhbmRsZXIgcGF0
Y2ggY2FuIGFsc28gdGFrZSBhZHZhbnRhZ2Ugb2YNCnRoaXMgdG9vIGJlY2F1c2UgI01DIGhhbmRs
ZXIgY2FuIHRydWx5IHJ1biBjb25jdXJyZW50bHkgd2l0aCBtb2R1bGUNCmluaXRpYWxpemF0aW9u
LiAgQ3VycmVudGx5IHRoYXQgb25lIHJlYWRzIHRkeF9tb2R1bGVfc3RhdHVzIGZpcnN0IGJ1dCBh
Z2FpbiB3ZQ0KbWF5IGhhdmUgdGhlIHNhbWUgbWVtb3J5IG9yZGVyIGlzc3VlLiAgU28gaGF2aW5n
IGEgc3BpbmxvY2sgbWFrZXMgc2Vuc2UgZnJvbSAjTUMNCmhhbmRsZXIgcGF0Y2gncyBwb2ludCBv
ZiB2aWV3Lg0KDQpJJ2xsIGNoYW5nZSB0byB1c2Ugc3BpbmxvY2sgaWYgRGF2ZSBpcyBmaW5lPw0K
DQpUaGFua3MgZm9yIGZlZWRiYWNrIQ0K
