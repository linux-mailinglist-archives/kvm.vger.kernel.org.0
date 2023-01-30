Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AC2680F66
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 14:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbjA3NwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 08:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjA3NwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 08:52:23 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E0238E89
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 05:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675086741; x=1706622741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P8rAuLX/NNPJBmsJ+vrVoCasNODDsriZc9Z1nVISlPU=;
  b=nuCvUDlnmKX8Hh4qriDGH7fcJPxhluNqq4IwADtYfcz+MlA0xLdfucVy
   KU2gcsC0mdMv8Yeq3xQgIN3d9o2iuJeCMi5+Lhe0cuT+IwBngUvtojlFl
   dtxiswR9L5yjfy8/mJ+CyEUdEvkE3jy5FyFy6x9EjKAKaup45OnZM4cOY
   nRSvpEDitQp+jGccYHQ5+y0vT6ray/5i6JynccCuXETg/UJYw81ZfWmhB
   KEDedl3Wf+Dz17aGw8+/PSBMolh8OndCdV0ylb48m4tcnaGZiO5zbOvc7
   o+Jdgf2WGwG5bPKTXMw3eugZ/lkLqQwCjq6AzZ5oygrrrJzsYn9BIR1d/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="311178538"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="311178538"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 05:52:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="641550196"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="641550196"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 30 Jan 2023 05:52:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 05:52:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 05:52:20 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 05:52:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJ/1xcwYAqH31S69DXovHeOwk81de7B68ompKHFzvYo5wRJH/ftuom9wpDjsDm7JvL7fLA5mcfsnqnl20qhjcK8lJQt39pVwHL7AwWr2AHvy5I1ZVB7adoPbOleU9gsEwg27dkDgL5eObuYy8mgcNNnLJArmdXeLC3AnJHXLPOYDneB2t0QyUkCpGJZEUyOSl+++rMxOMfMuFcMbQwrGgjQlr+c2XobH3atSWjKLsPC7jh+Txp3aTfWu678MGjU5Lmu7fqdgojLZqTVnSETiWCGGDxqJIQNCWHxfN4e9cjoxn8IRNdc5lLuH/HJGE9bVOd34ru4odkG912kBI4uf9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8rAuLX/NNPJBmsJ+vrVoCasNODDsriZc9Z1nVISlPU=;
 b=gNtJeRj+l1EmNOo3ZLGED0LZvHDsGqPn83AJ7/7xFxzsJAOzqpi6fhMuVRgAvWc1vCppTLeGsgROX2KgTwbdwchsbHMXEUobVv24fAn0Ih6lMR/v+vRHthylgpW17I7i2YqoqQgEgXZWKhqcQd63kTPgQwIJ0OYB43FkT2E1LDywymrTAMYvMgPSdR/xPYpu4FuyJkj1JGPzSImQSihcuwVA2X/HcoERj0Y8IFb1H1YLUxHWRRyiuQsbbDXKuh5yWYAAZjg257pvRzBDUT5h8/ErZwidFoud1sDI3xIeMU1j3IottYqQ3De1EuVO5djFFlwl76Ip/anZyoZJ5A/tYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5475.namprd11.prod.outlook.com (2603:10b6:610:d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 13:52:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 13:52:17 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 09/13] vfio: Add infrastructure for bind_iommufd and
 attach
Thread-Topic: [PATCH 09/13] vfio: Add infrastructure for bind_iommufd and
 attach
Thread-Index: AQHZKnqY260TmmopQU2QvQkLUHfEK66lgIiAgBGOVdA=
Date:   Mon, 30 Jan 2023 13:52:17 +0000
Message-ID: <DS0PR11MB75292A18056953962A3E3F1AC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-10-yi.l.liu@intel.com>
 <BN9PR11MB52764F98E64DE3BB8305F7248CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52764F98E64DE3BB8305F7248CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH0PR11MB5475:EE_
