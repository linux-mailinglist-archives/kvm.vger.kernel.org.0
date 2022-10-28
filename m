Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC696106B3
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 02:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbiJ1AK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 20:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235441AbiJ1AKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 20:10:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B653B83069;
        Thu, 27 Oct 2022 17:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666915837; x=1698451837;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nEfeC0B5JOryy/WB2aWLInZSBPlc1+KwwSRRgN8GwXo=;
  b=j2zWKCAKVtMlKIsIipD2JEmnL4jLxIYs3n3d7sfkG6Jlpsh5qTY/ki+0
   xrPHqyNa0T1M6ntX09GVjv+WZWl1vfqfXxQp8dprYgcgz9AjZY1ixK2dd
   4kQSxOtOd3dXMLuR94XRNZes2rP8tTmK8BW+CM+Poh6os61at+osDzx/1
   g0O7aTBnq8wPUtwWyOkNwhSVYUqfM+S5tnxfjjBMfH9Tw4p+Kk31gF0/F
   1eF3n4fYh5Km6lA3Bs09ZCvM0ooEbsAEEHZcT89JGbG+YIDPZg35CVjck
   1Gngyu0AuQ//QBtHQ+n2LIJ7JdGN4bMQs1LP+txrTokpL4AJ+LDMIYfWJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="370437806"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="370437806"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 17:10:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="807640838"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="807640838"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 27 Oct 2022 17:10:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 17:10:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 17:10:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 17:10:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgvvGxujVMEZp0HRhArfwMLgKQt6u65oXEhv6kFKj+mNVymhYZCPd7goSlGhFFRDipxXDHS+/dEl6t0UPTlteRBboRs9Ubm4Odt5NiMa1yAYx6y5YjLpeuXYnwD4hepq3rtbRkNTGIxCDHpDcuNlhahwB2pJF519KlAD/bd9BdZxsv8rLcXHbNjRKKH4bIkk0RwlUnkPHKjHAAu+pEoNB0jt82jvVK8ZYDRAWfePZAQJQSHyek71qytXZ3NbazVzb39YQRAEE9X4NT1ZFMc4o3Kf5GLiB9PFbLjt81MYZZb2X8J5ALIufT6rcd8od3eTK5yC6r4/ruvOfts8RdD8MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nEfeC0B5JOryy/WB2aWLInZSBPlc1+KwwSRRgN8GwXo=;
 b=hi7JtQx/HjndLpnwKBxfDRfSi0VDSSBKWbFKXALv37PILO73pt5jk5iNwYf0yuJSu0N0zP7ClPYcgXPSBEQs/fZ4lKlzDljbRxg4VekGYr1NJGXv6iWVYZ1PyuC5ovMTa8SmDKsk44bjFVmD/mZ8o1bvvNU1/crPhZkQiUttTs+3U+c2Aszr6hST9a8XpUvofDJGEgUZ1C+rqEwsM6jpIARpoKbHiVrdBReAtGYzhhtyqWpIJc0Syd+8gEBjYxIMI1GNuOi713IwuMxofd+sILvRYOcKttqm0uaqA3mb3Tdqlj8ck2r5O49ykhvdf4ZXTg0o8iFEDcsRdhJsoffsZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4671.namprd11.prod.outlook.com (2603:10b6:806:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 00:10:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 00:10:33 +0000
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
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX
 supported page sizes
Thread-Topic: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX
 supported page sizes
Thread-Index: AQHY6Y2c1fkWJEN4oUaD5m/zaHt0F64iXgkAgACSPYA=
Date:   Fri, 28 Oct 2022 00:10:32 +0000
Message-ID: <62c0214cae1bb9f2a4e25d85c7ea45b80906f929.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
         <03677288-2e96-a66e-fb1a-331e3b0d112f@intel.com>
In-Reply-To: <03677288-2e96-a66e-fb1a-331e3b0d112f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4671:EE_
x-ms-office365-filtering-correlation-id: e28b701a-a9e8-4cd5-e7c7-08dab878d4b4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: COQw76ImRawmKT6EMZqQgz1KVn0KkQ/SGbtU7UCxB7XRFTOPzUPN9QDL3T0SxpwMzP4gUQ73OOfky0n1I0p02RSWqg8EMraNHzIqTzlieDc6gh2OmhenfoU54g31fLZNmvJ7DBOY9UfDfUQvXj6wrobujtqUuZHOOTCpK5o8vboMqVkwgcV9CKQqjyXdjJaQwNeUsQ2MjZ7sU2Wci92UL9W+Kti6n3w7lPmp9qRNj7hNJEiKs2zu/vcocWYnSfNeT2KcwYJzPPCOo66oDhGxSZYh5doJtWiKVnLbAYmejLJgUr3HaW4GD9ImnqbuoPvAppuWqBlJjMPlpujUI563av6likdwO+acPU6nhpssX1J2hoj4tquDp+qsw3Xb8LaVknjvb6HoP4pXDUZkumcRfdakR9Ny6676F6psvkTtI9Wu/teaivIjkPka+T+Nw/HmPayO/syHiYX4rEboxy4ff1hr6XwSlKeO9YqmQJDHUiBdvJeF5v9TWh3eXvbmjfGsmRU85uS+N9pt0km5yg1Jnx/auqiLj2N+ZeJZiVwGnzZq2paAiR2nBUJL6JSIKnCPvW8g/Q5uoP6MZcvLb2vqLdzZxu4VaPVXqw3UO8DGQ8SIBH317Q+6OvnJCuNzT9ho21luGAsUWk+bttwIBHv8KUsW6GjtDJ7lMyLGGJW3oi9DHXDLXmRVo+pPHRpfHW3NHRaqRS7kmL+Wom5RZd6FD4oh7SAFhiYGA7SYee1yEUMPxNqP+8IYH3Mf/U1ynU8vU8c8lSaEdwxTHrBdYGdItw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(8936002)(5660300002)(478600001)(110136005)(38070700005)(54906003)(66556008)(38100700002)(36756003)(2906002)(4001150100001)(6486002)(4326008)(7416002)(66946007)(41300700001)(316002)(71200400001)(66476007)(64756008)(91956017)(8676002)(76116006)(66446008)(6512007)(2616005)(186003)(6506007)(82960400001)(86362001)(122000001)(26005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFA2Wm9YUExYcGRBUW40TDhId0QrUVYzT0Z1dnFMdWUybHFmcXlrTEE4am1R?=
 =?utf-8?B?aktuZXFadzlsdHJIVDF3a0J2ak5VZ3dFanVDOGdkSUdpcVY5LzVFWVRzby9S?=
 =?utf-8?B?ZG1qUnhOOFpBRDBtZjhXdDMrclRGM0ZwQ1lRZjYycnc4VEx6V2xhRExTTGVk?=
 =?utf-8?B?S3QwLyt3VkNVZjhqUGxFNE4zV1dPalR6SHdHNHJ5dHZTcy9LR2VZSFdQeDlJ?=
 =?utf-8?B?Sm1Zdmk4Nm1vdGcwcmNlcFFpVnkyaW9SWHNseWpHbkE4RjNLaEs5UEdhdXcy?=
 =?utf-8?B?K1Y2a1h1ekV4eEcxellWYmMzQW1PMXhidWJtaUNEbkl1dFFGN2hNQkp4bFRR?=
 =?utf-8?B?VktvMkZ6SVRRcERqaGMwVGRJa3Y1L0ZnYnFIem53MnhQZWRIbUkzVG9GbVgr?=
 =?utf-8?B?L24yYTFnYU9GdFpLcjZEOWhPL1JEc2R1TDhPblhjUUUwbWVlQ1RMdzdQMkMx?=
 =?utf-8?B?Nmp3c0ZOS0ZpTmEzTHV1OEMydllNeWlRRlZ2RTF4b005a1ZOUTRHUFl6aGV5?=
 =?utf-8?B?aUsyaTd1bFRTTzFNM1RvblM4NnJESHBrS1UraDlTbmcxbXhrVi9SWjRSTXZr?=
 =?utf-8?B?dWk5SlVJT21iUG9LMm9sdGVPdTNEVjJCcDhzRWdmczhBS2QxMlg5c3lTSEhS?=
 =?utf-8?B?SHl5dVlvOVpBL2w0WEZXUVV0SU9aVmp4R1VlekF1U21BbXI3bkd0RzdQQ1Rl?=
 =?utf-8?B?WmpWaE9LOEFmTzR5UVV6UUNHYVhkME9BM0FacGw1eHNBQTdKRlR2eWZsVjJN?=
 =?utf-8?B?VjBIQ2ZYR0Z2V0M3S3gxSWJRcC9KSEJXUGlRd3RzOW9RQWFXdXVEbmNoTW5M?=
 =?utf-8?B?SVYwb3dlOGlaVGVjRHF6WjdVdXNxdzRGb3lTelBvS3hWRVVkdTlHK0xacDdM?=
 =?utf-8?B?OXVoQUdNbFZ6N2hxOG1zZkM4aDV6blQyRjVuQ09OYWlNbytXczJMZ2toUDVD?=
 =?utf-8?B?bFFGTjNkd293a0VpT1NsYXNPbGpxUGl1YlBLRjhjSE05ekRNSTZuRTg3Z3d5?=
 =?utf-8?B?eVhkUnlrUUJvS3dZNGFacFJEcGlKUmdaemp2ejkwNldtd1Zxc3RvWjNWVS92?=
 =?utf-8?B?V1ZZNmhycDl3UWZabzJveGdMQ3FGUUhON1Q4WnVvWnZSMlV3NG0wT0RGSHI3?=
 =?utf-8?B?NU1hL1V6WTBjeWZsZy9PWUdGMGNOck1LMTZiUE5id3p6N2c1NVJLbyt0RXhV?=
 =?utf-8?B?L2FUMnloakFwWk85eGxmTDZ4NnBzS29heE5pc3ZnQU1icExkWFFSYmFtOFNr?=
 =?utf-8?B?RVZqMUJNSkE3dHc0U0p0d0lhelVCT29NaG80NGVzZjM1bDdHVzdhRksvYVEw?=
 =?utf-8?B?cTExUy94SG91cUh1MDZZMHd0M0tjbTdacWticHRCNXJNZFV6K0c4N1ZSamVl?=
 =?utf-8?B?elFFSGpldEo2d3VMVmEvMS90OXloQlV3VFhuLzBVOFE5MFNYU0RObVpuTStZ?=
 =?utf-8?B?dVk3UGFKRUl4a2FWYy96NGU2WlFISC81NFZ3d01EYVRkM0VBZFBiNnhKUVNZ?=
 =?utf-8?B?cHJQRDhBQ2RYWjk2TDhiQVFZVUdDWlpaZUN0T2RDZzNDS0IrNWhuU0VvRzVz?=
 =?utf-8?B?cENwS3pKdGFUV1pnTDA1NTZuSFBpcE94OHdxc0lZWEpSY2dXUXJVSkdHL09E?=
 =?utf-8?B?OGtFQnEzUVhrbllyMlM0c21Pb1JwN2tOYzhDRXh3V0JHNUp5d3A4YUhwd1pG?=
 =?utf-8?B?OExXL3BOTzVzaGRCUkY5SVFPQktwaVFIdUx4d2I2NG5BR29LWWc3Nyt5dXpG?=
 =?utf-8?B?ZmRRWHpJd0hPSEdhSy9CM2Fyc0NyNzAzZ0ppWVVid1Q2VzJrRWdFTFc4WGhO?=
 =?utf-8?B?em1XWDEzVERPWlpHZzd5ckYwdkkvMWtqa1NDUzFXTUxwdDdSSUxhTHgxenJ0?=
 =?utf-8?B?QVl1N0tsZHp4U25rb0tiS1BCNnNVc1N5U0xmb3Y1cUZ4QlRpWVlKcHVPQUR1?=
 =?utf-8?B?cVFZK21vdGhHNlBmTmV5S0VhTXF2Y01sbmp6VGNuMnVaVkN3aGJ5NkF0cXZt?=
 =?utf-8?B?U3Nxb0U4QjdwTER1S3RXRVJSMFprbmFwdDlkbUp4YTZCdUVZWXVFSWpWRjNU?=
 =?utf-8?B?aCthZENXT2NIaloxaEU3V29Hc2txa2NOdDJEZTcwTGFVQ0J6K25qNjFVNngz?=
 =?utf-8?B?VitTOFoyNWx0dUo0VGxrWWYzWXNad0thRzdzS1RVNTNJSExZRUlaTXBicGlU?=
 =?utf-8?B?Y3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B566F3D3B60F9B4CA7FB66C5505966E4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e28b701a-a9e8-4cd5-e7c7-08dab878d4b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 00:10:33.0089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nKcBsc6ea+T9ZtNhkYTkgbCF+drLyzV9msq5d+UbXTdHeBk6hVaDW9nvAoCK3g0pZ2HUGwJ1wepSX7MTQAzACw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4671
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDA4OjI3IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMjYvMjIgMTY6MTYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiArLyoNCj4gPiArICogR2V0
IHRoZSBURFggcGFnZSBsZXZlbCBiYXNlZCBvbiB0aGUga2VybmVsIHBhZ2UgbGV2ZWwuICBUaGUg
Y2FsbGVyDQo+ID4gKyAqIHRvIG1ha2Ugc3VyZSBvbmx5IHBhc3MgNEsvMk0vMUcga2VybmVsIHBh
Z2UgbGV2ZWwuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW5saW5lIGVudW0gdGR4X3BnX2xldmVs
IHRvX3RkeF9wZ19sZXZlbChlbnVtIHBnX2xldmVsIHBnbHZsKQ0KPiA+ICt7DQo+ID4gKwlzd2l0
Y2ggKHBnbHZsKSB7DQo+ID4gKwljYXNlIFBHX0xFVkVMXzRLOg0KPiA+ICsJCXJldHVybiBURFhf
UEdfTEVWRUxfNEs7DQo+ID4gKwljYXNlIFBHX0xFVkVMXzJNOg0KPiA+ICsJCXJldHVybiBURFhf
UEdfTEVWRUxfMk07DQo+ID4gKwljYXNlIFBHX0xFVkVMXzFHOg0KPiA+ICsJCXJldHVybiBURFhf
UEdfTEVWRUxfMUc7DQo+ID4gKwlkZWZhdWx0Og0KPiA+ICsJCVdBUk5fT05fT05DRSgxKTsNCj4g
PiArCX0NCj4gPiArCXJldHVybiBURFhfUEdfTEVWRUxfTlVNOw0KPiA+ICt9DQo+IA0KPiBJcyBU
RFhfUEdfTEVWRUxfTlVNIHBhcnQgb2YgdGhlIEFCST8gIE9yLCBpcyB0aGlzIGdvaW5nIHRvIGFj
Y2lkZW50YWxseQ0KPiBwYXNzIGEgd2hhY2t5IHZhbHVlIHRvIHRoZSBTRUFNIG1vZHVsZT8NCg0K
VGhlIGludGVudGlvbiBpcyBURFhfUEdfTEVWRUxfTlVNIGlzIG5vdCBwYXJ0IG9mIEFCSSwgYnV0
IGxvb2tzIEkgd2FzIHdyb25nLiANCktWTSBzZWN1cmUgRVBUIGNhbiBhY2NlcHQgbGFyZ2VyIHBh
Z2UgbGV2ZWwgb2YgMUcgYXMgcGFnZSB0YWJsZS4NCg0KPiBUaGlzIG5lZWRzIHNvbWV0aGluZyBs
aWtlIHRoaXMgYXQgdGhlIGNhbGwtc2l0ZToNCj4gDQo+IAlwYWdlX3NpemUgPSB0b190ZHhfcGdf
bGV2ZWwocGdfbGV2ZWwpOw0KPiAJaWYgKHBhZ2Vfc2l6ZSA+PSBURFhfUEdfTEVWRUxfTlVNKQ0K
PiAJCXJldHVybiBmYWxzZTsNCg0KWWVzLiAgVGhhbmtzIGZvciB0aGUgdGltZSB0byByZXZpZXcu
ICBJdCdzIGJhZCwgYW5kIHNob3VsZCBnbyBhd2F5Lg0KDQpUaGlzIHJlbWluZHMgbWUgSSBoYXZl
IG1peGVkIHR3byB0aW5ncyB0b2dldGhlcjogMSkgbGVhZiBwYWdlIHNpemVzICg0Sy8yTS8xRyk7
DQoyKSBwYWdlIHRhYmxlIGxldmVscywgd2hpY2ggY2FuIGhhdmUgbGFyZ2VyIGxldmVsIHRoYW4g
MUcuDQoNCkluIGZhY3QsIHRoZSBURFggbW9kdWxlIHNwZWMgaGFzIGEgc2VwYXJhdGUgZGVmaW5p
dGlvbiBmb3IgdGhlIGxlYWYgcGFnZSBzaXplczoNCg0KCVRhYmxlIDIwLjEwOiBQYWdlIFNpemUg
RGVmaW5pdGlvbg0KDQoJUFNfMUcJMUcJMg0KCVBTXzJNCTJNCTENCglQU180Swk0SwkwDQoNCldo
aWxlIFREWCBndWVzdCBhbmQgVERYIGhvc3QgY29kZSBvbmx5IG5lZWRzIGxlYWYgcGFnZSBzaXpl
cywgS1ZNIG5lZWRzIGFsbCB0aGUNCnBhZ2UgdGFibGUgbGV2ZWxzLCBzbyBpdCdzIG5vdCBuZWNl
c3NhcmlseSB0byBwcm92aWRlIGEgY29tbW9uIGhlbHBlciB0byBnZXQgVERYDQpwYWdlIGxldmVs
IGZyb20ga2VybmVsIHBhZ2UgbGV2ZWwuDQoNCkFzIElzYWt1IGFsc28gcmVwbGllZCwgSSdsbCBy
ZW1vdmUgdGhlIGhlbHBlci4NCg0KSGkgS2lyaWxsLA0KDQpZb3UgZXhwcmVzc2VkIHBlcmhhcHMg
d2UgY2FuIHVzZSBtYWNybyBkZWZpbml0aW9ucyBpbnN0ZWFkIG9mIHRoZSBlbnVtIHR5cGUuIA0K
RG9lcyBiZWxvdyBsb29rIGdvb2QgdG8geW91Pw0KDQotLS0gYS9hcmNoL3g4Ni9jb2NvL3RkeC90
ZHguYw0KKysrIGIvYXJjaC94ODYvY29jby90ZHgvdGR4LmMNCkBAIC02NzEsMTMgKzY3MSwxMyBA
QCBzdGF0aWMgYm9vbCB0cnlfYWNjZXB0X29uZShwaHlzX2FkZHJfdCAqc3RhcnQsIHVuc2lnbmVk
DQpsb25nIGxlbiwNCiAgICAgICAgICovDQogICAgICAgIHN3aXRjaCAocGdfbGV2ZWwpIHsNCiAg
ICAgICAgY2FzZSBQR19MRVZFTF80SzoNCi0gICAgICAgICAgICAgICBwYWdlX3NpemUgPSAwOw0K
KyAgICAgICAgICAgICAgIHBhZ2Vfc2l6ZSA9IFREWF9QU180SzsNCiAgICAgICAgICAgICAgICBi
cmVhazsNCiAgICAgICAgY2FzZSBQR19MRVZFTF8yTToNCi0gICAgICAgICAgICAgICBwYWdlX3Np
emUgPSAxOw0KKyAgICAgICAgICAgICAgIHBhZ2Vfc2l6ZSA9IFREWF9QU18yTTsNCiAgICAgICAg
ICAgICAgICBicmVhazsNCiAgICAgICAgY2FzZSBQR19MRVZFTF8xRzoNCi0gICAgICAgICAgICAg
ICBwYWdlX3NpemUgPSAyOw0KKyAgICAgICAgICAgICAgIHBhZ2Vfc2l6ZSA9IFREWF9QU18xRzsN
CiAgICAgICAgICAgICAgICBicmVhazsNCiAgICAgICAgZGVmYXVsdDoNCiAgICAgICAgICAgICAg
ICByZXR1cm4gZmFsc2U7DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4Lmgg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KaW5kZXggMDIwYzgxYTdjNzI5Li43NDg0NWQw
MTRkMWMgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KKysrIGIvYXJj
aC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCkBAIC0yMCw2ICsyMCwxOCBAQA0KIA0KICNpZm5kZWYg
X19BU1NFTUJMWV9fDQogDQorLyoNCisgKiBURFggc3VwcG9ydGVkIHBhZ2Ugc2l6ZXMgKDRLLzJN
LzFHKS4NCisgKg0KKyAqIFBsZWFzZSByZWZlciB0byB0aGUgVERYIG1vZHVsZSAxLjAgc3BlYyAy
MC40LjEgUGh5c2ljYWwgUGFnZSBTaXplLg0KKyAqDQorICogVGhvc2UgdmFsdWVzIGFyZSBwYXJ0
IG9mIHRoZSBURFggbW9kdWxlIEFCSSAoZXhjZXB0IFREWF9QU19OVU0pLg0KKyAqLw0KKyNkZWZp
bmUgVERYX1BTXzRLICAgICAgMA0KKyNkZWZpbmUgVERYX1BTXzJNICAgICAgMQ0KKyNkZWZpbmUg
VERYX1BTXzFHICAgICAgMg0KKyNkZWZpbmUgVERYX1BTX05VTSAgICAgMw0KKw0KDQpCdHcsIFRE
WCBob3N0IHBhdGNoIHdpbGwgdXNlIHRoZW0gaW4gYmVsb3cgd2F5IChwbGVhc2UgcmVmZXIgdG8g
cGF0Y2ggMTQ6DQp4ODYvdmlydC90ZHg6IEFsbG9jYXRlIGFuZCBzZXQgdXAgUEFNVHMgZm9yIFRE
TVJzKToNCg0KCXVuc2lnbmVkIGxvbmcgcGFtdF9zaXplW1REWF9QU19OVU1dOw0KDQoJLyoNCgkg
KiBDYWxjdWxhdGUgdGhlIFBBTVQgc2l6ZSBmb3IgZWFjaCBURFggc3VwcG9ydGVkIHBhZ2Ugc2l6
ZQ0KCSAqIGFuZCB0aGUgdG90YWwgUEFNVCBzaXplLiAgVERYX1BTXyogYXJlIGNvbnRpZ3VvdXMg
ZnJvbSAwIHRvIDMuDQoJICovDQoJZm9yIChwZ3N6ID0gVERYX1BTXzRLOyBwZ3N6IDwgVERYX1BT
X05VTTsgcGdzeisrKSB7DQoJCXBhbXRfc2l6ZVtwZ3N6XSA9IHRkbXJfZ2V0X3BhbXRfc3oodGRt
ciwgcGdzeik7DQoJCS4uLg0KCX0NCg0K
