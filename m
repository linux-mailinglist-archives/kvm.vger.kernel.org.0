Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1153F6A7CF2
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 09:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCBIkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 03:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCBIkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 03:40:04 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4892C659;
        Thu,  2 Mar 2023 00:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677746397; x=1709282397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VF9kQ6Rl7ZSBe7EtjCveTf5V9Li+PoJ4sfjarwwcz10=;
  b=VwECNqPW3Ldn5fR90Bw6vSvCHhwJqqpSSY2OCdIlwVDS5fxmJcovHH+T
   4t4WnmjPNPEzF4h2IWrzBNZWbLDIITlGK4Y68MenRWbGwPo0Cr7QbnySk
   btQHOGjgB5yJEXWrwmu++xDekSG/llNV63Fk6095kub+UD4QKjWVlqAEw
   CtAIlDQx7k62OawJsEgjCUAlGuZ3hJVKA2e2KBeK8zueyrMYe/mFa7ySH
   YXDFpsvbNo9xjRYws0Nqb2AXNoGdbXXRlHIIana8xEumci1XP3umOA7k3
   HQeV83Q0xUPFfzp4aNgncmN3I4RaHpQlETWWZU3H1ANe/1FXBciOiklHI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="399448084"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="399448084"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 00:39:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="674870767"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="674870767"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2023 00:39:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 00:39:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 00:39:41 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 2 Mar 2023 00:39:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuNAJEcpTARHP2qDTn/zWRz2nFi/t3aWHClIjjLdbJ256WdPnFMTgnghxfqDlV9jFgkFNgzJs9fAGB6s6vIqhwj0uUVrh9/CoKsK6z9UqhyJRj719mLW6uyxnh4dg5QduQCgEzUo+05fl7NvHVSSezIJaKDQaoiWZ0HhM4OblmIEMUAZ3wA46pk7bzJ6bcUPF5lQP7QWCJt0a8+Ds1edNLCN1OREenbchbTdf8X8csuKiruElvXAB57lQMzM5sxmEDbPUIN6oYZKkC77S6u7jg1T3DY+TV5D7/uv6XubyFsJfoESRSr+52Q+sYdjHpfC4mcNU3r++jvu2DGE8DAzTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VF9kQ6Rl7ZSBe7EtjCveTf5V9Li+PoJ4sfjarwwcz10=;
 b=TmCOt8K4Nm4vx9nwqnsNgTILhpQdwigmNb24ggS8S15anXyEkjF0/qDtmN6PR914usNaepHKX+aGmcg3IPAKCvIpzUUTjdz1YjSMJNncFNfYmbkLmb8bKUWoXLaPLB6qGEauMJGHzHjlNQMZHmTcjcswaqfET6hnQFoDxqaXjusvTFcG7aiGZaoIiPWEhBaJHpmMaFKjeCXHOaSZMY5fG9NW4ycsu0BS6oG3/nhE06GNKHr6eM+FgiG838Ao1Mn+7hdtaWNmkQNvcFyf2CnoE9QHM1zOQq4oNJxypDdzOSmMFRRaJWYbG/4KwTV6rEdLlDqcajM+C6ASk1GaaNYPKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5705.namprd11.prod.outlook.com (2603:10b6:610:ec::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 08:39:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6134.029; Thu, 2 Mar 2023
 08:39:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
Thread-Topic: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
Thread-Index: AQHZTCxXkF4K+ZZqtEaRiCI/5s8D/a7m+acAgAAzBoA=
Date:   Thu, 2 Mar 2023 08:39:36 +0000
Message-ID: <3aec157afb6727e603d80c2232b3718033295f13.camel@intel.com>
References: <20230301105438.599196-1-kai.huang@intel.com>
         <ZAA1+EMTIkBJvdZF@gao-cwp>
In-Reply-To: <ZAA1+EMTIkBJvdZF@gao-cwp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5705:EE_
x-ms-office365-filtering-correlation-id: 1c3096a4-3840-4596-ebbc-08db1af9a787
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: db2w7F3J6ddaI4DkNHTQN5rFyjg90UcZqtsntx7uIokym6MrQflCruN5/PF1BAo+a8flRtN0M8ECfUeAGVtpPfIvpv6pTSNDBHF4gq/F1uAyjehvyboWsAVJr6IlmZl7+WLwL0Qu3CnMkY7Mk36sLOUVZKVpIG6n2Vw3nIxZl+/A/6yIsT4bFQRPo7h2L6xfUVviSPmA214fphBlVF0uINcNiKaXgb+28KWoqSxPljDwshaQBOMtW6zbiovngq1k3V+W6ontGOtRSi5+QKcNiACdF1UXxaGF8C9aOxB0ps6pfx/Vrn4UTVFvlKHcYTqVQfzdI2aOjnUDfpMG9hW7ywzNco4stu2m42YHMI5IZ9RVjIX4YvcoUJvWPTuDHSpHCNPy4fwIuWCMDKaOEZJNG0Zpe0t6FA2Vgm61yGHJ8adlnv9B16nTFN5GYt7he7H48WptBzEBBa7EZcFgivvRHBL0ldLbJ5B6ZW9VKJ+VSbP13C/PoGQiO9hX4FQpebk4vsF4ChiOGYKhVpzb5t1QuST48CvLvuYnuF8brwBybvyJ8pfm7BFr03BC4ftsZ6enY+wQtGrKSDaX+usS/zol9nfFygsGMNWr9ZKGDSURby70m/GGMIZpSOAKOurNWNGCQKGSCAXyYtwAJn3PXC19ic5tdr8WrXuhMFvH4Z6TZQSqCW3UaTkmzsjcRHAStLU8kyF5f8M4gF9+oyLbd+IxEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199018)(83380400001)(36756003)(122000001)(38100700002)(6862004)(8936002)(5660300002)(71200400001)(82960400001)(478600001)(86362001)(38070700005)(2616005)(186003)(26005)(6512007)(6506007)(6486002)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(2906002)(8676002)(316002)(37006003)(91956017)(4326008)(41300700001)(54906003)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MG5GNUprZVBnazI2R05tNDA4d2ZZc1lsUDFseFo4WUdkelpDVldTbHE5OXBS?=
 =?utf-8?B?Z21iSThmUE8xdExWTlY1SWx4NXZFeVlyY0pMUHpDMEZ0RTRuUmgxZ1k0amIz?=
 =?utf-8?B?d2RWamNjRDRleFgvdHJKU3h2cm82NldoM2FJRHM0VnFINHdPcjJIdTEzZFJC?=
 =?utf-8?B?NkgvT21lVE9LYS94T2U3NGVmenV6YTk4bE92ZlRDQlN2eWJzTXZKY3pzVDlw?=
 =?utf-8?B?clJOMmd1Umk1a3plMTlNUStuZVhRZHU5dEdNVUUrWDhSOUhOeGtnbUpsdkdV?=
 =?utf-8?B?Qjc3U1h5cWlRYU5JWUtPTFJodFVoOHF2cVl4Z3Y0OSs3bzQ0L0thVW42SDR0?=
 =?utf-8?B?VXpmZ1g1S0hpTWVEWXBmd0hrSmJTUFF0TndEZFhTMVJqdy9UTTR4d1ZmUjBy?=
 =?utf-8?B?UmMxSk1nTjFsU3BkTXc4cmR4K0I0eW1HQ0dhVjl5VGJmdnZGVys3RHRuamdQ?=
 =?utf-8?B?WHlnODNJcnFrc1Z1UERNVGRDQ2N1MnpUc0VnNWFHMTlIRHd5empPUEY2WG9h?=
 =?utf-8?B?eHptN1lQSXV6ZUdmNFlDandyckJXSDFnWUZzVmdhWUJmSWJOdXJDbG5FQVk2?=
 =?utf-8?B?Qzl2UjUwb0dPL2pxanFDR0J5eEs1SlJJY1FGdHZ4Nm5VSHlYaHEwWXJqU0hS?=
 =?utf-8?B?NEVaOTR2ajFYb1FXb3NVdVpoRlNYVS9EbmhtMVI1dTZwU2p0NnQ0UXQvR0ZC?=
 =?utf-8?B?UDBxbURZNWFObnNvUXBCeXFmNzk2YzgzRmVmUVBMd1Fwc2ZqZzdkVEZwUDMx?=
 =?utf-8?B?M29HZHV4MDFlV255djF6L21DR2k5NGN0b1VtT05mdjZiZ25pWjFjakJqeS81?=
 =?utf-8?B?aFdDejRTcDJIV21xV0xpOXNObmhOclNZOGF3U25KcXlzYVZYNExDZVg3eW9a?=
 =?utf-8?B?QlRXR2o0cU15RXRJaHVtU0VQTCtFZ3RkNVVNSjZNTzlnZjhZOS9kMksrc0t6?=
 =?utf-8?B?SjRTckV4V09Va1NhTThLSUJld1BRdnR6SllWNEFRTkdXVVJ4SkxCZjA4U0E1?=
 =?utf-8?B?eVJVVWxIeFVoSk9paVhnZGFkVHI1cmd4WWlhUG0wTm83bFYxWWxXc1Z2N2NL?=
 =?utf-8?B?Q3ltQS96MTVVRlJVYWdNeWYrK3NkMkJYR1Y0OElrelV3Y00rdncxWTBQbnV4?=
 =?utf-8?B?b1EyQ0VuOXN4NEVUVWJnU2FhN3BvSVk4V1VzZ1pmZDUxRGhWallGUm5lckZ3?=
 =?utf-8?B?UXA3OURjeEwyOUtFT01PVzV4U2pGK09lODhQWUdoVk9LMzh0aEFOZlVpRTcw?=
 =?utf-8?B?WEZhOWtIbHU4N3k3NjB4cXlOMEh5eExNMjRQYXZTM3pBbDQ5RTBrTllHZU5O?=
 =?utf-8?B?VWIwUXIyMnhRRHh6RzUzNlQwOUczS0dTNDgzN2l1MjJtS0lKYlBIWlVzbjJM?=
 =?utf-8?B?MFJTMm00N1dya3VRbnZSVURZc0doYUZ1SGl0dmU2M0EzWG9NUUcweE5XYlQ0?=
 =?utf-8?B?T3RjQzBrMVZuQ2psSlJqajljb0hlYTRMaU5oeTdyWmdHMk9tK0JHOS91dTZO?=
 =?utf-8?B?cytZZkFTZ2FZRXhTTzRCRk10RU5aNHRKMmtaNXVYcjZwVHpldFpxcm5ZSkhC?=
 =?utf-8?B?N3g0NklRVTJKNzVKT08vSWFLcXlwYXkrcDQ2Y3ZoazE4TmFkSnMrUzZNcHpK?=
 =?utf-8?B?dVdIemNpc1EwcS9iUXFFNUkxTXFSdTVrQ2JBOU5adjhvcVVReThZR2JEZmxB?=
 =?utf-8?B?Q3JmUThSMENwZXNBRmpzWisxRnlvcndZZmwrRUxDVEMxZHU0ZzZzZHN5M3Ft?=
 =?utf-8?B?ZzYyZkFCa3ZTLzg0T29zZ1NVb25nUnE0U24vK3hjZG9OYUFTVHVtVEFxV2I1?=
 =?utf-8?B?eEhyUnZzdktTWmNWR1k4VjFNRGpMZFpPdlRrLzNhZm4wV1d1Z1RLRHhUWmda?=
 =?utf-8?B?Yk9rYW1tcFkrTk5xYnZDSDNPa01tOUF6Y1NnUFh6VGV0TG55RHo5RU9ySnNj?=
 =?utf-8?B?aG43WFFWdTc5SU12b1pvK2p1VmJqWmFzd0JPUFhXZ2JqOWprOFhnazVIRFR5?=
 =?utf-8?B?c3F0eVhOUnN2Umw4RHdhUDhDSjRnemxCV25XMFdqZVhNSTRkOUtWdUVqZjA3?=
 =?utf-8?B?dUM2YUxway9MeWdWUzRCV3J1UFU0UGcwZ3V1d1hud3B4YnUxeU0xVUJraDNn?=
 =?utf-8?B?cEtkOTY1dHVSd2NIL3BMenIrRWRyMFk4OGpQc1Zha0dGU0ptMkdDQ2lSWXFn?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C4CAAC40C1EDE4695E11E791B274169@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3096a4-3840-4596-ebbc-08db1af9a787
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 08:39:36.2626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IxXPprejgFWide37zjKXK6LI4EcZSEqm4hE3FR2z8DPWeSh4juDv7rSM6oMA0Zd1rLREn1joirBKo9bmuNkqfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5705
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTAyIGF0IDEzOjM2ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IE9u
IFdlZCwgTWFyIDAxLCAyMDIzIGF0IDExOjU0OjM4UE0gKzEzMDAsIEthaSBIdWFuZyB3cm90ZToN
Cj4gPiBNYWtlIHNldHVwX3ZtY3NfY29uZmlnKCkgcHJlZW1wdGlvbiBkaXNhYmxlZCBzbyBpdCBh
bHdheXMgcGVyZm9ybXMgb24NCj4gPiB0aGUgc2FtZSBsb2NhbCBjcHUuDQo+ID4gDQo+ID4gRHVy
aW5nIG1vZHVsZSBsb2FkaW5nIHRpbWUsIEtWTSBpbnRlbmRzIHRvIGNhbGwgc2V0dXBfdm1jc19j
b25maWcoKSB0bw0KPiA+IHNldCB1cCB0aGUgZ2xvYmFsIFZNQ1MgY29uZmlndXJhdGlvbnMgb24g
X29uZV8gY3B1IGluIGhhcmR3YXJlX3NldHVwKCksDQo+ID4gYW5kIHRoZW4gY2FsbHMgc2V0dXBf
dm1jc19jb25maWcoKSBvbiBhbGwgb3RoZXIgb25saW5lIGNwdXMgdmlhIHNlbmRpbmcNCj4gDQo+
ICphbGwgb3RoZXIqIGlzIG1pc2xlYWRpbmcuIFRoZSBjb21wYXRpYmlsaXR5IGNoZWNrIGlzIGFj
dHVhbGx5IGRvbmUgb24NCj4gKmFsbCogb25saW5lIGNwdXMuDQo+IA0KPiAgICAgICAgIGZvcl9l
YWNoX29ubGluZV9jcHUoY3B1KSB7DQo+ICAgICAgICAgICAgICAgICBzbXBfY2FsbF9mdW5jdGlv
bl9zaW5nbGUoY3B1LCBrdm1feDg2X2NoZWNrX2NwdV9jb21wYXQsICZyLCAxKTsNCj4gICAgICAg
ICAgICAgICAgIGlmIChyIDwgMCkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXRf
dW53aW5kX29wczsNCj4gICAgICAgICB9DQo+IA0KPiBHaXZlbiB0aGlzLCBpdCBwcm9iYWJseSBp
cyBvayB0byBub3QgZGlzYWJsZSBwcmVlbXB0aW9uIGJlY2F1c2UgYWxsIENQVXMNCj4gYXJlIGd1
YXJhbnRlZWQgdG8gYmUgY29tcGF0aWJsZSBsYXRlciBpbiB0aGUgZmxvdyBpbiB0ZXJtcyBvZiBW
TUNTDQo+IGNhcGFiaWxpdGllcy4gQnV0IHdlIGRvbid0IHdhbnQgdG8gaGF2ZSBzdWNoIGEgc3Vi
dGxlIGRlcGVuZGVuY3kuDQo+IA0KPiBEbyB5b3Ugc2VlIGFueSByZWFsIHByb2JsZW0gd2l0aCBw
cmVlbXB0aW9uIGVuYWJsZWQ/DQoNCk5vLiAgSnVzdCB0aG91Z2h0IGl0IGlzIHRoZSByaWdodCB0
aGluZyB0byBkby4NCg0KPiANCj4gPiBJUEkgdG8gcGVyZm9ybSBWTVggY29tcGF0aWJpbGl0eSBj
aGVjay4gIEZ1cnRoZXIgbW9yZSwgS1ZNIGhhcyBDUFUNCj4gPiBob3RwbHVnIGNhbGxiYWNrIHRv
IGNhbGwgc2V0dXBfdm1jc19jb25maWcoKSB0byBkbyBjb21wYXRpYmlsaXR5IGNoZWNrDQo+ID4g
b24gdGhlICJuZXctb25saW5lIiBjcHUgdG8gbWFrZSBzdXJlIGl0IGlzIGNvbXBhdGlibGUgdG9v
Lg0KPiA+IA0KPiA+IHNldHVwX3ZtY3NfY29uZmlnKCkgaXMgc3VwcG9zZWQgdG8gYmUgZG9uZSBv
biB0aGUgc2FtZSBjcHUuICBUaGlzIGlzDQo+ID4gdHJ1ZSBpbiB0aGUgY29tcGF0aWJpbGl0eSBj
aGVjayBjb2RlIHBhdGggYXMgc2V0dXBfdm1jc19jb25maWcoKSBpcw0KPiA+IGNhbGxlZCBlaXRo
ZXIgdmlhIElQSSBvciBpbiBwZXItY3B1IENQVSBob3RwbHVnIHRocmVhZC4gIEhvd2V2ZXIsIHRo
ZQ0KPiA+IGZpcnN0IGNhbGwgZnJvbSBoYXJkd2FyZV9zZXR1cCgpIGlzbid0IGFzIGl0IGlzIGNh
bGxlZCB3aGVuIHByZWVtcHRpb24NCj4gPiBpcyBlbmFibGVkLg0KPiA+IA0KPiA+IENoYW5nZSB0
aGUgZXhpc3Rpbmcgc2V0dXBfdm1jc19jb25maWcoKSB0byBfX3NldHVwX3ZtY3NfY29uZmlnKCkg
YW5kDQo+ID4gY2FsbCB0aGUgbGF0dGVyIGRpcmVjdGx5IGluIHRoZSBjb21wYXRpYmlsaXR5IGNo
ZWNrIGNvZGUgcGF0aC4gIENoYW5nZQ0KPiA+IHNldHVwX3ZtY3NfY29uZmlnKCkgdG8gY2FsbCBf
X3NldHVwX3ZtY3NfY29uZmlnKCkgd2l0aCBwcmVlbXB0aW9uDQo+ID4gZGlzYWJsZWQgc28gX19z
ZXR1cF92bWNzX2NvbmZpZygpIGlzIGFsd2F5cyBkb25lIG9uIHRoZSBzYW1lIGNwdS4NCj4gDQo+
IE1heWJlIHlvdSBjYW4gc2ltcGx5IGRpc2FibGUgcHJlZW1wdGlvbiBpbiBoYXJkd2FyZV9zZXR1
cCgpIGFsdGhvdWdoIEkNCj4gZG9uJ3QgaGF2ZSBhIHN0cm9uZyBwcmVmZXJlbmNlLg0KPiANCj4g
bmVzdGVkX3ZteF9zZXR1cF9jdGxzX21zcnMoKSBhbHNvIHJlYWRzIHNvbWUgTVNScyBhbmQgc2V0
cyB1cCBwYXJ0IG9mDQo+IHZtY3NfY29uZiwgc2hvdWxkIGl0IGJlIGNhbGxlZCBvbiB0aGUgc2Ft
ZSBDUFUgYXMgc2V0dXBfdm1jc19jb25maWcoKT8NCg0KWWVzIEkgdGhpbmsgc28uICBJIG1pc3Nl
ZCB0aGlzIDopDQoNCk5vdCBzdXJlIHdoZXRoZXIgdGhlcmUgYXJlIG90aGVyIHNpbWlsYXIgcGxh
Y2VzIHRvbyBldmVuIG91dHNpZGUgb2YNCmhhcmR3YXJlX3NldHVwKCkuDQoNCkJ1dCBjb21wYXRp
YmlsaXR5IGNoZWNrIG9ubHkgY2hlY2tzIHRoaW5ncyBjYWxjdWxhdGVkIHZpYSBzZXR1cF92bWNz
X2NvbmZpZygpDQphbmQgbmVzdGVkX3ZteF9zZXR1cF9jdGxzX21zcnMoKSwgc28gSSB0aGluayBp
dCdzIGZhaXIgdG8gb25seSBwdXQNCmhhcmR3YXJlX3NldHVwKCkgaW5zaWRlIHByZWVtcHRpb24g
ZGlzYWJsZWQuDQo=
