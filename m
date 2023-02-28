Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8026A61BB
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 22:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjB1VtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 16:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjB1VtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 16:49:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BE786A8;
        Tue, 28 Feb 2023 13:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677620956; x=1709156956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eHkKQtmTh2Ys4zTV3zbA//pbB3pGizCCDOm9Py9E5RI=;
  b=fhaM13FnKGRfy3P9NIL0y5a9uAe7IdAz35qe/+GA/b9RxuHQUx0TlKgz
   I9HPCiloKWMUcmUZNFcmDMM3VhnBFxuuOmDnEnDGZPHDGBtnabh8ycnII
   D96id2/hDgMoR+vF8ot2+BD0f+2XzvL+6iJJUhLcjwvDkXA53eP8hhZiC
   edW9yeW0H9RedKZqgwehhs3qxO8MwYGudW3aa7/AXfl4sTDVjHWMTrust
   6uHVNVKEGbMvQ+PgMnKvPBfgqMtBH4hvdbwsJIx2Edi9y7PXe+aCLnwGg
   2iUtj+VXpPk1k5IYDKD3z6J9IScM8UQt8tbmyBrhPUE/jp9XI/lxE0T1P
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="314681154"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="314681154"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 13:49:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="651757588"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="651757588"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 28 Feb 2023 13:49:15 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 13:49:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 13:49:14 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 13:49:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GufZonBL0dKuRC7JK0EjcjDHV1TfmcNBet6lpQbkWYk6htowHDhZcnoimGGrhRNCLd7sdZV+yUlj2KFs5r3ZmX03nX7tO5lccO0AJ4SRHUZDgpdSNEIO0G86ye7N+T/eVaxruVWPvjgEcwhwEX+v74AKGNhCFNbKVzJ17ybHj+nSskPxRo5JTSv7KIzYWEH0eYWHm3b+Rg+8vT6vjlLy9pbKBGMKJhrVX0mKQN/xvTWmicza+ukf8CzCJV3JDjaWfr0P7AH/z7lfMv2hS3keIIscYL/NjpvW7+i5HWabSRRIty7vHbsf5TbhQC6PjZ8wGkwoLhYr7by6GfztLprlFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eHkKQtmTh2Ys4zTV3zbA//pbB3pGizCCDOm9Py9E5RI=;
 b=L80VIb1cyXHJ3V0QOO4RldF9efl2lZvHHnrvENIxudxd8/p8iNAKRFA7AEWtosP69aDY4vDbUIbb7etAymc8U1N4Y13zn6JdW/BJ6ucorK9WioF5z1WfrHanpZwTyuG5IgS6AYAOmeVMilfT4adBGY0pJ5cGjVFx+qtd6iFhMVaybPPkpg7c+LUECXyOpoTO1yOW0eMrdbtuadrxvEIT01EI3WQG5ZsIYq3z4NWqN8BuT8Zd3ciBrN5XSVMzjPmjPlkNwxP7VuZliMUN4pOATKEq+e2eeEriEsgFM1IE7uGftNnwJ0k5567fMj9KA3mb+LDaVkXSy15ICA/GOiJgJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4786.namprd11.prod.outlook.com (2603:10b6:303:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 21:49:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 21:49:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Thread-Topic: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Thread-Index: AQHZJqT+Gmb2zZevo06P/V36G5cIjK6k8UOAgD+K4ACAAAz4gIAAjWEAgAAZMQA=
Date:   Tue, 28 Feb 2023 21:49:10 +0000
Message-ID: <a455c53dc1cdf81790f2996056cdd13cff482d9b.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
         <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
         <20230228110632.GV4175971@ls.amr.corp.intel.com>
         <7dd3b2a9406bdfd574ae12f0f4651e3fe6c4b82a.camel@intel.com>
         <20230228201858.GY4175971@ls.amr.corp.intel.com>
In-Reply-To: <20230228201858.GY4175971@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4786:EE_
x-ms-office365-filtering-correlation-id: 0263b6a4-ae6a-42d6-cd58-08db19d59fe4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xn9upA5nGVrmtFpHpyQh1ztou4bzJeFdcSIAiSqwY/ZOYLL1LPtuUQy+Nv1vLeLaDaVrQU5+LiMgH8eVabxLf8/UlOGIREfr9VHTgwvDrRZsSFifTyQ9KIAWkeZMuhjAAJGu+QVi/8BVBJYaciU6UfttiGYiQDK3aB/Tv3K3wpbeemyYN3BQtSYZuy50O1u1fYk/H79RScBepzqzPJH5btv1gJBYY1J4HkfBSCziYStbrKKb9BRiRmCbugCtofuiskUehiiH8GJvYZ5aN+PKiYkofTO/AsTeHwZBMLi69x1/CzPXIBgprb+SbOl7aCC2pjH/FAoymn21jIROfzteDnbT3vj3CrxW0kgtM0gLit9IBIbA5gNOlDMuj2TO+Y6WZbKjjcIIX5njTCnv1sc4axQgpqaGNimOLgBMXdk+YgNUWdnOnrewbrZJHw+gaS/SaPEMepiSgWe3B3Aa0x42U4FVG5bXR+hus2XxFqqMnNr0MORJjbAVxw0uu1CxrWZjKCtxQnfu/m/7DDG2zN+hJwJJYnJue9juNBylgRp1+bYyIfFYcHR8saVrkDzcalw54dm/Kd9l0KCDXExAiGdg4j8r3dICLm//TRrl+BS8ybeDSBW0lMnnyNOB/JClBJugyk5aOJRFQE8UREOkCNEdOpJrpQXS9w3DA6I6ZCU7dE5MuQqSXcNeneKqLc17hRWYSpfAMn2o/t7G3ZR+p/oUDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(38070700005)(86362001)(41300700001)(64756008)(66476007)(5660300002)(66946007)(66556008)(66446008)(8936002)(6916009)(4326008)(2906002)(36756003)(82960400001)(122000001)(38100700002)(8676002)(71200400001)(6486002)(91956017)(478600001)(54906003)(316002)(83380400001)(76116006)(2616005)(26005)(186003)(6506007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1JMVmJkT1NlNEgrWUxILzRjZzMwc2N2dVhsKzlqeEhqL1BCS0VXWDZ5YVgz?=
 =?utf-8?B?NHhoekc5d3hDYUFEMk9oLzl4dnY0U0VGdVpMNE1RV3Y4SjFVQXp5YmludWhn?=
 =?utf-8?B?N1lDa2FEL2t5MjBBdUxQamR0RzhSWE9OMGttMTBLNmFITHRHYW1rVHc1aDdG?=
 =?utf-8?B?Uy9HOWdnT1M3R2FEUEFxUnk4eDJWb1JSWmRyNGl4VklNYnY0Q0g1Z2lJU1F5?=
 =?utf-8?B?blZMKzdvQytoU1R1SHVhR3JPRDBVTGhac0dJZ0ZrRVg5aUhodkRHc2duNmZo?=
 =?utf-8?B?Y01tS09aY2RQTS9qWjJtdHR6dXlyYXpoZytmeGk5R1NxYUw5ZzNiV3Qza1Vj?=
 =?utf-8?B?b25UZnJoY1lVZCtVZEQ5Y0pDUGRudFI1STh5OWN2c0huaFR3VWdsajFKMlVS?=
 =?utf-8?B?ZUZhanRieHRCYnZ2cmUxK1FmRXlvWVB4VGtadDcwRHFvYjd3OVJwZkI2YjNF?=
 =?utf-8?B?YjZoZlJSVUNxVUx4RGZHZGJCVVhNSkQwTlgrY2xucE9OZ3BaUktKeTcxcmVL?=
 =?utf-8?B?R3NWRmxhZlVwNlBXTWs3Sm92U1F4MG1jcWprZ2Vjay96QTA5S0s5cXhYNWpi?=
 =?utf-8?B?QTRiOGFjMUdSOU1PajEwZUxORlNMRHZUMU5Ga2Q2MEhzRDVpaE83cFRCTG1E?=
 =?utf-8?B?ZGhhOW1kTE5BL0ZkZkQxWUZGTHBPR2xwSzhsemhQSzNxdkJkckVUdDlxSlBZ?=
 =?utf-8?B?M0VkbGNkdGUxelZRbzZvY1lJeDVDbVl0ZWNFRDEzYkt2blZiUGdOZzFFUVEr?=
 =?utf-8?B?RUtSYjZyMWhvQ2NtSkVvb2JBVzk0QlRBMkdUczZhN29aZnJNQnNiM0s3RWFW?=
 =?utf-8?B?WFhhM2pHZ0FKMkhRUjVHTFhTVVhiZFlvUitqdm9TVjBDNHRSM0IyWTBCMThT?=
 =?utf-8?B?a0thRjY2OXA5NUFGMmIzcHMwRERONHZhY1BHeGJBTTZJNFdsS0dTazF3Z01n?=
 =?utf-8?B?WUk4ekRmejlvTTVkVjZxYVBKa05xZlRPcGhSS2lSL0ozVzI5R29kcUtQOEtM?=
 =?utf-8?B?ZmVVWFBPU3ZUK05ZWFJJWWErQWgzdjNlWm1rQmsrbUNLcnFyNGxtL3NjNEtC?=
 =?utf-8?B?WUU5QVBWVmlQdW5iU3hVMnZPMWdPNm9yV0JCVStZVWV3NlJ3OWdXVXR5SHFT?=
 =?utf-8?B?WGtGRkRra0dvZTBhWXJvK1J4NWhLa1dheWVXOEEvUlRZcmgvNDZNVERZQVR0?=
 =?utf-8?B?bURHbUtTTFhJak94SE1oekZpdzNuTU9NT1JxdEtVVEFRUHdxTWI1MDVvTUtQ?=
 =?utf-8?B?YmtpbC9HWG0razNkZVhuVlN2UllMdDdyMjhHUDFyRm1oS24zYS9NdWYycXlE?=
 =?utf-8?B?K0laVW9XNVJBVGxNOTFOdzBKL0ZieTFaVFZiN3ZPMTQ5dWJ0Mmc2ZTdqWUxo?=
 =?utf-8?B?UTJRSk05TUlubXFJZjJJaDdOZmNJYjZPOTRCaTRlTGlrTFlnd1hrRXFCNDJ3?=
 =?utf-8?B?ZC9lanJwdVJndGxWWnphblpZbTU2NGpna0pOL1JRTytrdkhYNTA5aHhvclhv?=
 =?utf-8?B?dHNxTmlNVnB3L3N5U3p6R01KME54QmJldml5Q1Z1Z0JaZlRqcmI5bVgxeFRN?=
 =?utf-8?B?UXJ1TG5PbFdwUWY2RGduc1N5dWhQVlEySDYrekZNNE1OMWdpSjRDc212M2pL?=
 =?utf-8?B?aW5MRS8yTlFLc0VDSXM5NTdqbFN4MEdlUDZmcHRBZFpVQmRRRnNhUXJOWHRC?=
 =?utf-8?B?ZStOQVd2elFOMEd4WVhRVXg3eWVScE5mRGJlV1QydDYvVm0vRzdKVTBiUVJq?=
 =?utf-8?B?ZGE4MmFYakhuK3crTzVDQVk1VTFRcXpvRjhYK0NjQ0ovWUFFNWkvbVMrZWp4?=
 =?utf-8?B?Q1V4R29RVjhOUExwcnBsWWUyK2Z2eHcxOVYvYXBvYnUvZFh4S1JZc2d0emVR?=
 =?utf-8?B?bEMrS0F4anl3QXg4SW5FWUxxZzFFT2dnajlLdEVnSmh1RHh5ejRhNVBVSzRM?=
 =?utf-8?B?RFoxdkg3YXdRSlVmN1RZcWNZRllyelU0TUtveUdXTjlDRy8zZDdUaU9QRmp1?=
 =?utf-8?B?YzlqYkFsMGhiUWVWcHcyYUduT2ZweXBlR0xzNlVkaUpSSVQyYklVWllEUkM5?=
 =?utf-8?B?K3Nsam1uZmVuZXpUcEJDUlFNM0E4Z3RQcWNLbHdFb0lweHpENnBhSy9VSmFv?=
 =?utf-8?B?ZGF2dmtRbEFrUEVwSHVxdXo3OC9DV2J1ZnJ0SjQ5RlJNYnJmaUVXbWc5bUl2?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7251A9FDAD4CA42B452CB9AFE3F332C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0263b6a4-ae6a-42d6-cd58-08db19d59fe4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 21:49:10.4045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hSiMgE5T78kuGLZsed+Zp546S+efwlRY0fyy/89gU/v3z6PlOpXU5wkP21MjU50OSkmdRDnSxp/Cc8DoYBNeVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4786
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTI4IGF0IDEyOjE4IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVHVlLCBGZWIgMjgsIDIwMjMgYXQgMTE6NTI6NTlBTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gVHVlLCAyMDIzLTAy
LTI4IGF0IDAzOjA2IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+ID4gPiArCWlm
ICghZSkNCj4gPiA+ID4gPiArCQlyZXR1cm4gLUVOT01FTTsNCj4gPiA+ID4gPiArCSplwqAgPSAo
c3RydWN0IGt2bV9jcHVpZF9lbnRyeTIpIHsNCj4gPiA+ID4gPiArCQkuZnVuY3Rpb24gPSAxLAkv
KiBGZWF0dXJlcyBmb3IgWDJBUElDICovDQo+ID4gPiA+ID4gKwkJLmluZGV4ID0gMCwNCj4gPiA+
ID4gPiArCQkuZWF4ID0gMCwNCj4gPiA+ID4gPiArCQkuZWJ4ID0gMCwNCj4gPiA+ID4gPiArCQku
ZWN4ID0gMVVMTCA8PCAyMSwJLyogWDJBUElDICovDQo+ID4gPiA+ID4gKwkJLmVkeCA9IDAsDQo+
ID4gPiA+ID4gKwl9Ow0KPiA+ID4gPiA+ICsJdmNwdS0+YXJjaC5jcHVpZF9lbnRyaWVzID0gZTsN
Cj4gPiA+ID4gPiArCXZjcHUtPmFyY2guY3B1aWRfbmVudCA9IDE7DQo+ID4gPiA+IA0KPiA+ID4g
PiBBcyBtZW50aW9uZWQgYWJvdmUsIHdoeSBkb2luZyBpdCBoZXJlPyBXb24ndCBiZSB0aGlzIGJl
IG92ZXJ3cml0dGVuIGxhdGVyIGluDQo+ID4gPiA+IEtWTV9TRVRfQ1BVSUQyPw0KPiA+ID4gDQo+
ID4gPiBZZXMsIHVzZXIgc3BhY2UgVk1NIGNhbiBvdmVyd3JpdGUgY3B1aWRbMHgxXSBhbmQgQVBJ
QyBiYXNlIE1TUi7CoCBCdXQgaXQNCj4gPiA+IGRvZXNuJ3QNCj4gPiA+IG1hdHRlciBiZWNhdXNl
IGl0J3MgYSBidWcgb2YgdXNlciBzcGFjZSBWTU0uIHVzZXIgc3BhY2UgVk1NIGhhcyB0byBrZWVw
IHRoZQ0KPiA+ID4gY29uc2lzdGVuY3kgb2YgY3B1aWQgYW5kIE1TUnMuDQo+ID4gPiBCZWNhdXNl
IFREWCBtb2R1bGUgdmlydHVhbGl6ZXMgY3B1aWRbMHgxXS54MmFwaWMgdG8gZml4ZWQgMSwgS1ZN
IHZhbHVlIGRvZXNuJ3QNCj4gPiA+IG1hdHRlciBhZnRlciB2Y3B1IGNyZWF0aW9uLg0KPiA+ID4g
QmVjYXVzZSBLVk0gdmlydHVhbGl6ZXMgQVBJQyBiYXNlIGFzIHJlYWQgb25seSB0byBndWVzdCwg
Y3B1aWRbMHgxXS54MmFwaWMNCj4gPiA+IGRvZXNuJ3QgbWF0dGVyIGFmdGVyIHZjcHUgY3JlYXRp
b24gYXMgbG9uZyBhcyB1c2VyIHNwYWNlIFZNTSBrZWVwcyBLVk0gQVBJQw0KPiA+ID4gQkFTRQ0K
PiA+ID4gdmFsdWUuDQo+ID4gPiANCj4gPiANCj4gPiBDb250cmFyeSwgY2FuIHdlIGRlcGVuZCBv
biB1c2Vyc3BhY2UgVk1NIHRvIHNldCB4MkFQSUMgaW4gQ1BVSUQsIGJ1dCBub3QgZG8gdGhpcw0K
PiA+IGluIEtWTT8gIElmIHVzZXJzcGFjZSBkb2Vzbid0IGRvIGl0LCB3ZSB0cmVhdCBpdCBhcyB1
c2Vyc3BhY2UncyBidWcuDQo+ID4gDQo+ID4gUGx1cywgdXNlcnNwYWNlIGFueXdheSBuZWVkcyB0
byBzZXQgeDJBUElDIGluIENQVUlEIHJlZ2FyZGxlc3Mgd2hldGhlciB5b3UgaGF2ZQ0KPiA+IGRv
bmUgYWJvdmUgaGVyZSwgY29ycmVjdD8NCj4gPiANCj4gPiBJIGRvbid0IHNlZSB0aGUgcG9pbnQg
b2YgZG9pbmcgYWJvdmUgaW4gS1ZNIGJlY2F1c2UgeW91IGFyZSBuZWl0aGVyIGVuZm9yY2luZw0K
PiA+IGFueXRoaW5nIGluIEtWTSwgbm9yIHlvdSBhcmUgcmVkdWNpbmcgZWZmb3J0IG9mIHVzZXJz
cGFjZS4NCj4gDQo+IEdvb2QgaWRlYS4gSSBjYW4gZHJvcCBjcHVpZCBwYXJ0IGZyb20gdGR4X3Zj
cHVfY3JlYXRlKCkgYW5kIGFwaWMgYmFzZSBwYXJ0IGZyb20NCj4gdGR4X3ZjcHVfcmVzZXQoKS4g
SXQgbmVlZHMgdG8gbW9kaWZ5IHRkeF9oYXNfZW11bGF0ZWRfbXNyKCkgdG8gYWxsb3cgdXNlciBz
cGFjZQ0KPiBWTU0gdG8gdXBkYXRlIEFQSUMgQkFTRSBNU1IuDQoNCk15IHBlcnNvbmFsIHByZWZl
cmVuY2Ugd291bGQgYmU6DQoNCjEpIEluIEtWTV9TRVRfQ1BVSUQyLCB3ZSBkbyBzYW5pdHkgY2hl
Y2sgb2YgQ1BVSURzIHByb3ZpZGVkIGJ5IHVzZXJzcGFjZSwgYW5kDQpyZXR1cm4gZXJyb3IgaWYg
bm90IG1ldCAoaS5lIFgyQVBJQyBpc24ndCBhZHZlcnRpc2VkKS4gIFdlIGFscmVhZHkgaGF2ZSBj
YXNlcw0KdGhhdCBLVk1fU0VUX0NQVUlEMiBjYW4gZmFpbCwgc28gZXh0ZW5kaW5nIHRvIGRvIFRE
WC1zcGVjaWZpYyBjaGVjayBzZWVtcw0KcmVhc29uYWJsZSB0byBtZSB0b28uDQoyKSBGb3IgQVBJ
Q19CQVNFLCB5b3UgY2FuIGp1c3QgaW5pdGlhbGl6ZSB0aGUgTVNSIGluIHRkeF92Y3B1X3Jlc2V0
KCkgYW5kIGlnbm9yZQ0KYW55IHVwZGF0ZSAoK3ByX3dhcm4oKT8pIHRvIE1TUl9JQTMyX0FQSUNf
QkFTRS4NCg0KDQpCdXQgU2VhbiBtYXkgaGF2ZSBkaWZmZXJlbnQgb3BpbmlvbiBlc3BlY2lhbGx5
IGZvciB0aGUgQ1BVSUQgcGFydC4NCg==
