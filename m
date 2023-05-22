Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A5570CEF6
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbjEVXky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 19:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbjEVXaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 19:30:07 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4904D120;
        Mon, 22 May 2023 16:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684797930; x=1716333930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1BmM8mPNw3zFCVeKQhgWZhWvwuuK2+0ft36SMTAWKYA=;
  b=XymiRWK3JeDAjneUt+iOcgS3lcAo4h9XEIkziCEYrAynvcyS/ywUmSeB
   DCmiPs/H3rYhT9m+9zVXStlBzTZzwuPkCsUt7M1R1EDkIykNbBxQmIKsB
   Yx9YZi4wrzgMMuXhj8TRJQPOeBWwlhkfdt1AjM4rdZV62tT2oUOamnmhQ
   6Ecp4Zj0OektYxBx9ORe5H5K4Pgv57GwLehcxccOoiE7ObL//F6l9PXvK
   tIO9a2HMj2L1UeIY/mAeZ+2DOMoihnaAtRtNeqEm59f5BS7tjHFKVwM6W
   MKPVPVQEj/Dmp9SIY1SK0wqf+UyzkwwWEznxnVMP4zQ6c/SdJ+cdmKAO0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="337659304"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="337659304"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:25:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="877960355"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="877960355"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 22 May 2023 16:25:29 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:25:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 16:25:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 16:25:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gszd3LOR0gN1oNTkonUWzG9SlxTNILPI63gJTKf9ol/GGGxAtQ12ml0Wyo6h4xjL9gfH8EvfvGUEy/ZqDP5AI0ejzb67/wvzfeDkPevCjZFa6XaGPQTiI65wZw6SeBUNe2ao3bpaVsf5eLfWYhBIqKV9MqTrZnki5U/TS03v+AnMBxuIi9Y28mzJVl/+ONjUJLoAJVNFUI2bdKEs3osUFVndMIOZ9VRJ3rykPI7rYG97g8NCRE75mle7ltcTbI1+k+yWW/YCtHx9WDDJVt4/qVYDBSDl7gm2UX7B3/pA1X1Xad4igr2zYYLF0AIpG7oxJ8DSQXTf5194M+a4AWFEqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BmM8mPNw3zFCVeKQhgWZhWvwuuK2+0ft36SMTAWKYA=;
 b=l5XW0pdJb2PiavrDe/vfiNakeh5ijdBZVk+fsjAwhWhdNo83jYEpwDboigVKmlxb+Oxt07lbKR5Y1OLoXbtA5Tg4CEWZcnrlalHWXcDtMgBxGHYiEcoukL5IyE3fWtQ5sNVTr08qwW8MAz1gC08WNzs1BAT3hPEmoHk/OfS/RpkwLWxF9MYxPPf5sVM58oxSSXFgGHqA8vA/CY1gvO3OZUbBuhy/h1T9x4kCkHt5+H+1zNH/xj7DtJv5A43cSBa47UTY77NOppwQVpme6UW4DEfoRxvROuojfK8C0xgud98jKe+1QtMqysxz1e4MD4r9hglf4pTqd9bFDvXy1+CuHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5367.namprd11.prod.outlook.com (2603:10b6:208:318::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:25:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:25:21 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 17/18] KVM: x86: Force kvm_rebooting=true during
 emergency reboot/crash
Thread-Topic: [PATCH v3 17/18] KVM: x86: Force kvm_rebooting=true during
 emergency reboot/crash
