Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1546FFF21
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 04:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbjELC75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 22:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjELC7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 22:59:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571B21B4;
        Thu, 11 May 2023 19:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683860394; x=1715396394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XVy2vDwkX0LC3h3vtH2Z48ruQ7KEvxrsXqUxPyfwGGE=;
  b=WZMYF6yMytYw1uFa52EnItR/xjRYGmYD6rEdYcDG3ir70rr1AW7dgYGQ
   LamWHTfMj54BvGFQKkZRsD2qI9PG5lx8ix0+v3E2louGPfHc2HGnRdRHa
   ZYg7mRNn82u4Izmov49MgyGuWBADXEoj5tywThZADoT2AQpcSdDDNRV8Z
   ksupieunt+h5hcVxT5pFJPFZ36v/o0BWFKN9t7MYmOR79rEa8Cwe/9vJ7
   oxOJbO9iG1BHQjq0w5Ka3aPElq2jed3VgFaAXTqlwhg3jhP9kB64EEVE1
   tsPr8jPziplvo9U952lISexZeL1wPyoR/chCnznJ42a51COBuQvrz7DJF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="416315629"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="416315629"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 19:59:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="730640935"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="730640935"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2023 19:59:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 19:59:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 19:59:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 19:59:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvPeJCnd6k3BMJe25vRoebA+FwGquK4YT9SEoTGpYtgJJSUmvZCUxwwDXJAHuQvg+2Jfhx43dpj8VmSwSQz2rrNZ3ObX8oe/SQCaTgktcKnohjrzWhD6IkNznzleW4sKEo2eczPZca2/2JfdhZn65Pi4R8qI8v98T249AYS4TpJomACW0ZGSDMZFqVXvcfUUTYrIRYV53il/DertW26zfXpV8Wx2cf11UWPibkg2YsMhZdcLou4BWIRgnJIfbmpYxl69KM5wK4QCh/MQAYC6GnYrWp7s01ScmTvNuWQ8WAzKKXVCfPkIRYf1yILO9iTQlN6oeaoHs7+XYaYBb88RdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVy2vDwkX0LC3h3vtH2Z48ruQ7KEvxrsXqUxPyfwGGE=;
 b=cABTVc/iSbFMhU7KDM/It9RTccawZDo3GEgkcrGMUSVT7oIhLi3xjtUGW0VS1w2PFELtseEW9PyfYwH2lJit0Dj7US1z79ixOq3DYEx6P2CuguyhG8nLoRq/UVWAZ3B2ICDwCo7BDRED1ppwQtwuejoEPYGPh9RJThvUQWScTTDZCqeGfhc4bK+iw5GLGDEgxUKvrNndLvOjAcW3HJgJ6gt1DZBClCs4qK9UVW5ozAH1k9gABaqptdafo2vLvb5k3gUCedyhXi/RxxEuhiXKrts4xzrdmoB/twsaEOlritTd4hMjYmWeHKII2VNAFz/0thE61N/bHeiF5JE89c8WeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS7PR11MB7887.namprd11.prod.outlook.com (2603:10b6:8:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Fri, 12 May
 2023 02:59:41 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::6f80:cda7:a88f:3cc1]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::6f80:cda7:a88f:3cc1%3]) with mapi id 15.20.6387.018; Fri, 12 May 2023
 02:59:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5ABFkrqAABzyefAACRsDgAAgPFxw
Date:   Fri, 12 May 2023 02:59:40 +0000
Message-ID: <BL1PR11MB5271F073616B5869E380DD208C759@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230510112449.4d766f6f.alex.williamson@redhat.com>
 <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
 <49063f2e-4ab5-1e20-093d-e1a0b3c15481@linux.intel.com>
