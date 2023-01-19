Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC846746F7
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjASXOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjASXN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:13:27 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B90A8F6E7;
        Thu, 19 Jan 2023 15:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674169752; x=1705705752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hSpUafYzsaW3wM3IwxQahpkJnYL9hzMuUDvaBZGcATM=;
  b=ST+Os65gvB/QTstHEYHbipQr+PN30/ugd5iHVM7wwNWjP8kejXmrRNOd
   /TIub3Kl0p6A5uLw4bBR+H8fxN09Ea4wNy98eI1mD2BtqtigFdRs8K3KV
   /63SCDNRza43Z5U+YovDoxgtp2QmUAinntNqWsH/bVn7MMqIUWD7aco4C
   ZT4jrYQWYdcTJ5iQ5nzZyNb1gWbWzlOwQWcT9xEjCsTTIfQWzcbMlbKfF
   kvv9vBfrD+ce6xPgTr1L5JQB1rY6+TPWu2PXje9GppSOfAveY5HNikUx/
   otci/t+a6OM/1KEeW0WUcMilLZTWt/alpGQwNwgo4d56LsxDGgXSrKUiJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305821984"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="305821984"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 15:09:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="802831324"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="802831324"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jan 2023 15:09:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 15:09:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 15:09:10 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 15:09:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHInQuJ6/c5rbfyHZBn6HOtRqW/76QTYmsS7JIM48DmLiOZhBfh0XTMwrXoVoXcIRzjMgtI4olGN75zlr8qY9HQpQ2KFE/mZ3yCrQPm4FmsZ7HCFWLXKwDxSLJ/QBca6MOjnl/ZymuENXaW4mElTsKaPqS0Mbc06EbIuCtR0w9roCJXlm24xWLIfUDjrl1Fx3v8vv9+R9hAOKR1cAP2eUVvHjCFIraaWKG7HE5IfjkPTNYzBNYhUsyISrFoBkGJDcjgISnyPq2+xExL2EkzGhq3WvqYieF1q+U1WA4aA50YndDJBuusM7AnHcv5ai3oakyPfEneazaYjiOZb853FOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSpUafYzsaW3wM3IwxQahpkJnYL9hzMuUDvaBZGcATM=;
 b=RFgTJUt1/5Gm4dVeklDVtDioAFMae6Njtfd9y8SPrTm9w4lFzQVScmd8fXseISg354znapH1jbp/7krWIn1fWk2wMECgm+pc3VuNT3bYQExEMQ2ZdKYTLem+kDunHbVl5AzDC2bnShsFwwxvQM8p0r6uyRewkmgE6Q08idl8oQhmTGGPIl7dTFH5jFsqmSLzKAuzfzzqIcqoGGA/g54bml9VLfcJfayN8mWEaRcUvC2BWtvv7erGt8ZIUFTLjgjOVzwNKyNTKOg2+fFAFR99BY7W8WX0CeOZ3J2OIWRDbOQvl5Z6ECF5qPciXHcGAhATEzh6tKOQ1gt657z88Y5rWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB7805.namprd11.prod.outlook.com (2603:10b6:8:ea::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 23:08:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 23:08:41 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "dmatlack@google.com" <dmatlack@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGAgAAP1gCAABm5AA==
Date:   Thu, 19 Jan 2023 23:08:41 +0000
Message-ID: <38f506575caacd5488f73315b231c3282f893d46.camel@intel.com>
References: <20230113151258.00006a6d@gmail.com>  <Y8F1uPsW56fVdhmC@google.com>
 <20230114111621.00001840@gmail.com>     <Y8bFCb+rs25dKcMY@google.com>
 <20230117214414.00003229@gmail.com>     <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com>
         <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
         <Y8ljwsrrBBdh1aYw@google.com>
         <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
         <Y8m34OEVBfL7Q4Ns@google.com>
In-Reply-To: <Y8m34OEVBfL7Q4Ns@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB7805:EE_
x-ms-office365-filtering-correlation-id: bf4acb2c-08e4-4f73-877f-08dafa721b0c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XnZQBRQPDrgt4o/PrmMDPraP4ysghiJzVQrzswpK/AZ2PecaF212vOSdWW40yQuW5FF2IvmHOB3LLCFh9EQQ3G9RkH2mwUGcWVqUivMePryadt4PueD7+UcFEajwaWQu3BsnuKs8pEyzlc/VmuQkqgz6H+UszNYyko+5VM/cy0BrlF//z5WHjn9kQI8msWgBAFn5zTRRtL8ovbGH37jjhbeLv4tY4NmOdlqhPt1T7EeuEywU2wmClQBPuF5lBSRpqgu0UULbfnpsJz/1/OBQ30Y483mpzmc4XSIy//M/lpPQvgUGL0nMWFYypfU9Zmrc0VK72UB/qICyZ/cibyMcGabn6P0vm9u4wnSd9IEyud6Zp8joTYgB0M/MCkuAUIAts53/9cgqBdygsSrGD4Ja/Zwtxt5ocWqYw47sDs2TGU/9ZmeeP2wIOBO2Hy0w+6GicyL6P+7VydiDrLaUQd4/7ukJkB0sbmYM7cRfQhcQbfZhbzrL5MF8c09KbBnBAe7TI+T6fBXjlYd/uX5b05LQbLk4PnBh+SroiDTG0dX2GXohpx5FxY5LKvQGxLNaR0JBu0CUNrI5bS2nnVTRirsyR6i27CM4EjGEGrUJj4RnaxW0Cxha4k/X8GlMXrEpYmGG6XSXvlGNzAy4bK1T+YknOzPmSAx7L/+H/rZ4+nJYPPnWeXU5jZ8tywLIAxAzm+FlYFlTjx9ciJAZ+U3ijbvTZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(6486002)(478600001)(86362001)(66556008)(122000001)(66946007)(2906002)(91956017)(8936002)(5660300002)(66476007)(82960400001)(38100700002)(76116006)(316002)(54906003)(107886003)(71200400001)(38070700005)(6506007)(36756003)(26005)(64756008)(8676002)(4326008)(66446008)(41300700001)(6916009)(2616005)(186003)(6512007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTZjZzJ0dm1FckJPcGRUSW40MWE4WmhTekI4SjYraVRNZldHeDd4WXNYVEx4?=
 =?utf-8?B?V1hPV05QUWk1Ti9JODlZYVREVmxGL05yeFBNR2xMRnJ1ZWlITnpBaFZXZXJ3?=
 =?utf-8?B?Z2l0TzcydXQ2M2hmbG9sSzYzRDNOMkM3cW9ST3VUbXY0azBVZ3FNUWppdUo2?=
 =?utf-8?B?aU5zcWIzTXRiRks5K2pnRGNYU0pMZmhNdng5MHQvdnN5ZTcwa2Z3R2tmOFZN?=
 =?utf-8?B?dkRGbmhPRjJFM3czSGR2czllSTJ1NThhcUJsTEN4UW1MQUxlZXBjY0k2Y3d2?=
 =?utf-8?B?eVZpUWJzUXlFS0ZZRHoyL1FSVTVrUDgwazNXb0FnTGttUVVWc0lkTUVlT2Zv?=
 =?utf-8?B?MEh2UVgrVllScnp3QVc5ZDUySk16Rjlqa1cvM0NBYXdGc1ppNkJsdEQ1VFg2?=
 =?utf-8?B?WGtkNHpVNlNNUklYbFJOMDhmRnRBeXpnZ1dZOTFmZHZkblVsbEMwUlZLTVdP?=
 =?utf-8?B?ekpjTDczSk9SSHI5YVdObjVtamJua0pOZVFvaG5nN0htbmp2aHorL245Yy9h?=
 =?utf-8?B?b0xaMnJ3c3RPOU9VakNqR0REbXNTaE1TTEZHMWNqL1ArR0JkbDc2V1V1UnpY?=
 =?utf-8?B?TFljeldWQVp3RTJqbHNRMkVZeGNYQWkyL2J5VERXK1lwM0E2dmhSNThTNnZD?=
 =?utf-8?B?QWhFeHBmbGhtVzk0SFpKZ0VvWUt6UHMzTWI4d0RZbVEzTEJDTjZZYzcrQndR?=
 =?utf-8?B?azRxcTRzOTlJczJtVUVkTWhpRmRaZHhhTklMQTNFUkVXWWFvY0diOWI2QVdP?=
 =?utf-8?B?N3pGWCtWK213TWJaRzNJdXE0MS9TZVMrZUJVK1Y1SmpaOVNpVmZzMFJOTy90?=
 =?utf-8?B?T3VHK3hRMDlIY1Y5M0t1UHh1R0RMUlhNY0s5L1lVK2lNd3ozdUQzZWJ6ZUJ6?=
 =?utf-8?B?TlhJZ3FFREh2L25hSWFwZk9DbVE3YndYY3JGRlpOZEdPcERJVXhTNGVjbHdx?=
 =?utf-8?B?REtqOVpVNkR1ZVJaSDl0YzF2N0V2TDNHRjNpQ0ZTdFAxdVFlZlVudXJYSGRX?=
 =?utf-8?B?WDE1TkRsbjM5eHd2ZURlSEhXaGI3ZUpESlpacVMwNVVyUkdsMVhwc2gxdlVi?=
 =?utf-8?B?WUg4UWQ1MlJFeUxxSXNBQ0YyWWtZcW5LYVIydTBlMnlEM21NbW9wUnk5NVN6?=
 =?utf-8?B?dkJ5RFNrQmdOSE1ZbzkwZVc0K09pdTRmVHg5RExHbm1Ea1h5RGZ0czJIdEd0?=
 =?utf-8?B?cExQY2FRQjF6aTNiMit4VytENXFUWDNLK1JwODZZV1V6WEYxMWVlQWN0RUtw?=
 =?utf-8?B?VG1tZG03cXdRalRmaE5PZHlUUk5lTElGdnZaTU93YWdXUDMyWDU3OE1HbllE?=
 =?utf-8?B?dGJ2NkY0WHRMaVMvcjVHM0o5WnBXemZQSHVqbzh6M0tPQzI2N3lKUTZMVFhK?=
 =?utf-8?B?LzdqVkZtNlBMWm1jeHd3S2JuSzlsZlRldDMrcXI5RGlPMUtGWlNLWlY3VXhj?=
 =?utf-8?B?RXVPNnNvR1MwOVdUY0NEUGdjRzViR2hIOEFZU3pydnQ2TDBtenJUdUkxOUxm?=
 =?utf-8?B?RFBkaGVaM1ZaMWJ6RFNaYWE0SG1RS1llYXdiWk91SEF1RFlaNHFDd2VDN2tY?=
 =?utf-8?B?R3VJQ3B4QUw2RmhzK0l2WWNjSVdpMWcydjFhcUtEVHVGSEdFZ3J1d2FRT2Nk?=
 =?utf-8?B?V3FjNW9RRUxsUDNhb29ldTFtUnBjdmVlY0UxZkg2anFIeUdaUVlnZnJlWjZv?=
 =?utf-8?B?bTlEbW1JM29vVXFTOUxEQVY4eG95TXdpSzdDOVJlK2I4dEVVV0Q2dHJXbjk0?=
 =?utf-8?B?RWZiVEFNNkt4YjNKKzdUMlVLZUZ4OFdueEFrY3ZaRXI3OTZTUTh0L2JXZzN6?=
 =?utf-8?B?TTRyUjBZR3crTnN5a0orS3FQMU52NFlMdzBQMkNlSUlYU3I1Q3ZYV1RQWTIy?=
 =?utf-8?B?dlJPVWlVN0FMMUFnL3g1c2NjQkEyNVF1V0o5UTdnR2ZuOW9NTjFUQmY3QXlF?=
 =?utf-8?B?N2tPNjJpT2JYQWU3QUYzR3JlQjZlRGtseGNRbXdsSENrb3hrYmpRK0JrSy9j?=
 =?utf-8?B?b3p4T3QxaXprcjZITDkra3dxVm91VW52T2p5Y0Z3MGVTME9kaFNrZS9yNGcw?=
 =?utf-8?B?WlRoQVBycmROQThrT1pNdjJHYnhrdHNJWkNCdVdHc1ltZy9OSnNzQVdOOXZi?=
 =?utf-8?B?TXYxdit2c0RUWVMvT3FlMlZ3aFVnWWp0eEx2OVJrY2Y1QW5GM2F0RmtwV1RF?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC51FBE1E1736842A278D4431F983A05@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4acb2c-08e4-4f73-877f-08dafa721b0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 23:08:41.2743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xCT6aoM64jHJy1g0bzdKR/0j30S6tx7g/UJEZRp3NVUIRGiiSrRLw0+XLfKwbijFWASIrrM8OaJpRoSyIEhqCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7805
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDIxOjM2ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAxOSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
aHUsIDIwMjMtMDEtMTkgYXQgMTU6MzcgKzAwMDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBPbiBUaHUsIEphbiAxOSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4g
T24gVHVlLCAyMDIzLTAxLTE3IGF0IDIxOjAxICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gPiA+IE9uIFR1ZSwgSmFuIDE3LCAyMDIzLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOg0KPiA+ID4gPiA+ID4gT24gVHVlLCBKYW4gMTcsIDIwMjMsIFpoaSBXYW5nIHdyb3Rl
Og0KPiA+ID4gPiA+IE9oLCB0aGUgb3RoZXIgaW1wb3J0YW50IHBpZWNlIEkgZm9yZ290IHRvIG1l
bnRpb24gaXMgdGhhdCBkcm9wcGluZyBtbXVfbG9jayBkZWVwDQo+ID4gPiA+ID4gaW4gS1ZNJ3Mg
TU1VIGluIG9yZGVyIHRvIHdhaXQgaXNuJ3QgYWx3YXlzIGFuIG9wdGlvbi4gIE1vc3QgZmxvd3Mg
d291bGQgcGxheSBuaWNlDQo+ID4gPiA+ID4gd2l0aCBkcm9wcGluZyBtbXVfbG9jayBhbmQgc2xl
ZXBpbmcsIGJ1dCBzb21lIHBhdGhzLCBlLmcuIGZyb20gdGhlIG1tdV9ub3RpZmllciwNCj4gPiA+
ID4gPiAoY29uZGl0aW9uYWxseSkgZGlzYWxsb3cgc2xlZXBpbmcuDQo+ID4gPiA+IA0KPiA+ID4g
PiBDb3VsZCB3ZSBkbyBzb21ldGhpbmcgc2ltaWxhciB0byB0ZHBfbW11X2l0ZXJfY29uZF9yZXNj
aGVkKCkgYnV0IG5vdCBzaW1wbGUgYnVzeQ0KPiA+ID4gPiByZXRyeWluZyAiWCB0aW1lcyIsICBh
dCBsZWFzdCBhdCB0aG9zZSBwYXRocyB0aGF0IGNhbiByZWxlYXNlIG1tdV9sb2NrKCk/DQo+ID4g
PiANCj4gPiA+IFRoYXQncyBlZmZlY3RpdmVseSB3aGF0IGhhcHBlbnMgYnkgdW53aW5kaW5nIHVw
IHRoZSBzdGFrIHdpdGggYW4gZXJyb3IgY29kZS4NCj4gPiA+IEV2ZW50dWFsbHkgdGhlIHBhZ2Ug
ZmF1bHQgaGFuZGxlciB3aWxsIGdldCB0aGUgZXJyb3IgYW5kIHJldHJ5IHRoZSBndWVzdC4NCj4g
PiA+IA0KPiA+ID4gPiBCYXNpY2FsbHkgd2UgdHJlYXQgVERYX09QRVJBTkRfQlVTWSBhcyBzZWFt
Y2FsbF9uZWVkYnJlYWsoKSwgc2ltaWxhciB0bw0KPiA+ID4gPiByd2xvY2tfbmVlZGJyZWFrKCku
ICBJIGhhdmVuJ3QgdGhvdWdodCBhYm91dCBkZXRhaWxzIHRob3VnaC4NCj4gPiA+IA0KPiA+ID4g
SSBhbSBzdHJvbmdseSBvcHBvc2VkIHRvIHRoYXQgYXBwcm9hY2guICBJIGRvIG5vdCB3YW50IHRv
IHBvbGx1dGUgS1ZNJ3MgTU1VIGNvZGUNCj4gPiA+IHdpdGggYSBidW5jaCBvZiByZXRyeSBsb2dp
YyBhbmQgZXJyb3IgaGFuZGxpbmcganVzdCBiZWNhdXNlIHRoZSBURFggbW9kdWxlIGlzDQo+ID4g
PiB1bHRyYSBwYXJhbm9pZCBhbmQgaG9zdGlsZSB0byBoeXBlcnZpc29ycy4NCj4gPiANCj4gPiBS
aWdodC4gIEJ1dCBJSVVDIHRoZXJlJ3MgbGVnYWwgY2FzZXMgdGhhdCBTRVBUIFNFQU1DQUxMIGNh
biByZXR1cm4gQlVTWSBkdWUgdG8NCj4gPiBtdWx0aXBsZSB0aHJlYWRzIHRyeWluZyB0byByZWFk
L21vZGlmeSBTRVBUIHNpbXVsdGFuZW91c2x5IGluIGNhc2Ugb2YgVERQIE1NVS4gDQo+ID4gRm9y
IGluc3RhbmNlLCBwYXJhbGxlbCBwYWdlIGZhdWx0cyBvbiBkaWZmZXJlbnQgdmNwdXMgb24gcHJp
dmF0ZSBwYWdlcy4gIEkNCj4gPiBiZWxpZXZlIHRoaXMgaXMgdGhlIG1haW4gcmVhc29uIHRvIHJl
dHJ5Lg0KPiANCj4gVW0sIGNydWQuICBJIHRoaW5rIHRoZXJlJ3MgYSBiaWdnZXIgaXNzdWUuICBL
Vk0gYWx3YXlzIG9wZXJhdGVzIG9uIGl0cyBjb3B5IG9mIHRoZQ0KPiBTLUVQVCB0YWJsZXMgYW5k
IGFzc3VtZXMgdGhlIHRoZSByZWFsIFMtRVBUIHRhYmxlcyB3aWxsIGFsd2F5cyBiZSBzeW5jaHJv
bml6ZWQgd2l0aA0KPiBLVk0ncyBtaXJyb3IuICBUaGF0IGFzc3VtcHRpb24gZG9lc24ndCBob2xk
IHRydWUgd2l0aG91dCBzZXJpYWxpemluZyBTRUFNQ0FMTHMgaW4NCj4gc29tZSB3YXkuICBFLmcu
IGlmIGEgU1BURSBpcyB6YXBwZWQgYW5kIG1hcHBlZCBhdCB0aGUgc2FtZSB0aW1lLCB3ZSBjYW4g
ZW5kIHVwIHdpdGg6DQo+IA0KPiAgIHZDUFUwICAgICAgICAgICAgICAgICAgICAgIHZDUFUxDQo+
ICAgPT09PT0gICAgICAgICAgICAgICAgICAgICAgPT09PT0NCj4gICBtaXJyb3JbeF0gPSB4eXoN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBvbGRfc3B0ZSA9IG1pcnJvclt4XQ0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1pcnJvclt4XSA9IFJFTU9WRURfU1BURQ0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNlcHRbeF0gPSBSRU1PVkVEX1NQVEUNCj4gICBz
ZXB0W3hdID0geHl6DQoNCklJVUMgdGhpcyBjYXNlIGNhbm5vdCBoYXBwZW4sIGFzIHRoZSB0d28g
c3RlcHMgaW4gdGhlIHZjcHUwIGFyZSB3aXRoaW4gcmVhZA0KbG9jaywgd2hpY2ggcHJldmVudHMg
ZnJvbSB2Y3B1MSwgd2hpY2ggaG9sZHMgdGhlIHdyaXRlIGxvY2sgZHVyaW5nIHphcHBpbmcgU1BU
RS4NCg0KDQoNCg==
