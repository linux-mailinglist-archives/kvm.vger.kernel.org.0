Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7EF6F5CCC
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjECRO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjECRKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:10:00 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4300769A;
        Wed,  3 May 2023 10:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683133767; x=1714669767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J7LPTh4/JlGAqW/+ybEPGvH2JxqAhjig/2OPHloEQYY=;
  b=fUId0bIgQhhkV7c5SMqB7nnJrYAsgMqS+plathVBdEOtqWsR5BUtEnOG
   O5tHLw9xdn6HGyZiDFXfUelse4MCYcWtyQ4ADPmHrkcIxX+f9okh+JjO8
   vrfV8oRBq+smBRSeaR6A03rjIvVcqpsg72JdhhSPhmy3NSAY8LoElmgs7
   aWas3ukx8sEP9GmMwkX632ANQ9+Nio93jxOlA+N6bDZRcfDA1yjtsBoDD
   I+tlWhP7xsN7zuOUnmMMjJOpTd/jgwlt99Ac8I+odCljGHAykxmikh5CA
   qBPumvVdYNRue2bdBEa7Ll3VRgdGQliX35Zg0Jw2xGX7p7wVT07iPlMM8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="350785245"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="350785245"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 10:08:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="729408734"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="729408734"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 03 May 2023 10:08:06 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 10:08:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 10:08:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 10:08:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrDSdsEiPFeLfDoG3pTnZ3W4Lbi24JjJRpCDAm7EFyTW1oKrCYDi1fVzqgUEUd+Ymd+CxMh0CRvIyCQaJKsLh+qEcV1Kix7pFkRp9s0LeU7lribjbjhm5WVSlByMP2OrUZCN07yH6BPVrh/3rj2HTnQdjP3FQIxSLl53SsJREwu4qNnXz9VkOCsS6yQ/YfZ/htZ9bMZGxvKB57PWQU7nT9nr6MWvr8kw2NyUgghawX07YVLlTjQTLy3vOLzCWldJLPIb569QSDy1mOmeeSUgzJjFnbDz+u64nUB+9ylvFgv15Ypqlad/yrxXJ+FaRGXf+gFGr6RqyD226RO3o5/H2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7LPTh4/JlGAqW/+ybEPGvH2JxqAhjig/2OPHloEQYY=;
 b=gnUJMDMX/kFzgAZh1cOcXYK7q2IlyLGJGp/Bw72FSgQnAoxodoYVNDzivdHiwuINK5tHjpvWKtw9+s3vn7NWUnE1EKJYcH/Hd4U7d4SYIFh4h93IDUi2eISVdDVT2w0GtllgLDA88B3nuuyL+EoqXNNcOkSrU6Qb+ghrBvorQ/wggpaQYELPZluuqHKnObPb/ny57N9lrJXJwycX1ysX4tQqAE2boc1KsIIPMUa3D4xDz1kGFKRuZ2gsQBx7DR8V5+KOEdrfqkM9zaUlpdovpGbstsGY7gY7STjJWa8C2WkQxmnxy3QPRlPDMkgRJjKh9f4nd2+AM8pyp69EEUqqOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB7048.namprd11.prod.outlook.com (2603:10b6:510:214::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 17:08:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::33bf:d30c:12fd:b7e3]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::33bf:d30c:12fd:b7e3%6]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 17:08:03 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 14/21] KVM:VMX: Add a synthetic MSR to allow userspace
 VMM to access GUEST_SSP
Thread-Topic: [PATCH v2 14/21] KVM:VMX: Add a synthetic MSR to allow userspace
 VMM to access GUEST_SSP
Thread-Index: AQHZdHFyerpLLlhD2EOSew/RgQAij69I2sAA
Date:   Wed, 3 May 2023 17:08:02 +0000
Message-ID: <50366bbd8ff5adf164644dd406ea7337c174ec22.camel@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
         <20230421134615.62539-15-weijiang.yang@intel.com>
