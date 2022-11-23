Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D706634CE2
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 02:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiKWBXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 20:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiKWBXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 20:23:01 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE01F15FF4;
        Tue, 22 Nov 2022 17:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669166579; x=1700702579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qoNsrzsroRUyRYkFeHmGyYDMRPEaXwImHGOKLPPeKOo=;
  b=U2agHZhE+04e+J/FEkVjYH7aKpG7Uxa0AUUIzBB4LxIFj8czh5SK8u43
   30Q0EkCLJYwWXGrE/Eln4DkO5VvVB0Xa3LhR8MMugHoTl8WZikAjoKMh9
   4e+irw4j9FRNSWMzEIt0j+Nst0V1zm274GcnXyDAItDax2vhxCjGKvqmz
   wfuYSUs8Z4GqW4D/Iub6dZfO8s87TAh20J5VBt5CZYvSzoDkw+j/3jD51
   l+ZovKP1yXW80VhdeTnJSAYZKuCbRICXwDpOuiRMQkCTRDnmEsGu1ftKM
   L8xp+1KnRjwkK1hwbH4YV4p6FJki84q/WgzRJonUm1k5ZikZb/lidUA1k
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="340830300"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="340830300"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 17:22:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="635738577"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="635738577"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 22 Nov 2022 17:22:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:22:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 17:22:31 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 17:22:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUxRCMfuzdQlIW2Wr/qcCpx2ONnRQafHZFwf/rnela4IOh3jCuoFR0FcDh8X/GoTs5lud7p7ZfmtSDIAGr8EONu9WBntmH5Dwu4LeR6R8n9w9N61qOlSbk8rrE9XU8ZZlJc51gafB5e7NZgM8JN176JxnHqdqshyq/+Yx9JBBtoNbTntOJG+8eQXV85f2mdFi0lezOc46j2mlwtneU+kPTimb9Lw4XLmzuJWanNuejC3ZAhdh0xOAmCTTP/E6p80CLqvvDDa/V6fwUFscjd2Z2vyezA8mi58Bfd0fEcfKpRhGKtAbGsmnAuZHfyfEV8vayFtxtbfGhI9Vl8RsF9UOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qoNsrzsroRUyRYkFeHmGyYDMRPEaXwImHGOKLPPeKOo=;
 b=CGgVe9ZhRuoowzfyKFy9nejVRYP8QlqdA/TZtqjZ/IRHgzfer3qX/TKqClnejOyRpgzMR+ee8n0p5RH+iHF/CTB/axYscD7yzxodWa9YLWNcUFD+2XO+4Npx2iW6JCNWpzE7nQY2wXdX+rOT4Qb72985E5SOdYZW06fPvYZIUnXRo1JJgFvC7OM49tbF0tNkM9OBdr17CJs9qNpBL9Om3Wx/j8J17rNSpRETnmuoqaC/3SfaqUvZkzZnaumBZ06gTT8Jme3epH0Bi3UGCElsc3SdyzGpTAf1upNWlRSCydXgY8vdpkmDOl4NHHJmL16XS1y82w2v7rdY6LbT90YoSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6957.namprd11.prod.outlook.com (2603:10b6:303:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 01:22:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 01:22:26 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Topic: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Index: AQHY/T2+AlEdwutNGkW7IAmyyjQDW65KqvAAgABkvgCAAELPgIAAAzIAgABdRgCAAAGegIAABQYA
Date:   Wed, 23 Nov 2022 01:22:26 +0000
Message-ID: <9f1ea2639839305dd8b82694b3d8c697803f43a1.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
         <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
         <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
         <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
         <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
         <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
         <791bf9a2-a079-3cd6-90a3-42dbb332a38c@intel.com>
In-Reply-To: <791bf9a2-a079-3cd6-90a3-42dbb332a38c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6957:EE_
x-ms-office365-filtering-correlation-id: 72766da2-744d-41ac-1fe7-08daccf12e9f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P5xFb1vIqN3OCG5aIRbTlRwKedFi5SOFdy2XRUXi7lNMH8ZQV4AXwvvOv001DqYCbhA8Cf/uQU8Zw0YwPyrwko6n9nLm52v90hFebUZElj7YP1E2ftd1GDDNCVZ6s/z9X+AwRGafhr0MSAWNgCvugNFyau62VeI1GclHBoynKFNvmFLOGNTnFAivf9KrCZsWDWQKJoB7zQT+r4Xw2VXTlr6a0c1z41fh+rA3rqVjGh89vemkBeOAT87E5OWdDPA9rsDqpYhPw03wqVsb7ieg2F7cwZXfGre/Qmkbw+DtY9WdDgkeWDfYS+qYzXTMIeDsdhj6mLVOf5N3u3nn4UU9RaPOEQrifPEKcZVQLZWsh+nkKmmJH4lO9XqYNRZcjcNsxKqvvNvJzN5ciN4pkuenoOcGJnwo/HSbCM7UJ06x8z8FRKXmQnZT3MER719UDaUb6UiYkA8YeVHHxD+wvlQPuZVyaemXHgkfI+M+t5K/dImiNGgQ36Lbw3HyN37fyrgnMCTLykABLrqlu4o9wONjeo+TZ3o526G/l9uNnY2h6cuSVaqrIT3VN8kqqkf4L0HOE9tR5wx8RSfB8/144d0TFQ7tj2OuLtAqn2mzUCybssKY+TsNaGSMmjGMTbTsjLRQEw1zP/CmM3tBXluIKB3b1nhW3RGTuC17Ux4xU09GvtEKHfyWx72NE8hKlmb5CITiVB69uK0r1Pi3xQDSEYPWpkCv5i1xmfpeZjPw8AKRtRA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(122000001)(38100700002)(66446008)(76116006)(2906002)(66476007)(38070700005)(64756008)(8676002)(316002)(66946007)(41300700001)(82960400001)(66556008)(4326008)(26005)(91956017)(5660300002)(6512007)(4744005)(8936002)(7416002)(6506007)(186003)(2616005)(53546011)(6636002)(110136005)(966005)(71200400001)(54906003)(6486002)(478600001)(4001150100001)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0Q1MDhOUVEvUEZOOGx1bEhCQStnQ1p5dFpldnVFUm9yZ0RUM0oxMHkvcHB2?=
 =?utf-8?B?L2RKQysrMGF4blZ6UXEzZHYxTnR4UXBIenpkcElySjNETXl5eCtjeFU1UmNT?=
 =?utf-8?B?QkRVdHJxZTM2QXBtWTBiYUlwSHNJaDRuRVVDMGZreGlYaTZWRnJ2U01xeGxo?=
 =?utf-8?B?RTlwS3hnZnNvcXN5NW9ONzNnWFJQMXNONlpjNWM5d3FvYytOdzArbUhuSld6?=
 =?utf-8?B?akt6MWM3b0tUY2QvRDN5OFFwZS8yTU5ZeStiSlJKUkJRYWxSNFNRQW1LL0l1?=
 =?utf-8?B?R3dwRHgvWnF5TXhaMXJQSHpCZnE2cU5NWlBrZENJMnBNR1g4ZVFoLzJuYSt5?=
 =?utf-8?B?MFZURDRwQUtxRkh0WkZQaGd3R2hIRHdzOE9PYkY3ZFRPUzJ3L1QycUJ2UlFD?=
 =?utf-8?B?MXVJaEtNdGtyOUFWUkc3YmhuL25PaFhhZ1BkcEpnRFFOWXpvOW55dnphNnpD?=
 =?utf-8?B?aVloMDE4Wm5mK01JQ1ZOdXZqYmc5YTVZdE9QZlpsNG81SklLWnJCeHhiZ3lp?=
 =?utf-8?B?QkIzSVlVTkhCKzdrRXBnb1NPRVZ0WjU5ZnN4OHQwWHdDa0J1eE1kMURSdnlC?=
 =?utf-8?B?NWJtZUp0V3I3VlZveWFOV1kyTm9KNVlmVHl2NHZOT25qMU4wWkZPVFV0N3BP?=
 =?utf-8?B?SEI5QTI4dkNDdFYyTTlhQmpvZTVjQS9zbmM4TjZweTBsTmVCZlpvWmdlRmlB?=
 =?utf-8?B?OElpY0Jub1JnMXNjV25NUHh5UjF6OFgyeDBGTjFOZ2FZM0E4WDZJNHRscFBl?=
 =?utf-8?B?Nk1yRFB2b0UvcXBXdlAxZDNmZXhMMjdZYjUwU3RxU0RKT0tqL016bENaMHFu?=
 =?utf-8?B?TnoxZ04rN05EVHhZaGhjS01oS1N3a1hsckx2elNZSWFYU3VtWVZIVU9JM0Y2?=
 =?utf-8?B?NVBLUU83UEtJeGxuM3NaY0tjMFQ0cGZSMjJlQXI4U2w4Tlc4cEpVb2FwMjdP?=
 =?utf-8?B?bTAwcFhkR0VzZzRzRmF1a2pIQU85aDUwR1FvbmpLdUdDSkVTVGZkNG80ZDFP?=
 =?utf-8?B?L3k3Q0M3b2U5ZXhZMm9TZTlYcjlwNmRIcDNzV0hyL3htdTNnVDhDd01OZERn?=
 =?utf-8?B?VmhqSEFqNTY3REJ6WVRtREMyZll0UE9kbm1hN3F0VE9nV1hzTkJhZXUvRHBB?=
 =?utf-8?B?aXM1SzlXVHZsZHJnRmpXczRXUmo2UVNuSGc5Vzd6WGRKU2IyaFkvQlhLL3Qx?=
 =?utf-8?B?ei9DQSszNWNsTnJqdDJLK2hyWk5uSnR3ZUgrbHZDeVl3OWlxRnROMXUvZVh3?=
 =?utf-8?B?UHVXcms5aWlBa292M1cxdUFYekFad2VjdFhvWHJsWWtFTEtNSE8ycmpIY2V6?=
 =?utf-8?B?TGtVZHlmeHVHSTdhUHljRTZEalBZdk1VOCtDSW85MU5OU2ZpQWNWcFhjUnJ3?=
 =?utf-8?B?b2k4NlFwdzNudmZ6U0xlNHc3RnJ4Q0pqOENTYlptOUFZMnV0Njh6c1AvRXdG?=
 =?utf-8?B?T1F2UkQxbGlWblRucUNrYW9DbHNQSVZRU0t6SGpoZll4ei9xc1JZRjFQcVpX?=
 =?utf-8?B?SW8rWG5MZkVXRUlzZUt3MHppejcwZzFBbGdTQ054ZG1UUzBTdGNBU1JKMUlH?=
 =?utf-8?B?WTQxcEFFdW9xMEV4U0FBUlRiRFZMRUZYdWR6TVVWeWVRQkdzblJFV2pmTXFZ?=
 =?utf-8?B?OFZWZ3BQc3kwOCswV2JRMXRZMmp0b215UkdXSkozeE8wQkE3dGR1TmlkUTFT?=
 =?utf-8?B?eWxwOGlkNWV6TWEvazVzeDZZd1JIUkRIVnVuU0RrNjlIeWYxdVJrWXlqYTZS?=
 =?utf-8?B?R3VSa25sT2FHaFFYT2IrZkhuais2a1NURE91cVBnNVMrTmk2RmJIYVRaMlpZ?=
 =?utf-8?B?cjlTaE1oMXZSTEFuUHQ3dTlMMTk3YVRFY3M0TzBRdmRScXBTNC9BQlMrTU1m?=
 =?utf-8?B?OG92QTlZV3RTeUZxTGU5dm52aFRmeXQ0ODhmMTl5ZlRjYWFIT215ZW9YU1RW?=
 =?utf-8?B?c1V0WStEYkdXbEdCUm5mT3dGKzhZT2VrQTNpRXZheFNqbU5jYS9zeTExbWVZ?=
 =?utf-8?B?WnZNNUtubmRjRTRuUEhDT3BHWHdhZWt1NE1NMmFTaCtCNkJkdGVaSFdOZEho?=
 =?utf-8?B?NjUyMm42SVV1QlA4bmxhaGk3d2ptMDU3ZkU0TVdnK1lQcVBjb1FCMEVKUVo5?=
 =?utf-8?B?bUV4WUJ2UHRMY1FBcHFMa2F6VnE0YS9WM3RycHY5TWxmYmpzOVd4WXAzK1RF?=
 =?utf-8?B?YWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9266B7581B08794A8FACD1EDC284B989@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72766da2-744d-41ac-1fe7-08daccf12e9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 01:22:26.7086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GAQx96n4Iu6DcBQtMK1dLRhUKyFAH6OfvQwI6VTRNgnbZJ2HcuGPMQW9grQl31PdyZmJ8BQnt71AK3NHuAjaSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDE3OjA0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjIvMjIgMTY6NTgsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDIyLTEx
LTIyIGF0IDExOjI0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiA+ID4gSSB3YXMgZXhw
ZWN0aW5nIFREWCB0byBub3QgZ2V0IGluaXRpYWxpemVkIHVudGlsIHRoZSBmaXJzdCBURFggdXNp
bmcgS1ZNDQo+ID4gPiA+IGluc3RhbmNlIGlzIGNyZWF0ZWQuIEFtIEkgd3Jvbmc/DQo+ID4gPiBJ
IHdlbnQgbG9va2luZyBmb3IgaXQgaW4gdGhpcyBzZXJpZXMgdG8gcHJvdmUgeW91IHdyb25nLiAg
SSBmYWlsZWQuICDwn5iEDQo+ID4gPiANCj4gPiA+IHRkeF9lbmFibGUoKSBpcyBidXJpZWQgaW4g
aGVyZSBzb21ld2hlcmU6DQo+ID4gPiANCj4gPiA+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGttbC9DQUFoUjVERnJ3UCs1SzhNT3h6NVlLN2pZU2hoYUs0QSsyaDFQaTMxVV85K1orY3otMEFA
bWFpbC5nbWFpbC5jb20vVC8NCj4gPiA+IEkgZG9uJ3QgaGF2ZSB0aGUgcGF0aWVuY2UgdG8gZGln
IGl0IG91dCB0b2RheSwgc28gSSBndWVzcyB3ZSdsbCBoYXZlIEthaQ0KPiA+ID4gdGVsbCB1cy4N
Cj4gPiBJdCB3aWxsIGJlIGRvbmUgd2hlbiBLVk0gbW9kdWxlIGlzIGxvYWRlZCwgYnV0IG5vdCB3
aGVuIHRoZSBmaXJzdCBURFggZ3Vlc3QgaXMNCj4gPiBjcmVhdGVkLg0KPiANCj4gV2h5IGlzIGl0
IGRvbmUgdGhhdCB3YXk/DQo+IA0KPiBDYW4gaXQgYmUgY2hhbmdlZCB0byBkZWxheSBURFggaW5p
dGlhbGl6YXRpb24gdW50aWwgdGhlIGZpcnN0IFREWCBndWVzdA0KPiBuZWVkcyB0byBydW4/DQo+
IA0KDQpTZWFuIHN1Z2dlc3RlZC4NCg0KSGkgU2VhbiwgY291bGQgeW91IGNvbW1lbmV0Pw0KDQoo
SSdsbCBkaWcgb3V0IHRoZSBsaW5rIG9mIHRoYXQgc3VnZ2VzdGlvbiBpZiBTZWFuIGRpZG4ndCBy
ZXBseSkNCg0K
