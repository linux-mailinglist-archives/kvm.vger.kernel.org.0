Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542BF4DD30A
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 03:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiCRCZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 22:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiCRCZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 22:25:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F751DA8FB;
        Thu, 17 Mar 2022 19:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647570248; x=1679106248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n4DGeMIQMi+sYIZ1hFmSwBxLMAekUrKitQjPfq7YYEA=;
  b=RlQKBv3egswJoZim7vb2NODuErNw7M9TN0NITAQJrsIdeMjzPm4/qMeX
   qQMQeIwTWIH8KoN52H/pPg2rOJNILOLoJ/OigJIUO3uOvvBrN5chSBmgL
   4irMq/sw0gtUWzPN4FNJLJzAFMlhdJsWEOygVUFo/ofUx06ixNdD1153z
   LDgWx1wfUY2TAJyythyqnYGvA6EntfdCuctYCKPne88qf/Cf4xpRZQ61r
   h4t8laAeP/M1Q6SMmfVg534EwH2zPAR27136GhS3VD3bQbo6Z5jG8zuvO
   kQejBEKeex3Vqv+WK4Arn8B8Vud3uwtDRYbhsEyw2OE3OUo6ZckzcjE+3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="256757825"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="256757825"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 19:24:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="614203180"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 17 Mar 2022 19:24:06 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 19:24:06 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 19:24:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 17 Mar 2022 19:24:05 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 17 Mar 2022 19:24:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bfsupyr1X/g8/yL0udq3qXKuiaxwaJL7qGSLp1sE3m5EmCSVq5/aokOnng+Ly9V7cU+mEJVcjLRM4hVU2WM4E3Pf1ugrKiHr4HrYFwTC0r7vj/qKEp2/XElT/SFAKwhhGDYmFBevV43pMupkW8c6Sy5UcFpW9SG/Cf651m2X1KxFM0vfTWRE9x/nxzl5VcrYtXHLBkjK0OLh+9BtovEU7MVQGYTZ+VjsktburkvRmDWVMJshS6UEiaWhr30AdV6ag9bA4wLiuc8BaPr4wIdBZC0Rgcx36QfbtVQC1C4Ka4yIYRX6mKb5LPgHG7oVgjfn8PXvfEjBTfl3+v+IhRt7GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4DGeMIQMi+sYIZ1hFmSwBxLMAekUrKitQjPfq7YYEA=;
 b=a8snpaA2Xo7YPYhybJXwEEjkuYJe/ZEMW2hbdfjQ08fSrKGzZRUqO6Pp1R80mvrkLHaqSlLcrA8fscCGT9JXo68//431ouzd/ZSqrXOunPYuJjDbHnx3ZRaNHlkjQ/jjAQivlVFhpbYxwUsrpCRTa+l3l21SlymOfq7X7d0rU3N1PUAQ/v7iyyb546jn2logiOkCBi059phMH2n5DqsI0NRPfttJubaftG0OudUvtrOpIywWYQV8qU6B/0xm3YPwI3UM7uuwhm3uuyYH9HiEH252fd1G8H/JJXhByxP1iAhyoNYSHwbMXOHTeWDpG+VmyXaJtWo9UjdmBYb/Su/qRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5261.namprd11.prod.outlook.com (2603:10b6:5:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Fri, 18 Mar
 2022 02:23:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 02:23:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "will@kernel.org" <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and the
 KVM type
Thread-Topic: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and
 the KVM type
Thread-Index: AQHYN9xnDDDBVY4pLUqXQfRGdryZ0KzARNcAgALO3mCAAIkrAIAAzPRA
Date:   Fri, 18 Mar 2022 02:23:57 +0000
Message-ID: <BN9PR11MB52764EF888DDB7822B88CF918C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-15-mjrosato@linux.ibm.com>
 <a9637631-c23b-4158-d2cb-597a36b09a6b@arm.com>
 <BN9PR11MB5276360F6DBDC3A238F3E41A8C129@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220317135254.GZ11336@nvidia.com>
