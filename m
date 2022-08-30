Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463D85A70E7
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 00:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiH3WkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 18:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiH3Wj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 18:39:56 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8209D12764;
        Tue, 30 Aug 2022 15:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661899194; x=1693435194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WtUs97Yky22o33BRcxCRz9hKqlwxoGIq7V2sw1kQh+s=;
  b=cZ30L4VTgqI1R8g2AIzMxpxDu6ehR+Ole65hC4xnM3ujFIrRsi3CNkJp
   VJsSyIW3IsVbtbQ2T7NsR1SGfA06XxxeFmbamDJijnJ3MQywnk5cD9u5g
   tHaiaKFxaYwpdQoYs7cbWv+sS2/ageiG4MZki/7h4kBsO4U0OV0tEnlUz
   IEyFD4WheiCAZcfZPAWPai4pOldrxLoAa6aipFOYvAfwIIoKRXKcWRWCU
   HEWclFGb9Cv/k7u9B39OLLw+ipRcfI7lP9sY70YfPVy8nvELQIJOm9mQF
   3995/VjU+X+IkFZoWmAfCtmA9XPbk9WfAZIoJ0LSIdgrsX1+ppmO5yMLL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="282295636"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="282295636"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 15:39:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="673087389"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 30 Aug 2022 15:39:53 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 15:39:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 15:39:53 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 15:39:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8uzzgPpIrx0ZBIyKio+fBX7LEaJUP7rb+Aiv+01HrrrH5zI1Ysh8deUB0NS1QNvNX1aUW0MZZQPuZeChWRHJDmz24mmxMRoeyxDSzWoxynnD/v3kRGLr80qp+jTehrnw4t3yLWOzcG9nntttl9GiGuvMw5TicJ6hpgqkxV0yn92CSwYugCHp3SB+vDSHyrifGEylMSiMjd70KSVxAOwb0HzKY1cT6BH9KtFJOOmPaZDLRkV3qw5NUr6WjGrDdfK3eXpLVFsTRpWAZYnwlYDg/EVuRpdx7Rin61m2m+36loRXEyY6shwGJtKkcLCOMmlJJaSrYQf0zTIGhYvNwkoOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtUs97Yky22o33BRcxCRz9hKqlwxoGIq7V2sw1kQh+s=;
 b=TDAk6y7kvtNrN/6SpBwC3tnLdXgewSlv5a0lmg/L5J3lr2XkkEDzDk7o2FjNz7s+7+QU8hlrxB78GYWhEW6I1wn0BIRHqttcQjFr1dQydZA6Epy4zj91xKICZtAwRYYCrwv6n6Xb3OAc9MvGRuZOhqqvDLQwWTKYQwTEdAfe5DePK8A6svS0OaXmrgXMd58D3G7DYyiaM/F+VAkFztXVArobFq/4rRVJPn4Uy/cgP8quc3ei5zEJty8jaqo/9B7Dr5iv3RcgbBgGrsZ3lKyBekpPsAPhuO6imSUboBq9AOc212xYcR3HiSusjtxUhGYVJpOk/YgBAQqe00tsZAYCWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by CH0PR11MB5562.namprd11.prod.outlook.com (2603:10b6:610:d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 30 Aug
 2022 22:39:48 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::fcf2:866:2eb0:b146]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::fcf2:866:2eb0:b146%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 22:39:48 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH v2 04/19] Partially revert "KVM: Pass kvm_init()'s opaque
 param to additional arch funcs"
Thread-Topic: [PATCH v2 04/19] Partially revert "KVM: Pass kvm_init()'s opaque
 param to additional arch funcs"
Thread-Index: AQHYvGhT6kJ+kaVNQ0GsqEJxVnlCLa3ICf+A
Date:   Tue, 30 Aug 2022 22:39:48 +0000
Message-ID: <7f3003465bc8e7a75d7e27a0928271210c5e2323.camel@intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
         <7f4a3ef13cc4b22aa77e8c5022e1710fd4189eff.1661860550.git.isaku.yamahata@intel.com>