In-Reply-To: <49063f2e-4ab5-1e20-093d-e1a0b3c15481@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS7PR11MB7887:EE_
x-ms-office365-filtering-correlation-id: 423cae4c-d439-4ee4-1461-08db5294ee41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JwlnIB9LR0CoULHEmTbMN1eOukXuwnXVUH1YKv82QOzIl9UUAUIkYHi9H74Pt65mW4E9tPD4w9P2O4hKrO0Ur1QhJhkll1+EQoBHFJLraujT4DUQZzToDZgE4Pi4WgCrk4rm3Y+AihObaACHHodZuPELTg39h0I2TQJcL9PUm4dFBIfvysj0YWdBFGAfbldcbHPfr+CVyAo4yKFLaGQ5eU8FOBjxxrE5vfyWwTdVB76v7V4yi+NagbIsuTzYIwSzYOd5o9Ml/a8CgoN1UAh6NM0H83m9MCARbPtE+dRJcsp2cOGgVzBJmUZQKxyK3n2jPclCl7FP/djJi4pbtQmepbiJ06s7QbowVRva9WVt1NTboNueXRVSo6h1OU/2BRFCqFBjtB4VdxNKMC60PGq3Jmx+OIUs8qVds6Ftl0GCQ3ZD5pU4FLD8AfofxI7idNVjYWyr+adkFz6X8NOwTpTYwq41kNq2uCT0ok/OmjwGOEcK2QxwCImdz9vns/8vpsveDbGPWb4HYWETaWLoquE/wYByL2dDhTvGvUzVbaisZ/UedGuPZMZc8IJvbK6AqZnz2LBjlL1doQ0VGRXlVnHn/HgrqSkTXDZLGuo0gdQsXtM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(86362001)(83380400001)(186003)(38070700005)(66476007)(66446008)(66946007)(64756008)(76116006)(4326008)(66556008)(6506007)(2906002)(53546011)(9686003)(26005)(3480700007)(33656002)(8936002)(966005)(8676002)(38100700002)(41300700001)(7696005)(55016003)(122000001)(110136005)(316002)(71200400001)(54906003)(82960400001)(52536014)(5660300002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUd1bHh5dERRSkpDbUNBbU1MdmY3aHJNNWdBZDRrM3NVM2JvRTJpdTJFZmJC?=
 =?utf-8?B?eEN5Sy9VZjRGZ1BpVWpzYTFmN1dPVGozaVR4TzFudHJISlJwSnI1SkNySDJZ?=
 =?utf-8?B?S2dOeWNaY1B3SU1CNGVWNUZ2bjlDRGl5MW5zc1RObUNCaXQ1MkJrSHhNaDF3?=
 =?utf-8?B?U1dPVVk0SDQ4Q3V3Rlo4ZzEzMk1IS2NGSmhGM3BKbFd0TG03dHBxajVhNjJS?=
 =?utf-8?B?RVluWlRDbFJaL1I0aE9lMUxVaHI3N0tBdHZzb0xxbEcyeXBSR3oyajROd2VE?=
 =?utf-8?B?eTI3N2QrdFNCZ0c4NC9EZmdBNFJNNnZQOGF0STdabFZRZjhGWFJvVWFRa3dQ?=
 =?utf-8?B?N0hab3hyaWgxRk50Z0tDU21NdW5sN1NFb0paQkFDN3ZMZlFYUDNpb0Jrdnhs?=
 =?utf-8?B?ZDRmT1RaWkNRNTZFRWZ0VkRoSHR4cDlnNllCS21PVjB1blR2dEJjQXBWZUk3?=
 =?utf-8?B?bWJrbGcxUVU2TWZWazZUdHBnRzNibklrcytvSUovYmxhWEdybnZqTVArTmtL?=
 =?utf-8?B?VzNXNmFsS2tFczFmN3RqUDc0NU1vVmszYWlMTGowdWl6SXpFK3FoV3g5WTNm?=
 =?utf-8?B?VXdhQ2s2MGxIUHJBa0FzdUtjVG1lTXhkaVVBeE4ydVlBZnFOdHdrM3pxbmFX?=
 =?utf-8?B?SHhnNElFZVpuc2pURndZQkVWU1ZCdEx0QWtsOW5ueEp6QlROQVJKMVhRMkdI?=
 =?utf-8?B?UFdKeVBDVUZrMmIxL1N1Y01NTC9VOWVha1FFQTRXQUVPamYwT2JiTmc2a0lx?=
 =?utf-8?B?UXRGNkZxQkhyTVp2VnhRaTVzSEJ5S0FTRlpEVk9QZkJDNWxWVjFoV25VY1RV?=
 =?utf-8?B?OUhUTWQ5YXFxdXRwenk1eFhjV2JRS1JhM3FkdEVXaGdJa1RCQ25Fak9TK0Y3?=
 =?utf-8?B?SXZTeW1jNEtEN05GVFg2UUFXS2xTZHQ1YWNOZWFXYVBORnpsYUFlVmFSbWpF?=
 =?utf-8?B?aW13OVdyS0hHdkYydjFnekhXLzNmUmxQVTZIdEZkR0ZXb2V1Qk8rWFZnZWVW?=
 =?utf-8?B?TC9qOStqMDRpelZwb3BMOGxNKzJWQ1pxbnU5YzkvZVVGY3RndHdWRFJGYTR4?=
 =?utf-8?B?Tm1xdkVwbmJ2L3RFaHRLdGdYQkdRR1dHYzl1OXUrYmNNTUJ3MFdOMFgzeWZF?=
 =?utf-8?B?azVMSU5CVis1aEwwdCt2MGpGY2lSYnJsWWJNY3hyY2Fpbkx0KzR2MCtYZmpi?=
 =?utf-8?B?VlV6NnZiUHppemdjRWpWaGtQZlZuTTI0LzRiWVJqKzVKTldwOTg5VTNreG9H?=
 =?utf-8?B?TVc4VS8xOW5nRU4wZVV0YXBLeTAzYmVVQ1ExTkJaVXlkM01CYkQ1YkhWZXVM?=
 =?utf-8?B?NHpTdGpXdVQ3T1l4YVpaUlVhOHRPSjNsaDJBNVZsOGk3SW8raU1vcGRkM3FR?=
 =?utf-8?B?Unp3NDhPVzYwQ3hyRmprY04vZXJ4YmRRa2k3bU9PL1BMbHZEOGl4U2ZrZEJ1?=
 =?utf-8?B?TTNWb1lJdU9vNDQ3ZWU0VEU5ZjBjZldoVW0veFh3bUdZQ0Fzb1ZSc1pRYnJB?=
 =?utf-8?B?TVhobno2bXlZVlVZNDZPSGZJUTdXeVJGZjJxWFBlMENpWkRrZnNkc1VVZ2Nh?=
 =?utf-8?B?N0pJZ0F6NERWSkdwUDVGSndCZnplbmRXdFh2dURCL0hLNXk0T2RUUFYwSXVm?=
 =?utf-8?B?RldYM0lua2RLcG1hZDBTSy9VVDdtQy9yTld2d3R4UUJRK0FvYWEra0RZZkF2?=
 =?utf-8?B?SDY4QVZHUXNJVUhENEovRkZKWlY4M2grZVNhU3RXT1pzL3psdUhTK1ZWeWxT?=
 =?utf-8?B?QmpvamV1ck5Ec3RQeCtGQ2Jpa2IrVjFpREhBTHlheW1zNFJjTXd3enVYczk5?=
 =?utf-8?B?eXVHMXFqNVQwWGxWOGcyTzVBVE8waXVkUnVKNVMwNk81ODNYUC9oRndkNG9p?=
 =?utf-8?B?aFNDRWhzWGJnQ0xlejdSMnc2NE1ZNDk4WDhKRm5lMk1wanhrN0FMNE9WZ2tq?=
 =?utf-8?B?dzVGS0FrbktCb1pwN0NHTHpJZzIxTVBXdFFGN3FsS2hXZCtkTWF5b1dPTC9M?=
 =?utf-8?B?NXhlbWdJWWUyWmZrN3JRRTVoejFXbUhDWjFEbUhjbXFnWWlVUERQZnF0bDhV?=
 =?utf-8?B?WDg2OUYwdk5KeWZ4amNzeC9RS2kxbEtxdGVEcXd3dGg2WTl5aTF6aVhuUWU1?=
 =?utf-8?Q?9PKU0ubi3FBZr8sXLAek7JpqZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 423cae4c-d439-4ee4-1461-08db5294ee41
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 02:59:40.8358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w4Zxck9rzKjcfcxvX1yHcVQ6lRqNOXy+X7Y0ygkzS0dXF1e39QX4l+OH+5cLQHrw7zjufvqpA60Sd2/Mlcct4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7887
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgTWF5IDExLCAyMDIzIDc6MzQgUE0NCj4gDQo+IE9uIDUvMTEvMjMgMzoyNyBQTSwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEFsZXggV2lsbGlhbXNvbjxhbGV4LndpbGxpYW1z
b25AcmVkaGF0LmNvbT4NCj4gPj4gU2VudDogVGh1cnNkYXksIE1heSAxMSwgMjAyMyAxOjI1IEFN
DQo+ID4+DQo+ID4+IE9uIFR1ZSwgOSBNYXkgMjAyMyAwODozNDo1MyArMDAwMA0KPiA+PiAiVGlh
biwgS2V2aW4iPGtldmluLnRpYW5AaW50ZWwuY29tPiAgd3JvdGU6DQo+ID4+DQo+ID4+PiBBY2Nv
cmRpbmcgdG8gUENJZSBzcGVjICg3LjguOSBQQVNJRCBFeHRlbmRlZCBDYXBhYmlsaXR5IFN0cnVj
dHVyZSk6DQo+ID4+Pg0KPiA+Pj4gICAgVGhlIFBBU0lEIGNvbmZpZ3VyYXRpb24gb2YgdGhlIHNp
bmdsZSBub24tVkYgRnVuY3Rpb24gcmVwcmVzZW50aW5nDQo+ID4+PiAgICB0aGUgZGV2aWNlIGlz
IGFsc28gdXNlZCBieSBhbGwgVkZzIGluIHRoZSBkZXZpY2UuIEEgUEYgaXMgcGVybWl0dGVkDQo+
ID4+PiAgICB0byBpbXBsZW1lbnQgdGhlIFBBU0lEIGNhcGFiaWxpdHksIGJ1dCBWRnMgbXVzdCBu
b3QgaW1wbGVtZW50IGl0Lg0KPiA+Pj4NCj4gPj4+IFRvIGVuYWJsZSBQQVNJRCBvbiBWRiB0aGVu
IG9uZSBvcGVuIGlzIHdoZXJlIHRvIGxvY2F0ZSB0aGUgUEFTSUQNCj4gPj4+IGNhcGFiaWxpdHkg
aW4gVkYncyB2Y29uZmlnIHNwYWNlLiB2ZmlvLXBjaSBkb2Vzbid0IGtub3cgd2hpY2ggb2Zmc2V0
DQo+ID4+PiBtYXkgY29udGFpbiBWRiBzcGVjaWZpYyBjb25maWcgcmVnaXN0ZXJzLiBGaW5kaW5n
IHN1Y2ggb2Zmc2V0IG11c3QNCj4gPj4+IGNvbWUgZnJvbSBhIGRldmljZSBzcGVjaWZpYyBrbm93
bGVkZ2UuDQo+ID4+IEJhY2t1cCBmb3IgYSBtb21lbnQsIFZGcyBhcmUgZ292ZXJuZWQgYnkgdGhl
IFBBU0lEIGNhcGFiaWxpdHkgb24gdGhlDQo+ID4+IFBGLiAgVGhlIFBBU0lEIGNhcGFiaWxpdHkg
ZXhwb3NlcyBjb250cm9sIHJlZ2lzdGVycyB0aGF0IGltcGx5IHRoZQ0KPiA+PiBhYmlsaXR5IHRv
IG1hbmFnZSB2YXJpb3VzIGZlYXR1cmUgZW5hYmxlIGJpdHMuICBUaGUgVkYgb3duZXIgZG9lcyBu
b3QNCj4gPj4gaGF2ZSBwcml2aWxlZ2VzIHRvIG1hbmlwdWxhdGUgdGhvc2UgYml0cy4gIEZvciBl
eGFtcGxlLCB0aGUgUEFTSUQgRW5hYmxlDQo+ID4+IGJpdCBzaG91bGQgcmVzdHJpY3QgdGhlIGVu
ZHBvaW50IGZyb20gc2VuZGluZyBUTFBzIHdpdGggYSBQQVNJRCBwcmVmaXgsDQo+ID4+IGJ1dCB0
aGlzIGNhbiBvbmx5IGJlIGNoYW5nZWQgYXQgdGhlIFBGIGxldmVsIGZvciBhbGwgYXNzb2NpYXRl
ZCBWRnMuDQo+ID4+DQo+ID4+IFRoZSBwcm90b2NvbCBzcGVjaWZpZWQgaW4gNy44LjkuMyBkZWZp
bmVzIHRoaXMgZW5hYmxlIGJpdCBhcyBSVy4gIEhvdyBkbw0KPiA+PiB3ZSB2aXJ0dWFsaXplIHRo
YXQ/ICBFaXRoZXIgaXQncyB2aXJ0dWFsaXplZCB0byBiZSByZWFkLW9ubHkgYW5kIHdlDQo+ID4+
IHZpb2xhdGUgdGhlIHNwZWMgb3Igd2UgYWxsb3cgaXQgdG8gYmUgcmVhZC13cml0ZSBhbmQgaXQg
aGFzIG5vIGVmZmVjdCwNCj4gPj4gd2hpY2ggdmlvbGF0ZXMgdGhlIHNwZWMuDQo+ID4+DQo+ID4g
Q3VycmVudGx5IHRoZSBQQVNJRCBjYXAgaXMgZW5hYmxlZCBieSBkZWZhdWx0IHdoZW4gYSBkZXZp
Y2UgaXMgcHJvYmVkDQo+ID4gYnkgaW9tbXUgZHJpdmVyLiBMZWF2aW5nIGl0IGVuYWJsZWQgaW4g
UEYgd2hpbGUgZ3Vlc3Qgd2FudHMgaXQgZGlzYWJsZWQNCj4gPiBpbiBWRiBpcyBoYXJtbGVzcy4g
Vy9vIHByb3BlciBzZXR1cCBpbiBpb21tdSBzaWRlIHRoZSBWRiBjYW5ub3QNCj4gPiBkbyByZWFs
IHdvcmsgd2l0aCBQQVNJRC4NCj4gDQo+IFtzb3JyeSBmb3IgcGFydGlhbCByZXBseV0NCj4gDQo+
IEkgYW0gYXR0ZW1wdGluZyB0byBtb3ZlIFBBU0lEIGVuYWJsaW5nL2Rpc2FibGluZyBvdXQgb2Yg
dGhlIGlvbW11DQo+IGRyaXZlciBhbmQgZ2l2ZSBpdHMgY29udHJvbCB0byB0aGUgZGV2aWNlIGRy
aXZlci4gT25lIHB1enpsZSB0aGluZyBpcw0KPiB0aGF0IFBDSSBzcGVjIHJlcXVpcmVzIFBBU0lE
IGNvbnRyb2wgYml0cyBub3QgY2hhbmdlZCBvbmNlIHRoZSBBVFMgaXMNCj4gaXMgZW5hYmxlZC4g
U28gSSBhbHNvIG5lZWQgdG8gYWRkIGlvbW11IGludGVyZmFjZXMgdG8gZW5hYmxlL2Rpc2FibGUN
Cj4gQVRTIG9uIGRldmljZXMuDQo+IA0KPiBCeSBkZWZhdWx0LCB0aGUgQVRTIGlzIGVuYWJsZWQg
YnkgdGhlIGlvbW11IHN1YnN5c3RlbSB0byB1dGlsaXplIHRoZQ0KPiBkZXZpY2UgVExCLCB0aGUg
ZGV2aWNlIGRyaXZlciBuZWVkcyB0byBkaXNhYmxlIGl0IGJlZm9yZSBjaGFuZ2UgdGhlDQo+IFBB
U0lEIGNvbnRyb2wgYml0cyBhbmQgcmUtZW5hYmxlIGl0IGFmdGVyd2FyZHMuDQo+IA0KDQpBVFMg
aXMgYWxzbyByZWxpZWQgb24gYnkgUFJTLiBOb3Qgc3VyZSBob3cgdGhhdCB3aWxsIGJlIGFmZmVj
dGVkIHdoZW4NCkFUUyBpcyBkeW5hbWljYWxseSB0dXJuZWQgb24vb2ZmLiBhbmQgUFJTIGlzIG5v
dCB0aWVkIHRvIFBBU0lELg0KDQpKYXNvbiwgaXMgaXQgc3RpbGwgYSBzdHJvbmcgcmVxdWlyZW1l
bnQgdG8gaGF2ZSBkcml2ZXItb3B0IG1vZGVsIGZvcg0KcGFzaWQgZW5hYmxpbmc/IGlpcmMgaXQn
cyBmaXJzdCByYWlzZWQgaW4gYSBkaXNjdXNzaW9uIGZvciBhbiBBTUQgR1BVDQpzY2VuYXJpbyBb
MV0NCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXBjaS8zOGE3YmFmNC05YjNi
LTE1NGItZjc2NC1mYThjZmE2MDA4NThAbGludXguaW50ZWwuY29tLw0K
