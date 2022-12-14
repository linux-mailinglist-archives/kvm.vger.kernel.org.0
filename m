Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF0964C7CE
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 12:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbiLNLWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 06:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbiLNLWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 06:22:31 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEEEF62;
        Wed, 14 Dec 2022 03:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671016948; x=1702552948;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dJqFQ6td5Kxg/ZvDd/FtgjrtetOTXVoBfAnCxh+GcaA=;
  b=Ubf25EUrhp3GD7f9jQqyGPobfkaxVt/Uq5XyfP3mb/HLKGv50gLF9oeY
   dEgCIyPLP3Kyujy7+ffX12v5yRUegnFm5bo7Nnc10POSmTfoQXj9l7X0W
   RaO0/sRtAA1fwYStzZCilFCDmVVmpvGxc3ZdOzML59+ocf19FQZLvAstM
   nQopjoQpJEypVplL8tIDV3SCraxMwYKC5S1WRCGj4QsJTEtqPY3OJqTeN
   Ukr6uF+NB6nloLnYZjhs6UiPVO9uEwxcsgzPBr4ILr97q5LBUM4J596An
   TC5tnoR/PK+5yURiW+JBbnnDuix51fEzqsM5pHgvNP2451XGtDwungBXZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="317079079"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="317079079"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 03:22:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="755848527"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="755848527"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 14 Dec 2022 03:22:10 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 03:22:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 03:22:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 03:22:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTmQux7uGU46vYIyP3wQQrsddscoUNtMC9PcMMk/NVMFHkI+16ogD5ZElDNKnxRp9w7clLe5Ao3Zpa+q2pjp5twaPlR23PYUJWCH42wV4HOWMVPis+peFbJToB4xichwlBsCk15/mzX25oV6VX2QBo5+EMXmVbIt0huOVDvRgLs14/jDg/C95ErE49rdZUSUs5+/kMhhzhZueeTCwgK/fKQhWMK/zOLLiBwpcwJeDfrZCilVVihLUQpv0FDCCxz3fylYy1IaQPWtlYkQRdXMSg2Nq7Oj6xgFhYWqv2AXM1ZKA53goTAQhzTP3FNGEuz7uJU8+sVbHhiJGfiQNkv7QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJqFQ6td5Kxg/ZvDd/FtgjrtetOTXVoBfAnCxh+GcaA=;
 b=P1ViFs41kRLBHzpXIW9XC96VdscZ55IeqZorn0Deq8flscGGXKvabNYsk/e9+GWctBiov3UzDzLcath3axooygxCpPzLRw4QWM8Gy4+6qHQYyRySa8k6x3jlBwMaSELAGTQGA5JA6Fz50fUyGtHkmAosRUmDdGXXfCBxAydBSKYUOSq+OY0fPhix8b+T33ODBnh0R/+QMoS7cH/TZHiNrB25Ak3Ri4867LsCWq/UYkV2gzDRZJYwMGQUv0itbd4e4XdOAIL3MrSWZcgq4vB8lfPymZb408bg6RmgxIOuk+QelE2SUpv8RhZU0M3QC7shm9uEEf1Jcz1mNFbxMTQtaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5351.namprd11.prod.outlook.com (2603:10b6:208:318::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 11:22:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 11:22:03 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 098/108] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Thread-Topic: [PATCH v10 098/108] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Thread-Index: AQHY7CmPXXj+CXsOk0a+H1I2lRHISK5thD0A
