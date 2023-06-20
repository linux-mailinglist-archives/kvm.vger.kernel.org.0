Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2827E73605D
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 02:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjFTAE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 20:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjFTAEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 20:04:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26FBE7F;
        Mon, 19 Jun 2023 17:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687219454; x=1718755454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HY8kGCTpD8rzRLb17wDndYhXLcAgKPljrCzjeM+uHLM=;
  b=J7QUxnvtTI1CRrwiOD7vpWwOEaTRmj5oAYTzdLd/ypqVD+FL50pM30cF
   saBkdFiA+rFoqwv/2XN/7iQnQifv0wprP5JQzXA0cTLXpNbX0Do9GQh/9
   T1vT7/4HpO2tCpiQph0ydoj2nktyuI25Azhs/yctWRtKjt2YuV1djWFVI
   3j01EV7Udo26eokIY7Nc2EIl696Ks8/H1kQDD1RZtJI9QoysjvtjPYYOX
   9RNQSvbHk2M7spKiQtGjqeDTDDSYMpXEYroq+9xY7l37eKiEwUiG5Mufw
   GMHsPCTRBIG4MwDIvxH0tlGVhtCrn2aPBkqMR0sitaP62VlALd1HFg3It
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="425684902"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="425684902"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 17:04:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="858363973"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="858363973"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jun 2023 17:04:12 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 17:04:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 17:04:12 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 17:04:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8vJDoMNxUF7vS4Rxcz7h2JL9OahYp0gnggFeDvVL6n0tPpN8QqA+jwZ1+2vRjfPJwLoSWlDI1JP6ZcWuieaLyVZhmoShAD7zmcVfQfHE/enuMBEH5ujaj9BiaNC2vEzyab2EYMQ7+bxhfx6yiVunaYL4bzUG4ZiRGRvOmlVzlT1QErtW78NlZvvObHd82NvpS8ZMcL5D+TJejHFJ3b6cDPgxx7vShUyzhu9oEnbZj4h/0swO9s+w1fZauh27N/oj+qSBBnbrEpJGKL+N+55v970JEfvS9cpkp/MGyOO1T7nsi/nQ4cVhJMFvRa86deEa0mhUBBP5ne4+iRhec9B0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HY8kGCTpD8rzRLb17wDndYhXLcAgKPljrCzjeM+uHLM=;
 b=QVbSk2laZhPX13pBqH7qJVJ1BoNSkGL3FNJTTDVTXvKTvMk7BoFhsST5c3dSifAUr4fU4zr6dOLqAWkLDjaz85Rp0XejYLl/YVSYiCxBYe2N8aSe0Czdg/UdhhUN9Ww0MyBgMuzdjfsCIIQRcIPQpHF/yq8mz0yk88eGj5MlUt00UR41usGxxtN8smSe947Xc6uggxjtUzfGwgl3fDjJKjG20II6Fn2E36AH0JJVUBZgnpdkSl5jLLqrDkEtohb5aR4BpySfyCaUspkJ4sEa9YAu/bqk2dJLPNQX4Y7cmB9mYVcu/hHP1olU4QBknvULp3rdYZh0HOJS9D/6NHSAxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB7552.namprd11.prod.outlook.com (2603:10b6:510:26a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 00:04:08 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 00:04:08 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Topic: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Index: AQHZa4g62amPAW2/oE6/VfNOqnc7za9542QAgALl3wCAAACfgIABxIeAgBOgaQCAAG0NgIAASD3QgAAJ/gCAAFAEUA==
Date:   Tue, 20 Jun 2023 00:04:08 +0000
Message-ID: <SA1PR11MB673492082606C66ED2F0717EA85CA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx>
 <87edmp6doh.ffs@tglx> <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com>
 <877csgl5eo.ffs@tglx>
 <SA1PR11MB67344FE6C8A83810D0CAF175A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
 <877crzr0pq.ffs@tglx>
 <SA1PR11MB673465675DA199C2C7EB1ADFA85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
 <68D62BB9-8F8A-4269-AF7C-F568AE093A6D@zytor.com>
In-Reply-To: <68D62BB9-8F8A-4269-AF7C-F568AE093A6D@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB7552:EE_
x-ms-office365-filtering-correlation-id: faa76e2e-f0fb-478c-3817-08db7121de83
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +OE0cvkvFA0tkJrW/aav+la9M8KGcJzmb102ppLDJ4uDotNemigHVlyaJdixnrpah3yOi9ByeoXYxFcRTrGeKIVi10CqTSNa9UoCsZ+iQtYNVJNgsf49Kfc9SGEVK9yhmkKMvW27oH+FYu2Q+G7PC+AvX/+lC7gTeX1Km07lKqjt4Ff7vBcNBPowPt1quq9MWlMMZALmXuGRdIZEb7QdojdCZ7pq1w1QYSJEtgnTM7csVbKLI7D8yigSbGvKms88AAm/+eyYXQoGhQPXpNe7TGLzSdcyjxqJMXNRtBTbg2DJWozxsSsdJOWusY4906rwy6IPESR4qkbJcTPUtdGbG8Gp9TG5hXm5B2Z7EgPu1aW1nEA48aLVz0RwiJLSR0a4/BmazDTmSuhnoEgVi4VJHPSqGil9XoJdn1s+1MXzSy8h/dwrIqf/YQK5P9lYNJMruw2AdBhfxcvQMQcioT794wEnWXapMEq8xtOVqoeSO3SrIHZf3ydWCFvrWYkKjJDaLnBs4OHOKJ7xG4jjLyd54NRdxIaR+G+39nCULtsaVBxN/yiPhE86TWgQTaBk0WpN0w+/hf8K9v1Yx6ZZzn9hRHLZuaY5VZuw2uphUsCfYZ261d4DR4NYiXgxDtXvfxNC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(4326008)(71200400001)(478600001)(76116006)(110136005)(7696005)(54906003)(26005)(6506007)(9686003)(186003)(55016003)(4744005)(2906002)(8676002)(41300700001)(38070700005)(8936002)(66946007)(66446008)(64756008)(66556008)(66476007)(316002)(5660300002)(7416002)(52536014)(83380400001)(38100700002)(33656002)(86362001)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmtaV3poamNSSEZ0dElJY3lsYmcwVkFLSGZwemc5UEI3MTlzK0NJbnk5aVpQ?=
 =?utf-8?B?eWtueFlpRzE2VXo0Zll1L2g2ZVlYL0ZGOGdwdGoxZ3JzYTRoZW5jbEtqTmRk?=
 =?utf-8?B?RzVtQVBWdVZURmhyQmI2V2VMek44OVpsODNKZ1R6S0lpT2w5WTB6Wjk5K2dS?=
 =?utf-8?B?MzlOSHhhSUhZR0pKZmk5Q2NUVXgwM1puaEE0U2tEZEo2Z2pPQzlqWG02S3p1?=
 =?utf-8?B?VzQ4RmRZQXZyVXgyVWJZcnU5M0dtVE55dFlNNW81eUJMcUZuWWp5Tm9mZFo3?=
 =?utf-8?B?bVNSS1FtVy92Z2w3UXZ6L2tETjFwVGtXN3p2dGtNbDliWlQ5U2w5RjVjME9q?=
 =?utf-8?B?Mml4YmZuVEc1Qk53di9kSHlKSFBCRkxyQ3hHRWRkc2pTL2lGYjZoOFRWTUll?=
 =?utf-8?B?K1hKckI1MkJUWU9GZXBQOGlpUWlYNDc5STBpZzh2Q0ZPS3RzZnNuenAzZE5o?=
 =?utf-8?B?WG9xMEVNVVdWeno4SVFPT0JGblc4VFFuNzJLZSs2UDFsQWVaK0lIVEhqVkt6?=
 =?utf-8?B?dEtXUlB6KzZUb0hXUktGVFZoSHZ6aHlXckdXVThlUjNIZXlRcGlnK1BEcnlD?=
 =?utf-8?B?eks5R29KMzFhNHRWMnk3TE5EeHFiMmtqOTVhbFR2ZytyKzhySlgzMjgxczRY?=
 =?utf-8?B?aHF1VmRkQ3lENnN1RUl6Z3RBUFp3ZmpMQ0tmUkNYME4xUUFFZFl5Z09pQmw3?=
 =?utf-8?B?V3ZnQnBKSHlFMVlxZ1RJS1AzS2JWcnRpOHZuMmZuK2laak5wcDFOZU1YU21C?=
 =?utf-8?B?Vmk5ejQ4R29ITVVIL0xRdFBEWVhXdThxY2tTOStzRS80V2JMUlU1Zkx0aUNq?=
 =?utf-8?B?ZFRSaEtJWEJJYjV0WU1qQkRndHNMYTFkekw0bkN0RDBhNnNHVS9EaVhEcmM0?=
 =?utf-8?B?UlpHRHFyVDBOcVRZdkl5VE5BSm5zZFJIeVZlQlRxQ1ErSk1YSmxNN3F3cjlM?=
 =?utf-8?B?eGp3L3pMWjJ3ZENiSzVoOFhKaWNmZmhnd3NWTEJsNm5iWkZlSVNiOVJScm5K?=
 =?utf-8?B?bkRrdG90YkpBSCtBRHBKWXo2engxQm01dkloSjI1b2FZLzRzRnR4UEhLckFZ?=
 =?utf-8?B?VHIxdVgxd2p0bSt3Mml5ZlVYbHFjVTJnZFRKU3ZsTFcwQmJnbXQwNnk4bnV1?=
 =?utf-8?B?UW16SXRSVVlvZERTRWhXcDgwaExXeC9iOFI0MjVoaWxoL0pyeGJKMzhrSUl1?=
 =?utf-8?B?ZFROUDRwQ0lhbVRrWkpHVEVtNEd1K3NmNkJ6UXlMY05TMmJzVFhmRXlBVDIx?=
 =?utf-8?B?WDcvTVkvcVlWQ09pbmh6dld6L3VRU2VSZ05seUpTMWRERHN2R2N5aXI4NHIy?=
 =?utf-8?B?MmtreHhNWGUxTTVWVExJU0lRbTF2UXNXNmtBblpKUjVzT0hzaG50Q2tpWU9l?=
 =?utf-8?B?T2pDWFlyNWM2TzVnZ3p1ZWw4OFJmeE5JRDJuT1RLelhTbitMcjc5S3BMdVlh?=
 =?utf-8?B?U3luRnFWQXFuN3ovemY4RFIxVklLWk1EaUVyaEc2eE9CVHpDN1NLTmN1dHV1?=
 =?utf-8?B?djJ0WUZkNlFWK2grYUZ2UW9VdmdKZ09Lb2FlNVpLUldBelg2Qk42RTg2dklj?=
 =?utf-8?B?UlRxOVhoUmczWVZwa1Nzc0ZOcklvYUxNZGwxR3pGa3lsRGxweGtDbTF4RDRt?=
 =?utf-8?B?R2RZMkNWVFBKYThpT1c0VVIwcVAxbFZ6YU5nRDNZZStLMTNORHBiOTFaY0w4?=
 =?utf-8?B?bFFOQ1A5c0VHcnFGcFpaYm94U2NjNU1NVUFmSVJTb2xvOUZZZXlROVEwaE40?=
 =?utf-8?B?VVprRllQWGpWTFE1M0tiVGZLbTdnTlNNdzV0Q0c0RHlScEFoYjBJTVpSbDlM?=
 =?utf-8?B?U1A2REp2eHFIdW5XWlM2aldaTUhmNngyN2k0dzJvaXN6OWRVWHBQTHdQNktk?=
 =?utf-8?B?eWhqVnNpanp5L3ptWTh3RFBzRldmS0tRRjNDa2k5bFFIdjIzV2pTbExpcDlQ?=
 =?utf-8?B?UU1SS251SWVQbGE4M3hsNUM0UVFtMnNKOHllVEg0ODltQmFTN3l1WXNUbkov?=
 =?utf-8?B?Mm82dHBBWXAza1hxRDdYRU84dStJTE5mWXI2RWxHeVp3Tkc3RVA2OFJ5M1Nv?=
 =?utf-8?B?aTl5TVdXMHg0MTVVcFplVHFGbWFGVk9JT0tNaGpNKzNxbmVSNkd3Y0g1Q05M?=
 =?utf-8?Q?BWfw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa76e2e-f0fb-478c-3817-08db7121de83
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 00:04:08.3761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z1++lPtr814dV5HHpPh96x0Cht/8FNlb0uX6XoANRPJs2+3Ayk3gkvUaFuNAa53Rg0FscXqb1fxvxiNK0uf9Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7552
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

PiA+T2theSwgaXQncyBhIGJpdCB3aXJlZCB0byBtZSB0byByZW5hbWUgYmVmb3JlIGFueSBhY3R1
YWwgY29kZSBsb2dpYyBjaGFuZ2UuDQo+ID4NCj4gDQo+IFdlaXJkIG9yIG5vdCwgdGhhdCdzIHRo
ZSBlc3RhYmxpc2hlZCBwcmFjdGljZS4NCj4gDQo+IEhvd2V2ZXIsIGlmIHlvdSB0aGluayBhYm91
dCBpdCwgaXQgbWFrZXMgc2Vuc2U6IHRoYXQgd2F5IHlvdXIgY29kZSBsb2dpYyBwYXRjaA0KPiBk
b2Vzbid0IGNvbnRhaW4gYSBidW5jaCBvZiBuYW1lcyB3aGljaCB3aWxsIGFsbW9zdCBpbW1lZGlh
dGVseSBiZSBvdXRkYXRlZC4gVGhhdA0KPiBpcyAqcmVhbGx5KiBjb25mdXNpbmcgd2hlbiB5b3Ug
YXJlIGdvaW5nIGJhY2sgdGhyb3VnaCB0aGUgZ2l0IGhpc3RvcnksIGZvciBleGFtcGxlLg0KDQpU
aGFua3MgZm9yIHRoZSBjbGFyaWZpY2F0aW9uIQ0KICBYaW4NCg==
