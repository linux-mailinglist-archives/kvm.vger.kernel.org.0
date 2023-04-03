Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B550D6D407E
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjDCJZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjDCJZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:25:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7DC170E;
        Mon,  3 Apr 2023 02:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680513912; x=1712049912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qip7ZAoIC0+bXWGQIv5j87+wX6HHEm5HFnJPIts10io=;
  b=NgcMe/iyULySH9ln5oAbpHGSXIQYz+unIb3OjZB+ZvN9ztfPH7i4SUZg
   qRVEqGgJMZFwoTJ0DUQo/8hPVA2+mBfKxPRSeBEDQJjTgpDvKa0oZSjlW
   5pgddcb4YsjLVKrO7ohgKmzy3bzf9QZdmH7wZ9j9M/Ey6EpTxweMvB/Zp
   W2XCVXRpFCtVu2CIRePRsolDha7SVJ5hMslQUZeSwgVqU5uFAhqUZWbaC
   AJNf12EMzfjBbLHnHxpDbJGi0kS73RTaPkRDB5bzuu8vEn7h7Y14FcSbW
   UrSiQrUIBwkxdcDPGvECrY4j1f22hRtBTvVqxHIOWczBMXyxH9SC9eoIn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="340581420"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="340581420"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 02:25:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="775113736"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="775113736"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Apr 2023 02:25:11 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 02:25:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 02:25:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 02:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIw8XQawqzGgaQzQKQcoHilDc2o/JNfPVHQMx1SflGTCDEpHudZAKbd9iofvcC82fR/KIUxwKN3GJ3Mm5rhm+5jQQoOWrwQyUlSNf/s3uylj+UIbld63DgM60GB6bnkQYyr2fhVK04stfgcyd0g8EaQwM2AZMMZFTYsKD2bS4/ZLJmSgozv/kI6MDUuueeJTtqYA8YrPdADkV3uRgSJ0os8dIWM19IbXs6aigMtkshfMPj/sKAOBPNcHCLSbOeENZ+Y24r3/PWAqBe3DTHUM3le/ukA12eMGdnsePM2Cufjst0xWEYIwbEETBueXnGNC5DbPF73zBtw0rW23Q24EXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qip7ZAoIC0+bXWGQIv5j87+wX6HHEm5HFnJPIts10io=;
 b=GlrdgPL1U/YOmIvJrYGvIGz4KQpDnLgVq4VliJr1HqT43+hbrW+uTfLtG0wRJp1+HuQt/vH1iioPGOY9bwIX7ynno8CK224UyCKIxIYkpXryARA/u8pqs/MZgr7MAAUorQ0xPiAR3CxVcwV/j8T4KR1Mt2Tev2sH17RwwKZyHkY5tiZHpO/liwxsnsymQtQkSEfmyYbEBB1TW0GTEL2W0WzUc1L6rs5Hz9Gb+HFKXGlFZuXEKrSej+HN4JWuGOaHkk9qfT1BMUeBywXRENI2VN2FNxDIvbK8cOTK36WILXwx+Fwos8I5E9+Wls2tdg2/2nbnIlZX/z+P6i85ZimFiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW5PR11MB5906.namprd11.prod.outlook.com (2603:10b6:303:1a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 09:25:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.028; Mon, 3 Apr 2023
 09:25:06 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8ZTcVQ
Date:   Mon, 3 Apr 2023 09:25:06 +0000
Message-ID: <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
In-Reply-To: <20230401144429.88673-13-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW5PR11MB5906:EE_
x-ms-office365-filtering-correlation-id: 2c795573-ed41-4a4f-8f5e-08db3425502f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hBEPNLlP0uNIzz5pvmGacC/ZqJVhFAatgwPDlW3p/jegl6dUG5d3RE6FBiv+6sviGjciMiM7DypFw4ycA7QvGm7AIfRIwgqAZkRhcbf+kOPd2wm03kvsgPY08M1Q+0XPNZTCe4aJmuQ3AJD8CoGG2a20YHiPgqTEo4O8Z669zKJ329Fy7Ry28rqnjuYYdNwkkgC7vG+cU7vTO8FIuJdBuGxvwRk5Ld2gVvpGivKbrcaRWA7/gNtVxDITniFBybwky1li32NFdAKAm5JgLvpeMxCLOQhdtJ/uMJk9GdBbsvT27qyJBPu7zWmzxqGThWD+/yOTipq9iAbNhx96mxq7jxpkGeP21sSzvwzO6FRHeXf04S+gQ7hxZsR+BIPjnjewUtDVZjmpYgWXH7sHGkdyB9IlpBTFPxvY6RuIQONHEbswS8jHKLM/Z3wBgMi1d1xO6ONK0OiQ0Zr3ZEEAUR1NBe7T018c4gfqhw7guT/aLwn+cH7qS2tZVk9k+NuARJMdvHp9ljy3Yilh2C0qweoGbZKEjVC9Q4dDkaU3rPwbdtWzz65N/egSu4InKHpNmwEIvYQ6ZAnjN7gWUaLrjoaB9Wn90yVSCgC51klTHIqrj77fWZWzySymb4SZXhPqQeXP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199021)(55016003)(8676002)(4326008)(66476007)(66556008)(64756008)(66446008)(66946007)(76116006)(478600001)(316002)(6636002)(110136005)(54906003)(52536014)(8936002)(4744005)(7416002)(41300700001)(82960400001)(38100700002)(122000001)(5660300002)(186003)(7696005)(71200400001)(6506007)(26005)(9686003)(86362001)(33656002)(2906002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEZRTDZZVWlxczY2UVRHWU80U1B5aS9qUC9JQlZ4dmVGTmROOUV6SUovNkd0?=
 =?utf-8?B?d1VnUWFGSkV3Uko1TUwxUjIwd1M4WEdSR3J2UHdhSDZ3bE5XeUFGMXhDK0tu?=
 =?utf-8?B?U2swakVxTXNURFR1c3EwalBab1dGOXM5eTdDVW1JWDJXMW12b1JjbDJ1SVdk?=
 =?utf-8?B?NGJFMklaNUlpcktMZG5xOGVOSk8yYmVvVnV0MVRYTnAzRlI4VEY1cGRnNUZU?=
 =?utf-8?B?NnVzc2M0V1lJbE15b2dBdHI0SXBnK2k4bk43aldoS0JSR1pacmt6dHYvSHJm?=
 =?utf-8?B?VURCUE91d2dqNnEzNm0zai9lL2NRN1BCUFhINVNyMEhIb0hvNW9xNGJYeXk2?=
 =?utf-8?B?Nzg0SlZOUmw0d1h1TnkrN3hUOGdqUE1NSlBhOXh4USsxV0JhRUU5Y3dacStI?=
 =?utf-8?B?OXhuSWpWTGxBUGhWb1hWZTFmWTh3YXFEQXZWREJDLzE4S3FjR0JoOEl5bjl2?=
 =?utf-8?B?RHUweW83T3JwQmtSUytLNHZucmsxak5vQjdsejkzbk44RGxzR3JxblJhNFYx?=
 =?utf-8?B?RGlTd2dYTk9Sb3U2MUcvS1dvNVBBdWxUeEZuUkgrOGp3dGxEeDYzMkY2YmJs?=
 =?utf-8?B?ZDk3bnF6NVEzdlVpOWREMm5NOFMxTEZkeU55OVViY2QwV0ZNUEdKNTlEaFlM?=
 =?utf-8?B?eTM0bkhJcC9GaXg1ZGJzN3dKWnlQeG1xR053cHI2cFByRzYxMjRYTnIxRnZF?=
 =?utf-8?B?czlwM2UzZGdKSkJCZXlKbkZxcUNwRXFuNnE1UDJyT2NlL2dsVnlCWkZnSEdX?=
 =?utf-8?B?aTlLejgzU2ZvWUE5bFBmT0N4Z1ZPMEhURTNlSEhSWkUza3VkMkZOd1VhZ2oz?=
 =?utf-8?B?SkxFd3NWYzZBZjFocUQ0cXBkbzVEQ2hCMjhjaFFheGVIbXJkRm9BRENYbHpk?=
 =?utf-8?B?bi9jSEJqdDBIVTR2RnJaZE5idGVFbXNJR2VGQVA3cjhVZ2ptek5CNUtlV29L?=
 =?utf-8?B?M0tiRDN5d3NWVkxBZmpDcElrbmRjZTZvaGt6WWpYbUpHQjBwZUNIN2dITTBG?=
 =?utf-8?B?NXN1bWVQYmphQXMxc0ZHY3I0OUQyYnRSbXdHdkNFcldOYnVlMEtBL0pKL2dq?=
 =?utf-8?B?TVkvY1ZCdjB1ckJWV3NpYzdXODc3RitTV05UNEh3MDZaS2ZoOUJvRVdDUEVM?=
 =?utf-8?B?M01aZGdMcklaVzJnbzJkR1lsdy9ueURqaFRYbTN4VkxQSndIcWRMRUVDUzIy?=
 =?utf-8?B?WFVqV2lVRThtdUpINmJBV3Y1amJmNks1N0VtZU02ZGJGSUIzUkVWcE5Hbnlr?=
 =?utf-8?B?cDZFUHluWWdtSEhBc2NBdmZDZGJsUDhXNlh1Q2NQbmRjMnJDV1JrSDVmb1p2?=
 =?utf-8?B?MTJiVzY5SXZHcXRYVm1HaEFaU2t2TFFaNXF4YVJ2MktZUEkvZFJrZ0wwS0Rn?=
 =?utf-8?B?Vkw2dUZJQWllbHhoVkVaWXE1N2pObGN1YkMybTZKNmZvVG5RL1Mzdmk3c2NU?=
 =?utf-8?B?eGdqenhLK2Y0S21rTEZGcGlRZ05OT0xXbStPMTV2UjBVQlQ4ZUdRajJBQ29P?=
 =?utf-8?B?cGdDUWJRZ2VaT0lsb05pN0lDNzRjZnJ3M1laSlN3MXFWYWdPU01FWHBnWm9W?=
 =?utf-8?B?dHJaclZxZThUc3lScVo3ekZBTWR5L2dQZllnZFRrbVZrdjd3cVY0TCtaMzhP?=
 =?utf-8?B?bjhmUjI3amhuay9QanhJWkxJZXZHNjUvOWx6NmJLdzJMK1BGaDJRZ2xjdDJU?=
 =?utf-8?B?QzVPN0NOOEYwT3lKcmxpOFVJOG5KdjRqTUN4WTBJV25HUUxlR2I1YjQwUXZ5?=
 =?utf-8?B?aUtpUWpqejlleUxpeDgyL3g2dk9IYTEwNmh4TktDRXdnUDVqVlJ1ZEZhRXdW?=
 =?utf-8?B?dERKWXptVmVzajZ2UzBvYlJRNG1xR1RNeUNLUngrUDFaL21xbUxvK2RPT2Rr?=
 =?utf-8?B?N3NObVJ6anhhTjFOdEp3bU5TUXpXaGxSazNrYkh2NHd2ZW0yakZvTGFvZGRv?=
 =?utf-8?B?ZXdNeGsydDhtdHBBMHp4SzRpYk1jVGF2NW1uTHB3L1VnSDkxbGJKb25TbHNB?=
 =?utf-8?B?VG95NHdWNGs5OFpRMHluNEhWSk1MczBmTHcrLzl0a3BHQUNKU0hJVFZZcUow?=
 =?utf-8?B?bzVxM0tHN2RTS29CWWlNMTl2NjRqbk1EZFZTbk0wenN1TmM2Sm9uTTJPa2Nw?=
 =?utf-8?Q?N8pTD/twyY0Tod8LpO+7IpxZy?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c795573-ed41-4a4f-8f5e-08db3425502f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 09:25:06.6166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yKxddyhN/JIVujr/rXE+8YOzZ5z6GjQjXPjRg45Vr0LgiW+CEhDKBjwrir63itJDL1EoU7iZ9NQYx20J+YTOQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5906
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogU2F0dXJkYXks
IEFwcmlsIDEsIDIwMjMgMTA6NDQgUE0NCg0KPiBAQCAtNzkxLDcgKzgxMywyMSBAQCBzdGF0aWMg
aW50IHZmaW9fcGNpX2ZpbGxfZGV2cyhzdHJ1Y3QgcGNpX2RldiAqcGRldiwgdm9pZCAqZGF0YSkN
Cj4gIAlpZiAoIWlvbW11X2dyb3VwKQ0KPiAgCQlyZXR1cm4gLUVQRVJNOyAvKiBDYW5ub3QgcmVz
ZXQgbm9uLWlzb2xhdGVkIGRldmljZXMgKi8NCg0KSGkgQWxleCwNCg0KSXMgZGlzYWJsaW5nIGlv
bW11IGEgc2FuZSB3YXkgdG8gdGVzdCB2ZmlvIG5vaW9tbXUgbW9kZT8gSWYgbm8sIGp1c3Qgc2tp
cA0KdGhlIGJlbG93IGNvbnRlbnRzLiDwn5iKIElmIHllcywgdGhlbiBtYXkgbmVlZCB0byBjaGVj
ayBpZiBiZWxvdyBpcyBleHBlY3RlZC4NCg0KSSBhZGRlZCBpbnRlbF9pb21tdT1vZmYgdG8gZGlz
YWJsZSBpbnRlbCBpb21tdSBhbmQgYmluZCBhIGRldmljZSB0byB2ZmlvLXBjaS4NCkkgY2FuIHNl
ZSB0aGUgL2Rldi92ZmlvL25vaW9tbXUtMCBhbmQgL2Rldi92ZmlvL2RldmljZXMvbm9pb21tdS12
ZmlvMC4gQmluZA0KaW9tbXVmZD09LTEgY2FuIHN1Y2NlZWQsIGJ1dCBmYWlsZWQgdG8gZ2V0IGhv
dCByZXNldCBpbmZvIGR1ZSB0byB0aGUgYWJvdmUNCmdyb3VwIGNoZWNrLiBSZWFzb24gaXMgdGhh
dCB0aGlzIGhhcHBlbnMgdG8gaGF2ZSBzb21lIGFmZmVjdGVkIGRldmljZXMsIGFuZA0KdGhlc2Ug
ZGV2aWNlcyBoYXZlIG5vIHZhbGlkIGlvbW11X2dyb3VwIChiZWNhdXNlIHRoZXkgYXJlIG5vdCBi
b3VuZCB0byB2ZmlvLXBjaQ0KaGVuY2Ugbm9ib2R5IGFsbG9jYXRlcyBub2lvbW11IGdyb3VwIGZv
ciB0aGVtKS4gU28gd2hlbiBob3QgcmVzZXQgaW5mbyBsb29wcw0Kc3VjaCBkZXZpY2VzLCBpdCBm
YWlsZWQgd2l0aCAtRVBFUk0uIElzIHRoaXMgZXhwZWN0ZWQ/DQoNClJlZ2FyZHMsDQpZaSBMaXUN
Cg==
