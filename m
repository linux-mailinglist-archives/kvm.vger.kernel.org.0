Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57297915CC
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 12:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351403AbjIDKmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 06:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbjIDKmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 06:42:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230A8197;
        Mon,  4 Sep 2023 03:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693824153; x=1725360153;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wti9MFj+d2xugCP1lqMDtOEbsvQT37v4HuSiS2LRcTk=;
  b=MwWG8ju74qPlr4YdxgiOnuyK9qfBocX9Ih+fv/ZDQx7Vg9WxfSk+ixWs
   eidmngEkm0WFwKMaO/lP2pkTFCqdIiPlOBdu9+Js1GR/Hr3DNJ/2pOtSQ
   19OqRKAxxIlMmbK3LLxSyoR2JRDl10rghta6YWUJsq2OL87zmdu+TBNqa
   Nu7PxpmWKcXZitFo09DDrUOTTOxuj+rOKvjR8sKIEjwGyrwz/ngjWgjDh
   novOPa6GnBcEEvpmKapjaiKbXwHITghzNtf7n46Q/AQzk+T0Q2HP192DV
   7PzLbJtwMSN0iyzvR42tuOCkm/MxUItxJfaS9vhNHL06OsPoE2xMvH9ms
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="375465285"
X-IronPort-AV: E=Sophos;i="6.02,226,1688454000"; 
   d="scan'208";a="375465285"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 03:39:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="717509070"
