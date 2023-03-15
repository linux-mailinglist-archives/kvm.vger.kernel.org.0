Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056126BA4AC
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 02:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjCOBbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 21:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjCOBbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 21:31:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A76821A3E;
        Tue, 14 Mar 2023 18:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678843866; x=1710379866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5Lk5Bh7E7Xm7TgFukllwTW2/rqol9QRFtOSjFVbHF2U=;
  b=CiOSRS1/OxcNF6zxAKifY0+4DHSHdbv+VS6ZN+cV7D1lmTnj9n+EB/Dc
   v3iSgy91b66KckZGkJ0iIJbTThfZkD78seQIKDASZuHSlMNM+Y9ENNj4T
   oV1iyKHL1GshnnAn62K6s+gEkhPUdlGLzHtvf9QA/kGN0IyAjsbAuL/0J
   6TVx9rx1KyFHIuoxP1Rel9/qv6D6DDf5+kNwUiB53iQpOjExgSO4kdf8V
   xJGzRAHohCUc1c0YxnrhZfxqzapB9q+but8Pv5tdlwtIsMQe8xbtXL64r
   wkNvZIzUG0IMXkm98or7U+f5btwecFs7fVa+Zmpznwsv2ie7OwVafUd30
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="325945641"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="325945641"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 18:30:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="711728594"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="711728594"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 14 Mar 2023 18:30:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 18:30:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 18:30:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 18:30:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuNKAodKsZFvTVN3gds67MwK5M9kZzRfsjmhKgzMIJL/b+A9Ck63qo2raO/2ifw1+kwTmMo8diEw/ASbPyHt9yy7/TcchFBowXDS7NmuF4AT8BQHcUa4qkRQQBZggX4kVhN3W7bLU2DMdlmnviEKhioscCPtfQ6rPb0IynvlRh990K7fTrQGgIoP5reSZJhqyOFy+JR6QKzcTZSaxqJsjKTGMQXZlqiObdHfWMJ5duRJDcZSjb3nYQhPawmBgxaXarWpi/eBjZ26HIK9w9YZ5eAPY0JazpU8pF2VOy+WaYv/QAmiSu3H7lfEX3r9a5kvLDJ3Eh2DWI0DElD23HCy/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Lk5Bh7E7Xm7TgFukllwTW2/rqol9QRFtOSjFVbHF2U=;
 b=ZyMSgK4aFvr8v803+nqDpYqL2z2PyYGiOX/NYrub7EwvNkPW+D1xKLGuw1qG2ZDDqt/SjBr8eQclrNDxmUnP8UnPxa7LQIpYH9VAwZzv2oj7VObVpXKAfvKLjT1yd6iHWlPnEyy/H4la8r4tXoX7wn5FZnlE9z0JNg3BxaBsIq9+fBMfZ55ATqoxgRXqP+LutqfE+lvBUS1v5pr8GDaxllwSfwH724FSsqLi3aHnISGu8GQQ1n2FJKCZW/YiNL1rBBN92ZwYvFk1uipZ7Na4OrmuDnYealUBh6uSsl0lbliaLcwjQwSa7gLyEW3BsBe8nll30jxaadEgKjQ39oZMnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 01:30:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 01:30:35 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
