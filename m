Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340446CB506
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 05:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjC1DpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 23:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjC1DpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 23:45:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB235171F;
        Mon, 27 Mar 2023 20:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679975104; x=1711511104;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PmDFl1ZkOIi4Kr02WO70ndAACSSRwylE4YVoU9CkaVc=;
  b=JpXsRwAPR1lJg0S76KWvyCFR2TO4pmfbGMt/2o92KS+YXtlu3rzGBu0s
   B5X393pPDvSgdTeu5wE7DpGQaAaNWUITbn+fwa5JFeXjvD6sE+4M1KENP
   AkNR+kh/xQOK/Nrse780Eg4AUFClXmUkGolicRAQiB4r0XTa31LodbWNB
   0rVJ2lcRg7lBH09GcH2br0+my+iYs+wXZ99Kv/IBnZk55VnGxAld+HBwc
   st003dDywTW1dbvypDOpLTjaxeupA8bkivVVpPGq6SbX7/cL7sYTR+opa
   MJ4ZNKvCoRHtM/0afQ8UGZJs1QfnBTS9zuEP7EnYn10SQswV34Rq8uQYr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="320114412"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="320114412"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 20:45:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="686228351"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="686228351"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2023 20:45:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 20:45:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 20:45:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 20:45:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAINnkHeiLXCeJB3b6NGrkZBSuoks8S/iBKhhNjZq25ckMQmfzDlvzALWNrrPMytbZns5Vh9i2Kx84QKZcCJuEwJULc50FUPe8lfhyrUyfqBbNNZ5w2NmdMBOdK1QXGrJh4FBWB6TwW6rwDY+mBeVCT+v83GUJUp5j29IQ3VwuquuqSYA1gMvmCrEN3kipK4rflESJhR+nsMY1Gn1N9wH8ID/2xo6oWHgCmUld2DL1tMNj/32iPUr4FokJ5bb7vFHkNRNlnJ9u5YaFbu5D+maO0hbKR+NMjMFSQrCIQ2npDhRiGSszjKlx5jd0eeqnX6rVRS8BAW7rHjqtAexifIWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmDFl1ZkOIi4Kr02WO70ndAACSSRwylE4YVoU9CkaVc=;
 b=FtTejBPKJlT2G466dV1VEf6vva0TWmpV20JLrAdt8Yb/r8VCpSYTUHjwea0A+qu8rSSQ7DwTgOdAo3UY8dochPBNj3xovS6UZrSm80tK6nLpdyjhDLKbXsHT/36hBzHXVfaJsTh6lIXjrl7TnLYNueueKuw+Kc0J3q8ZZ5/wJfbSKj7hOe45IwvEpwIzFBZ9+0mloxR4c9z1mKL3y+qyMZPTkGuFbwZ7DsE5ANF8KRkfJe6W4ILwcw48WRYAxXh31/P8jgFxXGOSnejRh211+lAVwwk2nDQQK8F4+p8ZDq9vzdjbHC0T/PDFfIhYHc/M8wr033+d1sANFvBectkdsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6893.namprd11.prod.outlook.com (2603:10b6:806:2b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Tue, 28 Mar
 2023 03:45:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 03:45:00 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92Dc+A7iEOnEaMeK3O2ipWfK8PAuSAgAAU2QCAAHLuMA==
Date:   Tue, 28 Mar 2023 03:45:00 +0000
Message-ID: <DS0PR11MB752966CC1CE8F50D9F3B147BC3889@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
 <20230327144056.3a287eea.alex.williamson@redhat.com>
In-Reply-To: <20230327144056.3a287eea.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB6893:EE_
x-ms-office365-filtering-correlation-id: 8ce0fb7b-c636-4658-5c2f-08db2f3ece8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xyF9e6Z9y04RLwQSjje9OZK0V2L/MaO2jwI7O4S7weJw/L2s7rNThsVGRl20VgYBLdpAZt1MvyomhTegwiuwZEW7uBKgJUOEAp4nAT5VFR8OR8cO1p6cOhz8vjnyRF3mzsuJz0XRy5X6odvm92DeKJW7EQeRU3v29eDGN23rYjcWdb4wbVybYyFr+LrHAA2AyS5NPsCu+1nwyiaKHJTBhsbbhkOONQC/QjOytnVwzBTDWiFjd+/K9AEdAUbllNQzLh1zlTcZCM7YHXX8pcmd7R2njZ+qacCKCzeSSIrCmwseDolzsvmsvbkxs8J9VFBO0xCDbzyqkDuUTPCs3izkHYGNIZ+6mNgenceUglZXW5JbQKGfbUtGBQraYJs5c818VF3Av6PI21pc6gJiX2RtqPOInxUYF7c+VVEGw5IE+z1St+1DxA/GczSjuBaqP+gnTSj3UpNwgyDODddQ5h/NZqEnDYZlj2qYFKeK/TjHM60rsat9cBI66IkNzG4WyPiG8H+/pwaqL32Y8HMz/rIox7BDYNZuSnCLGdQYn7ML4wWlv0JNp+i5tM0Ll44CAxNZPIsyptC5wu0YC6ya95OVVY2LXclKEjBH5a84jWg6ZrcsMIVL53BHQ7HZdWDkRC+HjoqR2vQMUsE+WuOtRGs2kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199021)(66946007)(66556008)(66476007)(66446008)(64756008)(122000001)(4326008)(8676002)(76116006)(6916009)(5660300002)(54906003)(316002)(6506007)(8936002)(82960400001)(7416002)(41300700001)(26005)(52536014)(478600001)(186003)(9686003)(7696005)(83380400001)(71200400001)(38070700005)(33656002)(86362001)(2906002)(38100700002)(55016003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnFPQkcvelpSamtqZ2U4TWZoRDk4Y3YrNUtLU2d3VXRvL2hEVHpvL0ZGS01V?=
 =?utf-8?B?OHcxbFFVTDE2WUhtWHNpVlRCdkRxTDZxa3g0UXIyYjJ4cG1IVWdsZTJRdlpp?=
 =?utf-8?B?ME9vUDUvOVZDZkNPcmhwRjRqWEtPallPK05QOFNFVzBPTkFhQU9JSWlrUk9v?=
 =?utf-8?B?anllYkJZbXFlS2d3S2JTamNseVFITUVPRHkyRmdwcmw5bVh2a0wwNjJUeGVB?=
 =?utf-8?B?NGcwQ1ZWZnRZTzBCSXFJUzlKSjc4U0xMT2VHVWN6eW00NHY3NC92aHA3Zkh2?=
 =?utf-8?B?dVRrUzNuc2tyNXpEcTdYbWk5NDRteWtMZnZQNXBKSTlrWVBVamQ5Wm5BcTR1?=
 =?utf-8?B?VEYyRERPckIrZnVjWUxyMWtiWjVweEdrem5oZUZoSVYrdGdyMGlVSnBUTzVm?=
 =?utf-8?B?cXpEYndvejRjcndqS3RXL3M1TlhTeE5FME5tVTg4YzUvcE8zVW5WdjFhQTFz?=
 =?utf-8?B?M1A0T3JWMHZQMzVCcHVlYjA2cFh5UG5TR1lVeUlvc0dGUXlBcEkydkN0Uzdi?=
 =?utf-8?B?bGpDZGJTejlOY2lCYmhra1lPVHNBQW43MW11UmpsUVZ2VEJRZ09MTHZxVnF2?=
 =?utf-8?B?T05DZGxKd2NMRVMyREhUdnh5dklsVTFDdzJXL2taKzlGM1FvNW0xQ09kSnRP?=
 =?utf-8?B?eExwcTdkd0g3cnROK2VjZ1pnMTBHdFh2Q3FicWlHMGZTYU0yN01UUDdaMDkz?=
 =?utf-8?B?RndWSTBqc3J2bUhHQlYzZDQvSUNrellIQWNFdXc5dXR2R2dEWURaQTdSYjgy?=
 =?utf-8?B?K0w0WVIyVERrSjh3OUFMZERXcldnUzJCYmdYRWhZcE41dFVMZmVDRXpGSkdZ?=
 =?utf-8?B?cXVZbzBITWtxZHkxWUdEM205bUVxQ2N6RGtxL2VaVldoTU5VNHk3QXNCc3JW?=
 =?utf-8?B?amhpeEI1alhVVmlmZFRTVGVqVm9mc2o2NU0zWkxPNEVyS3k3eUxBaE1SMUVT?=
 =?utf-8?B?cXR0K1gzUExjSDlRRmVCcUNsZzJsZzJxNWVYd00venNiUkVMWmM2MDBkaTNk?=
 =?utf-8?B?OWoxRzNoelBWd3FWaGdKcVFyV1FaYVlybXQrdzE0WVNLR2ZlRUo4ZlRqejY0?=
 =?utf-8?B?WkZ0aXd5RjNRdEJ1WWUwbTlZbGNpSVk3YVkvY1FMMkp2SXdOOGpNMXpONjY5?=
 =?utf-8?B?Nmh3RitPUW5vQURYd1VPeVZLS3Q3ZCtaSVE1NDVJemRmK2J6akd3RGl2QnZY?=
 =?utf-8?B?OWdWMmhLU1loZXNNT2pJTGYyTGl6VEhTSWhubjVBc05ISnp0YVFvRWtZS1pO?=
 =?utf-8?B?dUFsWm95anB0MXk2WHo0cWhuaXczcFNOalN5SGFPODdCd0tsd0NaSEhTdmh5?=
 =?utf-8?B?Zkd2aFJBT3FhTmZUZTI2dlBzWDRXaGFNNUsyK3BmdkR6UWlHUVdNTEs1Vy9h?=
 =?utf-8?B?eC9XenJGclBZNE1Xa2xJeHg5a3UyaFJ1cnNPcU5qQmdGdzIwZXlhSmxmOWNz?=
 =?utf-8?B?Uk5ZNGpCb1RnTnJHYmY3dmRwR2RBMGxJS1cvOUg2OUNxMUFLV01vcXhUK3Jt?=
 =?utf-8?B?R2c4Syt1dUNBOG9iVzN0aEtzT1ZscTBGN3lmbmVpOUZIMlFWYy8wMExwWVpU?=
 =?utf-8?B?U1ZFajNXTVFVeTZCd3pheXUwUFZ1T2FOVGtSZk9kWjdCUGUvZGNJSnRBaCty?=
 =?utf-8?B?ZlBGRUR6MW1WOXdWbklrUU81U2J5T2IwVjByUjV0SE1SMi92Vko3QWJlOCtP?=
 =?utf-8?B?TWMzRjZuNmgyRWFsRm9TbEFVYjF4Q3Y4SUpwVFBDUkJiL1Awb3hLKzNtYjlH?=
 =?utf-8?B?aEFXR2Y0N2sva1Y0K0RsNU9IcWpZNFB4YUZvNDlmaytqM3hSSkJJV2laV0Nl?=
 =?utf-8?B?Wm4rVFAvTHl5SHg2SkRtaXV0dWhYdHdiVmhOSVZWNlpjM015RDBHWStWN0Yv?=
 =?utf-8?B?Q2lML2RscnlyMnB3UWZ0cWtKYWh2alpnakFhNmxHc0RrTnlkbWFsRzBYeVB5?=
 =?utf-8?B?RTZQbHAzb3BJa29EeFdia3BENU0zTzZQYXpOcVMvL2ZpT0xZRXJvN1FFN29k?=
 =?utf-8?B?VU5uOWY0UmN6Tk12M0daNDBUdWpPVENmM2kwendaRU5Cekt3SHBQMCtqQm81?=
 =?utf-8?B?blV2ZzFYNExDSHhFZDRhRHp1MDlJQ2FpcWtiZktFd3c3ci9ORU1JNGpiRndM?=
 =?utf-8?Q?OjedQ+sBg99iU5XLDmeaEnCs9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce0fb7b-c636-4658-5c2f-08db2f3ece8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 03:45:00.2411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nh1EO0t8hl5aa7od4Tx24Ifwu8vMceXRaVLIWRL25d4WjUMSomO0At8z8JE5niwm0XGF0QooAv7Wq9X1wBsTSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6893
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBNYXJjaCAyOCwgMjAyMyA0OjQxIEFNDQo+IA0KPiBPbiBNb24sIDI3IE1h
ciAyMDIzIDEzOjI2OjE5IC0wNjAwDQo+IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29u
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANClsuLi5dDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNp
X2NvcmUuYw0KPiA+ID4gaW5kZXggMTlmNWIwNzVkNzBhLi40NWVkZjRlOWI5OGIgMTAwNjQ0DQo+
ID4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYw0KPiA+ID4gKysrIGIv
ZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gPiA+IEBAIC0xMTgxLDYgKzExODEs
MTAyIEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfaW9jdGxfcmVzZXQoc3RydWN0DQo+IHZmaW9fcGNp
X2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+ID4gIAlyZXR1cm4gcmV0Ow0KPiA+ID4gIH0NCj4gPiA+
DQo+ID4gPiArc3RhdGljIHN0cnVjdCBwY2lfZGV2ICoNCj4gPiA+ICt2ZmlvX3BjaV9kZXZfc2V0
X3Jlc2V0dGFibGUoc3RydWN0IHZmaW9fZGV2aWNlX3NldCAqZGV2X3NldCk7DQo+ID4gPiArDQo+
ID4gPiArc3RhdGljIGludCB2ZmlvX3BjaV9pb2N0bF9nZXRfcGNpX2hvdF9yZXNldF9ncm91cF9p
bmZvKA0KPiA+ID4gKwlzdHJ1Y3QgdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYsDQo+ID4gPiAr
CXN0cnVjdCB2ZmlvX3BjaV9ob3RfcmVzZXRfZ3JvdXBfaW5mbyBfX3VzZXIgKmFyZykNCj4gPiA+
ICt7DQo+ID4gPiArCXVuc2lnbmVkIGxvbmcgbWluc3ogPQ0KPiA+ID4gKwkJb2Zmc2V0b2ZlbmQo
c3RydWN0IHZmaW9fcGNpX2hvdF9yZXNldF9ncm91cF9pbmZvLCBjb3VudCk7DQo+ID4gPiArCXN0
cnVjdCB2ZmlvX3BjaV9ob3RfcmVzZXRfZ3JvdXBfaW5mbyBoZHI7DQo+ID4gPiArCXN0cnVjdCBp
b21tdWZkX2N0eCAqaW9tbXVmZCwgKmN1cl9pb21tdWZkOw0KPiA+ID4gKwl1MzIgY291bnQgPSAw
LCBpbmRleCA9IDAsICpkZXZpY2VzID0gTlVMTDsNCj4gPiA+ICsJc3RydWN0IHZmaW9fcGNpX2Nv
cmVfZGV2aWNlICpjdXI7DQo+ID4gPiArCWJvb2wgc2xvdCA9IGZhbHNlOw0KPiA+ID4gKwlpbnQg
cmV0ID0gMDsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKGNvcHlfZnJvbV91c2VyKCZoZHIsIGFyZywg
bWluc3opKQ0KPiA+ID4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4gPiArDQo+ID4gPiArCWlmICho
ZHIuYXJnc3ogPCBtaW5zeikNCj4gPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ID4gKw0KPiA+
ID4gKwloZHIuZmxhZ3MgPSAwOw0KPiA+ID4gKw0KPiA+ID4gKwkvKiBDYW4gd2UgZG8gYSBzbG90
IG9yIGJ1cyByZXNldCBvciBuZWl0aGVyPyAqLw0KPiA+ID4gKwlpZiAoIXBjaV9wcm9iZV9yZXNl
dF9zbG90KHZkZXYtPnBkZXYtPnNsb3QpKQ0KPiA+ID4gKwkJc2xvdCA9IHRydWU7DQo+ID4gPiAr
CWVsc2UgaWYgKHBjaV9wcm9iZV9yZXNldF9idXModmRldi0+cGRldi0+YnVzKSkNCj4gPiA+ICsJ
CXJldHVybiAtRU5PREVWOw0KPiA+ID4gKw0KPiA+ID4gKwltdXRleF9sb2NrKCZ2ZGV2LT52ZGV2
LmRldl9zZXQtPmxvY2spOw0KPiA+ID4gKwlpZiAoIXZmaW9fcGNpX2Rldl9zZXRfcmVzZXR0YWJs
ZSh2ZGV2LT52ZGV2LmRldl9zZXQpKSB7DQoNClsxXQ0KDQo+ID4gPiArCQlyZXQgPSAtRVBFUk07
DQo+ID4gPiArCQlnb3RvIG91dF91bmxvY2s7DQo+ID4gPiArCX0NCj4gPiA+ICsNCj4gPiA+ICsJ
aW9tbXVmZCA9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9pY3R4KCZ2ZGV2LT52ZGV2KTsNCj4gPiA+
ICsJaWYgKCFpb21tdWZkKSB7DQo+ID4gPiArCQlyZXQgPSAtRVBFUk07DQo+ID4gPiArCQlnb3Rv
IG91dF91bmxvY2s7DQo+ID4gPiArCX0NCj4gPiA+ICsNCj4gPiA+ICsJLyogSG93IG1hbnkgZGV2
aWNlcyBhcmUgYWZmZWN0ZWQ/ICovDQo+ID4gPiArCXJldCA9IHZmaW9fcGNpX2Zvcl9lYWNoX3Ns
b3Rfb3JfYnVzKHZkZXYtPnBkZXYsDQo+IHZmaW9fcGNpX2NvdW50X2RldnMsDQo+ID4gPiArCQkJ
CQkgICAgJmNvdW50LCBzbG90KTsNCj4gPiA+ICsJaWYgKHJldCkNCj4gPiA+ICsJCWdvdG8gb3V0
X3VubG9jazsNCj4gPiA+ICsNCj4gPiA+ICsJV0FSTl9PTighY291bnQpOyAvKiBTaG91bGQgYWx3
YXlzIGJlIGF0IGxlYXN0IG9uZSAqLw0KPiA+ID4gKw0KPiA+ID4gKwkvKg0KPiA+ID4gKwkgKiBJ
ZiB0aGVyZSdzIGVub3VnaCBzcGFjZSwgZmlsbCBpdCBub3csIG90aGVyd2lzZSByZXR1cm4gLUVO
T1NQQyBhbmQNCj4gPiA+ICsJICogdGhlIG51bWJlciBvZiBkZXZpY2VzIGFmZmVjdGVkLg0KPiA+
ID4gKwkgKi8NCj4gPiA+ICsJaWYgKGhkci5hcmdzeiA8IHNpemVvZihoZHIpICsgKGNvdW50ICog
c2l6ZW9mKCpkZXZpY2VzKSkpIHsNCj4gPiA+ICsJCXJldCA9IC1FTk9TUEM7DQo+ID4gPiArCQlo
ZHIuY291bnQgPSBjb3VudDsNCj4gPiA+ICsJCWdvdG8gcmVzZXRfaW5mb19leGl0Ow0KPiA+ID4g
Kwl9DQo+ID4gPiArDQo+ID4gPiArCWRldmljZXMgPSBrY2FsbG9jKGNvdW50LCBzaXplb2YoKmRl
dmljZXMpLCBHRlBfS0VSTkVMKTsNCj4gPiA+ICsJaWYgKCFkZXZpY2VzKSB7DQo+ID4gPiArCQly
ZXQgPSAtRU5PTUVNOw0KPiA+ID4gKwkJZ290byByZXNldF9pbmZvX2V4aXQ7DQo+ID4gPiArCX0N
Cj4gPiA+ICsNCj4gPiA+ICsJbGlzdF9mb3JfZWFjaF9lbnRyeShjdXIsICZ2ZGV2LT52ZGV2LmRl
dl9zZXQtPmRldmljZV9saXN0LA0KPiB2ZGV2LmRldl9zZXRfbGlzdCkgew0KPiA+ID4gKwkJY3Vy
X2lvbW11ZmQgPSB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfaWN0eCgmY3VyLT52ZGV2KTsNCj4gPiA+
ICsJCWlmIChjdXItPnZkZXYub3Blbl9jb3VudCkgew0KPiA+ID4gKwkJCWlmIChjdXJfaW9tbXVm
ZCAhPSBpb21tdWZkKSB7DQo+ID4gPiArCQkJCXJldCA9IC1FUEVSTTsNCj4gPiA+ICsJCQkJYnJl
YWs7DQo+ID4gPiArCQkJfQ0KPiA+ID4gKwkJCXJldCA9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9k
ZXZpZCgmY3VyLT52ZGV2LA0KPiAmZGV2aWNlc1tpbmRleF0pOw0KPiA+ID4gKwkJCWlmIChyZXQp
DQo+ID4gPiArCQkJCWJyZWFrOw0KPiA+ID4gKwkJCWluZGV4Kys7DQo+ID4gPiArCQl9DQo+ID4g
PiArCX0NCj4gDQo+IFRoaXMgYWxzbyBtYWtlcyB1c2Ugb2YgdmZpb19wY2lfZm9yX2VhY2hfc2xv
dF9vcl9idXMoKSB0byBpdGVyYXRlDQo+IGFmZmVjdGVkIGRldmljZXMsIGJ1dCB0aGVuIHN0aWxs
IGFzc3VtZXMgdGhvc2UgYWZmZWN0ZWQgZGV2aWNlcyBhcmUNCj4gbmVjZXNzYXJpbHkgcmVwcmVz
ZW50ZWQgaW4gdGhlIGRldl9zZXQuICBGb3IgZXhhbXBsZSwgYSB0d28tZnVuY3Rpb24NCj4gZGV2
aWNlIHdpdGggQUNTIGlzb2xhdGlvbiBjYW4gaGF2ZSBmdW5jdGlvbiAwIGJvdW5kIHRvIHZmaW8g
YW5kDQo+IGZ1bmN0aW9uIDEgYm91bmQgdG8gYSBuYXRpdmUgaG9zdCBkcml2ZXIuICBUaGUgYWJv
dmUgY29kZSByZXF1aXJlcyB0aGUNCj4gdXNlciB0byBwYXNzIGEgYnVmZmVyIGxhcmdlIGVub3Vn
aCBmb3IgYm90aCBmdW5jdGlvbnMsIGJ1dCBvbmx5DQo+IGZ1bmN0aW9uIDAgaXMgcGFydCBvZiB0
aGUgZGV2X3NldCwgc28gZnVuY3Rpb24gMSBpcyBub3QgcmVwb3J0ZWQgYXMNCj4gYWZmZWN0ZWQs
IG5vciBkb2VzIGl0IGdlbmVyYXRlIGFuIGVycm9yLg0KDQpUaGUgdmZpb19wY2lfZGV2X3NldF9y
ZXNldHRhYmxlKCkgaXMgdXNlZCBhdCBbMV0gdG8gY2hlY2sgaWYgYWxsIHRoZSBhZmZlY3RlZA0K
ZGV2aWNlcyBhcmUgaW4gdGhlIGRldl9zZXQuIElmIG5vdCwgdGhlbiBpdCBmYWlscyBhdCB0aGUg
Zmlyc3QgcGxhY2UuIFNvIGluIHRoZQ0KZm9sbG93aW5nIGNvZGUsIGxvb3BpbmcgdGhlIGRldmlj
ZXMgaW4gdGhlIGRldl9zZXQgaXMgZXF1aXZhbGVudCB0byBsb29waW5nDQpkZXZpY2VzIHdpdGgg
dmZpb19wY2lfZm9yX2VhY2hfc2xvdF9vcl9idXMoKS4gSSBuZWVkIHRvIGxvb3AgZGV2X3NldCBh
cw0KZGV2X3NldCBoYXMgdGhlIHZmaW9fZGV2aWNlIHdoaWNoIGlzIG1vcmUgY29udmVuaWVudCB0
byBnZXQgZGV2X2lkLg0KDQo+IA0KPiBJdCBsb29rcyBsaWtlIHdlIGFsc28gZmFpbCB0byBzZXQg
aGRyLmNvdW50IGV4Y2VwdCBpbiB0aGUgZXJyb3IgcGF0aA0KPiBhYm92ZSwgc28gdGhlIGJlbG93
IGNvcHlfdG9fdXNlcigpIGNvcGllcyBhIHVzZXIgc3BlY2lmaWVkIHJhbmdlIGJleW9uZA0KPiB0
aGUgZW5kIHRoZSBhbGxvY2F0ZWQgZGV2aWNlcyBidWZmZXIgb3V0IHRvIHVzZXJzcGFjZSEgIFRo
YW5rcywNCg0KT29wcywgeWVzLCBpdCBpcy4gTXkgdGVzdCBvbmx5IGhhcyBvbmUgZGV2aWNlIGFm
ZmVjdGVkLCBzbyBpdCBkb2VzIG5vdCBoaXQNCnRoZSBwcm9ibGVtLiDimLkgDQoNClRoYW5rcywN
CllpIExpdQ0KDQo+IEFsZXgNCj4gDQo+ID4gPiArDQo+ID4gPiArcmVzZXRfaW5mb19leGl0Og0K
PiA+ID4gKwlpZiAoY29weV90b191c2VyKGFyZywgJmhkciwgbWluc3opKQ0KPiA+ID4gKwkJcmV0
ID0gLUVGQVVMVDsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKCFyZXQpIHsNCj4gPiA+ICsJCWlmIChj
b3B5X3RvX3VzZXIoJmFyZy0+ZGV2aWNlcywgZGV2aWNlcywNCj4gPiA+ICsJCQkJIGhkci5jb3Vu
dCAqIHNpemVvZigqZGV2aWNlcykpKQ0KPiA+ID4gKwkJCXJldCA9IC1FRkFVTFQ7DQo+ID4gPiAr
CX0NCj4gPiA+ICsNCj4gPiA+ICsJa2ZyZWUoZGV2aWNlcyk7DQo+ID4gPiArb3V0X3VubG9jazoN
Cj4gPiA+ICsJbXV0ZXhfdW5sb2NrKCZ2ZGV2LT52ZGV2LmRldl9zZXQtPmxvY2spOw0KPiA+ID4g
KwlyZXR1cm4gcmV0Ow0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+ICBzdGF0aWMgaW50IHZmaW9f
cGNpX2lvY3RsX2dldF9wY2lfaG90X3Jlc2V0X2luZm8oDQo+ID4gPiAgCXN0cnVjdCB2ZmlvX3Bj
aV9jb3JlX2RldmljZSAqdmRldiwNCj4gPiA+ICAJc3RydWN0IHZmaW9fcGNpX2hvdF9yZXNldF9p
bmZvIF9fdXNlciAqYXJnKQ0KPiA+ID4gQEAgLTE0MDQsNiArMTUwMCw4IEBAIGxvbmcgdmZpb19w
Y2lfY29yZV9pb2N0bChzdHJ1Y3QgdmZpb19kZXZpY2UNCj4gKmNvcmVfdmRldiwgdW5zaWduZWQg
aW50IGNtZCwNCj4gPiA+ICAJCXJldHVybiB2ZmlvX3BjaV9pb2N0bF9nZXRfaXJxX2luZm8odmRl
diwgdWFyZyk7DQo+ID4gPiAgCWNhc2UgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRfSU5G
TzoNCj4gPiA+ICAJCXJldHVybiB2ZmlvX3BjaV9pb2N0bF9nZXRfcGNpX2hvdF9yZXNldF9pbmZv
KHZkZXYsIHVhcmcpOw0KPiA+ID4gKwljYXNlIFZGSU9fREVWSUNFX0dFVF9QQ0lfSE9UX1JFU0VU
X0dST1VQX0lORk86DQo+ID4gPiArCQlyZXR1cm4gdmZpb19wY2lfaW9jdGxfZ2V0X3BjaV9ob3Rf
cmVzZXRfZ3JvdXBfaW5mbyh2ZGV2LA0KPiB1YXJnKTsNCj4gPiA+ICAJY2FzZSBWRklPX0RFVklD
RV9HRVRfUkVHSU9OX0lORk86DQo+ID4gPiAgCQlyZXR1cm4gdmZpb19wY2lfaW9jdGxfZ2V0X3Jl
Z2lvbl9pbmZvKHZkZXYsIHVhcmcpOw0KPiA+ID4gIAljYXNlIFZGSU9fREVWSUNFX0lPRVZFTlRG
RDoNCj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oIGIvaW5jbHVk
ZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+ID4gaW5kZXggMjU0MzJlZjIxM2VlLi42MWI4MDFkZmQ0
MGIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oDQo+ID4gPiAr
KysgYi9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oDQo+ID4gPiBAQCAtNjY5LDYgKzY2OSw1MyBA
QCBzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0X2luZm8gew0KPiA+ID4NCj4gPiA+ICAjZGVmaW5l
IFZGSU9fREVWSUNFX0dFVF9QQ0lfSE9UX1JFU0VUX0lORk8JX0lPKFZGSU9fVFlQRSwNCj4gVkZJ
T19CQVNFICsgMTIpDQo+ID4gPg0KPiA+ID4gKy8qKg0KPiA+ID4gKyAqIFZGSU9fREVWSUNFX0dF
VF9QQ0lfSE9UX1JFU0VUX0dST1VQX0lORk8gLQ0KPiBfSU9XUihWRklPX1RZUEUsIFZGSU9fQkFT
RSArIDEyLA0KPiA+ID4gKyAqCQkJCQkJICAgIHN0cnVjdA0KPiB2ZmlvX3BjaV9ob3RfcmVzZXRf
Z3JvdXBfaW5mbykNCj4gPiA+ICsgKg0KPiA+ID4gKyAqIFRoaXMgaXMgdXNlZCBpbiB0aGUgdmZp
byBkZXZpY2UgY2RldiBtb2RlLiAgSXQgcmV0dXJucyB0aGUgbGlzdCBvZg0KPiA+ID4gKyAqIGFm
ZmVjdGVkIGRldmljZXMgKHJlcHJlc2VudGVkIGJ5IGlvbW11ZmQgZGV2X2lkKSB3aGVuIGhvdCBy
ZXNldCBpcw0KPiA+ID4gKyAqIGlzc3VlZCBvbiB0aGUgY3VycmVudCBkZXZpY2Ugd2l0aCB3aGlj
aCB0aGlzIGlvY3RsIGlzIGludm9rZWQuICBJdA0KPiA+ID4gKyAqIG9ubHkgaW5jbHVkZXMgdGhl
IGRldmljZXMgdGhhdCBhcmUgb3BlbmVkIGJ5IHRoZSBjdXJyZW50IHVzZXIgaW4gdGhlDQo+ID4g
PiArICogdGltZSBvZiB0aGlzIGNvbW1hbmQgaXMgaW52b2tlZC4gIFRoaXMgbGlzdCBtYXkgY2hh
bmdlIHdoZW4gdXNlcg0KPiBvcGVucw0KPiA+ID4gKyAqIG5ldyBkZXZpY2Ugb3IgY2xvc2Ugb3Bl
bmVkIGRldmljZSwgaGVuY2UgdXNlciBzaG91bGQgcmUtaW52b2tlIGl0DQo+ID4gPiArICogYWZ0
ZXIgb3Blbi9jbG9zZSBkZXZpY2VzLiAgVGhpcyBjb21tYW5kIGhhcyBubyBndWFyYW50ZWUgb24g
dGhlDQo+IHJlc3VsdA0KPiA+ID4gKyAqIG9mIFZGSU9fREVWSUNFX1BDSV9IT1RfUkVTRVQgc2lu
Y2UgdGhlIG5vdC1vcGVuZWQgYWZmZWN0ZWQNCj4gZGV2aWNlIGNhbg0KPiA+ID4gKyAqIGJlIGJ5
IG90aGVyIHVzZXJzIGluIHRoZSB3aW5kb3cgYmV0d2VlbiB0aGUgdHdvIGlvY3Rscy4gIElmIHRo
ZQ0KPiBhZmZlY3RlZA0KPiA+ID4gKyAqIGRldmljZXMgYXJlIG9wZW5lZCBieSBtdWx0aXBsZSB1
c2VycywgdGhlDQo+IFZGSU9fREVWSUNFX1BDSV9IT1RfUkVTRVQNCj4gPiA+ICsgKiBzaGFsbCBm
YWlsLCBkZXRhaWwgY2FuIGNoZWNrIHRoZSBkZXNjcmlwdGlvbiBvZg0KPiBWRklPX0RFVklDRV9Q
Q0lfSE9UX1JFU0VULg0KPiA+ID4gKyAqDQo+ID4gPiArICogRm9yIHRoZSB1c2VycyB0aGF0IG9w
ZW4gdmZpbyBncm91cC9jb250YWluZXIsIHRoaXMgaW9jdGwgaXMgdXNlbGVzcyBhcw0KPiA+ID4g
KyAqIHRoZXkgaGF2ZSBubyBpZGVhIGFib3V0IHRoZSBpb21tdWZkIGRldl9pZCByZXR1cm5lZCBi
eSB0aGlzIGlvY3RsLg0KPiBGb3INCj4gPiA+ICsgKiB0aGUgdXNlcnMgb2YgdGhlIHRyYWRpdGlv
bmFsIG1vZGUgdmZpbyBncm91cC9jb250YWluZXIsIHRoaXMgaW9jdGwgd2lsbA0KPiA+ID4gKyAq
IGZhaWwgYXMgdGhpcyBtb2RlIGRvZXMgbm90IHVzZSBpb21tdWZkIGhlbmNlIG5vIGRldl9pZCB0
byByZXBvcnQNCj4gYmFjay4NCj4gPiA+ICsgKiBGb3IgdGhlIHVzZXJzIG9mIHRoZSBpb21tdWZk
IGNvbXBhdCBtb2RlIHZmaW8gZ3JvdXAvY29udGFpbmVyLA0KPiB0aGlzIGlvY3RsDQo+ID4gPiAr
ICogd291bGQgc3VjY2VlZCBhcyB0aGlzIG1vZGUgdXNlcyBpb21tdWZkIGFzIGNvbnRhaW5lciBm
ZC4gIEJ1dCBzdWNoDQo+IHVzZXJzDQo+ID4gPiArICogc3RpbGwgaGF2ZSBubyBpZGVhIGFib3V0
IHRoZSBpb21tdWZkIGRldl9pZCBhcyB0aGUgZGV2X2lkIGlzIG9ubHkNCj4gc3RvcmVkDQo+ID4g
PiArICogaW4ga2VybmVsIGluIHRoaXMgbW9kZS4gIEZvciB0aGUgdXNlcnMgb2YgdGhlIHZmaW8g
Z3JvdXAvY29udGFpbmVyLCB0aGUNCj4gPiA+ICsgKiBWRklPX0RFVklDRV9HRVRfUENJX0hPVF9S
RVNFVF9JTkZPIHNob3VsZCBiZSB1c2VkIHRvIGtub3cNCj4gdGhlIGhvdCByZXNldA0KPiA+ID4g
KyAqIGFmZmVjdGVkIGRldmljZXMuDQo+ID4gPiArICoNCj4gPiA+ICsgKiBSZXR1cm46IDAgb24g
c3VjY2VzcywgLWVycm5vIG9uIGZhaWx1cmU6DQo+ID4gPiArICoJLWVub3NwYyA9IGluc3VmZmlj
aWVudCBidWZmZXI7DQo+ID4gPiArICoJLWVub2RldiA9IHVuc3VwcG9ydGVkIGZvciBkZXZpY2U7
DQo+ID4gPiArICoJLWVwZXJtID0gbm8gcGVybWlzc2lvbiBmb3IgZGV2aWNlLCB0aGlzIGVycm9y
IGNvbWVzOg0KPiA+ID4gKyAqCQkgLSB3aGVuIHRoZXJlIGFyZSBhZmZlY3RlZCBkZXZpY2VzIHRo
YXQgYXJlIG9wZW5lZCBidXQNCj4gPiA+ICsgKgkJICAgbm90IGJvdW5kIHRvIHRoZSBzYW1lIGlv
bW11ZmQgd2l0aCB0aGUgY3VycmVudCBkZXZpY2UNCj4gPiA+ICsgKgkJICAgd2l0aCB3aGljaCB0
aGlzIGlvY3RsIGlzIGludm9rZWQsDQo+ID4gPiArICoJCSAtIHRoZXJlIGFyZSBhZmZlY3RlZCBk
ZXZpY2VzIHRoYXQgYXJlIG5vdCBib3VuZCB0byB2ZmlvDQo+ID4gPiArICoJCSAgIGRyaXZlciB5
ZXQuDQo+ID4gPiArICoJCSAtIG5vIHZhbGlkIGlvbW11ZmQgaXMgYm91bmQgKGUuZy4gbm9pb21t
dSBtb2RlKQ0KPiA+ID4gKyAqLw0KPiA+ID4gK3N0cnVjdCB2ZmlvX3BjaV9ob3RfcmVzZXRfZ3Jv
dXBfaW5mbyB7DQo+ID4gPiArCV9fdTMyCWFyZ3N6Ow0KPiA+ID4gKwlfX3UzMglmbGFnczsNCj4g
PiA+ICsJX191MzIJY291bnQ7DQo+ID4gPiArCV9fdTMyCWRldmljZXNbXTsNCj4gPiA+ICt9Ow0K
PiA+ID4gKw0KPiA+ID4gKyNkZWZpbmUgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRfR1JP
VVBfSU5GTw0KPiAJX0lPKFZGSU9fVFlQRSwgVkZJT19CQVNFICsgMTgpDQo+ID4gPiArDQo+ID4g
PiAgLyoqDQo+ID4gPiAgICogVkZJT19ERVZJQ0VfUENJX0hPVF9SRVNFVCAtIF9JT1coVkZJT19U
WVBFLCBWRklPX0JBU0UgKyAxMywNCj4gPiA+ICAgKgkJCQkgICAgc3RydWN0IHZmaW9fcGNpX2hv
dF9yZXNldCkNCj4gPg0KDQo=
