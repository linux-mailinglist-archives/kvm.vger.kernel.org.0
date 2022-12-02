Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFB96406A4
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 13:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiLBMT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 07:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiLBMTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 07:19:06 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD23DD4AE5;
        Fri,  2 Dec 2022 04:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669983535; x=1701519535;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wi48IRAlj8rws7OXian+RqCB7j1U88ZDa1zqvDwWk3c=;
  b=efxfcj8ENLTl62HabsxPfwYVGRFdWPDcoKp8qhazkyrMOt38mK+a9HJu
   8NwQPC3b4flsg8BF9phh6dLgqAxtK94tpPdzNT6Ue3QaA+9GKXW5SulH+
   U/YilEU1S8o0uPetVJ+yxtgFlnOnmWayBtH7x1e92TPvPDOvqmYlXpNcn
   oS8yBgVDIvEKdlrJ8F0M/zC53k/YqnHSajc9YiDqxyh2CksqJIJiLW2vG
   4uZEjpD/5jF/c3LUSclQrPjdD+YD0cViYXvvPX1Q9VkLV1KEGuDuBF98O
   xYn9n5naKm0e9KqxUkierM+dg3Ae3CjTuGbPqBn6Pmdh1zFzzNzhrWA4V
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="303544305"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="303544305"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 04:18:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="677582600"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="677582600"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 02 Dec 2022 04:18:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 04:18:53 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 04:18:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 04:18:52 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 04:18:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+YVQYh8kEpkh1kwsXNoCo2I+ywl9up8yv8Jbv6b/8wuo4rx1p41rPs/n2F0iEoQLrpBQqtWp0XpaX9MGT6+1Nti/kgnBlGYftUtmGq2PdXDSD/KCpN4vkhxIlAIWb4m6RSq5PUzGkBnY9GWox6cP+wjdHeLkRwQndpwVEwmMA56Jw+7BNYzcTCa8NYI9JU24aAdvAsltSwSpGWVM6ZRJ1GmZf9CBjGOpGXZLIbVzCHl+REbemh9IyyJlZdwZ96aazHVhN/uwlGCNgrjRlmbDoAhQOMAUX0en2nKUpgYgqfB5gYBnN7+WX9QzkKH3rD5IpVWLpmAxpFLOkAT66wKCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wi48IRAlj8rws7OXian+RqCB7j1U88ZDa1zqvDwWk3c=;
 b=MxoZ8LXqL2ypwySuP2agnbFi4afD5w3N6PVYoCepM3SrNGxbWnRqEGLTQsMD/5jBDa/6xOsPUs/Mp4xJyYt1PGqxnFGvaO9PMifUhfS7d+rJ9+znXaMCnwrgfNQ9had4fnM+5B+CBkkAfIs2U3VIGsh4HwtEpfLEbWcNojgtC0MWb5pyTX3L9Kvh98Fgt9TjAMUtGCW3KVS1fHbmiAkWO90BDalZ5Hw/Cf+0rm55nWxAxdk+mSIjBNF1LXMYrI9dHlKHvT1OznWIIXRnK5cdg3mGBPShgIO1w/dmtAtKq842t9a5//KR2WgyeNfGQtp91kTHVigHzKc60HOk2rxppg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5061.namprd11.prod.outlook.com (2603:10b6:510:3c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 12:18:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 12:18:49 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "paul@xen.org" <paul@xen.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "anup@brainfault.org" <anup@brainfault.org>
CC:     "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "atishp@atishpatra.org" <atishp@atishpatra.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 35/50] KVM: VMX: Use current CPU's info to perform
 "disabled by BIOS?" checks
Thread-Topic: [PATCH v2 35/50] KVM: VMX: Use current CPU's info to perform
 "disabled by BIOS?" checks
Thread-Index: AQHZBRD6iqD9Xi/jQ0CDB6+2sIzlZa5ahlMA
Date:   Fri, 2 Dec 2022 12:18:49 +0000
Message-ID: <94ced947d0f6a82905afbfe413cf1b6d16fa5fd8.camel@intel.com>
References: <20221130230934.1014142-1-seanjc@google.com>
         <20221130230934.1014142-36-seanjc@google.com>
