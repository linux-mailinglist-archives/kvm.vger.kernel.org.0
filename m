Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1173E665167
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 02:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbjAKB6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 20:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbjAKB6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 20:58:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06B3B6B;
        Tue, 10 Jan 2023 17:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673402296; x=1704938296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0eIQt1Ua+gVVmDCT7qzt9m6dj0IlsUGllaXFKX5DxXQ=;
  b=lqVe+WacEzt6xYSAoa1Bp1HNQ22XQzHDHrPIIfTgLfWZLOjRLF2ESCjv
   caw4Wl2EhYzrYxOP2AUsBdtzXDGktD5RsaHtvbiuvUhDVYmZDQMfafKIB
   DrHiMFNKBRFOWK2BnpoiPm0aGxl1KTVmgu9GVWw9J5g+7nyUUek+w/Cf0
   dn+1LNs3GukzY9GfNU/HJxLFRtWc9rtBcGpirmojkVEU89kWhWytVMGkW
   BSTRJFPF+vsNRvl7bN6Fsun9H9NqYiB6ftdv+oNMJgQAMYrEVQWo2MPM+
   C5xOw6FnBa583b7fZojYfW7ZDo/gMCpU+yVHyNgThWPfOd4DUyIJRIdp9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="387769709"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="387769709"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 17:58:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="985978008"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="985978008"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jan 2023 17:58:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 17:58:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 17:58:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 17:58:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kemsxoBwFb+rD4bFeJKSdiRLRK/sjEzQIeEBZVTh5D8Wr+PFDFkikOxmsnUGMGFC2UZ3qQoeUgTpF6GWH6aZT8ER2HAaIY1mji59ZKfDgA0LEuy2I1kgKcb76Hg1wzEVWKAxXAXKTNSSROuGWpcxEBaLUwro3gfxyyn9wWmWPglDURuaMyNnyFooOIsSPjGJhMYGgyYKUFDcOpTL2Z2iYwfvrxyUePMGDJfFUkMCcMDGhLApWjNJs6hLOEyQ953NoBNUCtN9qUXaml1L0Q1qqBzDPgxZHhM/JG893+mkupXivsGQj1UvUlsqLyjzQr0sFMrifZN98jHG16W9jAslaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0eIQt1Ua+gVVmDCT7qzt9m6dj0IlsUGllaXFKX5DxXQ=;
 b=G/KlAJpUwO5eRnwK+Eyd9MTyYWvouZ/52G2HD7hrVj+UxVraMdsMptBwtVcj2NS53CtxAFAjin+TigoeBpRk8f06YzY9RjnvhwebzelkVZv14Z76KlAlyV46EW139hx6Ql4TpHUKewxupCVcNccbYQKuBr5qTLGzqlbPeojdQd7uvzTGV/gv3rlh7+rotYupMOaRbVRqiYDevtZxFxR3Ljnh/vw5nFabBgXpAMDRANMZzTz+79YcwKOWqhtKufJwOSp5fpDnV7ep5Jju3kllC1Azab59iX1bvQdn4ElOM01BNQdTjG9AToIsZWgDD7H+ZyEMicZKUCPzoQM8zBCXaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM8PR11MB5575.namprd11.prod.outlook.com (2603:10b6:8:38::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 01:58:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 01:58:09 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX is
 enabled
Thread-Topic: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX
 is enabled
Thread-Index: AQHZC5gL930dln/hIEKzIGHp1lCBha6SSMqAgAVttoCAAEJpgIAAkweAgAAExACAABhpAA==
Date:   Wed, 11 Jan 2023 01:58:09 +0000
Message-ID: <f46e3846069447793f88ee299144099b0bf76991.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <ee5185e1727c3cd8bd51dbf9fcec95d432100d12.1670566861.git.kai.huang@intel.com>
         <ba0fdee9-148b-b0b9-ecde-2610eff02ba1@intel.com>
         <6f959f494f0fb3dedfa963c3d6a0ce7f395b745d.camel@intel.com>
         <944ffd4b-3090-e068-a649-b9a84add8395@intel.com>
         <b84232220d03889321248ffb82739c64204cc4af.camel@intel.com>
         <c5a08366-ddc2-a26f-fffa-c2b0ac4e45b4@intel.com>
In-Reply-To: <c5a08366-ddc2-a26f-fffa-c2b0ac4e45b4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM8PR11MB5575:EE_
x-ms-office365-filtering-correlation-id: 38f8fe5c-c525-4320-e398-08daf3774a0a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AnzlywBFhM14pzE+btG+IfdLjYaGduxwcbrHgbAfNyjwwhNHSWFBYOewV6BFdWbv8/2OyXqv9+Z979ybI5CqrGu3ob1QNBPfDY7G4mxaCIQaz85rBz+SWzkWZAM4NiEwlcv6dsIv6Ey6Ph3xQ5Bf6gDsyRPwuMlBR3lVM3ORDPUgcRUpArBWgapgUPHsGbNrkk5Tim+ickZfJvTamt+LUvrwP/WlBJCifAMhY5tmNvIUJh1BzAFg4ADX+niia9/2/ARO6hXPP2AZQXBLxbxK5Eojoodjdf3r1r36Nf2zWCeCA/pnrH828ZVsW8xaZDJDlWzZ9glhOGVkag0luzddEXSuct0vIVI3uAh4Gtfr1QJ4q+9AJgKQzE2cfgk67RHYPRvCfrAEQOOvzXrJLA6rGB5Swq4fTnzriox4t9Ppt1zaTYVmsz4g846E9PteAOR3tFXLcSJYU4pzxLqztxnXjr0LdnMMnC890aktBopjZ2TYzoP2AHGtOD/jgRBX0xms/ZOcl3E3xcIpoHyIcovyaoqB533biswVSy/Z8MIZdmdVhh38y6amIoTpD5/NJ9eAxZwgdDyuKPUKO5k5bJvfPYyW4/iqcq97gUwiU2sH2kbbjDBSC3EudBshf+V/AllDg2/QeVXQ1C0tYEdQ2BPH7lSi+/7KTjP37Ba+BFdZCui6KW25bdrJXVhkvPjsanGX62iHwfFzmv6A1F+9EHQnkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199015)(6506007)(82960400001)(38100700002)(122000001)(53546011)(2906002)(6486002)(478600001)(2616005)(7416002)(26005)(186003)(6512007)(71200400001)(5660300002)(316002)(38070700005)(8936002)(36756003)(86362001)(41300700001)(64756008)(8676002)(76116006)(110136005)(66446008)(54906003)(91956017)(66946007)(66556008)(66476007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWtvVEJndHV5alJ4SmxYcDRNVG9hRFZ1elNybzFFZTZRSjZDY0tUQitUcFlP?=
 =?utf-8?B?T21SMm9OeVRzc2o2TUZyOTNUSHVqd0FMNWVHSkc3c0UrQ1hYYys3MElPUkRn?=
 =?utf-8?B?aXVVcmhORDl1MGN6aTdnT2hacjBFUS9FbkwvZ29nT2d4b2h6OFBIck1KYjBr?=
 =?utf-8?B?NDlUYktJUFlPWjRKL1NmN2d3b0VGM1U3bzB2Smh0VThEMWtpdHpQZmFOMitv?=
 =?utf-8?B?MDFzdzQ2Wk1TYkd0SHFoVWEvQTZHbHFrckFHS1hZYVlxbnFVS3hmTmVySTIw?=
 =?utf-8?B?NElMYVlXaGI0aUxGNlNxQXE3ZDF2RE5wY09BL1pMU3h5ZGRTTG1mN1I2QXlO?=
 =?utf-8?B?bUxEalBmcGNWNGR1UlFWaEd5TEdHK2kzd1JHN2QrZzdsY1AwTU5UUmNrNkhk?=
 =?utf-8?B?SGNWaTI3a1c1NHlMWlNEMzNsYURwb1hJbWF3cWU3RkdKT2VYUEt6OHlkZ0R3?=
 =?utf-8?B?SWpSdjVJcjVJK1N6OVhFVFVNZ0s4KzJtMW9IeEh0VGdVV1h1eWhqTlJyT2ZL?=
 =?utf-8?B?RWVxT0U2WnV1YjVYbFdEUkFSTzhiRXNUbUdKK2k2ZThSaFF0WndqWnhsd01X?=
 =?utf-8?B?MnppSlhZd2tnTEF3QUU4MXRrYmk4Z1Y4M3BwcEhCcDJxWGk4dnc0TFEya1Nx?=
 =?utf-8?B?WjgyeU9tcGx1NFZvMk9JNTlVc0tZQ21adFZrdXA1Tk1Eekp5NHFNOG1MeVpJ?=
 =?utf-8?B?YmJjVjU1WDBDS1FNanJXU1BOdDducDE5K3d2T2VpMytneGJ2RjQxcmdvUnRw?=
 =?utf-8?B?U0cxb3VDOS9MdUx6MWllK2RYajZ4Q2R0QXNyeEsyeE95Slk4YXJzUnQxSlp3?=
 =?utf-8?B?RDYxK3hyYTI3eGpjYTZ6eWtQU2RBVjBjeFdPRlhBZlVtMHpUQzRJa2JIS2Ja?=
 =?utf-8?B?YlpBR2FqTE5kQmpuSjNLZk9XbVplZmRQblFLMjJ1YUR1aWI2Y0taSlB3bEtB?=
 =?utf-8?B?VjdzNytlUURhRmR4VTBaZU42d2dHZ2J3TXRicmdqQWRwREFlTFZLRnFxcVZr?=
 =?utf-8?B?ZTlCSGJrVlNWRDh0SkRWL2FTUlJWTC9MT2sraWhrYnRjVkhBbzNUUlFlc0R0?=
 =?utf-8?B?VTZLdUg1YVJyNGlKb205Z0pBQnc2bWg1T0w0MHZ5NDM1MmN3cmNudjl3OUhO?=
 =?utf-8?B?MjZDWEMzeEo5cGpOT2xPb2dFQ1lydjk1UHAwL3MvbWV1OTdGaDVXZ1dxK09k?=
 =?utf-8?B?ZHBCT2ZIalp5STJDVHZPKzNPeUlxdzZtbW94OEhDMGpkL056OGRQME5kT0ZQ?=
 =?utf-8?B?eWxDZlRGYXFQaGM2cEV4Z1AxWjhQTG9YL0Z4Ny83dVpoTUF2UUw5VGo5Z3BI?=
 =?utf-8?B?NkVhVzU1RDNRTVV2QUlzbG0xS2xEckVhWmY2bmJ4ellZaFJweVJTYXFram5n?=
 =?utf-8?B?TWgwZEVFcUo3d1J0cnBxMGdMVXgvUFdZWHZta3RGZkxqR21qQzZVWXJIaW52?=
 =?utf-8?B?dkdIRjIweVpDRStlODRkSW9VblFNNllGYXVqU3pyOHFOWWdobGgyNXhMOXVy?=
 =?utf-8?B?ZFhqZWpLMThhQ1c2SUE3dW9EUDk3ZjNmcXJSUFNTV29ldzFCc3UxWG5PUk1X?=
 =?utf-8?B?NVM2SmlvSVJTLyszMksza0pzaHJFOVAwcEdpR0F6eUU0cjlra3lrdmF3dHVy?=
 =?utf-8?B?ZlFEcGdzZ0RvTUVteG9FVjFVMzh4WFZpRTE2NUZOUENRWU5Id1lCZ1JTTHhO?=
 =?utf-8?B?bEFvQnEraUZGcVBEeHlPd0I3eTJwNG5Ra0J2dG5xakRaS0NzTk9leTFrQ3dG?=
 =?utf-8?B?UTlKWU01MUlySlQwMFhybGNEK2R1UkZENUZQcDV6ejF5M0R2T2lyNmpheUs2?=
 =?utf-8?B?dWVCaW1jK2FBQVZUaEtib3U4Y3Y2QjVhZmVWZmNoc3pxYVphQy82ZWlDc2wy?=
 =?utf-8?B?WEhpYUN4aDNmdGdkTTZJZEpUeVlEekhYemgrZk1xWlhDclZ3Nk4rWlEzL3pw?=
 =?utf-8?B?aTN3ZGc5QUNvSGtHN21aZXNpV1VFcjBMVjFHNEtvTVFpc240QUJqYitoc0J6?=
 =?utf-8?B?ZHBRM3hmU2I5bEJ6T1hPc1dDZVNoTGZCWnpkaGRraWRQUW9ZY1lYZDIyMXQw?=
 =?utf-8?B?VUZXTWN6cFN4TnRMVklXL0lLMHkzaVlLOG1JRXZLZ2RYMG1GckMrTHl5WWZ4?=
 =?utf-8?B?OGxyQ0o4M2Y3TUc5MExPQW1JQXNSTmMzRU9vRUdPOUFTczg3UkJlL2MzRmk4?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFEB55C4137C8946B726895245E51756@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f8fe5c-c525-4320-e398-08daf3774a0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 01:58:09.4763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3eCyYngqrQOzbjWYBBZdQ8CeM84AHZR9jMTefAeQ2ZD2MZwRBynfszxHXLPnsPlFPrHWyToFKs6e/pGRXVoPsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5575
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTEwIGF0IDE2OjMwIC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDEvMTAvMjMgMTY6MTMsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDIzLTAx
LTEwIGF0IDA3OjI3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gLi4uDQo+ID4gPiBUaGlu
ayBhYm91dCBpdCB0aGlzIHdheToga2V4ZWMoKSBpcyBtb2RpZnlpbmcgcGVyc2lzdGVudCAoYWNy
b3NzIGtleGVjKQ0KPiA+ID4gc3RhdGUgdG8gZ2V0IHRoZSBzeXN0ZW0gcmVhZHkgZm9yIHRoZSBu
ZXcga2VybmVsLiAgVGhlIGNhY2hlcyBhcmUNCj4gPiA+IHBlcnNpc3RlbnQgc3RhdGUuICBEZXZp
Y2VzIGhhdmUgcGVyc2lzdGVudCBzdGF0ZS4gIE1lbW9yeSBzdGF0ZSBwZXJzaXN0cw0KPiA+ID4g
YWNyb3NzIGtleGVjKCkuICBUaGUgbWVtb3J5IGludGVncml0eSBtZXRhZGF0YSBwZXJzaXN0cy4N
Cj4gPiA+IA0KPiA+ID4gV2hhdCBwZXJzaXN0ZW50IHN0YXRlIGRvZXMgYSBjb252ZXJzaW9uIHRv
IEtleUlELTAgYWZmZWN0PyAgSXQgcmVzZXRzDQo+ID4gPiB0aGUgaW50ZWdyaXR5IG1ldGFkYXRh
IGFuZCB0aGUgbWVtb3J5IGNvbnRlbnRzLg0KPiA+ID4gDQo+ID4gPiBLZXhlYyBsZWF2ZXMgbWVt
b3J5IGNvbnRlbnRzIGluIHBsYWNlIGFuZCBkb2Vzbid0IHplcm8gdGhlbSwgc28gbWVtb3J5DQo+
ID4gPiBjb250ZW50cyBkb24ndCBtYXR0ZXIuICBUaGUgaW50ZWdyaXR5IG1ldGFkYXRhIGFsc28g
ZG9lc24ndCBtYXR0ZXINCj4gPiA+IGJlY2F1c2UgdGhlIG1lbW9yeSB3aWxsIGJlIHVzZWQgYXMg
S2V5SUQtMCBhbmQgdGhhdCBLZXlJRCBkb2Vzbid0IHJlYWQNCj4gPiA+IHRoZSBpbnRlZ3JpdHkg
bWV0YWRhdGEuDQo+ID4gDQo+ID4gUmlnaHQuICBTbyBJIGd1ZXNzIHdlIGp1c3QgbmVlZCB0byBj
YWxsIG91dCB0aGUgbmV3IGtlcm5lbCB3aWxsIHVzZSBtZW1vcnkgYXMNCj4gPiBLZXlJRC0wPw0K
PiANCj4gTm90IGV2ZW4gdGhhdC4NCj4gDQo+IFNheSB0aGUgbmV3IGtlcm5lbCB3YW50ZWQgdG8g
dXNlIHRoZSBtZW1vcnkgYXMgS2V5SUQtMy4gIFdoYXQgd291bGQgaXQNCj4gZG8/ICBJdCB3b3Vs
ZCAqQVNTVU1FKiB0aGF0IHRoZSBtZW1vcnkgKldBU04nVCogS2V5SUQtMy4gIEl0IHdvdWxkDQo+
IGNvbnZlcnQgaXQgdG8gS2V5SUQtMy4gIFRoYXQgY29udmVyc2lvbiB3b3VsZCB3b3JrIGZyb20g
KmFueSogS2V5SUQuDQo+IA0KPiBTbzoNCj4gDQo+IAlLZXlJRC0wOiBPSywgYmVjYXVzZSBpdCBo
YXMgbm8gaW50ZWdyaXR5IGVuZm9yY2VtZW50DQo+IAlLZXlJRC0xOiBPSywgbmV3IGtlcm5lbCB3
aWxsIGNvbnZlcnQgdGhlIHBhZ2UNCj4gCUtleUlELTI6IE9LLCBuZXcga2VybmVsIHdpbGwgY29u
dmVydCB0aGUgcGFnZQ0KPiAJLi4uDQo+IAlLZXlJRC0kTUFYOiBPSywgbmV3IGtlcm5lbCB3aWxs
IGNvbnZlcnQgdGhlIHBhZ2UNCj4gDQo+IFNvLCAiT0siIGV2ZXJ5d2hlcmUuICBOb3RoaW5nIHRv
IGRvLi4uIGFueXdoZXJlLg0KPiANCj4gRWl0aGVyIEknbSB0b3RhbGx5IG1pc3NpbmcgaG93IHRo
aXMgd29ya3MsIG9yIHlvdSdyZSBkZXNwZXJhdGVseSB0cnlpbmcNCj4gdG8gbWFrZSB0aGlzIG1v
cmUgY29tcGxpY2F0ZWQgdGhhbiBpdCBpcy4NCj4gDQoNCllvdSBhcmUgcmlnaHQuICBUaGUgcGFn
ZSBjb252ZXJzaW9uIG11c3QgZG8gTU9WRElSNjRCIGZpcnN0IGV2ZW4gY29udmVydGluZyB0aGUN
CnBhZ2UgZnJvbSBLZXlJRCAwLiAgSSB3YXMgd3JvbmdseSB0aGlua2luZyB3aGVuIGNvbnZlcnRp
bmcgZnJvbSBLZXlJRCAwIHdlIGRvbid0DQpuZWVkIHRvIGRvIE1PVkRJUjY0Qi4gIE15IGJhZC4N
Cg0KU29ycnkgZm9yIHRoZSBub2lzZS4gIFRoYW5rcyBmb3IgeW91ciB0aW1lLiAgSSdsbCByZW1v
dmUgYWxsIHRob3NlIHN0YWZmLg0K
