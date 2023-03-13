Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE146B6D9B
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 03:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCMCrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 22:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCMCrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 22:47:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AF63BDA7;
        Sun, 12 Mar 2023 19:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678675626; x=1710211626;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t7ra9MhB1sPhe3c8BiPk+hlrGlU7UbnNGeknTcRuRDc=;
  b=bRrufMst4XnREiGgxyrGN0RtwVQMzFSb95zieZzdVIVkIbEnl3YOpRZ+
   sWrskyAfR2WrwlAg2D92bbtegM+fv+0543wh7wCjXRw4tLvKFF0D3BFdp
   +/9SvQOAYBqIGUzHu97v90nxssZF9rq4wWRBvp1MVdbgK7I7oVkJV9U8V
   oayGOcTvkNICS2wCKNkZDOOTOjBK+hjMVkIYTYakR8y4+0H5uu3jDU12u
   bZQ4EckmpV6PS02IflX/0/eVu17pOs3DvchTpTl8jCU2XoybQqxXF7ZfZ
   Hol99/xjuRjBu2Gm4q5EwpFa9O0TshIznnGmG2n76S8PDptYlWUp+T4mm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="317434879"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="317434879"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 19:47:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="710958615"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="710958615"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 12 Mar 2023 19:47:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 19:47:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 19:47:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 19:47:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJ123psRKDiUkWQ5HIiYIlM7rqgEk0Bwu2YxYuQ7Fk8UU+gRaFIETQ5QQ7g6m8o3NmakUfnaa8CkDt2k/3elM6Bqchc0kGR4si8qgx0ZbSvQcnOhyp9EIm44oFC572wMujmledcRFQRjDU7QjFc+yQqiwufNkeS4c5g9iyQkWMih9ULY6wXqFEChlG6wWS50S7S0Pn31D6dWYc9BIY69QqCkP7GAKWpuINIaKnHns/JRXKm80GrcPJYCcdNZpX11oi/iqbviLdU4Gb9v21c63OjKEbvXTgnyz9nh1FidwaTUDk/OTxm62TIkBHKBHSmiTd6nuMEf8JcDioIifrIg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7ra9MhB1sPhe3c8BiPk+hlrGlU7UbnNGeknTcRuRDc=;
 b=OqyaP4sPgTGe35tU9jPeTLDwVW6wyJUADJoimZfgi75BLk9YWMOfcg6cZYrLMSwr/KD7zz0WYdgRiJoBIfpXLczNDb6Y+6GTp/tsmHBZ8Am1o7F9GYh/5SpCGY+k9g73teAZEjWiCwfDDHw+0dqRyUyau4FuXGb7UPm6BBFXSG6t6qq6mCGmmt00h2kUGYLloEl7/AXsGaP4FT0sCUYw9j/YteBbwOWtihq8Ma2yTLhHjxKobIHiRy34A+WAMaM+9VwVaIvJy4WYUsKgGvSrRGYqnrWmHc6sbKeXI4tD2qvuKmit9Rwdme+q0zoWojLjhbjEfVbe7CwSHEFOmV4UZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Mon, 13 Mar
 2023 02:47:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 02:47:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v2 14/18] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Thread-Topic: [PATCH v2 14/18] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Thread-Index: AQHZU5lXMnpUqycUmkKZ0SzG1hqX/q74BPSA
