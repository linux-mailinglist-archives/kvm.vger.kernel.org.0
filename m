Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B33C622A5E
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 12:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKILYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 06:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKILYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 06:24:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056AC1901E;
        Wed,  9 Nov 2022 03:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667993088; x=1699529088;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Lqh0iZaJKqjvcMK+NCJIFnr0AWd/Sxrs8Vg+7WY3pn8=;
  b=d4wEMOmvoNf9k1MGlhpw3qzk7HRfb+G9ZPSZpawG8R/nbP3j3sKCTEfj
   pARPkr55jzU1tQ1rRqrZh/KHVJ43szAkPBzLRjoiYNpghsG9bGALm60+K
   qweaw3dK0zbZuRRJukS56ve4XKPGAHfqkal7jVB5XhN0KSGK+V0gik2dr
   ahkeR0xCfMWQ6qJ1GNb2B7WOROKLXkWHP8QxQkox+QAy5O8e/7LZWFlYQ
   hctx0srHmpS3NhxNI7svRTjh/HFd0VbsaIsUxRtOaEUy/eIWV1c2L0mis
   LgH7HdJTCe6J4tmJYT+GkKDJvZ4xKCCdcKxMGmzaFA4msRCWGn48GQZAU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="373099202"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="373099202"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 03:24:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="700323642"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="700323642"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 09 Nov 2022 03:24:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 03:24:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 03:24:47 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 03:24:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbBMJyQ4XQJ1277tvbbVcm5nUEsF2sdE8/rG8UJ2nPp5VF3NTMgMWF2EWltQZywwNZgeKMJ3mmLSiLE6wWWwyZX/xGUKNEO+yloqQE+g/i5WfYnOM74RXDE/0fIBYaKE90vYZJcuz3b+hyg9sRoUawcxK8Ci1zPZjJ7HKTNJ0A6rtzlq5Y82sVmlCgMwnxIngc7IFDmyUcNlpFpIZ8zF8u9yN+Q7guaZcKcK3tPqExdoX283YtYhWS5jtczwOnUXK29QRKYRQgGsU/q9f8q8sAPU+V3rTfL9R4gav/6qZzwAyayZVWZ+r6vI2d0H8bsK6S135ol+fqaPmsvXhuWJeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lqh0iZaJKqjvcMK+NCJIFnr0AWd/Sxrs8Vg+7WY3pn8=;
 b=aZY95fZFOY+JAcMR+vGLcwzoqkVVnZVMTg0On4T6dmgPxF5koCaQ4w2vobKKcqsaSQNF/NbXgJDyIDiIEgLoYNJkevS8F2nx9Wz8vmlHByrE9XZjrZGqU/3TVn+2IBlcJYu69lhz/lOsc+TnuSssFcUMaBNbmoWIu8S87OL8mTt+keRo7O3DWcGBzFUe6JCcHmCKM/f4+wQI4AeNUeu4wnSYsQep0nO6Apot0pjUGhYtnGYcteXhYsEhk0xEsR5jU95br3Q00KtcXatO/jm6tu+JRLjKIZ8kzEQ9Y2G1pJoxbX8DKOo6MWBpFk84dt83bkG7vUCySR/3E3miQZpCdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Wed, 9 Nov
 2022 11:24:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Wed, 9 Nov 2022
 11:24:44 +0000
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
Subject: Re: [PATCH v10 032/108] KVM: x86/mmu: Make sync_page not use
 hard-coded 0 as the initial SPTE value
Thread-Topic: [PATCH v10 032/108] KVM: x86/mmu: Make sync_page not use
 hard-coded 0 as the initial SPTE value
