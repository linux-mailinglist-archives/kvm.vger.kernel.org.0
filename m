Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504FC5F58D2
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 19:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiJERJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 13:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJERJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 13:09:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50ECEE0A
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 10:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664989788; x=1696525788;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H9IaEdSOWBEAiF0JlbNlS9K0YXjOCbyojZpRTRPeGjU=;
  b=D0L4Ahel4L+4w0q29U+eJXCmkGWuDuhS/pSbHI7gZM71fzMITsWjmzlV
   tgpBw69/6ENkNWk/T83B2APnEryIFIbyMLAnjjFyc5i6TYG+7TIUpO4YK
   FSlrIXUyHh4TM+R2ulqf+wnTFYZZ4+ODqhgPMQ+UgUw2JrEkHwZVcWLAB
   q0kG41SX7vSdj6bKU6PEUnMYVf1V872wfS2VL3/kM2oEqhnEB4m1cnBNQ
   ZfmAhobzq1fCly8cUDMS0XWyoxjV8sORqa2l1m2ite+qD6K0FDZxWY2Ga
   bww9EicNIFGWDPnHq8kDdnLya/Xph+mBwjsFxHaE4GnlAKtNfKUbNwQPS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="283583696"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="283583696"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 10:09:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="655240619"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="655240619"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 05 Oct 2022 10:09:48 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 10:09:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 5 Oct 2022 10:09:47 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 5 Oct 2022 10:09:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mm2V/OSLHRFx9aacV+LyMYHwCkDo0Ujugz/MDst13ew2aB539gA24eeDTMSUzjozQk66XZeaWosWrDLyLiiHoPcHD7khy1IkwLmGsP3CbEw5+ER6foQ2T8tki1kUsxsIXgCM903tar2s6tsdWN4NprIIVU7uz3J6e0yyGIcM8mo6yW4OWh2bU5NciU7VRsJKW8rNGldB2GeM5j1kNQru1y9wwE0BKEmSLlt30JNgDBlos3yEcfbEUgxfWtmgX96dEIkWjLS44s7pKF7F19xT57daVV/6rWB6s9wwPfB304l/KnlkmVU43ccLmC2b38Qnb6BMMLe0Bjay1yq06h+Ttg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9IaEdSOWBEAiF0JlbNlS9K0YXjOCbyojZpRTRPeGjU=;
 b=bX8QUpRwlneubddiZQwlPQiwou5vDrTyZi0BrGsSSxkpwhWNn8ZEMGBL26eA/JUflbgGj4fxHXgi+KbgOjgg8NfprRrAk+wXupw9PmxHp9ha0iUwiSKOp7UeiLWZ26eWUsLkEbMKV5XuP3yVb1i5EL9C+mCPi03FyUcVbT94NayOvssIxWazRCCAY/xHZMbfnFGI/ktAjz0Vow9pQvBZi9BB6b4aBtiO3PVQzKlVvnvrYMWAF/iu4HWRzoyACDEhubI0ylPXf/7e4L3FsJxuOSa4IewKO2nd2Q1cE1XXH/J3upJar5AzgPfu9WseQ8e0IidtkJNwHS2HJZXlsWpcfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 17:09:45 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5%3]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 17:09:44 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Topic: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Index: AQHY1FYuEs8BAKsu5UCBOzB/nmNIY634etfwgAAg0oCAAAmBoIAADbaAgARdgACAABF6gIABzqOwgAAztgCAAO13oA==
Date:   Wed, 5 Oct 2022 17:09:44 +0000
Message-ID: <BL0PR11MB3042B81532FCC9F1F45AD8F68A5D9@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-2-jmattson@google.com>
 <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com>
 <BL0PR11MB30421511435BFEF36E482AC28A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eTNeeCNt=xMFBKSnXV+ReSXR=D11BQACS3Gwm7my+6sHA@mail.gmail.com>
 <BL0PR11MB3042784D7E66686207D679268A5B9@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eRJOHwh1twmS5X+ooGQqn+y0YrNXgJoB7UhMb+nUa+EFw@mail.gmail.com>
 <BL0PR11MB30426E91DB220599F53F577F8A5D9@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eS0-j7mV8M-G30XqR3wyLhoOK3JEs5PYag7s-3fVMd=5w@mail.gmail.com>
