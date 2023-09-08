Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296EC7985E8
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 12:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbjIHKdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 06:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjIHKdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 06:33:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16AF1BC8;
        Fri,  8 Sep 2023 03:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694169216; x=1725705216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ft4T6iDv/1lp7b2mwFG9RYhiX/SglRI7hZcEjbNi52k=;
  b=eKHWgJI1o7Oul9/Wqo4Ij1P2BoqhXy4Z4ATiNenZg22j4pCsRTIOg9SJ
   tC+kjZxIKZ7dukDp1M0Zj1PaJqkuaX4u64kF40GVkyKuCWXBv8BjEyMrH
   KW6t2jD+b2JgVYMw9lRxhar0cqF7vvSDtXNwPr+/Gu+1fUQE0qufQROBl
   0ofYS9xuC3phiju3QH+CBXEdxrQw3rLx2x7LCZT9a6QEq7+BYM76Erx41
   bT5vURiLxHGPKOGz4stfxw8BErtCiv7wuhRhDXUJarJp7aASbHHu8kJmA
   7ekNmfBlEfsZvLPGiGt2VG2E0ldbhYrWr9RK4RVimLnTRdmrNS5k6sFH3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="408605209"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="408605209"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 03:33:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="807983423"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="807983423"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Sep 2023 03:33:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 8 Sep 2023 03:33:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 8 Sep 2023 03:33:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 8 Sep 2023 03:33:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJtH+F1hmHpf1D0hNEzCIXg7Bu20iZyWP4GG8nBnxHbwCyKxVMUY2Kpcn+T88Ds47P9oJ8VudTW69L8RY3iGn4yrhUiyhFpz979M0Yf5FCigcxZCI6UKFwdrSRdxxG6Cvpq1A56RDTgKZyak8InBtdUn7IExU7SRb/0Y29zEYeMKZNGcid0rZreLghQgCaWVuKPNAucoQtmhLyIj1pWagQh2ssNXrX2CiBJUti5hkjRQYZxEgH1Gl4tGYolF/A7+JGBZOoBTqlnhzqM9p9afAMsxu1pxsQMkfRlQOxGDomY2FWXsPqFxd22CPgNvjGJtAKwr16YZQYHgS2dtq6PgRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ft4T6iDv/1lp7b2mwFG9RYhiX/SglRI7hZcEjbNi52k=;
 b=E504dXvssbwVCW5ADzzhfnGkt9K06PL/JseXqwZogt2KXYtLmCYZ//LpuSVKIUlF5iEgHufLZ5KJdZdrHlZbZyY74AbbwIhO7OwgxmjTGstpJCXpU4uPj1jGqwPJirx1cCWbIuYf+9AODNG3WLb4KKHk6WlpJpmuH+HZIATzkwQ2g0Sv9Qtq1SLuVlm3WgIGyNFharUDlcVVRJfaMd7i/+ukkn55X3wNhH4AEWTMmbwVvOpmqJbmhy8POzDZhopAIsxHNsTBpC+ZzrkZZBIEgxsDn07TKV+XDfYpKRlfyqjLVqHMwGBgWvrzIDMUV9mIlVV2qFDzya8ZL9JK5z/EUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5958.namprd11.prod.outlook.com (2603:10b6:510:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Fri, 8 Sep
 2023 10:33:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.029; Fri, 8 Sep 2023
 10:33:31 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 06/22] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Thread-Topic: [PATCH v13 06/22] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Thread-Index: AQHZ101De3tVNeYkQ0yO53WAEnLA0rAPY8gAgAFta4A=
Date:   Fri, 8 Sep 2023 10:33:30 +0000
Message-ID: <4134057a145677de2779612920f3f903654c554f.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
         <7523faad-23f0-2fcb-30e3-b0207d71e63f@suse.com>
