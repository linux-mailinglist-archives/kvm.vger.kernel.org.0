Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC58610714
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 03:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbiJ1BIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 21:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJ1BIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 21:08:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE7E72294;
        Thu, 27 Oct 2022 18:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666919314; x=1698455314;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ApP0uDCv40lvxfVrhbSEBEokAW8KkA/LTuo2oXA4aUs=;
  b=QAhcMzh903I6aKUYBH9OTJdqpUQ8CdQY4+/K7a08vq/I3Tn/G+mYNiy0
   vPXuPPFa6fneIxIK55zRDpSnFb7WAW7CKQ66rJYEmSQghThIs4N6B1cZ+
   97X7uUK8Eatzm2eZJnEk25rNfnK6wWIi9NYAWBDOBMudfHJKqX0nfFb2z
   Wzq1JV1/H/hP6OOcKUAt7tphzbxVZRlAqo56IE8lx/ICNrmVjn3LfwFJx
   U8HHkckaB+kM1j2u3Yqg70Hm0Y4yGBJJygEmBqtuU4dlsHscWYcxJIHm1
   x6bljW7VY/fPeO43sYMLowIW3He5Drd+l+y+eQLYQfabCiSlLZwBH/KOu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="335017777"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="335017777"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 18:08:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701556759"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="701556759"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 27 Oct 2022 18:08:33 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:08:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 18:08:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 18:08:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+jX0p4nzFPGQYND3Di/U4DYL46Lr9TzJNgbXg40Rit35DravrbOY7ksWkoPh3axAAfEipvQDCcgvkoZ4Lk4V6zIpPWA9ZPWn/jm0cIQMcvQ4nyG/GrEvL30vyGh/ALBZ0cobnnftSeiv+FtxiBMV43TzG32Lb2rhQglsR2ZdLF7VzvDy8QQt+8rC1UG9XavSBHE1nLZKzzM5YtKjU2v+dIC04yksRW6hIHTsswADzM3hR40i0jZTInnfojbWcXyT4H8jYc4qzox0jECdsBEO78nlj2QdQubVGmHdLnsjqsc6ZHpSe/qT/Q3h1WC/GfZ/D55NLrDbQ/zqu8EJ0sneA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApP0uDCv40lvxfVrhbSEBEokAW8KkA/LTuo2oXA4aUs=;
 b=QIgAnplnl47FKvFi6tfaXWiYPmVJX/3wPC7Pwc9uaHanMZ/Q7BuyGLK0LksH8elC84UTdXe3k4zzX1iEhXtbTf31ev+ghPuTqfOwTPYt6Fx8vsammRo8AUHJUdQpB5FAulYxwqZPiA+J27UW3pK9kXjozfyXmNmSuWYOH5w/Ek0K7/cGj/iAew70R2W6ipsgZTbU0qhBZS/9psZAi1lgDx0oFMawSTsmSx3BP4Bjd0fiyhHVtl0tOv/uWDDMRvjAFy/sCuzyfWiYeKsFwdddsI47rtfp0ES18WYnah58Ywqu8aw5UCMkZK35Z3F1UKAF8FmyNb4vVrt5k05q+L8Gog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6608.namprd11.prod.outlook.com (2603:10b6:510:1b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Fri, 28 Oct
 2022 01:08:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 01:07:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 18/21] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v6 18/21] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHY6Y2lKqD18N61SE24eJl1MAkaR64iLjKAgADSIQA=
Date:   Fri, 28 Oct 2022 01:07:59 +0000
Message-ID: <7e551933cf1b41d39f772f4f06a6912d77eb64b1.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <c88eb1d501abffc5b9181ef0930579871b7fcbff.1666824663.git.kai.huang@intel.com>
         <49a6cf62-547f-0f70-3c40-4d7cc077a5c7@linux.intel.com>
