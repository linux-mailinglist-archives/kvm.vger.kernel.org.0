Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FFC736048
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 01:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjFSX6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 19:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFSX6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 19:58:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E49B1AD;
        Mon, 19 Jun 2023 16:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687219112; x=1718755112;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TDsoPNdYFKdTTdgHUMHiRod8FYIpKc5W9/ohz9EQ6wg=;
  b=UxI1IiDEcFc/FLRvqXULSCoUpe1OyaeM7zHVcI2vkKkCiw9VBx7OwC3E
   4ol5dTCL7h3KRB4AZDsCguuqpoWIa9dITucOLYDVhPwFRElosGdmKuw6l
   BRqkkjIVnoit/PrtsyxxoE2VlfXa52ZhG2ASGDP4r3FkUm7r3OLJ/TzZl
   1c0TO3rQyQ89JUzdYcOP8DbEAyL1jcWkVwJ1NZkHNzlA55pLvpliJ1MKs
   Ga6/rhXtdwq4N3iD2ycaJZD30Pbzgqcl0QAnfPo92PgU7+jiCOK6MA4pJ
   KjOiVo7Ct62F9I3BpbGLw2iWeL4HKc3hTdZcSAwvmKVqfX0axrHKbJEig
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="358598671"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="358598671"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 16:58:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="708054623"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="708054623"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 19 Jun 2023 16:58:31 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 16:58:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 16:58:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 16:58:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHzDwUKIq/N5Tw0dT1jGrF0cyZHcznlnMeu0+Jt4tE6elpyR4FTqgaBpbviY4rJi95hN/mpKriUE4kWPepNMjuLwh8UyP9y0AKu+zLNvOJC2Y47carri5NFiUu+fFXhrbygZ5SDq/WvvEIe3ICgR2Iez8XVBRq7YWrJOGO3Jln7hpWbc1Bqwr1BJYo0nH4tcXHVnNozVZlL8/9cD7h9y/GlVTDvNJg95kJbgBo5Fpc9e0InI8Cf7d+ZCjvSoh2y+8o0l6svSMxhqY3oX9oDCcHIwK+wKq19AVp677NiWWZsPDcL7a+F2R11mqb0Prb6ck7m0vFqB3rAzhzQfBnwYGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDsoPNdYFKdTTdgHUMHiRod8FYIpKc5W9/ohz9EQ6wg=;
 b=LRq6Aj3HCwGyUHHd/u9MwI5/Cn/neRPTYsTZJx9rRJhmmkgalakxE/6fFUJg0jkknqZMcRSWaFkGbNRb3vy2IRBAxJBAmtCPrrc38Pb54PxiFl51C1D8FmVH58nuVlINIS66VI4JHcknFVXgZ5A0npL2pY/xEAhYKLAiW6gOx8xkwLk/vzbwTKyqJ2l+MkY3HugweJq1dYqOOTPIIiAGoxa0lI1FwcgZ+pcevSgB7RXIx2O9uuR4oRuULb7lJZVHpaWj7Kq9VzlEuMf2bljageZKUk1AoX3TzAXSXZwCU8/76bE2+hKnbJy1Zh+Oqwm5C+oV/yAUDPqJBecSS2FTWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CYYPR11MB8305.namprd11.prod.outlook.com (2603:10b6:930:c1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 23:58:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 23:58:27 +0000
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
Subject: Re: [PATCH v11 02/20] x86/virt/tdx: Detect TDX during kernel boot
Thread-Topic: [PATCH v11 02/20] x86/virt/tdx: Detect TDX during kernel boot
Thread-Index: AQHZlu+rpaaVXo8nO0KFA4JXild3XK+SILUAgADFSQA=
Date:   Mon, 19 Jun 2023 23:58:26 +0000
Message-ID: <190d38fc17268badc401b7de1a87f09acd0b1a2a.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <af4e428ab1245e9441031438e606c14472daf927.1685887183.git.kai.huang@intel.com>
         <13174f0e-801c-bdac-5df9-484435de1f8e@redhat.com>
In-Reply-To: <13174f0e-801c-bdac-5df9-484435de1f8e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CYYPR11MB8305:EE_
x-ms-office365-filtering-correlation-id: 5d7f61d6-335a-4fbb-5653-08db712112ed
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xHHUmUH7INLQ77twEftZNPRy8gaP+s7N+P/LabGdjEfSqr+rg4m0GHMDBJ8nFsOjUVk1/ukQCPUca6Sz2JCSjHHybyQjOGKWUroluWKDSgl0/A+iu7o7GlKfXygRLDRGxRMm4xTuY0xjkAcb3LA2SHwLv4mnw9snWOpOayx1EM0a8vzO5GMzVVbj69txScY7ncCsCSaJXgfo3EMDyNjTo3/lizpU5nsyW01nn/8nKlqE3dGxI9dKFyKuwYtu6eSOxYytmT38YEAAXnu9/KXQ7tapow98zqaT/qT3al5H+8ZKPdkCUwSvkEMi3fmE5yYsQ1oVyTyFl0/SsMFrOCWSuPbLIosK1HzjX5yTWHCcCMy4+IZ3MXMOWVgpDEf5mmZM3WeOWi7CMcXDUcbgyvoP7lGFWe2SVQTWfdTIDHgPRtZU5wcNiuhi/7re+5RjsnBZGnylrfBs9jG4eBw1/3ox7DliQLdiQmI5dD7zoO7MKdBoldeB1+KbV3emalKig7SNrqJ7XaN22IAOhy1jnXWHBU1QcVQK9+vTZOTI8Wxbf13T5qg88TfzcyyCUh0orQokWfGStDImYD90l+RpXgh0pYdGw12mmSQW/UxFSgATyhl3QBsedsmL7je36TKx+dPp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199021)(7416002)(2906002)(478600001)(4744005)(5660300002)(41300700001)(4326008)(76116006)(66946007)(91956017)(66556008)(64756008)(66446008)(66476007)(54906003)(110136005)(316002)(186003)(71200400001)(6486002)(8676002)(8936002)(6512007)(26005)(6506007)(2616005)(122000001)(38100700002)(82960400001)(36756003)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzlJL1VocE9QMlduOTJIS2NlcmZCWS9oYyttNlVMWmhqSlQ0VEk2UlZ3N1RG?=
 =?utf-8?B?SVZjNDk5dHpTeWFibjlwRHlHamdZekFTSEF1MFBpWWZENWE5VmNrRXNPb1NB?=
 =?utf-8?B?em9uSHk0SUVIbzg5WW1LNWd3Zis4QVI3WThqSytJT0ZGUlk3OXE5SllsblJr?=
 =?utf-8?B?RU9yUGMxTmtPZzJSdFZOc0MrOVhYdGJtUm5wWnpMZHZmTjNRRmVoRHlDQWFY?=
 =?utf-8?B?bnMvSHNzVzdHUS9uWit1L0ozZWpKUkU1WXlNdlJOOG5teldzQVFWa2lJd0g5?=
 =?utf-8?B?MGlma3M3T1FzTGFCRDZLNnkveEMxdDlvU1d4S0VWVC9uY2h3TXRBNWV1azVO?=
 =?utf-8?B?blRyOXQ4TlVsRHRhaG1KTlZaS1U3Y2ZEMUtWbWV5L01kR1pEZWo4M2JVc2dW?=
 =?utf-8?B?OFFlQVhsV3B2Y0M0NlJ1NS9hU2VPOU96RVJqNEt0VkFoQk9mVTZhS0ZQLy8z?=
 =?utf-8?B?S3dlSmJvN1U3ZXd4L2kzbUZmOWp0N0JHREhUL3BGUmlwaEgzZzhmOVZFQTRW?=
 =?utf-8?B?cUp5MHQrREhQRFEyT3Fnek80RUVBNll3UlNNZkNRS0t6a2VIZFFwbVg0Z3Ra?=
 =?utf-8?B?WWZ5SGFNU000eDZ4RWtRUklxZXB1QjY5QmhYeGJMMUhOdEJTbE9XekIyNld4?=
 =?utf-8?B?UWRaSHk5NHl6dm02b2s5NHJHSmtQTzBFK3dRTWR1a3h6a3RUVEQzOXR6THNF?=
 =?utf-8?B?aFpYaDVqck9scktCQ3E5NDAwNWJvTUVRVDRPUjRWRUxOZTRQMzE3cHFON0po?=
 =?utf-8?B?QlU5Y0NhRk14Y1pPT2J6d2ovT3Jva002QmtHYVVzQk0vMWYzUTcvK1RmQ2ph?=
 =?utf-8?B?TkZKbW1RdmZPSklydDlRbXJkVzBZMUhJTVcxSzVoNGxPUFdCdk5yUDhTVW1t?=
 =?utf-8?B?WnlqUnpSRmJ5aHZRVEQ5c0NrTnhaU1daYjRBeFczSTMycUk4TXF1MU1IaWR6?=
 =?utf-8?B?QlIwZTByeTc5VnJqZjZzRk9sQjNNZVdGaGZha0t0cXl1QzFCeUVMOEZLa1NF?=
 =?utf-8?B?UmFwSnMvcXViOStlRENmcjlwbHQzOVk3ZjBpQXJzNU9ZZ3NGbHNuTzB0dmR3?=
 =?utf-8?B?eGZSNy9XS1B3VlJEelp0T2xkME80ekxRL0JDOUJqbGk5b2hMZGoxKzJnU3d3?=
 =?utf-8?B?b2c1MGxaZHpGMGFTOHhSNkR5MCtPc2p5LzR5Rm5JeVJWeEs0RFBYRUdwS1cv?=
 =?utf-8?B?TCtIOVNFQVVTOEJmRnhXcXQ4SXdiTUFaRk9DZGxyRElsUDBBcTNjOGVLMktq?=
 =?utf-8?B?UHZIOG5RZG1TblB6SnR2cVlSOXFwSlNZQ3pYSVVjd1k0VUZzQlZvMmV6eWRQ?=
 =?utf-8?B?UkR0cEpLOGVUbXgvcmpQN1hiRU5rT1lXRGVaOFNsVitUNER2NkdML3ZFWWRv?=
 =?utf-8?B?SjVlK2xjcFJQTWxEKzNBL2lKRlhEcFU1VW9DMmVSSFFodEtHWFUzeU96ZTM2?=
 =?utf-8?B?T2NCU0s3MzAvbklzemVRRFBEMUQ2aUs5MGRrVmxpQzhib0Z1UkNabFlEbFpD?=
 =?utf-8?B?YXYvK2R1MldkWWVaaTBXdGdkZDlhOXgvVDZZTjFna3hpYkc3Ky82WlJOOGRP?=
 =?utf-8?B?em1FRit2dFZoYzh1eXY1Nlh5bUI3aitOQTl2TC9NUnBRc1I5RjlsV3dGeEhq?=
 =?utf-8?B?cTRHSjdPck4yZndQVUUvQVFNSTBKY1JSTVcyNTU5bnU0UEY0YkMzVDI5Y3Vj?=
 =?utf-8?B?SUt0aXBCcXJhK0VvdE43c2FUZnpFOXlFVVJBbDI0Ulo5NFNmM3QxNGlxVmx3?=
 =?utf-8?B?QkdaVnl0cm0ydCtPWDB2RlFUQlkrdmtQVHhXUFFydWoyVzYzUmpoWWkwMkRH?=
 =?utf-8?B?OENLWlkxMDR0eHpUVGhzcGVUeHlyM0tDYkRqd3BFaVhoWUQyOGFOQmdnMWZ3?=
 =?utf-8?B?YVlpNWxMbEFsdm5OU1ppczRidjAzdjMxeUdCVDJXSk1Qb2dsVS9ZdTMwSW9J?=
 =?utf-8?B?bEZNODNWdTZVR1BGQlk5aVdpNlJGK1lVZmhvKy83Q2RLN0V3ZzVBaGdaQWFz?=
 =?utf-8?B?eEFRdDhhODA1c0ovdU5QSmtvZlpsSllKbzY1WFVLMUFCazZYK09ta1ZMRHVv?=
 =?utf-8?B?S2NUY05jTEdVY0RUeHhNYTJqOHZHMjFZaExhajZmRWhURVkzWUpSQW5Gc1Bj?=
 =?utf-8?Q?spxiL4O4jn8GLawhKAXRjzfsU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5F45FB97CEAAD4FA3EE00DDDFF7970D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7f61d6-335a-4fbb-5653-08db712112ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 23:58:26.7938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4B6YBV/92G3EMlMFU+hdV5NUoXgGuGomx2EhWe4teUYq4557qgck6E7JsVCqqVRCcv0M2Y8fuQb7DNxIOTkBCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8305
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

