Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556A975E9BE
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 04:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjGXCaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jul 2023 22:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjGXCax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jul 2023 22:30:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3EC180;
        Sun, 23 Jul 2023 19:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690165832; x=1721701832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vk7AVkhITa5/9+WRLmB3kneAgQKPOUFQw0AdQE3rg5o=;
  b=YptsPa7hX1VpDbdaNlM2q0vRRfLQSZrbNx8D6uIEo0dxF1FLQldK7c3H
   CJFMReFApbeMO378yjF/K8fumdFvPfe1Xx+UGq6dR+oUF/zhaXJ9OvrrA
   0xgTVBYSHAH+IyK3x2/untvJpqASRgQuhg/bsERXR7AcWuOybQd0rJ+RR
   DHa4ssj4Tvu7S6DnOeo6kRc/AeiNc+qvgKJo/nSE5mYoibtmhl1fTdVmk
   C4HAmWkrk/umruxi1J2IILPZS8NAxp0jvRlr+NXuZGbGjftUdGU0U80eJ
   w28TQm3iIeOumNqn1V+yBIHcrij2RoUSmbHgwPcxKiRtWD8qQboMzwXM9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="352226823"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="352226823"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 19:30:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="899347340"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="899347340"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 23 Jul 2023 19:30:31 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 23 Jul 2023 19:30:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 23 Jul 2023 19:30:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 23 Jul 2023 19:30:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+SxJBw7mMVWx32C3h0Y5r5Vb46hoNd/ue4jiC+qoMqTI/CoSMNbB6jGCKBgLWO1JVswEsnsSjYrraiWgDc4PAxTVENTwZKPKEVj10kxQHwS9gFQQKpkAEHzAQmxugGC7UddlETWlaOb7g1GJ2mqkRFlpUEIUOQO83jzIZyPR592kgWjqSvf3j4sTa2oGGhZ1albbn49lf2KYa6+uIM+HI/m1wa88R2NsCjvHscpBMLP0UTALDHnjG3cTO8g6pftvCvpbvsUZQbd1enUm+AqlcRW6tyJt9uRSngEu04GEGLaPG9T2hrHnUi0AjRTEHKMQbtV0hD0PERSsOylIe0fqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk7AVkhITa5/9+WRLmB3kneAgQKPOUFQw0AdQE3rg5o=;
 b=dQbAMu3g23lmiVACUbnfI8zUaODw0Mi75N+rpUan4ou7Z+dtYUwr87UPAAHH3zPtpNBl4M5tDEhgk60hqmHVCdTQfMRsdMHPjasSrTu65j4yN1SaJfq75deP4/gxljo5N2Zw73Wt4rz6AHxXQYsLEfjwn3/n2fDg5Wct5k7uJPsyQbqdjnnzpOagED1RAzznMykNTN7GKGAO1fRFIHWrvl84/R48o0iJiFowUkjBNRYkwceD1ScY3KMj2vhX6sQIfmSVzEQWuTeRic3rVJ1PcEZPtjucU6gQd3TJB3vgR2EGQ8LZxaNticmkbHhBxTVdg6KkUoUbHZ0/Cwsxy+y3sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5090.namprd11.prod.outlook.com (2603:10b6:303:96::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Mon, 24 Jul
 2023 02:30:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.026; Mon, 24 Jul 2023
 02:30:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Topic: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Index: AQHZupFmkHLXvoHLwkSg/oL5LnrRZ6/D7upAgAF1HgCAAtMVYA==
Date:   Mon, 24 Jul 2023 02:30:09 +0000
Message-ID: <BN9PR11MB52762A02D14E3FAD064A74058C02A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-5-brett.creeley@amd.com>
 <BN9PR11MB52761AA921E8A3A831DD4A1A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <259c5f0d-24bf-dfd4-a1c5-102944aecd4f@amd.com>
In-Reply-To: <259c5f0d-24bf-dfd4-a1c5-102944aecd4f@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5090:EE_
x-ms-office365-filtering-correlation-id: 64939e16-eae8-4e87-cbf5-08db8bede6dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jh1xWVB+5F0v6RBNCsZ2vsxdNWLgkDIETAFjMA/SO4B/SwstOfZ1oaEs6NfBpYbdKSqafsRNvysOamMoZmll8yKm+QQ3aUB5suSDFe8WeZt9uzEV780DNMHSga39RYECBaHIDHQxDC9up8ZD00q2/Q1ZD7BYWysCvbXd54uC1y0cWblPF1gYrSgL8oXZX4/ksau+ZuocHdRJMdoY6sq63wB+Ri6stP3hM8QiaTJH3w9mnn3VDWxCIXiIgbDA0me3bZ+58kCaVb1FYr4P/VIE3Pyv5T6sREQQJDMnoYiZsFQfLh+p0KPVS54mTgNfQadkcha8NtDp00IM08+fSFVmm7tPMSQPGS9C1SipLulBTxxGRPl2P/FOu7DdsnrbROynGew40L3j/ATT9ZDbIZH/5Avj1uzV1VyGgNUjxJEmKUoiFfRHC5dy4o58VMz0a/iPYGcLQWXavArR4WWwagtUQr4ubqkkCd/NqH6ObV0ldNO+4ZP63WZChhv5WmrvR2AKnvk/jRxgl1PzcUPi7apIQH19/4DL3x4F5g35AOCBRvXOHnwg4xgiCWr3Gqg0FeT+yiU2MpBUkNiPKT+SHCds0lXAb49y30snDng4NnurGR5zf2Dh/DAJe4coSpc72Lkl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(55016003)(316002)(186003)(5660300002)(8936002)(8676002)(52536014)(110136005)(7696005)(26005)(6506007)(4326008)(9686003)(82960400001)(71200400001)(66946007)(76116006)(41300700001)(478600001)(2906002)(86362001)(38100700002)(38070700005)(33656002)(64756008)(66446008)(66556008)(66476007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sy9Oc09FNHdsTzEyOWNTYWtuK3B1dDA4aXk2V3BhWW1VMUY4c0F6RVB3MXJr?=
 =?utf-8?B?d2w0QUx2YlRoeE9WMGt6c0k2VjlVRUYzYUQ4M2RyN0locE5ENjFoaUZJOWVR?=
 =?utf-8?B?aWNWUE1xWUZWSFdnVWhyZTkxUi9JVUt0VXNqWmZLLzhWdngzZjl0ZmlaRHVq?=
 =?utf-8?B?dVdsekxxcGE5NnlpeTlNLytYWExjNTdYMHRENUhocEdGWW9oWGNQTzRqbUtI?=
 =?utf-8?B?NDhLTzl1cDRPUHIrN3cxQm5CeUwvUS9KcHBOUFlKOXZqMmh3RTRsMHNORFov?=
 =?utf-8?B?dmVBMXREVmJFb1FQSWRrVkxGUnVmYi9VZDl6ZUhqdUZJenlWOTc1ZjEwWUVL?=
 =?utf-8?B?Y1NTWDRvMVVHMXFkeER6SWZSeEdoWE5WNzl4c2VqRnRSS0dabFpwYXg1aEtB?=
 =?utf-8?B?eTA1Y2VkdWViMWlSejB0S1dMOVpLMGJjdTFHVlp4ZC9qWFdFbm95RGtuVjlN?=
 =?utf-8?B?and6K0NxMlgvdlJWWmxkZGs1T1NCNG1MbVUyV0RjQVF5SzZBYVlkTXIzTUNk?=
 =?utf-8?B?WXZwaW9oUUpFbEN3R2dOdy9lcHAreEFCdmV0NFJXTFNES2ZBZ1F6WlZRYzRk?=
 =?utf-8?B?U3pnRzVKZXdSTTRQL29xOFpGdnBqRUkwVEdreFd5ck8xNVRBaHUxcmk4OEJt?=
 =?utf-8?B?VC9LMlVPVHZrOFU3eURxVUVqLzFCVXU2SWhON3BLa0Y2UTVZZVpSSDJGUzVk?=
 =?utf-8?B?QkdWaHUrSFNwZk1tWG9UanRyekQvNW9RUGg2UjU0Z1E5WVZSZFBhVVFVT1Bo?=
 =?utf-8?B?a1dzT3l6YTlBdHpxOXFaTlVsZ0VxQXVlTEhHVU53d1h1dmRYNzU2OTllVkpP?=
 =?utf-8?B?bGFMVi9ld0s0TURoeVFTa3FiQUZnZEhwcjNRWXRQSUFoMXlPV2paOTZGUExq?=
 =?utf-8?B?NTVTcTd0TDJTVWNrRnRiN0RCS3pMdU9BcEkra0hDTXBFQXZoYXNuSVlOZ3l0?=
 =?utf-8?B?eVB4OTRQek1jelBnTzhyTyswR1VkbVVHTDA0L2VXVXZIRHBuZHhCQlNyK2Na?=
 =?utf-8?B?aEFxVTJRTXVkckNOMHFOMHBrY3BEOWtGVEF3YTNzWmZpM2tMTmoyUzRHbTZ2?=
 =?utf-8?B?ZWkwVjJQcU5YZjBxakV1dVhyL2NLMkhyY2c2ZWRCTjIxSDNnOThzZEdSdDdZ?=
 =?utf-8?B?VmxnQXpDd3FjTDF4NDdVRnZiamJSaUVrMkZaYlNMYWpuZW1ORDEvR3c5a2ts?=
 =?utf-8?B?WnptZTdmUGtXUXYwdklQb3NVeUYwaDIvNXMxWEQ0MEJxVUUrN0FHQW51bzFv?=
 =?utf-8?B?bmx3b3M1Y1Z3NUwvTEhDTEVDMTZBTnZFVmVMSWg4Ni8xWjZRM3dBc3VYZkZO?=
 =?utf-8?B?UVJURUdFYmlGbFVQWjdQNis4VHdvZUxieXNpMDNpWHlzcU8rSndOL1o4WStQ?=
 =?utf-8?B?ajZBUHpYcHVGaXEzRVdpZ3dyNkFjUWhEOGZGaUw0YW40MkIxQ3hiVlM1dTdl?=
 =?utf-8?B?RzVrZ3huZVRUellmUzNPTHYwTTRXMDB4N25QVVR2emFlU0dhKzEvK29kbHl1?=
 =?utf-8?B?NzhqQkxUbXdNVFNaR0oxRzYrTkEyOEM3QVV3MGtKWmtpeG9KWU9xUHJ1L3B4?=
 =?utf-8?B?SWxYQmQyeExlbE5SZ09PZ082UnFSaHJZamtUZUZaYTBmY1ZWYzZ0Z1FXU0pO?=
 =?utf-8?B?YlBQWFNEMEpMREV3ZFUxRmxnWFlXa09LYUpHaldnRnlMTjV0VStQd0tqVkJU?=
 =?utf-8?B?c29kcnVqTUhVb3MwU01EUklhU2pCZzJLaFA5RzV6SElGL1Q0eDdmMGJ5R2tv?=
 =?utf-8?B?RUY0SGpPZDVlbnBzRnVvN3R2RE10L0NGOFY2OUdEOStrSEhvTUpwMS9nT051?=
 =?utf-8?B?TWZLSjNpQis4Y1R4dCsva0JGN09jcndSNGQ1YnFJd29yQWlkNGgwanlUelJp?=
 =?utf-8?B?TGNxK0lOcGQ3TXNWbGFpRkVHQ2ozSUtadjVpVXY4dEdCVnVRb3lKWHVGTUVx?=
 =?utf-8?B?dDFUakxZMVcxUlhsTGtKYjRzdWVMbmhTbHBkWU1iRUxPWUY4TEltZHhNazE3?=
 =?utf-8?B?azN6ejFLQ3VmWk9QQ3JhTmFHYU1UYXdDaWhPMmJYK3hsVFdQVlhUcXRyVUxi?=
 =?utf-8?B?WW9NdUZxRTZPZk4ydGxSYkxzcVNSQTZDTGJGSHVYTXEyZjhZcXZRWkd0cEJi?=
 =?utf-8?Q?8ri7p/VZMyAAPdALm7Ahwnjz+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64939e16-eae8-4e87-cbf5-08db8bede6dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 02:30:09.9513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QfRI4GWchcsBLfRl1HBmVPN4RnFRVMiAxo0fMdVA6MFCPlmqT/O9hvfpNUxsg+qQHSZucG1jfVWDvv1p/0KhzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5090
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCcmV0dCBDcmVlbGV5IDxiY3JlZWxleUBhbWQuY29tPg0KPiBTZW50OiBTYXR1cmRh
eSwgSnVseSAyMiwgMjAyMyAzOjE4IFBNDQo+ID4+ICsNCj4gPj4gK3N0YXRpYyBzdHJ1Y3QgcGRz
X3ZmaW9fbG1fZmlsZSAqDQo+ID4+ICtwZHNfdmZpb19nZXRfbG1fZmlsZShjb25zdCBzdHJ1Y3Qg
ZmlsZV9vcGVyYXRpb25zICpmb3BzLCBpbnQgZmxhZ3MsIHU2NA0KPiBzaXplKQ0KPiA+PiArew0K
PiA+PiArICAgICBzdHJ1Y3QgcGRzX3ZmaW9fbG1fZmlsZSAqbG1fZmlsZSA9IE5VTEw7DQo+ID4+
ICsgICAgIHVuc2lnbmVkIGxvbmcgbG9uZyBucGFnZXM7DQo+ID4+ICsgICAgIHN0cnVjdCBwYWdl
ICoqcGFnZXM7DQo+ID4+ICsgICAgIHZvaWQgKnBhZ2VfbWVtOw0KPiA+PiArICAgICBjb25zdCB2
b2lkICpwOw0KPiA+PiArDQpbLi4uXQ0KPiA+DQo+ID4gSSB3b25kZXIgd2hldGhlciB0aGUgbG9n
aWMgYWJvdXQgbWlncmF0aW9uIGZpbGUgY2FuIGJlIGdlbmVyYWxpemVkLg0KPiA+IEl0J3Mgbm90
IHZlcnkgbWFpbnRhaW5hYmxlIHRvIGhhdmUgZXZlcnkgbWlncmF0aW9uIGRyaXZlciBpbXBsZW1l
bnRpbmcNCj4gPiB0aGVpciBvd24gY29kZSBmb3Igc2ltaWxhciBmdW5jdGlvbnMuDQo+ID4NCj4g
PiBEaWQgSSBvdmVybG9vayBhbnkgZGV2aWNlIHNwZWNpZmljIHNldHVwIHJlcXVpcmVkIGhlcmU/
DQo+IA0KPiBUaGVyZSBpc24ndCBkZXZpY2Ugc3BlY2lmaWMgc2V0dXAsIGJ1dCB0aGUgb3RoZXIg
ZHJpdmVycyB3ZXJlIGRpZmZlcmVudA0KPiBlbm91Z2ggdGhhdCBpdCB3YXNuJ3QgYSBzdHJhaWdo
dCBmb3J3YXJkIHRhc2suIEkgdGhpbmsgaXQgbWlnaHQgYmUNCj4gcG9zc2libGUgdG8gcmVmYWN0
b3IgdGhlIGRyaXZlcnMgdG8gc29tZSBjb21tb24gZnVuY3Rpb25hbGl0eSBoZXJlLCBidXQNCj4g
SU1PIHRoaXMgc2VlbXMgbGlrZSBhIHRhc2sgdGhhdCBjYW4gYmUgZnVydGhlciBleHBsb3JlZCBv
bmNlIHRoaXMgc2VyaWVzDQo+IGlzIG1lcmdlZC4NCj4gDQoNCklmIHRoZXJlIGlzIG5vIGRldmlj
ZSBzcGVjaWZpYyBzZXR1cCBJIGRvbid0IHNlZSBhIHJlYXNvbiB0byBmdXJ0aGVyIHByb2xpZmVy
YXRlDQp0aGUgY29kZSBkdXBsaWNhdGlvbi4gQXQgbGVhc3QgaXQncyBhbiBpbmNyZWFzaW5nIHJl
dmlldyBidXJkZW4gdG8gbWUuDQoNCkknZCBsaWtlIHRvIGhlYXIgb3BpbmlvbnMgZnJvbSBvdGhl
ciByZXZpZXdlcnMuIA0K
