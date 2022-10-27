Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9E460F2B7
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiJ0ImZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiJ0ImX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:42:23 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347841213D2;
        Thu, 27 Oct 2022 01:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666860142; x=1698396142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UAEvtr1v6b/I3pQr5xW/9F2HAlbJjnw9Wtbw7sSPqTQ=;
  b=J524rp1DwyzOHeVBfXIj3Xh+SHziQ7Qv57dZqNpFpR+BdU+13F9Pp0OJ
   4JycTJKejJMiADz1NZabhOFtYSwFUaNPqCshq9Ki3SSMedVnLrcQRaTUk
   6TqMUc9xgCzSdokepY2zL8wGE/dDFPuPgPplsC0+jy449b+c9Fg3KMuuX
   bcBZQgDDLiGhPYuqxZ/Ra/BHWomEuSQEV4GCsTqhofQnZsl+piPwHF0i7
   GTpIt5+glXYvzM0zBx78f4F+ts3j6ed9tjjSc8OlwkZtnLI2Yo1hyyBRC
   dxm4OWbXBuKobaSCv1gcbZDfEyin5kERP5a7vg9oYmuWdqhAufMtxJ6ck
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="287883224"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="287883224"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 01:42:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="663539891"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="663539891"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 27 Oct 2022 01:42:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 01:42:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 01:42:20 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 01:42:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUkdGHjZ/7Do+Ef9Yavcna7XsEqJLaW29ocZy39C5rWTuznMoYRHaPk2kJueszpsmndxwYvhibgjonpsjXN42pjc8ta3T7Fig2WDCIJW1KtbtmRX5gi+Ib+k3L/ZpcdKl6Ocpod3Jp0oR6R97uLn4qtE1IHpGhmakfhC5sqsgNKNXUNMLUtUX2GS/41z0iAhrbxoAx+IB+4FSa0vJwGn56G4zGEVP7VrKx0rWhD0KnnkQtdadT2zSDBBIiAcOAAZfDaJd32uOhvciVLZiPAiQcyxzNdgzo0TibfeZ4t/obXFPJ/Zl/QnBUiDTsAS8IlpYd5nu06tvv1hRu13+UEIwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAEvtr1v6b/I3pQr5xW/9F2HAlbJjnw9Wtbw7sSPqTQ=;
 b=BYFRMqsoB2gJVDap3Pc+VCKU/7eO1Pt0HSZa0rtEzP6tKyPD4bwL6I9XbHYQd8wJz2TK8Jd/BaRKTDQ8XfGR7KvNWvBXNoelJ4Vrq/MlJE6+KgXl60v/bOCSTphdF+Q9MJeojRs/BuVOBXvvSjSJa7/jOT1siMtRnm7i26xdvDcVgBZ7SCsCrMmECuF2ImQKVI5KNuu29Cfbw5oIzybRxRYUy35BjYobc7xXqFHiWWgYCYAzKNO5BoCvux9827FC9flVjziIvV3/XM94u2BswWlkidIWEA7bisGiqLYnck0/291FXbTQ2sxZYxS2CDRoE9z6EPHn02aqe2df/PmT5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO6PR11MB5618.namprd11.prod.outlook.com (2603:10b6:303:13f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 08:42:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Thu, 27 Oct 2022
 08:42:16 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
Thread-Index: AQHY6Y2c1fkWJEN4oUaD5m/zaHt0F64h0pYAgAAaVoA=
Date:   Thu, 27 Oct 2022 08:42:16 +0000
Message-ID: <d19c81ef34856f72c964322a7390d6fa21976e6f.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
         <80e8111b-76a2-4999-782b-fdd4b9f425fa@intel.com>
In-Reply-To: <80e8111b-76a2-4999-782b-fdd4b9f425fa@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO6PR11MB5618:EE_
x-ms-office365-filtering-correlation-id: 25a413b2-ef26-4aa4-dc3a-08dab7f7270a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yty8PyoND2Z10GHQ8XaLQE8hykRWXXTNhhoddh4O3dnmvWL0AzHvT104087jMNILRWbQQkuCTXE5lkw2cvf7Lp2IqN9Px0ad3a7B7cqEDp6vFUI/rwqrgVMpvEMchNjJ2Ht++Nl5VLfPqwjQu/y7VobeDajOw5aUDwPg7GJoZx29kK5Lykry+LZAwoFLvQWbgJn+nIXw5hKNOCHlkcF1ahy0EdTkjGmpKdz+jOyMrecXbuw4iOIOaZi73K4LnEn4idhPuD5IFU24cBshPFOS4TJuQoQL0AQkd7WiX+GyjZtEMpBrJZHH17FiZAdmjtqkf0XowxnL2q+IgqIXnzAD71KGkwgOdLozx1D73SJncEsXJDXUShbvoYMB7NaYNFNSoeHxQ8MR4V0DDnYG98Ba+cof3pU+tzRyUQ9whxRyFWYS2sy8eHJf21qvJFMlJ3esWeWk3QRQy4e8h+3NltujZ9TphUsxOGWLO2XRhnCn2YjRH9goSMACKngWXCCTOps54wuKFtdPix6ts856s2qGwVLyfMnJ0LJfGz50dTKF1mM6w3xWCvy1l4JaSGGfheogzTvIQKFoSllBgL2YU4if37PBMCpkEVyEh33OaoWMHLwJhdV8N/JYWxfL/ovuW/pnody/l9Y3JTUMVAmpojOFPSb5fhGPvFbst0fE3r7Yr4QMP25dOOrF97AYimA1ZI7VEHb7uLUN6k13yw00O7WqVhlEg1y4NGMGdE4XxqqzmuEqgLwZajRstCCUHQJaGGc201VoIiMcRW7cDORcq66FTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199015)(91956017)(54906003)(6506007)(316002)(6512007)(26005)(76116006)(8936002)(4326008)(66476007)(86362001)(7416002)(110136005)(4001150100001)(38070700005)(66446008)(36756003)(66946007)(66556008)(8676002)(64756008)(5660300002)(41300700001)(2906002)(478600001)(6486002)(122000001)(38100700002)(2616005)(71200400001)(82960400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEJGc00rUXpKMW5uelB2VGNmMXAwRjFESTByeXA0NHBLOG10SlVPWkFuYWtB?=
 =?utf-8?B?NFhiWi94VlIwbzhHN09GSzZPNW1LdkZNM2x1NjJpaG5FVGtSZkFwT2dLMllu?=
 =?utf-8?B?MEJUM2NVMXQ0UGI0ZFdUV0o4ZWllbXlzUjZtTTAxM3NVVHhYOUtJWkFrd2V6?=
 =?utf-8?B?bVFGSDNVMDVoWFVFWktPNDFWMjZXS1h5N0tVckEvNWRVV2hod2V3Wkxzd0Uz?=
 =?utf-8?B?aWtlSTMzY3kxVTRCcExDQUxaQ2c0WEdicHJGclhvNGVWcjIrZmtvZFpNTkpF?=
 =?utf-8?B?b0szdjRlUytqQ1BZVG9FRWdGaVZiUi93RkJFUktlcUVEVkRGRHdzV0Qzajhy?=
 =?utf-8?B?MCtOVmoxOFRrakd2RkdGTzAyek9iM0RHZ0FHSDd0Q0d0MGxNT1FHYk9FNHZK?=
 =?utf-8?B?OG5LYUV3VEIxSlNUUmN6K0IvUnVjcUJob3lBeCtQemNXODExbUFlOXpJY2tL?=
 =?utf-8?B?MTY2Z2hWRUttUDBKM0VXbThwTUx6M1pXRmV1SDMxN0FjdkpMakg2OHlLK0F1?=
 =?utf-8?B?WFIzc2JMcSt4RGttS3hTV2FHL2VvY0FtbG5WVVI3ZmN2bWRYVGdPVXNNcnNz?=
 =?utf-8?B?TkUzSXpvd3FTaVg5NytvSUoyS3ZmSU50Y3duUFdzK3dNZnVleW1TU2drNTR4?=
 =?utf-8?B?T014UElCcC9nTTlHK0QvZUttaTlJVm0yMzdRV0ZhdE5SZVBIK0NremFyRlZC?=
 =?utf-8?B?N1dTQ1dqRFpRTFF3azJ0bWdmYURHbXA5aHRtdEdzczdlU044YUlGYkJkZFZv?=
 =?utf-8?B?TDZvZVc4SlhNSFhqSG50UmFhU2VrNXI2dXcrazMrbGZtS3FqNjhUcHpFY1hw?=
 =?utf-8?B?U3JlNk9DRFAzMlgxU1B2UG9qWlpWb0hScnIxMnFwZEtrZERVRytQOEgxRW5Y?=
 =?utf-8?B?clVTWEFudmluNjllRnR0ei9tY3BCbG42RVAwSHlNWnBxbWV5aC80SmpzSUQ5?=
 =?utf-8?B?ejlKb3BwSWtXMHFOOVN1MnlNR3NxTGF1eWFDRzVYZS9LdEYwL2Fzd3VYSzlT?=
 =?utf-8?B?Q0c0Wmtnc0FQcGQvYllDL0F2a0x1QTQvanN4NmxwbjhQTWc5ZDJIRk52cEZK?=
 =?utf-8?B?emplRzJ3ZHFaM0IwZ1ZWdmQyL0NuS0M2TjI3dXBnWHVLeCtYaUJVdHgzdDNL?=
 =?utf-8?B?WDl6S28xSlk3b0NidjBLcUZCQWlzcWVpN25JYzd6SmZBTFZyUE16VVo2bEZa?=
 =?utf-8?B?ZFJuc0dkckRkdDNFZnRDR0NtenA1TjJid1pTQ25HQjJJSDFrRTRXUVI3Nnor?=
 =?utf-8?B?alhPNFNkNUsrNHVjSGFqc2daUGlaZVRUdjR1Tnp6Q2NHb1lmWGpWVEU2bUxJ?=
 =?utf-8?B?MGorcTMzR1h6NEJuOWtqdHA0d2RLdmJrOHFZNUdWTlNoT0pFbWdERW5BSHU1?=
 =?utf-8?B?STRaTE1NRzN3T0NTSEJvRzh3M01HWnVxNlp6ekJLa1JwUWZqcDBiWUVjOEJL?=
 =?utf-8?B?djRDRDRIOHc4eEJvY3pYbHNBUzBYbEhWclBNNmZjbTFtd0IveGFPN2dzdE51?=
 =?utf-8?B?NEJKRS9uamc5M1UzckVXMkpUZUFSdGdmcStnQnZsUlVMQ1J2QWhXRWFjNC8x?=
 =?utf-8?B?VUNGamFHVTBJWWZkdWhrMnZGdW45OXVobGxsOGpOeEJxUzkvU1lDYklSYUky?=
 =?utf-8?B?ZUo5bk8zd05qalRjNkRoVHhNZTFnOFczOEJPb1N6dktUc2NXNkwxNDhERlFZ?=
 =?utf-8?B?K3BURW5Mdm15c3ljR2FHd01uN3FJZGNJSmQ5bllCYWdPenZnVEdQRkZVTWl3?=
 =?utf-8?B?b1ZPdGpUc3kwUUFMM1BsNU5wVHVDMTY3dTBvaURrWTU0dXY1amNSUEdVbE1Q?=
 =?utf-8?B?cFlrWjBOa0loU3hsUXJ0OElKcWNqNnYvZGtHazZIQXpSYVg0SXlRWWwzQzU2?=
 =?utf-8?B?WWZLZ3lKaGphYWRqTGhaYVkvNU5ncW1aTlh2aHIxcU1nYWtWQ2xjTTJBMlRu?=
 =?utf-8?B?RmdqSW1mUy9zS0g0Y1RzZ3hNUEl0aG5tc3B2VkJPelhJTlRPWFRzei81c21G?=
 =?utf-8?B?dXVFTVNwS3VzQytCZk9aRThaVkxLM0FYcExsdnNtOTlwcTBDOFdyajNlUXdG?=
 =?utf-8?B?dDBQbFdFKzJHeHFPbkpoMnIzVUdWSGdQWDRLMkJ0Sk93UERKdHl1d0pkUm1Q?=
 =?utf-8?B?OXNVVXJjdjE2NHg1c2VGeXk4dzRuV001eEZmSTVJUUIxTmFMU1h4UjZYQnlG?=
 =?utf-8?B?U3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D000FFF3525F3C47BBAA2D31C7AFCA71@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a413b2-ef26-4aa4-dc3a-08dab7f7270a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 08:42:16.5541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: klhlE0+3qqXDfbCCP5ux8vauS0OsAB47xE7FQ1d+HhCpWfcDjj0IHYbmldLAExRh6iYslA/RebP8IG39hYvsdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5618
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDE1OjA4ICswODAwLCBMaSwgWGlhb3lhbyB3cm90ZToNCj4g
PiBAQCAtNjYzLDI3ICs2NjIsMTYgQEAgc3RhdGljIGJvb2wgdHJ5X2FjY2VwdF9vbmUocGh5c19h
ZGRyX3QgKnN0YXJ0LA0KPiA+IHVuc2lnbmVkIGxvbmcgbGVuLA0KPiA+IMKgwqDCoAlpZiAobGVu
IDwgYWNjZXB0X3NpemUpDQo+ID4gwqDCoMKgCQlyZXR1cm4gZmFsc2U7DQo+ID4gwqDCoCANCj4g
PiArCS8qIFREWCBvbmx5IHN1cHBvcnRzIDRLLzJNLzFHIHBhZ2Ugc2l6ZXMgKi8NCj4gDQo+IHll
cywgYSBwYWdlIGNhbiBiZSBtYXBwZWQgYXMgMUcgc2l6ZSB0byBURCB2aWEgc2VjdXJlL3NoYXJl
ZCBFUFQuIEJ1dCANCj4gZm9yIHRoaXMgcGFydGljdWxhciBURFhfQUNDRVBUX1BBR0UgY2FzZSwg
aXQgb25seSBzdXBwb3J0cyA0SyBhbmQgMk0gDQo+IGN1cnJlbnRseSwgd2hpY2ggaXMgZGVmaW5l
ZCBpbiBURFggbW9kdWxlIHNwZWMuDQoNCkkgY2hlY2tlZCB0aGUgVERYIG1vZHVsZSBwdWJsaWMg
c3BlYywgYW5kIGl0IGFwcGVhcnMgeW91IGFyZSByaWdodC4gIEJ1dCBJIGFtDQpub3Qgc3VyZSB3
aGV0aGVyIGl0IHdpbGwgYmUgY2hhbmdlZCBpbiB0aGUgZnV0dXJlPw0KDQpBbnl3YXkgdGhpcyBw
YXRjaCBkb2Vzbid0IGludGVuZCB0byBicmluZyBhbnkgZnVuY3Rpb25hbCBjaGFuZ2UgKEkgc2hv
dWxkIGhhdmUNCnN0YXRlZCB0aGlzIGluIHRoZSBjaGFuZ2Vsb2cpLCBzbyBJIHRoaW5rIGZpeGlu
ZyB0byB0aGlzLCBpZiBldmVyIG5lZWRlZCwgc2hvdWxkDQpiZSBhbm90aGVyIHBhdGNoLg0KDQpI
aSBJc2FrdSwNCg0KWW91IHN1Z2dlc3RlZCB0byBpbnRyb2R1Y2UgYSBoZWxwZXIsIGJ1dCB0aGlz
IHJlbWluZHMgbWUgaG93IEtWTSBpcyBnb2luZyB0byB1c2UNCnRoaXMgaGVscGVyPyBLVk0gc2Vj
dXJlIEVQVCBjYW4gYWNjZXB0IG1vcmUgbGV2ZWxzIHRoYW4gdHJ5X2FjY2VwdF9vbmUoKS4NCg0K
UGVyaGFwcyBJIGNhbiBqdXN0IGdldCByaWQgb2YgdGhpcyBoZWxwZXI/IFREWCBob3N0IHNlcmll
cyBvbmx5IG5lZWRzIHNvbWUNCmRlZmluaXRpb25zIHRvIHJlcHJlc2VudCA0Sy8yTS8xRyBwYWdl
IHRvIGdldCByaWQgb2YgdXNpbmcgbWFnaWMgbnVtYmVycy4NCg0KPiANCj4gVGhpcyBhbHNvIGlt
cGxpZXMgb25lIHRoaW5nIGNhbiBiZSBpbXByb3ZlZCBpbiBjdXJyZW50IGtlcm5lbCB0aGF0IA0K
PiB0cnlpbmcgYWNjZXB0aW5nIGEgcGFnZSBmcm9tIDFHIGluIHRkeF9lbmNfc3RhdHVzX2NoYW5n
ZWQoKSBjYW4gYmUgDQo+IG9wdGltaXplZCB0byBmcm9tIDJNLiBJdCBjYW4gYmUgY2hhbmdlZCB0
byBzdGFydCBmcm9tIDFHIHdoZW4gVERYIA0KPiBzdXBwb3J0cyBhY2NlcHRpbmcgMUcgcGFnZSBk
aXJlY3RseS4NCg0KRGl0dG8uDQoNCj4gDQo+ID4gKwlpZiAocGdfbGV2ZWwgPCBQR19MRVZFTF80
SyB8fCBwZ19sZXZlbCA+IFBHX0xFVkVMXzFHKQ0KPiA+ICsJCXJldHVybiBmYWxzZTsNCj4gPiDC
oMKgwqAJLyoNCj4gPiDCoMKgwqAJICogUGFzcyB0aGUgcGFnZSBwaHlzaWNhbCBhZGRyZXNzIHRv
IHRoZSBURFggbW9kdWxlIHRvIGFjY2VwdCB0aGUNCj4gPiDCoMKgwqAJICogcGVuZGluZywgcHJp
dmF0ZSBwYWdlLg0KPiA+IMKgwqDCoAkgKg0KPiA+IMKgwqDCoAkgKiBCaXRzIDI6MCBvZiBSQ1gg
ZW5jb2RlIHBhZ2Ugc2l6ZTogMCAtIDRLLCAxIC0gMk0sIDIgLSAxRy4NCj4gDQo+IE1heWJlIHRo
ZSDigJxwYWdlIHNpemXigJ0gY2FuIGJlIGFkanVzdGVkIHRvIOKAnFREWCBwYWdlIGxldmVs4oCd
IGFjY29yZGluZ2x5Lg0KDQpQZXJoYXBzLCBidXQgSSB0aGluayAicGFnZSBzaXplIiBpcyBhbHNv
IG5vdCB0aGF0IHdyb25nLCBzbyBJIGFtIHJlbHVjdGFudCB0bw0KY2hhbmdlIHRoZSBleGlzdGlu
ZyBjb21tZW50LiAgQW5kIGxldCdzIHNlZSBJc2FrdSdzIHJlc3BvbnNlIHRvIG15IGFib3ZlDQpx
dWVzdGlvbiBmaXJzdC4NCg==
