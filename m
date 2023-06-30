Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3B97438CC
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjF3J6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjF3J62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:58:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C051726;
        Fri, 30 Jun 2023 02:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688119106; x=1719655106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+EM0joyjZXMFqyXpZuuiXW0j1k8qWp0AtcQ+wbjoyDs=;
  b=Ml4qfA4szgZnIxzGAOVeZS9y9I/hZoLz25sZYtYQVSxwU6HOmJMyhdNr
   Ab7Gc4hJZO5viv6fiaXYRvN1nEzLf8M0T1HefTeiHgJOK47wp3PtyC6y+
   DEZyq5U3og0kXeMz4QYW4QTL3VyxCFKeiBbPJd8ug1TKq+KSVROVjcxbm
   JpGMvxvA4uteaZgrzrcG21bpzitd8MvpBqMLglzZ7xR8WkVtuJtLVZOlB
   I3qw6qsDcekOV1xE5dLt7ncJVy1i1aXQDAhPhPgVWrCV1R28nuf7WbO2+
   UlPZKqhGIEV1lu7fArepCscBJHrhAPiY99qt5rnsr0uSCjEDGfRXn3wVF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="393086446"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="393086446"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 02:58:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="752942265"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="752942265"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 30 Jun 2023 02:58:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 02:58:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 02:58:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 02:58:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GP7zbI1yZ5287852hoc2Rskbwynkm7aZm1e0/7lo+odqhZd5d/9E4Dae4YMYOe2UeLwSy4JIsbK/mBTh9VJM29Qsi6dh+GcYe0VBS7CNfGJJyylhGfql+5/aJDSvvmsfC5wf874GU0hQj9rFIknsYfeHnrTrlPo0h8xTjo1G/nUk8VET8uerWQmPc2fnfxoulPA41ZfezNue34EXsXuVxxb2AzpXPlpnyKJsg1t0fyNAHqUImFNLx7s1r06ZR7Zys1bbSX8DQVQGACpvx4HwkPQLYy5uITjPGaKD8TdFAhXh04ZW1Y1gNkGCIIpJolDI1xHO6oZ66B1KueshZeXfpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EM0joyjZXMFqyXpZuuiXW0j1k8qWp0AtcQ+wbjoyDs=;
 b=bGiVM5NAMgbzPyYawrN3ZP3jtJMtjIwgHA6o5br4JhDQhFWy1s8SndKTo/FtvfOmZySp/8OynAvLcKvR56LtLd1HFePDH36dFiwF/FnLb3uQfaRQICxIYKlJ2pT2t3SCsj8BBV7V1DRIaMOV0RfXkWsvF5mWs4aYO1EMx2u6L5iV6IPwU0EP0GDsPHd6L1ZSV88Klce02ZiN4FMWQgSohmFQu35PSo+qJ0k3HPmRsHg0OXDv/HE/4FiJmWuhU9OgxnKbVRpDzBsypTtyoZnxtw5NZbBagRZlsXKdWzMDC3hRRa+PRdgZK1vgqLx6Wd7rYL/1UCwiXn1cxRiunUAjow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB7702.namprd11.prod.outlook.com (2603:10b6:a03:4e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 09:58:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 09:58:19 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZqDWtVIac1znuLUmerNJjHJZ1la+gRBWAgAFABgCAAZesgIAABpaA
Date:   Fri, 30 Jun 2023 09:58:19 +0000
Message-ID: <9c23f44576a4c2757ebceaca453f387ba9abb764.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
         <20230628141011.GG2438817@hirez.programming.kicks-ass.net>
         <d759c22d1360a56aa43796700a7fa3a9106d9fa9.camel@intel.com>
         <20230630093443.GE2533791@hirez.programming.kicks-ass.net>
In-Reply-To: <20230630093443.GE2533791@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB7702:EE_
x-ms-office365-filtering-correlation-id: 68d2ff1e-85d8-4f8a-f068-08db79508879
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mnhj1lj9K+SXnjz1YZF/ypIEINK88HKIUizNlqXGWL86CJdrPaQMUy7x9NCbuZW48ceSWeax+K+5GBtVlx6nqr9PCSZ/Cdgmj0sbqNrHbwA+MbmUTNsIeVa0hEpe/rkqByq+h+3efMdUlLz3XU61zyxLPIz1K9iY3sMPEmjs2ZMMvMQmz8DqTWCvbl3IGHG3415PUHekE86ddMRoUXyIYf15ft62MfoNAybyntcXJATpjYoxsOMmbctTjpmCv7LLuRSzlBPH8kdBjFF1pUj5qScQG5T5UcNwWrLzIe/4RyWaKBYS2ufCpj2Y7B2fkzXAgGRq8q2oqotwzVKqa/KScmtre0DAGWhZJGtkgC1eWLd+qtL3cNg4s4qMLR3ecKXPKGwAhu4/a3NYA68i2m+MBKyFafCQqiiQdcIBiLTLb6HfBsBVHHCo1opDlyYfFDikf1IS3AwZaAUS1g0awxEnhadTvnSgrOEl4/ZXFuN8qxj4Af3th8YdQMmGJFLndn2E3Lae1FGZf/H56U2rcgZBR8WLFUlC459s1XMTxoKgDivDH2KaHo8DJ3WqwjBI1metUqEU/U0b2P40tysYxcUSt2ZBZfFOOX0O5yd3R66F6nQaJM9zIAS/LiCpyrYsqixdz8cjbo8rjcrN9T+TqxV+lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199021)(66899021)(66446008)(36756003)(38070700005)(5660300002)(64756008)(7416002)(86362001)(91956017)(66476007)(66556008)(41300700001)(6916009)(122000001)(8676002)(316002)(76116006)(4326008)(8936002)(38100700002)(82960400001)(66946007)(966005)(2906002)(478600001)(6506007)(186003)(6512007)(26005)(2616005)(6486002)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmE4M1BrQ0FpNGt6NmVMaGlaZGhOTEt6ZEk5czgvcTJ6NmV3VGtQTEc0bXhl?=
 =?utf-8?B?V2RHKzFhUkYvSG1ETENKVUw0UlByU3dURDZFWGFtWlhTd1pkSG5aSXlhT0FG?=
 =?utf-8?B?MWFxeGFvTVlPOUgyU2dDQ3FVampodU5CUWR6Y3J5ak1GZXVodlBQVSt4SUtF?=
 =?utf-8?B?aWNCdE5xUWN5empQYzRCU2FGSHVVVUJyR2F5aDBoQ2txOWxLRjVxci9tM1Iy?=
 =?utf-8?B?ZXBqOWs3TFVPZ21SQ095b3hsN3N2bkhlODViY1dCS2hpRi80NVFmYlZpMG5D?=
 =?utf-8?B?UHVIY0pFRnFteElPcCtGS3BxNzNvZ1NKU0hqNzNIeDIrZWVYSGo0Y0p3YmJU?=
 =?utf-8?B?SktUdlR0ZHAybU1jcmFtUWZwU0dCYkF0aWZRMVZtZndJa2xvejBuQ2V3OFpH?=
 =?utf-8?B?WmkxQm5qS2lveUFISmtMeDc5S1RHWjByaXNHQ2JFeEpXTkEzelJyam44VzVS?=
 =?utf-8?B?Q21sdkYxZWRuWVgwRDhsUXRGR2xhbGxoSnBPODM1ZkFuMnFKRGRWN3Vacit1?=
 =?utf-8?B?SDEzWS8vNzNqQ2JlRHdxc2tLV2pBMTJNeEtWY0xUcGhiK2hRQjRwOU01VzAv?=
 =?utf-8?B?cTZ5eitmeDg3V1RVeGgwNlZrczRIWXhBZlpxcGw3YU9aYlF6NlQ0c2xYUnpX?=
 =?utf-8?B?azJHeERxVktsK2RlUFZOZlFhRHlnUmNpaWVUM1dUTUZxZi95cGJveS91b0VT?=
 =?utf-8?B?Q2xqV3FSUUtpU0ZYRklwQlNKM1kraDROT2NyaHg3VU5BTitDSjFyMkhvaFQ5?=
 =?utf-8?B?WDlyUVRKcHVWbmtKL3c2YmNVMHhxUCtsZkVLZ2V4aXZGUnNyQWQrQjF0S3Nw?=
 =?utf-8?B?VFM2Tjh1ZzRHUzAyaGN6NU5ibXhPa2J0ZGRCMTFreDJ0V0k2R0VyZWd3RUh1?=
 =?utf-8?B?ZTlVSmdlTXZxSWtIWFY2cVV4VTJkOHpzOGVwMFVva0N4b0YzLzkwelhxYllo?=
 =?utf-8?B?SklodXNlWjhQYlNQMDVuVjNwN1MvNW5LSzkwbG92Y01RKzVFeFBaZnlrM0FJ?=
 =?utf-8?B?d3daczZOS25CVlNFbG9ydUQ4VU9yWEdJN0tTdE9lWGlZY0w0QUJKQWRSQklO?=
 =?utf-8?B?dGpIZWxmTTJPZkI2RlcvajVldGtBUzUxSFJ4aXZyYTh4TDF5TEFFaFZGNFFi?=
 =?utf-8?B?WSs3SE5pdXFPbXBFTjNsRHFaczdlV0NGQVhXN0E4VTlsL1M4cjA3VFQrcjRh?=
 =?utf-8?B?QnUwckE3TlhGbnNmMWtTM05iTm56MkxJS2toWGgyWngvZWE4blBlcVNLSGtU?=
 =?utf-8?B?OFNleGpYSEYxbnRFTm1xdzRuSC8xRjdzRktaeWdLSitVYjZITk9BdGJkak82?=
 =?utf-8?B?RFdHa3hTR1RKamd4UUZPVHRtSXJ0ZHJ0alpTR3VHRWlIUk9rYytRM0E4Q3Ri?=
 =?utf-8?B?UStRMDNFemxSanNPb1g3d21nSnZ0S2w5MXY2YUQ2V0E0NWc5M0g1aUhzWTBV?=
 =?utf-8?B?NC9SdlFSQlJaL1ZJMDJhZkI5RHhrVlUvaVFvQUF6TjFaZXlnQk9uY0lpbEdP?=
 =?utf-8?B?ZUMrREV2b292WGREY3AzY2xkdHpGdnJGMjY2K3cydWVFZTlIWXFDYldmS052?=
 =?utf-8?B?QlBNWHZyeHJRaGhvMy90Zy9PZERSMGZHT1d0NUZ4MjF1d0lZaG9tMVVpTXg4?=
 =?utf-8?B?R25rT1I4N002STVJVmFSWVM5WVlEWUVWK2pFck9EMmtXRHlLWHlTNi9LcUFv?=
 =?utf-8?B?aTZuRVlGR3ZPRW1LZG5KVjJPY0d0MUdXaEMrb2tXN1RzOFp3OXVQNHZwbUtl?=
 =?utf-8?B?MElhUFFTTTQrS1ZyNVpMUjg5cGVTaU1qeGxEbHk4QmYvYUw5aERBb0k1NEdx?=
 =?utf-8?B?QUVBNUJ1Sy9jZy9IVzREMklWT2l4UTg4NCtiRDczSGUrNUhMaktXVjAvVS9a?=
 =?utf-8?B?SE9wUkYzb0xsSkpTeGtSNnB2WXBiaEhyMkJWSjJwclYyallxSkxoWWNMNkZy?=
 =?utf-8?B?QjNpcHM2aTRPSUYxWlM2MEpGU2R2ajMwbklvV3NrV2l5d2MyOU0vcTRsNFU4?=
 =?utf-8?B?NkJwR3BQODd2YUM1ZGtwNnArbDUzTFNrZ2NFMExtdTBKd1FNYXd1UHlLSTdJ?=
 =?utf-8?B?TUN6eDBHNUNlaU4wY1ltWFJBQlhNeWJEd2dSWldQL2VFb0Z5d1RiSGc1MmZQ?=
 =?utf-8?Q?WFBXoF6cEZgJCwsHa8ukOccRJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6490530CF7381E489931458B42DB8824@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d2ff1e-85d8-4f8a-f068-08db79508879
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 09:58:19.6489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zk9yz5gwkhrZ5RJK1vebT0+ztGdXZ/m8NOcE1wkCpdeklBXQCO2ppnKvIW+UoxJar7GBzVyuzD1XHOATlOzIMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7702
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDExOjM0ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMjksIDIwMjMgYXQgMDk6MTU6MzlBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gDQo+ID4gU3VyZS4gIEhvdyBhYm91dCBiZWxvdz8NCj4gPiANCj4gPiArICAgICAg
IC8qDQo+ID4gKyAgICAgICAgKiBUREguU1lTLklORk8gd3JpdGVzIHRoZSBURFNZU0lORk9fU1RS
VUNUIGFuZCB0aGUgQ01SIGFycmF5DQo+ID4gKyAgICAgICAgKiB0byB0aGUgYnVmZmVycyBwcm92
aWRlZCBieSB0aGUga2VybmVsICh2aWEgUkNYIGFuZCBSOA0KPiA+ICsgICAgICAgICogcmVzcGVj
dGl2ZWx5KS4gIFRoZSBidWZmZXIgc2l6ZSBvZiB0aGUgVERTWVNJTkZPX1NUUlVDVA0KPiA+ICsg
ICAgICAgICogKHZpYSBSRFgpIGFuZCB0aGUgbWF4aW11bSBlbnRyaWVzIG9mIHRoZSBDTVIgYXJy
YXkgKHZpYSBSOSkNCj4gPiArICAgICAgICAqIHBhc3NlZCB0byB0aGlzIFNFQU1DQUxMIG11c3Qg
YmUgYXQgbGVhc3QgdGhlIHNpemUgb2YNCj4gPiArICAgICAgICAqIFREU1lTSU5GT19TVFJVQ1Qg
YW5kIE1BWF9DTVJTIHJlc3BlY3RpdmVseS4NCj4gPiArICAgICAgICAqDQo+ID4gKyAgICAgICAg
KiBVcG9uIGEgc3VjY2Vzc2Z1bCByZXR1cm4sIFI5IGNvbnRhaW5zIHRoZSBhY3R1YWwgZW50cmll
cw0KPiA+ICsgICAgICAgICogd3JpdHRlbiB0byB0aGUgQ01SIGFycmF5Lg0KPiA+ICsgICAgICAg
ICovDQo+ID4gICAgICAgICBzeXNpbmZvX3BhID0gX19wYShzeXNpbmZvKTsNCj4gPiAgICAgICAg
IGNtcl9hcnJheV9wYSA9IF9fcGEoY21yX2FycmF5KTsNCj4gPiAgICAgICAgIHJldCA9IHNlYW1j
YWxsKFRESF9TWVNfSU5GTywgc3lzaW5mb19wYSwgVERTWVNJTkZPX1NUUlVDVF9TSVpFLA0KPiAN
Cj4gPiBPciBzaG91bGQgSSBqdXN0IHJlcGVhdCB0aGUgc3BlYyBsaWtlIGJlbG93Pw0KPiANCj4g
PiArICAgICAgIC8qDQo+ID4gKyAgICAgICAgKiBUREguU1lTLklORk8gd3JpdGVzIHRoZSBURFNZ
U0lORk9fU1RSVUNUIGFuZCB0aGUgQ01SIGFycmF5DQo+ID4gKyAgICAgICAgKiB0byB0aGUgYnVm
ZmVycyBwcm92aWRlZCBieSB0aGUga2VybmVsOg0KPiA+ICsgICAgICAgICoNCj4gPiArICAgICAg
ICAqIElucHV0Og0KPiA+ICsgICAgICAgICogIC0gUkNYOiBUaGUgYnVmZmVyIG9mIFREU1lTSU5G
T19TVFJVQ1QNCj4gPiArICAgICAgICAqICAtIFJEWDogVGhlIHNpemUgb2YgdGhlIFREU1lTSU5G
T19TVFJVQ1QgYnVmZmVyLCBtdXN0IGJlIGF0DQo+ID4gKyAgICAgICAgKiAgICAgICAgIGF0IGxl
YXN0IHRoZSBzaXplIG9mIFREU1lTSU5GT19TVFJVQ1QNCj4gPiArICAgICAgICAqICAtIFI4OiBU
aGUgYnVmZmVyIG9mIHRoZSBDTVIgYXJyYXkNCj4gPiArICAgICAgICAqICAtIFI5OiBUaGUgZW50
cnkgbnVtYmVyIG9mIHRoZSBhcnJheSwgbXVzdCBiZSBhdCBsZWFzdA0KPiA+ICsgICAgICAgICog
ICAgICAgIE1BWF9DTVJTLg0KPiA+ICsgICAgICAgICoNCj4gPiArICAgICAgICAqIE91dHB1dCAo
c3VjY2Vzc2Z1bCk6DQo+ID4gKyAgICAgICAgKiAgLSBSRFg6IFRoZSBhY3R1YWwgYnl0ZXMgd3Jp
dHRlbiB0byB0aGUgVERTWVNJTkZPX1NUUlVDVA0KPiA+ICsgICAgICAgICogICAgICAgICBidWZm
ZXINCj4gPiArICAgICAgICAqICAtIFI5OiBUaGUgYWN0dWFsIGVudHJpZXMgd3JpdHRlbiB0byB0
aGUgQ01SIGFycmF5Lg0KPiA+ICsgICAgICAgICovDQo+ID4gICAgICAgICBzeXNpbmZvX3BhID0g
X19wYShzeXNpbmZvKTsNCj4gPiAgICAgICAgIGNtcl9hcnJheV9wYSA9IF9fcGEoY21yX2FycmF5
KTsNCj4gPiAgICAgICAgIHJldCA9IHNlYW1jYWxsKFRESF9TWVNfSU5GTywgc3lzaW5mb19wYSwg
VERTWVNJTkZPX1NUUlVDVF9TSVpFLA0KPiANCj4gRWl0aGVyIG9mIHRoZW0gd29yayBmb3IgbWUs
IHRoYW5rcyENCg0KSSB3aWxsIGNob29zZSB0aGUgZmlyc3Qgb25lIHNpbmNlIGl0J3Mgc2hvcnRl
ci4gIFRoYW5rcyENCg0KPiANCj4gPiA+IFNETSBkb2Vzbid0IHNlZW0gdG8gYmUgdGhlIHBsYWNl
LiBUaGF0IGRvZXNuJ3QNCj4gPiA+IGV2ZW4gbGlzdCBURENBTEwvU0VBTUNBTEwgaW4gVm9sdW1l
IDIgOi0oIExldCBhbG9uZSBkZXNjcmliZSB0aGUgbWFnaWMNCj4gPiA+IHZhbHVlcy4NCj4gPiA+
IA0KPiA+IA0KPiA+IFREWCBoYXMgaXQncyBvd24gc3BlY3MgYXQgaGVyZToNCj4gPiANCj4gPiBo
dHRwczovL3d3dy5pbnRlbC5jb20vY29udGVudC93d3cvdXMvZW4vZGV2ZWxvcGVyL2FydGljbGVz
L3RlY2huaWNhbC9pbnRlbC10cnVzdC1kb21haW4tZXh0ZW5zaW9ucy5odG1sDQo+ID4gDQo+ID4g
Rm9yIHRoaXMgb25lIHlvdSBjYW4gZmluZCBpdCBpbiBoZXJlOg0KPiA+IA0KPiA+IGh0dHBzOi8v
Y2RyZHYyLmludGVsLmNvbS92MS9kbC9nZXRDb250ZW50LzczMzU2OA0KPiANCj4gWWVhaCwgZXZl
bnR1YWxseSBmb3VuZCBpdC4gSSBzdGlsbCB0aGluayBib3RoIFREQ0FMTCBhbmQgU0VBTUNBTEwg
c2hvdWxkDQo+IGJlIGxpc3RlZCBpbiBTRE0gVm9sLjIgaW5zdHJ1Y3Rpb24gbGlzdGluZyAtLSBl
dmVyeSB2YWxpZCBpbnN0cnVjdGlvbg0KPiBzaG91bGQgYmUgZm91bmQgdGhlcmUgSU1PLg0KPiAN
Cj4gSSBhbHNvIGZlZWwgc3Ryb25nbHkgdGhhdCBhIGdsb2JhbCBBQkkgc2hvdWxkIGJlIGRlY2lk
ZWQgdXBvbiBmb3IgdGhlbQ0KPiBhbmQgdGhlIFNETSB3b3VsZCBiZSBhIGdvb2QgcGxhY2UgdG8g
bWVudGlvbiB0aGF0LiAgbGVhdmluZyB0aGlzIHRvDQo+IGluZGl2aWR1YWwgY2FsbHMgbGlrZSBu
b3cgaXMgYSBnaWFudCBwYWluIGluIHRoZSByZWFyLg0KDQpZZWFoIEkgYWdyZWUgaG93IHRoZSBz
cGVjcyBhcmUgb3JnYW5pemVkIGlzIG5vdCBpZGVhbC4gIFdlIGhhdmUgYmVlbiBoYXZpbmcgcGFp
bg0KZHVyaW5nIG91ciBkZXZlbG9wbWVudCB0b28uDQoNCj4gDQo+IEFzIGlzLCB3ZSBoYXZlIFRE
Q0FMTCBsZWFmLTAgd2l0aCBhIGdpYW50IHJlZ3NldCBidXQgZXZlcnkgb3RoZXIgbGVhZg0KPiBo
YXMgKGMsZCw4LDkpIGZvciBpbnB1dCBhbmQgKygxMCwxMSkgZm9yIG91dHB1dC4gTGV0cyBmaXgg
dGhhdCBpbiBzdG9uZS4NCj4gDQo+IE9idmlvdXNseSBJIGFsc28gdmVyeSBzdHJvbmdseSBmZWVs
IGFueSBzdWNoIEFCSSBtdXN0IG5vdCBjb25maWN0IHdpdGgNCj4gcHJlLWV4aXN0aW5nIGNhbGxp
bmcgY29udmVudGlvbnMgLS0gSU9XLCB1c2luZyBCUCBpcyBvdXQsIG11c3Qgbm90DQo+IGhhcHBl
bi4NCg0KRnVsbHkgYWdyZWVkLg0KDQo=