In-Reply-To: <20230421134615.62539-15-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB7048:EE_
x-ms-office365-filtering-correlation-id: 09a131db-4673-4980-918a-08db4bf8f495
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rXBDkUPkv5ESaKcsUe4O7ognFqL3JCtZsKj3v9AdBFtyO9HCEntDmxXA15IQOBlQTISQ1a/QlcfExk9KHQIociPeHVsPhq71IBmUO6GksXh2qskvGjWu+Z9TD0X/XMTj3LxBbDtShAxJlNDR8owvVGgsKXeuqG9pV2bL53Sj6bafQQQDZ7W/axEaQ5F8069T3wqFifNI7XSXDa0SSRxsOFkXgAdS+bifHb2KbtY4/2U/g6Y1U+FYsdGPKVBnMmfSMTBZuOjXYsQF1yaaWKH4/SARBwhfVh01Xdv57xzM3CH5uEZi4QQJyOm0Qez4teNlMwbj826dylDOnC93hB7C5Vy8tXey/j735kXYOGELl6wLOJupOt/rfYEVtVYZ+Mcb7Mpg5J+QHD0Uzp2MfxDGeLPAGBVrPs6jKlBrzNr1xxg+LU3SKdafFDxhem0HzsnR5l2yDcGQS/UZD/mslUSHFODy5mcRhRpDuQ52jVe55eXHVx7a587ZC++wUyleGOq0jT6do9OyRYIZ3mXAG/Dx7rw4tYbx7EY9ZazSkLaR2FzFfAjwdZ1/UqrFx08EhG+Vy7r/3DNXv7xSq1b2Hyp52Fp7up8ymmQJqDH+BQaQb3biHuZuqNX1TKRKzPGNC6hL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199021)(8676002)(8936002)(36756003)(82960400001)(921005)(71200400001)(41300700001)(38070700005)(66946007)(64756008)(66446008)(66476007)(66556008)(76116006)(4326008)(86362001)(91956017)(110136005)(38100700002)(478600001)(122000001)(316002)(6486002)(4744005)(2906002)(2616005)(5660300002)(6512007)(6506007)(26005)(186003)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlA0bjA0VUJVTjBBcjhJd29SVmJER2J5a1lMTEZSSVoxL2JqdEJJTmZFb0E4?=
 =?utf-8?B?ZFpGeXRBQ0swbktyUVJPUFF6RkdLb1l3ak15SWJPem1tRm1ySzJuNGJsRlh2?=
 =?utf-8?B?ZUNNRWkzNW1hYmV2OEowZXNjTHJIRUs1RDRpaytNbUcvVTN1T2FiMVpIZWV1?=
 =?utf-8?B?b2pRYys2YzlYaWJqcndXeWFnaFVTeFdUeHNGNWlEajZvdFdFSnUvRkJlUTR6?=
 =?utf-8?B?TXZrRlJsRUpFSDZXeE9Jby9pS2lkTHBYdXZ4cjFQNTVtMnhRai9xQkRpckQr?=
 =?utf-8?B?L3pOWGZoeERkVWhnMUtHZjlXMEVkd1JSSUltY2p3bGYrRFZNdW9iaWszQlYx?=
 =?utf-8?B?c3hrTzJrVW9oTS9ZTWJqQUcyUk1xVW5haWFJWUhtVm5TLzh4eXBGMjNkRjBJ?=
 =?utf-8?B?YjhGRjl0dGE4dW91MDJFYmdSbHJaeVVqV3BmSzJkNzVNWkdnUXRHSXRDYW5X?=
 =?utf-8?B?RDlkZmZ5cXpPem0weXViVDRqRzVJaEJUYjBPc0FLUlBjVkVPODdPaXFFSE5W?=
 =?utf-8?B?R21EdHZ4bVUrTzB1aVVFeUxiVkk4RW44NnNYRkxMZ1RnWXpHQmoxdkRYT3lq?=
 =?utf-8?B?RVFTK1pUTk1hWERyOE0zb3NLTWRmaDdvaUpWelFIc0hvWUZPQ1pLRjVPdDRG?=
 =?utf-8?B?NHdLZDRvMVFKVkVxaVZybTNnb0tlOGdVL2Y0WnRDM1ZZZmhrd1lDcUl6WUdw?=
 =?utf-8?B?Mk1rT3k1VDRSemY0UkpKU0lUb2hzazcxeGNJajR6aG5Od0NZdHFCbnZFMzU1?=
 =?utf-8?B?aWtrMjVNSjFmcFNQck9Ca1F0dVQzaHYrc0VsNzdUMVlOTGh2Smd0NmNGMVR4?=
 =?utf-8?B?VEdEMG52M3FYd3dOY3BtNnl5aE4xbDNiS0FpNGZCR0o4WVVQbTNFUU8vTysw?=
 =?utf-8?B?aHVmdXlkK2pJbEFxSmVJdVlyU2NrZFdBRUxUbU9GNWFFamJZdG52TGZwVUlH?=
 =?utf-8?B?anpVL2R3WlkwbFZvUnh4Z1hqcXUwK1liWDl0WWFBc0JqUkRQSmpjREZEWDZy?=
 =?utf-8?B?QmNnTVhnMEJjVmVXeForUGx0T2xrVGt3cUhMTE5TaFNXQmFIMFVPbUhhWkNw?=
 =?utf-8?B?UWF1bGtjUnUrS0tPd25NUUFPdXdYZUlaaTFRclVxenkyMllRVENjdTlJbjNS?=
 =?utf-8?B?eEd4c0NwTlkyVGxjNHEzMmNZeE1aNTlmNFpWQ1VlenU3QVc4elZkbE5ydlYr?=
 =?utf-8?B?SEx0MnJWZVVYenN2WkJiSUQxcGM0YmdGeEdqLzBQN0gvMG85eVFIWlRwbE0y?=
 =?utf-8?B?ODlNUDVwMnlQMFlvbnFrQ3pqdjdjMHpKS0FlWXpmT0MrOGV2bUVNU0tMdzhr?=
 =?utf-8?B?WFpEQ0t4QU9pZnZiZGVEd3c2OWRzd0RyUTBtYTFQY25ZL2pTYXRLNEh2ejc2?=
 =?utf-8?B?YWxCcjBHVitrS01NMFdkZ1lBbWpVRzRQMzMyTkpWLytUbGFxU3l3Q1ErZTZX?=
 =?utf-8?B?aFBkY2lPTm1xV3NPYnZuN1hVbTh4WTk4SVZSNkRoN0t5Q2wzRW83NTMxWXNn?=
 =?utf-8?B?Ukc4WXdJTnJhNmRSNXBDR2VVc3FCYnZEMTBiN3pPNEIwQ3dHSlJ3dXlKRkpI?=
 =?utf-8?B?VDdvaWRwSXQzYXZkTG5DeTBJczZ2R0VpQ0k3S2pSQjVxdmoyR1pHYzY3c1Rm?=
 =?utf-8?B?Tk51N2ROQ0dYcVdxRVdJNmdVUS8yVTlNWTJSQVh0NktNdXhHaStDNkgrRUNy?=
 =?utf-8?B?c3RVUU81cHRMQmZiN0c4UW43VTlwZUNMWGkxZ1VHTXRPblZIZGtNTEpTc0pz?=
 =?utf-8?B?TXN5azZiWmN1aENEaUNzWUI3QUc1YmtvQTVWMVN2TEYzOWJvS3NMMEVZZXJs?=
 =?utf-8?B?M2FiMS8wcVZCQ1NkamlUZUdLTEV2cE5Gd3JSTmh2WGlFU0grRi9sbDRVQk9q?=
 =?utf-8?B?U2pmcjVVdStmckJSRk16VXJMcnlWSjVYQXpEN1RQenBmNkdOeURMcWNhTnk5?=
 =?utf-8?B?RkczbCtpRkRWc0owOUUvNndKZWtzZG04VXE4eWV1ZjM5eVNKTlMwd2pxblAx?=
 =?utf-8?B?ZmJQSC9ZM21SRkxDcEoyN2dtYkt3VmJ1V0MxWVF2b1J4RTFsSENLaFcwRHJN?=
 =?utf-8?B?ZG1xb1NBSjBHZlZudml3a1BVTU56ckl5d1NURTQ4UVIraEFmUUw2YjRZVnZT?=
 =?utf-8?B?UUhsZHRjMkF0MWJrWGs5TDY4M1dTOWhwd01NTXBMeFIya3N1OWFNOGVRVmhK?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1AC58B71DCA6142A7687354302687AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a131db-4673-4980-918a-08db4bf8f495
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 17:08:02.9896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YXVAAgWQ5RRHDoDKVNDbJ1PV4G/f0vRg2OgsMsPx8aFH4caRzPgcF/QjHBj6qb2gUbh1ZSwX17Mp9gwAV+dy9tiW2YbZZd9bOPpu03XF8ug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7048
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA0LTIxIGF0IDA5OjQ2IC0wNDAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBJbnRyb2R1Y2UgYSBob3N0LW9ubHkgc3ludGhldGljIE1TUiwgTVNSX0tWTV9HVUVTVF9TU1As
IHNvIHRoYXQgdGhlDQo+IFZNTQ0KPiBjYW4gcmVhZC93cml0ZSB0aGUgZ3Vlc3QncyBTU1AsIGUu
Zy4gdG8gbWlncmF0ZSBDRVQgc3RhdGUuwqAgVXNlIGENCj4gc3ludGhldGljDQo+IE1TUiwgZS5n
LiBhcyBvcHBvc2VkIHRvIGEgVkNQVV9SRUdfLCBhcyBHVUVTVF9TU1AgaXMgc3ViamVjdCB0byB0
aGUNCj4gc2FtZQ0KPiBjb25zaXN0ZW5jeSBjaGVja3MgYXMgdGhlIFBMKl9TU1AgTVNScywgaS5l
LiBjYW4gc2hhcmUgY29kZS4NCg0KSXQgc2VlbXMgdGhpcyBpcyBleHBvc2VkIHRvIHRoZSBndWVz
dD8gSSdtIHRoaW5raW5nIG1heWJlIGl0IHNob3VsZCBub3QNCmJlLiBJQTMyX1BMMF9TU1AgY29t
ZXMgd2l0aCBzb21lIGV4dHJhIGNoZWNrcywgc28gTVNSX0tWTV9HVUVTVF9TU1ANCnNlZW1zIGEg
Yml0IHBvd2VyZnVsLiBJIHRoaW5rIHRoZSBndWVzdCBkb2Vzbid0IG5lZWQgaXQgZWl0aGVyLg0K
