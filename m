Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BCE6DA8A8
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 07:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjDGF7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 01:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjDGF7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 01:59:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BA940CE
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 22:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680847175; x=1712383175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=27zst/mvaYzYcwffI0DvnNEjG5GA+fP08pJNPGglTeM=;
  b=HslXo6lQhPfF+DviEM+9wY4G96sMUSlTesaMfq+PbVLzAxCxrYhBmglt
   AaO9+gjoS98btvFVz42FWaKbaiUelZYLYo540UKWwCn9jZe9i37/7J1Rl
   1emRgD57k8G3rhxWILd3nnBW23gZP5gfz+ExlJDzU3E+yb9bHqOmqOTXg
   1YjIE09+saBh/ZfKTHknJih+8aZ6pp7+iHWQrRXodd6yI2ohSNSBJNGgw
   IUtGVCN/pV/k4lwi01eNsUQqhS+1KBLtUBwf1w6mTWFBMUOlz4i1OC5T9
   8wT2Y4bAydmftWO4yaeZTwfxNK2aPvEfuP7T0eKaD5g3/Dd7TwPUq0RHr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="342938553"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="342938553"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 22:59:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="798600952"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="798600952"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 06 Apr 2023 22:59:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 22:59:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 22:59:35 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 22:59:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMm5m2Ibw5XlyD4M29Y8OixQBBeDcU4gw8Uie6tTZcLnrfKx1RzOCn6A8Wdij2233+hhCmP8TJJ2Q9HqGs/M9DQqnzEtp/mXKsZQMTksdmsCSKYOPq//RnP9FXNQOUqPpb91RWzttrkqFoynnNB1wvzrn9DMH5VWsmqnC+Z+Kdh8dr+o3+zrS1JcI0cd+P4WMbmG6M5swG3BdoAr4aX5SqtoVo9ou3boOvmy5Wy4g+6ejm4kNINouwX86vehjOUUBOWFCQYy9ub5VHdo0laygATlsof0QPX8cSq+aobAYPDgnq9eAF6YixXiOuxOm08pX8o2IjzIBaYz2gZ2V0/QiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27zst/mvaYzYcwffI0DvnNEjG5GA+fP08pJNPGglTeM=;
 b=mK59BLB11Th8mFNu/aKtpDXrAIPN+4gzK66kKHlPsbV9Ztw+nuPU0ziwgWFhFwLpTfDlJbZ8FTXxNE2HAlCFH0vG+t9k5N0LytHcB7qS9AAvHI//73snOKUqFP7gZwBexDWAYebDc2NcMmo2QhJKxRl7IaURFfeAqckZHT+pAjtsT5tE6kjpo+iBls+MgHfAvMTPgPEphK+WDPigGfpUK5jeeCBCxew42QD0a1Ib0mgjqm3+U04C1NPLce9UPqU8qwC2jLm4vx971ZP6S9GDWAEBJQGgd6Ro6kRiFo8zSUmm9D4laGeLocZuzLEptRsro1HXwMO1cUQQfa9H0PMYDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB7369.namprd11.prod.outlook.com (2603:10b6:610:14d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 05:59:33 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%6]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 05:59:33 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: RE: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Topic: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Index: AdlnGoO7DMFQx8JhSoqsl2dQLdydDAAn9S+AAAre6EAAHRfvgAAtUV2A
Date:   Fri, 7 Apr 2023 05:59:32 +0000
Message-ID: <SA1PR11MB67344D734B7A67E7588FFCF5A8969@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <CABgObfaJwgBKkSfp=GP437jEKTP=_eCktdiKcujeSOgwv9dbiQ@mail.gmail.com>
 <SA1PR11MB673431B687B392B142129E72A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <34e9da5c-f79a-db5e-bce6-95101e919097@redhat.com>
