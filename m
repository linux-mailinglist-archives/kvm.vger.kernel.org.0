Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E50663ED0
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 12:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjAJLCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 06:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbjAJLCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 06:02:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA7232E8B;
        Tue, 10 Jan 2023 03:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673348499; x=1704884499;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zIh8M1ovKUbVrr4esCUM2QCiLu2F0Wi7qCjuSp4z52g=;
  b=HVwnviu7uMgosKrQHzSiAZrd+paVI4ihwoiKtQAOTT6CNWeUnvZt8Z1W
   lqK9VPS9GgpoC/V8rHDL7PvgliOnGPyj0hBznjMrNXU5wpRqk2rczyzHs
   T4EyOaRwrH/QX3bzB8rQMvOYTRuUOUiw9wX7KxFNk2yNOwLw6AmqFI7ai
   itiKQbgrkKGMxBDdj8sH88O9tjHFvCKd8JiUyGxe59CYWu5T8kGekjH1H
   JALyiyQvzybKSqyfnHO1Dh4j+dhC+UNPCbIj1SgH1iyZhSfWdJLL+p7/j
   7OUGCaEPmTMlc2tprasu9OHPrlNmU7soQrHONr2/MN9nkxhKvx7+zJKQF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="310919126"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="310919126"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 03:01:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="781026924"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="781026924"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 10 Jan 2023 03:01:39 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 03:01:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 03:01:38 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 03:01:38 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 03:01:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHfGHdjdefvGM8F8aoWEG+RpHeQ5eLcEJ6m1vVw5vFOMx0gqYSu7Umgjunp//yPZC/fBwQwl0aEBkIZmNzEcEnKMrQWrJwIcU27VLBCrmeAgmoaYqQ6JYvUmLBMF0qbMWYlKKn3jUpn6SC1R+9FryzqoSt29RZJRdThBx+Z7mAYDk4nu1n47uM1maH7pZJyC4vy+/3XfZjepg+YtkFNw1AGx1Rypu+9W3jAkWAVD/pQAFjPxs55hi+kB7sCeTxhRVPBtfi4IGDUKKN85Lhnu60SeYa79ddNr6MkqbizxIMSIxj/c/atJPE3ABlVkXqthfHr+c3byuHPtKEtjUgYE7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIh8M1ovKUbVrr4esCUM2QCiLu2F0Wi7qCjuSp4z52g=;
 b=fWOBOS/yIVCqRu4V1QKJufBe+ZBdaA43Se60/pT8ru/8NZ1yf0YQrm/tqSJwDZwFE6s0n+VZA8iY6ZKXeZFCT5YoMUV2vzP7PWQx7vayUXinrW9d+Vwolbc7f/dcBgdn9ldj9q06yia4j9tsaIijzrEffQtiC3D2kwBv115MeXhkbm77/k+8JtpGuzg+G50DegrnGtwcMs+irHkvBCfBnSC4YtxwMguXQu/gTXxWlgn+g62KNENj7scdgZBX7gKOvvxB9Fvw3EeKPHeHhIIzePtahzNnSplXgxSmlIM62NQ8ph7Y8bqd+oAIl3KyOeqJx8DaVirX5yGYqPG3hJq0Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6218.namprd11.prod.outlook.com (2603:10b6:208:3ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 11:01:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 11:01:31 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Topic: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Index: AQHZC5gQ3FCTeDpWDE6DayveLyjo/66SH22AgATsd4CAAKKzgA==
Date:   Tue, 10 Jan 2023 11:01:31 +0000
Message-ID: <5f7891ebecb8dbe71b9e2c67332df716f0b9a8e0.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
         <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
         <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
In-Reply-To: <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6218:EE_
x-ms-office365-filtering-correlation-id: 5da03b1b-eeee-4681-aa29-08daf2fa07b8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cHuq8eS6OHTZP7Xcetd+gwQWbptRr9mKm3q1HXN6W7xUXsFIwkIZtqRONFc/eNs0dYairxFb9RdjlfsLfir3YjzXngSEg7SQ8HEYQp48f8qlNALG5EjS9a2lAvr0upEIPLvELygGpqdwKA9daU5dB6VhuJaMnJUFXYFnmQPZ1h2Ip9Wc14tNiPiuoVdYADLJqrixrMyU2/N2Ey8tjW0U4DmKwrW6XnC7znaAgDpmEmuTVJ1urBEGJuICvhh3i0YaGNDrMC8g9dNxlqF00+NQWjkmZGOeBf59haP+Zpu4PxvK8GLIO2WRfSvgyEtv8sE01Zcz41fxnt7+HZjIM8t5TyXNz/0Yp+63osT7L0k+oQvXR3bTYw3oZhRfpyms8S+QtTV7bK8NXP1vMMQm+GXSC+8WWWCtiPvXoFpIc9JdAAmNrQHQzmSC1aUAyioWy5VfrEt+LWIdSsSminsMLKoOAPJ8Z/ILPfCs8Rjlx57sGGfHNqMgzXe6sSO+QckdtvV+WNqEg9Lw8H08nN0sXirWO/zNm7LA8mgCwNDOto/Rv0/sXeHeQDnJIHlmVjsSaS20UJFTGsAErjJhEchbiI0tZtwalq2/kkahZLy4BnFsjOLO8No7Ub3Rh2Yer2lwaet68uxSbWsKOTkweNJ9BYrhwOU4H8wuQceWmr08mezZZalJDVkzLbSFGo+++a6EWyOVMYRTr34KFYtCUgNr8oUZx9uA4ricyyZjtE0WVE5syU4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(41300700001)(110136005)(4326008)(54906003)(2616005)(8676002)(76116006)(66446008)(64756008)(36756003)(66476007)(66946007)(66556008)(91956017)(86362001)(38070700005)(82960400001)(38100700002)(4744005)(8936002)(122000001)(7416002)(5660300002)(316002)(2906002)(71200400001)(6506007)(6486002)(186003)(6512007)(478600001)(26005)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REgxRXphWXBtZnZMS2xDL05Lb0NVZ25jdnZzTjYwOFVGd0RuWDJ5aWR3SkJP?=
 =?utf-8?B?ZzlUdEJoWEt4ZmVLMXdvc0Z3MmVBNUtUb29sU2VqQ0lGWWFkUFpVRVhvMXhM?=
 =?utf-8?B?eXUzTUxQaWFjQ3JYZEdrNGM1elJlU3hjZ2tXKzBWeHd1aERqR0xRUSsxZjE1?=
 =?utf-8?B?d011N1lWRVRoQjRiL0owZ0Z5cVZEK2JSTGtEOXh6NXZmM3BoYkRtV1FqbzlE?=
 =?utf-8?B?VjQwN280UzZHUTU3QUVSMFFvcHYxWjNlMDQxRWtQajVna2VneXIwaDkzSlBo?=
 =?utf-8?B?dVJxeUFRNk1qc0R0bDI3TDYrUlkxUjBYUjBrVUplTUt0MnVPZnZ2RXR6a0lP?=
 =?utf-8?B?TGp2Q21rQnNEVzFmMktUMFRXVHdkSjZidXJxMkdQT0JSVTh1M0ZtWktvMk1P?=
 =?utf-8?B?bTd3Qlk2ekp2MmhXM2NtN0RKOU1YVVVCTTdKNDhKNVVWNlNqSzhkZ2ZJMWNl?=
 =?utf-8?B?cVVlUGJhZVBLM2VpVnorRzNLVXhTMEJFS1Q4Z0VoVndJZXo4cXZxM1hEQXI5?=
 =?utf-8?B?LzJmYTlVdW5mU3hYWTdaOHdXVURrRVJyZkhNMUQwTC90L0lqZEIvTnE2cVdD?=
 =?utf-8?B?TkZaV3lXemNUdmJxa05wYmpOMXlGb04vTC9XNFVSRU9IWnZ6K1huYjJyaWUy?=
 =?utf-8?B?dG83MGFoaktIMlc4UUFaMzg2MjBodk44S2VWbDAzQ1NrTjlzak1LMHlCWVdZ?=
 =?utf-8?B?cXVSZ2MzNmdsZ0VvcE45VklKQUpaOEgvTDFENGNmUy9VU1R6RjkxSEhvUmRX?=
 =?utf-8?B?WnNoazJQb3FvajlVMVQrQTFXd3hOYjdSNzMwVkNTT2NNRGNpSkJLZHRxWVJr?=
 =?utf-8?B?RDhzWHlISHBzRHRIMk5BcGM4OHl1T3YzMG5KNzhkN3R2RlpndnNUVDNXbER6?=
 =?utf-8?B?UUJqeXlNWElDcEoxY0VZMlpLVDd6bmlhSlNqd3RITDlldEFNZzZrZHpVSGRV?=
 =?utf-8?B?Uk55WGhHekRCTmd2cU5wNFVqakl4Zng4d1AvenliTWowRlpQcUcwWGxaNU8w?=
 =?utf-8?B?MGV6UEpnR3RhOVg3WmVpVDN3TERVQVVPVkxuKzhFUGFpbGdEQ3NWd3llU1Mw?=
 =?utf-8?B?b2JSdWhjdkJSTk1KTHNaVlBaYUdNZ2g5WEwrakVaRVZ1MnI4Smh5TTI0NHV0?=
 =?utf-8?B?TUhhb045MDBURG9TQnZlWkFiQTYzQURGTXUrajVldXR0Q2tMUnFra3NzQmJx?=
 =?utf-8?B?Z29PRFVheGRJbEdTcmpaTmxSRmF6Yk9rNkYvTEFMOWxKWU9SWGNxYWtZdCtw?=
 =?utf-8?B?LzJ3US93UytRM25UZ1FjbWpEekJHb1ArdUIyUVpMNzNGVGlvb2k0SlQzQjlV?=
 =?utf-8?B?eEVFWVh3SzdXRmJuMVJBblgyTEUyalpFcFMvNmtVRUhRalcyZUdXdE1WQk4z?=
 =?utf-8?B?WUxKSE1zOVdlMWk2a0VZT2VDa2d5MjY1VEozNWtMZ00wd1hjckpBcElYYkhu?=
 =?utf-8?B?Z1d6UEFYcWkrNHlMUjBaQXl5REgydVRvWFRFeE5McGpoajBLa2NxdGxZL2hK?=
 =?utf-8?B?V3VZQmRRSE1vaW4wb0tCSkZoS29TemVnVnJZdzRBTDBNMlRQVHl3SXM5QlY1?=
 =?utf-8?B?UTRpRWRTQm4welhtTktGcGV0OVVkb0wwYmxuMlFiQTdVNER6UUtYazAzcmt1?=
 =?utf-8?B?UjY3cE5lRXdXVXR2bjRPb0hzd3J0MkVrUXluUjBDZkkzQko1WFFpR0hIMEdX?=
 =?utf-8?B?MjRudkJLMW9jTjE2c0VjNGFkSzBKWEw4SzdjMUxHd2VhanhTK09Bamd2eUVH?=
 =?utf-8?B?U0ZOQ0xKK3FVbVpMMElSMWxLRlR3Q0hzSVhNS2lNa2xCSXVJMVorQ2E4QXVF?=
 =?utf-8?B?c01NZzlGYlU2WU9YclBFS1l0YWd3K0dDZkovcTUyUitubURRajN6emZCTEVh?=
 =?utf-8?B?RDdPc2NvckY4VE4wTllwdEZyeU1VSGpBc0xSUXlNVnAvdGI4dnIvT3hJMnJU?=
 =?utf-8?B?SkhrYkhnazBUaGcrOE03dGs0NTQ5SXZHSkVPTDU5bG9DYWVXdzc2eGVGTlBj?=
 =?utf-8?B?dlp6RXRrT2xVUGRpK0FienJlUmxvcldIY1FlNDdaTEkwR25sMThSRWVwWE9O?=
 =?utf-8?B?bVlnV1lnWTEzMXB3K0RvWVIzNVpVTExCZ0cyZnVZL0kwNDdvQS9jWGIzMmgz?=
 =?utf-8?B?ZXRQdmpOQ3Z3cHU2MFBpRGRyUjlpUTEyRkpFODZIUS80VU5wRzErS1hNM08x?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D81C1C42F4C964799F62024FCCBB88D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da03b1b-eeee-4681-aa29-08daf2fa07b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 11:01:31.1479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZD7Y0Qt49+/tF//bvHTkH1HN5vL35LcqZvuDyUO0wuKLXamCmqTA6BCckZB8tLoyKCdt1DJt3P0wv2XXzhJgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6218
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

T24gVHVlLCAyMDIzLTAxLTEwIGF0IDAxOjE5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IEkgdGhpbmsgdGhlIC1FMkJJRyBpcyBhbHNvIHdyb25nLsKgIEl0IHNob3VsZCBiZSBFTk9TUEMu
wqAgSSdkIGFsc28gYWRkIGENCj4gPiBwcl93YXJuKCkgdGhlcmUuwqAgRXNwZWNpYWxseSB3aXRo
IGhvdyBsYXp5IHRoaXMgd2hvbGUgdGhpbmcgaXMsIEkgY2FuDQo+ID4gc3RhcnQgdG8gc2VlIGhv
dyB0aGUgcmVzZXJ2ZWQgYXJlYXMgbWlnaHQgYmUgZXhoYXVzdGVkLsKgIExldCdzIGJlIGtpbmQN
Cj4gPiB0byBvdXIgZnV0dXJlIHNlbHZlcyBhbmQgbWFrZSB0aGUgZXJyb3IgKGFuZCB0aGUgZml4
KSBlYXNpZXIgdG8gZmluZC4NCj4gDQo+IFllcyBhZ3JlZWQuwqAgV2lsbCBjaGFuZ2UgdG8gLUVO
T1NQQyBhbmQgYWRkIHByX3dhcm4oKS4NCg0KQnR3LCBpbiBwYXRjaCAoIng4Ni92aXJ0L3RkeDog
RmlsbCBvdXQgVERNUnMgdG8gY292ZXIgYWxsIFREWCBtZW1vcnkgcmVnaW9ucyIpLA0Kd2hlbiB0
aGVyZSBhcmUgdG9vIG1hbnkgVERNUnMsIEkgc3VwcG9zZSBJIHNob3VsZCBhbHNvIHJldHVybiAt
RU5PU1BDIGluc3RlYWQgb2YNCi1FMkJJRz8NCg==