In-Reply-To: <CALMp9eS0-j7mV8M-G30XqR3wyLhoOK3JEs5PYag7s-3fVMd=5w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|SA0PR11MB4541:EE_
x-ms-office365-filtering-correlation-id: 4b57f7fb-41ce-4281-290d-08daa6f4668c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kl1/NRZqNf0tzglrtDVTyyqWOGjkRVY0RvZlVuFVc2pJ2M7OIbTfMHnmcohFFuqXePZO5hN/7n4usTA2RnOb5oQbJmz3kzqjckD4D2CkxQFdfY20a7rjbrEMFuIiTm3WNPkXmsJ8O8taLkRgjAaYgOPoy0hzGuWua7Q0iqfY/xTS5263ItxG17OzwK/ilTEYuNvcRuX+j71zuliRxwJ+LOyEMDXMjyIXhdighUhgQtwrAdmIamDkXuDE+3nCfXAVt+ZY9GFpZ8oR5USVfTGat5BBCMO8cB3DwBOSIF4Z4OYMAkGaRtfJIo8DG2nY+WrqolALfZKe8NSOAZ814/Owtk8EwrHWVqSBmvmRsi/AfLLPJTIihgBqojYOqhv/vHojU93/j6EaOUK4t9jHo5CRxyBtnaTcW8Jv4MoZGHXZ2XcLiAmguI9FbsGcXVJHezry4WB6qdmaNlanWXIjcEmxx1VUBNwKbB4LOAY/hm6Lx0GMeQGpNtBV+DEE01QvkHdKW/+a006WpaERa+DlJ6RfYIUuvOaA4Amb2MxPLgraGG21aa6Gbr+YArArJCOMpTh35pL3RkF8mNuQkE1HcQsHocBvAdXl1w39vVOLspk5OctwD92q28zZzVT8jHIBfKwZQ+krtrkhu31ZOOqn1FcF7i2OwVWkSWcfnFBacmnKZlUTPfbu6KAR7u2gUaYbZQSgGGqUdj1ytP61ifNUhIHtreeti5C5BxoeoiaOvfoxJQdyjLmmQvrFpmSx3vUas1zOvegdP74oMpPBhpwlb7BDTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(8676002)(66556008)(66476007)(66446008)(64756008)(4326008)(66946007)(76116006)(316002)(54906003)(6916009)(186003)(55016003)(86362001)(8936002)(478600001)(52536014)(5660300002)(38070700005)(71200400001)(38100700002)(41300700001)(2906002)(122000001)(26005)(33656002)(9686003)(82960400001)(83380400001)(53546011)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHJld29DZ1d6TlBJWXdlZm83MHBXZ3pZMkFzdFJrK3JXbnBZbGswUy9BaGpP?=
 =?utf-8?B?dUNHOXgrWUlydU5WUjE3WjZjSWdxTDJPYm5NdEVoUFcrT0hDWVMrTjYxU29q?=
 =?utf-8?B?dGRXQ3paaCt0eGxIcURIaE5KUjd5YXBBZU1pblpCNHFWcEdtYmx2VFNMMm10?=
 =?utf-8?B?cjRtV3h0eUtUbE54UDBZa1NYVnNzUmFCaSs1TWJRcmthOWRHajE1WFdrYVo4?=
 =?utf-8?B?ajR6N1UzN1VHVUhRaWJQN21YWFMzV0NBSElCSFFORG1QY21nYmJKZWIvRXAw?=
 =?utf-8?B?UlZjKzZFcEVubTJFSmZ3UEtWNGpaM0pmblJTZjNMOWlBdTQ1ZDdnc0c5ZGdx?=
 =?utf-8?B?VngwNTNieEpJcHlzY1BxdytwQ2I0WU02ZVpaVWo4ekFTOVRxWFJhN1YveFJz?=
 =?utf-8?B?d1JxUHE5L2w4Vjg1dnEwVmE2VmhpY2NkN09Kai9DK0VCVitYYmp2ZWdGdkVk?=
 =?utf-8?B?dWhXaUQvclAxWWpCQ3Q2MjVLaW1Ld3J2U2JSckZTWUJtUDZpdTgwOFJ0S1d4?=
 =?utf-8?B?U1lsZGpZLzBjZWFhelJRTkg3bFBob3BmQjBYQ3ZwaVo1WVpOODBnYnlVUGd6?=
 =?utf-8?B?bVV2bU4vOWlWdkhqaVFOaGNIKzdmcWg5b3dPbzdwd01MRjZobnJTYUNJUFha?=
 =?utf-8?B?MGdzQSs1RmE4OG5CZHNvbFlHamhuT1Z6QTRZMnlGYzZFSE1hTUErckNxVFRo?=
 =?utf-8?B?RExCY05WdWhmMEs5bnk5dFRhMmxuaDJxVVY1R05DZk90amJqcWVTSXBWRy9j?=
 =?utf-8?B?OHdGdW40T0pJWEFHdGNmbGwvUWJ1akpkMUZ1NDJXZWF1cTkxYzFoN08zRmFG?=
 =?utf-8?B?TFZYN1dBV1huYm9uWGdQdys1YU1jeFVxa0tFamMwN3RTdzdodnR1NW95c1dD?=
 =?utf-8?B?Q20zNEl5em5ncnlUTGJNOGFpS1pRQ3YrU29QWWVUM0FZY2FCSHpLbVMxSVIv?=
 =?utf-8?B?QTNPamdhSXpZL3FXb0tseGtEaURQV3ZWd1htT3dmZ2ZSV1QvK1RKUUJCbHFr?=
 =?utf-8?B?ZTVBT3RqMjRtN1BMSHlpb21EVlJlL1VmYWpyYU9LSCtWTXAwZ3E0Wm9nYlFD?=
 =?utf-8?B?U3hiZDd6aDJoQ3pUTEZMYWRBTkdGU0VKU3dsQXlUbzRkdjliNldPdmxZOUJV?=
 =?utf-8?B?K2FoY3M3VGoxWEEzQkdiNTlIUUhDK2t6RW9zM1RPS0hJKzRXbmxIQ25iSm1Z?=
 =?utf-8?B?ZEtGbm9yTVkwalF4VWVibWFJeTBjS1RockNXdkZLTEFZRGhGaUlFK05IdFRo?=
 =?utf-8?B?RVdwOG40U0RtdEN0eUZ0bFRsNGZDRm5kT2dReWxhZjZzVzcvNUZBcWl0VnQ5?=
 =?utf-8?B?WHpTOWNQY1VKZmpzR00xOGZENVNaQndiU3RBcHUyMU52TlJpN2dRZFllbEE3?=
 =?utf-8?B?WnJmR3hsT1grdFdteVNUS21iRm95dGw3QmxEU3E3cWJpTVZxYVlJWFF3Wm43?=
 =?utf-8?B?YXhYaHhJVGg1aVVzb3VuU0MxYXpUZmZkSjFjQkZUbEUrNC8wZ0JjUWNXWk9I?=
 =?utf-8?B?SzZxRXBQdlBZbksrZWdEekxBbFNWbkVLdnp0ZUoyNWZoNERSUWtRNmp2ZVZ0?=
 =?utf-8?B?ZHBWdWZieHRXcTFKNkx1VEo5a3Mzd05BengzUGpnRVVka3NWUjZ3L0JqeXdP?=
 =?utf-8?B?ZjlYemNWTmpHQXFxZFB1emFFZ1RrWEdYUjVMbGFCQ1Q0WHVYd1dBODVRcm0w?=
 =?utf-8?B?Y0tPYmVaUm1SUGVmcGZMOHlEdTJpSUI5OUR3RW1TbjJrQ2xtR2ZJRDVFcmlV?=
 =?utf-8?B?Y21lUUdUdnpqcEJEMEkzRllwd3BlZHBYRklKaGRiUXNnQmxNem92WkJySjAr?=
 =?utf-8?B?VzRveDFpZmV2MHEvV2k0NjhaUUNoRDB2S29rY2FWUXpoZkZuRllpMnpja3lo?=
 =?utf-8?B?RVFLYUZPNUlmdzI3VFp1Q3BodEhKUWJFY1lwNExyajQ3a1luSnBuQVFySGVQ?=
 =?utf-8?B?Y1BHM2RhSUlRQnVmRklNRjkwcjNHMm1pSkUxaWdaR2IzYisxNVA1ejJmbU5T?=
 =?utf-8?B?TVVhUm50SUtIRnJkYVB5bWtJTHF1VnNyeWdaL0ZsVWZHbDI0R0xLc0UxQWxx?=
 =?utf-8?B?b2R1YWszeHFTMnR4VUkwa0MzcFBjYU1WWndnbm9lblpxV3BFU29oR0FMaWpU?=
 =?utf-8?Q?5Xx/pGrmAa/XSjQpCNohGYthi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b57f7fb-41ce-4281-290d-08daa6f4668c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2022 17:09:44.8414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rOjNDpRcB3EAfcbObCHFFXVxMZ/upaIE0Oefg5gsc3p9biFSO+CrktVo2CRaIcY8ibxIltsZ6Sjp8IjBey+uHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SSBzZWUuIFRoYW5rcyBKaW0hDQpJdCBtYWtlcyBzZW5zZS4NCkVkZGllDQoNCj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmltIE1hdHRzb24gPGptYXR0c29uQGdvb2dsZS5j
