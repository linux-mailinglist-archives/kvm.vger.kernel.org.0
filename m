Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E2667D789
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 22:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjAZVTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 16:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjAZVTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 16:19:09 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1375C71679;
        Thu, 26 Jan 2023 13:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674767944; x=1706303944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q7p4FKtXir0RwruJKKeIPwSOlbEhP7HcavNhaZZVukI=;
  b=gisl6JvZEimcT8jYyfedduE5gyBnuaEAy5YbpzMiM1ASYWG7yxogCR8H
   SxuHZIEgyqHJGoNxD7XadoKky21wBDGCVaazFDGmsxB+KgrHzIvUf+enm
   daQZOmVW3yZ5mnCF65v9sHzxV5a15+fIkxT/MAAJcNoFL8O4Sj8tjERfq
   LgdmDr981tvceSIe8NykGuFnWBDi+BjL0dPqIosRcOpJTPJGhpfDBpXw3
   PELgfKGcY28T4GUH6pbUCg8/3leYr8SW11m6AZy+/Iw528X4DGADZElDE
   zkH/Ia2FUii9Z7b91VzdoaTBPrMQw77G6LOcgEn23AEsXorSGb+qBDr3S
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="306601173"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="306601173"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 13:19:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="695270217"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="695270217"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2023 13:19:03 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 13:19:02 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 26 Jan 2023 13:19:02 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 26 Jan 2023 13:18:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGJ+AtW5SjLPC8ePA2p8q3lpGRCy7lo/30HeOF9ohL+M6RhnzJ6Y0XDus0EndKRC6SUiSZysQ37m+eDFhfdEp3EGvaYxffSKGOZvo77ILJocX1yE0hmux/t4TTF79IkwcCGNrFjWCYnnqrb4M5dcn3IZD/1By9mmctGEwK9CETWxBKQdo3tJI7XcGSyJ9ymXn2EoOpeYvc8ycQJwaqM4riiUBI/ARUHmwonhzUGzTXCdpTL+4oEuc1vsagkIfigza5DtB/LAziMAQlIm4W7xH8jeMwtlyM4Bn1dTOOC+p8cyEImGT5es0y+BQhSBBw8JNFq7eXmYtGypmhjEkjRuuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7p4FKtXir0RwruJKKeIPwSOlbEhP7HcavNhaZZVukI=;
 b=kbEAv6gKK70XEWumqzybwztNN/kGCxxX+O7J+8N3q2PKfgP5RjeaTNEOnenubanrK7qTikw/eOqzrONY9t0h6SZgfeFH9hIitUq5+qxfHDXI9z8EDyvFKTsLBP7m8es8EXkytOXJEJFzDRJo+XCVyenwEMmX1YQd5L4Ufj1Uu6yCGx04ivnMmlzsxTrk7RBOb77qAZHOqxvvIr4jDz0/+e89zYYhWIhr25yD6Hb9bEK1ZzyZTsGV/UsTXVDkt5Y8DpwK2AxyjIRU1a/Morp9IpvCtEE1lWcLbOIgOveSn999jLU1xYL4nyJohywck0KjDCAQWQeO7DM06lFpMJMqaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6149.namprd11.prod.outlook.com (2603:10b6:8:9e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 21:18:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 21:18:55 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGAgAAP1gCAACa5AIAABg4AgAFyH4CAAB7oAIADQFwAgAEJgQCABEVHAIAAbgUAgABAawA=
Date:   Thu, 26 Jan 2023 21:18:55 +0000
Message-ID: <144de0bf7cc86dd7807f1b559c3269bccbb56317.camel@intel.com>
References: <Y8ljwsrrBBdh1aYw@google.com>
         <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
         <Y8m34OEVBfL7Q4Ns@google.com>
         <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
         <Y8ndcGHUHQjHfbF9@google.com>
         <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
         <Y8st2PjGDQ+Q0LlW@google.com>
         <3951e178bc38191074f5cccadc442212ff15c737.camel@intel.com>
         <Y87GzHrx8vxZLBEJ@google.com>
         <e5912f7d04ce7a27a68ce4328fc50ce594295c6c.camel@intel.com>
         <Y9K4Mnx/Je4j+RsD@google.com>
In-Reply-To: <Y9K4Mnx/Je4j+RsD@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6149:EE_
x-ms-office365-filtering-correlation-id: cd0322c7-36e0-4576-68d5-08daffe2ee9d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tcq7O6+mqmAjzrD5hfTP8xnEspXT59hnbRodSDUth/YlIY7lCDz/VV8Skr4VsKuE7uwX69zpZndmrQ84Sv07y2boEi+DMtT/FZJAH7DzjnYwFCC2VcDbb1+KQlAUW8KL7TnpId8Ql9WHO5fpy3b5SFdPkZExvSFuSk9aclKBDGOqQCTx2zaoPGYfOCFW+r/uWjG0rS1o3Fje+i8cudTHka5Iab6OMERXcGv7hhqoU2hkWOUpJ+6XS+BWQribwC95XHZhvT/qKE6Xm2LMqzj3s6cuFdcJK2+OKTnW076btHczW7p0pikGq00D2IpiXpgx7C5j15geDjsWZagxdWlEpxvwBxZIJEnXe/Bcb8upAvqzt9YaiPIioHYBE1ad/sJD7oL7XNvj6ksXhWAj/hfcvDWaTl2ij/mOLuaotcsuxIb/8Zkq1WXfyMh4ciGfUQMO/U+379UsB+BFYB53h4OVli9taApmmd9mlv9iLsuOJlLgq5I5bgUohMWA+26Y8rPTRc+dlLkBldSuiNZPfO4bRrPFDL/y5137UugsgG7hPeTmeLPs5q2+WH/aY/+XwVmWJ6FKDPp9bQyq08zuTaeNo+BZAM5WngMyPt3LnPgmvxDPhthG6hZNW79JUgN1QAEvFW9J/apUIJURityqMX3e/N9tngJWiihd441jM+Baj8eRr4DWLg/epEMzQCZgrOleuJfBB2bkL2gsNdlSrSuvzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199018)(38100700002)(122000001)(86362001)(36756003)(38070700005)(54906003)(82960400001)(2906002)(6512007)(66476007)(66899018)(41300700001)(8936002)(66946007)(76116006)(66556008)(4326008)(91956017)(8676002)(6916009)(186003)(64756008)(5660300002)(66446008)(6506007)(2616005)(26005)(316002)(6486002)(478600001)(83380400001)(107886003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXJDRmplWmhqclV6bmN3K2ViUDFCeEovTlptaUFWUzN3SC9Hek4veVhtWGhk?=
 =?utf-8?B?NXArQldlc0p5VlRMUGUxckNGdzM2dDZZOEVBamh2VXoyamx3VjZsMk5YNTFu?=
 =?utf-8?B?MERyN1RNZkR4U3poZ0JLekx4aFEyMklFSjBpZkttYWxPVWVvYlordk1XVS81?=
 =?utf-8?B?Wnc0d3owTkI0QzdEYVdLRUVnTFhPNEpKYUlPNTN0VWx3cjlFckdnWXBYbmRa?=
 =?utf-8?B?L0pTN3c5MGVVMjdoMW5RVEN1TFNYN1RJQnJqbUs1SEVBWlpFdW1oeTNiMlJJ?=
 =?utf-8?B?SlhuVERoVEppOThkT2lDNVY4T3pNaHU0eGw3UnN0WGVQSWw4MW4zZ3pBcWFV?=
 =?utf-8?B?eHRKUzBteHk1T3lnUHVOQ1lRVTc5VlFWVWhlUXBhUFJzQnBJT0ZxWW1PRDB6?=
 =?utf-8?B?RkVndnc1SVlGaDJzaTErWHROTmo2TEZ1L2VDUGZyTFlhalZLT0ZHS2RtcGJm?=
 =?utf-8?B?SklOV2l6NGMrVVVmZkdCZGd0blh2SlFURUp4bVd2bDhRM1loR0p1N2hVS1A3?=
 =?utf-8?B?Z1h4UDY3WW9mN0EzdmllN1o5ZXluTDUwTnNWQUhpeEpjK0NPK0I5YVVLYWJj?=
 =?utf-8?B?YjlTSCtUcCtXdVBVT2l6eUNra1VtQnNaNGFwWk40N1k4TENXMmV0Yi9sMjZt?=
 =?utf-8?B?bkJhem5zMkhtSjFXeC94SHl5WGdWOGRnNU9oL1VHaW53Mk1vR3ArUU4xLzkx?=
 =?utf-8?B?TC9UMjh1K0lEMlZMcW5QemhvV2NMdTBmZUh0emJWKzdXbjhReFVNdTZHN0xY?=
 =?utf-8?B?eTFPRnp1UzhibElHS09XVlh4bzJ2bHBhWjB2MGV5cWxVUU1Tb204eUIzVUhQ?=
 =?utf-8?B?SmZlZmk3ckRJV2FSUVREUGpUTTUxcGVld2hFNHF5WnUycktUR3VXUEdRWkV5?=
 =?utf-8?B?QjRYdHZMM2gvSVNkeWkreXBRU3pSc3k5ZEo1N0FHSGRwUlhKSkwvVGVyOHRD?=
 =?utf-8?B?VjZnSFJSVVBaY0NPa2RXbTNXNytncGRQNEN4b0NBblJKYVpQUDdtZUlxSjRS?=
 =?utf-8?B?WnhrVzBhV211RmF5a1QzZWZHSzdadUJUUHhmYzN6LzJ1TWhqRHl6NXo5MFFN?=
 =?utf-8?B?SGRLTjFCeFduVlROOGdRNGpmZ2VKMGdRSDRKUXB5M3RIemFJQ1B1YnV1T0I5?=
 =?utf-8?B?SGxaRWRkenhUU1A3OHRaYWY0ZFRKQ2EvMFRBWVBUV2lSZlZ3VS9WUTRFUS82?=
 =?utf-8?B?NDRJWkZyTXBKa1pKeEN3d2g2ZUhvUEhYS01aR1JVaXZmZ09UbUdIQkxEOXI1?=
 =?utf-8?B?Z2x0cUJwWE9wTXpFd0g2Ky9yK2IvOThmZFVyckFvUWhoUnp5NWNsVExvdHFJ?=
 =?utf-8?B?ME13VkhpMzZKY0dMZTg5WGVWenMwNGRiRnVYRXNFL1lJNnRNeS9DNll0bndL?=
 =?utf-8?B?OGNkV1d5K3JkV2lvUmZKNW1IUFdNa1BwN0JnV2lKODdHa29wUkM3ZVBUUnc5?=
 =?utf-8?B?SjZCVnVidlJmVGV4ZGJRWU9NTVJIZEx4dDlsQVJyTnQ4aC9EUUdIekRUcUF2?=
 =?utf-8?B?OHJHYzNLR2R0emhtTWt6VVpvVjRnTnd3dTR2d0tSakVrbitSUXRCU1JqeHFt?=
 =?utf-8?B?WXpLRUUvajV3RHRXdXFQay9TKzc2MFVnODVoTk5CQkJUcXdndE1Lby8rYWVh?=
 =?utf-8?B?OGN6U3QxSjB2aHlDRE1td0VaVE83Z0NxanZmRWtNcERQa1FrRmIyZEV1dUlW?=
 =?utf-8?B?SWNXNXdLWjNBRjlRdjRxV1l6SGJEV2tYVmhFOEdwdVc1SFpYK2pueXdheGUr?=
 =?utf-8?B?c3BOV3dEQllnV1pUZHdia2hkSE5yNnYraitSNm9zMFM0eEhIZTRvSzdvb1h3?=
 =?utf-8?B?b0N0c3diYzdMcjYwTG9DSDdkSnZIT21WYjVraDEvMkkwcUhpRFJLUjc5ZlVB?=
 =?utf-8?B?UWJ5Ymk0V1VRWGpwcVZwemNpV20xYXNjNFJXakNDQmtwbytidzhMbmNxcUVQ?=
 =?utf-8?B?YnBkekZWSVFRc1NqMXdGb3psSEZ3RnJFeWlpM3p0dksyQjlvOGhkOFl4Yksv?=
 =?utf-8?B?dmlSY3lsYVBlY2NZSXNIak8yWE5HbFNsUlh5dTRjNnUrZGJ0cUl5ZmJEL3Jk?=
 =?utf-8?B?WmFiRzZnTE0zVHRaT3cxOCtseUFaY2xRTlZ2L0NId3dYanhkUEN1cS9FTU5q?=
 =?utf-8?B?RDdGY0JrSDZqMUx6Mm9xUDgvcmIwMElWczM2NStlOGFUcUJXaDV2NnNjcGlJ?=
 =?utf-8?B?NWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA5B3899D1BD294BA3B4728C3DCFA2A8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0322c7-36e0-4576-68d5-08daffe2ee9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 21:18:55.7175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bO2loeboKH+dV157WDS012CJTctc9j93NIdsG2tN4l+seoGCJw+xp1iHT1RLLlfYjkUeGP5Qu07X6WbaZxDEEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6149
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTI2IGF0IDE3OjI4ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAyNiwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBN
b24sIDIwMjMtMDEtMjMgYXQgMTc6NDEgKzAwMDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBJIHRoaW5rIHRoZXJlJ3MgYW4gb3Bwb3J0dW5pdHkgYW5kIG1vdGl2YXRpb24gdG8g
aW1wcm92ZSB0aGUgVERQIE1NVSBhcyBhIHdob2xlIG9uDQo+ID4gPiB0aGlzIGZyb250IHRob3Vn
aC4gIFJhdGhlciB0aGFuIHJlY3Vyc2l2ZWx5IHphcCBjaGlsZHJlbiBpbiBoYW5kbGVfcmVtb3Zl
ZF9wdCgpLA0KPiA+ID4gd2UgY2FuIHVzZSB0aGUgUkNVIGNhbGxiYWNrIHRvIHF1ZXVlIHRoZSBw
YWdlIHRhYmxlIGZvciByZW1vdmFsLiAgU2V0dGluZyB0aGUgcGFyZW50DQo+ID4gPiAodGFyZ2V0
IHBhZ2UgdGFibGUpICFQUkVTRU5UIGFuZCBmbHVzaGluZyB0aGUgVExCcyBlbnN1cmVzIHRoYXQg
YWxsIGNoaWxkcmVuIGFyZQ0KPiA+ID4gdW5yZWFjaGFibGUsIGkuZS4gS1ZNIGRvZXNuJ3QgbmVl
ZCB0byBpbW1lZGlhdGVseSBzZXQgY2hpbGRyZW4gIVBSRVNFTlQuICBVbmxpa2UNCj4gPiA+IHRo
ZSBzaGFkb3cgTU1VLCB3aGljaCBtYWludGFpbnMgYSBoYXNoIHRhYmxlIG9mIHNoYWRvdyBwYWdl
cywgb25jZSBhIHBhcmVudCBwYWdlDQo+ID4gPiB0YWJsZSBpcyByZW1vdmVkIGZyb20gdGhlIFRE
UCBNTVUsIGl0cyBjaGlsZHJlbiBhcmUgdW5yZWFjaGFibGVkLg0KPiA+IA0KPiA+IERvIHlvdSBt
ZWFuIHNvbWV0aGluZyBsaWtlIChwc2V1ZG8pOg0KPiA+IA0KPiA+IAlyY3VfY2FsbGJhY2soJnJl
bW92ZWRfc3AtPnJjdV9oZWFkLCBoYW5kbGVfcmVtb3ZlZF9wdCk7DQo+IA0KPiBZZXAuDQo+IA0K
PiA+ID4gVGhlIFJDVSBjYWxsYmFjayBtdXN0IHJ1biBpbiBuZWFyLWNvbnN0YW50IHRpbWUsIGJ1
dCB0aGF0J3MgZWFzeSB0byBzb2x2ZSBhcyB3ZQ0KPiA+ID4gYWxyZWFkeSBoYXZlIGEgd29ya3F1
ZXVlIGZvciB6YXBwaW5nIHBhZ2UgdGFibGVzLCBpLmUuIHRoZSBSQ1UgY2FsbGJhY2sgY2FuIHNp
bXBseQ0KPiA+ID4gYWRkIHRoZSB0YXJnZXQgcGFnZSB0byB0aGUgemFwIHdvcmtxdWV1ZS4gIFRo
YXQgd291bGQgYWxzbyBhbGxvdyBmb3IgYSAodmVyeSBtaW5vcikNCj4gPiA+IHNpbXBsaWZpY2F0
aW9uIG9mIG90aGVyIFREUCBNTVUgY29kZTogdGRwX21tdV96YXBfcm9vdCgpIHdvdWxkbid0IG5l
ZWRlZCB0byB6YXAgaW4NCj4gPiA+IHR3byBwYXNzZXMgc2luY2UgemFwcGluZyBjaGlsZHJlbiBv
ZiB0aGUgdG9wLWxldmVsIFNQVEVzIHdvdWxkIGJlIGRlZmVycmVkIHRvIHRoZQ0KPiA+ID4gd29y
a3F1ZXVlLg0KPiA+IA0KPiA+IERvIHlvdSBtZWFuIHphcHBpbmcgdGhlIGVudGlyZSBwYWdlIHRh
YmxlIChmcm9tIHJvb3QpIGRvZXNuJ3QgbmVlZCB0byBiZSBpbiBSQ1UNCj4gPiByZWFkLWNyaXRp
Y2FsIHNlY3Rpb24sIGJ1dCBjYW4vc2hvdWxkIGJlIGRvbmUgYWZ0ZXIgZ3JhY2UgcGVyaW9kPyAg
SSB0aGluayB0aGlzDQo+ID4gbWFrZXMgc2Vuc2Ugc2luY2UgemFwcGluZyBlbnRpcmUgcm9vdCBt
dXN0IGhhcHBlbiB3aGVuIHJvb3QgaXMgYWxyZWFkeSBpbnZhbGlkLA0KPiA+IHdoaWNoIGNhbm5v
dCBiZSB1c2VkIGFueW1vcmUgd2hlbiB0aGUgbmV3IGZhdWx0cyBjb21lIGluPw0KPiANCj4gWWVz
LCBtaW51cyB0aGUgImZyb20gcm9vdCIgcmVzdHJpY3Rpb24uICBXaGVuIGEgcGFnZSB0YWJsZSAo
Y2FsbCBpdCAiYnJhbmNoIiB0bw0KPiBjb250aW51ZSB0aGUgYW5hbG9neSkgUFRFIGhhcyBiZWVu
IHphcHBlZC9ibG9ja2VkICgicHJ1bmVkIiksIEtWTSBqdXN0IG5lZWRzIHRvDQo+IHdhaXQgZm9y
IGFsbCBwb3RlbnRpYWwgcmVhZGVycyB0byBnbyBhd2F5LiAgVGhhdCBndWFyYW50ZWUgaXMgcHJv
dmlkZWQgYnkgUkNVOw0KPiBzb2Z0d2FyZSB3YWxrZXJzLCBpLmUuIEtWTSBpdHNlbGYsIGFyZSBy
ZXF1aXJlZCB0byBob2xkIFJDVSwgYW5kIGhhcmR3YXJlIHdhbGtlcnMsDQo+IGkuZS4gdkNQVXMg
cnVubmluZyBpbiB0aGUgZ3Vlc3QsIGFyZSBwcm90ZWN0ZWQgYnkgcHJveHkgYXMgdGhlIHphcHBl
ciAoImFyYm9yaXN0Ij8pDQo+IGlzIHJlcXVpcmVkIHRvIGhvbGQgUkNVIHVudGlsIGFsbCBydW5u
aW5nIHZDUFVzIGhhdmUgYmVlbiBraWNrZWQuDQoNClllcy4NCg0KPiANCj4gSW4gb3RoZXIgd29y
ZHMsIG9uY2UgdGhlIFBURSBpcyB6YXBwZWQvYmxvY2tlZCAoYnJhbmNoIGlzIHBydW5lZCksIGl0
J3MgY29tcGxldGVseQ0KPiByZW1vdmVkIGZyb20gdGhlIHBhZ2luZyB0cmVlIGFuZCBubyBvdGhl
ciB0YXNrcyBjYW4gYWNjZXNzIHRoZSBicmFuY2ggKHBhZ2UgdGFibGUNCj4gYW5kIGl0cyBjaGls
ZHJlbikuICBJLmUuIHRoZSBvbmx5IHJlbWFpbmluZyByZWZlcmVuY2UgdG8gdGhlIGJyYW5jaCBp
cyB0aGUgcG9pbnRlcg0KPiBoYW5kZWQgdG8gdGhlIFJDVSBjYWxsYmFjay4gIFRoYXQgbWVhbnMg
dGhlIFJDVSBjYWxsYmFjayBoYXMgZXhjbHVzaXZlIGFjY2VzcyB0byB0aGUNCj4gYnJhbmNoLCBp
LmUuIGNhbiBvcGVyYXRlIGFzIGlmIGl0IHdlcmUgaG9sZGluZyBtbXVfbG9jayBmb3Igd3JpdGUu
ICBGdXJ0aGVybW9yZSwgdGhlDQo+IFJDVSBjYWxsYmFjayBhbHNvIGRvZXNuJ3QgbmVlZCB0byBm
bHVzaCBUTEJzIGJlY2F1c2UgdGhhdCB3YXMgYWdhaW4gZG9uZSB3aGVuDQo+IHBydW5pbmcgdGhl
IGJyYW5jaC4NCj4gDQo+IEl0J3MgdGhlIHNhbWUgaWRlYSB0aGF0IEtWTSBhbHJlYWR5IHVzZXMg
Zm9yIHJvb3QgU1BzLCB0aGUgb25seSBkaWZmZXJlbmNlIGlzIGhvdw0KPiBLVk0gZGV0ZXJtaW5l
cyB0aGF0IHRoZXJlIGlzIGV4YWN0bHkgb25lIGVudGl0eSB0aGF0IGhvbGRzIGEgcmVmZXJlbmNl
IHRvIHRoZSBTUC4NCg0KUmlnaHQuICBUaGlzIHdvcmtzIGZpbmUgZm9yIG5vcm1hbCBub24tVERY
IGNhc2UuICBIb3dldmVyIGZvciBURFggdW5mb3J0dW5hdGVseQ0KdGhlIGFjY2VzcyB0byB0aGUg
cmVtb3ZlZCBicmFuY2ggKG9yIHRoZSByZW1vdmVkIHN1Yi1wYWdlLXRhYmxlKSBpc24ndCB0aGF0
DQoiZXhjbHVzaXZlIiBhcyB0aGUgU0VBTUNBTEwgdG8gdHJ1bHkgemFwIHRoYXQgYnJhbmNoIHN0
aWxsIG5lZWRzIHRvIGhvbGQgdGhlDQp3cml0ZSBsb2NrIG9mIHRoZSBlbnRpcmUgU2VjdXJlIEVQ
VCB0cmVlLCBzbyBpdCBjYW4gc3RpbGwgY29uZmxpY3Qgd2l0aCBvdGhlcg0KdGhyZWFkcyBoYW5k
bGluZyBuZXcgZmF1bHRzLg0KDQpUaGlzIGlzIGEgcHJvYmxlbSB3ZSBuZWVkIHRvIGRlYWwgd2l0
aCBhbnl3YXkuDQoNCj4gDQo+ID4gPiBCYWNrIHRvIFREWCwgdG8gcGxheSBuaWNlIHdpdGggdGhl
IHJlc3RyaWN0aW9uIHRoYXQgcGFyZW50cyBhcmUgcmVtb3ZlZCBvbmx5IGFmdGVyDQo+ID4gPiBj
aGlsZHJlbiBhcmUgcmVtb3ZlZCwgSSBiZWxpZXZlIEtWTSBjYW4gdXNlIFRESC5NRU0uUkFOR0Uu
QkxPQ0sgdG8gbWFrZSB0aGUgcGFyZW50DQo+ID4gPiAhUFJFU0VOVC4gIFRoYXQgd2lsbCBlZmZl
Y3RpdmVseSBwcnVuZSB0aGUgUy1FUFQgZW50cnkgYW5kIGFsbCBpdHMgY2hpbGRyZW4sIGFuZA0K
PiA+ID4gdGhlIFJDVSBjYWxsYmFjayB3aWxsIGFnYWluIGVuc3VyZSBhbGwgaW4tZmxpZ2h0IFNF
QU1DQUxMcyBmb3IgdGhlIGNoaWxkcmVuIGNvbXBsZXRlDQo+ID4gPiBiZWZvcmUgS1ZNIGFjdHVh
bGx5IHRyaWVzIHRvIHphcCB0aGUgY2hpbGRyZW4uDQo+ID4gDQo+ID4gUmVhZGluZyB0aGUgc3Bl
YywgaXQgc2VlbXMgVERILk1FTS5SQU5HRS5CTE9DSyBvbmx5IHNldHMgdGhlIFNlY3VyZSBFUFQg
ZW50cnkNCj4gPiB3aGljaCBwb2ludHMgdG8gdGhlIGVudGlyZSByYW5nZSBhcyAiYmxvY2tlZCIs
IGJ1dCB3b24ndCBnbyBkb3duIHVudGlsIGxlYWYgdG8NCj4gPiBtYXJrIGFsbCBFUFQgZW50cmll
cyBhcyAiYmxvY2tlZCIsIHdoaWNoIG1ha2VzIHNlbnNlIGFueXdheS4NCj4gPiANCj4gPiBCdXQg
aXQgc2VlbXMgVERILk1FTS5QQUdFLlJFTU9WRSBhbmQgVERILk1FTS5TRVBULlJFTU9WRSBib3Ro
IG9ubHkgY2hlY2tzDQo+ID4gd2hldGhlciB0aGF0IHRhcmdldCBFUFQgZW50cnkgaXMgImJsb2Nr
ZWQiLCBidXQgZG9lc24ndCBjaGVjayB3aGV0aGVyIGFueSBwYXJlbnQNCj4gPiBoYXMgYmVlbiBt
YXJrZWQgYXMgImJsb2NrZWQiLiAgTm90IHN1cmUgd2hldGhlciB0aGlzIHdpbGwgYmUgYSBwcm9i
bGVtLiAgQnV0DQo+ID4gYW55d2F5IGlmIHRoaXMgaXMgYSBwcm9ibGVtLCB3ZSBwZXJoYXBzIGNh
biBnZXQgVERYIG1vZHVsZSB0byBmaXguDQo+IA0KPiBPaCwgSSBkaWRuJ3QgbWVhbiB0byBzdWdn
ZXN0IEtWTSBza2lwIFRESC5NRU0uUkFOR0UuQkxPQ0sgZm9yIGNoaWxkcmVuLCBJIHNpbXBseQ0K
PiBmb3Jnb3QgdGhhdCBhbGwgUy1FUFQgZW50cmllcyBuZWVkIHRvIGJlIGJsb2NrZWQgYmVmb3Jl
IHRoZXkgY2FuIGJlIHJlbW92ZWQuDQo+IA0KPiA+ID4gQW5kIGlmIHdlIHJld29yayB6YXBwaW5n
IHBhZ2UgdGFibGVzLCBJIHN1c3BlY3Qgd2UgY2FuIGFsc28gYWRkcmVzcyBEYXZpZCdzIGNvbmNl
cm4NCj4gPiA+IChhbmQgbXkgbm90LXlldC12b2ljZWQgY29uY2VybikgYWJvdXQgcG9sbHV0aW5n
IHRoZSBURFAgTU1VIGNvZGUgd2l0aCBsb2dpYyB0aGF0IGlzDQo+ID4gPiBuZWNlc3Nhcnkgb25s
eSBmb3IgUy1FUFQgKGZyZWV6aW5nIFNQVEVzIGJlZm9yZSBwb3B1bGF0aW5nIHRoZW0pLiAgUmF0
aGVyIHRoYW4gdXBkYXRlDQo+ID4gPiBTLUVQVCBfYWZ0ZXJfIHRoZSBURFAgTU1VIFNQVEUsIGRv
IHRoZSBTLUVQVCB1cGRhdGUgZmlyc3QsIGkuZS4gaW52b2tlIHRoZSBLVk0gVERYDQo+ID4gPiBo
b29rIGJlZm9yZSB0cnlfY21weGNoZzY0KCkgKG9yIG1heWJlIGluc3RlYWQgb2Y/KS4gIFRoYXQg
d2F5IEtWTSBURFggY2FuIGZyZWV6ZSB0aGUNCj4gPiA+IHRvLWJlLWluc3RhbGxlZCBTUFRFIHdp
dGhvdXQgY29tbW9uIFREUCBNTVUgbmVlZGluZyB0byBiZSBhd2FyZSBvZiB0aGUgY2hhbmdlLg0K
PiA+IA0KPiA+IEkgZG9uJ3QgcXVpdGUgdW5kZXJzdGFuZCBob3cgcHV0dGluZyBTRUFNQ0FMTCBi
ZWZvcmUgdGhlIHRyeV9jbXB4Y2hnNjQoKSBjYW4NCj4gPiB3b3JrLiAgTGV0J3Mgc2F5IG9uZSB0
aHJlYWQgaXMgcG9wdWxhdGluZyBhIG1hcHBpbmcgYW5kIGFub3RoZXIgaXMgemFwcGluZyBpdC4g
DQo+ID4gVGhlIHBvcHVsYXRpbmcgdGhyZWFkIG1ha2VzIFNFQU1DQUxMIHN1Y2Nlc3NmdWxseSBi
dXQgdGhlbiB0cnlfY21weGNoZzY0KCkNCj4gPiBmYWlscywgaW4gdGhpcyBjYXNlIGhvdyB0byBw
cm9jZWVkPw0KPiANCj4gQWgsIHNvcnJ5LCB0aGF0IHdhcyB1bmNsZWFyLiAgQnkgImludm9rZSB0
aGUgS1ZNIFREWCBob29rIiBJIGRpZG4ndCBtZWFuICJkbyB0aGUNCj4gU0VBTUNBTEwiLCBJIG1l
YW50IEtWTSBURFggY291bGQgZG8gaXRzIG93biBtYW5pcHVsYXRpb24gb2YgdGhlIEtWTS1tYW5h
Z2VkIFNQVEVzDQo+IGJlZm9yZSB0aGUgY29tbW9uL3N0YW5kYXJkIGZsb3cuICBFLmcuIHNvbWV0
aGluZyBsaWtlOg0KPiANCj4gCWlmIChrdm1feDg2X29wcy5zZXRfcHJpdmF0ZV9zcHRlICYmIHBy
aXZhdGUpDQo+IAkJciA9IHN0YXRpY19jYWxsKGt2bV94ODZfc2V0X3ByaXZhdGVfc3B0ZSguLi4p
DQo+IAllbHNlDQo+IAkJciA9IHRyeV9jbXB4Y2hnNjQoLi4uKSA/IDAgOiAtRUJVU1k7DQo+IA0K
PiBzbyB0aGF0IHRoZSBjb21tb24gY29kZSBkb2Vzbid0IG5lZWQgdG8gZG8sIG9yIGV2ZW4gYmUg
YXdhcmUgb2YsIHRoZSBmcmVlemluZy4NCj4gVGhlbiBJIHRoaW5rIHdlIGp1c3QgbmVlZCBhbm90
aGVyIGhvb2sgaW4gaGFuZGxlX3JlbW92ZWRfcHQoKSwgb3IgbWF5YmUgaW4gd2hhdA0KPiBpcyBj
dXJyZW50bHkgX19rdm1fdGRwX21tdV93cml0ZV9zcHRlKCk/DQo+IA0KPiBJLmUuIGZ1bGx5IHJl
cGxhY2UgdGhlICJ3cml0ZSIgb3BlcmF0aW9ucyBpbiB0aGUgVERQIE1NVSBpbnN0ZWFkIG9mIHRy
eWluZyB0bw0KPiBzbXVzaCBTLUVQVCdzIHJlcXVpcmVtZW50cyBpbnRvIHRoZSBjb21tb24gcGF0
aC4NCg0KSSBoYXZlIG5vIHByZWZlcmVuY2UgYnV0IGxvb2tzIGJldHRlciB0byBtZSBhcyB0aGUg
YmVuZWZpdHMgeW91IG1lbnRpb25lZCBhYm92ZS4NCjopDQo=