In-Reply-To: <7f4a3ef13cc4b22aa77e8c5022e1710fd4189eff.1661860550.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b6fb7c2-d815-4763-5144-08da8ad88b5e
x-ms-traffictypediagnostic: CH0PR11MB5562:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n2w8tH9j8bzAolIuZ57AteIxQKBON3ojIKR86ORhYxexO+1vZHKi784F5p+9YJ+4U9/b0XyMHUVUuOUJqe+ViuVCgKC7izxrCObcp41ZuXVOj2je6mLFm8Yncy+t5AvXyS8UQC93IIXEkCrarXIdfjHUuG4oqNfBKWmchdir5rLCc2Obh2FU4ucvnC5oPR4jboHDs+3/7UnXy0p6pON4JjsW6Pd2DcqtHWlTH41MwdztdjQanx94NcmpK8W75N/a04Q/OcXwOrER6voXAaRPTsNmNN3dS3cIJaK7xHhYu1zAeLibCGnQ16Suaok0wtsLybhP83I0FUXE5/gnCSnj+wLnpVFEqnyn6XZQp70gmOe6cHPFZWmLZ0I03oyfbgGhbDhuC0jBJ2I5/gsyNnTOV6xocwLScopH6xFJy7dh+mjUPnuatBgoNApGa93WEqO6COHjyp3R16w5OPVejHqN1fjIcC/yQ2bZAKCauRySpcQnkKFP+QN7fMrB2+FnTNDRrA1LDJo0l/uJjmencgUX+isElSPml2aRs1p0lATd/2oX4V69BosHJbqjnzJfH2WuX0RIrN6MAtsaIm7MdOgy1rZBlB8pY06UZpJMDfqgYaLl2tovTprgSjTrngbTlfKCpjaN+fegzJBi4AIyZYnlcMyh91AKhX01/mUGF9U0+YO9ndccYDHTDvl3GKdGb7+kymaOKX43qZ0bIQdNYLcql+2Tk9FLkJfJU9ROq2djKoiUB8JFFcvo4KCRgvzHQXJCE4yaSa4O/gLGDxuUb55g/vCTquw63EGhIW1PGelkplk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(376002)(366004)(136003)(8676002)(66556008)(66946007)(66446008)(64756008)(4326008)(6486002)(478600001)(966005)(76116006)(26005)(6512007)(2906002)(6506007)(2616005)(41300700001)(83380400001)(8936002)(86362001)(5660300002)(186003)(66476007)(71200400001)(6636002)(54906003)(110136005)(82960400001)(38070700005)(316002)(122000001)(36756003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cURYRHF5VUh5M3pMRHRqdGxINXZxaWgxcHNUNmFpUyt4K25keElQbHM2OWVF?=
 =?utf-8?B?dys5MU1Tai9nc0tOUSt4bERWYWVsaWlLckVEODlCc0FxZ3lKZWlIcDhweU9S?=
 =?utf-8?B?NG1qMzFXdEhFd1FvWDdMN1hqNkhLSGNrZ1lkQ3IreEFwcWlhOW1pTnNVbzFL?=
 =?utf-8?B?VkdlbEprSUpnTEdaZk8wVVhvODYyeXAxUUFPdXpmYW1vZWFQK0tlUjRIRWxH?=
 =?utf-8?B?L0pyNHJLRWFoZUtZNTdOaUtSMkJwZUMrNm9qY1ltYVM4NWFTUlhPdEcyQ1I4?=
 =?utf-8?B?WVJJK2NTemk5TmpTTFQ2UVRZcG5yMGpxTGk4ZjFIYkNSSXFwc3ZON0M1akN0?=
 =?utf-8?B?Ynhxd0RDTGtmekU2RTR5anFaZ1E0YkwvVnR1VU10QjRONDB6bGJSZDlQZXF5?=
 =?utf-8?B?NnlVelBIajRnUjR1ZDFBK0NVeFhVMnhwWFFlL0UxWGZrZDZZV01FNkQ1VVI2?=
 =?utf-8?B?aXplZ3JMb0t0SDFBc0ZCOWo5K1Z5M0Rnd1lKMEhUaDZVaG5sTjlXOXE0T2ps?=
 =?utf-8?B?cjdpWk1yTUhsb3RnaEo0Sm05UzgzZS8zMkFFVk5nL1BpTWhERlMwMXlrRlNq?=
 =?utf-8?B?NkZQVDUxWUlkU2NiRC9qRUI4S2V4bzl2TWN3d0hGT3c5dTVqRm5pVFJQUE92?=
 =?utf-8?B?ckVwOERxN0hDZkV5cjh2QS9CMUc3Q25JdVMwVzRvWFAybS83dmFLbkk5SmhU?=
 =?utf-8?B?WGwxM0JvMVV6MEIyYXZCS01LM29mMmYwTkpNOS9MWmovOGFaRGhNUUtJbUFt?=
 =?utf-8?B?MnF5STdTb2NzTVd4R2t1VkZldTFmYTFTSHdKNzEraFFTeEpoNVZOSUhGS1JY?=
 =?utf-8?B?ZEFYOFUzU2ExMDhIcjE3WXM1RktyRTdGdWVlMEtxK2lXajVqZ2s5cmI0Q0ZN?=
 =?utf-8?B?OVFES002Q2lNLzJvR1JERG1PRkhqYkJ4MW51Z1Nla01UVytsNnRra1lCdU5C?=
 =?utf-8?B?U0VMMFE4T3U4U3ZuUXE0NFhuZTk1ZDQ1ZnJ3SWF5NUNjekhNVmJ3N2RlU25X?=
 =?utf-8?B?YWpsRS9iaVNIVXlFQ2NCTGlRQ1V1YnUrYW4vSE1jS0Z4eFBrelYrWmJaaFZE?=
 =?utf-8?B?OHU2SVRIcjh2dHF2VzlheTVNUnJXeXFhbVc0UU9malI0am1XMkVJTHlVOTFM?=
 =?utf-8?B?WEFlaElTZnBaVmgwVkJvcytFbXR1SzV1OEJpaW5ad2RoQzM0U08rRFZhQzc3?=
 =?utf-8?B?TjE4ZHFRdmRTWGwvT3NZY0xBSnU2cTVQMk10NGp4UnhGVHVKVHdxamJnWHFh?=
 =?utf-8?B?V01JYjZON1FyMmkyTnFpL3VWSU8wM08veUVxOVgwa0Vmbk5vRWM2T2JFdTc3?=
 =?utf-8?B?VHRYU3RYNHczSlFkNm0yUVFNZldTeExEU0NHM05KOEVzb0lPcXV6c2RMYWJQ?=
 =?utf-8?B?TDRBNURyNUh3N3B4VGVtMTErVnFiNDI5T21CTlpyWW5YdnNZMWFRam5qTGJu?=
 =?utf-8?B?NUJqOUJPS2VWTDk4MGdLWUtPdXZmSDRFN0N5SG1waEVMU3RHWk1IQnhpVVVT?=
 =?utf-8?B?MzlPdGpSdnFpY0c0MVhxWXdkWEZYY2RFZWdTVWtCTmhTNEYrT2tUamFzMHVS?=
 =?utf-8?B?eFV3V3owRDRFTm1leGlENy9JV1lXZXo2NXVLaW5nc2c0amRYQWsySzQrTDVv?=
 =?utf-8?B?TUVrL1laTjMyb2hxVjJST3FEQVVCZTZsQzFOajlxWFlEVFhrNDhuaGR5UklW?=
 =?utf-8?B?TzUrMGZXTHlTT3hSWEh1a0hjT2FZcFg4TFA3dXRLc1JNVVNzWENzbkZQNDlT?=
 =?utf-8?B?akhITnBzSnlSdENaTk5oK0pQR1g3WHpZdnhaTkttWW56dUhmbWFSVC9vNlp6?=
 =?utf-8?B?a1VldmNJK2tUREt2QjRnWmpWeklQcWNoeWJPc0IvOEYyVHVQaUkxczdWb3cr?=
 =?utf-8?B?UFQ1c0JqaHllUnh3bGp2WEVKRFN2TnRqYXE5WGl1cmN1Sk01NnRaTURqZXZs?=
 =?utf-8?B?dkx5SGV0WWNsQXk3SzFJcDdQZFhUSnZ2SmErNlY1TkNML1FWZHRzRFRjYzlN?=
 =?utf-8?B?UG56SjhUUnR0dVR6TDhyZlJnYU9QOTZtaitjU0Vud0paTlFuem91bGtyM0hz?=
 =?utf-8?B?SHhjZEZ1UTk5N2YwSEgxUHhWMFVNM2dudkh6emJxUzJ6R1BkV0U4anZFZFhW?=
 =?utf-8?B?aldxT1FKeHI4ZGgyRXFqZUJKUTMvaEpxNDh4SDBodVl6cWU2S05ZZCtpY2tV?=
 =?utf-8?B?bmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6D0CD4E3FDF0D45AD074E89B6DC147C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6fb7c2-d815-4763-5144-08da8ad88b5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 22:39:48.1973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LekSQn6Ov/wud1m+y5L7TVnGRuaLBAakZHEPsrISCmqhqZM/rI0YlmaRDhYGImk6SATwewtnzapcjrO2yoawng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5562
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTMwIGF0IDA1OjAxIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IA0KPiBU
aGlzIHBhcnRpYWxseSByZXZlcnRzIGNvbW1pdCBiOTkwNDA4NTM3MzggKCJLVk06IFBhc3Mga3Zt
X2luaXQoKSdzIG9wYXF1ZQ0KPiBwYXJhbSB0byBhZGRpdGlvbmFsIGFyY2ggZnVuY3MiKSByZW1v
dmUgb3BhcXVlIGZyb20NCj4ga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCBiZWNhdXNl
IG5vIG9uZSB1c2VzIHRoaXMgb3BhcXVlIG5vdy4NCj4gQWRkcmVzcyBjb25mbGljdHMgZm9yIEFS
TSAoZHVlIHRvIGZpbGUgbW92ZW1lbnQpIGFuZCBtYW51YWxseSBoYW5kbGUgUklTQy1WDQo+IHdo
aWNoIGNvbWVzIGFmdGVyIHRoZSBjb21taXQuICBUaGUgY2hhbmdlIGFib3V0IGt2bV9hcmNoX2hh
cmR3YXJlX3NldHVwKCkNCj4gaW4gb3JpZ2luYWwgY29tbWl0IGFyZSBzdGlsbCBuZWVkZWQgc28g
dGhleSBhcmUgbm90IHJldmVydGVkLg0KPiANCj4gVGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24g
ZW5hYmxlcyBoYXJkd2FyZSAoZS5nLiBlbmFibGUgVk1YIG9uIGFsbCBDUFVzKSwNCj4gYXJjaC1z
cGVjaWZpYyBpbml0aWFsaXphdGlvbiBmb3IgdGhlIGZpcnN0IFZNIGNyZWF0aW9uLCBhbmQgZGlz
YWJsZXMNCj4gaGFyZHdhcmUgKGluIHg4NiwgZGlzYWJsZSBWTVggb24gYWxsIENQVXMpIGZvciBs
YXN0IFZNIGRlc3RydWN0aW9uLg0KPiANCj4gVG8gc3VwcG9ydCBURFgsIGhhcmR3YXJlX2VuYWJs
ZV9hbGwoKSB3aWxsIGJlIGRvbmUgZHVyaW5nIG1vZHVsZSBsb2FkaW5nDQo+IHRpbWUuICBBcyBh
IHJlc3VsdCwgQ1BVIGNvbXBhdGliaWxpdHkgY2hlY2sgd2lsbCBiZSBvcHBvcnR1bmlzdGljYWxs
eSBtb3ZlZA0KPiB0byBoYXJkd2FyZV9lbmFibGVfbm9sb2NrKCksIHdoaWNoIGRvZXNuJ3QgdGFr
ZSBhbnkgYXJndW1lbnQuICBJbnN0ZWFkIG9mDQo+IHBhc3NpbmcgJ29wYXF1ZScgYXJvdW5kIHRv
IGhhcmR3YXJlX2VuYWJsZV9ub2xvY2soKSBhbmQNCj4gaGFyZHdhcmVfZW5hYmxlX2FsbCgpLCBq
dXN0IHJlbW92ZSB0aGUgdW51c2VkICdvcGFxdWUnIGFyZ3VtZW50IGZyb20NCj4ga3ZtX2FyY2hf
Y2hlY2tfcHJvY2Vzc29yX2NvbXBhdCgpLg0KDQpUaGlzIHBhdGNoIG5vdyBpcyBub3QgcGFydCBv
ZiBURFgncyBzZXJpZXMsIHNvIGl0IGRvZXNuJ3QgbWFrZSBhIGxvdCBzZW5zZSB0bw0KcHV0IHRo
ZSBsYXN0IHR3byBwYXJhZ3JhcGhzIGhlcmUgKGJlY2F1c2UgdGhlIHB1cnBvc2UgaXMgZGlmZmVy
ZW50KS4gIEkgdGhpbmsNCnlvdSBjYW4ganVzdCB1c2UgQ2hhbydzIG9yaWdpbmFsIHBhdGNoLg0K
DQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+
IFJldmlld2VkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IFN1enVraSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+DQo+
IEFja2VkLWJ5OiBBbnVwIFBhdGVsIDxhbnVwQGJyYWluZmF1bHQub3JnPg0KPiBBY2tlZC1ieTog
Q2xhdWRpbyBJbWJyZW5kYSA8aW1icmVuZGFAbGludXguaWJtLmNvbT4NCj4gTGluazogaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIyMDIxNjAzMTUyOC45MjU1OC0zLWNoYW8uZ2FvQGludGVs
LmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50
ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
PiAtLS0NCj4gIGFyY2gvYXJtNjQva3ZtL2FybS5jICAgICAgIHwgIDIgKy0NCj4gIGFyY2gvbWlw
cy9rdm0vbWlwcy5jICAgICAgIHwgIDIgKy0NCj4gIGFyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5j
IHwgIDIgKy0NCj4gIGFyY2gvcmlzY3Yva3ZtL21haW4uYyAgICAgIHwgIDIgKy0NCj4gIGFyY2gv
czM5MC9rdm0va3ZtLXMzOTAuYyAgIHwgIDIgKy0NCj4gIGFyY2gveDg2L2t2bS94ODYuYyAgICAg
ICAgIHwgIDIgKy0NCj4gIGluY2x1ZGUvbGludXgva3ZtX2hvc3QuaCAgIHwgIDIgKy0NCj4gIHZp
cnQva3ZtL2t2bV9tYWluLmMgICAgICAgIHwgMTYgKysrLS0tLS0tLS0tLS0tLQ0KPiAgOCBmaWxl
cyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2t2bS9hcm0uYyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jDQo+IGlu
ZGV4IDJmZjBlZjYyYWJhZC4uMzM4NWZiNTdjMTFhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0
L2t2bS9hcm0uYw0KPiArKysgYi9hcmNoL2FybTY0L2t2bS9hcm0uYw0KPiBAQCAtNjgsNyArNjgs
NyBAQCBpbnQga3ZtX2FyY2hfaGFyZHdhcmVfc2V0dXAodm9pZCAqb3BhcXVlKQ0KPiAgCXJldHVy
biAwOw0KPiAgfQ0KPiAgDQo+IC1pbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2
b2lkICpvcGFxdWUpDQo+ICtpbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lk
KQ0KPiAgew0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL2t2
bS9taXBzLmMgYi9hcmNoL21pcHMva3ZtL21pcHMuYw0KPiBpbmRleCBhMjVlMGI3M2VlNzAuLjA5
MmQwOWZiNmE3ZSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9taXBzL2t2bS9taXBzLmMNCj4gKysrIGIv
YXJjaC9taXBzL2t2bS9taXBzLmMNCj4gQEAgLTE0MCw3ICsxNDAsNyBAQCBpbnQga3ZtX2FyY2hf
aGFyZHdhcmVfc2V0dXAodm9pZCAqb3BhcXVlKQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+
IC1pbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkICpvcGFxdWUpDQo+ICtp
bnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkKQ0KPiAgew0KPiAgCXJldHVy
biAwOw0KPiAgfQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMgYi9h
cmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMuYw0KPiBpbmRleCBmYjE0OTA3NjFjODcuLjdiNTZkNmNj
ZmRmYiAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMNCj4gKysrIGIv
YXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMNCj4gQEAgLTQ0Nyw3ICs0NDcsNyBAQCBpbnQga3Zt
X2FyY2hfaGFyZHdhcmVfc2V0dXAodm9pZCAqb3BhcXVlKQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0K
PiAgDQo+IC1pbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkICpvcGFxdWUp
DQo+ICtpbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkKQ0KPiAgew0KPiAg
CXJldHVybiBrdm1wcGNfY29yZV9jaGVja19wcm9jZXNzb3JfY29tcGF0KCk7DQo+ICB9DQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2t2bS9tYWluLmMgYi9hcmNoL3Jpc2N2L2t2bS9tYWluLmMN
Cj4gaW5kZXggMTU0OTIwNWZlNWZlLi5mOGQ2MzcyZDIwOGYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gv
cmlzY3Yva3ZtL21haW4uYw0KPiArKysgYi9hcmNoL3Jpc2N2L2t2bS9tYWluLmMNCj4gQEAgLTIw
LDcgKzIwLDcgQEAgbG9uZyBrdm1fYXJjaF9kZXZfaW9jdGwoc3RydWN0IGZpbGUgKmZpbHAsDQo+
ICAJcmV0dXJuIC1FSU5WQUw7DQo+ICB9DQo+ICANCj4gLWludCBrdm1fYXJjaF9jaGVja19wcm9j
ZXNzb3JfY29tcGF0KHZvaWQgKm9wYXF1ZSkNCj4gK2ludCBrdm1fYXJjaF9jaGVja19wcm9jZXNz
b3JfY29tcGF0KHZvaWQpDQo+ICB7DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IGRpZmYgLS1naXQg
YS9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMgYi9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMNCj4g
aW5kZXggZWRmZDRiYmQwY2JhLi5lMjZkNGRkODU2NjggMTAwNjQ0DQo+IC0tLSBhL2FyY2gvczM5
MC9rdm0va3ZtLXMzOTAuYw0KPiArKysgYi9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMNCj4gQEAg
LTI1NCw3ICsyNTQsNyBAQCBpbnQga3ZtX2FyY2hfaGFyZHdhcmVfZW5hYmxlKHZvaWQpDQo+ICAJ
cmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gLWludCBrdm1fYXJjaF9jaGVja19wcm9jZXNzb3JfY29t
cGF0KHZvaWQgKm9wYXF1ZSkNCj4gK2ludCBrdm1fYXJjaF9jaGVja19wcm9jZXNzb3JfY29tcGF0
KHZvaWQpDQo+ICB7DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gaW5kZXggOTg1NDg3ZmUwZDYzLi5j
YTkyMGI2YjkyNWQgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiArKysgYi9h
cmNoL3g4Ni9rdm0veDg2LmMNCj4gQEAgLTExOTk0LDcgKzExOTk0LDcgQEAgdm9pZCBrdm1fYXJj
aF9oYXJkd2FyZV91bnNldHVwKHZvaWQpDQo+ICAJc3RhdGljX2NhbGwoa3ZtX3g4Nl9oYXJkd2Fy
ZV91bnNldHVwKSgpOw0KPiAgfQ0KPiAgDQo+IC1pbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29y
X2NvbXBhdCh2b2lkICpvcGFxdWUpDQo+ICtpbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2Nv
bXBhdCh2b2lkKQ0KPiAgew0KPiAgCXN0cnVjdCBjcHVpbmZvX3g4NiAqYyA9ICZjcHVfZGF0YShz
bXBfcHJvY2Vzc29yX2lkKCkpOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2
bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgNCj4gaW5kZXggZjQ1MTlkMzY4OWUx
Li5lYWIzNTI5MDJkZTcgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0K
PiArKysgYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgNCj4gQEAgLTE0MzgsNyArMTQzOCw3IEBA
IGludCBrdm1fYXJjaF9oYXJkd2FyZV9lbmFibGUodm9pZCk7DQo+ICB2b2lkIGt2bV9hcmNoX2hh
cmR3YXJlX2Rpc2FibGUodm9pZCk7DQo+ICBpbnQga3ZtX2FyY2hfaGFyZHdhcmVfc2V0dXAodm9p
ZCAqb3BhcXVlKTsNCj4gIHZvaWQga3ZtX2FyY2hfaGFyZHdhcmVfdW5zZXR1cCh2b2lkKTsNCj4g
LWludCBrdm1fYXJjaF9jaGVja19wcm9jZXNzb3JfY29tcGF0KHZvaWQgKm9wYXF1ZSk7DQo+ICtp
bnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkKTsNCj4gIGludCBrdm1fYXJj
aF92Y3B1X3J1bm5hYmxlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ICBib29sIGt2bV9hcmNo
X3ZjcHVfaW5fa2VybmVsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ICBpbnQga3ZtX2FyY2hf
dmNwdV9zaG91bGRfa2ljayhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiBkaWZmIC0tZ2l0IGEv
dmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gaW5kZXggNTg0YTVi
YWIzYWYzLi40MjQzYTk1NDE1NDMgMTAwNjQ0DQo+IC0tLSBhL3ZpcnQva3ZtL2t2bV9tYWluLmMN
Cj4gKysrIGIvdmlydC9rdm0va3ZtX21haW4uYw0KPiBAQCAtNTc5OSwyMiArNTc5OSwxNCBAQCB2
b2lkIGt2bV91bnJlZ2lzdGVyX3BlcmZfY2FsbGJhY2tzKHZvaWQpDQo+ICB9DQo+ICAjZW5kaWYN
Cj4gIA0KPiAtc3RydWN0IGt2bV9jcHVfY29tcGF0X2NoZWNrIHsNCj4gLQl2b2lkICpvcGFxdWU7
DQo+IC0JaW50ICpyZXQ7DQo+IC19Ow0KPiAtDQo+IC1zdGF0aWMgdm9pZCBjaGVja19wcm9jZXNz
b3JfY29tcGF0KHZvaWQgKmRhdGEpDQo+ICtzdGF0aWMgdm9pZCBjaGVja19wcm9jZXNzb3JfY29t
cGF0KHZvaWQgKnJ0bikNCj4gIHsNCj4gLQlzdHJ1Y3Qga3ZtX2NwdV9jb21wYXRfY2hlY2sgKmMg
PSBkYXRhOw0KPiAtDQo+IC0JKmMtPnJldCA9IGt2bV9hcmNoX2NoZWNrX3Byb2Nlc3Nvcl9jb21w
YXQoYy0+b3BhcXVlKTsNCj4gKwkqKGludCAqKXJ0biA9IGt2bV9hcmNoX2NoZWNrX3Byb2Nlc3Nv
cl9jb21wYXQoKTsNCj4gIH0NCj4gIA0KPiAgaW50IGt2bV9pbml0KHZvaWQgKm9wYXF1ZSwgdW5z
aWduZWQgdmNwdV9zaXplLCB1bnNpZ25lZCB2Y3B1X2FsaWduLA0KPiAgCQkgIHN0cnVjdCBtb2R1
bGUgKm1vZHVsZSkNCj4gIHsNCj4gLQlzdHJ1Y3Qga3ZtX2NwdV9jb21wYXRfY2hlY2sgYzsNCj4g
IAlpbnQgcjsNCj4gIAlpbnQgY3B1Ow0KPiAgDQo+IEBAIC01ODQyLDEwICs1ODM0LDggQEAgaW50
IGt2bV9pbml0KHZvaWQgKm9wYXF1ZSwgdW5zaWduZWQgdmNwdV9zaXplLCB1bnNpZ25lZCB2Y3B1
X2FsaWduLA0KPiAgCWlmIChyIDwgMCkNCj4gIAkJZ290byBvdXRfZnJlZV8xOw0KPiAgDQo+IC0J
Yy5yZXQgPSAmcjsNCj4gLQljLm9wYXF1ZSA9IG9wYXF1ZTsNCj4gIAlmb3JfZWFjaF9vbmxpbmVf
Y3B1KGNwdSkgew0KPiAtCQlzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUoY3B1LCBjaGVja19wcm9j
ZXNzb3JfY29tcGF0LCAmYywgMSk7DQo+ICsJCXNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZShjcHUs
IGNoZWNrX3Byb2Nlc3Nvcl9jb21wYXQsICZyLCAxKTsNCj4gIAkJaWYgKHIgPCAwKQ0KPiAgCQkJ
Z290byBvdXRfZnJlZV8yOw0KPiAgCX0NCg0K
