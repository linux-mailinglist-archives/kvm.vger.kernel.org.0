Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC09C6F0689
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243373AbjD0NXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 09:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjD0NXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 09:23:13 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776644491
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 06:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682601792; x=1714137792;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gJ+IVCmTB33sDj0xw4BsxbcQAW28OeG9ihfWaS5GE3w=;
  b=U6Mr9WKMHHMOy1iFlDDIif5EUHkj5h8y/NnGoN62qHMHuLSf8uMkz5Di
   1nNtLQmvrclgSmZAfsagh4zPgjOugui9k1bf0zfQQ4IxbB/YHVvluefnV
   l80G+8DMK8pbbF9ymH8yBn+y7JGy5UMMzQ700GTm5r1burndwBJ89seeZ
   9JaYWFcNqcRUs4/BxTS3wUe7QM8e+gdnE07Ts7zOu8x0tzTGlmmh2uhK2
   j6ZWhh9c8p1PBf85r7skQosScluvQYalt6FhDTHHWBWCawUEQSd7P4B2X
   IMpmsBlbxxyUtoVYdZVVx3cQzKaOLXkGIuziIk9sHAFOi+0lVkQcjyCQL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="344885190"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="344885190"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 06:23:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="763805199"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="763805199"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 27 Apr 2023 06:23:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 06:23:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 06:23:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 06:23:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hj7mym4ehI3D/us6tEWweO4uj3YVH5CNfNhyS4eZJGlC13BRge0I/QKzICWgxywKKPlW03Hf852CT9sLQ2U22zka+yiXKc6FE7yFnAmo9r/ZUDLvAbT90zKePj3kQXf7dyV2Eq9+F2ipYMt36PtmDOHhIznNv8winhS8wJghLpZEY9l8kqy0mCkxpDC9GRNrSBCEEiT0oFyVLK169cHmo/7ri9Q+HQvQ6xSbwzNz5zFx80bNVsOoTg1uqhIv1o6LfgAOGsVMG2sSYm4QuBSFWtrg0BifYJmZzseXG87F63wGu6bhwfBf9PvPktT0GoplIOmbh4lJR3Vo3EGzkbQKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJ+IVCmTB33sDj0xw4BsxbcQAW28OeG9ihfWaS5GE3w=;
 b=E5X4GDHSmYiRGK1ACupp1jvQOZ6RKV7+HE+dHygtEyaBxZHf5/o1wqsiPLTx7NVeoUqDaVScf+tRCvub65YOxb44YkrIKrBJvunFzgj/hbNMykqQFW6LWsw2Y717JselumpHJDuV+suU8BQX5YypCk4ppEf1A/N1curPTLA+fm8GcdVS+OZ3JXnmB3kvpvo77DZ5WNrrrBo74g4kw5N8K/cIUxwM0CDejJ1xjT/pyJuucZHYU858lJgDJbf2V4wBFyqAj+1qvOUtJbL6x/8vnyhJTbUYJCPYqPWxjWQvgE8mAX1tSYyz7HqWqBHnJn9zu5ANjToIwuUcfOUIuzo5rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7621.namprd11.prod.outlook.com (2603:10b6:8:143::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 13:23:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 13:23:09 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgIAAJr0AgABKcWCADGbRAIAAVjKAgAEJCwCABfnwAIAAR8SAgABejICAACPmAIABvIiA
Date:   Thu, 27 Apr 2023 13:23:08 +0000
Message-ID: <d4c09b548d543eb89d5cb3e0646980a1a0bbcdff.camel@intel.com>
References: <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
         <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
         <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
         <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
         <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
         <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
         <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
         <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
         <14e019dff4537cfcffe522750a10778b4e0f1690.camel@intel.com>
         <ZEiU5Rln4uztr1bz@chao-email>
         <b7d4d662d82ad1503d971a8716ff11edbfd33b14.camel@intel.com>
         <3efd2b9b-bfea-1c33-d78d-30078f0c967c@linux.intel.com>
In-Reply-To: <3efd2b9b-bfea-1c33-d78d-30078f0c967c@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7621:EE_
x-ms-office365-filtering-correlation-id: fb8c4bfe-439a-43a8-8d44-08db47228b0e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MXNEXDsD0c8UBc6C7MuJQe/1qSiCtU5fUnnw9lYGQcrpmTRzaiawLuqZMUFy4tzFfc/b5TpLOiNBLq6CWYyvyUocESjsZLwQqF3IubWDszC2rrYuZSGP8CJ0rm6/LBsi5EqWsFKKPC8GWRlFaByB3QoG3vVRQ71y/Qizpk39o0vQaVe3HiUIhJgC0TTMdRPp/rlqECBWsnCcQg24CXlpcUpxygO5PKWTSDAqqSosK4L8vViFdqHh2nonxnP8Tcs9KPFhPfbipNscSH3WINoXzvYAv9aWQp2f8gyGNWop2RLOIGXxxUf8vxAzDidQWIDyq18FbKLfWmVK5sUEsnsuRR3n4ptSummGYSRkMQMXXR5Oqm2xMOYG+kz8/tSrqG1EOONLYcwdiQ5OlnlXzsYcfqa9JtmNHyypxMA4IWP4008a/x5el8o5VbvxnvAxrrN8UfPoopIbno5BF1KJdK6DngTkc1hPkls00D3toQcZ8yhI2FOrdzanND5M8Yipbw2nR/Gy3NLnMeofXIWPSrBNDZBQNPKB99G8j/BWMKTw4jc68mpW+ng6e/xs7gsIFRfO7rH1+SGgbiSgv67MBbdM18ROypP5USHU4K67FhDaCmZCjy2+905NGyOEfejoiO0I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(8676002)(8936002)(66446008)(5660300002)(66476007)(64756008)(41300700001)(316002)(2906002)(4326008)(6636002)(66556008)(91956017)(76116006)(66946007)(110136005)(54906003)(478600001)(6486002)(71200400001)(26005)(186003)(6512007)(53546011)(6506007)(83380400001)(2616005)(38070700005)(38100700002)(86362001)(122000001)(36756003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFJKMnZtTWQ3VjRFVEVkbEI5NG5UWEJKVTFBMENDcjMwem10TnNSRXlpWldH?=
 =?utf-8?B?SXRBVXo5c3FyOG9hUzdkd1FJejNhWndjZnFpWWVZZDdjV1YyOXBGNFBSVTNC?=
 =?utf-8?B?MlNwSVdIZy9xZzhBY2VsU1RTRTN5d0lQOHd4cFgwbzRJc1JJeVROVXc2YXpQ?=
 =?utf-8?B?RWN1UHhkaU1HcGVaS2xQYzJnODVpc1FPUkhYRmE0VEVTMUpUTzFzTGpDZkts?=
 =?utf-8?B?YUYzWk5pZm4zd1FYU1d3WU95YzlPYmR6b1JwT0IvQlJERVVjL3FRS2xoVDJs?=
 =?utf-8?B?OUFoc3lZVjd1VGdDRnVUSlpTdFBqU2pMYjBXMDloMFBjKzBDTXY1a09mNEJq?=
 =?utf-8?B?aWNmdlNud3lFazZwZk9IWitBeXVWekowdy90dS9aZURBeFFwazdCRlZ1aVVE?=
 =?utf-8?B?UElQOG9OS1JBUitxbXdHRGN2MzhLZGJNV1ZRRkdhV24vVllXK1ZhaXByZDNR?=
 =?utf-8?B?aml1UGtDei9zdFRRWG5NMnVGbVZPT3NVelpMTy9QR1lpRjB6K1diUFJBRVpI?=
 =?utf-8?B?cFpFNUNwM3QzdnFKN0FZa3ZWdEUxdzF3UFZkNU5EMGhONU5sbytyWnBrLzJl?=
 =?utf-8?B?R1RGbDNKNzlVaUp1R0ZyQjcrVCtlT3BVdGcrL2phd0xiZGJ5WmhjSFBDVFI1?=
 =?utf-8?B?SlN1TDVmTUVHODc5YnhYWUpCQ1Y4T2xBTFJOVGVPUnl6U1lBRE1QWElPbFNh?=
 =?utf-8?B?bmRCcDNXVU9DQ3VoY1hES0pZbGFOclBaeVZSR3VFQVhFQm92SEk0RG1PQ0xF?=
 =?utf-8?B?R0tXcUxNcFQrcDB3REhXS1o4aExZZ0dORDV2QW83dGN1dFQxMEV2SDcyT2FC?=
 =?utf-8?B?MGQvZVhYVzA1RnZPaW04bWl1aXQzanVUbUl3dS9vWG1MMDNraW05aVh5d2Fq?=
 =?utf-8?B?RzVsdTB0NGMvSm83TlhQOSthbFZjejdkWUFwbDc0Ny9hZS8vVXJleko1WlUw?=
 =?utf-8?B?bktzMExVc1pXN2xxNm8zQkRtY21MOEpwa2haeFBtcjRaVVRzSFV4bFRtWFZ0?=
 =?utf-8?B?V1BNWVc3dHpOcEprTkZHa1NRN1h1a1hOQlBWQUsvalhKVGFWdWpZa0pLZUF2?=
 =?utf-8?B?L1pBbUNueWxCemZMWlh3N1lldlFYa2dGQUx0SDdjWHZPVkVDM3NiL21KblNU?=
 =?utf-8?B?M2xOWS9QbE9OR3FudVR0SmM0MWN6aWZrR2dBVk5hbjZ1NzkvYXllY1o4RHNM?=
 =?utf-8?B?WXBwZGUzNUJHOEc0NG4vWjlGalRkNzlFQ1p5VUVQNkliYkJIcmFsRW9lSU1x?=
 =?utf-8?B?eDdsOUlRNmtFMW1Ydm56aGtTelJwR0hiTFNDbGhkczROcWFWUXBGMFI1T2dJ?=
 =?utf-8?B?UGNnVXZHeUtMU1RrbzRwd3VRS2EwUXpFcUNnZk1SYzJoeFhPZjY0RXJzRm85?=
 =?utf-8?B?SkowUzN3YkROWmphUzgxaDZhcUlTcW1KZW1McGdiTlNOSlAzLzNUYTRXeGdl?=
 =?utf-8?B?SmhjWmxYZlZKWVltZTIvWmZKWjA5YnRlS1ZwdjFiVnB4T1YyNW5OeFhZZGcr?=
 =?utf-8?B?WW5aWUFtaEpCSmx1VHVxZFZxSm1kYTNhZTIzNWp6b3FvY1hucVNUcmFMSmdp?=
 =?utf-8?B?dHlwRUx2dDU4LzV3VmVKM25GOXhLbi9kMWcwK2xkQk1XZktMUS80dy8xOW5j?=
 =?utf-8?B?NVJsSlNFNjloMldhSjZncFJETE9VQUE1THdrdzUxQ0dkRkp3NlcxM0dWYkhw?=
 =?utf-8?B?ZWFTZVlYOW52VGM3ZUt0Nmo5VFBQbEVRMmJzdUNGa0hwd2g5Y001RTN3YWZX?=
 =?utf-8?B?eG1ITWlYUWFWcGVBUzJIdmpTUHF6aGo5cFZTZUMra2oxUlp5ekcxTEljZjFT?=
 =?utf-8?B?cXZWdUtXUzRjVm9jQkhRRmEyRThKNEUrN04rRkFXZnFhMCtralRvSjY4R2Yy?=
 =?utf-8?B?ZVhwUENOb0NON093SlRFY2k3cDNsUndoM3YwemZGL2JqaWJzMDFZWUpqaXRj?=
 =?utf-8?B?OUtDd1NCUDZaRHpycWpXUlJ6UXpWbUt2YU5yMEd5dVNudFJqRWMyN003K2V0?=
 =?utf-8?B?VkJ4Tlg4LzVmSDdvbEFBaXNOREVaMURtbXB2VXJaUFlLQ1Z2ZldWUEYvYWl0?=
 =?utf-8?B?ZzdVMkNvVEUvN2ppcjRFVFdGQ013emhyWnpxdVM3RlB0SU5qcnZIMStjRyta?=
 =?utf-8?Q?Ou8/laILh4Mcdoma1+AyhobtF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DDD1629FEC74647825860BDFFFEE21A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb8c4bfe-439a-43a8-8d44-08db47228b0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 13:23:09.0075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xMeodihhw99ApafIQSNA5vWYrOQBwSnU4b9oIRnxRwQnUEN8ca8SHassL7CCgtcj0YbEeXiPPAWCesuarXQZTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7621
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTI2IGF0IDE4OjUyICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiA0LzI2LzIwMjMgNDo0MyBQTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBXZWQsIDIw
MjMtMDQtMjYgYXQgMTE6MDUgKzA4MDAsIEdhbywgQ2hhbyB3cm90ZToNCj4gPiA+IE9uIFdlZCwg
QXByIDI2LCAyMDIzIGF0IDA2OjQ4OjIxQU0gKzA4MDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4g
PiA+IC4uLiB3aGVuIEVQVCBpcyBvbiwgYXMgeW91IG1lbnRpb25lZCBndWVzdCBjYW4gdXBkYXRl
IENSMyB3L28gY2F1c2luZyBWTUVYSVQgdG8NCj4gPiA+ID4gS1ZNLg0KPiA+ID4gPiANCj4gPiA+
ID4gSXMgdGhlcmUgYW55IGdsb2JhbCBlbmFibGluZyBiaXQgaW4gYW55IG9mIENSIHRvIHR1cm4g
b24vb2ZmIExBTSBnbG9iYWxseT8gIEl0DQo+ID4gPiA+IHNlZW1zIHRoZXJlIGlzbid0IGJlY2F1
c2UgQUZBSUNUIHRoZSBiaXRzIGluIENSNCBhcmUgdXNlZCB0byBjb250cm9sIHN1cGVyIG1vZGUN
Cj4gPiA+ID4gbGluZWFyIGFkZHJlc3MgYnV0IG5vdCBMQU0gaW4gZ2xvYmFsPw0KPiA+ID4gUmln
aHQuDQo+ID4gPiANCj4gPiA+ID4gU28gaWYgaXQgaXMgdHJ1ZSwgdGhlbiBpdCBhcHBlYXJzIGhh
cmR3YXJlIGRlcGVuZHMgb24gQ1BVSUQgcHVyZWx5IHRvIGRlY2lkZQ0KPiA+ID4gPiB3aGV0aGVy
IHRvIHBlcmZvcm0gTEFNIG9yIG5vdC4NCj4gPiA+ID4gDQo+ID4gPiA+IFdoaWNoIG1lYW5zLCBJ
SVJDLCB3aGVuIEVQVCBpcyBvbiwgaWYgd2UgZG9uJ3QgZXhwb3NlIExBTSB0byB0aGUgZ3Vlc3Qg
b24gdGhlDQo+ID4gPiA+IGhhcmR3YXJlIHRoYXQgc3VwcG9ydHMgTEFNLCBJIHRoaW5rIGd1ZXN0
IGNhbiBzdGlsbCBlbmFibGUgTEFNIGluIENSMyB3L28NCj4gPiA+ID4gY2F1c2luZyBhbnkgdHJv
dWJsZSAoYmVjYXVzZSB0aGUgaGFyZHdhcmUgYWN0dWFsbHkgc3VwcG9ydHMgdGhpcyBmZWF0dXJl
KT8NCj4gPiA+IFllcy4gQnV0IEkgdGhpbmsgaXQgaXMgYSBub24taXNzdWUgLi4uDQo+ID4gPiAN
Cj4gPiA+ID4gSWYgaXQncyB0cnVlLCBpdCBzZWVtcyB3ZSBzaG91bGQgdHJhcCBDUjMgKGF0IGxl
YXN0IGxvYWRpbmcpIHdoZW4gaGFyZHdhcmUNCj4gPiA+ID4gc3VwcG9ydHMgTEFNIGJ1dCBpdCdz
IG5vdCBleHBvc2VkIHRvIHRoZSBndWVzdCwgc28gdGhhdCBLVk0gY2FuIGNvcnJlY3RseSByZWpl
Y3QNCj4gPiA+ID4gYW55IExBTSBjb250cm9sIGJpdHMgd2hlbiBndWVzdCBpbGxlZ2FsbHkgZG9l
cyBzbz8NCj4gPiA+ID4gDQo+ID4gPiBPdGhlciBmZWF0dXJlcyB3aGljaCBuZWVkIG5vIGV4cGxp
Y2l0IGVuYWJsZW1lbnQgKGxpa2UgQVZYIGFuZCBvdGhlcg0KPiA+ID4gbmV3IGluc3RydWN0aW9u
cykgaGF2ZSB0aGUgc2FtZSBwcm9ibGVtLg0KPiA+IE9LLg0KPiA+IA0KPiA+ID4gVGhlIGltcGFj
dCBpcyBzb21lIGd1ZXN0cyBjYW4gdXNlIGZlYXR1cmVzIHdoaWNoIHRoZXkgYXJlIG5vdCBzdXBw
b3NlZA0KPiA+ID4gdG8gdXNlLiBUaGVuIHRoZXkgbWlnaHQgYmUgYnJva2VuIGFmdGVyIG1pZ3Jh
dGlvbiBvciBrdm0ncyBpbnN0cnVjdGlvbg0KPiA+ID4gZW11bGF0aW9uLiBCdXQgdGhleSBwdXQg
dGhlbXNlbHZlcyBhdCBzdGFrZSwgS1ZNIHNob3VsZG4ndCBiZSBibGFtZWQuDQo+ID4gPiANCj4g
PiA+IFRoZSBkb3duc2lkZSBvZiBpbnRlcmNlcHRpbmcgQ1IzIGlzIHRoZSBwZXJmb3JtYW5jZSBp
bXBhY3Qgb24gZXhpc3RpbmcNCj4gPiA+IFZNcyAoYWxsIHdpdGggb2xkIENQVSBtb2RlbHMgYW5k
IHRodXMgYWxsIGhhdmUgbm8gTEFNKS4gSWYgdGhleSBhcmUNCj4gPiA+IG1pZ3JhdGVkIHRvIExB
TS1jYXBhYmxlIHBhcnRzIGluIHRoZSBmdXR1cmUsIHRoZXkgd2lsbCBzdWZmZXINCj4gPiA+IHBl
cmZvcm1hbmNlIGRyb3AgZXZlbiB0aG91Z2ggdGhleSBhcmUgZ29vZCB0ZW5lbnRzIChpLmUuLCB3
b24ndCB0cnkgdG8NCj4gPiA+IHVzZSBMQU0pLg0KPiA+ID4gDQo+ID4gPiBJTU8sIHRoZSB2YWx1
ZSBvZiBwcmV2ZW50aW5nIHNvbWUgZ3Vlc3RzIGZyb20gc2V0dGluZyBMQU1fVTQ4L1U1NyBpbiBD
UjMNCj4gPiA+IHdoZW4gRVBUPW9uIGNhbm5vdCBvdXR3ZWlnaCB0aGUgcGVyZm9ybWFuY2UgaW1w
YWN0LiBTbywgSSB2b3RlIHRvDQo+ID4gPiBkb2N1bWVudCBpbiBjaGFuZ2Vsb2cgb3IgY29tbWVu
dHMgdGhhdDoNCj4gPiA+IEEgZ3Vlc3QgY2FuIGVuYWJsZSBMQU0gZm9yIHVzZXJzcGFjZSBwb2lu
dGVycyB3aGVuIEVQVD1vbiBldmVuIGlmIExBTQ0KPiA+ID4gaXNuJ3QgZXhwb3NlZCB0byBpdC4g
S1ZNIGRvZW5zJ3QgcHJldmVudCB0aGlzIG91dCBvZiBwZXJmb3JtYW5jZQ0KPiA+ID4gY29uc2lk
ZXJhdGlvbg0KPiA+IFllYWggcGVyZm9ybWFuY2UgaW1wYWN0IGlzIHRoZSBjb25jZXJuLiAgSSBh
Z3JlZSB3ZSBjYW4ganVzdCBjYWxsIG91dCB0aGlzIGluDQo+ID4gY2hhbmdlbG9nIGFuZC9vciBj
b21tZW50cy4gIEp1c3Qgd2FudCB0byBtYWtlIHN1cmUgdGhpcyBpcyBtZW50aW9uZWQvZGlzY3Vz
c2VkLg0KPiA+IA0KPiA+IE15IG1haW4gY29uY2VybiBpcywgYXMgKGFueSkgVk1FWElUIHNhdmVz
IGd1ZXN0J3MgQ1IzIHRvIFZNQ1MncyBHVUVTVF9DUjMsIEtWTQ0KPiA+IG1heSBzZWUgR1VFU1Rf
Q1IzIGNvbnRhaW5pbmcgaW52YWxpZCBjb250cm9sIGJpdHMgKGJlY2F1c2UgS1ZNIGJlbGlldmVz
IHRoZQ0KPiA+IGd1ZXN0IGRvZXNuJ3Qgc3VwcG9ydCB0aG9zZSBmZWF0dXJlIGJpdHMpLCBhbmQg
aWYgS1ZNIGNvZGUgY2FyZWxlc3NseSB1c2VzDQo+ID4gV0FSTigpIGFyb3VuZCB0aG9zZSBjb2Rl
LCBhIG1hbGljaW91cyBndWVzdCBtYXkgYmUgYWJsZSB0byBhdHRhY2sgaG9zdCwgd2hpY2gNCj4g
PiBtZWFucyB3ZSBuZWVkIHRvIHBheSBtb3JlIGF0dGVudGlvbiB0byBjb2RlIHJldmlldyBhcm91
bmQgR1VFU1RfQ1IzIGluIHRoZQ0KPiA+IGZ1dHVyZS4NCj4gDQo+IEhvdyBhYm91dCBkbyBndWVz
dCBDUjMgTEFNIGJpdHMgY2hlY2sgYmFzZWQgb24gdGhlIGNhcGFiaWxpdHkgb2YgDQo+IHBoeXNp
Y2FsIHByb2Nlc3NvciBpbnN0ZWFkIG9mIHZDUFU/DQo+IFRoYXQgaXMgS1ZNIGRvZXNuJ3QgcHJl
dmVudCBndWVzdCBmcm9tIHNldHRpbmcgQ1IzIExBTSBiaXRzIGlmIHRoZSANCj4gcHJvY2Vzc29y
IHN1cHBvcnRzIExBTS4NCj4gPiANCj4gDQoNCkRvZXNuJ3Qgc2VlbSB0byBoYXZlIGFueSBiZW5l
Zml0IGFzIHRoaXMgbG9va3MgbGlrZSBhbm90aGVyIGhhY2sgKHdoaWNoIGFsc28NCmJyZWFrcyB0
aGUgcnVsZSBvZiB2aXJ0dWFsaXphdGlvbikgaW4gb3JkZXIgdG8gKHRyeSB0bykgZml4IGEgdmly
dXRhbGl6YXRpb24NCmhvbGUuDQoNCg==
