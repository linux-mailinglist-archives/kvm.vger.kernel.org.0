Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C85751F44
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbjGMKsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234239AbjGMKru (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:47:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7029212B;
        Thu, 13 Jul 2023 03:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689245269; x=1720781269;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rtKc7U7eq2Upeewh9gR2vWAoak/eI8af6FssZ9iqJzo=;
  b=WkCJvICXsHdAAFq+v4fekNc/6yLgCdtc8f8bBGw3z5GaChKAlPmnHS4k
   2Ue5YbVaCGEZjd0kWFxb7KHoYVLhQGy9P+7JnZg+pc63MS8qXENKjpx/P
   GyuBRWAG3FUGkGqKHIhD1u4ZElwBSTznJrcKhBJl6nhD6QQpwcFmTs8hI
   gG6Iq851E/x2w2yPxThhUlS+fRtrDYf4TUH3uvAh9TotpgR66NmuJ9Zfx
   5lOifFwWg2lCTZn1TORk7ZpXN+E1X8/SVDe0D3sx3yjHVLp+IHHZMN2L4
   UER2em1Eq+LV3GJZ1jj+exaWir6eh8eOjDTdv89C4N4DHO8Zm1J2U6oLk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="355067395"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="355067395"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 03:47:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="725260592"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="725260592"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2023 03:47:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 03:47:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 03:47:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 03:47:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLhwh/Kr50jLyi3RdCGksFdHkKTVfJAVrtkNtJFahdsVafi4ZQOHWyeQlb/S+2weoafR0UOrWiQaJTnXuFaa89L2URdEG96B3V9LODBcdvUTmLWfd5lfdNPX/O1UNjmIAggo5N57ubrqNk2L9ItOifR87CBW8ZhAvS5z5Kok5jmgvJYZUittbhWqFWHTjTZSQHzeFKFVdDfMnWRQvHTS6ItQNGbi53u6fFT6UN+d8xgI1Nvxp5NK8w19CK3VX0LaCqzpoHRtZBXwsQ2QEWkSqOgHgUi9+WXZErUR/ZtBWtZUnanj671wHYcVRB9RLkgxSxmNXVA6/LSlB8hiOeXgGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtKc7U7eq2Upeewh9gR2vWAoak/eI8af6FssZ9iqJzo=;
 b=AH57fkXeNtfMEVRNTPiD4w4+Ax6YB/3G3zkknvnVq74qXW4PiiSGt0tuaz2NQI+o25wb4regv6+znO47UBzEg9gIDAqadDKnBvrAuBy4ADMSHLwKEqXM8i4wkC9ETIf5nmUPEH2pAQfIxgJvzs84XBB/Ea0kNWN9SoH12iKJhu6RU6CW3gtwPLTUPjXYgI9Lewfq/vzAcPUI/i4wLDs1Jf4sNeTEDMVU+5V0mm6+edfzi5hgOB1twEveRC/O9F2/uz6WxM9zQ6kGvgR5xoWTZB6g2sCimMwyLaFgBarqHeaIbhSEm6UxQCyIwGUnnpAiEs6zs9bjpJ7ghrRfLYj4hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.26; Thu, 13 Jul
 2023 10:47:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 10:47:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Topic: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2WZEAgAABkQCAAPx6gIAAC1QAgAAa7QCAAAT4gIAAAtYA
Date:   Thu, 13 Jul 2023 10:47:44 +0000
Message-ID: <edf3b6757c7e40abb574f2363e34c8d3722d8846.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
         <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
         <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
         <cc5b4df23273b546225241fae2cbbea52ccb13d3.camel@intel.com>
         <20230713084324.GA3138667@hirez.programming.kicks-ass.net>
         <5cc5ba09636647a076206fae932bbf88f233b8b2.camel@intel.com>
         <20230713103733.GF3139243@hirez.programming.kicks-ass.net>
In-Reply-To: <20230713103733.GF3139243@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4882:EE_
x-ms-office365-filtering-correlation-id: a262e36c-47a1-48b6-d278-08db838e9729
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WN8hww/SYoWSud5Lo+Um1ZHWmbNOAwA5RHVhzwAc68/7q0veJREM9Ud8ByVFhv7Ro/lRR0be5ORprbjn084dUR6GzTVHvlveD540b1K+f2RNb8xfw4SCMvJS7OKcL6pFuDaU9GUC9nb9Ij/I8xrtWZfKe4zHaL27fgcIdutscPuwI4P7ZeuBpL02imPQhlXOqOwx5GpevIXvhgzljQzTx36xqbAZrfyHVJNmJRRzLFd52gXFs0qpc+eivd+b5TAOe8ug0sXlac9NPbmLrWD122fqZu4mxmzeTo5kKnOphsPtQsVLmP4tgnS75SzMlPqaRMUZ98RRontucx6+mtWj5f1eCUHZA3u499s4wtJXV6BKvHH3aG/V4HCk8JVwtGJXXgff9Nq/nfLd54IctZWduw3QIttvOSWafCoad4q35BDO1FPVn4Ht7gi89yAcbNmWh9rtGcrhl2AcSQcXzZ51B4F5FyR19AXmjpuVEJxJ1KcfcuhGtepnL0jZT0Ylj53m7ThY0k8bfQpAS2leKdponFkVpBwGOdkCobtKTpi+HpTgWUNqrr3I22cf9PLtshkzaQMRE9evVGWLo9Vahi6JYGCumiEnUbG52jqTEFciEiRsMAUj4rYCAGAjGj1JDgTQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(2906002)(2616005)(82960400001)(38070700005)(86362001)(36756003)(122000001)(38100700002)(6916009)(316002)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(71200400001)(91956017)(186003)(26005)(41300700001)(6506007)(54906003)(478600001)(6512007)(6486002)(8676002)(7416002)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmE0cXFMSU9IRmFzTEhCNG9NR09PSnp1cDd2R1ByQXNZODZpMWVhVHphL29P?=
 =?utf-8?B?UnJoR25GQlJqSTNmcyt6SDV3eVIxOUh5Y1JKZWJKWENacWNoalhhWGJaSUtD?=
 =?utf-8?B?MmJQUUdMak9QOW91N2FXbEdoT3dubU95bTNkbzR0Y3FWT05zVXdMd09PRHFl?=
 =?utf-8?B?U3RwdjhyQTVvd2VSdWQ4bTNmb2diSnFaTEk0NGhLcSszZmIzNmJSZGNRTk5C?=
 =?utf-8?B?bUkvQ1grRE5oS09lNWN0V0diRUhNMGxrTG1LVWtLYzEwNndRTHJwUE5wdjdL?=
 =?utf-8?B?QnRWZHhNbHVoc2llVTlISTBGMDVUc0pjU2pJT2pDYXptdUkyUkZ4QmpBVThV?=
 =?utf-8?B?Ri9FWTNsU3JPSGZoTmN5MmNOWGpuWnFNczY2b3FLT1Bodjl1U0RGdWc1d3BE?=
 =?utf-8?B?dGkzTzFUSmhIOGRaa0dxSWNnbHhXbzNsaU04UWRoVTdLcnpWUE9OU3VsakpB?=
 =?utf-8?B?MENHUWZHemJ6Vm4yRHdtM3FSa3Y5R2QyK0E5dWcyZ3ROeVJpdTgrVUgycUJQ?=
 =?utf-8?B?a1A4bXk2eFF6ZW1MYWd4QWsxTE4vNkl5TGpQSldFUWF2MzVJNnhmVDhSOTdB?=
 =?utf-8?B?UkR6TUJEZzN6bTY2aWJyRTJPME90QkFoRTR5VzBWMm9jS0xRcWkxbk1STVlF?=
 =?utf-8?B?cm1PWnN2cGNzQnlhaXpsUCs1L0dDOHhFVHNpa25KS3dHcXE5NlBiRG82K0Nv?=
 =?utf-8?B?OHlaOFdTZXB6dzRrUEY4UmdmbkROY3kvTk5GY3hVZnczUVg4M2s0WjZUcThS?=
 =?utf-8?B?RDBIR2Y2VGFhcWdhd2d3cCszVk8zdkc4V1Qzdm5jb0w1L01pL2Zvam4wMGVQ?=
 =?utf-8?B?TEdVVHB1czVObTBiNUc0V2tjY3N4UlZUSHRFeEY5YWlFMCtLZlJIR0dYSlQ4?=
 =?utf-8?B?aWJQcjlXUmo5RURSTjRYNmlMeUVEWlgrU2p4anBrVEtHenpSRzVzbzA2WVM1?=
 =?utf-8?B?THZteXFjQmZyVmRsTzZIb0tDSTYrRkdNVnFkV2I1UW1jcUdVNDB1TTZuYnF1?=
 =?utf-8?B?cFlGcVlZd3VEMTlIZGRxTHBhMS9BbXRoSVJxNTNOU2pKbk5ZOGVNWEY0MmZy?=
 =?utf-8?B?NEsxWWNhdDdTVWVHcmh3U0RaV3orVU1yN2xDV0hPQlFGb0w4Qk1TcSs0Y1pX?=
 =?utf-8?B?OU0xUkFpWVgwbCtuaWFwM3M0WUQ2c2d1NUJORFZLMmh0M1VzRzZnK2xGemd5?=
 =?utf-8?B?L1UyNVJQZGhHUHRDNlJGMXNkNFJiMWFTVkUxLzY3QjJ0eXBKSVFWelFUa1lq?=
 =?utf-8?B?a21GSXRKZk9xaHg1SzZXMzBpNUQrbHRwUDFBQkh5dzE2S3NXTVYrdHZDbkI2?=
 =?utf-8?B?RXdIUllRNGxDdHBvZXRNQXhWRFZqcHZjN3N3dTl1ekFDVzNacmRlQjhUNDBO?=
 =?utf-8?B?MFRWbHdlcTNOb0xTNE1LMGNJVTVFckxtbUFEWEFRanhvMGVKMGpTWWRtdXMw?=
 =?utf-8?B?ME5HMlBNczJWOEVSYkVqNUU4YUhGcWw0cTVETTNndnN6U0hseU9pS0dNblda?=
 =?utf-8?B?cXpiaDA2Tk9LK3FwUEJEcGNNenhCSnBTNnhlYmpKZUpHZmszSy9DOWhHa3VF?=
 =?utf-8?B?M2lqOXZwTnJ0SXhjdmlpb2M0Yk0xZ1VzSnMwclVDOVJrMUM5Qk5qN1J0RGh4?=
 =?utf-8?B?UGVHYTJDUFVkQ0dUL3JCeXJIUHpqV3kwMDVZUmZkQ3FYZHNQZWYrWHU0Mk5m?=
 =?utf-8?B?VUNQK0Vpdm5EU0o5MWFtdmQ5RlpKK1NtZ01SUlVOSXVlYzNMcXQzZGpOM2gr?=
 =?utf-8?B?R0hlMnBNcFdZcm9lWUowQXJEL1FMbUJZN1ZMMmgxQVZBbmZVemFtWUV3K0gz?=
 =?utf-8?B?ekN5dmYwbk9uMjgrUlk0ZklkV1F3OVo1OG83aFI2V0JkMUFJaUJDazdPNFdy?=
 =?utf-8?B?NEN3TFVJdXdFNC9tajk5WVE1dFdCKzViWXFHMHlhdUJVdytRd3FYc2tsaGJs?=
 =?utf-8?B?YktlVlc2S04vRzVQbFdBRWRlNld5c1JYTGNtaDVHT2o5clNtUncvay9Pc1dy?=
 =?utf-8?B?eWhHUVhEUUJMV2xoeXA5MnRDcGRkU2R2UWpxRmlCWC9qdTJUOUlyOEpCT05X?=
 =?utf-8?B?UC9KV0dJL21STzgxVXBHS0poZjZHMGtFaTVsYVI5bmJjU2cvclZndkQvWFV5?=
 =?utf-8?B?Nis1czh0amFBbGZkcXRIb0w5VXNSQ3dYU0VuK25JMkM0czQwTDRIS204dUNh?=
 =?utf-8?B?cnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACB15DAA326BC04C91076CD2E360F297@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a262e36c-47a1-48b6-d278-08db838e9729
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 10:47:44.7305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J6yLy/YFKq/b134Tk1OX2SLNVbjqB3eUb1Gsuo9Y+lfmEY+vIsA7TfM0u8ZSHFu5fO0kCtArDOU5ig2rfhgNuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4882
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDEyOjM3ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMTA6MTk6NDlBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBUaHUsIDIwMjMtMDctMTMgYXQgMTA6NDMgKzAyMDAsIFBldGVyIFppamxz
dHJhIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDg6MDI6NTRBTSArMDAw
MCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IA0KPiA+ID4gPiBTb3JyeSBJIGFtIGlnbm9yYW50
IGhlcmUuICBXb24ndCAiY2xlYXJpbmcgRUNYIG9ubHkiIGxlYXZlIGhpZ2ggYml0cyBvZg0KPiA+
ID4gPiByZWdpc3RlcnMgc3RpbGwgY29udGFpbmluZyBndWVzdCdzIHZhbHVlPw0KPiA+ID4gDQo+
ID4gPiBhcmNoaXRlY3R1cmUgemVyby1leHRlbmRzIDMyYml0IHN0b3Jlcw0KPiA+IA0KPiA+IFNv
cnJ5LCB3aGVyZSBjYW4gSSBmaW5kIHRoaXMgaW5mb3JtYXRpb24/IExvb2tpbmcgYXQgU0RNIEkg
Y291bGRuJ3QgZmluZCA6LSgNCj4gDQo+IFllYWgsIEkgY291bGRuJ3QgZmluZCBpdCBpbiBhIGh1
cnJ5IGVpdGhlciwgYnV0IGJwZXRrb3YgcGFzdGVkIG1lIHRoaXMNCj4gZnJvbSB0aGUgQU1EIGRv
Y3VtZW50Og0KPiANCj4gICJJbiA2NC1iaXQgbW9kZSwgdGhlIGZvbGxvd2luZyBnZW5lcmFsIHJ1
bGVzIGFwcGx5IHRvIGluc3RydWN0aW9ucyBhbmQgdGhlaXIgb3BlcmFuZHM6DQo+ICDigJxQcm9t
b3RlZCB0byA2NCBCaXTigJ06IElmIGFuIGluc3RydWN0aW9u4oCZcyBvcGVyYW5kIHNpemUgKDE2
LWJpdCBvciAzMi1iaXQpIGluIGxlZ2FjeSBhbmQNCj4gIGNvbXBhdGliaWxpdHkgbW9kZXMgZGVw
ZW5kcyBvbiB0aGUgQ1MuRCBiaXQgYW5kIHRoZSBvcGVyYW5kLXNpemUgb3ZlcnJpZGUgcHJlZml4
LCB0aGVuIHRoZQ0KPiAgb3BlcmFuZC1zaXplIGNob2ljZXMgaW4gNjQtYml0IG1vZGUgYXJlIGV4
dGVuZGVkIGZyb20gMTYtYml0IGFuZCAzMi1iaXQgdG8gaW5jbHVkZSA2NCBiaXRzICh3aXRoIGEN
Cj4gIFJFWCBwcmVmaXgpLCBvciB0aGUgb3BlcmFuZCBzaXplIGlzIGZpeGVkIGF0IDY0IGJpdHMu
IFN1Y2ggaW5zdHJ1Y3Rpb25zIGFyZSBzYWlkIHRvIGJlIOKAnFByb21vdGVkIHRvDQo+ICA2NCBi
aXRz4oCdIGluIFRhYmxlIEItMS4gSG93ZXZlciwgYnl0ZS1vcGVyYW5kIG9wY29kZXMgb2Ygc3Vj
aCBpbnN0cnVjdGlvbnMgYXJlIG5vdCBwcm9tb3RlZC4iDQo+IA0KPiA+IEkgX3RoaW5rXyBJIHVu
ZGVyc3RhbmQgbm93PyBJbiA2NC1iaXQgbW9kZQ0KPiA+IA0KPiA+IAl4b3IgJWVheCwgJWVheA0K
PiA+IA0KPiA+IGVxdWFscyB0bw0KPiA+IA0KPiA+IAl4b3IgJXJheCwgJXJheA0KPiA+IA0KPiA+
IChkdWUgdG8gImFyY2hpdGVjdHVyZSB6ZXJvLWV4dGVuZHMgMzJiaXQgc3RvcmVzIikNCj4gPiAN
Cj4gPiBUaHVzIHVzaW5nIHRoZSBmb3JtZXIgKHBsdXMgdXNpbmcgImQiIGZvciAlciopIGNhbiBz
YXZlIHNvbWUgbWVtb3J5Pw0KPiANCj4gWWVzLCA2NGJpdCB3aWRlIGluc3RydWN0aW9uIGdldCBh
IFJFWCBwcmVmaXggMHg0WCAoc29tZWhvdyBJIGtlZXAgdHlwaW5nDQo+IFJBWCkgYnl0ZSBpbiBm
cm9udCB0byB0ZWxsIGl0J3MgYSA2NGJpdCB3aWRlIG9wLg0KPiANCj4gICAgMzEgYzAgICAgICAg
ICAgICAgICAgICAgeG9yICAgICVlYXgsJWVheA0KPiAgICA0OCAzMSBjMCAgICAgICAgICAgICAg
ICB4b3IgICAgJXJheCwlcmF4DQo+IA0KPiBUaGUgUkVYIGJ5dGUgd2lsbCBzaG93IHVwIGZvciBy
TiB1c2FnZSwgYmVjYXVzZSB0aGVuIHdlIG5lZWQgdGhlIGFjdHVhbA0KPiBSZWdpc3RlciBFeHRl
bnRpb24gcGFydCBvZiB0aGF0IHByZWZpeCBpcnJlc3BlY3RpdmUgb2YgdGhlIHdpZHRoLg0KPiAN
Cj4gICAgNDUgMzEgZDIgICAgICAgICAgICAgICAgeG9yICAgICVyMTBkLCVyMTBkDQo+ICAgIDRk
IDMxIGQyICAgICAgICAgICAgICAgIHhvciAgICAlcjEwLCVyMTANCj4gDQo+IHg4NiBpbnN0cnVj
dGlvbiBlbmNvZGluZyBpcyAnZnVuJyA6LSkNCj4gDQo+IFNlZSBTRE0gVm9sIDIgMi4yLjEuMiBp
ZiB5b3Ugd2FudCB0byBrbm93IG1vcmUgYWJvdXQgdGhlIFJFWCBwcmVmaXguDQoNCkxlYXJuZWQg
c29tZXRoaW5nIG5ldy4gIEFwcHJlY2lhdGUgeW91ciB0aW1lISA6LSkNCg==