In-Reply-To: <34e9da5c-f79a-db5e-bce6-95101e919097@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB7369:EE_
x-ms-office365-filtering-correlation-id: 82a31bbb-a7f2-4b48-b472-08db372d4241
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u2mkxcK7/BNdulBytPMLV7S7hBngkS2vInWtcEQ2E1vGDW1gWzA4AcuMANj16O5PQjL++YtPJSSaBiQjNG2ejBHlcsFemEe9W0L7+SMPpx2guUhAli4o8HU+Eh3ZFIPdHmPlrLjVImiqY/uu0iKJchCNUhxFuNpFWL9mS6JGpZWvNdyYV43NWEpgY7ffUWprCWeixPATc2mV1bEz/IVpcAcfkg5jBfiUdu56Yzap2EXxLYE+9AgNsh9DqNeERXTA7lj2zxabH4BPr56TX94SR77V8j5Q9MGuC6LnK7/woFHrkExDYz6NycUA3R+vigbxLGzjV/76MHbSSWBAaqapDXM2yslHmG/1Dn+ZjVXaksHXToqWDuaMh5rcD2FWNq3sJDueSrOKtA3GoAC8ouwTtXsMl9BcOVUHWAXj4kk7kQO7u7PyOYG8XkN6i1lv4q6oumjU5r72S3T9keOPG2jfEOIVqCWs2+M/77jIRKE4U/9o8ToPYepGEweYPvwjzvQbTVeHL/nFVgEe/2UXYT811MqGUtKHiKnt61F+3zSvL/qoEH4aRb7IU1YW042GSjjNphKW04vmpNjZbERiIjpjOcUWtCyl72hv8CSOV39rg2CGd+6/A/inoiA+xdE4OyGM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199021)(38100700002)(86362001)(38070700005)(55016003)(33656002)(4326008)(6506007)(52536014)(76116006)(2906002)(8676002)(26005)(9686003)(107886003)(186003)(64756008)(6916009)(5660300002)(66446008)(8936002)(71200400001)(7696005)(478600001)(54906003)(66476007)(66946007)(41300700001)(66556008)(316002)(122000001)(82960400001)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXRUeXFzLzhhZmZmN3cvWlg0Vy94MWlROGxBb0hsYWsrL1hkbnUyaWxaMjRR?=
 =?utf-8?B?cHdOWXRySGZTay9YTlRkVXh6SmVHVkVNanEyYWtSN0JTNnZDbnc2WVNHcUY1?=
 =?utf-8?B?a2p3RS9UcWFOZzNXSFY0VnRrMXFDQlRGQVpTM3NYL3l3NzI3c0xra3QzM0Jv?=
 =?utf-8?B?MlRvWHBWUUlVdXVUN0NRa3lSMFpsdEUvd0NEVGxKUW8wNno3WlphMWNJTzlh?=
 =?utf-8?B?TmJQWHM5VTl4T1pEcnVPV0tZRGxZMnMwbmxjUkxkMHl3a2EvRFNGM3Fqdit2?=
 =?utf-8?B?cDNPNnBqMTR6bzRXL0FRTEJ5U2NKbSszaFF0aU5zOGlyZE5GQnBqdDltNytY?=
 =?utf-8?B?Mmp0MFIrdFRDcUlIMmZZcmpMUzd4ckxGS09xVVNadVk3NjRwZGRPUnNCRkQx?=
 =?utf-8?B?L3ZDaSthdUp3UlhGdjVNWmVlSGp5M1JhV3JzVkxEb1RZTXBZdWVZUHN5VENZ?=
 =?utf-8?B?UGZwOHJ0bWNBemtMcW5UcW14b3N3T2NobmRaS0dnWngwSWVtNWI0YmVQZmhq?=
 =?utf-8?B?NkpPWnBibDNSVWJvcW1KYnVOUm5icWVhK1d5MHZ5MTNTbSsxRERRMmJOQmo5?=
 =?utf-8?B?YTJiUDVydkZ6MTdabHdWWExIMHNzYnRJTXBhWXBmc0xKdHRad2NyYkZ5T1pX?=
 =?utf-8?B?VS9uUmhUMEQ2M3p3OUpXYUx4K0ZMWVpRcnB5NUpVLys5bzdubktLczRYNExT?=
 =?utf-8?B?S3cyNVlIVnMyeUhQeW1CdThGczM5Z05zODVHYXlNMVZPYVZpN3RmajVORE8v?=
 =?utf-8?B?VzdPdjIxNkVvWTBEZ0lXVUZUQTFIV0F2Wk1VYThseVFwM1AvaUNrWjdGNmNO?=
 =?utf-8?B?NFdnWEtIa2xTMi81Q3dwNFJkSHRIcTFneDZMLzZUWEZaYm1tWWdCalRLaWpS?=
 =?utf-8?B?djJaTEZRL0tpWlVUQ1R4VmZxekdyUVowUE1ueFJQaTF2NlBiZTk4QlZ4dzlw?=
 =?utf-8?B?Z0hLU3lkWTgrYmN6UCtGNzlxVlJRUk9PMTVkN1VaRVJuVmR6TzdsQklNLzNs?=
 =?utf-8?B?Y21GVEZKVGtUVEV5Mkkrcmc2eitGTlVjSmRWK2xURFNLWWlKSll4eDdNWmtM?=
 =?utf-8?B?ZWdNZUVmeXhsSlhVdmlHejgrWUpzMlB4amRad0xqWFpkZ2ZDR0FWRVl4Nkg3?=
 =?utf-8?B?YnEvSjJQYlVxcDB4UjY0ZmJzRDBCT0Z2YUlDeVFEeTAzV1h5aU1HY0JRWHFM?=
 =?utf-8?B?Skg3ZWFtdTlzb0JsOG50Zm5PRjRTVlRPZmFFY3NJRnpidzRDOC9xYmtsRUNq?=
 =?utf-8?B?T1FHU2UvTm8wWFdZcVVQcmI5VjJDY2dxMFNlRWxOeTBLSUJZWXRVTjhPTUtB?=
 =?utf-8?B?Ulk5OWllOFltVFpmMlJJSTBvM2xGeEpUMkdwUnc5L3lEdEJROHhhQ3FzWUho?=
 =?utf-8?B?V3M4K1orcnVoYzNqYzhsbDdnRHZKeTlDL1Nwb3dNc1ZaZzhOOUFCdm9Ya3Va?=
 =?utf-8?B?dlQ4NXMzcHp0dmFSVEFjRmJTdU9PMjQvNDZwNGZVSFM3YitnbVQ2a2QwU3l5?=
 =?utf-8?B?V085V1NWb003R01wTU5NK2JOYnJDbGtSdzhFTnJSRzBVd0R6OWJaRnZwaThM?=
 =?utf-8?B?QnEyV1BPc2Zyb05oc0x6QzFiR3Z6RFREdHhiNFN4OE5oQzQxMjdGWlVYekFZ?=
 =?utf-8?B?OHFIM2FabFgxNHoyOUhsQ25CRlJ1QlFsbkpROVdxWXBYcVRBN2lJY2svb2gw?=
 =?utf-8?B?VmxEMEN6RzlPK0ZRUE5nZ0NZRGNCUEJCUElYUGtlcFlYcjlBR1N4Q3Z5c1Bl?=
 =?utf-8?B?UWVuMnFEVlFTb20rdUdONlREN1ZJM1l5Qjd3dVcxSjlsSWxUVERzTys0TUdB?=
 =?utf-8?B?M0QyRHRGdC9RQ2JPZjJjbTBSODNadzhYOEZONmVwU0JTYlp4VFB2N0hoVXh2?=
 =?utf-8?B?aVRzeHIraEc3ckZoZnRHc0d1ZnpINTJaOVVDVkVpNGdWelZZaTFXRmZtcGU1?=
 =?utf-8?B?a1k1ZytOdE1NNGl1ZEU5L09TcVptQktLVzRyU29WdjRNZHNCaGdDak9SM3ZX?=
 =?utf-8?B?T3FtUmdLQ0E2c002MnVWY2dVNFYzK1RRZ1hHaE5kNWd6R21STmdpcjJZMmFk?=
 =?utf-8?B?azI1S3BBUTJhZVFJbkVwdmVYdEwydmpPTnEvOGJnQWtLV1luTlhObDNOc2Rm?=
 =?utf-8?Q?9pjg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a31bbb-a7f2-4b48-b472-08db372d4241
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 05:59:32.7481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JOtHvpFg3aiKgQvtSM90eafkocreCmD7pTPuexdxEOSFnGweiFP42lVxYuB0h9jyT+vzYN3iOo79jyTBMin1Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7369
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+PiBJZiB0aGUgc2Vjb25kIGV4Y2VwdGlvbiBkb2VzIG5vdCBjYXVzZSBhIHZtZXhpdCwgaXQg
aXMgaGFuZGxlZCBhcw0KPiA+PiB1c3VhbCBieSB0aGUgcHJvY2Vzc29yIChieSBjaGVja2luZyBp
ZiB0aGUgdHdvIGV4Y2VwdGlvbnMgYXJlIGJlbmlnbiwNCj4gPj4gY29udHJpYnV0b3J5IG9yIHBh
Z2UgZmF1bHRzKS4gVGhlIGJlaGF2aW9yIGlzIHRoZSBzYW1lIGV2ZW4gaWYgdGhlDQo+ID4+IGZp
cnN0IGV4Y2VwdGlvbiBjb21lcyBmcm9tIFZNWCBldmVudCBpbmplY3Rpb24uDQo+ID4NCj4gPiBU
aGUgY2FzZSBJIHdhcyB0aGlua2luZyBpcywgYm90aCB0aGUgZmlyc3QgYW5kIHRoZSBzZWNvbmQg
ZXhjZXB0aW9uDQo+ID4gZG9uJ3QgY2F1c2UgYW55IFZNIGV4aXQsIGhvd2V2ZXIgdGhlIGZpcnN0
IGV4Y2VwdGlvbiB0cmlnZ2VyZWQgYW4gRVBUDQo+ID4gdmlvbGF0aW9uLiBMYXRlciBLVk0gaW5q
ZWN0cyB0aGUgZmlyc3QgZXhjZXB0aW9uIGFuZCBkZWxpdmVyaW5nIG9mIHRoZQ0KPiA+IGZpcnN0
IGV4Y2VwdGlvbiBieSB0aGUgQ1BVIHRyaWdnZXJzIHRoZSBzZWNvbmQgZXhjZXB0aW9uLCB0aGVu
IHRoZQ0KPiA+IGluZm9ybWF0aW9uIGFib3V0IHRoZSBmaXJzdCBLVk0taW5qZWN0ZWQgZXhjZXB0
aW9uIGlzIGxvc3QsIGFuZCBpdCBjYW4NCj4gPiBiZSByZS1nZW5lcmF0ZWQgb25jZSB0aGUgc2Vj
b25kIGV4Y2VwdGlvbiBpcyBjb3JyZWN0bHkgaGFuZGxlZC4NCj4gDQo+IFRoYXQncyBub3QgYSBw
cm9ibGVtLCB0aGUgYmVoYXZpb3IgaXMgdGhlIHNhbWUgYXMgb24gYmFyZSBtZXRhbCAoZGVwZW5k
aW5nIG9uDQo+IHdoZXRoZXIgdGhlIHR3byBleGNlcHRpb25zIGFyZSBiZW5pZ24vY29udHJpYnV0
b3J5L3BhZ2UgZmF1bHRzKS4NCg0KTXkgcG9pbnQgaXMgdGhhdCBpZiBLVk0gZG9lc24ndCBpbmpl
Y3QgdGhlIGZpcnN0IGV4Y2VwdGlvbiBpbiB0aGlzIHNwZWNpZmljDQpjYXNlIGFmdGVyIGl0IGhh
bmRsZXMgRVBUIHZpb2xhdGlvbiwgIGFzIHlvdSBzYWlkLCB0aGUgYmVoYXZpb3IgaXMgc3RpbGwg
dGhlDQpzYW1lIGFzIG9uIGJhcmUgbWV0YWwuDQoNCkl0IG1ha2VzIG5vIGRpZmZlcmVuY2Ugd2hl
dGhlciB0byBpbmplY3QgaXQgKmluIHRoaXMgc3BlY2lmaWMgY2FzZSouDQoNCkJ1dCBhcyB5b3Ug
YW5kIFNlYW4gc2FpZCwgaXQgY2FuJ3QgZGVhbCB0aGUgY2FzZSB0aGF0IEwxIGluamVjdHMgYW4g
ZXhjZXB0aW9uDQpub3QgcmVsYXRlZCB0byB0aGUgY29kZSB0aGF0IEwyIGlzIGV4ZWN1dGluZy4N
Cg0KVGhhbmtzIQ0KICBYaW4NCg0KDQo=