Date:   Wed, 14 Dec 2022 11:22:02 +0000
Message-ID: <d163d23d64447bc576c9931f4d5e4da0cb87a081.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <1cacbda18e3c7dcccd92a7390b0ca7f4ba073f85.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <1cacbda18e3c7dcccd92a7390b0ca7f4ba073f85.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5351:EE_
x-ms-office365-filtering-correlation-id: 8d1abd54-1d01-44fe-a838-08daddc56cbc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Cz9N4Mcx3CYuwR+R6KRVCwar5Mh370l0se2bnf9IqSvRhMIWXitZuHbfPGCCISlQya2PD4/CHFBEU59mwZDkPKfDSSh6CphbT3ANolPu++Nge8VrF71vhg6nQJwTI6rTGi+9id+eGBxGKnS+GT/V9ZgzLMwV7TYfPS30jFgiz1eW/k7C8UT/rgwV5ukXINeIx0mV2S8OID1Ov32FWQRvvhJVHeLYMPxT2yIfS/r6Pw1o2B8tGG5C/ObdkaMfNOEi9PVmoFNoN7I0HjY4Xf6rXI1h/Epo1a6HPfMuSA+/soWKoKqqAajiNm/LDFdcjDiMSn+ZLW4qG2Rna9COVWTTt/cQ8/jcKN/Yrru6hIfCl2J/rP0e5RyklhBOyOo/u/CWEgHwv0VFS3zkfsmXbCgxD9aSrJ0aZKQ42aYEZF1b5CjHTSRuqqGO+5fqUnvMUOsCDTa51GZt0Pae/t28HvL1JhXECtrBXKTt6pBKl9qb+79+cHUwfFUNU5AXVukUCDw0FcGpTE9YXUT0cBfk7Qy0V8ea8Ql4+MBD7W2Cb+aCkF4DK97+vjt+RIxDQ+KxsGoccX10n6HCYuSjm5R4yB3zaLUuLKxRzJQDwaE8UPzrksvjt+70Y3bW3IBB3GEvWfJI5luFfSA4NmzhJk3Ih/Wg6b0zhZe9/a8eIZG9yf9tBsVL3YMaqFMSO5pFSH2INqXUC4IjtMl1NRHfccD7nSkOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199015)(6506007)(6486002)(110136005)(6636002)(478600001)(54906003)(8936002)(4326008)(91956017)(2906002)(76116006)(66476007)(8676002)(66946007)(2616005)(4001150100001)(41300700001)(66556008)(186003)(64756008)(83380400001)(66446008)(5660300002)(71200400001)(36756003)(38100700002)(316002)(122000001)(38070700005)(26005)(82960400001)(6512007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVBaM3VZZ2pJc1IzbjV2RXdabWg3SXVXSzF4SGE3aUxXdnQyM2lHcllYYTRh?=
 =?utf-8?B?d3M4Qm9kZTZyVVBYeC9VVFFPVEpYM2VTRnc0d2h2dXZmeWxkMlNEV3Y0ZS8r?=
 =?utf-8?B?VGhqV1BCaXgySzc0WVdYdWwvQUhBTWpwWEI3OWhMUEFvZEZOYWhmRjNSakhE?=
 =?utf-8?B?bE5vVW54RG9PTVhvaWlScS9hL0tHRFpuVDZSbmxjcURoK2JjMlo5VklzVXFC?=
 =?utf-8?B?K3VPbUpBTnlCeFpFc05scTU2NURWL2ROSGRhNDhXdkVrYUpoS3Y1cjlPdEZN?=
 =?utf-8?B?SDhDcXN4M2NNdFlWWHozMjgyci82YnZaaU5qWE40eWgrRStLOUxRTzZSYzBx?=
 =?utf-8?B?RXBpR2xGOGZITlNMQ0xIdlZncWlCeXFiOXBGUzJuQWl0c2dkQkhxOVE1VlJL?=
 =?utf-8?B?alFzeWJDRUpKa2RDNlFwcktxMWVVSS9JdDNGQUswK1BqUjlTdUdDMGxaeVpm?=
 =?utf-8?B?cFJvcFowRkdNeitUNEZmdnpPSGYydmI1ckFVS2owQkhCNm5ua0czNWtIQmY1?=
 =?utf-8?B?WXpWREhpRmZsekNabFBKdGpWV2tvUW04TnBaYkpDajNmK1JUdWwwRkswdHNP?=
 =?utf-8?B?TTFGb2pnSm5JTXpEdERTOWt6TzZPYTVJR2kzTlhvdi9BTjZjemRFLzByeEcw?=
 =?utf-8?B?aWhuUnRsekRtRHlNMFhPc0lnOStDSTZMdjMxQ1grZGxCUFFmdEY2WCtqejJj?=
 =?utf-8?B?SmpQeFRjL0NLUG1CQjZKVWdEU3RqOERPR0tHK1pFbWorN054SGRUQmlraVJD?=
 =?utf-8?B?TG9PVGh6ckVrMm9QNkhhWU8rdFhkeGZnSTBKMEh4NzUzaFFzS3Azb2lTNDJL?=
 =?utf-8?B?UWFVLzd0K1didEZzWXYyNi9CRlI5S0JWeXZZTDJPODNvOEE5eWdUZm14OEFY?=
 =?utf-8?B?L2xkOXpObnBGNStDMjZOakczRDZzV1p6QUtzSjZmU0prbGhkWW1VRkxGTCtl?=
 =?utf-8?B?YWxjV29keUNJYzgvRUtyaktmSjBTUUQvM3ZyaVF1azFFTFdJcmFnNXJZUjMx?=
 =?utf-8?B?cmFFVytXbC8vZ0IzZ2ZwWVkwd0NxWXI0MHNmcnNDVjFlMkQ4TmFnZlVqRDdJ?=
 =?utf-8?B?djBwQ2V1aGF0VnFjRmxqeWpLR2JwZzNKcWZTWFFmSGcxRXNZRGhrZW55THhJ?=
 =?utf-8?B?WUQ4TGh4dWdhczVoL2tvRnY0QlVlb2RFYmRUUnBheDhHV1prNm00WUhhOEd6?=
 =?utf-8?B?eDRVbFNqZ0xqTFBjZGhqT0Z6M1V0Nmx3L212cHdUYlJ6U1M0TWhaSTBCcTRj?=
 =?utf-8?B?cnVQZUVvbVIwcDQ2QzJnbElzcjE5dmNuSUVBV1d5MHNncEJwMTFsY29XbjJW?=
 =?utf-8?B?Y2lMbE5MS3B5Yy9uQ29scWE1OFNuOGZVK3dOa1NBbDB5SWpmSS9LYjVZZm9S?=
 =?utf-8?B?K2VkMWdEa3BJS1ZlYm9ZUm81SzRsZEtxV3g5dVBaVHVpcVB2alZCbUJ1Wll2?=
 =?utf-8?B?cUgwWGVkeVgwRWpJMndwNFVVamNaR21Ma0QrdC9YZHhKSEhxN0QzWDVhTUNy?=
 =?utf-8?B?eVFJN2RUWVFsTkZ4bWtFWSthZTJZTVNjeDYzU2IrQnQ1N1FrSE5pZU0yQXBD?=
 =?utf-8?B?bEpqWlA0YTJ6dFg2cFNndzhYYzFYVW5MYWJCTHNQbENocjlFZkZlQ3VsZlEr?=
 =?utf-8?B?dlV6ejF3ZjZMZFdROWxjbnMzRDdhVWpNODBGSk83WXZhMkErYUp2K2k0c3p4?=
 =?utf-8?B?d0Ntd3BOT3pURVFtRC9kVzEwa1JzUW5KOHdCZ2ZqRktuVU8vWnRzSGREMEVK?=
 =?utf-8?B?UTZsa2Y1SFlsTmFyV1FnN3dkZ2ZVMmo0NEpqc25nSCthbGw1dXpDSjEyZG9t?=
 =?utf-8?B?YWFmUzhaa3J0Y0FCelFFeGpjb0tDWFhITHp3NkxWZ3VzbjBIYTUvTHF2Nzda?=
 =?utf-8?B?OTJPcWNPNlE4QVFmMEdEQ0dFaXRITjgycE5Ua1MzcktUaTE4NExwbTdGRHAx?=
 =?utf-8?B?S054UHU0QUdYdGdxaHMyTUdWM1lqWEE0NzNiZzNEOVMwNXVBM2ZQb0dycDB6?=
 =?utf-8?B?SzZtK0RzNDVFSktkRnA1THhIbXFBdTZob0s2bVFCMW5Jd2R5Wm5lRndzc25G?=
 =?utf-8?B?Z2F1RnBKSzBYaUNuRjJ3WEMzYXFENEVqZFZrVWg0YmJ5Rng5cExjclVaelJ0?=
 =?utf-8?B?VFZZa0hkSjNuUDVNa0JGTStNQ2ZOdWhkWUFvV2IyYmptbnlwVWUxNFprMy9w?=
 =?utf-8?B?OFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C093A1C73CF891458758F9605FB35456@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1abd54-1d01-44fe-a838-08daddc56cbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 11:22:02.8633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ygIZQmyN8AUSV6l9a1n8N8VhQCeWNQUqKRrSEVgxQOVSiR3I2cOHOodATE38NrQLWWr36rcaWvX799PlIN/Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5351
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIzIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICtib29sIHRkeF9pc19lbXVsYXRlZF9tc3IodTMyIGluZGV4LCBib29sIHdy
aXRlKQ0KPiArew0KPiArCXN3aXRjaCAoaW5kZXgpIHsNCj4gKwljYXNlIE1TUl9JQTMyX1VDT0RF
X1JFVjoNCj4gKwljYXNlIE1TUl9JQTMyX0FSQ0hfQ0FQQUJJTElUSUVTOg0KPiArCWNhc2UgTVNS
X0lBMzJfUE9XRVJfQ1RMOg0KPiArCWNhc2UgTVNSX01UUlJjYXA6DQo+ICsJY2FzZSAweDIwMCAu
Li4gMHgyNmY6DQo+ICsJCS8qIElBMzJfTVRSUl9QSFlTe0JBU0UsIE1BU0t9LCBJQTMyX01UUlJf
RklYKl8qICovDQo+ICsJY2FzZSBNU1JfSUEzMl9DUl9QQVQ6DQo+ICsJY2FzZSBNU1JfTVRSUmRl
ZlR5cGU6DQo+ICsJY2FzZSBNU1JfSUEzMl9UU0NfREVBRExJTkU6DQo+ICsJY2FzZSBNU1JfSUEz
Ml9NSVNDX0VOQUJMRToNCj4gKwljYXNlIE1TUl9LVk1fU1RFQUxfVElNRToNCj4gKwljYXNlIE1T
Ul9LVk1fUE9MTF9DT05UUk9MOg0KDQpUbyBtZSBwdXR0aW5nIEtWTSBwYXJhLXZpcnQgTVNScyBh
bmQgaGFyZHdhcmUgTVNScyB0b2dldGhlciBpc24ndCBnb29kIGlkZWEuIA0KWW91IGNhbiBpbnRy
b2R1Y2Ugc2VwYXJhdGUgaGVscGVycyBmb3IgdGhlbS4NCg0KPiArCWNhc2UgTVNSX1BMQVRGT1JN
X0lORk86DQo+ICsJY2FzZSBNU1JfTUlTQ19GRUFUVVJFU19FTkFCTEVTOg0KPiArCWNhc2UgTVNS
X0lBMzJfTUNHX0NBUDoNCj4gKwljYXNlIE1TUl9JQTMyX01DR19TVEFUVVM6DQo+ICsJY2FzZSBN
U1JfSUEzMl9NQ0dfQ1RMOg0KPiArCWNhc2UgTVNSX0lBMzJfTUNHX0VYVF9DVEw6DQo+ICsJY2Fz
ZSBNU1JfSUEzMl9NQzBfQ1RMIC4uLiBNU1JfSUEzMl9NQ3hfQ1RMKEtWTV9NQVhfTUNFX0JBTktT
KSAtIDE6DQo+ICsJY2FzZSBNU1JfSUEzMl9NQzBfQ1RMMiAuLi4gTVNSX0lBMzJfTUN4X0NUTDIo
S1ZNX01BWF9NQ0VfQkFOS1MpIC0gMToNCj4gKwkJLyogTVNSX0lBMzJfTUN4X3tDVEwsIFNUQVRV
UywgQUREUiwgTUlTQywgQ1RMMn0gKi8NCj4gKwkJcmV0dXJuIHRydWU7DQo+ICsJY2FzZSBBUElD
X0JBU0VfTVNSIC4uLiBBUElDX0JBU0VfTVNSICsgMHhmZjoNCj4gKwkJLyoNCj4gKwkJICogeDJB
UElDIHJlZ2lzdGVycyB0aGF0IGFyZSB2aXJ0dWFsaXplZCBieSB0aGUgQ1BVIGNhbid0IGJlDQo+
ICsJCSAqIGVtdWxhdGVkLCBLVk0gZG9lc24ndCBoYXZlIGFjY2VzcyB0byB0aGUgdmlydHVhbCBB
UElDIHBhZ2UuDQo+ICsJCSAqLw0KPiArCQlzd2l0Y2ggKGluZGV4KSB7DQo+ICsJCWNhc2UgWDJB
UElDX01TUihBUElDX1RBU0tQUkkpOg0KPiArCQljYXNlIFgyQVBJQ19NU1IoQVBJQ19QUk9DUFJJ
KToNCj4gKwkJY2FzZSBYMkFQSUNfTVNSKEFQSUNfRU9JKToNCj4gKwkJY2FzZSBYMkFQSUNfTVNS
KEFQSUNfSVNSKSAuLi4gWDJBUElDX01TUihBUElDX0lTUiArIEFQSUNfSVNSX05SKToNCj4gKwkJ
Y2FzZSBYMkFQSUNfTVNSKEFQSUNfVE1SKSAuLi4gWDJBUElDX01TUihBUElDX1RNUiArIEFQSUNf
SVNSX05SKToNCj4gKwkJY2FzZSBYMkFQSUNfTVNSKEFQSUNfSVJSKSAuLi4gWDJBUElDX01TUihB
UElDX0lSUiArIEFQSUNfSVNSX05SKToNCj4gKwkJCXJldHVybiBmYWxzZTsNCj4gKwkJZGVmYXVs
dDoNCj4gKwkJCXJldHVybiB0cnVlOw0KPiArCQl9DQo+ICsJY2FzZSBNU1JfSUEzMl9BUElDQkFT
RToNCj4gKwljYXNlIE1TUl9FRkVSOg0KPiArCQlyZXR1cm4gIXdyaXRlOw0KPiArCWRlZmF1bHQ6
DQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKwl9DQo+ICt9DQoNCg==
