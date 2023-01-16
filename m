Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212AE66B66B
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 04:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjAPDsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 22:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjAPDsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 22:48:16 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E3C72AE;
        Sun, 15 Jan 2023 19:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673840894; x=1705376894;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7p0dibTd+tocrslMyOSW0jamBg+erg+vCjbDDjZW4cI=;
  b=f2tNi8MSowyczqpod23AspCze2WakqxyOqAGR/L19Eh34O+H8hOMbZ+H
   p6+mJEZoGBP580u11r3onrVO8ARPtxKLu4byiOx/vubmI/IPaVenw8byB
   iwLEIHd+3fbb24vAvcrhWYhI6mTcDYYVnK3bemxulMTZQEvCDERTrx1na
   bdDS/8EbUhxrO2IYyj651bH9q5VPaYgHVysE8LFDvcO2ZtlxXp8v10x6L
   To/d4VrgqRtgbevt1a70k+AsMuJ+Me4E7WQdSNZMM6obNK3nNSL1c+AQ1
   212+EQFalW+ae16j4N5HsNwt/c6xWYmBxMRr2WJSp5iNj1XgiMS3Z8Nhr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="312229752"
X-IronPort-AV: E=Sophos;i="5.97,219,1669104000"; 
   d="scan'208";a="312229752"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2023 19:48:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="652136838"
