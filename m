Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A7743E41
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbjF3PGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjF3PGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:06:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799441FF9;
        Fri, 30 Jun 2023 08:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688137560; x=1719673560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IC6ycRO104gjGaWvubfpJmxGFYo7mNbT3w+OpnXAF6k=;
  b=HsBRtAfLC1Ut+F4PbnNfpg3AqYVwPf1TwVAioZiTCmpBryY233YD9FId
   B2umrv4pZK88xtTp5ckORSqFjpoxoBkjdmSUU7H30svDYMPpsgb17ZKJi
   RTRk5b0F/ivXcECZ79dFv1SxvpVnrppzVFE041SRzUIwT+VMqDoOO174m
   wE2HE+LvXoNUeGvpKQQV7Fsqfg3USfCpBfrIN3Yxdhj4Wicvs3DVFEnWR
   KV24kYMkWQaMBNbfDzKi0v0jQYVhDoNPFwqTNoYINJmD1wv+sfam4KCD/
   2DDSAP+FEaRg1HC7e47diUDDxr8YqDz/XMg/j3lqZ7vplYMLGYKZ4bpmf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="428456812"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="428456812"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 08:05:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="841897577"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="841897577"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 30 Jun 2023 08:05:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 08:05:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 08:05:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 08:05:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTrmX+1nhvL+JctbWQ4STwvvIsvldZagYXqLYiKTd85Z9knHd/Iabz57hqM+35YBTX8PiCw3rIE+8/9cd0cZnt/rPmA4kkYaCzLbFQi971wrIcZUmDOY23PLQVPHwiia4HrYw10QCToh6CeGpa8l/LAiyDTNeU6DF1blGPoVbIkRhURCHoBzGKKxkilo95OhwI/g21kKm9lr6Z7LMc3f0Lq5UxmFaEEhfuD33Yd0Z5PGk/dw70Xh21gpc3q21L1iUblwS/MIklJNe4aJEJe0+nVC/JWMkqGQDD3RD9neX7epqX/ZPqmJ4FDGzuP3Wt1MgF0bPLAp/dMUWRPn90s4yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IC6ycRO104gjGaWvubfpJmxGFYo7mNbT3w+OpnXAF6k=;
 b=RxGK2giFr/oscWTKe2esOlNaRu6WOKclClhbe42s0m1hcDYEag7doJ4pCDOTPIzJbQQVOorU/5GEqs8JZmzr1P4Ps9QgPN45hlHp8AixtuNzZHcSQy7qR3ZC8hHae+7HbNo1QSMR80AIqYskO08fy5/IaPzKj+jb+qdaJ3BVTQi40ntx4G101z4n+GgKje9kuz8/EbavAkxTfCuBtD2mtJMa4ZPopHdSx9StoFYrBZwyPDK9hyh/o7UtzvxJOevKmZlY0EhJ/T0pSKJ/HFpnF74rwckh8BTDuz/H34IyHVK8yafYIHf2hsZWbog9Bjd4y8xIFjBvdVNDKw8C9SaxsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6)
 by PH7PR11MB7450.namprd11.prod.outlook.com (2603:10b6:510:27e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 30 Jun
 2023 15:05:54 +0000
Received: from CO1PR11MB5107.namprd11.prod.outlook.com
 ([fe80::a8a6:41b5:74ac:e2d5]) by CO1PR11MB5107.namprd11.prod.outlook.com
 ([fe80::a8a6:41b5:74ac:e2d5%4]) with mapi id 15.20.6544.019; Fri, 30 Jun 2023
 15:05:54 +0000
From:   "Neiger, Gil" <gil.neiger@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
Subject: RE: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Thread-Topic: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Thread-Index: AQHZqzYYqQglnvQawUuRS2Dzv6LIHq+jJKGAgAAbOYCAADFe8A==
Date:   Fri, 30 Jun 2023 15:05:54 +0000
Message-ID: <CO1PR11MB5107FBC68DBA6877E390A633912AA@CO1PR11MB5107.namprd11.prod.outlook.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
 <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
 <ZJ6uKZToMPfwoXW6@chao-email>
 <8dec8b09-2568-a664-e51d-e6ff9f49e7de@intel.com>
In-Reply-To: <8dec8b09-2568-a664-e51d-e6ff9f49e7de@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5107:EE_|PH7PR11MB7450:EE_
x-ms-office365-filtering-correlation-id: 7c43a557-41b2-4d88-b153-08db797b803a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GgfjPXDx2elk0Tx5SqWYedD63RMlicMghlUl8MikCbMThQa0h7yGmPGpiDkfX0AecnCt+K0ie/SWQyyOHrkBqL2e9xgmmgytPdupk5hFDFZ2+6BSyY5ekHWCOrbSHQBCA/sDJ+/bOMz0VoE/3yWkd8ZDRrD+OCwmLRmyVfCC/MdAbGklAtaQ2iV3Q0V++NpkNR3z1zX5hp8V72msAeBGHWbeOwsQ1Tf4VWIMbpbiLfd0j5LU2qXbnylUzHiCykyEUdkzOne36z1nE135isCGNAZ7PDWXSUVRBCkw+Px6NZAggfyfLEL93NQbtTceMRsHHR6lJy9KJzxt6f4kOCySLXhZijVNKTN+VIrR2CI+m+1yhex94y59Pt8WRrHaCUOFiWiPb0L3DN46R5fNQzfKaJGeVtU/5N/FvY7syvZ2skYgNoxzuudGz0py1Q05tJ5JmBU4OsVYGFOc6LwEmptfxayhA2KtJZy+FnL00Rp7LTqvl6QqcBOhofnG2M00fR7LTEL+3KtvXC0OMxDI/adzhG9Xw1MmjcC38v3RWmMGzqS2p0NUlyZD77hTSkBftAWc2zjDau+yB2EKV8KykSi1+QHqJmFNXc20xu2dM/PcNuKl6XRVtwwWaizL8BNiYGAY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199021)(66446008)(478600001)(110136005)(54906003)(86362001)(38070700005)(55016003)(66476007)(6636002)(64756008)(4326008)(33656002)(2906002)(66556008)(66946007)(41300700001)(316002)(76116006)(7696005)(52536014)(5660300002)(6506007)(186003)(9686003)(53546011)(26005)(83380400001)(8936002)(122000001)(82960400001)(71200400001)(8676002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1ppNFpsbFpjR1FDemJ2aGJjTG5UeUlMNFNiRDF6dU5STUZTZ2VPQ3NXaHJa?=
 =?utf-8?B?VGtEaVRSU29xZ1FxREVscW9jS05MSEhkdjU3OGlpaXRwU0REbXpYZXBzVHdw?=
 =?utf-8?B?Tyt5Wm5HMmIrV3BnMFEvaTkwZGlFM1NGSzd6TG1HUHJSaGw5YXRiZ3IrcmRq?=
 =?utf-8?B?ZHZDdGM0czRPRG1oYS9zanJkalNSdmx1dW5IZWw5KzhWQVRzZTBXMzZYaFlH?=
 =?utf-8?B?Q0F3eGdGNHp4Q1dQZnZWanc1bkRSN0JOTnNCNVcyRzRHYnV1NVhkRTFQMWk1?=
 =?utf-8?B?cHorOWRIbDZFQ1htcmRwYXpZN2VuSXMyVFBkdkw3aDZkK0l5QVY1RFd3RzJ5?=
 =?utf-8?B?R1ErWXlETEZCL2YvUnpBWitpb0JlVk5aTzBUTy9Cd1VFb0lqNWN4NWNRWlVC?=
 =?utf-8?B?ZmJzcnBTZ0cxblpseDRJMS9ITVE1d0RmUmZoUTZFTHMvZEZuZW8zaGQ0dkpL?=
 =?utf-8?B?S2ZNYVptY3JUemJodi9oVHFzaXZ3SFFZNlB3VUJMK0R1TC8vMDdMVjhhbndz?=
 =?utf-8?B?VWVWbDF6b0F1VUljWlBNZ3lyd1Fkc2pqVEYxaERkTEtoZGZHWUU2amhZR1I4?=
 =?utf-8?B?UUhlTFg4RDFLSnliSHpjd2lrZnZWZ3JPM2trcFlnVUNoRWkvbitxNitZU1JP?=
 =?utf-8?B?YnoxREJybHh3VkRlZWY4eVJzTG1oOWZaTmRQcU9oYjVOOW95VVZmb3VhT0F3?=
 =?utf-8?B?K0xYM1dYWjBROHMzTjJ6bnNKenpXclVIKzZPd29zWlozVVNnLzFWNThHN2Z5?=
 =?utf-8?B?cGFodnZlTjR0c0kvY2lGZDJiekVmODRPYTNIN3ZWcXZGUHlwTkVaVXZUQ0dq?=
 =?utf-8?B?dW9tNVJXcnJrZ3hlaWR5VFk0endocit6M1pMSWNCNXUwbUtqeDNLemhYUUo0?=
 =?utf-8?B?NWF1d3NFM3NCWTVtSmJCYmRINEVxcnNtdHgxaGdETnNtTXNIWWtwYnhFZVBs?=
 =?utf-8?B?Q3JveHIxdXJubDdLRzdFc0xzTTZKQk1YM3B4TExkb2wwSXZOeHdPcjY5UnE4?=
 =?utf-8?B?RDBMTnFBTHAvNlU4T255NmhOZy92OXlxb056TW1URzdiSXNxZVd3L2owNzZC?=
 =?utf-8?B?VWNxb0ZMaFNHclN6Yk1WTldONVBIa3hQWHlYUUpZZW50Y1FuZ1RSRVRzSTly?=
 =?utf-8?B?QVNuSncvV2pDTERaMFV3ZHhNZ3NrbHFjYVcwYlZLOXlzREk1dStOdVR0MXlV?=
 =?utf-8?B?UE43QXMzN003WVpMY1ZtQk92Y0pqQWNSb3RaZnNqeFlXZXdpTFpLSXFTVENs?=
 =?utf-8?B?R1k1bzlwdEJsem5FVklTK0Z6em51NGxlSHE2dXFJWHZTVU1TTU9TWk5WWUQ3?=
 =?utf-8?B?M3YrYTlVZXVScjRvTVZrWHJkOStuR3ZWS1BjNWVNanEvN3dhQnp4YVFuWTV0?=
 =?utf-8?B?YlRTUmF4ZGJYanRobHNweXRRNlBrS1h3MmFHZWJ4ODAwRk9mcGxLMTN5UnRi?=
 =?utf-8?B?Tkw5bFNMcHNyUGx2TWYvWlJCby9sZlZyQmg4dFVtK01oeUw5dy8vU0F5RHBZ?=
 =?utf-8?B?bTFvQ0lTMXo4TmVIK1lUdkpGamRSOGZYdVNQZTdxYkpzeERqNmpTby93Zlh1?=
 =?utf-8?B?ZUl1cWxGNDIzMyt4ckNseUw4akNEM1N6Z1I5QVZhZFNXNTVZRHc5Zks2cEk4?=
 =?utf-8?B?YWdRbUp4ZzFZNkJ4VnlSUXNyTTJER2hXaS9wYzN3L2hyc2xjT0I4b2RRSWM0?=
 =?utf-8?B?aDl6RTVrdFFFVlNFc2lwbkJ5VXA1bXZCU0RmVmFBRkNaY0hYZ0ttZ09WNGs1?=
 =?utf-8?B?VTRZWjJEQjRHT1Zmb05ETGxxT0JFWTBmRE9KMjJneTBCcmlqRm5vYVBrbmtv?=
 =?utf-8?B?dGxJSGlGTHVWcTBJNHRTT09GZUtCT1NJc2hVdmgveCsxcGx1Sy90UVpsUjVR?=
 =?utf-8?B?dnRuMTgwdThzd3MzZ0RFdzhSNGFmUWgwMXZUZWtuOXc0MkUzQ09TWjNOK1RP?=
 =?utf-8?B?bFl4RjZBTExZTHpZN3BVQTZuUWdZY0VpUWc1RWdIN3JmaHhYU215aWJydU5R?=
 =?utf-8?B?ZmpSRm1TRVNEcFhvWnFHMm9GenhJS3Q0a1h5K29qZnF5MVZqV0gwT1VpZ2ls?=
 =?utf-8?B?eXVEWHZaMkZDVSs0Z2VLZEhJZXJ3WWhERVRPRGdIZ083RElJL1ZGVnJFNlMr?=
 =?utf-8?Q?lPoY8oVu3JHbi4SrfZ602IaK8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c43a557-41b2-4d88-b153-08db797b803a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 15:05:54.2223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XRuL47CfeKYLweFz5v9lStofkFcGLb0hD+QRmuaiJHCCtA40UNN3ntKqA4wxZDdCAW/iXxZ63GJrdkissoU73g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7450
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

SW50ZWwgd2lsbCBub3QgcHJvZHVjZSBhbnkgQ1BVIHdpdGggQ0VUIHRoYXQgZG9lcyBub3QgZW51
bWVyYXRlIElBMzJfVk1YX0JBU0lDWzU2XSBhcyAxLg0KDQpPbmUgY2FuIGNoZWNrIHRoYXQgYml0
IGJlZm9yZSBpbmplY3RpbmcgYSAjQ1Agd2l0aCBlcnJvciBjb2RlLCBidXQgaXQgc2hvdWxkIG5v
dCBiZSBuZWNlc3NhcnkgaWYgQ0VUIGlzIGVudW1lcmF0ZWQuDQoNCk9mIGNvdXJzZSwgaWYgdGhl
IEtWTSBtYXkgcnVuIGFzIGEgZ3Vlc3Qgb2YgYW5vdGhlciBWTU0vaHlwZXJ2aXNvciwgaXQgbWF5
IGJlIHRoYXQgdGhlIHZpcnR1YWwgQ1BVIGluIHdoaWNoIEtWTSBvcGVyYXRlcyBtYXkgZW51bWVy
YXRlIENFVCBidXQgY2xlYXIgdGhlIGJpdCBpbiBJQTMyX1ZNWF9CQVNJQy4NCg0KCQkJCS0gR2ls
DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBZYW5nLCBXZWlqaWFuZyA8d2Vp
amlhbmcueWFuZ0BpbnRlbC5jb20+IA0KU2VudDogRnJpZGF5LCBKdW5lIDMwLCAyMDIzIDA1OjA1
DQpUbzogR2FvLCBDaGFvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQpDYzogQ2hyaXN0b3BoZXJzb24s
LCBTZWFuIDxzZWFuamNAZ29vZ2xlLmNvbT47IHBib256aW5pQHJlZGhhdC5jb207IGt2bUB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHBldGVyekBpbmZyYWRl
YWQub3JnOyBycHB0QGtlcm5lbC5vcmc7IGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb207IEVkZ2Vj
b21iZSwgUmljayBQIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT47IGpvaG4uYWxsZW5AYW1k
LmNvbTsgTmVpZ2VyLCBHaWwgPGdpbC5uZWlnZXJAaW50ZWwuY29tPg0KU3ViamVjdDogUmU6IFtQ
QVRDSCB2MyAxMC8yMV0gS1ZNOng4NjogQWRkICNDUCBzdXBwb3J0IGluIGd1ZXN0IGV4Y2VwdGlv
biBjbGFzc2lmaWNhdGlvbg0KDQoNCk9uIDYvMzAvMjAyMyA2OjI3IFBNLCBDaGFvIEdhbyB3cm90
ZToNCj4gT24gRnJpLCBKdW4gMzAsIDIwMjMgYXQgMDU6MzQ6MjhQTSArMDgwMCwgWWFuZywgV2Vp
amlhbmcgd3JvdGU6DQo+PiBPbiA2LzE3LzIwMjMgMjo1NyBBTSwgU2VhbiBDaHJpc3RvcGhlcnNv
biB3cm90ZToNCj4+PiBPbiBGcmksIEp1biAxNiwgMjAyMywgV2VpamlhbmcgWWFuZyB3cm90ZToN
Cj4+Pj4gT24gNi8xNi8yMDIzIDc6NTggQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+
Pj4+PiBPbiBUaHUsIEp1biAwOCwgMjAyMywgV2VpamlhbmcgWWFuZyB3cm90ZToNCj4+Pj4+PiBP
biA2LzYvMjAyMyA1OjA4IFBNLCBDaGFvIEdhbyB3cm90ZToNCj4+Pj4+Pj4gT24gVGh1LCBNYXkg
MTEsIDIwMjMgYXQgMTI6MDg6NDZBTSAtMDQwMCwgWWFuZyBXZWlqaWFuZyB3cm90ZToNCj4+Pj4+
Pj4+IEFkZCBoYW5kbGluZyBmb3IgQ29udHJvbCBQcm90ZWN0aW9uICgjQ1ApIGV4Y2VwdGlvbnMo
dmVjdG9yIDIxKS4NCj4+Pj4+Pj4+IFRoZSBuZXcgdmVjdG9yIGlzIGludHJvZHVjZWQgZm9yIElu
dGVsJ3MgQ29udHJvbC1GbG93IA0KPj4+Pj4+Pj4gRW5mb3JjZW1lbnQgVGVjaG5vbG9neSAoQ0VU
KSByZWxldmFudCB2aW9sYXRpb24gY2FzZXMuDQo+Pj4+Pj4+Pg0KPj4+Pj4+Pj4gQWx0aG91Z2gg
I0NQIGJlbG9uZ3MgY29udHJpYnV0b3J5IGV4Y2VwdGlvbiBjbGFzcywgYnV0IHRoZSANCj4+Pj4+
Pj4+IGFjdHVhbCBlZmZlY3QgaXMgY29uZGl0aW9uYWwgb24gQ0VUIGJlaW5nIGV4cG9zZWQgdG8g
Z3Vlc3QuIElmIA0KPj4+Pj4+Pj4gQ0VUIGlzIG5vdCBhdmFpbGFibGUgdG8gZ3Vlc3QsICNDUCBm
YWxscyBiYWNrIHRvIA0KPj4+Pj4+Pj4gbm9uLWNvbnRyaWJ1dG9yeSBhbmQgZG9lc24ndCBoYXZl
IGFuIGVycm9yIGNvZGUuDQo+Pj4+Pj4+IFRoaXMgc291bmRzIHdlaXJkLiBpcyB0aGlzIHRoZSBo
YXJkd2FyZSBiZWhhdmlvcj8gSWYgeWVzLCBjb3VsZCANCj4+Pj4+Pj4geW91IHBvaW50IHVzIHRv
IHdoZXJlIHRoaXMgYmVoYXZpb3IgaXMgZG9jdW1lbnRlZD8NCj4+Pj4+PiBJdCdzIG5vdCBTRE0g
ZG9jdW1lbnRlZCBiZWhhdmlvci4NCj4+Pj4+IFRoZSAjQ1AgYmVoYXZpb3IgbmVlZHMgdG8gYmUg
ZG9jdW1lbnRlZC4gIFBsZWFzZSBwZXN0ZXIgd2hvZXZlciANCj4+Pj4+IHlvdSBuZWVkIHRvIGlu
IG9yZGVyIHRvIG1ha2UgdGhhdCBoYXBwZW4uDQo+Pj4+IERvIHlvdSBtZWFuIGRvY3VtZW50YXRp
b24gZm9yICNDUCBhcyBhbiBnZW5lcmljIGV4Y2VwdGlvbiBvciB0aGUgDQo+Pj4+IGJlaGF2aW9y
IGluIEtWTSBhcyB0aGlzIHBhdGNoIHNob3dzPw0KPj4+IEFzIEkgcG9pbnRlZCBvdXQgdHdvICp5
ZWFycyogYWdvLCB0aGlzIGVudHJ5IGluIHRoZSBTRE0NCj4+Pg0KPj4+ICAgICDigJQgVGhlIGZp
ZWxkJ3MgZGVsaXZlci1lcnJvci1jb2RlIGJpdCAoYml0IDExKSBpcyAxIGlmIGVhY2ggb2YgdGhl
IGZvbGxvd2luZw0KPj4+ICAgICAgIGhvbGRzOiAoMSkgdGhlIGludGVycnVwdGlvbiB0eXBlIGlz
IGhhcmR3YXJlIGV4Y2VwdGlvbjsgKDIpIGJpdCAwDQo+Pj4gICAgICAgKGNvcnJlc3BvbmRpbmcg
dG8gQ1IwLlBFKSBpcyBzZXQgaW4gdGhlIENSMCBmaWVsZCBpbiB0aGUgZ3Vlc3Qtc3RhdGUgYXJl
YTsNCj4+PiAgICAgICAoMykgSUEzMl9WTVhfQkFTSUNbNTZdIGlzIHJlYWQgYXMgMCAoc2VlIEFw
cGVuZGl4IEEuMSk7IGFuZCAoNCkgdGhlIHZlY3Rvcg0KPj4+ICAgICAgIGluZGljYXRlcyBvbmUg
b2YgdGhlIGZvbGxvd2luZyBleGNlcHRpb25zOiAjREYgKHZlY3RvciA4KSwgI1RTICgxMCksDQo+
Pj4gICAgICAgI05QICgxMSksICNTUyAoMTIpLCAjR1AgKDEzKSwgI1BGICgxNCksIG9yICNBQyAo
MTcpLg0KPj4+DQo+Pj4gbmVlZHMgdG8gcmVhZCBzb21ldGhpbmcgbGlrZQ0KPj4+DQo+Pj4gICAg
IOKAlCBUaGUgZmllbGQncyBkZWxpdmVyLWVycm9yLWNvZGUgYml0IChiaXQgMTEpIGlzIDEgaWYg
ZWFjaCBvZiB0aGUgZm9sbG93aW5nDQo+Pj4gICAgICAgaG9sZHM6ICgxKSB0aGUgaW50ZXJydXB0
aW9uIHR5cGUgaXMgaGFyZHdhcmUgZXhjZXB0aW9uOyAoMikgYml0IDANCj4+PiAgICAgICAoY29y
cmVzcG9uZGluZyB0byBDUjAuUEUpIGlzIHNldCBpbiB0aGUgQ1IwIGZpZWxkIGluIHRoZSBndWVz
dC1zdGF0ZSBhcmVhOw0KPj4+ICAgICAgICgzKSBJQTMyX1ZNWF9CQVNJQ1s1Nl0gaXMgcmVhZCBh
cyAwIChzZWUgQXBwZW5kaXggQS4xKTsgYW5kICg0KSB0aGUgdmVjdG9yDQo+Pj4gICAgICAgaW5k
aWNhdGVzIG9uZSBvZiB0aGUgZm9sbG93aW5nIGV4Y2VwdGlvbnM6ICNERiAodmVjdG9yIDgpLCAj
VFMgKDEwKSwNCj4+PiAgICAgICAjTlAgKDExKSwgI1NTICgxMiksICNHUCAoMTMpLCAjUEYgKDE0
KSwgI0FDICgxNyksIG9yICNDUCANCj4+PiAoMjEpWzFdDQo+Pj4NCj4+PiAgICAgICBbMV0gI0NQ
IGhhcyBhbiBlcnJvciBjb2RlIGlmIGFuZCBvbmx5IGlmIElBMzJfVk1YX0NSNF9GSVhFRDEgZW51
bWVyYXRlcw0KPj4+ICAgICAgICAgICBzdXBwb3J0IGZvciB0aGUgMS1zZXR0aW5nIG9mIENSNC5D
RVQuDQo+PiBIaSwgU2VhbiwNCj4+DQo+PiBJIHNlbnQgYWJvdmUgY2hhbmdlIHJlcXVlc3QgdG8g
R2lsKGFkZGVkIGluIGNjKSwgYnV0IGhlIHNoYXJlZCANCj4+IGRpZmZlcmVudCBvcGluaW9uIG9u
IHRoaXMgaXNzdWU6DQo+Pg0KPj4NCj4+ICJJdCBpcyB0aGUgY2FzZSB0aGF0IGFsbCBDRVQtY2Fw
YWJsZSBwYXJ0cyBlbnVtZXJhdGUgSUEzMl9WTVhfQkFTSUNbNTZdIGFzIDEuDQo+Pg0KPj4gIMKg
SG93ZXZlciwgdGhlcmUgd2VyZSBlYXJsaWVyIHBhcnRzIHdpdGhvdXQgQ0VUIHRoYXQgZW51bWVy
YXRlZCANCj4+IElBMzJfVk1YX0JBU0lDWzU2XSBhcyAwLg0KPj4NCj4+ICDCoE9uIHRob3NlIHBh
cnRzLCBhbiBhdHRlbXB0IHRvIGluamVjdCBhbiBleGNlcHRpb24gd2l0aCB2ZWN0b3IgMjEgDQo+
PiAoI0NQKSB3aXRoIGFuIGVycm9yIGNvZGUgd291bGQgZmFpbC4NCj4+DQo+PiAoSW5qZWN0aW9u
IG9mIGV4Y2VwdGlvbiAyMSB3aXRoIG5vIGVycm9yIGNvZGUgd291bGQgYmUgYWxsb3dlZC4pDQo+
Pg0KPj4gIMKgSXQgbWF5IG1ha2UgdGhpbmdzIGNsZWFyZXIgaWYgd2UgZG9jdW1lbnQgdGhlIHN0
YXRlbWVudCBhYm92ZSAoYWxsIA0KPj4gQ0VULWNhcGFibGUgcGFydHMgZW51bWVyYXRlIElBMzJf
Vk1YX0JBU0lDWzU2XSBhcyAxKS4NCj4+DQo+PiBJIHdpbGwgc2VlIGlmIHdlIGNhbiB1cGRhdGUg
ZnV0dXJlIHJldmlzaW9ucyBvZiB0aGUgU0RNIHRvIGNsYXJpZnkgdGhpcy4iDQo+Pg0KPj4NCj4+
IFRoZW4gaWYgdGhpcyBpcyB0aGUgY2FzZSzCoCBrdm0gbmVlZHMgdG8gY2hlY2sgSUEzMl9WTVhf
QkFTSUNbNTZdIA0KPj4gYmVmb3JlIGluamVjdCBleGNlcHRpb24gdG8gbmVzdGVkIFZNLg0KPiBB
bmQgS1ZNIGNhbiBoaWRlIENFVCBmcm9tIGd1ZXN0cyBpZiBJQTMyX1ZNWF9CQVNJQ1s1Nl0gaXMg
MC4NCg0KWWVzLCB0aGlzIHNjcmF0Y2ggcGF0Y2ggZGlkbid0IGNvdmVyIGNyb3NzLWNoZWNrIHdp
dGggQ0VUIGVuYWJsaW5nLCB0aGFua3MhDQoNCj4NCj4+IEFuZCB0aGlzIHBhdGNoIGNvdWxkIGJl
IHJlbW92ZWQsIGluc3RlYWQgbmVlZCBhbm90aGVyIHBhdGNoIGxpa2UgYmVsb3c6DQo+Pg0KPj4g
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5oDQo+PiBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5oDQo+PiBpbmRleCBhZDM1MzU1ZWU0M2UuLjZiMzNh
YWNjODU4NyAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5o
DQo+PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tc3ItaW5kZXguaA0KPj4gQEAgLTEwNzYs
NiArMTA3Niw3IEBADQo+PiAgwqAjZGVmaW5lIFZNWF9CQVNJQ19NRU1fVFlQRV9NQVNLwqDCoMKg
IDB4MDAzYzAwMDAwMDAwMDAwMExMVQ0KPj4gIMKgI2RlZmluZSBWTVhfQkFTSUNfTUVNX1RZUEVf
V0LCoMKgwqAgNkxMVQ0KPj4gIMKgI2RlZmluZSBWTVhfQkFTSUNfSU5PVVTCoMKgwqAgwqDCoMKg
IDB4MDA0MDAwMDAwMDAwMDAwMExMVQ0KPj4gKyNkZWZpbmUgVk1YX0JBU0lDX0NIRUNLX0VSUkNP
REXCoMKgwqAgMHgwMTQwMDAwMDAwMDAwMDAwTExVDQo+Pg0KPj4gIMKgLyogUmVzY3RybCBNU1Jz
OiAqLw0KPj4gIMKgLyogLSBJbnRlbDogKi8NCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0v
dm14L2NhcGFiaWxpdGllcy5oIA0KPj4gYi9hcmNoL3g4Ni9rdm0vdm14L2NhcGFiaWxpdGllcy5o
IGluZGV4IDg1Y2ZmZWFlN2YxMC4uNGIxZWQ0ZGMwM2JjIA0KPj4gMTAwNjQ0DQo+PiAtLS0gYS9h
cmNoL3g4Ni9rdm0vdm14L2NhcGFiaWxpdGllcy5oDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vdm14
L2NhcGFiaWxpdGllcy5oDQo+PiBAQCAtNzksNiArNzksMTEgQEAgc3RhdGljIGlubGluZSBib29s
IGNwdV9oYXNfdm14X2Jhc2ljX2lub3V0KHZvaWQpDQo+PiAgwqDCoMKgwqAgcmV0dXJuwqDCoMKg
ICgoKHU2NCl2bWNzX2NvbmZpZy5iYXNpY19jYXAgPDwgMzIpICYgDQo+PiBWTVhfQkFTSUNfSU5P
VVQpOw0KPj4gIMKgfQ0KPj4NCj4+ICtzdGF0aWMgaW5saW5lIGJvb2wgY3B1X2hhc192bXhfYmFz
aWNfY2hlY2tfZXJyY29kZSh2b2lkKQ0KPj4gK3sNCj4+ICvCoMKgwqAgcmV0dXJuwqDCoMKgICgo
KHU2NCl2bWNzX2NvbmZpZy5iYXNpY19jYXAgPDwgMzIpICYNCj4+IFZNWF9CQVNJQ19DSEVDS19F
UlJDT0RFKTsNCj4+ICt9DQo+PiArDQo+PiAgwqBzdGF0aWMgaW5saW5lIGJvb2wgY3B1X2hhc192
aXJ0dWFsX25taXModm9pZCkNCj4+ICDCoHsNCj4+ICDCoMKgwqDCoCByZXR1cm4gdm1jc19jb25m
aWcucGluX2Jhc2VkX2V4ZWNfY3RybCAmIFBJTl9CQVNFRF9WSVJUVUFMX05NSVMgDQo+PiAmJiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC9uZXN0ZWQuYyBiL2FyY2gveDg2L2t2bS92bXgv
bmVzdGVkLmMgDQo+PiBpbmRleCA3ODUyNGRhYTJjYjIuLjkyYWE0ZmMzZDIzMyAxMDA2NDQNCj4+
IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS92
bXgvbmVzdGVkLmMNCj4+IEBAIC0xMjI3LDkgKzEyMjcsOSBAQCBzdGF0aWMgaW50IHZteF9yZXN0
b3JlX3ZteF9iYXNpYyhzdHJ1Y3QgDQo+PiB2Y3B1X3ZteCAqdm14LA0KPj4gdTY0IGRhdGEpDQo+
PiAgwqB7DQo+PiAgwqDCoMKgwqAgY29uc3QgdTY0IGZlYXR1cmVfYW5kX3Jlc2VydmVkID0NCj4+
ICDCoMKgwqDCoCDCoMKgwqAgLyogZmVhdHVyZSAoZXhjZXB0IGJpdCA0ODsgc2VlIGJlbG93KSAq
Lw0KPj4gLcKgwqDCoCDCoMKgwqAgQklUX1VMTCg0OSkgfCBCSVRfVUxMKDU0KSB8IEJJVF9VTEwo
NTUpIHwNCj4+ICvCoMKgwqAgwqDCoMKgIEJJVF9VTEwoNDkpIHwgQklUX1VMTCg1NCkgfCBCSVRf
VUxMKDU1KSB8IEJJVF9VTEwoNTYpIHwNCj4+ICDCoMKgwqDCoCDCoMKgwqAgLyogcmVzZXJ2ZWQg
Ki8NCj4+IC3CoMKgwqAgwqDCoMKgIEJJVF9VTEwoMzEpIHwgR0VOTUFTS19VTEwoNDcsIDQ1KSB8
IEdFTk1BU0tfVUxMKDYzLCA1Nik7DQo+PiArwqDCoMKgIMKgwqDCoCBCSVRfVUxMKDMxKSB8IEdF
Tk1BU0tfVUxMKDQ3LCA0NSkgfCBHRU5NQVNLX1VMTCg2MywgNTcpOw0KPj4gIMKgwqDCoMKgIHU2
NCB2bXhfYmFzaWMgPSB2bWNzX2NvbmZpZy5uZXN0ZWQuYmFzaWM7DQo+Pg0KPj4gIMKgwqDCoMKg
IGlmICghaXNfYml0d2lzZV9zdWJzZXQodm14X2Jhc2ljLCBkYXRhLCBmZWF0dXJlX2FuZF9yZXNl
cnZlZCkpIA0KPj4gQEAgLTI4NzMsNyArMjg3Myw4IEBAIHN0YXRpYyBpbnQgDQo+PiBuZXN0ZWRf
Y2hlY2tfdm1fZW50cnlfY29udHJvbHMoc3RydWN0DQo+PiBrdm1fdmNwdSAqdmNwdSwNCj4+ICDC
oMKgwqDCoCDCoMKgwqAgc2hvdWxkX2hhdmVfZXJyb3JfY29kZSA9DQo+PiAgwqDCoMKgwqAgwqDC
oMKgIMKgwqDCoCBpbnRyX3R5cGUgPT0gSU5UUl9UWVBFX0hBUkRfRVhDRVBUSU9OICYmIHByb3Rf
bW9kZSAmJg0KPj4gIMKgwqDCoMKgIMKgwqDCoCDCoMKgwqAgeDg2X2V4Y2VwdGlvbl9oYXNfZXJy
b3JfY29kZSh2ZWN0b3IpOw0KPj4gLcKgwqDCoCDCoMKgwqAgaWYgKENDKGhhc19lcnJvcl9jb2Rl
ICE9IHNob3VsZF9oYXZlX2Vycm9yX2NvZGUpKQ0KPj4gK8KgwqDCoCDCoMKgwqAgaWYgKCFjcHVf
aGFzX3ZteF9iYXNpY19jaGVja19lcnJjb2RlKCkgJiYNCj4gV2UgY2FuIHNraXAgY29tcHV0aW5n
IHNob3VsZF9oYXZlX2Vycm9yX2NvZGUuIGFuZCB3ZSBzaG91bGQgY2hlY2sgaWYgDQo+IElBMzJf
Vk1YX0JBU0lDWzU2XSBpcyBzZXQgZm9yIHRoaXMgdkNQVSAoaS5lLiBpbiANCj4gdm14LT5uZXN0
ZWQubXNycy5iYXNpYykgcmF0aGVyIHRoYW4gaG9zdC9rdm0gY2FwYWJpbGl0eS4NCg0KT29wcywg
SSBjb25mdXNlZCBteXNlbGYsIHllcywgbmVlZCB0byByZXNoYXBlIHRoZSBjb2RlIGEgYml0IGFu
ZCB1c2UgbXNycy5iYXNpYw0KDQp0byBjaGVjayB0aGUgYml0IHN0YXR1cywgdGhhbmtzIQ0KDQo+
DQo+PiArwqDCoMKgIMKgwqDCoCDCoMKgwqAgQ0MoaGFzX2Vycm9yX2NvZGUgIT0gc2hvdWxkX2hh
dmVfZXJyb3JfY29kZSkpDQo+PiAgwqDCoMKgwqAgwqDCoMKgIMKgwqDCoCByZXR1cm4gLUVJTlZB
TDsNCj4+DQo+PiAgwqDCoMKgwqAgwqDCoMKgIC8qIFZNLWVudHJ5IGV4Y2VwdGlvbiBlcnJvciBj
b2RlICovIEBAIC02OTg2LDYgKzY5ODcsOCBAQCANCj4+IHN0YXRpYyB2b2lkIG5lc3RlZF92bXhf
c2V0dXBfYmFzaWMoc3RydWN0IG5lc3RlZF92bXhfbXNycyAqbXNycykNCj4+DQo+PiAgwqDCoMKg
wqAgaWYgKGNwdV9oYXNfdm14X2Jhc2ljX2lub3V0KCkpDQo+PiAgwqDCoMKgwqAgwqDCoMKgIG1z
cnMtPmJhc2ljIHw9IFZNWF9CQVNJQ19JTk9VVDsNCj4+ICvCoMKgwqAgaWYgKGNwdV9oYXNfdm14
X2Jhc2ljX2NoZWNrX2VycmNvZGUoKSkNCj4+ICvCoMKgwqAgwqDCoMKgIG1zcnMtPmJhc2ljIHw9
IFZNWF9CQVNJQ19DSEVDS19FUlJDT0RFOw0KPj4gIMKgfQ0KPj4NCj4+ICDCoHN0YXRpYyB2b2lk
IG5lc3RlZF92bXhfc2V0dXBfY3JfZml4ZWQoc3RydWN0IG5lc3RlZF92bXhfbXNycyAqbXNycykg
DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92
bXgvdm14LmMgaW5kZXggDQo+PiBkNzBmMmU5NGIxODcuLjk1YzBlYWI3ODA1YyAxMDA2NDQNCj4+
IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgv
dm14LmMNCj4+IEBAIC0yNzQ4LDcgKzI3NDgsNyBAQCBzdGF0aWMgaW50IHNldHVwX3ZtY3NfY29u
ZmlnKHN0cnVjdCB2bWNzX2NvbmZpZyANCj4+ICp2bWNzX2NvbmYsDQo+PiAgwqDCoMKgwqAgcmRt
c3JsKE1TUl9JQTMyX1ZNWF9NSVNDLCBtaXNjX21zcik7DQo+Pg0KPj4gIMKgwqDCoMKgIHZtY3Nf
Y29uZi0+c2l6ZSA9IHZteF9tc3JfaGlnaCAmIDB4MWZmZjsNCj4+IC3CoMKgwqAgdm1jc19jb25m
LT5iYXNpY19jYXAgPSB2bXhfbXNyX2hpZ2ggJiB+MHgxZmZmOw0KPj4gK8KgwqDCoCB2bWNzX2Nv
bmYtPmJhc2ljX2NhcCA9IHZteF9tc3JfaGlnaCAmIH4weDdmZmY7DQo+Pg0KPj4gIMKgwqDCoMKg
IHZtY3NfY29uZi0+cmV2aXNpb25faWQgPSB2bXhfbXNyX2xvdzsNCj4+DQo+Pg0K
