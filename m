Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C771470CEF0
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjEWAYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbjEWACk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:02:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C58119;
        Mon, 22 May 2023 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684798926; x=1716334926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SPTO4/N++bVbL7QmtFRC+uLRYEEqI9MsXLqPp5zMjeY=;
  b=Iu5fi6d6+3Y9uqgqpXqp1H3l44F9xEeaNBsGedd2F30deBP6PRqRDFgp
   KV7KP6aGP5t4P8hv8q9NDTr5Gt5LGxyFehzs+eUAkuw6MjuFf3VUZTP4T
   ywGIfaZS6RC0xWFpf8G6JK9398pBr7f0GG7ma7PpN5XYHkR+KLSf2F96q
   ygCXmvOcOpE7Hfe4hgvUEbHKk1IXmEaJXiMi3GnYd5d0H3ckACMOVHdq7
   Xanm+KDo4YgCXjHwubtMhBCewddzOu0ZxEDrg50SZ1M/2NZSHHOrphmQA
   Rf9ONiGjpUiBs4wzQsg9uTsuKD7zposzROLOraT8rvEJJk0wi56B1R4LQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="356302501"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="356302501"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:41:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="827878184"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="827878184"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 22 May 2023 16:41:52 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:41:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 16:41:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 16:41:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7mkOt+TPzGKENKY6chSu8UN5Na3EVnXztKA9soeKa2OqjM/lCMmOB55EAdUi4mUVEwQkLNLEACaqVDg6tr0gNVvKUHqKzE40EQtXS5N/2N4BTlZx9rO31pk8nnmzLjQSQRkGIbjydrzWaYuSjOvTZ0MPNBjNu/tTeZpW3KBSszHKGbxDuLabJKmp+KgOoTGuYv7c98VegmFnZgTU10jvZm7b8KXwW4DEMyr4N9dLPe0lX/42MwqcYEGLYQZpUoduzuwhL8f6XWMDp6vKpcFczY/02b69MJbCR18fRXjKs9LigWMA1Ezv6hfB3/B1/g9eK4Oyfo9hMgQw1VHJBpPLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPTO4/N++bVbL7QmtFRC+uLRYEEqI9MsXLqPp5zMjeY=;
 b=hS2I7vmy5WKNrUHS24v44zxRJue1cqTnm/WDO5ucP5MucFcR671fY0w6XTUTKtWv87jliTYd9CaCRQQq1DIGdJJVhRwjn3Baxwdf0AX3uPrYWIqoEYjpwJBedOJdoxHBqWrBr1itCwQ6YzJ5pjX+YqjmBzib6vUltB0D0lbMyxqgyYgXG/rp3BoP0yUnmvrS1caHH7VfgmVZmRoBsAd0t68obOGBkGZUPRiQgP7IHUR/SGI7pGFTY+G0atinvq1+TOVrFMrjJR0vs8PtZ7L1G6UN4XXw6TWqb0/6oG77v81sKOj/7WWWgGguQs5Fq7UyK1L4ZNictTfA/bTYNcGzbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4621.namprd11.prod.outlook.com (2603:10b6:806:72::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:41:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:41:49 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 09/18] x86/virt: KVM: Open code cpu_has_vmx() in KVM
 VMX
Thread-Topic: [PATCH v3 09/18] x86/virt: KVM: Open code cpu_has_vmx() in KVM
 VMX