Date:   Mon, 13 Mar 2023 02:47:00 +0000
Message-ID: <eb7ccc4f362ce833600f0096710003188571e4b2.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-15-seanjc@google.com>
In-Reply-To: <20230310214232.806108-15-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5830:EE_
x-ms-office365-filtering-correlation-id: fcc9344c-a043-4e3b-688a-08db236d3813
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t8qJb6vyxbvjtmHVqxWT/23iXDMRwyHPuID4qUEvzIUZ+2/GyHYTzBYYfTmkQyS4SvZWAaFd80aYJ+2o1Xsa8uZ2pgixn1p80bYZ6/DG50YOE+l4kjGt2s19ZpnEYbY0b1m/CuqBFIyG01h8096ifba3dP/BDp3rbNzfylZK/WfpXRkK8ZV8wMQ+IP8S1157Srf3VW5oY+ZpeZfRSi4cHT0D8trykh22OxJXDLOF7QkUpov9oqwp+lrCPyvmFbjW2lchbfxVz1NISRisQlEE+UzQHkmkQ1IlKb+3PvLTCNHPSKAo9lbYmV5eapA6oahcQxlP+O/y+6dduIQyN8x4dO1k+mXrxdSfktDqO1ldMKMfcNLLoOeSLVAxboxX59dKTjA+i6wAcxkgaw5HhY+iDgDGhZGd101PgEXoENJA2Iq0nQFGSNPAhCWiUOrxCsIP4+m0cDCaPVDYazPRDM5BaTdk3IPzz4Q2M4QdiQjHQ8/23YzYYJVBFfLdaP4m8OLtpgZhPOapQ/iG1/+WJtlJoYxVIhNMQi0yhg4a8NLUeHnas/a0dCTGRMx4q/yEKdNVM1kQfgd7mIFqSqLpHry6+F9f68KvDiOGcy5f91VCLTx5nv+GHQJbmDw2CNbC3+TFDyYoh2G+xyQ79bjbs4nA2EF/1wqEmomjN2KAQaRiW3SeHaXo9+eoD664x7PC/ISI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199018)(36756003)(110136005)(54906003)(966005)(5660300002)(71200400001)(316002)(8936002)(64756008)(76116006)(66446008)(2906002)(66556008)(8676002)(66946007)(91956017)(4326008)(66476007)(41300700001)(7416002)(26005)(122000001)(186003)(86362001)(38070700005)(6486002)(82960400001)(2616005)(6506007)(478600001)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEk5cE84aS9mUWV5akpVZ1N0WnluRDllMG9leDI2ZkZ2ZlBkUWNKZVIwMXNv?=
 =?utf-8?B?N3BGcWdqMnpwSlUycTdOamZ6aWdsK2NDTGd0cVBYOUdSVDE5VlpDK1NlWXhB?=
 =?utf-8?B?UkdnRkpGdG90K2FXOWxEWHVhejFGR2poQmdwdmkyVVh3cnpBb1Z2b2RMZTU3?=
 =?utf-8?B?eFZJbXBBTWRTdEZLNS9LQVZQNjdnZTIwcW5kSWY0eVIyWE9NQWtNUnBQeitL?=
 =?utf-8?B?aUM0aTVFUksrOVdZc2xURnhDendvck5sRG5rSnZvZ09DLy9KWnd4MnZURHRX?=
 =?utf-8?B?dERHQUY2dENuVUlqTGJWc1BSdWtKTmtJdXBvQS9xQzFBWTZqdmQwdy92alpF?=
 =?utf-8?B?Y3NnV25VK1cyZmZSYmFETXBlSUYvaFhoVDV0MzVRQnZVVjg1ZkhhOVFzUjhi?=
 =?utf-8?B?bGwvcHpuOE44UlZvYVpwb1QxeURrdnI2VDZpcHR1WnkyWjh3aE1ENFFEZC9l?=
 =?utf-8?B?ekU3QkdyWFVGTTd0Q250QUk4Z3dsdlN4V3ZseVdQU0cyeXI4YUZSbXM5NVNY?=
 =?utf-8?B?ODBydW9Gd0hIcjlkbFhYSVNaRWlmRGJGSDg4UW9zcE9BWVNtMkdmemM2U0VM?=
 =?utf-8?B?ZVhiQ1Nmd3RmL1JoWDJHRFBSRW00M0lCdnc2NW8rQytHWFZEdGxoRUQyT2hs?=
 =?utf-8?B?TTRVdjNBTmNIQjErMnlZVXBaVGFlQm1GZi9PY1RmWitUVkFWdEV1dFZueVFh?=
 =?utf-8?B?NDlnSG8vTkU5dm0xbGhrcGdqdG95M3JaMFVIeHZsN3BFUWxzYzJQM0ZheHdo?=
 =?utf-8?B?RG1mM2VqMG81cE1TUU1FRENPMVdPd1JwRzhmTEhSWHZydERoUHhBc3dRNFZM?=
 =?utf-8?B?RVFGTjdpWmh1anMrT0wzcGdXV1FXZHRybmV5b1J5cHFlM3FpYThLdFpqQVVW?=
 =?utf-8?B?UG81YkI2WU5MblQ4ZkZHcTc3b0RYaW93YzdlY3RGTkpzT1ZmMW04ajcrQnp5?=
 =?utf-8?B?RmFrK3ZuU0tpcGtJbWJNWGJ2TWpvenZCYXg5R3R5QWI0LzZienhGSHNXOEhL?=
 =?utf-8?B?VVlybnFsRWt5RWljMVovNC9GRjFyMVFET2RjY050UVc0ZUJwTXR0ajBWUGFP?=
 =?utf-8?B?SnZMUy80M00rWm1iT0dkUjlYVHUwc3F6bjJNQm1QdmJzQzhhRStod0lYNVNk?=
 =?utf-8?B?NVV1dW90K2s0Qy9pVkFmOHRJWlBkbkw4OUVDdDVDV3ErYllzM1VybG0xNzZv?=
 =?utf-8?B?Sm84bmhwWmh5MFIwUFhSNTFUUWhDVnBoeGE3WnNtWS9QSzR5R3pHUDl6YjU0?=
 =?utf-8?B?bXlScmVlV3hQQXNsbnNoTG1Fam5EYU9tVE54NHF1OWtSelZzdzZ2U3pTRlIw?=
 =?utf-8?B?ZWZNS3ZEY3MwaFR6U3hBdm1uWS9HTGgyMlU2RmZ4WTNwMWFpQnFiYWVlREJK?=
 =?utf-8?B?TVd6N1VwT2toZ29uRHdsUE9Va1NTcXpSVm9TSWhkVndCRkI5aDZDSUNSUkpn?=
 =?utf-8?B?MU1sY2JxU1ZFVVNMVFBRVFVXZk5hWDE1TVN1ZmNhQndiZXM4bGlwS2pDQzB1?=
 =?utf-8?B?Um9OV1lWY1VXQ1JjVkhvbkgxeWMwWEx6akFlNk9ja1ZJaG8zVkJ5YmdGbXpj?=
 =?utf-8?B?VG5uNGpMSUplNWVYMEVacjMrUDZWQmtnTkliMlBmS2ZMNzdGYndvWUZNSmhT?=
 =?utf-8?B?eGozVDRXUDFuWVcyaWhiSzZNSzFpRGNHalg2SHpSTmR3cndBbUZleWtzdTV1?=
 =?utf-8?B?OW81T0o0NVV6NWQvZUVkem9rSTZWNURNYVhnWGcyZFZIcTlRMTlBb2IxQ25Q?=
 =?utf-8?B?YzJDZ2U2b05FNkY4ZDQzb293OHRlc3crUEN6eFhUMUVSZnVieS9Kd0U1NUVU?=
 =?utf-8?B?ZFcvZ3plZ2hFNktRamFsSzRDS0hUeUJNVWRTT2JHYlNhRHc2VExKKy9tS3lI?=
 =?utf-8?B?K0J5eThGYjNFczVKYmpqd1dWOFRQODVKNHZjcjhnbHhiZ0dkTitHS1pNR1Nz?=
 =?utf-8?B?ckJ0azZCUkFmK0FDNzhUcWZ5Nmk1SWhMTDFNOFE1S3ZON01XeS9qQi9ic1Mv?=
 =?utf-8?B?NVFwOGdOOTZ0cU1STFpVZVhpYktSbUwyODVkc0c0QjJ0R1pIRnhBeVFlYkx3?=
 =?utf-8?B?czlUMDZPNFhRZm16Sk9HMTVKWHFmRUtJL2MxY2hEWlQ2NXpLb1V1bEgwTlNn?=
 =?utf-8?B?REF3MVhrV2VpU09FVU4zOE1UK3FyQnZrM2Vod3hqNi9mbHIzdmcrS3QralNi?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEB4B5D2DF15DD459F0A75F1DF34640F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc9344c-a043-4e3b-688a-08db236d3813
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 02:47:00.1791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MiS5Ocdq1KQZuTAaf4Lr9HpP2QlN3LUXjaHX6ymt7iTz9sjM9e4jOlRcp6BQHF+PD+mCzvkwsMxKh1RgxfK/+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5830
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAzLTEwIGF0IDEzOjQyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBDaGVjayAidGhpcyIgQ1BVIGluc3RlYWQgb2YgdGhlIGJvb3QgQ1BVIHdoZW4gcXVl
cnlpbmcgU1ZNIHN1cHBvcnQgc28gdGhhdA0KPiB0aGUgcGVyLUNQVSBjaGVja3MgZG9uZSBkdXJp
bmcgaGFyZHdhcmUgZW5hYmxpbmcgYWN0dWFsbHkgZnVuY3Rpb24gYXMNCj4gaW50ZW5kZWQsIGku
ZS4gd2lsbCBkZXRlY3QgaXNzdWVzIHdoZXJlIFNWTSBpc24ndCBzdXBwb3J0IG9uIGFsbCBDUFVz
Lg0KPiANCj4gRGlzYWJsZSBtaWdyYXRpb24gZm9yIHRoZSB1c2UgZnJvbSBzdm1faW5pdCgpIG1v
c3RseSBzbyB0aGF0IHRoZSBzdGFuZGFyZA0KPiBhY2Nlc3NvcnMgZm9yIHRoZSBwZXItQ1BVIGRh
dGEgY2FuIGJlIHVzZWQgd2l0aG91dCBnZXR0aW5nIHllbGxlZCBhdCBieQ0KPiBDT05GSUdfREVC
VUdfUFJFRU1QVD15IHNhbml0eSBjaGVja3MuICBQcmV2ZW50aW5nIHRoZSAiZGlzYWJsZWQgYnkg
QklPUyINCj4gZXJyb3IgbWVzc2FnZSBmcm9tIHJlcG9ydGluZyB0aGUgd3JvbmcgQ1BVIGlzIGxh
cmdlbHkgYSBib251cywgYXMgZW5zdXJpbmcNCj4gYSBzdGFibGUgQ1BVIGR1cmluZyBtb2R1bGUg
bG9hZCBpcyBhIG5vbi1nb2FsIGZvciBLVk0uDQo+IA0KPiBMaW5rOiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9hbGwvWkFkeE5ndjBNNlA2M29kRUBnb29nbGUuY29tDQo+IENjOiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IENjOiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNv
bT4NCg0KU2hvdWxkIHdlIGFkZDoNCg0KRml4ZXM6IGM4MmE1YzVjNTNjNSAoIktWTTogeDg2OiBE
byBjb21wYXRpYmlsaXR5IGNoZWNrcyB3aGVuIG9ubGluaW5nIENQVSIpDQoNCkFzIHRoYXQgY29t
bWl0IGludHJvZHVjZWQgdXNpbmcgcmF3X3NtcF9wcm9jZXNzb3JfaWQoKSB0byBnZXQgQ1BVIGlk
IGluDQprdm1faXNfc3ZtX3N1cHBvcnRlZCgpIGFuZCBwcmludCB0aGUgQ1BVIGlkIG91dCBpbiBl
cnJvciBtZXNzYWdlPw0KDQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9zdm0uYyB8IDI1ICsr
KysrKysrKysrKysrKysrKystLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0v
c3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IGluZGV4IDI5MzRmMTg1OTYwZC4uZjA0
YjYxYzNkOWQ4IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+ICsrKyBi
L2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gQEAgLTUyMCwxOCArNTIwLDIwIEBAIHN0YXRpYyB2
b2lkIHN2bV9pbml0X29zdncoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgCQl2Y3B1LT5hcmNo
Lm9zdncuc3RhdHVzIHw9IDE7DQo+ICB9DQo+ICANCj4gLXN0YXRpYyBib29sIGt2bV9pc19zdm1f
c3VwcG9ydGVkKHZvaWQpDQo+ICtzdGF0aWMgYm9vbCBfX2t2bV9pc19zdm1fc3VwcG9ydGVkKHZv
aWQpDQo+ICB7DQo+IC0JaW50IGNwdSA9IHJhd19zbXBfcHJvY2Vzc29yX2lkKCk7DQo+ICsJaW50
IGNwdSA9IHNtcF9wcm9jZXNzb3JfaWQoKTsNCg0KU2luY2Ugd2UgaGF2ZSBtYWRlIHN1cmUgX19r
dm1faXNfc3ZtX3N1cHBvcnRlZCgpIGlzIGFsd2F5cyBwZXJmb3JtZWQgb24gYSBzdGFibGUNCmNw
dSwgc2hvdWxkIHdlIGtlZXAgdXNpbmcgcmF3X3NtcF9wcm9jZXNzb3JfaWQoKT8gwqANCg0KSXQg
aXMgZmFzdGVyIHRoYW4gc21wX3Byb2Nlc3Nvcl9pZCgpIHdoZW4gQ09ORklHX0RFQlVHX1BSRUVN
UFQ9eSwgYnV0IHllcyB0aGUNCmxhdHRlciBjYW4gaGVscCB0byBjYXRjaCBidWcuDQoNCj4gKwlz
dHJ1Y3QgY3B1aW5mb194ODYgKmMgPSAmY3B1X2RhdGEoY3B1KTsNCj4gKw0KPiAgCXU2NCB2bV9j
cjsNCj4gIA0KPiAtCWlmIChib290X2NwdV9kYXRhLng4Nl92ZW5kb3IgIT0gWDg2X1ZFTkRPUl9B
TUQgJiYNCj4gLQkgICAgYm9vdF9jcHVfZGF0YS54ODZfdmVuZG9yICE9IFg4Nl9WRU5ET1JfSFlH
T04pIHsNCj4gKwlpZiAoYy0+eDg2X3ZlbmRvciAhPSBYODZfVkVORE9SX0FNRCAmJg0KPiArCSAg
ICBjLT54ODZfdmVuZG9yICE9IFg4Nl9WRU5ET1JfSFlHT04pIHsNCj4gIAkJcHJfZXJyKCJDUFUg
JWQgaXNuJ3QgQU1EIG9yIEh5Z29uXG4iLCBjcHUpOw0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICAJ
fQ0KPiAgDQo+IC0JaWYgKCFib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfU1ZNKSkgew0KPiArCWlm
ICghY3B1X2hhcyhjLCBYODZfRkVBVFVSRV9TVk0pKSB7DQo+ICAJCXByX2VycigiU1ZNIG5vdCBz
dXBwb3J0ZWQgYnkgQ1BVICVkXG4iLCBjcHUpOw0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICAJfQ0K
PiBAQCAtNTUwLDkgKzU1MiwyMCBAQCBzdGF0aWMgYm9vbCBrdm1faXNfc3ZtX3N1cHBvcnRlZCh2
b2lkKQ0KPiAgCXJldHVybiB0cnVlOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgYm9vbCBrdm1faXNf
c3ZtX3N1cHBvcnRlZCh2b2lkKQ0KPiArew0KPiArCWJvb2wgc3VwcG9ydGVkOw0KPiArDQo+ICsJ
bWlncmF0ZV9kaXNhYmxlKCk7DQo+ICsJc3VwcG9ydGVkID0gX19rdm1faXNfc3ZtX3N1cHBvcnRl
ZCgpOw0KPiArCW1pZ3JhdGVfZW5hYmxlKCk7DQo+ICsNCj4gKwlyZXR1cm4gc3VwcG9ydGVkOw0K
PiArfQ0KPiArDQo+ICBzdGF0aWMgaW50IHN2bV9jaGVja19wcm9jZXNzb3JfY29tcGF0KHZvaWQp
DQo+ICB7DQo+IC0JaWYgKCFrdm1faXNfc3ZtX3N1cHBvcnRlZCgpKQ0KPiArCWlmICghX19rdm1f
aXNfc3ZtX3N1cHBvcnRlZCgpKQ0KPiAgCQlyZXR1cm4gLUVJTzsNCj4gIA0KPiAgCXJldHVybiAw
Ow0KPiAtLSANCj4gMi40MC4wLnJjMS4yODQuZzg4MjU0ZDUxYzUtZ29vZw0KPiANCg0K
