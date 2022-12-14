Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318EA64C847
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 12:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLNLnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 06:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbiLNLnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 06:43:19 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175A320F5B;
        Wed, 14 Dec 2022 03:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671018199; x=1702554199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JtAv2pZZvzPArW36r1gpHt0sdBTnE8Bc9gHFY6jGjmk=;
  b=WnnxAR8mJT+qr+mw3q3hINiS2RDiTTEk/on8umhqIByEx1Z/lW1OiwIb
   2YlZu0IEYuNqLYImHcwKJvsorIij4+7+nyW0zXGQhS9uhYq4OzHo6fyvv
   qoOCptxyxxjhKD6F1cwRBQ+bgKLjcHcbKbxo1usUk/Tp+KHUMMeWbT73f
   rO/+tQuo0c7RyJj+q7KNNE6ezhKJwRNFSQBXxFaddPfekYhuTUdO61jjQ
   8xQBkfsjn2HYEqCkih43UJfpptUbtVR7iY9ozolmVBqL1almiuF4mYZ32
   37VDzXS42qNSaZpLV363tJVyyTaB+cCGTt9rVi6UE4/l83l9BkCRQ6mGx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="316015845"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="316015845"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 03:43:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="648989798"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="648989798"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 14 Dec 2022 03:43:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 03:43:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 03:43:17 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 03:43:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMb8OpelsflTMUi0whiZ6hTjA599Z025zMx/8FEl22bKch+Vvw7nHlOH30MbEkTMzsjAbZ2OukD26eJ3on1GiUI5GjmM+AYZ5VDxJGvCv3K+U0o5L37zkOoNwQ2wCxjIKH9Ri35KZkE4nbQmmi1HwjaBT9B2f8vwEIrg3xig2mTkVFn96dK/cvzUwICxfFwx6ZucxZmtV+IG3hHW4EuIDq8j/wzCjnmdMYpxRxOd6VSlK+H0QwEbPdPQ897pwQ0RWmay99w9SNC6Q6LJ0rQQIdL6mu6f6U9wVrYXE5rAUHx20LambmJB+mO7VVqaW+9mSjTSNOx/MH78OlTy55xvMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtAv2pZZvzPArW36r1gpHt0sdBTnE8Bc9gHFY6jGjmk=;
 b=SMUJ/ishNpTxw5PX79ymJxabVKa2eMxlrBMgvMh+eugyM4ICc/XQaGosVxtpC+eJxyolW0Eh6zlEplIMEfT00MnXcrNP0h/NgRMv2DCY5p6pwk1/z05BuZqmKDFtGWq5mietaxHmLJNaXIXlXeAPns/Vn43C+CefOU+UiG9gi7PHhakb5PCWEbNNWjeqFnq7gJvSJucCSp0qmaULTzCT9ygAFqMTVrT6kBna/0I8QX8SLxHCRSmIW0C3yy4NbcLdybO3bmdkvhaXUSl1/IAfbVkiR8qO0wRIPQ5SXLIghHiGR2IeG392y1Igdzlts9KtyUzdD/yhnVaret1Os9COHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7275.namprd11.prod.outlook.com (2603:10b6:610:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 11:43:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 11:43:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 105/108] KVM: TDX: Add methods to ignore accesses to
 CPU state
Thread-Topic: [PATCH v10 105/108] KVM: TDX: Add methods to ignore accesses to
 CPU state