Thread-Index: AQHZhSyYi6ztTKwZhEKVcIZEXw3JbK9nA5iA
Date:   Mon, 22 May 2023 23:41:49 +0000
Message-ID: <50eb361c5ef386f0870028fd8875028bb30377ea.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-10-seanjc@google.com>
In-Reply-To: <20230512235026.808058-10-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4621:EE_
x-ms-office365-filtering-correlation-id: c6588295-d4af-4a28-2ec3-08db5b1e1d05
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XJtzCHG5DhO0l035S7TjgrTs5bYjMm6JPoGfdqpTPqlWl6X3xW2XGxTjlYYUOUXV3xZLb+NkonnMXJBNdIzamPVmkEJ3ElBICNMXR2j8BJaykpl+zt415xmKDywhnziZklB5wGbSsl+SvtBN/ERnqVGXiW54G8ulojdQsEginAiLpAKO5/FOAGkWO4960aGfYal9C7ugtIUjU3bm8Ptqz1VpSSZrZdNDieKJoVD0uEuA1Q7fJ76WSCYrOlWfDbZGLEn3zYH3vp4LEb5IW/k09ZgLa52VyFALc8IX3tcOnWQnvnItgn8tQnREbPnVbMKle/dV8eSZ27dEB/zZjpX/9b/3jpsTiabyuskNMtGNBa35iG43vtxF4oi6dvAKYUE+daN+7F8gGJ8nxvGrw0r7GkNBVyC2Q+l51d2R04cITwdQP0ntcWKApiXM22D5b/N/R2XTg+jtsuddANdBk/1G29cHqyL7aw+xngN5tvSut1MoNEaEGOMxMjx4TDfdJ1fo1mKucMfk3/Q0CoqJYVoFlvEfZs6JBLGwoouoUp4ZwpqmlKFSiikBgQRo4NNo/da55swf0oFZhznqhVFe6tEpqZOQ/ciMKWy/YYQz1sa6V3h2Rrw3oFs2L0+7evUeupMQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199021)(76116006)(66946007)(64756008)(91956017)(66556008)(66476007)(66446008)(478600001)(41300700001)(6486002)(54906003)(110136005)(316002)(71200400001)(5660300002)(86362001)(8936002)(4326008)(38070700005)(8676002)(38100700002)(82960400001)(186003)(6506007)(26005)(2906002)(6512007)(122000001)(83380400001)(2616005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0xHOHFIV0JZNEhjRzNaUnNqQ1dKTUJJcFZIbVBuOWkzYkl3ZHFub3lSYTA0?=
 =?utf-8?B?bUFUTVppaHZPdk44WmF3dVVGVHVuRlJlMjBORnFud0kzU3hJcGlVVWtIY01o?=
 =?utf-8?B?YzBrSklVWmpoelY1VCtnZFJNYW9INVErNE9uSCs4dDdXVXJ4UzdCL2gwd3lS?=
 =?utf-8?B?aVJYVG96b0J1K1NZQncrZ2JkdXF5citsZTM2TE1YVWZqdXhVQW1WSHJKb21I?=
 =?utf-8?B?b2xQdUUyWGw0UWo2cGJyQ01RWkEwNjZiNHoyZkZKdU5qQkRvbXdpSGJGNGd4?=
 =?utf-8?B?QkhVVWQrRE5OQitGa3JIMEs0ZFJaNFhXTWgvQktJQTA1YmQ4QWNTTzJDdUN0?=
 =?utf-8?B?c3l1blR6bWs3bGJXc05kVjB6OEUyQWQ0REpjS05oVWg4c2NKNk1iMnRhWWFk?=
 =?utf-8?B?dXU3dXdoMW5QWnZiaDBxN2hObnBGYVdNYnhDL3dCVjlCSlRXamg4aDd6S3Qr?=
 =?utf-8?B?dElRS2o0bmpFcllwZHdKd3BLc3ZUNDlxdm9aK0dXbkN2T0I5d0RPY0NkZmFu?=
 =?utf-8?B?UktXeWRSdlRnTlFCcGVZcmVLVDllb0dZVENEdVFzS284eGQraWl5TVAvOWla?=
 =?utf-8?B?OGlCakVBLzFsWFBjOFU3RDdaY09zOTZYNzZjTTlyV0FIQ0xya2JxQXZOM2xx?=
 =?utf-8?B?MGhISXZjd3JLUldPV1JKMG5jQlZpVk1INGg1UkhHUXdyQjJwVGtadHd2RG8x?=
 =?utf-8?B?Rjc1Uzc0SEE0cmNUc1NaaGtGUnNDVzk2eHp3WTFlL2lrc1l3S1dRdWExMmxv?=
 =?utf-8?B?MnRvaGswNVJDUEJJc0gzTjJ4OFFvWE05OWZEbWVMZHBPVEJ5eXUxcGxONXN1?=
 =?utf-8?B?UTdvc0N4emYwRFI2U01sUVovY0RBU0Z2dEMrU3Q3cEtCWDVUTVVncERFK29u?=
 =?utf-8?B?Y2oreWpIOFJMQjFCdHFzcjd1R0JnaHZlNVNlWHpVT2p4cXpMU1p5eko0MWpT?=
 =?utf-8?B?WXpERU9PT2szS214V0ROSHphNlc1YjlaemxJU2xNdjRhYzVkcWpmNGVQUFB0?=
 =?utf-8?B?cnZuSnczbHc2MXdnbWE1K0JuQklVMVhHRmYzVXo4K2h0c1d1dDVHSUkyTFMz?=
 =?utf-8?B?MERCZXZlb3JGVTVhTW96QmZOZlVpdnFlY2lwT0FJeXJhRkw3Rm54WkJBVENh?=
 =?utf-8?B?ZHZUQTBiWGVDS0ljWGc1VmtqdnJTUWtQd1hrRDFwMUw3YUtJQkFpSk84Y01h?=
 =?utf-8?B?V3BmT3psTWdFYzFXMW5QVUlMKzNHWHlJVWdDVGRtNmJQR2NOdmNjOHV0VHV3?=
 =?utf-8?B?V3ZrWXQvbDhyMWhidGtXRkpCbkZCYUZiMzNRWVRHVU0xZTcrWk5vQnZhdmtw?=
 =?utf-8?B?TXh5WEdaK0FuU1hBSFhQOEFWeDJ0cXlFck9scEcyOGNGMzJRZlM3c0FLU25Z?=
 =?utf-8?B?eTkrbThhbDZUUnMrT0xpZVRIY0crUXp2OFpnUDdJMnAwK3BtRExuYUpBakZO?=
 =?utf-8?B?dGdVelBGR0I2eHJCN21vTnFyMkRLS0JjQ0RFOXB6TnJxSU50NVhiQzJqc0Np?=
 =?utf-8?B?aHBHbGdaOU1YdzhMNnVkNzZOOGRFSm9jYSthY3drZnhKaXMxQWhrTFluVkkr?=
 =?utf-8?B?WnBhZWVOWERKWVpkREJqUXFDZmtBRExENUw2dkVZMjAreUovcWdDQ3RqcFNL?=
 =?utf-8?B?a2R2WDVBb1N4NWxpUnUyZC81QjNPUTNuMndCM2JIOWtWenhHQ0oxWFA3cHpk?=
 =?utf-8?B?WmVHcTRHc1ZNRFhQN1g4TkJGKzlJNFB2V2ZnQ3JBbzdkcGs3ajV1bFNOR0xM?=
 =?utf-8?B?YURTcVVuc1QvdWFhSS9uRnlyZDFub2M1OGdyVnJ6REU4TkpWbGJtbU1ENnM4?=
 =?utf-8?B?YWJRZXJhT1dQU1UvaGpRa1lYbGxXU2Z4Z0dCazIwTkJtZ2hSUUo2VnNEOWkw?=
 =?utf-8?B?ZzQ1djMxRmlGdWpHeTE3eS9LKzhPdG9NSmNLNWNTNEVrNkVGMTU0Q1BMYTNr?=
 =?utf-8?B?a2F6QTV0YUYzeStFM3pLOVN6dTRTbXRWejBoT29wSDRoZEdNcnU3a1JYWHZ2?=
 =?utf-8?B?QUdpckorQ1JSeDlJRnFpcm42QzAwcDl4SnM4VWEram4yczVMa0lHL0NXZXZs?=
 =?utf-8?B?RkgydzFjbkl3eUY1OTVabzZyR0FNdWtZS0JPTkk0SXQwZGRmUVM4eGlVV2lM?=
 =?utf-8?B?eFA0K3ZYUklTMEJSaDRleCtUS1k5Qy9ldTRRb05KTmgvM1kxd2pzSlFyRW5C?=
 =?utf-8?B?UUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76BB5FC60170BE42852B0D5DE2A7499C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6588295-d4af-4a28-2ec3-08db5b1e1d05
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 23:41:49.6517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FHdQHo8usZS0zI/FHmgJiHCf1+mK9qQU5GGTy+cp6YuHcwITlIlS21wHH1KBvARSbs5m+ec6OiTqC1aQnR27Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4621
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGb2xkIHRoZSByYXcgQ1BVSUQgY2hlY2sgZm9yIFZNWCBpbnRvIGt2bV9pc192bXhf
c3VwcG9ydGVkKCksIGl0cyBzb2xlDQo+IHVzZXIuICBLZWVwIHRoZSBjaGVjayBldmVuIHRob3Vn
aCBLVk0gYWxzbyBjaGVja3MgWDg2X0ZFQVRVUkVfVk1YLCBhcyB0aGUNCj4gaW50ZW50IGlzIHRv
IHByb3ZpZGUgYSB1bmlxdWUgZXJyb3IgbWVzc2FnZSBpZiBWTVggaXMgdW5zdXBwb3J0ZWQgYnkN
Cj4gaGFyZHdhcmUsIHdoZXJlYXMgWDg2X0ZFQVRVUkVfVk1YIG1heSBiZSBjbGVhciBkdWUgdG8g
ZmlybXdhcmUgYW5kL29yDQo+IGtlcm5lbCBhY3Rpb25zLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBj
aGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KVG8gYmUgaG9uZXN0IEkgYW0gbm90IHN1cmUgdGhlIGJl
bmVmaXQgb2Ygb3BlbiBjb2RpbmcsIGJ1dCB0aGlzIGlzIGEgc2ltcGxlDQpjaGVjaywgc286DQoN
ClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCj4gLS0tDQo+
ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS92aXJ0ZXh0LmggfCAxMCAtLS0tLS0tLS0tDQo+ICBhcmNo
L3g4Ni9rdm0vdm14L3ZteC5jICAgICAgICAgfCAgMiArLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMTEgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYvaW5jbHVkZS9hc20vdmlydGV4dC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdmlydGV4dC5o
DQo+IGluZGV4IGFhZWQ2NjI0OWNjZi4uYjExNzFhNWFkNDUyIDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS92aXJ0ZXh0LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20v
dmlydGV4dC5oDQo+IEBAIC0yMiwxNCArMjIsNiBAQA0KPiAgLyoNCj4gICAqIFZNWCBmdW5jdGlv
bnM6DQo+ICAgKi8NCj4gLQ0KPiAtc3RhdGljIGlubGluZSBpbnQgY3B1X2hhc192bXgodm9pZCkN
Cj4gLXsNCj4gLQl1bnNpZ25lZCBsb25nIGVjeCA9IGNwdWlkX2VjeCgxKTsNCj4gLQlyZXR1cm4g
dGVzdF9iaXQoNSwgJmVjeCk7IC8qIENQVUlELjE6RUNYLlZNWFtiaXQgNV0gLT4gVlQgKi8NCj4g
LX0NCj4gLQ0KPiAtDQo+ICAvKioNCj4gICAqIGNwdV92bXhvZmYoKSAtIERpc2FibGUgVk1YIG9u
IHRoZSBjdXJyZW50IENQVQ0KPiAgICoNCj4gQEAgLTYxLDggKzUzLDYgQEAgc3RhdGljIGlubGlu
ZSBpbnQgY3B1X3ZteF9lbmFibGVkKHZvaWQpDQo+ICB9DQo+ICANCj4gIC8qKiBEaXNhYmxlIFZN
WCBpZiBpdCBpcyBlbmFibGVkIG9uIHRoZSBjdXJyZW50IENQVQ0KDQpOaXQ6IGxvb2tzIHRoZSBr
ZG9jIHN0eWxlIGNvbW1lbnQgKGRvdWJsZSAqKikgY2FuIGJlIHJlbW92ZWQuDQoNCj4gLSAqDQo+
IC0gKiBZb3Ugc2hvdWxkbid0IGNhbGwgdGhpcyBpZiBjcHVfaGFzX3ZteCgpIHJldHVybnMgMC4N
Cj4gICAqLw0KPiAgc3RhdGljIGlubGluZSB2b2lkIF9fY3B1X2VtZXJnZW5jeV92bXhvZmYodm9p
ZCkNCj4gIHsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4
Ni9rdm0vdm14L3ZteC5jDQo+IGluZGV4IDc2Y2RiMTg5ZjFiNS4uZjQ0ZjkzNzcyYjRmIDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92
bXgvdm14LmMNCj4gQEAgLTI3MjEsNyArMjcyMSw3IEBAIHN0YXRpYyBib29sIGt2bV9pc192bXhf
c3VwcG9ydGVkKHZvaWQpDQo+ICB7DQo+ICAJaW50IGNwdSA9IHJhd19zbXBfcHJvY2Vzc29yX2lk
KCk7DQo+ICANCj4gLQlpZiAoIWNwdV9oYXNfdm14KCkpIHsNCj4gKwlpZiAoIShjcHVpZF9lY3go
MSkgJiBmZWF0dXJlX2JpdChWTVgpKSkgew0KPiAgCQlwcl9lcnIoIlZNWCBub3Qgc3VwcG9ydGVk
IGJ5IENQVSAlZFxuIiwgY3B1KTsNCj4gIAkJcmV0dXJuIGZhbHNlOw0KPiAgCX0NCj4gLS0gDQo+
IDIuNDAuMS42MDYuZ2E0YjFiMTI4ZDYtZ29vZw0KPiANCg0K
