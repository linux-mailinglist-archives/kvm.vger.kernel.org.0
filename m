Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338E863B5AC
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 00:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiK1XK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 18:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiK1XKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 18:10:41 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E989531DDC;
        Mon, 28 Nov 2022 15:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669677038; x=1701213038;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=doHIUUueUFlPAJ88VKvZQgG52hW6bwyweTjTvGXznbk=;
  b=XL47/MLIQ3Hsxnj9Y4Z4aaDe2o6goLvXPy8ffNYzM6TIzdZ7p+5QoPE5
   TO87gyTPVlV0XVj+ePxiBYKppGczMl5KMdQbbQ8VChtgDFQ2Wk06A79sX
   cRUcRCkVoS+BoePGNsPPqJ2nBLi0Gv0x/vuZxvO7bxqT92SQ38yW4coA6
   jIzdVHfDBrPlC4IbOgHX0uGzoXwZ2i9X6BP7D9QY9ucw5ara9j9lmPV6y
   zQdj9pR6i3cJkjz5n7X8yfz/NJCIfAEi0zCvTyaV8t1bxWVckO3Fl7/qc
   NhPVDImOzX40vakYkd8W1eNsAFxwUjzYK4fu2HHnqw3q6fVny6RHA7O6D
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379229908"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379229908"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:10:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="594046461"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="594046461"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 28 Nov 2022 15:10:35 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:10:35 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:10:35 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:10:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDH2lw2DX/xILgP2aLM+Ycuv65cFV/dAuYFFsNYHvc5Yb8E6ZRXqp+D1dysK+g1G5+yIuVxzVfF40KPg5Ag+TTmDmfn6/qVKdwv2zEgmVvqqmCYU2fWaueUs4GKElmfqHzPhvhyUFpAKG0EUNC3jZMkOo0NnSk12TfikySvwhSWncYVWdaV6QYPAr9XNRcEYHYNdvBB294WumB9ty09woBE30r4sjIhOba0kZdpHArW2/mmGA5uYINbeAW5kyPceWo5rVg7BsdFaQyf970gnqBfQSBWC92zIDviUx6CwjWPE7/+aGwJ1xXXqzvnqn2JuALE9Z1r+Qs8r5t+ew0v+uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doHIUUueUFlPAJ88VKvZQgG52hW6bwyweTjTvGXznbk=;
 b=S+sEghRkRJe4KCK6M51N66AJag15IuPLQIxMwti116HJmAlx8Ff3Au1AZdbsR/ea2EMiO3sXPeqTHs3aayvKVk/wbltcYm0nqLXBWZrBrVTRQnhhE5VJIRCvWRCmUCSWVsRmVB357loFFNaZT5yq/++h5g2AZCGDh87XwlvGIlSVmdQb6GhH+H7wFA4ETIriCDuCGuGN6+NfpUitDxc0cuqdmzGDZaPLnm96NNvqM56RTtR67FCcna3VaLJwTbDBEmXWeJG6KfXkd2SlBv3SurYcUEDniFvKMvdP2/oEjwrKaDDqps+vJUkhpe3iot5Tw2FhMVn+oQpcFEwu/NUCZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5049.namprd11.prod.outlook.com (2603:10b6:806:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 23:10:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 23:10:32 +0000
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
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
Thread-Topic: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
Thread-Index: AQHY/T3PFb2p/zo5A0CRtiPfoDprYK5NLyGAgAbp/4CAAEQfAIAAmLCAgAAJeQCAAANVgA==
Date:   Mon, 28 Nov 2022 23:10:32 +0000
Message-ID: <bfd09ea94fb9067f9ef8dc284a18800cac31be05.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <5a5644e691134dc72c5e3fb0fc22fa40d4aa0b34.1668988357.git.kai.huang@intel.com>
         <5526fedd-fa54-0ad2-f356-94b167e6e290@intel.com>
         <0ebf26d1ee540b4e082b65c51cabe3327f6d51ac.camel@intel.com>
         <c752d17e-23fd-4452-e1d8-6c82748b6c8a@intel.com>
         <2b3568f3ff472a83c0539aa351cb0c1fec834728.camel@intel.com>
         <aa80863f-ab3b-c3d2-917d-b2b7e564a4ff@intel.com>
In-Reply-To: <aa80863f-ab3b-c3d2-917d-b2b7e564a4ff@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5049:EE_
x-ms-office365-filtering-correlation-id: f16caf27-6672-478e-5cbc-08dad195bfe2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ODyCJ5KNJESzCvYyiZYj3r9Bt5dwu6ofQaGzgHrvQGSgrmdSQkWi3bwIZwOK4NnUn6t7GrKSXlU6NoNuwONFMCFXPBGUSlKptJx5BBhdt+uOFS82pwEVrykom083J2XAzjZbE8+0gfSUSyS4H+Izb8EDbXybEg6pGRUxZ/95z7TPu/LNSA65ZGXnqvXsK4WGbP5ixpmCoz/HGbDGId4Rw1nzK0d07nEVAcixUMR1ma0D77h3yj+8tLUOZokftfrjDLBouJCL+/VqyiBMuLl9BwdFrFGj4NHzhAssPWN2ifhi75j2RPIu5keQaUS4lT7kjwJUV4+n8TiJmGmclpqh3Lvgv0rMqHu8tYD6vtC96wQg6PwS3677pSSOVlxwuNrBJOA8SRXtlo4xlKKe3Ge+BjWovhHt76jayKoT1KRlQIFkrhGtGwacdxd3o73SwxnF2qeUv4qmZCZpWSN0YiIL2X0/RHbi9/eFRICYz1Y6jhSSdx2HToKg7wEnZkKUqjKlYAD61cIWBCI2nBOYEZcupz+WdW8nxBhl/CrVvfQReFhpYjwaeVOBM3oSbuTEcYnwnba3ClN/SUzlCCQLYSprUevggnPUZdu/QKH+dg1IoBsf5SFy0sBZTm1g8/RMCY2PPc+akfF7ml+zaUcZ84WzC/hOOBCLwb+/XlfbBiMKwKzpGeWEuIPb400/UpC9r4FFrgouk8Fa3aHUjHeNWwN9DGdpENUsMWPkNVC+11wEXgY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199015)(186003)(2616005)(122000001)(41300700001)(4744005)(8936002)(7416002)(8676002)(2906002)(36756003)(86362001)(4326008)(91956017)(4001150100001)(110136005)(66476007)(66556008)(64756008)(66446008)(82960400001)(316002)(76116006)(66946007)(54906003)(5660300002)(71200400001)(6486002)(38070700005)(478600001)(6512007)(6506007)(53546011)(38100700002)(26005)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3hLank4dmt0d05TUzBmRFp1V2tVT1hyU2lHWkVJQzdOckp3MlVQeWRvZkdQ?=
 =?utf-8?B?RzRwWVhuNE10bWQraldUVmlsSXlESWJMcVRTb3ZrdnIrejY5TjdYeExyMGg5?=
 =?utf-8?B?bDhWTW5KUXIxVU91MFk4VEhCRHR1ZXJwa2NCMVp2VlJZRDZkdlBEcFhvdkF5?=
 =?utf-8?B?eCt3Sk83NlhwUWFEc3VOVGIvTzVRbmFPdmQ0c2RzYjdDcFU4WHdJMFppWjB3?=
 =?utf-8?B?ZEFkSzlJUG1GV25hcGw4ZFV2MmhLWEM2RHZWM0lwTEdNZjBLdEoxTmpubHM5?=
 =?utf-8?B?M2Y2RWJwY2ZXWXdrVDlqdjBQMGhXWlpjT1ViY0pwSnJiSXZaQmdpeEsyb2sy?=
 =?utf-8?B?ZFpISnJmbjhrOWdORnVTZkFDWHEvcE8vVVRScDRIL1RQOFlmRzU1ZmFpWk1i?=
 =?utf-8?B?ZUtDeGROazVtT2xqWVAxanJINnZDM2c5c2JMai8rMitpelNWWVF2c0tISkFX?=
 =?utf-8?B?bFlNclJ3alRUbGNpMFdhb1FTRTFtYnFQV21mc252aE1zdnQ5dmZ5QkwyOUY0?=
 =?utf-8?B?OEdLR3ZlM3FraHo0UERpYTVZd3ZVOVQyVWt5Wm9paDdLei9jWElYQ054RVc4?=
 =?utf-8?B?ckF1emFGc0hMZGlDUkF4NmU4SWd1OU8yMDFXR2Rnb2xSazAzYkdTblV6UWdG?=
 =?utf-8?B?MUlyQ3FsWld2TEVlYU1XcmJ0REtXNkxPZVNoTFJSL1Z0aml0aXNWakNLTUEz?=
 =?utf-8?B?Nm9Mc2VrOVVCLzJCWGJmT3VMMVpXY2VqQlIzODNFSW9qL2doSnpYYWdFM1Zn?=
 =?utf-8?B?aWppbnU5L01tcjBqclBNNWY4d1pnL1B2R0t5Zk1IUWlPTkZibVpLbE1rSldF?=
 =?utf-8?B?R3k2cWl5MEpoWE5mV01senNLTUVqU1FwODNQQVMyT2NPdjYwT0tXT28wL2Rl?=
 =?utf-8?B?RGVzVy9iQUI5SFBpTkprTExtUXJWL0M0ZkFXMG92Y09XNC90VDBkSW9zWHU2?=
 =?utf-8?B?a3hkWFJWdXRPZmxOZWl6UlhwM2Vsa2Z2MzNqQ2xjRWxiTGtMZjBtNmRCVGk5?=
 =?utf-8?B?UTMrQXJ1aVFiZzlNZTFjMXYwcnY0Yllkb1E4VmJWYjBKN0JpYWoxT3UySkhp?=
 =?utf-8?B?TUN2b0xYVFUvSlQyTjVUTGp3UFZ6L3NRTm02QzZjUjNVRTFyOTM3S2djWldo?=
 =?utf-8?B?R09NMExtbzRKMWt2WDBQSHpVV0JXeE1ZVXNYVVpFZmpwUHpZWTZEUnRveHhs?=
 =?utf-8?B?akNEY2R1Rm5JVUtPbzZ2NFg2TldUYlBNWjBPck9vK2tsM2dmRkJVTzZwZzFT?=
 =?utf-8?B?b0RGc2M3c1dHZFd3RlJxWkVIU1BYR2pMblhHdG14QklQL1Q4cjdUNGFnd3dT?=
 =?utf-8?B?WmZEa0tYMjUybkxoK2VzSm11SWV1elRscE90aHZKT3VycDRqbGkxNE5QSFNx?=
 =?utf-8?B?YXcyaTQzWWc0aEpLeDVDZlp1OWFleHNjN2dRUjg5bzZZeGIzKzlGUW4zQmlw?=
 =?utf-8?B?bS9sckh3UkhaT0JEbzJBS3ZtZXBEcnF0aVF0Um5EWEVER0tYNUVpOEtsMDM1?=
 =?utf-8?B?Nm9RZjRMc1FmRUpSWFZHR1J2dnh5d2wwZ3ZQMHBaTDU4c2xKQXRoVTR3ZHl0?=
 =?utf-8?B?STB1K0s2a1BibzAwaUV4QTZUWlJOY2FaSDMzTTRFTmZxWVphdWlkTnMxOVFw?=
 =?utf-8?B?ZnlPTnRGaHdMZDRnaTd3cGhXdHZwLzAwVjl3VDdleHlsMVdUd2RGRmt0ZTdn?=
 =?utf-8?B?NmttN0J6UUFid3l6YVI0T1pqc29HNWRxQnRsYXoxVDc1cDJtL0d0QStvUk9W?=
 =?utf-8?B?aVlJV01ROUdwOFljUjdROFVHNjlKM0poVlAxaEYvNStFcU44bXFaeG5DOW1L?=
 =?utf-8?B?THBnOS9Yc3B2QUFvM0poYmhUYXU2SnRHVk5VRHEwWVVlMlNIY2s3NTRtZDF5?=
 =?utf-8?B?cDh6RjdpVDZ0R0sxRUZndTJSV1BOQndvbENQTzNHSUh3eFhXM3hhZEtRVWRi?=
 =?utf-8?B?aTNXQzNZdWhtSzM1cFF5bmF4eUVVM24raW94UVhicUNtbmZEUWptMGxVK2pS?=
 =?utf-8?B?dkVyU2J2RklaRkpydlhQYitWN2t3Rnc3RDk4WWdjb2RweTUycVh0alRoV1Rr?=
 =?utf-8?B?TFhvdVNWMnBRcTZibk9lUEVuNUh5NHErOHNxOTZpRElrUWpvM2ljUUpqWVNa?=
 =?utf-8?B?OHdPbXZrNU5jazlEeHlJdE04OG1VVy9paTUzcFNqWWdLOFppaEVhWC9ISThv?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70B84892D5E7464D8D8C2E744AF477B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16caf27-6672-478e-5cbc-08dad195bfe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 23:10:32.5337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KusrJ59LNcF92t1voYgMn14C6jgtzOqZNt/r1vkV3qpQMA4/Euw/BUY8Brm8gwGDbME7JrWvhmqCRyQq6BMb0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5049
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDE0OjU4IC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDExLzI4LzIyIDE0OjI0LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gSSBkb24ndCBrbm93
LiAgSSdsbCBsb29rIGF0IHRoZSBuYW1pbmcgYWdhaW4gb25jZSBJIHNlZSBpdCBhbGwgdG9nZXRo
ZXIuDQo+ID4gU3VyZS4gSSdsbCBvbmx5IGNoYW5nZSB0aGUgb25lIHlvdSBtZW50aW9uZWQgYWJv
dmUgYW5kIGtlZXAgdGhlIG90aGVycyBmb3IgdGhlDQo+ID4gbmV4dCB2ZXJzaW9uLg0KPiANCj4g
VGhlIGFsdGVybmF0aXZlIGlzIHRoYXQgeW91IGNhbiBsb29rIGF0IHdoYXQgSSBzdWdnZXN0ZWQs
IHRyeSBhbmQgbGVhcm4NCj4gc29tZXRoaW5nIGZyb20gaXQsIGFuZCB0cnkgdG8gYXBwbHkgdGhh
dCBlbHNld2hlcmUgaW4gdGhlIHNlcmllcyBiZWZvcmUNCj4geW91IHBvc3QgYWdhaW4uDQoNClll
YWggc3VyZWx5IHdpbGwgZG8uDQo=