X-IronPort-AV: E=Sophos;i="6.02,226,1688454000"; 
   d="scan'208";a="717509070"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 03:39:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 03:39:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 03:39:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 03:39:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etIpEXhzOecYjXBkoC8k51IVp+qQn36OJqQX4VUbJKrRXVSgKCKA15BObD6IlLRgLavtJDIo46xhltAO4RmxJTa58S9/gpsO8V6pHCQp62JGof5P20DM7FEIG3ndoGKmUoRHlug08Hss/cSk/hq33xCzx4NK5Z18hTpGHYKfiEd+f6c2WlWLoZUN9dlJgAbhlwrQzuUOULJNEo8potDHugk8HSQ77f1b59IN/Urp1o29frAefo6gvCs3RV8AHn1QckK9WPUqC3T3mnB4bp9okmT6tMXCE43oJo0RtKwGMRl8S2gxVslwfw5+wf4AyPIIoqjDULTMAyz/g4P2UOEVgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wti9MFj+d2xugCP1lqMDtOEbsvQT37v4HuSiS2LRcTk=;
 b=VAm4GtvBwbuu6/HKirdxl1VgSn8Oo7e4+L8S+/IKW4vbXmo/YCdKq3VrU9BkekL/E3iv5wr3HhtPObR3EXXb6XpfG3Vj0SPG26NvEXyMbG7acfWDE5Y1dFoyiAIkCh1uxSeIWdiZOoJq6qAyudtBv5Ie655/Y42npPk1EhQQ7xA00adXgTD9G7EjryARZt5Bf5nOroJOpVNU1EVwJXN3JuwDKL74VSz23SZucObExzewURIxe53Dl2q8Aszm6kzPqu303F67FTAIRN9xwBvZ6AKR4lok5Y9a4b1Zczr3SwJMBT/FdYEx/38Fz1PrwfCF40gE+FRuVhT1VoLEDeTlRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6700.namprd11.prod.outlook.com (2603:10b6:510:1ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 4 Sep
 2023 10:39:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 10:39:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "zeming@nfschina.com" <zeming@nfschina.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?UmU6IFtQQVRDSF0geDg2L2t2bS9tbXU6IFJlbW92ZSB1bm5lY2Vzc2FyeSA=?=
 =?utf-8?B?4oCYTlVMTOKAmSB2YWx1ZXMgZnJvbSBzcHRlcA==?=
Thread-Topic: =?utf-8?B?W1BBVENIXSB4ODYva3ZtL21tdTogUmVtb3ZlIHVubmVjZXNzYXJ5IOKAmE5V?=
 =?utf-8?B?TEzigJkgdmFsdWVzIGZyb20gc3B0ZXA=?=
Thread-Index: AQHZ3HNMJp3CnKHkCkaR6HqaH2qDArAGL0qAgARP8QA=
Date:   Mon, 4 Sep 2023 10:39:24 +0000
Message-ID: <99cf9b5929418e8876e95a169d20ee26e126c51c.camel@intel.com>
References: <20230902175431.2925-1-zeming@nfschina.com>
         <ZPIVzccIAiQnG4IA@google.com>
In-Reply-To: <ZPIVzccIAiQnG4IA@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6700:EE_
x-ms-office365-filtering-correlation-id: 32f1ea6b-b7aa-4d76-432b-08dbad333511
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qX5YEzpepPDOlx2r/X/5nK8Vb4KnNeE9It0A3CD/u5qlW0IePqOhaFLCG4BqPjVu5k/Hajl/nJ53wDm2eKs9ozCtNHg509bujO+OoLWePcKcrY6r08q8v6IibMLgDP+Z7XrsQ6+pSdq64+HlCkqtqRx5SPjVQe+bAMDK04dHLvPu0fLEL5RJZ5vYMjmuP4HRqrmbs55RM4Pxrc6idrLczeZHAhG9JN1i+2UhzOYiqamhCvRJUchSxavBCgcaiU+O6LADcGislnLVEh3OR55J5ZKuGcs6/GFoWU3zqT01GwWwnGb3jSj8CrDIgyp8NH0sueE7w32SzM5qAAwFxj1M8i4bYUZuhO/DlMORAkmPpFNuoS21bCyX8NnCZgbJF8rwAu0a/gb2T1D8382K15OdHvTOC3UfGkNFBOFtvXkIPNfhlvDNBifi6qkFiRG3JCRRTFyE8FEa0BmI4JjaBB3AYNRZEMVddyFRuD8WYZ274VgWlcQhX5iygqTiW7kZXNLqNzFEdiQMeg9bQOydsfoZSJPPs1qYKTZM8+lVRd9+Yzoz3xRZyE8r1DTdn2U0qrRRPaXVnPL1uPCcYFc1IBAqeqIuIr++HQsFw+5Gk3f4fsI9iUZERQ7NYVptmlU/7Gy3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(346002)(376002)(39860400002)(1800799009)(186009)(451199024)(5660300002)(41300700001)(2616005)(26005)(2906002)(7416002)(122000001)(82960400001)(86362001)(38100700002)(38070700005)(36756003)(4326008)(8936002)(83380400001)(6506007)(6512007)(6486002)(478600001)(110136005)(316002)(66946007)(71200400001)(91956017)(76116006)(66476007)(54906003)(64756008)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUdTcU9TaTR6SmI4cWFnS1N0UjZqbUhtR3BRSFVNdE9YYkkxbFp3K2V5MENr?=
 =?utf-8?B?aVpxVjJBcVNUTFFRbmZDNDljOXFlUXVvTjFrL1ZtLzNGbnNDSSt3SlRJajhM?=
 =?utf-8?B?ZFdoWFJsT0JTaWswdllPeGxpQ2NZSHJqVU1FNWRDRFZDTklWb1Iyb1p4eWIx?=
 =?utf-8?B?eWJEaEpBTVdQUkdUR1pDTE4xdXIyM1dDZGlJcWIwL1kwc3hacS9EUmhpN0ZB?=
 =?utf-8?B?cms5MmJLamZWeHVCd1Zobnh2WVQwRHVhVWVrbnYzVXN2WGdOaGRyamFvdmVM?=
 =?utf-8?B?b0VvZTArejNlakZKTTNvWUZPN3g5dU1aY2k5eWR0NloxNWVjRHJLUlNaN1F1?=
 =?utf-8?B?ZytJZk1VUHpNSENHM3ZUOHRUL3o0UkdsVmtqeEVzQTNjZlFHeEFEYjUrcE1Q?=
 =?utf-8?B?dU5FSzZtY0JhZFBtSUFSNWlyNC9zWjk1YlNMZUJDSElJamh4WE9kY09FNERo?=
 =?utf-8?B?R3R0Z2Z3NWJnU0hueFRKZVd5djV5WkR0ZkZpMHlUa2ViNHFieUFmMzV1VHA4?=
 =?utf-8?B?NDFoSjIzY3dqTW9VcDlvV0JYQ09HZ0JHZWxlbTNlM0xmUy9uSlZuTzZUMVNE?=
 =?utf-8?B?MGUydnRqb2l5UTNCZ1B2L2tHY1R4MzRRdmFWV1ZMMnJFTHhNQ3I3R2NMWUtr?=
 =?utf-8?B?azBpQ3djYUNxYmNGemJVSFV1eDlYVXlaY2trL3lXeHJrYXg4ckU3R2p0OWJ2?=
 =?utf-8?B?UEtERnIzemY1RFQyWE5pRFZWNDhia2hEc1c3NmM2YUowSEwwWVVZbGh2NUJZ?=
 =?utf-8?B?QUFJcTJMM0ZhMUplV3ZRTTJqdGxJUW96OUNBQ1ZsbDlHSUdMT3JCUlhCczVE?=
 =?utf-8?B?dmRRODdqa3luNWd0cjBXNVd2cmk0dCt3OXphenZmM0FmcWhWTWlWQVEwV3V1?=
 =?utf-8?B?MWtqMUhnL3p6NE9jOXA1dTdHQ1pZVURVb0tmVGN2Q0JSSXZOZU4yVzVOVU1x?=
 =?utf-8?B?TVVHdi9WVmhOTXRhRzdpOVYvZFBRQW9KdGZhV1Z4V2pjZ3lpbHBFSG1aMEpU?=
 =?utf-8?B?dlFoS05hS1V5VXp1NlBVQk1XRUxRa1JHaWZnWG1hY05EZFY0VkdTSVd3aEYw?=
 =?utf-8?B?SG8vQkdNaVduT0FOdDZkamFmVXl0SXBBYmJNelQ2S1pMTkpzemllTFNZMkc0?=
 =?utf-8?B?N1c3aHBNWEdlaHp6MDhnb2JmTEN3Mm9FV0Y1WjVtcERILzliUGM5VmVsK0ZV?=
 =?utf-8?B?QS9DeEhyYjZhMDJFUk5pYTd0RjJPdEhYOHBlU2o5VjQveEpPK2NyUWFsUjJr?=
 =?utf-8?B?YUR2YzY3RzRuT0p6eWpUUXN1QWhTaGFhR0FybVlXeHRsSlpzV3BOTU5peEJh?=
 =?utf-8?B?eVNKak9RVENxZE1jRjRXVUNoYTlCOWRmdDNoYXRyYWFEejBOYjY3ZStxR2RH?=
 =?utf-8?B?c05PaTFiVVpGWXhtdUdaVVlKQzZheUlrNng5VFU2cndlV3RWemw2VllDMXhB?=
 =?utf-8?B?QmVKZGRPUFYxaEpuL2JRUFZWS1NPTGxNUkRLL1poZE5LemRZTkxMaDdRbHhr?=
 =?utf-8?B?eUhydWNRSjl1SUs1MUhpQ1JwcjhwaXU2UzZjVU1xWkY2b3VOZ1JrZldsZFQw?=
 =?utf-8?B?VHlZakhXeThGaE5CMU5zczQ1NmhQK05zUGhBQmxrQloxd2M1ZmcvUk1CVkwz?=
 =?utf-8?B?aHhVY1ZmNG5RTHBaNnJUZ0o2U3RRRncrejBTbytrL2R5ZWtwdzcxMkRDYm1i?=
 =?utf-8?B?NFc4TkxPUGRWdEVuU0g4cUhvQUVxNmZMSnp4S1ZyTC9tZ2NCSFpTUXhaeTlD?=
 =?utf-8?B?WkVNN3ZIaGxudFUySnRoelN1WUJVd0FIbVJWVVZSV3BQS0w4MlFyQXVkTm5x?=
 =?utf-8?B?V2xtL1lBY3kzVVN3Y0lVR29ZN0p2K1lpZ1RpcWVGMVpKNGxTeGNkRGIxTHNM?=
 =?utf-8?B?ZzlwdFNNdU9RNzRxWUlVWS9OQk5uMlhabFB1ckI3SVV1UTBoYm1Kb1pqOXB0?=
 =?utf-8?B?bHlMb1NybElPZG5DeC9kb01oSXZ0dHNPV2VmbXkrQklsRFFKQktqODhTTSs4?=
 =?utf-8?B?ak14TGRhRVBnbVZiMkpKdVd0ZDVFM09Ea0hESW1OWG40U2VhMXFxb21YTkFU?=
 =?utf-8?B?ZWNSM0dteXg2dzhvRGlFcUw4SllkTnBnL0N0TkxFSmpLVmVPOVFOdjlBTkZH?=
 =?utf-8?Q?o6fykStTmCIHRcve4qKxsdslM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C35BA1891DE55428C3186E2477E5658@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f1ea6b-b7aa-4d76-432b-08dbad333511
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2023 10:39:24.7777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rrZuvlAufB+hlCUBwNH/Q1Yf93OwUjosjeMd+q5AC9Xn+xrUwNFjYciPSQ7979Px5NxVQs5QEroZA6lekCkXBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6700
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

T24gRnJpLCAyMDIzLTA5LTAxIGF0IDA5OjQ4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBTdW4sIFNlcCAwMywgMjAyMywgTGkgemVtaW5nIHdyb3RlOg0KPiA+IHNwdGVw
IGlzIGFzc2lnbmVkIGZpcnN0LCBzbyBpdCBkb2VzIG5vdCBuZWVkIHRvIGluaXRpYWxpemUgdGhl
IGFzc2lnbm1lbnQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgemVtaW5nIDx6ZW1pbmdA
bmZzY2hpbmEuY29tPg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9rdm0vbW11L21tdS5jIHwgMiAr
LQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2
bS9tbXUvbW11LmMNCj4gPiBpbmRleCBlYzE2OWY1YzdkY2UuLjk1Zjc0NWFlYzRhYSAxMDA2NDQN
Cj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ID4gKysrIGIvYXJjaC94ODYva3Zt
L21tdS9tbXUuYw0KPiA+IEBAIC0zNDU3LDcgKzM0NTcsNyBAQCBzdGF0aWMgaW50IGZhc3RfcGFn
ZV9mYXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcGFnZV9mYXVsdCAqZmF1
bHQpDQo+ID4gIAlzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcDsNCj4gPiAgCWludCByZXQgPSBSRVRf
UEZfSU5WQUxJRDsNCj4gPiAgCXU2NCBzcHRlID0gMHVsbDsNCj4gPiAtCXU2NCAqc3B0ZXAgPSBO
VUxMOw0KPiA+ICsJdTY0ICpzcHRlcDsNCj4gPiAgCXVpbnQgcmV0cnlfY291bnQgPSAwOw0KPiA+
ICANCj4gPiAgCWlmICghcGFnZV9mYXVsdF9jYW5fYmVfZmFzdChmYXVsdCkpDQo+IA0KPiBIbW0s
IHRoaXMgaXMgc2FmZSwgYnV0IHRoZXJlJ3Mgc29tZSB1Z2xpbmVzcyBsdXJraW5nLiAgVGhlb3Jl
dGljYWxseSwgaXQncyBwb3NzaWJsZQ0KPiBmb3Igc3B0ZSB0byBiZSBsZWZ0IHVudG91Y2hlZCBi
eSB0aGUgd2Fsa2Vycy4gIFRoYXQgX3Nob3VsZG4ndF8gaGFwcGVuLCBhcyBpdCBtZWFucw0KPiB0
aGVyZSdzIGEgYnVnIHNvbWV3aGVyZSBpbiBLVk0uICBCdXQgaWYgdGhhdCBkaWQgaGFwcGVuLCBv
biB0aGUgc2Vjb25kIG9yIGxhdGVyDQo+IGl0ZXJhdGlvbiwgaXQncyAoYWdhaW4sIHRoZW9yZXRp
Y2FsbHkpIHBvc3NpYmxlIHRvIGNvbnN1bWUgYSBzdGFsZSBzcHRlLg0KPiANCj4gCQlpZiAodGRw
X21tdV9lbmFibGVkKQ0KPiAJCQlzcHRlcCA9IGt2bV90ZHBfbW11X2Zhc3RfcGZfZ2V0X2xhc3Rf
c3B0ZXAodmNwdSwgZmF1bHQtPmFkZHIsICZzcHRlKTsNCj4gCQllbHNlDQo+IAkJCXNwdGVwID0g
ZmFzdF9wZl9nZXRfbGFzdF9zcHRlcCh2Y3B1LCBmYXVsdC0+YWRkciwgJnNwdGUpOw0KPiANCj4g
CQlpZiAoIWlzX3NoYWRvd19wcmVzZW50X3B0ZShzcHRlKSkgPD09PSBjb3VsZCBjb25zdW1lIHN0
YWxlIGRhdGENCj4gCQkJYnJlYWs7DQo+IA0KPiBJZiB3ZSdyZSBnb2luZyB0byB0aWR5IHVwIHNw
dGVwLCBJIHRoaW5rIHdlIHNob3VsZCBhbHNvIGdpdmUgc3B0ZSBzaW1pbGFyIHRyZWF0bWVudA0K
PiBhbmQgaGFyZGVuIEtWTSBpbiB0aGUgcHJvY2VzcywgZS5nLg0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS9tbXUvbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+IGluZGV4
IDYzMjViYjNlOGMyYi4uYWUyZjg3YmJiZjBhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
bW11L21tdS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gQEAgLTM0MzAsOCAr
MzQzMCw4IEBAIHN0YXRpYyBpbnQgZmFzdF9wYWdlX2ZhdWx0KHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpmYXVsdCkNCj4gIHsNCj4gICAgICAgICBzdHJ1Y3Qg
a3ZtX21tdV9wYWdlICpzcDsNCj4gICAgICAgICBpbnQgcmV0ID0gUkVUX1BGX0lOVkFMSUQ7DQo+
IC0gICAgICAgdTY0IHNwdGUgPSAwdWxsOw0KPiAtICAgICAgIHU2NCAqc3B0ZXAgPSBOVUxMOw0K
PiArICAgICAgIHU2NCBzcHRlOw0KPiArICAgICAgIHU2NCAqc3B0ZXA7DQo+ICAgICAgICAgdWlu
dCByZXRyeV9jb3VudCA9IDA7DQo+ICANCj4gICAgICAgICBpZiAoIXBhZ2VfZmF1bHRfY2FuX2Jl
X2Zhc3QoZmF1bHQpKQ0KPiBAQCAtMzQ0Nyw2ICszNDQ3LDE0IEBAIHN0YXRpYyBpbnQgZmFzdF9w
YWdlX2ZhdWx0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpm
YXVsdCkNCj4gICAgICAgICAgICAgICAgIGVsc2UNCj4gICAgICAgICAgICAgICAgICAgICAgICAg
c3B0ZXAgPSBmYXN0X3BmX2dldF9sYXN0X3NwdGVwKHZjcHUsIGZhdWx0LT5hZGRyLCAmc3B0ZSk7
DQo+ICANCj4gKyAgICAgICAgICAgICAgIC8qDQo+ICsgICAgICAgICAgICAgICAgKiBJdCdzIGVu
dGlyZWx5IHBvc3NpYmxlIGZvciB0aGUgbWFwcGluZyB0byBoYXZlIGJlZW4gemFwcGVkDQo+ICsg
ICAgICAgICAgICAgICAgKiBieSBhIGRpZmZlcmVudCB0YXNrLCBidXQgdGhlIHJvb3QgcGFnZSBp
cyBzaG91bGQgYWx3YXlzIGJlDQo+ICsgICAgICAgICAgICAgICAgKiBhdmFpbGFibGUgYXMgdGhl
IHZDUFUgaG9sZHMgYSByZWZlcmVuY2UgdG8gaXRzIHJvb3QocykuDQo+ICsgICAgICAgICAgICAg
ICAgKi8NCj4gKyAgICAgICAgICAgICAgIGlmIChXQVJOX09OX09OQ0UoIXNwdGVwKSkNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgc3B0ZSA9IFJFTU9WRURfU1BURTsNCg0KSWYgSSByZWNhbGwg
Y29ycmVjdGx5LCBSRU1PVkVEX1NQVEUgaXMgb25seSB1c2VkIGJ5IFREUCBNTVUgY29kZS4gIFNo
b3VsZCB3ZSB1c2UNCjAgKG9yIGluaXRpYWwgU1BURSB2YWx1ZSBmb3IgY2FzZSBsaWtlIFREWCkg
aW5zdGVhZCBvZiBSRU1PVkVEX1NQVEU/DQoNCkFuZCBJIGFncmVlIHRoaXMgY29kZSBpcyBtb3Jl
IGVycm9yIHByb29mIChhbHRob3VnaCB0aGVvcmV0aWNhbGx5IGZvciBub3cpLg0KICANCj4gKw0K
PiAgICAgICAgICAgICAgICAgaWYgKCFpc19zaGFkb3dfcHJlc2VudF9wdGUoc3B0ZSkpDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiAgDQo+IA0KDQo=