Thread-Index: AQHZhSyjOuJ4Qyzib0KQbsMiOzm3ya9m/v0A
Date:   Mon, 22 May 2023 23:25:21 +0000
Message-ID: <bc6a458d20c2b1743196b672a201d1d9e004b518.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-18-seanjc@google.com>
In-Reply-To: <20230512235026.808058-18-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5367:EE_
x-ms-office365-filtering-correlation-id: d4e21246-036a-443b-901d-08db5b1bcff2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pV5O8hN9jA/gqfczo/pgHyunit86j1WHMVxzOGiB+Kzp+ogWJeKq3jHLc49A9WH0SsbYvlMcztqJbyWysa1lFfcdPKfsuhv2NgRCtkYavs7i0T3B/7DgotjzE8ib3J5/XN3dRPfNjPDqz+8c5CcCRfj25doShYCCbhzQRdMsF+X+H2cqi8tt83Ea5q788L/rxoql546hU/58meCH/XzkaZO6d3Aw9HVBjiHs392pNj8v+QuaPizL8mnKQ6drWX3rMw/o416OfvMewPXpkmWifeDOMFPBJ/Kn4yEZr3uoRi54TS6loJLPqph1Yt+o7hyM1+UOFPHvmoalQ1qrfjRiICgXZXf2+ewqx4q1bAXGBBL7YCgKw2w0h39/OZXqrw+RRL7iFPHn1wGxgvvzW2/pxKHMMSWgG+/bpbHEovVy919nXiRUNLOv1Q1RwvhGXJ/7cSFv11hbm7HQe2T13OcozSor+ngHqh6ttNDxM37tbrEwjbylz5ZJ1S84plXGP2X2k7M7Tzsn/OXWyn7U2QZ9QbJuB1ygNcLezU+oPIV3zi+BCcYkrrKSTG5yvE9Gco9lu4ypFWj385pdo1GJAf1gwfACxQCL1kb+ujxdyJCjTY5xGIz1FiT/AkH7KKUeHwu5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199021)(2906002)(5660300002)(83380400001)(8676002)(8936002)(91956017)(76116006)(66946007)(64756008)(66556008)(36756003)(66476007)(4326008)(54906003)(110136005)(316002)(478600001)(41300700001)(71200400001)(66446008)(86362001)(2616005)(122000001)(82960400001)(26005)(6506007)(6512007)(186003)(6486002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2hGOW90dUJkUzlHUVh0ZXJmQkUrMWtjOEJyNUpyOXBRaVJxN2tFR2xLcWFV?=
 =?utf-8?B?RXdsMmNhMmhQZCs4clI3THhDSFIwSDZEWVZhVi9iN1JXQjB2TUJ1Q09tSXVZ?=
 =?utf-8?B?WWJBUEZ1dmFDWVk3UHkxMUFyVVJWUXp4RFByTi9ZOHgxcGs1am5aNEVpUjV5?=
 =?utf-8?B?TEEyK29QYjhRMitMSi9OS082bkNBc2pRT1oxTU5Jd09mL1ZCUVZ5ZTdqN0E0?=
 =?utf-8?B?Wk14azVGTEZKSmpwSTZqSysxRnlubG1ocW82Ym05YTdqSDRQbXdxZHdxSHhK?=
 =?utf-8?B?OHJNMWROL05oZm9LK0lySGdaZEJrdy9nU1ZNM2kzTTBqK01JY29SQ3JKMWll?=
 =?utf-8?B?dVZyWFVhRWw1NXZnV0M3bTh0YXhtT3prWDJtYWNoeTRsRG1JQ09tcFhtK0l6?=
 =?utf-8?B?eEY1TzRWUitBTjVOTzg3SzNiclkyRU55NzNTZ3BxOU1jWnMxeG8xOHJvV0pu?=
 =?utf-8?B?NnZFaC83U3BMVUpzKzUycmdLVXpNQTg2TlpHdXJPdkpkWndLNkhsQmZCcUJx?=
 =?utf-8?B?b2hnbTJsbkRlYWVlZzdGMHZpWnhBakhrdE9xRDdMVnQ2TkxqZUFadlhPR1lN?=
 =?utf-8?B?RkJ1N1liZG9mODdtOTQ1clFsVHh5UXlJNDlFOUUyKzEzWURRdjg5NFRLb05O?=
 =?utf-8?B?Y3RJRWc1SWtlaTNHNXZGV3ZGYzFDQkwwYlFXTzV5QWVZRHdZRTRUTmxvdWNs?=
 =?utf-8?B?RHE0NWVDc01wWXBFS0hwYms0cG96SktCcy9jWEI4aFlBY2UvNFhYcFF4Ty9q?=
 =?utf-8?B?V2NaWGxTZ0EzNkNraWc5cXYycmNtWXo3ZGdNRGg0Z2kxQzZ1NUZwRWQ2dCty?=
 =?utf-8?B?ekFZbjVCK2UrN1JzMlYvczBGVEZ2c2NJZm94M1pRWXFWOENLdGNudWRXRWl3?=
 =?utf-8?B?WEtCTEpGRUFsc3NGOXAra2dzKytZNEhua29nS1pRVmRTUkNmbW1NbDlReVVl?=
 =?utf-8?B?eCs3QU4reVJCUWFFUk44THFtWDZRaTZ1aXEwemIrS3p3K2R3bTVUYXZ3eE4v?=
 =?utf-8?B?d21zWEJBSXF6VmVuM2Q0MVFzaVIrVDJ5STdjNXhqai9HenVhY2tWMURnQlNn?=
 =?utf-8?B?b3pXdENsRTBpTERqSE54NGY5NW5ock52UStVbk1yY0pqVXo1eDFiajh4T3Rs?=
 =?utf-8?B?NVZxRzlsZVUxL29CWlhaU2hjQXVYYmNobE1rSWhkRitKODVtbGozaHdWaFJw?=
 =?utf-8?B?eGNMRC9XWkpuOUNLdFZ3cU0wQWlqRjF0bkxEUjVoOXZ4S1Z3cHorTzNUazFR?=
 =?utf-8?B?NytVajF4UTByUHRnZWpaOEdPcXlwVTVyMVgwSk4xRzgyNXVlK2lZTFl2c2Mv?=
 =?utf-8?B?bk5kcWNxeG1ZOStHZnZ6c25kekp5RW14bWRtR21lZTV4Y25GMHFBcWdObmFx?=
 =?utf-8?B?ZzlJT3NwOFR6NllmNDBwN0R5TnRqYWxjbmhxOG1kWVU4dW93NHZPM2VIUDhl?=
 =?utf-8?B?TW85SGJkWUlpeXZocld5UndBSXByUEQvS1MyeXV4TEs2SGVMT3k4MTkzUUFs?=
 =?utf-8?B?Yk90VE45OWhvbnVrVUtSNjQ2RFAvVERnMmFSS2FNMUNrSHRUMFRpNThHZXNk?=
 =?utf-8?B?WXo4eTc5MzFFdUxER3VJOWVrV3pwd0xKdkhjSkNCbEVuSGE0TWd2d1lmWVkv?=
 =?utf-8?B?a3dJYnA3elZYcXdJUXVoSitWbWxJZUxZaUN6cC92MVlIY0tVcVA2MWFhNXA4?=
 =?utf-8?B?bXgyQmlwazVyV3VjTEpSVG9uZy9YaDZmYlZaeVR3c1lGOVQ3YUtES0pTRzBE?=
 =?utf-8?B?VzVEdVVGSG9UUy9FMXJRdm5LY09yZkkwdlRISERGU2IrYUo0ZFVUZllJQlFH?=
 =?utf-8?B?M3BpSlAvRktjdWFOQVNWYVdVaUtpTFJBbWZqOUVTT3lqVnBHZGpnWFh1Y1RT?=
 =?utf-8?B?RFFWNTZXVTZBaEZlLzJFTkJ6LzN0N0VuUU1BMC8yb0FSMlpyL3k2ckZOM3JH?=
 =?utf-8?B?aE9DMWJzSWNCWmFJalNiMlJyR2NsUE10bDRzaHRpUjN6NzB6bnlwUmlUQk1l?=
 =?utf-8?B?SldmOXBUN25WVWkva1ZaakgvUURFZ1NyeU56VHNibUg0T2R5UWx6SWNGckJP?=
 =?utf-8?B?aGZ4RDZpSFNsT0R1OXpEY1FDcEttWWlMVmZGcVVpMk8xTFE5NHk4K29RM1Ji?=
 =?utf-8?Q?4sT+dxy1qiBbtipnuXttFM6HW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0658861C7E113E45B3A2CC8E5C6EC1E4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e21246-036a-443b-901d-08db5b1bcff2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 23:25:21.3500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ms41qeRzZfNLHJZIdWOqqG3aUVH9gogie7SGqblFz1hVXe5c6SkA6B5rDGBlvpj/QJ8yr47A6b7H1VoDwWmFVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5367
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBTZXQga3ZtX3JlYm9vdGluZyB3aGVuIHZpcnR1YWxpemF0aW9uIGlzIGRpc2FibGVk
IGluIGFuIGVtZXJnZW5jeSBzbyB0aGF0DQo+IEtWTSBlYXRzIGZhdWx0cyBvbiB2aXJ0dWFsaXph
dGlvbiBpbnN0cnVjdGlvbnMgZXZlbiBpZiBrdm1fcmVib290KCkgaXNuJ3QNCj4gcmVhY2hlZC4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUu
Y29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS9zdm0vc3ZtLmMgfCAyICsrDQo+ICBhcmNoL3g4
Ni9rdm0vdm14L3ZteC5jIHwgMiArKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jIGIvYXJjaC94ODYv
a3ZtL3N2bS9zdm0uYw0KPiBpbmRleCAyY2MxOTVkOTVkMzIuLmQwMGRhMTMzYjE0ZiAxMDA2NDQN
Cj4gLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vc3Zt
L3N2bS5jDQo+IEBAIC02MTEsNiArNjExLDggQEAgc3RhdGljIGlubGluZSB2b2lkIGt2bV9jcHVf
c3ZtX2Rpc2FibGUodm9pZCkNCj4gIA0KPiAgc3RhdGljIHZvaWQgc3ZtX2VtZXJnZW5jeV9kaXNh
YmxlKHZvaWQpDQo+ICB7DQo+ICsJa3ZtX3JlYm9vdGluZyA9IHRydWU7DQo+ICsNCj4gIAlrdm1f
Y3B1X3N2bV9kaXNhYmxlKCk7DQo+ICB9DQo+ICANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2
bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IGluZGV4IDAwODkxNDM5NjE4
MC4uMWRlYzkzMmFmZjIxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+
ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gQEAgLTc3MSw2ICs3NzEsOCBAQCBzdGF0
aWMgdm9pZCB2bXhfZW1lcmdlbmN5X2Rpc2FibGUodm9pZCkNCj4gIAlpbnQgY3B1ID0gcmF3X3Nt
cF9wcm9jZXNzb3JfaWQoKTsNCj4gIAlzdHJ1Y3QgbG9hZGVkX3ZtY3MgKnY7DQo+ICANCj4gKwlr
dm1fcmVib290aW5nID0gdHJ1ZTsNCg0KRG8gd2UgbmVlZCBhIG1lbW9yeSBiYXJyaWVyIGhlcmU/
DQoNCj4gKw0KPiAgCWxpc3RfZm9yX2VhY2hfZW50cnkodiwgJnBlcl9jcHUobG9hZGVkX3ZtY3Nz
X29uX2NwdSwgY3B1KSwNCj4gIAkJCSAgICBsb2FkZWRfdm1jc3Nfb25fY3B1X2xpbmspDQo+ICAJ
CXZtY3NfY2xlYXIodi0+dm1jcyk7DQo+IC0tIA0KPiAyLjQwLjEuNjA2LmdhNGIxYjEyOGQ2LWdv
b2cNCj4gDQoNCg==