Thread-Index: AQHY7Ckvrt4ExdXw0UaZ9PPNheleja5tiimA
Date:   Wed, 14 Dec 2022 11:43:14 +0000
Message-ID: <5dc0263aa963534bb049b61adbfb18dec3f65f00.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <282dd5a8edbee0aa87cdf035088ecd8558b0b999.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <282dd5a8edbee0aa87cdf035088ecd8558b0b999.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7275:EE_
x-ms-office365-filtering-correlation-id: e3ad70b6-4ed4-44c5-40f6-08daddc862f1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jfVVPYL+7IasyuBsZ3wsmbMNLPbWJPeYmoVz3xI9Ox3VavE/ljyXF8rCyICv861x49Dfm+d3S+2GebaIAvqePL5lpui3FoFUu9EBo7jaqIY0bVlpFiZkqYanu7q2YFxzTl6/rfw3vJhTMc6H3N5eAiJJWOcQubFgatJNY+n780F7VX3qQZxLdmyQYP0ChQ5vCtlcZ11Hqr/7ZRoOaIluRI3jF1v17fiqrtxZaJYtqo2o+CsT3oAyGCrb83fJr6fotVPIsVplTv8P6H+yVaJqRc1Dr1/xmAC8hrHNhchs6W0lMl54dqcq7ROF5HNZq3M8V3FAecoxcTdVFjuA//P6+KiM3bO3qIW7ch7QMXYYe4dJynDzuEZKoRL9+mTMxwMl6NcxLyngEtqbkJDkDeb+R+nPdvVHOPz3luj1ykRqUzP0EtX3VhLi1X22pWAt4VhWg0zmxyn3XuSvl4GFV0lwMODboQHy8yMj9hxutWDV5S7I/QG1tmysrkOqdVUhV8xRrzxhF1fgp2VrqGHJlV5mfJI5v4dM3Hz7i9U4M0rc2ciJMSPe67Ud2Etbf5XXsX5v5+S/NLSLVfNGk6pdivlO0d31EmVqpTi9OmxCA4/3u9y+kpaFcNMcSErf+jqxqOUh0YLYd6rcui45mCjOAJfJ3BevwKiYy6TWbcEv0+flCFN7vqZ8snY6PIxS5QuzrF2DwLBD0MrOBgwfKzRQFWuyHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199015)(2906002)(5660300002)(4326008)(64756008)(66476007)(76116006)(54906003)(66946007)(91956017)(66446008)(316002)(8676002)(71200400001)(4744005)(66556008)(6636002)(110136005)(8936002)(4001150100001)(41300700001)(478600001)(82960400001)(36756003)(2616005)(186003)(6486002)(6512007)(6506007)(26005)(83380400001)(38070700005)(122000001)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHRQMWlMb0JJOVREUklPdVpiV0JTYi8zY1o2ZXJtT3cxMDAvd0hjb1I2MXNE?=
 =?utf-8?B?SEp1ZlRMSExOb1hMTjgvWVJsYzdBNGEvZXFDYmZnY3Z4VDAwSUp3RkFMUjl6?=
 =?utf-8?B?UW9hZnd3V1ptdUNZNm8wOU1xVDhGL3dhSVM2TXk4VnRvVytNbFNnNmo3OFY2?=
 =?utf-8?B?cUpHTmNMZWZVMXJEZWRWaDdwSm5jVDIyRjk1K1ExaGxKWWFMKzlCNDdYUmFI?=
 =?utf-8?B?QnhMYmJETFFpYkt2M0dsQWdpdW5FaDMvaU52NklBdU9MMlB4bUxkd280YzlQ?=
 =?utf-8?B?eXV3YjBrVWpONjYyRnNYRjlLNXNnQ2x0WUVxS3d2UUZoZ2g1Z21BTEltcmZ2?=
 =?utf-8?B?Um1DbkN6ZkRoczJTQngydWc5cGlnQzZhSzV3NERnMkxxV1RSdVFINVpJYjF0?=
 =?utf-8?B?ZWt1MEN4TjgrQlhEY1dkYnRLNVpLbGZtK2V3ZlVDb0xqdE5RWWdVdS8vR2ND?=
 =?utf-8?B?VWV5OXhKR0JudFc1YWdFWFhpdzFIOE9UeGFENm5qeE95eUZjanlUQk9mZnhN?=
 =?utf-8?B?T3BLNUc0eERJSEdqZ2IyM2lGN2d5NlBmTHFDKy9vTnc2VTlnN2dzN1FwOTRS?=
 =?utf-8?B?T1c3QXlTVWdHOXRPVmo4azFZWVF6VE1vbWJtSDlmOVErY2lzdy8rR0lRZE9o?=
 =?utf-8?B?bk5ud0lGY2lwRDJDQTZnRE00OVg5R2FYbGRCVnMyeWJaUlYvc1ppdGoxR0p4?=
 =?utf-8?B?eGxsaW5BUGFTcDBwUEUrbldvQmo4WUFVNFQyZWltODhmZW94R0xFcVBhNVI5?=
 =?utf-8?B?MDNVOG5tcU9YM0dRSElIVmtYZEl6VzZaMFU0WVI3S1JVU1FtdVdwNEdGbUZq?=
 =?utf-8?B?czRmQ3NWOVkxQm1pbVRSa2J0V3U2NmoydjN4Q0dHSjFXWW9uc1JQN092SnRX?=
 =?utf-8?B?RGhkYWtUV3c0Mmp5aUFvciszU2dxdHZQckR1VTRxRS8zb1h5NDdBbG1QWWxN?=
 =?utf-8?B?Y0dVdW1lekQ2TFhZSVlkNU13VHZrTUdhYURhVlNRUG5TOWFaaGxZTU5ZaGhX?=
 =?utf-8?B?c1VDVzdKR0FxSCsrdGxZVzVlU3haVlE0YWxNU0h4dlU1bkthc1hmSVQ1cDRC?=
 =?utf-8?B?QmN6YzA3djBmNGp1SVc2ODZzMDlZRTB5MFVtVWxZNlI4NHI4TzlHQ2JyalM4?=
 =?utf-8?B?WFJkbzkrUTdjejV5ZVFBMnIxL2s3bXo0SkVnamZNb0U4U1lHeXFuQm1TbG1S?=
 =?utf-8?B?QU5SSU9jZU5Dc1hKZ0V3YTlTTW9OWTQzU25qMnJKc1lMWUxvenNDSG9uR1lT?=
 =?utf-8?B?dSs4V2tMeGJXdG9TdnJ3bkM1dUZVZzVRVit1YzNGeVFtUjJHYnlRbGh5STVj?=
 =?utf-8?B?RUdweWRmY0poTUV0dnpLWDAxbm5rZmw4Wk9MbGtVT1Fld0VuN3AyNmM0Tita?=
 =?utf-8?B?TGdvTGcra3J6TWVKYzBudlk4dXRjOFBWNTl6SWtSK3R2RHdTZWJLUmcxbDRG?=
 =?utf-8?B?MEQ1SHhOb3hYOC9lNjZRcWZpN0k3NE5IWVZuSFFVcUpJdEEwdzhXTnZKMlE2?=
 =?utf-8?B?S2crcTFkZWRIdk9yYlM1djZlbzBlUmt0cDg2OTZvVUhRQ0p4MjFIWUljamR2?=
 =?utf-8?B?dTR5Z3hQVEJvcTFJQ1ZBOXBMV0RWUXFoTU1Uc3Nhb2V1QytsYU8zVWxzNFFW?=
 =?utf-8?B?WDltRkxuYVphUk9iYkZIaWx3VXdMcllNNW9udFVvWitHUjJzTGErUE4rZnR6?=
 =?utf-8?B?b1V0bjRGbWFXbWhxOVFiejN3RlBJQllZaFhERGJEYzdZck84WnlHeW10RVpu?=
 =?utf-8?B?V0ZFR2NVWXlCamJHQUpkK2RIa3BHY2NWNUd6T21FbWthVDh0eUxaVHRoYjZU?=
 =?utf-8?B?cDhuLy9QRFNLTTNlOWMzdzdVK25PTFFEa0gzcWgxV0FiVStUR24xY3ErOEQz?=
 =?utf-8?B?RUo1c04vQ3FyeGRRN0ticjN3Y1o1R0E4TmRNcHVBYnNBUHBDWFN2NktWTExR?=
 =?utf-8?B?Y0lOcy92VjZZUlFUcGFlU1ZCdjE1KzQ0YXZNZmt2YkV4VG0rVHRpL0hzYWRl?=
 =?utf-8?B?dWpDSHRnQjNEUzZPalR0S3Q5VUhlSk5jSDRoUC9GRWMzVWlSaXUrWkhFOEFp?=
 =?utf-8?B?eVhMRVoyYlk2bnJNOVkwUVJsQ3hsais3VHR3QlpCSTQ4aWRWdU1OT2JPeER1?=
 =?utf-8?B?TFdIeUUvTHVVUllLN2ZTNHQ5OGtQa0hPcGlqN1Z5TUVXNDNvYVFlYnA0TVFQ?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72B323F561895E48803DA54B2D88EF89@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ad70b6-4ed4-44c5-40f6-08daddc862f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 11:43:14.9209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QsWNFqOGxVRWNPEiXXuEk54YYmhIBEeQVhi7g/Z3w06RRQF8a0puyNJSijza2fs0RlE7L569kaNUzj0I5bI+TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7275
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIzIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICtzdGF0aWMgdTggdnRfZ2V0X210X21hc2soc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBnZm5fdCBnZm4sIGJvb2wgaXNfbW1pbykNCj4gK3sNCj4gKwlpZiAoaXNfdGRfdmNwdSh2
Y3B1KSkgew0KPiArCQlpZiAoaXNfbW1pbykNCj4gKwkJCXJldHVybiBNVFJSX1RZUEVfVU5DQUNI
QUJMRSA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQ7DQo+ICsJCXJldHVybsKgIE1UUlJfVFlQRV9X
UkJBQ0sgPDwgVk1YX0VQVF9NVF9FUFRFX1NISUZUOw0KPiArCX0NCj4gKw0KPiArCXJldHVybiB2
bXhfZ2V0X210X21hc2sodmNwdSwgZ2ZuLCBpc19tbWlvKTsNCj4gK30NCg0KU28geW91IGFyZSBy
ZXR1cm5pbmcgV0IgZm9yIF9BTExfIGd1ZXN0IG1lbW9yeSwgaW5jbHVkaW5nIHNoYXJlZC4gIFdv
dWxkbid0IHRoaXMNCmJyZWFrIE1UUlIgaGFuZGxpbmcgZm9yIHNoYXJlZCBtZW1vcnk/ICBGb3Ig
aW5zdGFuY2UsIElJVUMgd2UgY2FuIHN0aWxsIHN1cHBvcnQNCmFzc2lnbmluZyBhIGRldmljZSB0
byBhIFREWCBndWVzdCB3aGlsZSB0aGUgVlQtZCBkb2Vzbid0IHN1cHBvcnQgY29oZXJlbnQNCm1l
bW9yeSwgaW4gd2hpY2ggY2FzZSBndWVzdCdzIE1UUlIvUEFUIGFyZSBob25vcmVkLiAgSSB0aGlu
ayB0aGlzIHNob3VsZCBhbHNvDQphcHBseSB0byBURFggZ3Vlc3QncyBzaGFyZWQgbWVtb3J5Pw0K
DQo=
