Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47437D4E32
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 12:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbjJXKqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 06:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjJXKqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 06:46:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAAD10CB;
        Tue, 24 Oct 2023 03:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698144372; x=1729680372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LhdA3l/+X+zmVsI1+QWEK0hp+oQqBdkiZrDhh+cyopI=;
  b=LuRjPVK23ELxjJWR5fld+PjE4oj9IS1WI7PaM+3KochU+quFInSHOj+F
   cF8jzLIxF4RuAi4Gb0eTcj+A0QLRV9sISNiQ8szWssDINBVwI0K7OOcIZ
   uPoT3xlZFLyJCFMJDH41RWXff43Q8JP5Kn7wYMheLkj9NZT0Jw5BTgaQz
   E+mantCd9yd8byswDzB6VnxHw+iSxbfN8XjL5dnHRSuuLQhOCrO8KL8wr
   Pe3cUgol6kI2czIlQgz8B8BSchwUQZuqdTwTJ+Wvw70GReSfKEYVDDNRw
   kygT955AkGIa1XfhbeaZgNqZ0TDpa8dBuA5ttIFY2zI3sj9DReSKv8nhX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="418156155"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="418156155"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 03:46:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="751954198"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="751954198"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2023 03:46:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 03:46:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 03:46:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 24 Oct 2023 03:46:10 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 24 Oct 2023 03:46:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYRYi81DHg0DVqbQ4GFwRiyVKxvhmAG8BIfZ77vb59auiOLYVCRN8Sp7KWjHMvVRo6O3rLkB1u0B9XHmpkNuSbc0SvfDfvaZ9LUFT4sRqVjK1WMXyARgnEwgfhrSbIssHZ+JNTVA0xvVwqF5NM6zIr/Q3+fgaw+ucWGap63PMpVi7PwvI/vLsSShJ0xzhck1k9l1Z56zUqcK1uQ0tQzmL66W4AsccQlTGd78WrioHwTPz26omNzBxb/JKcOAHnCC1CdAt40rpykDC+tRHQeTQwfG5BZYdLjp9D8lKcA4CBtA3fmR0i7Uq21cJE921MNwpTCizH2Q0otdfnqtq+SGTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhdA3l/+X+zmVsI1+QWEK0hp+oQqBdkiZrDhh+cyopI=;
 b=Z6j9xZG8Z37h96nKy80b04Xed2+ssWt0cyzNrTImg0hMXmNhZIZsXWIqf4XtEj5UKvekI5IBEAGtgbhmgN3IzYm0f0o9ip9O/5xeANuUgTAF9yFrA34mptELWMOc+d9Nc6lvTmuBu+laqRYqXdIlYoSuttyYt9zlnY0J9YKLQDlqwJ/gmz3L7k0JOL0vIOicfwTbb/aDYPK4yNeQIb1Em5/6NF2Udz3/cBJvbPXxDmwRYfZME0StBK+ppNjirqF7dz5z9ZLaQQIgDEfR4dNV0rj+VNiuzfs86qPTim265uB4vs23EbW9Cp4/J7nxX01jLK+6Tt+IYqW0m897CBuxuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5783.namprd11.prod.outlook.com (2603:10b6:510:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 24 Oct
 2023 10:46:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Tue, 24 Oct 2023
 10:46:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "rafael@kernel.org" <rafael@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
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
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
Thread-Topic: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
Thread-Index: AQHaAOAHZhhRpZBgMkGcIwyiZNScqbBNzo0AgAEURgCAAHOagIAACd+AgAAArQCAAjeVgIAHNEOA
Date:   Tue, 24 Oct 2023 10:46:06 +0000
Message-ID: <6f9fb8b056eb24cb0cd8c695de8d468bbb794f07.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
         <CAJZ5v0ifJ5G7yOidiADkbwvuttVAVhVx6eSoJqBDeacZiGXZDg@mail.gmail.com>
         <0d5769002692aa5e2ba157b0bd47526dc0b738fb.camel@intel.com>
         <CAJZ5v0jd0_bsFHTQ_5jo3chxFvEvfiPkmi0w31DGHeSWQNuWow@mail.gmail.com>
         <1c118d563ead759d65ebd33ecee735aaff2b7630.camel@intel.com>
         <CAJZ5v0jy0MR-VyQHQt9-zAhHoTDp-xHtFnDOre3BPmT+FNgjCQ@mail.gmail.com>
         <a663370374f56c05a9241918473adb72accd2054.camel@intel.com>
In-Reply-To: <a663370374f56c05a9241918473adb72accd2054.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5783:EE_
x-ms-office365-filtering-correlation-id: 5c7ba5d0-3b00-4d23-e9b1-08dbd47e6cfc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rma6SHIU/54JnQS97JRzP0zJXFApeb/UhYk2tq3Dg75FIeqPpGlWNO4oFLvWAN9vRXU/isU0r8OhAiOtisxyTUi+ldGnSSVgtJ7iCynKX8V5huP7N8svWtb38YCr26reOFC4bpdlX2oVT3w4j2n48v7HkeN22txr+N4nxqboB9gmarFeeTzJNnzy7GWj+7e8fy3E+ns3VbHVTEXSSxNSl/QwEGr/iBL/0TymZsLJ1BSpjLVyrJSOxuhWtWNfXsguEgEbglqMWjzsoImwNUYc0+n7Il9xPxpun60QqXw9y+8EE1bjeHIWhcixHAzRq1iK4uA8hjn9rcK8ddOK3EAac9NyYr3L+2g/9UaaVJjvRtJBEjDQuO4xV5etjd2DudmCbYt3J0xNqJSug23lL/sCm0Mz7xugApItfV9G+AooFoMUz/07J4dZTvg+NhpdpScR/XmkATUf+8QgEK4qAZxdO7ar1qmYCb63CG6DrTsGPgVINTMdTRpZWvwzwD9QYy1MVel0keid5k4Qs1sKhg6JOdLeUPVV9L/mlcwsmTMPvFUFJGZStLFhE8sglGNbjHHkGtnIEBFFeMoYgU19gQziGpbCx4w4g3Y8DMLi3UrAmx8exIEE0OXmik6a+HjLzigM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(136003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(86362001)(82960400001)(36756003)(316002)(38070700009)(66446008)(71200400001)(26005)(76116006)(54906003)(66946007)(478600001)(66556008)(122000001)(2616005)(66476007)(64756008)(6486002)(5660300002)(8676002)(6512007)(91956017)(6506007)(38100700002)(41300700001)(6916009)(8936002)(7416002)(4326008)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K21DbjhFZ3l3MHJtVmd2dWdmTkxkYVFWT0ZsQ1I4WkMzSnRTUXFRRDU3MjRG?=
 =?utf-8?B?bGdQRmM4NTVseWJ0RUI1MFNSU3YwVExiZFVLeGo3SksyR3VsK3VwWSszNWRu?=
 =?utf-8?B?NXEycnNnMVZ2NW9DYkVWYUVEbTQzOFRrekRHZmYxY2xIUjU1TE1EVWRPMzBV?=
 =?utf-8?B?ZkFOWUsrQW8rSnVWZDdFNGdES0F6eVVQYTJ6emE0RXpPQStqK3JUa1NEVUhZ?=
 =?utf-8?B?amY2eTRXM1FDaVBZcGZkRHdMcVc5cjhSWXREMndza1pLcURwRXB4Tml6NnFh?=
 =?utf-8?B?UzRHb0NNQmRSTEVrSmRCSFpDQ21WNml5ejFOdGU0cFNwbWYrZ1Yra3ZRNTM4?=
 =?utf-8?B?UnVsOVJBNlJNU1NWanJnOFBaaDZyN2xxVHN0RTd6by9udXN4WUlqNTdYa0JF?=
 =?utf-8?B?aFZXTGNyb3ZsU0hDVXNyaGtuOUt6OFdIWnJvL2h6TlhFYVJGbjdubllMMXYz?=
 =?utf-8?B?ZktLUTI0aFNUakI5KzZsdHZyUDRpMW1rYVZBaWtXUWZtYSs4WC81a0lRempx?=
 =?utf-8?B?cnJQbmVQQ1F6QXBpR2NZU0gxY0lZTzVCdXVvV0FuYWt6Q3l1RW1HMXFkcUd5?=
 =?utf-8?B?ZHFnNnNreFZEMVJGSzNyTlc3OWxTSm1GNlB3TFRCZ2lDcUFJSVNEc2dmYkZQ?=
 =?utf-8?B?eEdoYnE4UjJVZnl2VmpUWW52NzF5QldON1h0ZTVCbnczTm91N1V0VzB4NVZU?=
 =?utf-8?B?R2l6NEMyQ2p6RjNuczRGZmJKNFpFVi9WdEtYNy8rWThLSHRjUVVuVEl5ZlFQ?=
 =?utf-8?B?QlJZYUdIU3EvcjFFRUUwOWk5cXkvSzkwdUZZRkhkc0tFVmdSeElFMDFwVUgy?=
 =?utf-8?B?ZmRlUS9McWNhcUxCcjdGait1QlR6MkVQWTluYmJKeWFSbUQ4Vm01Tm9Obnhx?=
 =?utf-8?B?L1FNL3hYZDJnMDE2M0Jsd3hLZ2N5N2NRKzJVY0VvM0wyK2trVmpWb0ppcHB2?=
 =?utf-8?B?R2xXRlE5bGRsWWpDcDZpRXk2Y3A1WGxDbTExN0hzYzlOYlNQRy9xVHZqOEVi?=
 =?utf-8?B?M2JkR0JxdmtIVDBwQW9TRVkzaW5CRzFnTmgvcnpIMWtCck5RMjl3SUdCTVdy?=
 =?utf-8?B?cFpYUFZSVy9PRkZBK0YxbUNjWS9jbitYK2NuSGIzNlIwdW9YM3FiUHFOUHZP?=
 =?utf-8?B?QlNXZnZuTlMrQjlwcWlqRmhKNW1oWTIwRjJ2ZWxzb1hqRWE5NEFIQmRyM0Ix?=
 =?utf-8?B?Nzd5NzV0bVVsUk1TYTZJbGpEVzdBMkVSVzlPdVpyWmlhY3VlY25XbVdtbVhF?=
 =?utf-8?B?c0dsaEZIZVlhYWRCVVdCUll4ZW52TXF4RHViZXRleGZGalllQWNocm92WERQ?=
 =?utf-8?B?MmtwNzB4UUVTVmdERnZEL1JWdS9KVitHOEh3MzQxaGhSWFV1bVZSR29ISGVm?=
 =?utf-8?B?RFNsaXU5Kzh5YlZ1VFNlRFV3ZDZaT0pVeWVZUmZmbVJKRGRxS3huOEJoY095?=
 =?utf-8?B?YlZ5ZEVJN0xrNUFvbUpseHV3U0JsMEhocWt5cVV1ZWd0Wko5enRkdTA3S2lZ?=
 =?utf-8?B?eVFaMFFyWTVlRUE0NTJvT0ZhRkRtRUVnYXMwNjREa3E1NEdqNXFaUWxmd09y?=
 =?utf-8?B?YlZyRzlHb1ZmZXFQSzVjRXk0K243dlBMckFLRXoyNm1PcTFuWCtpN2xES0la?=
 =?utf-8?B?d1NicXh2TG0xZm1Ba2owL2FCVVJiazZqOXluYjU4a3JjSEtlZHVLd0lCOHJE?=
 =?utf-8?B?dmNqSnpJbTJnNEplZXlHaEplTWNaQjVuRWFaQkNGZHE5RWx5QmFsRlRaRXha?=
 =?utf-8?B?MzNybW1RSTdNbWdocXNVcXZhaG1UYm9oeFpJS284YytaTzAxbGFxalhOSmtx?=
 =?utf-8?B?U1JPdGJZUXlaRlFCUTFTRUFVbWI3dkdGUG5KbXk5cmU5UlY5QW8yRGxrWFlB?=
 =?utf-8?B?TGlHeTFwYzl2TTg1NWtuSG5QQVBMNFpQdDFFVzBBbDNPUlNLclhBNlNQM1NQ?=
 =?utf-8?B?WDhIRjBXYlYrMXRCVzMxME9SME9iMVlPQkxtR1kzM3pOOGVibkJDMGE5dGdH?=
 =?utf-8?B?NStOOGFUalhvWnRIUDNCNm9KWUV6YU84WWY0Z1o1N0NWYkszanMyeGtZVlBY?=
 =?utf-8?B?V08zWHZod052cFprbmJ5Z2Q1ME1PclVJd1htdmZqbVF2QVp3ZmRZWktxOHpz?=
 =?utf-8?B?dTFhazA5MGlhZnhxdlRWZ2VoSU9ZWDVoaW1BUXBlWE85RDdOMDUxcHZwd09r?=
 =?utf-8?B?bFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4E9D15C40C15A49BAE305F745A753A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7ba5d0-3b00-4d23-e9b1-08dbd47e6cfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 10:46:06.2309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XpSS6K/EMmudsggwagu+Q+yJv1zmYUQZJwyd5R8yo8Kmga7daGXTuA+CdJnjTnOEQlwCgteBmmxA4jHtdw6eZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5783
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

PiANCj4gSGkgUmFmYWVsLA0KPiANCj4gU29ycnkgZm9yIHRoZSBiYWNrIGFuZCBmb3J0aCBvbiB0
aGlzLg0KPiANCj4gV2l0aCB0aGUgcGF0Y2ggd2hpY2ggcHJvdmlkZXMgdGhlIGhlbHBlciwgTEtQ
IHJlcG9ydGVkIGJ1aWxkIGVycm9yOg0KPiANCj4gwqDCoMKgZHJpdmVycy9hY3BpL3NsZWVwLmM6
IEluIGZ1bmN0aW9uICdhY3BpX3N1c3BlbmRfZW50ZXInOg0KPiA+ID4gZHJpdmVycy9hY3BpL3Ns
ZWVwLmM6NjAwOjIyOiBlcnJvcjogJ2FjcGlfc3VzcGVuZF9sb3dsZXZlbCcgdW5kZWNsYXJlZCAo
Zmlyc3QNCj4gdXNlIGluIHRoaXMgZnVuY3Rpb24pOyBkaWQgeW91IG1lYW4gJ2FjcGlfc2V0X3N1
c3BlbmRfbG93bGV2ZWwnPw0KPiDCoMKgwqDCoMKgNjAwIHwgICAgICAgICAgICAgICAgIGlmICgh
YWNwaV9zdXNwZW5kX2xvd2xldmVsKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqB8ICAgICAgICAgICAg
ICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiDCoMKgwqDCoMKgwqDCoMKgwqB8ICAg
ICAgICAgICAgICAgICAgICAgIGFjcGlfc2V0X3N1c3BlbmRfbG93bGV2ZWwNCj4gDQo+IFR1cm5z
IG91dCBJIGRpc2FibGVkIGJvdGggc3VzcGVuZC9oaWJlcm5hdGlvbiBpbiBteSBvd24ga2VybmVs
IGJ1aWxkIHRlc3QsIHNpZ2guDQo+IA0KPiBUaGUgY29tbW9uIEFDUEkgc2xlZXAgY29kZSByZXF1
aXJlcyB0aGUgQVJDSCB0byBkZWNsYXJlICdhY3BpX3N1c3BlbmRfbG93bGV2ZWwnDQo+IGluIDxh
c20vYWNwaS5oPiwgYW5kIGRlZmluZSBpdCBzb21ld2hlcmUgaW4gdGhlIEFSQ0ggY29kZSAgdG9v
Lg0KPiANCj4gU28gc2FkbHkgSSBjYW5ub3QgcmVtb3ZlIHRoZSBhY3BpX3N1c3BlbmRfbG93bGV2
ZWwgdmFyaWFibGUgZGVjbGFyYXRpb24gaW4NCj4gPGFzbS9hY3BpLmg+LiAgQW5kIHRoZSBlbmRp
bmcgcGF0Y2ggd291bGQgaGF2ZSBib3RoIGJlbG93IGluIDxhc20vYWNwaS5oPjoNCj4gDQo+IMKg
wqDCoC8qIExvdy1sZXZlbCBzdXNwZW5kIHJvdXRpbmUuICovDQo+IMKgwqDCoGV4dGVybiBpbnQg
KCphY3BpX3N1c3BlbmRfbG93bGV2ZWwpKHZvaWQpOw0KPiANCj4gwqDCoCsvKiBUbyBvdmVycmlk
ZSBAYWNwaV9zdXNwZW5kX2xvd2xldmVsIGF0IGVhcmx5IGJvb3QgKi8NCj4gwqDCoCt2b2lkIGFj
cGlfc2V0X3N1c3BlbmRfbG93bGV2ZWwoaW50ICgqc3VzcGVuZF9sb3dsZXZlbCkodm9pZCkpOw0K
PiDCoMKgKw0KPiANCj4gVGh1cyBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgaXQgc3RpbGwgYSBnb29k
IGlkZWEgdG8gaGF2ZSB0aGUgaGVscGVyPw0KPiANCg0KSGkgUmFmYWVsLA0KDQpDb3VsZCB5b3Ug
aGVscCB0byB0YWtlIGEgbG9vayB3aGV0aGVyIHlvdSBzdGlsbCB3YW50IHRoZSBoZWxwZXI/DQoN
CkFucyBzb3JyeSBpbiBwcmV2aW91cyByZXBseSBJIHBhc3RlZCBhbiBvbGQvd3JvbmcgcGF0Y2gs
IHBsZWFzZSBpZ25vcmUuICBCZWxvdw0KaXMgdGhlIHBhdGNoIHRoYXQgY2FuIGJ1aWxkIHN1Y2Nl
c3NmdWxseS4gDQoNCg0KeDg2L2FjcGk6IEFkZCBhIGhlbHBlciB0byBvdmVycmlkZSBBQ1BJIGxv
d2xldmVsIHN1c3BlbmQgZnVuY3Rpb24NCg0KQUNQSSBTMyBzdXNwZW5kIGNvZGUgcmVxdWlyZXMg
YSB2YWxpZCAnYWNwaV9zdXNwZW5kX2xvd2xldmVsJyBmdW5jdGlvbg0KcG9pbnRlciB0byB3b3Jr
LiAgRWFjaCBBUkNIIG5lZWRzIHRvIHNldCB0aGUgYWNwaV9zdXNwZW5kX2xvd2xldmVsIHRvDQpp
dHMgb3duIGltcGxlbWVudGF0aW9uIHRvIG1ha2UgQUNQSSBTMyBzdXNwZW5kIHdvcmsgb24gdGhh
dCBBUkNILiAgWDg2DQppbXBsZW1lbnRzIGEgZGVmYXVsdCBmdW5jdGlvbiBmb3IgdGhhdCwgYW5k
IFhlbiBQViBkb20wIG92ZXJyaWRlcyBpdA0Kd2l0aCBpdHMgb3duIHZlcnNpb24gZHVyaW5nIGVh
cmx5IGtlcm5lbCBib290Lg0KDQpJbnRlbCBUcnVzdGVkIERvbWFpbiBFeHRlbnNpb25zIChURFgp
IGRvZXNuJ3QgcGxheSBuaWNlIHdpdGggQUNQSSBTMy4NCkFDUEkgUzMgc3VzcGVuZCB3aWxsIGdl
dHMgZGlzYWJsZWQgZHVyaW5nIGtlcm5lbCBlYXJseSBib290IGlmIFREWCBpcw0KZW5hYmxlZC4N
Cg0KQWRkIGEgaGVscGVyIGZ1bmN0aW9uIHRvIG92ZXJyaWRlIHRoZSBhY3BpX3N1c3BlbmRfbG93
bGV2ZWwgYXQga2VybmVsDQplYXJseSBib290LCBzbyB0aGF0IHRoZSBjYWxsZXJzIGRvbid0IG1h
bmlwdWxhdGUgdGhlIGZ1bmN0aW9uIHBvaW50ZXINCmRpcmVjdGx5LiAgQ2hhbmdlIHRoZSBYZW4g
Y29kZSB0byB1c2UgdGhlIGhlbHBlci4gIEl0IHdpbGwgYmUgdXNlZCBieQ0KVERYIGNvZGUgdG8g
ZGlzYWJsZSBBQ1BJIFMzIHN1c3BlbmQgdG9vLg0KDQpObyBmdW5jdGlvbmFsIGNoYW5nZSBpcyBp
bnRlbmRlZC4NCg0KU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29t
Pg0KLS0tDQogYXJjaC94ODYvaW5jbHVkZS9hc20vYWNwaS5oIHwgMyArKysNCiBhcmNoL3g4Ni9r
ZXJuZWwvYWNwaS9ib290LmMgfCA1ICsrKysrDQogaW5jbHVkZS94ZW4vYWNwaS5oICAgICAgICAg
IHwgMiArLQ0KIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hY3BpLmggYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9hY3BpLmgNCmluZGV4IGM4YTdmYzIzZjYzYy4uNjAwMWRmODc1MjZlIDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vYWNwaS5oDQorKysgYi9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9hY3BpLmgNCkBAIC02Myw2ICs2Myw5IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBhY3Bp
X2Rpc2FibGVfcGNpKHZvaWQpDQogLyogTG93LWxldmVsIHN1c3BlbmQgcm91dGluZS4gKi8NCiBl
eHRlcm4gaW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2b2lkKTsNCg0KKy8qIFRvIG92ZXJy
aWRlIEBhY3BpX3N1c3BlbmRfbG93bGV2ZWwgYXQgZWFybHkgYm9vdCAqLw0KK3ZvaWQgYWNwaV9z
ZXRfc3VzcGVuZF9sb3dsZXZlbChpbnQgKCpzdXNwZW5kX2xvd2xldmVsKSh2b2lkKSk7DQorDQog
LyogUGh5c2ljYWwgYWRkcmVzcyB0byByZXN1bWUgYWZ0ZXIgd2FrZXVwICovDQogdW5zaWduZWQg
bG9uZyBhY3BpX2dldF93YWtldXBfYWRkcmVzcyh2b2lkKTsNCg0KZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2tlcm5lbC9hY3BpL2Jvb3QuYyBiL2FyY2gveDg2L2tlcm5lbC9hY3BpL2Jvb3QuYw0KaW5k
ZXggMmEwZWEzODk1NWRmLi5mOTg1OGIxMDgzODcgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJu
ZWwvYWNwaS9ib290LmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9hY3BpL2Jvb3QuYw0KQEAgLTc4
NCw2ICs3ODQsMTEgQEAgaW50ICgqYWNwaV9zdXNwZW5kX2xvd2xldmVsKSh2b2lkKSA9DQp4ODZf
YWNwaV9zdXNwZW5kX2xvd2xldmVsOw0KIGludCAoKmFjcGlfc3VzcGVuZF9sb3dsZXZlbCkodm9p
ZCk7DQogI2VuZGlmDQoNCit2b2lkIF9faW5pdCBhY3BpX3NldF9zdXNwZW5kX2xvd2xldmVsKGlu
dCAoKnN1c3BlbmRfbG93bGV2ZWwpKHZvaWQpKQ0KK3sNCisgICAgICAgYWNwaV9zdXNwZW5kX2xv
d2xldmVsID0gc3VzcGVuZF9sb3dsZXZlbDsNCit9DQorDQogLyoNCiAgKiBzdWNjZXNzOiByZXR1
cm4gSVJRIG51bWJlciAoPj0wKQ0KICAqIGZhaWx1cmU6IHJldHVybiA8IDANCmRpZmYgLS1naXQg
YS9pbmNsdWRlL3hlbi9hY3BpLmggYi9pbmNsdWRlL3hlbi9hY3BpLmgNCmluZGV4IGIxZTExODYz
MTQ0ZC4uODFhMWI2ZWU4ZmMyIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS94ZW4vYWNwaS5oDQorKysg
Yi9pbmNsdWRlL3hlbi9hY3BpLmgNCkBAIC02NCw3ICs2NCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9p
ZCB4ZW5fYWNwaV9zbGVlcF9yZWdpc3Rlcih2b2lkKQ0KICAgICAgICAgICAgICAgIGFjcGlfb3Nf
c2V0X3ByZXBhcmVfZXh0ZW5kZWRfc2xlZXAoDQogICAgICAgICAgICAgICAgICAgICAgICAmeGVu
X2FjcGlfbm90aWZ5X2h5cGVydmlzb3JfZXh0ZW5kZWRfc2xlZXApOw0KDQotICAgICAgICAgICAg
ICAgYWNwaV9zdXNwZW5kX2xvd2xldmVsID0geGVuX2FjcGlfc3VzcGVuZF9sb3dsZXZlbDsNCisg
ICAgICAgICAgICAgICBhY3BpX3NldF9zdXNwZW5kX2xvd2xldmVsKHhlbl9hY3BpX3N1c3BlbmRf
bG93bGV2ZWwpOw0KICAgICAgICB9DQogfQ0KICNlbHNlDQotLSANCjIuNDEuMA0KDQoNCg0K
