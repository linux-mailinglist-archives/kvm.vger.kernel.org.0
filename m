Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD3573D1C5
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjFYPip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 11:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjFYPio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 11:38:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC710E47;
        Sun, 25 Jun 2023 08:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687707522; x=1719243522;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ROrA9WwYPaGci78mfsa/l5YJCh+DgPpttDFIzUF99KI=;
  b=BgqNuTV1Xfk4UK1iQ/lms1nk9G4ja+cMDeXSz1TM3qyZMwnWjSNI9iPL
   UWnblroLstzMbvT51Xab9rl5DRtUj2xc4y7soJ63nkJWcPXdYJPP1LKXa
   cGcRfRYrbliMT4Lhws1ywpSKLhy1RsZyjz04k4+YWoIsCb5CClan1UJmX
   8NnpbevSVH3ch2nFC0g2NI5dnLmXH/U0zLkqfp+IFoHI3MvJcQQq89Q3z
   nCB2p79i2w+ksfApRx54hqJ1Y/0QGgzYa0KljFWif9fD9rEBZL8BTpOja
   gDGMazIttSYsgFNcdlkckNFdBNSh/qrw16WKXeforiAEXCfoU2fDocK6b
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="427073693"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="427073693"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 08:38:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="781137307"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="781137307"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 25 Jun 2023 08:38:22 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 25 Jun 2023 08:38:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 25 Jun 2023 08:38:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 25 Jun 2023 08:38:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTPKQgdDq3hH1xf+Q8DkewXsgjlzwmV0ssxmeI3r9FzdGp+pc71/EjFOALKIWlIumurI/cVEsKkseSxn0jBDr2Pi19kPnhivBanJLlQXvvB5JDDwKj/MAuRalQt09/zMxHV6Py3+9HUpIRljnhhW5Jae2c34jKc0ttYguvaWKm1HoGFFQvCaXTPA/ZUoIPfCuo3OgelzuNF2VFynkrKT1gqrXhhqcS0jeVm5T9240hzxOldHMpl84wTS6wfoSmpQs3Uy2AzxWimfsq5/KcV0WRGjSdoywjU1k62X2fXXl5dsyL+PvoYA2w9I7zvg2ndpFtTSNOE1+ZKSNIfvap8gSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROrA9WwYPaGci78mfsa/l5YJCh+DgPpttDFIzUF99KI=;
 b=WIjgc08pOHmLYC0hPPrClvoDDMS6mDVEnFB7CQJ9Z3d8mRj3Jdlxru40qLn2DKCGuJA2NYp5sefPv0//5SqCpEOHgVEooWU6b98nGM0NkwrK1LPTGfSB/e/uv7IUJYOk4cuuf0lo17VUmAwRaOR088NjTqt2e8SU3bHd8xsk7Tf/0xI1nNtYn0Ivyv8f8+3+Fz2Sn27w7oj1Z+kaqcWcgUe0hrVk6b41wzkTNxXMpH7ol5nhWec09NQyOV7U8q5ZWCGBv9OWMmo9Y5pBIkilsgM7UF7YV6MPhmRz9LVGr2yO0t8/AuR6cC9nVwgxshfCOUryDIfb0HIPsjVqzje7Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Sun, 25 Jun
 2023 15:38:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Sun, 25 Jun 2023
 15:38:19 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 12/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v11 12/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHZlu+5q5NS4Kj6PEufTtj99AOoBq+BkvoAgBo1RAA=
Date:   Sun, 25 Jun 2023 15:38:19 +0000
Message-ID: <36ad9d4a1c87d56313f598e57e0d4ac34e7ad089.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <4e108968c3294189ad150f62df1f146168036342.1685887183.git.kai.huang@intel.com>
         <20230608232452.yrx2tekugkvral4z@box>
