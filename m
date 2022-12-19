Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA63650A51
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 11:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiLSKrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 05:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiLSKrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 05:47:04 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A611C958D;
        Mon, 19 Dec 2022 02:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671446821; x=1702982821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=G5gqUoCkuPKi1+ZeSj08Mn8tMlwk0ihv+ZHJHouuhBI=;
  b=ZSA8c59zBAaOLycG9JFrP8dnA/U0tAFeAfCsXqldpn4c9XLFZ6g8v+0b
   fyK85Acm5xnh5W9Eeo2YZNTadIxJQglsQUKQMRvqdn0yRdy8kSBATgCIz
   dSQL1nmbr4rI5ufFwUwOwQQWCsT2ATyhCxNDHEQvBlU1h0UcQzDfQEM2c
   p38WBr2QQicfpYCOcttHa5YWQk2OJVL0zP2YIlJEX3oxBMSd2c817iG8c
   ttenOkQjlHxDoWFwZWE5QgewtWYhidMfDRreLwn13WzoIah8F+/n/XsoB
   i+mRB+gCcQrnosI6LPiYSgVJgXZdJrcPEpfbObzppI/5z+2XhlAIRCHEP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="299653037"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="299653037"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 02:47:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="979332547"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="979332547"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 19 Dec 2022 02:47:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 02:47:00 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 02:47:00 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 02:47:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPxWNEAVxpaHPpzh0n6nCJdhuohDSrUwO7eI+M0A2vRXqtkDd7CE4BIebKHO7VdIdY5nfhe0v6jxCZlaVRvEaIWy0wAsWJizpDyMDx7SjHF8mzPdYl6e5x+gU319CXp+1sYtDmsE1vCjPqOznadKXFbpBKUSu8t6fG0UU8WsqgvAcX/wbjxN4KyeRy/iKaoFm9n7As4nVAJfvW2HsdOpFUM9X/VAcn/oAOmvDLMEnoa8PbKrzK/j3aWkGhV3NZbqK5YBhk33qADZGQaCmUJlcIjOvFEv7PKGn8AKZC+x138lysgMZIj9VjVHPZ1lF7xURh9BdiKkms6ZAQxhaFKlnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5gqUoCkuPKi1+ZeSj08Mn8tMlwk0ihv+ZHJHouuhBI=;
 b=NS1ombpzk7Dl8q5CZTugbMxurlz3AIESccr4DcWvkG7miESMVK/H0Y5wOqafyC2KjcHlhBai/lK6wDJiuJeqBll9FDmZ4AMqo+Y22f8mzMl15K7MfAvT4fufR0nVrO29jVeZj3gyYXKrnKVV5uS6GjLQaovswyRWdmlzBkHYIvObuF1maHc8EtmFWf+2sUvEw1JNrfDxfrQsL6iycI6FLNR9mrANIVKyShgSbeQsFkW+QEhn0amOHdS1JYxYOiaPDux1akqTUb9hVVB0bIk0697Q1An2XLhyD5ST33C6AZdL+zDhr6TSERO+fQmTO4wsmAMGD81EE7s6XM/Boxv3Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6953.namprd11.prod.outlook.com (2603:10b6:510:204::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 19 Dec
 2022 10:46:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 10:46:57 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 105/108] KVM: TDX: Add methods to ignore accesses to
 CPU state
Thread-Topic: [PATCH v10 105/108] KVM: TDX: Add methods to ignore accesses to
 CPU state
Thread-Index: AQHY7Ckvrt4ExdXw0UaZ9PPNheleja5tiimAgAK7egCABRB3AA==
Date:   Mon, 19 Dec 2022 10:46:57 +0000
Message-ID: <3b4c7bf768f6b56d51c0c573863afca78a15cc6d.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <282dd5a8edbee0aa87cdf035088ecd8558b0b999.1667110240.git.isaku.yamahata@intel.com>
         <5dc0263aa963534bb049b61adbfb18dec3f65f00.camel@intel.com>
         <20221216052642.GF527635@ls.amr.corp.intel.com>