In-Reply-To: <49a6cf62-547f-0f70-3c40-4d7cc077a5c7@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6608:EE_
x-ms-office365-filtering-correlation-id: 713c9671-20c5-4942-24d1-08dab880db1f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nH27DPWFLZR8Yvdz49g8Z9FZwr5pvtbUwpjUi/LaIF0MU0nzrJe/gfCmXiMIk9te6gwT9b/VIrEozX+dbFnAm/je/YyMMXYwqqZ53neJjFSHIKxY0P9iNZZg4ZeQbDv+ex63OtLNjaD9fSm21W/H8Fi5mIj1/2jFsiI+YMWP+HbM9I70+wZYjVRl8HdF7GsU8eBaoYj2Fj7j2amfZ3tppCU/wGPNzCPyFaZrHyb6NHZVrShN1nFgylPfzmLwNK0YX32tqcTcUmdX1cCmFsFnW7JbSDKHsOJHzmXfTT6DhiIxvAnianaXOgqznpGQdAfJQFt7KqwcbfA1G+53F0j59sSK2Zt57GrOfS80pP/Be3sRsShhzzDCnvYE+LP6DPL2R0/PwH8v8DUwxO3TM28+bM7lfr3YzsytpWLEjWcG58mu1ZHA+NSdlT+QBhYiedLsbk++fR9MJ6ELSDbfQmJiLwkCMN8tlS33WgKc1DGv3WlXGg/bnjrdn5gW7PRLHgZGqSLO8LtRoZY70JuJakMo9dZJZMfxASL+QGn4dr/E2fY5QKBMzSZ8wq2Pz183BFmJotpFfFe9lDCKlt+zAlbkLCcADAForohd9igep8Z23Gw5+z60ZlrqE/NgxXjyFSyT3kROR3gRpGDbqw4tUewHowyzp2wRjr+4LQYp2Y0jNs5DlpFEP+JDLr4NQLY++bQyexMdJKwf6cbg28bBCvb8wqyxAazyLbnM5TwfmslppF71s05lDPl61t7QkChyKuHg5iJDxjC/EuiKfoWQ85yrSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(376002)(39860400002)(346002)(451199015)(6486002)(2906002)(110136005)(66476007)(54906003)(5660300002)(41300700001)(8936002)(8676002)(64756008)(66946007)(66556008)(316002)(76116006)(86362001)(66446008)(91956017)(7416002)(4326008)(478600001)(83380400001)(38070700005)(186003)(2616005)(36756003)(26005)(38100700002)(71200400001)(82960400001)(6512007)(6506007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkgzanRQOWlBdzdqcVU1RzczTlhmSllOVzkrYVVuN2N5U3A4Qk0rRWMyYTl1?=
 =?utf-8?B?K3FNdi85WC9SRm9nL3lob2trRzQ1cTVtY3czTzNtYW42WndZdEpJQmJ0UHhs?=
 =?utf-8?B?Y1VUemUrbWxnbkpzTnVQSzBtREo2engzSzNDZWV0SklZUnV2dGlRc1A2TjVK?=
 =?utf-8?B?Zk5hcytPSWNtOFVBbFNYWSsrRjlJYXlZUDFUaWNYaUd2akNHMGpJK3NSWSt2?=
 =?utf-8?B?RXRpOUw0MFBCR3Z3UThIU3k4T2hYR2ZkZWtiNUJ3OVpNWHJ3T0wwdVBWTUY2?=
 =?utf-8?B?V1ROVTR5b0IrRE8yKzVhM2tWbjViWFdtbGVrYldxT0QwSnc0eVRuOHNrV2J1?=
 =?utf-8?B?bGwzVFV6S01qemxhTEdpYnU3alpWK0N3aHg3STNBRlp3c0RPQ21Uc1ducjlZ?=
 =?utf-8?B?N2lMU0ZkYjBTc2NSRWN0Y3YwdERTUnZ4dVBsRWRzN1I3REJBbkVNdzNlZXEr?=
 =?utf-8?B?cWpJblEzWDU5MXpSU1VKNmNid0FEa0M0QWk5OGlKclBDamF0S2tUdUpwTVNL?=
 =?utf-8?B?Z1B4SzNGdUQyd3QxcXFTdTRTOGNldDlLTkQxTy8xckZIQUc1VzFZOHJ4NTBW?=
 =?utf-8?B?SDdiUUtPTWdKWEdxdndkTThaOEY3RHd3OHZFS0ZaeTcyMnFhTlhyNW9lZlZ3?=
 =?utf-8?B?L04reVFnN2NMOENDSFdwYUlyTTU4d1Y0S2Z4bW44OEJ5TmlvUGNmUDZKeXd5?=
 =?utf-8?B?V0RKWERJZ2dVVE9BU2tHLzhMNG81b3BlTzVseVV2VnZVL21Zbk1TRTFyOHI0?=
 =?utf-8?B?ejhhVG4yN3FyNU5FeXc4YkdtT1o2djhpTjVKUkRjTHMvMXVYSlZvKzBteHNQ?=
 =?utf-8?B?emNsbit2cUlzYjRGcFdESVl0cWFickJHZGNzQ3FRVnloMEQ4eWJDS3lGdElh?=
 =?utf-8?B?Y1NXMkttT3BhaFptOFFEZHpSTVZqeDZyOWt1ZEdxUVVseFlUeUdpd3JoRUox?=
 =?utf-8?B?Z0F6UFpoUVIyZWFqMC9JNVdQQmMwdkdaeTlsRlZTVlMzRXJWYVFlZGVYZkN3?=
 =?utf-8?B?V2E0WGIxWGJkcWROMHBMUERQVnlKbTdNTlV2Q1o0TnFvL2xsd1owcnFrTjlN?=
 =?utf-8?B?L3FoTytlRHUvWFZ5cjIyK1VkT1FSTzZTZkNpaDY2VGlUSEZWdG12SStGVzZD?=
 =?utf-8?B?UGFQQUY3U2J6U090aXRPMGhscHpjYktYQWc0SkVTcVowTjY4VVlqY1prcnds?=
 =?utf-8?B?V0VwOHV1S3c0OTM2NXphNEt6S05GZzRkTHlTdWZOOFlHUFBraDJzS242b2th?=
 =?utf-8?B?VHNQZnlXT2hNQmhVcTJGdTh6TE9XV2JHZklzdGJoUGtsYTlVT2xlcmpjT0VG?=
 =?utf-8?B?L3RDK1VHd3NaUjgvaktYOEJGdDduT3loYm0vMzJqZDNYMzNzTkNzaXV4ckpD?=
 =?utf-8?B?WWxpdVF5VmdmV3A4VlJONFhJUC95U1NZaVBjVmswUWdCR3F6dXdOekcyenF6?=
 =?utf-8?B?MXZFaHR1V3NNd1VTc2dnTk45dkJkdmZLWUVsKzZFV29NaFcreXVFajllWVlk?=
 =?utf-8?B?N29KYTg5K3h0ZTAvMExJdlNWNEk3S2FyMGhHMmxaY2NVdmFLSHhwMDZycFJI?=
 =?utf-8?B?ZS9nWXN5RXVqUmN3dGdEclpMR0tsTHJ4MDVCb0RqNVJicmJnK3c5dmJGaU9k?=
 =?utf-8?B?UnUvdkMranBnMHlSM2hMOFhsQURKUUg2WUt3YTc0eFZsd2IwenVjb2FWMHBS?=
 =?utf-8?B?dmZKY0NxNE4za0YxK0ZFZDJOeUJURGF4ZUFhUW9YOGVKdERmZHhZSXNNWHZp?=
 =?utf-8?B?c21NWGlSc2NwSWhrc1dqNlhHbmhxUU04REpIM0tsRy9pWm9VRHhwd0tJSFV0?=
 =?utf-8?B?SzRRVUQvb2hueDlDNS83djc3UkFyUlYyZEQzL1l4clBqSWhkWlJkNks5Uzh3?=
 =?utf-8?B?dUJ5eDY1U1RDb1JYUFk3c0YyalUvSTZROHJyUXdLMSt4YWNFN21Ua2JHbThB?=
 =?utf-8?B?c2Q0bzRneVVEZlhYOVQ0SWE3b2s3dGFpQlFQV3F1WmFEeHdRMUhodnpqeW1L?=
 =?utf-8?B?bHdudmx6UERUOXk2aDQ5WjhuVDgyNkxucWRqZFdYbVpxMDBJd0NGSlpyMVhE?=
 =?utf-8?B?NitOSW9xME13STNBcnp0d1NJM3ptaE9wRXhsakxvN3pyaGlEdWM5ekdlbGlt?=
 =?utf-8?B?Vkw1cUZaL0NCRStIc0E4M1cvNWVNeTZMUVU1NmRBVzFZQUlyS1NEdURqS3BI?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B92B7FC57F0B1349B3AB30E44194DFE8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713c9671-20c5-4942-24d1-08dab880db1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 01:07:59.7610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cpeNtoO5UK45JsmpO1rP/ibskRZ2hKEFAUzJ5eO5/WhmNUX7N0cdLO842n3EhmAh8hOqB/g8frZv2tMdWmYOYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6608
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpUaGFua3MgZm9yIHRoZSByZXZpZXchDQoNCj4gPiAgIA0KPiA+ICsvKg0KPiA+ICsgKiBDYWxs
IG9uZSBTRUFNQ0FMTCBvbiBvbmUgKGFueSkgY3B1IGZvciBlYWNoIHBoeXNpY2FsIHBhY2thZ2Ug
aW4NCj4gPiArICogc2VyaWFsaXplZCB3YXkuICBSZXR1cm4gaW1tZWRpYXRlbHkgaW4gY2FzZSBv
ZiBhbnkgZXJyb3IgaWYNCj4gPiArICogU0VBTUNBTEwgZmFpbHMgb24gYW55IGNwdS4NCj4gDQo+
IA0KPiBJdCdzIG5vdCBjbGVhciB3aGF0IGFyZSB5b3Ugc2VyaWFsaXppbmcgYWdhaW5zdCAoYWdh
aW5zdCBpdHNlbGYgb3Igb3RoZXIgDQo+IGNhbGxzIG9mIHRoaXMgZnVuY3Rpb25zKQ0KPiANCj4g
SSBhc3N1bWUgaXRzIGJlY2F1c2UgdGhlIFREWCBtb2R1bGUgZXJyb3JzIG91dCBmb3IgcGFyYWxs
ZWwgY2FsbHMgDQo+IGluc3RlYWQgb2Ygd2FpdGluZy4NCg0KWWVzLg0KDQo+IA0KPiBUaGUgY29k
ZSBzZWVtcyB0byBvbmx5IGRvIGl0c2VsZiwgc28gd2hlcmUgaXMgdGhlIGNoZWNrIGFnYWluc3Qg
b3RoZXJzPyANCj4gSSBhc3N1bWUgaW4gdGhlIGNhbGxlcnMgYnV0IHRoYXQgd291bGQgbmVlZCB0
byBiZSBleHBsYWluZWQuwqANCj4gDQoNClllcyBpbiB0aGUgY2FsbGVycy4gIEluIHNob3J0IHRo
ZXJlJ3Mgbm8gbmVlZCwgb3IgaXQgZG9lc24ndCBtYWtlIHNlbnNlIHRvIGNoZWNrDQphZ2FpbnN0
IG90aGVycyBhcyBTRUFNQ0FMTHMgaW52b2x2ZWQgZHVyaW5nIHRoZSBtb2R1bGUgaW5pdGlhbGl6
YXRpb24gYXJlIG5vdA0Kc3VwcG9zZWQgY2FuIGJlIG1hZGUgaW4gcmFuZG9tLg0KDQo+IEFsc28g
Y291bGQgDQo+IGl0IG5lZWQgc2VyaWFsaXphdGlvbiBhZ2FpbnN0IG90aGVyIGtpbmRzIG9mIHNl
YW0gY2FsbHM/DQoNCg0KVGhlIFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gaXMgZXNzZW50aWFs
bHkgYSBzdGF0ZSBtYWNoaW5lIC0tIGl0IGludm9sdmVzIGENCmNvdXBsZSBvZiBzdGVwcyB0byBm
aW5pc2ggdGhlIHByb2Nlc3MgYW5kIGVhY2ggc3RlcCBtb3ZlcyB0aGUgVERYIG1vZHVsZSdzDQpj
dXJyZW50IHN0YXRlIHRvIGEgbGF0ZXIgc3RhdGUuDQoNCkVhY2ggc3RlcCBpbnZvbHZlcyBhIGRp
ZmZlcmVudCBTRUFNQ0FMTCwgYnV0IHRoaXMgU0VBTUNBTEwgbWF5IGJlIG9ubHkgY2FsbGVkDQpv
bmUgKGFueSkgY3B1LCBvciBuZWVkcyB0byBiZSBjYWxsZWQgZm9yIGFsbCBjcHVzLCBvciBvbmUg
KGFueSkgY3B1IGZvciBlYWNoDQpwYWNrYWdlLg0KDQpUaGUgVERYIG1vZHVsZSBpbml0aWFsaXph
dGlvbiBjb2RlIGRvIHRoZSB3aG9sZSBwcm9jZXNzIHN0ZXAgYnkgc3RlcCwgc28gdGhlDQpjYWxs
ZXIgZ3VhcmFudGVlcyBubyByYW5kb20gU0VBTUNBTExzIHdpbGwgYmUgbWFkZSB3aGVuIGl0IGlz
IGRvaW5nIG9uZSBzdGVwIG9mDQp0aGUgaW5pdGlhbGl6YXRpb24uDQoNCj4gDQo+IFBlcmhhcHMg
aXQgbWlnaHQgYmUgbW9yZSBlZmZpY2llbnQgdG8ganVzdCBicm9hZCBjYXN0IGFuZCBoYW5kbGUg
YSByZXRyeSANCj4gd2l0aCBzb21lIHN5bmNocm9uaXphdGlvbiBpbiB0aGUgbG93IGxldmVsIGNv
ZGUuDQo+IA0KPiBUaGF0IGxpa2VseSB3b3VsZCBjYXVzZSBsZXNzIHJldmlldyB0aHJhc2ggdGhh
biBqdXN0IHJlaW1wbGVtZW50aW5nIGEgDQo+IGNvbW1vbiBmdW5jdGlvbiBsaWtlIHRoaXMgaGVy
ZS4NCg0KQXMgbWVudGlvbmVkIGFib3ZlIHRoZSB3aG9sZSBpbml0aWFsaXphdGlvbiBwcm9jZXNz
IGlzIGp1c3QgYSBtYWNoaW5lIHN0YXRlLCBzbw0Kbm90IGFsbCBTRUFNQ0FMTHMgYXJlIHN1Ympl
Y3QgdG8gdGhlIGxvZ2ljIG9mIHJldHJ5LiAgVG8gbWUgdGhlIHJldHJ5IG9ubHkgbWFrZXMNCnNl
bnNlIGZvciBvbmUgcGFydGljdWxhciBTRUFNQ0FMTCB3aGljaCBtdXN0IGJlIGRvbmUgb24gbXVs
dGlwbGUgY3B1cyBidXQNCnJlcXVpcmVzIHNvbWUgc2VyaWFsaXphdGlvbi4NCg0KRG9lcyBhbGwg
YWJvdmUgbWFrZSBzZW5zZT8NCg==
