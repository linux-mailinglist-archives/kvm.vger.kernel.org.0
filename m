Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C6B7CD997
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjJRKvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 06:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjJRKve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 06:51:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4023CBA;
        Wed, 18 Oct 2023 03:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697626293; x=1729162293;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Pdxvl6Cd2QmqX2Nsx4xa+kBsT8UPDeoKnWkQGX1E7NQ=;
  b=InJOlUvbHTUAjIENM/lnr58+mDhn0XCgL8av1QqDl9v8gB+N4kosopnG
   25Oq78r5s8OJcqEi0t961RI5n6uXpPnqPAXtTlvgQ0t+2DHBiPccEgs+i
   KYZt/Jh397QcpUmhjHzUgKzBeOl928lyGIMg0v6ZvyKrARHkZouuhPf1m
   PjMkzx4b8tL7lkc2mWoQ5JbpDaKpXPVjEhByl36ijUMzrUl3OWQRAvgXl
   EdqKA/aAvHHQP6SJHyX+0SUZjOV75jCa7nZ563ZNMaOhkYwfl+nzBwpxX
   VHiaB065x+fOB6v2fIBTYCe8CgHYHI6zoA2vuYF6eYgAjIWmnOGUwSRqm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="385820593"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="385820593"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 03:51:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="930141493"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="930141493"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2023 03:51:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 03:51:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 18 Oct 2023 03:51:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 18 Oct 2023 03:51:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSW2Ff8C68B6W7Xi09eOzFvYRZuFyce7VuYQ1Zcw2Xuf6tbcFowXvps7okNTFwpqdUOIJESf3KVzJlcameAKSVR11MMbJdubjMMMPYEJj001pGOMcRY952L4PNbQxh/L+DAswRKhowsD/vx5hHZSoSDKepTw7hK0pTFPYc7lHnWCqntAEVWm5SZRjrix5LJS6+f24KV4V2Og3LAZlxj2NEA4Brn/4v9iH82Hs0SiyzG632rtrBb4tgp5qomVuCv0udUcNdR6pSS7cXiD3NqpmkOkQym7rRi+Cs8GXn3Ok/yhlzmqg+WSg2dJvMVyiVaNIox1FS/9JbER2+gOILS3qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pdxvl6Cd2QmqX2Nsx4xa+kBsT8UPDeoKnWkQGX1E7NQ=;
 b=Y9RkUuB1uBiiKCxggzUh87RcnqL4FuCU5hjpsxF4iZ0kJXMKw0uWMIQZD7qre0rd7WUv1LbwwPC3WYPuid8wFXrNgHnPMnJ3toGyaD/jQA6MqMVyBK2tkcH/yQjaDFaUFwZs/n83XD3e97ktUkjWgLGcgDToC+I7y0EIKxVGWyYtjNJ3PC+N99u/+pNShFZvdCgEzNilXz4rPlLU268oxVa/OtqapPfe3gON2CtzWEveR5bazc0kogxCp0puAySGwa4SnvLzHJ2yELwYmAjUOTmIKp7IhdvX9gPAfmfPvmqOHd4bSjUWQMWZRi8RmrF9Az9RRVcJizrZVuMCZ3jsPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB7158.namprd11.prod.outlook.com (2603:10b6:806:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Wed, 18 Oct
 2023 10:51:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 10:51:22 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "rafael@kernel.org" <rafael@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
Thread-Topic: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
Thread-Index: AQHaAOAHZhhRpZBgMkGcIwyiZNScqbBNzo0AgAEURgCAAHOagIAACd+A
Date:   Wed, 18 Oct 2023 10:51:22 +0000
Message-ID: <1c118d563ead759d65ebd33ecee735aaff2b7630.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
         <CAJZ5v0ifJ5G7yOidiADkbwvuttVAVhVx6eSoJqBDeacZiGXZDg@mail.gmail.com>
         <0d5769002692aa5e2ba157b0bd47526dc0b738fb.camel@intel.com>
         <CAJZ5v0jd0_bsFHTQ_5jo3chxFvEvfiPkmi0w31DGHeSWQNuWow@mail.gmail.com>
In-Reply-To: <CAJZ5v0jd0_bsFHTQ_5jo3chxFvEvfiPkmi0w31DGHeSWQNuWow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB7158:EE_
x-ms-office365-filtering-correlation-id: cd4b84e0-00ca-4ca6-1125-08dbcfc82ac1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3iVos/fwi5gX9uVy0AtJvAx6unL9QGNHxtyEQqoUW0iEdQ0QJCfNEYuE28g3M1GQGc9b/L1ROernja8Q3gObuW57gqb3OjPwcNSLeb6G8kxHGSS1IW18nOwd5jAPy09Ri3AnMrXj3Mx03nDoAtvSA0qGicW33VLWH/MCEAvNrq2HZCTSNpr6E7C6X5YbI1z1ov76/H5mWRxVm70DRAa3jmmsbid2rsS55aay6Y/IQXO9UBGUkRNdEBLn8LpfvbT/PnWRaaZGU95PUnH/PwG+XXtSiMOUPTLjQ1/u+8kPWYKbBGz4IXp0XYhS8GQRaZTt9VEmhYryeiJ4MzaxgwTkVifvq8cLesjtvBfuhewFm/OURXl67AyrHo5PA0uPQeiyJ9tZ6i687ujanI/f6Oko4QsepEWEn42IxJgSr9acNPDm3tK+Te1LX4+lrGfdkU7N5BDdpPDY6baOeuaTDDyQDuYtf/7vq+9XMWUAvY+2fFRge/uofNcqO6ZV7hh0YOJUBRbirluIb2FhOln2o5yUrzf75qn5VNnh8qggW9E0lbG+kB7VTzjhD/3dZPLO/JX8dQqQc1Xj93S7CpzoiHZp4L1Z1uDR70QBHhScNa8dfHFUyRpk2u20bpfGDf94xBD5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(39860400002)(376002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(86362001)(38100700002)(38070700005)(2616005)(71200400001)(82960400001)(122000001)(26005)(83380400001)(6506007)(53546011)(6512007)(36756003)(8676002)(4326008)(8936002)(478600001)(5660300002)(6486002)(41300700001)(7416002)(2906002)(4001150100001)(66946007)(66476007)(66446008)(64756008)(54906003)(66556008)(6916009)(91956017)(76116006)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OE0vVlV3dlQ0RHROYmFYaGN6MGpDbkN2N28vMDNpYmZGMzAzT0ZHR3diUVhW?=
 =?utf-8?B?dnB0NkdibEVyQWFqN3orQlpwclY2Rk44bFEyaXVmczFGVVU5TmdaT2RvaVVw?=
 =?utf-8?B?Yjl6WEdtQTB6VjZRUHhPTWFONEhReDRYTi9NVzFJZlZpNFJTYmk3YXgyUE9x?=
 =?utf-8?B?Skp3NHB6cVMvNnhZeDRPaldBcm1ucy9XS0hyT3ZnVEJhNG5RbjFTbytjYTdn?=
 =?utf-8?B?Rlh4cngzRFpVU1M2Y3VIY0U0TEFTTFEyZUNvakFLRXROU2ZxcGE5MDhTWDB5?=
 =?utf-8?B?bGVVZFNqUGdiUmExdVJSUEp2VlhYS2xmTzRhbVR0a2pxN3RNNUxwYUxubG54?=
 =?utf-8?B?QTNaYkZ4ZkJpNkZ4UGRqK2ZHVnBiVnQxRTMvUVdscjZXZ0ZReW8rWDl6YkUw?=
 =?utf-8?B?SEphRDZ4dzgvVWlrYUtNQ1BBMWFzMEYrTnpDdFFyQXlxeTRFQ2t4cWZ4S3dY?=
 =?utf-8?B?Sjhoakd2dnlaZnRlOC9ON2xEbWFmbjc1Z2ZzTUNjUDBZT2c2b3U1bDlrMXVi?=
 =?utf-8?B?SWVQcXpWK1pGaDk0dlFpODc3OEpXRWFtV3RTTkpTSzhTSDVQRzZOLzZjaDUv?=
 =?utf-8?B?ekxwTVBxMERCNnpaRVJoZFhYSlpvWFpZQ0FSd2ZzeWdNK0FjOEdYUGhaaWVB?=
 =?utf-8?B?TmlUWW9yekZpUnp3TnhVOUsrQjVnSXppN21RYi95QmdEU2FZSHY5dGhod2Mx?=
 =?utf-8?B?S0Ridy8zYTNkdncrazZIZkZKK3VlL3BFVDMzUUFINHN4L3lTcWMwMDdBdTZx?=
 =?utf-8?B?cElUeWhPRWc0RDRxU3FnMVlyNWJPTVZva2Q3RDNlY0NXMW1aMHkrMGFIc2o0?=
 =?utf-8?B?MEYxbGQyaThkZGY0MUNEZTBCVFAya2c5dUpOSC9UVUxTNW1zTnhhQnY4TFp5?=
 =?utf-8?B?TnF0d2l6a1NWbnVkRFg2bUFMZm1WM3c5REo3MG5GWSttTk0xTmQ5SDFiOERi?=
 =?utf-8?B?WmUyb2NNbTc5UE91T1FJMnd5UWNkTFNvSHpIQ1RvWTZRRFdDZ05iYjRCVHBl?=
 =?utf-8?B?MWpFRFp3RlN2aTJNVFlpRGZ6dXg1bGY3WDFzWEhxamgzZ2dRTE9wdlBQL2pk?=
 =?utf-8?B?VllsdElPQkR0UDVQbytkd2x0N0FhWktjbk42dERZMmMvVEpQZjJ3RTk5NVRp?=
 =?utf-8?B?ek1PUXBvZDZWYXNwdHlTaUd6U2dkaFoyUWh5RUppeXExU1V2TVlFUm5OWTFN?=
 =?utf-8?B?MTQzQnFJMFRnU1lOR1FRQWR3TERrbE5FVG91d1J6NU5YZXF5clhZRzlIWW9s?=
 =?utf-8?B?VStHbzZlMVo4TnJlQzlGck96Vlh2U2lOVStvOXV3bVFKK1hwYmJNZDdMWGxy?=
 =?utf-8?B?WXErSE5KdnJWWUJhUU5EaGlFcmRSNWpGNE41TnRTb1htK3lvS0UyNGlnNjdX?=
 =?utf-8?B?TTF6RStkYkxXTGt6Q2IrSEN2VnFSRzZhT2E5OHNnMjV0YWZ0VG5wQlg3ZlJ6?=
 =?utf-8?B?WmVHSVQwczhrTGVLODREQnBpTDRGUjlxZXJIclFFdkNKUFpEbW5jVTJHbjdO?=
 =?utf-8?B?N2hVdndGU3Q3cTMwWnZjSG13cG5XeFpjQ2lDRTh5bEdqOGhkTmhhdUUrYTFF?=
 =?utf-8?B?Wis4ejBXQ2RXZjdmMTVaUzlPMTczcUEzWlcxbldVZmhxc0dTYVM5WFFnMG5Z?=
 =?utf-8?B?WXR4Y0pnOGwvT2ZkQUtPNjI2RlZZWUhtOUZwdCtmUjVXK1NXRjMwQm5NQ3Jw?=
 =?utf-8?B?QnR2dkY2RjZBQXFMQkIyRXVtRjdqTWlla1VHd0RNaHVMSHlKZUxXTUhsalhD?=
 =?utf-8?B?c3hSQmQxN3RvcnNnQU44R3JOZkF3aFlhaEphbjZmQmNKK2hhWHl2bmVRdno3?=
 =?utf-8?B?azczRVdJUmVzbnZncEJTUTZzamhUbkhxTHBlbzQvRWJyVE8vaWt2WkN6Nk5C?=
 =?utf-8?B?V205dnYxL1QwQkhzT2NuMnY0UitrdmJmYnpkWGxOQjZXZjRTeU1qQzVwZGRm?=
 =?utf-8?B?Y2RzMk1qY3c3Tmg1ZzRoVERwK3VqczNsbHFtbDE0ejRXbk5HRzdVTnBqcEho?=
 =?utf-8?B?SkV1cy8zc0tCQWlvcmlEdytwV0k3MjEwbjdzbzlIZ1BJRHN6WGZ1emZyYnpB?=
 =?utf-8?B?c29KMmFESTVkcUFOUUFyRXpuWFk3SFdkNnZobUNTOVNsSEpqUXlldTVNL0FG?=
 =?utf-8?B?ZW5aWHRGUDl4U0FhY0l5RE90a0czNC8vOTZmRzE0dGlTbTNwbHd6Z1NKdnZ1?=
 =?utf-8?B?Ync9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA478DBBD7B48E4A9A0592F32C2E0D9D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4b84e0-00ca-4ca6-1125-08dbcfc82ac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 10:51:22.0275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OLGHzq3h50awk9GIRSeVT3GdpPBAFTdyC12tjEyNzVCGytKmkH4C6166vhUvra8aE1BVV4cHsUSa+xtgnIkt/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7158
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTEwLTE4IGF0IDEyOjE1ICswMjAwLCBSYWZhZWwgSi4gV3lzb2NraSB3cm90
ZToNCj4gT24gV2VkLCBPY3QgMTgsIDIwMjMgYXQgNToyMuKAr0FNIEh1YW5nLCBLYWkgPGthaS5o
dWFuZ0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEhpIFJhZmFlbCwNCj4gPiBUaGFua3Mg
Zm9yIGZlZWRiYWNrIQ0KPiA+ID4gDQo+ID4gDQo+ID4gDQo+ID4gPiA+IEBAIC0xNDI3LDYgKzE0
MjksMjIgQEAgc3RhdGljIGludCBfX2luaXQgdGR4X2luaXQodm9pZCkNCj4gPiA+ID4gICAgICAg
ICAgICAgICAgIHJldHVybiAtRU5PREVWOw0KPiA+ID4gPiAgICAgICAgIH0NCj4gPiA+ID4gDQo+
ID4gPiA+ICsjZGVmaW5lIEhJQkVSTkFUSU9OX01TRyAgICAgICAgICAgICAgICBcDQo+ID4gPiA+
ICsgICAgICAgIkRpc2FibGUgVERYIGR1ZSB0byBoaWJlcm5hdGlvbiBpcyBhdmFpbGFibGUuIFVz
ZSAnbm9oaWJlcm5hdGUnDQo+ID4gY29tbWFuZCBsaW5lIHRvIGRpc2FibGUgaGliZXJuYXRpb24u
Ig0KPiA+ID4gDQo+ID4gPiBJJ20gbm90IHN1cmUgaWYgdGhpcyBuZXcgc3ltYm9sIGlzIHJlYWxs
eSBuZWNlc3NhcnkuDQo+ID4gPiANCj4gPiA+IFRoZSBtZXNzYWdlIGNvdWxkIGJlIGFzIHNpbXBs
ZSBhcyAiSW5pdGlhbGl6YXRpb24gZmFpbGVkOiBIaWJlcm5hdGlvbg0KPiA+ID4gc3VwcG9ydCBp
cyBlbmFibGVkIiAoYXNzdW1pbmcgYSBwcm9wZXJseSBkZWZpbmVkIHByX2ZtdCgpKSwgYmVjYXVz
ZQ0KPiA+ID4gdGhhdCBjYXJyaWVzIGVub3VnaCBpbmZvcm1hdGlvbiBhYm91dCB0aGUgcmVhc29u
IGZvciB0aGUgZmFpbHVyZSBJTU8uDQo+ID4gPiANCj4gPiA+IEhvdyB0byBhZGRyZXNzIGl0IGNh
biBiZSBkb2N1bWVudGVkIGVsc2V3aGVyZS4NCj4gPiANCj4gPiANCj4gPiBUaGUgbGFzdCBwYXRj
aCBvZiB0aGlzIHNlcmllcyBpcyB0aGUgZG9jdW1lbnRhdGlvbiBwYXRjaCB0byBhZGQgVERYIGhv
c3QuICBXZQ0KPiA+IGNhbiBhZGQgYSBzZW50ZW5jZSB0byBzdWdnZXN0IHRoZSB1c2VyIHRvIHVz
ZSAnbm9oaWJlcm5hdGUnIGtlcm5lbCBjb21tYW5kIGxpbmUNCj4gPiB3aGVuIG9uZSBzZWVzIFRE
WCBnZXRzIGRpc2FibGVkIGJlY2F1c2Ugb2YgaGliZXJuYXRpb24gYmVpbmcgYXZhaWxhYmxlLg0K
PiA+IA0KPiA+IEJ1dCBpc24ndCBiZXR0ZXIgdG8ganVzdCBwcm92aWRlIHN1Y2ggaW5mb3JtYXRp
b24gdG9nZXRoZXIgaW4gdGhlIGRtZXNnIHNvIHRoZQ0KPiA+IHVzZXIgY2FuIGltbWVkaWF0ZWx5
IGtub3cgaG93IHRvIHJlc29sdmUgdGhpcyBpc3N1ZT8NCj4gPiANCj4gPiBJZiB1c2VyIG9ubHkg
c2VlcyAiLi4uIGZhaWxlZDogSGliZXJuYXRpb24gc3VwcG9ydCBpcyBlbmFibGVkIiwgdGhlbiB0
aGUgdXNlcg0KPiA+IHdpbGwgbmVlZCBhZGRpdGlvbmFsIGtub3dsZWRnZSB0byBrbm93IHdoZXJl
IHRvIGxvb2sgZm9yIHRoZSBzb2x1dGlvbiBmaXJzdCwgYW5kDQo+ID4gb25seSBhZnRlciB0aGF0
LCB0aGUgdXNlciBjYW4ga25vdyBob3cgdG8gcmVzb2x2ZSB0aGlzLg0KPiANCj4gSSB3b3VsZCBl
eHBlY3QgYW55b25lIGludGVyZXN0ZWQgaW4gYSBnaXZlbiBmZWF0dXJlIHRvIGdldCBmYW1pbGlh
cg0KPiB3aXRoIGl0cyBkb2N1bWVudGF0aW9uIGluIHRoZSBmaXJzdCBwbGFjZS4gIElmIHRoZXkg
bmVnbGVjdCB0byBkbyB0aGF0DQo+IGFuZCB0aGVuIGZpbmQgdGhpcyBtZXNzYWdlLCBpdCBpcyBh
YnNvbHV0ZWx5IGZhaXIgdG8gZXhwZWN0IHRoZW0gdG8gZ28NCj4gYW5kIGxvb2sgaW50byB0aGUg
ZG9jdW1lbnRhdGlvbiBhZnRlciBhbGwuDQoNCk9LLiAgSSdsbCByZW1vdmUgSElCRVJOQVRJT05f
TVNHIGFuZCBqdXN0IHByaW50IHRoZSBtZXNzYWdlIHN1Z2dlc3RlZCBieSB5b3UuDQoNCkFuZCBp
biB0aGUgZG9jdW1lbnRhdGlvbiBwYXRjaCwgYWRkIG9uZSBzZW50ZW5jZSB0byB0ZWxsIHVzZXIg
d2hlbiB0aGlzIGhhcHBlbnMsDQphZGQgJ25vaGliZXJuYXRlJyB0byByZXNvbHZlLg0KDQoNClsu
Li5dDQoNCj4gPiANCj4gPiAtLyogTG93LWxldmVsIHN1c3BlbmQgcm91dGluZS4gKi8NCj4gPiAt
ZXh0ZXJuIGludCAoKmFjcGlfc3VzcGVuZF9sb3dsZXZlbCkodm9pZCk7DQo+ID4gK3R5cGVkZWYg
aW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsX3QpKHZvaWQpOw0KPiA+ICsNCj4gPiArLyogU2V0
IHVwIGxvdy1sZXZlbCBzdXNwZW5kIHJvdXRpbmUuICovDQo+ID4gK3ZvaWQgYWNwaV9zZXRfc3Vz
cGVuZF9sb3dsZXZlbChhY3BpX3N1c3BlbmRfbG93bGV2ZWxfdCBmdW5jKTsNCj4gDQo+IEknbSBu
b3Qgc3VyZSBhYm91dCB0aGUgdHlwZWRlZGYsIGJ1dCBJIGhhdmUgbm8gc3Ryb25nIG9waW5pb24g
YWdhaW5zdCBpdCBlaXRoZXIuDQo+IA0KPiA+IA0KPiA+ICAvKiBQaHlzaWNhbCBhZGRyZXNzIHRv
IHJlc3VtZSBhZnRlciB3YWtldXAgKi8NCj4gPiAgdW5zaWduZWQgbG9uZyBhY3BpX2dldF93YWtl
dXBfYWRkcmVzcyh2b2lkKTsNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2FjcGkv
Ym9vdC5jIGIvYXJjaC94ODYva2VybmVsL2FjcGkvYm9vdC5jDQo+ID4gaW5kZXggMmEwZWEzODk1
NWRmLi45NWJlMzcxMzA1YzYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL2FjcGkv
Ym9vdC5jDQo+ID4gKysrIGIvYXJjaC94ODYva2VybmVsL2FjcGkvYm9vdC5jDQo+ID4gQEAgLTc3
OSwxMSArNzc5LDE3IEBAIGludCAoKl9fYWNwaV9yZWdpc3Rlcl9nc2kpKHN0cnVjdCBkZXZpY2Ug
KmRldiwgdTMyIGdzaSwNCj4gPiAgdm9pZCAoKl9fYWNwaV91bnJlZ2lzdGVyX2dzaSkodTMyIGdz
aSkgPSBOVUxMOw0KPiA+IA0KPiA+ICAjaWZkZWYgQ09ORklHX0FDUElfU0xFRVANCj4gPiAtaW50
ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2b2lkKSA9IHg4Nl9hY3BpX3N1c3BlbmRfbG93bGV2
ZWw7DQo+ID4gK3N0YXRpYyBpbnQgKCphY3BpX3N1c3BlbmRfbG93bGV2ZWwpKHZvaWQpID0geDg2
X2FjcGlfc3VzcGVuZF9sb3dsZXZlbDsNCj4gPiAgI2Vsc2UNCj4gPiAtaW50ICgqYWNwaV9zdXNw
ZW5kX2xvd2xldmVsKSh2b2lkKTsNCj4gPiArc3RhdGljIGludCAoKmFjcGlfc3VzcGVuZF9sb3ds
ZXZlbCkodm9pZCk7DQo+IA0KPiBGb3IgdGhlIHNha2Ugb2YgY29uc2lzdGVuY3ksIGVpdGhlciB1
c2UgdGhlIHR5cGVkZWYgaGVyZSwgb3IgZG9uJ3QgdXNlDQo+IGl0IGF0IGFsbC4NCg0KQWggcmln
aHQuDQoNClNpbmNlIHlvdSBkb24ndCBwcmVmZXIgdGhlIHR5cGVkZWYsIEknbGwgYWJhbmRvbiBp
dDoNCg0KRS5nLDoNCg0Kdm9pZCBhY3BpX3NldF9zdXNwZW5kX2xvd2xldmVsKGludCAoKnN1c3Bl
bmRfbG93bGV2ZWwpKHZvaWQpKQ0Kew0KCWFjcGlfc3VzcGVuZF9sb3dsZXZlbCA9IHN1c3BlbmRf
bG93bGV2ZWw7DQp9DQoNCkxldCBtZSBrbm93IHdoZXRoZXIgdGhpcyBsb29rcyBnb29kIHRvIHlv
dT8NCg0KWy4uLl0NCg0KPiANCj4gT3RoZXJ3aXNlIExHVE0uDQoNClRoYW5rcy4gSSdsbCBzcGxp
dCB0aGUgaGVscGVyIHBhdGNoIG91dCBhbmQgaW5jbHVkZSBpdCB0byB0aGUgbmV4dCB2ZXJzaW9u
IG9mDQp0aGlzIHNlcmllcy4NCg0K
