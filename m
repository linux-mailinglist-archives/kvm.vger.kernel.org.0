Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7D663A605
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 11:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiK1KW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 05:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiK1KW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 05:22:26 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0F91A3BE
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 02:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669630945; x=1701166945;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h/xQ5CX40rrGJ6fLirVuULVGw2iIKcm9EohY4upz9Js=;
  b=bBbEtJdjRfSEMZu41NGsOYM6VyXib7f2o+hbhGwgZETtXUGvc+mkZLBE
   efCnUTCQIzjbMXJjkVxux5QT7Ru+CL4itjdaaXCGyA2T0XZz6gQcXwQTp
   7+xYpAVLtiWCf4etGpDxAbYS2EE5j+NtUFUesUnLDpzW9l/pX52BogXhf
   dLC8Wxs/ilVjdaa9ktki5hjONRFM4aRrMn6oWR4Q5PPJoK+h99dNvIwCL
   K1QzZjm/PWi13YI4r03SCl5EHKsdHlgPMDc1Ny4WwF+A5T1CqV4XxY1Mk
   36shzezkoJ8jdrCRfxUjZX0hKyCkXeLiK2icpGFQprP/H5XID+0dR/rWz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="298154493"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="298154493"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 02:22:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="620997535"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="620997535"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 28 Nov 2022 02:22:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 02:22:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 02:22:19 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 02:22:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtUtrzznsCLrVdozE1mj27Tfa8qjlGoJyYrqMXI04eric+2jzaTCnAPwOvmMVIGX1bwHQ9Av16fV8UYIp+4m9mJMpBOVegwjWvWS06v6V8TNx9vMtN6v8uKZrQ41GfWitbFNVBuikuvs2J8d7keZD13RAZpzx8ObS3mM02NQKoP1W0+1gM/MHxBxBr8WcXp1K8vZOBSMKQ1J+tS32e9jaBMUjgY2MOeXbK56CaxIhl0Z2DLmyYVRF/EzMWDaNbry6s41odY8IFCTcGGmvFs5Jul8gfSrKe+TlqYn+w74j6GYz23E/Y0IQcr9Eo5MltVZbHCDifNK3hIGZ/vFNSKqIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/xQ5CX40rrGJ6fLirVuULVGw2iIKcm9EohY4upz9Js=;
 b=SUZqusoiLow41eqgTmClHZaEW1Qtwos2pH6C5B7khXRF1TQSp9D8sQiLASRRomDUWEFC1XHSY6ZpqP0zC3imz2EFqaeSGp3wIq78EamuK2TbJPkA8ahhhBAbaPiVRpgVkRN/1qwyhubzUzWDKNCKxPGtb48UflGdg0LHnJ8g8n6RTJh2+OVMjSbjO+3fLmCpiU+VonEoequR/3K+5DrNiY5O5gAXChzHQFjFwndTPg7TdnUC4wnJw0OVPUZROIyzvHY/AlSUaqdh/ZOI2juwABa4FGQen5ahJJUGLk/5nxrzr0ackoMkVM2Gv6BB91U1JJfDtIJ6YwYlRxnEUdSp1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 SJ0PR11MB4782.namprd11.prod.outlook.com (2603:10b6:a03:2df::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 10:22:17 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::4cb1:2965:376:8bda]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::4cb1:2965:376:8bda%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 10:22:17 +0000
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Thread-Topic: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Thread-Index: AQHY/0JMNGwP1j7DQEC1JUkosyakIq5UKA4A
Date:   Mon, 28 Nov 2022 10:22:17 +0000
Message-ID: <9634490f-d100-5a08-013f-439218a4232a@intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-2-yi.l.liu@intel.com>
In-Reply-To: <20221123134832.429589-2-yi.l.liu@intel.com>
Accept-Language: en-FI, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5549:EE_|SJ0PR11MB4782:EE_
x-ms-office365-filtering-correlation-id: 1f70fc33-8f78-4733-1192-08dad12a6cef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nzl7QFTMCssh9TgcV1C1nVdhHta1saBZjlwj1Di1LjiDyUtysYbXsXM1o+I2Fz+iiAB2tFYU5g2iCkzAlhXfulx3aRZdd41CA1kPnatyBL2lQha1UNc6BO+26nRflmEE5MMgj/uuw3aQ+/+QRB0CGzOZyYcYZuYjsb9ArzprLuCZdh8GeYNRKahTAkUc1PRAcPQtE4WKhzRjT7EC8ONQoUk49WP4XEnmJnEw0FT76yqTMGN879IjcPNydhZXdZXVZrsvn60JXqAXCIHCQ7GKPYs3IG4lwFfkFmAvVA11lmFFCo65PMtvuJ/ARIB5z07S7Vu9yubTaQC5AvyixvUhiaJ/JBQh4Z2w21NeZa8aAghMG2RJsnMiCo0RoaJ8sKcEMkSXRtXE94eJH37SBNMHW9Cq3WscFoyJNBqB2kFLH1lF5EAAHq5iOJvWoKc6V+jgYzK9+rQJTmWK2o+JVqJLGJks0R4tdxoX9pdKC7MpKw40LaJTurbo+B31aQmUobc4kPZHF+gyg14uFk0JnQ8HOWzO76o/80/Qdl52bpDw3jCkEtGP0gd3VwnPVijaPdopgwQyHRAI7ftdbIfIs0i71tmZmbSJWF3M/+UhQM9FRlSVcKj/tbnF6QNkXwpQzClU1OPs2K7hsaPsJekInTACTkD5zWyOdqjJAY41IGw58XzsmZMnK/V4coKjvM8+Jll/8y0Hp9Qaw1QKEI7QjTnP4vkftD0Jrtk57le9MWa0fRdmCF0I7/Yl7/15uZFRV4dX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199015)(66446008)(64756008)(38100700002)(6486002)(91956017)(82960400001)(66946007)(66476007)(76116006)(66556008)(41300700001)(4326008)(36756003)(478600001)(71200400001)(122000001)(8676002)(54906003)(316002)(2906002)(38070700005)(5660300002)(8936002)(110136005)(86362001)(31696002)(31686004)(2616005)(83380400001)(186003)(6512007)(26005)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEwrbWhwbFNmakkvekxKUzlmUjFLMitUR0tNVzg5QUtMSWc2Z0pXaXpoRysz?=
 =?utf-8?B?VWdVOU0vQVZ4anNtVEtNT2FyQnZDVTErblZ3ZnFpWmZMdENLOU9WaXpvWlJZ?=
 =?utf-8?B?cVpmbGtWVTY5eCtzL3czVVFEKzFDR2ZMbTIxWnRMUnNTU2hrRk00OTNuWEdC?=
 =?utf-8?B?Y05YS2xJZnloZjQ1VXhkTTNHYXBEcHlTWUVoa2VRdFl6bUVEeVV3S1hWQzNR?=
 =?utf-8?B?L3VNVGZNcFQ5REcrVDAxeWwreU9JalpsU3VnS2ZqUWtyZmdTRy92T05ScnhW?=
 =?utf-8?B?UHIzQXdvclN2blVuU25nRElqa2RXTUpkRG1vY0dzMThnN3hIek1WRjhBODZW?=
 =?utf-8?B?WnFrWHlEOVkvbHIzNk0rVmJNbWR3MDZVRjNQcnlaR0xCSTRLL2xMZ25ITVVl?=
 =?utf-8?B?TThJd2VRVkU5Q0VnMGhJSkpEOTdRc1VBZDNUalN0QkoxckZkR3F6R3QvdXBX?=
 =?utf-8?B?SUNmSnNwSnZtb2ZDbHBjRk9hekVTVzMwNUcweG5SbHJhSStwOWgvaTBjOW4y?=
 =?utf-8?B?U3dyMTU2SXBUYjE5TnNrVVl0VUs5c0pTblY5NWVuUHVqdGIyTGxsVG1DRUs4?=
 =?utf-8?B?Z2VMc1VkRjM3US80d1h5eXg1bk1XMi9mcjRIcTBzZkZmOS9lY0JYWERpTEVV?=
 =?utf-8?B?dzkyenErSHFHM0UrL3hkcG4rdzN3YnQ4MFFCRHNoREVCZWJCNlNMczJ3dUdC?=
 =?utf-8?B?aDhpSkFmem9lL0tCSmoxWlZSOEpHc2xUaU54QUJRY1VzMHFiam1RZHg0czVa?=
 =?utf-8?B?aGdLam01VFQwRGJmbFRnS3h4TXpvZnkwM000WHRON3lqZ3h6KzM3aFZNYW9n?=
 =?utf-8?B?K01TUkUvdUlxdjN4TWdqZXF6M3NuQWdURTZEWjZnbFhlL0ZxOEt1QS94REJx?=
 =?utf-8?B?QmpmWnFsL0V2Sno0MHlrRzZpUS9vMjkrMzRpZWNwT3FpUmc1eDdaZEROTndv?=
 =?utf-8?B?VmN4TmpHSUc4OGNQSDQwZFJONTE1ajRzWG5aRzVERkZXYzF5bXpqSWFUUzFT?=
 =?utf-8?B?dnZzckx2U211S3BGdUdhczREQWdYV0lhRWFPRmg0bngyN3lGakc5amwzZVJz?=
 =?utf-8?B?R0VwM3MvUFA4cVJPS1Rwc1UwMG9HUmRHbHAxeWhWYUl5RFNTY2RXeGtWb09N?=
 =?utf-8?B?bmd6aERvTS9iWmJwL042QjNnc2Vjb2QxdEtzTjBPbnk5ZFN4VnlEY094Ykhh?=
 =?utf-8?B?bEtObTJDVjdTZ3AzYi9QN2FMVGg1VjEvTGMwS0pMQXR3REw5TWlwOW1tRUx3?=
 =?utf-8?B?V0pUUTdKNE1iWEJFeXRmZlczSGhJWk56SmhjSEg0NVM4TGtxMUp3VWlYMEZa?=
 =?utf-8?B?WjE2WjlISHdBQkZaTURzMm81NW91a1BDdmtzc2RGckRhaWN3UTlWNjJ4WktB?=
 =?utf-8?B?REVLZHNYRkpCUWYyWHo5RU51Sk1HMXdVWlFSQlNKajR1SnUzc1l3anZiVnZE?=
 =?utf-8?B?cEpPa1ZXZUdZNUpKMWxweDB6K0J2OW1aQ0V5cTBUc2NSNlZOVHd2U0I4MEhY?=
 =?utf-8?B?OUxhUUVURUJqWWREcTZQZzJJcVJWd0U2dVNkVEtDVVpiR3NTd0FRL0ZmR3hM?=
 =?utf-8?B?Wkp3eVNaY0xDNkVCdnphWkZ3QU52UXdIaDlGeXp2eU5IckhyRXFiN3RpeVVr?=
 =?utf-8?B?MnB4YXJiemFLUGhtWmpydXpFSG5peitLR0pmRkhESHJ1a1J6WHRNLzJZd0gw?=
 =?utf-8?B?WnZtOWNYamlEVEN2UVYwVzRmYkRkNUxBYmpLdmVuZFlQbG50ZjlETUNvU2V3?=
 =?utf-8?B?cW1MS0JLY2ZIb1ZzNVZBdHFYYzM2QzJpRVIwMk9TVkNZeWFGLy9ZZkJSeHJ6?=
 =?utf-8?B?Mi9LN1FhclFUQVVNUndsVFB6MFRQM3ptbUJrcnZ1VFkyRlVYcHI4T2dwN3Jx?=
 =?utf-8?B?TFFmL1V3Y2hNOVRseVdFOGFxWnNuWXJRdVhOOTloNFduaEJCVWF6NDM5YkhC?=
 =?utf-8?B?M2dMSUtvYXlnWjdnbnQwOHdJdHhFZ2tQc3VhRGNVV25BdTFCZkpsbDQ1Tmg2?=
 =?utf-8?B?U1FPZDY2V211OW9HWWRrNEVPMkZhL3hyOC9jdjMvMnp5VklVek04RHNjelJL?=
 =?utf-8?B?QUlueTNZYUVCZHFTd1hnSXNTdFRvTDQ4bndvdVAwKzN3eDlKbkxkTnJZQnhi?=
 =?utf-8?Q?pNPFcbwjHU4tkeH7Q8o5/qdOk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED5665FAB363444B8DE05792BDE22E6A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f70fc33-8f78-4733-1192-08dad12a6cef
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 10:22:17.2472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ngRn8rLIPnwqC6OBCBAArA6VPrrvX/usLMNJvulDM3W6kExpOoudNYJxEd6z/kY9hy2Tvc9pFwdNB5ofeEvqsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4782
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTEvMjMvMjIgMTM6NDgsIExpdSwgWWkgTCB3cm90ZToNCj4gdmZpb19pb21tdWZkX2JpbmQo
KSBjcmVhdGVzIGFuIGFjY2VzcyB3aGljaCBoYXMgYW4gdW5tYXAgY2FsbGJhY2ssIHdoaWNoDQo+
IGNhbiBiZSBjYWxsZWQgaW1tZWRpYXRlbHkuIFNvIGRtYV91bm1hcCgpIGNhbGxiYWNrIHNob3Vs
ZCB0b2xlcmF0ZSB0aGUNCj4gdW5tYXBzIHRoYXQgY29tZSBiZWZvcmUgdGhlIGVtdWxhdGVkIGRl
dmljZSBpcyBvcGVuZWQuDQoNCkFmdGVyIHJlYWRpbmcgY29kZSBvbiBKYXNvbidzIHRyZWUsIEkg
dGhpbmsgaXQgd291bGQgYmUgbmljZSB0byBkb2N1bWVudA0KDQp0aGUgcmVxdWlyZW1lbnRzIGZv
ciBhIHZmaW8gZHJpdmVyIHNvbWV3aGVyZSwgbGlrZSB3aGF0IHRoZXkgbXVzdCBkbyBhbmQNCg0K
bXVzdCBub3QgZG8gaW4gdGhlIGNhbGxiYWNrcyBvZiB2ZmlvX2RldmljZV9vcHMuIG1heWJlIGlu
IGluY2x1ZGUvbGludXgvdmZpby5oPw0KDQo+IFRvIGFjaGlldmUgYWJvdmUsIG1vdmUgdGhlIHBy
b3RlY3RfdGFibGVfaW5pdCBhbmQgZ3Z0X2NhY2hlX2luaXQgaW50byB0aGUNCj4gaW5pdCBvcCB3
aGljaCBpcyBzdXBwb3NlZCB0byBiZSB0cmlnZ2VyZWQgcHJpb3IgdG8gdGhlIG9wZW5fZGV2aWNl
KCkgb3AuDQo+DQo+IENjOiBaaGVueXUgV2FuZyA8emhlbnl1d0BsaW51eC5pbnRlbC5jb20+DQo+
IENjOiBaaGkgV2FuZyA8emhpLmEud2FuZ0BpbnRlbC5jb20+DQo+IENjOiBLZXZpbiBUaWFuIDxr
ZXZpbi50aWFuQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWkgTGl1IDx5aS5sLmxpdUBp
bnRlbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3Z0L2d2dC5oICAgfCAy
ICsrDQo+ICBkcml2ZXJzL2dwdS9kcm0vaTkxNS9ndnQva3ZtZ3QuYyB8IDcgKystLS0tLQ0KPiAg
ZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3Z0L3ZncHUuYyAgfCAyICsrDQo+ICAzIGZpbGVzIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2d2dC9ndnQuaCBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC9n
dnQuaA0KPiBpbmRleCBkYmY4ZDc0NzBiMmMuLmEzYTdlMTYwNzhiYSAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3Z0L2d2dC5oDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9p
OTE1L2d2dC9ndnQuaA0KPiBAQCAtNzU0LDYgKzc1NCw4IEBAIHZvaWQgaW50ZWxfZ3Z0X2RlYnVn
ZnNfcmVtb3ZlX3ZncHUoc3RydWN0IGludGVsX3ZncHUgKnZncHUpOw0KPiAgdm9pZCBpbnRlbF9n
dnRfZGVidWdmc19pbml0KHN0cnVjdCBpbnRlbF9ndnQgKmd2dCk7DQo+ICB2b2lkIGludGVsX2d2
dF9kZWJ1Z2ZzX2NsZWFuKHN0cnVjdCBpbnRlbF9ndnQgKmd2dCk7DQo+ICANCj4gK3ZvaWQgZ3Z0
X2NhY2hlX2luaXQoc3RydWN0IGludGVsX3ZncHUgKnZncHUpOw0KPiArdm9pZCBrdm1ndF9wcm90
ZWN0X3RhYmxlX2luaXQoc3RydWN0IGludGVsX3ZncHUgKmluZm8pOw0KPiAgaW50IGludGVsX2d2
dF9wYWdlX3RyYWNrX2FkZChzdHJ1Y3QgaW50ZWxfdmdwdSAqaW5mbywgdTY0IGdmbik7DQo+ICBp
bnQgaW50ZWxfZ3Z0X3BhZ2VfdHJhY2tfcmVtb3ZlKHN0cnVjdCBpbnRlbF92Z3B1ICppbmZvLCB1
NjQgZ2ZuKTsNCj4gIGludCBpbnRlbF9ndnRfZG1hX3Bpbl9ndWVzdF9wYWdlKHN0cnVjdCBpbnRl
bF92Z3B1ICp2Z3B1LCBkbWFfYWRkcl90IGRtYV9hZGRyKTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvZ3B1L2RybS9pOTE1L2d2dC9rdm1ndC5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3Z0L2t2
bWd0LmMNCj4gaW5kZXggNTc5YjIzMGEwZjU4Li5jYjIxYjFiYTQxNjIgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC9rdm1ndC5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2d2dC9rdm1ndC5jDQo+IEBAIC0zMjIsNyArMzIyLDcgQEAgc3RhdGljIHZvaWQgZ3Z0
X2NhY2hlX2Rlc3Ryb3koc3RydWN0IGludGVsX3ZncHUgKnZncHUpDQo+ICAJfQ0KPiAgfQ0KPiAg
DQo+IC1zdGF0aWMgdm9pZCBndnRfY2FjaGVfaW5pdChzdHJ1Y3QgaW50ZWxfdmdwdSAqdmdwdSkN
Cj4gK3ZvaWQgZ3Z0X2NhY2hlX2luaXQoc3RydWN0IGludGVsX3ZncHUgKnZncHUpDQo+ICB7DQo+
ICAJdmdwdS0+Z2ZuX2NhY2hlID0gUkJfUk9PVDsNCj4gIAl2Z3B1LT5kbWFfYWRkcl9jYWNoZSA9
IFJCX1JPT1Q7DQo+IEBAIC0zMzAsNyArMzMwLDcgQEAgc3RhdGljIHZvaWQgZ3Z0X2NhY2hlX2lu
aXQoc3RydWN0IGludGVsX3ZncHUgKnZncHUpDQo+ICAJbXV0ZXhfaW5pdCgmdmdwdS0+Y2FjaGVf
bG9jayk7DQo+ICB9DQo+ICANCj4gLXN0YXRpYyB2b2lkIGt2bWd0X3Byb3RlY3RfdGFibGVfaW5p
dChzdHJ1Y3QgaW50ZWxfdmdwdSAqaW5mbykNCj4gK3ZvaWQga3ZtZ3RfcHJvdGVjdF90YWJsZV9p
bml0KHN0cnVjdCBpbnRlbF92Z3B1ICppbmZvKQ0KPiAgew0KPiAgCWhhc2hfaW5pdChpbmZvLT5w
dGFibGUpOw0KPiAgfQ0KPiBAQCAtNjcxLDkgKzY3MSw2IEBAIHN0YXRpYyBpbnQgaW50ZWxfdmdw
dV9vcGVuX2RldmljZShzdHJ1Y3QgdmZpb19kZXZpY2UgKnZmaW9fZGV2KQ0KPiAgDQo+ICAJdmdw
dS0+YXR0YWNoZWQgPSB0cnVlOw0KPiAgDQo+IC0Ja3ZtZ3RfcHJvdGVjdF90YWJsZV9pbml0KHZn
cHUpOw0KPiAtCWd2dF9jYWNoZV9pbml0KHZncHUpOw0KPiAtDQo+ICAJdmdwdS0+dHJhY2tfbm9k
ZS50cmFja193cml0ZSA9IGt2bWd0X3BhZ2VfdHJhY2tfd3JpdGU7DQo+ICAJdmdwdS0+dHJhY2tf
bm9kZS50cmFja19mbHVzaF9zbG90ID0ga3ZtZ3RfcGFnZV90cmFja19mbHVzaF9zbG90Ow0KPiAg
CWt2bV9wYWdlX3RyYWNrX3JlZ2lzdGVyX25vdGlmaWVyKHZncHUtPnZmaW9fZGV2aWNlLmt2bSwN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC92Z3B1LmMgYi9kcml2ZXJz
L2dwdS9kcm0vaTkxNS9ndnQvdmdwdS5jDQo+IGluZGV4IDU2YzcxNDc0MDA4YS4uMDM2ZTFhNzJh
MjZiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9ndnQvdmdwdS5jDQo+ICsr
KyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC92Z3B1LmMNCj4gQEAgLTM4Miw2ICszODIsOCBA
QCBpbnQgaW50ZWxfZ3Z0X2NyZWF0ZV92Z3B1KHN0cnVjdCBpbnRlbF92Z3B1ICp2Z3B1LA0KPiAg
DQo+ICAJaW50ZWxfZ3Z0X3VwZGF0ZV9yZWdfd2hpdGVsaXN0KHZncHUpOw0KPiAgCW11dGV4X3Vu
bG9jaygmZ3Z0LT5sb2NrKTsNCj4gKwlrdm1ndF9wcm90ZWN0X3RhYmxlX2luaXQodmdwdSk7DQo+
ICsJZ3Z0X2NhY2hlX2luaXQodmdwdSk7DQoNCkl0IHdvdWxkIGJlIG5pY2UgdGhhdCB5b3UgY2Fu
IHN0aWxsIGtlZXAgdGhlIGluaXRpYWxpemF0aW9uIGluIHRoZSBrdm1ndC5jIGFzIHRoZXkgYXJl
DQoNCmt2bWd0IHJlbGF0ZWQuDQoNCldpdGggdGhlIGNoYW5nZXMgYWJvdmU6IFJldmlld2VkLWJ5
OiBaaGkgV2FuZyA8emhpLmEud2FuZ0BpbnRlbC5jb20+DQoNCj4gIAlyZXR1cm4gMDsNCj4gIA0K
PiAgb3V0X2NsZWFuX3NjaGVkX3BvbGljeToNCg==
