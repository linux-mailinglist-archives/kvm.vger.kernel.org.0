Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423464D2E98
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 13:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiCIMCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 07:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiCIMCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 07:02:24 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDAA13AA35;
        Wed,  9 Mar 2022 04:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646827285; x=1678363285;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9CVOv+vuTBW/hlvVDOCJwZO2U1rjUJ35kBGud6CW8xs=;
  b=WvzzFR716BipbxRiFJ95hMAM73Lb58TDLCTG8CStPH7MiCsikOl33Xo8
   eL3+CPwshO4uiuhJ7S1++tL+FOX376xOQ3ha+MFBrUOQ3SGwocn83k33e
   I5MOT9FxVEcI6a2tsIfJsmydwsSobMXuHBZ/AfxB89XQq443Rqe0PQCxW
   XQUy16dAi5m2QPWrhehULH19xS5X6ROY1hdFZDDDaUyKbVIfkp26Pqgg9
   dAsMBmbIoytL4RHlzt4OJ0CzgYbHjYEHTMKavbf4xEbXqa+qhs68CYWit
   JqEEUeRqUS9OKyRga6sFu3arxmnYCyQ/XFl88BqF1chUC1h44QYkPKd1F
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="234909488"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="234909488"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 04:01:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="537982550"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 09 Mar 2022 04:01:24 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 04:01:24 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 04:01:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 9 Mar 2022 04:01:23 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 9 Mar 2022 04:01:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGojDKzbMq6Jmf6wbzUohjZCGT3r1wxIVibeo7ecwgtPqHgYr4QYX1VWXDQlICiRGRAqRy9+tixbR4zCmVCDUMcfdGWT5JHohKnbrXu4Pg97V53DeHSugNBiYu1AOxyqi4LvQ0EqH3wfZuawTKWSms4rjWfIhX+tE1eSIS3ywSJaChPSvBfdWUDuQWXMSzRzi2q1+M/keoPNg0HcMdy5DSRI8svFF1O3x3Zx38APRe5IXBeR2+LYEWcmi0un1tt+4Fx4N2FwJ4CW+aPugH72Ufz8gtGeyoab+A5ZtGg84ytQF7rdvRv/5gvNgqEpKHE99p3eN4PydSi0CLZhGJZWLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CVOv+vuTBW/hlvVDOCJwZO2U1rjUJ35kBGud6CW8xs=;
 b=cG9yLhDZ5UPhjMvz8Y2VcGAi0JkwWgKPDe8Xa+YvM6JhDbeizQksQDpp/rGUa/T/m+S+yUgFp8UftVDd5KUZoC6BevWmHgOJDuait+8HXmoiqFCNhAeKpkUpQ6ZISuaY+S5C5Fu7MEv7i/OgYQcQPg0wfaoSZEMH7T/sERtbcivbvKU7cjmQiOZA2CkCaRHxETqwAVkcqDVwdh1rbt0K4mXcHl7FVhgjWiSLG9Jpd1jm+StQpti2iXyDRD/w5UkHr4h4RJTui5NBJ6MoQELprC936r9USZftx+EfQ0I36sI3ZY9j+OcrIGsNj/3+GZiYecwujpynoX72X034ipAQ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3665.namprd11.prod.outlook.com (2603:10b6:408:91::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 12:01:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 12:01:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v9 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Topic: [PATCH v9 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Index: AQHYMx1voFpTeZi+gUm8/EoxJDqDpKy21j2Q
Date:   Wed, 9 Mar 2022 12:01:21 +0000
Message-ID: <BN9PR11MB5276C76D7BC4ADAB8CC935BA8C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
 <20220308184902.2242-6-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20220308184902.2242-6-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 383c8d77-849d-41c0-d6cf-08da01c48741
x-ms-traffictypediagnostic: BN8PR11MB3665:EE_
x-microsoft-antispam-prvs: <BN8PR11MB3665CCCCDCA821A9819C1B298C0A9@BN8PR11MB3665.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mv8eJumFG2wEwrPZPQchmDxR3P0sKHw+d5IKyitABeUnW+bLNhP54l066TC27QI0zLCQmaEPiCC+r9Ht57nMVzu1yIF/57EM90OqxBJrI79TPG3ZEPikOaD+1fecDKkIAXLJ+b29d6iVrBfa7OR9J8NbD6pH+e99CmWbX5XDslXbv4Ai9CkHZE4sra5yZzclgv0B3veYBnIiFRNLary/WCf4OwKgKYy+/i3ZlFVJAElx5b+kK1hQoJANSwMJQh/bsiUolk1UeTkiclJUhkQ3vKGlHpJ/wMPKzScCNYsX5P8txULncGYX8pFhXhWx0uN+URHfutmqnAiWvDb9nSEA+C+brJLHkCg4nu6ragBdFq27LkFidRRxekLX7+TDt5M85L1Y+MR1tg+zaw1w3a2N4ots89AxMlMK4TW7aK7f4d3xxUA/HC7ipV2Nq3MJgYnlKb5Vxgrud4IN5O+GJ4WM+KWSRR+VQuA+DzrYHr4aLJ9Wzu0rZEtCgkh88Qn3gQs89v6avyDDtGoapPZF6IZx+3f8iccMiKW5uzRIYxrmTnwCzukNsCDUgr3Vv4j5b55DfDuO1dvTMXpZViy80Eg6Zolul96FGwlY2+4Z7W25rOEVH0++KYB0luGPVzREevBq390WI+it7dy4idaAhpwgjthC8srEVYz8Y8yZg7cviRVZQ2L16VA+6qB0A8Gzcr+LYxzK6UsVgr/FFPDDkf+U6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(52536014)(33656002)(83380400001)(8936002)(7416002)(26005)(55016003)(508600001)(186003)(71200400001)(76116006)(54906003)(4326008)(66946007)(66476007)(66446008)(66556008)(86362001)(6506007)(7696005)(9686003)(2906002)(110136005)(8676002)(64756008)(122000001)(38100700002)(38070700005)(316002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bCtoWjFJMlFMTEZaWENiN3o0SS9WaDdoTmk0Q05QTVdvakdsNEN5eUxKS2hS?=
 =?utf-8?B?NlR3R0hFVVorSUMxRFN6ai9OaktBamEvdGtrbmVWU0VGdFBBSUc5Z2lXSDk2?=
 =?utf-8?B?VTJ1MTBjWUFIWFc5ZlBaRnMzZEdNVURxcitvNzU0LzVTeDhnV3lESzN3L3JI?=
 =?utf-8?B?RXBxSVZIWjB2TFpmWk5VMG1jUGd3ZWhiSit0Zk9lcVExMUZGSHI4cldiNWxB?=
 =?utf-8?B?cmJ4RDNNNDNUQzZvTFVoTFVxV2I5YlIxZnVPcExvTUdxRnNuWDU2QlVmSzdJ?=
 =?utf-8?B?V2RNN0FIWDFScHl5QXdFSTY0QWJOZFJkOEx0WmVOeHZHL3lGREJXMW1Vdzlm?=
 =?utf-8?B?dWJWaUFOdG03UkVnc2Rwc0w1NlRyWURFcnpUM2JBTTl3MHljbUVkeWRxb2Zw?=
 =?utf-8?B?cDlnMGRBaDREYWNwRTB0Y25FK2kwRlY3TWN3T1VNU0dIRGdXZHpocVpid2U1?=
 =?utf-8?B?UUFYd0ROM0cycmdZUXNZNVQyTFBzY0xHN1RwbFo5eDYrYmVweTN4QXZtbzJx?=
 =?utf-8?B?akNRUGJvTlZCWFdVcXIzcHhtS3h3TlJJNjBlL2JkRmsycm43QnhaSnJ5b0xm?=
 =?utf-8?B?Sk5SYUtNRlMwUkE4S2VZRllIQXJvOXpqWWVGSTJCdTJUL1VUUi9YclR1ZDJO?=
 =?utf-8?B?MzVjc1RwN3hlUXhReVl6M2tKV2c1dHVlblNabFJsbkJLWk9UUTRDSjNmTkxI?=
 =?utf-8?B?V3RXaFZQVXVjMUpIQUJsWmF2VHd6STFiZWFxblhuNjNLdlRoSGZUc29aWHRL?=
 =?utf-8?B?TXJhYlZkSU1uWTFMUXBSSEJRZnJRcFZWdkpSeUVVcEVyb0hzdTJ2MnRaZzVO?=
 =?utf-8?B?YkNXN1Qxam55MkNpU1NGWFFzTTZKbkg3SFNuTEkrdm4rT2FoN05ENE55S2hG?=
 =?utf-8?B?djhzYUlrQVd5c1ZFc2VkMFZSRWNxNnMyaTNuUWhkaVI5bk9GQm15M3ExT3pM?=
 =?utf-8?B?S041ZGJSVGprZVVsbGpZV0FiWDhQcFlZRUloNThIZlNWd1hMelFhbXYwZXhE?=
 =?utf-8?B?T0t3Ukg3TFNPc0JhcVRublBOcUxWNWVQMmNWaGR5cTJpYy8vSTlrdEpQMmpV?=
 =?utf-8?B?OGhzUHRRYXM3Z2hXS2FTYm9RZkhMUHBrSEhVWW1aM1gvK2hwQ0dWR2p2Y0ZQ?=
 =?utf-8?B?YWJBQU5mR3JTaGpDakxBaE91OHRDdEZQd1grZE1JQ29KZDBpT1Q1ZWtsWmQv?=
 =?utf-8?B?ME9adW1lbFJXOVhTdnlpblF1ZUp4Y2dvRXBKajBSNWFoZXcvMHlDQU9XVm1R?=
 =?utf-8?B?RCtrL05hemJxc3ppczhGRmU5dzNKUVRpeW00a1VSc1BtM1JDbEEyVUhkRkZJ?=
 =?utf-8?B?ZkdmNW0yeHliYm1yUmdDMUl2dTJyNXpBSGFxUmQvQkdQK0FJNUtXTkVGOW1W?=
 =?utf-8?B?aTdMNUNUSklWTFVuS2NHRDlIWDcwNExUMml6TktiVmtTVkkwZUd4YVl6eWNw?=
 =?utf-8?B?UEhaeVNaZlMxR3ZYWUtZamEzb3dmQTZhYm5lTUN2Uis0WFhvQkVGbTRESVZY?=
 =?utf-8?B?R1VteTgxbGc2VlNUOU1ES1VUTGV3bXVTZ3M2eUYvZm1URjNHbjM0dFJhVjlV?=
 =?utf-8?B?SmZjem45WDZMMTZ6MGVZdTdFMldYajAyQkxqVnkyMnNoTHkxT1I4ZXdLckdT?=
 =?utf-8?B?SW5NZlRCQTB5Q3JrdVRJdVo1SEtzR2VlRDkxVnhjd0VjN1E5dmtvT0NhZW9t?=
 =?utf-8?B?NUhqNTlWQjFEVWJidUNKQXFuVWxwWWFLVEdMODdVQlFTL05iRVJHTWxuWVlz?=
 =?utf-8?B?b0VMdGtnbktGbS9mN1lLOGdLWGxLYmFnS0pHeUpPc1VINzFKZ3V0aytjZ1Y3?=
 =?utf-8?B?aks3WTFWSTFSaWc5ajFaS2JDQ1FTbmQzNlZBTDQya0tCWHZVcDNGVzBNNXRn?=
 =?utf-8?B?L2hyWEx2bkl6ZFg3VVlkYjI3eEFJZXAxRmYxOUFtYmJrTmQ4T2JDMzJpclJL?=
 =?utf-8?Q?5YoP2WkIBGCA5d/o/p3h1K7H+hF5CUhT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 383c8d77-849d-41c0-d6cf-08da01c48741
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 12:01:22.0022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1jCLsy/2qgVdZBgTc6dZ79i/jPniOBrWknGUSxerYCxjwqWQhhb1z9YYKJUbAVRhAevUtsMNtM3s/01o0w6/bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3665
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyIEtvbG90aHVtIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdl
aS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggOSwgMjAyMiAyOjQ5IEFNDQo+IA0KPiBI
aVNpbGljb24gQUNDIFZGIGRldmljZSBCQVIyIHJlZ2lvbiBjb25zaXN0cyBvZiBib3RoIGZ1bmN0
aW9uYWwgcmVnaXN0ZXINCj4gc3BhY2UgYW5kIG1pZ3JhdGlvbiBjb250cm9sIHJlZ2lzdGVyIHNw
YWNlLiBVbm5lY2Vzc2FyaWx5wqBleHBvc2luZyB0aGUNCj4gbWlncmF0aW9uIEJBUiByZWdpb24g
dG8gdGhlIEd1ZXN0IGhhcyB0aGUgcG90ZW50aWFsIHRvIHByZXZlbnQvY29ycnVwdA0KPiB0aGUg
R3Vlc3QgbWlncmF0aW9uLg0KPiANCj4gSGVuY2UsIGludHJvZHVjZSBhIHNlcGFyYXRlIHN0cnVj
dCB2ZmlvX2RldmljZV9vcHMgZm9yIG1pZ3JhdGlvbiBzdXBwb3J0DQo+IHdoaWNoIHdpbGwgb3Zl
cnJpZGUgdGhlIGlvY3RsL3JlYWQvd3JpdGUvbW1hcCBtZXRob2RzIHRvIGhpZGUgdGhlDQo+IG1p
Z3JhdGlvbiByZWdpb24gYW5kIGxpbWl0IHRoZSBHdWVzdCBhY2Nlc3Mgb25seSB0byB0aGUgZnVu
Y3Rpb25hbA0KPiByZWdpc3RlciBzcGFjZS4NCj4gDQo+IFRoaXMgd2lsbCBiZSB1c2VkIGluIHN1
YnNlcXVlbnQgcGF0Y2hlcyB3aGVuIHdlIGFkZCBtaWdyYXRpb24gc3VwcG9ydA0KPiB0byB0aGUg
ZHJpdmVyLg0KPiANCj4gUGxlYXNlIG5vdGUgdGhhdCBpdCBpcyBPSyB0byBleHBvcnQgdGhlIGVu
dGlyZSBWRiBCQVIgaWYgbWlncmF0aW9uIGlzDQo+IG5vdCBzdXBwb3J0ZWQgb3IgcmVxdWlyZWQg
YXMgdGhpcyBjYW5ub3QgYWZmZWN0IHRoZSBQRiBjb25maWd1cmF0aW9ucy4NCj4gDQo+IFJldmll
d2VkLWJ5OiBMb25nZmFuZyBMaXUgPGxpdWxvbmdmYW5nQGh1YXdlaS5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IFNoYW1lZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2Vp
LmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0K
DQo+IC0tLQ0KPiAgLi4uL3ZmaW8vcGNpL2hpc2lsaWNvbi9oaXNpX2FjY192ZmlvX3BjaS5jICAg
IHwgMTI2ICsrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEyNiBpbnNlcnRp
b25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS9oaXNpbGljb24vaGlz
aV9hY2NfdmZpb19wY2kuYw0KPiBiL2RyaXZlcnMvdmZpby9wY2kvaGlzaWxpY29uL2hpc2lfYWNj
X3ZmaW9fcGNpLmMNCj4gaW5kZXggODEyOWMzNDU3YjNiLi41ODJlZTRmYTQxMDkgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvdmZpby9wY2kvaGlzaWxpY29uL2hpc2lfYWNjX3ZmaW9fcGNpLmMNCj4g
KysrIGIvZHJpdmVycy92ZmlvL3BjaS9oaXNpbGljb24vaGlzaV9hY2NfdmZpb19wY2kuYw0KPiBA
QCAtMTMsNiArMTMsMTE5IEBADQo+ICAjaW5jbHVkZSA8bGludXgvdmZpby5oPg0KPiAgI2luY2x1
ZGUgPGxpbnV4L3ZmaW9fcGNpX2NvcmUuaD4NCj4gDQo+ICtzdGF0aWMgaW50IGhpc2lfYWNjX3Bj
aV9yd19hY2Nlc3NfY2hlY2soc3RydWN0IHZmaW9fZGV2aWNlICpjb3JlX3ZkZXYsDQo+ICsJCQkJ
CXNpemVfdCBjb3VudCwgbG9mZl90ICpwcG9zLA0KPiArCQkJCQlzaXplX3QgKm5ld19jb3VudCkN
Cj4gK3sNCj4gKwl1bnNpZ25lZCBpbnQgaW5kZXggPSBWRklPX1BDSV9PRkZTRVRfVE9fSU5ERVgo
KnBwb3MpOw0KPiArCXN0cnVjdCB2ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiA9DQo+ICsJCWNv
bnRhaW5lcl9vZihjb3JlX3ZkZXYsIHN0cnVjdCB2ZmlvX3BjaV9jb3JlX2RldmljZSwgdmRldik7
DQo+ICsNCj4gKwlpZiAoaW5kZXggPT0gVkZJT19QQ0lfQkFSMl9SRUdJT05fSU5ERVgpIHsNCj4g
KwkJbG9mZl90IHBvcyA9ICpwcG9zICYgVkZJT19QQ0lfT0ZGU0VUX01BU0s7DQo+ICsJCXJlc291
cmNlX3NpemVfdCBlbmQgPSBwY2lfcmVzb3VyY2VfbGVuKHZkZXYtPnBkZXYsIGluZGV4KSAvDQo+
IDI7DQo+ICsNCj4gKwkJLyogQ2hlY2sgaWYgYWNjZXNzIGlzIGZvciBtaWdyYXRpb24gY29udHJv
bCByZWdpb24gKi8NCj4gKwkJaWYgKHBvcyA+PSBlbmQpDQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gKw0KPiArCQkqbmV3X2NvdW50ID0gbWluKGNvdW50LCAoc2l6ZV90KShlbmQgLSBwb3MpKTsN
Cj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiArc3RhdGljIGludCBoaXNp
X2FjY192ZmlvX3BjaV9tbWFwKHN0cnVjdCB2ZmlvX2RldmljZSAqY29yZV92ZGV2LA0KPiArCQkJ
CSAgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpDQo+ICt7DQo+ICsJc3RydWN0IHZmaW9fcGNp
X2NvcmVfZGV2aWNlICp2ZGV2ID0NCj4gKwkJY29udGFpbmVyX29mKGNvcmVfdmRldiwgc3RydWN0
IHZmaW9fcGNpX2NvcmVfZGV2aWNlLCB2ZGV2KTsNCj4gKwl1bnNpZ25lZCBpbnQgaW5kZXg7DQo+
ICsNCj4gKwlpbmRleCA9IHZtYS0+dm1fcGdvZmYgPj4gKFZGSU9fUENJX09GRlNFVF9TSElGVCAt
IFBBR0VfU0hJRlQpOw0KPiArCWlmIChpbmRleCA9PSBWRklPX1BDSV9CQVIyX1JFR0lPTl9JTkRF
WCkgew0KPiArCQl1NjQgcmVxX2xlbiwgcGdvZmYsIHJlcV9zdGFydDsNCj4gKwkJcmVzb3VyY2Vf
c2l6ZV90IGVuZCA9IHBjaV9yZXNvdXJjZV9sZW4odmRldi0+cGRldiwgaW5kZXgpIC8NCj4gMjsN
Cj4gKw0KPiArCQlyZXFfbGVuID0gdm1hLT52bV9lbmQgLSB2bWEtPnZtX3N0YXJ0Ow0KPiArCQlw
Z29mZiA9IHZtYS0+dm1fcGdvZmYgJg0KPiArCQkJKCgxVSA8PCAoVkZJT19QQ0lfT0ZGU0VUX1NI
SUZUIC0gUEFHRV9TSElGVCkpIC0gMSk7DQo+ICsJCXJlcV9zdGFydCA9IHBnb2ZmIDw8IFBBR0Vf
U0hJRlQ7DQo+ICsNCj4gKwkJaWYgKHJlcV9zdGFydCArIHJlcV9sZW4gPiBlbmQpDQo+ICsJCQly
ZXR1cm4gLUVJTlZBTDsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gdmZpb19wY2lfY29yZV9tbWFw
KGNvcmVfdmRldiwgdm1hKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIHNzaXplX3QgaGlzaV9hY2Nf
dmZpb19wY2lfd3JpdGUoc3RydWN0IHZmaW9fZGV2aWNlICpjb3JlX3ZkZXYsDQo+ICsJCQkJICAg
ICAgIGNvbnN0IGNoYXIgX191c2VyICpidWYsIHNpemVfdCBjb3VudCwNCj4gKwkJCQkgICAgICAg
bG9mZl90ICpwcG9zKQ0KPiArew0KPiArCXNpemVfdCBuZXdfY291bnQgPSBjb3VudDsNCj4gKwlp
bnQgcmV0Ow0KPiArDQo+ICsJcmV0ID0gaGlzaV9hY2NfcGNpX3J3X2FjY2Vzc19jaGVjayhjb3Jl
X3ZkZXYsIGNvdW50LCBwcG9zLA0KPiAmbmV3X2NvdW50KTsNCj4gKwlpZiAocmV0KQ0KPiArCQly
ZXR1cm4gcmV0Ow0KPiArDQo+ICsJcmV0dXJuIHZmaW9fcGNpX2NvcmVfd3JpdGUoY29yZV92ZGV2
LCBidWYsIG5ld19jb3VudCwgcHBvcyk7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBzc2l6ZV90IGhp
c2lfYWNjX3ZmaW9fcGNpX3JlYWQoc3RydWN0IHZmaW9fZGV2aWNlICpjb3JlX3ZkZXYsDQo+ICsJ
CQkJICAgICAgY2hhciBfX3VzZXIgKmJ1Ziwgc2l6ZV90IGNvdW50LA0KPiArCQkJCSAgICAgIGxv
ZmZfdCAqcHBvcykNCj4gK3sNCj4gKwlzaXplX3QgbmV3X2NvdW50ID0gY291bnQ7DQo+ICsJaW50
IHJldDsNCj4gKw0KPiArCXJldCA9IGhpc2lfYWNjX3BjaV9yd19hY2Nlc3NfY2hlY2soY29yZV92
ZGV2LCBjb3VudCwgcHBvcywNCj4gJm5ld19jb3VudCk7DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0
dXJuIHJldDsNCj4gKw0KPiArCXJldHVybiB2ZmlvX3BjaV9jb3JlX3JlYWQoY29yZV92ZGV2LCBi
dWYsIG5ld19jb3VudCwgcHBvcyk7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBsb25nIGhpc2lfYWNj
X3ZmaW9fcGNpX2lvY3RsKHN0cnVjdCB2ZmlvX2RldmljZSAqY29yZV92ZGV2LCB1bnNpZ25lZA0K
PiBpbnQgY21kLA0KPiArCQkJCSAgICB1bnNpZ25lZCBsb25nIGFyZykNCj4gK3sNCj4gKwlpZiAo
Y21kID09IFZGSU9fREVWSUNFX0dFVF9SRUdJT05fSU5GTykgew0KPiArCQlzdHJ1Y3QgdmZpb19w
Y2lfY29yZV9kZXZpY2UgKnZkZXYgPQ0KPiArCQkJY29udGFpbmVyX29mKGNvcmVfdmRldiwgc3Ry
dWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlLA0KPiB2ZGV2KTsNCj4gKwkJc3RydWN0IHBjaV9kZXYg
KnBkZXYgPSB2ZGV2LT5wZGV2Ow0KPiArCQlzdHJ1Y3QgdmZpb19yZWdpb25faW5mbyBpbmZvOw0K
PiArCQl1bnNpZ25lZCBsb25nIG1pbnN6Ow0KPiArDQo+ICsJCW1pbnN6ID0gb2Zmc2V0b2ZlbmQo
c3RydWN0IHZmaW9fcmVnaW9uX2luZm8sIG9mZnNldCk7DQo+ICsNCj4gKwkJaWYgKGNvcHlfZnJv
bV91c2VyKCZpbmZvLCAodm9pZCBfX3VzZXIgKilhcmcsIG1pbnN6KSkNCj4gKwkJCXJldHVybiAt
RUZBVUxUOw0KPiArDQo+ICsJCWlmIChpbmZvLmFyZ3N6IDwgbWluc3opDQo+ICsJCQlyZXR1cm4g
LUVJTlZBTDsNCj4gKw0KPiArCQlpZiAoaW5mby5pbmRleCA9PSBWRklPX1BDSV9CQVIyX1JFR0lP
Tl9JTkRFWCkgew0KPiArCQkJaW5mby5vZmZzZXQgPSBWRklPX1BDSV9JTkRFWF9UT19PRkZTRVQo
aW5mby5pbmRleCk7DQo+ICsNCj4gKwkJCS8qDQo+ICsJCQkgKiBBQ0MgVkYgZGV2IEJBUjIgcmVn
aW9uIGNvbnNpc3RzIG9mIGJvdGggZnVuY3Rpb25hbA0KPiArCQkJICogcmVnaXN0ZXIgc3BhY2Ug
YW5kIG1pZ3JhdGlvbiBjb250cm9sIHJlZ2lzdGVyIHNwYWNlLg0KPiArCQkJICogUmVwb3J0IG9u
bHkgdGhlIGZ1bmN0aW9uYWwgcmVnaW9uIHRvIEd1ZXN0Lg0KPiArCQkJICovDQo+ICsJCQlpbmZv
LnNpemUgPSBwY2lfcmVzb3VyY2VfbGVuKHBkZXYsIGluZm8uaW5kZXgpIC8gMjsNCj4gKw0KPiAr
CQkJaW5mby5mbGFncyA9IFZGSU9fUkVHSU9OX0lORk9fRkxBR19SRUFEIHwNCj4gKwkJCQkJVkZJ
T19SRUdJT05fSU5GT19GTEFHX1dSSVRFIHwNCj4gKwkJCQkJVkZJT19SRUdJT05fSU5GT19GTEFH
X01NQVA7DQo+ICsNCj4gKwkJCXJldHVybiBjb3B5X3RvX3VzZXIoKHZvaWQgX191c2VyICopYXJn
LCAmaW5mbywNCj4gbWluc3opID8NCj4gKwkJCQkJICAgIC1FRkFVTFQgOiAwOw0KPiArCQl9DQo+
ICsJfQ0KPiArCXJldHVybiB2ZmlvX3BjaV9jb3JlX2lvY3RsKGNvcmVfdmRldiwgY21kLCBhcmcp
Ow0KPiArfQ0KPiArDQo+ICBzdGF0aWMgaW50IGhpc2lfYWNjX3ZmaW9fcGNpX29wZW5fZGV2aWNl
KHN0cnVjdCB2ZmlvX2RldmljZSAqY29yZV92ZGV2KQ0KPiAgew0KPiAgCXN0cnVjdCB2ZmlvX3Bj
aV9jb3JlX2RldmljZSAqdmRldiA9DQo+IEBAIC0yOCw2ICsxNDEsMTkgQEAgc3RhdGljIGludCBo
aXNpX2FjY192ZmlvX3BjaV9vcGVuX2RldmljZShzdHJ1Y3QNCj4gdmZpb19kZXZpY2UgKmNvcmVf
dmRldikNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gDQo+ICtzdGF0aWMgY29uc3Qgc3RydWN0IHZm
aW9fZGV2aWNlX29wcyBoaXNpX2FjY192ZmlvX3BjaV9taWdybl9vcHMgPSB7DQo+ICsJLm5hbWUg
PSAiaGlzaS1hY2MtdmZpby1wY2ktbWlncmF0aW9uIiwNCj4gKwkub3Blbl9kZXZpY2UgPSBoaXNp
X2FjY192ZmlvX3BjaV9vcGVuX2RldmljZSwNCj4gKwkuY2xvc2VfZGV2aWNlID0gdmZpb19wY2lf
Y29yZV9jbG9zZV9kZXZpY2UsDQo+ICsJLmlvY3RsID0gaGlzaV9hY2NfdmZpb19wY2lfaW9jdGws
DQo+ICsJLmRldmljZV9mZWF0dXJlID0gdmZpb19wY2lfY29yZV9pb2N0bF9mZWF0dXJlLA0KPiAr
CS5yZWFkID0gaGlzaV9hY2NfdmZpb19wY2lfcmVhZCwNCj4gKwkud3JpdGUgPSBoaXNpX2FjY192
ZmlvX3BjaV93cml0ZSwNCj4gKwkubW1hcCA9IGhpc2lfYWNjX3ZmaW9fcGNpX21tYXAsDQo+ICsJ
LnJlcXVlc3QgPSB2ZmlvX3BjaV9jb3JlX3JlcXVlc3QsDQo+ICsJLm1hdGNoID0gdmZpb19wY2lf
Y29yZV9tYXRjaCwNCj4gK307DQo+ICsNCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdmZpb19kZXZp
Y2Vfb3BzIGhpc2lfYWNjX3ZmaW9fcGNpX29wcyA9IHsNCj4gIAkubmFtZSA9ICJoaXNpLWFjYy12
ZmlvLXBjaSIsDQo+ICAJLm9wZW5fZGV2aWNlID0gaGlzaV9hY2NfdmZpb19wY2lfb3Blbl9kZXZp
Y2UsDQo+IC0tDQo+IDIuMjUuMQ0KDQo=
