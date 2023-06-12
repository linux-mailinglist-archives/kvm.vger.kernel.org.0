Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FEF72B571
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 04:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjFLCeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 22:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjFLCeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 22:34:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A101AB;
        Sun, 11 Jun 2023 19:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686537244; x=1718073244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MU5zoFd0VeiraLiT4R8r7rTGZEznvVfFw1whZ7TXSIw=;
  b=hltV//vp3gHQDI0yTeysfBmgy1dT/IAc2gC9c5KWK8FryxPqOb/mug5u
   4PJM5+KMA+3qJF63m9U/T2NMMvcjIkFfWkWFUM1TQSO/Tu+1tQ3X4VLJG
   wXbmvVZSH2XSXDrdBWSr0cNNNCVI8tvI+o0xFaLfX3SPm5fw8CPer5Fw4
   VQ8YZ1xyxJJWOEu6IR59QbO9700pYyXQJsMFANvu3brffM/R3s4yIF3j8
   e4uSURPptKq72+hHFbNFw9d+IdnrU0O2IJAdRofCA4ju7pZit0H40hiT7
   t05Mj6am0z4tj1ysh8z1kTz5HRWA8PHw2w9x/BbropFnTjrElv3uBTbwq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="421523996"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="421523996"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 19:34:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="776185718"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="776185718"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jun 2023 19:34:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:34:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 19:34:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 19:34:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOAazCE/1GADBr2OLQHddzAaXH7ioNdGzizDuGie6BWYGjfaDk7e7zN/SN+COaJR2YacC2fvkqTpGx9zvIX0SwvUOeDSXknoGN2+CfdbBeg66hmKAR1wQ1IKCtvW1qV1d4w+b2083ms2/VMsWhsmunwhtvWGmCAcCWxQUrRYLsr01lvZlpI2RAP/kdm4vsrck4HGUXk7izHziQp1WqQxkCNU3BHYw1HZ8GtIwj+21Q720W2V/eXEwU8uIZ6jaPMYabVCkQi68vRMQZIb4H1GKZO2ls6ID/zc69jhkWHMAKSofUId3zb+m+6YkNdyqNJqE8xS9x1b34ViVECTvbmXNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MU5zoFd0VeiraLiT4R8r7rTGZEznvVfFw1whZ7TXSIw=;
 b=gvGf6nXpUJm2h87OQYz6iS91JjCvas7Kl4oiRmoFsnfN+NtcgiwJ1vU980AlyM+0gUjpMosjlolrOCKOA3LnEI/Zn/HuGmvg27rvT590YTVgOvVYWcfoT8Rs6+K6derFt+Upr5Y9z+Poi28ua2BEx10S4h56CVx9RB31BNl56O4PC9jHqHR28IjWlRjxb/P+mWNpNLd3QkCtqawWxDywlLgplgL1SlHBYZXduh5a3Bkbq1B1Xa3LXe2tL9/jAYH1dYNaVW1HIl6Ailbt4Zu5rz9lZrK0P+1mOA+NITKQ0iwsiFPqX+S+8IFJJo0pamvdMi6KWRqriZbFZG3NIwMPzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6092.namprd11.prod.outlook.com (2603:10b6:930:2c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 02:33:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 02:33:58 +0000
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
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Index: AQHZlu+2r84uqtF1H0SFKn93tuC1FK9/hdAAgAE59ICAACfHgIAFl0EA
Date:   Mon, 12 Jun 2023 02:33:58 +0000
Message-ID: <89c99e7360dc2acfe5fb56c2bbb40e074e1f94d5.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
         <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
         <ddbcadf36016bb60a695f54b28f5c9e9af53a07f.camel@intel.com>
         <201af662-f700-9145-c113-563e378074ad@intel.com>
In-Reply-To: <201af662-f700-9145-c113-563e378074ad@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6092:EE_
x-ms-office365-filtering-correlation-id: 15bd2e61-18a3-425a-b63b-08db6aed79f1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z8GhDYvMLYQpoFqLHvnDgClBhxwULnjWLOr80amS/8P81XaLGQFxBhvboQfW4pBmUtEouHUCkS3GNVxM332yw8SsS4klkjvP3GxZ3AA7YDoool3pBblA+kKamF5Sq+PlILfqC+EhjOYTFuFpVJHAMw1QLhcfG9eLoc5zjjDGFa9fY3k9/ILMdO9lrwWgUfdO1XZ6GZ4ZPH0ZNNOGpSM4MBhWxmXYn5X3bPCLYq9UkhupmaooQcMDtdCQrzgLjY+TPufPCuT/isZSM8ruKtNRDH5IYRiIsZptjcvBo0iic/yeekoI0bBHQTnvahzLcaANWFz/0N8YQIQKMZYz2ewHaISuQC4ROcRwJ/gYzI/aO3HbX/STkN1MhzlVeT+rh1we0mt6BR1TemSm4pGVJbTNCjOBELmyk1maT4Blg5bxZ5G6ZloZHpbM7olg5cU29LpFeJ3iaWZPEfhdhOrMBveCsQtda+PWWokIYTCSh1rPhG6H9aDhVxnx5/D7hNNPNSwDQ2faLecm+5AOFze+nUo3aYOwLnzE8d0WCSTaX7ygA+ngjpUJ+Dhasir6mGLES5TjZb3hHs9WuliIPz9KAdsTRzb0+tj0jzfkVh4bES7TvrDvkYqcao9RB2Ix4SCB/YSr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199021)(2616005)(186003)(26005)(6512007)(478600001)(6486002)(6506007)(71200400001)(110136005)(54906003)(82960400001)(316002)(41300700001)(5660300002)(38100700002)(8676002)(8936002)(91956017)(76116006)(66556008)(7416002)(4326008)(122000001)(66946007)(66446008)(64756008)(2906002)(66476007)(86362001)(38070700005)(36756003)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2xBOEozZHlPaVZVZ255czhhN0tQUCswa0NJRXdDSnZlV1ZXdFFaa2s5N0pH?=
 =?utf-8?B?ZHBQSkpUVWVVeGQ4Y3JuSUo4R21ra3JNeVBmZnpKNkZoQ3BNM2hCbHhrQUZm?=
 =?utf-8?B?SEQvSU40Wk1qcXlWVXhlL1FJVzRZQ1hDWDRRUGllcTlSMkZiUG9rS3hhU2t6?=
 =?utf-8?B?ejNOa25jZ0JmWE1RSzBOK1I4aVdXU056SHVuZE1mKzlKeCtsZkZQTkxoTzVS?=
 =?utf-8?B?NEwwbHdDVWVqbHFFdXZYVzg2S1NoRU1QeDhXYnVmRjl0N1pNZUxzcVBObytH?=
 =?utf-8?B?RFk1ditFczh4UkhOTUU5YkcxSkhQaWViY29qZFhXREVTZmQvN1RRU3h0c0V6?=
 =?utf-8?B?YXQ3MzlKOS9CdVJ3WlVPUnVXSSsvRVloYU1KNjFqM2E2dTVFdmo0ZHpjSXdo?=
 =?utf-8?B?d216d3VnRFZ3bS9hUklMVTFxbHZaMnFvV3ZjMHdzVXhGeG5pajh5MGJhRC95?=
 =?utf-8?B?NmV3TXR5cWNvYzNQcTFjZGRRVnZQeHhQdXhvbmZCd2Q1SVBhMDRVRWFFQjNX?=
 =?utf-8?B?RnMxRWRSK0NnTVhaVlBNM3hpZndQU3FPMldlZDNkU2hYODM5cVRKUEVKamRM?=
 =?utf-8?B?REROY1BMVEdoZ1pwWCtvV3BLVDgwMVhCcWgzVUkwb0hzMGdiWUFsSkNzVHo2?=
 =?utf-8?B?bGN0SnFDRUNORmZrOWpIWDRqYllWTzc5bDdEYkZsdGFxcmNHUUtYZkpzUWVD?=
 =?utf-8?B?S2VoMWxCcENhdUxnSXB2SDg0cFJYQnloT25JVkZ1VXJsTXRpT1IrSHFJZ0lU?=
 =?utf-8?B?MkF3Zmh4cXhDTFRyN1F0R1BwcHJuZmJTM2NsTnh0NCt5OU5MQ05sWWp2bTQ0?=
 =?utf-8?B?c2hBZFlWMVdwL2lPY1ZpMk05VVREWkM1aGdqZ2NvYTVUYW82QlZVeGZJY3Jn?=
 =?utf-8?B?S2k0SG5HdFJVbzdGNHI0TGFWa0xQdnpFSEdrck9wUjBTcElOYis3bFRwYmYx?=
 =?utf-8?B?Z0RXK3crNG9PNlZzQUNiMU9nVHdKb21Bakd0WFVNVy9vZi8rc01HK1Z5NDZq?=
 =?utf-8?B?R3lEdGFZVmZ3VGlkVEZqcHNEd0N4OEg1cklhNms5ZktjeXQ5Ry9nTGNFR0RW?=
 =?utf-8?B?d3FiSi9QWEM4L2RjY1grUGNoZ09FRXhNRmpJUVJNUEswVEpPOUVFZys1ZXlQ?=
 =?utf-8?B?c1BIM3JHNWE0cCtTWDhpdWx4K0lxeU1JNU5XdENxWHpYN3poaFlXUlZzNFBD?=
 =?utf-8?B?cWVObHV6WlpScmVrTEtRR1FWN3EzN2FOS3hONG93cS9LYis1TVhJZFBLNXI0?=
 =?utf-8?B?aWl5andVa05tMVVUUExZTUM4RU4rM2RYVURHL3FVMmRmT05OdVBMSVZXN0E1?=
 =?utf-8?B?cXF5RDlKSVpCREtpTGZLRGdEcTNYZnJPRHBTelBmcmhvWGd6ZzJsNlJYdVh6?=
 =?utf-8?B?Rkd5MkxtQkhvNldvcHRFWlJlY3hBMGJkUDFlUStHakJ6TjR2d2Y0N3U5QmxX?=
 =?utf-8?B?ZmhEVUpXMDJzcDJuQ3hXVFNpNit0aXJWUnRCSTAwdUZ2cnBaaXNFZUpQdlpt?=
 =?utf-8?B?eG5Ba1ExWkJlQnJvd0QwNmdEeEhRcStzNkFMcUZublkwQnRmRm80UWh0dzRk?=
 =?utf-8?B?eXY0Mkh1ODZkakRTTjIzTi9FL1RUTy9PcHJaUEVRUitrM2tNMlpkK3V5R3R1?=
 =?utf-8?B?blM4NnlLQThJalNDMFMzUUphcG5rWWxKRUtub2lIYnhuV0ZwaWRVUEpoVEpG?=
 =?utf-8?B?TGkzZ3ZJK3o1T2xzdENscXNnWWx5RzlmYmpCMi9pb0VLWlBSUzRjNDRJQXVp?=
 =?utf-8?B?bWJ1TU91cHdEaDRBL2N4dEpTbTdYTkN1N1JZbktqR1lwQ0dnSDJhOXZSa0xa?=
 =?utf-8?B?UENIb0ZJQ3M2NnJuNC9RaXAxdEd6R1JMd2x0dFB2UzFXMXFXcnljd3Ntb1oz?=
 =?utf-8?B?L3pZL3FCTFlPcEpsRE0yTlk4RzlXL1hHQ1ZGUHJPdXcrQ1FKS0tDVWZVOExM?=
 =?utf-8?B?VjVhdm9BRFg0YW5sU1hMb2Vqckt5eENZSlRiSWFzNlQ1cXZzK0F0aDBEc003?=
 =?utf-8?B?L2J0VjRsVFpOdEJKcGFRZ0lISDVSV1V5c3RQU2dtLzA5STF4SWJoM29UUFE5?=
 =?utf-8?B?V2UzK3ZFRGNmVGhJT1Z1cXBjanU3K012SXllY3NRSHpLMFpMa1dwVkxnNnVF?=
 =?utf-8?Q?LaViuyUk2AkUF/3Nz6XtfXBE8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <840D7D3BFDB0294DAFB571F4E8741D16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15bd2e61-18a3-425a-b63b-08db6aed79f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 02:33:58.8664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9B+2RIzg4ZKJ5nhvBdjWmCiaHE/ocGGlYi569Xqy+X6R288ZAHKq7VH00Jpn4/oSnhEtNbmnCD55DcMj7Fl90g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6092
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

DQo+IA0KPiBNYXliZSBub3QgZXZlbiBhIHByX3dhcm4oKSwgYnV0IHNvbWV0aGluZyB0aGF0J3Mg
YSBiaXQgb21pbm91cyBhbmQgaGFzIGENCj4gY2hhbmNlIG9mIGdldHRpbmcgdXNlcnMgdG8gYWN0
Lg0KDQpTb3JyeSBJIGFtIG5vdCBzdXJlIGhvdyB0byBkby4gIENvdWxkIHlvdSBnaXZlIHNvbWUg
c3VnZ2VzdGlvbj8NCg==
