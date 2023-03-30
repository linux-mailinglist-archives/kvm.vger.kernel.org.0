Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691746CF8C4
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjC3BgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjC3BgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:36:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D0E49EF;
        Wed, 29 Mar 2023 18:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680140169; x=1711676169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lF4XAgTLQhYuDO7vGf/X3W4Dj0Mlz6LcItpI65LKWpE=;
  b=GOB8al6x+xrNWhKPcEtU1nx7GGkCuDkXyQNm4uzYmA0tMfiepu1qg3R6
   ktGe8bKwWfhis1VgG36PxzG/s5a7UZBDiZJsq6799vkcWGxOjuKI5qwEc
   2fJNDkWL1JHu177o/yJxLVljn4b/oYPPNgqUOHP7fJUr6quyQCGD1SWDL
   3FwBgcyafuEadIzEuwqDLvHvPeaz81m1y8XRwtsbe3IHdBdwL5P7hdfHa
   tgiEvmVn9nUH+ISd41YlpxCenRc433nbmtJQMAU6XzmZ0qmb8DEay8xJO
   Gl3gLrxeSOZ9atLOAocSomROw/MVv6U91eiW8txXI0+8CFMrkl8VCeVP9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="341062394"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="341062394"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 18:36:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="687045428"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="687045428"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 29 Mar 2023 18:36:09 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 18:36:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 18:36:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 18:36:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxfEl8FD8oLCbu28pfrlVoybBoSXjx5gQQf9msj5VnDUb1jjKa2Vddfo+7NZjfD/gSSCurf0HB9srr7l8QIeLXQg+6pHUbb1QGKe1Z2E+uL+lp4F/ztvyjvDj/XSi3RRuMRUa73WS+PVJ1ldXyNxn5ZqRR3RxnvrJojuW3ZlyqAurS8RLG+PDhbk/VTiScTKO90613nkhTipLR4bhaofJecjNLTkArTQ3Rg2FJNzb8rgi2WjxKYz+bdM6P4yrBDj0K0Ayhle/ZgHWCHoIsEyYcvpH89AJPCOAL/Sd4xQjclWSr8tsYFbb5Jc7TOArwX05V1Q1KZzuac4MH3vv1hmBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lF4XAgTLQhYuDO7vGf/X3W4Dj0Mlz6LcItpI65LKWpE=;
 b=bnFO28Y2jylu5GsNAhEnLlbtOPncnBC/a5K8KAHqoBsAFv9OPobm2+nQgblB4tVF3rl74GssDfUlBPzK8ffu3WMfLjLCOS7JmO2ESLuENR0dUnnkXC6UD3NE8vjn3Oe/Fen3x/KedNpMF1ocDL9euBOLSCAzYmq5596JYfwaksW8rfmRDW94eyc5uVSwNGUAYJZ8+lMN6KqsO0pqwXhHH68oIGWYIKdUGD1PDy6TTPhATIlvLHiGQj2dEtLSwZmj/X2gNlpN6W6VmWE3+othDQtO6WHBndfR147ACa2/co2NwsgHQ+ERQcL7z5ZePNigodK0UxxY4xYxeH54cTraEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6345.namprd11.prod.outlook.com (2603:10b6:208:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 01:36:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%6]) with mapi id 15.20.6178.038; Thu, 30 Mar 2023
 01:36:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 057/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Thread-Topic: [PATCH v13 057/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Thread-Index: AQHZVQw3kEskAU/Ee0qwjXZZkrxQv679PKiAgA2G2QCAA7atAIAEJhIAgAAFoAA=
Date:   Thu, 30 Mar 2023 01:36:05 +0000
Message-ID: <058c0dedfc3464a62085f071f593796c6fb9f072.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <cbfaedb652dad85f4020a2dcd74ac4abb5c14ac5.1678643052.git.isaku.yamahata@intel.com>
         <b3198a621a39d4c277ddf540e7a492953dc3637d.camel@intel.com>
         <20230325011200.GB214881@ls.amr.corp.intel.com>
         <a10d63840b02c4bbe1c027e5f230e4799f87ddda.camel@intel.com>
         <20230330011554.GD1112017@ls.amr.corp.intel.com>
In-Reply-To: <20230330011554.GD1112017@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6345:EE_
x-ms-office365-filtering-correlation-id: e59adc9d-e9a3-466d-715f-08db30bf2107
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjbju5lXngvKS1dn+Y+B3KesJA9LomcQm/NuflUeT+Kslu8Scq8jQAGmuhW5w8/x9E0j5dqgr6aRJGKvxd+TZvLxcIyaDdt+BE7dOgHIdShZ+M8WBq/Q9hRhd/R7hZSk77TU9juLSgXEKSjOhxlfoiP0kZbVd40Gpa4LMgsKc5CzpHAZLiGRKIA463y4KwX8yJM5H6I8PPXljxFY+S96tFDrwnQPpCKkQup6mzOatc4UqPd7lDqPhjCAGjM1/zLFQPfM4skhxsRjEj5msMhsI9bZcK47BgmN+LztlVAmAb3Urre4VkesOdaZnU0UtUTbo/5LrD0hSEyKrXvOHToGesBYESL73gdCfUfTw1Y5y8mmXZnXENgruSrzbpv2907zqJNoK7p+uClZqNHATQE1DBxfLrK+iAKV5JQCE5n1d7vP+a1R4SjprmuxyD+Lx7pW1jMXbaVw9YCmBh37ezdi0ZnpwYmglORpA7dWGmGEhKCo50dIi+hmacpgvt3uJYbKs50OtRd1aIVtcLJ5m3+UfAbNilc0Veav0DEPySMpzrlY5LU0/RhaDOwO2AcUoS5ohgO1laYtNW1MMmQltU0syPx+zimuhspJx4y3aX3eTtX8olv2r0ALwMQ7Nhrz0DTo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199021)(86362001)(38070700005)(36756003)(2616005)(186003)(5660300002)(6506007)(26005)(8936002)(6512007)(122000001)(82960400001)(2906002)(107886003)(6486002)(83380400001)(71200400001)(91956017)(41300700001)(4326008)(6916009)(66946007)(38100700002)(54906003)(316002)(76116006)(66446008)(8676002)(66556008)(64756008)(66476007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1pGQ2JsaEw3T3FpUFZoeGtGdEVQWjdMcHVkTGZuMkpRamo5WWZ2RTJnRm9y?=
 =?utf-8?B?OHZzVnZrUVViSFk2alVRSDYyaFBDV0dkbUhUaG5wM2cyMkxxQ0JncGRTZXA3?=
 =?utf-8?B?ekZPMGhTSk1oRWxHdlhHMk1SUllSdnpiNlEwRjZudk1mYWIvb3pTNHRHbDd3?=
 =?utf-8?B?M21NNHQwLyswRlJKT1VUWmZhcTMwRTh2ejViYjFHYzJoTGpRZ0RIRnhWVTF6?=
 =?utf-8?B?L2UzUkdKeFRLcmllWExvVDdLdnZoRzN1VXRjRVdXUWl0ODhJdTV6dnc5VUZa?=
 =?utf-8?B?a3o1QVZPMUFRbjNNL3ZlckllV1kwMnpKdXlNdDhtK2EvWjVxVGpFMnY5OTZj?=
 =?utf-8?B?em9hbS9xS3cxVTUydy9WUzM0eUY4ZDdrOHZRSFpIeXQyM3Y5NUJHZG1CQzhL?=
 =?utf-8?B?RW8rTzN6dy9YTGkra0dTZXN4VXArRHNJdmFHMEpvTDFURHVKZ1ZPUzBUaUFG?=
 =?utf-8?B?K1VzL3ErdzhqRThnTks5TmFvNkFqRXloN2FpUDUva21QUnlucnE3dzQ1bDlU?=
 =?utf-8?B?MDlodEVHaXZjNjNPUGorb0gxdWxMRDJmVWF3bmY1aS9DdXp0QnVhZkEyQk16?=
 =?utf-8?B?ZlB1NmdGeElNZUtKaUdTMHptZGJkdlNFalErTUJvYjIwcndzTEQrS2V1bVgz?=
 =?utf-8?B?blpGYlJic2dBQXNkSjlPZzVYaTVhakxqNUFqQ2xGN3JDZ0lvazA5WGcwclFC?=
 =?utf-8?B?cWNWU0ZEZytLT1laMGV0MWFEZHBSODlQVjkwT0NiczNyWTIwQWZQd2Q5dE80?=
 =?utf-8?B?aFo2dXYrQm5XZFNsemRRV09CL1dlR0kva1RNQmpKTE1SYk1JWFJUZm5oMDBo?=
 =?utf-8?B?bVBjbUNIUVNXK1E3YjBYeXQyNEtTalBHRWR1ZjJWMnlvdnM1NVhRNUhEbHpS?=
 =?utf-8?B?WDhSSFR6d09CL2o3UllCaG5lcTZOQ1ZwYTIzUGlSNVZUNGFhK0RJTStwT0dK?=
 =?utf-8?B?bUxNTmZ1c2EzeHVzeFhaM2hOVGlOVTZrd2J6QjBMVVFZcWpDb3JFOUxBNHNE?=
 =?utf-8?B?MTFNV1VOeUZGbEdGWGVoM043b2NENTFDRDUwNHAwUkFUVUEyMGN2Zk96SWQx?=
 =?utf-8?B?VlZ2TGFHWjZFYjFUWDlLWVErOTJtc0pSRUdKT3ZmT2tSQmtPZWpTL1VTR2tO?=
 =?utf-8?B?VVQ5ejdHSGJuQWZmNFEzVStPVGhXNnZPU1pSZjBDU2l6WE9HTCtqcmlSdUFa?=
 =?utf-8?B?emNYRlVKRUtTZmZKUC82clZFQS81M1I1VVhyZmo2b3gwSmdlbWlEU1BCanVS?=
 =?utf-8?B?LzNBZm1ud0lrZVVCeGNBanIva2RkbXA5MnNNQ1IybzB6eTZhODhFWUVLdENv?=
 =?utf-8?B?bUM4RnpGVU90ZDB1d284cS9pclBSL09IV0grSEZ5a3NJRUpiSkhMNjFuR0dG?=
 =?utf-8?B?WGk1Wk4xbVdLVTdOU29vQmZyeXh2SFB0OFVRTXFxQkJCeHNtZm9qVXRnM2Mw?=
 =?utf-8?B?LzNaamkvVDNQL2RSTmp0dTRIQVAybUFxMlc0Zk9OVDhLSGN6cnNBTTUrU0Np?=
 =?utf-8?B?NW1LaENEVG1FeitMeUVKRTZuZnNWWnY3YlE2bDhHaTJoVWJWQjV1ZkloYWZM?=
 =?utf-8?B?R1ZsSk9hU254ejVTM3dnYmR3V203Z3pkVyswWDJ0M3R2TjVOTzlGb0JCVVdl?=
 =?utf-8?B?VE01RkN4MWtUMmYrTUdXNU13UzJ2aWo0UEhrcmlUdTJEemJoQzJWSW42azU5?=
 =?utf-8?B?WjFia01HaHBrWEN6d2l5aE5kQVlpVHVRM0gxMVAzMFprcS8wdXZKcTFJS1R0?=
 =?utf-8?B?cy82S2F6cFJhTmFqS1h4YVE1aW0ycmZDUDZIY3NtditPdEZpaUZjUnZKUlIv?=
 =?utf-8?B?Qm9jMS95bGcvdDVhSzYrbWUyd2hLR2FOTjZMWEZ3eW4xV1ZzTWg2Y25keUFp?=
 =?utf-8?B?cjFTTlowd3BUeDdpdDQ4UUJmdm5CaFRRY0xEU0RjQkRTdFE4bmRJSFRtdGpL?=
 =?utf-8?B?cjQ3c2xNanR2TTZDRVVMRFVqQytWMU9hYllrMFpia2ZySVpnRHJEcTFROXJQ?=
 =?utf-8?B?VEhSRzFxLzFFc050T3c2NWswdVhmMDZLSC9vNFQxZU5hZE80aWg1Z2dNbGQ1?=
 =?utf-8?B?NllFYnI4VmtiSjNiQm0wSC8yZElKcWVTRXpkR0lhbFFsUHlDcDVkQ0dHK29I?=
 =?utf-8?Q?3xNZvmoPzOUPSz0QIacfxTh93?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <241F57A6653BDC44B3B71E04D009BBC2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e59adc9d-e9a3-466d-715f-08db30bf2107
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 01:36:05.3454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nc6Zw5zULT/1r1Gimf2u7kwyn1mFad0nLaU1JBilMz2s4oLR0cUuHg8nryDFBap6MntXNMrEDXo0Pq+0tcEkKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6345
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTI5IGF0IDE4OjE1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gTW9uLCBNYXIgMjcsIDIwMjMgYXQgMDk6NTQ6NDBBTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gPiBkaWZmIC11IGIvYXJj
aC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiA+IC0tLSBi
L2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4
LmMNCj4gPiA+IEBAIC0zNDcsNiArMzQ3LDI1IEBADQo+ID4gPiAgCXJldHVybiAwOw0KPiA+ID4g
IH0NCj4gPiA+ICANCj4gPiA+ICt1OCB0ZHhfZ2V0X210X21hc2soc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBnZm5fdCBnZm4sIGJvb2wgaXNfbW1pbykNCj4gPiA+ICt7DQo+ID4gPiArCS8qIFREWCBw
cml2YXRlIEdQQSBpcyBhbHdheXMgV0IuICovDQo+ID4gPiArCWlmICghKGdmbiAmIGt2bV9nZm5f
c2hhcmVkX21hc2sodmNwdS0+a3ZtKSkpIHsNCj4gPiANCj4gPiBBcmUgeW91IHN0aWxsIHBhc3Np
bmcgYSAicmF3IiBHRk4/ICBDb3VsZCB5b3UgZXhwbGFpbiB3aHkgeW91IGNob29zZSB0aGlzIHdh
eT8NCj4gPiANCj4gPiA+ICsJCS8qIE1NSU8gaXMgb25seSBmb3Igc2hhcmVkIEdQQS4gKi8NCj4g
PiA+ICsJCVdBUk5fT05fT05DRShpc19tbWlvKTsNCj4gPiA+ICsJCXJldHVybiAgTVRSUl9UWVBF
X1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQ7DQo+ID4gDQo+ID4gSSBndWVzcyBpdCdz
IGJldHRlciB0byBpbmNsdWRlIFZNWF9FUFRfSVBBVF9CSVQgYml0Lg0KPiANCj4gT24gc2Vjb25k
IHRob3VnaHQsIHRoZXJlIGlzIG5vIG5lZWQgdG8gY2hlY2sgaXQuICBXZSBjYW4gc2ltcGx5IGRy
b3AgdGhpcyBjaGVjay4NCj4gDQo+IHU4IHRkeF9nZXRfbXRfbWFzayhzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIGdmbl90IGdmbiwgYm9vbCBpc19tbWlvKQ0KPiB7DQo+IAlpZiAoaXNfbW1pbykNCj4g
CQlyZXR1cm4gTVRSUl9UWVBFX1VOQ0FDSEFCTEUgPDwgVk1YX0VQVF9NVF9FUFRFX1NISUZUOw0K
PiANCj4gCWlmICgha3ZtX2FyY2hfaGFzX25vbmNvaGVyZW50X2RtYSh2Y3B1LT5rdm0pKQ0KPiAJ
CXJldHVybiAoTVRSUl9UWVBFX1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQpIHwgVk1Y
X0VQVF9JUEFUX0JJVDsNCj4gDQo+IAkvKiBURFggZW5mb3JjZXMgQ1IwLkNEID0gMCBhbmQgS1ZN
IE1UUlIgZW11bGF0aW9uIGVuZm9yY2VzIHdyaXRlYmFjay4gKi8NCj4gCXJldHVybiBNVFJSX1RZ
UEVfV1JCQUNLIDw8IFZNWF9FUFRfTVRfRVBURV9TSElGVDsNCj4gfQ0KPiANCj4gDQoNCkkgdGhp
bmsgZm9yIHByaXZhdGUgcGFnZSwgX3RoZW9yZXRpY2FsbHlfLCB5b3Ugc2hvdWxkIGluY2x1ZGUg
Vk1YX0VQVF9JUEFUX0JJVA0KKGJlY2F1c2UgdGhlIFREWCBtb2R1bGUgc3BlYyBzYXlzIHRoZSAi
YWNjZXNzIHNlbWFudGljcyBmb3IgcHJpdmF0ZSBpcyBXQiIsIGJ1dA0Kbm90ICJwcml2YXRlIGlz
IF9tYXBwZWRfIGFzIFdCIikuICBCdXQgaW4gcHJhY3RpY2UgdGhpcyBkb2Vzbid0IG1hdHRlciBi
ZWNhdXNlDQp0aGUgbWlycm9yZWQtRVBUIGlzIG5ldmVyIHVzZWQgYnkgaGFyZHdhcmUuDQoNCldo
aWxlIGZvciBzaGFyZWQgcGFnZSwgd2hlbiBndWVzdCBoYXMgbm9uLWNvaGVyZW50IERNQSwgSUlV
QyB5b3VyIGludGVudGlvbiBpcw0KeW91IHN0aWxsIHdhbnQgdG8gaG9ybmVyIGd1ZXN0J3MgUEFU
LCBzbyB5b3Ugb21pdHRlZCB0aGUgVk1YX0VQVF9JUEFUX0JJVC4NCg==
