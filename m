Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476B070265A
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 09:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbjEOHsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 03:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbjEOHr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 03:47:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CCC1B3;
        Mon, 15 May 2023 00:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684136876; x=1715672876;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LV+OWYeuHplHSB04vOLDiTGp4z4KfstHFPbkuy/Lxo0=;
  b=V1palgHZF6sFky4OQd0l+4ssmqztXU6cuss2PekK3LIfpwTnWLNWUAU/
   xix0ENwBWpylFqzpENMT9zi8o+ywzcG3fh7QHGVPG+9xsccT6Le/t+c8c
   NldAohr03/SgkrR+BZ7lWVBadJgE05mVfN/pd5fbTlAfgtZvhMxHJ2lZ6
   uyMJZn/lN2d1nr1AkiQvc79HhOkC4jodARpvKXDNckT4UvfP4WODlRhmC
   MZ3kHkhV6/c8Jqy4rSICHBp3gU4x2jOiUyDqpGt+J9V6ZXVSOXcjn5703
   IjzhIkfLWp5Bqmfu1eW+S/6cMQXmQA/i6nCa2WpAxKLQw94edAowZTQNo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="335675218"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="335675218"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 00:47:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="790570700"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="790570700"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2023 00:47:54 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 00:47:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 00:47:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 00:47:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRppMoEE3I+WUJK9C23nOPD4HZgn7HYc4eQ7PigbpI6nh4dhM7syst7Zb28PwZ47knb22SzSiNfbay0w9J83fdXzLEDAMY478N3CuGCIPpwnMPeMstOs7spSicxfopgVgLkifR/alUnsv3Er8miqkXVALLBeWd9wn5dzaK/uBU6btaRkGUz44J8Ccf1rMWzB6zIbBGT/l7ulnIVWYDQl6u0BFgZTBiTzVYSFiDipBXzwG3RBjMNcTosBbYbt73Ljw4eMQeL2nXaBc/SjqjDdbF/r+NOHTy62UulKb7y8Jsbljkq+jGZ0wA1usG5h1N9m4m7rzYk5RB7gDpju8VaEOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LV+OWYeuHplHSB04vOLDiTGp4z4KfstHFPbkuy/Lxo0=;
 b=OE+Y+XeMv0MLHG9EIIqnmi4cnYMPCMkJETy2SUqbmeriiviRSStzhagR8gDCEr/HR9tJrCIT2XXFY3z6Rd4rCxZeko/IW+F/+9C91vLs+NwgDaxJO+U2SI7SlfNPVt2LOx0+vQgZZFsgL8zxb3WN/vWEG9ggSFnGZ95fKUPRcu8RjdWF4J80KoTQtXFF1ML26IcMmSWxSBd01HPzCs+QeLHt3OdaNTJbpKSkX53/hw/YTQZGYEdr2T/O3AWgiOJCu49aQxZZQNJZ4epDHJXjpsmxoxIYsEBvfSi203z0gc2wHyz+5/BEEaYLF+KXQ5ms/4NPW5wvH78EJudEnUoxig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB4987.namprd11.prod.outlook.com (2603:10b6:806:113::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 07:47:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 07:47:45 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clegoate@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v5 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v5 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZhZ3jyYhqTyCeBkWxtZfhjn83dK9a8sEAgAACtzA=
Date:   Mon, 15 May 2023 07:47:45 +0000
Message-ID: <DS0PR11MB752984D04C49FD022AD4A611C3789@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
 <20230513132136.15021-10-yi.l.liu@intel.com>
 <aa59a555-0f6f-9cd7-5253-621c98d19fb8@redhat.com>
In-Reply-To: <aa59a555-0f6f-9cd7-5253-621c98d19fb8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA2PR11MB4987:EE_
x-ms-office365-filtering-correlation-id: c9f12378-ff24-41d2-1f57-08db5518abb4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aXl/ndwM1qNnD0a8MK2sUiHk7/Z7XCdlX6PYUar9zyfRd3DVyzCNQIk3h92A5idMMRYnMHnE/3qGUOAcP3Iu3Vz8TXHHfleGqWSeFb8fMXLLSurj42wz4RFKpTP5dR+8S8rgcrfMowqYeuI+AV7ArFJR0MOyQUIwtIG9Sr+ah3n6ZnkKk2uWTPFoNGNETu9fIP3744LdHIu7Qy6fvsBbeoZGMiRKGLjo/2TaMvcy/MUFxXHnMjqYF/jaIZ816eGS/BMHFHWOkIoGDC4j83kukDm7dAhO/5yY+cGVCnwUf1ojLFj6VF1E6sDAvdWZcomGJJylM+PMKuSywR1mNtGgFV3xifCwAkl2N36/fFY4j8mPwLUjTaTTc3QvrOacQ8s5qmYI3MQxZMQ6skCdC6YP8aFRDgh4IHQehsdFILiKroXBmtsApuuFEf8wIeSlzDa4Fd5okoHayyRF8OeFky2MM/I5Jf8LTtb4kfd5iiL1AEbaH6EjXpiQqze+KIWb/JvKOtaVmhG5MZifhNP7zRwTi06eQU0NJOXvNFtwgqciIaY9IdcgcygNne0rWl+Uezt5fFt0o7/nh/bmtOLojr87CM07Y8ATzgv8IBqiHOc5uTchw34fow+TbW7jrcrDLYOf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199021)(83380400001)(66574015)(4326008)(6636002)(316002)(41300700001)(38070700005)(122000001)(82960400001)(38100700002)(9686003)(6506007)(53546011)(7696005)(478600001)(66946007)(66446008)(64756008)(66476007)(66556008)(55016003)(76116006)(86362001)(5660300002)(52536014)(2906002)(33656002)(8676002)(8936002)(110136005)(54906003)(7416002)(186003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDlLMEZKMFhpZnZ5YlFXd09aTEU3a05lb2pMQTYyZFNONnQzQ2t6WDBXMUNU?=
 =?utf-8?B?dDJNYTBkS2VybEc4NDR3Vm5McmM4dFlKRWFzbXdMRUpEaTBuNFJPQUdYeEFL?=
 =?utf-8?B?UmloZE5FMXNOcC9ZZFREc1lucjllSzlRTmZMVDdSNDRBS0lqVmhvdWRwS0FW?=
 =?utf-8?B?V3FLTjlKWk96anVzUzNkT1doWEZzcDVnRnRmaG9tTERFVWQ2emJ2Qzg0alFY?=
 =?utf-8?B?aHhmdTN2TzVMNUtLTXdkd051Q2Zhb0pTdmxHQ3JaNXVzWXc2d0dyQWxBeDY2?=
 =?utf-8?B?aVgyVUlIQnFRRkJmdTBhSGxvMHlWTE1VbDdZS0tCWEtjbURHSHZybGhVMzdM?=
 =?utf-8?B?Z2NXSHdCNTJpQXp0UEdhWS9kSFRjeWVGdGRMVFc2NCtBZFVuRm9KZWQzNWl5?=
 =?utf-8?B?Q0pEM09UcDBxQlZSR0poVTNQMVVqbXFFWm9tTUI3aThVbXNOcFJNZXBUSzR5?=
 =?utf-8?B?bDFMQ0dNWlhDZXZaUXN6VFB4OUFXWnBZVWNGc09IMnQrdUJvdjNTalFxajF4?=
 =?utf-8?B?V0NoclpLYTEzLzdhaXh4S0dUQlc5Zkw2QnIxYlE4bU9QZ0tvbitvbk5OSTZJ?=
 =?utf-8?B?WFNBelp1TDlRU2tNYk1GelB4Si9tT3MvMElNYjJTdG5tS1g5N1FZb0N5a29x?=
 =?utf-8?B?dmNMZmxmSGpCSlNaK0NiMnNvbFkrSE1YZ0ViTHBDak5mVm5oc1UrY010eWxN?=
 =?utf-8?B?N1V2Vk1BOVJGbVp5TWdLYTNXMVJmMy9GZ2pVMUw0aElQZHI1WGUza01wSXNB?=
 =?utf-8?B?Qk1FUUJaK1lhZUVKeU90cVJVcXVNSjVsNlA1TnhSUVpuQ3pvQnI2WXgrZDgy?=
 =?utf-8?B?bkY5cHc1MzNkMkYra0VwVVpJdVdzNWxDeTU4S0ZNZi9CVmpkSmNEd3lwaFZI?=
 =?utf-8?B?UmxvNFIrdzRsSWcyRU1CTFQzZTlGNVdnb1U4L3JjeEJ4MkJuRVM3ZGRBMFNK?=
 =?utf-8?B?bmF5UjQrTVY2Z0IyWUVMV0xjNlhNSDAxTlAwWWF5bkZoTi80ZE5JbDlKZnBB?=
 =?utf-8?B?Ui9Eb2dab3BIS0RXZU9LdlRycDRieWNub01YakwzVlRTTjBYNnY5L3FRcXJz?=
 =?utf-8?B?c1BiekJQNndKNE1oU1dOOXhvc0FaMkdiMWl5dlVKSzFSSUhPYUo2Z2lWMXRH?=
 =?utf-8?B?bXluTG90eFVnSTg3U01zK045b29jUmtDcWtScXM1MVBlZXdBN1cyc2V4aEwv?=
 =?utf-8?B?QWJDRGFxK2dLTmtmYUJGdDhSTzhxanQ5ZG5SdWFneEN0VUdKaDBVSHc5ZXhn?=
 =?utf-8?B?eWpPbGZ4QkJvT2hjRGxHa0dnaEZoMTg2aFFXM2lTblcrRWdHaFhEVk1Bb1JE?=
 =?utf-8?B?TzM2YnVHR25GZFJVaVRlY2lBNHZYcm95S3gzak0zZW53UG5LbEwxVHduOTNQ?=
 =?utf-8?B?NlpvaTUwcTdsZmluUkVxZUMwelJyZlYwckRLaW9PRElmS1R4TWpydGV5NndY?=
 =?utf-8?B?Tkk5OW9vcUdWY0kyTnpiUVh6K3FTNUpDTEgxM0Y4KzdDSjQ0TG9mWlMxbjl4?=
 =?utf-8?B?L3piMVFYTC9HcEZVQVYyTzBkemdTQzlKTXdpRVo2ZEtySy9QM29vaDZLQ2kr?=
 =?utf-8?B?VGNJWFdpY3R3TTEyWDlxUXNZcW1MWTFTclVsMUVveFlRUWd2Smlwek9sNFBJ?=
 =?utf-8?B?TVVteU5LZnUxQmJHempuN05QbXFpejZTSzRtbTkvMngyUFdiL1hPdjhPRFhD?=
 =?utf-8?B?QUJvZVZuRm5rUU1lMHlyZVJXSDlLRENBaFMxYlJBa0xwcVZacFY5MThhNGU4?=
 =?utf-8?B?TWtpSGgvekp5VU1idUxubUpISVNtWkZTMHNxTnlYWTJwNVZzcWM0RjhSTHdR?=
 =?utf-8?B?MS9WZXVKNnIyNTlVQ2FFaFRzeXZoM0g5MWJVeXNsTjBqc1RKQURPVmdWeWFI?=
 =?utf-8?B?SDVqaCs5WVhSaXdvSWhGbVZYVndCS1VpMmt1MHlJUkF0MUw0S1ArZUJjMTQx?=
 =?utf-8?B?QVNiLzJtd2p3K3V5b3BaV1gvYklvYTdlRlVPd2pIRlJqUFFHRGg0MjEzd0xU?=
 =?utf-8?B?dk50T3V2eGN5UGhLY3kxTlMwTDhYN2Fzd1J6SXVLWTZtUnk4RnRMMGZteWp5?=
 =?utf-8?B?SnpFTkpyRmFXSFVnWHpIQWpVTk0zVVVTWXRPQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f12378-ff24-41d2-1f57-08db5518abb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 07:47:45.0851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IhJ5Zv4ZwykaEVl0+Sd0MDknTMXF3B3E14lhdyh2j0460MqdZiwQjJZQuZKIvfbe3vGIWVYLw+YSBCxqmCxyZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4987
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

PiBGcm9tOiBDw6lkcmljIExlIEdvYXRlciA8Y2xlZ29hdGVAcmVkaGF0LmNvbT4NCj4gU2VudDog
TW9uZGF5LCBNYXkgMTUsIDIwMjMgMzozMCBQTQ0KPiANCj4gT24gNS8xMy8yMyAxNToyMSwgWWkg
TGl1IHdyb3RlOg0KPiA+IFRoaXMgbWFrZXMgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRf
SU5GTyBpb2N0bCB0byB1c2UgdGhlIGlvbW11ZmRfY3R4DQo+ID4gb2YgdGhlIGNkZXYgZGV2aWNl
IHRvIGNoZWNrIHRoZSBvd25lcnNoaXAgb2YgdGhlIG90aGVyIGFmZmVjdGVkIGRldmljZXMuDQo+
ID4NCj4gPiBUaGlzIHJldHVybnMgZGV2aWQgZm9yIGVhY2ggb2YgdGhlIGFmZmVjdGVkIGRldmlj
ZXMuIElmIGl0IGlzIGJvdW5kIHRvIHRoZQ0KPiA+IGlvbW11ZmRfY3R4IG9mIHRoZSBjZGV2IGRl
dmljZSwgX0lORk8gcmVwb3J0cyBhIHZhbGlkIGRldmlkID4gMDsgSWYgaXQgaXMNCj4gPiBub3Qg
b3BlbmVkIGJ5IHRoZSBjYWxsaW5nIHVzZXIsIGJ1dCBpdCBiZWxvbmdzIHRvIHRoZSBzYW1lIGlv
bW11X2dyb3VwIG9mDQo+ID4gYSBkZXZpY2UgdGhhdCBpcyBib3VuZCB0byB0aGUgaW9tbXVmZF9j
dHggb2YgdGhlIGNkZXYgZGV2aWNlLCByZXBvcnRzIGRldmlkDQo+ID4gdmFsdWUgb2YgMDsgSWYg
dGhlIGRldmljZSBpcyB1bi1vd25lZCBkZXZpY2UsIGNvbmZpZ3VyZWQgd2l0aGluIGEgZGlmZmVy
ZW50DQo+ID4gaW9tbXVmZCwgb3Igb3BlbmVkIG91dHNpZGUgb2YgdGhlIHZmaW8gZGV2aWNlIGNk
ZXYgQVBJLCB0aGUgX0lORk8gaW9jdGwgc2hhbGwNCj4gPiByZXBvcnQgZGV2aWQgdmFsdWUgb2Yg
LTEuDQo+ID4NCj4gPiBkZXZpZCA+PTAgZG9lc24ndCBibG9jayBob3QtcmVzZXQgYXMgdGhlIGFm
ZmVjdGVkIGRldmljZXMgYXJlIGNvbnNpZGVyZWQgdG8NCj4gPiBiZSBvd25lZCwgd2hpbGUgZGV2
aWQgPT0gLTEgd2lsbCBibG9jayB0aGUgdXNlIG9mIFZGSU9fREVWSUNFX1BDSV9IT1RfUkVTRVQN
Cj4gPiBvdXRzaWRlIG9mIHByb29mLW9mLW93bmVyc2hpcCBjYWxsaW5nIGNvbnZlbnRpb25zIChp
ZS4gdmlhIGxlZ2FjeSBncm91cA0KPiA+IGFjY2Vzc2VkIGRldmljZXMpLg0KPiA+DQo+ID4gVGhp
cyBhZGRzIGZsYWcgVkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdfREVWX0lEIHRvIHRlbGwgdGhlIHVz
ZXIgZGV2aWQgaXMNCj4gPiByZXR1cm5lZCBpbiBjYXNlIG9mIGNhbGxpbmcgdXNlciBnZXQgZGV2
aWNlIGZkIGZyb20gb3RoZXIgc29mdHdhcmUgc3RhY2sNCj4gPiBhbmQgYWRkcyBmbGFnIFZGSU9f
UENJX0hPVF9SRVNFVF9GTEFHX0RFVl9JRF9PV05FRCB0byB0ZWxsIHVzZXIgaWYgYWxsDQo+ID4g
dGhlIGFmZmVjdGVkIGRldmljZXMgYXJlIG93bmVkLCBzbyB1c2VyIGNhbiBrbm93IGl0IHdpdGhv
dXQgbG9vcGluZyBhbGwNCj4gPiB0aGUgcmV0dXJuZWQgZGV2aWRzLg0KPiA+DQo+ID4gU3VnZ2Vz
dGVkLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+IFN1Z2dlc3RlZC1i
eTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRy
aXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jIHwgNTIgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrLS0NCj4gPiAgIGluY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggICAgICAgIHwgNDYg
KysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICAgMiBmaWxlcyBjaGFuZ2VkLCA5NSBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9j
b3JlLmMNCj4gPiBpbmRleCA0ZGYyZGVmMzViZGQuLjU3NTg2YmU3NzBhZiAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYw0KPiA+ICsrKyBiL2RyaXZlcnMv
dmZpby9wY2kvdmZpb19wY2lfY29yZS5jDQo+ID4gQEAgLTI3LDYgKzI3LDcgQEANCj4gPiAgICNp
bmNsdWRlIDxsaW51eC92Z2FhcmIuaD4NCj4gPiAgICNpbmNsdWRlIDxsaW51eC9ub3NwZWMuaD4N
Cj4gPiAgICNpbmNsdWRlIDxsaW51eC9zY2hlZC9tbS5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgv
aW9tbXVmZC5oPg0KPiA+ICAgI2lmIElTX0VOQUJMRUQoQ09ORklHX0VFSCkNCj4gPiAgICNpbmNs
dWRlIDxhc20vZWVoLmg+DQo+ID4gICAjZW5kaWYNCj4gPiBAQCAtMzYsNiArMzcsMTAgQEANCj4g
PiAgICNkZWZpbmUgRFJJVkVSX0FVVEhPUiAgICJBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlh
bXNvbkByZWRoYXQuY29tPiINCj4gPiAgICNkZWZpbmUgRFJJVkVSX0RFU0MgImNvcmUgZHJpdmVy
IGZvciBWRklPIGJhc2VkIFBDSSBkZXZpY2VzIg0KPiA+DQo+ID4gKyNpZmRlZiBDT05GSUdfSU9N
TVVGRA0KPiANCj4gVG8gaW1wb3J0IHRoZSBJT01NVUZEIG5hbWVzcGFjZSwgSSBoYWQgdG8gdXNl
IDoNCj4gDQo+ICNpZiBJU19FTkFCTEVEKENPTkZJR19JT01NVUZEKQ0KDQpUaGFua3MuIFllcywg
SU9NTVVGRCBpcyB0cmlzdGF0ZSBub3csIHNvIG5lZWRzIHRvIHRlc3QgQ09ORklHX0lPTU1VRkQ9
bS4NCmFuZCAiI2lmIElTX0VOQUJMRUQoQ09ORklHX0lPTU1VRkQpIiBmaXhlcyB0aGUgY29tcGls
aW5nIGZhaWx1cmUuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCj4gDQo+IA0KPiA+ICtNT0RVTEVfSU1Q
T1JUX05TKElPTU1VRkQpOw0KPiA+ICsjZW5kaWYNCj4gPiArDQo+ID4gICBzdGF0aWMgYm9vbCBu
b2ludHhtYXNrOw0KPiA+ICAgc3RhdGljIGJvb2wgZGlzYWJsZV92Z2E7DQo+ID4gICBzdGF0aWMg
Ym9vbCBkaXNhYmxlX2lkbGVfZDM7DQo+ID4gQEAgLTc3Niw2ICs3ODEsOSBAQCBzdHJ1Y3QgdmZp
b19wY2lfZmlsbF9pbmZvIHsNCj4gPiAgIAlpbnQgbWF4Ow0KPiA+ICAgCWludCBjdXI7DQo+ID4g
ICAJc3RydWN0IHZmaW9fcGNpX2RlcGVuZGVudF9kZXZpY2UgKmRldmljZXM7DQo+ID4gKwlzdHJ1
Y3QgdmZpb19kZXZpY2UgKnZkZXY7DQo+ID4gKwlib29sIGRldmlkOjE7DQo+ID4gKwlib29sIGRl
dl9vd25lZDoxOw0KPiA+ICAgfTsNCj4gPg0KPiA+ICAgc3RhdGljIGludCB2ZmlvX3BjaV9maWxs
X2RldnMoc3RydWN0IHBjaV9kZXYgKnBkZXYsIHZvaWQgKmRhdGEpDQo+ID4gQEAgLTc5MCw3ICs3
OTgsMzcgQEAgc3RhdGljIGludCB2ZmlvX3BjaV9maWxsX2RldnMoc3RydWN0IHBjaV9kZXYgKnBk
ZXYsIHZvaWQgKmRhdGEpDQo+ID4gICAJaWYgKCFpb21tdV9ncm91cCkNCj4gPiAgIAkJcmV0dXJu
IC1FUEVSTTsgLyogQ2Fubm90IHJlc2V0IG5vbi1pc29sYXRlZCBkZXZpY2VzICovDQo+ID4NCj4g
PiAtCWZpbGwtPmRldmljZXNbZmlsbC0+Y3VyXS5ncm91cF9pZCA9IGlvbW11X2dyb3VwX2lkKGlv
bW11X2dyb3VwKTsNCj4gPiArCWlmIChmaWxsLT5kZXZpZCkgew0KPiA+ICsJCXN0cnVjdCBpb21t
dWZkX2N0eCAqaW9tbXVmZCA9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9pY3R4KGZpbGwtPnZkZXYp
Ow0KPiA+ICsJCXN0cnVjdCB2ZmlvX2RldmljZV9zZXQgKmRldl9zZXQgPSBmaWxsLT52ZGV2LT5k
ZXZfc2V0Ow0KPiA+ICsJCXN0cnVjdCB2ZmlvX2RldmljZSAqdmRldjsNCj4gPiArDQo+ID4gKwkJ
LyoNCj4gPiArCQkgKiBSZXBvcnQgZGV2aWQgZm9yIHRoZSBhZmZlY3RlZCBkZXZpY2VzOg0KPiA+
ICsJCSAqIC0gdmFsaWQgZGV2aWQgPiAwIGZvciB0aGUgZGV2aWNlcyB0aGF0IGFyZSBib3VuZCB3
aXRoDQo+ID4gKwkJICogICB0aGUgaW9tbXVmZCBvZiB0aGUgY2FsbGluZyBkZXZpY2UuDQo+ID4g
KwkJICogLSBkZXZpZCA9PSAwIGZvciB0aGUgZGV2aWNlcyB0aGF0IGhhdmUgbm90IGJlZW4gb3Bl
bmVkDQo+ID4gKwkJICogICBidXQgaGF2ZSBzYW1lIGdyb3VwIHdpdGggb25lIG9mIHRoZSBkZXZp
Y2VzIGJvdW5kIHRvDQo+ID4gKwkJICogICB0aGUgaW9tbXVmZCBvZiB0aGUgY2FsbGluZyBkZXZp
Y2UuDQo+ID4gKwkJICogLSBkZXZpZCA9PSAtMSBmb3Igb3RoZXJzLCBhbmQgY2xlYXIgZGV2X293
bmVkIGZsYWcuDQo+ID4gKwkJICovDQo+ID4gKwkJdmRldiA9IHZmaW9fZmluZF9kZXZpY2VfaW5f
ZGV2c2V0KGRldl9zZXQsICZwZGV2LT5kZXYpOw0KPiA+ICsJCWlmICh2ZGV2ICYmIGlvbW11ZmQg
PT0gdmZpb19pb21tdWZkX3BoeXNpY2FsX2ljdHgodmRldikpIHsNCj4gPiArCQkJaW50IHJldDsN
Cj4gPiArDQo+ID4gKwkJCXJldCA9IHZmaW9faW9tbXVmZF9waHlzaWNhbF9kZXZpZCh2ZGV2KTsN
Cj4gPiArCQkJaWYgKFdBUk5fT04ocmV0IDwgMCkpDQo+ID4gKwkJCQlyZXR1cm4gcmV0Ow0KPiA+
ICsJCQlmaWxsLT5kZXZpY2VzW2ZpbGwtPmN1cl0uZGV2aWQgPSByZXQ7DQo+ID4gKwkJfSBlbHNl
IGlmICh2ZGV2ICYmIGlvbW11ZmRfY3R4X2hhc19ncm91cChpb21tdWZkLCBpb21tdV9ncm91cCkp
IHsNCj4gPiArCQkJZmlsbC0+ZGV2aWNlc1tmaWxsLT5jdXJdLmRldmlkID0gVkZJT19QQ0lfREVW
SURfT1dORUQ7DQo+ID4gKwkJfSBlbHNlIHsNCj4gPiArCQkJZmlsbC0+ZGV2aWNlc1tmaWxsLT5j
dXJdLmRldmlkID0gVkZJT19QQ0lfREVWSURfTk9UX09XTkVEOw0KPiA+ICsJCQlmaWxsLT5kZXZf
b3duZWQgPSBmYWxzZTsNCj4gPiArCQl9DQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJCWZpbGwtPmRl
dmljZXNbZmlsbC0+Y3VyXS5ncm91cF9pZCA9IGlvbW11X2dyb3VwX2lkKGlvbW11X2dyb3VwKTsN
Cj4gPiArCX0NCj4gPiAgIAlmaWxsLT5kZXZpY2VzW2ZpbGwtPmN1cl0uc2VnbWVudCA9IHBjaV9k
b21haW5fbnIocGRldi0+YnVzKTsNCj4gPiAgIAlmaWxsLT5kZXZpY2VzW2ZpbGwtPmN1cl0uYnVz
ID0gcGRldi0+YnVzLT5udW1iZXI7DQo+ID4gICAJZmlsbC0+ZGV2aWNlc1tmaWxsLT5jdXJdLmRl
dmZuID0gcGRldi0+ZGV2Zm47DQo+ID4gQEAgLTEyMjksMTcgKzEyNjcsMjcgQEAgc3RhdGljIGlu
dCB2ZmlvX3BjaV9pb2N0bF9nZXRfcGNpX2hvdF9yZXNldF9pbmZvKA0KPiA+ICAgCQlyZXR1cm4g
LUVOT01FTTsNCj4gPg0KPiA+ICAgCWZpbGwuZGV2aWNlcyA9IGRldmljZXM7DQo+ID4gKwlmaWxs
LnZkZXYgPSAmdmRldi0+dmRldjsNCj4gPg0KPiA+ICsJbXV0ZXhfbG9jaygmdmRldi0+dmRldi5k
ZXZfc2V0LT5sb2NrKTsNCj4gPiArCWZpbGwuZGV2aWQgPSBmaWxsLmRldl9vd25lZCA9IHZmaW9f
ZGV2aWNlX2NkZXZfb3BlbmVkKCZ2ZGV2LT52ZGV2KTsNCj4gPiAgIAlyZXQgPSB2ZmlvX3BjaV9m
b3JfZWFjaF9zbG90X29yX2J1cyh2ZGV2LT5wZGV2LCB2ZmlvX3BjaV9maWxsX2RldnMsDQo+ID4g
ICAJCQkJCSAgICAmZmlsbCwgc2xvdCk7DQo+ID4gKwltdXRleF91bmxvY2soJnZkZXYtPnZkZXYu
ZGV2X3NldC0+bG9jayk7DQo+ID4NCj4gPiAgIAkvKg0KPiA+ICAgCSAqIElmIGEgZGV2aWNlIHdh
cyByZW1vdmVkIGJldHdlZW4gY291bnRpbmcgYW5kIGZpbGxpbmcsIHdlIG1heSBjb21lIHVwDQo+
ID4gICAJICogc2hvcnQgb2YgZmlsbC5tYXguICBJZiBhIGRldmljZSB3YXMgYWRkZWQsIHdlJ2xs
IGhhdmUgYSByZXR1cm4gb2YNCj4gPiAgIAkgKiAtRUFHQUlOIGFib3ZlLg0KPiA+ICAgCSAqLw0K
PiA+IC0JaWYgKCFyZXQpDQo+ID4gKwlpZiAoIXJldCkgew0KPiA+ICAgCQloZHIuY291bnQgPSBm
aWxsLmN1cjsNCj4gPiArCQlpZiAoZmlsbC5kZXZpZCkgew0KPiA+ICsJCQloZHIuZmxhZ3MgfD0g
VkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdfREVWX0lEOw0KPiA+ICsJCQlpZiAoZmlsbC5kZXZfb3du
ZWQpDQo+ID4gKwkJCQloZHIuZmxhZ3MgfD0NCj4gVkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdfREVW
X0lEX09XTkVEOw0KPiA+ICsJCX0NCj4gPiArCX0NCj4gPg0KPiA+ICAgcmVzZXRfaW5mb19leGl0
Og0KPiA+ICAgCWlmIChjb3B5X3RvX3VzZXIoYXJnLCAmaGRyLCBtaW5zeikpDQo+ID4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggYi9pbmNsdWRlL3VhcGkvbGludXgvdmZp
by5oDQo+ID4gaW5kZXggMDU1MmU4ZGNmMGNiLi4wMTIwMzIxNTI1MWEgMTAwNjQ0DQo+ID4gLS0t
IGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51
eC92ZmlvLmgNCj4gPiBAQCAtNjUwLDExICs2NTAsNTMgQEAgZW51bSB7DQo+ID4gICAgKiBWRklP
X0RFVklDRV9HRVRfUENJX0hPVF9SRVNFVF9JTkZPIC0gX0lPV1IoVkZJT19UWVBFLCBWRklPX0JB
U0UgKyAxMiwNCj4gPiAgICAqCQkJCQkgICAgICBzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0X2lu
Zm8pDQo+ID4gICAgKg0KPiA+ICsgKiBUaGlzIGNvbW1hbmQgaXMgdXNlZCB0byBxdWVyeSB0aGUg
YWZmZWN0ZWQgZGV2aWNlcyBpbiB0aGUgaG90IHJlc2V0IGZvcg0KPiA+ICsgKiBhIGdpdmVuIGRl
dmljZS4NCj4gPiArICoNCj4gPiArICogVGhpcyBjb21tYW5kIGFsd2F5cyByZXBvcnRzIHRoZSBz
ZWdtZW50LCBidXMsIGFuZCBkZXZmbiBpbmZvcm1hdGlvbiBmb3INCj4gPiArICogZWFjaCBhZmZl
Y3RlZCBkZXZpY2UsIGFuZCBzZWxlY3RpdmVseSByZXBvcnRzIHRoZSBncm91cF9pZCBvciBkZXZp
ZCBwZXINCj4gPiArICogdGhlIHdheSBob3cgdGhlIGNhbGxpbmcgZGV2aWNlIGlzIG9wZW5lZC4N
Cj4gPiArICoNCj4gPiArICoJLSBJZiB0aGUgY2FsbGluZyBkZXZpY2UgaXMgb3BlbmVkIHZpYSB0
aGUgdHJhZGl0aW9uYWwgZ3JvdXAvY29udGFpbmVyDQo+ID4gKyAqCSAgQVBJLCBncm91cF9pZCBp
cyByZXBvcnRlZC4gIFVzZXIgc2hvdWxkIGNoZWNrIGlmIGl0IGhhcyBvd25lZCBhbGwNCj4gPiAr
ICoJICB0aGUgYWZmZWN0ZWQgZGV2aWNlcyBhbmQgcHJvdmlkZXMgYSBzZXQgb2YgZ3JvdXAgZmRz
IHRvIHByb3ZlIHRoZQ0KPiA+ICsgKgkgIG93bmVyc2hpcCBpbiBWRklPX0RFVklDRV9QQ0lfSE9U
X1JFU0VUIGlvY3RsLg0KPiA+ICsgKg0KPiA+ICsgKgktIElmIHRoZSBjYWxsaW5nIGRldmljZSBp
cyBvcGVuZWQgYXMgYSBjZGV2LCBkZXZpZCBpcyByZXBvcnRlZC4NCj4gPiArICoJICBGbGFnIFZG
SU9fUENJX0hPVF9SRVNFVF9GTEFHX0RFVl9JRCBpcyBzZXQgdG8gaW5kaWNhdGUgdGhpcw0KPiA+
ICsgKgkgIGRhdGEgdHlwZS4gIEZvciBhIGdpdmVuIGFmZmVjdGVkIGRldmljZSwgaXQgaXMgY29u
c2lkZXJlZCBvd25lZCBieQ0KPiA+ICsgKgkgIHRoaXMgaW50ZXJmYWNlIGlmIGl0IG1lZXRzIHRo
ZSBmb2xsb3dpbmcgY29uZGl0aW9uczoNCj4gPiArICoJICAxKSBIYXMgYSB2YWxpZCBkZXZpZCB3
aXRoaW4gdGhlIGlvbW11ZmRfY3R4IG9mIHRoZSBjYWxsaW5nIGRldmljZS4NCj4gPiArICoJICAg
ICBPd25lcnNoaXAgY2Fubm90IGJlIGRldGVybWluZWQgYWNyb3NzIHNlcGFyYXRlIGlvbW11ZmRf
Y3R4IGFuZCB0aGUNCj4gPiArICoJICAgICBjZGV2IGNhbGxpbmcgY29udmVudGlvbnMgZG8gbm90
IHN1cHBvcnQgYSBwcm9vZi1vZi1vd25lcnNoaXAgbW9kZWwNCj4gPiArICoJICAgICBhcyBwcm92
aWRlZCBpbiB0aGUgbGVnYWN5IGdyb3VwIGludGVyZmFjZS4gIEluIHRoaXMgY2FzZSBhIHZhbGlk
DQo+ID4gKyAqCSAgICAgZGV2aWQgd2l0aCB2YWx1ZSBncmVhdGVyIHRoYW4gemVybyBpcyBwcm92
aWRlZCBpbiB0aGUgcmV0dXJuDQo+ID4gKyAqCSAgICAgc3RydWN0dXJlLg0KPiA+ICsgKgkgIDIp
IERvZXMgbm90IGhhdmUgYSB2YWxpZCBkZXZpZCB3aXRoaW4gdGhlIGlvbW11ZmRfY3R4IG9mIHRo
ZSBjYWxsaW5nDQo+ID4gKyAqCSAgICAgZGV2aWNlLCBidXQgYmVsb25ncyB0byB0aGUgc2FtZSBJ
T01NVSBncm91cCBhcyB0aGUgY2FsbGluZyBkZXZpY2UNCj4gPiArICoJICAgICBvciBhbm90aGVy
IG9wZW5lZCBkZXZpY2UgdGhhdCBoYXMgYSB2YWxpZCBkZXZpZCB3aXRoaW4gdGhlDQo+ID4gKyAq
CSAgICAgaW9tbXVmZF9jdHggb2YgdGhlIGNhbGxpbmcgZGV2aWNlLiAgVGhpcyBwcm92aWRlcyBp
bXBsaWNpdCBvd25lcnNoaXANCj4gPiArICoJICAgICBmb3IgZGV2aWNlcyB3aXRoaW4gdGhlIHNh
bWUgRE1BIGlzb2xhdGlvbiBjb250ZXh0LiAgSW4gdGhpcyBjYXNlDQo+ID4gKyAqCSAgICAgdGhl
IGludmFsaWQgZGV2aWQgdmFsdWUgb2YgemVybyBpcyBwcm92aWRlZCBpbiB0aGUgcmV0dXJuIHN0
cnVjdHVyZS4NCj4gPiArICoNCj4gPiArICoJICBBIGRldmlkIHZhbHVlIG9mIC0xIGlzIHByb3Zp
ZGVkIGluIHRoZSByZXR1cm4gc3RydWN0dXJlIGZvciBkZXZpY2VzDQo+ID4gKyAqCSAgd2hlcmUg
b3duZXJzaGlwIGlzIG5vdCBhdmFpbGFibGUuICBTdWNoIGRldmljZXMgcHJldmVudCB0aGUgdXNl
IG9mDQo+ID4gKyAqCSAgVkZJT19ERVZJQ0VfUENJX0hPVF9SRVNFVCBvdXRzaWRlIG9mIHByb29m
LW9mLW93bmVyc2hpcCBjYWxsaW5nDQo+ID4gKyAqCSAgY29udmVudGlvbnMgKGllLiB2aWEgbGVn
YWN5IGdyb3VwIGFjY2Vzc2VkIGRldmljZXMpLg0KPiA+ICsgKgkgIEZsYWcgVkZJT19QQ0lfSE9U
X1JFU0VUX0ZMQUdfREVWX0lEX09XTkVEIHdvdWxkIGJlIHNldCB3aGVuIGFsbCB0aGUNCj4gPiAr
ICoJICBhZmZlY3RlZCBkZXZpY2VzIGFyZSBvd25lZCBieSB0aGUgdXNlci4gIFRoaXMgZmxhZyBp
cyBhdmFpbGFibGUgb25seQ0KPiA+ICsgKgkgIHdoZW4gVkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdf
REVWX0lEIGlzIHNldCwgb3RoZXJ3aXNlIHJlc2VydmVkLg0KPiA+ICsgKg0KPiA+ICAgICogUmV0
dXJuOiAwIG9uIHN1Y2Nlc3MsIC1lcnJubyBvbiBmYWlsdXJlOg0KPiA+ICAgICoJLWVub3NwYyA9
IGluc3VmZmljaWVudCBidWZmZXIsIC1lbm9kZXYgPSB1bnN1cHBvcnRlZCBmb3IgZGV2aWNlLg0K
PiA+ICAgICovDQo+ID4gICBzdHJ1Y3QgdmZpb19wY2lfZGVwZW5kZW50X2RldmljZSB7DQo+ID4g
LQlfX3UzMglncm91cF9pZDsNCj4gPiArCXVuaW9uIHsNCj4gPiArCQlfX3UzMiAgIGdyb3VwX2lk
Ow0KPiA+ICsJCV9fdTMyCWRldmlkOw0KPiA+ICsjZGVmaW5lIFZGSU9fUENJX0RFVklEX09XTkVE
CQkwDQo+ID4gKyNkZWZpbmUgVkZJT19QQ0lfREVWSURfTk9UX09XTkVECS0xDQo+ID4gKwl9Ow0K
PiA+ICAgCV9fdTE2CXNlZ21lbnQ7DQo+ID4gICAJX191OAlidXM7DQo+ID4gICAJX191OAlkZXZm
bjsgLyogVXNlIFBDSV9TTE9UL1BDSV9GVU5DICovDQo+ID4gQEAgLTY2Myw2ICs3MDUsOCBAQCBz
dHJ1Y3QgdmZpb19wY2lfZGVwZW5kZW50X2RldmljZSB7DQo+ID4gICBzdHJ1Y3QgdmZpb19wY2lf
aG90X3Jlc2V0X2luZm8gew0KPiA+ICAgCV9fdTMyCWFyZ3N6Ow0KPiA+ICAgCV9fdTMyCWZsYWdz
Ow0KPiA+ICsjZGVmaW5lIFZGSU9fUENJX0hPVF9SRVNFVF9GTEFHX0RFVl9JRAkJKDEgPDwgMCkN
Cj4gPiArI2RlZmluZSBWRklPX1BDSV9IT1RfUkVTRVRfRkxBR19ERVZfSURfT1dORUQJKDEgPDwg
MSkNCj4gPiAgIAlfX3UzMgljb3VudDsNCj4gPiAgIAlzdHJ1Y3QgdmZpb19wY2lfZGVwZW5kZW50
X2RldmljZQlkZXZpY2VzW107DQo+ID4gICB9Ow0KDQo=