x-ms-office365-filtering-correlation-id: 365d9d34-9ab8-462e-b224-08db02c93359
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CBgifKQfCCaq6vXhOvzYn8t9VbDb+99qcBC56+pqbZvX0u0emFvw7AJOncrvxa/qulOGTHRGbaHRvTYPQGT6hWM3NwGgFzmjekvwrl7FUoFQ8MGFCycAL5/Jd7uWNL4d71QrmMWgLloPbE4AGVUryi3vEe6KKjpvg4XpJ+0m+cpUNMKUTRcuAATglRbN99X2Cbu+oe+ElzqZqAFhqLFLbeSGE+BPNOVB9ntbUSv/yVCGG7gXI3wc0pQKRd5MbfjMsRiXRpZT+VbAS1c1ZjAW84OAJ5pw8balHDAIhrDDnQ6uRrpUMpYUM1w922M71JBn8WOxYlK2gVl4Pf7bqZ9bfdJm5oDvs5nv24x8I4+wa1efJNI4tmTMadfdUv93Wu4CBsHkfMEn+KvtATzL4uEMjW7Ytlw0Zy9hotfjhaUipdSYiN9oK8ocIAWsDgsmoaY36e5NjeqbboiUGXuqN5YltK3vgXn33Tbm0ejH/iytyj9S4EEwIru4uhoXXB/oLSDCNHQWxHKfp1xmClcnRVnKgZXaxCHAGAF8ezoFiHJiIP3bHdYwnZImKFuHK7VNd1nDh2mBIw9ZSo2kPBjh/M160REcOjSpot3JHglL+pCr1CeR3kFg5vY6StzfnJu4BtJCF7k6NUvuXmZ5QZqcx1oywlO/T6JvhrR4BZ3e7vhTTW93YWIueG+gSNaAykWyivenS8zaBou2VVJQqfEqCxzXJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199018)(8936002)(41300700001)(86362001)(5660300002)(52536014)(38070700005)(7416002)(83380400001)(82960400001)(33656002)(110136005)(55016003)(54906003)(122000001)(316002)(66556008)(66476007)(66946007)(38100700002)(64756008)(66446008)(4326008)(76116006)(8676002)(26005)(9686003)(186003)(6506007)(7696005)(71200400001)(478600001)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVpjRkF2MUtFcERKV3BJbFhaRmpxRDJObURrRXJVWVNRa1ZFVUlIRm4yM3Fp?=
 =?utf-8?B?alJCUUlZbGJNbTZDKytRODZkdWZTRk5lYWVKcURWNlZFV3hGalQxbzdXL1ZT?=
 =?utf-8?B?NEJPOE04Qm9aajUwMGNGKzFqVFpMYnY2NWdMeE9UNnBUK3lOU1ZjdSsrTHpW?=
 =?utf-8?B?am5oZFA3TWI1YXdCc3RzQXB0Zlk4czgrbHc2Unhhcm80c2tHOE50dEFQMThU?=
 =?utf-8?B?d3o5Y2pYOEp3UkNLZXpkZmtSSDhTd1JOcVRwblVtRXdMUitCSmZTdGtpd2xn?=
 =?utf-8?B?UkhBcjVPc0w0Z0VrMVZsekFpUktoRUo3eTB0bnFSMzhUUUhGZVV0NmoyVGll?=
 =?utf-8?B?TnlSQldIZS9jaDdiY29FWmUrWkRyNUhvUDVRbldtb3NlT3lYNEREV2F4dVZS?=
 =?utf-8?B?Szh3Z3RlSVJxRWNnK3MrTXJDWDhydFMvM3QxOVA2TTVJbkpjRFBSRXd3YjBX?=
 =?utf-8?B?YnhsaFBZM3NGRTQ5QStmZXlERnI0Qnl5OG9zVlRkbFFJOHJLUTdFVFdVTFBj?=
 =?utf-8?B?dkl0WndUR0ZZU21DRlRsYUowVUpwcHVnLzVUS3VzTmNCNHdCbjhSK2ZJRHRo?=
 =?utf-8?B?Qms0UXhCYU0zKzBVUk1aS3lPbisxd1ozTnViOWxiWE5wZm5hSGFPZ2Y5eWZN?=
 =?utf-8?B?NlhSRUJrbEk1OFFrNzBZODRJc0xNclJXc3JTOTRCRzlEQjVWcFVIWVc5RVQy?=
 =?utf-8?B?RFhhMkwvQzhJMzdXNEtTdE1yNXlNcUh5eVlvZ2toZkxuM3lxOTB5ZXZITWNl?=
 =?utf-8?B?TFdQUWtHT3hGMW5GcTg2N0w1Q09kaXFNdlBkMW9Kc1BSeVMzaUNRUEZPRHcv?=
 =?utf-8?B?c05PcHBGckZRa3B2UmhKK0pSRUNLM2txS0ZCRkN0d2tPbE5kTkFOcXJXS2lz?=
 =?utf-8?B?SW1SNmtZUzdOR21sdWZrbXRrYlJlbVJFMmY1WDdHWnpsV2N3bml6S2Vpa3Jv?=
 =?utf-8?B?MG9qUDJGdU5oZ0JjZjhuVTlFUkZGRktzQXVTeGE3SUZUbmE5WkpnV0dsNlFX?=
 =?utf-8?B?eWg2NE5XL2RQZllmRExWY0RrS1V4VlRsOFlBeEpKS1Q4N205RTkxRWlVeW4v?=
 =?utf-8?B?NnYrZDMvcDVEVHd2WXFKNUFPZ2VtU25YTzVwZG5jZFBrNXZKOTh4bjY3SW1V?=
 =?utf-8?B?QitDRE4vWlFVTGNsRThyYTJzZ1JxOVVBdFFGQU0wRFZ5VnpHTXBySUJVdnBK?=
 =?utf-8?B?RDFPZnlPcS9nQUVHd0xLZzBpVERoK3FPOEVNd0kzYWk3cXp6LzJaaWNYUjVm?=
 =?utf-8?B?SUUzMVl5NVE3MGJMQ3g0U0xTcEZvRTdKWGxqdmNvbVMwSjhBWUg1QkhEeS95?=
 =?utf-8?B?b0NRNHBqSjVVTHdCZUs4YWJ2aDZFcDV4RnBaRXRhNlJsUkw4N2p0a1doN0F2?=
 =?utf-8?B?T0FZYTdrT0NEK0JnMFprODBDUGYvUmRQUHlaOFQrRVFqcno1U2d3Z2ZBYm9q?=
 =?utf-8?B?eGVYT3JWeENMRi9uRWVpN3gyUUlhSkFJZ3hZbGlMZkNvZlNLS1RCNUtFemh4?=
 =?utf-8?B?eVFHUXdub2RLTW50ZTlwWmNnYTZ0eUZ5LzA3YWJzei85YldpU1YzWUlRMjcz?=
 =?utf-8?B?bks1R2thY2lHWHJVM0xxUSt3TDNNdWZ4aGUxemd5QWVIZ1VhV0xBbU9wZU5q?=
 =?utf-8?B?dmlFNWFnM2JlNit0cEhtSTNGVjJ4LzNuYXVvN0VlSExKZVNFTkdsNklCSHFs?=
 =?utf-8?B?eTJzcStpNmJFTDBkZUJiRUdMQ1NTenVKeEdxeE53M25GaHdjNHBxcktEMnpE?=
 =?utf-8?B?WEdlbzRZNHRiOERDQUgwZytrbWhIU2wwMkU1VmszQ0dkNFloMUJmS2hZd2VO?=
 =?utf-8?B?b3BJaWRJemk3V3c1MGQ5NW9vR3h4S2U2bU1LRVlsMDBWVnM4MkRTNzFVOVRR?=
 =?utf-8?B?MWpvd2orbWw0aXI2aDRyd0k4eU41MlVnWVFxZzZpQTErN1lrSDBJMUk5OWNH?=
 =?utf-8?B?eG1kSWkyaEVPWHg0TDZrTjVXZU1CeXpnYmhkYzRHcWt3Y1lXZVVMTFE5cFo2?=
 =?utf-8?B?UWZJN2xucXl5WDNacEEwZkU1S1pZWG9pMXB1eGZURE9ORVFRdWdITG15blpM?=
 =?utf-8?B?ZDdOK3hyK1QrUkg3cFhCeGlHbTFlQ2FwYm5YNmZBRmdPSHp4MnJ4UUZ5Y1ZV?=
 =?utf-8?Q?5zgM33UFv03j8GTsw3Rwqpgm7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365d9d34-9ab8-462e-b224-08db02c93359
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 13:52:17.5630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2kevwnVd0olmUByEg3XYGThAFdjKjDPKvXr5PZmpetNUUthdLt7Umwxp+ilQF8R8YD4Iqh3lNtwgmB4BVoNpwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5475
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBKYW51YXJ5IDE5LCAyMDIzIDU6NDUgUE0NCj4gDQo+ID4gRnJvbTogTGl1LCBZaSBMIDx5
aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gU2VudDogVHVlc2RheSwgSmFudWFyeSAxNywgMjAyMyA5
OjUwIFBNDQo+ID4gIHN0YXRpYyBpbnQgdmZpb19kZXZpY2VfZ3JvdXBfb3BlbihzdHJ1Y3QgdmZp
b19kZXZpY2VfZmlsZSAqZGYpDQo+ID4gIHsNCj4gPiAgCXN0cnVjdCB2ZmlvX2RldmljZSAqZGV2
aWNlID0gZGYtPmRldmljZTsNCj4gPiArCXUzMiBpb2FzX2lkOw0KPiA+ICsJdTMyICpwdF9pZCA9
IE5VTEw7DQo+ID4gIAlpbnQgcmV0Ow0KPiA+DQo+ID4gIAltdXRleF9sb2NrKCZkZXZpY2UtPmdy
b3VwLT5ncm91cF9sb2NrKTsNCj4gPiBAQCAtMTY1LDYgKzE2NywxNCBAQCBzdGF0aWMgaW50IHZm
aW9fZGV2aWNlX2dyb3VwX29wZW4oc3RydWN0DQo+ID4gdmZpb19kZXZpY2VfZmlsZSAqZGYpDQo+
ID4gIAkJZ290byBlcnJfdW5sb2NrX2dyb3VwOw0KPiA+ICAJfQ0KPiA+DQo+ID4gKwlpZiAoZGV2
aWNlLT5ncm91cC0+aW9tbXVmZCkgew0KPiA+ICsJCXJldCA9IGlvbW11ZmRfdmZpb19jb21wYXRf
aW9hc19pZChkZXZpY2UtPmdyb3VwLQ0KPiA+ID5pb21tdWZkLA0KPiA+ICsJCQkJCQkgICZpb2Fz
X2lkKTsNCj4gPiArCQlpZiAocmV0KQ0KPiA+ICsJCQlnb3RvIGVycl91bmxvY2tfZ3JvdXA7DQo+
ID4gKwkJcHRfaWQgPSAmaW9hc19pZDsNCj4gPiArCX0NCj4gPiArDQo+ID4gIAltdXRleF9sb2Nr
KCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ICAJLyoNCj4gPiAgCSAqIEhlcmUgd2UgcGFz
cyB0aGUgS1ZNIHBvaW50ZXIgd2l0aCB0aGUgZ3JvdXAgdW5kZXIgdGhlIGxvY2suICBJZg0KPiA+
IHRoZQ0KPiA+IEBAIC0xNzQsNyArMTg0LDcgQEAgc3RhdGljIGludCB2ZmlvX2RldmljZV9ncm91
cF9vcGVuKHN0cnVjdA0KPiA+IHZmaW9fZGV2aWNlX2ZpbGUgKmRmKQ0KPiA+ICAJZGYtPmt2bSA9
IGRldmljZS0+Z3JvdXAtPmt2bTsNCj4gPiAgCWRmLT5pb21tdWZkID0gZGV2aWNlLT5ncm91cC0+
aW9tbXVmZDsNCj4gPg0KPiA+IC0JcmV0ID0gdmZpb19kZXZpY2Vfb3BlbihkZik7DQo+ID4gKwly
ZXQgPSB2ZmlvX2RldmljZV9vcGVuKGRmLCBOVUxMLCBwdF9pZCk7DQo+IA0KPiBoYXZpbmcgYm90
aCBpb2FzX2lkIGFuZCBwdF9pZCBpbiBvbmUgZnVuY3Rpb24gaXMgYSBiaXQgY29uZnVzaW5nLg0K
PiANCj4gRG9lcyBpdCByZWFkIGJldHRlciB3aXRoIGJlbG93Pw0KPiANCj4gaWYgKGRldmljZS0+
Z3JvdXAtPmlvbW11ZmQpDQo+IAlyZXQgPSB2ZmlvX2RldmljZV9vcGVuKGRmLCBOVUxMLCAmaW9h
c19pZCk7DQo+IGVsc2UNCj4gCXJldCA9IHZmaW9fZGV2aWNlX29wZW4oZGYsIE5VTEwsIE5VTEwp
Ow0KDQpZZXMuIPCfmIoNCg0KPiA+ICsvKiBAcHRfaWQgPT0gTlVMTCBpbXBsaWVzIGRldGFjaCAq
Lw0KPiA+ICtpbnQgdmZpb19pb21tdWZkX2F0dGFjaChzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYs
IHUzMiAqcHRfaWQpDQo+ID4gK3sNCj4gPiArCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJnZkZXYtPmRl
dl9zZXQtPmxvY2spOw0KPiA+ICsNCj4gPiArCXJldHVybiB2ZGV2LT5vcHMtPmF0dGFjaF9pb2Fz
KHZkZXYsIHB0X2lkKTsNCj4gPiArfQ0KPiANCj4gd2hhdCBiZW5lZml0IGRvZXMgdGhpcyBvbmUt
bGluZSB3cmFwcGVyIGdpdmUgYWN0dWFsbHk/DQo+IA0KPiBlc3BlY2lhbGx5IHB0X2lkPT1OVUxM
IGlzIGNoZWNrZWQgaW4gdGhlIGNhbGxiYWNrIGluc3RlYWQgb2YgaW4gdGhpcw0KPiB3cmFwcGVy
Lg0KDQpZZXAsIHdpbGwganVzdCBvcGVuIGNvZGUgaW4gdGhlIGNhbGxlci4NCg0KUmVnYXJkcywN
CllpIExpdQ0K
