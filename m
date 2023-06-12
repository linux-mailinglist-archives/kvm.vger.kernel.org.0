Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9362672D541
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 01:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbjFLXzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 19:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjFLXzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 19:55:21 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096FA1713;
        Mon, 12 Jun 2023 16:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686614120; x=1718150120;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Rrxeoh8tzTyWh9JnIexLcWisTupVgs5bvTUn7dr5ESw=;
  b=bZbxN6H8mYMgM5zYg0hWMXKrJmGmock1cfxbznNCXBGmssd/3vIQfMvu
   KYXgdqFiTKCQBUlw8QdlT+xSXfjKA2PyKJ7gvw0q5HUYQqccTeC/4ihyE
   P7FAubNoHMtO21Bl7e/vm2MhVM8Y3x9mY879aBogVSwLHYSbzyPW2kMa+
   K/6zWEf63500AE1OEG82tph5pt6IbNyZW1BYJEfGNRU9EyTJndaP+LyPV
   6a5g/kLbkUdfhJuW2jtgRGu/NI7xSQtLUrRSIZ6N7VD/pLtG2I+tkyORx
   eBlnDy9FOMNiP+THWHxKiegARqYCokVJrPfN6k0wAXSrsK3Kce6LlCrpI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="421779166"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="421779166"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 16:55:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="744491925"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="744491925"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 12 Jun 2023 16:55:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 16:55:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 16:55:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 16:55:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iF6BoYp/fjJJhJRem2oS2YY7ArFJpwYJar23KTs0tUdp7pQmx/Qot8Mx2+HaV0OPgyhb99V3e5TfVQBGzYHiJJIRtxRNW9htX4cjiGgm+993vEwSElvmTAeEjy/hZwMB1QH44izd9Jv2kZbfc4w6VbM/t6eqkzIV/EkEUP28xdf2NHkCfoLucsTScmu55u9K3rCkZ+AVP8X4maZvyH1leaaIt7DFT5XE5rCPU+tzc90xXXfwQQzT6MRo8XmkVsF10orCYSbKm7hJuqu9/vEztlAbSYsHMob3iGIY19M/4mZykQvTwAi/IGKzAP9311ZhTIAAH391tl4P97Q3uvqNCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rrxeoh8tzTyWh9JnIexLcWisTupVgs5bvTUn7dr5ESw=;
 b=a1i6BvKy1JOBBNdlPPe+My4TFUaLZbPgV8DJVynXIscVVzeXxZGGkJtdmSxK6ByuEzOOTi2FmnUs8Ay+dXtBnnOyWgIrm686UFoIm/NYYtssY2Lkq7T24017tN2js7OWPOhhYZ72vfyiVo8IZnzA4c6XazPrX6ZvpJQ6aqBuW9tNb/GlJAivl7u8+1g1jo9eso9brLhgCzAxB3Dbq+1WMKYlqhYNIaX6Rr4mi32gbPsJZ8xvTit1knLjrxxQGSAf4XaJde278oUS9gvTrmqQsnjGLHtYlsiQAIkuTrwG5mkebjmDZidk5hgGKIH0svZmazw5JFTfDB9Hgs5oAaYf8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6536.namprd11.prod.outlook.com (2603:10b6:930:40::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Mon, 12 Jun
 2023 23:55:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 23:55:14 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZkeT0wH2MEOTseU2fipMRPmQQrK99OF2AgAJ5WgCACD0lAA==
Date:   Mon, 12 Jun 2023 23:55:14 +0000
Message-ID: <6b60200b23fa3eac689a140abb92506410b14531.camel@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
         <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
         <3d8355ae582119486ac7ec129c4ba18d2cdf3ccb.camel@intel.com>
         <20230607180616.GF2244082@ls.amr.corp.intel.com>
In-Reply-To: <20230607180616.GF2244082@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6536:EE_
x-ms-office365-filtering-correlation-id: 75c8fc37-297f-48f6-965a-08db6ba07788
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yDzkZdBnMJrlVhecxxSmsGHXpskSWGQjFMUGPMm+sk3aMnTtvYqnYGO9PM0lQg/gU9pXsV98CymgfU/HqwV3LWECov6+0LDtPKdJ9Vmt4uvnaLKDBYjBFP7XpgUcaN7lJlVW/H+O+oDs64DCGPMU50/aNidtrnbel6+9RtGy93HacdYFbWLCS+hiyIr2r9kcKQy0AMk3MCFC0247yOUDD547nGHjgY/7tPHXJwhV1aDOR3T9l8okGYfBnmLJ+l+qBtx2xW3duxtXZObyJBpccP3xnQ/O6pQxXHx0YoWI7KJhYiGzO2F/SdXczdNvYY9ndoWsbeuTdb7pYnWjZkVqiiyT11a2GOl0+Yw6/GN83anB3N9WZNDbskMzWYNEFlGnyqQHo0qtPXhDUuGUbluxrDSkDOt8upThj+OocNA0sHIrDZU+44q3xBy9PdnFwwix88O6kUQNyt25oClt1n4yEf1YJM0TGpPmod+VfpGhB5qUjF53d7Ov9k7EjrYDTzoUMMeUyKWY9FkmfoGwAbKUsJDZELe8OtJb9CS8OQZTm9qqoj0qBiB1eyYgalSwguBhQeEy7lhqMYsh8wb/BQcx/vQ86ixNj3nZEij4On0Jies=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199021)(316002)(122000001)(83380400001)(54906003)(478600001)(82960400001)(8676002)(8936002)(66446008)(66556008)(86362001)(66476007)(76116006)(91956017)(66946007)(41300700001)(38070700005)(64756008)(38100700002)(5660300002)(4326008)(6916009)(6486002)(2906002)(36756003)(71200400001)(966005)(186003)(26005)(6506007)(2616005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0x2WktBa1hkbkpZRy9uNC9ycFNQeUxLSExWek1hNVQzVFB0SjU5bmtieGlC?=
 =?utf-8?B?TGxTUmNyWG9keVN2eUxFWnpFOWp6SUwyTTliaEFBWVFjcmVDL05zK1FaK3I1?=
 =?utf-8?B?Mm5SeCtISWxxZzJ5cXg3Mmd0Y0d2R2hwSFdnamc0cnQ2cUxlYldyVWthTHpt?=
 =?utf-8?B?cXdMR3R1S1dOQXNwa1Z0dGpHU0NrZC9TWHlLQlhoTGsrSGdtUDUySk1FU2hz?=
 =?utf-8?B?ajEra241bnJIZUZtWXFFbXN4Sko5bnBRTFQxYTJkQ3drWkJlM1Uza2ZZU0d3?=
 =?utf-8?B?STNMT2tTNFQ5bUhJeHFMU3B2K3ZWbUhYbDgvaDhIcllRTlJWLzZzOUpUSlEx?=
 =?utf-8?B?cHk2Q0RoTXVzTUUvTWdqYk1QM3NVYXUvd0pEMmsxMUcwaHVlWnZmY0JWZzJi?=
 =?utf-8?B?dWc1NUF2NElFUEtkUTBveC9OTW5GSFUvUVM3c1RxYmV0d2VETkhYNDN5cW16?=
 =?utf-8?B?V243dHdJTHBFMjdsOVBVVUNYV1NYakdQM3prM0ZOb0FqT3FhWS9nOGl6SzJD?=
 =?utf-8?B?MEdseEQ0OHRqcEFpaFJzb1RJSUNzblFTTmNpR0pEc2FRTm1OUFd2dXlCQnZk?=
 =?utf-8?B?UFNRNzRsMmtGK0N6UkQrczJuQ2ZsanBQRHZ2OEVMdm14WnhTOUtsZzEwZkd5?=
 =?utf-8?B?T2Yzd01QdTVjQTNhalB2d2M2cWwwczFRUmNEZE05U1h5dUlqT0ZmdGE3UHRl?=
 =?utf-8?B?VVBlUHArVGYrRkxIcW1kdUljVWFiSEZYWUs3UzVBMnhrTUlwS01RbXlyRUwz?=
 =?utf-8?B?NThlTlZqRDJMYmxKc1h1RW1WZzUraXMrcnlDRXB6ZWNzdCtrZmJzdld1Y09u?=
 =?utf-8?B?NzRERnNJMnpGQU11a09jeEQwQlhTbm1pYzNaMHZIWTJtWVNjcTU5MHVNNVM2?=
 =?utf-8?B?a0ZyeEE4SXJSbHpJZjQ1dzh3amw5ZjBoZWFzZzMvQ3gyUWxKVi9MemN6S3ZY?=
 =?utf-8?B?eEhqejhwSi9lZHB2b0RDcHhDd0IxaUIranNJTEQyZE9FWis1bm05QkF4WkZi?=
 =?utf-8?B?bG05eWppaTAxQk11cTZOVkNjYW5QRktDR0RCaWFtSGxjV2RoMGZQbEN3YW9Q?=
 =?utf-8?B?UTBlcjRqTFhGWVZFMlk0ZDcxUVhRRVBubDJjUjlFNlU5UXpOUC9yVlU3V1RT?=
 =?utf-8?B?dWpxNUhHdzM1Wk55QmZhNUpwR0JmR2ttemJRa200L2srNm9GTm8xMStaRDZ6?=
 =?utf-8?B?b2xNRVVzV2NHVVRxSWtrc3NVN1ltK1dwR2hSYWlEZzZXYkduZXE0SFI5azIw?=
 =?utf-8?B?Z1hzeCtlZlhKbXJwSk1TYVp4cHB0YTM2c3RtNHA2YndVY1lOMU05Uk1UWExI?=
 =?utf-8?B?Yitya0lqT1RuTkxRdndRa2NjdDlldmtVSVVBVlE2SEdPQjBlRnZnM1d6VUN4?=
 =?utf-8?B?U0lkMFNWV25aK2VWWjNrVWJQa29FTERURzJveEhyQVhKeHVZVjlna2I1Ujln?=
 =?utf-8?B?RzFUSlk1QncyZ3ZGSnFuaXpid3F2QVlkQ2dZMWRNSjlHYkNLdDgzeUJhMkhS?=
 =?utf-8?B?SFNwN3RwUGtjU201MGtQZnltTTZGeDcvTWZ3OFlEdmpCQWpBd1M2WnJGUFJ4?=
 =?utf-8?B?eTlPSUIvdEZPeUdWZDNvOWtBN1R1dWJSQUcwdHc0QjM5TzBPZTNwUmlBbmd6?=
 =?utf-8?B?OWZFVmJBaS9LRTFEQVFRQS9ZRmZLNW9uWWtGclhJQWt5WWZkbmRrM3psQm80?=
 =?utf-8?B?blpjOGg5SG5Wb1UyVTRZTlVMQlE1TXpDSE9MTU5rMVc0enZlenV4ZExaYzVW?=
 =?utf-8?B?S0g0UkFUVFVVK2oyamV3OGRNYkNMSEhOOGxLVC9wT0gzYXZ6RVZkZGFiY25F?=
 =?utf-8?B?RWxIYUVyQkdmSHBFenRzQ3NydmFWcEZEVzVUQTJKUnU1QTZvSDVzV24yUzA4?=
 =?utf-8?B?UDFQcVZxVkNmZXdrb0VmY0N5OFY1c0RDVjhlWVJCVWdYLzVuU2V1cTI4Qk9a?=
 =?utf-8?B?NlVseC81M3FHK0JhaDRCK0ROZTAwdGtUTjVaYU1nZlB0Z0xZT0lzY3NiZ0xR?=
 =?utf-8?B?bDFRTjBZTThoTnpCN245VXJBdVpSSjJKUUs2ZTFVOHc5UjdjMHh5ekk5RUZv?=
 =?utf-8?B?azRlaFdNbzFiejFmeWZRaHBSM1Mya3dvblZOUUNsSkxNSFdkdG5WSERNUDc0?=
 =?utf-8?B?QWd5Z29MOXNHbmJXVCt3VGt5OEFOR2FzY1ZFcHdpWFZmQlM0MzJ3QkRadUs2?=
 =?utf-8?B?L1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05AE4F34D11D6C43B75064FC7211C6E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c8fc37-297f-48f6-965a-08db6ba07788
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 23:55:14.6912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ETZZGfk7qWOvTeGXcCcqgDrVlTnX8+7F7XEX+znht7hzSK1RFbyTkurs0wQM6M8hgMjxUAh0dlQ3fb1bPboDEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDExOjA2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gVGhhbmtzIGZvciBwb2ludGluZyBpdCBvdXQuIFRoZSBmb2xsb3dpbmcgaXMgdGhlIGZpeC4N
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3Zt
L3ZteC90ZHguYw0KPiBpbmRleCA4YTFkMDc1NWQyNzUuLmIwZDNmNjQ2YWZiMSAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3Rk
eC5jDQo+IEBAIC00NDk5LDI2ICs0NDk5LDM5IEBAIHU2NCB0ZHhfbm9uX2FyY2hfZmllbGRfc3dp
dGNoKHU2NCBmaWVsZCkNCj4gwqAJfQ0KPiDCoH0NCj4gwqANCj4gLXN0YXRpYyB2b2lkIF9faW5p
dCB2bXhfdGR4X29uKHZvaWQgKmluZm8pDQo+ICtzdHJ1Y3Qgdm14X3RkeF9lbmFibGVkIHsNCj4g
KwljcHVtYXNrX3Zhcl90IHZteF9lbmFibGVkOw0KPiArCWF0b21pY190ICplcnI7DQo+ICt9Ow0K
PiArDQoNClNvcnJ5IGZvciBsYXRlIHJlcGx5Lg0KDQpJIHRoaW5rIHlvdSBqdXN0IG5lZWQgdG8g
bWltaWMgaGFyZHdhcmVfZW5hYmxlX2FsbCgpIC0tIHVzaW5nIGEgcGVyLWNwdQ0KdmFyaWFibGUu
ICBJbiB0aGlzIHdheSB5b3UgY2FuIGdldCByaWQgb2YgdGhpcyBzdHJ1Y3R1cmUuDQoNCkJ1dCBh
Z2Fpbiwgd2UgaGF2ZSBsaXN0ZWQgYSBjb3VwbGUgb2Ygb3B0aW9ucyBpbiB0aGUgdjEzIGRpc2N1
c3Npb24gWzFdOg0KDQoxKSBDYWxsIGt2bV9vcHNfdXBkYXRlKCkgdHdpY2UgYmVmb3JlIGFuZCBh
ZnRlciBoYXJkd2FyZV9zZXR1cCgpIGluIG9yZGVyIHRvIHVzZQ0KaGFyZHdhcmVfZW5hYmxlX2Fs
bCgpIGRpcmVjdGx5Lg0KDQoyKSBFeHBvc2Uga3ZtX3g4Nl9vcHMgYXMgc3ltYm9sIHNvIFZNWCBj
YW4gc2V0IGhhcmR3YXJlX3tlbmFibGV8ZGlzYWJsZX0oKQ0KY2FsbGJhY2sgYmVmb3JlIGhhcmR3
YXJlX3NldHVwKCkgaW4gb3JkZXIgdG8gdXNlIGhhcmR3YXJlX2VuYWJsZV9hbGwoKS4NCg0KMykg
SW1wbGVtZW50IFZNWCdzIG93biBoYXJkd2FyZV9lbmFibGVfYWxsKCkgbG9naWMgYXMgc2hvd24g
aW4gdGhpcyBwYXRjaC4NCg0KNCkgPz8/DQoNCkkgdGhpbmsgaXQgd291bGQgYmUgYmV0dGVyIGlm
IFNlYW4gY2FuIHByb3ZpZGUgc29tZSBjb21tZW50cyBoZXJlLCBidXQgdW50aWwgaGUNCmRvZXMs
IHdlIGNhbiBrZWVwIHVzaW5nIG9wdGlvbiAzKSAodGhpcyBwYXRjaCkuDQoNClsxXQ0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC81ZGM4NGEyNjAxYTQ3Y2NjMjllZjQzMjAwY2YzZWMwZDFi
NDg1ZDIzLmNhbWVsQGludGVsLmNvbS8NCg==