In-Reply-To: <20221130230934.1014142-36-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5061:EE_
x-ms-office365-filtering-correlation-id: 62133e92-ac4f-42f0-c652-08dad45f5e2c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uxrWgTc450VZbeWbFPvWZQCwS+1pjY08Xt4utqXgK+ImRNq8FpaEOu3OQcjYVZFwUG1be1U5GWwE0GczDYmqjmh1e5HSotKJ+zb0UxjSQxGru+cXtXVZNVabTjccQWvu2kMgZnwyLyfgv1MJkvom/XCE4RypXujnLSDJuOC0UGbNy8lEvrEUlYX2CRIys3LqinyaDTdWJxAPUMEE4QIlVyeE7hjGhB/uZM2ydsjZQOzwkXtWaWFnNiJyoyg+QfQntFbbGMSNZOWRQ4GwQ7rseqTKCM+Q26SK3BDdWgxJVGtHHw5LrwEVdQCG56/PLgQ4pvz6hnJ997bOMwR2YRoZ8VCvMtnywPnS+Dwc1xSSDo9c33VBldOMB7uGxYfT7RqvhMZPliLGVEhDccVtrJk7MP258zIogadjAWtJCB7clPNoNVlPahJtMpMv2OA7qLH7HRibiQnj0reaWB6dNhTfh7EJe+fsUjEW3dPWLlJ082zh456bm2bTCCarQo+H6r9p6YU6gmewFDQCGd2UnrPr1hAAZ9eqbIQzfscojXOiAYemEoUcDfcpkSiE52WgSF101IIhz61+NgACku7Ho1DFC8bvWY0N9AhPyCO6Jd7G6eCis4U3Q0JmEpCYMnoYANWT28OHQUS/J/CTUtWQarfhUciQnlnoGJpgviQ/vdIRiaKzrZtoGp3PU0mz7E3tSUNm7T97LcynK7vVT4TSJbzbDQamHW5IGddVn2z36tp2q2s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(2616005)(110136005)(6486002)(316002)(38070700005)(54906003)(36756003)(921005)(86362001)(107886003)(82960400001)(38100700002)(6506007)(83380400001)(186003)(26005)(122000001)(6512007)(7406005)(4001150100001)(478600001)(2906002)(64756008)(66556008)(66476007)(41300700001)(5660300002)(71200400001)(8936002)(66946007)(76116006)(66446008)(91956017)(7416002)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXpjSks2T2ZVTitRMDJVM05wRUJ3c1p3dUllSzRjWDFWTW1TVFNtWHp6QThF?=
 =?utf-8?B?S2hTMjNuWUdBdVhJS0tPQTdwdzBaQndoSjFqZDFVOGNCeGcwK2p5NUhueE4x?=
 =?utf-8?B?eVRyZVFtdjZoN3ZoMXFDVlNQMEFIdnh5UW10bzgvSGFISkZVTlIwYmF5ZXl6?=
 =?utf-8?B?bm5SZkJxZHBjcUFJMWRHNldTY05QYlpKOGcyaEZtQW50YlcyTDBQdjR3RjY4?=
 =?utf-8?B?N0lmRjROZXNZUGtTcHUxT3p1QThCclp1N3loSnhzTDUyS29jTGZoL0lNNzhr?=
 =?utf-8?B?WGduUFZRVm9KN2pXZW5qcnM0SXArUE5NS0tlU0EybERwajhHQUREUk55ZHM4?=
 =?utf-8?B?ZkxJRHpmTnZ4b3Z2MGtWYllTcTdaQ1FpTE1KRGJjRmdROGhtekxvQWJEMS9V?=
 =?utf-8?B?NzNpV041WGRXd3FZeDVIeHNpcG5yYWNDRjluNXM4UkZVRkpTNkV5TTFUeERm?=
 =?utf-8?B?THRGcDBvVzVjaS95K1MrY2VEK1U4bm9pVUROUlFkcUMyM3U4MWppa3hpZUZZ?=
 =?utf-8?B?NUsydzQ2TkZRVC9TV1FJWE9TWjJBc0JGSTZxZlRIZHJSRUNkMnBwT2Q4b2tB?=
 =?utf-8?B?a0g1UXNzRUNONG0rZFFQTkkzbHNzWG8zUTI0dE15YjJVc0M1VG9TaEZnU3RE?=
 =?utf-8?B?N1ZjUzB0aXN0Z3JoRjMvd1RJR1FwOXZROXMvbHRsdzNPY2dQUXRPNmNpa3o1?=
 =?utf-8?B?YUowSnVGaFVzNVJxemdjeEdhUFVTZ3o1UVNGVDFaQXlVREpvYmw0M3k0R3ZY?=
 =?utf-8?B?aVp3YWh1MkFsYTZOc1BHaGtSMmdmVFU5aTFhVURuWEx6U215VVZDVk8yeW9E?=
 =?utf-8?B?YVBBaEdLcnZwQXhMUHFhcmgwZHhxUG4zMWZYcGFzZkN1amQ4bXFGYkV2RXVz?=
 =?utf-8?B?UG9vZkpPRDVia0ExK0FaOWJRdUN6OUNxTmxWVnhUZHNBSUw1MXVHMXBNL203?=
 =?utf-8?B?Zjc5ZXpCOXFBTTQxKzZsWVBndWVQWldnUGE5YUpxRzF4Rkk0RzlCTDlYTXh1?=
 =?utf-8?B?ODhWSEhHS21MOHhuTU9YYklEMkcwNmtDazJGam5lUjlTcTdJQ0xlTFpTZitS?=
 =?utf-8?B?RStpL052bEIwdkxpMVQ4Y0dJa05pMmtRTEZ1N2EwbVozOVlxcnR2empCTlpm?=
 =?utf-8?B?MmNEYmtMRHVXR3p5aklRWlhOOG9Bdk55Qmp2UnFzVDhDS2FqRmVTd295SWhi?=
 =?utf-8?B?SUM1Wldoa3VxUHRwS0poT0VYS3k5OStTdnNQdVYxdEx1R1puSGk2dFdDODlF?=
 =?utf-8?B?RnJxZmxTaW9kVlQ3MWRTNXhxVVJGNDV0OTJGczJsM0xaeDkxUnJWbG1uclR3?=
 =?utf-8?B?TmhRNzFJVFpPd1lKNld5SFFGeEtmaGZtNFlKSGRXZURvcWZ4RFIzZmZITFo1?=
 =?utf-8?B?YUpkb1EzVzVoSk9rTjQ2VHdSTUZHSSt6YlY2SDFoNlJ4VzFxWFZ0ZTFUbUxM?=
 =?utf-8?B?MWlrVzhtYXpzQy9EV05xWjBDenlaYk81aHgzQzN5emxnMTBiYTdiNGRYNFVW?=
 =?utf-8?B?cTUycFRHbFdtaFphbzRETHBlUWxwSnVPZ3h6U3loYzhPL05PTVdMRnhPUUpp?=
 =?utf-8?B?MkFSVmpXbGd3emNVb3BxajVhVFRDdWJiM0h5ckx1ejFRY0VObko0VnlIdjZL?=
 =?utf-8?B?RlZkUmd3TURwckV5Y2N0UWRpWGlPZXZDY2tJQ2h5c0Z5UFBmZ0tMWHNMWWFH?=
 =?utf-8?B?MG9mMmtjRys5MWdTYlNLbm0zaXRMRXhaSXUreHhXcjJEWXBEZWRGdEx0SmU4?=
 =?utf-8?B?M3FyUTJSOC9EUFIwanhjYkNGdExWeURWNG5hN0o0OGNYWldIc1drMDdpSUZQ?=
 =?utf-8?B?YXVvQmFoRm1WQWJVdGVSWUlIS0tUbUJQQWU5MHZ1YkhMSHN2U3M2OE9yd2ov?=
 =?utf-8?B?SExLNmxDUG1XM25NSUEyNnBCZmtZQnY4WlI5emlwZUdwSHlsMVEwU1lHemx1?=
 =?utf-8?B?RUJobVErcFVSckNsWnlXTWlSRFVBSWxoMTRaN0lWU2RDcFFJd1RzdkIvN2Fo?=
 =?utf-8?B?NzZpMEpUUW1UL3U0VDltamFGdjlFOGhVcjd6NzVqN2ozeFFWT3BuLzRSdit4?=
 =?utf-8?B?Tjhzb0FDS3Znajd5bzd1VHlPck5GTVlJZTBSelAxeVdjemVDSUJDVzBmYXhZ?=
 =?utf-8?B?cEZ4UTdXK01ONEwzQmFtUFdPY1dqb1R6NjNCYU5zRjZQR1N3bW03dEEybkxL?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99D4C9A3D984C2428A927ED5B867F5BF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62133e92-ac4f-42f0-c652-08dad45f5e2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 12:18:49.2695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D8sfVH2lNpgmmjNH3fhelMv0ILsRAGM5Re0l7ofIu3xuYV3WnXzg8Lp2u42wHkephYXX5NDKJAnScO8VqLpPzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5061
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

