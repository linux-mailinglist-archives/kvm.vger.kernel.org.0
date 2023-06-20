Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBC4736979
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 12:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjFTKjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 06:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbjFTKjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 06:39:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12ECE3;
        Tue, 20 Jun 2023 03:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687257547; x=1718793547;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ceFDh9Lt7UqC4bdLXIjcgPBQZRdAjJ55u3yseSHqoaI=;
  b=fy6ohFQb0fcutLNC4oZ1YsBpF9+R9i2ddVwEEwCm0fsZ2PyuCrRKCIBW
   NK2QTI8KGtZfXRNzMqWQaepRfEVn5EhCCsP0Rs5gVLpE270vS9EhcUpH9
   lX6KcFCIdLN94CBNXd1jCcN3OqLuiWH/xdg+ZW4HA/jjQG34zWPcdpL/O
   jLi9GKYTmsn70F9m2fpbvgxGBl0KS9XZJwz0yEsXpFW3KPcP1/wUBSofW
   n49uuoAut/0/HRGT33rLM7u7kbwP5nQpRW8TA5U2tENLAP8JyeKwaWmZe
   Csa+46p/YxoDW5bOD+oTssLymljlViBDB9oAXgzpTd/v6CWrkwDMKSx+L
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="425781166"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="425781166"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 03:39:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="708205289"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="708205289"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 20 Jun 2023 03:39:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 03:39:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 03:39:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 03:39:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 03:39:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmWGChNxnSrzxD2yOlZjp1qGPnvNgUN8SFyH1sOhBNEJb+b1kswt3qolg7WkXbmfbG0A6CY46oZocZCtuwjkwhtJap2DBsVZmC6V4hY+1T8rd3Vb7NXN3QpZaoyxvmZ4Sv1k/IzjoyPXV4rcBltUto/9nZKevDQJoAY1r6XOupPmV/LJZKdBuHk/SfkxtbMzGxeuPpw46pY/POFS85ZgsEgx+dXDFW/Rcue8uWH4SB1jnGpKgB9lCoQJMLdYIhd6CjuXGe7bpX1kTt7vcn+NGgqalp8hYmML5Es+BS8P+aYQPsGq/rS/Q+eIZeR3vIZszoRSXKXELZXWLUpwtbb/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ceFDh9Lt7UqC4bdLXIjcgPBQZRdAjJ55u3yseSHqoaI=;
 b=jy1jqnPG/yNmSxa0OV9KbyY+isglU7/x/rVQn1Cwi6kDNNNRIqWhuIQcUlDpQLN6Zd4s0HBv1FtTXaiCt8C4lIfKB8+jkc7Vk+hvhXIzX59LEgwtk4KN5ODDVayoQA0sm2ualWvHiMl2v/hCmnO7gkRZKgYOY2uyO2W0CqkFv8vJhsTrIfAVga+nLWfU+sXgvIlNph4IzCFhv8ur5dmrqENMAH87FPESvcktbHmUP+gRTYP+qYn3PmJzAp1J3ZkB6SBnIkJ1kSvyNOy2naYQb1umYClqyhfH47a4f0PJATYaLTVuJ9IeKzPTurCX8KIGbJIoy2HMKue4qm7zFVMHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6650.namprd11.prod.outlook.com (2603:10b6:510:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Tue, 20 Jun
 2023 10:39:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 10:39:02 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
Subject: Re: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Thread-Topic: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Thread-Index: AQHZlu+v0XNcOtw04kG29tp3PFLJcq+SLhaAgAFq4QA=
Date:   Tue, 20 Jun 2023 10:39:02 +0000
Message-ID: <1cc1879691fcd077fed1a485de799594d751a8ec.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
         <dfb59553-2777-15ed-d523-6a7cc5b68e53@redhat.com>
In-Reply-To: <dfb59553-2777-15ed-d523-6a7cc5b68e53@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6650:EE_
x-ms-office365-filtering-correlation-id: f841aa6c-10f6-433f-dcd0-08db717a9095
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 40gXaxhTyY4HbNVj0Ro0yoBEvoYrS7xpDchpa9cqW6H5K4jDKiNoAwTw8kknXp6EYILtby/dznH/+nmCDZKMItdHhcVvrRfDYul6TwMFFeI3R5FIOSYwEvtISnlZAWXEU8U3qTciTVfd+PmEQAkBmvVr+gpOOwTX0/6eVxPeJUk70Bdi9u9kCE0XlG7mgnNGabInV4Gyd80lV8vh6q4HZVUIfoccCw674ErM5AldqP8vSlwYPG1Gx+OgFTjiYOBVHaCcF8cqU4ZpLV2fogga0qMeKbU1qqMpLGvGxYYqrexZzlFGsCTaEjF3W96JHrG5WyzVoC+oZQhaXl/JAxtnL5p7+Mz2PSnxkH2b/iAK7ZgbHisiyflv91uhNlEwKNT2Spk2IwfE5nFpNrZ9hFJw8QJPEaI1SbWOawUb45ZKpEZswgvmPEd/49mx4Sok/fsK7ukQuDI3qpnKs2AttzGo/NYM0V+uFP8j2gCtRgQx/HdiMlhHpz2Twt1WIeKbBrVFMHw8Y52hpAWC35cBWttQiknzR4Lqxle+5lXW6j9DtfCdaGommYPBdJMo+WpKWdpn+NSCJ9iWRDxm79nDFb8mYz0TTf/YK4Aa1yw/DC9QL1zY+xh3PvvnKdoQ9S8NDbbp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199021)(71200400001)(6486002)(478600001)(83380400001)(186003)(6512007)(6506007)(26005)(2616005)(36756003)(38100700002)(38070700005)(86362001)(122000001)(82960400001)(8676002)(5660300002)(8936002)(316002)(2906002)(41300700001)(91956017)(4326008)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(7416002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFhFMVJ5KysrVTlQUUJ1Nno4QmlDZEQ4Yis0RDU3ZWk5d2s2dmpLcmRFY2l2?=
 =?utf-8?B?dXFZaDNSWWIrMUgwY1FqMzZoLzFqMWxkdDhmYWg1cnlSNTVxVVJDdFN6Rnc3?=
 =?utf-8?B?Z2o0aVhiSFJHcmFHRHZvNHcwWDZRQjI1NWpxRHJPeUJrU21XSlhkWEVIQzVj?=
 =?utf-8?B?amcyQWJEMXdnUGxzbWxuamZoczRjckREaitQMUNuVzQ1Ni9wcnN1R2NPdFF3?=
 =?utf-8?B?R1R5Y1h1clYwd3drZkk1REtvS0RmcWtNSWNuNTZpWURHMXFNZE1kN3JjS0N2?=
 =?utf-8?B?VkdTakllUnJ2SE1tMVk1OTQ3NmhlVGdTQ29wS2tnSlRqUUZ3SmNIN3k0aTVl?=
 =?utf-8?B?dzRmd0kzRWlYMEVXQS9NdUtvenVUYWZFYk1tV3BQZWhmRU04ZjhFU1ZSMzJr?=
 =?utf-8?B?OUtHVkpnditrcW0zS1BvODg0SlhoTkpLNVJnQTgwNTZDeFpZNW9hZW03Q2s0?=
 =?utf-8?B?K3NaNUJreVF0WjNMczR5aWdZcjlhZ0d1MnhxVjhPbUh4WDE3UlFUZWNGY1lC?=
 =?utf-8?B?Z3A2OWpUVVo3QlkrdVhTOHRpNzVQYjZLV0dNYjZxNDV3dG9mOHRwTzZTWDVU?=
 =?utf-8?B?SE03V0RKL0VGTGhFalJRbVNqdzJSTVRxeGRGZ2Y2Ny9YYlJ0M1RtdDNlaCtp?=
 =?utf-8?B?RForRkdqc1BCZGdVR1RaUGdBa05melJYMzRpbi85U0JOM3g3K1hVZy84Q1Qw?=
 =?utf-8?B?VWNLbktYR2JwTEhVWHRKdDFoaFcvcG5rN1kxakZwZkRKTVJ1dnlrM1hzVTFt?=
 =?utf-8?B?VVlkNm15RU5HdVd5UEkvUXdPU2EzaVJkMWppcFl3ZzF3THFyd2lJTnVKUEsz?=
 =?utf-8?B?QUY2Q3Ewa2J4eDVvamtHdDVldjd2WHcwSS9GamNoWlpBMW9ZM1ZFVFJhejkr?=
 =?utf-8?B?VmVDTlh2RmlLUXB0VWtqeHNHbENLVnZEMlhpUnN5V3hpbnBsd0RZaDdMZjd3?=
 =?utf-8?B?Q1JKNk1kTXpIbzdKbHVYRGIxUkRPVXJ3WG1PNHhZc2VpcUNiNnY5UXpNMDAv?=
 =?utf-8?B?blN4SC93UUZtOWg2VmJpOEZheEIyKzd2bEkranEyQzFwYWNSQXVRRFFSVSt2?=
 =?utf-8?B?ZEdMV2ZiVTVkTDI1V0JVTklLNXcvZUxnTEpnVHNYbzZkczRXRnVPUTJxUVJl?=
 =?utf-8?B?MGN6OWw1dmNwc2NyOWkyOUp4NGNJblJaWjM5eGpxQ0c1cUMwNXh6ZmZJSzlm?=
 =?utf-8?B?bEc2cWhUemw4eGhVQThrWXMraFd2QWlQbVhaYkQrVERma0VkZ3JFMCt1cXZz?=
 =?utf-8?B?bTlNZWJVVnlGVXpnWlZ1aTBVYWMwbzg2ZU5LQ3A4Yk9qUmRYYkpHMHdobFBS?=
 =?utf-8?B?UWt2eWdWMXVtUWt2WGdnV0QzMFZuYis4My8rSHVpcmx3UGgyd2dJbUlneExL?=
 =?utf-8?B?dENFTGJqbWM4U1lkdnhJZUY0aXBHN1BXV1JPdUpwMnBrUDJJSHh5Mlo2QWV4?=
 =?utf-8?B?Sk5UTDdtSzhNeFY2QWo4amQ5QXVIU2dNVEFhbVZTVndYMSs5TXcxWlRTQWZQ?=
 =?utf-8?B?TzgrOURUQzllWHpkZTlpVEF0cWVrQlpuUVlFaDVkQm9nenpvSk4yejlQRTB1?=
 =?utf-8?B?eUpUZ0pvb3FUOWpTd0pvaW1WSnhkTzEvWHVKOTNFNFhKdVZYRTlYQjg5Vlcz?=
 =?utf-8?B?d3dZSWwzQUV1bXlySEF6cU5SelBYSEhWd1dMU3NIVnJBNjFiRVc5d2wxRkpG?=
 =?utf-8?B?ZUhjcEdYYy9OdWU5Q1RTRU1GeHZlM3pUS3NDSWNKckk5Sit5NGcrdE54OGNj?=
 =?utf-8?B?OWI5VnpHcEhpN012NXdMN1FBNXVZcjlHUlBKOGoxSUU0cDQrenRTdS90TVZM?=
 =?utf-8?B?a0tRS3J2Vm1WdXZldTlwLytoNzFiUFBDNmtMOXdqVWJOdmRXdVJCQjRDS0FN?=
 =?utf-8?B?dFVraThhbnlDZi9jQ2JCRVY1YTNLUWxJeTF4eDYwVjB2MUNSd3BGaTRIeWZP?=
 =?utf-8?B?cVpCSCtNRFhXeVdGMHNlZlcxdWh4RUVxZXRUS3JBaEdGa3M0WDJ0cXpvenFq?=
 =?utf-8?B?UCt6cmhVbS9xRWpJRmJTOHJBZEVxQ05ub3pFakxrUTNBNzFvRTVlSDVkS3hx?=
 =?utf-8?B?NU0zMnpydHFVSzhkNG9jdU9yeHNRSW90UHIwWDZ1OGl1dFNONkpZanFTUHRu?=
 =?utf-8?B?algvYUh5aEJLb0Jva0VRWlJyYTFXNXpZeFp2YUIxeDVKOGZTUXQvd2NSV3dm?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB426050159E434199191F2D59832A61@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f841aa6c-10f6-433f-dcd0-08db717a9095
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 10:39:02.8447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YpSsMolTnc1pmv/yQLj7sMi1myW/BrLD5E/GZLtVUF3vvcq3iKGMlqHsiBudfwjCT7QQBdo9VRfuqijnOz2NwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6650
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gQEAgLTMzLDEyICszNCwyNCBAQCBzdGF0aWMgaW50IF9fYWx3YXlzX3VudXNlZCBzZWFt
Y2FsbCh1NjQgZm4sIHU2NCByY3gsIHU2NCByZHgsIHU2NCByOCwgdTY0IHI5LA0KPiA+ICAgCQkJ
CSAgICBzdHJ1Y3QgdGR4X21vZHVsZV9vdXRwdXQgKm91dCkNCj4gPiAgIHsNCj4gPiAgIAlpbnQg
Y3B1LCByZXQgPSAwOw0KPiA+ICsJaW50IHJldHJ5Ow0KPiA+ICAgCXU2NCBzcmV0Ow0KPiA+ICAg
DQo+ID4gICAJLyogTmVlZCBhIHN0YWJsZSBDUFUgaWQgZm9yIHByaW50aW5nIGVycm9yIG1lc3Nh
Z2UgKi8NCj4gPiAgIAljcHUgPSBnZXRfY3B1KCk7DQo+ID4gICANCj4gPiAtCXNyZXQgPSBfX3Nl
YW1jYWxsKGZuLCByY3gsIHJkeCwgcjgsIHI5LCBvdXQpOw0KPiA+ICsJLyoNCj4gPiArCSAqIENl
cnRhaW4gU0VBTUNBTEwgbGVhZiBmdW5jdGlvbnMgbWF5IHJldHVybiBlcnJvciBkdWUgdG8NCj4g
PiArCSAqIHJ1bm5pbmcgb3V0IG9mIGVudHJvcHksIGluIHdoaWNoIGNhc2UgdGhlIFNFQU1DQUxM
IHNob3VsZA0KPiA+ICsJICogYmUgcmV0cmllZC4gIEhhbmRsZSB0aGlzIGluIFNFQU1DQUxMIGNv
bW1vbiBmdW5jdGlvbi4NCj4gPiArCSAqDQo+ID4gKwkgKiBNaW1pYyB0aGUgZXhpc3RpbmcgcmRy
YW5kX2xvbmcoKSB0byByZXRyeQ0KPiA+ICsJICogUkRSQU5EX1JFVFJZX0xPT1BTIHRpbWVzLg0K
PiA+ICsJICovDQo+ID4gKwlyZXRyeSA9IFJEUkFORF9SRVRSWV9MT09QUzsNCj4gDQo+IE5pdDog
SSdkIGp1c3QgZG8gYSAiaW50IHJldHJ5ID0gUkRSQU5EX1JFVFJZX0xPT1BTIiBhbmQgc2ltcGxp
ZnkgdGhpcyANCj4gY29tbWVudCB0byAiTWltaWMgcmRyYW5kX2xvbmcoKSByZXRyeSBiZWhhdmlv
ci4iDQoNCk9LIHdpbGwgZG8uDQoNCkJ1dCBJIHRoaW5rIHlvdSBhcmUgdGFsa2luZyBhYm91dCBy
ZXBsYWNpbmcgdGhlIHNlY29uZCBwYXJhZ3JhcGggYnV0IG5vdCB0aGUNCmVudGlyZSBjb21tZW50
Pw0KDQo+IA0KPiA+ICsJZG8gew0KPiA+ICsJCXNyZXQgPSBfX3NlYW1jYWxsKGZuLCByY3gsIHJk
eCwgcjgsIHI5LCBvdXQpOw0KPiA+ICsJfSB3aGlsZSAoc3JldCA9PSBURFhfUk5EX05PX0VOVFJP
UFkgJiYgLS1yZXRyeSk7DQo+ID4gICANCj4gPiAgIAkvKiBTYXZlIFNFQU1DQUxMIHJldHVybiBj
b2RlIGlmIHRoZSBjYWxsZXIgd2FudHMgaXQgKi8NCj4gPiAgIAlpZiAoc2VhbWNhbGxfcmV0KQ0K
PiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggYi9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmgNCj4gPiBpbmRleCA0OGFkMWExYmE3MzcuLjU1ZGJiMWI4Yzk3MSAx
MDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gPiArKysgYi9h
cmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gPiBAQCAtNCw2ICs0LDIzIEBADQo+ID4gICAN
Cj4gPiAgICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KPiA+ICAgDQo+ID4gKy8qDQo+ID4gKyAq
IFRoaXMgZmlsZSBjb250YWlucyBib3RoIG1hY3JvcyBhbmQgZGF0YSBzdHJ1Y3R1cmVzIGRlZmlu
ZWQgYnkgdGhlIFREWA0KPiA+ICsgKiBhcmNoaXRlY3R1cmUgYW5kIExpbnV4IGRlZmluZWQgc29m
dHdhcmUgZGF0YSBzdHJ1Y3R1cmVzIGFuZCBmdW5jdGlvbnMuDQo+ID4gKyAqIFRoZSB0d28gc2hv
dWxkIG5vdCBiZSBtaXhlZCB0b2dldGhlciBmb3IgYmV0dGVyIHJlYWRhYmlsaXR5LiAgVGhlDQo+
ID4gKyAqIGFyY2hpdGVjdHVyYWwgZGVmaW5pdGlvbnMgY29tZSBmaXJzdC4NCj4gPiArICovDQo+
ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBURFggU0VBTUNBTEwgZXJyb3IgY29kZXMNCj4gPiArICov
DQo+ID4gKyNkZWZpbmUgVERYX1JORF9OT19FTlRST1BZCTB4ODAwMDAyMDMwMDAwMDAwMFVMTA0K
PiA+ICsNCj4gPiArLyoNCj4gPiArICogRG8gbm90IHB1dCBhbnkgaGFyZHdhcmUtZGVmaW5lZCBU
RFggc3RydWN0dXJlIHJlcHJlc2VudGF0aW9ucyBiZWxvdw0KPiA+ICsgKiB0aGlzIGNvbW1lbnQh
DQo+ID4gKyAqLw0KPiA+ICsNCj4gPiAgIHN0cnVjdCB0ZHhfbW9kdWxlX291dHB1dDsNCj4gPiAg
IHU2NCBfX3NlYW1jYWxsKHU2NCBmbiwgdTY0IHJjeCwgdTY0IHJkeCwgdTY0IHI4LCB1NjQgcjks
DQo+ID4gICAJICAgICAgIHN0cnVjdCB0ZHhfbW9kdWxlX291dHB1dCAqb3V0KTsNCj4gDQo+IElu
IGdlbmVyYWwsIExHVE0NCj4gDQo+IFJldmlld2VkLWJ5OiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2
aWRAcmVkaGF0LmNvbT4NCg0KVGhhbmtzIQ0KDQo=
