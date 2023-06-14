Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303E072F99D
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 11:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbjFNJpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 05:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244334AbjFNJow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 05:44:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6B32110;
        Wed, 14 Jun 2023 02:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686735844; x=1718271844;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WRVTml8vSErOzHkm4+t86y7xRQSDuUiMriPwAnorK5w=;
  b=nPTMfxv9hS1Wp+J8gVoJ3h9ZQpPMiECFKeGU3NGA55mNBGBdmKUTTFIV
   vZh+ErazzrlkGNlCXU7nS/2JQiKxWaOjH64BxtbZex1493oVYL29qj42k
   JNHjZU52YI7Dy6X/ZKUI40c8iAGhzh9qfzwgfVbxzjwEYjGpyW9ijbFPm
   OCIwp5y9DlTmVDj08zHgvXkUq5U0fSDNBVS6kvy2ujSOQ+B2r+DVUK2v6
   FD4E/XcXY3X1Z8XEkX40S99/S1vh5BgFz6QNzaum8rhq0B/2CjZ8PxWGs
   udwKynZp3cY7Lw7t/JbLdhB3fk4bf7Q/XZOZ2yPiPqB2PjC+QaildO7wc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="348230286"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="348230286"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 02:44:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="706162236"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="706162236"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2023 02:44:03 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 02:43:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 02:43:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 02:43:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7Z6lRzrAbv/QHwkLTgaW1pdnSLzN4IeY4867rnelSv8xFisyn6XzWJrn52ExGGlhXl4pEd3kEBmRBhd4wINGRsfod/k+1H6fTbVNz4SgGFGdOsGo/4xg2nKOOQ5YW3TzmS7PifOyyKFBZrWJHfSSe94YQ9vMcXk55WHh7KKLaEBW+Vm2pJOFuQQtNjIw+WjZAWKUfUB+1AdzbzQ5Eq3hgD1SZRphWXIze7/QvPuJuw+xsYTlZJxCOAWVDyfXVGFwkT5bBgJbPXwkxLDOKPxiRSHCTtVClJDBN+L3iXkqFeBH80aONF60RIdQkRkSNlPeVpnL5TuGD5L/+t5iqb0NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRVTml8vSErOzHkm4+t86y7xRQSDuUiMriPwAnorK5w=;
 b=Hp7xLJiVjmVFzrE7wwt3wyaaF+4iy1kQADGUBZTShMXR0oKHOgc5ST2FTsbl5OqYNr4bgwGzL+4krvB3iLDYBqpFAIy55q/CIURH78ptLz2Pz0008FdzGhdE9gzHPfnpaNCne/8hBwrjQVax8tgey01YSoTTmAoh7vJnjkM8lYm7Oe1C+85RZzs1VoFD3zM0K5b9wGxPiJWXBF6OpALf5RmtrybrGK8pd2jWolchGVXnIKxmB1deUezQni5FJtMg/mm1rI/jAeJeyO0EgbF4LnJoY/iy5WJMYQdc3EtrdYAKt0Ssrb6MfWi2wN86DCrGesmVw8GfOCjFvVZUSPA/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7216.namprd11.prod.outlook.com (2603:10b6:8:11c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 09:43:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Wed, 14 Jun 2023
 09:43:55 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting
 CPUID
Thread-Topic: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting
 CPUID
Thread-Index: AQHZkeUiOK4roLgjWkKd/CN/ohKP6a9+gXUAgAqUeQCAAQ+8AA==
Date:   Wed, 14 Jun 2023 09:43:55 +0000
Message-ID: <0bb55025908cdc4011175603744a36549e235d58.camel@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
         <00f3770050fb0751273a48eb17804a7a1a697e75.1685333728.git.isaku.yamahata@intel.com>
         <05da9ce1eacab59e81801acca146b5f4949b98ac.camel@intel.com>
         <20230613173118.GO2244082@ls.amr.corp.intel.com>
In-Reply-To: <20230613173118.GO2244082@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7216:EE_
x-ms-office365-filtering-correlation-id: 02d8abf3-09f6-474d-061a-08db6cbbde88
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AZjp93ucUKWIjjD0xa0IzEHdWb3a1RpMgEOxvzkH8BteTk7CE4/H3uIWUi70UPdBNGPcFc4zrg5J6syk9sBlTVdmPJr6s/Xz9hLf+z8Xso/XlHFqHbdoVgg2vQmo0GuBKwNYX3Ung1W58Sv0zAAkDcjxs0Q1rtcQneDSxnisS8YJjHsk0KMQD4yECVjtcG4IMExIghB1aNuvzZSmFJevkdg6Nz9TRO9XY+ZSioNhMCHfIhIBPx4yJfbA9i82Eq7kDmDupfPG+/EaPmgr6E/5j6FoWlu+6rd5AWe9uVMgrER1amIeERuMdnYGIg5Ihllow0MpwhufFubr57MiNqcYL/nrcohM6SCbk01FogxabdxNiJasuGxrMV9oWHEI0FnyS9wyDCJD9gShtJ8vtJbfhWEw6aqj1BEsv2lEr1a6wJKsyrJknJEc0rVKL1H4D60NiYjmALQUXbDbyOV0XKQ5Dd8rlWtq6yMBNMvr+DwErujSH2H2Xc9TMkpA6fHnpCNu1fxKsGjAAyM8eAq0va1bvYsp3GfNSmlluzZf8IAN9wMIsDDV5Inw77qvUDvNhtpBwNJsBJEwwBEhX7ahgwbjPFki+hzjhahnKK/uvd6BJJp6FSWkdz9XtEtwFcrJEnrZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199021)(66476007)(6916009)(91956017)(64756008)(66446008)(4326008)(66556008)(76116006)(66946007)(36756003)(316002)(2906002)(5660300002)(8936002)(8676002)(41300700001)(6486002)(54906003)(38070700005)(86362001)(478600001)(38100700002)(122000001)(186003)(6506007)(6512007)(26005)(82960400001)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2hYWFNmUGtKYjRmSlB2cnplN2h5bVAyVDdad1RmTmkxTmJvSzVTbVRJSUxD?=
 =?utf-8?B?STh5alVCUFFWUTVMSFlHNmVWNjkvdEFxTUFDYmpITFhJTFhYR3lEeTV0Z0dj?=
 =?utf-8?B?NXZRdVlLcGM4MVdxSWEvWSt1U1hqWjJhYWtReHgrUkMwajN1ZFdydWg5QnFH?=
 =?utf-8?B?ZlpFNGF4MFZ4KzdJYjRQeWpMOHd3bzBtUU1LTHlpVkVrWG5nZEQ0dTY4MmZ5?=
 =?utf-8?B?SFhHZFhpazlwdTc2L3N3RUhSaitJTFVHK3NjYkV1ODk4Y0pHWWdkTno1MUdP?=
 =?utf-8?B?aElFT05zMHBRMDh2QWdoMmRIQU12eXRhbDVaRGIvUjVXWktaUGlwdzdLLytj?=
 =?utf-8?B?ME9jK2t4bkxPSHp5RTlQaG95a085b1A3RC92U21pNFlua3N2OTR0Q2JpQXBy?=
 =?utf-8?B?UXVtdjVYTSs1enRBeTFFQ0FtdnpkTXd5TEVnOFZUODE3MUo3WkpYdDRiNjIy?=
 =?utf-8?B?aFR2VkpXNWdZYlVvcTlkbG9Yem9BWGpYdHB1WVd5QXE4bjd2SWNHbGx5aE5H?=
 =?utf-8?B?cHAxYnZ5SG5sdXlweGF5VDFTcjJLYVcxT2E5eXVZa1U2d3IvRkhDb2hDSEp3?=
 =?utf-8?B?VVRua1IxNVN2Z28yTUFIeFkwaFNRTS8zaGhScmczS0dnSEFRK1JhcHQ1KzRs?=
 =?utf-8?B?SVc2TVpvMHBvelV5bitQb1l0dnQ3VTArSHUwMlhMVzgyb0N3N1pPOHM4dUt3?=
 =?utf-8?B?SDVtWXZ0NDk3d3Y3RGVYaGw3OFlvVEU3TlNlb2ZoaC9QQThndlZNczRUdU5L?=
 =?utf-8?B?T3Q5MEN3RWZvWDNVU2tnNTV2NTg5WExlVERUOFJGSSt4WGlKQ0RxODVkcmR3?=
 =?utf-8?B?OTIrYVhDRHU5YjlWdlBrTGlhQWJ3MjFwaW9NZjJZZU5EbnV6N2lWZTAvSmNo?=
 =?utf-8?B?cHhNVFBQTzZzaWJLL25MRnk4S3NQZnh2aDBKTTcyQWtPd0lmZUs0dlV5TG5r?=
 =?utf-8?B?Wnl2NEo4ZmtYTVJDYUpSQlpWRHZ1SVhvbS9vMTZMeUhCelVGd1BxTVN3blQv?=
 =?utf-8?B?eXZzY1lNTHNVSEZueVdLdzQ1Wi9tdlR2VzhucWw5ekNEcXVuWUVta2NMT0Jn?=
 =?utf-8?B?VWpjYWFtSExoWFdiMG5TOG1iZytLMU56ank2eDFXaGxpcXo2UFg1NnMxZUs1?=
 =?utf-8?B?VzREaUc0bDFMNEVkL3psYmxhN3YyczdoZ0xoUDJRN0NEYXZiU09sbmVQR0Y1?=
 =?utf-8?B?cmhuSHdCbS9BNWk1NXh4WThSc3VVYWF2aHdYMzBzWlEyUFgxeHVpSXZJaDk2?=
 =?utf-8?B?ajhrdzFzb1JScTc5NFpsWGxYZjl2VXhITmF3ZDlHWVl3dGg0bDE3NmN0L1Uw?=
 =?utf-8?B?TVlnclgvZnpUMjg4eE1EMlhtd3o3SnpsMURPZlNFd3ZuREVrYTJGVnoxNXJt?=
 =?utf-8?B?akJsKzJWa09UYlhaSFlKNmdoNjdrMDlYTFZhSDVPcGhib2VPL2NqVlp5d25M?=
 =?utf-8?B?c3EzbHQyVTFyK2J4MWVpVmJMOFh1dUY3aElpaFMrbHhaRjJjaFFXMEV1TGFq?=
 =?utf-8?B?VFdhQWorb1NXcHNoSjJzSUdZM3hqS0E4MGVTK2p2RU9mYVdJNDVaWnRqcEc4?=
 =?utf-8?B?MGszN1d5Nm84SVBqS0xhOGIxdGdrd3Z6MW15WkJ4aVJRd21hZm1rYzVhSW81?=
 =?utf-8?B?T1JucERmc1VqTEk0QU9yVFFsS3VWRm1qaW1UTHVZQ3ZaZ1c3eEFGT3lIM1Vr?=
 =?utf-8?B?R0puNnRlUFo1Y3dSRC8wUU1tZ2tFT1RHYlRQczZCTkluVjdhNUF2OU9mVFZO?=
 =?utf-8?B?bFBXay8vbXhJczN6STF3N0cySnlYZGpZSFRDbGxXVytKenloSEZOb2pVMlBv?=
 =?utf-8?B?V1lNclEwV0o5NThTbmsxbmF5eU1iM1pkMmpLbXlycVRTcjFPMnJtYnhtQXFV?=
 =?utf-8?B?aTJ3ZUJYZjgvc1lJdnJSU3NSSUU4Z1hVT1U0Yk1ESU1nSC9VcXBUcjdjZ3ls?=
 =?utf-8?B?ZElGZGRBYlc2ZWNHRlhZN2hzUnU2d1JEM094VEk4eGtwTG8wNElsS1d3d0FS?=
 =?utf-8?B?R0lYME81d0J6b2VQR01rSFMzWE9hWWRnUXBiNHFwVDgxTGdKUVdjYmpEUU02?=
 =?utf-8?B?dDhUZ1dZK2QrWGdrUUkyYXlVMU5wa2x5U0lXVmlCTW01NTVEYUpnSjVkdnVT?=
 =?utf-8?Q?swNx/JGHPuNzYPxGeJWvaDzOd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52F146A86B8C0148AEC99F5A32AF6732@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d8abf3-09f6-474d-061a-08db6cbbde88
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 09:43:55.0926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tqOCfykCL1C6zS+I7ek6hIKoKo3F4S4H8ZppGVut84pI9al/nVD5xfCi/GF6deffrn/wbwSi4mMKD+8YOBvuRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTEzIGF0IDEwOjMxIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMDYsIDIwMjMgYXQgMTE6NTc6MzVQTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gU3VuLCAyMDIzLTA1
LTI4IGF0IDIxOjIwIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5jb20gd3JvdGU6DQo+ID4g
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiA+ID4g
DQo+ID4gPiBBZGQgYSBob29rIHRvIHNldHRpbmcgQ1BVSUQgZm9yIGFkZGl0aW9uYWwgY29uc2lz
dGVuY3kgY2hlY2sgb2YNCj4gPiA+IEtWTV9TRVRfQ1BVSUQyLg0KPiA+ID4gDQo+ID4gPiBCZWNh
dXNlIGludGVsIFREWCBvciBBTUQgU05QIGhhcyByZXN0cmljdGlvbiBvbiB0aGUgdmFsdWUgb2Yg
Y3B1aWQuICBTb21lDQo+ID4gPiB2YWx1ZSBjYW4ndCBiZSBjaGFuZ2VkIGFmdGVyIGJvb3QuICBT
b21lIGNhbiBiZSBvbmx5IHNldCBhdCB0aGUgVk0NCj4gPiA+IGNyZWF0aW9uIHRpbWUgYW5kIGNh
bid0IGJlIGNoYW5nZWQgbGF0ZXIuICBDaGVjayBpZiB0aGUgbmV3IHZhbHVlcyBhcmUNCj4gPiA+
IGNvbnNpc3RlbnQgd2l0aCB0aGUgb2xkIHZhbHVlcy4NCj4gPiANCj4gPiBZb3UgbWlnaHQgd2Fu
dCB0byB1c2Ugc29tZSBncmFtbWFyIHRvb2wgdG8gY2hlY2sgYWdhaW5zdCB0aGUgY2hhbmdlbG9n
Lg0KPiA+IA0KPiA+IEFsc28sIHBlcnNvbmFsbHkgSSB0aGluayBpdCdzIGJldHRlciB0byBicmll
Zmx5IG1lbnRpb24gd2h5IHdlIGNob29zZSB0aGlzDQo+ID4gZGVzaWduIGJ1dCBub3QgYW5vdGhl
ciAoZS5nLiwgd2h5IHdlIGp1c3QgZG9uJ3QgbWFrZSBLVk0gcmVtZW1iZXIgYWxsIENQVUlEcyBp
bg0KPiA+IFRESC5NTkcuSU5JVCBhbmQgc2ltcGx5IGlnbm9yZXMvcmVqZWN0cyBmdXJ0aGVyIEtW
TV9TRVRfQ1BVSUQyKS4gIEl0IHdvdWxkIGJlDQo+ID4gaGVscGZ1bCBmb3IgdGhlIHJldmlld2Vy
LCBvciBzb21lIGdpdCBibGFtZXIgaW4gdGhlIGZ1dHVyZS4NCj4gPiANCj4gDQo+ID4gQW5kIHdo
eSB0aGlzIHBhdGNoIGlzIHBsYWNlZCBhdCB0aGUgdmVyeSBib3R0b20gb2YgdGhpcyBzZXJpZXM/
IFRoaXMgbG9naWMNCj4gPiBzaG91bGQgYmVsb25nIHRvIFREIGNyZWF0aW9uIHBhcnQgd2hpY2gg
c2hvdWxkIGJlIGF0IGEgcmVsYXRpdmUgZWFybGllciBwb3NpdGlvbg0KPiA+IGluIHRoaXMgc2Vy
aWVzLg0KPiANCj4gQmVjYXVzZSB0aGlzIGlzIG5pY2UtdG8taGF2ZSwgbm90IG5lY2Vzc2FyeSBm
b3IgdGhpcyBwYXRjaCBzZXJpZXMgdG8gd29yay4gIA0KDQpJcyBpdD8gIEkgdGhvdWdodCBTZWFu
IHN1Z2dlc3RlZCB3ZSBzaG91bGQgdG8gdGhpcy4NCg0KSSB0aGluayB5b3Ugc2hvdWxkIGp1c3Qg
aW5jbHVkZSBpdCB0byB0aGlzIHNlcmllcyBhbmQgcGxhY2UgaXQgaW4gYSBwcm9wZXINCnBvc2l0
aW9uIChvciBldmVuIG1lcmdlIGl0IHRvIHNvbWUgb3RoZXIgcGF0Y2gpLg0K