Thread-Index: AQHY7ChrbwhGj/8zMk2oUM0kWB1era42g2mA
Date:   Wed, 9 Nov 2022 11:24:44 +0000
Message-ID: <3f805b540780494c4a5b068287c37e40d71d7ba4.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <adcc3484605cb460a0c00ee5673c83f32a88e6ca.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <adcc3484605cb460a0c00ee5673c83f32a88e6ca.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4717:EE_
x-ms-office365-filtering-correlation-id: 4c5ac9b2-c0f3-4eac-5812-08dac24500c9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yt+8vNU5vxecf2MeKFicyqvz5t5kPF8DGBNhX5DvkjmKTGnt50reF4RVepbELlL8TcSYvhOLN0BQfBcmWlHcUqZv2iJzazgbe5oOcywE8gi2X6YAESB6H8WuL6qkaQXmMNdrd/ns9WbemIs2Kpss0CDdyg9xadrA/BLMwFhLXZpHkmc7XDj/bR7Ese96J+5FBQnlLRTP9mVhFv5JSmP9E0a/vps8xTD7T0rDnnSGlmPJlKaSZEXJjaaW95ummVE2gstSmS73RskGU1LAwZt/VPJdkJcSshu8aK4ym5vnSywD+rWPHaoStSwtG0x9fNCBenZe9qB19Sf6rFeouh2KIcxW9OGfnApCfPvb4z3h2N0FDCdT39Rqt7zo7w2dpYj920J3/4BL9BMOy7At3+lDdkJghJIPMdKo+tgRj7hZcplOQhINfQnOAG4TUz7iRFtjTthlteiW1P0t6mTkM6EyN7i3edJjXTnIcUacsy4j/KJZOpkO6LPNpooA6jocQGxfYIPGxj6e1AFnXYry/PYBz/wrKgyvuSnWcBBx/GyBBX9zqgNmuUqmGYSBFVqiAJGxkbO9NkJPOn7Q34+d5EkqOQilXzLmAj/Fjw9EjJQJJwLyr9xW01XkC9IsByU/RGkZqL44tyjYUfGjwlVquWZS4Lunv0NiTVzk6dZqykxP6moxg9QYcUTVSPtVEyUbKk4mvTUTySRaKnfUHRoJZuN0yACX56oQ38HMVImupLwzK90s9dU57jMuyJGyg9n0bznWZh5AIuHA5ua8gOVgXS+jog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199015)(36756003)(82960400001)(38100700002)(122000001)(38070700005)(83380400001)(86362001)(6512007)(2616005)(186003)(6486002)(478600001)(71200400001)(110136005)(54906003)(316002)(6636002)(91956017)(66556008)(66476007)(66446008)(64756008)(66946007)(76116006)(8936002)(5660300002)(41300700001)(4001150100001)(4326008)(26005)(6506007)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzNVK2ZnOGNWelRNNzgvaVRFY0h5QlhaamJZYlB0NWFUOGJ6R2tOcDI0YlB6?=
 =?utf-8?B?YVB5SUZjdENxMzFLN0dhbnlBTGowVkk2emU5ZXFhRHJxMXhsc2t0amdZN0VM?=
 =?utf-8?B?WUlCakFpanptQURTSHZsUjNDZFB3bVFjdjdNL2JoRG5nRUxMNzYzdFhMRGx3?=
 =?utf-8?B?cHhkc1RVT0hZS1FCc2NnczF3TXFwYlVMVmQ0RDk2ejhWV3k4aUtnbjg5cW1F?=
 =?utf-8?B?VEhoNkpYSWgvZWhEZWpvOHRGa2pHUmVBR1A0TmE4M3FHcEZCOUp3VmFCRStE?=
 =?utf-8?B?N3NwRUlnNTFNL0p6U3F3UGwwbkFsczFna1NIYmlvRUNyNTQ1aDZXR3YwRjg1?=
 =?utf-8?B?cjhvRU1rYmNMeVlMVkxwSXNQdmE3cWtNRVZnQVJuU1FXS1JSRW14UlF5aUxM?=
 =?utf-8?B?S0dlZWloTVUvWDRaWE01RFhOTWdZMzhHa1pTYjBDd2hHOGZRRENEQnZPMXl5?=
 =?utf-8?B?QU1aN0lzWkdjSnhPMTBHeHU2Yyt3bjFMUEZQQm5lelBSVDY0L1JjSi9XZktv?=
 =?utf-8?B?SGJwazhnTEVXZkRCb1BwZncyUXpJbGxuTllxUVdJdzV4dUxTd0luc2MyS2hY?=
 =?utf-8?B?Y1ZvWVRMd3YwWFFTNHdheUd5YndXcjUwc2N1R0RqOXJpWEJqQ01HNHBaSm5H?=
 =?utf-8?B?VTVPZ1FTRDFMNUlHYmNSVm5VMnlXOXlkZE5jWUlNdHJYQi9FY0N3QkpjQnVv?=
 =?utf-8?B?SUxYS1pFRVYzY3YyNnd1Z2daZWxPYXp5MEFNNjF5VGg1QU90dW4yem00T0lI?=
 =?utf-8?B?c0pIZS85bXNkem03V2Vma2hJZzBQdklBcUJFS3QwQ2RkMmVRZGlRM1RrYTRI?=
 =?utf-8?B?QWw4RFp6ZEZza0s0dHVNYzZ6ckVvNmUxSHB2MExHM0dsSlBVYUwxeFZmbUov?=
 =?utf-8?B?NVZLTndPNHA3WVBQQnhzSSsrSHc5c2N0S21SY3RZeWJGRFcyNFdQOFYrVU9P?=
 =?utf-8?B?VDRCaThCYWxLY1ZWdktzQTBLTTJXSm1vUEl4TXo1SGNrdGtDOWRPRlBKRytQ?=
 =?utf-8?B?bGpvc25QVmI4N3l5NnNaSzUzUFB3SXMrMWFiQ2tLRnYrWmE4UitSWnFBMVFW?=
 =?utf-8?B?MW1hZzVmUm90dXh4MzEyUWdJdVZKaERIVkVzLzBjYjQ0UmEwSGo1dFN4S3N6?=
 =?utf-8?B?UGMwWmhYeXpmWTgwQWFHdjRBajhCYmxOMDZNdjhTa3pnUXdWYW96MHFxMXZr?=
 =?utf-8?B?VVRaOHdZakVBMXIrWFVBSHMzSXBkeCtqMGpCd0E1a29leTNQRUM0dkJqNEVP?=
 =?utf-8?B?bWgwZ09JaExMWG5xUDFGTWg0d1NGYU90L2xnNS9TckNFeWF3UE9Hb2NidXUx?=
 =?utf-8?B?T1lkeVRIY01sSUxiaVVyN25GVDIxMGxjTnZOb2E1bW9GQWs5b1I5elBNT3Z5?=
 =?utf-8?B?cytPc0cydkdvSGorTFdDNFJvQ3dOaDBoN0xzQk9SdW9aMTZTVG56ckVVZHF5?=
 =?utf-8?B?MDNBc2ZxQjlXYnd1cEp5Y2pIRGdNa1FOSFhlM3hHL3p0QlBPT0k2Um1uQWtw?=
 =?utf-8?B?OTVhL3IxWG1POE8yR05CS2p4QWNTSkNwdDRjNTRTRFpIQkl1cVE4ZS9nSDMx?=
 =?utf-8?B?RzdqQ2pKemNhelFLRGFBdEY0dmF3Z2RuQmNiSGJYMldSUXYvWEh5LzFkb0VF?=
 =?utf-8?B?dUFZTk1hNGt6SjdsYkVIMGF4OHk2N0l2VWxKSHUvV3ZGMXpRQmt2V3A5ajFB?=
 =?utf-8?B?VlFuL3lBaWlrVDJKcEJnbGh0OTI4dkxjM2NGVFk4ZEtoeHgyOWhzd2xsUWVV?=
 =?utf-8?B?TFNya3o0SGxDS1B5VGQ5aUs2KzI5YWw2NElIN1JWV1BFdDlwdWxZMk01WmF2?=
 =?utf-8?B?RmlnUkFLc3VDRFFhQnVaakU0UUZIeWFyQUNPKy9nOXR2MW11QzVqSHBMM1Ir?=
 =?utf-8?B?dTJOUWNIeUxXRk5MTWpacWl0U1E0c0Z2dExsTnJuaEkzSUhKVE5qU1FJN0k5?=
 =?utf-8?B?K2FDRGVldjlCeDBQTTRIdVE3TGZ5VnMxeW5sYVBxOUFGUDFPUklQY2NMRWNt?=
 =?utf-8?B?YUhvRHlWcjVVK1JzeEZaSjZlV0tXckJNc2xORjU3ZjMvZlAzajZyMTVycHh2?=
 =?utf-8?B?aGpDaFgrK29qeFRtVGhBMlNmNllJQXcyb3IyL1lmUnBERkQyUkp2aitXRjBv?=
 =?utf-8?B?VjRmekozaTRRai9sMDJoSTI5N0RkUkRxcFd4R3NTL0F6U2VGQ3ErZU4vd05l?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D358C1793B85B438FD30A9F8CB07073@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c5ac9b2-c0f3-4eac-5812-08dac24500c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 11:24:44.7605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pJ6JTzBGQ0a2naXlVcCazzfLQ2K0YV8fDxJ0sgSE0pKnTzNJjqSQEwHRZ5w0x0smB0i5wdPqr+u8/8cB1dsJBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBGTkFNRShzeW5jX3BhZ2UpIGluIGFyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3Rt
