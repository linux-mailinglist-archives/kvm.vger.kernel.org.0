Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255E2674793
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjASXzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjASXzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:55:33 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9099F3A1;
        Thu, 19 Jan 2023 15:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674172532; x=1705708532;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Co6oI7idwUATml4fuLoFVYvNeae7v8XjfSEinSSarOY=;
  b=ntz6eoKt4fGCEhzaFYjRmYQ5dUUwXlSNlicNp+PPCNre7qgIqwaLmc6Z
   U9lQYjeB50qtK310OE93TsNbVCIbwgDvmKP5mDG4vhNgdbm8mWXP5pcWG
   nV2pdPD5SkXCbUFaTnESj9G1vx6P7xSU+fZEyTEdgrU8NzZBjP6svFeNU
   UIH0RcuP6iy7XgATn4pbVRwwOplGrJxIqbPzlwfFiGL+Y2nSQxYAHhZU8
   wYJ3/V35CnbNp/nmKXtTisGXrkbiqFFzPm97tR0gphG7+eiPSgDPJ6Nag
   gV3S/9J9c+fcoNWPQTBHxcd8yOTkrzEEo3O6LlTnhZPkBa7WYbHnV1tHO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="327558082"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="327558082"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 15:55:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="834201778"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="834201778"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 19 Jan 2023 15:55:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 15:55:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 15:55:17 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 15:55:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVUofzpteW9jcXjnbJezzgMoWgDJ6EMa5xomMDLnakWydGNunTMjpJLNiivDXXWAOVIBnO8oDZCdoCO5lFh4SlFcacSLtcznJjGN1PFlFamONd5LMvtt2sd7vR3fkuQ/zw3Fo1h3Xtl5W5W7cZWxAtSKFWiieQetZUXBIHZB++u5G7D/YiDiXQby1ZGsMbOF9ld2VfXUoSnBhxj4LsM/ul9m3jnH0f1DeWkWHwu+fI36/j0mwGzjGx4bKW24F8pTqswo2Oqwsvn96mA5Sl1ybN3cwyeu/rsHEij3Y6JlXAm1WGp1UPZTlfWjmYVq6/RQWTNUV22am7sjxVdNCN13XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Co6oI7idwUATml4fuLoFVYvNeae7v8XjfSEinSSarOY=;
 b=UVgZG+tLFJiISTgkcHhS7C6dtYBLM9oih50YSCuHq9W0oCQ/vGhtnVFDf16dChx5OnXMawxLvnwzKppmPNONntLVg73sb9+Y9OGk4acBsRHI7L5FjaTTSfsFTTl1oN+qo7NlFbRnn3SGFwPZJTrkIq24BSTLiUetbM1fUKEedL0eHcU7OKLDu1c1RX+GAMaxp1xfohpKMzdknSgDPbem2ZggHvYZXmyS13c+AR8mTAdILOzbI9EJnr3cYvRMt7Cna++W9l63n5lseklYd6U4tuY148IPPiKucvdEhFCC8bwzoAgGvrYX7W9O+ZWKjuQBSvuPp7eGUBtTS9pIvQyk1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4850.namprd11.prod.outlook.com (2603:10b6:303:9c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 23:55:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 23:55:11 +0000
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
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGAgAAP1gCAACa5AA==
Date:   Thu, 19 Jan 2023 23:55:10 +0000
Message-ID: <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
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
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4850:EE_
x-ms-office365-filtering-correlation-id: bd5a8002-60f5-41c5-3024-08dafa7899c1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 41OitaY9qDfbOh+PWdb+prhhqdqhLhuIl8qcKS3N9pvPzsC9ER8oYWsHs+KN1vcQjLj7VjpJ+/wHKPiQlJjXoBaxhgKbW2N9H2HyVp5KlKe4PPyXpYVz7zCrzuw3qrXD+43i1gqIq8G9mB0y4w/2Cp5iO92UZ4xey9K2K3/4oVXUQi9MzUGmX1J6FpSD/Vsve82XCU6BlRXVileg2xqZ9d+FguJ3YjZe335UtaxEZ4xHyY/GrWWBV0t4ZkpqCBnobJ+nVvLCy9lz84Rlj21UJwJyWGW9p9fqsU4MRg84hYa0i5N0MI8RUQx4sCg9KED0LtUX0IfHtEzrG9eQdblQcMeLdGEZXeHzJi3rVPYizZ6jzDQomkWBtH5oUeR4kDfioaVb53SpACoDvWFNJYoWPL7akuDnjKKVt557QFliE8NNfOIvZePKBMbVj2lUzxb9uJcSzkOJMPfCh6SNHH8On/FwNSRFxfFiZABzo6DV0IoaVvLEcCfUakRfzwO0zUig6Wb1Gpl0ix59LLIb6Dh10vHW4pPWNbGUddDYAZSArN0PqD43b4+klG5BlGgEVTMsBZD3IX0DQJO0kSLzfVtur93Axn/HQX2VCysrWzZRpYCwEcTjshVRZPMoZOs1+3J1U+ljw09Q/0IYyOor3RLIC57PEZOlaip/HS2E6Pv5/ucACDmhuvoFSrhQ/E/IBowgDx7d1h0m7MtnEArkIJzbhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199015)(2616005)(41300700001)(36756003)(5660300002)(8936002)(4744005)(316002)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(4326008)(6916009)(76116006)(91956017)(26005)(186003)(6512007)(82960400001)(38100700002)(122000001)(38070700005)(86362001)(2906002)(83380400001)(107886003)(478600001)(6506007)(6486002)(54906003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RitGY0w4VjVUQkMrMm54UXg1MGw3blFsZVlDS25FVS9XM21tOTJHdWp1Zm9h?=
 =?utf-8?B?STBUYjVyK2JVTDFHbXhnYnVCd3ZQOWlvUWlsRkJpcTdsNWhaSzQ0a01GTzRa?=
 =?utf-8?B?VGQzUWZnY21nQWFDcm5waHl2azliUjRncnFvRXhrRHpwdDQyakZTL21sSjhy?=
 =?utf-8?B?N3FjS1N6Y1Nic0NGZFhvNjdiMnNTOVRsLzlmcnFlQjg2WUhlQlpTSG03SkU3?=
 =?utf-8?B?UjJjdkxaYUcrSEx4VktaeitpcGxxZUVNWDlTeDBsdTFySm85TkVGdWdycFdE?=
 =?utf-8?B?aE1qMDgwVDNCd1R6U0MyMmoyUXdkNkVYZnh1ZGxPOXkveCtZWG1hYkRhZjVQ?=
 =?utf-8?B?SGdkcTZWQ0FXc3dOc2NpdHl0N0QxY0E2TGpUSWhhbGQ0UGp3VXhWcHR6Y0Rk?=
 =?utf-8?B?L241UkozVm80cklkRWJlOTZaaTludlhjZ1A4Z1lsNGpaY2hIeTZ0Zi9tTVRq?=
 =?utf-8?B?UHJqalI3RWlmcmVQczlvUTdtbEVBVUI5dzFLeUpHNm1OanFFM0tNajNmVEpm?=
 =?utf-8?B?T3NqaFhkTnVtelREUTJYOEd6THZvSzNrN0JmNDIvSWVEdTZQZWZOVUZCVFZ0?=
 =?utf-8?B?VUtJaU51c3oyNTZDSW1ZN3FkUGVYSHFoOWZNZmJYZ2N2UFJjdllnZUpoc0lR?=
 =?utf-8?B?ZGJ3MEVQc28zYU1OcVp2dHdxOWJ4dVFoVmFGQlc5bEVMallwV0tKaVJvS0FN?=
 =?utf-8?B?YndhWldqaG11UkpSVlREcytaem9WUklIbnpMNXRSclNYTnRSaENoanBhOWRX?=
 =?utf-8?B?aFZLbGdjL1IwOEsydm9zeTFlYTFuMk11ZTN5YnJ3M3BJdGZ1eUIzQ25PNytN?=
 =?utf-8?B?d2hpRUQ1SnVvdzQ1OUUxYzc1bjRYaXpyRE5GbzMzcWY0MnkrOVpuTlcraEo2?=
 =?utf-8?B?RVdkNkJXZWtnamY4ZkZta0FRQ1VVYVUyaFJRNUZSVjlsT216MGU5bTNGbFZF?=
 =?utf-8?B?QUsyejcya2pTZUlTYTk0MkEvSUIzZHFoZjViQjhRTC82d3o0TFVUNlVjV0Mx?=
 =?utf-8?B?ZlJ2ZDhWM2FoN1dWZnFhYTNSOE5jVUdGbnNjZ2lnWThWU1dCWFJ0NVo1Nitu?=
 =?utf-8?B?L2p2Y2NQODBtSHMzSVZGMUt5MXJwZlVURzg0UmIyajg5RTlOc2krUjdKbWY5?=
 =?utf-8?B?L2ZYK0dEa0hiQ3FUcHhPM1FyUDRlNWJRUWFIRjFTbzJsTHdyejVMK2JlN0NV?=
 =?utf-8?B?REJMeWZaOXQ1bTFXS3ZKOWltRlFCMHhRRklYQ3JVc3o1QjdOeEFzcTFoWFhK?=
 =?utf-8?B?ZXV2SmlBd1Y1Z2tQWllEYXlPOWVWU2ZEZFErR2hDNE9OVWo5N3ludENrcERR?=
 =?utf-8?B?emY3KzZxSWRuY0Q5OFBqQXZRdUNQRjJBVkpOME5xUk9mNGNhK2VwaGFFS2hX?=
 =?utf-8?B?WHBBTnZzY2Z6cVFpTmd0WUcvTFBNQ216Nmx3dkpZVGJGbkI3UStzYlY1eG9G?=
 =?utf-8?B?M25CTFpCdGNJNmhpaUVEaTh4c1QwcTZkWm1aNENmWHV1N3ZXUFNBS0hZRzRL?=
 =?utf-8?B?elpRcVpmQk9vcXF3R2FYVU12TmhncmYvOG5JbUJ2VU5zdHlMaFgwY0VibnlH?=
 =?utf-8?B?S2xqUFNROFBIMFlHUCtsWVJXbXB1RUh6NUhrWlpmTFl5VVkrOWxhZitJa09Q?=
 =?utf-8?B?cWNRaWw3T0VhSkhTMnp0R3lpSElvVFpxajhHOWRrMzdCcXFFdUkva1VRaVJw?=
 =?utf-8?B?NVpacDlJWTdvMHpTRDlNdklTVWJQVlhkZ0xFMTZZYUN3MHFEU052ZU5FUUJC?=
 =?utf-8?B?ZTF3bWtnbFJEb1dCUkRuL0poYnRPUFl3aW94WEVpaWhGOGU1TlhpRmFSNUNT?=
 =?utf-8?B?QWNXWXhScGxnRzBEQW5vTk9jbXoycnk2dkFSMWlnOU1hYWVwd0hmS29lcDI4?=
 =?utf-8?B?WFVlK2wyZ2hBbEF1SmtHTlZQaU9QdUNrY05kckhLMjhvYnFPWXRQL3Bpemps?=
 =?utf-8?B?MWl2Y2NiM2VUTnYvTlk2bWlIZ25HeFRvV1R6YUIreXI1czZXRnhQemVlVmh1?=
 =?utf-8?B?czBvT29vU1JEb2JSZjVpb1FxNFJSdUcrNkVzOG1LdEF4M2JyKzVNUDNpM1pp?=
 =?utf-8?B?N1hQRlNKeEM3Z1MrTEQzUnRmZzhyQ21Fc1VDOHNaTXFkcENMeno2OEwxZDA2?=
 =?utf-8?B?L0x6ZDlvZXJteFhkWWRwRVJRT1NPYUZodERQOGdkcnF3RnRJYzdaa0psdjBs?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B44307C5EA01845B3C083FE69FE0007@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd5a8002-60f5-41c5-3024-08dafa7899c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 23:55:10.8784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQuv73nIuntRGUlzEAZuxGkvT9VqL0Dz8LiNtmh8OpmOd+JO5nUIJklZwVz9pqqoFmKvoVZJolrd9GquHveE3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4850
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
b3RlOg0KPiBUaGUgbGVhc3QgaW52YXNpdmUgaWRlYSBJIGhhdmUgaXMgZXhwYW5kIHRoZSBURFAg
TU1VJ3MgY29uY2VwdCBvZiAiZnJvemVuIiBTUFRFcw0KPiBhbmQgZnJlZXplIChhLmsuYS4gbG9j
aykgdGhlIFNQVEUgKEtWTSdzIG1pcnJvcikgdW50aWwgdGhlIGNvcnJlc3BvbmRpbmcgUy1FUFQN
Cj4gdXBkYXRlIGNvbXBsZXRlcy4NCg0KVGhpcyB3aWxsIGludHJvZHVjZSBhbm90aGVyICJoYXZp
bmctdG8td2FpdCB3aGlsZSBTUFRFIGlzIGZyb3plbiIgcHJvYmxlbSBJDQp0aGluaywgd2hpY2gg
SUlVQyBtZWFucyAob25lIHdheSBpcykgeW91IGhhdmUgdG8gZG8gc29tZSBsb29wIGFuZCByZXRy
eSwgcGVyaGFwcw0Kc2ltaWxhciB0byB5aWVsZF9zYWZlLg0KDQo+IA0KPiBUaGUgb3RoZXIgaWRl
YSBpcyB0byBzY3JhcCB0aGUgbWlycm9yIGNvbmNlcHQgZW50aXJlbHksIHRob3VnaCBJIGdvdHRh
IGltYWdpbmUNCj4gdGhhdCB3b3VsZCBwcm92aWRlIHByZXR0eSBhd2Z1bCBwZXJmb3JtYW5jZS4N
Cg0KUmlnaHQuICBJIGRvbid0IHRoaW5rIHRoaXMgaXMgYSBnb29kIG9wdGlvbi4NCg==