Wy4uLl0NCg0KPiA+ICsJLyoNCj4gPiArCSAqIEp1c3QgdXNlIHRoZSBmaXJzdCBURFggS2V5SUQg
YXMgdGhlICdnbG9iYWwgS2V5SUQnIGFuZA0KPiA+ICsJICogbGVhdmUgdGhlIHJlc3QgZm9yIFRE
WCBndWVzdHMuDQo+ID4gKwkgKi8NCj4gPiArCXRkeF9nbG9iYWxfa2V5aWQgPSB0ZHhfa2V5aWRf
c3RhcnQ7DQo+ID4gKwl0ZHhfZ3Vlc3Rfa2V5aWRfc3RhcnQgPSArK3RkeF9rZXlpZF9zdGFydDsN
Cj4gPiArCXRkeF9ucl9ndWVzdF9rZXlpZHMgPSAtLW5yX3RkeF9rZXlpZHM7DQo+IA0KPiB0ZHhf
Z3Vlc3Rfa2V5aWRfc3RhcnQgPSB0ZHhfa2V5aWRfc3RhcnQgKyAxOw0KPiB0ZHhfbnJfZ3Vlc3Rf
a2V5aWRzID0gbnJfdGR4X2tleWlkcyAtIDE7DQo+IA0KPiBFYXNpZXIgdG8gZ2V0LCBiZWNhdXNl
IHRoZSBtb2RpZmllZCB2YWx1ZXMgYXJlIHVudXNlZC4NCg0KV2lsbCBkby4NCg0KPiANCj4gSSdk
IHByb2JhYmx5IGF2b2lkIHRoZSAidGR4IiB0ZXJtaW5vbG9neSBpbiB0aGUgbG9jYWwgdmFyaWFi
bGVzIA0KPiAoImtlaWRfc3RhcnQiLCAibnJfa2V5aWRzIikgdG8gZ2l2ZSBhIGJldHRlciBoaW50
IHdoYXQgdGhlIGdsb2JhbCANCj4gdmFyaWFibGVzIGFyZSAodGR4XyopLCBidXQganVzdCBhIHBl
cnNvbmFsIHByZWZlcmVuY2UuDQo+IA0KDQpZZWFoIGluIGdlbmVyYWwgSSBhZ3JlZSBidXQgSSBj
aG9zZSB0byBoYXZlICJ0ZHhfKiIgYmVjYXVzZSBpdCBhbGxvd3MgbWUgdG8NCmVhc2lseSBkaXN0
aW5ndWlzaCBmdW5jdGlvbiBsb2NhbCB2YXJpYWJsZXMgYW5kIHN0YXRpYyB2YXJpYWJsZXMsIGVz
cGVjaWFsbHkNCnRoaXMgZmlsZSBjb250YWlucyBtb3JlIHRoYW4gfjE1MDAgTG9DIChpdCBhbHNv
IG1ha2VzIGxpZmUgZWFzaWVyIHRvIG5hbWUgdGhlDQpsb2NhbCB2YXJpYWJsZXMpLiAgU28gSSdk
IGxpa2UgdG8ga2VlcCB0aGUgInRkeF8qIi4NCg0KPiANCj4gQXBhcnQgZnJvbSB0aGF0LA0KPiAN
Cj4gUmV2aWV3ZWQtYnk6IERhdmlkIEhpbGRlbmJyYW5kIDxkYXZpZEByZWRoYXQuY29tPg0KPiAN
Cg0KVGhhbmtzIQ0K
