Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C2F6D5521
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 01:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbjDCXNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 19:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbjDCXNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 19:13:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8D9D7
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 16:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680563593; x=1712099593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7e9ChF7gjOM4rpF5vJ7ECaCxwW0/BJ/iEjVA+UiKDEQ=;
  b=XayoHS4l11r/opdW6W8SPGY9st26+P5WbHMfMl2M7Nq3Exy9GsrCm/6k
   5A6UIwFTnAFysIEDpvz5vVSbcb3dAoztd3z/NJJPaQEWcaKghHzKn9aoX
   kcx2MvNgX5EWQGO2ubsPcw/jx64wUgAYdVgUMIfi4MeQw/vRBTqERo0RC
   KLwToaf5YL9Ls8DZf4euMYUQUc4tKVA+nxt3sJVeuyqUwrFiyLEoG+F7u
   VusdVWBjuj8pxv8FXyUfMOe0WonVTNHTyp5AgYjjubPD2w6f5tTo0CHTp
   TJ1LA+CNHNQpsAJDlA8XcYqJ5rdxJcG6k+7dOmdxG8BSMcXOIs1p5rmsn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="339528796"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="339528796"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 16:13:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="810002406"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="810002406"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 03 Apr 2023 16:13:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 16:13:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 16:13:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 16:13:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAFIfK98NU6Xk6KqbsIFLNaOONZBcldcy62biYlp4ZKOEItbJJ8IZfu8h1c/ArTgANXTFFXEmfp14/QcnlL6JJ3vecG4l5pNsSD4aNOG5ybKBatrh/VV3r23vmCEBMld+6vmt/MY5RcKrHmNfFsIk5l+HOFfQtEihIAf00Ryn7QrJVzbgV87aKX6lovO1TCnzKAllB/xScImvy0PmlHnBwFTuDG/Bkig/fYzaWtPvhltQESJkN0cvkwGpMfOnoEbTjTAGUXqp/TZoaWrOWmjt7HuDtNpzgf3EE5KlJSvT1rHL6JhDG7BKAG+GuZYXZFHC5WWBSTtXAhwbHyikGmx3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7e9ChF7gjOM4rpF5vJ7ECaCxwW0/BJ/iEjVA+UiKDEQ=;
 b=IwU7N9Y1sKtXCadtkibJbD79rEioK+2wtN1NRJgWgf2QzHOdna4e+dX1vAYTk+ArkRMAVSOxrTczQiRBeDlfZxQPHcosHhYGQSMpVWmbXmwk0RMJOXE8VkICdcnGL6uv/Y+cCW1lJJQl5RraWityIMIZKg9oNXfi46wlK33WN4Ijl+Y/2HzGG1LVO+5fR6696DlIJD/QDd0wp7Vd4UrYr7qs1QwRjUY+KWlIdZBi9aJR+xmDT0LLQijb50Hl83J5aQ+mAq+BvfG9TEZkdjqNPqMuj70tzLDgqAiA3rUHjx+2R4jXyXfYrhgcZItMij814fn3qsFUOEjfqX1kTaDnqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7241.namprd11.prod.outlook.com (2603:10b6:930:94::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Mon, 3 Apr
 2023 23:13:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 23:13:07 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Topic: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Index: AQHZWj/xX+6sX0Ji9kGqSs4peyRxha8DnNOAgAIo0ACACyFUgIAAH6+AgAAKWgCAAAFNgIABArSAgABXIQCABpqMAIAAgp4AgAA87QCAAIj2AA==
Date:   Mon, 3 Apr 2023 23:13:07 +0000
Message-ID: <783ab8158ebf5b4659b8c21afa24829c322af19e.camel@intel.com>
References: <ZBhTa6QSGDp2ZkGU@gao-cwp> <ZBojJgTG/SNFS+3H@google.com>
         <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
         <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
         <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
         <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
         <ZCR2PBx/4lj9X0vD@google.com>
         <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
         <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com>
         <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
         <ZCrqZTZWd1LC5s3J@google.com>
In-Reply-To: <ZCrqZTZWd1LC5s3J@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7241:EE_
x-ms-office365-filtering-correlation-id: 82f9f72b-4251-4943-b668-08db3498fc42
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2vxkQN0S+zDAJsSfBey2gA6WParbFfczhCMhktNDtiVsjIuyHpWoOOMmt6qsxUixMvAsImFvJoLUDTui8XYtgwrP6tS2p9LPw1/YWCY358AO5Id+joLClRI3U6+T9ohOr9lxuao8uqFJtdFkHRsIZyEog/HdUGglpk55knZtUXu2U1Ca/oWXH7o4ebRYGy/Kow5WchEt1GpB0chFDcKd3a2zf4TLTTCbwkjk3ZArgQ0oOrwRXiSwYumB6ZKpe865Z4zK1h5052dYpF/p45VGdiDgaevEt192kaDYqCNNP7qli1SUBLZKvoxTj5z/WQmTHsV53N3vaz2GPCW3q59NApTJCa5Nwux3E4smpgNH10+cxeY9nzVKLxBl+v00QjlYMO8t6ocrIP89Z6xBIaFlh9cNNeYNg+skD8riaej4nuAdXvlwfH7K29crBhFPUbrB2Y1NrhkGD7aVLIJZTawWXkzYfAQ/vcq1/3T5N6xCl37W9/ymTFHo70WD8OyvZH/XHZvwIvz+l4L53Y/vRsKIh00KqVF70TuhnBOOFM9KEmEVheNbKc1qAJS0ivUIrKIHzaxQIHylzNVY/u4RnoLYUVH8Xf1DzGU8vkyEtY7mi3yuBBxH3aC/Q0lZK2TVk8f4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(366004)(346002)(396003)(451199021)(6486002)(26005)(6506007)(6512007)(36756003)(86362001)(478600001)(186003)(64756008)(38070700005)(38100700002)(76116006)(91956017)(8676002)(2906002)(66946007)(66476007)(66556008)(66446008)(6916009)(5660300002)(82960400001)(4326008)(8936002)(71200400001)(316002)(2616005)(122000001)(41300700001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cW9qZ0UvOFFHNDMvOUUyenJwQnJRRUNIekliY1JLNmw2dmcybTV3alJmelBz?=
 =?utf-8?B?NTdqZko2RVBnRkZhODdvSXN3NEFWS0t0TVFZeHFqeTJkNlM5WTFkQ2RFeFlv?=
 =?utf-8?B?aFZnVjloN2MveVdNbHQ3UEo2K1VGNVo0Qy9sazYwR1QzenRHUVpKa2FFZlpl?=
 =?utf-8?B?dnVhSElpb2l0NDVhYlEwMkJGT3JjRE5wYmk1QkhmaEZXcmFCV0hOajBteURI?=
 =?utf-8?B?bjY4cDdSYVR4eUtvK0dpSHdSSlBxVUZpaHRIbGVXSGFrNzBpR3cvN2VGbWtx?=
 =?utf-8?B?eUtBVDlwL3FGdjhwTVdkc1RXeXdQcTd0Tm1NZnlTRTIxTHNDWEFpWXFjR3RZ?=
 =?utf-8?B?b0hSMTUvbVpxVGRpQ1BZa2xWSkg5bEJNRmlXSEhJVUsxQ3FjdnhrSjd5VnZ1?=
 =?utf-8?B?MGdtYU10L25OQjY0MGN2YmtwcXA1QXN3Wk5wVWdYeUVKaldibW9neW5kTG1h?=
 =?utf-8?B?V0kwaWVYd21nWUJ6RGtpY1Awc2RodTBDVzljZXNpZHRTdlZtV0psVVVsaTV0?=
 =?utf-8?B?eWE5RHdtSlkwMGsvK2MveXcvTDlEeDFSYUVqU3VxNkt4YVJEbmd6aHRReFFK?=
 =?utf-8?B?cDQ5UXlOUm1wYzZQVDY1WmFtYzEyc3Yya0x1VWtLTjgvNUJBMzB5azdBakp4?=
 =?utf-8?B?UWZMRWI5VVU1aHVkZXp0TXFZTm0vck1KdHYvVXdGTnBmN1dqZjQ3Z0dTRTdX?=
 =?utf-8?B?MWVySVU1akp3VXhnRjlBRGhMZnpuMVFhS2hsd2xZa3pJeDcwYXBjaWlFbEl1?=
 =?utf-8?B?YXZGaXNDRGcwVElQaVloYU80UjZ1SWpXaURValIvbjJMdmpqdWlvYkE4RXcw?=
 =?utf-8?B?cHBvSitrVVhNNVR2dUhnLzN5dUgwRnZ0cUpUend4L05mYlhCVXVkbWZpdVlO?=
 =?utf-8?B?endSdE9yd2Ntdkx5bkVGMVdaZ1FWU3dPUFJlM0lsaTdjclJOSzVFS000RkFw?=
 =?utf-8?B?YW1nT2FtWlFXYUFBM1VWZE0zd2VqWDQzT1JWUUkxblk0S1BKTDkxdEU0ZmJU?=
 =?utf-8?B?NFd6ZHRGQXQ5ckxUQlZOK2lxdktjUG5WakRmVHZXT0xXbis3MjlhTFROQkg0?=
 =?utf-8?B?UW9ORjFJaTNkY2UvVWN1UjlmTmtQYXl6RFQzWnBKK2ZaRmFRN1h4U2VnbHow?=
 =?utf-8?B?SCtPTVBhYW1WUXlzQ0x3dEVjSE5lNFNDL1V0aWJpUTBGOC9DSHk4aEVYMVZw?=
 =?utf-8?B?Zms2T0xkc1I5WUdqZjE4dWpEbk1BVEo3dVpod2hmYVJDMzVJWUorUnJ1N3pE?=
 =?utf-8?B?Z0RnblRWYitjbWVrTWkxeWI1S0s3bVVjNndFeVVwUGNNQkw3blJ3RlVaaU9Q?=
 =?utf-8?B?QlkrWE5HNlc1TGZWaUFRZ2o5eGhYUUtNUzFVOVlZenRncUYzTFZIa1U5MDAy?=
 =?utf-8?B?eGJQQWE4d0RtbXUzY3F4YTYxUWl6dTcrd0E2cTBBVU9KV1hENUczMXpRZjVM?=
 =?utf-8?B?U01xdzBSVVFONWZ3SjZSWWNWSllNME8xaGFsMjZkVnBZQ1Q1dUNqcjJQUWJW?=
 =?utf-8?B?SFZlbWZlR3loRjIwcThRUVFXMlY1Y0ljWEpyUWVQUzdLc3VTa2J6R3FWZWpB?=
 =?utf-8?B?SFYzNmJialZzTlZnZWJDRUJsTWUvYUx3L0hxMllsWlFZZEN2SmJFL0dhVnNG?=
 =?utf-8?B?NlRqQVVLTGx6QUVsVHo2WUhFN3RsdWxabUFabHV1RzNhczdDVlg4eHBwVVdo?=
 =?utf-8?B?R3ZYY1Uwa2xxSnZuaC9ELzVZRDBKSGJSVExzSSszckM3by90V0dQMEdKYmRq?=
 =?utf-8?B?VjJvd21jcnVleExmRlZIZCtTV2lkWDBGaW12SjIwWlhKYTEvODhRUE96Y3Zq?=
 =?utf-8?B?YUMrcXFXTzM5TlFiSjV4L1A0NlRob29TdU10VWhKOGZtUlhNNzRZNU52VjU1?=
 =?utf-8?B?c1k4RE16TDVjWnU0TzNtUnpHNUlnbWE5NTZaKythaTQxNDc5VmRTajFyaVpM?=
 =?utf-8?B?enlMUmF3dU1aRTROQm0zZm81UDZPaUdqREZNcWJ0a3dxNFhFaHhGYXZOYTdn?=
 =?utf-8?B?UThYdFRHSnVNNXIxb050L3VmeUcxTlprT0gwTFJCeC9uSmdjeEhTVXNtL1U2?=
 =?utf-8?B?TGppNzFFT1QrNHhHQ2k1YjdNS1dqMkkzQnVpOWJ1OWFyRHVhcXJMZzZFbHpi?=
 =?utf-8?Q?1w2op/Y7WYUbhwXIfAmKlNhni?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <32DC8DB4F8811D489E643B5620E476BE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f9f72b-4251-4943-b668-08db3498fc42
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 23:13:07.4721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RQNYiDotoHikhSGt65ENlKMM4xdbHZmTPo9W1ZKu32Sa2PbR4JDQHSfPuhkx0rkBa/f+L/nPWBkC+nzyQoSK9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7241
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA0LTAzIGF0IDA4OjAyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIEFwciAwMywgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IA0K
PiA+ID4gSSBjaGVja2VkIHRoZSBjb2RlIGFnYWluIGFuZCBmaW5kIHRoZSBjb21tZW50IG9mIA0K
PiA+ID4gbmVzdGVkX3ZteF9jaGVja19wZXJtaXNzaW9uKCkuDQo+ID4gPiANCj4gPiA+ICIvKg0K
PiA+ID4gIMOvwr/CvSogSW50ZWwncyBWTVggSW5zdHJ1Y3Rpb24gUmVmZXJlbmNlIHNwZWNpZmll
cyBhIGNvbW1vbiBzZXQgb2YgDQo+ID4gPiBwcmVyZXF1aXNpdGVzDQo+ID4gPiAgw6/Cv8K9KiBm
b3IgcnVubmluZyBWTVggaW5zdHJ1Y3Rpb25zIChleGNlcHQgVk1YT04sIHdob3NlIHByZXJlcXVp
c2l0ZXMgYXJlDQo+ID4gPiAgw6/Cv8K9KiBzbGlnaHRseSBkaWZmZXJlbnQpLiBJdCBhbHNvIHNw
ZWNpZmllcyB3aGF0IGV4Y2VwdGlvbiB0byBpbmplY3QgDQo+ID4gPiBvdGhlcndpc2UuDQo+ID4g
PiAgw6/Cv8K9KiBOb3RlIHRoYXQgbWFueSBvZiB0aGVzZSBleGNlcHRpb25zIGhhdmUgcHJpb3Jp
dHkgb3ZlciBWTSBleGl0cywgc28gdGhleQ0KPiA+ID4gIMOvwr/CvSogZG9uJ3QgaGF2ZSB0byBi
ZSBjaGVja2VkIGFnYWluIGhlcmUuDQo+ID4gPiAgw6/Cv8K9Ki8iDQo+ID4gPiANCj4gPiA+IEkg
dGhpbmsgdGhlIE5vdGUgcGFydCBpbiB0aGUgY29tbWVudCBoYXMgdHJpZWQgdG8gY2FsbG91dCB3
aHkgdGhlIGNoZWNrIA0KPiA+ID4gZm9yIGNvbXBhdGliaWxpdHkgbW9kZSBpcyB1bm5lY2Vzc2Fy
eS4NCj4gPiA+IA0KPiA+ID4gQnV0IEkgaGF2ZSBhIHF1ZXN0aW9uIGhlcmUsIG5lc3RlZF92bXhf
Y2hlY2tfcGVybWlzc2lvbigpIGNoZWNrcyB0aGF0IHRoZQ0KPiA+ID4gdmNwdSBpcyB2bXhvbiwg
b3RoZXJ3aXNlIGl0IHdpbGwgaW5qZWN0IGEgI1VELiBXaHkgdGhpcyAjVUQgaXMgaGFuZGxlZCBp
bg0KPiA+ID4gdGhlIFZNRXhpdCBoYW5kbGVyIHNwZWNpZmljYWxseT8gIE5vdCBhbGwgI1VEcyBo
YXZlIGhpZ2hlciBwcmlvcml0eSB0aGFuIFZNDQo+ID4gPiBleGl0cz8NCj4gPiA+IA0KPiA+ID4g
QWNjb3JkaW5nIHRvIFNETSBTZWN0aW9uICJSZWxhdGl2ZSBQcmlvcml0eSBvZiBGYXVsdHMgYW5k
IFZNIEV4aXRzIjoNCj4gPiA+ICJDZXJ0YWluIGV4Y2VwdGlvbnMgaGF2ZSBwcmlvcml0eSBvdmVy
IFZNIGV4aXRzLiBUaGVzZSBpbmNsdWRlIA0KPiA+ID4gaW52YWxpZC1vcGNvZGUgZXhjZXB0aW9u
cywgLi4uIg0KPiA+ID4gU2VlbXMgbm90IGZ1cnRoZXIgY2xhc3NpZmljYXRpb25zIG9mICNVRHMu
DQo+ID4gDQo+ID4gVGhpcyBpcyBjbGFyaWZpZWQgaW4gdGhlIHBzZXVkbyBjb2RlIG9mIFZNWCBp
bnN0cnVjdGlvbnMgaW4gdGhlIFNETS4gIElmIHlvdQ0KPiA+IGxvb2sgYXQgdGhlIHBzZXVkbyBj
b2RlLCBhbGwgVk1YIGluc3RydWN0aW9ucyBleGNlcHQgVk1YT04gKG9idmlvdXNseSkgaGF2ZQ0K
PiA+IHNvbWV0aGluZyBsaWtlIGJlbG93Og0KPiA+IA0KPiA+IAlJRiAobm90IGluIFZNWCBvcGVy
YXRpb24pIC4uLg0KPiA+IAkJVEhFTiAjVUQ7DQo+ID4gCUVMU0lGIGluIFZNWCBub24tcm9vdCBv
cGVyYXRpb24NCj4gPiAJCVRIRU4gVk1leGl0Ow0KPiA+IA0KPiA+IFNvIHRvIG1lICJ0aGlzIHBh
cnRpY3VsYXIiICNVRCBoYXMgaGlnaGVyIHByaW9yaXR5IG92ZXIgVk0gZXhpdHMgKHdoaWxlIG90
aGVyDQo+ID4gI1VEcyBtYXkgbm90KS4NCj4gDQo+ID4gQnV0IElJVUMgYWJvdmUgI1VEIHdvbid0
IGhhcHBlbiB3aGVuIHJ1bm5pbmcgVk1YIGluc3RydWN0aW9uIGluIHRoZSBndWVzdCwNCj4gPiBi
ZWNhdXNlIGlmIHRoZXJlJ3MgYW55IGxpdmUgZ3Vlc3QsIHRoZSBDUFUgbXVzdCBhbHJlYWR5IGhh
dmUgYmVlbiBpbiBWTVgNCj4gPiBvcGVyYXRpb24uICBTbyBiZWxvdyBjaGVjayBpbiBuZXN0ZWRf
dm14X2NoZWNrX3Blcm1pc3Npb24oKToNCj4gPiANCj4gPiAJaWYgKCF0b192bXgodmNwdSktPm5l
c3RlZC52bXhvbikgeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
DQo+ID4gICAgICAgICAgICAgICAgIGt2bV9xdWV1ZV9leGNlcHRpb24odmNwdSwgVURfVkVDVE9S
KTsgICAgICAgICAgICAgICAgICAgICAgICAgIA0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm4g
MDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAN
Cj4gPiAgICAgICAgIH0NCj4gPiANCj4gPiBpcyBuZWVkZWQgdG8gZW11bGF0ZSB0aGUgY2FzZSB0
aGF0IGd1ZXN0IHJ1bnMgYW55IG90aGVyIFZNWCBpbnN0cnVjdGlvbnMgYmVmb3JlDQo+ID4gVk1Y
T04uDQo+IA0KPiBZZXAuICBJTU8sIHRoZSBwc2V1Y29kZSBpcyBtaXNsZWFkaW5nL2NvbmZ1c2lu
ZywgdGhlICJpbiBWTVggbm9uLXJvb3Qgb3BlcmF0aW9uIg0KPiBjaGVjayBzaG91bGQgcmVhbGx5
IGNvbWUgZmlyc3QuICBUaGUgVk1YT04gcHNldWRvY29kZSBoYXMgdGhlIHNhbWUgYXdrd2FyZA0K
PiBzZXF1ZW5jZToNCj4gDQo+ICAgICBJRiAocmVnaXN0ZXIgb3BlcmFuZCkgb3IgKENSMC5QRSA9
IDApIG9yIChDUjQuVk1YRSA9IDApIG9yIC4uLg0KPiAgICAgICAgIFRIRU4gI1VEOw0KPiAgICAg
RUxTSUYgbm90IGluIFZNWCBvcGVyYXRpb24NCj4gICAgICAgICBUSEVODQo+ICAgICAgICAgICAg
IElGIChDUEwgPiAwKSBvciAoaW4gQTIwTSBtb2RlKSBvcg0KPiAgICAgICAgICAgICAodGhlIHZh
bHVlcyBvZiBDUjAgYW5kIENSNCBhcmUgbm90IHN1cHBvcnRlZCBpbiBWTVggb3BlcmF0aW9uKQ0K
PiAgICAgICAgICAgICAgICAgVEhFTiAjR1AoMCk7DQo+ICAgICBFTFNJRiBpbiBWTVggbm9uLXJv
b3Qgb3BlcmF0aW9uDQo+ICAgICAgICAgVEhFTiBWTWV4aXQ7DQo+ICAgICBFTFNJRiBDUEwgPiAw
DQo+ICAgICAgICAgVEhFTiAjR1AoMCk7DQo+ICAgICBFTFNFIFZNZmFpbCgiVk1YT04gZXhlY3V0
ZWQgaW4gVk1YIHJvb3Qgb3BlcmF0aW9uIik7DQo+ICAgICBGSTsNCj4gDQo+IA0KPiB3aGVyZWFz
IEkgZmluZCB0aGlzIHNlcXVlbmNlIGZvciBWTVhPTiBtb3JlIHJlcHJlc2VudGF0aXZlIG9mIHdo
YXQgYWN0dWFsbHkgaGFwcGVuczoNCj4gDQo+ICAgICBJRiAocmVnaXN0ZXIgb3BlcmFuZCkgb3Ig
KENSMC5QRSA9IDApIG9yIChDUjQuVk1YRSA9IDApIG9yIC4uLg0KPiAgICAgICAgIFRIRU4gI1VE
DQo+IA0KPiAgICAgSUYgaW4gVk1YIG5vbi1yb290IG9wZXJhdGlvbg0KPiAgICAgICAgIFRIRU4g
Vk1leGl0Ow0KPiANCj4gICAgIElGIENQTCA+IDANCj4gICAgICAgICBUSEVOICNHUCgwKQ0KPiAN
Cj4gICAgIElGIGluIFZNWCBvcGVyYXRpb24NCj4gICAgICAgICBUSEVOIFZNZmFpbCgiVk1YT04g
ZXhlY3V0ZWQgaW4gVk1YIHJvb3Qgb3BlcmF0aW9uIik7DQo+IA0KPiAgICAgSUYgKGluIEEyME0g
bW9kZSkgb3INCj4gICAgICAgICh0aGUgdmFsdWVzIG9mIENSMCBhbmQgQ1I0IGFyZSBub3Qgc3Vw
cG9ydGVkIGluIFZNWCBvcGVyYXRpb24pDQo+ICAgICAgICAgVEhFTiAjR1AoMCk7DQoNClBlcmhh
cHMgd2UgbmVlZCB0byBsaXZlIHdpdGggdGhlIGZhY3QgdGhhdCB0aGUgcHNldWRvIGNvZGUgaW4g
dGhlIFNETSBjYW4gYmUNCmJ1Z2d5IDopDQoNCg==