In-Reply-To: <7523faad-23f0-2fcb-30e3-b0207d71e63f@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5958:EE_
x-ms-office365-filtering-correlation-id: 33c69baf-1eb1-462b-e270-08dbb0570bb5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tcGnLvach1fJ9jVuJ8PYLtxzJx/spXXlXjLmfTP1OpS4+65Og0O/tXSIwikW3y2sk9fVGJwjxIYZrt1gXDIPdvUdos6YDhScduAy7rJNYKILDCVkFUiqgT73HQhb6A+YfwtXf9sYee0u/fUJlO9awckB+Zm+z4kJQxXShzbOqNIONG2iTq+KTZOLm+aFUtDNFf7xSSo6XOiEdZm3rqSeik/ywke2zEM7dW4Tsfp+/ok8UrXiBj7LxhuBLPIwyfYkXr/Ccuz9+C42iuzWkL6eAGUqj7jj4hRgSb4GweH1Nn5U4qoO+46pH8LX99PBAVxla24AbmW+0HTCwPaThRq+YtJebbktY3PsqxnQpQU+rMyzJynr4gYbz/Lnm02CR6BSxg2zCnj+F3OoYpG5cNhje3lFrBk0MFcVzmWBSkABgEH+jy+cZKiQjItQ/rRCR4OmeBELZB2jgCpElzxgQCcpXwJrrtGy/0CoakiXUS1gAPER5g/V7y5lt3oUW1Gyi1S/ujM9le6AvW8TpofZtcAMgE6MF4LGZJbwTUnPIXBp+eLZeyaE4JuB8APbKjOcjJv6o2ZScSlKc6ngNqY3AGTg914K+0xC00deLs0JteymZ1iIlqrEvsXDWLETdj6rFwyw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199024)(186009)(1800799009)(8936002)(8676002)(4326008)(66476007)(66446008)(66556008)(91956017)(76116006)(110136005)(5660300002)(66946007)(83380400001)(478600001)(7416002)(71200400001)(2906002)(41300700001)(316002)(64756008)(86362001)(54906003)(6506007)(6512007)(6486002)(122000001)(82960400001)(2616005)(38070700005)(38100700002)(26005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzIwZ1BPREl6UHE1b3RoQ3JtVU9PbXhxdzZPZ0wzZjY4bFJOSkJNZEEvOGYw?=
 =?utf-8?B?WmltN2NvVVN4NU9QcHg1a25hcnZaYktCY01vVjcrQU1DalpNM09xWE5tcjhE?=
 =?utf-8?B?QlFMN2RkZTZyNTl0OGdPamFPcmdJb3dWM29laGdTVTRXc2lGNkh2cFZ4bkVJ?=
 =?utf-8?B?RVF0bkx1emhsY3JyTnRMajlVU2VVRWs4QlFPMk5mMkdMbVhjdmlQa3hVNG1H?=
 =?utf-8?B?eDdubnlhMzhhVWhPOEdaUTBMQ2VzMFkzK2RSQklDVkZHenBWOHBQS0s1eUk4?=
 =?utf-8?B?SEVjMGxwdFhwa25qK3pQeUlUQmdnYU5pYWdGVHNwRHhZc0lzNG0rakRqTXNx?=
 =?utf-8?B?NlNJRHpwc3ZQREsvVWpKNW4rNGFoT3hMRTBaTU5kT3RrYzdocm1vMGoyUnpy?=
 =?utf-8?B?WkVRUkRQTmE4ZlhNam1PVGpzNmx3VkwxRWFYbEJIVU1iQlBtbkxCUFlkSGJL?=
 =?utf-8?B?eE5xb0p4OEowWTNraHlhMTZRT2NwdjFtWmx3MEhaSm9yYnFWdjZMUTFDSjdJ?=
 =?utf-8?B?Nmx3U0NXajZMRGpVakFSVWIrcGw2NnVFa0FTOHRmVExRRklpbWNrcUhBckZa?=
 =?utf-8?B?Yk9MN29XelVPdU5LWDI2Qm1TRXUvcW9zbHZORGE5WHN3cmpMVDdZeVJ1OUUw?=
 =?utf-8?B?cDFWcjdPNmJOUDNwMFVlejVraVhzRnZMcmtTTDZZN1RIZEQvaUpVMmFCNEZW?=
 =?utf-8?B?R1hUa28rK1VCTFFZVCs0Rld1NnZaQUV3ZHN2S2t3Z0VVSXdXVlhmTklGd2s5?=
 =?utf-8?B?ZSt4ZThJQ3ZjR045dkcwbDQ3TnZGK3ZQRVpzZm9ueVUxSmZ3YjkzTjVyT2Nu?=
 =?utf-8?B?WUZHdXorN3pNWUN2SkphN1h6bkNsWXNyclZaT2dEQXdSMG92ZnJqektaR2U5?=
 =?utf-8?B?SDE2VmhxeDFhTVN1RkZvdERVUE1EUDh4bXBCS3J6ME5wV0VGTHdMQ3kyODB6?=
 =?utf-8?B?aUM5M0VnU0wzcFowcnZZbld6QW9vbjVNRHJVbmt0eEI5SmVWdjFqYjU4dTFT?=
 =?utf-8?B?bzRmUEFzS0RKd01PUEpUSG1xMkdqSHZoaEpTY1hYN1hJMDdHUHNLbWZ0Wkpm?=
 =?utf-8?B?LzVYNXN6Qm8xbVhTQWNkYTlCNEs3eGpiM1MxcjdiblVqRmhkYmlldGxxVXNZ?=
 =?utf-8?B?YjZoVFJKRzB4Yms0bzgvSHBmM3pxK1h4NjJZcFNIcTdVaE9PREczK3E3MXlx?=
 =?utf-8?B?ZDJYK1hYbkNHM3kxc1daT01zdmltMGszNkZZeWN3aXd5Znh0QzJ5VVFxUTZj?=
 =?utf-8?B?UHpMSkJIaFl4NHdIWkxlMkxtNE1tWnFwVVpIN1BFWnkzNGdHUkZhd3pURTkr?=
 =?utf-8?B?MllRMitMWU5qQ1hVc1ptMGZkRFpXSHFSVzBVMEdsN0FlM0Fybld1WnBtbDRH?=
 =?utf-8?B?dVNCQWV3Zm1hd1VMd1VxMEQ5UFVQaDZKY0MveGxpdmpQZU9qMnBGMlFTRCt0?=
 =?utf-8?B?d2pFY0ZIS1l1YnA4cXNOb3MxaVY2Z3dENVJGTGoraXV6V3Q3c0NBWVVpaVAv?=
 =?utf-8?B?a0pGV3AySzNVZHQ4b3VRaThLZGJ3K2lkSGI0aDNTdzYrMmFXMDh1clpuaFI0?=
 =?utf-8?B?ZVlXK1JDLzFRUm5raGUvYS9aMXF6c1A4SktMcFVxeTVQRE5Wdk9lYmV2Nkgx?=
 =?utf-8?B?MVNrSDlKeG5yeG5MVmxqMy84dFltTk9zdU55MVE5dU15ZnZnTENXa3YwTkg4?=
 =?utf-8?B?Mkp3MVgwak1IMmhpQy9PVkxKMXRQdE9jWUxXVnZlTFN1QU51a2pTbEMwaWhG?=
 =?utf-8?B?QmQ4c056dnFJUVl5NWNUNWNrSStFbU5xMkZiK0pLTncrOS84YnBSNFZEemdy?=
 =?utf-8?B?K2F1dHRyeDc3aFVkeThTbWdlNlRGdk9Bb2VEcVBxUkJFUmdGYzJYRGg5Yjdj?=
 =?utf-8?B?cEZzdUgyMElRcithZG1QYzk3eDlIZXc5SFQxRW1GcW1Dd1FOUkpyZkJ0Umk1?=
 =?utf-8?B?VlNiT0ZpY09vcVBWSmdaRUdhZkM3M3Z3UjJoVVBsRGI2ZFduNlJlUk0xRnZl?=
 =?utf-8?B?MnJJbDB6cW1uMm9VTkh4M1FNOU5KLzRmZUMxWEdSUVJXbE4wOVRJME52THgy?=
 =?utf-8?B?LzFxbEQ5dENzRmtJWk9sY201WGdUSlFmRGNjR3FkcGR2U1I1VjEvdVlrVkRa?=
 =?utf-8?Q?vS9kOWvG0oBsNB+DWwyqWFPk0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F17C73D5F7024247AD8817A5ADD35658@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c69baf-1eb1-462b-e270-08dbb0570bb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2023 10:33:30.7822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jhwScsGGwQlDS9yjSvZMed5CYxLCw+SQl+3l9287pQ8tP6ecDo4+I9ea5rVNQg77VQ2QKK5ZPdqlH8E00wPIrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5958
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gKyNkZWZpbmUgc2VhbWNhbGxfZXJyKF9fZm4sIF9fZXJyLCBfX2FyZ3MsIF9fcHJlcnJf
ZnVuYykJCQlcDQo+ID4gKwlfX3ByZXJyX2Z1bmMoIlNFQU1DQUxMICgweCVsbHgpIGZhaWxlZDog
MHglbGx4XG4iLAkJXA0KPiA+ICsJCQkoKHU2NClfX2ZuKSwgKCh1NjQpX19lcnIpKQ0KPiA+ICsN
Cj4gPiArI2RlZmluZSBTRUFNQ0FMTF9SRUdTX0ZNVAkJCQkJCVwNCj4gPiArCSJSQ1ggMHglbGx4
IFJEWCAweCVsbHggUjggMHglbGx4IFI5IDB4JWxseCBSMTAgMHglbGx4IFIxMSAweCVsbHhcbiIN
Cj4gPiArDQo+ID4gKyNkZWZpbmUgc2VhbWNhbGxfZXJyX3JldChfX2ZuLCBfX2VyciwgX19hcmdz
LCBfX3ByZXJyX2Z1bmMpCQlcDQo+ID4gKyh7CQkJCQkJCQkJXA0KPiA+ICsJc2VhbWNhbGxfZXJy
KChfX2ZuKSwgKF9fZXJyKSwgKF9fYXJncyksIF9fcHJlcnJfZnVuYyk7CQlcDQo+ID4gKwlfX3By
ZXJyX2Z1bmMoU0VBTUNBTExfUkVHU19GTVQsCQkJCQlcDQo+ID4gKwkJCShfX2FyZ3MpLT5yY3gs
IChfX2FyZ3MpLT5yZHgsIChfX2FyZ3MpLT5yOCwJXA0KPiA+ICsJCQkoX19hcmdzKS0+cjksIChf
X2FyZ3MpLT5yMTAsIChfX2FyZ3MpLT5yMTEpOwlcDQo+ID4gK30pDQo+ID4gKw0KPiA+ICsjZGVm
aW5lIFNFQU1DQUxMX0VYVFJBX1JFR1NfRk1UCVwNCj4gPiArCSJSQlggMHglbGx4IFJESSAweCVs
bHggUlNJIDB4JWxseCBSMTIgMHglbGx4IFIxMyAweCVsbHggUjE0IDB4JWxseCBSMTUgMHglbGx4
Ig0KPiA+ICsNCj4gPiArI2RlZmluZSBzZWFtY2FsbF9lcnJfc2F2ZWRfcmV0KF9fZm4sIF9fZXJy
LCBfX2FyZ3MsIF9fcHJlcnJfZnVuYykJXA0KPiA+ICsoewkJCQkJCQkJCVwNCj4gPiArCXNlYW1j
YWxsX2Vycl9yZXQoX19mbiwgX19lcnIsIF9fYXJncywgX19wcmVycl9mdW5jKTsJCVwNCj4gPiAr
CV9fcHJlcnJfZnVuYyhTRUFNQ0FMTF9FWFRSQV9SRUdTX0ZNVCwJCQkJXA0KPiA+ICsJCQkoX19h
cmdzKS0+cmJ4LCAoX19hcmdzKS0+cmRpLCAoX19hcmdzKS0+cnNpLAlcDQo+ID4gKwkJCShfX2Fy
Z3MpLT5yMTIsIChfX2FyZ3MpLT5yMTMsIChfX2FyZ3MpLT5yMTQsCVwNCj4gPiArCQkJKF9fYXJn
cyktPnIxNSk7CQkJCQlcDQo+ID4gK30pDQo+ID4gKw0KPiA+ICtzdGF0aWMgX19hbHdheXNfaW5s
aW5lIGJvb2wgc2VhbWNhbGxfZXJyX2lzX2tlcm5lbF9kZWZpbmVkKHU2NCBlcnIpDQo+ID4gK3sN
Cj4gPiArCS8qIEFsbCBrZXJuZWwgZGVmaW5lZCBTRUFNQ0FMTCBlcnJvciBjb2RlIGhhdmUgVERY
X1NXX0VSUk9SIHNldCAqLw0KPiA+ICsJcmV0dXJuIChlcnIgJiBURFhfU1dfRVJST1IpID09IFRE
WF9TV19FUlJPUjsNCj4gPiArfQ0KPiA+ICsNCj4gPiArI2RlZmluZSBfX1NFQU1DQUxMX1BSRVJS
KF9fc2VhbWNhbGxfZnVuYywgX19mbiwgX19hcmdzLCBfX3NlYW1jYWxsX2Vycl9mdW5jLAlcDQo+
ID4gKwkJCV9fcHJlcnJfZnVuYykJCQkJCQlcDQo+ID4gKyh7CQkJCQkJCQkJCVwNCj4gPiArCXU2
NCBfX19zcmV0ID0gX19zZWFtY2FsbF9mdW5jKChfX2ZuKSwgKF9fYXJncykpOwkJCVwNCj4gPiAr
CQkJCQkJCQkJCVwNCj4gPiArCS8qIEtlcm5lbCBkZWZpbmVkIGVycm9yIGNvZGUgaGFzIHNwZWNp
YWwgbWVhbmluZywgbGVhdmUgdG8gY2FsbGVyICovCVwNCj4gPiArCWlmICghc2VhbWNhbGxfZXJy
X2lzX2tlcm5lbF9kZWZpbmVkKChfX19zcmV0KSkgJiYJCQlcDQo+ID4gKwkJCV9fX3NyZXQgIT0g
VERYX1NVQ0NFU1MpCQkJCQlcDQo+ID4gKwkJX19zZWFtY2FsbF9lcnJfZnVuYygoX19mbiksIChf
X19zcmV0KSwgKF9fYXJncyksIF9fcHJlcnJfZnVuYyk7CVwNCj4gPiArCQkJCQkJCQkJCVwNCj4g
PiArCV9fX3NyZXQ7CQkJCQkJCQlcDQo+ID4gK30pDQo+ID4gKw0KPiA+ICsjZGVmaW5lIFNFQU1D
QUxMX1BSRVJSKF9fc2VhbWNhbGxfZnVuYywgX19mbiwgX19hcmdzLCBfX3NlYW1jYWxsX2Vycl9m
dW5jKQlcDQo+ID4gKyh7CQkJCQkJCQkJCVwNCj4gPiArCXU2NCBfX19zcmV0ID0gX19TRUFNQ0FM
TF9QUkVSUihfX3NlYW1jYWxsX2Z1bmMsIF9fZm4sIF9fYXJncywJCVwNCj4gPiArCQkJX19zZWFt
Y2FsbF9lcnJfZnVuYywgcHJfZXJyKTsJDQo+IA0KPiBfX1NFQU1DQUxMX1BSRVJSIHNlZW1zIHRv
IG9ubHkgZXZlciBiZSBjYWxsZWQgd2l0aCBwcl9lcnIgZm9yIGFzIHRoZSANCj4gZXJyb3IgZnVu
Y3Rpb24sIGNhbiB5b3UganVzdCBraWxsIG9mZiB0aGF0IGFyZ3VtZW50IGFuZCBhbHdheXMgY2Fs
bCBwcl9lcnIuDQoNClBsZWFzZSBzZWUgYmVsb3cuDQoNCj4gCQkJXA0KPiA+ICsJaW50IF9fX3Jl
dDsJCQkJCQkJCVwNCj4gPiArCQkJCQkJCQkJCVwNCj4gPiArCXN3aXRjaCAoX19fc3JldCkgewkJ
CQkJCQlcDQo+ID4gKwljYXNlIFREWF9TVUNDRVNTOgkJCQkJCQlcDQo+ID4gKwkJX19fcmV0ID0g
MDsJCQkJCQkJXA0KPiA+ICsJCWJyZWFrOwkJCQkJCQkJXA0KPiA+ICsJY2FzZSBURFhfU0VBTUNB
TExfVk1GQUlMSU5WQUxJRDoJCQkJCVwNCj4gPiArCQlwcl9lcnIoIlNFQU1DQUxMIGZhaWxlZDog
VERYIG1vZHVsZSBub3QgbG9hZGVkLlxuIik7CQlcDQo+ID4gKwkJX19fcmV0ID0gLUVOT0RFVjsJ
CQkJCQlcDQo+ID4gKwkJYnJlYWs7CQkJCQkJCQlcDQo+ID4gKwljYXNlIFREWF9TRUFNQ0FMTF9H
UDoJCQkJCQkJXA0KPiA+ICsJCXByX2VycigiU0VBTUNBTEwgZmFpbGVkOiBURFggZGlzYWJsZWQg
YnkgQklPUy5cbiIpOwkJXA0KPiA+ICsJCV9fX3JldCA9IC1FT1BOT1RTVVBQOwkJCQkJCVwNCj4g
PiArCQlicmVhazsJCQkJCQkJCVwNCj4gPiArCWNhc2UgVERYX1NFQU1DQUxMX1VEOgkJCQkJCQlc
DQo+ID4gKwkJcHJfZXJyKCJTRUFNQ0FMTCBmYWlsZWQ6IENQVSBub3QgaW4gVk1YIG9wZXJhdGlv
bi5cbiIpOwkJXA0KPiA+ICsJCV9fX3JldCA9IC1FQUNDRVM7CQkJCQkJXA0KPiA+ICsJCWJyZWFr
OwkJCQkJCQkJXA0KPiA+ICsJZGVmYXVsdDoJCQkJCQkJCVwNCj4gPiArCQlfX19yZXQgPSAtRUlP
OwkJCQkJCQlcDQo+ID4gKwl9CQkJCQkJCQkJXA0KPiA+ICsJX19fcmV0OwkJCQkJCQkJCVwNCj4g
PiArfSkNCj4gPiArDQo+ID4gKyNkZWZpbmUgc2VhbWNhbGxfcHJlcnIoX19mbiwgX19hcmdzKQkJ
CQkJCVwNCj4gPiArCVNFQU1DQUxMX1BSRVJSKHNlYW1jYWxsLCAoX19mbiksIChfX2FyZ3MpLCBz
ZWFtY2FsbF9lcnIpDQo+ID4gKw0KPiA+ICsjZGVmaW5lIHNlYW1jYWxsX3ByZXJyX3JldChfX2Zu
LCBfX2FyZ3MpCQkJCQlcDQo+ID4gKwlTRUFNQ0FMTF9QUkVSUihzZWFtY2FsbF9yZXQsIChfX2Zu
KSwgKF9fYXJncyksIHNlYW1jYWxsX2Vycl9yZXQpDQo+ID4gKw0KPiA+ICsjZGVmaW5lIHNlYW1j
YWxsX3ByZXJyX3NhdmVkX3JldChfX2ZuLCBfX2FyZ3MpCQkJCQlcDQo+ID4gKwlTRUFNQ0FMTF9Q
UkVSUihzZWFtY2FsbF9zYXZlZF9yZXQsIChfX2ZuKSwgKF9fYXJncyksCQkJXA0KPiA+ICsJCQlz
ZWFtY2FsbF9lcnJfc2F2ZWRfcmV0KQ0KPiANCj4gDQo+IFRoZSBsZXZlbCBvZiBpbmRpcmVjdGlv
biB3aGljaCB5b3UgYWRkIHdpdGggdGhvc2Ugc2VhbWNhbF9lcnIqIGZ1bmN0aW9uIA0KPiBpcyBq
dXN0IG1pbmQgYm9nZ2xpbmc6DQo+IA0KPiANCj4gU0VBTUNBTExfUFJFUlIgLT4gX19TRUFNQ0FM
TF9QUkVSUiAtPiBfX3NlYW1jYWxsX2Vycl9mdW5jIC0+IA0KPiBfX3ByZXJyX2Z1bmMgYW5kIGFs
bCBvZiB0aGlzIHNvIHlvdSBjYW4gaGF2ZSBhIHN0YW5kYXJkaXplZCBzdHJpbmcgDQo+IHByaW50
aW5nLiBJIHNlZSBubyB2YWx1ZSBpbiBoYXZpbmcgX19TRUFNQ0FMTF9QUkVSUiBhcyBhIHNlcGFy
YXRlIG1hY3JvLCANCj4gc2ltcGx5IGlubGluZSBpdCBpbnRvIFNFQU1DQUxMX1BSRVJSLCByZXBs
YWNlIHRoZSBwcmVycl9mdW5jIGFyZ3VtZW50IA0KPiB3aXRoIGEgZGlyZWN0IGNhbGwgdG8gcHJf
ZXJyLg0KDQpUaGFua3MgZm9yIGNvbW1lbnRzIQ0KDQpJIHdhcyBob3BpbmcgX19TRUFNQ0FMTF9Q
UkVSUigpIGNhbiBiZSB1c2VkIGJ5IEtWTSBjb2RlIGJ1dCBJIGd1ZXNzIEkgd2FzIG92ZXItDQp0
aGlua2luZy4gwqBJIGNhbiByZW1vdmUgX19TRUFNQ0FMTF9QUkVSUigpIHVubGVzcyBJc2FrdSB0
aGlua3MgaXQgaXMgdXNlZnVsIHRvDQpLVk0uDQoNCkhvd2V2ZXIgbWF5YmUgaXQncyBiZXR0ZXIg
dG8ga2VlcCBfX3ByZXJyX2Z1bmMgaW4gc2VhbWNhbGxfZXJyKigpIGFzIEtWTSBURFgNCnBhdGNo
ZXMgdXNlIHByX2Vycl9yYXRlbGltaXRlZCgpLiAgSSBhbSBob3BpbmcgS1ZNIGNhbiB1c2UgdGhv
c2UgdG8gYXZvaWQNCmR1cGxpY2F0aW9uIGF0IHNvbWUgbGV2ZWwuICBBbHNvLCBJTUhPIGhhdmlu
ZyBfX3ByZXJyX2Z1bmMgaW4gc2VhbWNhbGxfZXJyKigpIA0Kd291bGQgbWFrZSBTRUFNQ0FMTF9Q
UkVSUigpIG1vcmUgdW5kZXJzdGFuZGFibGUgYmVjYXVzZSB3ZSBjYW4gaW1tZWRpYXRlbHkgc2Vl
DQpwcl9lcnIoKSBpcyB1c2VkIGJ5IGp1c3QgbG9va2luZyBhdCBTRUFNQ0FMTF9QUkVSUigpLg0K
DQpBbnl3YXkgSSBhbSBlYWdlciB0byBoZWFyIGNvbW1lbnRzIGZyb20gb3RoZXJzIHRvby4gOi0p
DQoNCg==