b20+DQo+IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIgNCwgMjAyMiA3OjU5IFBNDQo+IFRvOiBEb25n
LCBFZGRpZSA8ZWRkaWUuZG9uZ0BpbnRlbC5jb20+DQo+IENjOiBrdm1Admdlci5rZXJuZWwub3Jn
OyBwYm9uemluaUByZWRoYXQuY29tOyBDaHJpc3RvcGhlcnNvbiwsIFNlYW4NCj4gPHNlYW5qY0Bn
b29nbGUuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDIvNl0gS1ZNOiB4ODY6IE1hc2sgb2Zm
IHJlc2VydmVkIGJpdHMgaW4NCj4gQ1BVSUQuODAwMDAwMDZIDQo+IA0KPiBPbiBUdWUsIE9jdCA0
LCAyMDIyIGF0IDU6MDggUE0gRG9uZywgRWRkaWUgPGVkZGllLmRvbmdAaW50ZWwuY29tPiB3cm90
ZToNCj4gPg0KPiA+ID4gSGFyZHdhcmUgcmVzZXJ2ZWQgQ1BVSUQgYml0cyBhcmUgYWx3YXlzIHpl
cm8gdG9kYXksIHRob3VnaCB0aGF0IG1heQ0KPiA+ID4gbm90IGJlIGFyY2hpdGVjdHVyYWxseSBz
cGVjaWZpZWQuDQo+ID4NCj4gPiBlbnRyeS0+ZWR4IGlzIGluaXRpYWxpemVkIHRvIG5hdGl2ZSB2
YWx1ZSBpbiBkb19ob3N0X2NwdWlkKCksIHdoaWNoIGV4ZWN1dGVzDQo+IHBoeXNpY2FsIENQVUlE
Lg0KPiA+IEkgZ3Vlc3MgSSBhbSBkaXNjb25uZWN0ZWQgaGVyZS4NCj4gDQo+IEhhcmR3YXJlIHZh
bHVlcyBzaG91bGQgb25seSBiZSBwYXNzZWQgdGhyb3VnaCBmb3IgZmVhdHVyZXMgdGhhdCBLVk0g
Y2FuDQo+IHN1cHBvcnQuIFJlc2VydmVkIGJpdHMgc2hvdWxkIGJlIHNldCB0byAwLCBiZWNhdXNl
IEtWTSBoYXMgbm8gaWRlYSB3aGV0aGVyDQo+IG9yIG5vdCBpdCB3aWxsIGJlIGFibGUgdG8gc3Vw
cG9ydCB0aGVtIG9uY2UgdGhleSBhcmUgZGVmaW5lZC4NCj4gDQo+IFBlcmhhcHMgYW4gZXhhbXBs
ZSB3aWxsIGhlbHAuDQo+IA0KPiBBdCBvbmUgdGltZSwgbGVhZiA3IHdhcyBjb21wbGV0ZWx5IHJl
c2VydmVkLiBGb2xsb3dpbmcgdGhlIHByaW5jaXBsZSB0aGF0IEtWTQ0KPiBzaG91bGQgbm90IHBh
c3MgdGhyb3VnaCByZXNlcnZlZCBDUFVJRCBiaXRzLCBLVk0gemVyb2VkIG91dCB0aGlzIGxlYWYg
cHJpb3IgdG8NCj4gY29tbWl0IDYxMWMxMjBmNzQ4NiAoIktWTTogTWFzayBmdW5jdGlvbjcgZWJ4
IGFnYWluc3QgaG9zdCBjYXBhYmlsaXR5DQo+IHdvcmQ5IikuDQo+IFN1cHBvc2UgdGhhdCB0aGUg
bGVnYWN5IEtWTSBoYWQsIGFzIHlvdSBzdWdnZXN0LCBwYXNzZWQgdGhyb3VnaCB0aGUNCj4gaGFy
ZHdhcmUgdmFsdWVzIGZvciBsZWFmIDcuIEFzIENQVXMgYXBwZWFyZWQgd2l0aCBTTUVQLCBTTUFQ
LCBJbnRlbA0KPiBQcm9jZXNzb3IgVHJhY2UsIFNHWCwgYW5kIGEgd2hvbGUgc2xldyBvZiBvdGhl
ciBmZWF0dXJlcywgdGhhdCB2ZXJzaW9uIG9mIEtWTQ0KPiB3b3VsZCBjbGFpbSB0aGF0IGl0IHN1
cHBvcnRlZCB0aG9zZSBmZWF0dXJlcy4gTm90IHRydWUuDQo+IA0KPiBIb3cgd291bGQgdXNlcnNw
YWNlIGJlIGFibGUgdG8gdGVsbCBhIHZlcnNpb24gb2YgS1ZNIHRoYXQgY291bGQgcmVhbGx5IHN1
cHBvcnQNCj4gU01FUCBmcm9tIG9uZSB0aGF0IGp1c3QgYmxpbmRseSBwYXNzZWQgdGhlIGJpdCB0
aHJvdWdoIHdpdGhvdXQga25vd2luZyB3aGF0DQo+IGl0IG1lYW50PyBUaGUgS1ZNX0dFVF9TVVBQ
T1JURURfQ1BVSUQgcmVzdWx0cyB3b3VsZCBiZSBpZGVudGljYWwuDQo+IA0KPiBJbiBzb21lIGNh
c2VzLCBpZiBLVk0gY2xhaW1zIHRvIHN1cHBvcnQgYSBmZWF0dXJlIHRoYXQgaXQgZG9lc24ndCAo
bGlrZSBTTUVQKSwgYQ0KPiBndWVzdCB0aGF0IHRyaWVzIHRvIHVzZSB0aGUgZmVhdHVyZSB3aWxs
IGZhaWwgdG8gYm9vdCAoZS5nLiBzZXR0aW5nIENSNC5TTUVQIHdpbGwNCj4gcmFpc2UgYW4gdW5l
eHBlY3RlZCAjR1ApLg0KPiANCj4gSG93ZXZlciwgYXMgeW91IGFsbHVkZWQgdG8gZWFybGllciwg
emVyb2luZyBvdXQgcmVzZXJ2ZWQgYml0cyBkb2VzIG5vdCBhbHdheXMNCj4gd29yayBvdXQuIEFn
YWluLCBsb29raW5nIGF0IGxlYWYgNywgdGhlIG9sZCBLVk0gdGhhdCBjbGVhcnMgYWxsIG9mIGxl
YWYgNyBjbGFpbXMNCj4gbGVnYWN5IHg4NyBiZWhhdmlvciB3aXRoIHJlc3BlY3QgdG8gdGhlIEZQ
VSBkYXRhIHBvaW50ZXIsIEZQVSBDUyBhbmQgRlBVIERTDQo+IHZhbHVlcywgZXZlbiBvbiBuZXdl
ciBjaGlwcyB3aGVyZSB0aGF0IGlzIG5vdCB0cnVlLiBUaGlzIGlzIGJlY2F1c2Ugb2YgdGhlIHR3
bw0KPiAicmV2ZXJzZSBwb2xhcml0eSIgZmVhdHVyZSBiaXRzIGluIGxlYWYgNywgd2hlcmUgJzAn
IGluZGljYXRlcyB0aGUgcHJlc2VuY2Ugb2YgdGhlDQo+IGZlYXR1cmUgYW5kICcxJw0KPiBpbmRp
Y2F0ZXMgdGhhdCB0aGUgZmVhdHVyZSBoYXMgYmVlbiByZW1vdmVkLiBBdCBsZWFzdCwgaW4gdGhp
cyBjYXNlLCB1c2Vyc3BhY2UNCj4gY2FuIHRlbGwgaWYgS1ZNIGlzIHdyb25nLCBqdXN0IGJ5IHF1
ZXJ5aW5nIENQVUlEIGxlYWYgNyBpdHNlbGYuIExvbmcgYWZ0ZXIgbGVhZiA3DQo+IHN1cHBvcnQg
d2FzIGFkZGVkIHRvIEtWTSwgaXQgY29udGludWVkIHRvIG1ha2UgdGhlIG1pc3Rha2Ugb2YgY2xl
YXJpbmcgdGhvc2UNCj4gdHdvIGJpdHMuIFRoYXQgYnVnIHdhc24ndCBhZGRyZXNzZWQgdW50aWwg
Y29tbWl0IGUzYmNmZGEwMTJlZCAoIktWTTogeDg2Og0KPiBSZXBvcnQgZGVwcmVjYXRlZCB4ODcg
ZmVhdHVyZXMgaW4gc3VwcG9ydGVkIENQVUlEIikuIEZvcnR1bmF0ZWx5LCBubw0KPiBzb2Z0d2Fy
ZSBhY3R1YWxseSBsb29rcyBhdCB0aG9zZSB0d28gYml0cy4NCj4gDQo+IFRoZSBLVk1fR0VUX1NV
UFBPUlRFRF9DUFVJRCBBUEkgaXMgYWJ5c21hbCwgYnV0IGl0IGlzIHdoYXQgd2UgaGF2ZSBmb3IN
Cj4gbm93LiBUaGUgYmVzdCB0aGluZyB3ZSBjYW4gZG8gaXMgdG8gemVybyBvdXQgcmVzZXJ2ZWQg
Yml0cy4gUGFzc2luZyB0aHJvdWdoIHRoZQ0KPiBoYXJkd2FyZSB2YWx1ZXMgaXMgbGlrZWx5IHRv
IGdldCB1cyBpbnRvIHRyb3VibGUgaW4gdGhlIGZ1dHVyZSwgd2hlbiB0aG9zZSBiaXRzDQo+IGFy
ZSBkZWZpbmVkIHRvIG1lYW4gc29tZXRoaW5nIHRoYXQgd2UgZG9uJ3Qgc3VwcG9ydC4NCg==
