Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139E26380E5
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 23:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiKXW2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 17:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKXW2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 17:28:53 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6798B8CF06;
        Thu, 24 Nov 2022 14:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669328932; x=1700864932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2ShGfZjSDrChg7lzqHKajAGuLp+6Bp3rWwxJX7Jj0bg=;
  b=SyyFEw3zLrdY2DAl03Xhw2hf4EMBdQhuCsqJavRvBDqwbF6zXJnh+fs3
   7IhkLqq1nIoXGQkC1Hw/o1v3CwqGo/6ALoZnAIhs3jbDQOr1Fymr8/KWf
   KwK+gjgM4wf8cRLkBjAwRaYa8KMHb2FYjvqWiRLDhY3YWt2qm4NW5mW+U
   2G6PpjgqzqhMOXshQPtXoML/Bj4BlPgK5WrTc4R4xJhSL3AAVORcnxuiW
   Fzx4LwuAH3w/Cl2jM6BNiOxOd2FaTTTcReQ9UzK2jMDCjnfQfauBFbTBR
   pRoxHboGaykFhB3sXPQ39gxQJO7d6BioNNSeAzEuPMcZaiPQofwFQ4+a1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="294757023"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="294757023"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 14:28:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="711081636"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="711081636"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 24 Nov 2022 14:28:51 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 14:28:50 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 14:28:50 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 14:28:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuVtYEStJrkmXE5HsoTZoK3gM7m1Ka0uusMGE/GvSNkeQeQS8Idku1cyIoKV46lEXz0l03xflA62+5wVanbtl5nFS3d3itmVDOXOEAIXBrZ1YHQ85hVlS9OAF+QOUw0XcrZOf9aWI8lGRFcHVWQ1e8wIyEQVF8AsofOv1kLYO54SZkAT/3sHmEffEyI5AzjXhODJnXxZ3N/UuoLzCaLvcqt6sxyAmSsrlFvQXf0kNKf+MmNjfJy7hY2pJWrQTD4WKmUt3cK9yMhenhugw+4PzSPrIOzKwC39naU5WQJEo4xhE+BlnPJZQOlcG5kjjrlLYI+bOB/e88KCRPe39mQpjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ShGfZjSDrChg7lzqHKajAGuLp+6Bp3rWwxJX7Jj0bg=;
 b=SgyoX4lD9NligI/Q9SQo5RM/lcY8voii7Twqc5thvTJz2Z0eLAlGy/IYfKdzQ0FHPVU02qx66PfTrnprMsM/3q6iLFHSIP0oT5Mnq6ufJbGdW6v1VTYdsfgQk1lKCUOMwqqOUlFs0LLxeKvGBWsx5AtBBAS/2v3IV5bSmE9xP4sXnyG8ippvs4nVnn1nj2l9SncYP5A+OMbWZQ/kLC3hhmu5uiHiRL6jUlYq7DYZgFGZsfqRNw9AwZ8QBuL4/d5dYP/CPl+YQWTVJUsl9QXfHuWQiqm9g8Z3y2fIxDcadvJJ1bMuadC/5nJN8EFj+W0N2lvD61yKUUkZvpeO7JhXAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB6518.namprd11.prod.outlook.com (2603:10b6:8:d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 22:28:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 22:28:45 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHY/T3LiMVg2HYmLEKsa3j9uYLXLa5NPPqAgAFwwoA=
Date:   Thu, 24 Nov 2022 22:28:45 +0000
Message-ID: <43aa0e78e15acc491ea3ac0db36dedfb6bd38515.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
         <001d826d-a644-37ef-6b6d-729be14fe5ca@intel.com>
In-Reply-To: <001d826d-a644-37ef-6b6d-729be14fe5ca@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB6518:EE_
x-ms-office365-filtering-correlation-id: 4778b10e-4bc1-480e-dd91-08dace6b3ffb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YPklNZpUI43/rwBP/W5dM3/qutL8bx8WJ365JCKidDqh3maN3+xEJ2yMQ94V62p3Z1pXLkHL85n8ddF65VVGOFSZqRvtDHRGsBVRyIHZ1KHSMZXSajNV/TPfKYfbB2wUJ7wBbRpvTAb+cv8N6AcVpg+MzJX+RNUybxriy7tTtughBCGvtGfJkIMBIlgEhAGeC34DpXiyY4n8O0hYCdTAO9rjlrtEGBvKViNw6imxw/rWDjOvXc/MjH2WCFu5/Xyh6PC8uT0atN6T/N+so+0Og8wsPyo37m5rH4aE5rsZRhBBa9SKw1IwfYJy2S2NB+NVgXEm+Q6qLT6v6AXuOhm9QCusYsLSXNOK5ZEMTAwxuy0FWRdWwrNqv4Kg3Jw6TmZFpru5q+RRGjcOiRvumY74fAHvsSmi7h8uHzoU9A9poa5u2Tv+rx1smpnUSOLK8SCKB5p9I51UlhxAgEnBrwGbSX38+R567a8of7RRmK9w5+gMLa1uFDhpFqvxx71yRCaLMRMEJiegNle1TjzUGpv1wbDt8EcF7atD0hqPw3FaZn75BFVUu0/NA3zC8kFGzPbWaR5l9n2JAS0xrd5ltgMc1nn9MYhmQ5W9qsgzwS5LkAi+SoHO48/lV/Q8zW5NESyZJEVK9X0JWO1mEclDun4pUuZZhN7WOvyPbpLJQ2R409QBGGAid1r2V/LoiX4YUAI//6a95EuuTDM7CU/Ce0LlNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(2616005)(186003)(6506007)(6512007)(53546011)(5660300002)(4001150100001)(36756003)(41300700001)(26005)(8936002)(7416002)(38070700005)(316002)(86362001)(54906003)(110136005)(66556008)(66476007)(8676002)(66446008)(66946007)(71200400001)(64756008)(4326008)(6486002)(478600001)(91956017)(76116006)(38100700002)(2906002)(122000001)(83380400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enBHWnlyU2poRHhsNG5EZzA2NjZQRTRTa3ZPNUxMWEVnVWdJdGtuQTFkbXhn?=
 =?utf-8?B?UHYvOXltNWMvaHF2eGh3emFJN0gyQXNHcEw2dUxSUzZaMUFseDhaWWVESGhL?=
 =?utf-8?B?MXdlZXFNaDdNbUN5SkJOVzhNZEhFb1FOTEF4c3VYQUNGOXVrRDN5Wm9jM2l2?=
 =?utf-8?B?S0R5TGFacWdVM0hLT0k5aWZacEJpUm1ZN2FOSU5mdHZyc0xRUEhwSUxtUlVP?=
 =?utf-8?B?L2txTHdSWlhOdkZ5ZWo5L2dyMzV5ajJrL1d6VGpKUS95NFY1TURnQ1dZZGdV?=
 =?utf-8?B?M1J0R3JSaDZRMlQ2VUx0eTdPQitKTERBQlNUMXlwYTlRbGR4T1duVURWVTUx?=
 =?utf-8?B?dVh2S3IvZ1hYcXZxNjFkZUlta1N6NlVYTTQ0NURnZUx3RmhIRnJ0UmtreTdI?=
 =?utf-8?B?bWFyN3NqVS9iY1hYT3ZrUFRtZm90amd2bVRrQ1pJVGNuUE5MSEQwSWRqNjJZ?=
 =?utf-8?B?eXFRTHVkeVc3RWpPeVo4WE94ZEhrUEJKSjcwVmFqeWk4S045d2NRd2toRXE2?=
 =?utf-8?B?dVlOUFFCVUg0WXRHT1BaSngweTZqL0huQmNMaTVMdEowN3RvK0tpYUliTjlK?=
 =?utf-8?B?M1p4OHlhRW5CYys2emdPK1B3LzF1WDJNNUQ3KzErNDdmMHlhd2JSWVIrb2Ix?=
 =?utf-8?B?R2xkQ2QzVzBSZ2RhKzA0VFFRUGRuM0hrR0loZWc5dWRIcXR0RmRZTkI2eVRh?=
 =?utf-8?B?N1pvS3l4Yjh4T0tBYXJpYmZvTEFibzZKeFI0ZE5MT0lGbWJDYi9oaTJFdi9n?=
 =?utf-8?B?cVZVRElMemtEbUQvVy9nem1VZU1SeGpBVERRYXlOcGNzeEtrUkh0Wk1ZcG5u?=
 =?utf-8?B?cW1PZXNNL3J2K1FxZmtlbVlUbitENDlTRkNFUnVKWmN0VzZaKzhTYzRFcFRj?=
 =?utf-8?B?ZTJJQjYyNkxyK1lUbStJR1MxYVR3M1dkV3J0TExXOHdLR0NDM0FPQ2FobnpG?=
 =?utf-8?B?dUhoaVVIWWhTbGpnY2o0Z1ByLzlPcDIrcHN3VWR3RnRNdDByWXZHbkd6NHpz?=
 =?utf-8?B?bldCdnRXNkZ2VklpZGJHM0w3RG13dXpNMEhmMmtDVndUSGRYbVJkV2VVTmRx?=
 =?utf-8?B?SVpVRkdXTENHbHZRS1ZjeUphdHZmdmcrai9KQU9McGNpeStlZ2lpVmVSOG9W?=
 =?utf-8?B?Y2hPYzU3a0dpQ1ltQzlxMWFJZnJuSmxXaS80TEk4bm54eHFhTmJCQndENUtQ?=
 =?utf-8?B?end4QlN5OHpyUWZINjEvc3pJTHNtLytoc21kVzg1NlFOR3AyazBTZHdRQVNE?=
 =?utf-8?B?MTJXL25aVnpyN1kwdEMzSCt3WlQ1Y2sxTG5mRHllZGRpS2hzcHlnNE02MFM0?=
 =?utf-8?B?U0FPUHVXM3hGZ0J5TzdBYU1sd1RPVFpoSUdzNXNxWDNnV1ZQSk0wWXovUTdY?=
 =?utf-8?B?QmVUbG92SFZpYm4zNy9kKzNrK3loNm96VHpadnR1b3FKQTMzTzdQaDVYVy9k?=
 =?utf-8?B?cGpiRXZpNk5PSmxDUXFjSC9SUmV2VEZXQzVBV0pVdjV6MFluNk5UVXllZk5x?=
 =?utf-8?B?NS9BOU1wVzhpZnFrOHRVSHY4Y01xbWs1a09KbysyM042SnZrVnNzVCtIMDls?=
 =?utf-8?B?ZVpuOXkwb2VtSVdHT21NZGZrVDVGZkdVR3NzVVE4L044RzdDZzJvcXJBcjQ5?=
 =?utf-8?B?NFVmaXNER0htTUhoUVZ5WjBnemViTDNGbDhKZHJwNm5QRUNnS1NWVTJMbkkz?=
 =?utf-8?B?NzdFaVVOUW1neWtYZ3dCL1lXYVVWU2IyZUFxdUN4YUk5Ukx6RSt1NitwaWZq?=
 =?utf-8?B?N2E3U3VKZUxyek1oRFI4ci9VcmZ1ZjE3RTdZdWw4VkhLWEtuR0ErOXg4SjZp?=
 =?utf-8?B?OWFjbVB0SlByNDh2YzFzZFNNNHJkbkowaWNsMlJBTy9zSVl2dFMwaWQyazBG?=
 =?utf-8?B?cmVhWTlMUkRlcWU2eTMvM3BVRjJESjZRR2wrei9mNEJSQkcxZ1d3ZllJTmdr?=
 =?utf-8?B?RWtwam5EWmxPRjU2UEszbG9rWkpBVFBtbDkrZW1CcTBmeGh3UXZPVy9LNHVQ?=
 =?utf-8?B?V0VXcExHeHoxL2VvYmRENkIxM1V2MVJFZVdFM2VFVm8yOXhHN25ncGJkRU5S?=
 =?utf-8?B?d3EzSEF3emY5L2JoMzRtME0zS0NDQXl4aU5rVjN4RTI0YXk5eUFxOCtSallN?=
 =?utf-8?B?R2R3WVhDcUMwdGFmbURCNmhSa2hpdEErcTBVeTkyeVc0dWtWeDJ5dG1Yd08x?=
 =?utf-8?B?WEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62F9794C4C9D764DA99D449996E82AE9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4778b10e-4bc1-480e-dd91-08dace6b3ffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 22:28:45.6327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ni7AaR7E4meWiRVJZ7Q8Cf7xleX3ZkDPLEfaQPpFCuvYpgdPQk7Yd3JTOWTqyHE2MMiRbyjJl4GixxCQ8YXeDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6518
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE2OjI4IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiBPbiAxMS8yMC8yMiAxNjoyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiBBZnRlciB0aGUg
YXJyYXkgb2YgVERNUnMgYW5kIHRoZSBnbG9iYWwgS2V5SUQgYXJlIGNvbmZpZ3VyZWQgdG8gdGhl
IFREWA0KPiA+ID4gPiBtb2R1bGUsIHVzZSBUREguU1lTLktFWS5DT05GSUcgdG8gY29uZmlndXJl
IHRoZSBrZXkgb2YgdGhlIGdsb2JhbCBLZXlJRA0KPiA+ID4gPiBvbiBhbGwgcGFja2FnZXMuDQo+
ID4gPiA+IA0KPiA+ID4gPiBUREguU1lTLktFWS5DT05GSUcgbXVzdCBiZSBkb25lIG9uIG9uZSAo
YW55KSBjcHUgZm9yIGVhY2ggcGFja2FnZS4gIEFuZA0KPiA+ID4gPiBpdCBjYW5ub3QgcnVuIGNv
bmN1cnJlbnRseSBvbiBkaWZmZXJlbnQgQ1BVcy4gIEltcGxlbWVudCBhIGhlbHBlciB0bw0KPiA+
ID4gPiBydW4gU0VBTUNBTEwgb24gb25lIGNwdSBmb3IgZWFjaCBwYWNrYWdlIG9uZSBieSBvbmUs
IGFuZCB1c2UgaXQgdG8NCj4gPiA+ID4gY29uZmlndXJlIHRoZSBnbG9iYWwgS2V5SUQgb24gYWxs
IHBhY2thZ2VzLg0KPiA+IA0KPiA+IFRoaXMgaGFzIHRoZSBzYW1lIHByb2JsZW1zIGFzIFNZUy5M
UC5JTklULiAgSXQncyBiYXNpY2FsbHkgc25ha2Ugb2lsIGluDQo+ID4gc29tZSBURFggY29uZmln
dXJhdGlvbnMuDQo+ID4gDQo+ID4gVGhpcyByZWFsbHkgb25seSBuZWVkcyB0byBiZSBkb25lIHdo
ZW4gdGhlIFREWCBtb2R1bGUgaGFzIG1lbW9yeQ0KPiA+IG1hcHBpbmdzIG9uIGEgc29ja2V0IGZv
ciB3aGljaCBpdCBuZWVkcyB0byB1c2UgdGhlICJnbG9iYWwgS2V5SUQiLiDCoA0KPiA+IA0KDQpJ
IHRoaW5rIHNvLg0KDQo+ID4gSWYNCj4gPiB0aGVyZSdzIG5vIFBBTVQgb24gYSBzb2NrZXQsIHRo
ZXJlIGFyZSBwcm9iYWJseSBubyBhbGxvY2F0aW9ucyB0aGVyZSB0bw0KPiA+IHNwZWFrIG9mIGFu
ZCBubyAqdGVjaG5pY2FsKiByZWFzb24gdG8gY2FsbCBUREguU1lTLktFWS5DT05GSUcgb24gdGhh
dA0KPiA+IHNvY2tldC4gIEF0IGxlYXN0IG5vbmUgSSBjYW4gc2VlLg0KDQpSaWdodCBQQU1UIGlz
IHRoZSBtYWluIHVzZXIuIEJlc2lkZXMgUEFNVCwgZWFjaCBURFggZ3Vlc3QgaGFzIGEgIlRydXN0
IERvbWFpbg0KUm9vdCIgKFREUikgcGFnZSwgYW5kIHRoaXMgVERSIHBhZ2UgaXMgYWxzbyBlbmNy
eXB0ZWQgdXNpbmcgdGhlIGdsb2JhbCBLZXlJRC4NCg0KPiA+IA0KPiA+IFNvLCBsZXQncyBjaGVj
ayB1cCBvbiB0aGlzIHJlcXVpcmVtZW50IGFzIHdlbGwuICBUaGlzIGNvdWxkIGFsc28gdHVybg0K
PiA+IG91dCB0byBiZSBhIHJlYWwgcGFpbiBpZiBhbGwgdGhlIENQVXMgb24gYSBzb2NrZXQgYXJl
IG9mZmxpbmUuDQoNClllcyBJJ2xsIGFsc28gY2hlY2suDQoNCj4gPiANCj4gPiA+ID4gSW50ZWwg
aGFyZHdhcmUgZG9lc24ndCBndWFyYW50ZWUgY2FjaGUgY29oZXJlbmN5IGFjcm9zcyBkaWZmZXJl
bnQNCj4gPiA+ID4gS2V5SURzLiAgVGhlIGtlcm5lbCBuZWVkcyB0byBmbHVzaCBQQU1UJ3MgZGly
dHkgY2FjaGVsaW5lcyAoYXNzb2NpYXRlZA0KPiA+ID4gPiB3aXRoIEtleUlEIDApIGJlZm9yZSB0
aGUgVERYIG1vZHVsZSB1c2VzIHRoZSBnbG9iYWwgS2V5SUQgdG8gYWNjZXNzIHRoZQ0KPiA+ID4g
PiBQQU1ULiAgRm9sbG93aW5nIHRoZSBURFggbW9kdWxlIHNwZWNpZmljYXRpb24sIGZsdXNoIGNh
Y2hlIGJlZm9yZQ0KPiA+ID4gPiBjb25maWd1cmluZyB0aGUgZ2xvYmFsIEtleUlEIG9uIGFsbCBw
YWNrYWdlcy4NCj4gPiANCj4gPiBJIHRoaW5rIGl0J3MgcHJvYmFibHkgd29ydGggYW4gYXNpZGUg
aGVyZSBhYm91dCB3aHkgVERYIHNlY3VyaXR5IGlzbid0DQo+ID4gZGVwZW5kZW50IG9uIHRoaXMg
c3RlcC4gIEkgKnRoaW5rKiBpdCBib2lscyBkb3duIHRvIHRoZSBtZW1vcnkgaW50ZWdyaXR5DQo+
ID4gcHJvdGVjdGlvbnMuICBJZiB0aGUgY2FjaGVzIGFyZW4ndCBmbHVzaGVkLCBhIGRpcnR5IEtl
eUlELTAgY2FjaGVsaW5lDQo+ID4gY291bGQgYmUgd3JpdHRlbiBiYWNrIHRvIFJBTS4gIFRoZSBU
RFggbW9kdWxlIHdvdWxkIGNvbWUgYWxvbmcgbGF0ZXIgYW5kDQo+ID4gcmVhZCB0aGUgY2FjaGVs
aW5lIHVzaW5nIEtleUlELXdoYXRldmVyLCBnZXQgYW4gaW50ZWdyaXR5IG1pc21hdGNoLA0KPiA+
IG1hY2hpbmUgY2hlY2ssIGFuZCB0aGVuIGV2ZXJ5b25lIHdvdWxkIGJlIHNhZC4NCj4gPiANCj4g
PiBFdmVyeW9uZSBpcyBzYWQsIGJ1dCBURFggc2VjdXJpdHkgcmVtYWlucyBpbnRhY3QgYmVjYXVz
ZSBtZW1vcnkNCj4gPiBpbnRlZ3JpdHkgc2F2ZWQgdXMuDQo+ID4gDQo+ID4gSXMgaXQgbWVtb3J5
IGludGVncml0eSBvciB0aGUgVEQgYml0LCBhY3R1YWxseT8NCg0KRm9yIHRoaXMgY2FzZSwgSSB0
aGluayBtZW1vcnkgaW50ZWdyaXR5Lg0KDQpUaGUgVEQgYml0IGlzIG1haW5seSB1c2VkIHRvIHBy
ZXZlbnQgaG9zdCBrZXJuZWwgZnJvbSBiZWluZyBhYmxlIHRvIHJlYWQgdGhlDQppbnRlZ3JpdHkg
Y2hlY2tzdW0gKE1BQykgb2YgVEQgbWVtb3J5LCB3aGljaCBjb3VsZCByZXN1bHQgaW4gcG90ZW50
aWFsIGJsdXRlLQ0KZm9yY2UgYXR0YWNrIG9uIHRoZSBNQUMuDQoNClNwZWNpZmljYWxseSwgdGhl
cmUncyBzdWNoIGF0dGFjayB0aGF0OiB0aGUgaG9zdCBrZXJuZWwgY2FuIGVzdGFibGlzaCBhIHNo
YXJlZA0KKG5vbi1URFggcHJpdmF0ZSkgS2V5SUQgbWFwcGluZywgYW5kIHJlcGVhdGVkbHkgdXNl
IGRpZmZlcmVudCBrZXlzIHZpYSB0aGF0DQptYXBwaW5nIHRvIHNwZWN1bGF0aXZlbHkgcmVhZCBU
RFggZ3Vlc3QgbWVtb3J5LiBXL28gdGhlIFREIGJpdCwgdGhlIGhhcmR3YXJlDQphbHdheXMgcGVy
Zm9ybXMgdGhlIGludGVncml0eSBjaGVjayBhbmQgdGh1cyB0aGVyZSdzIHBvc3NpYmlsaXR5IHRo
YXQgdGhlIGhvc3QNCmV2ZW50dWFsbHkgY2FuIGZpbmQgYSBrZXkgd2hpY2ggbWF0Y2hlcyB0aGUg
aW50ZWdyaXR5IGNoZWNrLg0KDQpUbyBwcmV2ZW50IHN1Y2ggY2FzZSwgdGhlIFREIGJpdCBpcyBh
ZGRlZC4gSGFyZHdhcmUgd2lsbCBjaGVjayB0aGUgVEQgYml0IG1hdGNoDQpmaXJzdCwgYW5kIG9u
bHkgcGVyZm9ybSBpbnRlZ3JpdHkgY2hlY2sgX2FmdGVyXyBURCBiaXQgbWF0Y2guIFNvIGluIGFi
b3ZlIGNhc2UsDQpob3N0IGtlcm5lbCBzcGVjdWxhdGl2ZWx5IHJlYWQgVERYIG1lbW9yeSB2aWEg
c2hhcmVkIEtleUlEIG1hcHBpbmcgd2lsbCBhbHdheXMNCmdldCBhIFREIGJpdCBtaXNtYXRjaCwg
dGh1cyB3b24ndCBiZSBhYmxlIHRvIGFjaGlldmUgYWJvdmUgYXR0YWNrLg0KDQo+ID4gPiA+IEdp
dmVuIHRoZSBQQU1UIHNpemUgY2FuIGJlIGxhcmdlICh+MS8yNTZ0aCBvZiBzeXN0ZW0gUkFNKSwg
anVzdCB1c2UNCj4gPiA+ID4gV0JJTlZEIG9uIGFsbCBDUFVzIHRvIGZsdXNoLg0KPiA+IA0KPiA+
IDxzaWdoPg0KPiA+IA0KPiA+ID4gPiBOb3RlIGlmIGFueSBUREguU1lTLktFWS5DT05GSUcgZmFp
bHMsIHRoZSBURFggbW9kdWxlIG1heSBhbHJlYWR5IGhhdmUNCj4gPiA+ID4gdXNlZCB0aGUgZ2xv
YmFsIEtleUlEIHRvIHdyaXRlIGFueSBQQU1ULiAgVGhlcmVmb3JlLCBuZWVkIHRvIHVzZSBXQklO
VkQNCj4gPiA+ID4gdG8gZmx1c2ggY2FjaGUgYmVmb3JlIGZyZWVpbmcgdGhlIFBBTVRzIGJhY2sg
dG8gdGhlIGtlcm5lbC4gIE5vdGUgdXNpbmcNCj4gPiA+ID4gTU9WRElSNjRCICh3aGljaCBjaGFu
Z2VzIHRoZSBwYWdlJ3MgYXNzb2NpYXRlZCBLZXlJRCBmcm9tIHRoZSBvbGQgVERYDQo+ID4gPiA+
IHByaXZhdGUgS2V5SUQgYmFjayB0byBLZXlJRCAwLCB3aGljaCBpcyB1c2VkIGJ5IHRoZSBrZXJu
ZWwpIHRvIGNsZWFyDQo+ID4gPiA+IFBNQVRzIGlzbid0IG5lZWRlZCwgYXMgdGhlIEtleUlEIDAg
ZG9lc24ndCBzdXBwb3J0IGludGVncml0eSBjaGVjay4NCj4gPiANCj4gPiBJIGhvcGUgdGhpcyBp
cyBjb3ZlcmVkIGluIHRoZSBjb2RlIHdlbGwuDQo+ID4gDQo+ID4gPiA+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMN
Cj4gPiA+ID4gaW5kZXggM2EwMzI5MzBlNThhLi45OWQxYmU1OTQxYTcgMTAwNjQ0DQo+ID4gPiA+
IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+ID4gPiArKysgYi9hcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiA+ID4gQEAgLTIyNCw2ICsyMjQsNDYgQEAgc3RhdGlj
IHZvaWQgc2VhbWNhbGxfb25fZWFjaF9jcHUoc3RydWN0DQo+ID4gPiA+IHNlYW1jYWxsX2N0eCAq
c2MpDQo+ID4gPiA+IMKgCW9uX2VhY2hfY3B1KHNlYW1jYWxsX3NtcF9jYWxsX2Z1bmN0aW9uLCBz
YywgdHJ1ZSk7DQo+ID4gPiA+IMKgfQ0KPiA+ID4gPiDCoA0KPiA+ID4gPiArLyoNCj4gPiA+ID4g
KyAqIENhbGwgb25lIFNFQU1DQUxMIG9uIG9uZSAoYW55KSBjcHUgZm9yIGVhY2ggcGh5c2ljYWwg
cGFja2FnZSBpbg0KPiA+ID4gPiArICogc2VyaWFsaXplZCB3YXkuICBSZXR1cm4gaW1tZWRpYXRl
bHkgaW4gY2FzZSBvZiBhbnkgZXJyb3IgaWYNCj4gPiA+ID4gKyAqIFNFQU1DQUxMIGZhaWxzIG9u
IGFueSBjcHUuDQo+ID4gPiA+ICsgKg0KPiA+ID4gPiArICogTm90ZSBmb3Igc2VyaWFsaXplZCBj
YWxscyAnc3RydWN0IHNlYW1jYWxsX2N0eDo6ZXJyJyBkb2Vzbid0IGhhdmUNCj4gPiA+ID4gKyAq
IHRvIGJlIGF0b21pYywgYnV0IGZvciBzaW1wbGljaXR5IGp1c3QgcmV1c2UgaXQgaW5zdGVhZCBv
ZiBhZGRpbmcNCj4gPiA+ID4gKyAqIGEgbmV3IG9uZS4NCj4gPiA+ID4gKyAqLw0KPiA+ID4gPiAr
c3RhdGljIGludCBzZWFtY2FsbF9vbl9lYWNoX3BhY2thZ2Vfc2VyaWFsaXplZChzdHJ1Y3Qgc2Vh
bWNhbGxfY3R4ICpzYykNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKwljcHVtYXNrX3Zhcl90IHBhY2th
Z2VzOw0KPiA+ID4gPiArCWludCBjcHUsIHJldCA9IDA7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlp
ZiAoIXphbGxvY19jcHVtYXNrX3ZhcigmcGFja2FnZXMsIEdGUF9LRVJORUwpKQ0KPiA+ID4gPiAr
CQlyZXR1cm4gLUVOT01FTTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCWZvcl9lYWNoX29ubGluZV9j
cHUoY3B1KSB7DQo+ID4gPiA+ICsJCWlmDQo+ID4gPiA+IChjcHVtYXNrX3Rlc3RfYW5kX3NldF9j
cHUodG9wb2xvZ3lfcGh5c2ljYWxfcGFja2FnZV9pZChjcHUpLA0KPiA+ID4gPiArCQkJCQlwYWNr
YWdlcykpDQo+ID4gPiA+ICsJCQljb250aW51ZTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCQlyZXQg
PSBzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUoY3B1LA0KPiA+ID4gPiBzZWFtY2FsbF9zbXBfY2Fs
bF9mdW5jdGlvbiwNCj4gPiA+ID4gKwkJCQlzYywgdHJ1ZSk7DQo+ID4gPiA+ICsJCWlmIChyZXQp
DQo+ID4gPiA+ICsJCQlicmVhazsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCQkvKg0KPiA+ID4gPiAr
CQkgKiBEb2Vzbid0IGhhdmUgdG8gdXNlIGF0b21pY19yZWFkKCksIGJ1dCBpdCBkb2Vzbid0DQo+
ID4gPiA+ICsJCSAqIGh1cnQgZWl0aGVyLg0KPiA+ID4gPiArCQkgKi8NCj4gPiANCj4gPiBJIGRv
bid0IHRoaW5rIHlvdSBuZWVkIHRvIGNvdmVyIHRoaXMgdHdpY2UuICBKdXN0IGRvIGl0IGluIG9u
ZSBjb21tZW50Lg0KDQpSaWdodC4gSSdsbCByZW1vdmUuIEknbGwgYmUgbW9yZSBjYXJlZnVsIG5l
eHQgdGltZSB0byBhdm9pZCBzdWNoIHBhdHRlcm4uIA0KDQo+ID4gDQo+ID4gPiA+ICsJCXJldCA9
IGF0b21pY19yZWFkKCZzYy0+ZXJyKTsNCj4gPiA+ID4gKwkJaWYgKHJldCkNCj4gPiA+ID4gKwkJ
CWJyZWFrOw0KPiA+ID4gPiArCX0NCj4gPiA+ID4gKw0KPiA+ID4gPiArCWZyZWVfY3B1bWFza192
YXIocGFja2FnZXMpOw0KPiA+ID4gPiArCXJldHVybiByZXQ7DQo+ID4gPiA+ICt9DQo+ID4gPiA+
ICsNCj4gPiA+ID4gIHN0YXRpYyBpbnQgdGR4X21vZHVsZV9pbml0X2NwdXModm9pZCkNCj4gPiA+
ID4gIHsNCj4gPiA+ID4gIAlzdHJ1Y3Qgc2VhbWNhbGxfY3R4IHNjID0geyAuZm4gPSBUREhfU1lT
X0xQX0lOSVQgfTsNCj4gPiA+ID4gQEAgLTEwMTAsNiArMTA1MCwyMiBAQCBzdGF0aWMgaW50IGNv
bmZpZ190ZHhfbW9kdWxlKHN0cnVjdCB0ZG1yX2luZm8gKnRkbXJfYXJyYXksIGludCB0ZG1yX251
bSwNCj4gPiA+ID4gIAlyZXR1cm4gcmV0Ow0KPiA+ID4gPiAgfQ0KPiA+ID4gPiAgDQo+ID4gPiA+
ICtzdGF0aWMgaW50IGNvbmZpZ19nbG9iYWxfa2V5aWQodm9pZCkNCj4gPiA+ID4gK3sNCj4gPiA+
ID4gKwlzdHJ1Y3Qgc2VhbWNhbGxfY3R4IHNjID0geyAuZm4gPSBUREhfU1lTX0tFWV9DT05GSUcg
fTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCS8qDQo+ID4gPiA+ICsJICogQ29uZmlndXJlIHRoZSBr
ZXkgb2YgdGhlIGdsb2JhbCBLZXlJRCBvbiBhbGwgcGFja2FnZXMgYnkNCj4gPiA+ID4gKwkgKiBj
YWxsaW5nIFRESC5TWVMuS0VZLkNPTkZJRyBvbiBhbGwgcGFja2FnZXMgaW4gYSBzZXJpYWxpemVk
DQo+ID4gPiA+ICsJICogd2F5IGFzIGl0IGNhbm5vdCBydW4gY29uY3VycmVudGx5IG9uIGRpZmZl
cmVudCBDUFVzLg0KPiA+ID4gPiArCSAqDQo+ID4gPiA+ICsJICogVERILlNZUy5LRVkuQ09ORklH
IG1heSBmYWlsIHdpdGggZW50cm9weSBlcnJvciAod2hpY2ggaXMNCj4gPiA+ID4gKwkgKiBhIHJl
Y292ZXJhYmxlIGVycm9yKS4gIEFzc3VtZSB0aGlzIGlzIGV4Y2VlZGluZ2x5IHJhcmUgYW5kDQo+
ID4gPiA+ICsJICoganVzdCByZXR1cm4gZXJyb3IgaWYgZW5jb3VudGVyZWQgaW5zdGVhZCBvZiBy
ZXRyeWluZy4NCj4gPiA+ID4gKwkgKi8NCj4gPiA+ID4gKwlyZXR1cm4gc2VhbWNhbGxfb25fZWFj
aF9wYWNrYWdlX3NlcmlhbGl6ZWQoJnNjKTsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4g
PiAgLyoNCj4gPiA+ID4gICAqIERldGVjdCBhbmQgaW5pdGlhbGl6ZSB0aGUgVERYIG1vZHVsZS4N
Cj4gPiA+ID4gICAqDQo+ID4gPiA+IEBAIC0xMDk4LDE1ICsxMTU0LDQ0IEBAIHN0YXRpYyBpbnQg
aW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4gPiA+ICAJaWYgKHJldCkNCj4gPiA+ID4gIAkJZ290
byBvdXRfZnJlZV9wYW10czsNCj4gPiA+ID4gIA0KPiA+ID4gPiArCS8qDQo+ID4gPiA+ICsJICog
SGFyZHdhcmUgZG9lc24ndCBndWFyYW50ZWUgY2FjaGUgY29oZXJlbmN5IGFjcm9zcyBkaWZmZXJl
bnQNCj4gPiA+ID4gKwkgKiBLZXlJRHMuICBUaGUga2VybmVsIG5lZWRzIHRvIGZsdXNoIFBBTVQn
cyBkaXJ0eSBjYWNoZWxpbmVzDQo+ID4gPiA+ICsJICogKGFzc29jaWF0ZWQgd2l0aCBLZXlJRCAw
KSBiZWZvcmUgdGhlIFREWCBtb2R1bGUgY2FuIHVzZSB0aGUNCj4gPiA+ID4gKwkgKiBnbG9iYWwg
S2V5SUQgdG8gYWNjZXNzIHRoZSBQQU1ULiAgR2l2ZW4gUEFNVHMgYXJlIHBvdGVudGlhbGx5DQo+
ID4gPiA+ICsJICogbGFyZ2UgKH4xLzI1NnRoIG9mIHN5c3RlbSBSQU0pLCBqdXN0IHVzZSBXQklO
VkQgb24gYWxsIGNwdXMNCj4gPiA+ID4gKwkgKiB0byBmbHVzaCB0aGUgY2FjaGUuDQo+ID4gPiA+
ICsJICoNCj4gPiA+ID4gKwkgKiBGb2xsb3cgdGhlIFREWCBzcGVjIHRvIGZsdXNoIGNhY2hlIGJl
Zm9yZSBjb25maWd1cmluZyB0aGUNCj4gPiA+ID4gKwkgKiBnbG9iYWwgS2V5SUQgb24gYWxsIHBh
Y2thZ2VzLg0KPiA+ID4gPiArCSAqLw0KPiA+ID4gPiArCXdiaW52ZF9vbl9hbGxfY3B1cygpOw0K
PiA+ID4gPiArDQo+ID4gPiA+ICsJLyogQ29uZmlnIHRoZSBrZXkgb2YgZ2xvYmFsIEtleUlEIG9u
IGFsbCBwYWNrYWdlcyAqLw0KPiA+ID4gPiArCXJldCA9IGNvbmZpZ19nbG9iYWxfa2V5aWQoKTsN
Cj4gPiA+ID4gKwlpZiAocmV0KQ0KPiA+ID4gPiArCQlnb3RvIG91dF9mcmVlX3BhbXRzOw0KPiA+
ID4gPiArDQo+ID4gPiA+ICAJLyoNCj4gPiA+ID4gIAkgKiBSZXR1cm4gLUVJTlZBTCB1bnRpbCBh
bGwgc3RlcHMgb2YgVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbg0KPiA+ID4gPiAgCSAqIHByb2Nl
c3MgYXJlIGRvbmUuDQo+ID4gPiA+ICAJICovDQo+ID4gPiA+ICAJcmV0ID0gLUVJTlZBTDsNCj4g
PiA+ID4gIG91dF9mcmVlX3BhbXRzOg0KPiA+ID4gPiAtCWlmIChyZXQpDQo+ID4gPiA+ICsJaWYg
KHJldCkgew0KPiA+ID4gPiArCQkvKg0KPiA+ID4gPiArCQkgKiBQYXJ0IG9mIFBBTVQgbWF5IGFs
cmVhZHkgaGF2ZSBiZWVuIGluaXRpYWxpemVkIGJ5DQo+ID4gDQo+ID4gCQkJCQkJcy9pbml0aWFs
aXplZC93cml0dGVuLw0KDQpXaWxsIGRvLg0KDQo+ID4gDQo+ID4gPiA+ICsJCSAqIFREWCBtb2R1
bGUuICBGbHVzaCBjYWNoZSBiZWZvcmUgcmV0dXJuaW5nIFBBTVQgYmFjaw0KPiA+ID4gPiArCQkg
KiB0byB0aGUga2VybmVsLg0KPiA+ID4gPiArCQkgKg0KPiA+ID4gPiArCQkgKiBOb3RlIHRoZXJl
J3Mgbm8gbmVlZCB0byBkbyBNT1ZESVI2NEIgKHdoaWNoIGNoYW5nZXMNCj4gPiA+ID4gKwkJICog
dGhlIHBhZ2UncyBhc3NvY2lhdGVkIEtleUlEIGZyb20gdGhlIG9sZCBURFggcHJpdmF0ZQ0KPiA+
ID4gPiArCQkgKiBLZXlJRCBiYWNrIHRvIEtleUlEIDAsIHdoaWNoIGlzIHVzZWQgYnkgdGhlIGtl
cm5lbCksDQo+ID4gPiA+ICsJCSAqIGFzIEtleUlEIDAgZG9lc24ndCBzdXBwb3J0IGludGVncml0
eSBjaGVjay4NCj4gPiA+ID4gKwkJICovDQo+ID4gDQo+ID4gTU9WRElSNjRCIGlzIHRoZSB0aW5p
ZXN0IG9mIGltcGxlbWVudGF0aW9uIGRldGFpbHMgYW5kIGFsc28gbm90IHRoZSBvbmx5DQo+ID4g
d2F5IHRvIGluaXRpYWxpemUgbWVtb3J5IGludGVncml0eSBtZXRhZGF0YS4NCj4gPiANCj4gPiBK
dXN0IGtlZXAgdGhpcyBoaWdoIGxldmVsOg0KPiA+IA0KPiA+IAkJKiBObyBuZWVkIHRvIHdvcnJ5
IGFib3V0IG1lbW9yeSBpbnRlZ3JpdHkgY2hlY2tzIGhlcmUuDQo+ID4gCQkqIEtleUlEIDAgaGFz
IGludGVncml0eSBjaGVja2luZyBkaXNhYmxlZC4NCg0KV2lsbCBkby4gVGhhbmtzLg0KDQo=