Thread-Topic: [PATCH v2 05/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
Thread-Index: AQHZU5lNLkv1cCahbEC0lBpbSQHWdK735QYAgAETiACAAHv9AIABk8OAgAAL9YA=
Date:   Wed, 15 Mar 2023 01:30:35 +0000
Message-ID: <6b6ba1875251c5b92f509b6d379252d9674ba91a.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-6-seanjc@google.com>
         <ce2330db94b05605a0649a3da0595211c5bd71dd.camel@intel.com>
         <ZA9avcHRPoIqZP/n@google.com>
         <9f8c89bf44a8eb68407369d26956c24082562cd2.camel@intel.com>
         <ZBEVc0/vD5tEj29e@google.com>
In-Reply-To: <ZBEVc0/vD5tEj29e@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB7472:EE_
x-ms-office365-filtering-correlation-id: 3c7b07f1-1ba5-444b-e33e-08db24f4e00b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3r0cOLEEOU0QT7W9XN2hCjCzuhqQOFdg4kJkXshRZaM8+QmoBtcbSGBWNgFmH/FZ72o7Rsf8Zs/Bo7TMszkqvJuCNWjVGPomZrv6FTrlm2jvZfUL81njMYyBkoJXOuF8ltY4eq65MuCVi9Eor2dDTQfAltA0lwTshvSgIkSocqP57M+pLyCx++B4eujuwmDMjuPhIPZnhM/pWtn/GsrgM6RZIqoXGyzR62bCBUpv/B+AfPi4sj5NEhVqcnONL7lXczOd9DY7XIfmFHRfhLMnuP5qO1eG8+j+L10vO4+djwMTXtmJcrMtv1W+W6zfp/zj3xF9rjebZgZcceafHwhgSVciBa0Xe1YY6Jc0PzH8wh8vBgwn1TR2fVULGBBxzhpA5SWdbLqmd6Giru/F5AgMALkLi2+lwro2JjZ/UW4rKNj0gfbv8Zuf7pKbtyoEDEYCwI/7YBEGSsqghmPPducNM38hJd96FS3PgdiL7au3dYV2103ApNUxbHCrNbEL7qIGNedIoIGvOwoSxTghI8nkNMNsS7wH3Tksy6jqiOdjFj8pSM3f7dVEw5M1snhFCPU6pyJCYSwrZj3ltxla/SgjS1c4ow2peG9+jP7VOAXrtfN+k6qP4FIOSkF5haxjUcBYxqd7lOPbiNEW9qzOs0Ea45cf9Pexqyjdc8WilY5F6M+a/3PK2752AfdqlmZY0/uHFzmFvzTjVFWAhExA32ltdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(82960400001)(122000001)(83380400001)(7416002)(5660300002)(36756003)(66446008)(66476007)(66556008)(66946007)(64756008)(41300700001)(8936002)(8676002)(38070700005)(76116006)(4326008)(6916009)(91956017)(38100700002)(54906003)(86362001)(316002)(478600001)(2616005)(186003)(6512007)(26005)(71200400001)(6486002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXNGcm9wY0lYNzdTNVQxSStoOG1rZk0vWU55VGZKbEVtMWZqczlaUTBkalBM?=
 =?utf-8?B?QlhWOFljNnNROC85ZUxSclpIcmd4S2YyYUtjZCs0azRlaWF2eENReVJsU0xW?=
 =?utf-8?B?Myt0d3lnZHhsL3pnV2tMQ0RGWjFVYzM2R3JGTGIxWnkzcmhNSExYTWw2WWtK?=
 =?utf-8?B?R1R2WWgrYkdLdTBBZU5Gdmc2M2h4RGFLaElKRzhFKzgrMWZ5RmxhR0NiTCtJ?=
 =?utf-8?B?T25SQjF3RmxxVGFsNzJqdUdjUlpqWUY2TEdZSFpxclovRG00SkRhZGdvekFi?=
 =?utf-8?B?WmF4Y0p3elpSUGdlQ1NtQlB1dHR1cmRNN1Y5aElYWThXaTVtaTdSRjZDK3NV?=
 =?utf-8?B?ZlpEQVovRk1pQ0ZNYkJ3aWowVTBmbWNRcmROWDNQQTZWaFhPTm1TWWsvK296?=
 =?utf-8?B?T0g2UW40QjdRRXdqTjlQT3ZYYkx1M1VwTGVjZzhqVmJoVGcwcERoUnFiTzAz?=
 =?utf-8?B?Y2V4dzVFVUlETE1LUHQ5YWRhcVV4WnJCa1VyL3J4WGNVMStRcHNkOWNwSGhn?=
 =?utf-8?B?VGxLU0pNazRTSTlFc1ovcDE5Nms5RUlmNmI5YlprQlcxTmpyVnJiSFBIYUNv?=
 =?utf-8?B?V1MvYTBvNE1XRXcrNlgvL2dXZjFGNHd2cnE5OGhKLzVhazB1NUZ6MWFyMEgr?=
 =?utf-8?B?dXlrRHV0YWtibU5wVGQ2cGRjSlU1NU15ZUtTY2dzaDFHVnRDNTN3Q2Y2bXlh?=
 =?utf-8?B?WGRNaGpvcFZBQnN5T2tpV3kybmtQSVBJSncwMzVjZldGN2orWXgwTGZ2RFkx?=
 =?utf-8?B?NjRFNHlQaVRVaTB1UEFFKzNud3J0NUNMRUt1Y3d3cnlUUEMwVmdPa3kxL1FG?=
 =?utf-8?B?S2hkWDJTaGg5eGg4WWxqeUtYWVJBSFpIK2hicmkzcDJibWVteW5HV0RFblJr?=
 =?utf-8?B?U2IzQVE3L0cxZ0ZuQXlrRmJSR2pKYlVuVFliSUNCVDM5U1REU1NnTStoWk9j?=
 =?utf-8?B?akZtVG9pQ2FDQ1NObVJjWDlFRkRZSW9aZVNKeUpaTHZGZFZ0a2djb0U5dTRq?=
 =?utf-8?B?aUN6bk8yb25CV05pZDNQT3hvSE1UcDFkNlJnRkg0MGVpVlE2dzdPVTUrYjU0?=
 =?utf-8?B?ZGNVeGlBbDVBenMwQUdVSWc0RUk5b1lnM09KK2NWbUhnb3ZxNjZnYUNicGU2?=
 =?utf-8?B?dHhwQWNFNmlzalN2S1UvNnlFZ2JhT0dPazJoRHRuTmNZc0cwa1o1ZC9CK1h4?=
 =?utf-8?B?UjFWbkFYZ2FlMnp1TVVHZ0I3b2ZJSldFVWZvTzlsYzN6VVozZ2RZVHMxUm5U?=
 =?utf-8?B?K2VQSjgwSDdnOTZ6WGJ0L3JtOW5OSS9ta0ozb2dPdjlBUncwTkdmS3ZtUnNt?=
 =?utf-8?B?UzN1WkZibS85UVVCZWkzTXRYUTM1alZRVXBLSkUzWjM1R0RHd29ZVWExMzVk?=
 =?utf-8?B?cUJEYXI2c1AvM0lNSU1QV25ucGhaaGtoSlhjVW84VUxVTHdtL1RLYXd2d3Rq?=
 =?utf-8?B?c2VDUTlHL1hZQnY2N0cycGhPZE92d1Fsb3hUS213ZHRETitOaFh4a1pOVVZT?=
 =?utf-8?B?UVlCSU4yWitTWTJIMU13NWN3bGVRYTVEdVBqMnNRVDVhMGNPYkwyaDdEMzQ0?=
 =?utf-8?B?UkpUeXB3MkE0Q1VnelRqQnR0NzFkMGVDdlBmRVhSODArb2YwNXV0bmFvSW1Q?=
 =?utf-8?B?VVVNallKUnR0NUVMYjlHenEyVy80Tk01VXlPMkRCbTg4dEVZWTdXK1h2VGVU?=
 =?utf-8?B?SXptREE0Y1ZMNGNHUk5HRmFubndYVC9OSU8vTUl2dzlMUDg3c214akFyM3Jw?=
 =?utf-8?B?bW5NRmhRWGZlTVY3RThKQnBTZS9aQ3RCZHBrN0JsQ0NIVW8vWVIyK3NHRUF2?=
 =?utf-8?B?bnhjMmZXTGpCRWhWZHhpU2ZzVSsrUVZrKzNZTVZMdnFndjN6dFkrTE5HWTky?=
 =?utf-8?B?WWZjVnBZK29PeHJva2pzSmI5TEQyTmRYL0dVckxHTWpsMFU5cHZoYUw2UW1z?=
 =?utf-8?B?Qm5lLzFrTWhNTTR0UkxFaGIvRlFZQ2lLOTN4ZjZHOWNLU1J6QytmMGFBZ3Js?=
 =?utf-8?B?UWl6NVovVys0ZkpBYzlFN1NTYjVmS2pRZVNuMFZHVFRTQUpZVlZIS3pVS2ND?=
 =?utf-8?B?MWN2aGlXVU1teElpMTFTYzJheDNJc0V5S2d5S3hGOW5YNnRTM21DL0lpM1VF?=
 =?utf-8?B?UnR3bDRJZlNaOENKUGdoSHdGOEwwYzN0WkZTMU02bjRSVnNTNDRCemMzSmo0?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA4B50B1BEE4DD49B6D69D0686D65561@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c7b07f1-1ba5-444b-e33e-08db24f4e00b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 01:30:35.1771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WF76D8ukjB7GEZqEubLrjltldJDUcZAJpfV2BgDyiKj+ul3mK6lk3qAIcsJ731p5RpMw6ybh2BuS2bNH4Oj9sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7472
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAzLTE0IGF0IDE3OjQ3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEFsc28sIHBlcnNvbmFsbHkgSSBkb24ndCBwYXJ0aWN1bGFybHkgbGlrZSB0aGUg
bWlkZGxlIHN0YXRlIGluIHBhdGNoIDA0Og0KPiA+IA0KPiA+IMKgIHZvaWQgY3B1X2VtZXJnZW5j
eV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKHZvaWQpDQo+ID4gwqAgew0KPiA+IMKgICNpZiBJU19F
TkFCTEVEKENPTkZJR19LVk1fSU5URUwpDQo+ID4gLQljcHVfY3Jhc2hfdm1jbGVhcl9sb2FkZWRf
dm1jc3MoKTsNCj4gPiAtI2VuZGlmDQo+ID4gKwljcHVfZW1lcmdlbmN5X3ZpcnRfY2IgKmNhbGxi
YWNrOw0KPiA+IMKgIA0KPiA+IC0JY3B1X2VtZXJnZW5jeV92bXhvZmYoKTsNCj4gPiArCXJjdV9y
ZWFkX2xvY2soKTsNCj4gPiArCWNhbGxiYWNrID0gcmN1X2RlcmVmZXJlbmNlKGNwdV9lbWVyZ2Vu
Y3lfdmlydF9jYWxsYmFjayk7DQo+ID4gKwlpZiAoY2FsbGJhY2spDQo+ID4gKwkJY2FsbGJhY2so
KTsNCj4gPiArCXJjdV9yZWFkX3VubG9jaygpOw0KPiA+ICsjZW5kaWYNCj4gPiArCS8qIEtWTV9B
TUQgZG9lc24ndCB5ZXQgdXRpbGl6ZSB0aGUgY29tbW9uIGNhbGxiYWNrLiAqLw0KPiA+IMKgwqAJ
Y3B1X2VtZXJnZW5jeV9zdm1fZGlzYWJsZSgpOw0KPiA+IMKgIH0NCj4gPiANCj4gPiBXaGljaCBl
dmVudHVhbGx5IGdvdCBmaXhlZCB1cCBpbiBwYXRjaCAwNToNCj4gPiANCj4gPiDCoCB2b2lkIGNw
dV9lbWVyZ2VuY3lfZGlzYWJsZV92aXJ0dWFsaXphdGlvbih2b2lkKQ0KPiA+IMKgIHsNCj4gPiAt
I2lmIElTX0VOQUJMRUQoQ09ORklHX0tWTV9JTlRFTCkNCj4gPiArI2lmIElTX0VOQUJMRUQoQ09O
RklHX0tWTV9JTlRFTCkgfHwgSVNfRU5BQkxFRChDT05GSUdfS1ZNX0FNRCkNCj4gPiDCoMKgCWNw
dV9lbWVyZ2VuY3lfdmlydF9jYiAqY2FsbGJhY2s7DQo+ID4gwqAgDQo+ID4gwqDCoAlyY3VfcmVh
ZF9sb2NrKCk7DQo+ID4gQEAgLTgzMCw4ICs4MzAsNiBAQCB2b2lkIGNwdV9lbWVyZ2VuY3lfZGlz
YWJsZV92aXJ0dWFsaXphdGlvbih2b2lkKQ0KPiA+IMKgwqAJCWNhbGxiYWNrKCk7DQo+ID4gwqDC
oAlyY3VfcmVhZF91bmxvY2soKTsNCj4gPiDCoCAjZW5kaWYNCj4gPiAtCS8qIEtWTV9BTUQgZG9l
c24ndCB5ZXQgdXRpbGl6ZSB0aGUgY29tbW9uIGNhbGxiYWNrLiAqLw0KPiA+IC0JY3B1X2VtZXJn
ZW5jeV9zdm1fZGlzYWJsZSgpOw0KPiA+IMKgIH0NCj4gPiDCoCANCj4gPiBDb3VsZCB3ZSBqdXN0
IG1lcmdlIHRoZSB0d28gcGF0Y2hlcyB0b2dldGhlcj8gDQo+IA0KPiBJJ2QgcHJlZmVyIG5vdCB0
byBzcXVhc2ggdGhlIHR3by7CoCBJIGFncmVlIGl0J3MgdWdseSwgYnV0IEkgZGlzbGlrZSBjb252
ZXJ0aW5nDQo+IFZNWCBhbmQgU1ZNIGF0IHRoZSBzYW1lIHRpbWUuwqAgSSdtIG5vdCB0b3RhbGx5
IG9wcG9zZWQgdG8gbW92aW5nIGV2ZXJ5dGhpbmcgaW4NCj4gb25lIGZlbGwgc3dvb3AsIGJ1dCBt
eSBwcmVmZXJlbmNlIGlzIHRvIGtlZXAgdGhlbSBzZXBhcmF0ZS4NCg0KU3VyZS4NCg==