X-IronPort-AV: E=Sophos;i="5.97,219,1669104000"; 
   d="scan'208";a="652136838"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 15 Jan 2023 19:48:13 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 15 Jan 2023 19:48:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 15 Jan 2023 19:48:13 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 15 Jan 2023 19:48:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAWwUedyKUDLjtjZs6fVWoI9mL0lO58QiVYuBrGTPY4JBLLY5rlUT8kyrzwo8hOBvgSm2bWbr62IYcPc456LaDHelPT6MjkFfNUkxZz+UROSlyZeTTKMvdMhBtD22wGvJhyJEyrsBgXrmpKUamVV1Ym17ITSgUNXtCnflfTxpUmsZovbcAOZ7X3DwNYaNp0RWZESp9uV3Jk/0pcPgd9kxJMVDBqMN7sH7uqvkPPhp9Yb8zHWMJW6c0AKfpuE6i/bIWoElIsFtSDEE7di7YOV3Fyx7U/qtJabYh8SZpmeWI6M24KsQyd5vJoSJlZfrZJHaF7Jdc8fkeIfU7slygAy6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7p0dibTd+tocrslMyOSW0jamBg+erg+vCjbDDjZW4cI=;
 b=lABACagFStzsStg/WqRwsGiy7o5+UK0j/YWUCEy0ImJQDmmV2WT/5DMAqrdJVz2K57JzCdEwOufe1XtP76Cs4DfdTQPMpUI7IbpbSODzRvvDEfWlEv+vXKzPvbCQtbFA8vY8+frqvInP/q4CZmIzasS9rmTdVRGANh/Zel/AKirfrNnzPVggaINkAt14CO/FQ5LAEmAwiP+C5GpoqWrCquU5txnOsTkg2P5DTupJO1x6JSfRa+LXq12RMcuGpPms3+bgCHrkaJIDQQ2Kt3yBO86LpLN7wRDRsFMtwDaPC7HqTTe30zD63cI5Bf3YtO5HKGYA6CDAbCL9IZu8f4xc3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7549.namprd11.prod.outlook.com (2603:10b6:510:27b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Mon, 16 Jan
 2023 03:48:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 03:48:09 +0000
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
Subject: Re: [PATCH v11 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v11 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZJqUCdrDuDjzxh0a6CQQT8apxmq6gbWQA
Date:   Mon, 16 Jan 2023 03:48:09 +0000
Message-ID: <bb8d5e7cf3ad806ca320659f1fde69bb7c11ee7b.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <60c842f347eaecdd0673bdc63acd95b82eeeda9c.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <60c842f347eaecdd0673bdc63acd95b82eeeda9c.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7549:EE_
x-ms-office365-filtering-correlation-id: 4f0e617c-ff2b-4c47-cc05-08daf7747bea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XcAKMJYVwhHCCMwHviPWivh1K9/5n5tkkFK2FIFbUT9SmqMdLh/6Mmx2JCmxd17NR8+40hwlQ9byDA+MvgVxooZQO0ouQwx/Ek/eWK5LQfyZ4MnmrQ6hqZCr7+LLzme3VHmvv0Xkh2uWCWXA1CsjpQMVhhKbn9Mm4bdsglVQIk3waMu4JRs5zpiTg4u+EejDoRYMrol1kpe9H8G5FVd3Rvxa7PgHQGhyZ+UYc4/1fvGv6tEaRH9TpCPwy5Ct6wqCksdpxlFpuyhgLh3aWycZ4A1Bbqmo4jjKgiBq2T4B7RqbD9eFOeHOQRDg8EIXEGi8z0JWrH1JS3qX9DcJN61Vc8J0pCCfjNjVPRVC27KMw+eTw80fXnqYtRZg1ZBYJ8AqFgGc/zVdIhDeAFB8/7TaBYW2n4xz8FzNk6C4BfwsylYQfsQFqc6VB23Ixj/VInteB+f/+tWr1AjAIUBVWiY6dvMVCwnNmKEeQQbQtWXdUId3q39csdIE6bjv4QwvWXHiWdTESbIiyXqbSXlO8SGpwhv+e9QfbQ0BLP9J9g7bE4iF86n9uqeRxWWuU42vzTiLwAhTzwv1c7SJv5KvI0WzdoGf+vmGaHRk8ul3P1MKJxObNqvZXCQu+e6HeWSvC17y0SW8bHWBM+pNgHQWLVRqaAeFTs56k1KX8lVUO3FQ29DLEOuE1ddV8ObWrf8yCp534Mx6groFC8jc8qf5EA38eWfZp7x/B2KUDif2eW4qj4o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199015)(54906003)(71200400001)(6636002)(110136005)(91956017)(41300700001)(4326008)(36756003)(316002)(66946007)(76116006)(66446008)(66476007)(66556008)(64756008)(83380400001)(86362001)(82960400001)(38100700002)(38070700005)(122000001)(478600001)(966005)(6486002)(8676002)(2616005)(6506007)(6512007)(186003)(26005)(2906002)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uzh4akx1UDdmWHpXSXZMdi9BNUtmdFF3LzJCbEViemN4VGhjZVR6VENjQzJ1?=
 =?utf-8?B?c2hHY0dnRzQwN0EwQWMxb0syWUM1WTJhT3N5am1yQ1ZlWW02MWFCcFMwRllE?=
 =?utf-8?B?VHJzWU83dU1ITFRKcUJialBzeTdjWDBuZzVzSFdFTjRxQTFJdXpLaE9OMUZD?=
 =?utf-8?B?OVpwenJGMkV0Rmsra29wYlhEMlJtS0k4RWRXajBjcTZrYXVGRWw0VmgzSmZB?=
 =?utf-8?B?bURIQmEzN1BMS2NqaUVmNVpHWTlNNFNzWENGWkp2SUc5MXR4ODE1Q095YllD?=
 =?utf-8?B?TGpKazVmd2M4TTU2c2tXOUZnNUlpb1NEUGJRaVhMNlEvMERleUtGQjF4R1FK?=
 =?utf-8?B?K0hza3l3R2ZXR0xhMXFaZThiMWtVSnlCcHZwS0tTaVFuSnJzN2xYWlExbVFz?=
 =?utf-8?B?RVRscmplQjNDbHV4djNCZTlwaURlNUg3NXRRMUdIY09WR0ZIZVpBcTRGbGlY?=
 =?utf-8?B?QUZjOE8xS1dEbDU2WFlrKzJaK0xQUzhCZVhGZFJ1Q1laZDB2Y2NLVGFQTjZG?=
 =?utf-8?B?Mjg5UkJETjlNdEJWUG5XUisvQnFuQWpVbm1qNmZtUE1ZbkVWOW9nYWhDR0Vm?=
 =?utf-8?B?Q2w3R3hYZy9ZalEreTZtamFFelcxc3JjYmlnbUhCdW5kMFQxNDlkQUxoQ2M5?=
 =?utf-8?B?cUZQVnFrVUVpM2JjOGNGQWphb1cvZlRQbmt5UnlWOXdvS1c2V2NrNkUxSHdt?=
 =?utf-8?B?ekg0aFI5REFQZDB5RExXbmlhV0hpNFhYUGQ2WWFjMmtPWlIyUHNXZTVqQjFZ?=
 =?utf-8?B?QzVIN1p4bFEzRmhsT3UyMTZ6V1JyMnNyRHlVU2I2citxeXlvMm1yV21HdEIv?=
 =?utf-8?B?Q2J4WmVlUXUrM3dmQXVMMjltQTZZMktORDVjQUVIeDJZTG04T2ZLcVZOcWxv?=
 =?utf-8?B?OWNiQ3NzYVBrQ0oxK0JPSEhFb1ZCVC9BWmNzR2ZNd0tXZU03a1RiNmRXK1FV?=
 =?utf-8?B?QW9jS2NjS0Z3R0N3MG4rVS9XMm51dEdza3ZRMFBKUGhHZXF6ZTMvckdSSFpt?=
 =?utf-8?B?eEV3cjM4U2dRYktKaTRrK0tJSlB0NTQ3bUlaaG5Jc1VWK0Z3a2lmUUN4ZndU?=
 =?utf-8?B?b2ZDQVZwQ1FGdUlRNUk4UkRzMTYwZGpUMHNJUHhIR0I4UHBGbVdpT09pOURQ?=
 =?utf-8?B?L2VtRlk1ZVhSZnB1MERmTTk4UE1JUHpGYlZ1Sjl2b01oOGZZOE0zV0NOd2xy?=
 =?utf-8?B?Mng1QnlrQUZJdzlub2tJOWpMWXpTWHJqbmVqRHBJNE5PQkVqY055YmJzajcz?=
 =?utf-8?B?Sm1OQlMvVnJYam9wV1dOdVIyUHVUUHlTRWFSeHRXMXZBOVVTeFN1NmdJRFpC?=
 =?utf-8?B?a2x0VCtnTnZGcVlpakJ3VUFma2VSQkJmSDI2akJCbW5aQ0czazdYMkd2eEU2?=
 =?utf-8?B?b1pvSC9scmlTaXppNTdBYWpDNGR4R2YzRmZ4dmtSclQ4SDFzMzFZVTgrcDRE?=
 =?utf-8?B?dklKNE8veHl6QmNKVFhnT3J5QU92clB1ZFVvNXVOUlBtSFE2TnJRM0swRkhR?=
 =?utf-8?B?TDF0UkNkN2l1cyt3TVJUZTdpNnR1RVM2cTN5azRSQlFLZ0FXQWdpWWg1TTVR?=
 =?utf-8?B?d08zZVljR0g1T0Qrc1FNeWI3MWtGMXZPNmpGRTg1VlNxcEkyK0U0T3RoRVdQ?=
 =?utf-8?B?cTBrZkprTnZ3Z083N21xN2pUempDS05jNVF0QUZ2ZXlQVXlodWhzcUxFb1R6?=
 =?utf-8?B?ci82K2NLSU51QkU4eXpHT3FOWEZTR2pYWjlzNUhMaG1ub1pOOS9PQU5ZTStY?=
 =?utf-8?B?WUlmYm5nZWVUZDZseUNyVzRRVW4rK3h6WGFBNUlaZ0dyMy9iY24xWUVwcS8x?=
 =?utf-8?B?U1JQZ1d3WGxkSkIwVnhFSXlRaERGMTIzSlAycjZpUWhYczR4MWVQRjNuNjZ3?=
 =?utf-8?B?SGRLY2JPSFp4SEUvd3lyVG16aUZydXZhRmUwMy9HeTkyVnRNT1JGanpPSDhR?=
 =?utf-8?B?bjhlaDRZdUxjSWR3UU44OGZoNi9pSS9CZTdNbjdOYVZZZzdOeEdWa1pkMy9D?=
 =?utf-8?B?a1NhNWk5YmNrK0tBckJpb0JvN0xhdGQvY0dPVXZERXNvc0YwZEZpd3BBR2F6?=
 =?utf-8?B?cnNvQi9YYldQK1dCZmVzVjZnTkkxZW5seThjRGI2UEFEWDRJR1hSdUk0NytX?=
 =?utf-8?B?elRRdDlObEE4bjA0OXBJRW5pczhldytZWkZ1UnJielJNWU5uY2pFd1ZZM0Z4?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33198D91A48AC04DAFEE385B5BCDAAD4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0e617c-ff2b-4c47-cc05-08daf7747bea
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 03:48:09.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ixmHmMTL/fhvHeByNyehVzFySvQtSHhX0cDrlZWEN5w1CdmUiT0wbj8MbHUbleypyTfCJ77nO+ypiXbMoJpRGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7549
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggcmVxdWlyZXMgc2V2ZXJhbCBpbml0aWFsaXphdGlvbiBzdGVwcyBmb3Ig
S1ZNIHRvIGNyZWF0ZSBndWVzdCBURHMuDQo+IERldGVjdCBDUFUgZmVhdHVyZSwgZW5hYmxlIFZN
WCAoVERYIGlzIGJhc2VkIG9uIFZNWCksIGRldGVjdCB0aGUgVERYIG1vZHVsZQ0KPiBhdmFpbGFi
aWxpdHksIGFuZCBpbml0aWFsaXplIGl0LiAgVGhpcyBwYXRjaCBpbXBsZW1lbnRzIHRob3NlIHN0
ZXBzLg0KDQoiZGV0ZWN0IHRoZSBURFggbW9kdWxlIiBpcyBub3QgbmVlZGVkIGFueW1vcmUuDQoN
CkJ0dywgSSBndWVzcyB5b3Ugc2hvdWxkIGdldCByaWQgb2YgIlRoaXMgcGF0Y2ggLi4uIi4gIFBs
ZWFzZSBzZWUgYmVsb3cgcXVvdGVkDQp0eHQgZnJvbSBodHRwczovL2RvY3Mua2VybmVsLm9yZy9w
cm9jZXNzL3N1Ym1pdHRpbmctcGF0Y2hlcy5odG1sIDoNCg0KIg0KRGVzY3JpYmUgeW91ciBjaGFu
Z2VzIGluIGltcGVyYXRpdmUgbW9vZCwgZS5nLiDigJxtYWtlIHh5enp5IGRvIGZyb3R64oCdIGlu
c3RlYWQgb2YNCuKAnFtUaGlzIHBhdGNoXSBtYWtlcyB4eXp6eSBkbyBmcm90euKAnSBvciDigJxb
SV0gY2hhbmdlZCB4eXp6eSB0byBkbyBmcm90euKAnSwgYXMgaWYNCnlvdSBhcmUgZ2l2aW5nIG9y
ZGVycyB0byB0aGUgY29kZWJhc2UgdG8gY2hhbmdlIGl0cyBiZWhhdmlvdXIuDQoiDQoNCj4gDQo+
IFRoZXJlIGFyZSBzZXZlcmFsIG9wdGlvbnMgb24gd2hlbiB0byBpbml0aWFsaXplIHRoZSBURFgg
bW9kdWxlLiAgQS4pIGtlcm5lbA0KPiBtb2R1bGUgbG9hZGluZyB0aW1lLCBCLikgdGhlIGZpcnN0
IGd1ZXN0IFREIGNyZWF0aW9uIHRpbWUuICBBLikgd2FzIGNob3Nlbi4NCj4gV2l0aCBCLiksIGEg
dXNlciBtYXkgaGl0IGFuIGVycm9yIG9mIHRoZSBURFggaW5pdGlhbGl6YXRpb24gd2hlbiB0cnlp
bmcgdG8NCj4gY3JlYXRlIHRoZSBmaXJzdCBndWVzdCBURC4gIFRoZSBtYWNoaW5lIHRoYXQgZmFp
bHMgdG8gaW5pdGlhbGl6ZSB0aGUgVERYDQo+IG1vZHVsZSBjYW4ndCBib290IGFueSBndWVzdCBU
RCBmdXJ0aGVyLiAgU3VjaCBmYWlsdXJlIGlzIHVuZGVzaXJhYmxlIGFuZCBhDQo+IHN1cnByaXNl
IGJlY2F1c2UgdGhlIHVzZXIgZXhwZWN0cyB0aGF0IHRoZSBtYWNoaW5lIGNhbiBhY2NvbW1vZGF0
ZSBndWVzdA0KPiBURCwgYnV0IGFjdHVhbGx5IG5vdC4gIFNvIEEuKSBpcyBiZXR0ZXIgdGhhbiBC
LikuDQo+IA0KPiBJbnRyb2R1Y2UgYSBtb2R1bGUgcGFyYW1ldGVyLCBlbmFibGVfdGR4LCB0byBl
eHBsaWNpdGx5IGVuYWJsZSBURFggS1ZNDQo+IHN1cHBvcnQuICBJdCdzIG9mZiBieSBkZWZhdWx0
IHRvIGtlZXAgc2FtZSBiZWhhdmlvciBmb3IgdGhvc2Ugd2hvIGRvbid0IHVzZQ0KPiBURFguICBJ
bXBsZW1lbnQgaGFyZHdhcmVfc2V0dXAgbWV0aG9kIHRvIGRldGVjdCBURFggZmVhdHVyZSBvZiBD
UFUuDQo+IEJlY2F1c2UgVERYIHJlcXVpcmVzIGFsbCBwcmVzZW50IENQVXMgdG8gZW5hYmxlIFZN
WCAoVk1YT04pLiAgVGhlIHg4Ng0KDQoiQmVjYXVzZSBURFggLi4uICwgdGhlIHg4NiBzcGVjaWZp
YyAuLi4iLg0KDQo+IHNwZWNpZmljIGt2bV9hcmNoX3Bvc3RfaGFyZHdhcmVfZW5hYmxlX3NldHVw
IG92ZXJyaWRlcyB0aGUgZXhpc3Rpbmcgd2Vhaw0KPiBzeW1ib2wgb2Yga3ZtX2FyY2hfcG9zdF9o
YXJkd2FyZV9lbmFibGVfc2V0dXAgd2hpY2ggaXMgY2FsbGVkIGF0IHRoZSBLVk0NCj4gbW9kdWxl
IGluaXRpYWxpemF0aW9uLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlz
YWt1LnlhbWFoYXRhQGludGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vTWFrZWZpbGUg
ICAgICB8ICAxICsNCj4gIGFyY2gveDg2L2t2bS92bXgvbWFpbi5jICAgIHwgMzMgKysrKysrKysr
KysrKysrKysrKysrKystLS0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC90ZHguYyAgICAgfCA0NCAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgYXJjaC94ODYva3ZtL3Zt
eC92bXguYyAgICAgfCAzOSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIGFy
Y2gveDg2L2t2bS92bXgveDg2X29wcy5oIHwgMTAgKysrKysrKysrDQo+ICA1IGZpbGVzIGNoYW5n
ZWQsIDEyMiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiAgY3JlYXRlIG1vZGUgMTAw
NjQ0IGFyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0vTWFrZWZpbGUgYi9hcmNoL3g4Ni9rdm0vTWFrZWZpbGUNCj4gaW5kZXggMGU4OTRhZTIzY2Jj
Li40YjAxYWI4NDJhYjcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9NYWtlZmlsZQ0KPiAr
KysgYi9hcmNoL3g4Ni9rdm0vTWFrZWZpbGUNCj4gQEAgLTI1LDYgKzI1LDcgQEAga3ZtLSQoQ09O
RklHX0tWTV9TTU0pCSs9IHNtbS5vDQo+ICBrdm0taW50ZWwteQkJKz0gdm14L3ZteC5vIHZteC92
bWVudGVyLm8gdm14L3BtdV9pbnRlbC5vIHZteC92bWNzMTIubyBcDQo+ICAJCQkgICB2bXgvaHlw
ZXJ2Lm8gdm14L25lc3RlZC5vIHZteC9wb3N0ZWRfaW50ci5vIHZteC9tYWluLm8NCj4gIGt2bS1p
bnRlbC0kKENPTkZJR19YODZfU0dYX0tWTSkJKz0gdm14L3NneC5vDQo+ICtrdm0taW50ZWwtJChD
T05GSUdfSU5URUxfVERYX0hPU1QpCSs9IHZteC90ZHgubw0KPiAgDQo+ICBrdm0tYW1kLXkJCSs9
IHN2bS9zdm0ubyBzdm0vdm1lbnRlci5vIHN2bS9wbXUubyBzdm0vbmVzdGVkLm8gc3ZtL2F2aWMu
byBcDQo+ICAJCQkgICBzdm0vc2V2Lm8gc3ZtL2h5cGVydi5vDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0vdm14L21haW4uYyBiL2FyY2gveDg2L2t2bS92bXgvbWFpbi5jDQo+IGluZGV4IDE4
ZjY1OWQxZDQ1Ni4uZjVkMTE2NmQyNzE4IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14
L21haW4uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiBAQCAtNyw2ICs3LDIy
IEBADQo+ICAjaW5jbHVkZSAicG11LmgiDQo+ICAjaW5jbHVkZSAidGR4LmgiDQo+ICANCj4gK3N0
YXRpYyBib29sIGVuYWJsZV90ZHggX19yb19hZnRlcl9pbml0ID0gSVNfRU5BQkxFRChDT05GSUdf
SU5URUxfVERYX0hPU1QpOw0KDQpUaGUgY2hhbmdlbG9nIHNhaWQgaXQncyBvZmYgYnkgZGVmYXVs
dCwgc28gbm90IGNvbnNpc3RlbnQgaGVyZS4NCg0KPiArbW9kdWxlX3BhcmFtX25hbWVkKHRkeCwg
ZW5hYmxlX3RkeCwgYm9vbCwgMDQ0NCk7DQo+ICsNCj4gK3N0YXRpYyBfX2luaXQgaW50IHZ0X2hh
cmR3YXJlX3NldHVwKHZvaWQpDQo+ICt7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IHZt
eF9oYXJkd2FyZV9zZXR1cCgpOw0KPiArCWlmIChyZXQpDQo+ICsJCXJldHVybiByZXQ7DQo+ICsN
Cj4gKwllbmFibGVfdGR4ID0gZW5hYmxlX3RkeCAmJiAhdGR4X2hhcmR3YXJlX3NldHVwKCZ2dF94
ODZfb3BzKTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICBzdHJ1Y3Qga3ZtX3g4
Nl9vcHMgdnRfeDg2X29wcyBfX2luaXRkYXRhID0gew0KPiAgCS5uYW1lID0gS0JVSUxEX01PRE5B
TUUsDQo+ICANCj4gQEAgLTE0OSw3ICsxNjUsNyBAQCBzdHJ1Y3Qga3ZtX3g4Nl9vcHMgdnRfeDg2
X29wcyBfX2luaXRkYXRhID0gew0KPiAgfTsNCj4gIA0KPiAgc3RydWN0IGt2bV94ODZfaW5pdF9v
cHMgdnRfaW5pdF9vcHMgX19pbml0ZGF0YSA9IHsNCj4gLQkuaGFyZHdhcmVfc2V0dXAgPSB2bXhf
aGFyZHdhcmVfc2V0dXAsDQo+ICsJLmhhcmR3YXJlX3NldHVwID0gdnRfaGFyZHdhcmVfc2V0dXAs
DQo+ICAJLmhhbmRsZV9pbnRlbF9wdF9pbnRyID0gTlVMTCwNCj4gIA0KPiAgCS5ydW50aW1lX29w
cyA9ICZ2dF94ODZfb3BzLA0KPiBAQCAtMTgyLDEwICsxOTgsMTcgQEAgc3RhdGljIGludCBfX2lu
aXQgdnRfaW5pdCh2b2lkKQ0KPiAgCSAqIENvbW1vbiBLVk0gaW5pdGlhbGl6YXRpb24gX211c3Rf
IGNvbWUgbGFzdCwgYWZ0ZXIgdGhpcywgL2Rldi9rdm0gaXMNCj4gIAkgKiBleHBvc2VkIHRvIHVz
ZXJzcGFjZSENCj4gIAkgKi8NCj4gLQl2dF94ODZfb3BzLnZtX3NpemUgPSBtYXgoc2l6ZW9mKHN0
cnVjdCBrdm1fdm14KSwgc2l6ZW9mKHN0cnVjdCBrdm1fdGR4KSk7DQo+IC0JdmNwdV9zaXplID0g
bWF4KHNpemVvZihzdHJ1Y3QgdmNwdV92bXgpLCBzaXplb2Yoc3RydWN0IHZjcHVfdGR4KSk7DQo+
IC0JdmNwdV9hbGlnbiA9IG1heChfX2FsaWdub2ZfXyhzdHJ1Y3QgdmNwdV92bXgpLA0KPiAtCQkJ
IF9fYWxpZ25vZl9fKHN0cnVjdCB2Y3B1X3RkeCkpOw0KPiArCXZ0X3g4Nl9vcHMudm1fc2l6ZSA9
IHNpemVvZihzdHJ1Y3Qga3ZtX3ZteCk7DQo+ICsJdmNwdV9zaXplID0gc2l6ZW9mKHN0cnVjdCB2
Y3B1X3ZteCk7DQo+ICsJdmNwdV9hbGlnbiA9IF9fYWxpZ25vZl9fKHN0cnVjdCB2Y3B1X3ZteCk7
DQo+ICsJaWYgKGVuYWJsZV90ZHgpIHsNCj4gKwkJdnRfeDg2X29wcy52bV9zaXplID0gbWF4X3Qo
dW5zaWduZWQgaW50LCB2dF94ODZfb3BzLnZtX3NpemUsDQo+ICsJCQkJCSAgIHNpemVvZihzdHJ1
Y3Qga3ZtX3RkeCkpOw0KPiArCQl2Y3B1X3NpemUgPSBtYXhfdCh1bnNpZ25lZCBpbnQsIHZjcHVf
c2l6ZSwNCj4gKwkJCQkgIHNpemVvZihzdHJ1Y3QgdmNwdV90ZHgpKTsNCj4gKwkJdmNwdV9hbGln
biA9IG1heF90KHVuc2lnbmVkIGludCwgdmNwdV9hbGlnbiwNCj4gKwkJCQkgICBfX2FsaWdub2Zf
XyhzdHJ1Y3QgdmNwdV90ZHgpKTsNCj4gKwl9DQoNCllvdSBoYXZlIGJlbG93IGNvZGUgaW4gdGhl
IHByZXZpb3VzIHBhdGNoOg0KDQpAQCAtMTgxLDkgKzE4MiwxMCBAQCBzdGF0aWMgaW50IF9faW5p
dCB2dF9pbml0KHZvaWQpDQogCSAqIENvbW1vbiBLVk0gaW5pdGlhbGl6YXRpb24gX211c3RfIGNv
bWUgbGFzdCwgYWZ0ZXIgdGhpcywgL2Rldi9rdm0gaXMNCiAJICogZXhwb3NlZCB0byB1c2Vyc3Bh
Y2UhDQogCSAqLw0KLQl2dF94ODZfb3BzLnZtX3NpemUgPSBzaXplb2Yoc3RydWN0IGt2bV92bXgp
Ow0KLQl2Y3B1X3NpemUgPSBzaXplb2Yoc3RydWN0IHZjcHVfdm14KTsNCi0JdmNwdV9hbGlnbiA9
IF9fYWxpZ25vZl9fKHN0cnVjdCB2Y3B1X3ZteCk7DQorCXZ0X3g4Nl9vcHMudm1fc2l6ZSA9IG1h
eChzaXplb2Yoc3RydWN0IGt2bV92bXgpLCBzaXplb2Yoc3RydWN0DQprdm1fdGR4KSk7DQorCXZj
cHVfc2l6ZSA9IG1heChzaXplb2Yoc3RydWN0IHZjcHVfdm14KSwgc2l6ZW9mKHN0cnVjdCB2Y3B1
X3RkeCkpOw0KKwl2Y3B1X2FsaWduID0gbWF4KF9fYWxpZ25vZl9fKHN0cnVjdCB2Y3B1X3ZteCks
DQorCQkJIF9fYWxpZ25vZl9fKHN0cnVjdCB2Y3B1X3RkeCkpOw0KDQpUaGUgY2h1bmsgaGVyZSBp
biB0aGlzIHBhdGNoIGlzIG5vdCByZWxhdGVkIGhvdyB0byBpbml0aWFsaXplIHRoZSBURFggbW9k
dWxlLA0KYnV0IGJlbG9uZyB0byAiaG93IEtWTSBoYW5kbGVzIFREWCBhdCBWTSBsZXZlbCBhbmQg
dmNwdSBsZXZlbCIsIHdoaWNoIGlzDQppbnRyb2R1Y2VkIGluIHRoZSBwcmV2aW91cyBwYXRjaCwg
d2hpY2ggaXNuJ3QgbWFuZGF0b3J5IHRvIGJlIGludHJvZHVjZWQgYmVmb3JlDQp0aGlzIHBhdGNo
Lg0KDQpJTUhPIGEgYmV0dGVyIHdheSBpcyB0byBtb3ZlIHRoZSBwcmV2aW91cyBwYXRjaCBhZnRl
ciB0aGlzIG9uZSwgYW5kIGp1c3QgcHV0IA0KdGhpcyBjaHVuayB0byB0aGF0IHBhdGNoLiAgQW5k
IGlmIHlvdSBkbyBzbywgdGhpcyBjaHVuayBvZiBjaGFuZ2UgY2FuIGp1c3QNCmFwcGVhciBvbmNl
IGJ1dCBub3QgdHdpY2UgaW4gdHdvIHBhdGNoZXMuDQogDQoNCltzbmlwXQ0KDQo+ICANCj4gKyNp
ZmRlZiBDT05GSUdfSU5URUxfVERYX0hPU1QNCj4gK2ludCBfX2luaXQgdGR4X2hhcmR3YXJlX3Nl
dHVwKHN0cnVjdCBrdm1feDg2X29wcyAqeDg2X29wcyk7DQo+ICsjZWxzZQ0KPiArc3RhdGljIGlu
bGluZSBpbnQgdGR4X2hhcmR3YXJlX3NldHVwKHN0cnVjdCBrdm1feDg2X29wcyAqeDg2X29wcykg
eyByZXR1cm4gMDsgfQ0KDQpXaHkgZG8geW91IHJldHVybiAwLCB3aGljaCBpcyBhIHN1Y2Nlc3Mg
SUlVQz8NCg0KDQoNCg==
