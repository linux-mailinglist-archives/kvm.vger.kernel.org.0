Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EFC4EA541
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 04:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiC2CiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 22:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiC2CiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 22:38:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5847D140FD;
        Mon, 28 Mar 2022 19:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648521391; x=1680057391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lz6zY0gGvBsuQZ50O8Aya0Px7CWaNAoLOjuZAtZQN30=;
  b=Qbnq36aXECyaa73HNFobeK2ZtUs/Mo/eDGO4glamC4B07nIAXW9E19kd
   yY7X1UreaMEBAIg2jDqTnlsWwzVoLnjQK+EWff6DGXlIee9ugDVukK/MN
   PZHbckpAD2+cCXuJzhwSL6SkSeAIHWMBaakwM+75izmuhLdRzTj7mtl1m
   tJzJ5NmueeXJM7eLaQYbRtDwPSWgdv8Z4NFcmzXOWL+PrdTGOwVPGZ9RK
   YLHA4B42vV6C+PC0JqJUcOIJ5hhrvBiEuD0/qK0iRPzEp8vC6BCdjMqNp
   4PYZQ0sxqCYfvsCQj3n6iHHTLx1NkzHL69pVDdac9VK9U99CAJVgntlJ3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="345581254"
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="345581254"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 19:36:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="585408832"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 28 Mar 2022 19:36:30 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 19:36:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 28 Mar 2022 19:36:30 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 28 Mar 2022 19:36:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bq/N/dS15cVG/uBl/lA/Ak8MkGSacx4l7ccdA+UQIiPwB1IUFHj7wE3vAMF+y5+qXJip45iK1CDdGrbymlvMyoGN7NSR5PVGte8neKspJFDnmw7EX0Hh+FU2QDj5DgvJ/bB/z1132M6nbgTQO2oJlgS5silsZHe6CAkAR6GcsHOm6YMuIU4YLOP00IMAw4M+NYg3pjDemQVc3Dz3GFrracXRvEjKpgAsIaBvMGk6YOi17PsuMVjJiLiZ+RCYhSCGXNUNWblO+Dx1JALX3HUJQyZbQJx2yJHTwlpRRSIOpyZcl67VsiOo4E8ky9h0xqeb4nKYjB1R/yY+zWhhAj7Zyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lz6zY0gGvBsuQZ50O8Aya0Px7CWaNAoLOjuZAtZQN30=;
 b=Y4uuRav8wTY1Jf9ZxSx/wtlxGEUbr4HixHG1WA49iMbXVpnaDPLpk3ym3GfNnN8Y4kHvmFpxhlay3TKeuz3n3P77fbTpK4vO3DuJI0MwIsC5eQt2cMKZIaRAqdBPqQwRKC+frKCacAgG1fz8F/OTKuKN/ETd9oiSGNS4lv9YO+Z9QNJMF3EANN/zvuyzMp5vTr0aWnjFYGjmeVSGumA2fZ3jNqBCeYSFR/wHMb6w3USSsO0w9tVUzMAAZFWCJpZZcA4unSeDgu6VtD3Y2VPHwE7ebgorMS7qCV3p96kWQd/mq9J1XpR/qKSpTcKaanMdWp4Ld+ROoViJg3nCwUQUug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4361.namprd11.prod.outlook.com (2603:10b6:5:1df::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 02:36:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 02:36:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gleixner, Thomas" <thomas.gleixner@intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: RE: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Thread-Topic: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Thread-Index: AQHYNsgzm2oe8d+tekOJ9ppfgUsWm6zMfiBAgAeiz4CAAGozsIAAEnGAgAAOOPCAANRagIAAO/Ug
Date:   Tue, 29 Mar 2022 02:36:26 +0000
Message-ID: <BN9PR11MB5276C837FE25BACCD53DB5D58C1E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
         <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
         <a68b378a40310c38f731f4bc7f0a9cc0d89efe92.camel@intel.com>
         <BN9PR11MB52760B743E208684A098B61C8C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
         <b4d97c46c52dbbecc6061f743b172015a73ec189.camel@intel.com>
         <BN9PR11MB52761E8DE55DC8872EC093758C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <8f85e6ad76508e0b7ac8667b1c0b7b3b43d67ef8.camel@intel.com>
In-Reply-To: <8f85e6ad76508e0b7ac8667b1c0b7b3b43d67ef8.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19745e14-cec5-4d08-1ac7-08da112cec4a
x-ms-traffictypediagnostic: DM6PR11MB4361:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <DM6PR11MB43611E96F9CB685E1E45CCC18C1E9@DM6PR11MB4361.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjbh42K2OngVNNSLA0WREpuNWhyJycUENpPnE4N43ffMR540Lv/wTA64Lpidc+fBNkMZSDlnKl0RCATZi3Ddv6+a9EF+Y/BkrdilSTi2FwkuCF4NDEkg15+E9PAzAEMjLsitOLNu/HXatkqQLdGxc9tkWhYeToqy4ggPpgcp64V7DwOmbOiJbq9ZKIMsB4DiURnOqlgwNgw/fR9rnYxze6xuKkWmeRF4CpTs3tFZiXt8/Y/mVZsf7P/shGYIshdo8qLMRlEJsCGrFstGIoy/BicgHGkdgoOn4Q13rvpaY3k0XfIIlJEtBukcJtbba/H3Fo1LyyTf1wlFjbr0vTRKt9cEjpwBOBgpicg/CcL/gkxBCeHY0QPKJn2lqjLNHqAOpjFnDTu45VYZb8qhmVeTX1LRb5GP9sBqNA+VnASPSpHwE1L7gaNRLtXO5vTY/08wL0EXQIiitDhEniXsZQ2uY040px67SxPPk/waqvNp0QE2Lnk0I5x80JbhOTVAwjePL9n+vYmxbLkYj/BRJaIwTgd4g3rpBUCMtjzJYfVrjLgP9h2WkFOWR61UJdLT18254SVAXf3EoIzBWDkFsvl+tGoHqEqHxIC5b0n1ArH33FwDax9WHtbJmoPWqR6+2e5F4NS1e/FKsMbfXgOYkwxSQOEmnUmQR1cH3ReAKp3ioe63NC4L5Kgritg+1ORQYDkfx1b5LFVbfrmpq5g56C/ovg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(5660300002)(83380400001)(122000001)(52536014)(2906002)(26005)(186003)(82960400001)(316002)(7696005)(66946007)(76116006)(6636002)(6506007)(38100700002)(38070700005)(33656002)(54906003)(508600001)(110136005)(66556008)(66476007)(86362001)(9686003)(4326008)(66446008)(64756008)(8676002)(71200400001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2JHWmtDT1MrUTVjdFNXSnlaZGMxb0xKWGJTVFZ5dlpkYnZmV0VLOVFOOGtQ?=
 =?utf-8?B?YjVFa1hmL2ZacjFhT2JlbzF0UHI4Wi9rZ3hFRlZpMDgyenZLVW5oV3JnUmtk?=
 =?utf-8?B?UVQyQmxPWGZzVzRMWGVsVVVsTjVrOGtESnVHYmlnVllkbS9pbk1semsyd3dl?=
 =?utf-8?B?RGg2T29SQWthL2V3NFJWTDhvU01UWTlBYS9jMytsVTAvdTFuOHVJSHgxbS8w?=
 =?utf-8?B?c1ZtcUpOZWg0aUVLVzlaUWRDbWtEeVBjOUhQMWdxRExQS3JRdGFwUFE2MTZZ?=
 =?utf-8?B?YWZuM2JxbG52Wm1ILzZ4K2U0Z1ZnSndPVERmVWYzSHNPY240TlJWbVA2Z0I3?=
 =?utf-8?B?U0c2YjhwYzZlb2hCQ0Vsa1NjbHM5aGNJNmxtdlNvQldRZ1ppY1Z4T1dkZ0FU?=
 =?utf-8?B?Yzg5eTFUU3dNK1MvSTBHcjZiYlZzN1VtZjUxVzIzK2IrSjRyaklCOHh4OGsx?=
 =?utf-8?B?bksxNk0xQjFUbzJXOEZOT05CNndDWmxRT2JNTStma0xHd2twZzVvNnFuUDgv?=
 =?utf-8?B?bTdtZkkzMjRleEdsckpZZDlvYjJWZkFGMGg3UWVJRXBmZjhyMWVKaG5vR3lz?=
 =?utf-8?B?NVZpNEltQ2lCRFNWcS9ZYy9NM1FiY2VnUGluVEZVVUhCVldYTW1iSTE0bVFq?=
 =?utf-8?B?YnhhZVZwa09GajAvanN0ekJ1c3NMRFNMakRvTXpUaTZYSGJSanBuaEpWZ29w?=
 =?utf-8?B?aUxkUDB6M3NyQVNoNWtiL1dSN0RmSFdKZUZLMVVoNWxLTUx2S2NlYWpubzNx?=
 =?utf-8?B?YkVEYVU1SlUxYWt5SjBpWG1hSGR3RnU5d2pKWkNSSmZZV2Q4MzVlRFUzMjdp?=
 =?utf-8?B?L2NaclVhYVNGRXozZGVaVG1scWo3bS95NnIrQkN1S2YrdTNtb1FUellkR09O?=
 =?utf-8?B?U1JXTllSNkRnZTdTT0UzY1FwYlZydW5YcW9qZ2xDOXFnQk1tT2FVbnVWbklu?=
 =?utf-8?B?MEhWWjRTUitTL2ptSm05RnVjYmM4dkNxZXdBdnNUei9zVE1rMnNOY1pqTGlv?=
 =?utf-8?B?UlFaaFQ5ZGpRZ1l2UFgycnV1Qm5Wcy91TDA1NjFkVldXQmxLVjliRW5LUGFs?=
 =?utf-8?B?eTQwWnZSc0hIc0tGTThEZVpWNE1UN0lnTjhyTG5oNk9FYjh5a0FsWE55eGcy?=
 =?utf-8?B?ZlpPMit2ai94NEZEb29oc1pPR1JJcjl2b0RSR3BETTNsZ0pDTU4vbnRqaWZU?=
 =?utf-8?B?K0lwRlQwM3NQakMzU3BnbUdxMVVxUHcveURjRSt2bWF3T1M2akZpeFg4aWJE?=
 =?utf-8?B?ajlVTDc0akdZMDdRZkZ2RXVXSkRsUlRjQzV2cmxvY2ZTOGVmM29SM0p1c3RG?=
 =?utf-8?B?RTBkUm5uSzcrRVJoNWhUUjg2Sm5KVXVNN3QyZG5kNlpPNjlPaUpEdE0vTDFX?=
 =?utf-8?B?dDVwZ3FrQVoweUY5bWUvQy9lS3pIVE5JREVtNGJhdHdWODhvMzhsSlZMaHlE?=
 =?utf-8?B?Yi8wd3RRNlpsM1pRY21nMk0ycTQyZ3NzSE1sWFdvb1RPNDBmYndMekU0SXBO?=
 =?utf-8?B?ZDcvTXNrN1BqM2NKWkxzL3Zra2hhNUpzdWtaY2E1QzAxSjBkSDg4UVFjL1Y4?=
 =?utf-8?B?RVNPR1VDSjNESHVMU2poNEVaaG1kd3BRWUQ0Szk1V3RHQWppdGJjTGduM1Zi?=
 =?utf-8?B?QVN4M3hhai8yOU5VMEE2bUZHZnpZdHJQVFRDQmFrTndyTkZjWjgzY1pDVXJi?=
 =?utf-8?B?aEo1VVNCM2IrZktFSVB1OE5BM0V1ZGtzL1BsT3JzbkRyaVZZY2M3ZlY4ZVVN?=
 =?utf-8?B?SmtKMlo2eUp5ZHpyNWZNVUdsSWhiQlBnb2YydHlFV1NwaHBaWkZ0V2luWkpS?=
 =?utf-8?B?RlRGNDN3ZkRsb08rVEFLc2RlUXdCa1B4V2Z0a2paOU93b3p2NW1raHNwV3Rw?=
 =?utf-8?B?OTBuazVodld0ck85Z1NiWUEycXBPUU4vWER6cTNuSndUc3hPamVrSnZnVGY3?=
 =?utf-8?B?NWZaZ3JZbkZSYlR2aDkxalFCQVNRdGV1SDFBVUFJbjdUVWRxZ3BuWG83bFhs?=
 =?utf-8?B?cFNhSmJyZGpRaS9tV3VEekZoZUs4cXJCVlVUUkxHRFlSVStrZWs0dHh3aHox?=
 =?utf-8?B?VXBucmJPNzY0UERoblFrSlA1WjUwRTQrQTg1bU9aOEFmNEdzM0VrbDFIeWVT?=
 =?utf-8?B?dURQd210MjNQTi92MG42SStYU0dtYkRqU2RoOXhPUzc5WnpheG41OExxN2NE?=
 =?utf-8?B?aVhPb21NN0NTcFl4bElTcEgvditkQVYyRE1KOXRvWFR6Z09UekNDR3dUUnFU?=
 =?utf-8?B?azY2V3pBdjJjRENBSW1ydTNVdE1nclJtM1ZDN0xkQW5tUnE0bzI5eFpBNmY4?=
 =?utf-8?B?MkgrcVM1MWNQcUFGUzRWRm16QkVvMk1qUVc1ckozTXVtTlliSnJvZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19745e14-cec5-4d08-1ac7-08da112cec4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2022 02:36:26.5609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e5Us9/e9cSO3bOz/6TVtGN5CJATJ1IyanCvys2ogJLexLLuy18aUNtZa+QZXo9qAsONduEkdbDlb4bYQkCRodg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4361
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

PiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBNYXJjaCAyOSwgMjAyMiA2OjU1IEFNDQo+IA0KPiBPbiBUdWUsIDIwMjItMDMtMjkgYXQgMDA6
NDcgKzEzMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gPiA+IFNlbnQ6IE1vbmRheSwgTWFyY2ggMjgsIDIwMjIgNToy
NCBQTQ0KPiA+ID4gPg0KPiA+ID4gPiBjcHVfcHJlc2VudF9tYXNrIGRvZXMgbm90IGFsd2F5cyBy
ZXByZXNlbnQgQklPUy1lbmFibGVkIENQVXMgZHVlDQo+ID4gPiA+IHRvIHRob3NlIGJvb3Qgb3B0
aW9ucy4gVGhlbiB3aHkgZG8gd2UgY2FyZSB3aGV0aGVyIENQVXMgaW4gdGhpcyBtYXNrDQo+ID4g
PiA+IChpZiBvbmx5IHJlcHJlc2VudGluZyBhIHN1YnNldCBvZiBCSU9TLWVuYWJsZWQgQ1BVcykg
YXJlIGF0IGxlYXN0DQo+IGJyb3VnaHQNCj4gPiA+ID4gdXAgb25jZT8gSXQgd2lsbCBmYWlsIGF0
IFRESC5TWVMuQ09ORklHIGFueXdheS4NCj4gPiA+DQo+ID4gPiBBcyBJIHNhaWQsIHRoaXMgaXMg
dXNlZCB0byBtYWtlIHN1cmUgU0VBTVJSIGhhcyBiZWVuIGRldGVjdGVkIG9uIGFsbCBjcHVzLA0K
PiA+ID4gc28NCj4gPiA+IHRoYXQgYW55IEJJT1MgbWlzY29uZmlndXJhdGlvbiBvbiBTRUFNUlIg
aGFzIGJlZW4gZGV0ZWN0ZWQuDQo+IE90aGVyd2lzZSwNCj4gPiA+IHNlYW1ycl9lbmFibGVkKCkg
bWF5IG5vdCBiZSByZWxpYWJsZSAodGhlb3JldGljYWxseSkuDQo+ID4NCj4gPiAqYWxsIGNwdXMq
IGlzIHF1ZXN0aW9uYWJsZS4NCj4gPg0KPiA+IFNheSBCSU9TIGVuYWJsZWQgOCBDUFVzOiBbMCAt
IDddDQo+ID4NCj4gPiBjcHVfcHJlc2VudF9tYXAgY292ZXJzIFswIC0gNV0sIGR1ZSB0byBucl9j
cHVzPTYNCj4gPg0KPiA+IFlvdSBjb21wYXJlZCBjcHVzX2Jvb3RlZF9vbmNlX21hc2sgdG8gY3B1
X3ByZXNlbnRfbWFzayBzbyBpZg0KPiBtYXhjcHVzDQo+ID4gaXMgc2V0IHRvIGEgbnVtYmVyIDwg
bnJfY3B1cyBTRUFNUlIgaXMgY29uc2lkZXJlZCBkaXNhYmxlZCBiZWNhdXNlIHlvdQ0KPiA+IGNh
bm5vdCB2ZXJpZnkgQ1BVcyBiZXR3ZWVuIFttYXhfY3B1cywgbnJfY3B1cykuDQo+IA0KPiBTRUFN
UlIgaXMgbm90IGNvbnNpZGVyZWQgYXMgZGlzYWJsZWQgaW4gdGhpcyBjYXNlLCBhdCBsZWFzdCBp
biBteSBpbnRlbnRpb24uDQoNCnRoZSBmdW5jdGlvbiBpcyBjYWxsZWQgc2VhbXJyX2VuYWJsZWQo
KSwgYW5kIGZhbHNlIGlzIHJldHVybmVkIGlmIGFib3ZlDQpjaGVjayBpcyBub3QgcGFzc2VkLiBT
byBpdCBpcyB0aGUgaW50ZW50aW9uIGZyb20gdGhlIGNvZGUuDQoNCj4gTXkNCj4gdW5kZXJzdGFu
ZGluZyBvbiB0aGUgc3BlYyBpcyBpZiBTRUFNUlIgaXMgY29uZmlndXJlZCBhcyBlbmFibGVkIG9u
IG9uZSBjb3JlDQo+ICh0aGUNCj4gU0VBTVJSIE1TUnMgYXJlIGNvcmUtc2NvcGUpLCB0aGUgU0VB
TUNBTEwgaW5zdHJ1Y3Rpb24gY2FuIHdvcmsgb24gdGhhdA0KPiBjb3JlLiAgSXQNCj4gaXMgVERY
J3MgcmVxdWlyZW1lbnQgdGhhdCBzb21lIFNFQU1DQUxMIG5lZWRzIHRvIGJlIGRvbmUgb24gYWxs
IEJJT1MtDQo+IGVuYWJsZWQNCj4gQ1BVcyB0byBmaW5pc2ggVERYIGluaXRpYWxpemF0aW9uLCBi
dXQgbm90IFNFQU0ncy4NCj4gDQo+IEZyb20gdGhpcyBwZXJzcGVjdGl2ZSwgaWYgd2UgZm9yZ2V0
IFREWCBhdCB0aGlzIG1vbWVudCBidXQgdGFsayBhYm91dCBTRUFNDQo+IGFsb25lLCBpdCBtaWdo
dCBtYWtlIHNlbnNlIHRvIG5vdCBqdXN0IHRyZWF0IFNFQU1SUiBhcyBkaXNhYmxlZCBpZiBrZXJu
ZWwNCj4gdXNhYmxlDQo+IGNwdXMgYXJlIGxpbWl0ZWQgYnkgJ25yX2NwdXMnLiAgVGhlIGNoYW5j
ZSB0aGF0IEJJT1MgbWlzY29uZmlndXJlZCBTRUFNUlIgaXMNCj4gcmVhbGx5IHJhcmUuICBJZiBr
ZXJuZWwgY2FuIGRldGVjdCBwb3RlbnRpYWwgQklPUyBtaXNjb25maWd1cmF0aW9uLCBpdCBzaG91
bGQgZG8NCj4gaXQuICBPdGhlcndpc2UsIHBlcmhhcHMgaXQncyBtb3JlIHJlYXNvbmFibGUgbm90
IHRvIGp1c3QgdHJlYXQgU0VBTSBhcw0KPiBkaXNhYmxlZC4NCg0KTXkgcHJvYmxlbSBpcyBqdXN0
IHRoYXQgeW91IGRpZG4ndCBhZG9wdCBjb25zaXN0ZW5jeSBwb2xpY3kgZm9yIENQVXMgaW4NCltt
YXhjcHVzLCBucl9jcHVzKSBhbmQgQ1BVcyBpbiBbbnJfY3B1cywgbnJfYmlvc19lbmFibGVkX2Nw
dXMpLiBUaGlzIGlzDQp0aGUgb25seSB0cm91YmxlIHRvIG1lIG5vIG1hdHRlciB3aGF0IHBvbGlj
eSB5b3Ugd2FudCB0byBwdXJzdWUuLi4NCg0KPiANCj4gDQo+ID4gSWYgZm9sbG93aW5nIHRoZSBz
YW1lDQo+ID4gcmF0aW9uYWxlIHRoZW4geW91IGFsc28gbmVlZCBhIHByb3BlciB3YXkgdG8gZGV0
ZWN0IHRoZSBjYXNlIHdoZXJlDQo+IG5yX2NwdXMNCj4gPiA8IEJJT1MgZW5hYmxlZCBudW1iZXIg
aS5lLiB3aGVuIHlvdSBjYW5ub3QgdmVyaWZ5IFNFQU1SUiBvbiBDUFVzDQo+ID4gYmV0d2VlbiBb
bnJfY3B1cywgN10uIG90aGVyd2lzZSB0aGlzIGNoZWNrIGlzIGp1c3QgaW5jb21wbGV0ZS4NCj4g
Pg0KPiA+IEJ1dCB0aGUgZW50aXJlIGNoZWNrIGlzIGFjdHVhbGx5IHVubmVjZXNzYXJ5LiBZb3Ug
anVzdCBuZWVkIHRvIHZlcmlmeQ0KPiBTRUFNUlINCj4gPiBhbmQgZG8gVERYIGNwdSBpbml0IG9u
IG9ubGluZSBDUFVzLiBBbnkgZ2FwIGJldHdlZW4gb25saW5lIG9uZXMgYW5kIEJJT1MNCj4gPiBl
bmFibGVkIG9uZXMgd2lsbCBiZSBjYXVnaHQgYnkgdGhlIFREWCBtb2R1bGUgYXQgVERILlNZUy5D
T05GSUcgcG9pbnQuDQo+IA0KPiBUaGlzIGlzIGVxdWl2YWxlbnQgdG8gbm90IGhhdmluZyB0aGUg
cGFyYW5vaWQgY2hlY2sgaW4gc2VhbXJyX2VuYWJsZWQoKS4gQnkNCj4gZGV0ZWN0aW5nIFNFQU1S
UiBpbiBpZGVudGlmeV9jcHUoKSwgdGhlIGRldGVjdGlvbiBoYXMgYWxyZWFkeSBiZWVuIGRvbmUg
Zm9yDQo+IGFueQ0KPiBvbmxpbmUgY3B1Lg0KPiANCj4gPg0KPiA+ID4NCj4gPiA+IEFsdGVybmF0
aXZlbHksIEkgdGhpbmsgd2UgY2FuIGFsc28gYWRkIGNoZWNrIHRvIGRpc2FibGUgVERYIHdoZW4N
Cj4gJ21heGNwdXMnDQo+ID4gPiBoYXMNCj4gPiA+IGJlZW4gc3BlY2lmaWVkLCBidXQgSSB0aGlu
ayB0aGUgY3VycmVudCB3YXkgaXMgYmV0dGVyLg0KPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gYnR3
IHlvdXIgY29tbWVudCBzYWlkIHRoYXQgJ21heGNwdXMnIGlzIGJhc2ljYWxseSBhbiBpbnZhbGlk
IG1vZGUNCj4gPiA+ID4gZHVlIHRvIE1DRSBicm9hZGNhc2UgcHJvYmxlbS4gSSBkaWRuJ3QgZmlu
ZCBhbnkgY29kZSB0byBibG9jayBpdCB3aGVuDQo+ID4gPiA+IE1DRSBpcyBlbmFibGVkLA0KPiA+
ID4NCj4gPiA+IFBsZWFzZSBzZWUgYmVsb3cgY29tbWVudCBpbiBjcHVfc210X2FsbG93ZWQoKToN
Cj4gPiA+DQo+ID4gPiBzdGF0aWMgaW5saW5lIGJvb2wgY3B1X3NtdF9hbGxvd2VkKHVuc2lnbmVk
IGludCBjcHUpDQo+ID4gPiB7DQo+ID4gPiDCoMKgwqDCoMKgwqAuLi4NCj4gPiA+IMKgwqDCoMKg
wqDCoMKgwqAvKg0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgKiBPbiB4ODYgaXQncyByZXF1aXJl
ZCB0byBib290IGFsbCBsb2dpY2FsIENQVXMgYXQgbGVhc3Qgb25jZSBzbw0KPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgKiB0aGF0IHRoZSBpbml0IGNvZGUgY2FuIGdldCBhIGNoYW5jZSB0byBzZXQg
Q1I0Lk1DRSBvbiBlYWNoDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqAqIENQVS4gT3RoZXJ3aXNl
LCBhIGJyb2FkY2FzdGVkIE1DRSBvYnNlcnZpbmcgQ1I0Lk1DRT0wYiBvbg0KPiBhbnkNCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoCogY29yZSB3aWxsIHNodXRkb3duIHRoZSBtYWNoaW5lLg0KPiA+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgKi8NCj4gPiA+IMKgwqDCoMKgwqDCoMKgcmV0dXJuICFjcHVt
YXNrX3Rlc3RfY3B1KGNwdSwgJmNwdXNfYm9vdGVkX29uY2VfbWFzayk7DQo+ID4gPiB9DQo+ID4N
Cj4gPiBJIHNhdyB0aGF0IGNvZGUuIE15IHBvaW50IGlzIG1vcmUgYWJvdXQgeW91ciBzdGF0ZW1l
bnQgdGhhdCBtYXhjcHVzDQo+ID4gaXMgYWxtb3N0IGludmFsaWQgZHVlIHRvIGFib3ZlIHNpdHVh
dGlvbiB0aGVuIHdoeSBkaWRuJ3Qgd2UgZG8gYW55dGhpbmcNCj4gPiB0byBkb2N1bWVudCBzdWNo
IHJlc3RyaWN0aW9uIG9yIHRocm93IG91dCBhIHdhcm5pbmcgd2hlbiBpdCdzDQo+ID4gbWlzY29u
ZmlndXJlZC4uLg0KPiANCj4gVGhlIHNlbnRlbmNlICInbWF4Y3B1cycgaXMgYW4gaW52YWxpZCBv
cGVyYXRpb24gbW9kZSBkdWUgdG8gdGhlIE1DRQ0KPiBicm9hZGNhc3QNCj4gcHJvYmxlbSIgd2Fz
IGZyb20gVGhvbWFzLiAgUGVyaGFwcyBJIHNob3VsZCBub3QganVzdCBwdXQgaXQgaW50byB0aGUN
Cj4gY29tbWVudC4NCj4gDQo+IEFsc28sIFRob21hcyBzdWdnZXN0ZWQ6DQo+IA0KPiAieW91IHNo
b3VsZCBoYXZlIGEgcGFyYW5vaWEgY2hlY2sgd2hpY2ggY2hlY2tzIGZvciB0aGUgbWF4Y3B1cw0K
PiBjb21tYW5kIGxpbmUgcGFyYW1ldGVyIGFuZCBpZiBpdCdzIHRoZXJlIGFuZCBzbWFsbGVyIHRo
YW4gdGhlIG51bWJlciBvZg0KPiBwcmVzZW50IENQVXMgdGhlbiB5b3UganVzdCByZWZ1c2UgdG8g
ZW5hYmxlIFREWC4NCj4gDQo+IEFsdGVybmF0aXZlbHkgeW91IGp1c3QgaGF2ZSBhIHNlcGFyYXRl
IGNwdW1hc2sgdGR4X2F2YWlsYWJlX21hc2sgYW5kDQo+IGtlZXAgdHJhY2sgb2YgdGhlIENQVXMg
d2hpY2ggaGF2ZSBiZWVuIGNoZWNrZWQuIFdoZW4gVERYIGlzIGluaXRpYWxpemVkDQo+IHlvdSB0
aGVuIGNhbiBkbzoNCj4gDQo+ICAgICBpZiAoIWNwdW1hc2tfZXF1YWwoY3B1X3ByZXNlbnRfbWFz
aywgdGR4X2F2YWlsYWJsZV9tYXNrKSkNCj4gICAgIAkgICAgIHJldHVybjsNCj4gIg0KPiANCj4g
SSBmb3VuZCB3ZSBjYW4ganVzdCB1c2UgY3B1c19ib290ZWRfb25jZV9tYXNrLCBpbnN0ZWFkIG9m
DQo+IHRkeF9hdmFpbGFibGVfbWFzaywgc28NCj4gSSB1c2VkIHRoZSBzZWNvbmQgd2F5LiAgQW5k
IGluc3RlYWQgb2YgcHV0dGluZyB0aGUgY2hlY2sgd2hlbiBpbml0aWFsaXppbmcgVERYLA0KPiBJ
IHB1dCB0byBzZWFtcnJfZW5hYmxlZCgpIHNpbmNlIEkgZ3Vlc3MgaXQncyBtb3JlIHJlYXNvbmFi
bGUgdG8gYmUgaGVyZSBhcyB0aGUNCj4gbG9naWMgaXMgdG8gbWFrZSBzdXJlIFNFQU1SUiBoYXMg
YmVlbiBkZXRlY3RlZCBvbiBhbGwgY3B1cy4NCg0KSSdtIG5vdCBzdXJlIHdoZXRoZXIgVGhvbWFz
J3MgY29tbWVudCBqdXN0IHRha2VzIG1heGNwdXMgYXMgYW4gZXhhbXBsZQ0Kd2hpY2ggc2hvdWxk
IGJlIGV4dGVuZGVkIHRvIG90aGVyIGJvb3Qgb3B0aW9ucyBsaWtlIG5yX2NwdXMgb3IgaGUgcmVh
bGx5DQpvbmx5IGNhcmVzIGFib3V0IG1heGNwdXMuIA0KDQo+IA0KPiBIaSBUaG9tYXMsDQo+IA0K
PiBJZiB5b3Ugc2VlIHRoaXMsIHNvcnJ5IGZvciBxdW90aW5nIHlvdXIgd29yZHMgaGVyZS4gIEp1
c3Qgd2FudCB0byBoYXZlIGEgYmV0dGVyDQo+IGRpc2N1c3Npb24uICBBbmQgYXBwcmVjaWF0ZSBp
ZiB5b3UgY2FuIGhhdmUgc29tZSBndWlkYW5jZSBoZXJlLg0KPiANCj4gPg0KPiA+ID4NCj4gPiA+
ID4gdGh1cyB3b25kZXIgdGhlIHJhdGlvbmFsZSBiZWhpbmQgYW5kIHdoZXRoZXIgdGhhdA0KPiA+
ID4gPiByYXRpb25hbGUgY2FuIGJlIGJyb3VnaHQgdG8gdGhpcyBzZXJpZXMgKGkuZS4gbm8gY2hl
Y2sgYWdhaW5zdCB0aG9zZQ0KPiA+ID4gPiBjb25mbGljdGluZyBib290IG9wdGlvbnMgYW5kIGp1
c3QgbGV0IFNFQU1DQUxMIGl0c2VsZiB0byBkZXRlY3QgYW5kIGZhaWwpLg0KPiA+ID4gPg0KPiA+
ID4gPiBAVGhvbWFzLCBhbnkgZ3VpZGFuY2UgaGVyZT8NCj4gPiA+ID4NCj4gPiA+ID4gVGhhbmtz
DQo+ID4gPiA+IEtldmluDQo+ID4NCg0K