In-Reply-To: <20220317135254.GZ11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f224b20-f026-4a59-84e0-08da08865b38
x-ms-traffictypediagnostic: DM4PR11MB5261:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM4PR11MB5261894331BCC29C6752F2A08C139@DM4PR11MB5261.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M/FXHztr4MeyZ1gzIG2eWyqrH32y5Q6eUubUWvuhPXTIS+O3CoYCiChWQmSQExEv/RDQ997Hi9YXhbhOh243R7WTzWn0rh1RM8cj8Ee99akDTHMjMU5qVHDInd0nwv5zpDKRzJbiiek+0+qcvbGg+5TZVnUnzlzMDywayY6ycRaS+xffbLEVxAbsNQJ7UoPVdYBRrNZkrPgqmJFV8egotL39cGJ+mqJg68NhaTlIcR4Q7GnsF51WCEeipxyYW394PI4RohvfDtorfFctwit+0ejsDhvLpxmTC6kFoyxuVgKtKC78ruCjTuuTV/vpiM7sW8I/GkQd4PiUIIHqHEahP/mQIl+pVLsqOMKibtUT6lRncvYBhpMz+YO30qu0xZJG28tninKPRYe5lFkKmMVS8TvO/ToiQhBHeDlDODjV9sRyoR32jao1SRsTkBSwxTSBMGegvvxdyXs66PNEB1HpC9mkDkbI2y9zcz8g/c8h3nQbhXTjMf32Ku/nwcYcXUaYpzub046bw2wZz93Fxs8amzQKjYhAHbsautI11vc1mwCora+QDLv1uRgTK4OKvV+NN7X9fbKXpyZ7zefumTl+WbhZgZTaoQG2UNx2lXSIwp8xUKyClI4mnK2ipqGT4h6YtiyAISyLUvRU+1oJJDLNwBCD8uBPLDljQumsmn1tk0yNPefUVOqIcfiHIJL8dgkJJQ2LObaVKu17Qkp/JIAtPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(33656002)(316002)(2906002)(53546011)(9686003)(7696005)(6506007)(8936002)(5660300002)(7406005)(7416002)(52536014)(8676002)(26005)(186003)(64756008)(107886003)(82960400001)(38070700005)(71200400001)(122000001)(86362001)(6916009)(54906003)(508600001)(38100700002)(66446008)(76116006)(66946007)(66556008)(66476007)(4326008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qi9WVzhFcXlVVWdCZklZeDlNMTdvWm9yQ1FwMks4dWw0clJLell5SWdPVHlW?=
 =?utf-8?B?dmJ2RmQrcFZOcWRnbjlmZW01eTNQZlRpZXh0U3pHSVpXenh3Sm53QzhwbHQx?=
 =?utf-8?B?Z0laVU4wVGpodVNldGpvYmxTOGorakhlbTVWdWwyaFluclJkbnF0QmI5NXk1?=
 =?utf-8?B?ZzVEYU9xSHBxZThXNFdBNGQ4Z1VseUFiSHJLRFdXdGpodFVyekVlQUR0VUhT?=
 =?utf-8?B?VUhJVjJDZkdnUEtnSC9SaW1vUVQ5b2tEdDNEa3BWdVdBSkFrT3hZMkNWS3A4?=
 =?utf-8?B?NFUvWmxjT2ZXaWxHOTBRM0lZeW5OUmszVWUrSFFIdXhiTm5POFNoMHBZUHRR?=
 =?utf-8?B?eFptNkFNbXdWR2hRMnZqaUpYaEtIVFBDcnhac2h1K0VhTUpEREZJeWh1U3hX?=
 =?utf-8?B?YTFuTDU1aTgwZ3U3R3FFWHdPMlpwbnR3N2VxYUJqZFl6YXFxREtxRy9JT0Zz?=
 =?utf-8?B?eCt2K3c1cktDbThremxDWTNMZ3pZckJ4dXROekpzM2tWMXdxUTB4Y1I0VThy?=
 =?utf-8?B?eVgrQXVtZ3lNaWNBOHh5ZjZCN0FyM1lyZWxRTEhxejREN3NNa1o5WTlYVWEz?=
 =?utf-8?B?TXdYaUFRMmJ6RXlmdStqUUhCSmE0blpZU0t3WlB3SW1NOG9BbG5ZMlZwSGhT?=
 =?utf-8?B?TUJEbzNkZlk0Q2xESE11OXJPR3BLazJzSUJ1S1dUbngrUCtLT09UYk1BbG5T?=
 =?utf-8?B?QkF6bUJ2V29hMjhQUVVzYjZuaVBDZTJBM2RseGxnODBGWGpMSVdMQ2lzNVNs?=
 =?utf-8?B?RWpPSjl4MktVUjhhYWxtbUEvOFEvTk5CNDJ2bjVpejZ2R0RPZFBSV3BhcTg4?=
 =?utf-8?B?RnB2TXIzVU9pWFkrMEplZmF5Zms1SXdkciszRUJtRGQrNEJuMWp1N2ZZOHZp?=
 =?utf-8?B?WjdEZ2ZJSXFIWktEQjBSKzFTQ0VHZVdza05TK3JsOHFaYjdVMzhpbTdiVmlX?=
 =?utf-8?B?NEpwSUorVjI2MHZsUjIzc2t3RWd6VitCZDRJb0F0NUFIWEIxeDI4RVF1Q3Za?=
 =?utf-8?B?V01mc0RUVW5weExiMVpDcS9PVTBXRHkvTVhudk9vYUc3aVNqVVpQaDZ2bUw5?=
 =?utf-8?B?MVhMbzZlN1hEYnBNRkMvYSs5d3R5Yit1N2tNWWZFcDcvK01HRHJGSTVZZ0d1?=
 =?utf-8?B?RFRVWDZDYXgxK05KQ3VXZ1R3R1Z2aURNTy9uSkhEWExvcWRMS0tzVnRDLzVP?=
 =?utf-8?B?aWNuNDdmdkZSbEFsbjBROHlZaW1jcVh1S0FIWHZXcTRHdkxmUDlvZGpjWXc3?=
 =?utf-8?B?MFNWcDhsZjJQU25IZEJRQnA3Mm91WXJZTDh0MTlYV0ZjRmZ0Qk1lRDZFMzEx?=
 =?utf-8?B?TGpKOWp5ZmNFSC9zUDQrc3pXTDRIYnJCY1N6SmtxNXJyYWYxZlhreEJLcExv?=
 =?utf-8?B?ZXppbXJzUUZodDNlM0duSkJDZmpYT0NtMlcrVHphNXExSlUxZ3BMM3d3L2hs?=
 =?utf-8?B?ZjZ3YmlGMzFkRHNzVDRZYysyRWh2emMrTnhTb3lxWFRqWkJqSnFLYnM4RTFO?=
 =?utf-8?B?TjhNSmsrRVVlaVRCckx2YVp4djkvV0QrdnFsZ2xXSUdIcXVsOVFxRytTNFM0?=
 =?utf-8?B?U0tJY0lDdE9BSjVJTXVGKytJcE4vaVB0SlVJUzZZaHU0VDRnLzRJWnJQM2RY?=
 =?utf-8?B?dW1zSzNNdnJUaVdpaE9CV0dyRXdnMEI1WGFiYjBwQkoxMFFYaWpoNEZXNWJS?=
 =?utf-8?B?a2Q2Vm92T2Z6WXNqbmVwdGNEMnVja2pmaGdBbXcreUxQTFp3bjRPWUxNRHpE?=
 =?utf-8?B?WlA4QXphZGY4OW05NVIyZGQvVGI5MmtkTFZTelluWXpoanNQTlNpbjlHU1VB?=
 =?utf-8?B?TGlIOWdJdUQxSzhoR2lMWFArbWtaVE9IK1Z3b0lBOTJWbExkQkcweXUvZ3or?=
 =?utf-8?B?djF6T2VYUXRKV0lUYXpEai9HYU1kWWpDSzdSVUxZckltNHhTNTRtNFBCbVpD?=
 =?utf-8?Q?SZOxp6/Ujkb9SZPN1pmHXe0lpeZRve3p?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f224b20-f026-4a59-84e0-08da08865b38
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2022 02:23:57.4322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5k1Qerkv4ULucZ+tSh511vqul0pKGsWKyCY1KQoGHkqc9d/mWWdBoQtEdtgVXV63bNgc+ulMmfyAz0CegnGZ5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5261
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgTWFyY2ggMTcsIDIwMjIgOTo1MyBQTQ0KPiANCj4gT24gVGh1LCBNYXIgMTcsIDIwMjIgYXQg
MDU6NDc6MzZBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBSb2JpbiBN
dXJwaHkNCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDE1LCAyMDIyIDY6NDkgUE0NCj4gPiA+
DQo+ID4gPiBPbiAyMDIyLTAzLTE0IDE5OjQ0LCBNYXR0aGV3IFJvc2F0byB3cm90ZToNCj4gPiA+
ID4gczM5MHggd2lsbCBpbnRyb2R1Y2UgYW4gYWRkaXRpb25hbCBkb21haW4gdHlwZSB0aGF0IGlz
IHVzZWQgZm9yDQo+ID4gPiA+IG1hbmFnaW5nIElPTU1VIG93bmVkIGJ5IEtWTS4gIERlZmluZSB0
aGUgdHlwZSBoZXJlIGFuZCBhZGQgYW4NCj4gPiA+ID4gaW50ZXJmYWNlIGZvciBhbGxvY2F0aW5n
IGEgc3BlY2lmaWVkIHR5cGUgdnMgdGhlIGRlZmF1bHQgdHlwZS4NCj4gPiA+DQo+ID4gPiBJJ20g
YWxzbyBub3QgYSBodWdlIGZhbiBvZiBhZGRpbmcgYSBuZXcgZG9tYWluX2FsbG9jIGludGVyZmFj
ZSBsaWtlDQo+ID4gPiB0aGlzLCBob3dldmVyIGlmIGl0IGlzIGp1c3RpZmlhYmxlLCB0aGVuIHBs
ZWFzZSBtYWtlIGl0IHRha2Ugc3RydWN0DQo+ID4gPiBkZXZpY2UgcmF0aGVyIHRoYW4gc3RydWN0
IGJ1c190eXBlIGFzIGFuIGFyZ3VtZW50Lg0KPiA+ID4NCj4gPiA+IEl0IGFsc28gc291bmRzIGxp
a2UgdGhlcmUgbWF5IGJlIGEgZGVncmVlIG9mIGNvbmNlcHR1YWwgb3ZlcmxhcCBoZXJlDQo+ID4g
PiB3aXRoIHdoYXQgSmVhbi1QaGlsaXBwZSBpcyB3b3JraW5nIG9uIGZvciBzaGFyaW5nIHBhZ2V0
YWJsZXMgYmV0d2Vlbg0KPiBLVk0NCj4gPiA+IGFuZCBTTU1VIGZvciBBbmRyb2lkIHBLVk0sIHNv
IGl0J3MgcHJvYmFibHkgd29ydGggc29tZSB0aG91Z2h0IG92ZXINCj4gPiA+IHdoZXRoZXIgdGhl
cmUncyBhbnkgc2NvcGUgZm9yIGNvbW1vbiBpbnRlcmZhY2VzIGluIHRlcm1zIG9mIGFjdHVhbA0K
PiA+ID4gaW1wbGVtZW50YXRpb24uDQo+ID4NCj4gPiBTYW1lIGhlcmUuIFlhbiBaaGFvIGlzIHdv
cmtpbmcgb24gcGFnZSB0YWJsZSBzaGFyaW5nIGJldHdlZW4gS1ZNDQo+ID4gYW5kIFZULWQuIFRo
aXMgaXMgb25lIGltcG9ydGFudCB1c2FnZSB0byBidWlsZCBhdG9wIGlvbW11ZmQgYW5kDQo+ID4g
YSBzZXQgb2YgY29tbW9uIGludGVyZmFjZXMgYXJlIGRlZmluaXRlbHkgbmVjZXNzYXJ5IGhlcmUu
IPCfmIoNCj4gDQo+IEkgYWx3YXlzIHRob3VnaHQgJ3BhZ2UgdGFibGUgc2hhcmluZyB3aXRoIEtW
TScgaXMgU1ZBIC0gaWUgaXQgcmVxdWlyZXMNCj4gUFJJIGluIHRoZSBJT01NVSBkcml2ZXIgYXMg
dGhlIEtWTSBwYWdlIHRhYmxlIGlzIGZ1bGx5IHVucGlubmVkIGFuZA0KPiBkeW5hbWljLiBUaGlz
IFMzOTAgY2FzZSBpcyBub3QgZG9pbmcgU1ZBL1BSSQ0KPiANCj4gQXJlIHBlb3BsZSB3b3JraW5n
IG9uIHRlYWNoaW5nIEtWTSB0byBETUEgcGluIGV2ZXJ5IHBhZ2UgYW5kIGF2b2lkDQo+IGhhdmlu
ZyBhIGR5bmFtaWMgcGFnZSB0YWJsZT8gSSdtIHN1cnByaXNlZCwgYSBsb3Qgb2Ygc3R1ZmYgd29u
J3Qgd29yaywNCj4gZWcgd3JpdGUgcHJvdGVjdC4uDQo+IA0KDQpZZXMsIHRoYXQgaXMgYW5vdGhl
ciBtYWpvciBwYXJ0IHdvcmsgYmVzaWRlcyB0aGUgaW9tbXVmZCB3b3JrLiBBbmQNCml0IGlzIG5v
dCBjb21wYXRpYmxlIHdpdGggS1ZNIGZlYXR1cmVzIHdoaWNoIHJlbHkgb24gdGhlIGR5bmFtaWMN
Cm1hbm5lciBvZiBFUFQuIFRob3VnaCBJdCBpcyBhIGJpdCBxdWVzdGlvbmFibGUgd2hldGhlciBp
dCdzIHdvcnRoeSBvZiANCmRvaW5nIHNvIGp1c3QgZm9yIHNhdmluZyBtZW1vcnkgZm9vdHByaW50
IHdoaWxlIGxvc2luZyBvdGhlciBjYXBhYmlsaXRpZXMsDQppdCBpcyBhIHJlcXVpcmVtZW50IGZv
ciBzb21lIGZ1dHVyZSBzZWN1cml0eSBleHRlbnNpb24gaW4gSW50ZWwgdHJ1c3RlZA0KY29tcHV0
aW5nIGFyY2hpdGVjdHVyZS4gQW5kIEtWTSBoYXMgYmVlbiBwaW5uaW5nIHBhZ2VzIGZvciBTRVYv
VERYL2V0Yy4NCnRvZGF5IHRodXMgc29tZSBmYWNpbGl0aWVzIGNhbiBiZSByZXVzZWQuIEJ1dCBJ
IGFncmVlIGl0IGlzIG5vdCBhIHNpbXBsZQ0KdGFzayB0aHVzIHdlIG5lZWQgc3RhcnQgZGlzY3Vz
c2lvbiBlYXJseSB0byBleHBsb3JlIHZhcmlvdXMgZ2FwcyBpbg0KaW9tbXUgYW5kIGt2bS4NCg0K
SW1hZ2luZSBtYW55IHRocmVhZHMgKGRpcnR5IHRyYWNraW5nLCBuZXN0ZWQsIEtWTSBwYWdlIHRh
YmxlIHNoYXJpbmcsDQpldGMuKSB3aWxsIHJ1biBpbiBwYXJhbGxlbCBzb29uIGFmdGVyIHRoZSBu
ZXcgaW9tbXVmZCBSRkMgaXMgb3V0LiBsb3RzIG9mDQpmdW4gYWhlYWQuIPCfmIoNCg0KVGhhbmtz
DQpLZXZpbg0K
