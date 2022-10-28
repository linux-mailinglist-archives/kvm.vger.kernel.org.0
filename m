Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705366106F3
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 02:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiJ1AsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 20:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiJ1AsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 20:48:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8DFA3B5A;
        Thu, 27 Oct 2022 17:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666918080; x=1698454080;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zWpNRir+oRPB8Fz11eZoNywUbEaK6PEz20BrpGDRA2Q=;
  b=Pm0Z+lTLpz3jhqEmRpWsdm/ASl3JJ6tBHkLu//4OdgkPYC2mACcqpzZi
   U3ATx33B9wyXt3E0wQk09ONG0laDtI7zkXghxjiACjvX1HeFU73u3PYq9
   mhbY/zimFWbZEqZsRiKE7KcJ0hIXoV1eWicjUCBG9SzvDa6pjkh6VmqtL
   O3Ano/p3OcRIfoGMdhq2jmbj2Tiv2qSReR1jhV1x2DkncHVc3lKSzUpOn
   lDBzIH5Kpw+Db91x1Yi7gOEK6dtfolyWj4LZ0xE3uDv6ulPAdc0VjzYOF
   uboaFW26TKEFYdCBppE2fChPpd13TyR8aVd1qSAPujMY83w8o93A0wYVA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="309470914"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="309470914"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 17:47:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="632603533"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="632603533"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 27 Oct 2022 17:47:58 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 17:47:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 17:47:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 17:47:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzHzRVMR3ldEC0FZFClQKgoMCuao5PeuIMZr7hyaw9/YJjG/rv+dYVlJ34kx2irKjh2Pniq+5PCAAwQ+Ryi6zT+WOgmphZpkkWG4kAw0lZNd/6JuUwA8eHmefQMRTBiYuWD1yO1ZKOK4dC2vB0xTJBOtwN8JL1E2efae1J41Ugz3qBgIlBLA2CI30F86yi8B4bPw4svOUYtv90wR/Zuz8m1WRC7plsDzbclBz90Z1l8vsF4o3c3T0hVJMLl+mSZpaND6P4HMZIVgIjvBw4HZVI7F71iY121smvjuLOyJjK3me1+yNp+Hn4lOuoNuk7hNv1N+xg87ZQxwMIvOgTmong==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWpNRir+oRPB8Fz11eZoNywUbEaK6PEz20BrpGDRA2Q=;
 b=OcGshbj86/E5RCESK7olsU7vdWkk0jaPYgqnZ2fozBy5sjbw8IrbPyvdOhshtZd5KNEFSS5+XwZb/P1t2WgsPDVPr4f70O8ABXRzSA05M0pYGBH48fsaR2bJkWfRnPZaIzeUp019my44I7EsJFV0DOo9rEOmqWCYsKyJ0LJDwYgkhDIYnVR2d3f4+pJucasfbC14S4rB1E1ah/9YyJ1LQ3o7pdP009nK+dN0FSXzvs1EtJolPZ5EzTEg+CCDpS2Dk02Vt6K2JaosQurAfiaTvtIUdnv+31izPH7dArWR4taL9hTHIcBT5DW78rrwzFPVjqYIq0neFrMwjUHvuYt6qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6155.namprd11.prod.outlook.com (2603:10b6:a03:45e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 00:47:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 00:47:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill@shutemov.name" <kirill@shutemov.name>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX
 supported page sizes
Thread-Topic: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX
 supported page sizes
Thread-Index: AQHY6Y2c1fkWJEN4oUaD5m/zaHt0F64h0pYAgAAaVoCAAFZsAIAAt12A
Date:   Fri, 28 Oct 2022 00:47:52 +0000
Message-ID: <57c22600dcd58eb5b29ee4589866cc0c2949130a.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
         <80e8111b-76a2-4999-782b-fdd4b9f425fa@intel.com>
         <d19c81ef34856f72c964322a7390d6fa21976e6f.camel@intel.com>
         <20221027135134.ya62y6lg2kh4yujb@box.shutemov.name>
In-Reply-To: <20221027135134.ya62y6lg2kh4yujb@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6155:EE_
x-ms-office365-filtering-correlation-id: bdb53cff-6174-4d24-e56d-08dab87e0b6a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +BJOzB8gXLNBIym93wJiUSvQMhtVyGmNZks8/1btBRG9XC8NY/VxtGuHqcKnOzd3OFoZWMsU94zurnIR8xvssbU4pb349YnmcLueb47TesZnydRA1d2bgIzHR/NCXvnjCd/v+Bsu7xSIzLHUxGdidEVQysi6kJA3Dng0yNZJdbOwNGlHo2F8xJaoJyGL+r1ljjzIVuIE6DUd1lgJX/henTgW8yXllyKoBHZmdDIiS30gVwXJrK2e60Me5fc104Kk+aBvqxROBOcBSPAmlpC1QBPM1CvOEEc096KDK/iFUdrMAwaOAUtrAuBo3Z2l25ciTfr+An7Y2BBaMCFcTJ/GMxTiZSzBGZeEX/rn0o6Td21Y5gjQxI2dQ8DrJinJjHKfTXj49IAHZyI1wqlpmRhMZnuBUQXEjI0Pd8khPJunpHBXhpH2dKlW6/MNQu8V8EzPz36gwHCS//7wv616Aq+5yqDBJWykwQcn22NdCKtk9O5mMq5xerxkW0yVFKgcqs2RuAOuCaTcRy9LX4pNTSyap977yJd3Us9xUSiYsTgmer2xr1qcM/Hnw8VrnxBIhGo/sCie35oVAOZcZlOAi2HjP86SvMBzx9XpyREQlQjZPnuN4n242IZckisNj2MAN+ypX3cqdgT5hPTJLu5aYZGlRiG9V8jYJl15DJPGLInPW2jCQiaxKRe4MdsceD1znBE7QQOB5Zh4/566fIqd+tb1w9xO/W5kfJXsClPwMYqndqrvp7Rs8CAdh5xNa/LSddSVNG8lvPg6QFmYKTT1mcQcIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(26005)(36756003)(122000001)(71200400001)(5660300002)(6486002)(7416002)(4001150100001)(478600001)(316002)(4326008)(38100700002)(2906002)(6512007)(91956017)(82960400001)(8676002)(8936002)(6506007)(186003)(2616005)(38070700005)(76116006)(86362001)(54906003)(6916009)(41300700001)(66446008)(66476007)(66946007)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVN5TGEvT1gxV1ltdExxeHprcWtoMVF0T1RtWVVmSVI3RUkya091RUxla2l4?=
 =?utf-8?B?L0d1dVc2RnJvOWFPMWxGNWsxcEpBcmEzeExZWUxrKzRoa3czdWtPYUI4Um02?=
 =?utf-8?B?OVI3M1kzbmZNMDlEajBCcHdrREMxdHNVcTRJSjhyWlp0a0t6T3E3clpkbExs?=
 =?utf-8?B?ZHhXT2JhcVZkK2xSTjdHcUE0Vi9tQ0VBQVl3SG90TTllRUpwcWVUSml5R1NL?=
 =?utf-8?B?RlorMUVTR0haSzB1dS9TcXFLUzhucXhQdkJ1bGF2NmNaU2phbUdqL0QvcXpJ?=
 =?utf-8?B?TjhtQ2YrVmJ2anN6LzVSNlFEUHJYUUJ5TGhjSS9mVXBPbWUrRHNFSXViMW9Z?=
 =?utf-8?B?Z3VocDVQTkpQOHdscThBMnlBVXIxdk9YZHlzQ2ZpY2lpdzVsd1gzaVlneHhQ?=
 =?utf-8?B?SmM2UjgrbldwUE1IZGhYanU0RTRGdFMwNGxNUDU1SDZMT05wRVYyMmhZQ3BZ?=
 =?utf-8?B?eXFQYzhtUVRObkR5Vmp0OTBBaElMcmpwMDk1azJRaE5ZMEYwQ0wwLzc4Y3Fx?=
 =?utf-8?B?N0dmRmlIRkpHbnZzTlNZYlcyZ0dPQnBYK1FxVmd6SnYySmdVbzAxbXlpbE9x?=
 =?utf-8?B?UGY2cHg3eis1NHViRWhNMHNvZldHQUdpTG5nVHBYem1YNjVmWnZRQm55Mi84?=
 =?utf-8?B?MHE4MWh1a2t1bnU4ZFlLWkRSVFBhbTNJR2x5d2xLU2xoMnBIaVE0RDNuSmdU?=
 =?utf-8?B?ZHc4MkQwUWk0WVhrT05tVWlZT2xQeHV0N2tKNDE0TXFxaWlrczlkRFladVRr?=
 =?utf-8?B?ak5rWTRHTFNPcDRjV0RiZHp5amZrc1NjRXlvOU9CbktXYzVqTEpuaXA4MVJq?=
 =?utf-8?B?bkxaY1BheU1hZUp1dC9CejU1WTJ5UmxCK0M5TkdJdnNuYnM2dnJWUmlscVNw?=
 =?utf-8?B?VitBVGh6azgzYi81UzdiREVBMldjc1RFdm1OUVRrcTE2Y3BoRmlGVkxZTXVK?=
 =?utf-8?B?SG9IdG8rVEpRaVB0L3U4NzFVem41VXBVS1dnNVR2ZmhzQjlZbGZ3T2lKQ3dx?=
 =?utf-8?B?emtkeDhtYXNjcnVlS1VwY285anpaZnFHZGNndGdtTDliMGl0MFBLSDVVY08y?=
 =?utf-8?B?VWFqUXNwdjIwVmhFbjd5dzE5a014d2ZsOWVBdVNnTU41VWk1NTEzVWVGTy9Y?=
 =?utf-8?B?ZmNHUmlwMVJScmoxZVdJRExCYk9HUXliY0h3dnpEV0t1dE0yS2p5SDhaaEcv?=
 =?utf-8?B?RFZyajFZZk9sd0JNZm9oNGpWak1BNERuZ0FTNlZCTDlGaFN5UFlNM2hOcnBj?=
 =?utf-8?B?VTFoMUVFYlIwY0kzR0tQeU1hYjFyNzk3TkZpUnVVdWt4bHFpb1lNYnpHbEd2?=
 =?utf-8?B?cWdkMlZUNXRleEVMUzhWS2VqaDJMa0RIQWdYK0EvNWUyWjEwY1JBNGx0cGpw?=
 =?utf-8?B?aWUrUTFCdm1IUUo5WitaaGg5dkowaEY2eEkwWWt6eWhnOWNlNlJRWExqdkVr?=
 =?utf-8?B?NDBRck4za014aDVGMWd3dk1xYk9MWlhta0pWcmRseGFUbzVzaXFwTGZhRVFH?=
 =?utf-8?B?QkVyS20wN3FRb2M3ZjhaZGNIVzdFYVZSVVpQd05leDNRd1N2TExnS3ZsbEkz?=
 =?utf-8?B?NGx2b3F4SGFpV0xabVVUcmNrUThEN1ZQMjJadzVMZFhNejlva0dvb0l3bnAw?=
 =?utf-8?B?RFJGT3VMcGlqSmRPN3pZa2J6OUpScmhydHRrVHBWcEZkSXdEeWFmUDFvd2Fh?=
 =?utf-8?B?VzFFVHJDcVAxcXJRaFhQR1dqaGwzeTRWU1d6Q0l0MTJHVFlDcytwN0NkUmRK?=
 =?utf-8?B?NUZISUcvUmxQL3J0MGVTYkw4dEpWOTRBQVBvMW5aNFlWWWowV0kvWGIyKzNL?=
 =?utf-8?B?Z0E5eG1kMHVMOUR6eGhKSUI3WFNYWlhPeHlSY3J6bW5ibXdCbE1UVGpCMml6?=
 =?utf-8?B?NFpSOXVHR2NUZ2FNaFlZd1FQQVQ5UXJhZEp5L3EydU5TSkZMVEJZMzN2eFZW?=
 =?utf-8?B?akhOaWUrWm5KMlRMM3BQTXRUTnlyRkxaQUxWelovbXdZUTBnN0VvcGJsODBC?=
 =?utf-8?B?Qm4rOTUxQVZ5V2VGVjYxUGlxYmZuS2JHZzEwMVJ6Uis4bm1OdWtzd2hWb0N3?=
 =?utf-8?B?bEhRRUc0UHNQM0ZWd2dMSjNxMlpTdlNkeldCQStydHFYd0xuSEdoUXVqdkNs?=
 =?utf-8?B?dlR0RGJUU2lIT0NKWHNTODkwaEphR3ZxZktWekFKZXdDOUdYWjlKV1NCSXVC?=
 =?utf-8?B?bWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <572737A52411254CBD62BDE1BD927B56@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb53cff-6174-4d24-e56d-08dab87e0b6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 00:47:52.2822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8k6wJz/J+4/NyPZGW+n1FJk2AmgPQZwbH6rbO+aB2l1SXwIMvx9YztHWHtfTLW+C/yPjZNisUgaQG8cE04/Igg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6155
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDE2OjUxICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IE9uIFRodSwgT2N0IDI3LCAyMDIyIGF0IDA4OjQyOjE2QU0gKzAwMDAsIEh1YW5nLCBL
YWkgd3JvdGU6DQo+ID4gT24gVGh1LCAyMDIyLTEwLTI3IGF0IDE1OjA4ICswODAwLCBMaSwgWGlh
b3lhbyB3cm90ZToNCj4gPiA+ID4gQEAgLTY2MywyNyArNjYyLDE2IEBAIHN0YXRpYyBib29sIHRy
eV9hY2NlcHRfb25lKHBoeXNfYWRkcl90ICpzdGFydCwNCj4gPiA+ID4gdW5zaWduZWQgbG9uZyBs
ZW4sDQo+ID4gPiA+IMKgwqDCoAlpZiAobGVuIDwgYWNjZXB0X3NpemUpDQo+ID4gPiA+IMKgwqDC
oAkJcmV0dXJuIGZhbHNlOw0KPiA+ID4gPiDCoMKgIA0KPiA+ID4gPiArCS8qIFREWCBvbmx5IHN1
cHBvcnRzIDRLLzJNLzFHIHBhZ2Ugc2l6ZXMgKi8NCj4gPiA+IA0KPiA+ID4geWVzLCBhIHBhZ2Ug
Y2FuIGJlIG1hcHBlZCBhcyAxRyBzaXplIHRvIFREIHZpYSBzZWN1cmUvc2hhcmVkIEVQVC4gQnV0
IA0KPiA+ID4gZm9yIHRoaXMgcGFydGljdWxhciBURFhfQUNDRVBUX1BBR0UgY2FzZSwgaXQgb25s
eSBzdXBwb3J0cyA0SyBhbmQgMk0gDQo+ID4gPiBjdXJyZW50bHksIHdoaWNoIGlzIGRlZmluZWQg
aW4gVERYIG1vZHVsZSBzcGVjLg0KPiA+IA0KPiA+IEkgY2hlY2tlZCB0aGUgVERYIG1vZHVsZSBw
dWJsaWMgc3BlYywgYW5kIGl0IGFwcGVhcnMgeW91IGFyZSByaWdodC4gIEJ1dCBJIGFtDQo+ID4g
bm90IHN1cmUgd2hldGhlciBpdCB3aWxsIGJlIGNoYW5nZWQgaW4gdGhlIGZ1dHVyZT8NCj4gDQo+
IFRoZSBzcGVjIHNheXM6DQo+IA0KPiAJTGV2ZWwgb2YgdGhlIFNlY3VyZSBFUFQgZW50cnkgdGhh
dCBtYXBzIHRoZSBwcml2YXRlIHBhZ2UgdG8gYmUNCj4gCWFjY2VwdGVkOiBlaXRoZXIgMCAoNEtC
KSBvciAxICgyTUIpIOKAkyBzZWUgMjAuNS4xDQo+IA0KPiBZZXMsIGl0IGlzIGFib3V0IDRrIGFu
ZCAyTSwgYnV0IGl0IGFsc28gcmVmZXJzIDIwLjUuMSwgd2hpY2ggbGlzdHMgc2l6ZXMNCj4gdXAg
dG8gMTZQQi4NCg0KQWxzbywgSSB0aGluayB3ZSBhcmUgbWl4aW5nIHR3byB0aGluZ3M6IDEpIGxl
YWYgcGFnZSBzaXplcyAgKDRLLzJNLzFHKTsgIDIpIHBhZ2UNCnRhYmxlIGxldmVscy4gIFRoZSBs
YXR0ZXIgaGFzIG1vcmUgbGV2ZWxzIHRoYW4gdGhlIGZvcm1lci4gIEZvciB0cnlfYWNjZXB0X29u
ZSgpDQooYW5kIFREWCBob3N0IGNvZGUpLCB3ZSBhY3R1YWxseSBjYXJlIG9ubHkgYWJvdXQgdGhl
IGZvcm1lci4NCg0KS1ZNIG5lZWRzIHRoZSBsYXR0ZXIgKG9yIGJvdGgpLCBzbyBpdCdzIGJldHRl
ciBmb3IgS1ZNIHRvIGhhbmRsZSBvbiBpdHMgb3duLg0KDQo+IA0KPiBVbHRpbWF0ZWx5LCBpdCBk
b2VzIG5vdCBtYXR0ZXI6IGlmIFREWCBtb2R1bGUgZG9lc24ndCBzdXBwb3J0IHRoZSBzaXplIG9y
DQo+IGNhbm5vdCBhY2NlcHQgdGhlIG1lbW9yeSBmb3Igb3RoZXIgcmVhc29uIGd1ZXN0IGtlcm5l
bCB3aWxsIGZhbGxiYWNrIHRvDQo+IHNtYWxsZXIgc2l6ZS4NCj4gDQoNClllcy4NCg0KDQo=
