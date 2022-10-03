Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5665F36DE
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 22:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiJCULy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 16:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJCULw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 16:11:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AB429808
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 13:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664827911; x=1696363911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ItxddPQ6pzXLwtramxQ4DtUe342+8GkmBfJiNYtNQJw=;
  b=CarldSMuMCuNOtPf440Vnj6MUBhRndMuoekFdR6fqO9ZJpZRMFfV/izQ
   7aNS6Jixyz63Dlek4tgCcX5odvCmIDXd3NMxEhA3dYIPHC2DiDjWTNwtt
   IzOyzfh6MtFQVZm27k8JIWaat1Lx8mQk4oVnwMmOpfwm22EZevLgt1KzK
   t68+ili3c1Stj3N6C/rNQUuf20bq6uRcKEOlm+2YH31KlEu++6LqK65kt
   kl70Kj6P5TF5mM2WWXJfJYXlxK8RxiDq3PY+OZWUG+XLKJJFFxaDgiu/9
   ImBjfBUVbIbpw8GG+fWFtF1XsixBKvTGntD8p/E8emTYvnW0F13/R+QV+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="364648783"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="364648783"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 13:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="574780265"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="574780265"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 03 Oct 2022 13:11:50 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 13:11:50 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 13:11:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 13:11:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 13:11:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqRvzdVJgMGd3vfbW1c0zCuUMeZugmSoaJlrzIO1Y9+dCJDHksO2si95ZUiTRKWXNJwjpdUQAHgPjI90Cr+eNJBZBuDklsvbe9iQZNjiSNe7wjQyG8M7hpnh5yPqJcoz04CxqH+c+Kw6+hUYa2QQ8GuqtFzqKIkRdwfr41Y8XPp433jaPw6w/6SJ/q9z+KWcdOawbcF7JO0WIMZ1V8fwN72l2HPLUYsfYRnI8FwDd3hqJCQamYo8pl2a9dtp78lDrHWNSYk9ixdbwDsFkty0k4wlFQhgnKaZZ9bcj8ZFwTY2ivW+MRo16RxKFCR9PqMW/oZZuCN69XN3eVcb2Ks7RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItxddPQ6pzXLwtramxQ4DtUe342+8GkmBfJiNYtNQJw=;
 b=TCcLoGPa3JXKXFBdaOPWP/M265F6tpzGklvMFaMGvCGww5K4ncfKl48QAKx6tpzfyjf/ozigatC0d5bBBEbauB6tuGjDBKkk0J2yH8t2nhxYWhKCETwGJL+M6HzF2DMsuLtSdIXjJxVQpRInNiwr4SaOwSXqjsPyEwogrBRqpMqogsuajGC9mdAznTcmWtWXF44P9PXHaeXVuYXufRc7YuPdl5PEwMR836BFjg2An5ue3MyOF35G4+8RRMYsG/Rl745o3LA6jrdtot8gXq8a9lKcW9jouHA1qygh7wU97hE5yb7WBAIdkAIWL9ZDykHudL7VEp0ukWp88vIBH3dlMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5398.namprd11.prod.outlook.com (2603:10b6:208:31c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 20:11:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 20:11:01 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Topic: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Index: AQHYzeClAoVSdFoVkE6IUn79IeyfMa3zCMQAgABz3YCAAFLRAIAJSRIAgAAUPQA=
Date:   Mon, 3 Oct 2022 20:11:01 +0000
Message-ID: <ec8ce2ce250286360fd67f32c057728c10e81bdb.camel@intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
         <20220921173546.2674386-2-dmatlack@google.com>
         <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
         <CALzav=d1wheG3bCKvjZ--HRipaehtaGPqJsDz031aohFjpcmjA@mail.gmail.com>
         <fde43a93b5139137c4783d1efe03a1c50311abc1.camel@intel.com>
         <20221003185834.GA2414580@ls.amr.corp.intel.com>
In-Reply-To: <20221003185834.GA2414580@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5398:EE_
x-ms-office365-filtering-correlation-id: b6bbbfe4-db92-489a-8e16-08daa57b6489
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8jImYw/2PLK4EFLUUFtlY7BasmpbXMA59nMoeGcWDV4UxJ0iVTgo3CNZpfSP9dEWkIIOr4xaVltrpCBkWa6xus+e7DlA8ZGL7djgpIvOR6+ORXGXxDhkGe2Y0luaX/Kvby6wOP4tiQQEnS+2BX2wrKjREKqI1T/ELrZEEnCNyv76WUBTUHrZXZaoPY6G2omBKQfTFa0OHbAGFIFHSI/LpS7gnNPw7VjHb9dHC7uW9ADfCSyjOGGziMV8kRDtZn55ct/Iz5/gNL3/tCVYB4S5L7foRhYiXdtV2n4WheBrR4gyz+x7IPGcOxnesLOT1WIEh83Sc0YGnYvz5SiWXjeEM0IV3/fx/42s+H/6vCZnxtxJ+wyfmfYHOQasc+df3rmOMPgeivvneKFgevf3W9paG4KVWB0MvmB6eaAuW35sTQZA+IloJkxGwK/pgyBO6Ga7wh979jH4bWEAX4qAXIcYV0MdELWfLf0SQxDM2L6n768rw+Yz/sjq7MYfMzjd4OqAAyctPhs41Opva8SbL97XsaIgiWqZoLiUSezDoubOEdwq+9tNs2+1JJT6IcQVUx4Ytv8Y3RH8Hu9hOYWnkdXTZI+35DQxPlds/IAZKN+RnJQdsaAXXNlL0xp+Q0hULWSmpLS/J/cGk4jTC79KKs4N9nI5E3IZx1hv3mZTp2hmKdIbd/PtcG38HQ39pBC/C90czgw9sQlCptzdi6RaMUG+G3ULVnfBXAoiDKR40AJDhIi9mEy4JAIWifjxKo+nupjTsFCGGecnQrxb/8yMXE1LVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199015)(64756008)(66446008)(53546011)(66556008)(8676002)(6512007)(54906003)(66476007)(4326008)(2616005)(316002)(6506007)(6916009)(76116006)(478600001)(36756003)(71200400001)(122000001)(91956017)(38100700002)(82960400001)(86362001)(6486002)(38070700005)(83380400001)(186003)(26005)(66946007)(5660300002)(8936002)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjhDVEJ3TmptQmllZVdPc2t0V2t2WWx1OVFIeGhKOUxPbWtmVFZySWwxK3c0?=
 =?utf-8?B?MUpIZGhERlJ2cGtVVU1maDdtUk5qcWZWeWxQN1BZTUQ5bWowai9qWW1UVlFp?=
 =?utf-8?B?VThRazJBakpVSXNsVGIzNExsSHAvOEp5ZmV3czhPRGdhMW1KdUVYUzYxNU55?=
 =?utf-8?B?cmx2MURXVUMraEVyTEJBWFF1QjFXSEZoRzA3bzU0UmYwUlV4Y3MxaGhpMnA5?=
 =?utf-8?B?cUxUS1paVGFjWnhEY1RibUI1dnpIS09mT2tQVzJkNHFtcU5ZRm1XeGM3VHRz?=
 =?utf-8?B?NU1KNVd4TXJVdDV3ZE9QQkM0czFkR2lFUWkzdWpybEI1d1ZaMFQvbFB6M20r?=
 =?utf-8?B?RTVCcU8wU0xBOEZkY2V2YnVaU2VvUllVOCtPMzVzenB4TkY4UXU3SVFqUFdE?=
 =?utf-8?B?a0d6ZnAyUkdOUzh1ekRLUFNIblJYMDhndFlZRmpJMXFrb3RDazNqNDlhNUxJ?=
 =?utf-8?B?bVlpQVpjZ29BY21PY3hSamRNQzYrcGhoOWJqQXJBSklMUDhKUTZDUnZGRFZM?=
 =?utf-8?B?dzhNMGE0OFNlbmx4QTNheVBnQ29yMjZHNEFXMFlaemtiYkMxZzRaYlI2SWxz?=
 =?utf-8?B?N3BpejRsVlNJVXdIS045Y0FseklSVUdieDQ0UVRTTFRTTHo2T1UySVBLQ1JY?=
 =?utf-8?B?TnB0UDE5S1M5SnJ2dk9vUXhlNXRPQWZYSjFaUmtyOGR3VUlESmg3cHhndjhX?=
 =?utf-8?B?N01qY2Y0WUhZNE1ZRHByTm5TQTVUaW1KdTU2cFdVZ0V0clF4NFdXR0NyeUFG?=
 =?utf-8?B?bFlnUjZnT0had0MzUXdTeStUczFZRTFBdDlnRDErMDJBdHhleDJWdUJweDR2?=
 =?utf-8?B?SnRuSEo1VjQzNVRRR0VQbjE5bnZZZGJFQ2ZsdEExUEVyT1A4bytRMW1aSDg5?=
 =?utf-8?B?QkdLL0NOSU40RnhESGJTUlN1aUw1QmRnWE9xMW5ncHcyYUVBUW1MSFUyK2dM?=
 =?utf-8?B?Sm1ya0hCbGxmU2tyYXVQWXJwSHF1WEQxZU1QMm81Y1RZNVNib053RUlLZGpa?=
 =?utf-8?B?Qjd6ei9LR3dhOVdqZW9ML0dSU1RIckloZFpBOFFQNEVyOWJNSmI1d0F5RzZt?=
 =?utf-8?B?L1R5eGdLTFk1cXdOcjFQaFRMcVFRZk9VcGVvVEtrcDB2elpidjNoQTdKdTJW?=
 =?utf-8?B?dCtmK0hlMWY0VFFZU0FONURYZlBwekpaR3BIdzg0ZmdmMnB4QjhSYlZBaVl3?=
 =?utf-8?B?dnF3Rm96WHl5aFNVTk5CUG81dExuNXVLMnVPd2lRa1ZFYnVDcUJhb0l5VHpP?=
 =?utf-8?B?MlVwelRsVS8rR1ZPV0JzQUhPelFRN2J0dE9oRTZzK29EKzJnS0cvQzhxMzBS?=
 =?utf-8?B?Q2ZYekpBRWZtczdhV1JDWDZmZmJ2bVFycTFraEVEcHpDdGJMeklnUzlqY29s?=
 =?utf-8?B?VXorSVV0cW9JV3ZlQWVKNjFSL2pzN0hlVzVYTVZrai9zZllvNVlOa1ROUUtj?=
 =?utf-8?B?SDEyV1kzMXJWanRGc1BBYmR4bUdlNjVXeUwyWStGMlJrYlNxVHdvN3RFc2Zu?=
 =?utf-8?B?am1jeTJCOGdRdHRkZ0piaERlc0FkVHZrN1hYQkFaUXd0WVc2RnZnRWVQQllS?=
 =?utf-8?B?RVovVzlBaml3OXJxblBFL3RHRlRtY2tDQTdIam1JRkhuZU5pYlJFcEZxYjhn?=
 =?utf-8?B?NG43Tm8wL1VTb2ZuQU00b1ZuZVNMMUlWcW9lLzRhTDMzMWlKSWV6N3N1a3c3?=
 =?utf-8?B?bzVUNWw3Mkc1R0E5R1ZEZnRpTW5INlk1OHNyQVlTcEpBZFBNWU9MUXF0VXRm?=
 =?utf-8?B?ZFB5S0VFZGgrdVhIMU9hcFRuQ1pnYjlKcGhpWG8xdkhnMHpQN1FZQldFQmc0?=
 =?utf-8?B?aTBvODdaWUdJdUNMNFZnZXdyWjF3eHpIWTZ3bk4zMUpGa1ZETnUrZXlHMkcw?=
 =?utf-8?B?MklsdE9LbDYra0FlZmpEL2lUZE5INC9pRnRSVVdoekJ4aXBVdWJ4dHpsNzJZ?=
 =?utf-8?B?U3NPRTVjM0V4bmZUT2VrZTd6S1FGOFVFcmR3Q0pRRHhFalI2ZW9jeTdHcm40?=
 =?utf-8?B?SUt6OVBKRm4rZjhNNVBsMmhzRGhXRnh3bVY5NGRUMWNFTTB0QkN6T04vSkZW?=
 =?utf-8?B?eE91dzd5WGp2MFhhWGJCNThIU254Ynk1c1I4Sml3T2c4TDBLWVdrYzdGRGR5?=
 =?utf-8?B?TkE3SzBMak4rOTNxRlFuazhxeE9CeFVseHJzeE1KZzcvUGpLd2c4ZlhlT25p?=
 =?utf-8?B?WlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78D97B66FFCF214D9C4015780FA6079C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bbbfe4-db92-489a-8e16-08daa57b6489
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 20:11:01.2018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LLUJ5+Lk4OOq9Hgv6zQLtAjuSFERhUrA6QNUCra+2q7lg6tUWAPIoquOqvbfTqSgVRvVFkQ7SOQ2qJ/iL+ZR0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5398
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTAzIGF0IDExOjU4IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVHVlLCBTZXAgMjcsIDIwMjIgYXQgMDk6MTA6NDNQTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gVHVlLCAyMDIyLTA5
LTI3IGF0IDA5OjE0IC0wNzAwLCBEYXZpZCBNYXRsYWNrIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBT
ZXAgMjcsIDIwMjIgYXQgMjoxOSBBTSBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3
cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ICtib29sIF9f
cm9fYWZ0ZXJfaW5pdCB0ZHBfbW11X2FsbG93ZWQ7DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiANCj4g
PiA+ID4gWy4uLl0NCj4gPiA+ID4gDQo+ID4gPiA+ID4gQEAgLTU2NjIsNiArNTY2OSw5IEBAIHZv
aWQga3ZtX2NvbmZpZ3VyZV9tbXUoYm9vbCBlbmFibGVfdGRwLCBpbnQgdGRwX2ZvcmNlZF9yb290
X2xldmVsLA0KPiA+ID4gPiA+ICAgICAgIHRkcF9yb290X2xldmVsID0gdGRwX2ZvcmNlZF9yb290
X2xldmVsOw0KPiA+ID4gPiA+ICAgICAgIG1heF90ZHBfbGV2ZWwgPSB0ZHBfbWF4X3Jvb3RfbGV2
ZWw7DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gKyNpZmRlZiBDT05GSUdfWDg2XzY0DQo+ID4gPiA+
ID4gKyAgICAgdGRwX21tdV9lbmFibGVkID0gdGRwX21tdV9hbGxvd2VkICYmIHRkcF9lbmFibGVk
Ow0KPiA+ID4gPiA+ICsjZW5kaWYNCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IFsuLi5d
DQo+ID4gPiA+IA0KPiA+ID4gPiA+IEBAIC02NjYxLDYgKzY2NzEsMTMgQEAgdm9pZCBfX2luaXQg
a3ZtX21tdV94ODZfbW9kdWxlX2luaXQodm9pZCkNCj4gPiA+ID4gPiAgICAgICBpZiAobnhfaHVn
ZV9wYWdlcyA9PSAtMSkNCj4gPiA+ID4gPiAgICAgICAgICAgICAgIF9fc2V0X254X2h1Z2VfcGFn
ZXMoZ2V0X254X2F1dG9fbW9kZSgpKTsNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiArICAgICAvKg0K
PiA+ID4gPiA+ICsgICAgICAqIFNuYXBzaG90IHVzZXJzcGFjZSdzIGRlc2lyZSB0byBlbmFibGUg
dGhlIFREUCBNTVUuIFdoZXRoZXIgb3Igbm90IHRoZQ0KPiA+ID4gPiA+ICsgICAgICAqIFREUCBN
TVUgaXMgYWN0dWFsbHkgZW5hYmxlZCBpcyBkZXRlcm1pbmVkIGluIGt2bV9jb25maWd1cmVfbW11
KCkNCj4gPiA+ID4gPiArICAgICAgKiB3aGVuIHRoZSB2ZW5kb3IgbW9kdWxlIGlzIGxvYWRlZC4N
Cj4gPiA+ID4gPiArICAgICAgKi8NCj4gPiA+ID4gPiArICAgICB0ZHBfbW11X2FsbG93ZWQgPSB0
ZHBfbW11X2VuYWJsZWQ7DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICAgICAgIGt2bV9tbXVfc3B0
ZV9tb2R1bGVfaW5pdCgpOw0KPiA+ID4gPiA+ICB9DQo+ID4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+
ID4gPiBTb3JyeSBsYXN0IHRpbWUgSSBkaWRuJ3QgcmV2aWV3IGRlZXBseSwgYnV0IEkgYW0gd29u
ZGVyaW5nIHdoeSBkbyB3ZSBuZWVkDQo+ID4gPiA+ICd0ZHBfbW11X2FsbG93ZWQnIGF0IGFsbD8g
IFRoZSBwdXJwb3NlIG9mIGhhdmluZyAnYWxsb3dfbW1pb19jYWNoaW5nJyBpcyBiZWNhdXNlDQo+
ID4gPiA+IGt2bV9tbXVfc2V0X21taW9fc3B0ZV9tYXNrKCkgaXMgY2FsbGVkIHR3aWNlLCBhbmQg
J2VuYWJsZV9tbWlvX2NhY2hpbmcnIGNhbiBiZQ0KPiA+ID4gPiBkaXNhYmxlZCBpbiB0aGUgZmly
c3QgY2FsbCwgc28gaXQgY2FuIGJlIGFnYWluc3QgdXNlcidzIGRlc2lyZSBpbiB0aGUgc2Vjb25k
DQo+ID4gPiA+IGNhbGwuICBIb3dldmVyIGl0IGFwcGVhcnMgZm9yICd0ZHBfbW11X2VuYWJsZWQn
IHdlIGRvbid0IG5lZWQgJ3RkcF9tbXVfYWxsb3dlZCcsDQo+ID4gPiA+IGFzIGt2bV9jb25maWd1
cmVfbW11KCkgaXMgb25seSBjYWxsZWQgb25jZSBieSBWTVggb3IgU1ZNLCBpZiBJIHJlYWQgY29y
cmVjdGx5Lg0KPiA+ID4gDQo+ID4gPiB0ZHBfbW11X2FsbG93ZWQgaXMgbmVlZGVkIGJlY2F1c2Ug
a3ZtX2ludGVsIGFuZCBrdm1fYW1kIGFyZSBzZXBhcmF0ZQ0KPiA+ID4gbW9kdWxlcyBmcm9tIGt2
bS4gU28ga3ZtX2NvbmZpZ3VyZV9tbXUoKSBjYW4gYmUgY2FsbGVkIG11bHRpcGxlIHRpbWVzDQo+
ID4gPiAoZWFjaCB0aW1lIGt2bV9pbnRlbCBvciBrdm1fYW1kIGlzIGxvYWRlZCkuDQo+ID4gPiAN
Cj4gPiA+IA0KPiA+IA0KPiA+IEluZGVlZC4gOikNCj4gPiANCj4gPiBSZXZpZXdlZC1ieTogS2Fp
IEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiANCj4ga3ZtX2FyY2hfaW5pdCgpIHdoaWNo
IGlzIGNhbGxlZCBlYXJseSBkdXJpbmcgdGhlIG1vZHVsZSBpbml0aWFsaXphdGlvbiBiZWZvcmUN
Cj4ga3ZtX2NvbmZpZ3VyZV9tbXUoKSB2aWEga3ZtX2FyY2hfaGFyZHdhcmVfc2V0dXAoKSBjaGVj
a3MgaWYgdGhlIHZlbmRvciBtb2R1bGUNCj4gKGt2bV9pbnRlbCBvciBrdm1fYW1kKSB3YXMgYWxy
ZWFkeSBsb2FkZWQuICBJZiB5ZXMsIGl0IHJlc3VsdHMgaW4gLUVFWElTVC4NCj4gDQo+IFNvIGt2
bV9jb25maWd1cmVfbW11KCkgd29uJ3QgYmUgY2FsbGVkIHR3aWNlLg0KPiANCg0KSGkgSXNha3Us
DQoNClBsZWFzZSBjb25zaWRlciBtb2R1bGUgcmVsb2FkLg0KDQotLSANClRoYW5rcywNCi1LYWkN
Cg0KDQo=
