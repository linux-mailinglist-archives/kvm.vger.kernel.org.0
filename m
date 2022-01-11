Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF148A5C0
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 03:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346614AbiAKClk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 21:41:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:43707 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244189AbiAKClj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 21:41:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641868899; x=1673404899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wXxV2I8AGIOVt9t0FQoTJadXO67yOrlMDyOUCMO2OaM=;
  b=jcSYV5BD1iSkcqVnAVyDhVso2khpvkyEAL1dd/FEx7jcFy+m/JkazEkf
   q/IdrVWVU1qKB+J0uOIbmJhEDL3xjJazJRqA0cfB6Hcg3m7OGixpdlan4
   06UYfXhDicqXsSw/FZY8MxPL2KB821ZODCU6D2N1OXOLE4xW1zIalGucj
   IxSuBnX2crCszD8LMXArGkovUpEiss6y2Ir4i1V2XDTWe8EIaMEX1LUhD
   xdvAv8R2XP9m3v3G4Qhhg8ZdcxRUPS5sOEinwBfZma+JSUpxXpyBMQfCf
   2unFi0SFNPEGIFn0MCf5daljgTGwvrBWy3JC64R6X9+EhIKKJR2Hz6tqN
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="230727692"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="230727692"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 18:41:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="690815940"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 10 Jan 2022 18:41:38 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 18:41:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 18:41:38 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 18:41:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REt5M22ypcMZGIccq8eXLLgpb/Mh5qCeszqPYV7CXEklEXbUl68pP9VAN0S5DGbHnjPa+IAZTONv8vnEI/UyTzFzYuMdtH6Y1kbt+52gepgiZDP4z3cOu37xL1uwWdH/vvzPodI/XoJ77JAQpzemXwRH6QtNxnb16ceXseBC4LYzR8s3h4s6U3SvetpP4yTtLhWfWBx+DtTK8zy/njI3HWErDnNEsk2/2eSTRdtFL2NyMUIYXhckjB6LFU+9aV+BDX5071oCsM1WY7BDwuQIYJjSFDUtFtXTZQ1/Ft6PtlnUU9/EIi/UGvFL48/iT9MZnvxLSj60t4eEtDOpK7YvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXxV2I8AGIOVt9t0FQoTJadXO67yOrlMDyOUCMO2OaM=;
 b=eFu7kOQ2aZ7jDw4Xv9DLR9e1AAVGmXI+x8RWG9F+WZF0DTnEl9ESVdnBPFmkOVRyx55H+GEeP4swbbj56seC1Sa8Dlo7S2mRrBBIQbp4dHvXj+DaEeqcQo+FfzaSW81Y5tqfvdHwK3Z/p/hzyU/nHjEPyeLXALPBy4qyRy1U9N2fh4UcSQ6MVw3E5qyGhAaxQFnH52GNJb7b+XNlAFoWtmO1zkUfdayi3TP8BrZJJTGH0TKzzwB1xX0Na9oQojCt38lZCoSn4+w0F9QAoxtDy5PZVSvMdZo58Fh+hKtRKs5iM8MohkdksTSxQKaDwDeK3Bt882QPfctlM1KhG3dHDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1650.namprd11.prod.outlook.com (2603:10b6:405:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 02:41:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 02:41:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAJ0m2AgBdyDgCAAv/9AIAAM0+AgAVWcQCAALN/AIAAlv/A
Date:   Tue, 11 Jan 2022 02:41:31 +0000
Message-ID: <BN9PR11MB5276F0F74A90AC8A02FCCF218C519@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
        <20211210012529.GC6385@nvidia.com>
        <20211213134038.39bb0618.alex.williamson@redhat.com>
        <20211214162654.GJ6385@nvidia.com>
        <20211220152623.50d753ec.alex.williamson@redhat.com>
        <20220104202834.GM2328285@nvidia.com>
        <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
        <20220106212057.GM2328285@nvidia.com>
        <BN9PR11MB52767CB9E4C30143065549C98C509@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220110103404.6130bc65.alex.williamson@redhat.com>
In-Reply-To: <20220110103404.6130bc65.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 131912ca-1c98-4002-4702-08d9d4abe066
x-ms-traffictypediagnostic: BN6PR11MB1650:EE_
x-microsoft-antispam-prvs: <BN6PR11MB165070931348D852DD50B81E8C519@BN6PR11MB1650.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5c4R2e3xzA+ahkaU1isqhv7fW7HkGw8Tc/o8E91DSB2bRNWY5ZviGShbSyWoI2CIDvlH7FR9P5TKCuWW0KeDLCCBZrwhW6j+DEAaK5i5gBsljHPNASKWHen8JiJ9zVeD/6E0Inrrk5d3qyqmEFE9BL3CKLXTCKU9gGkD03FMs0f85t0xErHTpmpNrIqBCFKRIHI/l8BQ//GvUwpV4MWErbQGFUFP8CaWsdsLgbdUXlkpNMSqt0sbqVgSLJ6DVzsbBp2XZ+HjuW3paAzQRU17DJFoPt3p0TbZmv3mDq3Cz8b4ItT4DPqNlMLDFFNWYKFpgWVSg9XTI9EoWrkpBuFk8cgB2qADXM/jnkw24ut+JBzYdyyUnqIEaky5c/I8P3ZeWnseogZX4Hqgkog1OOuRoYTRzRimcMxZWdEz1/VALWeGi8aW+s7l4PIklIvjvzAzqUG5AkFjbAXJokGmLbee/X0ndLW0DmQhbTunrm2dK5Ohxgsltj1ViLhVVKFztxHSoHoI/0Ne+eMY/ovtkOcmwWIrv046SG1dwHsgXx75MUFcskIs87y1Qgm8VnwdnKamCS47rOMsnztY5b23+sASuGuYhUQkem3sou3sUFjmSk90aa2wyjWyKxhyo8B4dadW61ypC1yRekY4k3CNuOiu2y6z9X5DU6t63qNky8uT/CSvUYH8b/mjwXf8JSt8xOe93KWlDIEPM6dipQtbwM70/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(76116006)(26005)(66556008)(66476007)(186003)(508600001)(52536014)(316002)(64756008)(66446008)(55016003)(9686003)(6916009)(82960400001)(5660300002)(66946007)(86362001)(4326008)(54906003)(6506007)(2906002)(38100700002)(122000001)(8676002)(8936002)(71200400001)(7696005)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0xIcWxhWmJRVWNpL2hCZ05ya3U4ZHg1MW93WUtUczZjd21hM0xMTy9zdXo3?=
 =?utf-8?B?bXFjakxaaGM2d2pZTmcyYi9wZHY4MGZXK1N3cmZEWGw1Tmg2Yk1mYzVtMkQ3?=
 =?utf-8?B?WnNJdzJyYnB0anR0WjVPVG9NUVBpTzB6d2FrdDFtdjdSTE5ueDgrdGY0UXVo?=
 =?utf-8?B?VEdiazJjTTRNU2lqNWg3SUlndHdpU2xNb2t3NlV1K243dFcweFpQNmszbjRJ?=
 =?utf-8?B?dmEvSnZCcnpFT0NlbkZRUERsamFJcFcwUFE0TmVKbFVSRzVoU1E0SWZaY3hx?=
 =?utf-8?B?Wk5PNEQ5ZDVsUTVBdnQrK3l6U0x0TS85T0k3WGhHc0JVNE56TFhMQkpic1Qr?=
 =?utf-8?B?dytTbGZYbm5nRVlqWndMaVM5STRBL0hCY1d2OGtWSE11WUo5b3F4TGpweFVM?=
 =?utf-8?B?SW1VUmtYUGRYeGNDNGdqV0tWcEtmNlltalBVTDFiek9OMGZsdi9kRGlkQW9P?=
 =?utf-8?B?dHlyUGliRHZNWTJuZzJIODVndWJ4TGZ3WFQxWEM5bUJSeTZjd1hYZFlJWlBp?=
 =?utf-8?B?b0VVdTRtcTFZay9yOWxxMTBldmF6Q2pTUTBaMHFrN1BHVzYzUjJmRkhqSGxT?=
 =?utf-8?B?N3E1ZWN4djRRcGwvbk44L05LVzlyQ20vT1pSbE92ZnNwOFVOaStLdWJWZy9o?=
 =?utf-8?B?bTduWkdNa1lqemxwMGV1d1R3TnpTT2pLdW1DNG5KbnMwNnRlaTBlaStDeEVC?=
 =?utf-8?B?eWVHK1oyT3FOWGs2OEMrNW05VTRYMmNoaGZNYUJoT2xRMUdPMTB6aDBPYzRM?=
 =?utf-8?B?L1lvWTFVVUhkdGgvaG1RdFNTcE0xMllsWTlaQ1h1aTZZNVpPNFI1dFMwTHU2?=
 =?utf-8?B?R3JGY2dqd1lSSFlhWG91ODhFR00zUERZNFNVZFk2aE51RkRsL1FOWStkWEVM?=
 =?utf-8?B?cnBYTTN4V0JDYVFwVU8xaStrYUVhL2o0Q3YwN24wNVgzUTltRllTd3dRaEw5?=
 =?utf-8?B?bzVtWk5OZUVhOStROXVGOVdxemM5UklsL0kvZyt5TnVsRmFFQUx0ZiszUDEy?=
 =?utf-8?B?bmpOYU5tS1lmOCt5QUUyQ3pOajkzSFM3WUYzYnBLTlQ5T2M2SUcrVkxteWRY?=
 =?utf-8?B?aEQ1MlcyYldld2p1MXA2aStoMEMwdUQxaVByb0tXMldvOVp6OGNOTHJuUnkv?=
 =?utf-8?B?cUZERVVMU3NZN01pVmQydUdYd3BCTFdLMGNYVzAyK0RvWkhWdXRTdDJFeHgv?=
 =?utf-8?B?UmhRdDdzZ1ZaUFZkYzVoWTVBTlFKMzNWc013U2JhdW5HckJsUUsyOXA0VmFD?=
 =?utf-8?B?Q2U0dWZMdnpkNjB1SFpNYno0RGZkYnh3NSs0UFk0ci94TEtCVk5KeWJLNTZw?=
 =?utf-8?B?aGZlejQrZEpFQW94ZDREVUFxL1NqOGxTWW9XMVg1TXF2TkxYU3dGSEIxRWpt?=
 =?utf-8?B?RDdLV0FydFdpcHpNMkFtK0lTYlZhNlByL2l4R3JJV1NFRk5BTUdVb3FvUjVu?=
 =?utf-8?B?YjBjRmN2QkoyVDRYckJUNjFJMDhHTGNrQVAvVWJ5Y2ljMVhXaHd0ckk3U1lm?=
 =?utf-8?B?dzRvTXQxV1Jyd3ZOLytrYU1VMUhSK0t6RVlJRW5COTdNeWEzL3BRcytQY0l1?=
 =?utf-8?B?UGlRQkZUeFVjYXQ2ZUVvOEZYMmRiajN5MFNsNmcyQnRCeGY1OGNZMmxUMlpj?=
 =?utf-8?B?c29BT0lGeGZaMWJjT0NPQi9qVFRTL2ZJaFh1Y1JITFRubGlmUzFoSnFwMFJB?=
 =?utf-8?B?dkRlb1B2NWtCem9BY3RzZ0JzaHZqZTV4ZGE3MVR1clZBTWNFTHpwdHRUZlVr?=
 =?utf-8?B?NTYwdnp6cXUreHQ1ZUNxN1c3VFFmTVhQV1pPSENFQmJrbW1hM0ZNMzdBMXA2?=
 =?utf-8?B?VXlqY0dac3I3WnRXNkJLemU0elNJMUFKTUpGNHBmMFBMS0E1QktIUldqWTRQ?=
 =?utf-8?B?UGJkQ2Rya0R1QnJuSUdFMmFYdWxmZzI1aWNiZXFhWExlRHB0VEZmUTBVczVU?=
 =?utf-8?B?VzhleDN6aUQ2dWh6VmVnRHFVZmpIQWE1VFJaM1JjZU56bWZONEdlVE8zeHl0?=
 =?utf-8?B?TFI3Q0N0MVc4Q0JWbXhJYmNMM0RzSUpvck4rcXI1Z0x3Z3ZkaWZHUUgyZk84?=
 =?utf-8?B?TlRLa0Y3T1g0dUE4R0djY2psNWdscFMvZlhiQXVtUVdrZ3RHekJuMThMMWc2?=
 =?utf-8?B?WDRPVml3UXFSNlVxeGFmdk94VW9LOVJZZWxSNWxxOGhsUVNKOUhkTlBTYkdj?=
 =?utf-8?Q?8C4397woXUrMFV3aqL9Cfhs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 131912ca-1c98-4002-4702-08d9d4abe066
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 02:41:31.6999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EzSkNenIBeE/gIcq0iQx641+/+mnCHxu1/W8IsUYLrqFcoVQvHyaGpFkjQPmzsx7mVybLy51kuZQ0MF69XiJeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1650
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBKYW51YXJ5IDExLCAyMDIyIDE6MzQgQU0NCj4gDQo+IE9uIE1vbiwgMTAg
SmFuIDIwMjIgMDc6NTU6MTYgKzAwMDANCj4gIlRpYW4sIEtldmluIiA8a2V2aW4udGlhbkBpbnRl
bC5jb20+IHdyb3RlOg0KPiANCj4gPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRp
YS5jb20+DQo+ID4gPiBTZW50OiBGcmlkYXksIEphbnVhcnkgNywgMjAyMiA1OjIxIEFNDQo+ID4g
Pg0KPiA+ID4gV2Ugd2VyZSBhbHNvIHRoaW5raW5nIHRvIHJldGFpbiBTVE9QLiBTQVZJTkcgLT4g
U1RPUCBjb3VsZCBwb3NzaWJseQ0KPiA+ID4gc2VydmUgYXMgdGhlIGFib3J0IHBhdGggdG8gYXZv
aWQgYSBkb3VibGUgYWN0aW9uLCBhbmQgc29tZSBvZiB0aGUgdXNlDQo+ID4gPiBjYXNlcyB5b3Ug
SUQnZCBiZWxvdyBhcmUgYWNoaWV2YWJsZSBpZiBTVE9QIHJlbWFpbnMuDQo+ID4NCj4gPiB3aGF0
IGlzIHRoZSBleGFjdCBkaWZmZXJlbmNlIGJldHdlZW4gYSBudWxsIHN0YXRlIHt9IChpbXBseWlu
ZyAhUlVOTklORykNCj4gPiBhbmQgU1RPUCBpbiB0aGlzIGNvbnRleHQ/DQo+ID4NCj4gPiBJZiB0
aGV5IGFyZSBkaWZmZXJlbnQsIHdobyAodXNlciBvciBkcml2ZXIpIHNob3VsZCBjb25kdWN0IGFu
ZCB3aGVuIGRvDQo+ID4gd2UgZXhwZWN0IHRyYW5zaXRpb25pbmcgdGhlIGRldmljZSBpbnRvIGEg
bnVsbCBzdGF0ZT8NCj4gDQo+IFNvcnJ5IGlmIEkgYWRkZWQgY29uZnVzaW9uIGhlcmUsIHRoZSBu
dWxsLCBpZS4ge30sIHN0YXRlIGZpdCBteQ0KPiBub3RhdGlvbiBiZXR0ZXIuICBUaGUgbnVsbCBz
dGF0ZSBpcyBzaW1wbHkgbm8gYml0cyBzZXQgaW4gZGV2aWNlX3N0YXRlLA0KPiBpdCdzIGVxdWl2
YWxlbnQgdG8gIlNUT1AiIHdpdGhvdXQgY29taW5nIHVwIHdpdGggYSBuZXcgbmFtZSBmb3IgZXZl
cnkNCj4gc2V0IG9mIGJpdCBjb21iaW5hdGlvbnMuDQoNClRoaXMgbWF0Y2hlcyBteSB0aG91Z2h0
LiBFYXJsaWVyIHJlYWRpbmcgdGhpcyB0aHJlYWQgSSB3YXMgbGVmdCB3aXRoDQp0aGUgaW1wcmVz
c2lvbiB0aGF0IEphc29uIG1lYW5zICdTVE9QJyBhcyBhIG5ldyBzdGF0ZS4NCg0KPiANCj4gPiA+
ID4gV2UgaGF2ZSAyMCBwb3NzaWJsZSB0cmFuc2l0aW9ucy4gIEkndmUgbWFya2VkIHRob3NlIGF2
YWlsYWJsZSB2aWEgdGhlDQo+ID4gPiA+ICJvZGQgYXNjaWkgYXJ0IiBkaWFncmFtIGFzIChhKSwg
dGhhdCdzIDcgdHJhbnNpdGlvbnMuICBXZSBjb3VsZA0KPiA+ID4gPiBlc3NlbnRpYWxseSByZW1v
dmUgdGhlIE5VTEwgc3RhdGUgYXMgdW5yZWFjaGFibGUgYXMgdGhlcmUgc2VlbXMgbGl0dGxlDQo+
ID4gPiA+IHZhbHVlIGluIHRoZSAyIHRyYW5zaXRpb25zIG1hcmtlZCAoYSkqIGlmIHdlIGxvb2sg
b25seSBhdCBtaWdyYXRpb24sDQo+ID4gPiA+IHRoYXQgd291bGQgYnJpbmcgdXMgZG93biB0byA1
IG9mIDEyIHBvc3NpYmxlIHRyYW5zaXRpb25zLiAgV2UgbmVlZCB0bw0KPiA+ID4gPiBnaXZlIHVz
ZXJzcGFjZSBhbiBhYm9ydCBwYXRoIHRob3VnaCwgc28gd2UgbWluaW1hbGx5IG5lZWQgdGhlIDIN
Cj4gPiA+ID4gdHJhbnNpdGlvbnMgbWFya2VkIChiKSAoNy8xMikuDQo+ID4gPg0KPiA+ID4gPiBT
byBub3cgd2UgY2FuIGRpc2N1c3MgdGhlIHJlbWFpbmluZyA1IHRyYW5zaXRpb25zOg0KPiA+ID4g
Pg0KPiA+ID4gPiB7U0FWSU5HfSAtPiB7UkVTVU1JTkd9DQo+ID4gPiA+IAlJZiBub3Qgc3VwcG9y
dGVkLCB1c2VyIGNhbiBhY2hpZXZlIHRoaXMgdmlhOg0KPiA+ID4gPiAJCXtTQVZJTkd9LT57UlVO
TklOR30tPntSRVNVTUlOR30NCj4gPiA+ID4gCQl7U0FWSU5HfS1SRVNFVC0+e1JVTk5JTkd9LT57
UkVTVU1JTkd9DQo+ID4gPg0KPiA+ID4gVGhpcyBjYW4gYmU6DQo+ID4gPg0KPiA+ID4gU0FWSU5H
IC0+IFNUT1AgLT4gUkVTVU1JTkcNCj4gPg0KPiA+IEZyb20gQWxleCdzIG9yaWdpbmFsIGRlc2Ny
aXB0aW9uIHRoZSBkZWZhdWx0IGRldmljZSBzdGF0ZSBpcyBSVU5OSU5HLg0KPiA+IFRoaXMgc3Vw
cG9zZWQgdG8gYmUgdGhlIGluaXRpYWwgc3RhdGUgb24gdGhlIGRlc3QgbWFjaGluZSBmb3IgdGhl
DQo+ID4gZGV2aWNlIGFzc2lnbmVkIHRvIFFlbXUgYmVmb3JlIFFlbXUgcmVzdW1lcyB0aGUgZGV2
aWNlIHN0YXRlLg0KPiA+IFRoZW4gaG93IGRvIHdlIGVsaW1pbmF0ZSB0aGUgUlVOTklORyBzdGF0
ZSBpbiBhYm92ZSBmbG93PyBXaG8NCj4gPiBtYWtlcyBTVE9QIGFzIHRoZSBpbml0aWFsIHN0YXRl
IG9uIHRoZSBkZXN0IG5vZGU/DQo+IA0KPiBUaGUgZGV2aWNlIG11c3QgYmUgUlVOTklORyBieSBk
ZWZhdWx0LiAgVGhpcyBpcyBhIHJlcXVpcmVtZW50IHRoYXQNCj4gaW50cm9kdWN0aW9uIG9mIG1p
Z3JhdGlvbiBzdXBwb3J0IGZvciBhIGRldmljZSBjYW5ub3QgYnJlYWsNCj4gY29tcGF0aWJpbGl0
eSB3aXRoIGV4aXN0aW5nIHVzZXJzcGFjZSB0aGF0IG1heSBubyBzdXBwb3J0IG1pZ3JhdGlvbg0K
PiBmZWF0dXJlcy4gIEl0IHdvdWxkIGJlIFFFTVUncyByZXNwb25zaWJpbGl0eSB0byB0cmFuc2l0
aW9uIGEgbWlncmF0aW9uDQo+IHRhcmdldCBkZXZpY2UgZnJvbSB0aGUgZGVmYXVsdCBzdGF0ZSB0
byBhIHN0YXRlIHRvIGFjY2VwdCBhIG1pZ3JhdGlvbi4NCj4gVGhlcmUncyBubyBkaXNjdXNzaW9u
IGhlcmUgb2YgZWxpbWluYXRpbmcgdGhlIHtSVU5OSU5HfS0+e1JFU1VNSU5HfQ0KPiB0cmFuc2l0
aW9uLg0KDQpUaGVuIGhhdmluZyBTVE9QIGluIHRoZSBmbG93IGlzIG1lYW5pbmdsZXNzLiBJdCBh
Y3R1YWxseSBtZWFuczoNCg0Ke1NBVklOR30tUkVTRVQtPntSVU5OSU5HfS0+e1NUT1B9LT57UkVT
VU1JTkd9DQoNCj4gDQo+ID4gPiA+IGRyaXZlcnMgZm9sbG93IHRoZSBwcmV2aW91c2x5IHByb3Zp
ZGVkIHBzZXVkbyBhbGdvcml0aG0gd2l0aCB0aGUNCj4gPiA+ID4gcmVxdWlyZW1lbnQgdGhhdCB0
aGV5IGNhbm5vdCBwYXNzIHRocm91Z2ggYW4gaW52YWxpZCBzdGF0ZSwgd2UgbmVlZCB0bw0KPiA+
ID4gPiBmb3JtYWxseSBhZGRyZXNzIHdoZXRoZXIgdGhlIE5VTEwgc3RhdGUgaXMgaW52YWxpZCBv
ciBqdXN0IG5vdA0KPiA+ID4gPiByZWFjaGFibGUgYnkgdGhlIHVzZXIuDQo+ID4gPg0KPiA+ID4g
V2hhdCBpcyBhIE5VTEwgc3RhdGU/DQo+ID4NCj4gPiBIYWgsIHNlZW1zIEknbSBub3QgdGhlIG9u
bHkgb25lIGhhdmluZyB0aGlzIGNvbmZ1c2lvbi4g8J+Yig0KPiANCj4gU29ycnkgYWdhaW4sIEkg
dGhvdWdodCBpdCBjb3VsZCBlYXNpbHkgYmUgZGVkdWNlZCBieSBpbmNsdWRpbmcgaXQgaW4NCj4g
dGhlIHN0YXRlIHRyYW5zaXRpb25zLg0KPiANCj4gPiA+IFdlIGhhdmUgZGVmaW5lZCAoZnJvbSBt
ZW1vcnksIGZvcmdpdmUgbWUgSSBkb24ndCBoYXZlIGFjY2VzcyB0bw0KPiA+ID4gWWlzaGFpJ3Mg
bGF0ZXN0IGNvZGUgYXQgdGhlIG1vbWVudCkgOCBmb3JtYWwgRlNNIHN0YXRlczoNCj4gPiA+DQo+
ID4gPiAgUlVOTklORw0KPiA+ID4gIFBSRUNPUFkNCj4gPiA+ICBQUkVDT1BZX05ETUENCj4gPiA+
ICBTVE9QX0NPUFkNCj4gPiA+ICBTVE9QDQo+ID4gPiAgUkVTVU1JTkcNCj4gPiA+ICBSRVNVTUlO
R19ORE1BDQo+ID4gPiAgRVJST1IgKHBlcmhhcHMgTVVTVF9SRVNFVCkNCj4gPg0KPiA+IEVSUk9S
LT5TSFVURE9XTj8gVXN1YWxseSBhIHNodXRkb3duIHN0YXRlIGltcGxpZXMgcmVzZXQgcmVxdWly
ZWQuLi4NCj4gDQo+IFRoZSB1c2Vyc3BhY2UgcHJvY2VzcyBjYW4gZ28gYXdheSBhdCBhbnkgdGlt
ZSwgd2hhdCBleGFjdGx5IGlzIGENCj4gIlNIVVRET1dOIiBzdGF0ZSByZXByZXNlbnRpbmc/DQoN
Ckkgc3VwcG9zZSBjbG9zaW5nIGZkIGZvciBwcmV2aW91cyBwcm9jZXNzIHRyYW5zaXRpb25zIHRo
ZSBkZXZpY2Ugc3RhdGUNCnRvIE5VTEwgb3IgU1RPUCBzdGF0ZSBmcm9tIHdoYXRldmVyIGN1cnJl
bnQgc3RhdGUgaXMuIFRoZW4gd2hlbiANCmFub3RoZXIgcHJvY2VzcyBvcGVucyB0aGUgc2FtZSBk
ZXZpY2UgaXRzIHN0YXRlIGJlY29tZXMgUlVOTklORy4NCg0KQWxsIG90aGVyIHN0YXRlcyBpbmNs
dWRpbmcgU0hVVERPV04gb25seSBoYXZlIGVmZmVjdCB3aGVuIHRoZQ0KZGV2aWNlIGZkIGlzIG9w
ZW5lZC4NCg0KPiANCj4gPiA+ID4gQnV0IEkgdGhpbmsgeW91J3ZlIGlkZW50aWZpZWQgdHdvIGNs
YXNzZXMgb2YgRE1BLCBNU0kgYW5kIGV2ZXJ5dGhpbmcNCj4gPiA+ID4gZWxzZS4gIFRoZSBkZXZp
Y2UgY2FuIGFzc3VtZSB0aGF0IGFuIE1TSSBpcyBzcGVjaWFsIGFuZCBub3QgaW5jbHVkZWQgaW4N
Cj4gPiA+ID4gTkRNQSwgYnV0IGl0IGNhbid0IGtub3cgd2hldGhlciBvdGhlciBhcmJpdHJhcnkg
RE1BcyBhcmUgcDJwIG9yDQo+IG1lbW9yeS4NCj4gPiA+ID4gSWYgd2UgZGVmaW5lIHRoYXQgdGhl
IG1pbmltdW0gcmVxdWlyZW1lbnQgZm9yIG11bHRpLWRldmljZSBtaWdyYXRpb24NCj4gaXMNCj4g
PiA+ID4gdG8gcXVpZXNjZSBwMnAgRE1BLCBleC4gYnkgbm90IGFsbG93aW5nIGl0IGF0IGFsbCwg
dGhlbiBORE1BIGlzDQo+ID4gPiA+IGFjdHVhbGx5IHNpZ25pZmljYW50bHkgbW9yZSByZXN0cmlj
dGl2ZSB3aGlsZSBpdCdzIGVuYWJsZWQuDQo+ID4gPg0KPiA+ID4gWW91IGFyZSByaWdodCwgYnV0
IGluIGFueSBwcmFjdGljYWwgcGh5c2ljYWwgZGV2aWNlIE5ETUEgd2lsbCBiZQ0KPiA+ID4gaW1w
bGVtZW50ZWQgYnkgaGFsdGluZyBhbGwgRE1Bcywgbm90IGp1c3QgcDJwIG9uZXMuDQo+ID4gPg0K
PiA+ID4gSSBkb24ndCBtaW5kIHdoYXQgd2UgbGFiZWwgdGhpcywgc28gbG9uZyBhcyB3ZSB1bmRl
cnN0YW5kIHRoYXQgaGFsdGluZw0KPiA+ID4gYWxsIERNQSBpcyBhIHZhbGlkIGRldmljZSBpbXBs
ZW1lbnRhdGlvbi4NCj4gPiA+DQo+ID4gPiBBY3R1YWxseSwgaGF2aW5nIHJlZmxlY3RlZCBvbiB0
aGlzIG5vdywgb25lIG9mIHRoZSB0aGluZ3Mgb24gbXkgbGlzdA0KPiA+ID4gdG8gZml4IGluIGlv
bW11ZmQsIGlzIHRoYXQgbWRldnMgY2FuIGdldCBhY2Nlc3MgdG8gUDJQIHBhZ2VzIGF0IGFsbC4N
Cj4gPiA+DQo+ID4gPiBUaGlzIGlzIGN1cnJlbnRseSBidWdneSBhcy1pcyBiZWNhdXNlIHRoZXkg
Y2Fubm90IERNQSBtYXAgdGhlc2UNCj4gPiA+IHRoaW5ncywgdG91Y2ggdGhlbSB3aXRoIHRoZSBD
UFUgYW5kIGttYXAsIG9yIGRvLCByZWFsbHksIGFueXRoaW5nIHdpdGgNCj4gPiA+IHRoZW0uDQo+
ID4NCj4gPiBDYW4geW91IGVsYWJvcmF0ZSB3aHkgbWRldiBjYW5ub3QgYWNjZXNzIHAycCBwYWdl
cz8NCj4gPg0KPiA+ID4NCj4gPiA+IFNvIHdlIHNob3VsZCBiZSBibG9ja2luZyBtZGV2J3MgZnJv
bSBhY2Nlc3NpbmcgUDJQLCBhbmQgaW4gdGhhdCBjYXNlIGENCj4gPiA+IG1kZXYgZHJpdmVyIGNh
biBxdWl0ZSByaWdodGx5IHNheSBpdCBkb2Vzbid0IHN1cHBvcnQgUDJQIGF0IGFsbCBhbmQNCj4g
PiA+IHNhZmVseSBOT1AgTkRNQSBpZiBORE1BIGlzIGRlZmluZWQgdG8gb25seSBpbXBhY3QgUDJQ
IHRyYW5zYWN0aW9ucy4NCj4gPiA+DQo+ID4gPiBQZXJoYXBzIHRoYXQgYW5zd2VycyB0aGUgcXVl
c3Rpb24gZm9yIHRoZSBTMzkwIGRyaXZlcnMgYXMgd2VsbC4NCj4gPiA+DQo+ID4gPiA+IFNob3Vs
ZCBhIGRldmljZSBpbiB0aGUgRVJST1Igc3RhdGUgY29udGludWUgb3BlcmF0aW9uIG9yIGJlIGlu
IGENCj4gPiA+ID4gcXVpZXNjZWQgc3RhdGU/ICBJdCBzZWVtcyBvYnZpb3VzIHRvIG1lIHRoYXQg
c2luY2UgdGhlIEVSUk9SIHN0YXRlIGlzDQo+ID4gPiA+IGVzc2VudGlhbGx5IHVuZGVmaW5lZCwg
dGhlIGRldmljZSBzaG91bGQgY2Vhc2Ugb3BlcmF0aW9ucyBhbmQgYmUNCj4gPiA+ID4gcXVpZXNj
ZWQgYnkgdGhlIGRyaXZlci4gIElmIHRoZSBkZXZpY2UgaXMgY29udGludWluZyB0byBvcGVyYXRl
IGluIHRoZQ0KPiA+ID4gPiBwcmV2aW91cyBzdGF0ZSwgd2h5IHdvdWxkIHRoZSBkcml2ZXIgcGxh
Y2UgdGhlIGRldmljZSBpbiB0aGUgRVJST1INCj4gPiA+ID4gc3RhdGU/ICBJdCBzaG91bGQgaGF2
ZSByZXR1cm5lZCBhbiBlcnJubyBhbmQgbGVmdCB0aGUgZGV2aWNlIGluIHRoZQ0KPiA+ID4gPiBw
cmV2aW91cyBzdGF0ZS4NCj4gPiA+DQo+ID4gPiBXaGF0IHdlIGZvdW5kIHdoaWxlIGltcGxlbWVu
dGluZyBpcyB0aGUgdXNlIG9mIEVSUk9SIGFyaXNlcyB3aGVuIHRoZQ0KPiA+ID4gZHJpdmVyIGhh
cyBiZWVuIGZvcmNlZCB0byBkbyBtdWx0aXBsZSBhY3Rpb25zIGFuZCBpcyB1bmFibGUgdG8gZnVs
bHkNCj4gPiA+IHVud2luZCB0aGUgc3RhdGUuIFNvIHRoZSBkZXZpY2Vfc3RhdGUgaXMgbm90IGZ1
bGx5IHRoZSBvcmlnaW5hbCBzdGF0ZQ0KPiA+ID4gb3IgZnVsbHkgdGhlIHRhcmdldCBzdGF0ZS4g
VGh1cyBpdCBpcyBFUlJPUi4NCj4gPiA+DQo+ID4gPiBUaGUgYWRkaXRpb25hbCByZXF1aXJlbWVu
dCB0aGF0IHRoZSBkcml2ZXIgZG8gYW5vdGhlciBhY3Rpb24gdG8NCj4gPiA+IHF1aWVzY2UgdGhl
IGRldmljZSBvbmx5IGludHJvZHVjZXMgdGhlIHBvc3NpYmxpdHkgZm9yIHRyaXBsZSBmYWlsdXJl
Lg0KPiA+ID4NCj4gPiA+IFNpbmNlIGl0IGRvZXNuJ3QgYnJpbmcgYW55IHZhbHVlIHRvIHVzZXJz
cGFjZSwgSSBwcmVmZXIgd2Ugbm90IGRlZmluZQ0KPiA+ID4gdGhpbmdzIGluIHRoaXMgY29tcGxp
Y2F0ZWQgd2F5Lg0KPiA+DQo+ID4gU28gRVJST1IgaXMgcmVhbGx5IGFib3V0IHVucmVjb3ZlcmFi
bGUgZmFpbHVyZXMuIElmIHJlY292ZXJhYmxlIHN1cHBvc2UNCj4gPiBlcnJubyBzaG91bGQgaGF2
ZSBiZWVuIHJldHVybmVkIGFuZCB0aGUgZGV2aWNlIGlzIHN0aWxsIGluIHRoZSBvcmlnaW5hbA0K
PiA+IHN0YXRlLiBJcyB0aGlzIHVuZGVyc3RhbmRpbmcgY29ycmVjdD8NCj4gDQo+IFllcywgdGhh
dCdzIGhvdyBJIHVuZGVyc3RhbmQgaXQuICBUaGUgRVJST1Igc3RhdGUgc2hvdWxkIGJlIHVzZWQg
aWYgdGhlDQo+IGRyaXZlciBjYW4gbmVpdGhlciBwcm92aWRlIHRoZSByZXF1ZXN0ZWQgbmV3IHN0
YXRlIG5vciByZW1haW4vcmV0dXJuIHRvDQo+IHRoZSBvbGQgc3RhdGUuDQo+IA0KPiA+IGJ0dyB3
aGljaCBlcnJubyBpbmRpY2F0ZXMgdG8gdGhlIHVzZXIgdGhhdCB0aGUgZGV2aWNlIGlzIGJhY2sg
dG8gdGhlDQo+ID4gb3JpZ2luYWwgc3RhdGUgb3IgaW4gdGhlIEVSUk9SIHN0YXRlPyBvciB3YW50
IHRoZSB1c2VyIHRvIGFsd2F5cyBjaGVjaw0KPiA+IHRoZSBkZXZpY2Ugc3RhdGUgdXBvbiBhbnkg
dHJhbnNpdGlvbiBlcnJvcj8NCj4gDQo+IE5vIHN1Y2ggZW5jb2RpbmcgaXMgZGVmaW5lZCBvciBy
ZXF1aXJlZCwgcGVyIHRoZSBleGlzdGluZyB1QVBJIHRoZSB1c2VyDQo+IGlzIHRvIHJlLWV2YWx1
YXRlIGRldmljZV9zdGF0ZSBvbiBhbnkgbm9uLXplcm8gZXJybm8uICBUaGFua3MsDQo+IA0KDQpN
YWtlcyBzZW5zZS4NCg0KVGhhbmtzDQpLZXZpbg0K
