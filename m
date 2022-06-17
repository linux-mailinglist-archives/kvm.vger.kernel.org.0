Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF5354EFF2
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 06:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiFQEFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 00:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiFQEFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 00:05:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABEC65D1A
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 21:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655438708; x=1686974708;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=OAxNDao8C889C/nD+EiCyGl0Awu2alb+Z0eLQXu6d80=;
  b=JSJ/T2Dq+fecyEAP3e+FeXqCp4Mt7ObhL9BK8faDJXQkFehHS8LXqBVY
   SfZiBAUi2VsX3R43V+t3oDaANVHV6lmUvHzJRAyOr1SG3plaAuByEh32C
   9mEIqAmhltuqIVCFPL5MyjJqMkkqYiJHrUP+7hrOXBqPXkr/tTUzmXsvC
   /xV9I1e0Nt/yWSO1ZQHXGfpciPPZt8vEVvT52+5xihhgQFeV+DryzDwpU
   6UTTewwbI0M4QPjCEdVdh6yFDTD4vTqCOQwUIEW93o7Oyc9iKBrqbR/d3
   1bThcT/e7QH5umCxvsfejB3rdA3W8yhC/nwH9eNWF720vbQnEdFHxvzrQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="279471913"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="279471913"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 21:05:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="831868992"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jun 2022 21:05:07 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 21:04:40 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 21:04:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 21:04:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 21:04:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEgeroHO78lguym+5EXqVdGjWobrKWmsNUlldMKFhmQ6iBNcUzU5mWNnlpW9IW1QJMV7ZH6jAM8jyyFiW0n/Nho/4bRadnh0uPF2u9l56xS7KGePb71vzD1YdKePCK9Rq25IZuXWSsgMpC9pCU/FG5U1Kp4Bkf2bau0eydWk6GUMix/EnW69fkD+I68XBcwm7bY2F7BEHoRRjawHxH5BmzmkEr2gRTmlbHlaWy83hPhe4sNcz0ol6d12uhAReAiMaS5HN0xH0PFCG4R55VnIsmwII/4n/FGY5lrnQ7HA1kNLi9PTsouRgUND5W8G+zvAhz/nB4QbPY8Cw82HphB48g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAxNDao8C889C/nD+EiCyGl0Awu2alb+Z0eLQXu6d80=;
 b=Flpr7omeOerzZIxFcJES2lWwDCeGrG75EY219/WdET7nTALC/iP8a4qPYk4kpBs5F6T1e2WMH76/ecMM2CkmOe3unU3r4xWNNIrpI6MwzLZJ0EqR5+VOxVNmQOEZvkE5pt2zPxcYHEAqNM2Wro7K1CRTdu7QreKkS+xPNTtS0zrNi9PxHPQdRAPbE6JrtB7yXCRvjCxi4a+KsvA54STc5wV7E/dsgN6NTf5bKN6NvgNUYNKfCUXkdRb2XTZkf0u0VBmtICmOBEB+F4BhnNB3YNvrs7AOc30OnNfft0pDZcafJCtQ3PKqFOWTRjRqh+S9ENCUD7B6MKPZ4382/EecJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6464.namprd11.prod.outlook.com (2603:10b6:930:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 17 Jun
 2022 04:04:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 04:04:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Subject: RE: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Thread-Topic: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Thread-Index: AQHYeYOPTfntv5YgX0aKO1lwAOJE4K1IAOQggAT2HYCABS3PAIAAkiIAgABMO8CAAAfeUA==
Date:   Fri, 17 Jun 2022 04:04:37 +0000
Message-ID: <BN9PR11MB5276D9D472EDC5988C0C9C4B8CAF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
        <20220606085619.7757-3-yishaih@nvidia.com>
        <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
        <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
        <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
 <20220616170118.497620ba.alex.williamson@redhat.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a74fc93f-f5e7-4285-e91d-08da50167f27
x-ms-traffictypediagnostic: CY5PR11MB6464:EE_
x-microsoft-antispam-prvs: <CY5PR11MB6464BBE6399542A1E748AD5C8CAF9@CY5PR11MB6464.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V1qZ1a6Jl9m+PuaKz1cbl15YL8pYq7xi8+5Pbv0mplQ8H4YFstvSIF6RZYfxPUT/ey0BVTvt7RhF8DjUwXCTA0FxFikrM4YargYtUno5YZSEb1PFno3fPznRfT5hzzZ0GqCvdiYXISl/yi6or07x1N2OxW5hZyxvGIGvhHGmr58kEOFvUhpZPdbslOk/T+VB2Js0jovTBVIAm3LQBd3F7HwwIuWrzBRLvv6kH1TXyqYfdh//EXxAHPSZ5vT64BOAvYgrgKpHrBxUMHNLDCDsNfL6wHyuq4YbC+grdY3Yw5zw84EPdBXZroZHhalT6BRUbGOVqnkV05s03JURJfhLtCL/SZogww1I+c2KczJ6gmtkpySkrLXfg9Euk4a3WrpKABADvfsV2LL0cmJC0PnjKLRoCAI2uIVAXDR7g50YUnr67PQhiWSbpmT2OAhvhq9/P9V9wjIUBJDCSu+zCxbehRQ+5DT0hs9lei9OS0b7ZfXd17p2rztp7hWIIOMtqddBuZqsnnLy19NMiVKJhMHa8jU3deBtD85VDleG0xuTDgzVMwqchSAOoXngjYj/uwMQLaBoQy1kzoCY24xlxx8T1Y6UtCX75t/Fb9Rquou6iWdNEMJSamOxOLfODAqBqYymQLT3mUF785/O3Hf1jgOD6nQzuEYJap/PRJn9gbgwVUZHd+TQ3jADwqlgxj7TNooF9JupjOGBcxGPj0/nFo2XOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(5660300002)(38100700002)(54906003)(110136005)(26005)(9686003)(498600001)(55016003)(8936002)(316002)(2906002)(52536014)(71200400001)(186003)(82960400001)(38070700005)(86362001)(6506007)(66476007)(8676002)(66946007)(76116006)(4326008)(66446008)(66556008)(64756008)(7696005)(122000001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cndENHFERHgzU2Nyd0wwTCtPS0xrYzZFY3R6TUNUZUVCck9DMkpKVkt2cEVV?=
 =?utf-8?B?YUlMM3ExYmpQb1l2T1gxNHVXWGVEOU10M3lUSFB5RUJJMUVxM2xWOEtDbWVD?=
 =?utf-8?B?YXVEM2FxakF0Z1huWUtBY0h1akh4Z0F0c1g2ZjhaU1k3T2ZJOXdsb3NNOWg5?=
 =?utf-8?B?RjVFMHRBbkxrS0dWWWYvWTg5T0dJdmNqR25QdHZPMStnc1FxZVowRkRxWW44?=
 =?utf-8?B?di9Ha0VFZ1NndDJ2Q2ZiK0hQeHU1dGtFQWRqaWRmcW94VmxIR1lidXNQZEJk?=
 =?utf-8?B?VCttQ2doRjhKTmZPVk1qdzFaZzhkemFkdkQ1cm1VMDBaaVJPL2c0NXZFakJm?=
 =?utf-8?B?U1FybVNuUUtBNmVKcmk5MkZsem5vRG1YSFU2TzIxQ3U2UUZrZ2dyczNhaXds?=
 =?utf-8?B?NHEyVDMzNml2MUlCUlFKZko1c3pxMmVWMk0vRm16WjhlYThseTdCUkR4cUVs?=
 =?utf-8?B?R1ZJUWtMME1RZUFBanZPaHJMZTRpNlV3QndCT0Fxb1NKWDB0ZUt1Qkw0QWRI?=
 =?utf-8?B?cXEzRDEwcG1nbDBHdU8wSVNmNklkOUw0NmpYampCNllJM0IySm53WkVobnVE?=
 =?utf-8?B?SGVvYUtmSUIxQUtHYWdyZG1oWFVYNkk5enB0cmVveTc5SWdqbnBlYU5vZWNK?=
 =?utf-8?B?RUl5NEdMRTVGQ0FvaW02L1RQYmlPL05tTmFzbmFpcTRWZ204anczSEU4SG85?=
 =?utf-8?B?ZkJMRS96Um52dGxHdW5hUnVXNG94L0Q4eEVBWnBsaWZHRkkwclpvdFJMWC9Y?=
 =?utf-8?B?YzBqb0FlQXFXUFUzM3hINDJkamdvMmpLTjBtY3YyelEzMUc0OEhBTzVneWc5?=
 =?utf-8?B?ZTg1dEpJenZJZnRQTGVMVVFMMUsvVUtTNjduOGttdzdQN0gxa3dleXU3dThs?=
 =?utf-8?B?R3lNcml6cjdIaGgvRlQzWFgrV2Y5aG53bisvWFZYMXlVcXRWSXBSR2JtZ1do?=
 =?utf-8?B?Vi8xUzQ2SXF5L1FMbVF3L0VUMFR6MzVrczRlNVpDVTJlcG9NcDlKSWl6ZUlB?=
 =?utf-8?B?QmpOMHpld29KNHJzK0hDOVM2NnU0ZkxndTN1QkZJd3BIRFRlSEFYaHJjMm9V?=
 =?utf-8?B?Mll4VzdwaXpGWnBCdmlGVCtvREFDTHJscHVMeExGVjVMb1o4cjY5MGlmS0pZ?=
 =?utf-8?B?M1lIRklNQUFvai9JVEljYjA3bG5Dck54bmo0cGNFNi9EbEtlZHBKMDFteDRz?=
 =?utf-8?B?QkYycVhjQ20yZGdtd1FoZElDZUZLdkt0d3lOS3FRY2NqWnlEOEl5MHZpdzJ5?=
 =?utf-8?B?OUsyWTlPMnIzTmVUcktGcDhkeE1seW5IaDFOeXJkdVlXSlR4N2o4clQxNmU3?=
 =?utf-8?B?M2hXOFFCTStrdXVyd1dVM0p5NUlvSnBCaVFUMTNwV0xHWkQ1ckFrSkp0b2w2?=
 =?utf-8?B?RUVWa3c4YW00M3NpaUlMTHphcElKMGNoc1hqbW9MZzlNbXR5anFwYVZhekVE?=
 =?utf-8?B?Rit1SU11ZVZDR0w4OFpVWGtGdVBNb0phZUpIQ3p6cm50WnNHVFdVbXd0ZU9C?=
 =?utf-8?B?TWtESTdpcHB6a3VYVU1ocVlGWmF2Q20wRUNvbGVZMU5seVZjaU1zbGM2LzRR?=
 =?utf-8?B?MWNqYk5QcXJkS0VpUlZGVzJ1SkNmMTB1Z0l6cHp6djJRRld4RXpZNDFsRmh6?=
 =?utf-8?B?OGg5WnZPdDIyeldvdmdEdkVMVmI2WDArUk9EaVpCQ1hxZFFRMzZmY1VmMFRK?=
 =?utf-8?B?MjQ3VlpTNHdEVGVWdWR6NVVicVp5T0o0N2JNMDg3akFraU9JVU1DN0ZvQmtQ?=
 =?utf-8?B?R2p4OUY4NEdhQ1hlZVprRmk1dTNQRndKR0ZOKzJYSXRWbVVLckpRTjF0ckVE?=
 =?utf-8?B?a0NtM0hxamR3TzB2V1lzcUtGZllOQzA2eTBReHIyRzZEMlkvdmxPTnNYYmFp?=
 =?utf-8?B?VjhwbWlwdkEvSnRCN3pmTVZqODdEY1B2c0pyUGpDMHBwSXlGbFJUZHYxUUpz?=
 =?utf-8?B?aks5ajUvSmhHUFVrNjJyTUplbTdEN2ZrNUpsV2s0ZkkraG9UMzB0Ym1RN0w3?=
 =?utf-8?B?dkR6L3ZHNThXeldVQlhBS2dZS3pXMEZZTzFYQVZmMUcwdVJja0o2dWZKaHpF?=
 =?utf-8?B?czhlZHdvb1Q0NWh6V2gzS2cveURMdGVxN1c1QStEazV6dkN2SHVGazlnRlRx?=
 =?utf-8?B?b0RtSlI3a2ZUenVxSUttMDQ3b28waGw0VFBSL3NNMndDMmxQYUhzTTJvUTF2?=
 =?utf-8?B?UllZc0UxNHg3WXpyVzBubEdld3ZpMndVa2ZQODJ2L2RCYmplR2hsZVRzbWpU?=
 =?utf-8?B?aWExZzE2ZzZObWNBa0k5OGZyMkdQb0ViNE45UnJiR0RORnhHY0s5TEErTUtq?=
 =?utf-8?B?VDM2dndNaGZCSXkzNE1aMEJpVE9wYVhGQ2d5TkF2L2UxR0lSZ3VtQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a74fc93f-f5e7-4285-e91d-08da50167f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2022 04:04:37.8702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R7HIr4OX1PdqIEigRsulAYR1nv9i8M4BELX0sAdNRCdsmyWbRlxriK2rwUAYcV760O6BffSXzuCbdVSJA+pl9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6464
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBGcmlkYXksIEp1bmUgMTcsIDIwMjIgMTE6NTkg
QU0NCj4gDQo+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0
LmNvbT4NCj4gPiBTZW50OiBGcmlkYXksIEp1bmUgMTcsIDIwMjIgNzowMSBBTQ0KPiA+DQo+ID4g
VGhlIHdob2xlIG1pZ19vcHMgaGFuZGxpbmcgc2VlbXMgcmF0aGVyIGFkLWhvYyB0byBtZS4gIFdo
YXQgdGVsbHMgYQ0KPiA+IGRldmVsb3BlciB3aGVuIG1pZ19vcHMgY2FuIGJlIHNldD8gIENhbiB0
aGV5IGJlIHVuc2V0PyAgRG9lcyB0aGlzDQo+ID4gZW5hYmxlIGEgZGV2aWNlIGZlYXR1cmUgY2Fs
bG91dCB0byBkeW5hbWljYWxseSBlbmFibGUgbWlncmF0aW9uPyAgV2h5IGRvDQo+ID4gd2UgaW5p
dCB0aGUgZGV2aWNlIHdpdGggdmZpb19kZXZpY2Vfb3BzLCBidXQgdGhlbiBvcGVuIGNvZGUgcGVy
IGRyaXZlcg0KPiA+IHNldHRpbmcgdmZpb19taWdyYXRpb25fb3BzPw0KPiA+DQo+IA0KPiBBIHNp
bXBsZXIgZml4IGNvdWxkIGJlIHRyZWF0aW5nIGRldmljZS0+bWlncmF0aW9uX2ZsYWdzPT0wIGFz
IGluZGljYXRvcg0KPiBvZiBubyBzdXBwb3J0IG9mIG1pZ3JhdGlvbi4gdy9vIGFkZGl0aW9uYWwg
ZmxhZ3Mgb25seSBSVU5OSU5HIGFuZA0KPiBFUlJPUiBzdGF0ZXMgYXJlIHN1cHBvcnRlZCB3aGlj
aCBjYW5ub3Qgc3VwcG9ydCBtaWdyYXRpb24uIEZhaWxpbmcNCj4gdGhlIHJlbGF0ZWQgZGV2aWNl
IGZlYXR1cmUgb3BzIGluIHN1Y2ggY2FzZSBzb3VuZHMgY2xlYXJlciB0byBtZS4NCg0KQWN0dWFs
bHkgdGhpcyBjaGVjayBpcyBhbnl3YXkgcmVxdWlyZWQgZ2l2ZW4gdGhlIHVBUEkgcmVxdWlyZXMg
U1RPUF9DT1BZDQoqKm11c3QqKiBiZSBzdXBwb3J0ZWQ6DQoNCi8qDQogKiBJbmRpY2F0ZXMgdGhl
IGRldmljZSBjYW4gc3VwcG9ydCB0aGUgbWlncmF0aW9uIEFQSSB0aHJvdWdoDQogKiBWRklPX0RF
VklDRV9GRUFUVVJFX01JR19ERVZJQ0VfU1RBVEUuIElmIHRoaXMgR0VUIHN1Y2NlZWRzLCB0aGUg
UlVOTklORyBhbmQNCiAqIEVSUk9SIHN0YXRlcyBhcmUgYWx3YXlzIHN1cHBvcnRlZC4gU3VwcG9y
dCBmb3IgYWRkaXRpb25hbCBzdGF0ZXMgaXMNCiAqIGluZGljYXRlZCB2aWEgdGhlIGZsYWdzIGZp
ZWxkOyBhdCBsZWFzdCBWRklPX01JR1JBVElPTl9TVE9QX0NPUFkgbXVzdCBiZQ0KICogc2V0Lg0K
