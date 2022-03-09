Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6519D4D2EAE
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 13:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbiCIMH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 07:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiCIMHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 07:07:23 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A51E171EFE;
        Wed,  9 Mar 2022 04:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646827585; x=1678363585;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YlIanTl/7PkcPEWpTwRxIHPUUtUablUnyeDgZJE5l7M=;
  b=hJcd7b57z2BdNtIEhwZXC7mns0q8uMjwYgIlopkOuua+6WC7OXL/pfZr
   +5URNN2BLVhg2sAWFelTWGyMmHUnGev5YZD1ihhbLyntGbJsUc6pl7WcE
   pS+o/2997cez9E6NgoLcr8uUTDlptVn+rGQLR0OhoSWF+962TbPJ9Jmex
   YMAiWXSTWA8ymJVnG8Ou7arFEqGKcnUy7HTgTpM6s0HevGInvQsV/uzzk
   r/8aquyK2ZOP7qCww/Wb2DZUwAnvCj4aAnPpWocUAwS5RFQtndXwWUb11
   SlkqN9l95zoJO/+3a9g3y7jTwYOJIo+33X1Sb3ZQJRXA0z4sRZKH6HnMt
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="318186231"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="318186231"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 04:06:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="537983714"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 09 Mar 2022 04:06:24 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 04:06:23 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 04:06:23 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 9 Mar 2022 04:06:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 9 Mar 2022 04:06:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGKi6SdysHAZpP0TARSgNM++O2y3v+aW2AcjaRFkFk6PPPduEt1rNbARrJuEgMGRL4BBfuvudOu03ediHhmYfHxwpSO7mlBot7FxPdEIi4wYYAJPYA1nYPXgExdWMfzh8adDefBthwYtPxRwutw3mb9ct8lMREdfip0kYueQlJTan4ExBu3nS28qMS93j4XM031rpDmYJy/5H5Rs6Ym/Io6SDBlhKtFSdPx1kPmRfXZR5XS7fschmETpNjgY3sq8hKr/m6LHtT5UUkI7+6Jzt3VF3Fe42zETj9/8EonwKR7RgfUf4WmYaj62NZGjgn0RJPLvWUmOuLKzV88jGxiigQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlIanTl/7PkcPEWpTwRxIHPUUtUablUnyeDgZJE5l7M=;
 b=TX4P8P7QCUWmq48phkU3HF5wOhDbr3xp5FT+6diJE1Yov31zw7Rmr1iuKEmyTKPYyjYtURlGqYh4zulgqSJm//zsEnC8hZM77aJh3tam6DxPq6EoDEtG3NtFXLuC6Apm2S5R/L8IB4RsqBhXJVH0BvHnpvbTKZ4oLb+8YZ/YbnsMPFNhAepaDiV+ATxtFll62H79l6dBedxNm31qJqhzSGw9AaU1fmv9gOV6XvWQWLdYEwRgT2jvF5/mT3SObUfdH1gXPN9QxY3x0EtAgObH9OVqssesUQCbq6uyYVp61gsL8Ap/BrGXP1DyzMsnq8z6ZoH6N3N9aXVSVfBEUdpBrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3665.namprd11.prod.outlook.com (2603:10b6:408:91::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 12:06:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 12:06:21 +0000
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
Subject: RE: [PATCH v9 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v9 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYMx2bXU4zCWoi+UG2susOy+Fmwqy29Jbg
Date:   Wed, 9 Mar 2022 12:06:21 +0000
Message-ID: <BN9PR11MB5276B77B877A6A80A5B514688C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
 <20220308184902.2242-9-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20220308184902.2242-9-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8348ec7d-2a25-494c-9757-08da01c539de
x-ms-traffictypediagnostic: BN8PR11MB3665:EE_
x-microsoft-antispam-prvs: <BN8PR11MB3665C8B872A6CD81DAAC0B7B8C0A9@BN8PR11MB3665.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0PXbwIry8bgi0jsIHY7GdtIQDUNdD0M/qTH2KqI18DjsUUq/l4ZUljSl2oc2o8JbEfRdSEq99gx+jUc4EodpoCr7VPGbi6hNGP5U1ulGXvPtT/JCJPNo+4WBWf6JFhlBY7zqWP31yf/Q69UH/6O52nFrv1Aq7k3FG/DJISLt0XCBcDY8tUImT2rxj1VfnTMIW1mflCL3tjHi7xklwln+1N1AwOctMCCerD+pY3bw4RwAVXqL7AW7BVcedWmCRI9q7WqEq+MyPucOPQHzzrie7d5FY1ITsWq/j3mfaIZJgnMkPl3mdQn1m1ngBXZ7ZaYThRbzKU1vqQY+nnTkjWx4hBvhjqOrz6LTZWXzhLS2Fp7RESl+T0++y4qoAk1K7Isgq074rETrD3c3Sk181/q+j5sTO2NezVrD0pmgDY4xhzB7YXfeJzQFi66xZT0vOXIP0tLyGpeBkflcx0uykzcQzp9rXuVIe0W1jiu2QfGZG1ztbBubRR8TPVaAdu5ZGapSfzuyTj80pfiPibxgNZKZ/FGVWtnZqH0r/ZNSggFJTugPDlgQ3hyxdKyBnN7bEWUwt5l30m3cUEbR8Oaaq5AX2L+6uzDoPxSufOPis63tvNytUnMGXiPsNztb9ch1yTH2mI2enGMt4vORj598fOx+5pMj7L7f3ux+uDvJHbskgmMnLyqs73i+6rmEoLYg+pLJsEQpV1pjLLZcdffwxZeYiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(52536014)(33656002)(83380400001)(8936002)(7416002)(26005)(55016003)(508600001)(186003)(71200400001)(76116006)(54906003)(4326008)(66946007)(66476007)(66446008)(66556008)(86362001)(6506007)(7696005)(9686003)(2906002)(110136005)(8676002)(64756008)(122000001)(38100700002)(38070700005)(316002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXd1VHNlNUp3OTBWM1pnbGUvMEtkT3RpODVEUGlydmZVenkxU3Z2ODR6RzEv?=
 =?utf-8?B?S2JQbjgvNGk5QjRNaEhtM3pxdG5jOXpaMmFXVFpyKy9waVo2eEh6T3hDdERL?=
 =?utf-8?B?a3BoZlVaelRXK1dKSGRSVlplSmxCMzhNelM0TDNlRlpIQmQwcjV0SHBCUUZK?=
 =?utf-8?B?dVhCcHhQODR6d3psTzA3Y2t1VS9wbDdYdEFjd0RnbTlvdWhqZStGWmUvN1pB?=
 =?utf-8?B?OXBqTisxdzJaUVpkSWxSbUpOVHR5bE5mQkFFMjhrbWFYay9SVXI3aHFHWFN5?=
 =?utf-8?B?cUY0clMwdE5YMjFYeHFXNnQxeG5td2ZnRnRYOTVzaml0dE1SSEVkMDhSU3dB?=
 =?utf-8?B?cEFtVTN0dVJWQ3dkVklESHh2a0RBU01sclAyei9vbS94eGRwSmd4QjkzeXpQ?=
 =?utf-8?B?WE9ZYTdVV1Mrd1p5dDJQSjkrZ0ZmdFk0bGxZR1lla3drcHVtRGt6MjRUOXpy?=
 =?utf-8?B?ZGJaSk4vWEZqZHY3WGs2UGpPMHVnN2pIRkR6U3FUZ0xiZWQrTnBhMUhsd1Nu?=
 =?utf-8?B?VGoyYnl6RHZaQnhqZzM4NjlnS3VIcm9CVnQwUXV2Tkh6SHFiTVJrTllUSDFI?=
 =?utf-8?B?b0FSV0FnT29KWlp5V2dJTWVIMC95QXV1QkRXQVpXSmF4QlVrdUZ2SXRGMHcy?=
 =?utf-8?B?anBBTkZXMnNNUlZrWHJ1V3pGYXBjV1lUKzJCMFFIbEF1SXJnaUtDdDA2OUcr?=
 =?utf-8?B?ZjNadkpQaGdzZTMzc1dNZXlNMmVCczFkeVdLSld5UWplbmFRQUx5OHYvM3Nx?=
 =?utf-8?B?T0NQOUtWOXNKcTk5dFRLQWNiK0RLclIwc3F4Q0grL0ZSNS9ORWwzNWlPOXVI?=
 =?utf-8?B?OUZIdUxldVRsSHJ4YmZuYS83TnNyRHRpT1g3RktUYmxhb2JoTnkyT2ZLaDg3?=
 =?utf-8?B?VnhwSmtXNXhwd2xRZC9LQ2NsWTJXVzgrNkx5cGVWL2d0eUpMMXBYOUtSY2hK?=
 =?utf-8?B?ckxYZUw5WUVyZFN5SkgrQUJFS1o3c2RmYjhxLzRhK1A4WkpFaXp1NjVqVGJ1?=
 =?utf-8?B?bVFURkd1RjZRZkFZaFNsU1NqdkRxaVdVZE1XTC9JMy9RcnVVNWJUblZoSS9W?=
 =?utf-8?B?L3p2Znk5L1YvUDc3TXZIRFdjZzE3dlZHZElkdWlJRVVHOFFMU2VsaTdRUXFu?=
 =?utf-8?B?SVRQRXVaaGxzME5FcDJqOFBGYjZ5REdRRVcxRk9rOWJreHVuQXVDK2RYRjd6?=
 =?utf-8?B?YVZUTjM1VmUvOThzdm56TzVtN0x3bUZiaWh4MWh3N3BDTEdxMXBYZGs3NlVx?=
 =?utf-8?B?cUNjOStoTUJmNUpwTTExQ09saUp0dEFycjdHcXY0dW5ycXhaMHFYTS9Qc1Z2?=
 =?utf-8?B?NDRwNnVNUlFxOHYveGZnSHN0QjdpSlNlTmIxVWtCTDJMa1VrZm5oakZvaW5m?=
 =?utf-8?B?Tmlqc1pNempKbnNaRkJseDhiWm5IQ1J6aEgrQ21zTUZEMGNTeHdwREd2ZmJZ?=
 =?utf-8?B?U1duRzFhd2hZdEFtaUZINWhoSStVZExMZ05sR0Z4Qnpta3d2dVVMRFdQZzd4?=
 =?utf-8?B?MWZZS2t5REV0a3REZGpLazl3ZENEVjRTRm5oZXpyT3RPQ2l3cG9kZDByRUJ2?=
 =?utf-8?B?VHZiNDUvREQzSXVOYlZjeER4RUFPaXRldnNsem14My9EZGJRcjdlTEdsdmRZ?=
 =?utf-8?B?V2lIdE4vZ0hTcHIrNWFXcGJGUGV2K3EwVGhUaWJzWTJnR2l3aXN4SlArcjI4?=
 =?utf-8?B?ZHpZY3orR2tOU2dxd2w2a09EcFJWUDV4V0QzQ21BUXJSRXZtKzdUZDlOYzN2?=
 =?utf-8?B?Y1ZOekJ1R0lldEJXNXVGNHhxWWpWZStTdDhwaWZwTm9YZXNRQjJ3eW5lOGQ1?=
 =?utf-8?B?cENLWFJHK2svcHdJSUtBdk5qV3VsaGc3ZkFCdSt6RlFtNno4bWhPemtqMUpp?=
 =?utf-8?B?WU1lNUMwZW9BbUtMdzJ3eG1MZXBWaTQrNm9YRWlUZzNpYUlTZEVHTGg5WGJy?=
 =?utf-8?Q?yjZR1b314rqOx13z8xf9weQYe9sanNm6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8348ec7d-2a25-494c-9757-08da01c539de
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 12:06:21.6639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sa9YaUHtw+LtlcihmGH5DfyyHcUHNgdwvPcWGaOKG+0rFR/NiwLqaWnQAt9lQ3qMsNjLjCjuCFEKx/XiN0aHkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3665
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyIEtvbG90aHVtIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdl
aS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggOSwgMjAyMiAyOjQ5IEFNDQo+IA0KPiBG
cm9tOiBMb25nZmFuZyBMaXUgPGxpdWxvbmdmYW5nQGh1YXdlaS5jb20+DQo+IA0KPiBWTXMgYXNz
aWduZWQgd2l0aCBIaVNpbGljb24gQUNDIFZGIGRldmljZXMgY2FuIG5vdyBwZXJmb3JtIGxpdmUg
bWlncmF0aW9uDQo+IGlmIHRoZSBWRiBkZXZpY2VzIGFyZSBiaW5kIHRvIHRoZSBoaXNpX2FjY192
ZmlvX3BjaSBkcml2ZXIuDQo+IA0KPiBKdXN0IGxpa2UgQUNDIFBGL1ZGIGRyaXZlcnMgdGhpcyBW
RklPIGRyaXZlciBhbHNvIG1ha2UgdXNlIG9mIHRoZSBIaVNpbGljb24NCj4gUU0gaW50ZXJmYWNl
LsKgUU0gc3RhbmRzIGZvciBRdWV1ZSBNYW5hZ2VtZW50IHdoaWNoIGlzIGEgZ2VuZXJpYyBJUCB1
c2VkDQo+IGJ5DQo+IEFDQyBkZXZpY2VzLiBJdCBwcm92aWRlcyBhIGdlbmVyaWMgUENJZSBpbnRl
cmZhY2UgZm9yIHRoZSBDUFUgYW5kIHRoZSBBQ0MNCj4gZGV2aWNlcyB0byBzaGFyZSBhIGdyb3Vw
IG9mIHF1ZXVlcy4NCj4gDQo+IFFNIGludGVncmF0ZWQgaW50byBhbiBhY2NlbGVyYXRvciBwcm92
aWRlcyBxdWV1ZSBtYW5hZ2VtZW50IHNlcnZpY2UuDQo+IFF1ZXVlcyBjYW4gYmUgYXNzaWduZWQg
dG8gUEYgYW5kIFZGcywgYW5kIHF1ZXVlcyBjYW4gYmUgY29udHJvbGxlZCBieQ0KPiB1bmlmaWVk
IG1haWxib3hlcyBhbmQgZG9vcmJlbGxzLg0KPiANCj4gVGhlIFFNIGRyaXZlciAoZHJpdmVycy9j
cnlwdG8vaGlzaWxpY29uL3FtLmMpIHByb3ZpZGVzIGdlbmVyaWMNCj4gaW50ZXJmYWNlcyB0byBB
Q0MgZHJpdmVycyB0byBtYW5hZ2UgdGhlIFFNLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTG9uZ2Zh
bmcgTGl1IDxsaXVsb25nZmFuZ0BodWF3ZWkuY29tPg0KPiBSZXZpZXdlZC1ieTogSmFzb24gR3Vu
dGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2hhbWVlciBLb2xvdGh1
bSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KDQpFeGNlcHQgdGhlIHN0
dWZmIGJlZm9yZSBoaXNpX2FjY192Zl9kaXNhYmxlX2ZkKCkgd2hpY2ggaXMgdmVyeSBRTSBzcGVj
aWZpYzoNCg0KCVJldmlld2VkLWJ5OiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4N
Cg0KVGhhbmtzDQpLZXZpbg0K
