Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5940F641043
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 22:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbiLBV5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 16:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiLBV5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 16:57:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024AA11473;
        Fri,  2 Dec 2022 13:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670018262; x=1701554262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wMLMo1AnmF16cAdN3aadHWHw/Pqp2mEsVw2LbUSdhLE=;
  b=NyMk73zacCoZmlaFRoTyOHm0ZVIK4yrdjSWJrRQChUMGhfhMACtHH1qf
   8CoWuGuPATSoa/tNnIquFL8Me2qrFVB4gsCKT22yc5s31Lbf6Q+10wS4b
   CEFsZSJmQS9x3DN6EShRGDD1/CDxGdqE+WBCu625gReLfSV8MMBEX4jGh
   GUIgDvhDQSgTytsLhplsjL2uBQ3DB/SqMZ1ywAfTQOxtGqc6MCY0PNLCS
   TANXxQO/HYVrr8h6hqFy6t8pNRTvmDKmy3Tqj7tj50bRxLGNFUwuOBSmI
   VjgLNSZ9mf6Zj8uSxbw8SBZXkuP+362m/49ZdxgDicwa18orDEy6XUTZy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="303664740"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="303664740"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 13:57:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="708633462"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="708633462"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 02 Dec 2022 13:57:40 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 13:57:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 13:57:39 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 13:57:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7gDdv9o7eKn0Ovcp6NXH+gn93C9biMenhktn/oYdmN1VRkVfcbtdizmz8Imv8NMSM17KeGmthrEyuWlruqSDn+ptLFkiQ89H1nJfHmGcQn8OKIeXZuW6TSMBVzBI8riWCMnsT/pcDsACiLz/6FGC40/Bg45X6qKCxLr3bFF72WduG6eQy6iTUduFPkLnpl3vhOv0BLgG6U8tqbjx/fE6g/Z/0yCS+OGD8575QoNcGX51+3wZXqEHXDaRaTMhwG0MulU/DFZ26ZJnAbaSoDludA179QdVdjJRXbk33ASeT0zjXaXkdhjARHD0To7lK4frxInmrQuZpU7JSOutZM3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMLMo1AnmF16cAdN3aadHWHw/Pqp2mEsVw2LbUSdhLE=;
 b=kRzQU08XMpVAdEZ2U2nSPnEtIU1tmSOMd5uU8qpcw33MVBRw/Afu3/2JqqDvZBYBqbryzfkNe59zg2ZoftLfsuxhWJjj3fPKxgPr+/FzfzZku5E+vhrk5oTts1dgi++l3mS0aXdZRA/8tHPxOjXOHPoiL3Msb91NLD9xPjNeRhKrE7qXITYgukzmOktn3ut69e/Z8m9D0uquT4GjTBdk8dgQIKcXGJoKZknDk5L8h2ZPT+PAZgkQyexe7teUKVJciLuih5oc8wfi6c2OmL5QI255u9sPtSU/mCpY0V7DNhPHXJXs5ST9PiM5cAELgQT1GjUoNXrdp9AVjsNOiuTfqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4861.namprd11.prod.outlook.com (2603:10b6:a03:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 21:57:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 21:57:37 +0000
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHY/T3BkERrb6yHxUStNPJD5vkcxK5LnNIAgADJbQCAAFT+AIAAZzMAgA1i+wCAAGZfAIAAS+aA
Date:   Fri, 2 Dec 2022 21:57:37 +0000
Message-ID: <7319decac03e0e2b5725ddf7634472f9728dac0b.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
         <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
         <57af0b96f8a827828b1d64031774962972bfb060.camel@intel.com>
         <1c6580f7-3abb-03ba-dd98-367ddb9bf23b@intel.com>
         <a5e0f218e911a4ad207da55e21fdeb6d8035fed0.camel@intel.com>
         <7be59cd82bc3f3c26e835980eb74a8d92c6d67d6.camel@intel.com>
         <0decd051-a247-3f92-2df7-c7684ed18c75@intel.com>
In-Reply-To: <0decd051-a247-3f92-2df7-c7684ed18c75@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4861:EE_
x-ms-office365-filtering-correlation-id: 14496206-13a9-4001-2daa-08dad4b0397f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yw7nECbMg6GGt+w64Kwsd07/PvYEku9kz+cbSzo6wV512Xru/9QJ7Srd44+fw1mOIv7UQDRlS+w73HkHh5wyG+w0p20BUnDB7XTZy7s0kX0CHiElhZHnRYAQmNpKwSf7rRHQsvNVTcwcmLRBTm3o9Z3XjzAExDJLQN1pTO1/SzJcdXEc40xR3nDZ1754V+HgurWxewQVZu2G8esuPK9f5gNyfTrIcJfzlhSeWvTwa7FN4x0lFr6kya8R3VFULKb2z3dryHS0c0Iv4/+seToZVUga1WoIMxbp/KhBfUEea1/0rKPHsngrY3RCKiEV56RfXBb4IVrieTQM1lOtuZCVyhKxHtGd8wD7JS6o6pQ5IjZEqCdIY+vc/0UxUgb+Iy1YQ+sAZr22/IHYCW0oA+3p3Wf5aiuW5spt/8abUZ60aW9m456Pmq6NxzTXP0J9qJiL8mAY+AePTkl+umcP/6iduUF9zp4SyVlJYs2AOSEDpCicb5gAwvgv+JoLxGD/CRmy5qvMVUsDSkv7rH9jklSxZIAlXiwpuRY9FjINQowlPMBJVt3+8n0/8Gt9qht/axAThqPH2PuxA8HHBR1W/JYoB0FG57z6LSDasbwD3M+WLfo3jH6YlNNJ8iRV9MomwajW3M0xKJRXVYL8pgZ2zkWAoB/YMzOlaZ2/DwW4lisMog5vgqdNCKGhudFWGCTkUjrmueNcgn2ea55oafu8JMe/LQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199015)(26005)(6512007)(53546011)(71200400001)(6506007)(4326008)(8676002)(66476007)(91956017)(64756008)(66446008)(6486002)(478600001)(2616005)(186003)(41300700001)(8936002)(7416002)(5660300002)(83380400001)(2906002)(76116006)(66946007)(122000001)(82960400001)(36756003)(86362001)(38100700002)(38070700005)(316002)(54906003)(66556008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amZSUk05ckdBK3JaUjgvZExvQzEwZ2FtWkRCMlR0WHgzRnZ2WEwxajA4RDBJ?=
 =?utf-8?B?UW5kQTdvcjlmMmFOUnhFaWtKemFoTWdLdUd4T2xULzAyeVBGTkR0VXp4MkE0?=
 =?utf-8?B?c29xZnhwWmh2TlRoZTEvSk5FaDJ5aXY5Vlh6Zm5NMjZXczFJSTdGOHlvbjZO?=
 =?utf-8?B?aitwQ1dHOFgzeDFQcUk4NEx2NlpNNGlncjUxZ0M2d2lJaXppa2NKMUxvWHFH?=
 =?utf-8?B?UHBhRXBIUDNCc0NMWEdGLzJaMHA1UDBkN25zSXdpdm02K1RwK3dJZFU2QUVQ?=
 =?utf-8?B?ZXplZU56cmxMczBaMmFQbktqcnl3endjSEc5dUFZUTZMR1R3ZXl3R3Z4MmFw?=
 =?utf-8?B?QlFibUFrSFRPaXFIYlZ6OEVYS2lxcUE5OWpySWVFeEF1cUZTYVFyZy9JWWY4?=
 =?utf-8?B?ZG1oVXg4WG03Tkd3ZmZiOEM4R3ppOFNUTnZyem1zVmlTS0xxSjRNOEhCYTdz?=
 =?utf-8?B?dncrT3dFdlBpQ1VUd0c0NHE0dzB1OUtZUzRFRE1BSHE0WGs2dEo1dWpEKzVZ?=
 =?utf-8?B?eTU1K085VTNhMktkSzE5b2MyWnlaSllMM0l2QjZIRzB0ejZNSEN4N29Ka3hS?=
 =?utf-8?B?RXAyTmtUVnNxdmJQd1ZNZzdaTmRBV2o0R1hPbGljUjNUQVJua0UrSCtSRDFr?=
 =?utf-8?B?dEdUUnZhOWJWQk1CRXhFWE1HclAyUUV4cU5tbm42cVcyZVlsZnVORUQxK29L?=
 =?utf-8?B?R01jTmRFRHhNVW12cjhnbnJNdm0veEFsT0hZZ1R1MUpRSnFZcExLWmRpNHlK?=
 =?utf-8?B?R0taaFI1YzFxTjYyemNrZFMyaVdCSnZiOGx3SlZ0Y0JzY2NKSXN3S0N1VHJP?=
 =?utf-8?B?bWJMK0o2UXhHUzRxNnN4Uzk1K2RNSFZsbkxkQWVDWEJTdGdqRHJzWjFFTWQz?=
 =?utf-8?B?REJxcmtoYmlqREVzSnB4cWZ3WWowejdROVpaSVF1aVlFSzVadkxXZDJydUxE?=
 =?utf-8?B?NUp2ODd0YnlUMWZQMzRNV2pvMzlOMkp3bkJkMmlEdTdpemNYdHZiZ3RXK0dw?=
 =?utf-8?B?ckx2TFljSVpSSEtOQ0Exc0Z4QnF3OFFDR2RBNkNkamtGZHZmL0JvamhaOUlL?=
 =?utf-8?B?aTRpdXh2TlhXcWhveHdZWXlQZE9QSGtzNWMwUGlRd3MvblNtWEZOQUJVMHRx?=
 =?utf-8?B?OVVOcldscytGbEVUaExzbWoxWlFORkVXNWwrV0lnZ3Y1amZwTWZ2d1BuMFRu?=
 =?utf-8?B?VHhaaU1zck5TcEYvaFdxU3JQRVR5K2pBZHpXWWhUK2J4U1MrYUordXlJbkV1?=
 =?utf-8?B?bnNmWUJ3TThXb3UyTVRpM3doRGVjbmIzbXFlMkNVeTlSNFpYK0lJSDhhOWtw?=
 =?utf-8?B?WW5nOFVDWEJHTVNnRHIvSDNycnpsbHp5K2tTTUFrYTZaejlKc0hlVkIxM2Er?=
 =?utf-8?B?UmhmdkJwZks0RzhlejBNT2ZZUkxSMEE1Y0E1cHN0alQrSWFoS2lQNFgwcm1v?=
 =?utf-8?B?MTNsZzErMEQ5aTJtNzUxeHpCaS9nVnFoYnlWZFVWN2hmVndmRWltS202Rnpo?=
 =?utf-8?B?amROV25EMmUzWHdJUzgyUDhFYkVlUDl6MnZ1YXQ1c3pEMjNCVXdrbTIyQVZE?=
 =?utf-8?B?WTVsM203TTZkTGhLaitJcWNESUhOdnVWWHhsZzg4ZXd2enJ6MGoxWGI4RDFp?=
 =?utf-8?B?bE9BN0p5YVVDby9qOTY3cFgvTVVQazBVMm1qMC9XUXpnOVNDVzU4blBLUDBX?=
 =?utf-8?B?RkdHdjB5c0JjTEcxUXJ5OHdNc3p5aWxtdS9JV3B4T0ZHajBYQzZ4aXcyUTdu?=
 =?utf-8?B?T2svWTdrenRTZHpXU2k4S0s1Vkh5TmdWZW5nN1dtYzNVZFVWMDJrbHcwWVZl?=
 =?utf-8?B?MFQ0VGRnMmVVOUR3R2FleVFzMEc2djF5M0lxVloyU0FIMzc2RGVSTDFSWEVl?=
 =?utf-8?B?RjhKMzJBOElXbkJ2bExGSk1OVWtxbHk5YlhZYUNmTVhNd1l6Smk5RVVQL0No?=
 =?utf-8?B?eUxqd0tXQ2l6Sm5DbWI1QU5tUElOV1hyZmg0Y0FWeTZ2TFhoZ2lLdnpGWjRo?=
 =?utf-8?B?WFdjNmFZMkxIWkNMb1VmN211azZHVm95M1ZPT1pMcWpEUHBSM056Y0JwWHl0?=
 =?utf-8?B?TWtUb3FydWpsOXpxeW4zZ2N0Ums1bXV3ZDRaZStXT1pFOXhkdnlyaWlLNzgr?=
 =?utf-8?B?L1B6TkMxQll1Z1ZFaTRHOUtFU1F1aFBZWGRIN3MvMUlWT1BtMnNGSFFYZ2dw?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8E5936E5D1DFE4FBE32A9A568801B76@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14496206-13a9-4001-2daa-08dad4b0397f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 21:57:37.0002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oD125UM5HtjBvSjeTntULG0tcwb9THl/1CYeuaFsN9I+6kupAX5hpKroIoaPRak+PzW/1pn9jyMKOS9EoLF04A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4861
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

T24gRnJpLCAyMDIyLTEyLTAyIGF0IDA5OjI1IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvMi8yMiAwMzoxOSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBQcm9iYWJseSBJIGZvcmdv
dCB0byBtZW50aW9uIHRoZSAicjkiIGluIHByYWN0aWNlIGFsd2F5cyByZXR1cm5zIDMyLCBzbyB0
aGVyZQ0KPiA+IHdpbGwgYmUgZW1wdHkgQ01ScyBhdCB0aGUgdGFpbCBvZiB0aGUgY21yX2FycmF5
W10uDQo+IA0KPiBSaWdodCwgc28gdGhlIHI5IHZhbHVlIGlzIGJhc2ljYWxseSB1c2VsZXNzLiAg
SSBiZXQgdGhlIGNvZGUgZ2V0cw0KPiBzaW1wbGVyIGlmIHlvdSBqdXN0IGlnbm9yZSBpdC4NCj4g
DQo+ID4gPiBCdXQgd2UgY2FuIGFsc28gZG8gbm90aGluZyBoZXJlLCBidXQganVzdCBza2lwIGVt
cHR5IENNUnMgd2hlbiBjb21wYXJpbmcgdGhlDQo+ID4gPiBtZW1vcnkgcmVnaW9uIHRvIGl0IChp
biBuZXh0IHBhdGNoKS4NCj4gPiA+IA0KPiA+ID4gT3IsIHdlIGRvbid0IGV2ZW4gbmVlZCB0byBl
eHBsaWNpdGx5IGNoZWNrIG1lbW9yeSByZWdpb24gYWdhaW5zdCBDTVJzLiBJZiB0aGUNCj4gPiA+
IG1lbW9yeSByZWdpb25zIHRoYXQgd2UgcHJvdmlkZWQgaW4gdGhlIFRETVIgZG9lc24ndCBmYWxs
IGludG8gQ01SLCB0aGVuDQo+ID4gPiBUREguU1lTLkNPTkZJRyB3aWxsIGZhaWwuIFdlIGNhbiBq
dXN0IGRlcGVuZCBvbiB0aGUgU0VBTUNBTEwgdG8gZG8gdGhhdC4NCj4gPiANCj4gPiBTb3JyeSB0
byBwaW5nLCBidXQgZG8geW91IGhhdmUgYW55IGNvbW1lbnRzIGhlcmU/DQo+ID4gDQo+ID4gSG93
IGFib3V0IHdlIGp1c3QgZG9uJ3QgZG8gYW55IGNoZWNrIG9mIFREWCBtZW1vcnkgcmVnaW9ucyBh
Z2FpbnN0IENNUnMsIGJ1dA0KPiA+IGp1c3QgbGV0IHRoZSBUREguU1lTLkNPTkZJRyBTRUFNQ0FM
TCB0byBkZXRlcm1pbmU/DQo+IA0KPiBSaWdodCwgaWYgd2Ugc2NyZXcgaXQgdXAgVERILlNZUy5D
T05GSUcgU0VBTUNBTEwgd2lsbCBmYWlsLiAgV2UgZG9uJ3QNCj4gbmVlZCB0byBhZGQgbW9yZSBj
b2RlIHRvIGRldGVjdCB0aGF0IGZhaWx1cmUgb3Vyc2VsdmVzLiAgVERYIGlzIHNjcmV3ZWQNCj4g
ZWl0aGVyIHdheS4NCg0KV2lsbCBkby4gIFRoYW5rcy4NCg==