cGwuaCBhc3N1bWVzIHRoYXQgdGhlIGluaXRpYWwNCj4gc2hhZG93IHBhZ2UgdGFibGUgZW50cnkg
KFNQVEUpIGlzIHplcm8uICBSZW1vdmUgdGhlIGFzc3VtcHRpb24gYnkgdXNpbmcNCj4gU0hBRE9X
X05PTlBSRVNFTlRfVkFMVUUgdGhhdCB3aWxsIGJlIHVwZGF0ZWQgZnJvbSAwIHRvIG5vbi16ZXJv
IHZhbHVlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFo
YXRhQGludGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L3BhZ2luZ190bXBsLmgg
fCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaCBiL2Fy
Y2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaA0KPiBpbmRleCA1YWI1Zjk0ZGNiNmYuLjZkYjNm
MmI1NTYzYSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL21tdS9wYWdpbmdfdG1wbC5oDQo+
ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaA0KPiBAQCAtMTAzNiw3ICsxMDM2
LDggQEAgc3RhdGljIGludCBGTkFNRShzeW5jX3BhZ2UpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwg
c3RydWN0IGt2bV9tbXVfcGFnZSAqc3ApDQo+ICAJCWdwYV90IHB0ZV9ncGE7DQo+ICAJCWdmbl90
IGdmbjsNCj4gIA0KPiAtCQlpZiAoIXNwLT5zcHRbaV0pDQo+ICsJCS8qIHNwdFtpXSBoYXMgaW5p
dGlhbCB2YWx1ZSBvZiBzaGFkb3cgcGFnZSB0YWJsZSBhbGxvY2F0aW9uICovDQo+ICsJCWlmIChz
cC0+c3B0W2ldID09IFNIQURPV19OT05QUkVTRU5UX1ZBTFVFKQ0KPiAgCQkJY29udGludWU7DQo+
ICANCj4gIAkJcHRlX2dwYSA9IGZpcnN0X3B0ZV9ncGEgKyBpICogc2l6ZW9mKHB0X2VsZW1lbnRf
dCk7DQoNCkkgdGhpbmsgdGhpcyBwYXRjaCBjYW4gYmUgbWVyZ2VkIHRvIHByZXZpb3VzIG9uZT8g
IExvb2tzIHRoZXJlJ3Mgbm8gZ29vZCByZWFzb24NCnRvIGtlZXAgaXQgYXMgc3RhbmRhbG9uZS4N
Cg==
