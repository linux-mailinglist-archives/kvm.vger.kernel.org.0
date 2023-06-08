Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A8A7273DD
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 02:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjFHAvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 20:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjFHAvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 20:51:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3717026A0;
        Wed,  7 Jun 2023 17:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686185481; x=1717721481;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=x3UuV9xmGIwVeBAgSBV1COO9SXzo1HPVhR1Oo6MXQWg=;
  b=VL/FCROfnDUnpPPfk5Xjht6e3THvYNxRKkRPFdX+GG48UG9TKSsQN/Tc
   KWS3c1X/FgrKg5cddKmElsH6DnTvCOvRkOXBU3mo2myP2HrU3zjxlySjK
   LKTh3jEsEbG3du9kEjrxIPGqh53xttCE6plLxm9naUAwh3vw8GVFGGM9G
   ZvlKspc49HbF794tRoWOKp0mlnl6QgrItQkT9RFc/K4c1bTDu+ozTzmoB
   TnzLZ7tU3OQ7RjLpBN0f3YkVwL0UUx9q/MVcVPTbDoaJ9VsDsuko1m7vA
   Q40WNFZxGAAn0XdwerXUbvb3Xcz7Z9UeAYZ5gfIvbDv7CbH1Ab2eP6lKY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="356011602"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="356011602"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:51:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="739482821"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="739482821"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 07 Jun 2023 17:51:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 17:51:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 17:51:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 17:51:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmpOAAL57lzHecErN0pj+crgMNVYLEcaYTxADq3vq9Vg9Zu+rKAc9oqXXOHK9Na9LiuBMZ17kOfQUKw39e8/FLBmYmHSfUhUiTamkhKJ8vGdSjJVeSO48AjVGQH4GEtamQlu2CFv4DiqY7l/cCpnnBsSXU1bLMLto8aIjumuWf6DluvpZWIZY/VTtusCCuMZiZbK2AcpKY28YPP0jFYunMOFV8goHQ84vB02hAmDY7A50E99mA8/vy+CPkrxREuJT6r5HU1lIZkqsfana62K6nwHwaFpbhmy58xWo1Q4WtL0TvOdz4chqr1JaGawFGElGCT9piPbn9eukHhKPJDFag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3UuV9xmGIwVeBAgSBV1COO9SXzo1HPVhR1Oo6MXQWg=;
 b=FZJaJGbmkAc+yqS/BpdqypguHUfZMHhnYPIS55WrbzKcueDkk/VVL8IQB1o6t9EXz4dfhroWgE5rQdGf3RR0l/dxLYljQnf/ORWsDaP47mvGe76DxydUcZNcWK2PtB4BfDcCEMBajU31/55c7DYfdGQHsuDxuHtmWCrhniYDdIw4wdpDG0eDch8n6c1V9F2Z2p0GJO/oHaKWIddl0Kb6HUhYYo6sT8usaa0w9TCjd9Odp0vOeltl66UQezavIgcYJFiWrTsrn91tOMo/0+xyyAj4kUQp06otAhhISE5Fbsu3EhAiUtpaa1RxmZ/Hd+trQEYaihlvHZzEkINna6RnPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW5PR11MB5761.namprd11.prod.outlook.com (2603:10b6:303:195::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 00:51:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 00:51:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZlu+qoC4MN/glPkShb4EFlRb+MK9/aaOAgABLToCAAAlmgIAABYiAgAAF9ICAAAPjAIAASw2A
Date:   Thu, 8 Jun 2023 00:51:15 +0000
Message-ID: <c4695e35353513381d661c21d2ebcd786f39f327.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
         <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
         <20230607185355.GH2244082@ls.amr.corp.intel.com>
         <f7ef157e-8f26-8d7b-a9b8-cb8de7f7aa2b@intel.com>
         <20230607194721.GI2244082@ls.amr.corp.intel.com>
         <ZIDjx4i2Z/OQgUra@google.com>
         <2061ced1-59d7-f21c-490c-b650b7378386@intel.com>
In-Reply-To: <2061ced1-59d7-f21c-490c-b650b7378386@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW5PR11MB5761:EE_
x-ms-office365-filtering-correlation-id: 9fafd79b-07d3-451a-985f-08db67ba7692
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7x2U2BaUnYrlqD4k1HAhWRbf4W3VDyGSbSPEvYDjjX796YV7fpYt5NWYvPdee6bhEObTJI3egHDatuHli8XhE6cEJQl5fqigFMRExAi2EPLoCZv6TwQloI1c20RtTOmKoeLrOFqv9/GH+j5XPjZcCqgB2P31JzH0bS8ENgRb3PBQ96uaWwGowWRmrfy1iX027ivfPLaraUfzZzetWysj6d/gwa8S3nlgrJGIcrXwiIm084BmR/pbLR4c+dXB+CJnem6Ui0LGb05mHRGc6aEBMLEsrTJZG/f7F0eULD9FzijhFL6Eu/hXU8oO9vPDoAKeDNLG5+HORGxbZnbMMIOMxJvxZfvU4vhPoopeQjw0iehlOfTvJvh5yCuPoVqcL1r6QxovT5spbkBlscVaBYGQKNK8RXezAqtag5O4vBPp2qu6L/spuQPlWhIB5Uvhxr3e2ODrdIfqE1JnOBVBwjStz1X2gcISrcZH03KIpQHmVSAbH8Gg9Ws+4qPemRIeM8xbVoYBXin1P2ZTBQeCUX2o/RmZA6mgSXzer5zJBpYIVqhsc0FOJ2miD9JFENvo8Br+FFEk6KjRy+KJXYIip0hDrOXYPRRglcEqwqteGr6t5kyxX/5klIlLYoZ6bRZBtvJvy1EeQYKQV2f7cwYBLKoqKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199021)(6506007)(26005)(966005)(53546011)(6512007)(186003)(36756003)(83380400001)(122000001)(86362001)(38070700005)(82960400001)(38100700002)(2616005)(8676002)(41300700001)(110136005)(54906003)(66446008)(478600001)(66946007)(4326008)(66476007)(76116006)(316002)(2906002)(64756008)(8936002)(91956017)(5660300002)(7416002)(6486002)(71200400001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXhRb0xQeDhmM2ZjbmF4SDRaUTBFOVNBeGtQTVNpMGtzYm1zVzFvVVlHUnM5?=
 =?utf-8?B?d2RWeklKeFpYRVpmWGY1UnIzdFNmM3h2M2YxQk85VGRBYmhyUVFTMXFzODMx?=
 =?utf-8?B?TWVqMUR2RmVSRlY5N29VZFRldlV4SkpydUY4WFVQcUY0REwzU1FmWElWN1Qz?=
 =?utf-8?B?K3Z0Q3AwRi9ac2w1dndaQ0RBN080RFhrV25PSVhkb3pRbERiZGVaRWpoSGRz?=
 =?utf-8?B?WEQ5UWpEZnI1V0xmVGN3SmNXcnBMWHB0MjRpVzd6c0FlRUJzMTRLUVI5dGNK?=
 =?utf-8?B?a1YxeUMyTkp1dnd2K2JzamZTbGRySVdvUTRua0dOaTF5NGo0dmF2VHdOMjl2?=
 =?utf-8?B?TFVmeTdQN0c0R0lSSnNUeml5VDR5aHNlMldpejZLNWxQQ2w0NlVOSUhPSkNk?=
 =?utf-8?B?YXRGRlNMMnAwYmJ2RXgrUllJd204MW5IRzRjL2NrS0NxMGJCektmd2dXNTg5?=
 =?utf-8?B?NitHZDQ0UXlLTkJ3SzJ5MU05OVc4RXRhbW51QW9lQWlBbWxMVGNaS3B2aVV4?=
 =?utf-8?B?SmFWY01lNERZOVU2Z1cwaHJHN2FPU3Qza0tPdURFWW5VZXEzUGVsbDlOUjdi?=
 =?utf-8?B?VnEyV3RnaEs4R2E0QU1vaGpPZmlIVktwTWVOSnEvVUV0T3N5bGVWVGgvQ29J?=
 =?utf-8?B?TzBadk92TndqYWJiT1FzODgyZC9QeWRrdFZ3Y3dCbDdNc0R6NVE0UDM3YXJH?=
 =?utf-8?B?cWVHZWRycVorMGl1dHNJTmhJL0duR3c1WVhzRmo3M2FmOW1SVm1tbjFma29m?=
 =?utf-8?B?bFZaTElMWkRjNkdmUTJ1T2FiNW52UjNmdjVqcDZSU3FFRE5CcGpzTXdaWGs5?=
 =?utf-8?B?bURoVTBHQWorTVFiZDcwd25IbkhDUXFBREF2dTNkS3VkbVE1Z25HYUVaVk9N?=
 =?utf-8?B?eEt2V2gxL2dGTnlZd1FmMVFnN0xEY2tYaDNpYWw1dzdHaUVYL1hSK1p0cVVo?=
 =?utf-8?B?TmtLWVJYcW5tSjlCbUo4RmVLbnpYa2pQRWdweXRGMzhudVdVTGl2bGdHNTVx?=
 =?utf-8?B?YTlLVUxvUXgyYXUxRllXNW9wREEycnVkbHhTemtYekJUVmljK2dhNUE4djZM?=
 =?utf-8?B?UWw3WnI4MWdVdEc1ZjdLZ0llMk5OUmZ1RitzeFVrSkNXZzE0eklhM0VmQ0Js?=
 =?utf-8?B?VmsxbE9OdmphdllHdWpDTGRHbnZsbDRPT2hJNFh3cmtrY28rTWF1OWI2eEZx?=
 =?utf-8?B?SHRJS1kzaGlmMklBblh1L3R5UmFTOFpycmgvRkI1cDJPcUoySlp2eVIvS2lq?=
 =?utf-8?B?NlA1UDFBVlRyKytBUVBKQXdTN3RydTNHRkh4VnlyUGYva2pZZHZ2ODNTL2JJ?=
 =?utf-8?B?YlFGQWwvR3paOHgyM2s4OVZHemphcDRaUkpuc0RpTVlhNlYxL3g3Si81ajE2?=
 =?utf-8?B?K3JKNkkyaWZRZHF5c2hTdDN4Vlk0N0I1QUJlUkQ2RjJyNmVENlZGSlphOGFj?=
 =?utf-8?B?eXhSaWR5Wm0zWjYwTEtZTkpURHZNTFFiZ1MxM01mRmNxM0szUWVXYzg4ZzMw?=
 =?utf-8?B?cEUrZWM3emNYbTNlK3hrNHUzTTZ4RitHbEZqamZWZXFrWDJQelFHd3ZlaTNu?=
 =?utf-8?B?MzFKTlNQd2pMZllpaVgyUnlVaVdDdzBRUjZBS240YkRDSGl0emhGTkxZRk96?=
 =?utf-8?B?RVIyYWpPdjZjQnFUbi9aY1ZTdDZ5Vk4yYlpVZWhBeDZBTk40ZWJ3ZTU2NFRK?=
 =?utf-8?B?cUlkMzFuK1k1aUhLakVxQjJydmVMOWZyQXpBVXhCWUd6WG8wTmRGeFlGT3p2?=
 =?utf-8?B?RWNYOVY4L3BIVk1kMFRvNysyeEhCMFVpdW1ka3k1RWJXeGlFMXA0YXdCMnlX?=
 =?utf-8?B?NTFZbVV6NzlNQkY5enlYZ1plcU5tVlZKekMwV0YyQjVXd2h4bWlVNnhrTElm?=
 =?utf-8?B?R2U4c0N1ZEZTRjhVUk9rcEdTSG9LcFEveXUycXI2SnBHeGk2QUsvdS9reFli?=
 =?utf-8?B?OUp5M24zQkNROEpmK09qMVArcGQ4bVRHZzRkN0JXalpJU2xESk1yc3Q1VDI4?=
 =?utf-8?B?bmtHKzJFVHZlUDhFTzRVaHNwRGo2eFZDbS8zaVNCcE1kY1RPUG9GeXIxS1Bw?=
 =?utf-8?B?Y1drd2dMa2NVRVVmRmdOQ0hOZWsvd0pRRUpjc3plZUJhN0ptSit5UFRDZWZ4?=
 =?utf-8?Q?ZOoRK+LFkgUxOHlo0gjeSQzfv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA0D315D0763D248ABD49F158EF79A62@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fafd79b-07d3-451a-985f-08db67ba7692
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 00:51:15.3688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FU7AetkMvtUNUuSgpzhFXCxO/jsZEY9rLMEanEQyKsBAPx14YLfM5ibbAgT5htWlEqKbgV3PggirP0cVmJPvnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5761
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

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDEzOjIyIC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDYvNy8yMyAxMzowOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+ID4gPiA+
ID4gVGhlIGN1cnJlbnQgVERYX01PRFVMRV9DQUxMIG1hY3JvIGhhbmRsZXMgbmVpdGhlciAjR1Ag
bm9yICNVRC4gIFRoZQ0KPiA+ID4gPiA+ID4gPiBrZXJuZWwgd291bGQgaGl0IE9vcHMgaWYgU0VB
TUNBTEwgd2VyZSBtaXN0YWtlbmx5IG1hZGUgdy9vIGVuYWJsaW5nIFZNWA0KPiA+ID4gPiA+ID4g
PiBmaXJzdC4gIEFyY2hpdGVjdHVyYWxseSwgdGhlcmUgaXMgbm8gQ1BVIGZsYWcgdG8gY2hlY2sg
d2hldGhlciB0aGUgQ1BVDQo+ID4gPiA+ID4gPiA+IGlzIGluIFZNWCBvcGVyYXRpb24uICBBbHNv
LCBpZiBhIEJJT1Mgd2VyZSBidWdneSwgaXQgY291bGQgc3RpbGwgcmVwb3J0DQo+ID4gPiA+ID4g
PiA+IHZhbGlkIFREWCBwcml2YXRlIEtleUlEcyB3aGVuIFREWCBhY3R1YWxseSBjb3VsZG4ndCBi
ZSBlbmFibGVkLg0KPiA+ID4gPiA+ID4gSSdtIG5vdCBzdXJlIHRoaXMgaXMgYSBncmVhdCBqdXN0
aWZpY2F0aW9uLiAgSWYgdGhlIEJJT1MgaXMgbHlpbmcgdG8gdGhlDQo+ID4gPiA+ID4gPiBPUywg
d2UgX3Nob3VsZF8gb29wcy4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gSG93IGVsc2UgY2Fu
IHRoaXMgaGFwcGVuIG90aGVyIHRoYW4gc2lsbHkga2VybmVsIGJ1Z3MuICBJdCdzIE9LIHRvIG9v
cHMNCj4gPiA+ID4gPiA+IGluIHRoZSBmYWNlIG9mIHNpbGx5IGtlcm5lbCBidWdzLg0KPiA+ID4g
PiA+IFREWCBLVk0gKyByZWJvb3QgY2FuIGhpdCAjVUQuICBPbiByZWJvb3QsIFZNWCBpcyBkaXNh
YmxlZCAoVk1YT0ZGKSB2aWENCj4gPiA+ID4gPiBzeXNjb3JlLnNodXRkb3duIGNhbGxiYWNrLiAg
SG93ZXZlciwgZ3Vlc3QgVEQgY2FuIGJlIHN0aWxsIHJ1bm5pbmcgdG8gaXNzdWUNCj4gPiA+ID4g
PiBTRUFNQ0FMTCByZXN1bHRpbmcgaW4gI1VELg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE9yIHdl
IGNhbiBwb3N0cG9uZSB0aGUgY2hhbmdlIGFuZCBtYWtlIHRoZSBURFggS1ZNIHBhdGNoIHNlcmll
cyBjYXJyeSBhIHBhdGNoDQo+ID4gPiA+ID4gZm9yIGl0Lg0KPiA+ID4gPiBIb3cgZG9lcyB0aGUg
ZXhpc3RpbmcgS1ZNIHVzZSBvZiBWTUxBVU5DSC9WTVJFU1VNRSBhdm9pZCB0aGF0IHByb2JsZW0/
DQo+ID4gPiBleHRhYmxlLiBGcm9tIGFyY2gveDg2L2t2bS92bXgvdm1lbnRlci5TDQo+ID4gPiAN
Cj4gPiA+IC5Mdm1yZXN1bWU6DQo+ID4gPiAgICAgICAgIHZtcmVzdW1lDQo+ID4gPiAgICAgICAg
IGptcCAuTHZtZmFpbA0KPiA+ID4gDQo+ID4gPiAuTHZtbGF1bmNoOg0KPiA+ID4gICAgICAgICB2
bWxhdW5jaA0KPiA+ID4gICAgICAgICBqbXAgLkx2bWZhaWwNCj4gPiA+IA0KPiA+ID4gICAgICAg
ICBfQVNNX0VYVEFCTEUoLkx2bXJlc3VtZSwgLkxmaXh1cCkNCj4gPiA+ICAgICAgICAgX0FTTV9F
WFRBQkxFKC5Mdm1sYXVuY2gsIC5MZml4dXApDQo+ID4gTW9yZSBzcGVjaWZpY2FsbHksIEtWTSBl
YXRzIGZhdWx0cyBvbiBWTVggYW5kIFNWTSBpbnN0cnVjdGlvbnMgdGhhdCBvY2N1ciBhZnRlcg0K
PiA+IEtWTSBmb3JjZWZ1bGx5IGRpc2FibGVzIFZNWC9TVk0uDQo+IA0KPiA8Z3J1bWJsZT4gVGhh
dCdzIGEgKlRPVEFMTFkqIGRpZmZlcmVudCBhcmd1bWVudCB0aGFuIHRoZSBwYXRjaCBtYWtlcy4N
Cj4gDQo+IEtWTSBpcyBiZWluZyBhIF9iaXRfIG51dHR5IGhlcmUsIGJ1dCBJIGRvIHJlc3BlY3Qg
aXQgdHJ5aW5nIHRvIGhvbm9yIHRoZQ0KPiAiLWYiLiAgSSBoYXZlIG5vIG9iamVjdGlvbnMgdG8g
dGhlIFNFQU1DQUxMIGNvZGUgYmVpbmcgbnV0dHkgaW4gdGhlIHNhbWUNCj4gd2F5Lg0KPiANCj4g
V2h5IGRvIEkgZ2V0IHRoZSBmZWVsaW5nIHRoYXQgY29kZSBpcyBiZWluZyB3cml0dGVuIHdpdGhv
dXQNCj4gdW5kZXJzdGFuZGluZyBfd2h5XywgZGVzcGl0ZSB0aGlzIGJlaW5nIHYxMT8NCg0KSGkg
RGF2ZSwNCg0KQXMgSSByZXBsaWVkIGluIGFub3RoZXIgZW1haWwsIHRoZSBtYWluIHJlYXNvbiBp
cyB0byByZXR1cm4gYW4gZXJyb3IgY29kZQ0KaW5zdGVhZCBvZiBPb3BzIHdoZW4gdGR4X2VuYWJs
ZSgpIGlzIGNhbGxlZCBtaXN0YWtlbmx5IHdoZW4gQ1BVIGlzbid0IGluIFZNWA0Kb3BlcmF0aW9u
LiAgQWxzbyBpbiB0aGlzIHZlcnNpb24sIHRoZSBtYWNoaW5lIGNoZWNrIGhhbmRsZXIgY2FuIGNh
bGwgU0VBTUNBTEwNCmxlZ2FsbHkgd2hlbiBDUFUgaXNuJ3QgaW4gVk1YIG9wZXJhdGlvbi4NCg0K
SSBvbmNlIG1lbnRpb25lZCBhbHRlcm5hdGl2ZWx5IHdlIGNvdWxkIGNoZWNrIENSNC5WTVhFIHRv
IHNlZSB3aGV0aGVyIENQVSBpcyBpbg0KVk1YIG9wZXJhdGlvbiBidXQgbG9va3MgeW91IHByZWZl
cnJlZCB0byB1c2UgRVhUVEFCTEUuICBGcm9tIGhhcmR3YXJlJ3MgcG9pbnQgb2YNCnZpZXcsIGNo
ZWNraW5nIENSNC5WTVhFIGlzbid0IGVub3VnaCwgYWx0aG91Z2ggY3VycmVudGx5IHNldHRpbmcg
aXQgYW5kIGRvaW5nDQpWTVhPTiBhcmUgYWx3YXlzIGRvbmUgdG9nZXRoZXIgd2l0aCBJUlEgZGlz
YWJsZWQuDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvY292ZXIuMTY1NTg5NDEzMS5n
aXQua2FpLmh1YW5nQGludGVsLmNvbS9ULyNtNmU1NjczYTE5MTI1NGJmMzZmNDgwODNjZDIxNWY3
ZmY4ZjJiMzE1Yg0KDQpIb3cgYWJvdXQgSSBhZGQgYmVsb3cgdG8gdGhlIGNoYW5nZWxvZz8NCg0K
Ig0KVGhlIGN1cnJlbnQgVERYX01PRFVMRV9DQUxMIG1hY3JvIGhhbmRsZXMgbmVpdGhlciAjR1Ag
bm9yICNVRC4gIFRoZSBrZXJuZWwgd291bGQNCmhpdCBPb3BzIGlmIFNFQU1DQUxMIHdlcmUgbWlz
dGFrZW5seSBtYWRlIHdoZW4gVERYIGlzIGVuYWJsZWQgYnkgdGhlIEJJT1Mgb3INCndoZW4gQ1BV
IGlzbid0IGluIFZNWCBvcGVyYXRpb24uICBGb3IgdGhlIGZvcm1lciwgdGhlIGNhbGxlcnMgY291
bGQgY2hlY2sNCnBsYXRmb3JtX3RkeF9lbmFibGVkKCkgZmlyc3QsIGFsdGhvdWdoIHRoYXQgZG9l
c24ndCBydWxlIG91dCB0aGUgYnVnZ3kgQklPUyBpbg0Kd2hpY2ggY2FzZSB0aGUga2VybmVsIGNv
dWxkIHN0aWxsIGdldCBPb3BzLiAgRm9yIHRoZSBsYXR0ZXIsIHRoZSBjYWxsZXIgY291bGQNCmNo
ZWNrIENSNC5WTVhFIGJhc2VkIG9uIHRoZSBmYWN0IHRoYXQgY3VycmVudGx5IHNldHRpbmcgdGhp
cyBiaXQgYW5kIGRvaW5nIFZNWE9ODQphcmUgZG9uZSB0b2dldGhlciB3aGVuIElSUSBpcyBkaXNh
YmxlZCwgYWx0aG91Z2ggZnJvbSBoYXJkd2FyZSdzIHBlcnNwZWN0aXZlDQpjaGVja2luZyBDUjQu
Vk1YRSBpc24ndCBlbm91Z2guDQoNCkhvd2V2ZXIgdGhpcyBjb3VsZCBiZSBwcm9ibGVtYXRpYyBp
ZiBTRUFNQ0FMTCBpcyBjYWxsZWQgaW4gdGhlIGNhc2VzIHN1Y2ggYXMNCmV4Y2VwdGlvbiBoYW5k
bGVyLCBOTUkgaGFuZGxlciwgZXRjLCBhcyBkaXNhYmxpbmcgSVJRIGRvZXNuJ3QgcHJldmVudCBh
bnkgb2YNCnRoZW0gZnJvbSBoYXBwZW5pbmcuDQoNClRvIGhhdmUgYSBjbGVhbiBzb2x1dGlvbiwg
anVzdCBtYWtlIHRoZSBTRUFNQ0FMTCBhbHdheXMgcmV0dXJuIGVycm9yIGNvZGUgYnkNCnVzaW5n
IEVYVFRBQkxFIHNvIHRoZSBTRUFNQ0FMTCBjYW4gYmUgc2FmZWx5IGNhbGxlZCBpbiBhbnkgY29u
dGV4dC4gIEEgbGF0ZXINCnBhdGNoIHdpbGwgbmVlZCB0byB1c2UgU0VBTUNBTEwgaW4gdGhlIG1h
Y2hpbmUgY2hlY2sgaGFuZGxlci4gIFRoZXJlIG1pZ2h0IGJlDQpzdWNoIHVzZSBjYXNlcyBpbiB0
aGUgZnV0dXJlIHRvby4NCiINCg==