T24gV2VkLCAyMDIyLTExLTMwIGF0IDIzOjA5ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgdGhpc19jcHVfaGFzKCkgaW5zdGVhZCBvZiBib290X2NwdV9oYXMoKSB0byBw
ZXJmb3JtIHRoZSBlZmZlY3RpdmUNCj4gImRpc2FibGVkIGJ5IEJJT1M/IiBjaGVja3MgZm9yIFZN
WC4gIFRoaXMgd2lsbCBhbGxvdyBjb25zb2xpZGF0aW5nIGNvZGUNCj4gYmV0d2VlbiB2bXhfZGlz
YWJsZWRfYnlfYmlvcygpIGFuZCB2bXhfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCgpLg0KPiANCj4g
Q2hlY2tpbmcgdGhlIGJvb3QgQ1BVIGlzbid0IGEgc3RyaWN0IHJlcXVpcmVtZW50IGFzIGFueSBk
aXZlcmdlbmNlIGluIFZNWA0KPiBlbmFibGluZyBiZXR3ZWVuIHRoZSBib290IENQVSBhbmQgb3Ro
ZXIgQ1BVcyB3aWxsIHJlc3VsdCBpbiBLVk0gcmVmdXNpbmcNCj4gdG8gbG9hZCB0aGFua3MgdG8g
dGhlIGFmb3JlbWVudGlvbmVkIHZteF9jaGVja19wcm9jZXNzb3JfY29tcGF0KCkuDQo+IA0KPiBG
dXJ0aGVybW9yZSwgdXNpbmcgdGhlIGJvb3QgQ1BVIHdhcyBhbiB1bmludGVudGlvbmFsIGNoYW5n
ZSBpbnRyb2R1Y2VkIGJ5DQo+IGNvbW1pdCBhNGQwYjJmZGJjZjcgKCJLVk06IFZNWDogVXNlIFZN
WCBmZWF0dXJlIGZsYWcgdG8gcXVlcnkgQklPUw0KPiBlbmFibGluZyIpLiAgUHJpb3IgdG8gdXNp
bmcgdGhlIGZlYXR1cmUgZmxhZ3MsIEtWTSBjaGVja2VkIHRoZSByYXcgTVNSDQo+IHZhbHVlIGZy
b20gdGhlIGN1cnJlbnQgQ1BVLg0KPiANCj4gUmVwb3J0ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vh
bmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQoNCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jIHwgNCArKy0tDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5j
DQo+IGluZGV4IGU4NTlkMmI3ZGFhNC4uM2Y3ZDlmODhiMzE0IDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni9rdm0vdm14L3ZteC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gQEAg
LTI0OTIsOCArMjQ5Miw4IEBAIHN0YXRpYyBfX2luaXQgaW50IGNwdV9oYXNfa3ZtX3N1cHBvcnQo
dm9pZCkNCj4gIA0KPiAgc3RhdGljIF9faW5pdCBpbnQgdm14X2Rpc2FibGVkX2J5X2Jpb3Modm9p
ZCkNCj4gIHsNCj4gLQlyZXR1cm4gIWJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9NU1JfSUEzMl9G
RUFUX0NUTCkgfHwNCj4gLQkgICAgICAgIWJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9WTVgpOw0K
PiArCXJldHVybiAhdGhpc19jcHVfaGFzKFg4Nl9GRUFUVVJFX01TUl9JQTMyX0ZFQVRfQ1RMKSB8
fA0KPiArCSAgICAgICAhdGhpc19jcHVfaGFzKFg4Nl9GRUFUVVJFX1ZNWCk7DQo+ICB9DQo+ICAN
Cj4gIHN0YXRpYyBpbnQga3ZtX2NwdV92bXhvbih1NjQgdm14b25fcG9pbnRlcikNCg0K