In-Reply-To: <20221216052642.GF527635@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6953:EE_
x-ms-office365-filtering-correlation-id: 6c976a12-e7ba-421b-a38f-08dae1ae59ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 91g1spJ57klKjb4SU9KPqoIUSm6+k48eAPowyw5n7ivGVQ+2hW4KInsYyTJqKRpmd1BpmGlb+YsMkLCtfojgfd1ZZwKKqNjbVOffCAugCJ/ORMEkcmIqCMiAZUsJ8uZqyMRZiWw5GmRWa8AL/vPjOJKk3kSmSMl7syPscnrjnNfn9BGE44J1yhSijFdfcrtRwywQtRyMmiQbXYL5KjHhOxjkRQdQ/WjvVUBPoVV3Ifoxn/ZCtcn1eHeWCCLHByEefXnVKerWiyZTyP6LvfDcUlxZjzi2IWFGDlvsx+qq2Vzp8Osv1kjBAo60Z1hq9JI2l4mS+sr1S2G07Ts/trOJKE7YSm69yjOrBKdoiAt7aMynQ2iz3EhAt9vU4h+ZdOWPubSvED+Jt2Q5XJV4xOvi2ygHXQ1rgetm1QgcA5w9170ZGwJAkNtUNSBL5K6vN6D182exVDRbJssTBfsV3k3gRI9UHV/chpVeZlr1hgEKdQzVIEj2L+gXcX+dn+4fmFM0m4g1RQ3GfcFE7nibThfoZG+2OAOhFRJebGR0pFdzB6JXrlB/wXh7psCgZlHcarc2JVSCP679Mful7B63flTxEPaSzaNic89fMqMII3B9qMKNEkAcmssbyj8UiOWrogWXwqjPcBuWATHVsIBdSPN4kzku7BQlv9bnSaBH5sD+zsBgUIf/T7YjM8qeK0uvrwvtTsXeOI6wn3OmizAe2gev8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(36756003)(54906003)(91956017)(4326008)(76116006)(8676002)(86362001)(38070700005)(478600001)(122000001)(316002)(38100700002)(82960400001)(186003)(83380400001)(6512007)(66946007)(26005)(6486002)(6506007)(66446008)(66476007)(2906002)(6916009)(8936002)(66556008)(2616005)(5660300002)(4001150100001)(64756008)(41300700001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTRneDA2bEpubm8vQ3dWaDFnM0VWL2ZDcnJabFZpaHA4cUhNaGVBUzFrbUp2?=
 =?utf-8?B?SmtNTUZ1QVJvakZaamRCbTErN1drWWhCTnlIaUhXdC9hVWJ2UWVleHRUVTJ0?=
 =?utf-8?B?RzEzWW5ZRU1ad0crSTBaNnNBZGhVYlYxaDZXbDEvYzJPN1pyWWpjMUxGZitq?=
 =?utf-8?B?SitlY1RDM0hTZzhKUjFJUlVndEUzemRXd2RHZ2hxd2tuVmJFNWFRcjhqNFJC?=
 =?utf-8?B?SHZ1cW8yZWEyakpCbFpmQTFsWG9wNEk1ZGh2ZGxzdHVaYmI4U1pId2U0U2cv?=
 =?utf-8?B?YnI0Z2V1TU9mbEFHcVV1N0ZHMzR1d05QaWlITm9tL3NMb2NjWEFvZDZoY2Zw?=
 =?utf-8?B?OGRSK0pNQ0VySW5TVFJlbThTUE8xSmM1d05JR1YzU2FzanBaRjlQM1l5S2NL?=
 =?utf-8?B?Qi8wQStJWlFjM00ydzNxcDRkRllndFpTUFk2RlVmNXRXeEZ5WXQrb3Q1VHRP?=
 =?utf-8?B?dWhlZktPb2c1d0NOV25hRnVwclpJZ2xHcnE1UEhvQU9qZktjU3pWY1R5aGpH?=
 =?utf-8?B?djdUWjVoOG8xemlPTlpkalNwRnRlaDFIN01MNG15MTg0Y2Y4bDFmajhtdjAz?=
 =?utf-8?B?UnpIMlZvd29vK1ppb2gwOE9yTWd1LzA1NjN6LzFyVElKVGxvRWRNUmRLMG5D?=
 =?utf-8?B?MGVUdWkwQ1J5d25VaGd0bjUwMUtTa1ROb1FjSnVtMG9oWmR4N0VvY1hMa1Vl?=
 =?utf-8?B?UWY1WUtXSERkZzVkQ0g1VDJzMUZDOXg5RHZNeTdiRG5zN2FvY0VELzZodTlY?=
 =?utf-8?B?VEhmMXhuVStiTHBMNjdvNHNyNEFZd3dTZS9nTXY0M0F4bEpJTS9jR3RoNEVS?=
 =?utf-8?B?WFZLRTNKemR6NWFLQ3NtbkZ0VFYvRUJJdTlISnd1cGJVNTQ2cm84eGtYUEJO?=
 =?utf-8?B?RFYzNWhzd1o2YWdCYWhYTUsrbEE4bFpQQWZDQk4yVktEZ0xORW1oK0J0ZkJC?=
 =?utf-8?B?RFE3bTFvNEoxbE1LWmxXQnlCMDJ4U2YwR1FtSVVXL2NLemdPaDZoK3F2SGZC?=
 =?utf-8?B?UUozWVZyVGI2SkVhcjdDY3A1YU5lSThFZmFiNGV1RzVFMDd4bExsMnI4eTl0?=
 =?utf-8?B?WnRweEVWZWRzZEdvVVNmd29LZnVZVTQxOGhtQ2FVYjZyb2x3YWViTmJVOFB3?=
 =?utf-8?B?MGd5Yk1SV0d2amh6M0o0MDRaSno1K3pjVDNoRlF1aWUvSHpHang5NXFldFpP?=
 =?utf-8?B?MzdFclVJR3VyVER6b29BL091TnRGSzZKSXRDdDQxOUE1dnczYm1KOFVTcXVH?=
 =?utf-8?B?VzNpVHhvWnZ2SVJXdHRpMEdGZGVSTVo0NURYemZJVnhKa2U3OGR6UGljZXln?=
 =?utf-8?B?TFJUNklXTVdmSTBxeHBSajNLUk1nNWZnQ2tEM2JUenVLNWtTai9tK2tmSlNw?=
 =?utf-8?B?ak9iVTRwVWVrMk1tcjN2bmd5bE95Q01pRGVNQ01jMWp3ZnRBQ3p6T2ZoWWRD?=
 =?utf-8?B?Vlp4ZW90V0t0Tm5IUnljRVZBN2FCV3FMeHJBSkxlRmdWVnZGcVFKejdzTFZW?=
 =?utf-8?B?VERzZHRiWWhZQngrNlFjcHlRbnFhWE1mcG56YnVJcm50MnptT0N4OTRDamht?=
 =?utf-8?B?VEMrbnlDZ1BHNUJFb1dUTkYvaHhwOW02R3doNStPK0FYazVhQzFMUWxVb1lQ?=
 =?utf-8?B?Sk96d0s2T1JRQ29RTk4wcnpEY3NkZWVUc3Npck04Y2hXZjYwRFFWdU1ZTXlK?=
 =?utf-8?B?bnBydzJLOG9URXEyWGR3bTVJREFhbTROOGJsbkd5SUNSQ0pFeDFvMVdmQkVz?=
 =?utf-8?B?MlNFd0xydnpKNnlRcTRDZHhrZFo2TXlLRlRRSmpQSXlVVjZsaGpJSDlMQ2tP?=
 =?utf-8?B?VWh0WXpZbGIrU01pQW1hRWdVR3RDMWc0Q0xiaGtTM3RRdlJNQzR3V3Z6QzNF?=
 =?utf-8?B?bFRtbSsrUG9qRGtDYkNWb0t3WUhlOHZTanJCOTJMTnRGamJNZEVlWGdJUEo0?=
 =?utf-8?B?M1hOOEpXWkNwbHA1OFNyL3ZtQ1orUkJOZkpMWFFRYW5GQXkyK3YxQ0NOVWF6?=
 =?utf-8?B?Q3JxS20yNlJaNmdGVks5L3Z0NzcrOE92aEYrcExEZGcyajJPSEs3ZEpnbWhz?=
 =?utf-8?B?VTFDNzdkdnp4Y0xTSFFFNDhMcWRTNzN3NE1QaWxOZEdlMzJyWnRuVklsOVlB?=
 =?utf-8?B?QUltZ2xlczQxNUFlRENReTl4eFl1Uks1N3dhUndWTFZJbnhBU2V3R2FJOXhr?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB38DFDEC088E54B825C5A4CBAB43547@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c976a12-e7ba-421b-a38f-08dae1ae59ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 10:46:57.1684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbC56X80ad3LWrqHQC8M3PglGI/2TwG/s5fuw6o53BOTo289FK8461oTHmPqvn64So29W3k6ZQcMKivjjjbW3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6953
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTE1IGF0IDIxOjI2IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gV2VkLCBEZWMgMTQsIDIwMjIgYXQgMTE6NDM6MTRBTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gU2F0LCAyMDIyLTEw
LTI5IGF0IDIzOjIzIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5jb20gd3JvdGU6DQo+ID4g
PiArc3RhdGljIHU4IHZ0X2dldF9tdF9tYXNrKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ2ZuX3Qg
Z2ZuLCBib29sIGlzX21taW8pDQo+ID4gPiArew0KPiA+ID4gKwlpZiAoaXNfdGRfdmNwdSh2Y3B1
KSkgew0KPiA+ID4gKwkJaWYgKGlzX21taW8pDQo+ID4gPiArCQkJcmV0dXJuIE1UUlJfVFlQRV9V
TkNBQ0hBQkxFIDw8IFZNWF9FUFRfTVRfRVBURV9TSElGVDsNCj4gPiA+ICsJCXJldHVybsKgIE1U
UlJfVFlQRV9XUkJBQ0sgPDwgVk1YX0VQVF9NVF9FUFRFX1NISUZUOw0KPiA+ID4gKwl9DQo+ID4g
PiArDQo+ID4gPiArCXJldHVybiB2bXhfZ2V0X210X21hc2sodmNwdSwgZ2ZuLCBpc19tbWlvKTsN
Cj4gPiA+ICt9DQo+ID4gDQo+ID4gU28geW91IGFyZSByZXR1cm5pbmcgV0IgZm9yIF9BTExfIGd1
ZXN0IG1lbW9yeSwgaW5jbHVkaW5nIHNoYXJlZC4gIFdvdWxkbid0IHRoaXMNCj4gPiBicmVhayBN
VFJSIGhhbmRsaW5nIGZvciBzaGFyZWQgbWVtb3J5PyAgRm9yIGluc3RhbmNlLCBJSVVDIHdlIGNh
biBzdGlsbCBzdXBwb3J0DQo+ID4gYXNzaWduaW5nIGEgZGV2aWNlIHRvIGEgVERYIGd1ZXN0IHdo
aWxlIHRoZSBWVC1kIGRvZXNuJ3Qgc3VwcG9ydCBjb2hlcmVudA0KPiA+IG1lbW9yeSwgaW4gd2hp
Y2ggY2FzZSBndWVzdCdzIE1UUlIvUEFUIGFyZSBob25vcmVkLiAgSSB0aGluayB0aGlzIHNob3Vs
ZCBhbHNvDQo+ID4gYXBwbHkgdG8gVERYIGd1ZXN0J3Mgc2hhcmVkIG1lbW9yeT8NCj4gDQo+IFlv
dSdyZSByaWdodC4gU28gaGVyZSBpcyB0aGUgdXBkYXRlZCBjaGFuZ2UuDQo+IC0tLSBhL2FyY2gv
eDg2L2t2bS92bXgvbWFpbi5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvbWFpbi5jDQo+IEBA
IC03OTgsMTEgKzc5OCw4IEBAIHN0YXRpYyBpbnQgdnRfc2V0X2lkZW50aXR5X21hcF9hZGRyKHN0
cnVjdCBrdm0gKmt2bSwgdTY0IGlkZW50X2FkZHIpDQo+ICANCj4gIHN0YXRpYyB1OCB2dF9nZXRf
bXRfbWFzayhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdmbl90IGdmbiwgYm9vbCBpc19tbWlvKQ0K
PiAgew0KPiAtICAgICAgIGlmIChpc190ZF92Y3B1KHZjcHUpKSB7DQo+IC0gICAgICAgICAgICAg
ICBpZiAoaXNfbW1pbykNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIE1UUlJfVFlQ
RV9VTkNBQ0hBQkxFIDw8IFZNWF9FUFRfTVRfRVBURV9TSElGVDsNCj4gLSAgICAgICAgICAgICAg
IHJldHVybiAgTVRSUl9UWVBFX1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQ7DQo+IC0g
ICAgICAgfQ0KPiArICAgICAgIGlmIChpc190ZF92Y3B1KHZjcHUpKQ0KPiArICAgICAgICAgICAg
ICAgcmV0dXJuIHRkeF9nZXRfbXRfbWFzayh2Y3B1LCBnZm4sIGlzX21taW8pOw0KPiAgDQo+ICAg
ICAgICAgcmV0dXJuIHZteF9nZXRfbXRfbWFzayh2Y3B1LCBnZm4sIGlzX21taW8pOw0KPiAgfQ0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgv
dGR4LmMNCj4gaW5kZXggYWM0N2IyMGU0ZTkxLi5mMTg0MmViMzJkNmMgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0K
PiBAQCAtNTY4LDcgKzU2OCwzMSBAQCBpbnQgdGR4X3ZtX2luaXQoc3RydWN0IGt2bSAqa3ZtKQ0K
PiAgICAgICAgIHJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICt1OCB0ZHhfZ2V0X210X21hc2soc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCBnZm5fdCBnZm4sIGJvb2wgaXNfbW1pbykNCj4gK3sNCj4gKyAg
ICAgICBpZiAoaXNfbW1pbykNCj4gKyAgICAgICAgICAgICAgIHJldHVybiBNVFJSX1RZUEVfVU5D
QUNIQUJMRSA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQ7DQo+ICsNCj4gKyAgICAgICBpZiAoIWt2
bV9hcmNoX2hhc19ub25jb2hlcmVudF9kbWEodmNwdS0+a3ZtKSkNCj4gKyAgICAgICAgICAgICAg
IHJldHVybiAoTVRSUl9UWVBFX1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQpIHwgVk1Y
X0VQVF9JUEFUX0JJVDsNCj4gKw0KPiArICAgICAgIC8qIEd1ZXN0IENSMCBpcyB1bmtub3duLiAg
QXNzdW1lIENSMC5DRCA9IDAuICovDQoNClRoaXMgY29tbWVudCBpcyBob3JyaWJsZS4gIFlvdSBu
ZWVkIHRvIGV4cGxhaW4gd2h5IGd1ZXN0IENSMC5DRCBpcyBpcnJlbGV2YW50DQpoZXJlLg0KDQpB
bmQgdGhlIGZhY3QgaXMgZm9yIFREWCBndWVzdCwgVERYIG1vZHVsZSB0ZWxscyB1cyB0aGUgQ1Iw
LkNEIGlzIGFsd2F5cyAwLg0KDQo+ICsNCj4gKyAgICAgICAvKiBURFggcHJpdmF0ZSBHUEEgaXMg
YWx3YXlzIFdCLiAqLw0KPiArICAgICAgIGlmIChnZm4gJiBrdm1fZ2ZuX3NoYXJlZF9tYXNrKHZj
cHUtPmt2bSkpDQo+ICsgICAgICAgICAgICAgICByZXR1cm4gIE1UUlJfVFlQRV9XUkJBQ0sgPDwg
Vk1YX0VQVF9NVF9FUFRFX1NISUZUOw0KDQpEb3NlIHRoZSAnZ2ZuJyBzdGlsbCBoYXZlIHRoZSBz
aGFyZWQgYml0IHNldD8gIEkgZG9uJ3QgdGhpbmsgc28/DQoNCj4gKw0KPiArICAgICAgIC8qDQo+
ICsgICAgICAgICogQmVjYXVzZSB0aGUgZGVmaW5pdGlvbiBvZiBNVFJSIE1TUiBpcyB1bmF3YXJl
IG9mIHNoYXJlZC1iaXQsDQo+ICsgICAgICAgICogY2xlYXIgc2hhcmVkLWJpdC4NCj4gKyAgICAg
ICAgKi8NCj4gKyAgICAgICBnZm4gPSBrdm1fZ2ZuX3ByaXZhdGUodmNwdS0+a3ZtLCBnZm4pOw0K
PiArICAgICAgIHJldHVybiBrdm1fbXRycl9nZXRfZ3Vlc3RfbWVtb3J5X3R5cGUodmNwdSwgZ2Zu
KSA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQ7DQo+ICt9DQoNCk92ZXJhbGwsIEkgdGhpbmsgYSBi
ZXR0ZXIgbG9naWMgc2hvdWxkIGJlOiAxKSBmb3IgcHJpdmF0ZSBwYWdlLCByZXR1cm4gV0IgKGFu
ZA0KV0FSTl9PTihpc19tbWlvKSksIGFsdGhvdWdoIHRoaXMgZG9lc24ndCBtYXR0ZXIgYW55d2F5
IGFzIHRoZSBTUFRFIHdvbid0IGJlIHVzZWQNCmJ5IENQVSBhbnl3YXkuIDIpIFRoZW4gZm9yIHNo
YXJlZCBwYWdlcywgd2UgdHJ5IHRvIGNvcHkgdm14X2dldF9tdF9tYXNrKCkgbG9naWMsDQpvciB1
c2Ugdm14X2dldF9tdF9tYXNrKCkgZGlyZWN0bHkuDQoNCkJ1dCBzaW5jZSBob3cgS1ZNIGFuZCBU
RFggbW9kdWxlIHZpcnR1YWxpemUgTVRSUi9QQVQgaXMgZGlmZmVyZW50LCB0aHVzIGZvciBub3cN
CkkgYW0gbm90IHN1cmUgd2hldGhlciBqdXN0IHVzaW5nIHZteF9nZXRfbXRfbWFzaygpIGNhbiB3
b3JrLiAgRm9yIGV4YW1wbGUsIElJVUMNCmZvciBURFggZ3Vlc3QgS1ZNIGNhbm5vdCBrbm93IGd1
ZXN0J3MgUEFULCBidXQgZm9yIFZNWCBndWVzdCBLVk0gdHJhcHMgTVRSUi9QQVQNCnNvIGl0IGNh
biBrbm93IGd1ZXN0J3MgbWVtb3J5IHR5cGUuDQoNCkZvciBub3cgSSBhbSBub3QgZXZlbiBzdXJl
IHdoZXRoZXIgd2UgY2FuL3Nob3VsZCBzdXBwb3J0IGRldmljZSBhc3NpZ25tZW50IHcvbw0KVlQt
ZCBzbm9vcGluZyBjYXBhYmlsaXR5IGFzIGZvciBURFggZ3Vlc3QgS1ZNIGNhbm5vdCBrbm93IGd1
ZXN0J3MgUEFUPyAgUGVyaGFwcw0Kd2Ugc2hvdWxkIGp1c3QgbWFrZSBzdXJlIHRoaXMgd29uJ3Qg
aGFwcGVuIHNvIHdlIGNhbiBhbHdheXMgcmV0dXJucyBXQiBmb3INCnNoYXJlZCBtZW1vcnkgdG9v
IGZvciBURFggZ3Vlc3QuDQoNCg==