In-Reply-To: <20230608232452.yrx2tekugkvral4z@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7468:EE_
x-ms-office365-filtering-correlation-id: 727bb11c-baae-4d30-f066-08db75923376
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qgz03Kp+iizhSDmqY272qZg1ijSfmrtsfACWSIif/VgFMM/ZoBXhjttIa8CnydJ969D0Zh+9WuCz9rSbXtn1amSCquEeV2q0opWX91Gx55G6ZbA7HJ1K2jYo9yexkKN3CI3Eojppw/wEMlw5wx0jATSCGJ89SsKh6w0sup1DcTG8pLewAQTapWT7T2ijxkkAbYDY5D5eLIgGxLxMEw2AHtbwzF9VVZDvZRhZoHkgpU/y//FMSLMgIPuLZMmOibeFmTA/1bX/N+f8uhYn1L5ry0AlGnbaE/f1Bfe91V5bu/C3KdJ+Rp3RpmBOFrEXO6JwkOjC70SdqV5AdeIs7PDs0+YZmXeVam0/1FIDBJArpqFvrcnmx0JS9g0LGPulR3raVEt+PcjDx3ygMIQ6lNi1MkJbu8DLCBddnlPI9N/yohJKmnwVP9oDQxqkEhc4Wi0/xuj4wCJKJlX3n3DIrjuhHxxi1xgCPMdy5MuSOo3+KfQ/mearaZNXStUm7Hn7rYkWbgMR4qLWIHqOC2+aWCvQHcj0K6AZcGWPNm9PJGdP2mP4/mrisTalbBctBKjzgtnAgCXHtjgiuRVenl/fCDQstmfcpuqKn2+Bq4nocyx25PqCJKc7qyVyOoA89t7gIiyX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199021)(6512007)(966005)(478600001)(6486002)(71200400001)(54906003)(2616005)(83380400001)(26005)(186003)(6506007)(2906002)(5660300002)(7416002)(36756003)(38100700002)(122000001)(4326008)(66946007)(82960400001)(91956017)(316002)(8936002)(8676002)(41300700001)(86362001)(6916009)(66476007)(66446008)(76116006)(64756008)(38070700005)(66556008)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnQzNU9VQ3dxR1RCVkhaUU16NnhDcExXeGVaZytFWERrUkdYdU9kU25zTTlr?=
 =?utf-8?B?bjczcHB3T01pVG52QWdNWm1VZ3BDOUg5TmZUeHFGSUVtTWJoNGkxcGhrdjdN?=
 =?utf-8?B?RTNsUi9Ud0FhRXExUWxXQjFCbmlEWXBYT0RQckFLb1hSSnZMZ2J4YWc2OEp5?=
 =?utf-8?B?WENJUzRJUVZxZWF2c2Nld3UxdFU0cDRycGhnbk53aDFqZVBVRUNCT3k5WTlN?=
 =?utf-8?B?M2MxUkFmSnNmOVJpRmthaE1GblFWMWFoZmY2eElPMGh6TlQzWmhIUlovZEpr?=
 =?utf-8?B?Z2w5SDc2NmE1enlNT0FkaHE5OGlQaTU3cnFVd2hHdkRwWU9PUHlVZnVWTXNY?=
 =?utf-8?B?R0VtQ3hkM3dxNXVsSE9Ya1BCeTlVSlBJWmxZSEdrNkkwZUptUUZtMXFZRjFO?=
 =?utf-8?B?ZnRVKzBVbTAzbStuOHB2S3FqcHVtTUhZVS9SSzFOQWlaL1JFZysyVm9SdGdY?=
 =?utf-8?B?MSsvV3lKMEZOZDRwbS9PS3pQMXIxRWdReFNkTzB5Sk9sazNDT2plK1lpUzlh?=
 =?utf-8?B?YzZXYlFqOWMwaE10akNhR0ZjMytMMGdjWENtaGZNdlVJbE51SHFOUjZOUnhP?=
 =?utf-8?B?bXIrTnFsL2dPVkNTMGZxVVhSazVmK05sdXNsdGs4ZzRVQ3Q4Tm1rWGpNRHl1?=
 =?utf-8?B?YTQ4M0dCcy9JS2t3Nmw4ck15bHZGT2xuS0NKOC8vZnkwRTN1QmF3Um9vRkpu?=
 =?utf-8?B?WStrY1NlZkhEUXpnZk1wVXZDTWZOOGhocFpMc0RDemVBNklaTUJIaEVpSXEr?=
 =?utf-8?B?S3B1dmo0SUk5OW9SaXJQRFdMRmpaOXVMU3NWYzNzeWRJcEdTTUhhTTVPbUR1?=
 =?utf-8?B?UDBCZWJTUVlhRGJZdm9VVktSYVdLSnJtbURmK25YSFIzdnVia0ZUajdVRGRK?=
 =?utf-8?B?MTJhdjdIR3lUQkhvSWdSNXF6N3RwbXVXaFN2Sjd1cVI0dDMvR1JxY3NUNkQv?=
 =?utf-8?B?NGpLT1FFVGduV0dHVmk5M1dMQVl3dnNTZTNGT0JHSWpEWTVsbzRybWJTK0w0?=
 =?utf-8?B?clptU2dUS2dwV2xjOXJXaFN2YVVRN1NaY25sQ0lxY1pqazJLSGJ0ZHJKOWVu?=
 =?utf-8?B?OGJGVE5GZTlCSUc2Z09CYkxRZFQ5TFYvTTZ2TU5GUDhUNExWOXo5ODI5d2lz?=
 =?utf-8?B?SkhlWDd4UXE3NkxWbzkwc0RoSkxTS20zbjBCWXlPbDhtUk8rOS9RMUlPaCt1?=
 =?utf-8?B?a0doRlFLZVlZVVRsWHE5MldqS3NhTW1YZXZPOWNHeUhmT0xHYkMxajY3M2xh?=
 =?utf-8?B?WFhsZUh6c2Y0MjJ5R1VoQXp1dmtPTkNKcm9tVWpGMEJ0Snp1ZVlQNWZwWjRJ?=
 =?utf-8?B?UHhTSW03dDd2Y2dpUEZJN292QjNma3RqQ2N1Yjc5bFdZUzN2cjVzOWFSb0Fx?=
 =?utf-8?B?RXBiTS9mWnlKVzkrOHNlVTF6ejI5WXl0UEZtUlFJSmMxdmhDd09nV2VHUTBR?=
 =?utf-8?B?NVROb1AyMHdWNGw2a2dvZStjTUJOMDk1c3Qrb3Jyc3UzUnBrUXhzVUxoSVoy?=
 =?utf-8?B?aVA5elJOZzA1dFpWSm5GdXRYeXcvSlV1QXJRN1VLVjlMZlExVTRsdG9saE5w?=
 =?utf-8?B?UjRNT2pQdDduYTVjdk5OVSs0RFVVckJkTlJKTFNrZ3pMTmRQY3NmaU1kcCs2?=
 =?utf-8?B?TytVTlFMV2RvQ2p5N0J3bjNIRStJWG1EaHFTbkM0Rk1RcncvdlJ0ekpKVEJm?=
 =?utf-8?B?TEZYM0lOYXV5eFdJUXNWVFlOK2pGQ3ZQUURWRkw4enJCdUZrTDR1V1dsd3FE?=
 =?utf-8?B?MUE3MmVVcm9jVXpXN3BjditXOEdOc255MSszVmtKQ0gxRE8wTXlpaENxYkhJ?=
 =?utf-8?B?cWdIUVpmVm54YjZqYXdXVGFuamVFMWFQeEF1OTUzSlhaTEd5Q2liVUNuSVhk?=
 =?utf-8?B?WGw4UUgwRmR3K0Y0U1J5dmdJeFB2VzBrMHpONEdhbldRUGJxY0FoN2dsSkJm?=
 =?utf-8?B?QmNHTzRYRUtoTkpEd1cvby9SNXQzZDl4TjdXRTNuYjk2eG1HSTNBQjdCVDUy?=
 =?utf-8?B?ZUJWTGVkVHREREg2c0JHSUtGRzM3NDUrVnNEb3gzVUZnQUV1eml0ZW1MRW5M?=
 =?utf-8?B?bWY1cUJrRkVKQStHRDREbmpScFloU0RUR3lCRWxFZHhLR2l6TkR1MzhxdkpT?=
 =?utf-8?Q?6zel4PlbSwAbW5kmzeQsfwhDk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F37C627A270DFB40B8BB284525419ADE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727bb11c-baae-4d30-f066-08db75923376
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2023 15:38:19.1640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0XypwbSrCwAwteOtamZXCb/zP+C1LUPVkUAuzt+AuH0rPnoIhALrd36QIn4ZKQ13hLhSr5Ifu4uwYQT0aaBTQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7468
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

T24gRnJpLCAyMDIzLTA2LTA5IGF0IDAyOjI0ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMjoyNzoyNUFNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IGluZGV4IGZhOWZh
OGJjNTgxYS4uNWYwNDk5YmE1ZDY3IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IEBA
IC0yNjUsNyArMjY1LDcgQEAgc3RhdGljIGludCB0ZHhfZ2V0X3N5c2luZm8oc3RydWN0IHRkc3lz
aW5mb19zdHJ1Y3QgKnN5c2luZm8sDQo+ID4gICAqIG92ZXJsYXAuDQo+ID4gICAqLw0KPiA+ICBz
dGF0aWMgaW50IGFkZF90ZHhfbWVtYmxvY2soc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3QsIHVu
c2lnbmVkIGxvbmcgc3RhcnRfcGZuLA0KPiA+IC0JCQkgICAgdW5zaWduZWQgbG9uZyBlbmRfcGZu
KQ0KPiA+ICsJCQkgICAgdW5zaWduZWQgbG9uZyBlbmRfcGZuLCBpbnQgbmlkKQ0KPiA+ICB7DQo+
ID4gIAlzdHJ1Y3QgdGR4X21lbWJsb2NrICp0bWI7DQo+ID4gIA0KPiA+IEBAIC0yNzYsNiArMjc2
LDcgQEAgc3RhdGljIGludCBhZGRfdGR4X21lbWJsb2NrKHN0cnVjdCBsaXN0X2hlYWQgKnRtYl9s
aXN0LCB1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwNCj4gPiAgCUlOSVRfTElTVF9IRUFEKCZ0bWIt
Pmxpc3QpOw0KPiA+ICAJdG1iLT5zdGFydF9wZm4gPSBzdGFydF9wZm47DQo+ID4gIAl0bWItPmVu
ZF9wZm4gPSBlbmRfcGZuOw0KPiA+ICsJdG1iLT5uaWQgPSBuaWQ7DQo+ID4gIA0KPiA+ICAJLyog
QHRtYl9saXN0IGlzIHByb3RlY3RlZCBieSBtZW1faG90cGx1Z19sb2NrICovDQo+ID4gIAlsaXN0
X2FkZF90YWlsKCZ0bWItPmxpc3QsIHRtYl9saXN0KTsNCj4gPiBAQCAtMzAzLDkgKzMwNCw5IEBA
IHN0YXRpYyB2b2lkIGZyZWVfdGR4X21lbWxpc3Qoc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3Qp
DQo+ID4gIHN0YXRpYyBpbnQgYnVpbGRfdGR4X21lbWxpc3Qoc3RydWN0IGxpc3RfaGVhZCAqdG1i
X2xpc3QpDQo+ID4gIHsNCj4gPiAgCXVuc2lnbmVkIGxvbmcgc3RhcnRfcGZuLCBlbmRfcGZuOw0K
PiA+IC0JaW50IGksIHJldDsNCj4gPiArCWludCBpLCBuaWQsIHJldDsNCj4gPiAgDQo+ID4gLQlm
b3JfZWFjaF9tZW1fcGZuX3JhbmdlKGksIE1BWF9OVU1OT0RFUywgJnN0YXJ0X3BmbiwgJmVuZF9w
Zm4sIE5VTEwpIHsNCj4gPiArCWZvcl9lYWNoX21lbV9wZm5fcmFuZ2UoaSwgTUFYX05VTU5PREVT
LCAmc3RhcnRfcGZuLCAmZW5kX3BmbiwgJm5pZCkgew0KPiA+ICAJCS8qDQo+ID4gIAkJICogVGhl
IGZpcnN0IDFNQiBpcyBub3QgcmVwb3J0ZWQgYXMgVERYIGNvbnZlcnRpYmxlIG1lbW9yeS4NCj4g
PiAgCQkgKiBBbHRob3VnaCB0aGUgZmlyc3QgMU1CIGlzIGFsd2F5cyByZXNlcnZlZCBhbmQgd29u
J3QgZW5kIHVwDQo+ID4gQEAgLTMyMSw3ICszMjIsNyBAQCBzdGF0aWMgaW50IGJ1aWxkX3RkeF9t
ZW1saXN0KHN0cnVjdCBsaXN0X2hlYWQgKnRtYl9saXN0KQ0KPiA+ICAJCSAqIG1lbWJsb2NrIGhh
cyBhbHJlYWR5IGd1YXJhbnRlZWQgdGhleSBhcmUgaW4gYWRkcmVzcw0KPiA+ICAJCSAqIGFzY2Vu
ZGluZyBvcmRlciBhbmQgZG9uJ3Qgb3ZlcmxhcC4NCj4gPiAgCQkgKi8NCj4gPiAtCQlyZXQgPSBh
ZGRfdGR4X21lbWJsb2NrKHRtYl9saXN0LCBzdGFydF9wZm4sIGVuZF9wZm4pOw0KPiA+ICsJCXJl
dCA9IGFkZF90ZHhfbWVtYmxvY2sodG1iX2xpc3QsIHN0YXJ0X3BmbiwgZW5kX3BmbiwgbmlkKTsN
Cj4gPiAgCQlpZiAocmV0KQ0KPiA+ICAJCQlnb3RvIGVycjsNCj4gPiAgCX0NCj4gDQo+IA0KPiBU
aGVzZSB0aHJlZSBodW5rcyBhbmQgY2hhbmdlIHRvIHN0cnVjdCB0ZHhfbWVtYmxvY2sgbG9va3Mg
dW5yZWxhdGVkLg0KPiBXaHkgbm90IGZvbGQgdGhpcyB0byAwOS8yMD8NCg0KU29ycnkgSSBtaXNz
ZWQgdG8gcmVwbHkgdGhpcy4NCg0KVGhlIEBuaWQgaXMgdXNlZCB0byB0cnkgdG8gYWxsb2NhdGUg
dGhlIFBBTVQgZnJvbSBsb2NhbCBub2RlLiAgSXQgb25seSBnZXRzIHVzZWQNCmluIHRoaXMgcGF0
Y2guICBPcmlnaW5hbGx5IChpbiB2NykgSSBoYWQgaXQgaW4gcGF0Y2ggMDkgYnV0IERhdmUgc3Vn
Z2VzdGVkIHRvDQptb3ZlIHRvIHRoaXMgcGF0Y2ggKHNlZSB0aGUgZmlyc3QgY29tbWVudCBpbiBi
ZWxvdyBsaW5rKToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC84ZTY4MDNmNS1iZWM2
LTg0M2QtZjNjNC03NTAwNmZmZDBkMmZAaW50ZWwuY29tLw0KDQo+ID4gKw0KPiA+ICsjZGVmaW5l
IFREWF9QU19OUgkoVERYX1BTXzFHICsgMSkNCj4gDQo+IFRoaXMgc2hvdWxkIGJlIG5leHQgdG8g
dGhlIHJlc3QgVERYX1BTXyouDQo+IA0KDQpEb25lLg0KDQo=
